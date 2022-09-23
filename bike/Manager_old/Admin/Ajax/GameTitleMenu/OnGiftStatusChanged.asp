<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<script language="Javascript" runat="server">

function hasown(obj,  prop){
	if (obj.hasOwnProperty(prop) == true){
		return "ok";
	}
	else{
		return "notok";
	}
}
</script>

<%
  REQ = Request("Req")
  'REQ = "{""CMD"":5,""tGameTitleIDX"":""C4F45D4766A741AF49900107ACE44658"",""tGameLevelDtlidx"":""090D6DAF05BA220EDE09B5392FA2E655"",""tRequestIDX"":""FEFAD3F366578919A2C0EE2AECFD4DBE"",""tGiftCheck"":""Y"",""tGroupGameGb"":""F9A43D4DE4191C125B08095CC465CD4B""}"
  'REQ = "{""CMD"":1,""tGameTitleIdx"":""9832C70CDBBB6F8FB311345EF2AD1F2E""}"

  Dim constGroupGameGb_Person : constGroupGameGb_Person = "B0030001"
  Dim constGroupGameGb_Team : constGroupGameGb_Team = "B0030002"

  Set oJSONoutput = JSON.Parse(REQ)
  reqGameTitleIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameTitleIdx))
  crypt_reqGameTitleIdx =crypt.EncryptStringENC(tGameTitleIdx)

  If hasown(oJSONoutput, "tGameLevelDtlidx") = "ok" then
    reqGameLevelDtlidx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameLevelDtlidx))
    crypt_reqGameLevelDtlidx =crypt.EncryptStringENC(reqGameLevelDtlidx)
  Else
    reqGameTitleIDX = "" ' 개인전(B0030001), 단체전(B0030002)
    crypt_reqGameTitleIDX = ""
  End if	


  If hasown(oJSONoutput, "tGiftCheck") = "ok" then
    reqGiftCheck = fInject(oJSONoutput.tGiftCheck)
    crypt_reqGiftCheck = "" 
  End if	

  If hasown(oJSONoutput, "tGroupGameGb") = "ok" then
    reqGroupGameGb = fInject(crypt.DecryptStringENC(oJSONoutput.tGroupGameGb))
    crypt_reqGroupGameGb= fInject(crypt.EncryptStringENC(reqGroupGameGb))
  End if	

  If hasown(oJSONoutput, "tRequestIDX") = "ok" then
    reqRequestIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tRequestIDX))
    crypt_reqRequestIDX= fInject(crypt.EncryptStringENC(reqRequestIDX))
  End if	

  Response.Write "reqGameTitleIDX : " & reqGameTitleIDX & "<br/>"
  Response.Write "reqGameLevelDtlidx : " & reqGameLevelDtlidx & "<br/>"
  Response.Write "reqRequestIDX : " & reqRequestIDX & "<br/>"
  Response.Write "reqGroupGameGb : " & reqGroupGameGb & "<br/>"
  Response.Write "reqGiftCheck : " & reqGiftCheck & "<br/>"
    

  IF reqGroupGameGb = constGroupGameGb_Person Then
    LSQL = " Update tblGameMedal Set  IsGift = '" & reqGiftCheck  & "'" 
    LSQL = LSQL & " WHERE GameLevelDtlIDX = '" & reqGameLevelDtlidx & "' and RequestIdx = '" & reqRequestIDX & "'"
    Set LRs = DBCon.Execute(LSQL)
  ElseIF reqGroupGameGb = constGroupGameGb_Team Then
    LSQL = " Update tblGameMedal Set  IsGift = '" & reqGiftCheck  & "'" 
    LSQL = LSQL & " WHERE GameLevelDtlIDX = '" & reqGameLevelDtlidx & "' and RequestIdx = '" & reqRequestIDX & "'"
    Set LRs = DBCon.Execute(LSQL)
  END IF

  Response.Write "LSQL : " & LSQL & "<br/>"
  '예선 본선 값 설정

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
  
  DBClose()
%>
