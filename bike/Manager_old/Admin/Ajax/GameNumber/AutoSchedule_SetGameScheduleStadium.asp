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
  Const const_Empty = "empty"
  REQ = Request("Req")
  'REQ = "{""CMD"":10,""tGameTitleIDX"":""A0B63180CC3215B403232E31C8E393B4"",""tStadiumIdx"":""DBFEA0D74B3E8F60F71FF6132C0DB1AC"",""tGroupGameGb"":""B0030001"",""tTeamGb"":""16001"",""tSex"":""Mix"",""tPlayType"":""B0020002"",""tLevelJooName"":""B0110001"",""tLevel"":""empty"",""tPlayLevelType"":""empty"",""tGameDay"":""2018-07-17"",""tStartCourt"":"""",""tEndCourt"":""""}"
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

  If hasown(oJSONoutput, "tStadiumIdx") = "ok" then
    If ISNull(oJSONoutput.tStadiumIdx) Or oJSONoutput.tStadiumIdx = "" Then
      StadiumIdx = ""
      DEC_StadiumIdx = ""
    Else
      StadiumIdx = fInject(oJSONoutput.tStadiumIdx)
      DEC_StadiumIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tStadiumIdx))    
    End If
  End if 

  If hasown(oJSONoutput, "tGameDay") = "ok" then
    If ISNull(oJSONoutput.tGameDay) Or oJSONoutput.tGameDay = "" Then
      GameDay = ""
      DEC_GameDay= ""
    Else
      GameDay = fInject(oJSONoutput.tGameDay)
      DEC_GameDay = fInject(oJSONoutput.tGameDay)
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

   If hasown(oJSONoutput, "tStartCourt") = "ok" then
    If ISNull(oJSONoutput.tStartCourt) Or oJSONoutput.tStartCourt = "" Then
      StartCourt = ""
      DEC_StartCourt =""
    Else
      StartCourt = fInject(oJSONoutput.tStartCourt)
      DEC_StartCourt =  fInject(oJSONoutput.tStartCourt)   
    End If
  Else
    StartCourt = ""
    DEC_StartCourt =""
  End if

  If hasown(oJSONoutput, "tEndCourt") = "ok" then
    If ISNull(oJSONoutput.tEndCourt) Or oJSONoutput.tEndCourt = "" Then
      EndCourt = ""
      DEC_EndCourt =""
    Else
      EndCourt = fInject(oJSONoutput.tEndCourt)
      DEC_EndCourt =  fInject(oJSONoutput.tEndCourt)   
    End If
  Else
    EndCourt = ""
    DEC_EndCourt =""
  End if

  If hasown(oJSONoutput, "tSex") = "ok" then
    If ISNull(oJSONoutput.tSex) Or oJSONoutput.tSex = "" Then
      Sex = const_Empty
      DEC_Sex =const_Empty
    Else
      Sex = fInject(oJSONoutput.tSex)
      DEC_Sex =  fInject(oJSONoutput.tSex)   
    End If
  Else
    Sex = const_Empty
    DEC_Sex  const_Empty
  End if

  If hasown(oJSONoutput, "tPlayType") = "ok" then
    If ISNull(oJSONoutput.tPlayType) Or oJSONoutput.tPlayType = "" Then
      PlayType = const_Empty
      DEC_PlayType = const_Empty
    Else
      PlayType = fInject(oJSONoutput.tPlayType)
      DEC_PlayType =  fInject(oJSONoutput.tPlayType)   
    End If
  Else
    PlayType = const_Empty
    DEC_PlayType = const_Empty
  End if


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

  IF DEC_Sex = "empty" Then
    DEC_Sex = ""
  End IF

  IF DEC_PlayType = "empty" Then
    DEC_PlayType = ""
  End IF

  'Response.Write "DEC_GameTitleIDX : " & DEC_GameTitleIDX & "<br/>"
  'Response.Write "DEC_StadiumIdx : " & DEC_StadiumIdx & "<br/>"
  'Response.Write "DEC_GameDay : " &DEC_GameDay & "<br/>"
  'Response.Write "DEC_GroupGameGb : " &DEC_GroupGameGb & "<br/>"
  'Response.Write "DEC_TeamGb : " &DEC_TeamGb & "<br/>"
  'Response.Write "DEC_LevelJooName : " &DEC_LevelJooName & "<br/>"
  'Response.Write "DEC_Level : " &DEC_Level & "<br/>"
  'Response.Write "DEC_PlayLevelType : " & DEC_PlayLevelType & "<br/>"
  Dim GameLevelCnt : GameLevelCnt = 0

  LSQL = " SELECT Count(*) as GameLevelCnt "
  LSQL = LSQL & " FROM tblGameSchedule "
  LSQL = LSQL & " where GameTitleIDX ='" & DEC_GameTitleIDX & "' And DelYn ='N' "

  IF DEC_GroupGameGb <> "" Then
  LSQL = LSQL & " And GroupGameGb ='" & DEC_GroupGameGb & "' "
  End IF
  IF DEC_TeamGb <> "" Then
  LSQL = LSQL & " And TeamGb ='" & DEC_TeamGb & "' "
  End IF
  IF DEC_Level <> "" Then
  LSQL = LSQL & " And Level ='" & DEC_Level & "' "
  End IF
  IF DEC_LevelJooName <> "" Then
  LSQL = LSQL & " And LevelJooName ='" & DEC_LevelJooName & "' "
  End IF
  IF DEC_PlayLevelType <> "" Then
  LSQL = LSQL & " And PlayLevelType ='" & DEC_PlayLevelType & "' "
  End IF
   IF DEC_Sex <> "" Then
  LSQL = LSQL & " And Sex ='" & DEC_Sex & "' "
  End IF
  IF DEC_PlayType <> "" Then
  LSQL = LSQL & " And PlayType ='" & DEC_PlayType & "' "
  End IF
  'Response.Write "LSQL : " & LSQL & "<br/>"
  'rESPONSE.END
  Set LRs = Dbcon.Execute(LSQL)
  If Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
        GameLevelCnt =  LRs("GameLevelCnt") 
      LRs.MoveNext
    Loop
  End If
  LRs.Close

  IF CDBL(GameLevelCnt) > 0 Then
    Call oJSONoutput.Set("result", 1 )
    strjson = JSON.stringify(oJSONoutput)
	  Response.Write strjson
    Response.End
  END IF 
    
  LSQL = " EXEC tblGameTourneyLevel_Searched_STR '" & DEC_GameTitleIDX & "', '" & DEC_GroupGameGb  & "', '" & DEC_TeamGb & "', '" &  DEC_Level & "','" &DEC_LevelJooName & "', '" & DEC_PlayLevelType & "', '" & DEC_Sex & "','" & DEC_PlayType & "'"
  Set LRs = DBCon.Execute(LSQL)
  'Response.Write "LSQL : " & LSQL & "<br/>"  
  IF NOT (LRs.Eof Or LRs.Bof) Then
    arryGameTourneyLevel= LRs.getrows()
  End If

  If IsArray(arryGameTourneyLevel) Then
    For ar = LBound(arryGameTourneyLevel, 2) To UBound(arryGameTourneyLevel, 2) 
      DEC_GameLevelIdx    = arryGameTourneyLevel(0, ar) 
      LSQL = "INSERT INTO tblGameSchedule"
      LSQL = LSQL & "(" 
      LSQL = LSQL & "GameTitleIDX,"
      LSQL = LSQL & "GameLevelIdx,"
      LSQL = LSQL & "GroupGameGb,"
      LSQL = LSQL & "StartCourt,"
      LSQL = LSQL & "EndCourt,"
      LSQL = LSQL & "PlayLevelType,"
      LSQL = LSQL & "TeamGb,"
      LSQL = LSQL & "Sex,"
      LSQL = LSQL & "PlayType,"
      LSQL = LSQL & "Level,"
      LSQL = LSQL & "LevelJooName,"
      LSQL = LSQL & "StadiumIDX,"
      LSQL = LSQL & "GameDay"
      LSQL = LSQL & ")"
      LSQL = LSQL & "VALUES"
      LSQL = LSQL & "("
      LSQL = LSQL & "'" & DEC_GameTitleIDX & "',"
      LSQL = LSQL & "'" & DEC_GameLevelIdx & "',"
      LSQL = LSQL & "'" & DEC_GroupGameGb & "',"
      LSQL = LSQL & "'" & DEC_StartCourt & "',"
      LSQL = LSQL & "'" & DEC_EndCourt & "',"
      LSQL = LSQL & "'" & DEC_PlayLevelType & "',"
      LSQL = LSQL & "'" & DEC_TeamGb & "',"
      LSQL = LSQL & "'" & DEC_Sex & "',"
      LSQL = LSQL & "'" & DEC_PlayType & "',"
      LSQL = LSQL & "'" & DEC_Level & "',"
      LSQL = LSQL & "'" & DEC_LevelJooName & "',"
      LSQL = LSQL & "'" & DEC_StadiumIdx & "',"
      LSQL = LSQL & "'" & DEC_GameDay & "'"
      LSQL = LSQL & ")"
      Set LRs = DBCon.Execute(LSQL)
      'Response.Write "LSQL" & LSQL & "<BR/>"
      Next
  
    Call oJSONoutput.Set("result", 0 )  
    strjson = JSON.stringify(oJSONoutput)
	  Response.Write strjson
  ELSE
    Call oJSONoutput.Set("result", 2 )  
    strjson = JSON.stringify(oJSONoutput)
	  Response.Write strjson
  End IF
  
	
%>

<%
  DBClose()
%> 