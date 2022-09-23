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
GameTitleIDX = Request("GameTitleIDX")
GroupGameGb = Request("GroupGameGb")

DEC_GameTitleIDX = fInject(crypt.DecryptStringENC(GameTitleIDX))
DEC_GroupGameGb = fInject(crypt.DecryptStringENC(GroupGameGb))


Set oJSONoutput = jsArray()

'해당대회 등록된 종별
LSQL = " SELECT  Sex, PlayType, KoreaBadminton.dbo.FN_NameSch(Sex,'PubCode') AS SexName, KoreaBadminton.dbo.FN_NameSch(PlayType,'PubCode') AS PlayTypeName"
LSQL = LSQL & " FROM tblGameLevel"
LSQL = LSQL & " WHERE DelYN = 'N'"
LSQL = LSQL & " AND GameTitleIDX = '" & DEC_GameTitleIDX & "'"
LSQL = LSQL & " AND GroupGameGb = '" & DEC_GroupGameGb & "'"
LSQL = LSQL & " GROUP BY Sex, PlayType"

Set LRs = Dbcon.Execute(LSQL)

If Not (LRs.Eof Or LRs.Bof) Then

    Set oJSONoutput = jsArray()

	Do Until LRs.Eof

		Set oJSONoutput(NULL) = jsObject()

		oJSONoutput(Null)("Sex") = crypt.EncryptStringENC(LRs("Sex"))
        oJSONoutput(Null)("PlayType") = crypt.EncryptStringENC(LRs("PlayType"))
        oJSONoutput(Null)("SexName") = LRs("SexName")
        oJSONoutput(Null)("PlayTypeName") = LRs("PlayTypeName")

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