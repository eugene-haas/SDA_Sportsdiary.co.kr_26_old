<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->
<script language="Javascript" runat="server">

function hasown(obj,  prop){
	if (obj.hasOwnProperty(prop) == true){
		return "ok";
	}
	else{
		return "notok";
	}
}

</script>

<%
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

REQ = Request("Req")
'REQ = "{""CMD"":1,""GameTitleIDX"":""0B5EB9CEFAF1E107711072C78C2E36F8"",""GroupGameGb"":""F9A43D4DE4191C125B08095CC465CD4B"",""PlayType"":""9313C11726C4F47D4859E9CC91CA6DAA|A932F76713F8A9728D92A52C4795E4B7"",""TeamGb"":""2F9A5AB5A680D3EDDEE944350E247FCB"",""Level"":""13C75B262D4231E234F8EBBA4A58E54E|E957A65AA606B07B84BB4FB0AAD1EA4D|"",""SelType"":4}"
Set oJSONoutput = JSON.Parse(REQ)


If hasown(oJSONoutput, "GameTitleIDX") = "ok" then
  GameTitleIDX = fInject(oJSONoutput.GameTitleIDX)
  DEC_GameTitleIDX = fInject(crypt.DecryptStringENC(oJSONoutput.GameTitleIDX))
Else  
  GameTitleIDX = ""
  DEC_GameTitleIDX = ""
End if	

If hasown(oJSONoutput, "GroupGameGb") = "ok" then
  GroupGameGb = fInject(oJSONoutput.GroupGameGb)
  DEC_GroupGameGb = fInject(crypt.DecryptStringENC(oJSONoutput.GroupGameGb))
Else  
  GroupGameGb = ""
  DEC_GroupGameGb = ""
End if	

If hasown(oJSONoutput, "PlayType") = "ok" then
  PlayType = fInject(oJSONoutput.PlayType)
  DEC_PlayType = fInject(crypt.DecryptStringENC(oJSONoutput.PlayType))
Else  
  PlayType = ""
  DEC_PlayType = ""
End if	

If hasown(oJSONoutput, "TeamGb") = "ok" then
  TeamGb = fInject(oJSONoutput.TeamGb)
  DEC_TeamGb = fInject(crypt.DecryptStringENC(oJSONoutput.TeamGb))
Else  
  TeamGb = ""
  DEC_TeamGb = ""
End if	

If hasown(oJSONoutput, "Level") = "ok" then
  Level = fInject(oJSONoutput.Level)
  DEC_Level = fInject(crypt.DecryptStringENC(oJSONoutput.Level))
Else  
  Level = ""
  DEC_Level = ""
End if	


If InStr(PlayType,"|") < 1 Then
    Response.END
End if

If InStr(Level,"|") < 1 Then
    Response.END
End if


Arr_PlayType = Split(PlayType,"|")

DEC_Sex = fInject(crypt.DecryptStringENC(Arr_PlayType(0)))
DEC_PlayType = fInject(crypt.DecryptStringENC(Arr_PlayType(1)))

Arr_Level = Split(Level,"|")

DEC_Level = fInject(crypt.DecryptStringENC(Arr_Level(0)))
DEC_LevelJooName = fInject(crypt.DecryptStringENC(Arr_Level(1)))
DEC_LevelJooNum = Arr_Level(2)

strjson = JSON.stringify(oJSONoutput)
Response.Write strjson
Response.write "`##`"

LSQL = " SELECT "
LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(A.Sex, 'PubCode') AS SexName,"
LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(A.PlayType, 'PubCode') AS PlayTypeName,"
LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(A.TeamGb, 'TeamGb') AS TeamGbName,"
LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(A.Level, 'Level') AS LevelName,"
LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(A.LevelJooName,'PubCode') AS LevelJooName, A.LevelJooNum, B.LevelJooNum AS LevelJooNumDtl, B.LevelDtlName, GameLevelDtlIDX, "
LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(B.GameType,'PubCode') AS GameTypeName, "
LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(B.PlayLevelType,'PubCode') AS PlayLevelTypeName,"
LSQL = LSQL & " B.PlayLevelType,"
LSQL = LSQL & " A.GameType, B.GameType AS GameTypeDtl"
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

%>
<select id="sel_LevelDtl">
<%
If Not (LRs.Eof Or LRs.Bof) Then

    Set oJSONoutput = jsArray()

	Do Until LRs.Eof

        StrLevelName = ""

        '예선일떄..
        If LRs("PlayLevelType") = "B0100001" Then
            StrLevelName = LRs("SexName") & " " & LRs("PlayTypeName") & " " & LRs("TeamGbName") & " " & LRs("LevelName") & " " & LRs("LevelJooName") & " " & LRs("LevelJooNum") & " " & LRs("LevelJooNumDtl") & "조" 
        '본선일때
        Else
            StrLevelName = LRs("SexName") & " " & LRs("PlayTypeName") & " " & LRs("TeamGbName") & " " & LRs("LevelName") & " " & LRs("LevelJooName") & " " & LRs("LevelJooNum") 
        End If
%>
    <option value="<%=crypt.EncryptStringENC(LRs("GameLevelDtlIDX"))%>|<%=crypt.EncryptStringENC(LRs("GameTypeDtl"))%>"><%=StrLevelName%></option>
<%



	    LRs.MoveNext
	Loop

    strjson =  toJSON(oJSONoutput)

Else
%>
    <option value="">대진표 없음</option>
<%
End If

LRs.Close

Set LRs = Nothing
DBClose()
  
%>
</select>