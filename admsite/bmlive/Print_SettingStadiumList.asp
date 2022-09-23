<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->
<% 
	Response.CharSet="utf-8"
	Session.codepage="65001"
	Response.codepage="65001"
	Response.ContentType="text/html;charset=utf-8"

  tGameTitleIDX = Request("GameTitleIDX")
	tStadiumIdx = Request("StadiumIdx")
	tGameDay = Request("GameDay")

  If ISNull(tGameTitleIDX) Or tGameTitleIDX = "" Then
    GameTitleIDX = ""
    DEC_GameTitleIDX = ""
  Else
    GameTitleIDX = fInject(tGameTitleIDX)
    DEC_GameTitleIDX = fInject(crypt.DecryptStringENC(tGameTitleIDX))    
  End If
	
  If ISNull(tStadiumIdx) Or tStadiumIdx = "" Then
    StadiumIdx = ""
    DEC_StadiumIdx = ""
  Else
    StadiumIdx = fInject(tStadiumIdx)
    DEC_StadiumIdx = fInject(crypt.DecryptStringENC(tStadiumIdx))    
  End If

	If ISNull(tGameDay) Or tGameDay = "" Then
    GameDay = ""
    DEC_GameDay = ""
  Else
    GameDay = fInject(tGameDay)
    DEC_GameDay = fInject(tGameDay)
  End If


				LSQL = "	SELECT AA.StadiumNM, AA.GameDay, AA.StadiumIDX"
				LSQL = LSQL & "	FROM"
				LSQL = LSQL & "		("
				LSQL = LSQL & " 	SELECT "
				LSQL = LSQL & " 	dbo.FN_NameSch(C.StadiumIDX,'StadiumIDX') AS StadiumNM, "
				LSQL = LSQL & " 	C.GameDay,"
				LSQL = LSQL & " 	C.StadiumIDX"
				'LSQL = LSQL & " 	COUNT(*) AS GameCnt"
				LSQL = LSQL & " 	FROM tblGameLevel A"
				LSQL = LSQL & " 	INNER JOIN tblGameLeveldtl B ON B.GameLevelIDX = A.GameLevelIDX"
				LSQL = LSQL & " 	INNER JOIN tblTourney C ON C.GameLeveldtlIDX = B.GameLeveldtlIDX"
				LSQL = LSQL & " 	INNER JOIN tblTourney D ON D.GameLevelDtlidx = C.GameLevelDtlidx AND D.TeamGameNum = C.TeamGameNum AND D.GameNum = C.GameNum  "
				LSQL = LSQL & " 	WHERE A.DelYN = 'N'"
				LSQL = LSQL & " 	AND B.DelYN = 'N'"
				LSQL = LSQL & " 	AND C.DelYN = 'N'"
				LSQL = LSQL & " 	AND D.DelYN = 'N'"
				LSQL = LSQL & " 	AND C.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
				'LSQL = LSQL & " 	AND C.GameDay = '" & DEC_GameDay & "'"
				LSQL = LSQL & " 	AND C.ORDERBY < D.ORDERBY "
				LSQL = LSQL & " 	AND C.TeamGameNum = '0' "
				LSQL = LSQL & " 	AND C.ByeYN = 'N' AND D.ByeYN = 'N'"
				LSQL = LSQL & " 	"
				LSQL = LSQL & " 	UNION ALL"
				LSQL = LSQL & " 	"
				LSQL = LSQL & " 	SELECT "
				LSQL = LSQL & " 	dbo.FN_NameSch(C.StadiumIDX,'StadiumIDX') AS StadiumNM,"
				LSQL = LSQL & " 	C.GameDay,"
				LSQL = LSQL & " 	C.StadiumIDX"
				'LSQL = LSQL & " 	COUNT(*) AS GameCnt"
				LSQL = LSQL & " 	FROM tblGameLevel A"
				LSQL = LSQL & " 	INNER JOIN tblGameLeveldtl B ON B.GameLevelIDX = A.GameLevelIDX"
				LSQL = LSQL & " 	INNER JOIN tblTourneyTeam C ON C.GameLeveldtlIDX = B.GameLeveldtlIDX"
				LSQL = LSQL & " 	INNER JOIN tblTourneyTeam D ON D.GameLevelDtlidx = C.GameLevelDtlidx AND D.TeamGameNum = C.TeamGameNum "
				LSQL = LSQL & " 	WHERE A.DelYN = 'N'"
				LSQL = LSQL & " 	AND B.DelYN = 'N'"
				LSQL = LSQL & " 	AND C.DelYN = 'N'"
				LSQL = LSQL & " 	AND D.DelYN = 'N'"
				LSQL = LSQL & " 	AND C.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
				'LSQL = LSQL & " 	AND C.GameDay = '" & DEC_GameDay & "'"
				LSQL = LSQL & " 	AND C.ORDERBY < D.ORDERBY "
				LSQL = LSQL & " 	AND C.ByeYN = 'N' AND D.ByeYN = 'N'"
				LSQL = LSQL & " ) AS AA"
				LSQL = LSQL & " GROUP BY AA.GameDay, AA.StadiumIDX, AA.StadiumNM"
				LSQL = LSQL & " ORDER BY AA.GameDay, AA.StadiumNM"
				        

				Set LRs = DBCon.Execute(LSQL)
				IF NOT (LRs.Eof Or LRs.Bof) Then
					arryGameGubun = LRs.getrows()
				End If
				LRs.close	

				LSQL = "	SELECT *"
				LSQL = LSQL & "	FROM"
				LSQL = LSQL & "		("
				LSQL = LSQL & " 	SELECT "
				LSQL = LSQL & " 	C.GameLevelIDX,"
				LSQL = LSQL & " 	dbo.FN_NameSch(A.PlayType,'Pubcode') AS GameTypeNM,"
				LSQL = LSQL & " 	dbo.FN_NameSch(A.Sex,'PubCode') AS SexNM,"
				LSQL = LSQL & " 	dbo.FN_NameSch(A.TeamGb,'TeamGb') AS TeamGbNM,"
				LSQL = LSQL & " 	dbo.FN_NameSch(A.Level,'Level') AS LevelNM,"
				LSQL = LSQL & " 	dbo.FN_NameSch(A.LevelJooName,'Pubcode') AS LevelJooNameNM,"
				LSQL = LSQL & " 	A.LevelJooNum,"
				LSQL = LSQL & " 	dbo.FN_NameSch(A.GroupGameGb,'Pubcode') AS GroupGameGbNM,"
				LSQL = LSQL & " 	dbo.FN_NameSch(C.StadiumIDX,'StadiumIDX') AS StadiumNM, "
				LSQL = LSQL & " 	C.GameDay,"
				LSQL = LSQL & " 	COUNT(*) AS GameCnt,"
				LSQL = LSQL & " 	C.StadiumIDX"
				LSQL = LSQL & " 	FROM tblGameLevel A"
				LSQL = LSQL & " 	INNER JOIN tblGameLeveldtl B ON B.GameLevelIDX = A.GameLevelIDX"
				LSQL = LSQL & " 	INNER JOIN tblTourney C ON C.GameLeveldtlIDX = B.GameLeveldtlIDX"
				LSQL = LSQL & " 	INNER JOIN tblTourney D ON D.GameLevelDtlidx = C.GameLevelDtlidx AND D.TeamGameNum = C.TeamGameNum AND D.GameNum = C.GameNum  "
				LSQL = LSQL & " 	WHERE A.DelYN = 'N'"
				LSQL = LSQL & " 	AND B.DelYN = 'N'"
				LSQL = LSQL & " 	AND C.DelYN = 'N'"
				LSQL = LSQL & " 	AND D.DelYN = 'N'"
				LSQL = LSQL & " 	AND C.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
				'LSQL = LSQL & " 	AND C.GameDay = '" & DEC_GameDay & "'"
				LSQL = LSQL & " 	AND C.ORDERBY < D.ORDERBY "
				LSQL = LSQL & " 	AND C.ByeYN = 'N' AND D.ByeYN = 'N'"
				LSQL = LSQL & " 	GROUP BY C.GameLevelIDX, A.PlayType, A.Sex, A.TeamGb, A.Level, A.LevelJooName, A.LevelJooNum, A.GroupGameGb, C.GameDay, C.StadiumIDX"
				LSQL = LSQL & " 	"
				LSQL = LSQL & " 	UNION ALL"
				LSQL = LSQL & " 	"
				LSQL = LSQL & " 	SELECT "
				LSQL = LSQL & " 	C.GameLevelIDX,"
				LSQL = LSQL & " 	dbo.FN_NameSch(A.PlayType,'Pubcode') AS GameTypeNM,"
				LSQL = LSQL & " 	dbo.FN_NameSch(A.Sex,'PubCode') AS SexNM,"
				LSQL = LSQL & " 	dbo.FN_NameSch(A.TeamGb,'TeamGb') AS TeamGbNM,"
				LSQL = LSQL & " 	dbo.FN_NameSch(A.Level,'Level') AS LevelNM,"
				LSQL = LSQL & " 	dbo.FN_NameSch(A.LevelJooName,'Pubcode') AS LevelJooNameNM,"
				LSQL = LSQL & " 	A.LevelJooNum,"
				LSQL = LSQL & " 	dbo.FN_NameSch(A.GroupGameGb,'Pubcode') AS GroupGameGbNM,"
				LSQL = LSQL & " 	dbo.FN_NameSch(C.StadiumIDX,'StadiumIDX') AS StadiumNM,"
				LSQL = LSQL & " 	C.GameDay,"
				LSQL = LSQL & " 	COUNT(*) AS GameCnt,"
				LSQL = LSQL & " 	C.StadiumIDX"
				LSQL = LSQL & " 	FROM tblGameLevel A"
				LSQL = LSQL & " 	INNER JOIN tblGameLeveldtl B ON B.GameLevelIDX = A.GameLevelIDX"
				LSQL = LSQL & " 	INNER JOIN tblTourneyTeam C ON C.GameLeveldtlIDX = B.GameLeveldtlIDX"
				LSQL = LSQL & " 	INNER JOIN tblTourneyTeam D ON D.GameLevelDtlidx = C.GameLevelDtlidx AND D.TeamGameNum = C.TeamGameNum "
				LSQL = LSQL & " 	WHERE A.DelYN = 'N'"
				LSQL = LSQL & " 	AND B.DelYN = 'N'"
				LSQL = LSQL & " 	AND C.DelYN = 'N'"
				LSQL = LSQL & " 	AND D.DelYN = 'N'"
				LSQL = LSQL & " 	AND C.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
				'LSQL = LSQL & " 	AND C.GameDay = '" & DEC_GameDay & "'"
				LSQL = LSQL & " 	AND C.ORDERBY < D.ORDERBY "
				LSQL = LSQL & " 	AND C.ByeYN = 'N' AND D.ByeYN = 'N'"
				LSQL = LSQL & " 	GROUP BY C.GameLevelIDX, A.PlayType, A.Sex, A.TeamGb, A.Level, A.LevelJooName, A.LevelJooNum, A.GroupGameGb, C.GameDay, C.StadiumIDX	"
				LSQL = LSQL & " ) AS AA"
				LSQL = LSQL & " ORDER BY AA.StadiumNM, AA.SexNM, AA.GameTypeNM, AA.LevelNM, AA.LevelJooNameNM, AA.LevelJooNum"
				        

				Set LRs = DBCon.Execute(LSQL)
				IF NOT (LRs.Eof Or LRs.Bof) Then
					arryGameSchedule = LRs.getrows()
				End If
				LRs.close
