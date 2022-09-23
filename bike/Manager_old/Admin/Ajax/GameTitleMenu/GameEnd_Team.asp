<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->
<script language="Javascript" runat="server">
function hasown(obj,  prop){
	if (obj.hasOwnProperty(prop) == true){
		return "ok";
	}
	else{
		return "notok";
	}
}
</script>
<%
'단체전 경기결과 입력

REQ = Request("Req")
'REQ = "{""CMD"":6,""GameLevelDtlIDX"":""5DA8B97309D51CE41772A3CCBF968D9B"",""GameRound"":""D3510D3EEF159089CEE3710534553C12"",""TeamGameNum"":""4F0C40AE3DFDC66664FB7AC6C660689A""}"

'REQ = "{""CMD"":15,""GameLevelDtlIDX"":""666A8713D43C6EF5BCB3D19DE7D38F1E"",""TeamGameNum"":""775A4EB13A5B7CE6E0E1AAB80606E49A"",""GameNum"":""D3510D3EEF159089CEE3710534553C12"",""GameRound"":""D3510D3EEF159089CEE3710534553C12""}"

Set oJSONoutput = JSON.Parse(REQ)

If hasown(oJSONoutput, "GameLevelDtlIDX") = "ok" then
    If ISNull(oJSONoutput.GameLevelDtlIDX) Or oJSONoutput.GameLevelDtlIDX = "" Then
      GameLevelDtlIDX = ""
      DEC_GameLevelDtlIDX = ""
    Else
      GameLevelDtlIDX = fInject(oJSONoutput.GameLevelDtlIDX)
      DEC_GameLevelDtlIDX = fInject(crypt.DecryptStringENC(oJSONoutput.GameLevelDtlIDX))
    End If
  Else  
    GameLevelDtlIDX = ""
    DEC_GameLevelDtlIDX = ""
End if	

If hasown(oJSONoutput, "TeamGameNum") = "ok" then
    If ISNull(oJSONoutput.TeamGameNum) Or oJSONoutput.TeamGameNum = "" Then
      TeamGameNum = ""
      DEC_TeamGameNum = ""
    Else
      TeamGameNum = fInject(oJSONoutput.TeamGameNum)
      DEC_TeamGameNum = fInject(crypt.DecryptStringENC(oJSONoutput.TeamGameNum))    
    End If
  Else  
    TeamGameNum = ""
    DEC_TeamGameNum = ""
End if	

If hasown(oJSONoutput, "GameNum") = "ok" then
    If ISNull(oJSONoutput.GameNum) Or oJSONoutput.GameNum = "" Then
      GameNum = ""
      DEC_GameNum = ""
    Else
      GameNum = fInject(oJSONoutput.GameNum)
      DEC_GameNum = fInject(crypt.DecryptStringENC(oJSONoutput.GameNum))    
    End If
  Else  
    GameNum = ""
    DEC_GameNum = ""
End if	

If hasown(oJSONoutput, "GameRound") = "ok" then
    If ISNull(oJSONoutput.GameRound) Or oJSONoutput.GameRound = "" Then
      GameRound = ""
      DEC_GameRound = ""
    Else
      GameRound = fInject(oJSONoutput.GameRound)
      DEC_GameRound = fInject(crypt.DecryptStringENC(oJSONoutput.GameRound))    
    End If
  Else  
    GameRound = ""
    DEC_GameRound = ""
End if	




'INSERT 시, 이용 할 대회 정보 SELECT

