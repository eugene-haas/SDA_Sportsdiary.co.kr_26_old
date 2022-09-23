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
  'REQ = "{""CMD"":20,""tGameLevelDtlIDX"":""88146F35F5A3BD4D01C5E9F5051D91B9"",""tTeamGameNum"":""1"",""tGameNum"":""0"",""tGroupGameGb"":""B0030002"",""tStadiumIdx"":""75E0A26C83058B63F8E491C30A30C149"",""tGameDay"":""2018-06-21"",""tGameCourt"":""3"",""tGameOrder"":""1""}"    
  Set oJSONoutput = JSON.Parse(REQ)
  '------------------------------- 순서와 날짜를 적용할 Torueny Game -------------------------------
  If hasown(oJSONoutput, "tGameLevelDtlIDX") = "ok" then
    If ISNull(oJSONoutput.tGameLevelDtlIDX) Or oJSONoutput.tGameLevelDtlIDX = "" Then
      GameLevelDtlIDX = ""
      DEC_GameLevelDtlIDX = ""
    Else
      GameLevelDtlIDX = fInject(oJSONoutput.tGameLevelDtlIDX)
      DEC_GameLevelDtlIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tGameLevelDtlIDX))    
    End If
  End if  

   If hasown(oJSONoutput, "tTeamGameNum") = "ok" then
    If ISNull(oJSONoutput.tTeamGameNum) Or oJSONoutput.tTeamGameNum = "" Then
      TeamGameNum = ""
      DEC_TeamGameNum = ""
    Else
      TeamGameNum = fInject(oJSONoutput.tTeamGameNum)
      DEC_TeamGameNum = fInject(oJSONoutput.tTeamGameNum)
    End If
  End if  

   If hasown(oJSONoutput, "tGameNum") = "ok" then
    If ISNull(oJSONoutput.tGameNum) Or oJSONoutput.tGameNum = "" Then
      GameNum = ""
      DEC_GameNum = ""
    Else
      GameNum = fInject(oJSONoutput.tGameNum)
      DEC_GameNum = fInject(oJSONoutput.tGameNum)
    End If
  End if  
 
  If hasown(oJSONoutput, "tGroupGameGb") = "ok" then
    If ISNull(oJSONoutput.tGroupGameGb) Or oJSONoutput.tGroupGameGb = "" Then
      GroupGameGb = ""
      DEC_GroupGameGb= ""
    Else
      GroupGameGb = fInject(oJSONoutput.tGroupGameGb)
      DEC_GroupGameGb = fInject(oJSONoutput.tGroupGameGb)
    End If
  End if  


  
  '------------------------------- 순서와 날짜를 적용할 Torueny Game -------------------------------

   If hasown(oJSONoutput, "tStadiumIdx") = "ok" then
    If ISNull(oJSONoutput.tStadiumIdx) Or oJSONoutput.tStadiumIdx = "" Then
      StadiumIdx = ""
      DEC_StadiumIdx = ""
    Else
      StadiumIdx = fInject(oJSONoutput.tStadiumIdx)
      DEC_StadiumIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tStadiumIdx))    
    End If
  End if  

   If hasown(oJSONoutput, "tGameCourt") = "ok" then
    If ISNull(oJSONoutput.tGameCourt) Or oJSONoutput.tGameCourt = "" Then
      GameCourt = ""
      DEC_GameCourt= ""
    Else
      GameCourt = fInject(oJSONoutput.tGameCourt)
      DEC_GameCourt = fInject(oJSONoutput.tGameCourt)
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

   If hasown(oJSONoutput, "tGameOrder") = "ok" then
    If ISNull(oJSONoutput.tGameOrder) Or oJSONoutput.tGameOrder = "" Then
      GameOrder = ""
      DEC_GameOrder = ""
    Else
      GameOrder = fInject(oJSONoutput.tGameOrder)
      DEC_GameOrder = fInject(oJSONoutput.tGameOrder)
    End If
  End if  



  Response.Write "DEC_GameLevelDtlIDX" & DEC_GameLevelDtlIDX& "<br>"
  Response.Write "DEC_TeamGameNum" & DEC_TeamGameNum& "<br>"
  Response.Write "DEC_GameNum" & DEC_GameNum& "<br>"
  Response.Write "DEC_StadiumIdx" & DEC_StadiumIdx& "<br>"
  Response.Write "DEC_GameCourt" & DEC_GameCourt& "<br>"
  Response.Write "DEC_GameDay" & DEC_GameDay& "<br>"
  Response.Write "DEC_GameOrder" & DEC_GameOrder& "<br>"
 

  'Response.Write " GroupGameGb : " & GroupGameGb & "<br/>"
  IF PersonGame = DEC_GroupGameGb Then
    LSQL = " SELECT TourneyIDX,GameLevelDtlidx,GameNum "
    LSQL = LSQL & " FROM  tblTourney "
    LSQL = LSQL & " WHERE DelYN = 'N' and GameNum ='"& DEC_GameNum &"' and GameLevelDtlidx ='" & DEC_GameLevelDtlIDX & "'"
    'Response.Write "LSQL :" & LSQL & "<br>"
    Set LRs = DBCon.Execute(LSQL)
    IF NOT (LRs.Eof Or LRs.Bof) Then
      arrTourneyUpdates = LRs.getrows()
    End If
    LRs.close

    If IsArray(arrTourneyUpdates) Then
      For ar2 = LBound(arrTourneyUpdates, 2) To UBound(arrTourneyUpdates, 2) 
        arrTourneyIDX2	= arrTourneyUpdates(0, ar2) 
        arrGameLevelDtlidx	= arrTourneyUpdates(1, ar2) 
        arrTeamGameNum	= arrTourneyUpdates(2, ar2) 
        'Response.Write "arrTourneyTeamIDX :" & arrTourneyTeamIDX & "<br>"
        'Response.Write "arrGameLevelDtlidx :" & arrGameLevelDtlidx & "<br>"
        'Response.Write "arrTeamGameNum :" & arrTeamGameNum & "<br>"
        LSQL = " UPDATE tblTourney "
        LSQL = LSQL & " Set TurnNum = '" & DEC_GameOrder & "', GameDay= '" & DEC_GameDay & "', StadiumNum = '" & DEC_GameCourt & "', StadiumIDX = '" & DEC_StadiumIdx & "', UpdateGameOrderDate = getdate()"
        LSQL = LSQL & " WHERE DelYN = 'N' and TourneyIDX = '" & arrTourneyIDX2 & "'"
        Set LRs = DBCon.Execute(LSQL)
        'Response.Write "LSQL :" & LSQL & "<br>"
      Next
    End If
    
  ELSEIF GroupGame = DEC_GroupGameGb Then
        LSQL = " SELECT TourneyTeamIDX,GameLevelDtlidx,TeamGameNum "
        LSQL = LSQL & " FROM  tblTourneyTeam "
        LSQL = LSQL & " WHERE DelYN = 'N' and TeamGameNum ='"& DEC_TeamGameNum &"' and GameLevelDtlidx ='" & DEC_GameLevelDtlIDX & "'"
        'Response.Write "LSQL :" & LSQL & "<br>"
        Set LRs = DBCon.Execute(LSQL)
        IF NOT (LRs.Eof Or LRs.Bof) Then
          arrTourneyTeamUpdates = LRs.getrows()
        End If
        LRs.close

        If IsArray(arrTourneyTeamUpdates) Then
          For ar2 = LBound(arrTourneyTeamUpdates, 2) To UBound(arrTourneyTeamUpdates, 2) 
            arrTourneyTeamIDX2	= arrTourneyTeamUpdates(0, ar2) 
            arrGameLevelDtlidx	= arrTourneyTeamUpdates(1, ar2) 
            arrTeamGameNum	= arrTourneyTeamUpdates(2, ar2) 
            'Response.Write "arrTourneyTeamIDX :" & arrTourneyTeamIDX & "<br>"
            'Response.Write "arrGameLevelDtlidx :" & arrGameLevelDtlidx & "<br>"
            'Response.Write "arrTeamGameNum :" & arrTeamGameNum & "<br>"
            LSQL = " UPDATE tblTourneyTeam "
            LSQL = LSQL & " Set TurnNum = '" & DEC_GameOrder & "', GameDay= '" & DEC_GameDay & "', StadiumNum = '" & DEC_GameCourt & "', StadiumIDX = '" & DEC_StadiumIdx & "', UpdateGameOrderDate = getdate()"
            LSQL = LSQL & " WHERE DelYN = 'N' and TourneyTeamIDX = '" & arrTourneyTeamIDX2 & "'"
            Set LRs = DBCon.Execute(LSQL)
            'Response.Write "LSQL :" & LSQL & "<br>"
          Next
        End If
      
  
  End IF
    

  
	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
%>

<%
  DBClose()
%> 