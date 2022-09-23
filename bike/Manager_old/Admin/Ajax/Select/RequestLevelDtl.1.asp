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
Dim GameTitleIDX 

CMD = Request("CMD")
GameLevelDtlIDX = Request("GameLevelDtlIDX")


'DEC_Request = fInject(crypt.DecryptStringENC(GameLevelDtlIDX))

DEC_GameLevelDtlIDX = fInject(GameLevelDtlIDX)

LSQL = " SELECT A.TotRound, A.GameType, B.GroupGameGb, "
LSQL = LSQL & "  CASE WHEN A.TotRound = '512' THEN '9' "
LSQL = LSQL & "  WHEN A.TotRound = '256' THEN '8' "
LSQL = LSQL & "  WHEN A.TotRound = '128' THEN '7' "
LSQL = LSQL & "  WHEN A.TotRound = '64' THEN '6' "
LSQL = LSQL & "  WHEN A.TotRound = '32' THEN '5' "
LSQL = LSQL & "  WHEN A.TotRound = '16' THEN '4' "
LSQL = LSQL & "  WHEN A.TotRound = '8' THEN '3' "
LSQL = LSQL & "  WHEN A.TotRound = '4' THEN '2' "
LSQL = LSQL & "  WHEN A.TotRound = '2' THEN '1' "
LSQL = LSQL & "  Else '0' END AS GangCnt"
LSQL = LSQL & " FROM tblGameLeveldtl A"
LSQL = LSQL & " INNER JOIN tblGameLevel B ON B.GameLevelidx = A.GameLevelidx"
LSQL = LSQL & " WHERE A.DelYN = 'N'"
LSQL = LSQL & " AND A.GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"


Set LRs = Dbcon.Execute(LSQL)

If Not (LRs.Eof Or LRs.Bof) Then
    
    Do Until LRs.Eof

		TotRound = LRs("TotRound")
        GangCnt = LRs("GangCnt")
        GameType = LRs("GameType")
        GroupGameGb = LRs("GroupGameGb")

	  LRs.MoveNext
	Loop
Else

End If



LSQL = " SELECT GameRequestGroupIDX,"
LSQL = LSQL & " CASE WHEN CHARINDEX('|',LPlayers) > 0 THEN LEFT(LPlayers,CHARINDEX('|',LPlayers)-1) ELSE LPlayers END  AS Player1, "
LSQL = LSQL & " CASE WHEN CHARINDEX('|',LPlayers) > 0 THEN RIGHT(LPlayers,CHARINDEX('|',REVERSE(LPlayers))-1) ELSE '' END  AS Player2, "
LSQL = LSQL & " CASE WHEN CHARINDEX('|',LTeams) > 0 THEN LEFT(LTeams,CHARINDEX('|',LTeams)-1) ELSE LTeams END AS Team1,"
LSQL = LSQL & " CASE WHEN CHARINDEX('|',LTeams) > 0 THEN RIGHT(LTeams,CHARINDEX('|',REVERSE(LTeams))-1) ELSE '' END AS Team2"
LSQL = LSQL & " FROM"
LSQL = LSQL & " ("
LSQL = LSQL & " SELECT A.GameRequestGroupIDX,"
LSQL = LSQL & " STUFF(("
LSQL = LSQL & "         SELECT  DISTINCT (  "
LSQL = LSQL & "             SELECT  '|'   + MemberName "
LSQL = LSQL & "             FROM    KoreaBadminton.dbo.tblGameRequestPlayer  "
LSQL = LSQL & "             WHERE   DelYN = 'N' AND GameRequestGroupIDX    = AAA.GameRequestGroupIDX  "
LSQL = LSQL & "             FOR XML PATH('')  "
LSQL = LSQL & "             )  "
LSQL = LSQL & "         FROM    KoreaBadminton.dbo.tblGameRequestPlayer AAA  "
LSQL = LSQL & "         WHERE DelYN = 'N' AND AAA.GameRequestGroupIDX = A.GameRequestGroupIDX"
LSQL = LSQL & "         ),1,1,'') AS LPlayers"
LSQL = LSQL & " ,STUFF(("
LSQL = LSQL & "         SELECT  DISTINCT (  "
LSQL = LSQL & "             SELECT  '|'   + dbo.FN_NameSch(Team,'Team')"
LSQL = LSQL & "             FROM    KoreaBadminton.dbo.tblGameRequestPlayer  "
LSQL = LSQL & "             WHERE   DelYN = 'N' AND GameRequestGroupIDX    = AAA.GameRequestGroupIDX  "
LSQL = LSQL & "             FOR XML PATH('')  "
LSQL = LSQL & "             )  "
LSQL = LSQL & "         FROM    KoreaBadminton.dbo.tblGameRequestPlayer AAA  "
LSQL = LSQL & "         WHERE DelYN = 'N' AND AAA.GameRequestGroupIDX = A.GameRequestGroupIDX "
LSQL = LSQL & "         ),1,1,'') AS LTeams"
LSQL = LSQL & " FROM dbo.tblGameRequestGroup A"
LSQL = LSQL & " INNER JOIN dbo.tblGameRequestTouney B ON B.RequestIDX = A.GameRequestGroupIDX"
LSQL = LSQL & " WHERE A.DelYN = 'N'"
LSQL = LSQL & " AND B.DelYN = 'N'"
LSQL = LSQL & " AND B.GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "'"
LSQL = LSQL & " ) AS AA"

Set LRs = Dbcon.Execute(LSQL)

If Not (LRs.Eof Or LRs.Bof) Then

    Set oJSONoutput = jsArray()

	Do Until LRs.Eof

		Set oJSONoutput(NULL) = jsObject()

		oJSONoutput(Null)("GameRequestGroupIDX") = LRs("GameRequestGroupIDX")
        oJSONoutput(Null)("Player1") = LRs("Player1")
        oJSONoutput(Null)("Player2") = LRs("Player2")
        oJSONoutput(Null)("Team1") = LRs("Team1")
        oJSONoutput(Null)("Team2") = LRs("Team2")

	    LRs.MoveNext
	Loop

	strjson =  toJSON(oJSONoutput)

Else

End If



Set oJSONoutput_SUM = jsArray()
Set oJSONoutput_SUM = jsObject()

oJSONoutput_SUM("CMD") = CMD
oJSONoutput_SUM("TYPE") = "JSON"
oJSONoutput_SUM("TotRound") = TotRound
oJSONoutput_SUM("GangCnt") = GangCnt
oJSONoutput_SUM("GameType") = GameType
oJSONoutput_SUM("GroupGameGb") = GroupGameGb
oJSONoutput_SUM("RESULT") = strjson

strjson_sum = toJSON(oJSONoutput_SUM)

Response.Write strjson_sum


LRs.Close
Set LRs = Nothing
DBClose()
  
%>