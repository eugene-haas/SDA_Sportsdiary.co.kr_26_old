<%
'#############################################
' 대회그룹
'#############################################
	'request
	hostTitle = oJSONoutput.codeTitle
	titleGrade = oJSONoutput.grade

	Set db = new clsDBHelper

	tablename = " sd_TennisTitleCode "
	SQL = "select max(titlecode) from " &tablename
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If isNull(rs(0)) = true  then	'중복
		titlecode = 1
	Else
		titlecode = CDbl(rs(0)) + 1
	End if
		
	insertfield = " titleCode,titleGrade,hostTitle "
	insertvalue = " "&titlecode&", "&titleGrade&", '"&hostTitle&"'  "
	SQL = "SET NOCOUNT ON INSERT INTO "&tablename&" ( "&insertfield&" ) VALUES " 
	SQL = SQL & "( "&insertvalue&" ) SELECT @@IDENTITY"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	idx = rs(0)
	titleGrade = findGrade(titleGrade)

'	Select Case titleGrade
'	Case "1" : titleGrade = "SA"
'	Case "2" : titleGrade = "GA"
'	Case "3" : titleGrade = "A"
'	Case "4" : titleGrade = "B"
'	Case "5" : titleGrade = "C"
'	Case "6" : titleGrade = "단체전"
'	End Select 


  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>
	<!-- #include virtual = "/pub/html/RookietennisAdmin/gamehost/html.codeList.asp" -->