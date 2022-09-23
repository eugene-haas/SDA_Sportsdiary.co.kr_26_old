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
  'REQ = "{""CMD"":13,""tGameScheduleIDX"":""853A3E111047DDC564FB5259BE081CCB"",""tNumber"":""2""}"
  Set oJSONoutput = JSON.Parse(REQ)

  If hasown(oJSONoutput, "tGameScheduleIDX") = "ok" then
    If ISNull(oJSONoutput.tGameScheduleIDX) Or oJSONoutput.tGameScheduleIDX = "" Then
      GameScheduleIDX = ""
      DEC_GameScheduleIDX = ""
    Else
      GameScheduleIDX = fInject(oJSONoutput.tGameScheduleIDX)
      DEC_GameScheduleIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tGameScheduleIDX))    
    End If
  End if 

  If hasown(oJSONoutput, "tNumber") = "ok" then
    If ISNull(oJSONoutput.tNumber) Or oJSONoutput.tNumber = "" Then
      Number = ""
      DEC_Number= ""
    Else
      Number = fInject(oJSONoutput.tNumber)
      DEC_Number = fInject(oJSONoutput.tNumber) 
    End If
  End if 


  IF( cdbl(DEC_GameScheduleIDX) > 0 ) Then
  LSQL = " UPDATE  tblGameSchedule " 
  LSQL = LSQL & " SET GameGroupOrder = '" & DEC_Number & "'"
  LSQL = LSQL & " Where GameScheduleIDX = '" & DEC_GameScheduleIDX & "'"
  Set LRs = DBCon.Execute(LSQL)
    
    Call oJSONoutput.Set("result", 0 )
    strjson = JSON.stringify(oJSONoutput)
    Response.Write strjson
    Response.End
  End IF

  Call oJSONoutput.Set("result", 1 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
  


  
%>

<%
  DBClose()
%>
