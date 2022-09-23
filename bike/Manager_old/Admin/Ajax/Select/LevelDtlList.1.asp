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

LSQL = " SELECT "
LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(A.Sex, 'PubCode') AS SexName,"
LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(A.PlayType, 'PubCode') AS PlayTypeName,"
LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(A.TeamGb, 'TeamGb') AS TeamGbName,"
LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(A.Level, 'Level') AS LevelName,"
LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(A.LevelJooName,'PubCode') AS LevelJooName, A.LevelJooNum, B.LevelJooNum AS LevelJooNumDtl,  B.LevelDtlName, GameLevelDtlIDX, "
LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(B.GameType,'PubCode') AS GameTypeName, "
LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(B.PlayLevelType,'PubCode') AS PlayLevelTypeName,"
LSQL = LSQL & " B.PlayLevelType,"
LSQL = LSQL & " A.GameType"
LSQL = LSQL & " FROM tblGameLevel A"
LSQL = LSQL & " INNER JOIN tblGameLevelDtl B ON B.GameLevelidx = A.GameLevelIDX"
LSQL = LSQL & " WHERE A.DelYN = 'N'"
LSQL = LSQL & " AND B.DelYN = 'N'"

If GameTitleIDX <> "" Then
    LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "' "
End If

If GroupGameGb <> "" Then
    LSQL = LSQL & " AND A.GroupGameGb = '" & DEC_GroupGameGb & "' "
End If

If DEC_Sex <> "" AND DEC_Sex <> "0" Then
    LSQL = LSQL & " AND A.Sex = '" & DEC_Sex & "' "
End If

If DEC_PlayType <> "" AND DEC_PlayType <> "0" Then
    LSQL = LSQL & " AND A.PlayType = '" & DEC_PlayType & "' "
End If

If DEC_TeamGb <> "" AND DEC_TeamGb <> "0" Then
    LSQL = LSQL & " AND A.TeamGb = '" & DEC_TeamGb & "' "
End If

If DEC_Level <> "" AND DEC_Level <> "0" Then
    LSQL = LSQL & " AND A.Level = '" & DEC_Level & "' "
End If

If DEC_LevelJooName <> "" AND DEC_LevelJooName <> "0" Then
    LSQL = LSQL & " AND A.LevelJooName = '" & DEC_LevelJooName & "' "
End If

If DEC_LevelJooNum <> "" AND DEC_LevelJooNum <> "0" Then
    LSQL = LSQL & " AND A.LevelJooNum = '" & DEC_LevelJooNum & "' "
End If

Set LRs = Dbcon.Execute(LSQL)

If Not (LRs.Eof Or LRs.Bof) Then

    Set oJSONoutput = jsArray()

	Do Until LRs.Eof

		Set oJSONoutput(NULL) = jsObject()

        oJSONoutput(Null)("SexName") = LRs("SexName")
        oJSONoutput(Null)("PlayTypeName") = LRs("PlayTypeName")
        oJSONoutput(Null)("TeamGbName") = LRs("TeamGbName")
        oJSONoutput(Null)("LevelName") = LRs("LevelName")
        oJSONoutput(Null)("LevelJooName") = LRs("LevelJooName")
        oJSONoutput(Null)("LevelJooNum") = LRs("LevelJooNum")
        oJSONoutput(Null)("LevelJooNumDtl") = LRs("LevelJooNumDtl")
        
        oJSONoutput(Null)("LevelDtlName") = LRs("LevelDtlName")
        oJSONoutput(Null)("GameLevelDtlIDX") = LRs("GameLevelDtlIDX")

        oJSONoutput(Null)("GameTypeName") = LRs("GameTypeName")
        oJSONoutput(Null)("PlayLevelTypeName") = LRs("PlayLevelTypeName")
        oJSONoutput(Null)("PlayLevelType") = LRs("PlayLevelType")
        

        oJSONoutput(Null)("GameType") = LRs("GameType")

	    LRs.MoveNext
	Loop

    strjson =  toJSON(oJSONoutput)

Else

End If

LRs.Close



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