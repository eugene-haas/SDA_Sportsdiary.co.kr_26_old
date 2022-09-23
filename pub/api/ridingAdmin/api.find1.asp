<%
'#############################################

'(대진표 RGameList )에서 (코트정보입력창 enter_score )으로 갈때 필요한 정보 확인

'#############################################
	'request
	'request
	If hasown(oJSONoutput, "PARR") = "ok" then
		parr= oJSONoutput.PARR
		reqarr = Split(parr,",")		'//년도, 개인단체, 종목, 마종, class , class 안내

		'Response.write ubound(reqarr) & "<br>"

		Select Case ubound(reqarr)
		Case 0
			p_1 = reqarr(0) '년도
		Case 1
			p_1 = reqarr(0) '년도
			p_2 = reqarr(1) '개인 201, 202
		Case 2
			p_1 = reqarr(0) '년도
			p_2 = reqarr(1) '개인 201, 202
			p_3 = reqarr(2) '종목
		Case 3
			p_1 = reqarr(0) '년도
			p_2 = reqarr(1) '개인 201, 202
			p_3 = reqarr(2) '종목
			p_4 = reqarr(3) '마종
		Case 4
			p_1 = reqarr(0) '년도
			p_2 = reqarr(1) '개인 201, 202
			p_3 = reqarr(2) '종목
			p_4 = reqarr(3) '마종
			p_5 = reqarr(4) 'class
		Case 5
			p_1 = reqarr(0) '년도
			p_2 = reqarr(1) '개인 201, 202
			p_3 = reqarr(2) '종목
			p_4 = reqarr(3) '마종
			p_5 = reqarr(4) 'class
			p_6 = reqarr(5) 'class 안내
		End Select 
	End if


'Response.write p_1 & "-- 1<br>"
'Response.write p_2 & "-- 2<br>"
'Response.write p_3 & "-- 3<br>"
'Response.write p_4 & "-- 4<br>"
'Response.write p_5 & "-- 5<br>"
'Response.write p_6 & "-- 6<br>"

	If hasown(oJSONoutput, "TitleIDX") = "ok" then
		tidx = oJSONoutput.TitleIDX
	End if
	If hasown(oJSONoutput, "TITLE") = "ok" then
		title = oJSONoutput.TITLE
	End if

	Set db = new clsDBHelper





'	If P_1 = "" Then
'		P_1 = year(date)	
'	End if
'	findWhere = " and useYear = '"&P_1&"' "
'
'	If P_2 <> "" Then
'		findWhere = findWhere & " and PTeamGb = '"&P_2&"' "
'	End if
'
'	fieldstr =  "TeamGbIDX,useyear,PTeamGb,PTeamGbNm,TeamGb,TeamGbNm,levelno,levelNm,ridingclass,ridingclasshelp,Orderby,WriteDate,DelYN "
'	SQL = "Select  "&fieldstr&" from tblTeamGbInfo where DelYN = 'N' " & findWhere & " order by orderBy asc"
'	Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)
'
'	If Not rss.EOF Then
'		arrPub = rss.GetRows()
'	End If

	'Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)
	'Call rsDrow(rss)


	%><!-- #include virtual = "/pub/html/riding/gameinfoLevelFormLine1.asp" --><%

	db.Dispose
	Set db = Nothing
%>

