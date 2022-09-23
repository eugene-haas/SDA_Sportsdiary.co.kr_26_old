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


Dim GameRequestPlayerCnt : GameRequestPlayerCnt = 0
Dim New_tMemberIDX:  New_tMemberIDX = ""
Dim New_tUserName : New_tUserName = ""
Dim New_tTeam :  New_tTeam = ""
Dim New_tTeamDtl:  New_tTeamDtl = ""
Dim New_tTeam_Origin : New_tTeam_Origin = ""
Dim New_MemberIDX2 :  New_MemberIDX2 = ""
Dim New_UserName2 :  New_UserName2 = ""
Dim New_Team2 :  New_Team2 = ""
Dim New_TeamDtl2 :  New_TeamDtl2 = ""
Dim New_Team_Origin2 : New_Team_Origin2 = ""
Dim tTourneyTeamIDX : tTourneyTeamIDX = ""
Dim tRequestIDX : tRequestIDX = ""
Dim IsUpdateAndInsert : IsUpdateAndInsert = "false"
REQ = Request("Req")
'REQ = "{""CMD"":12,""TourneyIdx"":""14085"",""RequestIdx"":""6593"",""LevelDtl"":""1321""}"
'{"CMD":12,"TourneyIdx":"14156","RequestIdx":"6607","LevelDtl":"1323"}

Set oJSONoutput = JSON.Parse(REQ)

If hasown(oJSONoutput, "LevelDtl") = "ok" then
    If ISNull(oJSONoutput.LevelDtl) Or oJSONoutput.LevelDtl = "" Then
      LevelDtl = ""
      DEC_LevelDtl = ""
    Else
      LevelDtl = fInject(oJSONoutput.LevelDtl)
      DEC_LevelDtl = fInject(oJSONoutput.LevelDtl)    
    End If
  Else  
    LevelDtl = ""
    DEC_LevelDtl = ""
End if	

If hasown(oJSONoutput, "RequestIdx") = "ok" then
    If ISNull(oJSONoutput.RequestIdx) Or oJSONoutput.RequestIdx = "" Then
      RequestIdx = ""
      DEC_RequestIdx = ""
    Else
      RequestIdx = fInject(oJSONoutput.RequestIdx)
      DEC_RequestIdx = fInject(oJSONoutput.RequestIdx)    
    End If
  Else  
    RequestIdx = ""
    DEC_RequestIdx = ""
End if	

If hasown(oJSONoutput, "TourneyIdx") = "ok" then
    If ISNull(oJSONoutput.TourneyIdx) Or oJSONoutput.TourneyIdx = "" Then
      TourneyIdx = ""
      DEC_TourneyIdx = ""
    Else
      TourneyIdx = fInject(oJSONoutput.TourneyIdx)
      DEC_TourneyIdx = fInject(oJSONoutput.TourneyIdx)    
    End If
  Else  
    TourneyIdx = ""
    DEC_TourneyIdx = ""
End if	



LSQL = "SELECT Count(*) as TourneyCnt"
LSQL = LSQL & "   FROM tblTourney "
LSQL = LSQL & " WHERE DelYN ='N' and GameLevelDtlidx = '" &  DEC_LevelDtl & "'"
'Response.Write "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL : " & LSQL & "<br/>"

Set LRs = DBCon.Execute(LSQL)
If Not (LRs.Eof Or LRs.Bof) Then
  Do Until LRs.Eof
    tTourneyCnt = LRs("TourneyCnt")
    LRs.MoveNext
  Loop
End If
LRs.close

IF CDBL(tTourneyCnt) = 0 Then
  Call oJSONoutput.Set("result", 1 )
  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.End
End IF


LSQL = "SELECT TourneyIDX, RequestIDX, TourneyGroupIDX, GameLevelDtlidx"
LSQL = LSQL & " FROM  tblTourney "
LSQL = LSQL & " WHERE DelYN ='N' and TourneyIDX = '" &  DEC_TourneyIdx & "'"
'Response.Write "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL : " & LSQL & "<br/>"

