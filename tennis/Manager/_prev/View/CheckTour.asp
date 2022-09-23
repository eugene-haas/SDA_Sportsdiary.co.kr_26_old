<!--#include virtual="/Manager/Library/config.asp"-->
<%

		RGameLevelIDX = Request("RGameLevelIDX")

		CSQL = "SELECT	RPlayerIDX, PlayerIDX, SportsGb, GameTitleIDX, SchIDX, UserName, TeamGb, [Level], Sex, PlayerNum, UnearnWin, LeftRightGb, GroupGameNum, NoJoinChangeYN, "
		CSQL = CSQL&" CASE WHEN ISNULL(Game1R,0) = '' Then '0' Else ISNULL(Game1R,0) END AS Game1R,"
		CSQL = CSQL&" CASE WHEN ISNULL(Game2R,0) = '' Then '0' Else ISNULL(Game2R,0) END AS Game2R,"
		CSQL = CSQL&" CASE WHEN ISNULL(Game3R,0) = '' Then '0' Else ISNULL(Game3R,0) END AS Game3R,"
		CSQL = CSQL&" CASE WHEN ISNULL(Game4R,0) = '' Then '0' Else ISNULL(Game4R,0) END AS Game4R,"
		CSQL = CSQL&" CASE WHEN ISNULL(Game5R,0) = '' Then '0' Else ISNULL(Game5R,0) END AS Game5R,"
		CSQL = CSQL&" CASE WHEN ISNULL(Game6R,0) = '' Then '0' Else ISNULL(Game6R,0) END AS Game6R,"
		CSQL = CSQL&" CASE WHEN ISNULL(Game7R,0) = '' Then '0' Else ISNULL(Game7R,0) END AS Game7R,"
		CSQL = CSQL&" CASE WHEN ISNULL(Game8R,0) = '' Then '0' Else ISNULL(Game8R,0) END AS Game8R,"
		CSQL = CSQL&" CASE WHEN ISNULL(Game9R,0) = '' Then '0' Else ISNULL(Game9R,0) END AS Game9R,"
		CSQL = CSQL&" CASE WHEN ISNULL(Game10R,0) = '' Then '0' Else ISNULL(Game10R,0) END AS Game10R,"
		CSQL = CSQL&" CASE WHEN ISNULL(Game11R,0) = '' Then '0' Else ISNULL(Game11R,0) END AS Game11R,"
		CSQL = CSQL&" CASE WHEN ISNULL(Game12R,0) = '' Then '0' Else ISNULL(Game12R,0) END AS Game12R,"
		CSQL = CSQL&" GroupGameGb, GroupAddGame, "
		CSQL = CSQL&" RGameLevelidx, WorkDt, DelYN, Team, TeamDtl, WriteDate, EditDate"
		CSQL = CSQL&" FROM         tblRPlayer"
		CSQL = CSQL&" WHERE     (RGameLevelidx = '" & RGameLevelIDX & "') AND (DelYN = 'N')"
		CSQL = CSQL&" ORDER BY PlayerNum"

		Set CRs = Dbcon.Execute(CSQL)
%>
<html>
<body>
<table>
	<%
	If Not(CRs.Eof Or CRs.Bof) Then 
		i = 0 
		Do Until CRs.Eof 
%>
	<tr>
		<td width="50"><%=CRs("UserName")%></td>
		<td width="50"><%=CRs("PlayerNum")%></td>
		
		<%For j=1 To 10%>
		<td width="50"><font color="
		<%
			

			If CInt(CRs("Game"+CStr(j)+"R")) = 0 Then 
				Response.Write "white" 
			ElseIf CInt(CRs("Game"+CStr(j)+"R")) Mod 2 = 0 Then 
				Response.Write "red" 
			Else 
				Response.Write "blue" 
			End If%>">
			<%=CRs("Game"+CStr(j)+"R")%>
		</font></td>
		<%Next%>
	
	</tr>
<%
			CRs.MoveNext
			i = i + 1
		Loop
	End If
%>

</table>
</body>
</html>