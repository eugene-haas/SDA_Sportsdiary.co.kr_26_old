<%
'#############################################
'상금저장
'#############################################
	Set db = new clsDBHelper

	'request
	If hasown(oJSONoutput, "IDX") = "ok" then
		idx = oJSONoutput.IDX
	End If

	If hasown(oJSONoutput, "PIDX") = "ok" then
		pidx = oJSONoutput.PIDX
	End If
	If hasown(oJSONoutput, "HIDX") = "ok" then
		hidx = oJSONoutput.HIDX
	End If

	If hasown(oJSONoutput, "PM") = "ok" Then '설정할 상금
		pm = oJSONoutput.PM
		pm = pm * 10000
	End If

	fldnm = " c.pttotal,c.pricetotal,c.yearpt,c.yearprice,  a.priceMoney,c.playeridx "
	tblnm = " SD_tennisMember as a INNER JOIN sd_tennisMember_partner as b ON a.gamememberidx = b.gamememberidx INNER JOIN tblPlayer as c ON a.playeridx = c.playeridx or b.playeridx = c.playeridx  "
	SQL = "Select "&fldnm&" from "&tblnm &" where a.gameMemberIDX = '"&idx&"' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arrR = rs.GetRows()
	End If
	rs.close

	If IsArray(arrR)  Then

		SQL = "Update SD_tennisMember Set priceMoney = '"&pm&"'  where gamememberidx =  '"&idx&"' "
		Call db.execSQLRs(SQL , null, ConStr)

		For ar = LBound(arrR, 2) To UBound(arrR, 2)
			pointtotal = arrR(0, ar)
			pricetotal = arrR(1, ar)
			yearpt =  arrR(2, ar)
			yearprice = arrR(3, ar)

			pricemoney = arrR(4,ar) '이전값
			playeridx = arrR(5, ar)
			updatevalue = CDbl(pm) - CDbl(pricemoney)
			'증가값은 지금값 - 이전값 예)5 - 0  = 5 ,5 - 10 =  -5

			'양수만 입력되도록 설정
			SQL = "Update tblPlayer Set pricetotal = case when (pricetotal + "&updatevalue&" > 0 ) then pricetotal + "&updatevalue&" else 0 end,yearprice = case when (yearprice + "&updatevalue&" > 0 ) then yearprice + "&updatevalue&" else 0 end  where playerIDX =  '"&playeridx&"' "
			Call db.execSQLRs(SQL , null, ConStr)

		Next
	End if


  
  	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing
%>
