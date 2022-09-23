
<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  REQ = Request("REQ")
  'REQ = "{""CMD"":5,""IDX"":""118"",""NationType"":""A1E586BCFF6BD3A50117576E91803559"",""GameTitleName"":""테스트"",""GameStartDate"":""2018-02-02"",""GameEndDate"":""2018-02-15"",""GameRcvDateS"":""2018-02-01"",""GameRcvDateE"":""2018-02-15"",""GameTitleLocation"":""01"",""EnterType"":""A"",""ViewYN"":""N"",""GameTitleHost"":""ㅇㅇㅇㅁㅇㄴㅇㅁㄴㅇㅁㄴ"",""EntryViewYN"":""N""}"

  Set oJSONoutput = JSON.Parse(REQ)
	CMD = fInject(oJSONoutput.CMD)
  tIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tIdx))
  NationType = fInject(crypt.DecryptStringENC(oJSONoutput.NationType))
  GameTitleName = fInject(oJSONoutput.GameTitleName)
  GameStartDate = fInject(oJSONoutput.GameStartDate)
  GameEndDate = fInject(oJSONoutput.GameEndDate)
  GameRcvDateS = fInject(oJSONoutput.GameRcvDateS)
  GameRcvDateE = fInject(oJSONoutput.GameRcvDateE)
  GameTitleLocation = fInject(oJSONoutput.GameTitleLocation)
  EnterType = fInject(oJSONoutput.EnterType)
  ViewYN = fInject(oJSONoutput.ViewYN)
  GameTitleHost = fInject(oJSONoutput.GameTitleHost)
  EntryViewYN= fInject(oJSONoutput.EntryViewYN)
  GamePlace = fInject(oJSONoutput.GamePlace)
  GameTitleOldIDX = fInject(oJSONoutput.GameTitleOldIDX)

  MaxPoint = fInject(oJSONoutput.MaxPoint)
  RallyPoint = fInject(oJSONoutput.RallyPoint)
  DeuceYN = fInject(oJSONoutput.DeuceYN)
  MaxPoint_Ama = fInject(oJSONoutput.MaxPoint_Ama)
  RallyPoint_Ama = fInject(oJSONoutput.RallyPoint_Ama)
  DeuceYN_Ama = fInject(oJSONoutput.DeuceYN_Ama)  

  IF( tIdx <> "") Then
  LSQL = " Update tblGameTitle " 
  LSQL = LSQL & " SET GameGb = '" & NationType & "', GameTitleName = '" & GameTitleName & "', GameTitleHost = '" & GameTitleHost &"',GameS = '" & GameStartDate & "', GameE = '" & GameEndDate & "', Sido = '" & GameTitleLocation & "', EnterType= '" & EnterType & "', ViewYN = '" & ViewYN &"', GameRcvDateS = '" & GameRcvDateS & "', GameRcvDateE = '" & GameRcvDateE & "', EntryViewYN = '" & EntryViewYN & "', GamePlace = '" & GamePlace & "', GameTitleOldIDX ='" & GameTitleOldIDX & "',"
  LSQL = LSQL & " MaxPoint = '" & MaxPoint & "', RallyPoint = '" & RallyPoint & "', DeuceYN = '" & DeuceYN & "', MaxPoint_Ama = '" & MaxPoint_Ama & "', RallyPoint_Ama = '" & RallyPoint_Ama & "', DeuceYN_Ama = '" & DeuceYN_Ama & "'"
  LSQL = LSQL & " Where GameTitleIDX = " & tIdx
  Set LRs = DBCon.Execute(LSQL)
  End IF
  
  Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
%>

<%
  DBClose()
%>