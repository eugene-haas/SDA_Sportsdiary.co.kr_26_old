<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	strtp = fInject(request("tp"))
	strkey = fInject(decode(request("key"),0))
	ViewCnt = "1500"

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
		CSQL = CSQL&" AND ISNULL(SportsDiary.dbo.FN_PlayerName(A.LPlayerIDX) + ' - ' + SportsDiary.dbo.FN_PlayerName(A.RPlayerIDX),'') LIKE '%"&player&"%'"
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
	
	
	'LSQL = LSQL & " ISNULL(A.TeamGb,'') + ISNULL(A.Level,'')  + RIGHT('0000' + CONVERT(NVARCHAR,ISNULL(A.GroupGameNum,0)),4) + RIGHT('0000' + CONVERT(NVARCHAR,ISNULL(A.GameNum,0)),4) NextKey "

	'LSQL = LSQL & " ,A.TurnNum AS Nextkey " 
	
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
		'LSQL = LSQL & " AND ("
		'LSQL = LSQL & " 	  ISNULL(GameStatus,'') = ''"
		'LSQL = LSQL & " 		OR GameStatus = 'sd050001'"
		'LSQL = LSQL & " 		OR (GameStatus = 'sd050002' AND (LResult = 'sd019006' OR RResult = 'sd019006'))"
		'LSQL = LSQL & " 		)"
	End If

		
	If Trim(strkey) <> "" Then 
		'LSQL = LSQL&" AND ISNULL(A.TeamGb,'') + ISNULL(A.Level,'')  + RIGHT('0000' + CONVERT(NVARCHAR,ISNULL(A.GroupGameNum,0)),4) + RIGHT('0000' + CONVERT(NVARCHAR,ISNULL(A.GameNum,0)),4) > '" & strkey & "'"
		
		'LSQL = LSQL&" AND A.TurnNum > '" & strkey & "'"

		LSQL = LSQL & " AND RIGHT('00000' + CONVERT(NVARCHAR,ISNULL(A.TurnNum,0)),5) + RIGHT('00000' + CONVERT(NVARCHAR,ISNULL(A.TeamGb,0)),5) + RIGHT('00000000' + CONVERT(NVARCHAR,ISNULL(A.Level,0)),8) + RIGHT('0000' + CONVERT(NVARCHAR,ISNULL(A.GroupGameNum,0)),4) + RIGHT('0000' + CONVERT(NVARCHAR,ISNULL(A.GameNum,0)),4)"
		LSQL = LSQL & " > '" & strkey & "'"
	End If 
	


	'LSQL = LSQL & " ORDER BY ISNULL(A.TeamGb,''), ISNULL(A.Level,''), RIGHT('0000' + CONVERT(NVARCHAR,ISNULL(A.GroupGameNum,0)),4), RIGHT('0000' + CONVERT(NVARCHAR,ISNULL(A.GameNum,0)),4) "
	
	'LSQL = LSQL & "ORDER BY TurnNum ASC"

	LSQL = LSQL & " ORDER BY RIGHT('00000' + CONVERT(NVARCHAR,ISNULL(A.TurnNum,0)),5) + RIGHT('00000' + CONVERT(NVARCHAR,ISNULL(A.TeamGb,0)),5) + RIGHT('00000000' + CONVERT(NVARCHAR,ISNULL(A.Level,0)),8) + RIGHT('0000' + CONVERT(NVARCHAR,ISNULL(A.GroupGameNum,0)),4) + RIGHT('0000' + CONVERT(NVARCHAR,ISNULL(A.GameNum,0)),4) ASC"



	CntSQL = "SELECT  COUNT(A1.PlayerResultIDX) CNT  "
  CntSQL = CntSQL & " FROM ("
	CntSQL = CntSQL & " SELECT  A.PlayerResultIDX, SportsDiary.dbo.FN_GameTitleName(A.GameTitleIDX) AS GameTitleName, A.GroupGameGb, A.TeamGb, A.Sex, [Round], "
	CntSQL = CntSQL & " NowRoundNm AS Kang, "
	CntSQL = CntSQL & " A.LPlayerIDX, A.RPlayerIDX, A.GameNum, A.StadiumNumber, A.CheifMain, A.CheifSub1, A.CheifSub2 "
