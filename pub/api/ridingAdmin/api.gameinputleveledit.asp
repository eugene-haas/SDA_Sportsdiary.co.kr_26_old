<%
'#############################################

'경기세부종목 수정불러오기

'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" Then
		reqidx = oJSONoutput.IDX
	End if
	If hasown(oJSONoutput, "TitleIDX") = "ok" Then
		reqtidx = oJSONoutput.TitleIDX
	End If


	Set db = new clsDBHelper


	strTableName = "  tblRGameLevel as a inner join tblTeamGbInfo as b  ON a.gbidx = b.teamgbidx "
	strfieldA = " a.RGameLevelidx,a.gameno,a.GameTitleIDX,a.GbIDX,a.pubcode,a.pubName,a.attdateS,a.attdateE,a.GameDay,a.GameTime,a.levelno,a.attmembercnt,a.fee,a.cfg "
	strfieldB = " b.TeamGbIDX,b.useyear,b.PTeamGb,b.PTeamGbNm,b.TeamGb,b.TeamGbNm,b.levelno,b.levelNm,b.ridingclass,b.ridingclasshelp,b.EnterType "
	strFieldName = strfieldA &  "," & strfieldB
	strWhere = " a.RGameLevelidx = "& reqidx

	SQL = "Select top 1 " & strFieldName & " from "&strTableName&" where " & strWhere
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


	If Not rs.EOF Then
		arrR = rs.GetRows()
	End If

	If IsArray(arrR) Then 
		For ari = LBound(arrR, 2) To UBound(arrR, 2)
			e_a1 = arrR(0, ari) 'idx
			e_a2 = arrR(1, ari) 'gameno
			e_a3 = arrR(2, ari)
			e_a4 = arrR(3, ari) 'gbidx

			e_idx = e_a1			
			e_gno = e_a2

			e_a5 = arrR(4, ari) '부명
			e_a6 = arrR(5, ari)
			e_a7 = arrR(6, ari) '시작
			e_a8 = arrR(7, ari) '종료
			e_a9 = arrR(8, ari) '게임일
			e_a10 = arrR(9, ari)
			e_a11 = arrR(10, ari)
			e_a12 = arrR(11, ari) 
			e_a13 = arrR(12, ari) 'fee
			e_a14 = arrR(13, ari) 'cfg



			e_chk1 = Left(r_a14,1)
			e_chk2 = Mid(r_a14,2,1)
			e_chk3 = Mid(r_a14,3,1)
			e_chk4 = Mid(r_a14,4,1)

			'If chk1 = "Y" Then '사용하지말자...빈자리
			'chk1 = "체전"
			'Else
			'chk1 = "비체전"
			'End If

			e_b1 = arrR(14, ari)
			e_b2 = arrR(15, ari) '년도
			P_1 = e_b2
			e_b3 = arrR(16, ari)
			P_2 = e_b3
			e_b4 = arrR(17, ari) '개인/단체
			e_b5 = arrR(18, ari) 
			P_3 = e_b5
			e_b6 = arrR(19, ari) '종목
			e_b7 = arrR(20, ari)
			P_4 = e_b7
			e_b8 = arrR(21, ari) '마종
			e_b9 = arrR(22, ari) 'class
			P_5 = e_b9
			e_b10 = arrR(23, ari) 'classhelp
			P_6 = e_b10
			e_b11 = arrR(24, ari)

		Next
	End if

	'공통구하고
'Call rsdrow(rs)
'response.end

	SQL = "Select RGameLevelidx,pubcode,pubName,fee from tblRGameLevel where delYN = 'N' and gametitleidx = "&reqtidx&" and GbIDX = " & e_a4 & " order by pubcode "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

'Response.write sql
'Call rsdrow(rs)

	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	Do Until rs.eof
		e_pubcode = rs("pubcode")
		e_pubname = rs("pubname")
		e_pubfee = rs("fee")
		Select Case e_pubcode
		Case "1"
			e_pubcode1 = e_pubcode
			e_pubfee1 = e_pubfee
		Case "2"
			e_pubcode2 = e_pubcode
			e_pubfee2 = e_pubfee
		Case "3"
			e_pubcode3 = e_pubcode
			e_pubfee3 = e_pubfee
		Case "4"
			e_pubcode4 = e_pubcode
			e_pubfee4 = e_pubfee
		Case "5"
			e_pubcode5 = e_pubcode
			e_pubfee5 = e_pubfee
		Case "6"
			e_pubcode6 = e_pubcode
			e_pubfee6 = e_pubfee
		End Select 
	rs.movenext
	loop

'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'Call rsdrow(rs)
'response.end



	%><!-- #include virtual = "/pub/html/riding/gameinfolevelform.asp" --><%

	db.Dispose
	Set db = Nothing


%>