LSQL = " SELECT A.Team AS LTeam, A.TeamDtl AS LTeamDtl, B.Team AS RTeam, B.TeamDtl AS RTeamDtl,"
LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(A.Team,'Team') AS LTeamNM, "
LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(B.Team,'Team') AS RTeamNM,"
LSQL = LSQL & " D.GameTitleIDX, D.TeamGb, D.Sex, C.Level, C.LevelDtlName, D.GroupGameGb, D.GameLevelIDX,"
LSQL = LSQL & " C.PlayLevelType, ISNULL(D.JooRank,0) AS JooRank, ISNULL(C.LevelJooNum,0) AS LevelJooNum,"
LSQL = LSQL & " A.TourneyTeamNum AS LTourneyTeamNum, B.TourneyTeamNum AS RTourneyTeamNum"
LSQL = LSQL & " FROM tblTourneyTeam A"
LSQL = LSQL & " INNER JOIN tblTourneyTeam B ON B.GameLevelDtlidx = A.GameLevelDtlidx AND B.TeamGameNum = A.TeamGameNum"
LSQL = LSQL & " INNER JOIN tblGameLevelDtl C ON C.GameLevelDtlidx = A.GameLevelDtlidx"
LSQL = LSQL & " INNER JOIN tblGameLevel D ON D.GameLevelidx = C.GameLevelidx"
LSQL = LSQL & " LEFT JOIN ("
LSQL = LSQL & "   SELECT GameLevelDtlidx, TeamGameNum, GameNum, Team, TeamDtl, Result, Jumsu"
LSQL = LSQL & "   FROM KoreaBadminton.dbo.tblGroupGameResult"
LSQL = LSQL & "   WHERE DelYN = 'N'"
LSQL = LSQL & "   ) AS E ON E.GameLevelDtlidx = A.GameLevelDtlidx AND E.TeamGameNum = A.TeamGameNum AND E.Team + E.TeamDtl = A.Team + A.TeamDtl"
LSQL = LSQL & " WHERE A.DelYN = 'N'"
LSQL = LSQL & " AND B.DelYN = 'N'"
LSQL = LSQL & " AND A.ORDERBY < B.ORDERBY"
LSQL = LSQL & " AND A.GameLevelDtlIDX  = '" & DEC_GameLevelDtlIDX & "'"
LSQL = LSQL & " AND A.TeamGameNum = '" & DEC_TeamGameNum & "'"


Set LRs = Dbcon.Execute(LSQL)

If Not (LRs.Eof Or LRs.Bof) Then

    Do Until LRs.Eof

      LTeam = LRs("LTeam")
      LTeamDtl = LRs("LTeamDtl")
      LTeamNM = LRs("LTeamNM")
      RTeam = LRs("RTeam")
      RTeamDtl = LRs("RTeamDtl")
      RTeamNM = LRs("RTeamNM")    

			LTourneyTeamNum = LRs("LTourneyTeamNum")    
			RTourneyTeamNum = LRs("RTourneyTeamNum")    

	    GameTitleIDX = LRs("GameTitleIDX")
      TeamGb = LRs("TeamGb")
      Sex = LRs("Sex")
      Level = LRs("Level")
      LevelDtlName = LRs("LevelDtlName")
      GroupGameGb = LRs("GroupGameGb")
      GameLevelIDX = LRs("GameLevelIDX")
      PlayLevelType = LRs("PlayLevelType")
      JooRank = LRs("JooRank")
      LevelJooNum = LRs("LevelJooNum")

      LRs.MoveNext
    Loop

End If

LRs.Close


Function TotalPoint(fGameLevelDtlIDX, fTeamGameNum, fTeam, fTeamDtl)

	'TeamGameNum의 포인트합산
	LSQL = "SELECT ISNULL(SUM(CONVERT(INT,D.Jumsu)),0) AS Total_Jumsu"
	LSQL = LSQL & " FROM tblTourneyTeam A"
	LSQL = LSQL & " INNER JOIN tblTourney B ON B.GameLevelDtlidx = A.GameLevelDtlidx AND B.TeamGameNum = A.TeamGameNum"
	LSQL = LSQL & " INNER JOIN tblTourneyGroup C ON C.GameLevelDtlidx = A.GameLevelDtlidx AND C.TourneyGroupIDX = B.TourneyGroupIDX "
	LSQL = LSQL & " 	AND C.Team + C.TeamDtl = A.Team + A.TeamDtl"
	LSQL = LSQL & " INNER JOIN tblGameResultdtl D ON D.GameLevelDtlidx = A.GameLevelDtlidx AND D.TeamGameNum = B.TeamGameNum AND D.GameNum = B.GameNum  "
	LSQL = LSQL & " 	AND D.TourneyGroupIDX = C.TourneyGroupIDX"
	LSQL = LSQL & " WHERE A.DelYN = 'N'"
	LSQL = LSQL & " AND B.DelYN = 'N'"
	LSQL = LSQL & " AND C.DelYN = 'N'"
	LSQL = LSQL & " AND D.DelYN = 'N'"
	LSQL = LSQL & " AND A.GameLevelDtlidx = '" & fGameLevelDtlIDX & "' "
	LSQL = LSQL & " AND A.TeamGameNum = '" & fTeamGameNum & "'"
	LSQL = LSQL & " AND C.Team + C.TeamDtl = '" & fTeam & fTeamDtl & "'"

  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
		TotalPoint = LRs("Total_Jumsu")
	Else
		TotalPoint = "0"
  End If

