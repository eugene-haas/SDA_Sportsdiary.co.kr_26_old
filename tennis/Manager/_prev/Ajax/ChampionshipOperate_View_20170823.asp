<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	strtp = fInject(request("tp"))
	strkey = fInject(decode(request("key"),0))
	ViewCnt = "150"

	'조회조건 데이터
	Search_GameYear = fInject(Request("Search_GameYear"))
	Search_GameTitleIDX = fInject(Request("Search_GameTitleIDX"))
	Search_GroupGameGb  = fInject(Request("Search_GroupGameGb"))	
	Search_TeamGb       = fInject(Request("Search_TeamGb"))	
	Search_Sex          = fInject(Request("Search_Sex"))
	Search_Level        = fInject(Request("Search_Level"))
	Search_Stadium      = fInject(Request("Search_Stadium"))
	player              = fInject(Request("player"))
	Search_Url          = fInject(Request("Search_Url"))
	GameDay							= fInject(Request("GameDay"))

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
	
	If Search_Level <> "" Then 
		WSQL = WSQL&" AND A.Level = '"&Search_Level&"'"
	End If 
	
	If Search_Stadium <> "" Then 
		WSQL = WSQL&" AND ISNULL(A.StadiumNumber,'') = '"&Search_Stadium&"'"
	End If 
	
	If player <> "" Then 
		WSQL = WSQL&" AND ISNULL(A.LPlayerName + ' - ' + A.RPlayerName,'') LIKE '%"&player&"%'"
	End If 
	
	If Search_Url = "Y" Then 
		WSQL = WSQL&" AND ISNULL(A.MediaLink,'') <> ''"
	End If 
	
	If Search_Url = "N" Then 
		WSQL = WSQL&" AND ISNULL(A.MediaLink,'') = ''"
	End If 

	If GameDay <> "" Then
		WSQL = WSQL&" AND A.GameDay = '" & GameDay & "'"
	End If
		
	LSQL = " SELECT TOP " & ViewCnt & " A.PlayerResultIDX, SportsDiary.dbo.FN_GameTitleName(A.GameTitleIDX) AS GameTitleName,"
	LSQL = LSQL & " SportsDiary.dbo.FN_PubName(A.GroupGameGb) AS GroupGameGbNM, SportsDiary.dbo.FN_TeamGbNM(A.SportsGb, A.TeamGb) AS TeamGbNM,"
	LSQL = LSQL & " CASE WHEN A.Sex = 'Man' THEN '남자' ELSE '여자' END AS Gender,"
	LSQL = LSQL & " SportsDiary.dbo.FN_LevelNM(A.Sportsgb, A.TeamGb, A.Level) AS LevelNM,"
	LSQL = LSQL & " [Round], "
	LSQL = LSQL & " CONVERT(VARCHAR,SportsDiary.dbo.FN_Round_Nm(B.TotRound, A.[Round])) + '강' AS Kang, "
	LSQL = LSQL & " SportsDiary.dbo.FN_PlayerName(A.LPlayerIDX) AS LPlayerNM, SportsDiary.dbo.FN_PlayerName(A.RPlayerIDX) AS RPlayerNM,"
	LSQL = LSQL & " A.GameNum, A.StadiumNumber, SportsDiary.dbo.FN_CheifName(A.SportsGb,A.CheifMain) AS CheifMainNM,"
	LSQL = LSQL & " SportsDiary.dbo.FN_CheifName(A.SportsGb,A.CheifSub1) AS CheifSubNM1, SportsDiary.dbo.FN_CheifName(A.SportsGb,A.CheifSub2) AS CheifSubNM2, "
	LSQL = LSQL & " ISNULL(A.TeamGb,'') + ISNULL(A.Level,'')  + RIGHT('0000' + CONVERT(NVARCHAR,ISNULL(A.GroupGameNum,0)),4) + RIGHT('0000' + CONVERT(NVARCHAR,ISNULL(A.GameNum,0)),4) NextKey "
	LSQL = LSQL & " FROM SportsDiary.dbo.tblPlayerResult A "
	LSQL = LSQL & " INNER JOIN tblRGameLevel B ON B.RGameLevelidx = A.RgameLevelIDX "
	LSQL = LSQL & " INNER JOIN tblGameTitle C ON C.GameTitleIDX = B.GameTitleIDX "
	LSQL = LSQL & " WHERE A.DelYN = 'N' "
	LSQL = LSQL & " AND B.DelYN = 'N' "
	LSQL = LSQL & " AND C.DelYN = 'N' "
	LSQL = LSQL & " AND A.SportsGb = '" & Request.Cookies("SportsGb") & "' "

		
	If Trim(strkey) <> "" Then 
		LSQL = LSQL&" AND ISNULL(A.TeamGb,'') + ISNULL(A.Level,'')  + RIGHT('0000' + CONVERT(NVARCHAR,ISNULL(A.GroupGameNum,0)),4) + RIGHT('0000' + CONVERT(NVARCHAR,ISNULL(A.GameNum,0)),4) > '" & strkey & "'"
	End If 
	
	LSQL = LSQL&WSQL 

	LSQL = LSQL & " ORDER BY ISNULL(A.TeamGb,''), ISNULL(A.Level,''), RIGHT('0000' + CONVERT(NVARCHAR,ISNULL(A.GroupGameNum,0)),4), RIGHT('0000' + CONVERT(NVARCHAR,ISNULL(A.GameNum,0)),4) "


	

	CntSQL = "SELECT  COUNT(A1.PlayerResultIDX) CNT  "
  CntSQL = CntSQL & " FROM ("
	CntSQL = CntSQL & " SELECT TOP " & ViewCnt & " A.PlayerResultIDX, SportsDiary.dbo.FN_GameTitleName(A.GameTitleIDX) AS GameTitleName, A.GroupGameGb, A.TeamGb, A.Sex, [Round], "
	CntSQL = CntSQL & " CONVERT(VARCHAR,SportsDiary.dbo.FN_Round_Nm(B.TotRound, A.[Round])) + '강' AS Kang, "
	CntSQL = CntSQL & " A.LPlayerIDX, A.RPlayerIDX, A.GameNum, A.StadiumNumber, A.CheifMain, A.CheifSub1, A.CheifSub2, "
	CntSQL = CntSQL & " (CONVERT(VARCHAR,A.GameTitleIDX)+A.GroupGameGb+A.Sex+A.Level+A.ROUND+CONVERT(VARCHAR,A.PlayerResultIDX)) NextKey "
	CntSQL = CntSQL & " FROM SportsDiary.dbo.tblPlayerResult A "
	CntSQL = CntSQL & " INNER JOIN tblRGameLevel B ON B.RGameLevelidx = A.RgameLevelIDX "
	CntSQL = CntSQL & " INNER JOIN tblGameTitle C ON C.GameTitleIDX = B.GameTitleIDX "
	CntSQL = CntSQL & " WHERE A.DelYN = 'N' "
	CntSQL = CntSQL & " AND B.DelYN = 'N' "
	CntSQL = CntSQL & " AND C.DelYN = 'N' "
	CntSQL = CntSQL & " AND A.SportsGb = '" & Request.Cookies("SportsGb") & "' "
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
		<td style="cursor:pointer;"><%=LRs("GroupGameGbNM")%></td>
		<td style="cursor:pointer;"><%=LRs("TeamGbNM")%></td>
		<td style="cursor:pointer;"><%=LRs("Gender")%></td>
		<td style="cursor:pointer;"><%=LRs("LevelNM")%></td>
		<td style="cursor:pointer;"><%=LRs("Round")%></td>
		<td style="cursor:pointer;"><%=LRs("Kang")%></td>
		<td style="cursor:pointer;"><%=LRs("LPlayerNM") & "VS" & LRs("RPlayerNM")%></td>
		<td style="cursor:pointer;"><%=LRs("GameNum")%></td>		
		<td style="cursor:pointer;"><%=LRs("StadiumNumber")%></td>		
		<td style="cursor:pointer;"><%=LRs("CheifMainNM")%></td>		
		<td style="cursor:pointer;"><%=LRs("CheifSubNM1")%></td>		
		<td style="cursor:pointer;"><%=LRs("CheifSubNM2")%></td>		
	
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
