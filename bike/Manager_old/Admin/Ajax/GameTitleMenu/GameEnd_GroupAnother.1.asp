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

Dim CSQL
Dim LRs
Dim strjson
Dim strjson_sum

Dim oJSONoutput_SUM
Dim oJSONoutput

Dim CMD  
Dim GameLevelDtlIDX 
Dim TeamGameNum
Dim GameNum

Dim GameTitleIDX
Dim TeamGb 
Dim Sex 
Dim Level 
Dim LevelDtlName 
Dim GroupGameGb
Dim GameLevelIDX
Dim PlayLevelType
Dim JooRank

Dim LGroupJumsu
Dim RGroupJumsu

Dim Anth_TourneyIDX1
Dim Anth_TourneyIDX2
Dim TourneyIDX1
Dim TourneyIDX2
Dim Anth_ResultType
Dim Anth_ResultTypeDtl

Dim WinCode_Left2


Dim WIN_TourneyGroupIDX
Dim WIN_TourneyNum
Dim GrNum
Dim ModNum

Dim SchGRNum
Dim ORNum

Dim RsCnt

Dim MaxGameNum
Dim EndGameCnt

Dim i : i = 0

REQ = Request("Req")
'REQ = "{""CMD"":8,""GameLevelDtlIDX"":""996"",""GameRound"":""1"",""TeamGameNum"":""0"",""GameNum"":""1"",""WinType"":""WIN"",""TourneyGroupIDX"":""683"",""LGroupJumsu"":""2"",""RGroupJumsu"":""0"",""StrArea"":""L""}"

Set oJSONoutput = JSON.Parse(REQ)

If hasown(oJSONoutput, "GameLevelDtlIDX") = "ok" then
    If ISNull(oJSONoutput.GameLevelDtlIDX) Or oJSONoutput.GameLevelDtlIDX = "" Then
      GameLevelDtlIDX = ""
      DEC_GameLevelDtlIDX = ""
    Else
      GameLevelDtlIDX = fInject(oJSONoutput.GameLevelDtlIDX)
      DEC_GameLevelDtlIDX = fInject(oJSONoutput.GameLevelDtlIDX)    
    End If
  Else  
    GameLevelDtlIDX = ""
    DEC_GameLevelDtlIDX = ""
End if	

If hasown(oJSONoutput, "GameRound") = "ok" then
    If ISNull(oJSONoutput.GameRound) Or oJSONoutput.GameRound = "" Then
      GameRound = ""
      DEC_GameRound = ""
    Else
      GameRound = fInject(oJSONoutput.GameRound)
      DEC_GameRound = fInject(oJSONoutput.GameRound)    
    End If
  Else  
    GameRound = ""
    DEC_GameRound = ""
End if	

If hasown(oJSONoutput, "TeamGameNum") = "ok" then
    If ISNull(oJSONoutput.TeamGameNum) Or oJSONoutput.TeamGameNum = "" Then
      TeamGameNum = ""
      DEC_TeamGameNum = ""
    Else
      TeamGameNum = fInject(oJSONoutput.TeamGameNum)
      DEC_TeamGameNum = fInject(oJSONoutput.TeamGameNum)    
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
      DEC_GameNum = fInject(oJSONoutput.GameNum)    
    End If
  Else  
    GameNum = ""
    DEC_GameNum = ""
End if	

If hasown(oJSONoutput, "WinType") = "ok" then
    If ISNull(oJSONoutput.WinType) Or oJSONoutput.WinType = "" Then
      WinType = ""
      DEC_WinType = ""
    Else
      WinType = fInject(oJSONoutput.WinType)
      DEC_WinType = fInject(oJSONoutput.WinType)    
    End If
  Else  
    WinType = ""
    DEC_WinType = ""
End if	

If hasown(oJSONoutput, "TourneyGroupIDX") = "ok" then
    If ISNull(oJSONoutput.TourneyGroupIDX) Or oJSONoutput.TourneyGroupIDX = "" Then
      TourneyGroupIDX = ""
      DEC_TourneyGroupIDX = ""
    Else
      TourneyGroupIDX = fInject(oJSONoutput.TourneyGroupIDX)
      DEC_TourneyGroupIDX = fInject(oJSONoutput.TourneyGroupIDX)    
    End If
  Else  
    TourneyGroupIDX = ""
    DEC_TourneyGroupIDX = ""
End if	

