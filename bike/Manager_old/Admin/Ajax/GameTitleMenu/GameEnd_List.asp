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


REQ = Request("Req")
'REQ = "{""CMD"":14,""GameLevelDtlIDX"":""1DDD4D380E095C6E78A222BA362D0FF7"",""TeamGameNum"":""D3510D3EEF159089CEE3710534553C12"",""GameNum"":""D3510D3EEF159089CEE3710534553C12""}"
'REQ = "{""CMD"":14,""GameLevelDtlIDX"":""090D6DAF05BA220EDE09B5392FA2E655"",""TeamGameNum"":""BA8A3F4EEB3BD1BC6BDDCE9B834746BD"",""GameNum"":""D3510D3EEF159089CEE3710534553C12"",""GameRound"":""D3510D3EEF159089CEE3710534553C12"",""AnthTourneyGroupIDX1"":"""",""AnthTourneyGroupIDX2"":"""",""AnthResult"":"""",""AnthResultDtl"":""""}"

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

LSQL = "SELECT A.GameTitleIDX, A.TeamGb, A.Sex, B.Level, B.LevelDtlName, A.GroupGameGb, A.GameLevelIDX,"
LSQL = LSQL & " B.PlayLevelType, ISNULL(A.JooRank,0) AS JooRank, ISNULL(B.LevelJooNum,0) AS LevelJooNum"
LSQL = LSQL & " FROM KoreaBadminton.dbo.tblGameLevel A"
LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameLevelDtl B ON A.GameLevelidx = B.GameLevelIDX"
LSQL = LSQL & " WHERE A.DelYN = 'N'"
LSQL = LSQL & " AND B.DelYN = 'N'"
LSQL = LSQL & " AND GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"


Set LRs = Dbcon.Execute(LSQL)

If Not (LRs.Eof Or LRs.Bof) Then

    Do Until LRs.Eof

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

Else
    Call oJSONoutput.Set("result", 1 )
    strjson = JSON.stringify(oJSONoutput)
    Response.Write strjson
    Response.END
End If

LRs.Close

 Call oJSONoutput.Set("GroupGameGb", crypt.EncryptStringENC(GroupGameGb) )


'경기결과 카운트 불러오기
LSQL = "SELECT COUNT(*) AS ResultCnt"
LSQL = LSQL & " FROM KoreaBadminton.dbo.tblGameResult"
LSQL = LSQL & " WHERE DelYN = 'N'"
LSQL = LSQL & " AND GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "'"
LSQL = LSQL & " AND TeamGameNum = '" & DEC_TeamGameNum & "'"
LSQL = LSQL & " AND GameNum = '" & DEC_GameNum & "'"

Set LRs = Dbcon.Execute(LSQL)

If Not (LRs.Eof Or LRs.Bof) Then

    RsCnt = LRs("ResultCnt")

End If

LRs.Close

 
'경기결과가 있으면 UPDATE
If Cint(RsCnt) > 0 Then

CSQL = " UPDATE KoreaBadminton.dbo.tblGameResult SET"
CSQL = CSQL & " DelYN = 'Y'"
CSQL = CSQL & " WHERE DelYN = 'N'"
CSQL = CSQL & " AND GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "'"
CSQL = CSQL & " AND TeamGameNum = '" & DEC_TeamGameNum & "'"
CSQL = CSQL & " AND GameNum = '" & DEC_GameNum & "'"

Dbcon.Execute(CSQL)


End If


CSQL = "UPDATE KoreaBadminton.dbo.tblTourney SET"
CSQL = CSQL & " EndHour = '" & AddZero(Hour(Now)) & "',"
CSQL = CSQL & " EndMinute = '" & AddZero(Minute(Now)) & "'"
CSQL = CSQL & " WHERE GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
CSQL = CSQL & " AND TeamGameNum = '" & DEC_TeamGameNum & "'"
CSQL = CSQL & " AND GameNum = '" & DEC_GameNum & "'"
CSQL = CSQL & " AND ISNULL(EndHour,'') = ''"

