<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->
<%

Response.ContentType = "text/html"
Response.AddHeader "Content-Type", "text/html;charset=utf-8"
Response.CodePage = "65001"
Response.CharSet = "utf-8"

'득점자 배점,감점

Dim LSQL ,SSQL
Dim LRs ,SRs
Dim strjson
Dim strjson_sum

Dim i

Dim oJSONoutput_SUM
Dim oJSONoutput

Dim CMD  
Dim GameLevelDtlidx 
Dim TourneyGroupIDX

Dim WinCnt
Dim LoseCnt
Dim Ranking

Dim strjson_dtl

CMD = Request("CMD")
GameLevelDtlIDX = Request("GameLevelDtlIDX")
TourneyGroupIDX = Request("TourneyGroupIDX")


'대회정보
DEC_GameLevelDtlIDX = fInject(GameLevelDtlIDX)
DEC_TourneyGroupIDX = fInject(TourneyGroupIDX)

''승 카운트
'LSQL = " SELECT A.GameLevelDtlidx, A.TourneyGroupIDX, B.PubType, COUNT(*) AS Cnt"
'LSQL = LSQL & " FROM tblGameResult A"
'LSQL = LSQL & " INNER JOIN tblPubcode B ON B.PubCode = A.Result"
'LSQL = LSQL & " WHERE A.DelYN = 'N'"
'LSQL = LSQL & " AND B.DelYN = 'N'"
'LSQL = LSQL & " AND A.GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
'LSQL = LSQL & " AND A.TourneyGroupIDX = '" & TourneyGroupIDX & "'"
'LSQL = LSQL & " AND PubType = 'WIN'"
'LSQL = LSQL & " GROUP BY A.GameLevelDtlidx, A.TourneyGroupIDX, B.PubType"

'Set LRs = Dbcon.Execute(LSQL)

'If Not (LRs.Eof Or LRs.Bof) Then
'    WinCnt = LRs("Cnt")
'Else
'    WinCnt = "0"
'End If

'LRs.Close


''패 카운트
'LSQL = " SELECT A.GameLevelDtlidx, A.TourneyGroupIDX, B.PubType, COUNT(*) AS Cnt"
'LSQL = LSQL & " FROM tblGameResult A"
'LSQL = LSQL & " INNER JOIN tblPubcode B ON B.PubCode = A.Result"
'LSQL = LSQL & " WHERE A.DelYN = 'N'"
'LSQL = LSQL & " AND B.DelYN = 'N'"
'LSQL = LSQL & " AND A.GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
'LSQL = LSQL & " AND A.TourneyGroupIDX = '" & TourneyGroupIDX & "'"
'LSQL = LSQL & " AND PubType = 'LOSE'"
'LSQL = LSQL & " GROUP BY A.GameLevelDtlidx, A.TourneyGroupIDX, B.PubType"

'Set LRs = Dbcon.Execute(LSQL)

'If Not (LRs.Eof Or LRs.Bof) Then
'    LoseCnt = LRs("Cnt")
'Else
'    LoseCnt = "0"
'End If

'LRs.Close

LSQL = " SELECT TourneyGroupIDX, Ranking, WinCnt, LoseCnt"
LSQL = LSQL & " FROM "
LSQL = LSQL & " 	("
LSQL = LSQL & " 	SELECT TourneyGroupIDX, ROW_NUMBER() OVER(ORDER BY SUM(WinCnt) DESC, SUM(LoseCnt) ASC) AS Ranking, "
LSQL = LSQL & " 	SUM(WinCnt) AS WinCnt, SUM(LoseCnt) AS LoseCnt"
LSQL = LSQL & " 	FROM ("
LSQL = LSQL & " 		SELECT A.TourneyGroupIDX,"
LSQL = LSQL & " 		CASE WHEN PubType = 'WIN' THEN 1 ELSE 0 END AS WinCnt,"
LSQL = LSQL & " 		CASE WHEN PubType = 'LOSE' THEN 1 ELSE 0 END AS LoseCnt"
LSQL = LSQL & " 		FROM ("
LSQL = LSQL & " 			SELECT GamelevelDtlIDX, TourneyGroupIDX, MIN(ORDERBY) AS ORDERBY"
LSQL = LSQL & " 			FROM tblTourney"
LSQL = LSQL & " 			WHERE DelYN = 'N'"
LSQL = LSQL & " 			AND GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
LSQL = LSQL & " 			GROUP BY GamelevelDtlIDX, TourneyGroupIDX"
LSQL = LSQL & " 			) AS A"
LSQL = LSQL & " 		LEFT JOIN tblGameResult B ON A.GameLevelDtlidx = B.GameLevelDtlidx AND A.TourneyGroupIDX = B.TourneyGroupIDX"
LSQL = LSQL & " 		INNER JOIN tblPubcode C ON C.PubCode = B.Result"
LSQL = LSQL & " 		AND B.DelYN = 'N'"
LSQL = LSQL & " 		) AS AA"
LSQL = LSQL & " 	GROUP BY TourneyGroupIDX"
LSQL = LSQL & " 	) AS AAA"
LSQL = LSQL & " WHERE TourneyGroupIDX = '" & TourneyGroupIDX & "'"

Set LRs = Dbcon.Execute(LSQL)

If Not (LRs.Eof Or LRs.Bof) Then
    TourneyGroupIDX = LRs("TourneyGroupIDX")
    WinCnt = LRs("WinCnt")
    LoseCnt = LRs("LoseCnt")
    Ranking = LRs("Ranking")
Else
    WinCnt = "0"
    LoseCnt = "0"
    Ranking = "0"
End If

LRs.Close


Set oJSONoutput_SUM = jsArray()
Set oJSONoutput_SUM = jsObject()


oJSONoutput_SUM("CMD") = CMD
oJSONoutput_SUM("TYPE") = "JSON"
oJSONoutput_SUM("WinCnt") = WinCnt
oJSONoutput_SUM("LoseCnt") = LoseCnt
oJSONoutput_SUM("Ranking") = Ranking


strjson_sum = toJSON(oJSONoutput_SUM)

Response.Write strjson_sum


Set LRs = Nothing
DBClose()
  
  
%>