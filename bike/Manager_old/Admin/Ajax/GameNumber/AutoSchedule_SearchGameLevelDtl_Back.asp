
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
  REQ = "{""CMD"":3,""tGameTitleIDX"":""4C17525A0C3BEAA2DEA4CCDA9A2A664A"",""tGroupGameGb"":""B0030002"",""tTeamGb"":""empty"",""tLevelJooName"":""empty"",""tLevel"":""empty"",""tPlayLevelType"":""empty""}"
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
  LSQL = " SELECT GameLevelDtlidx "
  LSQL = LSQL & " FROM "
  LSQL = LSQL & " ("
  LSQL = LSQL & " SELECT C.GameLevelDtlidx "
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
  LSQL = LSQL & " SELECT C.GameLevelDtlidx "
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
  

  Set LRs = Dbcon.Execute(LSQL)
  If Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
        tGameLevelDtlidx = tGameLevelDtlidx & "_" & LRs("GameLevelDtlidx") 
      LRs.MoveNext
    Loop
  End If
  LRs.Close

  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"
  'Response.Write "LSQL" & LSQL & "<BR/>"
  'Response.Write "DEC_GameTitleIDX : " & DEC_GameTitleIDX & "<br/>"
  'Response.Write "DEC_GroupGameGb : " &DEC_GroupGameGb & "<br/>"
  'Response.Write "DEC_TeamGb : " &DEC_TeamGb & "<br/>"
  'Response.Write "DEC_LevelJooName : " &DEC_LevelJooName & "<br/>"
  'Response.Write "DEC_Level : " &DEC_Level & "<br/>"
  'Response.Write "DEC_PlayLevelType : " & DEC_PlayLevelType & "<br/>"
  'Response.Write "tGameLevelDtlidx : " & tGameLevelDtlidx & "<br/>"
%>       


<table cellspacing="0" cellpadding="0" id="tableGameSchedule" name="tableGameSchedule">
  <thead>
    <tr>
      <th>순서</th>
      <th>종별</th>
    </tr>
  </thead>
  <tbody>
  <%
    IF DEC_GroupGameGb = "empty" Then
      DEC_GroupGameGb = ""
    End IF

    IF DEC_TeamGb = "empty" Then
      DEC_TeamGb = ""
    End IF

    IF DEC_Level = "empty" Then
      DEC_Level = ""
    End IF

    IF DEC_LevelJooName = "empty" Then
      DEC_LevelJooName = ""
    End IF

    IF DEC_Level = "empty" Then
      DEC_Level = ""
    End IF

    IF DEC_PlayLevelType = "empty" Then
      DEC_PlayLevelType = ""
    End IF

    tTeamGbNM = "" 
    tSexNM = "" 
    tLevelNM = "" 
    tPlayTypeNM = "" 
    tLevelJooNameNM = "" 
    tLevelJooNum = "" 
    tPlayLevelTypeNM = "" 



    LSQL = " EXEC tblGameTourneyLevel_Searched_STR '" & DEC_GameTitleIDX & "', '" & DEC_GroupGameGb  & "', '" & DEC_TeamGb & "', '" &  DEC_Level & "','" &DEC_LevelJooName & "', '" & DEC_PlayLevelType & "'"
    Response.Write "LSQL : " & LSQL & "<br/>"    
    Set LRs = DBCon.Execute(LSQL)
    IF NOT (LRs.Eof Or LRs.Bof) Then
      arryGameTourneyLevel= LRs.getrows()
    End If

    If IsArray(arryGameTourneyLevel) Then
      For ar = LBound(arryGameTourneyLevel, 2) To UBound(arryGameTourneyLevel, 2) 
        tGameLevelIdx    = arryGameTourneyLevel(0, ar) 
    
      Next
    End If      
    
    
    Response.Write "LSQL : " & LSQL & "<br/>"
    Set LRs = Dbcon.Execute(LSQL)
    If Not (LRs.Eof Or LRs.Bof) Then
      Do Until LRs.Eof
      tTeamGb= LRs("TeamGb")
      tTeamGbNM= LRs("TeamGbNm")
      tSexNM = LRs("SexNM")
      tLevelNM= LRs("LevelNM")
      tPlayTypeNM = LRs("PlayTypeNM")
      tLevelJooNameNM = LRs("LevelJooNameNM")
      tLevelJooNum= LRs("LevelJooNum")
      tPlayLevelTypeNM = LRs("PlayLevelTypeNM")
      %>
      <tr>
        <td>
        <%=tTeamGb%>
          <% Response.Write tTeamGbNM & "-" & tSexNM & tPlayTypeNM  & " " & tLevelNM  & " " & tLevelJooNameNM & " " & tLevelJooNum & " " & tPlayLevelTypeNM %>
        </td>
      </tr>
      <%  
    LRs.MoveNext
      Loop
    End If
    LRs.Close
  %>

    
  </tbody>

</table>
<%
  DBClose()
%>
  
