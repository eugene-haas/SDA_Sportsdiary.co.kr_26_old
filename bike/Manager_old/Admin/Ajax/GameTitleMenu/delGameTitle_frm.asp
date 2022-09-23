<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  
  REQ = Request("REQ")
  'REQ = "{""CMD"":4,""tIDX"":""2E5522C42AE45144537C93D128DF7B18""}"

  Set oJSONoutput = JSON.Parse(REQ)
  tIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tIDX))
  crypt_tIDX =crypt.EncryptStringENC(tIDX)
  'Response.Write "CMD :" & CMD & "<BR>"

  IF( tIDX <> "") Then
    'LSQL = " DELETE FROM tblGameTitle " 
    'LSQL = LSQL & "   WHERE GameTitleIDX = " &  tIDX
    'Response.Write "SQL :" & LSQL & "<BR>"
    'Set LRs = DBCon.Execute(LSQL)

    LSQL = " Update tblGameTitle Set DelYN = 'Y' " 
    LSQL = LSQL & "   WHERE GameTitleIDX = '" &  tIDX & "'"
    'Response.Write "SQL :" & LSQL & "<BR>"
    Set LRs = DBCon.Execute(LSQL)

    LSQL = " Update tblGameLevel Set DelYN = 'Y' " 
    LSQL = LSQL & "   WHERE GameTitleIDX = '" &  tIDX & "'"
    'Response.Write "SQL :" & LSQL & "<BR>"
    Set LRs = DBCon.Execute(LSQL)

    LSQL = " Update tblGameLevelDtl Set DelYN = 'Y' " 
    LSQL = LSQL & "   WHERE GameTitleIDX = '" &  tIDX & "'" 
    'Response.Write "SQL :" & LSQL & "<BR>"
    Set LRs = DBCon.Execute(LSQL)

  End IF


	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
  
  DBClose()
%>
