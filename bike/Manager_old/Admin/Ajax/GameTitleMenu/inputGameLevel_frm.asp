
<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  REQ = Request("REQ")
  'REQ = "{""CMD"":3,""tIDX"":""47E0533CF10C4690F617881B06E75784"",""tPlayType"":""704C5971F9D17ABC8687A215715ABCE6"",""tGroupGameGb"":""F9A43D4DE4191C125B08095CC465CD4B"",""tTeamGB"":""BF593DD3E782EC864107F23897C0095E"",""tGameS"":""2018-02-27"",""tGameSex"":""E300F22B66DC861AB9DA1717B0C3A093"",""tTeamGBLevel"":""AA41731A91BDE25CE1E3BAAAA81CA0D6"",""tViewYN"":""N"",""NowPage"":1,""tLevelJoo"":""2B4F14AE43DBCAD1D5BFD3285CE3A249"",""tLevelJooNum"":"""",""tEntertype"":""A"",""tPayment"":""10000"",""tStadiumNum"":""AF196D354C670EF37345CAC45C580C25""}"

  Set oJSONoutput = JSON.Parse(REQ)
	CMD = fInject(oJSONoutput.CMD)
  tIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tIDX))
  playType = fInject(crypt.DecryptStringENC(oJSONoutput.tplayType))
  groupGameGb = fInject(crypt.DecryptStringENC(oJSONoutput.tgroupGameGb ))
  teamGB = fInject(crypt.DecryptStringENC(oJSONoutput.tteamGB))
  gameS = fInject(oJSONoutput.tgameS)
  gameSex = fInject(crypt.DecryptStringENC(oJSONoutput.tgameSex))
  'viewYN = fInject(oJSONoutput.tviewYN)
  teamGBLevel =fInject(crypt.DecryptStringENC( oJSONoutput.tteamGBLevel))
  tEntertype =fInject(oJSONoutput.tEntertype)
  tPayment = fInject(oJSONoutput.tPayment)
  tStadiumNum   = fInject(crypt.DecryptStringENC(oJSONoutput.tStadiumNum))
  tLevelJoo = ""
  tLevelJooNum = ""

  'Response.Write "tIDX" & tIDX & "<br>"
  'Response.Write "playType" & playType & "<br>"
  'Response.Write "groupGameGb" & groupGameGb & "<br>"
  'Response.Write "teamGB" & teamGB & "<br>"
  'Response.Write "gameS" & gameS & "<br>"
  'Response.Write "gameSex" & gameSex & "<br>"
  'Response.Write "viewYN" & viewYN & "<br>"
  'Response.Write "teamGBLevel" & teamGBLevel & "<br>"

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

  '아마추어는 조와 조번호가 있다.
  
  tLevelJoo = fInject(crypt.DecryptStringENC(oJSONoutput.tLevelJoo))
  tLevelJooNum = fInject(oJSONoutput.tLevelJooNum)
  


  'Response.Write "tLevelJoo" & tLevelJoo & "<br>"
  'Response.Write "tLevelJooNum" & tLevelJooNum & "<br>"

  '단체전일 경우 playType을 정할 수 없다.
  if groupGameGb = "B0030002" Then
    playType = ""
  End if
  

  'LSQL = " SET NOCOUNT ON insert into tblGameLevel " 
  'LSQL = LSQL & " ( GameTitleIDX, playType, groupGameGb ,TeamGb, GameDay, SEX, viewYN, Level, LevelJooName, LevelJooNum, Entertype,Payment, StadiumNum) "
  'LSQL = LSQL & " values ('"&tIDX & "','"&playType & "','" &  groupGameGb & "' ,'" & teamGB & "','" & gameS & "','" & gameSex & "', '" & viewYN &"','" & teamGBLevel & "','" & tLevelJoo &"','" & tLevelJooNum &"','" & tEntertype & "','" & tPayment & "','" & tStadiumNum & "')" 
  'LSQL = LSQL & " SELECT @@IDENTITY as IDX "

  LSQL = " SET NOCOUNT ON insert into tblGameLevel " 
  LSQL = LSQL & " ( GameTitleIDX, playType, groupGameGb ,TeamGb, GameDay, SEX, viewYN, Level, LevelJooName, LevelJooNum, Entertype,Payment, StadiumNum) "
  LSQL = LSQL & " values ('"&tIDX & "','"&playType & "','" &  groupGameGb & "' ,'" & teamGB & "','" & gameS & "','" & gameSex & "', 'Y','" & teamGBLevel & "','" & tLevelJoo &"','" & tLevelJooNum &"','" & tEntertype & "','" & tPayment & "','" & tStadiumNum & "')" 
  LSQL = LSQL & " SELECT @@IDENTITY as IDX "

  'Response.Write "SQL :" & LSQL & "<BR>"

  Set LRs = DBCon.Execute(LSQL)
  
  IF NOT (LRs.Eof Or LRs.Bof) Then
      Do Until LRs.Eof
      IDX = LRs("IDX")
    LRs.MoveNext
    Loop
  End If  

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
%>


<%
  DBClose()
%>