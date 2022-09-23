<!-- #include virtual = "/pub/header.tennisAdmin.asp" -->
<!-- #include virtual="/pub/class/JSON_2.0.4.asp" -->
<!-- #include virtual="/pub/class/JSON_UTIL_0.1.1.asp" -->
<!-- #include virtual="/pub/class/json2.asp" -->

<%
'잠시 사용한 거임.......
Response.end


Set db = new clsDBHelper

SQL = "select  PlayerIDX,max(teamGbName) as tn  from sd_TennisRPoint_log where teamGbName in ('신인부','오픈부')  group by playeridx"
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

Do Until rs.eof

boo = rs("tn")
pidx = rs("PlayerIDX")

	SQL = "update tblPlayer set belongBoo = '" & boo  & "' where PlayerIDX = " & pidx
	Call db.execSQLRs(SQL , null, ConStr)
	Response.write sql & "<br>"


prename = nm
rs.movenext
Loop



Response.end


SQL = "select name,booname,phone,title,team1 from sd_2017excelrank where booname in ('신인부','오픈부') "
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

Do Until rs.eof

title = rs("title")
name = rs("name")
team1 = rs("team1")
boo = rs("booname")

	Select Case  boo
	Case "신인부"
		teamgb = "20104"
	Case "오픈부"
		teamgb = "20105"
	End Select


'Response.write rs("name") & " " & rs("booname") & "<br>"

	SQL = "update sd_TennisRPoint_log  Set teamgb = "&teamgb&" ,teamGbName = '"&boo&"' where teamGb = '' and userName = '"&name&"' and titleName = '"&title&"' "
	'SQL = "update tblPlayer set belongBoo = '" & boo  & "' where userName = '"&nm&"' and userPhone = '"&pn&"' "
	Call db.execSQLRs(SQL , null, ConStr)
	Response.write sql & "<br>"


prename = nm
rs.movenext
Loop


Response.end


	SQL = "Select top 1 PlayerIDX,TeamNm,Team2Nm,userName,userPhone from tblPlayer where delYN = 'N' and UserName = '"&LCase(Trim(pname))&"' and belongBoo = '"&teamgbnm&"' and userPhone = '"&phone&"' order by UserName desc" 
	'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	'If rs.eof Then
		'선수등록
		insertfield = " SportsGb,UserName,EnterType,Team,TeamNm, Team2,Team2Nm,belongBoo,userphone "
		insertvalue = " 'tennis','"&pname&"','A','"&t1code&"','"&team1Nm&"','"&t1code&"','"&team2Nm&"', '" &teamgbnm & "', '" & phone &  "' "

		SQL = "SET NOCOUNT ON INSERT INTO tblPlayer ( "&insertfield&" ) VALUES " 
		SQL = SQL & "( "&insertvalue&" ) SELECT @@IDENTITY"
		'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)




db.Dispose
Set db = Nothing
%>