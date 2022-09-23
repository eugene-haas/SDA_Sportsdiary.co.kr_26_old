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
Dim GameYear

Dim DEC_GameTitleIDX 
Dim DEC_GameYear

CMD = Request("CMD")
GameTitleIDX = Request("GameTitleIDX")
GameDay = Request("GameDay")

DEC_GameTitleIDX = fInject(crypt.DecryptStringENC(GameTitleIDX))

If GameDay <> "" Then
    DEC_GameDay = fInject(GameDay)
End If

Set oJSONoutput = jsArray()

'대회목록 생성
'LSQL = " SELECT StadiumIDX, StadiumName, StadiumCourt"
'LSQL = LSQL & " FROM KoreaBadminton.dbo.tblStadium "
'LSQL = LSQL & " WHERE DelYN = 'N'"
'LSQL = LSQL & " AND GameTitleIDX = '" & DEC_GameTitleIDX & "'"


LSQL = " SELECT StadiumIDX, StadiumName"
LSQL = LSQL & " FROM "
LSQL = LSQL & " ("
LSQL = LSQL & " SELECT C.StadiumIDX, C.StadiumName"
LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourney A"
LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameTitle B ON B.GameTitleIDX = A.GameTitleIDX "
LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblStadium C ON C.StadiumIDX = A.StadiumIDX"
LSQL = LSQL & " WHERE A.DelYN = 'N'"
LSQL = LSQL & " AND B.DelYN = 'N'"
LSQL = LSQL & " AND C.DelYN = 'N'"
LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
LSQL = LSQL & " AND A.GameDay = '" & DEC_GameDay & "'"
LSQL = LSQL & " AND ISNULL(C.StadiumIDX,'') <> ''"
LSQL = LSQL & " "
LSQL = LSQL & " UNION ALL"
LSQL = LSQL & " "
LSQL = LSQL & " SELECT C.StadiumIDX, C.StadiumName"
LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourneyTeam A"
LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameTitle B ON B.GameTitleIDX = A.GameTitleIDX "
LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblStadium C ON C.StadiumIDX = A.StadiumIDX"
LSQL = LSQL & " WHERE A.DelYN = 'N'"
LSQL = LSQL & " AND B.DelYN = 'N'"
LSQL = LSQL & " AND C.DelYN = 'N'"
LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
LSQL = LSQL & " AND A.GameDay = '" & DEC_GameDay & "'"
LSQL = LSQL & " AND ISNULL(C.StadiumIDX,'') <> ''"
LSQL = LSQL & " ) AS AA"
LSQL = LSQL & " GROUP BY AA.StadiumIDX, AA.StadiumName"

Set LRs = Dbcon.Execute(LSQL)

If Not (LRs.Eof Or LRs.Bof) Then

    Set oJSONoutput = jsArray()

	Do Until LRs.Eof

		Set oJSONoutput(NULL) = jsObject()

		oJSONoutput(Null)("StadiumIDX") = crypt.EncryptStringENC(LRs("StadiumIDX"))
        oJSONoutput(Null)("StadiumName") = LRs("StadiumName")        
	
	    LRs.MoveNext
	Loop

	strjson =  toJSON(oJSONoutput)

Else

End If

Set oJSONoutput_SUM = jsArray()
Set oJSONoutput_SUM = jsObject()

oJSONoutput_SUM("CMD") = CMD
oJSONoutput_SUM("TYPE") = "JSON"
oJSONoutput_SUM("RESULT") = strjson

strjson_sum = toJSON(oJSONoutput_SUM)

Response.Write strjson_sum


LRs.Close
Set LRs = Nothing
DBClose()
  
%>