Dbcon.Execute(CSQL)


'LSQL = "SELECT TourneyGroupIDX, COUNT(TourneyGroupIDX) AS WinCnt"
'LSQL = LSQL & " FROM "
'LSQL = LSQL & " ( "
'LSQL = LSQL & " SELECT ROW_NUMBER() OVER (PARTITION BY GameLevelDtlIDX, TeamGameNum, GameNum, SetNum ORDER BY SetJumsu DESC) AS RowNum"
'LSQL = LSQL & " , TourneyGroupIDX, SetNum, SetJumsu"
'LSQL = LSQL & " FROM tblGameSetResult"
'LSQL = LSQL & " WHERE DelYN = 'N'"
'LSQL = LSQL & " AND GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "'"
'LSQL = LSQL & " AND TeamGameNum = '" & DEC_TeamGameNum & "'"
'LSQL = LSQL & " AND GameNum = '"& DEC_GameNum &"'"
'LSQL = LSQL & " ) AS A"
'LSQL = LSQL & " WHERE RowNum = '1'"
'LSQL = LSQL & " GROUP BY TourneyGroupIDX"
'LSQL = LSQL & " ORDER BY COUNT(TourneyGroupIDX) DESC"


'세트별 점수 따져서 이긴팀 진팀 구분
LSQL = "SELECT B.TourneyNum, B.TourneyGroupIDX, COUNT(A.TourneyGroupIDX) AS WinCnt"
LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourney B"
LSQL = LSQL & " LEFT JOIN "
LSQL = LSQL & " 	( "
LSQL = LSQL & "     SELECT RowNum, TourneyGroupIDX, SetNum, SetJumsu, GameLevelDtlIDX, TeamGameNum, GameNum"
LSQL = LSQL & "     FROM "
LSQL = LSQL & "         ("
LSQL = LSQL & " 	    SELECT ROW_NUMBER() OVER (PARTITION BY GameLevelDtlIDX, TeamGameNum, GameNum, SetNum ORDER BY CONVERT(BigINT,SetJumsu) DESC) AS RowNum"
LSQL = LSQL & " 	    , TourneyGroupIDX, SetNum, SetJumsu, GameLevelDtlIDX, TeamGameNum, GameNum"
LSQL = LSQL & " 	    FROM tblGameSetResult"
LSQL = LSQL & " 	    WHERE DelYN = 'N'"
LSQL = LSQL & " 	    AND GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "'"
LSQL = LSQL & " 	    AND TeamGameNum = '" & DEC_TeamGameNum & "'"
LSQL = LSQL & " 	    AND GameNum = '" & DEC_GameNum & "'"
LSQL = LSQL & " 	    AND SetJumsu <> '0'"
LSQL = LSQL & "         ) AS C"
LSQL = LSQL & "     WHERE RowNum = '1'"
LSQL = LSQL & " 	) AS A ON B.TourneyGroupIDX = A.TourneyGroupIDX AND B.GameLevelDtlIDX = A.GameLevelDtlIDX AND B.TeamGameNum = A.TeamGameNum AND B.GameNum = A.GameNum"
LSQL = LSQL & " WHERE B.GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "'"
LSQL = LSQL & " AND B.TeamGameNum = '" & DEC_TeamGameNum & "'"
LSQL = LSQL & " AND B.GameNum = '" & DEC_GameNum & "'"
LSQL = LSQL & " AND B.DelYN = 'N'"
LSQL = LSQL & " GROUP BY B.TourneyGroupIDX, B.TourneyNum"
LSQL = LSQL & " ORDER BY COUNT(A.TourneyGroupIDX) DESC"


Set LRs = Dbcon.Execute(LSQL)

i = 0