End Function 

Function TotalWinCnt(fGameLevelDtlIDX, fTeamGameNum, fTeam, fTeamDtl)

	'TeamGameNum의 승점합산
	LSQL = "SELECT COUNT(*) AS WinCnt"
	LSQL = LSQL & " FROM tblTourneyTeam A"
	LSQL = LSQL & " INNER JOIN tblTourney B ON B.GameLevelDtlidx = A.GameLevelDtlidx AND B.TeamGameNum = A.TeamGameNum"
	LSQL = LSQL & " INNER JOIN tblTourneyGroup C ON C.GameLevelDtlidx = A.GameLevelDtlidx AND C.TourneyGroupIDX = B.TourneyGroupIDX "
	LSQL = LSQL & " 	AND C.Team + C.TeamDtl = A.Team + A.TeamDtl"
	LSQL = LSQL & " INNER JOIN tblGameResult D ON D.GameLevelDtlidx = A.GameLevelDtlidx AND D.TeamGameNum = B.TeamGameNum AND D.GameNum = B.GameNum  "
	LSQL = LSQL & " 	AND D.TourneyGroupIDX = C.TourneyGroupIDX"
	LSQL = LSQL & " WHERE A.DelYN = 'N'"
	LSQL = LSQL & " AND B.DelYN = 'N'"
	LSQL = LSQL & " AND C.DelYN = 'N'"
	LSQL = LSQL & " AND D.DelYN = 'N'"
	LSQL = LSQL & " AND A.GameLevelDtlidx = '" & fGameLevelDtlIDX & "' "
	LSQL = LSQL & " AND A.TeamGameNum = '" & fTeamGameNum & "'"
	LSQL = LSQL & " AND C.Team + C.TeamDtl = '" & fTeam & fTeamDtl & "'"
	LSQL = LSQL & " AND dbo.FN_NameSch(D.Result, 'PubType') = 'WIN'"

  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
		TotalWinCnt = LRs("WinCnt")
	Else
		TotalWinCnt = "0"
  End If

End Function 

'좌우팀 포인트합산
TotalPoint_L = TotalPoint(DEC_GameLevelDtlIDX, DEC_TeamGameNum, LTeam, LTeamDtl)
TotalPoint_R = TotalPoint(DEC_GameLevelDtlIDX, DEC_TeamGameNum, RTeam, RTeamDtl)

'좌우팀 승점합산
TotalWin_L = TotalWinCnt(DEC_GameLevelDtlIDX, DEC_TeamGameNum, LTeam, LTeamDtl)
TotalWin_R = TotalWinCnt(DEC_GameLevelDtlIDX, DEC_TeamGameNum, RTeam, RTeamDtl)

DiffPoint_L = TotalPoint_L - TotalPoint_R
DiffPoint_R = TotalPoint_R - TotalPoint_L


'좌팀 승점이많으면 좌팀승
If TotalWin_L > TotalWin_R Then
	WIN_Team = LTeam
	WIN_TeamDtl = LTeamDtl
	WIN_TeamNM = LTeamNM
	WIN_TourneyTeamNum = LTourneyTeamNum
	Result_LTeam = "B5010001"
	Result_RTeam = "B6010001"
'우팀 승점이많으면 우팀승
ElseIf TotalWin_R > TotalWin_L Then
	WIN_Team = RTeam
	WIN_TeamDtl = RTeamDtl
	WIN_TeamNM = RTeamNM
	WIN_TourneyTeamNum = RTourneyTeamNum
	Result_LTeam = "B6010001"
	Result_RTeam = "B5010001"	
'비겼을때는 총포인트 득실차
Else
    If DiffPoint_L > DiffPoint_R THen
      WIN_Team = LTeam
	    WIN_TeamDtl = LTeamDtl     
			WIN_TeamNM = LTeamNM
			WIN_TourneyTeamNum = LTourneyTeamNum
			Result_LTeam = "B5010001"
			Result_RTeam = "B6010001"			
		ElseIf DiffPoint_L < DiffPoint_R THen
			WIN_Team = RTeam
			WIN_TeamDtl = RTeamDtl
			WIN_TeamNM = RTeamNM
			WIN_TourneyTeamNum = RTourneyTeamNum
			Result_LTeam = "B6010001"
			Result_RTeam = "B5010001"					
		'승점도 똑같고 포인트도 똑같으면 일단 왼쪽팀 이기게 처리
		Else
      WIN_Team = LTeam
	    WIN_TeamDtl = LTeamDtl     
			WIN_TeamNM = LTeamNM
			WIN_TourneyTeamNum = LTourneyTeamNum
			Result_LTeam = "B5010001"
			Result_RTeam = "B6010001"					
		End If