If hasown(oJSONoutput, "LGroupJumsu") = "ok" then
    If ISNull(oJSONoutput.LGroupJumsu) Or oJSONoutput.LGroupJumsu = "" Then
      LGroupJumsu = ""
      DEC_LGroupJumsu = ""
    Else
      LGroupJumsu = fInject(oJSONoutput.LGroupJumsu)
      DEC_LGroupJumsu = fInject(oJSONoutput.LGroupJumsu)    
    End If
  Else  
    LGroupJumsu = ""
    DEC_LGroupJumsu = ""
End if	

If hasown(oJSONoutput, "RGroupJumsu") = "ok" then
    If ISNull(oJSONoutput.RGroupJumsu) Or oJSONoutput.RGroupJumsu = "" Then
      RGroupJumsu = ""
      DEC_RGroupJumsu = ""
    Else
      RGroupJumsu = fInject(oJSONoutput.RGroupJumsu)
      DEC_RGroupJumsu = fInject(oJSONoutput.RGroupJumsu)    
    End If
  Else  
    RGroupJumsu = ""
    DEC_RGroupJumsu = ""
End if	

If hasown(oJSONoutput, "StrArea") = "ok" then
    If ISNull(oJSONoutput.StrArea) Or oJSONoutput.StrArea = "" Then
      StrArea = ""
      DEC_StrArea = ""
    Else
      StrArea = fInject(oJSONoutput.StrArea)
      DEC_StrArea = fInject(oJSONoutput.StrArea)    
    End If
  Else  
    StrArea = ""
    DEC_RStrArea = ""
End if	


If Not IsNumeric(LGroupJumsu) Then
    LGroupJumsu = "0"
End If

If Not IsNumeric(RGroupJumsu) Then
    RGroupJumsu = "0"
End If


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
    Response.END
End If

LRs.Close

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

 

If Cint(RsCnt) > 0 Then

CSQL = " UPDATE KoreaBadminton.dbo.tblGameResult SET"
CSQL = CSQL & " DelYN = 'Y'"
CSQL = CSQL & " WHERE DelYN = 'N'"
CSQL = CSQL & " AND GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "'"
CSQL = CSQL & " AND TeamGameNum = '" & DEC_TeamGameNum & "'"
CSQL = CSQL & " AND GameNum = '" & DEC_GameNum & "'"

Dbcon.Execute(CSQL)

'CSQL = " UPDATE KoreaBadminton.dbo.tblGameProgress SET"
'CSQL = CSQL & " DelYN = 'Y',"
'CSQL = CSQL & " EditDate = GetDate()"
'CSQL = CSQL & " WHERE DelYN = 'N'"
'CSQL = CSQL & " AND GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "'"
'CSQL = CSQL & " AND TeamGameNum = '" & DEC_TeamGameNum & "'"
'CSQL = CSQL & " AND GameNum = '" & DEC_GameNum & "'"
'CSQL = CSQL & " AND SetNum = '" & SetNum & "'"

'Dbcon.Execute(CSQL)

End If

CSQL = "UPDATE KoreaBadminton.dbo.tblTourney SET"
CSQL = CSQL & " EndHour = '" & AddZero(Hour(Now)) & "',"
CSQL = CSQL & " EndMinute = '" & AddZero(Minute(Now)) & "'"
CSQL = CSQL & " WHERE GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
CSQL = CSQL & " AND DelYN = 'N'"
CSQL = CSQL & " AND TeamGameNum = '" & DEC_TeamGameNum & "'"
CSQL = CSQL & " AND GameNum = '" & DEC_GameNum & "'"
CSQL = CSQL & " AND ISNULL(EndHour,'') = ''"

Dbcon.Execute(CSQL)


LSQL = "SELECT TourneyGroupIDX "
LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourney"
LSQL = LSQL & " WHERE GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
LSQL = LSQL & " AND DelYN = 'N'"
LSQL = LSQL & " AND TeamGameNum = '" & DEC_TeamGameNum & "'"
LSQL = LSQL & " AND GameNum = '" & DEC_GameNum & "'"
LSQL = LSQL & " AND TourneyGroupIDX <> '" & DEC_TourneyGroupIDX & "'"

Set LRs = Dbcon.Execute(LSQL)

If Not (LRs.Eof Or LRs.Bof) Then

    R_TourneyGroupIDX = LRs("TourneyGroupIDX")
Else
    R_TourneyGroupIDX = "0"
End If

LRs.Close

