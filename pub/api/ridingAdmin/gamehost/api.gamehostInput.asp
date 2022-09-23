<%
'#############################################
' 주최를 입력(ajax api)  2017년 10월 10일 백승훈
'#############################################
	'request
	hostname = oJSONoutput.hostname
	gubun = oJSONoutput.HGUBUN
	Set db = new clsDBHelper

	tablename = " tblGameHost "
	SQL = "select hostname from " &tablename& " where DelYN = 'N' and hostname = '"&hostname&"' and gubun = '"&gubun&"' "
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


		insertfield = " gubun, hostname "
		insertvalue = " "&gubun&" ,  '" & hostname& "' "
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

%>
	<!-- #include virtual = "/pub/html/riding/gamehost/html.GameHostList.asp" -->