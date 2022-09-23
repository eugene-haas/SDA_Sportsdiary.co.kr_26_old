
<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  REQ = Request("REQ")
  'REQ = "{""CMD"":20,""tDeleteSchedules"":""0B5EB9CEFAF1E107711072C78C2E36F8_""}"
  Set oJSONoutput = JSON.Parse(REQ)
	CMD = oJSONoutput.CMD
  tDeleteSchedules = fInject(oJSONoutput.tDeleteSchedules)

  DeleteSchedules = Split(tDeleteSchedules,"_")
  
  for each a in DeleteSchedules 
    DeleteSchedule = fInject(crypt.DecryptStringENC(a))
    IF Len(DeleteSchedule) > 0 Then
      LSQL = " Update tblGameSchedule " 
      LSQL = LSQL & " SET DelYN = 'Y'" 
      LSQL = LSQL & " Where GameScheduleIDX = '" & DeleteSchedule & "'"
      'Response.Write "LSQL :" & LSQL & "<BR>"
      Set LRs = DBCon.Execute(LSQL)
      DeleteSchedule = ""
    End IF
  next


  

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
%>
  
<%
  DBClose()
%>
