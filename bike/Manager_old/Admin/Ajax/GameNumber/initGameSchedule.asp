
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
  'REQ = "{""CMD"":10,""tGameTitleIDX"":""35D5B51E5025C785305E687C2F2EE95E"",""tStadiumIDX"":""75E0A26C83058B63F8E491C30A30C149"",""tGameDay"":""2018-06-27""}"
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

  If hasown(oJSONoutput, "tStadiumIDX") = "ok" then
    If ISNull(oJSONoutput.tStadiumIDX) Or oJSONoutput.tStadiumIDX = "" Then
      StadiumIDX = ""
      DEC_StadiumIDX = ""
    Else
      StadiumIDX = fInject(oJSONoutput.tStadiumIDX)
      DEC_StadiumIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tStadiumIDX))
    End If
  End if  


  If hasown(oJSONoutput, "tGameDay") = "ok" then
    If ISNull(oJSONoutput.tGameDay) Or oJSONoutput.tGameDay = "" Then
      GameDay = ""
      DEC_GameDay = ""
    Else
      GameDay = fInject(oJSONoutput.tGameDay)
      DEC_GameDay = fInject(oJSONoutput.tGameDay)
    End If
  End if  

  Dim StadiumCourt : StadiumCourt = 0
  LSQL = " SELECT StadiumCourt "
  LSQL = LSQL & " FROM tblStadium "
  LSQL = LSQL & "   where GameTitleIDX ='" & DEC_GameTitleIDX & "' and StadiumIDX ='" & DEC_StadiumIDX & "' and DelYN = 'N'"
  Set LRs = Dbcon.Execute(LSQL)

  IF Not (LRs.Eof Or LRs.Bof) Then
      Do Until LRs.Eof  
        StadiumCourt = LRs("StadiumCourt")
        LRs.MoveNext()
      Loop
  End If   
  LRs.Close         

  
%>

<%
  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.Write "`##`"
  'Response.Write "StadiumCourt : " & StadiumCourt & "<BR/>"
%>       

<table cellspacing="0" cellpadding="0" id="tableGameSchedule" name="tableGameSchedule">
  <thead>
    <tr>
      <th  class="backslash" style="width:60px"><div>코트</div>번호</th>
      <% For i = 1 To StadiumCourt %>
      <th><%=i%> 코트</th>
      <% Next %>
    </tr>
  </thead>
  <tbody>
  </tbody>
</table>
<button type="button" style="width:100%" id="btnInsertScheduleRow" name="btnInsertScheduleRow" onClick="javascript:insertScheduleRow('<%=StadiumIDX%>','<%=DEC_GameDay%>');">경기 번호 Row 생성</button>
