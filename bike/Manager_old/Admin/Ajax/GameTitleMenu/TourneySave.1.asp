<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->
<%
'<!-- include file="../Library/json2.asp" -->
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

CMD = Request("CMD")
LevelDtl = Request("LevelDtl")
RequestGroupIDX = Request("RequestGroupIDX")

'DEC_LevelDtl = fInject(crypt.DecryptStringENC(LevelDtl))
'DEC_RequestGroupIDX = fInject(crypt.DecryptStringENC(RequestGroupIDX))

DEC_LevelDtl = fInject(LevelDtl)
DEC_RequestGroupIDX = fInject(RequestGroupIDX)


'��ȸ���� �ҷ�����
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
    Response.Write "[��ȸ��������]����"
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

'����ȣ
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

'2���� ���� ������ �ִ´�. ���� �ֱ�
For i = 1 To Cint(GangCnt - 1) 

    If i > 1 Then
        BtnGang = Cint(BtnGang) / 2
    End If

    Empty_Round = Empty_Round +1

    For j = 1 TO BtnGang

        '����ȣ �����
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

Set oJSONoutput_SUM = jsArray()
Set oJSONoutput_SUM = jsObject()

oJSONoutput_SUM("CMD") = CMD
oJSONoutput_SUM("TYPE") = "JSON"
oJSONoutput_SUM("RESULT") = strjson

strjson_sum = toJSON(oJSONoutput_SUM)

Response.Write strjson_sum



Set LRs = Nothing
DBClose()
  
%>