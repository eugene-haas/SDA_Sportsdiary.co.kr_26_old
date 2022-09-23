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
Dim GroupGameGb
Dim PlayType
Dim TeamGb
Dim Level

Dim GameLevelidx

CMD = Request("CMD")
GameTitleIDX = Request("GameTitleIDX")
GroupGameGb = Request("GroupGameGb")
PlayType = Request("PlayType")
TeamGb = Request("TeamGb")
Level = Request("Level")

If InStr(PlayType,"|") < 1 Then
    Response.END
End if

If InStr(Level,"|") < 1 Then
    Response.END
End if



DEC_GameTitleIDX = fInject(crypt.DecryptStringENC(GameTitleIDX))
DEC_GroupGameGb = fInject(crypt.DecryptStringENC(GroupGameGb))
DEC_TeamGb = fInject(crypt.DecryptStringENC(TeamGb))

Arr_PlayType = Split(PlayType,"|")

DEC_Sex = fInject(crypt.DecryptStringENC(Arr_PlayType(0)))
DEC_PlayType = fInject(crypt.DecryptStringENC(Arr_PlayType(1)))

Arr_Level = Split(Level,"|")


DEC_Level = fInject(crypt.DecryptStringENC(Arr_Level(0)))
DEC_LevelJooName = fInject(crypt.DecryptStringENC(Arr_Level(1)))
DEC_LevelJooNum = Arr_Level(2)

Set oJSONoutput = jsArray()

LSQL = " SELECT GameLevelidx"
LSQL = LSQL & " FROM tblGameLevel "
LSQL = LSQL & " WHERE DelYN = 'N' "
LSQL = LSQL & " AND GameTitleIDX = '" & DEC_GameTitleIDX & "' "
LSQL = LSQL & " AND GroupGameGb = '" & DEC_GroupGameGb & "' "
LSQL = LSQL & " AND Sex = '" & DEC_Sex & "' "
LSQL = LSQL & " AND PlayType = '" & DEC_PlayType & "' "
LSQL = LSQL & " AND TeamGb = '" & DEC_TeamGb & "' "
LSQL = LSQL & " AND Level = '" & DEC_Level & "' "
LSQL = LSQL & " AND LevelJooName = '" & DEC_LevelJooName & "' "
LSQL = LSQL & " AND LevelJooNum = '" & DEC_LevelJooNum & "' "


Set LRs = Dbcon.Execute(LSQL)

If Not (LRs.Eof Or LRs.Bof) Then

	Do Until LRs.Eof

        GameLevelidx = LRs("GameLevelidx")

	    LRs.MoveNext
	Loop

Else

End If

LRs.Close


LSQL = " SELECT KoreaBadminton.dbo.FN_NameSch(PlayLevelType,'PubCode') AS PlayLevelTypeNM, GameLevelDtlidx "
LSQL = LSQL & " FROM tblGameLevelDtl"
LSQL = LSQL & " WHERE DelYN = 'N'"
LSQL = LSQL & " AND GameLevelidx = '" & GameLevelidx & "'"



Set LRs = Dbcon.Execute(LSQL)

If Not (LRs.Eof Or LRs.Bof) Then

    Set oJSONoutput = jsArray()

	Do Until LRs.Eof

		Set oJSONoutput(NULL) = jsObject()

        oJSONoutput(Null)("PlayLevelTypeNM") = LRs("PlayLevelTypeNM")	
		oJSONoutput(Null)("GameLevelDtlidx") = crypt.EncryptStringENC(LRs("GameLevelDtlidx"))
        oJSONoutput(Null)("GameLevelDtlidx_DEV") = LRs("GameLevelDtlidx")
        
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