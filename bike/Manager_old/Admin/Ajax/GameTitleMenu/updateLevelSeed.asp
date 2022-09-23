

<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  
  REQ = Request("REQ")
  'REQ = "{""CMD"":14,""tGameLevelIDX"":""8AA0D4536ED0294111F91E3943162F17"",""SEEDCNT"":""2""}"

  Set oJSONoutput = JSON.Parse(REQ)
	CMD = fInject(oJSONoutput.CMD)
  tGameLevelIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tGameLevelIDX))
  crypt_tGameLevelidx =crypt.EncryptStringENC(tGameLevelIDX)
  SEEDCNT = fInject(oJSONoutput.SEEDCNT)


  IF( cdbl(tGameLevelIDX) > 0 ) Then
    LSQL = " UPDATE  tblGameLevel " 
    'LSQL = LSQL & " SET EntryCnt = '" & tEntryCnt & "', PlayLevelType  =  '" & tPlayLevelType & "',  GameType  =  '" & tGameType & "', StadiumNumber  = '" & tStadiumNumber &"'  , TotRound  = '" & tTotalRound & "'  , GameDay  = '"  & tGameDay & "'  , GameTime  = '" & tGameTime & "', ViewYN = '" & ViewYN & "', LevelJooName = '" & tLevelJoo & "',LevelJooNum = '" & tLevelJooNum & "'" 
    LSQL = LSQL & " SET SeedCnt = '" & SEEDCNT & "'"
    LSQL = LSQL & " Where GameLevelidx = '" & tGameLevelIDX & "'"
    'Response.Write LSQL
    Set LRs = DBCon.Execute(LSQL)


     '------------------------PGameLevel에 본선에 올라간 순위 적용-----------------------
      LSQL = " SELECT COUNT(*) as Cnt  "
      LSQL = LSQL & " FROM  tblGameLevel "
      LSQL = LSQL & "  where PGameLevelidx = " & tGameLevelIDX & " and Delyn ='n'"
      'Response.Write "LSQL : " & LSQL & "<BR>"
      Set LRs = DBCon.Execute(LSQL)
      
      If Not (LRs.Eof Or LRs.Bof) Then
        Do Until LRs.Eof
            iPCnt = LRs("Cnt")
            LRs.MoveNext
        Loop
      End If 

      IF cdbl(iPCnt) > 0 Then
      
        '경기타입 (단식,복식,혼합복식)
        LSQL = " SELECT  GameLevelidx  "
        LSQL = LSQL & " FROM  tblGameLevel "
        LSQL = LSQL & " WHERE DelYN = 'N' and PGameLevelidx = '"  & tGameLevelIDX  & "'"

        Set LRs = DBCon.Execute(LSQL)
        IF NOT (LRs.Eof Or LRs.Bof) Then
          tblGameLevels = LRs.getrows()
        End If
        
        If IsArray(tblGameLevels) Then
          For ar = LBound(tblGameLevels, 2) To UBound(tblGameLevels, 2) 
            childGameLevelIdx		= tblGameLevels(0, ar) 

            LSQL = " UPDATE  tblGameLevel " 
            'LSQL = LSQL & " SET EntryCnt = '" & tEntryCnt & "', PlayLevelType  =  '" & tPlayLevelType & "',  GameType  =  '" & tGameType & "', StadiumNumber  = '" & tStadiumNumber &"'  , TotRound  = '" & tTotalRound & "'  , GameDay  = '"  & tGameDay & "'  , GameTime  = '" & tGameTime & "', ViewYN = '" & ViewYN & "', LevelJooName = '" & tLevelJoo & "',LevelJooNum = '" & tLevelJooNum & "'" 
            LSQL = LSQL & " SET SeedCnt = '" & SEEDCNT & "'"
            LSQL = LSQL & " Where GameLevelidx = '" & childGameLevelIdx & "'"
            'Response.Write LSQL
            DBCon.Execute(LSQL)
          Next
        End If
      End IF
      '------------------------PGameLevel에 본선에 올라간 순위 적용-----------------------

  End IF

  LSQL = "SELECT SeedCnt "
  LSQL = LSQL & " FROM  tblGameLevel"
  LSQL = LSQL & " WHERE GameLevelidx = " &  tGameLevelIDX
  'Response.Write "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL : " & LSQL

  Set LRs = DBCon.Execute(LSQL)
  If Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      tSeedCnt = LRs("SeedCnt")
      LRs.MoveNext
    Loop
  End If
  LRs.close

  
  'Call oJSONoutput.Set("result", 0 )
	'strjson = JSON.stringify(oJSONoutput)
	'Response.Write strjson

  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"
%>

<label for="txtSeedCnt_<%=crypt_tGameLevelidx%>">시드개수</label>
<input  class="ipt-value"  type="text" id="txtSeedCnt_<%=crypt_tGameLevelidx%>" name="txtSeedCnt_<%=crypt_tGameLevelidx%>" value="<%=tSeedCnt%>">
<input type="Button"  class="ipt-assign" id="btnLevelSeed" name="btnLevelSeed" value="적용" onclick="javascript:ApplyLevelSeed('<%=crypt_tGameLevelidx%>')">

<%
  DBClose()
%>


