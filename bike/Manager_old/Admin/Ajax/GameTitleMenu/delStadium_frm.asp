
<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  REQ = Request("REQ")
  'REQ = "{"CMD":4,"tIDX":"8007090508F26F02853D992888E22B9C","tStadiumIDX":"3601F5C464DFBEA23E5EB5558B0FC4B3"}"

  Set oJSONoutput = JSON.Parse(REQ)
  tIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tIDX))
  tStadiumIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tStadiumIDX))
  'NowPage = fInject(oJSONoutput.NowPage)

  'Response.Write "CMD :" & CMD & "<BR>"
  'Response.Write "tStadiumIDX :" & tStadiumIDX & "<BR>"
  'Response.Write "NowPage :" & NowPage & "<BR>"


  IF( tStadiumIDX <> "") Then
    LSQL = " Update tblStadium Set DelYN = 'Y' " 
    LSQL = LSQL & "   WHERE StadiumIDX = '" &  tStadiumIDX & "'"
    'Response.Write "SQL :" & LSQL & "<BR>"
    Set LRs = DBCon.Execute(LSQL)
  End IF


	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
  
  DBClose()
%>
