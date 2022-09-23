
<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  REQ = Request("REQ")
  'REQ = "{""CMD"":2,""NationType"":""A1E586BCFF6BD3A50117576E91803559"",""GameTitleName"":""단체전 테스트 댕댕이 대회"",""GameStartDate"":""2018-02-02"",""GameEndDate"":""2018-05-31"",""GameRcvDateS"":""2018-02-01"",""GameRcvDateE"":""2018-05-31"",""GameTitleLocation"":""01"",""EnterType"":""A"",""ViewYN"":""N"",""EntryViewYN"":""N"",""GameTitleHost"":""댕댕이"",""GamePlace"":""댕댕이집"",""NowPage"":1}"

  Set oJSONoutput = JSON.Parse(REQ)

	CMD = oJSONoutput.CMD
  NationType = fInject(crypt.DecryptStringENC(oJSONoutput.NationType))
  GameTitleName = fInject(oJSONoutput.GameTitleName)
  GameTitleHost = fInject(oJSONoutput.GameTitleHost)
  GameStartDate = fInject(oJSONoutput.GameStartDate)
  GameEndDate = fInject(oJSONoutput.GameEndDate)
  GameRcvDateS = fInject(oJSONoutput.GameRcvDateS)
  GameRcvDateE = fInject(oJSONoutput.GameRcvDateE)
  GameTitleLocation = fInject(oJSONoutput.GameTitleLocation)
  EnterType = fInject(oJSONoutput.EnterType)
  ViewYN = fInject(oJSONoutput.ViewYN)
  GamePlace = fInject(oJSONoutput.GamePlace)
  EntryViewYN= fInject(oJSONoutput.EntryViewYN)
  GameTitleOldIDX= fInject(oJSONoutput.GameTitleOldIDX)
  
  MaxPoint = fInject(oJSONoutput.MaxPoint)
  RallyPoint = fInject(oJSONoutput.RallyPoint)
  DeuceYN = fInject(oJSONoutput.DeuceYN)
  MaxPoint_Ama = fInject(oJSONoutput.MaxPoint_Ama)
  RallyPoint_Ama = fInject(oJSONoutput.RallyPoint_Ama)
  DeuceYN_Ama = fInject(oJSONoutput.DeuceYN_Ama)  

  'Response.Write "CMD :" & CMD & "<BR>"
  'Response.Write "NationType :" & NationType & "<BR>"
  'Response.Write "GameTitleName :" & GameTitleName & "<BR>"
  'Response.Write "GamePlace :" & GamePlace & "<BR>"
  'Response.Write "GameStartDate :" & GameStartDate & "<BR>"
  'Response.Write "GameEndDate :" & GameEndDate & "<BR>"
  'Response.Write "GameTitleLocation :" & GameTitleLocation & "<BR>"
  'Response.Write "EnterType :" & EnterType & "<BR>"
  'Response.Write "ViewYN :" & ViewYN & "<BR>"

  LSQL = " SET NOCOUNT ON insert into tblGameTitle " 
  LSQL = LSQL & " ( GameGb, GameTitleName,  GameS, GameE, Sido, EnterType, ViewYN, GameTitleHost,"
  LSQL = LSQL & "  GameRcvDateS, GameRcvDateE, EntryViewYN, GamePlace, GameTitleOldIDX,"
  LSQL = LSQL & "  MaxPoint, RallyPoint, DeuceYN, MaxPoint_Ama, RallyPoint_Ama ,DeuceYN_Ama "
  LSQL = LSQL & " ) "
  LSQL = LSQL & " values ('"&NationType & "','" & GameTitleName & "','" & GameStartDate & "','" & GameEndDate & "','" & GameTitleLocation & "','" & EnterType & "', '" & ViewYN &"','" & GameTitleHost & "',"
  LSQL = LSQL & " '" & GameRcvDateS & "','" & GameRcvDateE & "','" & EntryViewYN & "','" & GamePlace & "','" & GameTitleOldIDX & "',"
  LSQL = LSQL & " '" & MaxPoint & "','" & RallyPoint & "','" & DeuceYN & "','" & MaxPoint_Ama & "','" & RallyPoint_Ama & "','" & DeuceYN_Ama & "'"
  LSQL = LSQL & " )" 
  LSQL = LSQL & " SELECT @@IDENTITY as IDX "
 
  'Response.Write "SQL :" & LSQL & "<BR>"

  Set LRs = DBCon.Execute(LSQL)
  
  IF NOT (LRs.Eof Or LRs.Bof) Then
      Do Until LRs.Eof
      'LCnt = LCnt + 1
      IDX = LRs("IDX")
    LRs.MoveNext
    Loop
  End If  

  'Response.Write "IDX :" & IDX & "<BR>"
	Call oJSONoutput.Set("result", 0 )
  Call oJSONoutput.Set("tIdx", crypt.EncryptStringENC(IDX) )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
%>
  
<%
  DBClose()
%>
