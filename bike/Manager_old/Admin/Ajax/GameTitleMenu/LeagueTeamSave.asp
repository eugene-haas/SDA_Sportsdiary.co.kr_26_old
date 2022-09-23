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
Dim LSQL
Dim LRs
Dim strjson
Dim strjson_sum

Dim oJSONoutput_SUM
Dim oJSONoutput

Dim CMD  
Dim LevelDtl
Dim RequestTeamIDX

Dim GameTitleIDX
Dim TeamGb
Dim Level
Dim LevelDtlName 
Dim Sex

Dim Arr_LGameNum
Dim Arr_LGameNum_Dtl

REQ = Request("Req")
'REQ = "{""CMD"":7,""LevelDtl"":""1044"",""RequestGroupIDX"":""117,119,121"",""LeagueGameNum"":""1,2|1,3|2,3""}"

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

If hasown(oJSONoutput, "RequestGroupIDX") = "ok" then
    If ISNull(oJSONoutput.RequestGroupIDX) Or oJSONoutput.RequestGroupIDX = "" Then
      RequestTeamIDX = ""
      DEC_RequestTeamIDX = ""
    Else
      RequestTeamIDX = fInject(oJSONoutput.RequestGroupIDX)
      DEC_RequestTeamIDX = fInject(oJSONoutput.RequestGroupIDX)    
    End If
  Else  
    RequestTeamIDX = ""
    DEC_RequestTeamIDX = ""
End if	

If hasown(oJSONoutput, "LeagueGameNum") = "ok" then
    If ISNull(oJSONoutput.LeagueGameNum) Or oJSONoutput.LeagueGameNum = "" Then
      LeagueGameNum = ""
      DEC_LeagueGameNum = ""
    Else
      LeagueGameNum = fInject(oJSONoutput.LeagueGameNum)
      DEC_LeagueGameNum = fInject(oJSONoutput.LeagueGameNum)    
    End If
  Else  
    LeagueGameNum = ""
    DEC_LeagueGameNum = ""
End if	




If inSTR(DEC_LeagueGameNum,"|") < 1 Then
    Response.Write "오류1"
    Response.END
ENd If

Arr_LGameNum = Split(DEC_LeagueGameNum,"|")

'
LSQL = " SELECT A.GameTitleIDX, B.TEamGb, B.Level, A.LevelDtlName, B.Sex, B.GroupGameGb, A.TotRound, B.GameLevelIDX,"
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
LSQL = LSQL & " AND GameLevelDtlidx = '" & DEC_LevelDtl & "'"

Set LRs = Dbcon.Execute(LSQL)

If Not (LRs.Eof Or LRs.Bof) Then
    GameTitleIDX = LRs("GameTitleIDX")
    TeamGb = LRs("TEamGb")
    Level = LRs("Level")
    LevelDtlName = LRs("LevelDtlName")     
    Sex = LRs("Sex") 
    GroupGameGb = LRs("GroupGameGb") 
    TotRound = LRs("TotRound") 
    GangCnt = LRs("GangCnt") 
    GameLevelIDX = LRs("GameLevelIDX") 
    
Else
    Response.Write "[없음]"
    Response.END
End If

LRs.Close


CSQL = " UPDATE tblTourneyTeam SET DelYN = 'Y'"
CSQL = CSQL & " , EditDate = Getdate() "
CSQL = CSQL & " WHERE DelYN = 'N' "
CSQL = CSQL & " AND GameLevelDtlIDX = '" & DEC_LevelDtl & "'"
Dbcon.Execute(CSQL)

CSQL = " UPDATE tblTourneyGroup SET DelYN = 'Y'"
CSQL = CSQL & " , EditDate = Getdate() "
CSQL = CSQL & " WHERE DelYN = 'N' "
CSQL = CSQL & " AND GameLevelDtlIDX = '" & DEC_LevelDtl & "'"
Dbcon.Execute(CSQL)

CSQL = " UPDATE tblTourneyPlayer SET DelYN = 'Y'"
CSQL = CSQL & " , EditDate = Getdate() "
CSQL = CSQL & " WHERE DelYN = 'N' "
CSQL = CSQL & " AND GameLevelDtlIDX = '" & DEC_LevelDtl & "'"
Dbcon.Execute(CSQL)

