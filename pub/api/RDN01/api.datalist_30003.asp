<!-- #include virtual = "/pub/header.RidingAdmin.asp" -->
<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<%
Dim intTotalCnt, intTotalPage '총갯수, 총페이지수
'############################################
	If request("test") = "t" Then
		REQ ="{""CMD"":30003,""SENDPRE"":""rule_"",""PARR"":[""3"",""각 위원회 규정"",""56""]}"
	Else
		REQ = request("REQ")
	End if

	If REQ = "" Then
		Response.End
	End if

	Set oJSONoutput = JSON.Parse( join(array(REQ)) )
	CMD = oJSONoutput.Get("CMD")


'#############################################

'대회 정보 수정

'#############################################
	'request
	If hasown(oJSONoutput, "PARR") = "ok" then
		Set reqArr = oJSONoutput.PARR '23번까지 '13, 14 날짜형태
	End if

	Set db = new clsDBHelper 

		tablename = "tblSimpleBoard"
		strFieldName = " CATE,TITLE  "

		upfieldarr =  Split(strFieldName, ",")  'e_idx 는 맨두에 별도값으로가져오고

		For i = 0 To oJSONoutput.PARR.length-1 '받아온 값 기준
			Select Case i
			Case 0
				updatefield	= " "&upfieldarr(i)&" = '"&reqArr.Get(i)&"' "

			Case oJSONoutput.PARR.length-1
				e_idx = reqArr.Get(i)

			Case Else
				updatefield	= updatefield & ", "&upfieldarr(i)&" =  '"&reqArr.Get(i)&"' "
			End Select 
		next

		strSql = "update  "&tablename&" Set   " & updatefield & " where seq = " & e_idx
		Call db.execSQLRs(strSQL , null, ConStr)

		Call oJSONoutput.Set("result", 0 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson


  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>




