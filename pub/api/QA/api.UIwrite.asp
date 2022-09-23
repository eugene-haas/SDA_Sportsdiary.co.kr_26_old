<%
'#############################################

'대회생성저장

'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" then
		idx = oJSONoutput.IDX
	End if

	Set db = new clsDBHelper 


	Function addZero3(ByVal val)
		If Len(val) = 3 Then
			addZero3 = "0" & val
		Else
			addZero3 = val
		End If
	End Function



		SQL = "select max(reqid), max(uiid) from tblqa where reqid  in (select reqid from tblQA where idx = " & idx & ") "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			reqID = rs(0)

			preUIID = rs(1)
			uicd = addZero3(CDbl(Split(preUIID,"_")(1)) + 1)
			UIID = "UI_" &  uicd
			pgID = "PG_" &  uicd
			TotalTestID = "TS_" &  uicd

		SQL = "SET NOCOUNT ON INSERT INTO tblQA ( reqID,UIID,pgID,TotalTestID ) VALUES " 'confirm 확인여부
		SQL = SQL & "( '"&reqID&"','"&uiID&"','"&pgid&"','"&totalTestID&"' ) SELECT @@IDENTITY"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		idx = rs(0)

		Call oJSONoutput.Set("result", 0 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson


  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>