Set LRs = DBCon.Execute(LSQL)
If Not (LRs.Eof Or LRs.Bof) Then
  Do Until LRs.Eof
    tTourneyIDX = LRs("TourneyIDX")
    tTourneyRequestIDX = LRs("RequestIDX")
    tTourneyGroupIDX = LRs("TourneyGroupIDX")
    tGameLevelDtlidx = LRs("GameLevelDtlidx")
    LRs.MoveNext
  Loop
End If
LRs.close
'Response.Write "tTourneyIDX : " & tTourneyIDX & "<br/>"
'Response.Write "tTourneyRequestIDX : " & tTourneyRequestIDX & "<br/>"
'Response.Write "tTourneyGroupIDX : " & tTourneyGroupIDX & "<br/>"


LSQL = " SELECT A.GameTitleIDX, B.TEamGb, B.Level, A.LevelDtlName, B.Sex, B.GroupGameGb, A.TotRound, B.GameLevelIDX,B.PlayType,"
LSQL = LSQL & "  CASE WHEN TotRound = '512' THEN '9' "
LSQL = LSQL & "  WHEN TotRound = '256' THEN '8' "
LSQL = LSQL & "  WHEN TotRound = '128' THEN '7' "
LSQL = LSQL & "  WHEN TotRound = '64' THEN '6' "
LSQL = LSQL & "  WHEN TotRound = '32' THEN '5' "
LSQL = LSQL & "  WHEN TotRound = '16' THEN '4' "
LSQL = LSQL & "  WHEN TotRound = '8' THEN '3' "
LSQL = LSQL & "  WHEN TotRound = '4' THEN '2' "
LSQL = LSQL & "  WHEN TotRound = '2' THEN '1' "
LSQL = LSQL & "  Else '0' END AS GangCnt"
LSQL = LSQL & " FROM tblGameLevelDtl A"
LSQL = LSQL & " INNER JOIN tblGameLevel B ON A.GameLevelidx = B.GameLevelIDX"
LSQL = LSQL & " WHERE A.DelYN = 'N'"
LSQL = LSQL & " AND B.DelYN = 'N'"
LSQL = LSQL & " AND GameLevelDtlidx = '" & tGameLevelDtlidx & "'"

Set LRs = Dbcon.Execute(LSQL)

If Not (LRs.Eof Or LRs.Bof) Then
  tGameTitleIDX = LRs("GameTitleIDX")
  tTeamGb = LRs("TEamGb")
  tLevel = LRs("Level")
  tLevelDtlName = LRs("LevelDtlName")     
  tSex = LRs("Sex") 
  tGroupGameGb = LRs("GroupGameGb") 
  tTotRound = LRs("TotRound") 
  tGangCnt = LRs("GangCnt") 
  tGameLevelIDX = LRs("GameLevelIDX") 
  tPlayType= LRs("PlayType") 
Else
  Response.Write "[오류]"
  Response.END
End If

LRs.Close


LSQL = "SELECT ISNULL(TourneyGroupIDX,'0') AS TourneyGroupIDX "
LSQL = LSQL & " FROM  tblTourneyGroup "
LSQL = LSQL & " WHERE DelYN ='N' and TourneyGroupIDX = '" &  tTourneyGroupIDX & "'"
'Response.Write "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL : " & LSQL & "<br/>"

Set LRs = DBCon.Execute(LSQL)
If Not (LRs.Eof Or LRs.Bof) Then
  Do Until LRs.Eof
    SelTourneyGroupIDX = LRs("TourneyGroupIDX")
    LRs.MoveNext
  Loop
End If
LRs.close

LSQL = "SELECT ISNULL(GameRequestGroupIDX,'0') AS GameRequestGroupIDX "
LSQL = LSQL & " FROM tblGameRequestGroup "
LSQL = LSQL & " WHERE DelYN ='N' and GameRequestGroupIDX = '" &  DEC_RequestIdx & "'"
'Response.Write "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL : " & LSQL & "<br/>"

Set LRs = DBCon.Execute(LSQL)
If Not (LRs.Eof Or LRs.Bof) Then
  Do Until LRs.Eof
    SelGameRequestGroupIDX = LRs("GameRequestGroupIDX")
    LRs.MoveNext
  Loop
End If
LRs.close



