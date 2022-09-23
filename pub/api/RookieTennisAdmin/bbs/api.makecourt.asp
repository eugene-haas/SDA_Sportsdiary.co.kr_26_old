<%
'#############################################
'대진표 리그 화면 준비
'#############################################



'request
idx = oJSONoutput.IDX
tidx = oJSONoutput.TitleIDX
levelno = oJSONoutput.S3KEY

Set db = new clsDBHelper

If hasown(oJSONoutput, "CST") = "ok" then
	cst = oJSONoutput.CST
	Select Case cst
	Case "w"
		areaname = oJSONoutput.CTNAME
		SQL = "select count(*) from sd_TEnnisCourt where gameTitleIDX = " & tidx & " and levelno = " & levelno & " and areaname = '"&areaname&"'"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		no = CDbl(rs(0)) + 1
		ctname =  no

		SQL = "insert into sd_TEnnisCourt (no,gameTitleIDX,levelno,courtname,areaname) values ("&no&","&tidx&","&levelno&",'"&ctname&"','"&areaname&"')"
		Call db.execSQLRs(SQL , null, ConStr)
		SQL = "update tblRGameLevel Set courtcnt = "&no&" where RGameLevelidx = " & idx
		Call db.execSQLRs(SQL , null, ConStr)
	Case "e"
		ctname = oJSONoutput.CTNAME
		cidx = oJSONoutput.CIDX
		SQL = "update sd_TEnnisCourt Set courtname = '"&ctname&"' where idx = " & cidx
		Call db.execSQLRs(SQL , null, ConStr)
	Case "d"
		cidx = oJSONoutput.CIDX
		SQL = "update sd_TEnnisCourt Set courtuse = case when courtuse ='Y' then 'N' else 'Y' end where idx = " & cidx
		Call db.execSQLRs(SQL , null, ConStr)

	Case "r" '락잠금 해제 직접
		cidx = oJSONoutput.CIDX
		SQL = "update sd_TEnnisCourt Set courtstate = case when courtstate =1 then 0 else 1 end where idx = " & cidx
		Call db.execSQLRs(SQL , null, ConStr)
	End Select
End if



SQL = "Select idx,no,gameTitleIDX,levelno,courtname,courtuse,courtstate,areaname from sd_TEnnisCourt where gameTitleIDX = " & tidx & " and levelno = " & levelno & " order by areaname, no "
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

Call oJSONoutput.Set("CIDX", 0 )
Call oJSONoutput.Set("CST", "w" ) ' 상태(생성)
strjson = JSON.stringify(oJSONoutput)

%>
  <div class='modal-header game-ctr'>	
    <button type='button' class='close'  onmousedown="if ( $('#tryouting').length > 0 ) { $('#tryouting').click();}if ( $('#tourning').length > 0 ) { $('#tourning').click();};$('#Modaltest').modal('hide')">×</button><!-- data-dismiss='modal' aria-hidden='true' -->
    <h3 id='myModalLabel'>코트관리</h3>
  </div>



	<div style="text-align:center;width:100%;padding-top:8px;">
		<input type="text" id="kcourtname"  width="100px;" class="ui-autocomplete-input" autocomplete="off" style="padding-bottom:0px;font-size:18px;width:20%;height:35px;"  placeholder="지역명"  value="<%=areaname%>"
		onkeydown='if(event.keyCode == 13){mx.initCourt(<%=strjson%>)}' >
		<input type="button" value="생성"  onmousedown='mx.initCourt(<%=strjson%>)' class="btn_a btn btn_enter" style="height:38px;margin-bottom:10px;font-size:18px;width:20%;">
	</div>


	<div class="modal-body game-ctr no_scroll court-ctr">
		<div class="scroll_area" id="courtarea">
			<%Do Until rs.eof
				c_idx = rs("idx")
				c_no = rs("no")
				c_name = rs("courtname")
				c_use = rs("courtuse")
				c_state = rs("courtstate")
				c_area = rs("areaname")

			oJSONoutput.CIDX = c_idx
			oJSONoutput.CST = "e"
			e_strjson = JSON.stringify(oJSONoutput)
			oJSONoutput.CST = "d"
			d_strjson = JSON.stringify(oJSONoutput)
			oJSONoutput.CST = "r" '락해제
			r_strjson = JSON.stringify(oJSONoutput)
			%>
			<div style="background:<%If c_state = "1" then%>#D8DE29;<%else%>#efefef;<%End if%>">
			<input type="text" id="ar_<%=c_idx%>" value="<%=c_area%>" style="font-size:18px;height:38px;width:30%;<%If CStr(cidx) = CStr(c_idx) then%>background:#eeeeee;<%End if%>" onfocus="$('#kcourtname').val('<%=c_area%>');"  <%If c_use = "N" then%>disabled<%End if%>>
			<input type="text" id="ct_<%=c_idx%>" value="<%=c_name%>" style="font-size:18px;height:38px;width:20%;<%If CStr(cidx) = CStr(c_idx) then%>background:#eeeeee;<%End if%>"  <%If c_use = "N" then%>disabled<%End if%>>


			<a href='javascript:mx.initCourt(<%=e_strjson%>)'  class="btn_a" style="font-size:18px;width:10%;height:35px;">수정</a>
			<a href='javascript:mx.initCourt(<%=d_strjson%>)' class="<%If c_use = "N" then%>btn_rev<%else%>btn_a<%End if%>" style="font-size:18px;width:10%;height:35px;">
			<%If c_use = "N" then%>복구<%else%>삭제<%End if%></a>

			<a href='javascript:mx.initCourt(<%=r_strjson%>)'  class="btn_a" style="font-size:18px;width:20%;height:35px;">잠금/해제</a>
			</div>
			<%
			rs.movenext
			loop
			%>
		</div>

	</div>

<%
db.Dispose
Set db = Nothing
%>