If WinType = "WIN" Then

    If StrArea = "L" Then
        LTourneyGroupIDX = DEC_TourneyGroupIDX
        RTourneyGroupIDX = R_TourneyGroupIDX
    Else
        RTourneyGroupIDX = DEC_TourneyGroupIDX
        LTourneyGroupIDX = R_TourneyGroupIDX
    End If

    
    CSQL = "UPDATE KoreaBadminton.dbo.tblGameResultDtl"
    CSQL = CSQL & " SET DelYN = 'Y',"
    CSQL = CSQL & " EditDate = GETDATE()"
    CSQL = CSQL & " WHERE DelYN = 'N'"
    CSQL = CSQL & " AND GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
    CSQL = CSQL & " AND TeamGameNum = '" & DEC_TeamGameNum & "'"
    CSQL = CSQL & " AND GameNum = '" & DEC_GameNum & "'"

    Dbcon.Execute(CSQL)


    
    CSQL = "INSERT INTO KoreaBadminton.dbo.tblGameResultDtl"
    CSQL = CSQL & " ("
    CSQL = CSQL & " GameTitleIDX, GameLevelDtlidx, TeamGb, Sex, Level, "
    CSQL = CSQL & " LevelDtlName, GroupGameGb, TeamGameNum, GameNum, SetNum, "
    CSQL = CSQL & " TourneyGroupIDX, MemberIDX, ServeTourneyGroupIDX, ServeMemberIDX, RecieveTourneyGroupIDX, "
    CSQL = CSQL & " RecieveMemberIDX, JumsuGb, Jumsu, "
    CSQL = CSQL & " Pst_TourneyGroupIDX_L, Pst_MemberIDX_LL, Pst_MemberIDX_LR, Pst_TourneyGroupIDX_R, Pst_MemberIDX_RL, Pst_MemberIDX_RR,"
    CSQL = CSQL & " ServerPositionNum"
    CSQL = CSQL & " )"
    CSQL = CSQL & " VALUES"
    CSQL = CSQL & " ("
    CSQL = CSQL & " '" & GameTitleIDX & "', '" & DEC_GameLevelDtlIDX & "', '" & TeamGb & "', '" & Sex & "', '" & Level & "',"
    CSQL = CSQL & " '" & LevelDtlName & "', '" & GroupGameGb & "', '" & DEC_TeamGameNum & "', '" & DEC_GameNum & "', '1',"
    CSQL = CSQL & " '" & LTourneyGroupIDX & "', '0', '0', '0', '0',"
    CSQL = CSQL & " '0', '', '" & LGroupJumsu & "',"
    CSQL = CSQL & " '0','0','0','0','0','0',"
    CSQL = CSQL & " '0'"
    CSQL = CSQL & " )"

    Dbcon.Execute(CSQL)

    
    CSQL = "INSERT INTO KoreaBadminton.dbo.tblGameResultDtl"
    CSQL = CSQL & " ("
    CSQL = CSQL & " GameTitleIDX, GameLevelDtlidx, TeamGb, Sex, Level, "
    CSQL = CSQL & " LevelDtlName, GroupGameGb, TeamGameNum, GameNum, SetNum, "
    CSQL = CSQL & " TourneyGroupIDX, MemberIDX, ServeTourneyGroupIDX, ServeMemberIDX, RecieveTourneyGroupIDX, "
    CSQL = CSQL & " RecieveMemberIDX, JumsuGb, Jumsu, "
    CSQL = CSQL & " Pst_TourneyGroupIDX_L, Pst_MemberIDX_LL, Pst_MemberIDX_LR, Pst_TourneyGroupIDX_R, Pst_MemberIDX_RL, Pst_MemberIDX_RR,"
    CSQL = CSQL & " ServerPositionNum"
    CSQL = CSQL & " )"
    CSQL = CSQL & " VALUES"
    CSQL = CSQL & " ("
    CSQL = CSQL & " '" & GameTitleIDX & "', '" & DEC_GameLevelDtlIDX & "', '" & TeamGb & "', '" & Sex & "', '" & Level & "',"
    CSQL = CSQL & " '" & LevelDtlName & "', '" & GroupGameGb & "', '" & DEC_TeamGameNum & "', '" & DEC_GameNum & "', '1',"
    CSQL = CSQL & " '" & RTourneyGroupIDX & "', '0', '0', '0', '0',"
    CSQL = CSQL & " '0', '', '" & RGroupJumsu & "',"
    CSQL = CSQL & " '0','0','0','0','0','0',"
    CSQL = CSQL & " '0'"
    CSQL = CSQL & " )"

    Dbcon.Execute(CSQL)



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
    CSQL = CSQL & " '" & Level & "', '" & LevelDtlName & "', '" & GameRound & "', '" & DEC_TeamGameNum & "', '" & DEC_GameNum & "',"
    CSQL = CSQL & " '" & DEC_TourneyGroupIDX & "', 'B5010002', '1', '', '',"
    CSQL = CSQL & " ''"
    CSQL = CSQL & " )"

    Dbcon.Execute(CSQL)


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
    CSQL = CSQL & " '" & Level & "', '" & LevelDtlName & "', '" & GameRound & "', '" & DEC_TeamGameNum & "', '" & DEC_GameNum & "',"
    CSQL = CSQL & " '" & R_TourneyGroupIDX & "', 'B6010002', '0', '', '',"
    CSQL = CSQL & " ''"
    CSQL = CSQL & " )"

    Dbcon.Execute(CSQL)

    WIN_TourneyGroupIDX = TourneyGroupIDX

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
    CSQL = CSQL & " '" & Level & "', '" & LevelDtlName & "', '" & GameRound & "', '" & DEC_TeamGameNum & "', '" & DEC_GameNum & "',"
    CSQL = CSQL & " '" & DEC_TourneyGroupIDX & "', 'B6010002', '0', '', '',"
    CSQL = CSQL & " ''"
    CSQL = CSQL & " )"

    Dbcon.Execute(CSQL)

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
    CSQL = CSQL & " '" & Level & "', '" & LevelDtlName & "', '" & GameRound & "', '" & DEC_TeamGameNum & "', '" & DEC_GameNum & "',"
    CSQL = CSQL & " '" & R_TourneyGroupIDX & "', 'B6010002', '0', '', '',"
    CSQL = CSQL & " ''"
    CSQL = CSQL & " )"

    Dbcon.Execute(CSQL)

    WIN_TourneyGroupIDX = TourneyGroupIDX

