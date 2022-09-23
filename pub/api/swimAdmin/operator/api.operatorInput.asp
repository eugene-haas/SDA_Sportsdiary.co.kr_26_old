<%
'#############################################
' 관리자 관리
'#############################################
	'request
	admin_id = oJSONoutput.ADID
	admin_pwd = oJSONoutput.ADPWD
	admin_title = oJSONoutput.ADTITLE
	writeday =	 Left(date ,10)
	
	Set db = new clsDBHelper

'	strFieldName = " idx,SportsGb,HostCode,ManagerName,ManagerID,WritePwd,Gubun,WriteDate "

	tablename = " tblGameManager "
	SQL = "select ManagerID from " &tablename& " where SportsGb = 'tennis' and DelYN = 'N' and  ManagerID= '"&ad_id&"'"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If not rs.eof  then	'중복
		Call oJSONoutput.Set("result", "2" ) '존재
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.write "`##`"

		Set rs = Nothing
		db.Dispose
		Set db = Nothing
		Response.End
	End if

	hostcode = "sd100001"
	gubun = "sd200001"


		insertfield = " SportsGb,HostCode,ManagerName,ManagerID,ManagerPwd,Gubun,WriteDate "
		insertvalue = " 'tennis','"&hostcode&"','"&admin_title&"','"&admin_id&"','"&admin_pwd&"','"&gubun&"','"&date&"' "
		SQL = "SET NOCOUNT ON INSERT INTO "&tablename&" ( "&insertfield&" ) VALUES " 
		SQL = SQL & "( "&insertvalue&" ) SELECT @@IDENTITY"

		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		idx = rs(0)


		hostimg = ""
		makegamecnt = 0
		writeday = Date()

  Set rs = Nothing
  db.Dispose
  Set db = Nothing

	passstar = "*******************************************"
%>
		<!-- #include virtual = "/pub/html/swimAdmin/operator/html.operatorList.asp" -->