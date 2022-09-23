<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->
<%

'득점자 배점,감점

Dim LSQL ,SSQL
Dim LRs ,SRs
Dim strjson
Dim strjson_sum

Dim i
Dim strWinType
Dim strDualType

Dim oJSONoutput_SUM
Dim oJSONoutput

Dim CMD  
Dim GameLevelDtlidx 
Dim TeamGameNum
Dim GameNum

Dim TourneyGroupIDX1
Dim TourneyGroupIDX2

Dim strjson_dtl
Dim strjson_dtl2
Dim strjson_dtl3

CMD = Request("CMD")
GameLevelDtlIDX = Request("GameLevelDtlIDX")
TeamGameNum = Request("TeamGameNum")
GameNum = Request("GameNum")


If GameNum = "" Then
    Response.END
End If


'대회정보
DEC_GameLevelDtlIDX = fInject(GameLevelDtlIDX)
DEC_TeamGameNum = fInject(TeamGameNum)
DEC_GameNum = fInject(GameNum)


LSQL = " SELECT A.TourneyGroupIDX, dbo.FN_NameSch(Result, 'PubType') AS WinType, dbo.FN_NameSch(Result, 'PubCode') AS ResultNM, Jumsu,"
LSQL = LSQL & " KoreaBadminton.dbo.FN_1GameWinPoint(A.GameLevelDtlidx, A.TourneyGroupIDX, A.TeamGameNum, A.GameNum) AS DtlJumsu"
LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourney A "
LSQL = LSQL & " LEFT JOIN "
LSQL = LSQL & "         ("
LSQL = LSQL & "         SELECT GameLevelDtlidx, TourneyGroupIDX, TeamGameNum, GameNum, Result, Jumsu"
LSQL = LSQL & "         FROM KoreaBadminton.dbo.tblGameResult"
LSQL = LSQL & "         WHERE DelYN = 'N'"
LSQL = LSQL & "         ) B ON A.GameLevelDtlidx = B.GameLevelDtlidx AND A.TourneyGroupIDX = B.TourneyGroupIDX AND A.TeamGameNum = B.TeamGameNum AND A.GameNum = B.GameNum"
LSQL = LSQL & " WHERE A.DelYN = 'N'"
LSQL = LSQL & " AND A.GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
LSQL = LSQL & " AND A.TeamGameNum = '" & DEC_TeamGameNum & "'"
LSQL = LSQL & " AND A.GameNum = '" & DEC_GameNum & "'"
LSQL = LSQL & " ORDER BY A.TourneyNum "

Set LRs = Dbcon.Execute(LSQL)

If Not (LRs.Eof Or LRs.Bof) Then

    Set oJSONoutput = jsArray()

    i = 0

    Do Until LRs.Eof

        Set oJSONoutput(NULL) = jsObject()


        If i = 0 Then
            strWinType = LRs("ResultNM")
            TourneyGroupIDX1 = LRs("TourneyGroupIDX")
        Else

            If strWinType = LRs("ResultNM") Then
                strDualType = "Y"
            End If

            TourneyGroupIDX2 = LRs("TourneyGroupIDX")
        End If

        oJSONoutput(NULL)("TourneyGroupIDX") = LRs("TourneyGroupIDX")
        oJSONoutput(NULL)("WinType") = LRs("WinType")
        oJSONoutput(NULL)("ResultNM") = LRs("ResultNM")
        oJSONoutput(NULL)("Jumsu") = LRs("Jumsu")
        oJSONoutput(NULL)("DtlJumsu") = LRs("DtlJumsu")

        i = i + 1

        LRs.MoveNext
    Loop

    If strDualType = "Y" THen
        oJSONoutput(NULL)("WinTypeResult") = "양선수 " & strWinType
    Else
        oJSONoutput(NULL)("WinTypeResult") = strWinType
    End If

    strjson_dtl2 = toJSON(oJSONoutput)

End If

LRs.Close


Set oJSONoutput_SUM = jsArray()
Set oJSONoutput_SUM = jsObject()


oJSONoutput_SUM("CMD") = CMD
oJSONoutput_SUM("TYPE") = "JSON"
oJSONoutput_SUM("GAMERESULT") = strjson_dtl2


'oJSONoutput_SUM("SSQL") = SSQL


strjson_sum = toJSON(oJSONoutput_SUM)

Response.Write strjson_sum

Set LRs = Nothing
DBClose()
  
%>