<!-- #include virtual = "/pub/header.RidingAdmin.asp" -->
<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<%
Dim intTotalCnt, intTotalPage '총갯수, 총페이지수
'############################################
%><!-- #include virtual = "/pub/setReq.asp" --><%'이걸열어서 디버깅하자.%><%
'#############################################

'동영상갤러리 정보 수정

'#############################################
	'request
	If hasown(oJSONoutput, "PARR") = "ok" then
		Set reqArr = oJSONoutput.PARR '23번까지 '13, 14 날짜형태
	End if

	Set db = new clsDBHelper

		tablename = "tblTotalBoard"
		strFieldName = " title  "

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
