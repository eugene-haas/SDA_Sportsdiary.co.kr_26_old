
<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  REQ = Request("REQ")
  'REQ = "{""CMD"":5,""tIDX"":""9832C70CDBBB6F8FB311345EF2AD1F2E"",""tGameLevelIdx"":""E80CB108C155AF181F42CE659C455E19"",""tTeamGB"":""BF593DD3E782EC864107F23897C0095E"",""tPlayType"":""704C5971F9D17ABC8687A215715ABCE6"",""tTeamGBLevel"":""AA41731A91BDE25CE1E3BAAAA81CA0D6"",""tGroupGameGb"":""F9A43D4DE4191C125B08095CC465CD4B"",""tGameS"":""2018-03-06"",""tGameSex"":""E300F22B66DC861AB9DA1717B0C3A093"",""tViewYN"":""N"",""tLevelJoo"":""2B4F14AE43DBCAD1D5BFD3285CE3A249"",""tLevelJooNum"":"""",""tEntertype"":""A"",""tPayment"":""10000"",""tStadiumNum"":""0""}"

  Set oJSONoutput = JSON.Parse(REQ)
	CMD = fInject(oJSONoutput.CMD)
  tIDX =  fInject(crypt.DecryptStringENC(oJSONoutput.tIDX))
  gameLevelIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameLevelIdx))
  TeamGBLevel = fInject(crypt.DecryptStringENC(oJSONoutput.tTeamGBLevel))
  playType = fInject(crypt.DecryptStringENC(oJSONoutput.tPlayType))
  groupGameGb = fInject(crypt.DecryptStringENC(oJSONoutput.tGroupGameGb))
  teamGB = fInject(crypt.DecryptStringENC(oJSONoutput.tTeamGB))
  gameS = fInject(oJSONoutput.tGameS)
  sex = fInject(crypt.DecryptStringENC(oJSONoutput.tGameSex))
  'ViewYN = fInject(oJSONoutput.tViewYN)
  tEntertype = fInject(oJSONoutput.tEntertype)
  tPayment = fInject(oJSONoutput.tPayment)
  tStadiumNum   = fInject(crypt.DecryptStringENC(oJSONoutput.tStadiumNum))

  LSQL = "SELECT GameS,GameE ,EnterType "
  LSQL = LSQL & " FROM  tblGameTitle"
  LSQL = LSQL & " WHERE GameTitleIDX = " &  tIDX
  'Response.Write "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL : " & LSQL

  Set LRs = DBCon.Execute(LSQL)
  If Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      tGameS = LRs("GameS")
      tGameE = LRs("GameE")
      LRs.MoveNext
    Loop
  End If
  LRs.close

  if tEnterType = "A" Then
    tLevelJoo = fInject(crypt.DecryptStringENC(oJSONoutput.tLevelJoo))
    tLevelJooNum = fInject(oJSONoutput.tLevelJooNum)
  End if

  '단체전일 경우 PlayType을 정할 수 없다.
  if groupGameGb = "B0030002" Then
    playType = ""
  End if
  

  IF( cdbl(tidx) > 0 and cdbl(gameLevelIdx) > 0 ) Then
  'LSQL = " Update tblGameLevel " 
  'LSQL = LSQL & " SET Level  =  '" & TeamGBLevel & "',  PlayType  =  '" & playType  &"'  , TeamGb  = '" & teamGB & "'  , Sex  = '"  & sex & "'  , GroupGameGb  = '" & groupGameGb & "'  , GameDay  = '" & gameS &"' , ViewYN = '" & ViewYN & "', LevelJooName = '" & tLevelJoo & "',LevelJooNum = '" & tLevelJooNum & "', Entertype = '" & tEntertype & "',Payment ='" & tPayment & "', StadiumNum = '" & tStadiumNum & "'"
  'LSQL = LSQL & " Where GameLevelidx = '" & gameLevelIdx & "' and GameTitleIDX = '" & tidx & "'"

  LSQL = " Update tblGameLevel " 
  LSQL = LSQL & " SET Level  =  '" & TeamGBLevel & "',  PlayType  =  '" & playType  &"'  , TeamGb  = '" & teamGB & "'  , Sex  = '"  & sex & "'  , GroupGameGb  = '" & groupGameGb & "'  , GameDay  = '" & gameS &"' , LevelJooName = '" & tLevelJoo & "',LevelJooNum = '" & tLevelJooNum & "', Entertype = '" & tEntertype & "',Payment ='" & tPayment & "', StadiumNum = '" & tStadiumNum & "'"
  LSQL = LSQL & " Where GameLevelidx = '" & gameLevelIdx & "' and GameTitleIDX = '" & tidx & "'"

  'Response.Write LSQL & "<BR>"
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