'Response.Write "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL : " & LSQL & "<br/>"
'-----------------New Member------------------------------
LSQL = " SELECT MemberIDX, MemberName, Team, TeamDtl, Team_Origin "
LSQL = LSQL & " FROM tblGameRequestPlayer "
LSQL = LSQL & " WHERE DelYN ='N' and GameRequestGroupIDX = '" &  DEC_RequestIdx & "'"
'Response.Write "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL : " & LSQL & "<br/>"
Set LRs = DBCon.Execute(LSQL)
If Not (LRs.Eof Or LRs.Bof) Then
  Do Until LRs.Eof
    GameRequestPlayerCnt = GameRequestPlayerCnt + 1
    IF CDBL(GameRequestPlayerCnt) = 1 Then
      New_MemberIDX = LRs("MemberIDX")
      New_UserName = LRs("MemberName")
      New_Team = LRs("Team")
      New_TeamDtl = LRs("TeamDtl")
      New_Team_Origin = LRs("Team_Origin")
    ELSEIF CDBL(GameRequestPlayerCnt) = 2 Then
      New_MemberIDX2 = LRs("MemberIDX")
      New_UserName2 = LRs("MemberName")
      New_Team2 = LRs("Team")
      New_TeamDtl2 = LRs("TeamDtl")
      New_Team_Origin2 = LRs("Team_Origin")
    End IF
    LRs.MoveNext
  Loop
End If
LRs.close

IF CDBL(GameRequestPlayerCnt) > 2 Then
  Call oJSONoutput.Set("result", 2 )
  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.End
End IF



'Response.Write "tMemberIDX : " & New_MemberIDX  & " , "
'Response.Write "tUserName : " & New_UserName  & " , "
'Response.Write "tTeam : " & New_Team & " , "
'Response.Write "tTeamDtl : " & New_TeamDtl & " , "  
'Response.Write "tTeam_Origin : " & New_Team_Origin  & "<br/>"
'Response.Write "tMemberIDX2 : " & New_MemberIDX2  & " , "
'Response.Write "tUserName2 : " & New_UserName2  & " , "
'Response.Write "tTeam2 : " & New_Team2 & " , "
'Response.Write "tTeamDtl2 : " & New_TeamDtl2& " , "  
'Response.Write "tTeam_Origin2 : " & New_Team_Origin2  & "<br/>"



