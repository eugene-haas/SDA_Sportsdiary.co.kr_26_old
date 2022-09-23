<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  REQ = Request("Req")
  'REQ = "{""CMD"":1,""tIDX"":""9832C70CDBBB6F8FB311345EF2AD1F2E"",""tGAMELEVELIDX"":""0FD7B9606B580287A751F7F11E6E530A""}"
  Set oJSONoutput = JSON.Parse(REQ)
  tIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tIdx))
	tGameLevelIDX = fInject(crypt.DecryptStringENC(oJSONoutput.TGAMELEVELIDX))
  crypt_tGameLevelIDX =crypt.EncryptStringENC(tGameLevelIDX)
%>

<%
  LSQL = " SELECT Top 1 GameLevelidx, GameTitleIDX, PlayType, GameType, TeamGb,Level, Sex, GroupGameGb, GameDay, GameTime,ViewYN, LevelJooName, LevelJooNum, JooDivision, EnterType, Payment, StadiumNum"
  LSQL = LSQL & " FROM  tblGameLevel "
  LSQL = LSQL & " WHERE GameLevelidx = '"  & tGameLevelIDX  & "' and GameTitleIDX= '" & tidx & "'"

  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      selGameLevelIDX = LRs("GameLevelidx")
      enSelGameLevelIDX  = crypt.EncryptStringENC(selGameLevelIDX )
      tPlayType = LRS("PlayType")
      tTeamGb = LRS("TeamGb")
      tLevel = LRS("Level")
      tSex = LRS("Sex")
      tGroupGameGb = LRS("GroupGameGb")
      tGameDay = LRS("GameDay")
      tViewYN = LRS("ViewYN")
      tLevelJooName = LRS("LevelJooName")
      tLevelJooNum = LRS("LevelJooNum")
      tJooDivision = LRS("JooDivision")
      tEnterType = LRS("EnterType") 
      tPayment = LRS("Payment")
      tStadiumNum = LRS("StadiumNum") 
      LRs.MoveNext
    Loop
  End IF
 
  Call oJSONoutput.Set("selGameLevelIDX", enSelGameLevelIDX )
	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
  'Response.write "LSQL : " & LSQL
%>


 
