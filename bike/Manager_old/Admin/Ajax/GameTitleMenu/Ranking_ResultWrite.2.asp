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
'단체전 경기결과 입력

  REQ = Request("Req")
  'REQ = "{""tGameTitleIdx"":""BF242F3A46C5952F1DF14D02620F1AB7"",""CMD"":7,""tGroupGameGb"":""B4E57B7A4F9D60AE9C71424182BA33FE"",""tTeamGb"":""8A578417CC8014056D9834A4E56D712C"",""tPlayTypeSex"":""9313C11726C4F47D4859E9CC91CA6DAA|"",""tLevel"":"""",""arr_STR_Grade"":""4,,,,1,,,,3,,,,2,,,"",""arr_STR_Team"":""BA00392,BA00088,BA00389,BA00076,BA00394,BA00395,BA00393,BA00391,BA00052,BA00038,BA00213,BA00118,BA00388,BA00390,BA00078,BA00358"",""arr_STR_TeamDtl"":""0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0""}"

  Set oJSONoutput = JSON.Parse(REQ)
  reqGameTitleIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameTitleIdx))
  crypt_reqGameTitleIdx =crypt.EncryptStringENC(tGameTitleIdx)

  If hasown(oJSONoutput, "tGroupGameGb") = "ok" then
    reqGroupGameGb = fInject(crypt.DecryptStringENC(oJSONoutput.tGroupGameGb))
    crypt_reqGroupGameGb =crypt.EncryptStringENC(reqGroupGameGb)
  Else
    reqGroupGameGb = "B0030001" ' 개인전(B0030001), 단체전(B0030002)
    crypt_reqGroupGameGb = crypt.EncryptStringENC(reqGroupGameGb)
  End if	

  If hasown(oJSONoutput, "tTeamGb") = "ok" then
    reqTeamGb = fInject(crypt.DecryptStringENC(oJSONoutput.tTeamGb))
    crypt_reqTeamGb =crypt.EncryptStringENC(reqTeamGb)
  End if	

  If hasown(oJSONoutput, "tPlayTypeSex") = "ok" then
    reqPlayTypeSex= fInject(oJSONoutput.tPlayTypeSex)
    If InStr(reqPlayTypeSex,"|") > 1 Then
      arr_reqPlayTypeSex = Split(reqPlayTypeSex,"|")
      reqSex = fInject(crypt.DecryptStringENC(arr_reqPlayTypeSex(0)))
      reqPlayType = fInject(crypt.DecryptStringENC(arr_reqPlayTypeSex(1)))
    End if
  End if	

  If hasown(oJSONoutput, "tLevel") = "ok" then
    reqLevel= fInject(oJSONoutput.tLevel)
    'reqLevel = "FE25E609214EB0FC01BC8651577120A1|2B4F14AE43DBCAD1D5BFD3285CE3A249|1"
    If InStr(reqLevel,"|") > 1 Then
      arr_reqLevel = Split(reqLevel,"|")
      reqLevel = fInject(crypt.DecryptStringENC(arr_reqLevel(0)))
      reqLevelJooName = fInject(crypt.DecryptStringENC(arr_reqLevel(1)))
      reqLevelJooNum = arr_reqLevel(2)
    End if
  End if	

  If hasown(oJSONoutput, "arr_STR_Grade") = "ok" then
    arr_STR_Grade= fInject(oJSONoutput.arr_STR_Grade)
  End if	

  If hasown(oJSONoutput, "arr_STR_Team") = "ok" then
    arr_STR_Team= fInject(oJSONoutput.arr_STR_Team)
  End if	

  If hasown(oJSONoutput, "arr_STR_TeamDtl") = "ok" then
    arr_STR_TeamDtl= fInject(oJSONoutput.arr_STR_TeamDtl)
  End if	      

LSQL = " SELECT GameLevelDtlIDX,"
LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(A.Sex, 'PubCode') AS SexName,"
LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(A.PlayType, 'PubCode') AS PlayTypeName,"
LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(A.TeamGb, 'TeamGb') AS TeamGbName,"
LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(A.Level, 'Level') AS LevelName,"
LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(A.LevelJooName,'PubCode') AS LevelJooName, A.LevelJooNum, B.LevelJooNum AS LevelJooNumDtl,  B.LevelDtlName, "
LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(B.GameType,'PubCode') AS GameTypeName, "
LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(B.PlayLevelType,'PubCode') AS PlayLevelTypeName,"
LSQL = LSQL & " B.PlayLevelType,"
LSQL = LSQL & " A.GameType"
LSQL = LSQL & " FROM tblGameLevel A"
LSQL = LSQL & " INNER JOIN tblGameLevelDtl B ON B.GameLevelidx = A.GameLevelIDX"
LSQL = LSQL & " WHERE A.DelYN = 'N'"
LSQL = LSQL & " AND B.DelYN = 'N'"
LSQL = LSQL & " AND B.PlayLevelType = 'B0100001'"

If reqGameTitleIdx <> "" Then
    LSQL = LSQL & " AND A.GameTitleIDX = '" & reqGameTitleIdx & "' "
End If