End If


'단체전 경기결과가 있으면 초기화
CSQL = " UPDATE KoreaBadminton.dbo.tblGroupGameResult SET"
CSQL = CSQL & " DelYN = 'Y'"
CSQL = CSQL & " WHERE DelYN = 'N'"
CSQL = CSQL & " AND GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "'"
CSQL = CSQL & " AND TeamGameNum = '" & DEC_TeamGameNum & "'"


Dbcon.Execute(CSQL)

'경기 종료시간 UPDATE
CSQL = "UPDATE KoreaBadminton.dbo.tblTourneyTeam SET"
CSQL = CSQL & " EndHour = '" & AddZero(Hour(Now)) & "',"
CSQL = CSQL & " EndMinute = '" & AddZero(Minute(Now)) & "'"
CSQL = CSQL & " WHERE GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
CSQL = CSQL & " AND TeamGameNum = '" & DEC_TeamGameNum & "'"
CSQL = CSQL & " AND ISNULL(EndHour,'') = ''"

Dbcon.Execute(CSQL)


'좌측 팀 경기결과 INSERT
CSQL = "INSERT KoreaBadminton.dbo.tblGroupGameResult"
CSQL = CSQL & " ("
CSQL = CSQL & " GameLevelDtlidx, GameTitleIDX, TeamGb, Sex, GroupGameGb,"
CSQL = CSQL & " TeamGameNum, GameNum, Team, TeamDtl,"
CSQL = CSQL & " Round, Result, Jumsu, TotalPoint"
CSQL = CSQL & " )"
CSQL = CSQL & " VALUES"
CSQL = CSQL & " ("
CSQL = CSQL & " '" & DEC_GameLevelDtlIDX & "', '" & GameTitleIDX & "', '" & TeamGb & "', '" & Sex & "', '" & GroupGameGb & "',"
CSQL = CSQL & " '" & DEC_TeamGameNum & "', '" & DEC_GameNum & "','" & LTeam & "','" & LTeamDtl & "',"
CSQL = CSQL & " '" & DEC_GameRound & "', '" & Result_LTeam & "', '" & TotalWin_L & "','" & TotalPoint_L & "'"
CSQL = CSQL & " )"

Dbcon.Execute(CSQL)

'우측 팀 경기결과 INSERT
CSQL = "INSERT KoreaBadminton.dbo.tblGroupGameResult"
CSQL = CSQL & " ("
CSQL = CSQL & " GameLevelDtlidx, GameTitleIDX, TeamGb, Sex, GroupGameGb,"
CSQL = CSQL & " TeamGameNum, GameNum, Team, TeamDtl,"
CSQL = CSQL & " Round, Result, Jumsu, TotalPoint"
CSQL = CSQL & " )"
CSQL = CSQL & " VALUES"
CSQL = CSQL & " ("
CSQL = CSQL & " '" & DEC_GameLevelDtlIDX & "', '" & GameTitleIDX & "', '" & TeamGb & "', '" & Sex & "', '" & GroupGameGb & "',"
CSQL = CSQL & " '" & DEC_TeamGameNum & "', '" & DEC_GameNum & "','" & RTeam & "','" & RTeamDtl & "',"
CSQL = CSQL & " '" & DEC_GameRound & "', '" & Result_RTeam & "', '" & TotalWin_R & "','" & TotalPoint_R & "'"
CSQL = CSQL & " )"
Dbcon.Execute(CSQL)
            

'현재경기의 대진표 위치값 구하기 GrNum : 현재대진표 위치값
'4의배수숫자마다 1씩 증가하여 그룹화
'이긴팀 자리 구함