If Not (LRs.Eof Or LRs.Bof) Then

    Do Until LRs.Eof

        '승자 결과 INSERT
        If i = 0 Then

            '승자 TourneyGroupIDX, TourneyNum 은 따로 보관
            WIN_TourneyGroupIDX = LRs("TourneyGroupIDX")
            WIN_TourneyNum = LRs("TourneyNum")

            CSQL = "INSERT KoreaBadminton.dbo.tblGameResult"
            CSQL = CSQL & " ("
            CSQL = CSQL & " GameLevelDtlidx, GameTitleIDX, TeamGb, Sex, GroupGameGb, "
            CSQL = CSQL & " Level, LevelDtlName, Round, TeamGameNum, GameNum, "
            CSQL = CSQL & " TourneyGroupIDX, Result, Jumsu, Team, TeamDtl, "
            CSQL = CSQL & " StadiumNumber"
            CSQL = CSQL & " )"
            CSQL = CSQL & " VALUES"
            CSQL = CSQL & " ("
            CSQL = CSQL & " '" & DEC_GameLevelDtlIDX & "', '" & GameTitleIDX & "', '" & TeamGb & "', '" & Sex & "', '" & GroupGameGb & "',"
            CSQL = CSQL & " '" & Level & "', '" & LevelDtlName & "', '" & DEC_GameRound & "', '" & DEC_TeamGameNum & "', '" & DEC_GameNum & "',"
            CSQL = CSQL & " '" & LRs("TourneyGroupIDX") & "', '" & "B5010001" & "', '" & LRs("WinCnt") & "', '', '',"
            CSQL = CSQL & " ''"
            CSQL = CSQL & " )"

            Dbcon.Execute(CSQL)

        '패자 결과 INSERT
        Else

            CSQL = "INSERT KoreaBadminton.dbo.tblGameResult"
            CSQL = CSQL & " ("
            CSQL = CSQL & " GameLevelDtlidx, GameTitleIDX, TeamGb, Sex, GroupGameGb, "
            CSQL = CSQL & " Level, LevelDtlName, Round, TeamGameNum, GameNum, "
            CSQL = CSQL & " TourneyGroupIDX, Result, Jumsu, Team, TeamDtl, "
            CSQL = CSQL & " StadiumNumber"
            CSQL = CSQL & " )"
            CSQL = CSQL & " VALUES"
            CSQL = CSQL & " ("
            CSQL = CSQL & " '" & DEC_GameLevelDtlIDX & "', '" & GameTitleIDX & "', '" & TeamGb & "', '" & Sex & "', '" & GroupGameGb & "',"
            CSQL = CSQL & " '" & Level & "', '" & LevelDtlName & "', '" & DEC_GameRound & "', '" & DEC_TeamGameNum & "', '" & DEC_GameNum & "',"
            CSQL = CSQL & " '" & LRs("TourneyGroupIDX") & "', '" & "B6010001" & "', '" & LRs("WinCnt") & "', '', '',"
            CSQL = CSQL & " ''"
            CSQL = CSQL & " )"

            Dbcon.Execute(CSQL)
            
        End If

        i = i + 1

        LRs.MoveNext
    Loop

End If

LRs.Close


'현재경기의 대진표 위치값 구하기 GrNum : 현재대진표 위치값
'4의배수숫자마다 1씩 증가하여 그룹화
LSQL = "SELECT ASCNum"
LSQL = LSQL & " FROM"
LSQL = LSQL & " 	 ("
LSQL = LSQL & " 	 SELECT ROW_NUMBER() OVER ( ORDER BY ORDERBY ASC) ASCNum, tourneynum, TeamGameNum, GameNum, TourneyGroupIDX"
LSQL = LSQL & " 	 FROM KoreaBadminton.dbo.tblTourney"
LSQL = LSQL & " 	 WHERE DelYN = 'N'"
LSQL = LSQL & " 	 AND GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "'"
LSQL = LSQL & " 	 AND [ROUND] = '" & DEC_GameRound & "'"
LSQL = LSQL & " 	 ) AS A"
LSQL = LSQL & " WHERE TourneyGroupIDX = '" & WIN_TourneyGroupIDX & "'"
LSQL = LSQL & " AND TeamGameNum = '" & DEC_TeamGameNum & "'"
LSQL = LSQL & " AND GameNum = '" & DEC_GameNum & "'"


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

