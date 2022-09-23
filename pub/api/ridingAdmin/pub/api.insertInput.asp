<%
'#############################################
' 입력
'#############################################
	'request
	If hasown(oJSONoutput, "PARR") = "ok" then
		parr= Replace(oJSONoutput.PARR,"'","''")
		reqarr = Split(parr,",")

		p_1 = reqarr(0)
		p_2 = reqarr(1)
		p_3 = reqarr(2)
		p_4 = reqarr(3)
	End if

	Set db = new clsDBHelper

		tablename = " tblInsertData "
		insertfield = " title,targettable,targetfield,fieldvalue "
		insertvalue = " '"&p_1&"','"&p_2&"','"&p_3&"','"&Trim(p_4)&"' "


		SQL = "SET NOCOUNT ON INSERT INTO "&tablename&" ( "&insertfield&" ) VALUES " 
		SQL = SQL & "( "&insertvalue&" ) SELECT @@IDENTITY"
		Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)
		idx = rs(0)
		writeday = Date()
		endflag = "N"

  Set rs = Nothing
  db.Dispose
  Set db = Nothing

%>
<!-- #include virtual = "/pub/html/riding/common/html.dataInsertList.asp" --> 