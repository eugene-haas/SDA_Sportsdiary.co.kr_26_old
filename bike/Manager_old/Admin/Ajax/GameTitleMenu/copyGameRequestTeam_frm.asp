

<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  REQ = Request("REQ")
  'REQ = "{""CMD"":5,""IDX"":""118"",""NationType"":""A1E586BCFF6BD3A50117576E91803559"",""GameTitleName"":""테스트"",""GameStartDate"":""2018-02-02"",""GameEndDate"":""2018-02-15"",""GameRcvDateS"":""2018-02-01"",""GameRcvDateE"":""2018-02-15"",""GameTitleLocation"":""01"",""EnterType"":""A"",""ViewYN"":""N"",""GameTitleHost"":""ㅇㅇㅇㅁㅇㄴㅇㅁㄴㅇㅁㄴ"",""EntryViewYN"":""N""}"

  Set oJSONoutput = JSON.Parse(REQ)
	CMD = fInject(oJSONoutput.CMD)
  tGameTitleIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tGameTitleIDX))
  tGameLevelIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameLevelIdx))
  tGameRequestTeamIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameRequestTeamIdx))
  NowPage = fInject(oJSONoutput.NowPage)

  LSQL = "EXEC tblGameRequestTeam_Copy '" &  tGameRequestTeamIdx & "','" & tGameLevelIdx& "'"
  Set LRs = DBCon.Execute(LSQL)
  
  Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
%>

<%
  DBClose()
%>

