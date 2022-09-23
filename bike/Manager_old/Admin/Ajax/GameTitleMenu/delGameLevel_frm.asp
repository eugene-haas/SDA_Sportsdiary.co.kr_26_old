<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  REQ = Request("REQ")
  'REQ = "{""CMD"":2,""IDX"":""2""}"

  Set oJSONoutput = JSON.Parse(REQ)
  tGameLevelIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tGameLevelIDX))
  tIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tIDX))
  'Response.Write "CMD :" & CMD & "<BR>"

  IF( tGameLevelIDX <> "" and tIDX <> "") Then
    'LSQL = " DELETE FROM tblGameLevel " 
    'LSQL = LSQL & "   WHERE GameLevelidx = '" &  tGameLevelIDX & "' and GameTitleIDX = '" & tIDX & "'" 
    'Response.Write "SQL :" & LSQL & "<BR>"
    'Set LRs = DBCon.Execute(LSQL)

    'LSQL = " DELETE FROM tblGameLevelDtl " 
    'LSQL = LSQL & "   WHERE GameLevelidx = '" &  tGameLevelIDX & "'" 
    'Response.Write "SQL :" & LSQL & "<BR>"
    'Set LRs = DBCon.Execute(LSQL)

    LSQL = " Update tblGameLevel Set DelYN = 'Y' " 
    LSQL = LSQL & "   WHERE GameLevelidx = '" &  tGameLevelIDX & "' and GameTitleIDX = '" & tIDX & "'" 
    'Response.Write "SQL :" & LSQL & "<BR>"
    Set LRs = DBCon.Execute(LSQL)

    LSQL = " Update tblGameLevelDtl Set DelYN = 'Y' " 
    LSQL = LSQL & "   WHERE GameLevelidx = '" &  tGameLevelIDX & "'" 
    'Response.Write "SQL :" & LSQL & "<BR>"
    Set LRs = DBCon.Execute(LSQL)
  End IF


	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
  
  DBClose()
%>
