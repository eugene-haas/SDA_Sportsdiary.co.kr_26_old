<%
	TeamIDX = oJSONoutput.TeamIDX
	Team = oJSONoutput.Team
	TeamNm = oJSONoutput.TeamNm  
	sido = oJSONoutput.sido
	TeamTel = oJSONoutput.TeamTel

	ZipCode = oJSONoutput.ZipCode
	Address = oJSONoutput.Address
	AddrDtl = oJSONoutput.AddrDtl
	TeamLoginPwd = oJSONoutput.TeamLoginPwd 

	Set db = new clsDBHelper

	SQL = "select top 1 TeamIDX from tblTeamInfo where TeamNm = '"&  TeamNm  &"' and TeamIDX <> " & TeamIDX
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof Then
		Call oJSONoutput.Set("result", "200" )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.write "`##`"
		Response.end
	End if



	updatefield = " Team ='"&Team&"',TeamNm='"&TeamNm&"',sido ='"&sido&"', TeamTel ='"&TeamTel&"', ZipCode ='"&ZipCode&"',Address ='"&Address&"',AddrDtl ='"&AddrDtl&"',TeamLoginPwd ='"&TeamLoginPwd&"'"
	strSql = "update  tblTeamInfo Set   " & updatefield & " where TeamIDX = " & TeamIDX
	Call db.execSQLRs(strSQL , null, ConStr)

  db.Dispose
  Set db = Nothing
%>

<!-- #include virtual = "/pub/html/swimAdmin/Teaminfolist.asp" -->