LSQL = "SELECT TourneyIDX"
LSQL = LSQL & " FROM"
LSQL = LSQL & " 	 ("
LSQL = LSQL & " 	 SELECT ROW_NUMBER() OVER ( ORDER BY ORDERBY ASC) ASCNum, TourneyIDX"
LSQL = LSQL & " 	 FROM KoreaBadminton.dbo.tblTourney"
LSQL = LSQL & " 	 WHERE DelYN = 'N'"
LSQL = LSQL & " 	 AND GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "'"
LSQL = LSQL & " 	 AND [ROUND] = '" & Cint(DEC_GameRound + 1)  & "'"
LSQL = LSQL & " 	 ) AS A"
LSQL = LSQL & " WHERE ASCNum = '" & NextGrNum & "'"

Set LRs = Dbcon.Execute(LSQL)

i = 0

If Not (LRs.Eof Or LRs.Bof) Then

    Next_TourneyIDX = LRs("TourneyIDX")

End If

LRs.Close



CSQL = "UPDATE tblTourney SET "
CSQL = CSQL & " TourneyGroupIDX = '" & WIN_TourneyGroupIDX & "', "
CSQL = CSQL & " TourneyNum = '" & WIN_TourneyNum & "'"
CSQL = CSQL & " WHERE TourneyIDX = '" & Next_TourneyIDX & "'"
Dbcon.Execute(CSQL)

 '경기 수 구하기
 LSQL = "SELECT MAX(CONVERT(BIGINT,GameNum)) AS MaxGameNum"
 LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourney"
 LSQL = LSQL & " WHERE DelYN = 'N'"
 LSQL = LSQL & " AND GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
 Set LRs = Dbcon.Execute(LSQL)
 If Not (LRs.Eof Or LRs.Bof) Then
     MaxGameNum = LRs("MaxGameNum")
 End If
 LRs.Close

 '끝난경기수 구하기
 LSQL = "SELECT COUNT(*) AS EndGameCnt"
 LSQL = LSQL & " FROM "
 LSQL = LSQL & " ("
 LSQL = LSQL & " SELECT GameLevelDtlidx, TeamGameNum, GameNum"
 LSQL = LSQL & " FROM KoreaBadminton.dbo.tblGameResult "
 LSQL = LSQL & " WHERE DelYN = 'N'"
 LSQL = LSQL & " AND GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
 LSQL = LSQL & " GROUP BY GameLevelDtlidx, TeamGameNum, GameNum"
 LSQL = LSQL & " ) AS A"
 Set LRs = Dbcon.Execute(LSQL)
 If Not (LRs.Eof Or LRs.Bof) Then
     EndGameCnt = LRs("EndGameCnt")
 End If
 LRs.Close

If Cint(EndGameCnt) => Cint(MaxGameNum) Then
    '실적넣기
    LSQL = "dbo.Insert_tblMedal '" & DEC_GameLevelDtlIDX & "'"
    Dbcon.Execute(LSQL)
End If

