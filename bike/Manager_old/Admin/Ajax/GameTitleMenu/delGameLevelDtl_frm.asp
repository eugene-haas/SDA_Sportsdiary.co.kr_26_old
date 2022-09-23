<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  REQ = Request("REQ")
  'REQ = "{""CMD"":3,""tIdx"":""48"",""tGameLevelDtlIDX"":""7"",""tGameLevelIdx"":""11"",""NowPage"":1}"

  Set oJSONoutput = JSON.Parse(REQ)
  tGameLevelDtlIDX =  fInject(crypt.DecryptStringENC(oJSONoutput.tGameLevelDtlIDX))
  
  'Response.Write "CMD :" & CMD & "<BR>"

  IF( tGameLevelDtlIDX <> "") Then
    'LSQL = " DELETE FROM tblGameLevelDtl " 
    'LSQL = LSQL & "   WHERE GameLevelDtlidx = '" &  tGameLevelDtlIDX & "'"
    'Response.Write "SQL :" & LSQL & "<BR>"
    'Set LRs = DBCon.Execute(LSQL)
    LSQL = " Update tblGameLevelDtl Set DelYN = 'Y' " 
    LSQL = LSQL & "   WHERE GameLevelDtlidx = '" &  tGameLevelDtlIDX & "'"
    'Response.Write "SQL :" & LSQL & "<BR>"
    Set LRs = DBCon.Execute(LSQL)

    LSQL = " Update tblGameRequestTouney Set DelYN = 'Y' " 
    LSQL = LSQL & "   WHERE GameLevelDtlidx = '" &  tGameLevelDtlIDX & "'"
    'Response.Write "SQL :" & LSQL & "<BR>"
      Set LRs = DBCon.Execute(LSQL)

  End IF


	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
  
  DBClose()
%>