'	CntSQL = CntSQL & " (CONVERT(VARCHAR,A.GameTitleIDX)+A.GroupGameGb+A.Sex+A.Level+A.ROUND+CONVERT(VARCHAR,A.PlayerResultIDX)) NextKey "
	CntSQL = CntSQL &" ,RIGHT('00000' + CONVERT(NVARCHAR,ISNULL(A.TurnNum,0)),5) + RIGHT('00000' + CONVERT(NVARCHAR,ISNULL(A.TeamGb,0)),5) + RIGHT('00000000' + CONVERT(NVARCHAR,ISNULL(A.Level,0)),8) + RIGHT('0000' + CONVERT(NVARCHAR,ISNULL(A.GroupGameNum,0)),4) + RIGHT('0000' + CONVERT(NVARCHAR,ISNULL(A.GameNum,0)),4) AS Nextkey" 
	CntSQL = CntSQL & " FROM ( "

	CntSQL = CntSQL& " 			SELECT PlayerResultIDX, RGameLevelidx, LPlayerIDX, RPlayerIDX, SportsGb, TeamGb, LTeam, RTeam,"
	CntSQL = CntSQL& " 			GroupGameNum, GameNum, LTeamDtl, RTeamDtl, LResult, RResult, GameStatus, GroupGameGb, Level, NowRoundNM,"
	CntSQL = CntSQL& " 			Sex, CheifMain, CheifSub1, CheifSub2, StadiumNumber, TurnNum, GameTitleIDX, DelYN, GameDay,"
	CntSQL = CntSQL& " 			ROW_NUMBER() OVER(ORDER BY ISNULL(TurnNum,'') ASC) AS TempNum, [ROUND]"
	CntSQL = CntSQL& " 			FROM SportsDiary.dbo.tblPlayerResult A"
	CntSQL = CntSQL& " 			WHERE DelYN = 'N'"
	CntSQL = CntSQL& " 			AND ISNULL(TurnNum,'')<>''"
	CntSQL = CntSQL& WSQL
	CntSQL = CntSQL& " 			) AS A"

	CntSQL = CntSQL & " INNER JOIN tblRGameLevel B ON B.RGameLevelidx = A.RgameLevelIDX "
	CntSQL = CntSQL & " INNER JOIN tblGameTitle C ON C.GameTitleIDX = B.GameTitleIDX "
	CntSQL = CntSQL & " WHERE A.DelYN = 'N' "
	CntSQL = CntSQL & " AND B.DelYN = 'N' "
	CntSQL = CntSQL & " AND C.DelYN = 'N' "
	CntSQL = CntSQL & " AND A.SportsGb = '"&Request.Cookies("SportsGb")&"' "
	CntSQL = CntSQL & " AND (ISNULL(A.RResult,'') <> 'wr052002' AND ISNULL(A.LResult,'') <> 'wr052002' AND ISNULL(A.RResult,'') <> 'wr052013' AND ISNULL(A.LResult,'') <> 'wr052013')"
	CntSQL = CntSQL & " AND ISNULL(A.LPlayerIDX,'') <> '1497' AND ISNULL(A.RPlayerIDX,'') <> '1497'"
	CntSQL = CntSQL & CSQL 

	If Request.Cookies("SportsGb") = "judo" Then
		CntSQL = CntSQL & " AND (A.GroupGameGb = 'sd040001' OR (A.GroupGameGb = 'sd040002' AND (ISNULL(A.LPlayerIDX,'') = '' AND ISNULL(A.RPlayerIDX,'') = '' )))"
		'CntSQL = CntSQL & " AND ("
		'CntSQL = CntSQL & " 	  ISNULL(GameStatus,'') = ''"
		'CntSQL = CntSQL & " 		OR GameStatus = 'sd050001'"
		'CntSQL = CntSQL & " 		OR (GameStatus = 'sd050002' AND (LResult = 'sd019006' OR RResult = 'sd019006'))"
		'CntSQL = CntSQL & " 		)"
	End If

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
		<td style="cursor:pointer;"><%="(" & LRs("LTeamNM") & ")"%><font color="blue"><%=LRs("LPlayerNM") & " VS " & LRs("RPlayerNM")%></font><%="(" & LRs("RTeamNM") & ")"%></td>
		<td style="cursor:pointer;"><%=LRs("TurnNum")%></td>		
		<td style="cursor:pointer;"><%=LRs("TempNum")%></td>	
		<td style="cursor:pointer;"><%=LRs("StadiumNumber")%></td>		
		<td style="cursor:pointer;">
		<%
			If LRs("LResult") = "sd019006" Or LRs("RResult") = "sd019006" Then		
				Response.Write "부전승"
			Else
				Response.Write LRs("GameStatusNM")
			End If
		%>
		</td>		
		

		<%If Request.Cookies("SportsGb") = "wres" Then%>
		<td style="cursor:pointer;">			
			<select name="CheifMainNM<%=intCnt%>" id="CheifMainNM<%=intCnt%>" onChange="Change_CheifMain('<%=LRs("PlayerResultIDX")%>',this.value)">
				<option value="" selected>=선택=</option>
				<%
					CheifSQL1 = "SELECT CheifIDX,UserName from tblCheif where delyn='N' and sportsgb='wres' order by username "

					Set CheifRs1 = Dbcon.Execute(CheifSQL1)

					If Not (CheifRs1.Eof Or CheifRs1.Bof) Then
						Do Until CheifRs1.Eof 
				%>
				<option value="<%=CheifRs1("CheifIDX")%>" <%If CheifRs1("UserName") = LRs("CheifMainNM") Then %>selected<%End If %>><%=CheifRs1("UserName")%></option>
				<%
							CheifRs1.MoveNext
						Loop 
					End If 
				%>
			</select>			
		</td>		
		<td style="cursor:pointer;">
			<select name="CheifSubNM1<%=intCnt%>" id="CheifSubNM1<%=intCnt%>" onChange="Change_CheifSubNM1('<%=LRs("PlayerResultIDX")%>',this.value)">		
				<option value="" selected>=선택=</option>
				<%
					CheifSQL1 = "SELECT CheifIDX,UserName from tblCheif where delyn='N' and sportsgb='wres' order by username "

					Set CheifRs1 = Dbcon.Execute(CheifSQL1)

					If Not (CheifRs1.Eof Or CheifRs1.Bof) Then
						Do Until CheifRs1.Eof 
				%>
				<option value="<%=CheifRs1("CheifIDX")%>" <%If CheifRs1("UserName") = LRs("CheifSubNM1") Then %>selected<%End If %>><%=CheifRs1("UserName")%></option>
				<%
							CheifRs1.MoveNext
						Loop 
					End If 
				%>
			</select>
			
		</td>		
		<td style="cursor:pointer;">
			<select name="CheifSubNM2<%=intCnt%>" id="CheifSubNM2<%=intCnt%>" onChange="Change_CheifSubNM2('<%=LRs("PlayerResultIDX")%>',this.value)">	
				<option value="" selected>=선택=</option>
				<%
					CheifSQL1 = "SELECT CheifIDX,UserName from tblCheif where delyn='N' and sportsgb='wres' order by username "

					Set CheifRs1 = Dbcon.Execute(CheifSQL1)

					If Not (CheifRs1.Eof Or CheifRs1.Bof) Then
						Do Until CheifRs1.Eof 
				%>
				<option value="<%=CheifRs1("CheifIDX")%>" <%If CheifRs1("UserName") = LRs("CheifSubNM2") Then %>selected<%End If %>><%=CheifRs1("UserName")%></option>
				<%
							CheifRs1.MoveNext
						Loop 
					End If 
				%>
			</select>
		</td>
		<td style="cursor:pointer;"><a href="#" onclick="print_judgepaper('<%=LRs("PlayerResultIDX")%>')">출력</a></td>		
		<%End If%>
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
