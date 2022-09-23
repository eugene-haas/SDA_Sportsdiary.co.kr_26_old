<%
'#############################################

'(대진표 RGameList )에서 (코트정보입력창 enter_score )으로 갈때 필요한 정보 확인

'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" then
	d_idx = oJSONoutput.IDX
	Else
		Call oJSONoutput.Set("result", "1" )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.write "`##`"	  
	    Response.end
	End if
	Set db = new clsDBHelper

	SQL = "update  tblLimitAtt Set   DelYN = 'Y' where seq = " & d_idx
	Call db.execSQLRs(SQL , null, ConStr)

  	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson


  db.Dispose
  Set db = Nothing
%>


