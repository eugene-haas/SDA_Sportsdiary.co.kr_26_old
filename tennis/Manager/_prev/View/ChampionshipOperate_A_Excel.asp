<!--#include virtual="/Manager/Library/config.asp"-->
<%
  If Request.Cookies("UserID") = "" Then
    Response.Write "<script>top.location.href='/Manager/gate.asp?Refer_Url="&Refer_URL&"'</script>"
    Response.End
  End If 

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


	'엑셀다운로드
	fileNm = "경기진행순서"	


	Response.Buffer = True
	Response.ContentType = "application/vnd.ms-excel"
	Response.AddHeader "Content-disposition","attachment;filename="&fileNm&".xls"


	WSQL = ""
	CSQL = ""
	
	If Search_GameYear <> "" Then 
		CSQL = CSQL&" AND C.GameYear = '"&Search_GameYear&"'"
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
		
	LSQL = " SELECT A.PlayerResultIDX, SportsDiary.dbo.FN_GameTitleName(A.GameTitleIDX) AS GameTitleName,"
	LSQL = LSQL & " SportsDiary.dbo.FN_PubName(A.GroupGameGb) AS GroupGameGbNM, SportsDiary.dbo.FN_TeamGbNM(A.SportsGb, A.TeamGb) AS TeamGbNM,"
	LSQL = LSQL & " CASE WHEN A.Sex = 'Man' THEN '남자' ELSE '여자' END AS Gender,"
	LSQL = LSQL & " SportsDiary.dbo.FN_LevelNM(A.Sportsgb, A.TeamGb, A.Level) AS LevelNM,"
	LSQL = LSQL & " [Round], "
	LSQL = LSQL & " NowRoundNm AS Kang, "
	LSQL = LSQL & " SportsDiary.dbo.FN_PlayerName(A.LPlayerIDX) AS LPlayerNM, SportsDiary.dbo.FN_PlayerName(A.RPlayerIDX) AS RPlayerNM,"
	LSQL = LSQL & " A.GameNum, A.StadiumNumber, SportsDiary.dbo.FN_CheifName(A.SportsGb,A.CheifMain) AS CheifMainNM,"
	LSQL = LSQL & " SportsDiary.dbo.FN_CheifName(A.SportsGb,A.CheifSub1) AS CheifSubNM1, SportsDiary.dbo.FN_CheifName(A.SportsGb,A.CheifSub2) AS CheifSubNM2 "
	LSQL = LSQL & " ,A.TurnNum AS TurnNum " 
	LSQL = LSQL & " ,sportsdiary.dbo.FN_PubName(A.GameStatus) AS GameStatusNM" 
	LSQL = LSQL & " ,A.LResult" 
	LSQL = LSQL & " ,A.RResult" 
	LSQL = LSQL & " ,SportsDiary.dbo.FN_TeamNM(A.SportsGb, A.TeamGb, A.LTeam) AS LTeamNM" 
	LSQL = LSQL & " ,A.LTeamDtl" 
	LSQL = LSQL & " ,SportsDiary.dbo.FN_TeamNM(A.SportsGb, A.TeamGb, A.RTeam) AS RTeamNM" 
	LSQL = LSQL & " ,A.RTeamDtl" 
	LSQL = LSQL & " ,A.TempNum" 

	
	LSQL = LSQL & " ,RIGHT('00000' + CONVERT(NVARCHAR,ISNULL(A.TurnNum,0)),5) + RIGHT('00000' + CONVERT(NVARCHAR,ISNULL(A.TeamGb,0)),5) + RIGHT('00000000' + CONVERT(NVARCHAR,ISNULL(A.Level,0)),8) + RIGHT('0000' + CONVERT(NVARCHAR,ISNULL(A.GroupGameNum,0)),4) + RIGHT('0000' + CONVERT(NVARCHAR,ISNULL(A.GameNum,0)),4) NextKey "
	LSQL = LSQL & " FROM ( "

	LSQL = LSQL& " 			SELECT PlayerResultIDX, RGameLevelidx, LPlayerIDX, RPlayerIDX, SportsGb, TeamGb, LTeam, RTeam,"
	LSQL = LSQL& " 			GroupGameNum, GameNum, LTeamDtl, RTeamDtl, LResult, RResult, GameStatus, GroupGameGb, Level, NowRoundNM,"
	LSQL = LSQL& " 			Sex, CheifMain, CheifSub1, CheifSub2, StadiumNumber, TurnNum, GameTitleIDX, DelYN, GameDay,"
	LSQL = LSQL& " 			ROW_NUMBER() OVER(ORDER BY ISNULL(TurnNum,'') ASC) AS TempNum, [ROUND]"
	LSQL = LSQL& " 			FROM SportsDiary.dbo.tblPlayerResult A"
	LSQL = LSQL& " 			WHERE DelYN = 'N'"
	LSQL = LSQL& " 			AND ISNULL(TurnNum,'')<>''"
	LSQL = LSQL& WSQL
	LSQL = LSQL& " 			) AS A"

	LSQL = LSQL & " INNER JOIN tblRGameLevel B ON B.RGameLevelidx = A.RgameLevelIDX "
	LSQL = LSQL & " INNER JOIN tblGameTitle C ON C.GameTitleIDX = B.GameTitleIDX "
	LSQL = LSQL & " WHERE A.DelYN = 'N' "
	LSQL = LSQL & " AND B.DelYN = 'N' "
	LSQL = LSQL & " AND C.DelYN = 'N' "
	LSQL = LSQL & " AND A.SportsGb = '"&Request.Cookies("SportsGb")&"' "
	LSQL = LSQL & " AND (ISNULL(A.RResult,'') <> 'wr052002' AND ISNULL(A.LResult,'') <> 'wr052002' AND ISNULL(A.RResult,'') <> 'wr052013' AND ISNULL(A.LResult,'') <> 'wr052013')"
	LSQL = LSQL & " AND ISNULL(A.LPlayerIDX,'') <> '1497' AND ISNULL(A.RPlayerIDX,'') <> '1497'"
	LSQL = LSQL & CSQL 

	If Request.Cookies("SportsGb") = "judo" Then
		LSQL = LSQL & " AND (A.GroupGameGb = 'sd040001' OR (A.GroupGameGb = 'sd040002' AND (ISNULL(A.LPlayerIDX,'') = '' AND ISNULL(A.RPlayerIDX,'') = '' )))"
	End If

	LSQL = LSQL & " ORDER BY RIGHT('00000' + CONVERT(NVARCHAR,ISNULL(A.TurnNum,0)),5) + RIGHT('00000' + CONVERT(NVARCHAR,ISNULL(A.TeamGb,0)),5) + RIGHT('00000000' + CONVERT(NVARCHAR,ISNULL(A.Level,0)),8) + RIGHT('0000' + CONVERT(NVARCHAR,ISNULL(A.GroupGameNum,0)),4) + RIGHT('0000' + CONVERT(NVARCHAR,ISNULL(A.GameNum,0)),4) ASC"
	
	Set LRs = Dbcon.Execute(LSQL)

