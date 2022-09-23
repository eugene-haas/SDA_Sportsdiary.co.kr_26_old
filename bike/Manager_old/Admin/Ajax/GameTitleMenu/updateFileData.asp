
<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  REQ = Request("REQ")
  'REQ = "{""CMD"":5,""tIDX"":""9832C70CDBBB6F8FB311345EF2AD1F2E"",""tGameLevelIdx"":""E80CB108C155AF181F42CE659C455E19"",""tTeamGB"":""BF593DD3E782EC864107F23897C0095E"",""tPlayType"":""704C5971F9D17ABC8687A215715ABCE6"",""tTeamGBLevel"":""AA41731A91BDE25CE1E3BAAAA81CA0D6"",""tGroupGameGb"":""F9A43D4DE4191C125B08095CC465CD4B"",""tGameS"":""2018-03-06"",""tGameSex"":""E300F22B66DC861AB9DA1717B0C3A093"",""tViewYN"":""N"",""tLevelJoo"":""2B4F14AE43DBCAD1D5BFD3285CE3A249"",""tLevelJooNum"":"""",""tEntertype"":""A"",""tPayment"":""10000"",""tStadiumNum"":""0""}"

  Set oJSONoutput = JSON.Parse(REQ)
	CMD = fInject(oJSONoutput.CMD)
  tIDX =  fInject(crypt.DecryptStringENC(oJSONoutput.tddIDX))
  
  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"
%>

<%
  DBClose()
%>