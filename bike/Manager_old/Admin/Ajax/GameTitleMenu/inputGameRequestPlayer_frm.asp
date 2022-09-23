
<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  REQ = Request("REQ")
  'REQ = "{""CMD"":2,""tGameTitleIDX"":""9832C70CDBBB6F8FB311345EF2AD1F2E"",""tGameLevelIdx"":""E38577C1E203DFC6DA2B87B205A7DC51"",""tPlayType"":""704C5971F9D17ABC8687A215715ABCE6"",""tGroupGameGb"":""F9A43D4DE4191C125B08095CC465CD4B"",""tMemberName1"":""김지민"",""tMemberIdx1"":""EF992B1164029F84D8BF645B2DA88CF4"",""tTeam1"":""14389A7BD501CF41BA63138E46E4ED7E"",""tTeamName1"":""웅상중"",""NowPage"":1}"

  Set oJSONoutput = JSON.Parse(REQ)

	CMD = fInject(oJSONoutput.CMD)
   '------------------------대회 기본 정보-------------------------------
  tIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tGameTitleIDX))
  tGameLevelIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameLevelIdx))
  tGroupGameGb = fInject(crypt.DecryptStringENC(oJSONoutput.tGroupGameGb))
  tPlayType = fInject(crypt.DecryptStringENC(oJSONoutput.tPlayType))
  '---------------------------------------------------------------------

  '개인전 첫번째 선수
  tMemberIdx1 = fInject(crypt.DecryptStringENC(oJSONoutput.tMemberIdx1))
  tMemberName1 = oJSONoutput.tMemberName1
  tTeam1 = fInject(crypt.DecryptStringENC(oJSONoutput.tTeam1))
  tTeamName1 = oJSONoutput.tTeamName1

  '-----------------------------------------------------------------------
  ' tPlayType = 복식 
  ' 두번째 선수
  '------------------------복식일 경우 두번재 선수---------------------
  IF tPlayType = "B0020002" Then
    tMemberIdx2 = fInject(crypt.DecryptStringENC(oJSONoutput.tMemberIdx2))
    tMemberName2 = fInject(oJSONoutput.tMemberName2)
    tTeam2 = fInject(crypt.DecryptStringENC(oJSONoutput.tTeam2))
    tTeamName2 = fInject(oJSONoutput.tTeamName2)
  End IF
  '------------------------------------------------------------------
  

  '------------------------------- 대회 정보 ------------------------------
  LSQL = " SELECT Top 1 GameTitleName, EnterType  "
  LSQL = LSQL & " FROM  tblGameTitle "
  LSQL = LSQL & " WHERE DelYN = 'N' and GameTitleIDX = " & tidx

  Set LRs = DBCon.Execute(LSQL)
   IF NOT (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      tGameTitleName = LRS("GameTitleName")
			tEnterType = LRS("EnterType")
      LRs.MoveNext
    Loop
  End IF
  '-----------------------------------------------------------------------

  '개인전 그룹
  LSQL = " SET NOCOUNT ON insert into tblGameRequestGroup " 
  LSQL = LSQL & " ( GameTitleIDX, GameLevelIDX, GameTitleName, EnterType, GroupGameGb, Team) "
  LSQL = LSQL & " values ('"&tIDX & "','" &  tGameLevelIdx & "','" & tGameTitleName & "','" & tEnterType & "','" & "B0030001" &"','"&tTeam1&"')" 
  LSQL = LSQL & " SELECT @@IDENTITY as IDX "
  'Response.Write "SQL :" & LSQL & "<BR>"
  
  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
      Do Until LRs.Eof
      GroupRequestIdx = LRs("IDX")
    LRs.MoveNext
    Loop
  End If  

  '선수가 이미 등록되있는지 체크
  LSQL = " SET NOCOUNT ON insert into tblGameRequestPlayer " 
  LSQL = LSQL & " ( GameTitleIDX, GameLevelIDX, GameRequestGroupIDX ,MemberIDX, MemberName, Team, TeamName) "
  LSQL = LSQL & " values ('"&tIDX & "','" &  tGameLevelIdx & "' ,'"  &  GroupRequestIdx & "' ,'" & tMemberIdx1 & "','" & tMemberName1 & "','" & tTeam1 & "', '" & tTeamName1 &"')" 
  LSQL = LSQL & " SELECT @@IDENTITY as IDX "

    Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
      Do Until LRs.Eof
      PlayerIdx_1 = LRs("IDX")
    LRs.MoveNext
    Loop
  End If  

  'Response.Write "SQL :" & LSQL & "<BR>"
  IF tPlayType = "B0020002" Then
    LSQL = " SET NOCOUNT ON insert into tblGameRequestPlayer " 
    LSQL = LSQL & " ( GameTitleIDX, GameLevelIDX, GameRequestGroupIDX,MemberIDX, MemberName, Team, TeamName) "
    LSQL = LSQL & " values ('"&tIDX & "','" &  tGameLevelIdx & "' ,'" & GroupRequestIdx & "' ,'" & tMemberIdx2 & "','" & tMemberName2 & "','" & tTeam2 & "', '" & tTeamName2 &"')" 
    LSQL = LSQL & " SELECT @@IDENTITY as IDX "

    Set LRs = DBCon.Execute(LSQL)
    IF NOT (LRs.Eof Or LRs.Bof) Then
        Do Until LRs.Eof
        PlayerIdx_2 = LRs("IDX")
      LRs.MoveNext
      Loop
    End IF
  End IF

  '------------------------------- 부모 종별 정보 ------------------------------
  LSQL = " SELECT Top 1 Isnull(PGameLevelidx,'0') as PGameLevelidx  "
  LSQL = LSQL & " FROM tblGameLevel "
  LSQL = LSQL & " WHERE GameLevelidx = '"& tGameLevelIdx  &"' and DelYN ='N'"
  'LSQL = LSQL & " WHERE GameLevelidx = '" & tGameLevelIdx  &"' and DelYN ='N'"

  Set LRs = DBCon.Execute(LSQL)
   IF NOT (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      tPGameLevelidx = LRS("PGameLevelidx")
      LRs.MoveNext
    Loop
  End IF

  IF CDBL(tPGameLevelidx) <> CDBL(0) Then
      '개인전 그룹
    LSQL = " SET NOCOUNT ON insert into tblGameRequestGroup " 
    LSQL = LSQL & " ( GameTitleIDX, GameLevelIDX, GameTitleName, EnterType, GroupGameGb, Team) "
    LSQL = LSQL & " values ('"&tIDX & "','" &  tPGameLevelidx & "','" & tGameTitleName & "','" & tEnterType & "','" & "B0030001" &"','"&tTeam1&"')" 
    LSQL = LSQL & " SELECT @@IDENTITY as IDX "
    'Response.Write "SQL :" & LSQL & "<BR>"
    
    Set LRs = DBCon.Execute(LSQL)
    IF NOT (LRs.Eof Or LRs.Bof) Then
        Do Until LRs.Eof
        PGroupRequestIdx = LRs("IDX")
      LRs.MoveNext
      Loop
    End If  

    '선수가 이미 등록되있는지 체크
    LSQL = " SET NOCOUNT ON insert into tblGameRequestPlayer " 
    LSQL = LSQL & " ( GameTitleIDX, GameLevelIDX, GameRequestGroupIDX ,MemberIDX, MemberName, Team, TeamName) "
    LSQL = LSQL & " values ('"&tIDX & "','" &  tPGameLevelidx & "' ,'"  &  PGroupRequestIdx & "' ,'" & tMemberIdx1 & "','" & tMemberName1 & "','" & tTeam1 & "', '" & tTeamName1 &"')" 
    LSQL = LSQL & " SELECT @@IDENTITY as IDX "

      Set LRs = DBCon.Execute(LSQL)
    IF NOT (LRs.Eof Or LRs.Bof) Then
        Do Until LRs.Eof
        PPlayerIdx_1 = LRs("IDX")
      LRs.MoveNext
      Loop
    End If  

    'Response.Write "SQL :" & LSQL & "<BR>"
    IF tPlayType = "B0020002" Then
      LSQL = " SET NOCOUNT ON insert into tblGameRequestPlayer " 
      LSQL = LSQL & " ( GameTitleIDX, GameLevelIDX, GameRequestGroupIDX,MemberIDX, MemberName, Team, TeamName) "
      LSQL = LSQL & " values ('"&tIDX & "','" &  tPGameLevelidx & "' ,'" & PGroupRequestIdx & "' ,'" & tMemberIdx2 & "','" & tMemberName2 & "','" & tTeam2 & "', '" & tTeamName2 &"')" 
      LSQL = LSQL & " SELECT @@IDENTITY as IDX "

      Set LRs = DBCon.Execute(LSQL)
      IF NOT (LRs.Eof Or LRs.Bof) Then
          Do Until LRs.Eof
          PPlayerIdx_2 = LRs("IDX")
        LRs.MoveNext
        Loop
      End IF
    End IF
  End IF


  '-----------------------------------------------------------------------



 
	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
%>

<%
  DBClose()
%>