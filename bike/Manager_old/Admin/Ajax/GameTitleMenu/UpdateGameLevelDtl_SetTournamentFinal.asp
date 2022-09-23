

<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  REQ = Request("REQ")
  'REQ = "{""CMD"":3,""tGameLevelDtlIdx"":""1325^B0030002%1326^B0030001%1329^B0030001%1332^B0030001%1530^B0030002%""}"
  const teamGroupGameGb = "B0030002"
  const personGroupGameGb = "B0030001"
  Set oJSONoutput = JSON.Parse(REQ)
  CMD = fInject(oJSONoutput.CMD)
  
  tGameLevelDtlIdx = fInject(oJSONoutput.tGameLevelDtlIdx)
  
  a = Split(tGameLevelDtlIdx,"%")
  for each x in a
    if x <> "" Then
      items1 = Split(x,"^")
      gamelevelDtlIdx = items1(0)
      GroupGameGb = items1(1)

      if GroupGameGb =teamGroupGameGb Then
        LSQL = "  EXEC Insert_tblTourneyTeam_Bon '" & gamelevelDtlIdx &"' " 
        DBCon.Execute(LSQL)
        'Response.Write LSQL & "<BR/>"
      ELSE
        LSQL = "  EXEC Insert_tblTourney_Bon '" & gamelevelDtlIdx &"' " 
        DBCon.Execute(LSQL)
        'Response.Write LSQL & "<BR/>"
      END IF
    End IF
  next

  Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  DBClose()
%>



