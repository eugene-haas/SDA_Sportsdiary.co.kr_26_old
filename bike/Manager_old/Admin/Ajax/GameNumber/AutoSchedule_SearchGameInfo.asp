
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
  'REQ = "{""CMD"":2,""tGameTitleIDX"":""35D5B51E5025C785305E687C2F2EE95E"",""tGameLevelName"":""""}"
  Set oJSONoutput = JSON.Parse(REQ)

  If hasown(oJSONoutput, "tGameTitleIDX") = "ok" then
    If ISNull(oJSONoutput.tGameTitleIDX) Or oJSONoutput.tGameTitleIDX = "" Then
      GameTitleIDX = const_Empty
      DEC_GameTitleIDX = const_Empty
    Else
      GameTitleIDX = fInject(oJSONoutput.tGameTitleIDX)
      DEC_GameTitleIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tGameTitleIDX))    
    End If
  End if 
   
  LSQL = " EXEC tblGameTourneyTotalCount_Searched_STR '" & DEC_GameTitleIDX & "'"
  'Response.Write "LSQL : " & LSQL & "<br/>"
  Set LRs = Dbcon.Execute(LSQL)
  If Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
    tTouneyTotalCnt= LRs("TouneyTotalCnt")
    tTourneyCnt= LRs("TourneyCnt")
    tTourneyTeamCnt= LRs("TourneyTeamCnt")
    tTourneyNumberCnt= LRs("TourneyNumberCnt")
    tTourneyTeamNumberCnt= LRs("TourneyTeamNumberCnt")
    tTourneyNumber = CDBL(tTourneyNumberCnt) + CDBL(tTourneyTeamNumberCnt)

    IF tTourneyNumber > 0 Then
      tTourneyPercent = (tTourneyNumber) / tTouneyTotalCnt * 100
      tTourneyPercent = Round(tTourneyPercent,0)
    ELSE
      tTourneyPercent  = 100
    End IF

    LRs.MoveNext
    Loop
  ELSE
    tTouneyTotalCnt = 0
    tTourneyNumber = 0
    tTourneyPercent = 0
  End If
  LRs.Close

  Call oJSONoutput.Set("TouneyTotalCnt", tTouneyTotalCnt)
  Call oJSONoutput.Set("TourneyPercent", tTourneyPercent)
  Call oJSONoutput.Set("TourneyNumber", tTourneyNumber)
	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
  DBClose()
%>
  