'------------------------New Member------------------------------
  LSQL = "SELECT MemberIdx, UserName, Team, TeamDtl, Team_Origin, TourneyPlayerIDX"
  LSQL = LSQL & " FROM  tblTourneyPlayer "
  LSQL = LSQL & " WHERE DelYN ='N' and TourneyGroupIDX = '" &  tTourneyGroupIDX & "'"
  Set LRs = DBCon.Execute(LSQL)

  TourneyPlayerCnt = 0  

  IF NOT (LRs.Eof Or LRs.Bof) Then
    arrTourneyPlayers = LRs.getrows()
  End If

  If IsArray(arrTourneyPlayers) Then
    TourenyPlayerCnt = UBound(arrTourneyPlayers,2)  + 1 
    '복식이면서 TourenyPlayerCnt가 하나밖에 없을 경우
    IF tPlayType = "B0020002" And cdbl(TourenyPlayerCnt) = CDBL(1) Then
      LSQL = "SET NOCOUNT ON"
      LSQL = LSQL & " INSERT INTO dbo.tblTourneyPlayer ("
      LSQL = LSQL & " TourneyGroupIDX, MemberIDX, GameTitleIDX, UserName, TeamGb, GameLevelDtlidx, Level, LevelDtlName, Sex, MemberNum,CourtPosition, Team, TeamDtl, Team_Origin"
      LSQL = LSQL & " )"
      LSQL = LSQL & " VALUES ("
      LSQL = LSQL & " '" & tTourneyGroupIDX & "'"
      LSQL = LSQL & " ,'" & New_MemberIDX2 & "'"
      LSQL = LSQL & " ,'" & tGameTitleIDX & "'"
      LSQL = LSQL & " ,'" & New_UserName2 & "'"
      LSQL = LSQL & " ,'" & tTeamGb & "'"
      LSQL = LSQL & " ,'" & tGameLevelDtlidx & "'"
      LSQL = LSQL & " ,'" & tLevel & "'"
      LSQL = LSQL & " ,'" & tLevelDtlName & "'"
      LSQL = LSQL & " ,'" & tSex & "'"
      LSQL = LSQL & " ,'0'"
      LSQL = LSQL & " ,NULL"
      LSQL = LSQL & " ,'" & New_Team2 & "'"
      LSQL = LSQL & " ,'" & New_TeamDtl2 & "'"
      LSQL = LSQL & " ,'" & New_Team_Origin2 & "'"
      LSQL = LSQL & " );"
      LSQL = LSQL & " SELECT @@IDENTITY AS IDX"
      Dbcon.Execute(LSQL)
      IsUpdateAndInsert = "true"
    END IF

    For ar = LBound(arrTourneyPlayers, 2) To UBound(arrTourneyPlayers, 2) 
      TourneyPlayerCnt = TourneyPlayerCnt + 1 
      'tMemberIdx = arrTourneyPlayers(0, ar)
      'tUserName = arrTourneyPlayers(1, ar)
      'tTeam = arrTourneyPlayers(2, ar)
      'tTeamDtl = arrTourneyPlayers(3, ar)
      'tTeam_Origin = arrTourneyPlayers(4, ar)
      tTourneyPlayerIDX = arrTourneyPlayers(5, ar)
      IF CDBL(TourneyPlayerCnt) = 1 Then
        LSQL = " UPDATE tblTourneyPlayer "
        LSQL = LSQL & " 	SET MemberIDX =	'" & New_MemberIDX  & "'," 
        LSQL = LSQL & " 	UserName =	'" & New_UserName   & "'," 
        LSQL = LSQL & " 	Team =	'" & New_Team  & "'," 
        LSQL = LSQL & " 	TeamDtl =	'" & New_TeamDtl  & "'," 
        LSQL = LSQL & " 	Team_Origin =	'" & New_Team_Origin  & "'" 
        LSQL = LSQL & " WHERE TourneyPlayerIDX = '" & tTourneyPlayerIDX & "'" 
        'Response.Write "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL : " & LSQL & "<br/>"
        Dbcon.Execute(LSQL)
        IsUpdateAndInsert = "true"
      ELSEIF  CDBL(TourneyPlayerCnt) = 2 Then
        LSQL = " UPDATE tblTourneyPlayer "
        LSQL = LSQL & " 	SET MemberIDX =	'" & New_MemberIDX2 & "'," 
        LSQL = LSQL & " 	UserName =	'" & New_UserName2 & "'," 
        LSQL = LSQL & " 	Team =	'" & New_Team2 & "'," 
        LSQL = LSQL & " 	TeamDtl =	'" & New_TeamDtl2 & "'," 
        LSQL = LSQL & " 	Team_Origin =	'" & New_Team_Origin2 & "'" 
        LSQL = LSQL & " WHERE TourneyPlayerIDX = '" & tTourneyPlayerIDX & "'" 
        'Response.Write "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL : " & LSQL & "<br/>"
        Dbcon.Execute(LSQL)
        IsUpdateAndInsert = "true"
      END IF
    Next
  ELSE
  'TourenyPlayerCnt가 없을 경우
    For i = 1 To Cdbl(GameRequestPlayerCnt)
      IF cdbl(i) = 1 Then
        'Response.Write "tTourneyGroupIDX" & tTourneyGroupIDX & "<br/>" 
        'Response.Write "tMemberIDX : " & New_MemberIDX  & " , "
        'Response.Write "tUserName : " & New_UserName  & " , "
        'Response.Write "tTeam : " & New_Team & " , "
        'Response.Write "tTeamDtl : " & New_TeamDtl & " , "  
        'Response.Write "tTeam_Origin : " & New_Team_Origin  & "<br/>"

        LSQL = "SET NOCOUNT ON"
        LSQL = LSQL & " INSERT INTO dbo.tblTourneyPlayer ("
        LSQL = LSQL & " TourneyGroupIDX, MemberIDX, GameTitleIDX, UserName, TeamGb, GameLevelDtlidx, Level, LevelDtlName, Sex, MemberNum, CourtPosition, Team, TeamDtl, Team_Origin"
        LSQL = LSQL & " )"
        LSQL = LSQL & " VALUES ("
        LSQL = LSQL & " '" & tTourneyGroupIDX & "'"
        LSQL = LSQL & " ,'" & New_MemberIDX & "'"
        LSQL = LSQL & " ,'" & tGameTitleIDX & "'"
        LSQL = LSQL & " ,'" & New_UserName & "'"
        LSQL = LSQL & " ,'" & tTeamGb & "'"
        LSQL = LSQL & " ,'" & tGameLevelDtlidx & "'"
        LSQL = LSQL & " ,'" & tLevel & "'"
        LSQL = LSQL & " ,'" & tLevelDtlName & "'"
        LSQL = LSQL & " ,'" & tSex & "'"
        LSQL = LSQL & " ,'0'"
        LSQL = LSQL & " ,NULL"
        LSQL = LSQL & " ,'" & New_Team & "'"
        LSQL = LSQL & " ,'" & New_TeamDtl & "'"
        LSQL = LSQL & " ,'" & New_Team_Origin & "'"
        LSQL = LSQL & " );"
        LSQL = LSQL & " SELECT @@IDENTITY AS IDX"
        Dbcon.Execute(LSQL)
        IsUpdateAndInsert = "true"
        'Response.Write "LSQL : " & LSQL  & "<br/>"
      ELSEIF  cdbl(i) = 2 Then 
        'Response.Write "tTourneyGroupIDX" & tTourneyGroupIDX & "<br/>" 
        'Response.Write "tMemberIDX2 : " & New_MemberIDX2  & " , "
        'Response.Write "tUserName2 : " & New_UserName2  & " , "
        'Response.Write "tTeam2 : " & New_Team2 & " , "
        'Response.Write "tTeamDtl2 : " & New_TeamDtl2& " , "  
        'Response.Write "tTeam_Origin2 : " & New_Team_Origin2  & "<br/>"

        LSQL = "SET NOCOUNT ON"
        LSQL = LSQL & " INSERT INTO dbo.tblTourneyPlayer ("
        LSQL = LSQL & " TourneyGroupIDX, MemberIDX, GameTitleIDX, UserName, TeamGb, GameLevelDtlidx, Level, LevelDtlName, Sex, MemberNum,CourtPosition, Team, TeamDtl, Team_Origin"
        LSQL = LSQL & " )"
        LSQL = LSQL & " VALUES ("
        LSQL = LSQL & " '" & tTourneyGroupIDX & "'"
        LSQL = LSQL & " ,'" & New_MemberIDX2 & "'"
        LSQL = LSQL & " ,'" & tGameTitleIDX & "'"
        LSQL = LSQL & " ,'" & New_UserName2 & "'"
        LSQL = LSQL & " ,'" & tTeamGb & "'"
        LSQL = LSQL & " ,'" & tGameLevelDtlidx & "'"
        LSQL = LSQL & " ,'" & tLevel & "'"
        LSQL = LSQL & " ,'" & tLevelDtlName & "'"
        LSQL = LSQL & " ,'" & tSex & "'"
        LSQL = LSQL & " ,'0'"
        LSQL = LSQL & " ,NULL"
        LSQL = LSQL & " ,'" & New_Team2 & "'"
        LSQL = LSQL & " ,'" & New_TeamDtl2 & "'"
        LSQL = LSQL & " ,'" & New_Team_Origin2 & "'"
        LSQL = LSQL & " );"
        LSQL = LSQL & " SELECT @@IDENTITY AS IDX"
        Dbcon.Execute(LSQL)
        IsUpdateAndInsert = "true"
        'Response.Write "LSQL : " & LSQL  & "<br/>"
      END IF
    Next
  End If

  IF IsUpdateAndInsert = "true"  Then
    LSQL = " UPDATE tblTourney "
    LSQL = LSQL & " 	SET RequestIDX =	'" & DEC_RequestIdx & "'" 
    LSQL = LSQL & " WHERE TourneyIDX = '" & TourneyIdx & "'" 
    Dbcon.Execute(LSQL)    
  End IF

  LRs.close

  
Call oJSONoutput.Set("result", 0 )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson

Set LRs = Nothing
DBClose()
  
%>