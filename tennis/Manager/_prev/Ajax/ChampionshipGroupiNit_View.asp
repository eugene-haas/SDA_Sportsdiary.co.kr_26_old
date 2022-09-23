<!--#include virtual="/Manager_Wres/Library/ajax_config.asp"-->
<%
	strtp = fInject(request("tp"))
	strkey = fInject(decode(request("key"),0))
	ViewCnt = "50"

	'조회조건 데이터
	Search_GameYear = fInject(Request("Search_GameYear"))
	Search_GameTitleIDX = fInject(Request("Search_GameTitleIDX"))
	Search_GroupGameGb  = fInject(Request("Search_GroupGameGb"))	
	Search_TeamGb       = fInject(Request("Search_TeamGb"))	
	Search_Sex          = fInject(Request("Search_Sex"))
	Search_Stadium      = fInject(Request("Search_Stadium"))
	player              = fInject(Request("player"))

	WSQL = ""
	
	If Search_GameYear <> "" Then 
		WSQL = WSQL&" AND C.GameYear = '"&Search_GameYear&"'"
	End If 

	If Search_GameTitleIDX <> "" Then 
		WSQL = WSQL&" AND A.GameTitleIDX = '"&Search_GameTitleIDX&"'"
	End If 
	
	If Search_GroupGameGb <> "" Then 
		WSQL = WSQL&" AND A.GroupGameGb = '"&Search_GroupGameGb&"'"
	End If 
	
	If Search_TeamGb <> "" Then 
		WSQL = WSQL&" AND A.TeamGb = '"&Search_TeamGb&"'"
	End If 	

	If Search_Sex <> "" Then 
		WSQL = WSQL&" AND A.Sex = '"&Search_Sex&"'"
	End If 
	
	If Search_Stadium <> "" Then 
		WSQL = WSQL&" AND ISNULL(A.StadiumNumber,'') = '"&Search_Stadium&"'"
	End If 
	
	If player <> "" Then 
		WSQL = WSQL&" AND (SportsDiary.dbo.FN_TeamNM(A.SportsGb, A.TeamGb, A.LTeam) LIKE '%" & player & "%' OR SportsDiary.dbo.FN_TeamNM(A.SportsGb, A.TeamGb, A.RTeam) LIKE '%" & player & "%')"
	End If

	LSQL = " SELECT TOP " & ViewCnt & " A.RGameLevelidx, SportsDiary.dbo.FN_GameTitleName(A.GameTitleIDX) AS GameTitleName, "
	LSQL = LSQL & " SportsDiary.dbo.FN_PubName(A.GroupGameGb) AS GroupGameGbName, "
	LSQL = LSQL & " SportsDiary.dbo.FN_TeamGbNM(A.SportsGb, A.TeamGb) AS TeamGbName, "
	LSQL = LSQL & " CASE WHEN A.LTeam = '22369' THEN '불참학교' "
	LSQL = LSQL & " ELSE SportsDiary.dbo.FN_TeamNM(A.SportsGb, A.TeamGb, A.LTeam) END AS LTeamName , A.LTeamDtl, "
	LSQL = LSQL & " CASE WHEN A.RTeam = '22369' THEN '불참학교' "
	LSQL = LSQL & " ELSE SportsDiary.dbo.FN_TeamNM(A.SportsGb, A.TeamGb, A.RTeam) END AS RTeamName , A.RTeamDtl, A.ROUND, A.GroupGameNum, A.NowRoundNM, A.StadiumNumber,"
	LSQL = LSQL & " RIGHT('000000' + CONVERT(NVARCHAR,ISNULL(A.GameTitleIDX,0)),6) + A.TeamGb + RIGHT('000' + CONVERT(NVARCHAR,ISNULL(A.GroupGameNum,0)),3) AS NextKey"
	LSQL = LSQL & " FROM SPortsdiary.dbo.tblPlayerResult A"
	LSQL = LSQL & " INNER JOIN SPortsdiary.dbo.tblGameTitle C ON A.GameTitleIDX = C.GameTitleIDX"
	LSQL = LSQL & " WHERE A.DelYN = 'N'"
	LSQL = LSQL & " AND C.DelYN = 'N'"
	LSQL = LSQL & " AND A.GroupGameGb = 'sd040002'"
	LSQL = LSQL & " AND (ISNULL(A.LPlayerIDX,'') = '' AND ISNULL(A.RPlayerIDX,'') = '' )"
	LSQL = LSQL & " AND ISNULL(A.NowRoundNM,'') <> ''"
	
		
	If Trim(strkey) <> "" Then 
		LSQL = LSQL&" AND RIGHT('000000' + CONVERT(NVARCHAR,ISNULL(A.GameTitleIDX,0)),6) + A.TeamGb + RIGHT('000' + CONVERT(NVARCHAR,ISNULL(A.GroupGameNum,0)),3) > '" & strkey & "'"
	End If 
	
	LSQL = LSQL&WSQL 
	
	LSQL = LSQL & " ORDER BY RIGHT('000000' + CONVERT(NVARCHAR,ISNULL(A.GameTitleIDX,0)),6) + A.TeamGb + RIGHT('000' + CONVERT(NVARCHAR,ISNULL(A.GroupGameNum,0)),3) ASC"
	

	CntSQL = "SELECT  COUNT(*) CNT  "
  CntSQL = CntSQL & " FROM ("
	CntSQL = CntSQL & " SELECT A.RGameLevelidx, SportsDiary.dbo.FN_GameTitleName(A.GameTitleIDX) AS GameTitleName, "
	CntSQL = CntSQL & " SportsDiary.dbo.FN_PubName(A.GroupGameGb) AS GroupGameGbName, "
	CntSQL = CntSQL & " SportsDiary.dbo.FN_TeamGbNM(A.SportsGb, A.TeamGb) AS TeamGbName, "
	CntSQL = CntSQL & " CASE WHEN A.LTeam = '22369' THEN '불참학교' "
	CntSQL = CntSQL & " ELSE SportsDiary.dbo.FN_TeamNM(A.SportsGb, A.TeamGb, A.LTeam) END AS LTeamName , A.LTeamDtl, "
	CntSQL = CntSQL & " CASE WHEN A.RTeam = '22369' THEN '불참학교' "
	CntSQL = CntSQL & " ELSE SportsDiary.dbo.FN_TeamNM(A.SportsGb, A.TeamGb, A.RTeam) END AS RTeamName , A.RTeamDtl, A.ROUND, A.GroupGameNum, A.NowRoundNM, A.StadiumNumber"
	CntSQL = CntSQL & " FROM SPortsdiary.dbo.tblPlayerResult A"
	CntSQL = CntSQL & " INNER JOIN SPortsdiary.dbo.tblGameTitle C ON A.GameTitleIDX = C.GameTitleIDX"
	CntSQL = CntSQL & " WHERE A.DelYN = 'N'"
	CntSQL = CntSQL & " AND C.DelYN = 'N'"
	CntSQL = CntSQL & " AND A.GroupGameGb = 'sd040002'"
	CntSQL = CntSQL & " AND (ISNULL(A.LPlayerIDX,'') = '' AND ISNULL(A.RPlayerIDX,'') = '' )"
	CntSQL = CntSQL & " AND ISNULL(A.NowRoundNM,'') <> ''"
	CntSQL = CntSQL & WSQL 
	CntSQL = CntSQL & " ) A1 "

	Dbopen()
  Set LRs = Dbcon.Execute(LSQL)
	Set CRs = Dbcon.Execute(CntSQL)

	'다음조회 데이타는 행을 변경한다
	If Strtp = "N" Then 
	End If 