End If

Area_TourneyGroupIDX = TourneyGroupIDX


LSQL = "SELECT ASCNum"
LSQL = LSQL & " FROM"
LSQL = LSQL & " 	 ("
LSQL = LSQL & " 	 SELECT ROW_NUMBER() OVER ( ORDER BY ORDERBY ASC) ASCNum, tourneynum, TeamGameNum, GameNum, TourneyGroupIDX"
LSQL = LSQL & " 	 FROM KoreaBadminton.dbo.tblTourney"
LSQL = LSQL & " 	 WHERE DelYN = 'N'"
LSQL = LSQL & " 	 AND GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "'"
LSQL = LSQL & " 	 AND [ROUND] = '" & DEC_GameRound & "'"
LSQL = LSQL & " 	 ) AS A"
LSQL = LSQL & " WHERE TourneyGroupIDX = '" & Area_TourneyGroupIDX & "'"
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


If WIN_TourneyGroupIDX = "" Then
    WIN_TourneyGroupIDX = "0"
ENd If

CSQL = "UPDATE tblTourney SET "
CSQL = CSQL & " TourneyGroupIDX = '" & WIN_TourneyGroupIDX & "', "
CSQL = CSQL & " TourneyNum = '" & WIN_TourneyNum & "'"
CSQL = CSQL & " WHERE TourneyIDX = '" & Next_TourneyIDX & "'"
Dbcon.Execute(CSQL)



If PlayLevelType = "B0100001" Then

    
    LSQL = "SELECT MAX(CONVERT(BIGINT,GameNum)) AS MaxGameNum"
    LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourney"
    LSQL = LSQL & " WHERE DelYN = 'N'"
    LSQL = LSQL & " AND GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"

    Set LRs = Dbcon.Execute(LSQL)

    If Not (LRs.Eof Or LRs.Bof) Then
        MaxGameNum = LRs("MaxGameNum")
    End If

    LRs.Close


    
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

        
        LSQL = "Insert_tblTourney_Bon '" & bon_GameLevelDtlIDX & "'"

        Dbcon.Execute(LSQL)

    End If


  
    If Cint(EndGameCnt) => Cint(MaxGameNum) Then

        
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
'
                'Set MRs = Dbcon.Execute(MSQL)
'
                'If Not (MRs.Eof Or MRs.Bof) Then
'
	            '    Do Until MRs.Eof
'
                '        bon_TourneyGroupIDX =  MRs("IDX")
            '
                '        MRs.MoveNext            
                '    Loop
                'Else
                '    bon_TourneyGroupIDX = "0" 
                'End If
'
                'MRs.Close

                
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
               ''MSQL = MSQL & " AND A.TourneyGroupIDX = '" & WIN_TourneyGroupIDX & "'"
               'MSQL = MSQL & " AND A.TourneyGroupIDX = '" & LRs("TourneyGroupIDX") & "'"

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
                '        CSQL = "UPDATE tblTourney SET TourneyGroupIDX = '" & bon_TourneyGroupIDX & "'"
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