<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  REQ = Request("REQ")
  'REQ = "{""CMD"":3,""tIDX"":""9832C70CDBBB6F8FB311345EF2AD1F2E"",""tGameLevelIDX"":""29368CD8CAA6BDA4216467E6BB245E36"",""tPGameLevelIDX"":""E80CB108C155AF181F42CE659C455E19""}"

  Dim pGameLevelCnt : pGameLevelCnt = 0

  Set oJSONoutput = JSON.Parse(REQ)
  tGameLevelIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tGameLevelIDX))
  tPGameLevelIDX= fInject(crypt.DecryptStringENC(oJSONoutput.tPGameLevelIDX))
  tIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tIDX))

  'Response.Write "tIDX :" & tIDX & "<BR>"
  'Response.Write "부모 tPGameLevelIDX :" & tPGameLevelIDX & "<BR>"
  'Response.Write "자신 tGameLevelIDX :" & tGameLevelIDX & "<BR>"

  


  IF( tGameLevelIDX <> "" and tIDX <> "") Then
    'LSQL = " DELETE FROM tblGameLevel " 
    'LSQL = LSQL & "   WHERE GameLevelidx = '" &  tGameLevelIDX & "' and GameTitleIDX = '" & tIDX & "'" 
    'Response.Write "SQL :" & LSQL & "<BR>"
    'Set LRs = DBCon.Execute(LSQL)

    'LSQL = " DELETE FROM tblGameLevelDtl " 
    'LSQL = LSQL & "   WHERE GameLevelidx = '" &  tGameLevelIDX & "'" 
    'Response.Write "SQL :" & LSQL & "<BR>"
    'Set LRs = DBCon.Execute(LSQL)

    LSQL = " Update tblGameLevel Set DelYN = 'Y' " 
    LSQL = LSQL & "   WHERE GameLevelidx = '" &  tGameLevelIDX & "' and GameTitleIDX = '" & tIDX & "'" 
    'Response.Write "SQL :" & LSQL & "<BR>"
    Set LRs = DBCon.Execute(LSQL)

    LSQL = " Update tblGameLevelDtl Set DelYN = 'Y' " 
    LSQL = LSQL & "   WHERE GameLevelidx = '" &  tGameLevelIDX & "'" 
    'Response.Write "SQL :" & LSQL & "<BR>"
    Set LRs = DBCon.Execute(LSQL)


    ' 1. 부모 레벨로 만들어진 자식 레벨이 몇개 있는지 확인
    LSQL = " SELECT Count(*) as pGameLevelCnt " 
    LSQL = LSQL & " FROM tblGameLevel " 
    LSQL = LSQL & "   WHERE DelYN='N' and PGameLevelidx = '" &  tPGameLevelIDX & "'" 
    Set LRs = DBCon.Execute(LSQL)
    IF NOT (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      pGameLevelCnt = LRs("pGameLevelCnt")
      LRs.MoveNext
    Loop
    End IF

    ' 자식 레벨이 없다면 부모 레벨을 자동으로 대진표가 있는 정보로 바꾸기.
    IF cdbl(pGameLevelCnt) = 0 Then
      LSQL = " Update tblGameLevel Set JooDivision = '0', UseYN = 'Y' " 
      LSQL = LSQL & "   WHERE GameLevelidx = '" &  tPGameLevelIDX & "'" 
      Set LRs = DBCon.Execute(LSQL)
    End IF
  End IF

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
  DBClose()
%>
