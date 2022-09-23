

<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  
  REQ = Request("REQ")
  'REQ = "{""CMD"":14,""tGameLevelIDX"":""357E87C6F94F8BF6ED32548D760214DF"",""SEEDCNT"":""2""}"

  Set oJSONoutput = JSON.Parse(REQ)
	CMD = fInject(oJSONoutput.CMD)
  tGameLevelIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tGameLevelIDX))
  SEEDCNT = fInject(oJSONoutput.SEEDCNT)


  IF( cdbl(tGameLevelIDX) > 0 ) Then
  LSQL = " UPDATE  tblGameLevel " 
  'LSQL = LSQL & " SET EntryCnt = '" & tEntryCnt & "', PlayLevelType  =  '" & tPlayLevelType & "',  GameType  =  '" & tGameType & "', StadiumNumber  = '" & tStadiumNumber &"'  , TotRound  = '" & tTotalRound & "'  , GameDay  = '"  & tGameDay & "'  , GameTime  = '" & tGameTime & "', ViewYN = '" & ViewYN & "', LevelJooName = '" & tLevelJoo & "',LevelJooNum = '" & tLevelJooNum & "'" 
  LSQL = LSQL & " SET SeedCnt = '" & SEEDCNT & "'"
  LSQL = LSQL & " Where GameLevelidx = '" & tGameLevelIDX & "'"
  Response.Write LSQL
  Set LRs = DBCon.Execute(LSQL)
  End IF
  
  'Call oJSONoutput.Set("result", 0 )
	'strjson = JSON.stringify(oJSONoutput)
	'Response.Write strjson

  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"
%>

<%
  DBClose()
%>


