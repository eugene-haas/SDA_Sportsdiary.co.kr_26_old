<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  REQ = Request("REQ")
  'REQ = "{""CMD"":4,""tGameRequestPlayerIDX"":""21"",""NowPage"":1}"

  Set oJSONoutput = JSON.Parse(REQ)
  tGameRequestGroupIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tGameRequestGroupIDX))
  
  'Response.Write "CMD :" & CMD & "<BR>"

  IF( tGameRequestGroupIDX <> "") Then
    'LSQL = " DELETE FROM tblGameLevelDtl " 
    'LSQL = LSQL & "   WHERE GameLevelDtlidx = '" &  tGameLevelDtlIDX & "'"
    'Response.Write "SQL :" & LSQL & "<BR>"
    'Set LRs = DBCon.Execute(LSQL)
    LSQL = " Update tblGameRequestPlayer Set DelYN = 'Y' " 
    LSQL = LSQL & "   WHERE GameRequestGroupIDX = '" &  tGameRequestGroupIDX & "'"
    'Response.Write "SQL :" & LSQL & "<BR>"
    Set LRs = DBCon.Execute(LSQL)

    LSQL = " Update tblGameRequestGroup Set DelYN = 'Y' " 
    LSQL = LSQL & "   WHERE GameRequestGroupIDX = '" &  tGameRequestGroupIDX & "'"
    'Response.Write "SQL :" & LSQL & "<BR>"
    Set LRs = DBCon.Execute(LSQL)

    LSQL = " Update tblGameRequestTouney Set DelYN = 'Y' " 
    LSQL = LSQL & "   WHERE RequestIDX = '" &  tGameRequestGroupIDX & "' AND  GroupGameGb = 'B0030001'"
    'Response.Write "SQL :" & LSQL & "<BR>"
    Set LRs = DBCon.Execute(LSQL)

    LSQL = " Update tblTourney Set DelYN = 'Y' " 
    LSQL = LSQL & "   WHERE RequestIDX = '" &  tGameRequestGroupIDX & "'"
    'Response.Write "SQL :" & LSQL & "<BR>"
    Set LRs = DBCon.Execute(LSQL)

  End IF

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
  
  DBClose()
%>
