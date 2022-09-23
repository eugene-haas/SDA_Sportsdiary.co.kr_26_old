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
PlayType = Request("PlayType")
TeamGb = Request("TeamGb")

If InStr(PlayType,"|") < 1 Then
    Response.END
End if



DEC_GameTitleIDX = fInject(crypt.DecryptStringENC(GameTitleIDX))
DEC_GroupGameGb = fInject(crypt.DecryptStringENC(GroupGameGb))
DEC_TeamGb = fInject(crypt.DecryptStringENC(TeamGb))

Arr_PlayType = Split(PlayType,"|")

DEC_Sex = fInject(crypt.DecryptStringENC(Arr_PlayType(0)))
DEC_PlayType = fInject(crypt.DecryptStringENC(Arr_PlayType(1)))

Set oJSONoutput = jsArray()


LSQL = " SELECT Level, KoreaBadminton.dbo.FN_NameSch(Level,'Level') AS LevelNM , KoreaBadminton.dbo.FN_NameSch(leveljooName, 'PubCode') AS LevelJooNM, LevelJooName,"
LSQL = LSQL & " LevelJooNum "
LSQL = LSQL & " FROM tblGameLevel "
LSQL = LSQL & " WHERE DelYN = 'N' "
LSQL = LSQL & " AND UseYN = 'Y' "
LSQL = LSQL & " AND GameTitleIDX = '" & DEC_GameTitleIDX & "' "
LSQL = LSQL & " AND GroupGameGb = '" & DEC_GroupGameGb & "' "
LSQL = LSQL & " AND Sex = '" & DEC_Sex & "' "
LSQL = LSQL & " AND PlayType = '" & DEC_PlayType & "' "
LSQL = LSQL & " AND TeamGb = '" & DEC_TeamGb & "' "
LSQL = LSQL & " GROUP BY Level, leveljooName, LevelJooNum"

Set LRs = Dbcon.Execute(LSQL)

If Not (LRs.Eof Or LRs.Bof) Then

    Set oJSONoutput = jsArray()

	Do Until LRs.Eof

		Set oJSONoutput(NULL) = jsObject()

		oJSONoutput(Null)("Level") = crypt.EncryptStringENC(LRs("Level"))
        oJSONoutput(Null)("LevelNM") = LRs("LevelNM")	
        oJSONoutput(Null)("LevelJooNM") = LRs("LevelJooNM")	
        oJSONoutput(Null)("LevelJooName") = crypt.EncryptStringENC(LRs("LevelJooName"))
        oJSONoutput(Null)("LevelJooNum") = LRs("LevelJooNum")	
        
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