%>

<html lang="ko">
 <head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  <title>경기장별 진행종목</title>
 </head>
 <body>

	<%
		For j = 0 To UBound(arryGameGubun,2)
	%>
				<table cellspacing="0" cellpadding="0" border="1" style="width:800px;">

					<tr>
						<td colspan="2" style="text-align:center;border:1px solid #ccc;background:#D5D5D5;" width="800px">
							<%=arryGameGubun(0,j)%>
						</td>
					</tr>	
					<tr>
						<td colspan="2" style="text-align:right;" width="800px">
							경기일자 : <%=arryGameGubun(1,j)%>
						</td>
					</tr>			
					<tr>
						<!--
						<th class="border-left">경기장명</th>
						<th class="border-left">경기일자</th>
						-->
						<th width="400px">종목</th>
						<th width="400px">경기수</th>
					</tr>										
	<%
			For i = 0 To UBound(arryGameSchedule,2)
				If arryGameGubun(1,j) = arryGameSchedule(9,i) AND arryGameGubun(2,j) = arryGameSchedule(11,i)  Then
	%>


					<%
						
							GameTypeNM = arryGameSchedule(1,i)
							SexNM = arryGameSchedule(2,i)
							TeamGbNM = arryGameSchedule(3,i)
							LevelNM = arryGameSchedule(4,i)
							LevelJooNameNM = arryGameSchedule(5,i)
							LevelJooNum = arryGameSchedule(6,i)
							GroupGameGbNM = arryGameSchedule(7,i)
							StadiumNM = arryGameSchedule(8,i)
							GameDay = arryGameSchedule(9,i)
							GameCnt = arryGameSchedule(10,i)

							If GameTypeNM = "" OR ISNULL(GameTypeNM) Then
								LevelTitle = SexNM & " " & TeamGbNM & " " & LevelNM & " " & LevelJooNameNM & " " & LevelJooNum & " " & GroupGameGbNM
							Else
								LevelTitle = Left(SexNM,1) & "" & Left(GameTypeNM,1) & " " & TeamGbNM & " " & LevelNM & " " & LevelJooNameNM & " " & LevelJooNum & " " & GroupGameGbNM
							End If
					%>
						<tr>
							<td style="text-align:left;"><%=LevelTitle%></td>
							<td style="text-align:right;"><%=GameCnt%></td>
						</tr>

				
	<%
				End If
			Next
	%>
		</table>
		<br/>
		<br/>
		<br/>
	<%
		Next
	%>


 </body>
</html>

<%

 Response.Buffer = True
 Response.ContentType = "application/vnd.ms-excel"
 Response.CacheControl = "public"
 Response.AddHeader "Content-disposition","attachment;filename=stadium.xls"
%>


