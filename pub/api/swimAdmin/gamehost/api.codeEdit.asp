<%
'#############################################
'수정(ajax api)
'#############################################
	'request
	idx = oJSONoutput.IDX


	Set db = new clsDBHelper
	tablename = " sd_TennisTitleCode "
	SQL = "Select top 1 titleCode,titleGrade,hostTitle from "&tablename&" where DelYN = 'N'  and idx = "& idx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof Then
		titleCode = rs("titleCode")
		titleGrade = rs("titleGrade")
		hostTitle = rs("hostTitle") 
	End if

	db.Dispose
	Set db = Nothing

	titleGradestr = findGrade(titleGrade)

'	Select Case titleGrade
'	Case "1" : titleGradestr = "SA"
'	Case "2" : titleGradestr = "GA"
'	Case "3" : titleGradestr = "A"
'	Case "4" : titleGradestr = "B"
'	Case "5" : titleGradestr = "C"
'	Case "6" : titleGradestr = "D"
'	End Select 

Call oJSONoutput.Set("result", "0" ) 

Call oJSONoutput.Set("titleCode", titleCode ) 
Call oJSONoutput.Set("titleGrade", titleGradestr ) 
Call oJSONoutput.Set("hostTitle", hostTitle ) 
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson
Response.write "`##`"
%>
<!-- #include virtual = "/pub/html/swimAdmin/gamehost/inc.codeform.asp" --> 