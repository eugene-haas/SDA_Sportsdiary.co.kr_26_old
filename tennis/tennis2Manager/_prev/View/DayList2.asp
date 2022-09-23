<!--#include virtual="/Manager/Library/config.asp"-->
<%

	If GameTitleIDX = "" Then 
		GameTitleIDX = "53"
	End If 


	LSQL = "SELECT NowRoundNm"
	LSQL = LSQL&",Sportsdiary.dbo.Fn_TeamGbNm(SportsGb,TeamGb) AS TeamGbNm "
	LSQL = LSQL&",Sportsdiary.dbo.FN_LevelNm(SportsGb,TeamGb,Level) AS LevelNm "
	LSQL = LSQL&",Sportsdiary.dbo.FN_PubName(GameType) AS GameTypeNm "
	LSQL = LSQL&" FROM SportsDiary.dbo.tblPlayerResult "
	LSQL = LSQL&" WHERE DelYN='N'"
	LSQL = LSQL&" AND GameDay='2017-05-16'"
	LSQL = LSQL&" ORDER BY NowRound DESC,Level,GameNum"

	Set LRs = Dbcon.Execute(LSQL)

%>
<table border="1">
<%

	If Not(LRs.Eof Or LRs.Bof) Then 
		Do Until LRs.Eof 
%>
<tr>
	<td><%=LRs("NowRoundNm")%></td>
	<td><%=LRs("TeamGbNm")%></td>
	<td><%=LRs("LevelNm")%></td>
	<td><%=LRs("GameTypeNm")%></td>

</tr>
<%
			LRs.MoveNext
		Loop 
	End If 
%>