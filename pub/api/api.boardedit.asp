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

		<form method="post" name="fbbs">
		<input type="hidden" name="tid" value="<%=seq%>">
		<input type="hidden" name="pagec" value="<%=pagec%>">
		<input type="hidden" name="tid" value="<%=tid%>">
		<input type="hidden" name="ref" value="0">
		<input type="hidden" name="step" value="0">
		<input type="hidden" name="level" value="0">

			제  목<br>
			<input type="text" name="title" id="wtitle" style="width:100%;" value="<%=title%>">
			<textarea name="editor1" id="editor1" rows="10" cols="80" >
                <%=contents%>
            </textarea>

		  <div class='set blue' style="float:left;">
			<a href="javascript:mx.editOk()" class='btn pri ico'  style="content:'\f040'">수정</a>
		  </div>		

		  <div class='set blue'  style="float:left;">
			<a href="javascript:javascript:mx.SendPacket(this, {'CMD':mx.CMD_BOARD, 'PG':'<%=pagec%>','TID':'<%=tid%>','SS':'<%=searchstr%>'})" class='btn pri'  style="content:'\f040'">목록</a>
		  </div>		
		</form>