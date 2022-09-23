<%
'######################
'부서찾기
'######################
	If hasown(oJSONoutput, "SEQ") = "ok" then
		seq = chkInt(oJSONoutput.SEQ,0)
	End if	

	If hasown(oJSONoutput, "PUBARR") = "ok" then
		PUBARR = chkStrRpl(oJSONoutput.PUBARR,"")
	End if	

	If hasown(oJSONoutput, "HIDEARR") = "ok" then
		HIDEARR = chkStrRpl(oJSONoutput.HIDEARR,"")
	End if


	Set db = new clsDBHelper

	'온데이터들을 반데로 업데이트 한다.
	'SQL = "Update sd_bikeBoard Set pubshow = case when pubshow = '1' then '0' else '1' end  where idx in ("&PUBARR&")"
	If PUBARR <> "" Then 
	SQL = "Update sd_bikeBoard Set pubshow = '1'  where seq in ("&PUBARR&")"
	Call db.execSQLRs(SQL , null, ConStr)
	End if

	If HIDEARR <> "" Then 
	SQL = "Update sd_bikeBoard Set pubshow = '0'  where seq in ("&HIDEARR&")"
	Call db.execSQLRs(SQL , null, ConStr)
	End If
	
	db.Dispose
	Set db = Nothing


	'수정 모드로 커맨드 변경한 그대로 보낸다.
	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.write strjson
%>

