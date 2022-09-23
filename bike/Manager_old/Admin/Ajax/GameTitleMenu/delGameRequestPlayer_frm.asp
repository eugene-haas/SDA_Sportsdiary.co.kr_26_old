<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  REQ = Request("REQ")
  'REQ = "{""CMD"":4,""tGameRequestPlayerIDX"":""21"",""NowPage"":1}"

  Set oJSONoutput = JSON.Parse(REQ)
  tGameRequestPlayerIDX =  fInject(crypt.DecryptStringENC(oJSONoutput.tGameRequestPlayerIDX))
  
  'Response.Write "CMD :" & CMD & "<BR>"

  IF( tGameRequestPlayerIDX <> "") Then
    'LSQL = " DELETE FROM tblGameLevelDtl " 
    'LSQL = LSQL & "   WHERE GameLevelDtlidx = '" &  tGameLevelDtlIDX & "'"
    'Response.Write "SQL :" & LSQL & "<BR>"
    'Set LRs = DBCon.Execute(LSQL)
    LSQL = " Update tblGameRequestPlayer Set DelYN = 'Y' " 
    LSQL = LSQL & "   WHERE GameRequestPlayerIDX = '" &  tGameRequestPlayerIDX & "'"
    'Response.Write "SQL :" & LSQL & "<BR>"
    Set LRs = DBCon.Execute(LSQL)
  End IF

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
  
  DBClose()
%>
