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

Dim DEC_StadiumIDX

CMD = Request("CMD")
GameTitleIDX = Request("GameTitleIDX")

DEC_GameTitleIDX = fInject(crypt.DecryptStringENC(GameTitleIDX))

Set oJSONoutput = jsArray()

'대회목록 생성
LSQL = " SELECT GameDay"
LSQL = LSQL & " FROM "
LSQL = LSQL & " ("
LSQL = LSQL & " SELECT GameDay"
LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourney A"
LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameTitle B ON B.GameTitleIDX = A.GameTitleIDX "
LSQL = LSQL & " WHERE A.DelYN = 'N'"
LSQL = LSQL & " AND B.DelYN = 'N'"
LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
LSQL = LSQL & " AND GameDay IS NOT NULL"
LSQL = LSQL & " "
LSQL = LSQL & " UNION ALL"
LSQL = LSQL & " "
LSQL = LSQL & " SELECT GameDay"
LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourneyTeam A"
LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameTitle B ON B.GameTitleIDX = A.GameTitleIDX "
LSQL = LSQL & " WHERE A.DelYN = 'N'"
LSQL = LSQL & " AND B.DelYN = 'N'"
LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
LSQL = LSQL & " AND GameDay IS NOT NULL"
LSQL = LSQL & " ) AS AA"
LSQL = LSQL & " GROUP BY AA.GameDay"



Set LRs = Dbcon.Execute(LSQL)

If Not (LRs.Eof Or LRs.Bof) Then

    Set oJSONoutput = jsArray()

	Do Until LRs.Eof

		Set oJSONoutput(NULL) = jsObject()

		oJSONoutput(Null)("GameDay") = LRs("GameDay")
	
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