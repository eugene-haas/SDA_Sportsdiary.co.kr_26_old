<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  REQ = Request("REQ")
  'REQ = "{""CMD"":18,""tIDX"":""70848B6BA47E3010EF04E3E3929D83CF"",""tGameLevelIdx"":""AB8130D0ABFA78C693F19937B60FE4ED""}"

  Set oJSONoutput = JSON.Parse(REQ)
  tGameLevelIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameLevelIdx))
  tIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tIDX))

  'Response.Write "CMD :" & CMD & "<BR>"
  'Response.Write "tGameLevelIdx :" & tGameLevelIdx & "<BR>"
  'Response.Write "tIDX :" & tIDX & "<BR>"

  IF( tGameLevelIdx <> "" and tIDX <> "") Then
    '자식이 있는지 확인 
    LSQL = " SELECT Count(*) as Cnt " 
    LSQL = LSQL & " FROM tblGameLevel " 
    LSQL = LSQL & " WHERE PGameLevelidx = '" &  tGameLevelIDX & "' and GameTitleIDX = '" & tIDX & "' and DelYN ='N'" 
    'Response.Write "SQL :" & LSQL & "<BR>"
    Set LRs = DBCon.Execute(LSQL)
 
    IF NOT (LRs.Eof Or LRs.Bof) Then
        Do Until LRs.Eof
        'LCnt = LCnt + 1
        LevelCnt = LRs("Cnt")
      LRs.MoveNext
      Loop
    End If  

    IF CDBL(LevelCnt) <> cdbl(0)  Then
      Call oJSONoutput.Set("result", 1 )
	    strjson = JSON.stringify(oJSONoutput)
	    Response.Write strjson
      Response.End
    ELSE

      LSQL = " SELECT Top 1 UseYN" 
      LSQL = LSQL & " FROM tblGameLevel " 
      LSQL = LSQL & " WHERE GameLevelidx = '" &  tGameLevelIDX & "' and GameTitleIDX = '" & tIDX & "' and DelYN ='N'" 
      'Response.Write "SQL :" & LSQL & "<BR>"
      Set LRs = DBCon.Execute(LSQL)
  
      IF NOT (LRs.Eof Or LRs.Bof) Then
          Do Until LRs.Eof
      
          UseYN = LRs("UseYN")
        LRs.MoveNext
        Loop
      End If  

      If UseYN = "N" Then
      LSQL = " Update tblGameLevel " 
      LSQL = LSQL & " SET UseYN = 'Y'"
      LSQL = LSQL & " WHERE GameLevelidx = '" &  tGameLevelIDX & "' and GameTitleIDX = '" & tIDX & "' and DelYN ='N'" 
      'Response.Write "SQL :" & LSQL & "<BR>"
      Set LRs = DBCon.Execute(LSQL)

      Call oJSONoutput.Set("result", 0 )
	    strjson = JSON.stringify(oJSONoutput)
	    Response.Write strjson
      Response.End
      ELSE
      Call oJSONoutput.Set("result", 2 )
	    strjson = JSON.stringify(oJSONoutput)
	    Response.Write strjson
      Response.End
      End IF
    End IF

    'LSQL = " DELETE FROM tblGameLevelDtl " 
    'LSQL = LSQL & "   WHERE GameLevelidx = '" &  tGameLevelIDX & "'" 
    'Response.Write "SQL :" & LSQL & "<BR>"
    'Set LRs = DBCon.Execute(LSQL)

    'LSQL = " Update tblGameLevel Set DelYN = 'Y' " 
    'LSQL = LSQL & "   WHERE GameLevelidx = '" &  tGameLevelIDX & "' and GameTitleIDX = '" & tIDX & "'" 
    'Response.Write "SQL :" & LSQL & "<BR>"
    'Set LRs = DBCon.Execute(LSQL)

    'LSQL = " Update tblGameLevelDtl Set DelYN = 'Y' " 
    'LSQL = LSQL & "   WHERE GameLevelidx = '" &  tGameLevelIDX & "'" 
    'Response.Write "SQL :" & LSQL & "<BR>"
    'Set LRs = DBCon.Execute(LSQL)
  End IF


	
  
  DBClose()
%>