LSQL = "SELECT ASCNum"
LSQL = LSQL & " FROM"
LSQL = LSQL & " 	 ("
LSQL = LSQL & " 	 SELECT ROW_NUMBER() OVER ( ORDER BY ORDERBY ASC) ASCNum, TourneyTeamNum, TeamGameNum, Team, TeamDtl"
LSQL = LSQL & " 	 FROM KoreaBadminton.dbo.tblTourneyTeam"
LSQL = LSQL & " 	 WHERE DelYN = 'N'"
LSQL = LSQL & " 	 AND GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "'"
LSQL = LSQL & " 	 AND [ROUND] = '" & DEC_GameRound & "'"
LSQL = LSQL & " 	 ) AS A"
LSQL = LSQL & " WHERE Team + TeamDtl = '" & WIN_Team & WIN_TeamDtl & "'"
LSQL = LSQL & " AND TeamGameNum = '" & DEC_TeamGameNum & "'"


Set LRs = Dbcon.Execute(LSQL)

i = 0

If Not (LRs.Eof Or LRs.Bof) Then

    GrNum = LRs("ASCNum")

End If

LRs.Close


If CDbl(GrNum) Mod 2 = 1 Then
	GrNum = CDbl(GrNum) +1
End If

NextGrNum = Fix(CDbl(GrNum) /2) 

LSQL = "SELECT TourneyTeamIDX"
LSQL = LSQL & " FROM"
LSQL = LSQL & " 	 ("
LSQL = LSQL & " 	 SELECT ROW_NUMBER() OVER ( ORDER BY ORDERBY ASC) ASCNum, TourneyTeamIDX"
LSQL = LSQL & " 	 FROM KoreaBadminton.dbo.tblTourneyTeam"
LSQL = LSQL & " 	 WHERE DelYN = 'N'"
LSQL = LSQL & " 	 AND GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "'"
LSQL = LSQL & " 	 AND [ROUND] = '" & Cint(DEC_GameRound + 1)  & "'"
LSQL = LSQL & " 	 ) AS A"
LSQL = LSQL & " WHERE ASCNum = '" & NextGrNum & "'"



Set LRs = Dbcon.Execute(LSQL)

i = 0

If Not (LRs.Eof Or LRs.Bof) Then

    TourneyTeamIDX = LRs("TourneyTeamIDX")

End If

LRs.Close



CSQL = "UPDATE tblTourneyTeam SET "
CSQL = CSQL & " Team = '" & WIN_Team & "', "
CSQL = CSQL & " TeamDtl = '" & WIN_TeamDtl & "', "
CSQL = CSQL & " TeamName = '" & WIN_TeamNM & "', "
CSQL = CSQL & " TourneyTEamNum = '" & WIN_TourneyTeamNum & "'"
CSQL = CSQL & " WHERE TourneyTeamIDX = '" & TourneyTeamIDX & "'"
Dbcon.Execute(CSQL)



'call oJSONoutput.Set("result", 0 )
'strjson = JSON.stringify(oJSONoutput)
'Response.Write strjson
'Response.Write PlayLevelType
'Response.END

    '경기 수 구하기
    LSQL = "SELECT MAX(CONVERT(BIGINT,TeamGameNum)) AS MaxTeamGameNum"
    LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourneyTeam"
    LSQL = LSQL & " WHERE DelYN = 'N'"
    LSQL = LSQL & " AND GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"

    Set LRs = Dbcon.Execute(LSQL)

    If Not (LRs.Eof Or LRs.Bof) Then
        MaxTeamGameNum = LRs("MaxTeamGameNum")
    End If

    LRs.Close


    '끝난경기수 구하기
    LSQL = "SELECT COUNT(*) AS EndGameCnt"
    LSQL = LSQL & " FROM " 
    LSQL = LSQL & " ("
    LSQL = LSQL & " SELECT GameLevelDtlidx, TeamGameNum"
    LSQL = LSQL & " FROM KoreaBadminton.dbo.tblGroupGameResult "
    LSQL = LSQL & " WHERE DelYN = 'N'"
    LSQL = LSQL & " AND GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
    LSQL = LSQL & " GROUP BY GameLevelDtlidx, TeamGameNum"
    LSQL = LSQL & " ) AS A"		

    Set LRs = Dbcon.Execute(LSQL)

    If Not (LRs.Eof Or LRs.Bof) Then
        EndGameCnt = LRs("EndGameCnt")
    End If

    LRs.Close

    If Cint(EndGameCnt) => Cint(MaxTeamGameNum) Then
        '실적넣기
        LSQL = "dbo.Insert_tblMedal '" & DEC_GameLevelDtlIDX & "'"
        Dbcon.Execute(LSQL)
    End If    

