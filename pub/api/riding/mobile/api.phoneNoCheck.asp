<%
'#############################################
'참가자 전화번호 중복확인
'#############################################
	'request
	If hasown(oJSONoutput, "PHONENO") = "ok" then	 '이름
		phoneno = oJSONoutput.PHONENO
	End If


	Set db = new clsDBHelper

	'삭제플레그 확인
	SQL = "Select PlayerIDX from tblPlayer where userphone = '"&phoneno&"' and delYN = 'N' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof Then
		Call oJSONoutput.Set("result", "101" ) '중복 핸드폰 번호
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End If


	Call oJSONoutput.Set("pidx", rs(0) )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	db.Dispose
	Set db = Nothing
%>
