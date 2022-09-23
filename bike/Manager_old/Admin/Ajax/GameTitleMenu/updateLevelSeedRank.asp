

<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%

  REQ = Request("REQ")
  'REQ = "{""CMD"":16,""tGameLevelIDX"":""8AA0D4536ED0294111F91E3943162F17"",""RANKNUM"":""3""}"
  Set oJSONoutput = JSON.Parse(REQ)
	CMD = fInject(oJSONoutput.CMD)
  tGameLevelIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tGameLevelIDX))
  crypt_tGameLevelidx =crypt.EncryptStringENC(tGameLevelIDX)
  RANKNUM = fInject(oJSONoutput.RANKNUM)

  Dim iPCnt : iPCnt = 0

  'Response.Write "CMD : " & CMD & "<BR>"
  'Response.Write "tGameLevelIDX : " & tGameLevelIDX & "<BR>"
  'Response.Write "RANKNUM : " & RANKNUM & "<BR>"

  IF( cdbl(tGameLevelIDX) > 0 ) Then
      ' -----------------1.랭킹 업데이트-------------------
      LSQL = " UPDATE  tblGameLevel " 
      LSQL = LSQL & " SET JooRank = '" & RANKNUM & "'"
      LSQL = LSQL & " Where GameLevelidx = '" & tGameLevelIDX & "'"
      'Response.Write LSQL
      DBCon.Execute(LSQL)
      ' -----------------1.랭킹 업데이트--------------------

      ' -----------------2.예선 본선 랭킹 업데이트--------------------
      LSQL = " UPDATE  tblGameLevelDtl " 
      LSQL = LSQL & " SET JooRank = '" & RANKNUM & "'"
      LSQL = LSQL & " Where GameLevelidx = '" & tGameLevelIDX & "'"
      LSQL = LSQL & " AND DelYN = 'N'"
      LSQL = LSQL & " AND PlayLevelType <> 'B0100002'"
      'Response.Write LSQL
      DBCon.Execute(LSQL)
      ' -----------------2.예선 본선 랭킹 업데이트--------------------

      'LSQL = " SELECT ISNULL(SUM(CONVERT(INT,ISNULL(JooRank,'0'))),'0') AS PlayerCnt"
      'LSQL = LSQL & " FROM tblGameLevelDtl"
      'LSQL = LSQL & " WHERE DelYN = 'N'"
      'LSQL = LSQL & " AND GameLevelIDX = '" & tGameLevelIDX & "'"
      'LSQL = LSQL & " AND PlayLevelType <> 'B0100002'"
      'Response.Write LSQL
      'Set LRs = DBCon.Execute(LSQL)
      'If Not (LRs.Eof Or LRs.Bof) Then
      '    PlayerCnt = Cint(LRs("PlayerCnt"))
      'End If
      'LRs.close

      'If PlayerCnt <= 4 Then
      '  B_TotRound = "4"
      'ElseIf PlayerCnt <= 8 Then
      '  B_TotRound = "8"
      'ElseIf PlayerCnt <= 16 Then
      '  B_TotRound = "16"
      'ElseIf PlayerCnt <= 32 Then
      '  B_TotRound = "32"
      'ElseIf PlayerCnt <= 64 Then
      '  B_TotRound = "64"
      'ElseIf PlayerCnt <= 128 Then
      '  B_TotRound = "128"
      'ElseIf PlayerCnt <= 256 Then
      '  B_TotRound = "256"
      'ElseIf PlayerCnt <= 512 Then
      '  B_TotRound = "512"
      'End If

      'LSQL = " UPDATE tblGameLevelDtl SET  TotRound = '" & B_TotRound & "'"
      'LSQL = LSQL & " WHERE DelYN = 'N'"
      'LSQL = LSQL & " AND GameLevelIDX = '" & tGameLevelIDX & "'"
      'LSQL = LSQL & " AND PlayLevelType = 'B0100002'"
      'LSQL = LSQL & " AND ISNULL(LevelDtlName,'') = ''"
      'DBCon.Execute(LSQL)

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
            LSQL = LSQL & " SET JooRank = '" & RANKNUM & "'"
            LSQL = LSQL & " Where GameLevelidx = '" & childGameLevelIdx & "'"
            'Response.Write LSQL
            DBCon.Execute(LSQL)

            '각 대진표 본선진출순위 UPDATE
            LSQL = " UPDATE  tblGameLevelDtl " 
            'LSQL = LSQL & " SET EntryCnt = '" & tEntryCnt & "', PlayLevelType  =  '" & tPlayLevelType & "',  GameType  =  '" & tGameType & "', StadiumNumber  = '" & tStadiumNumber &"'  , TotRound  = '" & tTotalRound & "'  , GameDay  = '"  & tGameDay & "'  , GameTime  = '" & tGameTime & "', ViewYN = '" & ViewYN & "', LevelJooName = '" & tLevelJoo & "',LevelJooNum = '" & tLevelJooNum & "'" 
            LSQL = LSQL & " SET JooRank = '" & RANKNUM & "'"
            LSQL = LSQL & " Where GameLevelidx = '" & childGameLevelIdx & "'"
            LSQL = LSQL & " AND DelYN = 'N'"
            LSQL = LSQL & " AND PlayLevelType <> 'B0100002'"
            'Response.Write LSQL
            DBCon.Execute(LSQL)
            'Response.Write "childGameLevelIdx : " & childGameLevelIdx  & "<br>"
          Next
        End If
      End IF
      '------------------------PGameLevel에 본선에 올라간 순위 적용-----------------------
  End IF

  '------------------------업데이트든 순위 가져오기-----------------------
  LSQL = "SELECT JooRank "
  LSQL = LSQL & " FROM  tblGameLevel"
  LSQL = LSQL & " WHERE GameLevelidx = " &  tGameLevelIDX
  'Response.Write "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL : " & LSQL

  Set LRs = DBCon.Execute(LSQL)
  If Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      tJooRank = LRs("JooRank")
      LRs.MoveNext
    Loop
  End If
  LRs.close
  '------------------------업데이트든 순위 가져오기-----------------------

  
  'Call oJSONoutput.Set("result", 0 )
	'strjson = JSON.stringify(oJSONoutput)
	'Response.Write strjson

  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"
%>
  <label for="txtGoUpRank_<%=crypt_tGameLevelidx%>">본선 순위</label>
  <input style="width:30px" type="text" id="txtGoUpRank_<%=crypt_tGameLevelidx%>" name="txtGoUpRank_<%=crypt_tGameLevelidx%>"  value="<%=tJooRank%>">
  <input type="Button" id="btnLevelRank" name="btnLevelRank" value="적용" onclick="javascript:ApplyLevelRank('<%=crypt_tGameLevelidx%>')">
<%
  DBClose()
%>


