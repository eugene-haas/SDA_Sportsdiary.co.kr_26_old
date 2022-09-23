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
'REQ = "{""CMD"":7,""LevelDtl"":""997"",""RequestGroupIDX"":""4039,4045,4054"",""LeagueGameNum"":""1,2|1,3|2,3""}"

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
      RequestGroupIDX = ""
      DEC_RequestGroupIDX = ""
    Else
      RequestGroupIDX = fInject(oJSONoutput.RequestGroupIDX)
      DEC_RequestGroupIDX = fInject(oJSONoutput.RequestGroupIDX)    
    End If
  Else  
    RequestGroupIDX = ""
    DEC_RequestGroupIDX = ""
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


CSQL = " UPDATE tblTourneyGroup SET DelYN = 'Y'"
CSQL = CSQL & " , EditDate = Getdate() "
CSQL = CSQL & " WHERE GameLevelDtlIDX = '" & DEC_LevelDtl & "'"
Dbcon.Execute(CSQL)

CSQL = " UPDATE tblTourneyPlayer SET DelYN = 'Y'"
CSQL = CSQL & " , EditDate = Getdate() "
CSQL = CSQL & " WHERE GameLevelDtlIDX = '" & DEC_LevelDtl & "'"
Dbcon.Execute(CSQL)

CSQL = " UPDATE tblTourney SET DelYN = 'Y'"
CSQL = CSQL & " , EditDate = Getdate() "
CSQL = CSQL & " WHERE GameLevelDtlIDX = '" & DEC_LevelDtl & "'"
Dbcon.Execute(CSQL)

Arr_RequestGroupIDX = Split(DEC_RequestGroupIDX,",")


GameNum = 0
TourneyGroupNum = 100

