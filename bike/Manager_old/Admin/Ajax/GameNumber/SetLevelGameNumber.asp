<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  REQ = Request("Req")
  'REQ = "{""CMD"":3,""tIDX"":""70848B6BA47E3010EF04E3E3929D83CF"",""tGameLevelIdxs"":""01CA8E9297ACA1C79966C806F23899C5_847DFAABFA63A01879C01A614719074A_27FD2BD0D2C8BA44A71D64D17C9212A0_BAFB4A24C645BFFAC061E3865FFD6DAF_380BDAD6457FA1C71597661FDA1280E5""}"
  
  Dim GameLevelCnt : GameLevelCnt = 0

  Set oJSONoutput = JSON.Parse(REQ)
  tIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tIdx))
  crypt_tIdx =crypt.EncryptStringENC(tIdx)
  tGameLevelIdxs= fInject(oJSONoutput.tGameLevelIdxs)
  arrayGameLevelIdxs = Split(tGameLevelIdxs,"_")

  'Response.Write "tIdx:" & tIdx & "<br>"
  'Response.Write "tGameLevelIdxs:" & tGameLevelIdxs & "<br>"
  for each enGameLevelIdx in arrayGameLevelIdxs 
    GameLevelCnt = GameLevelCnt + 1
    deGameLevelIdx = crypt.DecryptStringENC(enGameLevelIdx) 

    If( cdbl(deGameLevelIdx) > 0) Then
    LSQL = " UPDATE tblGameLevel "
    LSQL = LSQL & " Set GameNumber = '" & GameLevelCnt & "'"
    LSQL = LSQL & " WHERE DelYN = 'N' and GameLevelidx = '" & deGameLevelIdx & "'"
    'response.write( "LSQL : " & LSQL & "<br>")
    Set LRs = DBCon.Execute(LSQL)
    'response.write( "GameLevelCnt : " & GameLevelCnt & ",")
    'response.write( deGameLevelIdx & "<br />")
    End IF
  next

  
	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
%>
