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
Dim RequestGroupIDX

Dim GameTitleIDX
Dim TeamGb
Dim Level
Dim LevelDtlName 
Dim Sex

REQ = Request("Req")
'REQ = "{""CMD"":8,""LevelDtl"":""1045"",""RequestGroupIDX"":""133,131,132,""}"

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
    Response.Write "[오류]"
    Response.END
End If

LRs.Close

CSQL = " UPDATE tblTourneyTeam SET DelYN = 'Y'"
CSQL = CSQL & " , EditDate = Getdate() "
CSQL = CSQL & " WHERE DelYN = 'N' "
CSQL = CSQL & " AND GameLevelDtlIDX = '" & DEC_LevelDtl & "'"
Dbcon.Execute(CSQL)

'CSQL = " UPDATE tblTourneyGroup SET DelYN = 'Y'"
'CSQL = CSQL & " , EditDate = Getdate() "
'CSQL = CSQL & " WHERE GameLevelDtlIDX = '" & DEC_LevelDtl & "'"
'Dbcon.Execute(CSQL)
'
'CSQL = " UPDATE tblTourneyPlayer SET DelYN = 'Y'"
'CSQL = CSQL & " , EditDate = Getdate() "
'CSQL = CSQL & " WHERE GameLevelDtlIDX = '" & DEC_LevelDtl & "'"
'Dbcon.Execute(CSQL)
'
'CSQL = " UPDATE tblTourney SET DelYN = 'Y'"
'CSQL = CSQL & " , EditDate = Getdate() "
'CSQL = CSQL & " WHERE GameLevelDtlIDX = '" & DEC_LevelDtl & "'"
'Dbcon.Execute(CSQL)

Arr_RequestTeamIDX = Split(DEC_RequestTeamIDX,",")


GameNum = 0
TourneyTeamNum = 100

For i = 0 TO UBOUND(Arr_RequestTeamIDX, 1)
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
			Else    
				Team = ""
				TeamDtl = "0"
			End If        
			Dbcon.Execute(LSQL)
    Else    
			Team = Null
			TeamDtl = "0"
    End If
   
		LSQL = " INSERT INTO dbo.tblTourneyTeam ("
		LSQL = LSQL & " RequestIDX, GameTitleIDX, GameLevelIdx, GameLevelDtlidx, TeamGb, Level, LevelDtlName, Team, TeamDtl, TeamName, "
		LSQL = LSQL & " TourneyTeamNum, Round, TeamGameNum, ORDERBY"
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
		LSQL = LSQL & " ,'" & GameNum & "'"
		LSQL = LSQL & " ,'" & ORDERBY & "'"
		LSQL = LSQL & " );"
		LSQL = LSQL & " SELECT @@IDENTITY AS IDX"

		Dbcon.Execute(LSQL) 
Next

BtnGang = Cint(TotRound) / 2
Empty_ORDERBY = TotRound
Empty_GameNum = GameNum
Empty_Round = 1


For k = 1 To Cint(GangCnt - 1) 
    If k > 1 Then
        BtnGang = Cint(BtnGang) / 2
    End If

    Empty_Round = Empty_Round +1

    For j = 1 TO BtnGang
        
        If j MOD 2 = 1 Then
            Empty_GameNum = Empty_GameNum + 1
        End If

        Empty_ORDERBY = Empty_ORDERBY + 1

        LSQL = " INSERT INTO dbo.tblTourneyTeam ("
        LSQL = LSQL & " GameTitleIDX, GameLevelIdx, GameLevelDtlidx, TeamGb, Level, LevelDtlName,"
        LSQL = LSQL & " TourneyTeamNum, Round, TeamGameNum, ORDERBY"
        LSQL = LSQL & " )"
        LSQL = LSQL & " VALUES ("
        LSQL = LSQL & " '" & GameTitleIDX & "'"
        LSQL = LSQL & " ,'" & GameLevelIDX & "'"
        LSQL = LSQL & " ,'" & DEC_LevelDtl & "'"
        LSQL = LSQL & " ,'" & TeamGb & "'"
        LSQL = LSQL & " ,'" & Level & "'"
        LSQL = LSQL & " ,'" & LevelDtlName & "'"
        LSQL = LSQL & " ,NULL"
        LSQL = LSQL & " ,'" & Empty_Round & "'"
        LSQL = LSQL & " ,'" & Empty_GameNum & "'"
        LSQL = LSQL & " ,'" & Empty_ORDERBY & "'"
        LSQL = LSQL & " );"
        LSQL = LSQL & " SELECT @@IDENTITY AS IDX"
        'Response.Write "LSQL : "  & LSQL & "<br/>"

        Dbcon.Execute(LSQL)   

    Next


Next

Call oJSONoutput.Set("result", 0 )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson


Set LRs = Nothing
DBClose()
  
%>