'개인전 예선이라면 마지막경기때 설정된 본선순위만큼 본선 진출
If GroupGameGb = "B0030001" AND PlayLevelType = "B0100001" Then

    '경기 수 구하기
    LSQL = "SELECT MAX(CONVERT(BIGINT,GameNum)) AS MaxGameNum"
    LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourney"
    LSQL = LSQL & " WHERE DelYN = 'N'"
    LSQL = LSQL & " AND GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"

    Set LRs = Dbcon.Execute(LSQL)

    If Not (LRs.Eof Or LRs.Bof) Then
        MaxGameNum = LRs("MaxGameNum")
    End If

    LRs.Close


    '끝난경기수 구하기
    LSQL = "SELECT COUNT(*) AS EndGameCnt"
    LSQL = LSQL & " FROM "
    LSQL = LSQL & " ("
    LSQL = LSQL & " SELECT GameLevelDtlidx, TeamGameNum, GameNum"
    LSQL = LSQL & " FROM KoreaBadminton.dbo.tblGameResult "
    LSQL = LSQL & " WHERE DelYN = 'N'"
    LSQL = LSQL & " AND GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
    LSQL = LSQL & " GROUP BY GameLevelDtlidx, TeamGameNum, GameNum"
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

        '경기결과 카운트 불러오기
        'LSQL = "Insert_tblTourney_Bon '" & bon_GameLevelDtlIDX & "'"

        'Dbcon.Execute(LSQL)

    End If

  
    If Cint(EndGameCnt) => Cint(MaxGameNum) Then




        '해당 대진표 랭킹구하기
        LSQL = "SELECT TourneyGroupIDX, WinCnt, GameCnt, WinPerc, LoseCnt, WinPoint, LosePoint, PointDiff, TRanking"
        LSQL = LSQL & " FROM"
        LSQL = LSQL & " ("
        LSQL = LSQL & " SELECT TourneyGroupIDX, WinCnt, GameCnt, WinPerc, LoseCnt, WinPoint, LosePoint, PointDiff,"
        LSQL = LSQL & " ROW_NUMBER() OVER ( ORDER BY WinCnt DESC, WinPerc DESC, PointDiff DESC, WinPoint DESC) AS TRanking"
        LSQL = LSQL & " FROM "
	    LSQL = LSQL & "     ("
	    LSQL = LSQL & "     SELECT TourneyGroupIDX, CONVERT(FLOAT,WinCnt) AS WinCnt, CONVERT(FLOAT,GameCnt) AS GameCnt, "
	    LSQL = LSQL & "     CONVERT(FLOAT,(CONVERT(FLOAT,WinCnt) / CONVERT(FLOAT,GameCnt)) * 100) AS WinPerc,"
	    LSQL = LSQL & "     LoseCnt, WinPoint, LosePoint, CONVERT(FLOAT,WinPoint) - CONVERT(FLOAT,LosePoint) AS PointDiff"
	    LSQL = LSQL & "     FROM"
		LSQL = LSQL & "         ("
		LSQL = LSQL & "         SELECT TourneyGroupIDX, "
		LSQL = LSQL & "         SUM(WinCnt) AS WinCnt, SUM(LoseCnt) AS LoseCnt, SUM(GameCnt) AS GameCnt,"
		LSQL = LSQL & "         KoreaBadminton.dbo.FN_WinPoint('" & DEC_GameLevelDtlIDX & "',TourneyGroupIDX) AS WinPoint,"
		LSQL = LSQL & "         KoreaBadminton.dbo.FN_LosePoint('" & DEC_GameLevelDtlIDX & "',TourneyGroupIDX) AS LosePoint"
		LSQL = LSQL & "         FROM ("
		LSQL = LSQL & " 	        SELECT A.TourneyGroupIDX,"
		LSQL = LSQL & " 	        CASE WHEN PubType = 'WIN' THEN 1 ELSE 0 END AS WinCnt,"
		LSQL = LSQL & " 	        CASE WHEN PubType = 'LOSE' THEN 1 ELSE 0 END AS LoseCnt,"
		LSQL = LSQL & " 	        1 AS GameCnt"
		LSQL = LSQL & " 	        FROM ("
		LSQL = LSQL & " 		        SELECT GamelevelDtlIDX, TourneyGroupIDX, MIN(ORDERBY) AS ORDERBY"
		LSQL = LSQL & " 		        FROM tblTourney"
		LSQL = LSQL & " 		        WHERE DelYN = 'N'"
		LSQL = LSQL & " 		        AND GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
		LSQL = LSQL & " 		        GROUP BY GamelevelDtlIDX, TourneyGroupIDX"
		LSQL = LSQL & " 		        ) AS A"
		LSQL = LSQL & " 	        LEFT JOIN tblGameResult B ON A.GameLevelDtlidx = B.GameLevelDtlidx AND A.TourneyGroupIDX = B.TourneyGroupIDX"
		LSQL = LSQL & " 	        INNER JOIN tblPubcode C ON C.PubCode = B.Result"
		LSQL = LSQL & " 	        AND B.DelYN = 'N'"
		LSQL = LSQL & " 	        AND A.TourneyGroupIDX <> '0'"
		LSQL = LSQL & " 	        ) AS AA"
		LSQL = LSQL & "         GROUP BY TourneyGroupIDX"
		LSQL = LSQL & "         ) AS AAA"
	    LSQL = LSQL & "     ) AS AAAA"
        LSQL = LSQL & " ) AS AAAAA"
        LSQL = LSQL & " WHERE TRanking <=" & JooRank 
        LSQL = LSQL & " ORDER BY TRanking" 

        Set LRs = Dbcon.Execute(LSQL)

        If Not (LRs.Eof Or LRs.Bof) Then

	        Do Until LRs.Eof

                MSQL = "SELECT CASE WHEN MAX(TourneyGroupNum) IS NULL THEN '101' ELSE MAX(TourneyGroupNum) + 1 END AS TourneyGroupNum"
                MSQL = MSQL & " FROM KoreaBadminton.dbo.tblTourneyGroup"
                MSQL = MSQL & " WHERE DelYN = 'N'"
                MSQL = MSQL & " AND GameLevelDtlidx = '" & bon_GameLevelDtlIDX & "'"

                Set MRs = Dbcon.Execute(MSQL)

                If Not (MRs.Eof Or MRs.Bof) Then
                    bon_TourneyGroupNum = MRs("TourneyGroupNum")
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
                'MSQL = MSQL & " ,NULL"
                'MSQL = MSQL & " ,'0'"
                'MSQL = MSQL & " ,'" & bon_TourneyGroupNum  & "'"
                'MSQL = MSQL & " );"
                'MSQL = MSQL & " SELECT @@IDENTITY AS IDX"

               'Set MRs = Dbcon.Execute(MSQL)

               'If Not (MRs.Eof Or MRs.Bof) Then


               '        bon_TourneyGroupIDX =  MRs("IDX")
           
               '        MRs.MoveNext            
               '    Loop
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

               'Set MRs = Dbcon.Execute(MSQL)

               'If Not (MRs.Eof Or MRs.Bof) Then

               '    Do Until MRs.Eof

               '        CSQL = "UPDATE tblTourney SET TourneyGroupIDX = '" & bon_TourneyGroupIDX & "'"
               '        CSQL = CSQL & " WHERE DelYN = 'N'"
               '        CSQL = CSQL & " AND GameLevelDtlidx = '" & bon_GameLevelDtlIDX & "'"
               '        CSQL = CSQL & " AND ORDERBY = '" & MRs("AreaNum") & "'"     

               '        Dbcon.Execute(CSQL)        

               '        MRs.MoveNext    
               '    Loop

               'End If

               'MRs.Close

                LRs.MoveNext            
            Loop

        End If

        LRs.Close
    
    End If 

End If
  
Call oJSONoutput.Set("result", 0 )
Call oJSONoutput.Set("WIN_TourneyGroupIDX", crypt.EncryptStringENC(WIN_TourneyGroupIDX))

strjson = JSON.stringify(oJSONoutput)
Response.Write strjson

Set LRs = Nothing
DBClose()
  
%>