'예선이라면 마지막경기때 설정된 본선순위만큼 본선 진출
If PlayLevelType = "B0100001" Then

    '경기 수 구하기
    LSQL = "SELECT MAX(CONVERT(BIGINT,TeamGameNum)) AS MaxTeamGameNum"
    LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourneyTeam"
    LSQL = LSQL & " WHERE DelYN = 'N'"
    LSQL = LSQL & " AND GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"

    Set LRs = Dbcon.Execute(LSQL)

    If Not (LRs.Eof Or LRs.Bof) Then
        MaxTeamGameNum = LRs("MaxTeamGameNum")
    End If

    LRs.Close


    '끝난경기수 구하기
    LSQL = "SELECT COUNT(*) AS EndGameCnt"
    LSQL = LSQL & " FROM " 
    LSQL = LSQL & " ("
    LSQL = LSQL & " SELECT GameLevelDtlidx, TeamGameNum"
    LSQL = LSQL & " FROM KoreaBadminton.dbo.tblGroupGameResult "
    LSQL = LSQL & " WHERE DelYN = 'N'"
    LSQL = LSQL & " AND GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
    LSQL = LSQL & " GROUP BY GameLevelDtlidx, TeamGameNum"
    LSQL = LSQL & " ) AS A"		

    Set LRs = Dbcon.Execute(LSQL)

    If Not (LRs.Eof Or LRs.Bof) Then
        EndGameCnt = LRs("EndGameCnt")
    End If

    LRs.Close

    LSQL = "SELECT A.GameTitleIDX, A.GameLevelDtlIDX, B.TeamGb, B.Level, A.LevelDtlName, A.TotRound "
    LSQL = LSQL & " FROM tblGameLevelDtl A"
    LSQL = LSQL & " INNER JOIN tblGameLevel B ON B.GameLevelIDX = A.GameLevelIDX"
    LSQL = LSQL & " WHERE A.DelYN = 'N'"
    LSQL = LSQL & " AND B.DelYN = 'N'"
    LSQL = LSQL & " AND A.GameLevelidx = '" & GameLevelIDX & "'"
    LSQL = LSQL & " AND A.PlayLevelType = 'B0100002'"

    Set LRs = Dbcon.Execute(LSQL)

    If Not (LRs.Eof Or LRs.Bof) Then
        bon_GameTitleIDX = LRs("GameTitleIDX")
        bon_GameLevelDtlIDX = LRs("GameLevelDtlIDX")
        bon_TeamGb = LRs("TeamGb")
        bon_Level = LRs("Level")
        bon_LevelDtlName = LRs("LevelDtlName")
        bon_TotRound = LRs("TotRound")
    End If

    LRs.Close

    If bon_GameLevelDtlIDX <> "" Then

        '단체전 본선 대진표 INSERT 프로시저
        LSQL = "Insert_tblTourneyTeam_Bon '" & bon_GameLevelDtlIDX & "'"

        Dbcon.Execute(LSQL)

    End If

  
    If Cint(EndGameCnt) => Cint(MaxTeamGameNum) Then

			'해당 대진표 랭킹구하기
      LSQL = "SELECT Team, TeamDtl, WinCnt, GameCnt, WinPerc, LoseCnt, WinPoint, LosePoint, PointDiff, TRanking"
      LSQL = LSQL & " FROM"
      LSQL = LSQL & " 	("
      LSQL = LSQL & " 	SELECT Team, TeamDtl, WinCnt, GameCnt, WinPerc, LoseCnt, WinPoint, LosePoint, PointDiff,"
      LSQL = LSQL & " 	ROW_NUMBER() OVER ( ORDER BY WinCnt DESC, WinPerc DESC, PointDiff DESC, WinPoint DESC) AS TRanking"
      LSQL = LSQL & " 	FROM"
      LSQL = LSQL & " 		("
      LSQL = LSQL & " 		SELECT Team, TeamDtl , CONVERT(FLOAT,WinCnt) AS WinCnt, CONVERT(FLOAT,GameCnt) AS GameCnt, "
      LSQL = LSQL & " 		CONVERT(FLOAT,(CONVERT(FLOAT,WinCnt) / CONVERT(FLOAT,GameCnt)) * 100) AS WinPerc,"
      LSQL = LSQL & " 		LoseCnt, WinPoint, LosePoint, CONVERT(FLOAT,WinPoint) - CONVERT(FLOAT,LosePoint) AS PointDiff"
      LSQL = LSQL & " 		FROM"
      LSQL = LSQL & " 			("
      LSQL = LSQL & " 			SELECT AA.GamelevelDtlIDX, AA.Team, AA.TeamDtl, SUM(AA.WinCnt) AS WinCnt, SUM(AA.LoseCnt) AS LoseCnt, SUM(AA.GameCnt) AS GameCnt,"
      LSQL = LSQL & " 			dbo.FN_WinGroupPoint(AA.GameLevelDtlidx, AA.Team, AA.TeamDtl) AS WinPoint,"
      LSQL = LSQL & " 			dbo.FN_LoseGroupPoint(AA.GameLevelDtlidx, AA.Team, AA.TeamDtl) AS LosePoint"
      LSQL = LSQL & " 			FROM"
      LSQL = LSQL & " 				("
      LSQL = LSQL & " 				SELECT A.GamelevelDtlIDX, A.Team, A.TeamDtl, "
      LSQL = LSQL & " 				CASE WHEN dbo.FN_NameSch(B.Result,'PubType') = 'WIN' THEN 1 ELSE 0 END AS WinCnt,"
      LSQL = LSQL & " 				CASE WHEN dbo.FN_NameSch(B.Result,'PubType') = 'LOSE' THEN 1 ELSE 0 END AS LoseCnt,"
      LSQL = LSQL & " 				1 AS GameCnt"
      LSQL = LSQL & " 				FROM"
      LSQL = LSQL & " 				("
      LSQL = LSQL & " 				SELECT GamelevelDtlIDX, Team, TeamDtl"
      LSQL = LSQL & " 				FROM tblTourneyTeam"
      LSQL = LSQL & " 				WHERE DelYN = 'N'"
      LSQL = LSQL & " 				AND GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
      LSQL = LSQL & " 				GROUP BY GamelevelDtlIDX, Team, TeamDtl"
      LSQL = LSQL & " 				) AS A"
      LSQL = LSQL & " 			LEFT JOIN tblGroupGameResult B ON A.GameLevelDtlidx = B.GameLevelDtlidx AND A.Team + A.TeamDtl = B.Team + B.TeamDtl "
      LSQL = LSQL & " 			AND B.DelYN = 'N'"
      LSQL = LSQL & " 			WHERE ISNULL(A.Team,'') <> ''"
      LSQL = LSQL & " 			) AS AA"
      LSQL = LSQL & " 		GROUP BY GamelevelDtlIDX, Team, TeamDtl"
      LSQL = LSQL & " 		) AS AAA"
      LSQL = LSQL & " 	) AS AAAA"
      LSQL = LSQL & " ) AS AAAAA"
      LSQL = LSQL & " WHERE TRanking <=" & JooRank 
      LSQL = LSQL & " ORDER BY TRanking"       

      Set LRs = Dbcon.Execute(LSQL)

      If Not (LRs.Eof Or LRs.Bof) Then

	      Do Until LRs.Eof

					'없어도됨
          'MSQL = "SELECT CASE WHEN MAX(TourneyGroupNum) IS NULL THEN '101' ELSE MAX(TourneyGroupNum) + 1 END AS TourneyGroupNum"
          'MSQL = MSQL & " FROM KoreaBadminton.dbo.tblTourneyGroup"
          'MSQL = MSQL & " WHERE DelYN = 'N'"
          'MSQL = MSQL & " AND GameLevelDtlidx = '" & bon_GameLevelDtlIDX & "'"

	         'Set MRs = Dbcon.Execute(MSQL)

	         'If Not (MRs.Eof Or MRs.Bof) Then
	         '    bon_TourneyGroupNum = MRs("TourneyGroupNum")
	         'End If

          'MRs.Close

					MSQL = "SELECT CASE WHEN MAX(TourneyTeamNum) IS NULL THEN '101' ELSE MAX(TourneyTeamNum) + 1 END AS TourneyTeamNum"
					MSQL = MSQL & " FROM KoreaBadminton.dbo.tblTourneyTeam"
					MSQL = MSQL & " WHERE DelYN = 'N'"
					MSQL = MSQL & " AND GameLevelDtlidx = '" & bon_GameLevelDtlIDX & "'"

          Set MRs = Dbcon.Execute(MSQL)

          If Not (MRs.Eof Or MRs.Bof) Then
              bon_TourneyTeamNum = MRs("TourneyTeamNum")
          End If

          MRs.Close							

          ''해당 그룹에 선수그룹 INSERT
          'MSQL = "SET NOCOUNT ON"
          'MSQL = MSQL & " INSERT INTO dbo.tblTourneyGroup ("
          'MSQL = MSQL & " GameTitleIDX, TeamGb, GameLevelDtlidx, Level, LevelDtlName, Team, TeamDtl, TourneyGroupNum"
          'MSQL = MSQL & " )"
          'MSQL = MSQL & " VALUES ("
          'MSQL = MSQL & " '" & bon_GameTitleIDX & "'"
          'MSQL = MSQL & " ,'" & bon_TeamGb & "'"
          'MSQL = MSQL & " ,'" & bon_GameLevelDtlIDX & "'"
          'MSQL = MSQL & " ,'" & bon_Level & "'"
          'MSQL = MSQL & " ,'" & bon_LevelDtlName & "'"
          'MSQL = MSQL & " ,'" & LRs("Team") & "'"
          'MSQL = MSQL & " ,'" & LRs("TeamDtl") & "'"
          'MSQL = MSQL & " ,'" & bon_TourneyGroupNum  & "'"
          'MSQL = MSQL & " );"
          'MSQL = MSQL & " SELECT @@IDENTITY AS IDX"
 
          'Set MRs = Dbcon.Execute(MSQL)
 
          'If Not (MRs.Eof Or MRs.Bof) Then
 
 
          '    bon_TourneyGroupIDX =  MRs("IDX")
          '    MRs.MoveNext     
 
          '  Loop
          'Else
          '    bon_TourneyGroupIDX = "0" 
          'End If
 
          'MRs.Close
 
          ''해당 대진에 선수 INSERT
          'MSQL = "SET NOCOUNT ON"
          'MSQL = MSQL & " INSERT INTO dbo.tblTourneyPlayer"
          'MSQL = MSQL & " ("
          'MSQL = MSQL & " TourneyGroupIDX, MemberIDX, GameTitleIDX, UserName, TeamGb"
          'MSQL = MSQL & " , GameLevelDtlidx, Level, LevelDtlName, Sex, MemberNum"
          'MSQL = MSQL & " , CourtPosition, Team, TeamDtl, Team_Origin"
          'MSQL = MSQL & " )"
          'MSQL = MSQL & " SELECT '" & bon_TourneyGroupIDX & "', A.MemberIDX, '" & bon_GameTitleIDX & "', A.UserName, '" & bon_TeamGb & "'"
          'MSQL = MSQL & " , '" & bon_GameLevelDtlIDX & "', '" & bon_Level & "', '" & bon_LevelDtlName & "', A.Sex, 0"
          'MSQL = MSQL & " , NULL, A.Team, A.TeamDtl, A.Team_Origin"
          'MSQL = MSQL & " FROM dbo.tblTourneyPlayer A"
          'MSQL = MSQL & " WHERE A.DelYN = 'N'"
          'MSQL = MSQL & " AND A.GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "'"
          'MSQL = MSQL & " AND A.TourneyGroupIDX = '" & WIN_TourneyGroupIDX & "'"

          'Dbcon.Execute(MSQL)

          
          'MSQL = "SELECT AreaNum "
          'MSQL = MSQL & " FROM dbo.tblGameRule"
          'MSQL = MSQL & " WHERE DelYN = 'N'"
          'MSQL = MSQL & " AND Gang = '" & bon_TotRound & "'"
          'MSQL = MSQL & " AND JoNum = '" & LevelJooNum & "'"
'
          'Set MRs = Dbcon.Execute(MSQL)
'
          'If Not (MRs.Eof Or MRs.Bof) Then
'
          '    Do Until MRs.Eof
'
          '        CSQL = "UPDATE tblTourneyTeam SET Team = '" & LRs("Team") & "',"
					'				CSQL = CSQL & " TeamDtl = '" & LRs("TeamDtl") & "'"
          '        CSQL = CSQL & " WHERE DelYN = 'N'"
          '        CSQL = CSQL & " AND GameLevelDtlidx = '" & bon_GameLevelDtlIDX & "'"
          '        CSQL = CSQL & " AND ORDERBY = '" & MRs("AreaNum") & "'"     
'
          '        Dbcon.Execute(CSQL)        
'
          '        MRs.MoveNext    
          '    Loop
'
          'End If
'
          'MRs.Close

          LRs.MoveNext            
        Loop

      End If

      LRs.Close
    
    End If 

End If
  

Call oJSONoutput.Set("result", 0 )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson

Set LRs = Nothing
DBClose()
  
%>