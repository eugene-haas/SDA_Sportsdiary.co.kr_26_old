<%
'#############################################

'대회생성저장

'#############################################
	'request
	If hasown(oJSONoutput, "PARR") = "ok" then
		Set reqArr = oJSONoutput.PARR '23번까지 '13, 14 날짜형태
	End if

	Set db = new clsDBHelper 

		SQL = "select max(reqID) from tblQA "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If isNull(rs(0)) = True Then
			reqID = "REQ_01"
			UIID = "UI_0101"
			pgID = "PG_0101"
			TotalTestID = "TS_0101"
		Else
			code = Split(rs(0),"_")(1)
			reqID = "REQ_" & addZero(CDbl(code) + 1)
			UIID = "UI_" & addZero(CDbl(code) + 1) & "01"
			pgID = "PG_" & addZero(CDbl(code) + 1) & "01"
			TotalTestID = "TS_" & addZero(CDbl(code) + 1) & "01"
		End If

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