%>
<%
	If LRs.Eof Or LRs.Bof Then 
		Response.Write "null"
		Response.End
	Else 
%>
	<%
		intCnt = 0

		Do Until LRs.Eof 										
	%>
	<tr>		
		<td style="cursor:pointer;text-align:left;padding-left:10px;"><%=LRs("GameTitleName")%></td>
		<td style="cursor:pointer;"><%=LRs("GroupGameGbName")%></td>
		<td style="cursor:pointer;"><%=LRs("TeamGbName")%></td>
		<td style="cursor:pointer;"><%=LRs("LTeamName") & " VS " & LRs("RTeamName")%></td>
		<td style="cursor:pointer;"><%=LRs("ROUND")%></td>		
		<td style="cursor:pointer;"><%=LRs("GroupGameNum")%></td>				
		<td style="cursor:pointer;"><%=LRs("StadiumNumber")%></td>		
		<td style="cursor:pointer;"><a href="javascript:reset_groupgame('<%=encode(LRs("RGamelevelIDX"),0)%>', '<%=encode(LRs("GroupGameNum"),0)%>', '<%=LRs("LTeamName")%>' , '<%=LRs("RTeamName")%>')">리셋버튼</a></td>		
	</tr>
<%
			'다음조회를 위하여 키를 생성한다.
			strsetkey = LRs("NextKey")				
			LRs.MoveNext
			intCnt = intCnt + 1
		Loop 
%>
		ㅹ<%=encode(strsetkey,0)%>ㅹ<%=StrTp%>ㅹ<%=Crs("Cnt")%>ㅹ<%=intCnt%>
<%
	End If 
%>
<% LRs.Close
   Set LRs = Nothing
   
   CRs.Close
   Set CRs = Nothing

	Dbclose()
%>