For i = 0 TO UBOUND(Arr_RequestGroupIDX,1)

    TourneyGroupIDX = "0"

    TourneyNum = 100 + (i + 1)
    ORDERBY = (i + 1)


    If ORDERBY MOD 2 = 1 Then
        GameNum = GameNum + 1
    End If

    If Arr_RequestGroupIDX(i) <> "" Then

        TourneyGroupNum = TourneyGroupNum + 1

        LSQL = "SET NOCOUNT ON"
        LSQL = LSQL & " INSERT INTO dbo.tblTourneyGroup ("
        LSQL = LSQL & " GameTitleIDX, TeamGb, GameLevelDtlidx, Level, LevelDtlName, Team, TeamDtl, TourneyGroupNum"
        LSQL = LSQL & " )"
        LSQL = LSQL & " VALUES ("
        LSQL = LSQL & " '" & GameTitleIDX & "'"
        LSQL = LSQL & " ,'" & TeamGb & "'"
        LSQL = LSQL & " ,'" & LevelDtl & "'"
        LSQL = LSQL & " ,'" & Level & "'"
        LSQL = LSQL & " ,'" & LevelDtlName & "'"
        LSQL = LSQL & " ,NULL"
        LSQL = LSQL & " ,'0'"
        LSQL = LSQL & " ,'" & TourneyGroupNum  & "'"
        LSQL = LSQL & " );"
        LSQL = LSQL & " SELECT @@IDENTITY AS IDX"

        Set LRs = Dbcon.Execute(LSQL)

        If Not (LRs.Eof Or LRs.Bof) Then

	        Do Until LRs.Eof

                TourneyGroupIDX =  LRs("IDX")
            
                LRs.MoveNext            
            Loop

        End If

        LRs.Close

        LSQL = "SET NOCOUNT ON"
        LSQL = LSQL & " INSERT INTO dbo.tblTourneyPlayer"
        LSQL = LSQL & " ("
        LSQL = LSQL & " TourneyGroupIDX, MemberIDX, GameTitleIDX, UserName, TeamGb"
        LSQL = LSQL & " , GameLevelDtlidx, Level, LevelDtlName, Sex, MemberNum"
        LSQL = LSQL & " , CourtPosition, Team, TeamDtl, Team_Origin"
        LSQL = LSQL & " )"
        LSQL = LSQL & " SELECT '" & TourneyGroupIDX & "', A.MemberIDX, '" & GameTitleIDX & "', A.MemberName, '" & TeamGb & "'"
        LSQL = LSQL & " , '" & LevelDtl & "', '" & Level & "', '" & LevelDtlName & "', '" & Sex & "', 0"
        LSQL = LSQL & " , NULL, A.Team, A.TeamDtl, A.Team_Origin"
        LSQL = LSQL & " FROM dbo.tblGameRequestPlayer A"
        LSQL = LSQL & " INNER JOIN dbo.tblGameRequestTouney B ON B.RequestIDX = A.GameRequestGroupIDX"
        LSQL = LSQL & " WHERE A.DelYN = 'N'"
        LSQL = LSQL & " AND B.DelYN = 'N'"
        LSQL = LSQL & " AND B.GroupGameGb = 'B0030001'"
        LSQL = LSQL & " AND B.GameLevelDtlIDX = '" & LevelDtl & "'"
        LSQL = LSQL & " AND A.GameRequestGroupIDX = '" & Arr_RequestGroupIDX(i) & "'"

        Dbcon.Execute(LSQL)

    End If

    LSQL = "INSERT INTO dbo.tblTourney("
	LSQL = LSQL & " TourneyGroupIDX, GameTitleIDX, GameLevelDtlidx, TeamGb, Level,"
    LSQL = LSQL & " LevelDtlName, GroupGameGb, TourneyNum, Round, TeamGameNum, GameNum, ORDERBY, GameLevelIDX"
    LSQL = LSQL & " )"
    LSQL = LSQL & " VALUES"
    LSQL = LSQL & " ("
    LSQL = LSQL & " '" & TourneyGroupIDX & "','" & GameTitleIDX & "', '" & DEC_LevelDtl & "', '" & TeamGb & "', '" & Level & "',"
    LSQL = LSQL & " '" & LevelDtlName & "','" & GroupGameGb & "', '" & TourneyNum & "', '1', '0', '" & GameNum & "', '" & ORDERBY & "', '" & GameLevelIDX & "'"
    LSQL = LSQL & " )"

    Dbcon.Execute(LSQL)

Next

BtnGang = Cint(TotRound) / 2

Empty_ORDERBY = TotRound
Empty_GameNum = GameNum
Empty_Round = 1


For i = 1 To Cint(GangCnt - 1) 

    If i > 1 Then
        BtnGang = Cint(BtnGang) / 2
    End If

    Empty_Round = Empty_Round +1

    For j = 1 TO BtnGang

        
        If j MOD 2 = 1 Then
            Empty_GameNum = Empty_GameNum + 1
        End If

        Empty_ORDERBY = Empty_ORDERBY + 1

        

        LSQL = "INSERT INTO dbo.tblTourney("
	    LSQL = LSQL & " TourneyGroupIDX, GameTitleIDX, GameLevelDtlidx, TeamGb, Level,"
        LSQL = LSQL & " LevelDtlName, GroupGameGb, TourneyNum, Round, TeamGameNum, GameNum, ORDERBY, GameLevelIDX"
        LSQL = LSQL & " )"
        LSQL = LSQL & " VALUES"
        LSQL = LSQL & " ("
        LSQL = LSQL & " '0','" & GameTitleIDX & "', '" & DEC_LevelDtl & "', '" & TeamGb & "', '" & Level & "',"
        LSQL = LSQL & " '" & LevelDtlName & "','" & GroupGameGb & "', NULL, '" & Empty_Round & "', '0', '" & Empty_GameNum & "', '" & Empty_ORDERBY & "', '" & GameLevelIDX & "'"
        LSQL = LSQL & " )"

        Dbcon.Execute(LSQL)   

    Next


Next

Call oJSONoutput.Set("result", 0 )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson


Set LRs = Nothing
DBClose()
  
%>