CSQL = " UPDATE tblTourney SET DelYN = 'Y'"
CSQL = CSQL & " , EditDate = Getdate() "
CSQL = CSQL & " WHERE DelYN = 'N' "
CSQL = CSQL & " AND GameLevelDtlIDX = '" & DEC_LevelDtl & "'"
Dbcon.Execute(CSQL)

Arr_RequestTeamIDX = Split(DEC_RequestTeamIDX,",")


GameNum = 0
TourneyTeamNum = 100



For i = 0 TO UBOUND(Arr_RequestTeamIDX,1)

    TourneyGroupIDX = "0"

    TourneyNum = 100 + (i + 1)
    ORDERBY = (i + 1)


    If ORDERBY MOD 2 = 1 Then
        GameNum = GameNum + 1
    End If

    If Arr_RequestTeamIDX(i) <> "" Then

        TourneyTeamNum = TourneyTeamNum + 1

        LSQL = "SELECT Team, TeamDtl "
        LSQL = LSQL & " FROM tblGameRequestGroup "
        LSQL = LSQL & " WHERE DelYN = 'N' AND GameRequestTeamIDX = '" & Arr_RequestTeamIDX(i) & "'"    

        Set LRs = Dbcon.Execute(LSQL)

        If Not (LRs.Eof Or LRs.Bof) Then

	        Do Until LRs.Eof

                Team = LRs("Team")
                TeamDtl = LRs("TeamDtl")

                LRs.MoveNext
            Loop
        End If

        LRs.Close        

        'LSQL = "SET NOCOUNT ON"
        'LSQL = LSQL & " INSERT INTO dbo.tblTourneyGroup ("
        'LSQL = LSQL & " GameTitleIDX, TeamGb, GameLevelDtlidx, Level, LevelDtlName, Team, TeamDtl, TourneyGroupNum"
        'LSQL = LSQL & " )"
        'LSQL = LSQL & " VALUES ("
        'LSQL = LSQL & " '" & GameTitleIDX & "'"
        'LSQL = LSQL & " ,'" & TeamGb & "'"
        'LSQL = LSQL & " ,'" & LevelDtl & "'"
        'LSQL = LSQL & " ,'" & Level & "'"
        'LSQL = LSQL & " ,'" & LevelDtlName & "'"
        'LSQL = LSQL & " ,'" & Team & "'"
        'LSQL = LSQL & " ,'" & TeamDtl & "'"
        'LSQL = LSQL & " ,'" & TourneyTeamNum & "'"
        'LSQL = LSQL & " );"
        'LSQL = LSQL & " SELECT @@IDENTITY AS IDX"
 
        'Set LRs = Dbcon.Execute(LSQL)
 
        'If Not (LRs.Eof Or LRs.Bof) Then
 
 
        '        TourneyGroupIDX =  LRs("IDX")
        '    
        '        LRs.MoveNext            
        '    Loop
 
        'End If
        'LRs.Close
 
        'LSQL = "SET NOCOUNT ON"
        'LSQL = LSQL & " INSERT INTO dbo.tblTourneyPlayer"
        'LSQL = LSQL & " ("
        'LSQL = LSQL & " TourneyGroupIDX, MemberIDX, GameTitleIDX, UserName, TeamGb"
        'LSQL = LSQL & " , GameLevelDtlidx, Level, LevelDtlName, Sex, MemberNum"
        'LSQL = LSQL & " , CourtPosition, Team, TeamDtl, Team_Origin"
        'LSQL = LSQL & " )"
        'LSQL = LSQL & " SELECT '" & TourneyGroupIDX & "', A.MemberIDX, '" & GameTitleIDX & "', A.MemberName, '" & TeamGb & "'"
        'LSQL = LSQL & " , '" & LevelDtl & "', '" & Level & "', '" & LevelDtlName & "', '" & Sex & "', 0"
        'LSQL = LSQL & " , NULL, A.Team, A.TeamDtl, A.Team_Origin"
        'LSQL = LSQL & " FROM dbo.tblGameRequestPlayer A"
        'LSQL = LSQL & " INNER JOIN dbo.tblGameRequestTouney B ON B.RequestIDX = A.GameRequestTeamIDX"
        'LSQL = LSQL & " WHERE A.DelYN = 'N'"
        'LSQL = LSQL & " AND B.DelYN = 'N'"
        'LSQL = LSQL & " AND B.GroupGameGb = 'B0030002'"
        'LSQL = LSQL & " AND B.GameLevelDtlIDX = '" & LevelDtl & "'"
        'LSQL = LSQL & " AND A.GameRequestTeamIDX = '" & Arr_RequestTeamIDX(i) & "'"

        'Dbcon.Execute(LSQL)

    End If

  
    Arr_LGameNum_Dtl = Split(Arr_LGameNum(i),",")


    For j = 0 To UBOUND(Arr_LGameNum_Dtl,1)

        'LSQL = "SET NOCOUNT ON"
        'LSQL = LSQL & " INSERT INTO dbo.tblTourneyGroup ("
        'LSQL = LSQL & " GameTitleIDX, GameLevelIdx, GameLevelDtlidx, TeamGb, Level, LevelDtlName, Team, TeamDtl"
        'LSQL = LSQL & " , TeamName, TourneyTeamNum, Round, TeamGameNum, ORDERBY, DelYN"
        'LSQL = LSQL & " )"
        'LSQL = LSQL & " VALUES ("

        'SELECT A.GameRequestTeamIDX, A.Team, A.TeamDtl, A.TeamName
        'FROM dbo.tblGameRequestTeam A
        'INNER JOIN dbo.tblGameRequestTouney B ON B.RequestIDX = A.GameRequestTeamIDX
        'WHERE A.DelYN = 'N'
        'AND B.DelYN = 'N'
        'AND B.GroupGameGb = 'B0030002'
        'AND B.GameLevelDtlIDX = '1044'
        'AND A.GameRequestTEamIDX = '117'

        LSQL = " INSERT INTO dbo.tblTourneyTeam ("
        LSQL = LSQL & " RequestIDX, GameTitleIDX, GameLevelIdx, GameLevelDtlidx, TeamGb, Level, LevelDtlName, Team, TeamDtl"
        LSQL = LSQL & " , TeamName, TourneyTeamNum, Round, TeamGameNum, ORDERBY"
        LSQL = LSQL & " )"
        LSQL = LSQL & " VALUES ("
        LSQL = LSQL & " '" & Arr_RequestTeamIDX(i) & "'"
        LSQL = LSQL & " ,'" & GameTitleIDX & "'"
        LSQL = LSQL & " ,'" & GameLevelIDX & "'"
        LSQL = LSQL & " ,'" & DEC_LevelDtl & "'"
        LSQL = LSQL & " ,'" & TeamGb & "'"
        LSQL = LSQL & " ,'" & Level & "'"
        LSQL = LSQL & " ,'" & LevelDtlName & "'"
        LSQL = LSQL & " ,'" & Team & "'"
        LSQL = LSQL & " ,'" & TeamDtl & "'"
        LSQL = LSQL & " ,dbo.FN_NameSch('" & Team & "','Team')"
        LSQL = LSQL & " ,'" & TourneyNum & "'"
        LSQL = LSQL & " ,'1'"
        LSQL = LSQL & " ,'" & Arr_LGameNum_Dtl(j) & "'"
        LSQL = LSQL & " ,'" & ORDERBY & "'"
        LSQL = LSQL & " );"
        LSQL = LSQL & " SELECT @@IDENTITY AS IDX"


        Dbcon.Execute(LSQL)
    
    Next

    LSQL = "UPDATE dbo.tblTourneyTeam"
    LSQL = LSQL & " SET ORDERBY = ("
    LSQL = LSQL & " 				SELECT rn"
    LSQL = LSQL & " 				FROM (SELECT TourneyTeamIDX"
    LSQL = LSQL & " 							, ROW_NUMBER() OVER(ORDER BY CONVERT(int,TeamGameNum), TourneyTeamNum) rn"
    LSQL = LSQL & " 						 FROM dbo.tblTourneyTeam"
    LSQL = LSQL & " 						 WHERE DelYN = 'N'"
    LSQL = LSQL & " 						 AND GameLevelDtlIDX = '" & DEC_LevelDtl & "'"
    LSQL = LSQL & " 					   ) AS B"
    LSQL = LSQL & " 				WHERE B.TourneyTeamIDX = C.TourneyTeamIDX"
    LSQL = LSQL & "                )"
    LSQL = LSQL & " FROM dbo.tblTourneyTeam C "
    LSQL = LSQL & " WHERE C.DelYN = 'N'"
    LSQL = LSQL & " AND C.GameLevelDtlIDX = '" & DEC_LevelDtl & "'"

    Dbcon.Execute(LSQL)


Next

Call oJSONoutput.Set("result", 0 )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson

Set LRs = Nothing
DBClose()
  
%>