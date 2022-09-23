<%
'#############################################
'선수 정보 수정 ( 이름은 변경 되지 않습니다.)
'#############################################
	'request
	idx = oJSONoutput.idx
	hostTitle = oJSONoutput.codeTitle
	titleGrade = oJSONoutput.grade
	titleCode = oJSONoutput.titleCode
	

	Set db = new clsDBHelper

	tablename = " sd_TennisTitleCode "
	updatevalue = " hostTitle='"&hostTitle&"',titleGrade =  "&titleGrade&"  " 
	SQL = " Update  "&tablename&" Set  " & updatevalue & " where idx = " & idx
	Call db.execSQLRs(SQL , null, ConStr)

	idx = idx
	titleGrade = findGrade(titleGrade)

'	Select Case titleGrade
'	Case "1" : titleGrade = "SA"
'	Case "2" : titleGrade = "GA"
'	Case "3" : titleGrade = "A"
'	Case "4" : titleGrade = "B"
'	Case "5" : titleGrade = "C"
'	Case "6" : titleGrade = "단체전"
'	End Select 


  db.Dispose
  Set db = Nothing
%>

	<!-- #include virtual = "/pub/html/tennisAdmin/gamehost/html.codeList.asp" -->