%>
<table border="1">
	<tr>
		<td>대회명</td>
		<td>구분</td>
		<td>종별</td>
		<td>성별</td>
		<td>체급</td>
		<td>경기장</td>
		<td>경기(강)</td>
		<td>경기순번</td>
		<td>선수소속명(좌)</td>
		<td>선수명(좌)</td>
		<td>선수소속명(우)</td>
		<td>선수명(우)</td>
		<td>상태</td>
		<%If Request.Cookies("SportsGb") = "wres" Then%>
		<td>심판장</td>
		<td>주심</td>
		<td>부심</td>
		<%End If%>
	</tr>
	<%
		If Not(LRs.Eof Or LRs.Bof) Then 
			Do Until LRs.Eof 
	%>
	<tr>
		<td style="mso-number-format:\@"><%=LRs("GameTitleName")%></td>
		<td style="mso-number-format:\@"><%=LRs("GroupGameGbNM")%></td>
		<td style="mso-number-format:\@"><%=LRs("TeamGbNM")%></td>
		<td style="mso-number-format:\@"><%=LRs("Gender")%></td>
		<td style="mso-number-format:\@"><%=LRs("LevelNM")%></td>
		<td style="mso-number-format:\@"><%=LRs("StadiumNumber")%></td>
		<td style="mso-number-format:\@"><%=LRs("Kang")%></td>
		<td style="mso-number-format:\@"><%=LRs("TempNum")%></td>
		<td style="mso-number-format:\@"><%=LRs("LTeamNM")%></td>
		<td style="mso-number-format:\@"><%=LRs("LPlayerNM")%></td>
		<td style="mso-number-format:\@"><%=LRs("RTeamNM")%></td>
		<td style="mso-number-format:\@"><%=LRs("RPlayerNM")%></td>
		<td style="mso-number-format:\@">
		<%
			If LRs("LResult") = "sd019006" Or LRs("RResult") = "sd019006" Then		
				Response.Write "부전승"
			Else
				Response.Write LRs("GameStatusNM")
			End If
		%>		
		</td>
		<%If Request.Cookies("SportsGb") = "wres" Then%>
		<td><%=LRs("CheifMainNM")%></td>
		<td><%=LRs("CheifSubNM1")%></td>
		<td><%=LRs("CheifSubNM2")%></td>
		<%End If%>
	</tr>
	<%
				LRs.MoveNext
			Loop 
		End If 
	%>
</table>
