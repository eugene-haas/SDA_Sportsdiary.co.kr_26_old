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


  REQ = Request("Req")
  'REQ = "{""tGameTitleIdx"":""BF242F3A46C5952F1DF14D02620F1AB7"",""CMD"":7,""tGroupGameGb"":""B4E57B7A4F9D60AE9C71424182BA33FE"",""tTeamGb"":""B32B6D24B11E75C717936C93707D92D5"",""tPlayTypeSex"":""9313C11726C4F47D4859E9CC91CA6DAA|"",""tLevel"":""5290F716FD35ACE8623962F63197E5F3|2B4F14AE43DBCAD1D5BFD3285CE3A249|"",""arr_STR_Grade"":"",,,,,,,,,,,,,,,,,,,,"",""arr_STR_Team"":""BA00038,BA00389,BA00395,BA00088,BA00213,BA00393,BA00078,BA00088,BA00394,BA00076,BA00118,BA00390,BA00118,BA00388,BA00392,BA00038,BA00052,BA00078,BA00050,BA00358,BA00391"",""arr_STR_TeamDtl"":""B,0,0,B,0,0,B,A,0,0,A,0,B,0,0,A,0,A,0,0,0""}"

  Set oJSONoutput = JSON.Parse(REQ)
  reqGameTitleIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameTitleIdx))
  crypt_reqGameTitleIdx =crypt.EncryptStringENC(tGameTitleIdx)

  If hasown(oJSONoutput, "tGroupGameGb") = "ok" then
    reqGroupGameGb = fInject(crypt.DecryptStringENC(oJSONoutput.tGroupGameGb))
    crypt_reqGroupGameGb =crypt.EncryptStringENC(reqGroupGameGb)
  Else
    reqGroupGameGb = "B0030001" ' 개인전(B0030001), 단체전(B0030002)
    crypt_reqGroupGameGb = crypt.EncryptStringENC(reqGroupGameGb)
  End if	

  If hasown(oJSONoutput, "tTeamGb") = "ok" then
    reqTeamGb = fInject(crypt.DecryptStringENC(oJSONoutput.tTeamGb))
    crypt_reqTeamGb =crypt.EncryptStringENC(reqTeamGb)
  End if	

  If hasown(oJSONoutput, "tPlayTypeSex") = "ok" then
    reqPlayTypeSex= fInject(oJSONoutput.tPlayTypeSex)
    If InStr(reqPlayTypeSex,"|") > 1 Then
      arr_reqPlayTypeSex = Split(reqPlayTypeSex,"|")
      reqSex = fInject(crypt.DecryptStringENC(arr_reqPlayTypeSex(0)))
      reqPlayType = fInject(crypt.DecryptStringENC(arr_reqPlayTypeSex(1)))
    End if
  End if	

  If hasown(oJSONoutput, "tLevel") = "ok" then
    reqLevel= fInject(oJSONoutput.tLevel)
    'reqLevel = "FE25E609214EB0FC01BC8651577120A1|2B4F14AE43DBCAD1D5BFD3285CE3A249|1"
    If InStr(reqLevel,"|") > 1 Then
      arr_reqLevel = Split(reqLevel,"|")
      reqLevel = fInject(crypt.DecryptStringENC(arr_reqLevel(0)))
      reqLevelJooName = fInject(crypt.DecryptStringENC(arr_reqLevel(1)))
      reqLevelJooNum = arr_reqLevel(2)
    End if
  End if	

  If hasown(oJSONoutput, "arr_STR_Grade") = "ok" then
    arr_STR_Grade= fInject(oJSONoutput.arr_STR_Grade)
  End if	

  If hasown(oJSONoutput, "arr_STR_Team") = "ok" then
    arr_STR_Team= fInject(oJSONoutput.arr_STR_Team)
  End if	

  If hasown(oJSONoutput, "arr_STR_TeamDtl") = "ok" then
    arr_STR_TeamDtl= fInject(oJSONoutput.arr_STR_TeamDtl)
  End if	      


  Response.Write reqGameTitleIdx & ":<Br>"
  Response.Write reqGroupGameGb & ":<Br>"
  Response.Write reqTeamGb & ":<Br>"
  Response.Write reqSex & ":<Br>"
  Response.Write reqPlayType & ":<Br>"
  Response.Write reqLevel & ":Level<Br>"
  Response.Write reqLevelJooName & ":<Br>"
  Response.Write reqLevelJooNum & ":<Br>"
  Response.Write arr_STR_Grade & ":<Br>"
  Response.Write arr_STR_Team & ":<Br>"
  Response.Write arr_STR_TeamDtl & ":<Br>"

  Response.END




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

          MSQL = "SELECT AreaNum "
          MSQL = MSQL & " FROM dbo.tblGameRule"
          MSQL = MSQL & " WHERE DelYN = 'N'"
          MSQL = MSQL & " AND Gang = '" & bon_TotRound & "'"
          MSQL = MSQL & " AND JoNum = '" & LevelJooNum & "'"

          Set MRs = Dbcon.Execute(MSQL)

          If Not (MRs.Eof Or MRs.Bof) Then

              Do Until MRs.Eof

                  CSQL = "UPDATE tblTourneyTeam SET Team = '" & LRs("Team") & "',"
									CSQL = CSQL & " TeamDtl = '" & LRs("TeamDtl") & "'"
                  CSQL = CSQL & " WHERE DelYN = 'N'"
                  CSQL = CSQL & " AND GameLevelDtlidx = '" & bon_GameLevelDtlIDX & "'"
                  CSQL = CSQL & " AND ORDERBY = '" & MRs("AreaNum") & "'"     

                  Dbcon.Execute(CSQL)        

                  MRs.MoveNext    
              Loop

          End If

          MRs.Close

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