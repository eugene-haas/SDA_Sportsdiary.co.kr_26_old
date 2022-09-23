<%
'#############################################
' 임시경기번호 일괄 변경
'#############################################
	'request
	tidx = oJSONoutput.Get("TIDX")

	Set db = new clsDBHelper

' If isnumeric(cngval) = False Then
' 		Call oJSONoutput.Set("result", 111 ) '서버에서 메시지 생성 전달
' 		Call oJSONoutput.Set("servermsg", "빈경기번호체크할까." ) '서버에서 메시지 생성 전달
' 		strjson = JSON.stringify(oJSONoutput)
' 		Response.Write strjson
' 		Response.end
'	End If

  SQL = "Update tblRGameLevel Set gameno = gameno_temp where cda = 'F2' and gametitleidx = " & tidx
  Call db.execSQLRs(SQL , null, ConStr)


	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing
%>