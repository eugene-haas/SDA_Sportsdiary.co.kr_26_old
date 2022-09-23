<%
'######################
'부서찾기
'######################
	If hasown(oJSONoutput, "GY") = "ok" then
		GY = oJSONoutput.GY
	End if

	If hasown(oJSONoutput, "TIDX") = "ok" then
		tidx = oJSONoutput.TIDX
	End If

	If hasown(oJSONoutput, "DROWTYPE") = "ok" then
		DROWTYPE = oJSONoutput.DROWTYPE
	End if	

	If hasown(oJSONoutput, "pg") = "ok" then
		page = oJSONoutput.pg
	Else
		page = 1
	End if


	Set db = new clsDBHelper

	SQL = "Select gameyear  from sd_bikeTitle where delYN = 'N' group by gameyear order by 1 desc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arrY = rs.GetRows()
	End If

	'그룹/종목
	SQL = "Select titleIDX,gameTitleName from sd_bikeTitle where delYN = 'N' and gameyear = '"&GY&"' order by titleidx desc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arrRS = rs.GetRows()
	End If


	'그룹/종목
	SQL = "Select levelIDX,detailtitle,sex,booNM from sd_bikeLevel where delYN = 'N' and titleIDX = '"&tidx&"' order by sex, booNM"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arrB = rs.GetRows()
	End If





	db.Dispose
	Set db = Nothing
%>
<!-- #include virtual = "/pub/html/bike/form.gameSearch.asp" -->