If reqGroupGameGb <> "" Then
    LSQL = LSQL & " AND A.GroupGameGb = '" & reqGroupGameGb & "' "
End If

If reqTeamGb <> "" AND reqTeamGb <> "0" Then
    LSQL = LSQL & " AND A.TeamGb = '" & reqTeamGb & "' "
End If

If reqSex <> "" AND reqSex <> "0" Then
    LSQL = LSQL & " AND A.Sex = '" & reqSex & "' "
End If

If reqPlayType <> "" AND reqPlayType <> "0" Then
    LSQL = LSQL & " AND A.PlayType = '" & reqPlayType & "' "
End If

If reqLevel <> "" AND reqLevel <> "0" Then
    LSQL = LSQL & " AND A.Level = '" & reqLevel & "' "
End If

If reqLevelJooName <> "" AND reqLevelJooName <> "0" Then
    LSQL = LSQL & " AND A.LevelJooName = '" & reqLevelJooName & "' "
End If

If reqLevelJooNum <> "" AND reqLevelJooNum <> "0" Then
    LSQL = LSQL & " AND A.LevelJooNum = '" & reqLevelJooNum & "' "
End If  

Set LRs = Dbcon.Execute(LSQL)

If Not (LRs.Eof Or LRs.Bof) Then
  Arr_Info = LRs.getrows()
End If

'본선번호 구하기
LSQL = "select GameLevelidx from tblGameLevelDtl WHERE GameLevelDtlidx = '" & Arr_Info(0,0) & "'"
Set LRs = Dbcon.Execute(LSQL)
If Not (LRs.Eof Or LRs.Bof) Then
  GameLevelIDX = LRs("GameLevelidx")
End If
LRs.Close

'본선번호 구하기
LSQL = "SELECT A.GameTitleIDX, A.GameLevelDtlIDX, B.TeamGb, B.Level, A.LevelDtlName, A.TotRound "
LSQL = LSQL & " FROM tblGameLevelDtl A"
LSQL = LSQL & " INNER JOIN tblGameLevel B ON B.GameLevelIDX = A.GameLevelIDX"
LSQL = LSQL & " WHERE A.DelYN = 'N'"
LSQL = LSQL & " AND B.DelYN = 'N'"
LSQL = LSQL & " AND A.GameLevelidx = '" & GameLevelIDX & "'"
LSQL = LSQL & " AND A.PlayLevelType = 'B0100002'"
Set LRs = Dbcon.Execute(LSQL)
If Not (LRs.Eof Or LRs.Bof) Then
    bon_GameTitleIDX = LRs("GameTitleIDX")
    bon_GameLevelDtlIDX = LRs("GameLevelDtlIDX")
    bon_TeamGb = LRs("TeamGb")
    bon_Level = LRs("Level")
    bon_LevelDtlName = LRs("LevelDtlName")
    bon_TotRound = LRs("TotRound")
End If
LRs.Close

Array_Grade = Split(arr_STR_Grade,",")
Array_Team = Split(arr_STR_Team,",")
Array_TeamDtl = Split(arr_STR_TeamDtl,",")

If IsArray(Array_Grade) Then
  For i = 0 To UBOUND(Array_Grade)
    If Array_Grade(i) <> "" Then
      MSQL = "SELECT CASE WHEN MAX(TourneyTeamNum) IS NULL THEN '101' ELSE MAX(TourneyTeamNum) + 1 END AS TourneyTeamNum"
      MSQL = MSQL & " FROM KoreaBadminton.dbo.tblTourneyTeam"
      MSQL = MSQL & " WHERE DelYN = 'N'"
      MSQL = MSQL & " AND GameLevelDtlidx = '" & bon_GameLevelDtlIDX & "'"
      Set MRs = Dbcon.Execute(MSQL)
      If Not (MRs.Eof Or MRs.Bof) Then
          bon_TourneyTeamNum = MRs("TourneyTeamNum")
      End If
      MRs.Close							      

      MSQL = "SELECT AreaNum "
      MSQL = MSQL & " FROM dbo.tblGameRule"
      MSQL = MSQL & " WHERE DelYN = 'N'"
      MSQL = MSQL & " AND Gang = '" & bon_TotRound & "'"
      MSQL = MSQL & " AND JoNum = '" & Array_Grade(i) & "'"
      Set MRs = Dbcon.Execute(MSQL)
      If Not (MRs.Eof Or MRs.Bof) Then
          Do Until MRs.Eof
              CSQL = "UPDATE tblTourneyTeam SET Team = '" & Array_Team(i) & "',"
              CSQL = CSQL & " TeamDtl = '" & Array_TeamDtl(i) & "'"
              CSQL = CSQL & " WHERE DelYN = 'N'"
              CSQL = CSQL & " AND GameLevelDtlidx = '" & bon_GameLevelDtlIDX & "'"
              CSQL = CSQL & " AND ORDERBY = '" & MRs("AreaNum") & "'"     
              Dbcon.Execute(CSQL)        
              MRs.MoveNext    
          Loop
      End If
      MRs.Close
    End If
  Next
End If


Call oJSONoutput.Set("result", 0 )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson

Set LRs = Nothing
DBClose()
  
%>