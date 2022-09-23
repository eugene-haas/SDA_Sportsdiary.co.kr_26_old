<%
'#############################################

'상세종목 불러오기

'#############################################
	'request
	If hasown(oJSONoutput, "LIDX") = "ok" Then 'tblRGameLevel.RGameLevelidx
		lidx = oJSONoutput.LIDX
	End If
	If hasown(oJSONoutput, "GNO") = "ok" Then 
		gameno = oJSONoutput.Get("GNO")
	End if	

	If hasown(oJSONoutput, "CTYPE") = "ok" Then 
		changetype = oJSONoutput.CTYPE
	End if	


	Set db = new clsDBHelper

	  'type1 오전 오후 경기 수도 업데이트 해줘야한다.

	  If changetype = "type1" then
	  SQL = "update tblRGameLevel set gameno = '"&gameno&"' where RgameLevelidx = " & lidx
	  Else
	  SQL = "update tblRGameLevel set gameno2 = '"&gameno&"' where RgameLevelidx = " & lidx
	  End if
	  Call db.execSQLRs(SQL , null, ConStr)		




	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing
%>