<!-- #include virtual = "/pub/header.RidingHome.asp" -->
<%
Dim intTotalCnt, intTotalPage '총갯수, 총페이지수
'############################################
%><!-- #include virtual = "/pub/setReq.asp" --><%'이걸열어서 디버깅하자.%><%
'#############################################
'삭제
'#############################################
	'request
	seq = oJSONoutput.Get("SEQ")

	'로그인 체크
	If login = False Then
		Call oJSONoutput.Set("result", "9" )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End if

	Set db = new clsDBHelper

	'중복체크
	SQL = "select seq from tbltotalBoard_shortcourseMember where seq = " & seq & " and userid = '"&session_uid&"'  "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.eof Then
		Call oJSONoutput.Set("result", "2" )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End if




	'참가신청
	fldstr = " seq ,webseq,playeridx,userid,username "
	valstr = ""&seq&","&session_wseq&", '"&session_pidx&"','"&session_uid&"','"&session_unm&"'  "
	SQL = "insert into tbltotalBoard_shortcourseMember ("&fldstr&") values ("&valstr&")"
	Call db.execSQLRs(SQL , null, ConStr)

	
	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	db.Dispose
	Set db = Nothing
%>


