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
		CSQL = CSQL&" AND B.GameYear = '"&Search_GameYear&"'"
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
		


	LSQL = " SELECT SportsDiary.dbo.FN_GameTitleName(A.GameTitleIDX) AS GameTitleName"
	LSQL = LSQL & " , SportsDiary.Dbo.FN_TeamGbNM(A.SportsGb,A.TeamGb) AS TeamGbNM, SportsDiary.Dbo.FN_LevelNM(A.SportsGb,A.TeamGb,A.level) AS LevelNM, A.NowRoundNM"
	LSQL = LSQL & " , MIN(A.TempNum) AS MinNum, MAX(A.TempNum) AS MaxNum, COUNT(*) AS CNT, StadiumNumber "
	LSQL = LSQL & " FROM "
	LSQL = LSQL & " 	("
	LSQL = LSQL & " 	 SELECT PlayerResultIDX, RGameLevelidx, LPlayerIDX, RPlayerIDX, SportsGb, TeamGb, LTeam, RTeam"
	LSQL = LSQL & "		 , GroupGameNum, GameNum, LTeamDtl, RTeamDtl, LResult, RResult, GameStatus, "
	LSQL = LSQL & " 	 GroupGameGb, Level, NowRoundNM, Sex, CheifMain, CheifSub1, CheifSub2, StadiumNumber, TurnNum, GameTitleIDX, DelYN, GameDay"
	LSQL = LSQL & " 	 , ROW_NUMBER() OVER(ORDER BY ISNULL(TurnNum,'') ASC) AS TempNum, [ROUND] "
	LSQL = LSQL & " 	 FROM SportsDiary.dbo.tblPlayerResult A"
	LSQL = LSQL & " 	 WHERE DelYN = 'N' AND ISNULL(TurnNum,'')<>'' "
	LSQL = LSQL & WSQL
	LSQL = LSQL & " 	) AS A"
	LSQL = LSQL & " INNER JOIN tblGameTitle B ON B.GameTitleIDX = A.GameTitleIDX "
	LSQL = LSQL & " WHERE A.DelYN = 'N'"
	LSQL = LSQL & CSQL


	If Request.Cookies("SportsGb") = "judo" Then
		LSQL = LSQL & " AND (A.GroupGameGb = 'sd040001' OR (A.GroupGameGb = 'sd040002' AND (ISNULL(A.LPlayerIDX,'') = '' AND ISNULL(A.RPlayerIDX,'') = '' )))"
	End If


	LSQL = LSQL & " GROUP BY A.SportsGb, A.GameTitleidx, A.TeamGb, A.[Level], A.NowRoundNM, A.StadiumNumber"
	LSQL = LSQL & " ORDER BY MIN(TurnNum)"

	Set LRs = Dbcon.Execute(LSQL)

%>
<table border="1">
	<tr>
		<td>대회명</td>
		<td>종별</td>
		<td>체급</td>
		<td>경기(강)</td>
		<td>경기장번호</td>
		<td>경기수</td>
		<td>경기시작순번</td>
		<td>경기끝순번</td>
	</tr>
	<%
		If Not(LRs.Eof Or LRs.Bof) Then 
			Do Until LRs.Eof 
	%>
	<tr>
		<td style="mso-number-format:\@"><%=LRs("GameTitleName")%></td>
		<td style="mso-number-format:\@"><%=LRs("TeamGbNM")%></td>
		<td style="mso-number-format:\@"><%=LRs("LevelNM")%></td>
		<td style="mso-number-format:\@"><%=LRs("NowRoundNM")%></td>
		<td style="mso-number-format:\@"><%=LRs("StadiumNumber")%></td>
		<td style="mso-number-format:\@"><%=LRs("CNT")%></td>
		<td style="mso-number-format:\@"><%=LRs("MinNum")%></td>
		<td style="mso-number-format:\@"><%=LRs("MaxNum")%></td>


		</td>
	</tr>
	<%
				LRs.MoveNext
			Loop 
		End If 
	%>
</table>
