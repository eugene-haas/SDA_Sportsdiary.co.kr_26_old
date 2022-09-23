<%
	'request 처리##############
	seq = oJSONoutput.value("SEQ") 
	tid = oJSONoutput.value("TID") 
	pagec = oJSONoutput.value("PG") 
	findtype = oJSONoutput.value("FT") 
	searchstr = oJSONoutput.value("SSTR") 


	seq = chkInt(seq, 0) 
	tid = chkInt(tid, 0) 
	pagec = chkInt(pagec, 1)
	findtype = chkStrRpl(findtype, "") 
	searchstr = chkStrRpl(searchstr, "") 
	'request 처리##############


	ConStr = Replace(ConStr, "ITEMCENTER", "itemcenter_test")
	Set db = new clsDBHelper

	strTableName = " __wboardS "
	SQL = "Update " & strTableName & " set readnum = readnum + 1 where seq = " & seq
	Call db.execSQLRs(SQL , null, ConStr)

	fildstr = " seq, tid, id, ip, title, contents,readnum,writeday,num,ref,re_step,re_level "
	SQL = "Select  " & fildstr & " from " &   strTableName & " where seq = " & seq

	
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof Then
		id = rs("id")
		ip = rs("ip")
		title = rs("title")
		contents = htmlDecode(rs("contents"))
		readnum = rs("readnum")
		writeday = rs("writeday")
	End if

	db.Dispose
	Set db = Nothing
%>
<table width="97%" align="center" cellpadding="0" cellspacing="0">
<tr>
<td>
	<div style="clear:both; height:30px;">
		<div style="float:left; margin-top:6px;">
		<span class="bbs_num">작성일 : <%=writeday%></span>
		</div>

		
		<div style="float:right;">
		<!-- 링크 버튼 -->
		</div>
	</div>

	<div  class="bbs_titleborder">
		<table height=34  border=0 cellpadding=0 cellspacing=0 width=100%>
		<tr>
			<td style="padding:8px 0 0 10px;">
				<div style="font-size:13px;word-break:break-all;"><%=title%></div>
			</td>
		</tr>
		</table>
	</div>
	<div id="bbs_listline"></div>


	<table border=0 cellpadding=0 cellspacing=0 width='97%'>
	<tr>
		<td height=30 style="color:#888;">
			<div style="float:left;" class="bbs_num">
			&nbsp;글쓴이 : <%=id%>
			</div>
			<div style="float:right;"  class="bbs_num">
			 조회 : <%=readnum%>
			</div>
		</td>
	</tr>

	<tr>
		<td height="150" style="word-break:break-all; padding:10px;">
			<!-- 내용 출력 -->
			<span><%=contents%></span>
			<!-- 테러 태그 방지용 --><!-- </xml></xmp><a href=""></a><a href=''></a> -->
		</td>
	</tr>
	</table>
	<br>


	<div style="height:1px; line-height:1px; font-size:1px; background-color:#2E71B5; clear:both;">&nbsp;</div>

	<div style="clear:both; height:43px;">

		<!-- 링크 버튼 -->
		<div style="float:left;margin-top:10px;">

		</div>

		<div style="float:right; margin-top:10px;">
		  <div class='set blue'  style="float:left;">
			<a href="javascript:javascript:mx.SendPacket(this, {'CMD':mx.CMD_BOARD, 'PG':'<%=pagec%>','TID':'<%=tid%>','SS':'<%=searchstr%>'})" class='btn pri'  style="content:'\f040'">목록</a>
		  </div>	
		  <div class='set blue'  style="float:left;">
			<a href="javascript:javascript:mx.SendPacket(this, {'CMD':mx.CMD_BOARDEDIT,'SEQ':<%=seq%> ,'PG':'<%=pagec%>','TID':'<%=tid%>','SS':'<%=searchstr%>'})" class='btn pri'  style="content:'\f040'">수정</a>
		  </div>	
		  <div class='set blue'  style="float:left;">
			<a href="javascript:javascript:mx.SendPacket(this, {'CMD':mx.CMD_BOARDDEL,'SEQ':<%=seq%> , 'PG':'<%=pagec%>','TID':'<%=tid%>','SS':'<%=searchstr%>'})" class='btn pri'  style="content:'\f040'">삭제</a>
		  </div>	


		</div>
	</div>

	<div style="height:2px; line-height:1px; font-size:1px; background-color:#2E71B5; clear:both;">&nbsp;</div>
</td>
</tr>
</table>
