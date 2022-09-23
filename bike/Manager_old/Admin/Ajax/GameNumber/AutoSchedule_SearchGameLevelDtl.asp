
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
  Const PersonGame = "B0030001"
  Const GroupGame = "B0030002"
  REQ = Request("Req")
  'REQ = "{""CMD"":3,""tGameTitleIDX"":""4C17525A0C3BEAA2DEA4CCDA9A2A664A"",""tGroupGameGb"":""B0030002"",""tTeamGb"":""empty"",""tLevelJooName"":""empty"",""tLevel"":""empty"",""tPlayLevelType"":""empty""}"
  Set oJSONoutput = JSON.Parse(REQ)

  If hasown(oJSONoutput, "tGameTitleIDX") = "ok" then
    If ISNull(oJSONoutput.tGameTitleIDX) Or oJSONoutput.tGameTitleIDX = "" Then
      GameTitleIDX = ""
      DEC_GameTitleIDX = ""
    Else
      GameTitleIDX = fInject(oJSONoutput.tGameTitleIDX)
      DEC_GameTitleIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tGameTitleIDX))    
    End If
  End if 

  If hasown(oJSONoutput, "tGroupGameGb") = "ok" then
    If ISNull(oJSONoutput.tGroupGameGb) Or oJSONoutput.tGroupGameGb = "" Then
      GroupGameGb = const_Empty
      DEC_GroupGameGb = const_Empty
    Else
      GroupGameGb = fInject(oJSONoutput.tGroupGameGb)
      DEC_GroupGameGb =  fInject(oJSONoutput.tGroupGameGb)
    End If
  Else
    GroupGameGb = const_Empty
    DEC_GroupGameGb = const_Empty
  End if 

  If hasown(oJSONoutput, "tTeamGb") = "ok" then
    If ISNull(oJSONoutput.tTeamGb) Or oJSONoutput.tTeamGb = "" Then
      TeamGb = ""
      DEC_TeamGb = ""
    Else
      TeamGb = fInject(oJSONoutput.tTeamGb)
      DEC_TeamGb =  fInject(oJSONoutput.tTeamGb)
    End If
  End if 
  
  
  If hasown(oJSONoutput, "tLevelJooName") = "ok" then
    If ISNull(oJSONoutput.tLevelJooName) Or oJSONoutput.tLevelJooName = "" Then
      LevelJooName = ""
      DEC_LevelJooName = ""
    Else
      LevelJooName = fInject(oJSONoutput.tLevelJooName)
      DEC_LevelJooName =  fInject(oJSONoutput.tLevelJooName)   
    End If
  End if

  If hasown(oJSONoutput, "tLevel") = "ok" then
    If ISNull(oJSONoutput.tLevel) Or oJSONoutput.tLevel = "" Then
      Level = ""
      DEC_Level = ""
    Else
      Level = fInject(oJSONoutput.tLevel)
      DEC_Level =  fInject(oJSONoutput.tLevel)   
    End If
  End if
   

   If hasown(oJSONoutput, "tPlayLevelType") = "ok" then
    If ISNull(oJSONoutput.tPlayLevelType) Or oJSONoutput.tPlayLevelType = "" Then
      PlayLevelType = ""
      DEC_PlayLevelType = ""
    Else
      PlayLevelType = fInject(oJSONoutput.tPlayLevelType)
      DEC_PlayLevelType =  fInject(oJSONoutput.tPlayLevelType)   
    End If
  End if
  Dim tGameLevelDtlidx : tGameLevelDtlidx = ""
  LSQL = " SELECT Sum(TourneyCnt) as TourneyCnt"
  LSQL = LSQL & " FROM "
  LSQL = LSQL & " ("
  LSQL = LSQL & " SELECT Count(*) as TourneyCnt "
  LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourney A"
  LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameLevel B ON A.GameLevelIdx = B.GameLevelIdx AND B.DelYN ='N' "
  LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl C ON A.GameLevelDtlidx = C.GameLevelDtlidx AND C.DelYN ='N' "
  LSQL = LSQL & " WHERE A.DelYN = 'N'"
  LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"

  IF DEC_GroupGameGb <> "empty" Then
    LSQL = LSQL & " AND B.GroupGameGb = '" & DEC_GroupGameGb & "'"
  End IF  

  IF DEC_TeamGb <> "empty" Then
    LSQL = LSQL & " AND A.TeamGb = '" & DEC_TeamGb & "'"
  End IF

  IF DEC_LevelJooName <> "empty" Then
    LSQL = LSQL & " AND B.LevelJooName = '" & DEC_LevelJooName & "'"
  End IF

  IF DEC_Level <> "empty" Then
    LSQL = LSQL & " AND A.Level = '" & DEC_Level & "'"
  End IF

  IF DEC_PlayLevelType <> "empty" Then
    LSQL = LSQL & " AND C.PlayLevelType = '" & DEC_PlayLevelType & "'"
  End IF

  LSQL = LSQL & " "
  LSQL = LSQL & " UNION ALL"
  LSQL = LSQL & " "
  LSQL = LSQL & " SELECT Count(*) as TourneyCnt "
  LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourneyTeam A"
  LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameLevel B ON A.GameLevelIdx = B.GameLevelIdx AND B.DelYN ='N' "
  LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl C ON A.GameLevelDtlidx = C.GameLevelDtlidx AND C.DelYN ='N' "
  LSQL = LSQL & " WHERE A.DelYN = 'N'"
  LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"

  IF DEC_GroupGameGb <> "empty" Then
    LSQL = LSQL & " AND B.GroupGameGb = '" & DEC_GroupGameGb & "'"
  End IF  

  IF DEC_TeamGb <> "empty" Then
    LSQL = LSQL & " AND A.TeamGb = '" & DEC_TeamGb & "'"
  End IF

  IF DEC_LevelJooName <> "empty" Then
    LSQL = LSQL & " AND B.LevelJooName = '" & DEC_LevelJooName & "'"
  End IF

  IF DEC_Level <> "empty" Then
    LSQL = LSQL & " AND A.Level = '" & DEC_Level & "'"
  End IF

  IF DEC_PlayLevelType <> "empty" Then
    LSQL = LSQL & " AND C.PlayLevelType = '" & DEC_PlayLevelType & "'"
  End IF

  LSQL = LSQL & " ) AS AA"
  LSQL = LSQL & " GROUP BY AA.GameLevelDtlidx"
  Dim tTourneyCnt : tTourneyCnt=  0

  Set LRs = Dbcon.Execute(LSQL)
  If Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
        tTourneyCnt =  LRs("TourneyCnt") 
      LRs.MoveNext
    Loop
    
  End If
  LRs.Close

  Call oJSONoutput.Set("TourneyCnt", tTourneyCnt )
	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
  'Response.Write "LSQL" & LSQL & "<BR/>"
  'Response.Write "DEC_GameTitleIDX : " & DEC_GameTitleIDX & "<br/>"
  'Response.Write "DEC_GroupGameGb : " &DEC_GroupGameGb & "<br/>"
  'Response.Write "DEC_TeamGb : " &DEC_TeamGb & "<br/>"
  'Response.Write "DEC_LevelJooName : " &DEC_LevelJooName & "<br/>"
  'Response.Write "DEC_Level : " &DEC_Level & "<br/>"
  'Response.Write "DEC_PlayLevelType : " & DEC_PlayLevelType & "<br/>"
  'Response.Write "tGameLevelDtlidx : " & tGameLevelDtlidx & "<br/>"

%>       
<%
  DBClose()
%>
  
