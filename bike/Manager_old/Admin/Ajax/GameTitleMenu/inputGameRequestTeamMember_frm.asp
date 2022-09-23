
<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  REQ = Request("REQ")
  'REQ = "{""CMD"":2,""tGameTitleIDX"":""B982ED46B36E629292ABE4DFB9242C60"",""tGameLevelIdx"":""890B09C57E3E5953C188AA071FCC1812"",""tGameRequestTeamIdx"":""24778D9FDE7FB939ACE097AD03CD4A9D"",""tTeam"":""BA00024"",""tMemberName"":""김태형"",""tMemberIdx"":""3F783640258DEB3BC045168557B9EE32"",""tTeamName"":""이천중"",""NowPage"":1}"

  Set oJSONoutput = JSON.Parse(REQ)

	CMD = oJSONoutput.CMD
   '------------------------대회 기본 정보-------------------------------
  tIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tGameTitleIDX))
  tGameLevelIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameLevelIdx))
  tGameRequestTeamIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameRequestTeamIdx))
  '---------------------------------------------------------------------
  '단체 선수
  tMemberIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tMemberIdx))
  tMemberName = oJSONoutput.tMemberName
  tTeam = fInject(crypt.DecryptStringENC(oJSONoutput.tTeam))
  tTeamName = oJSONoutput.tTeamName
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
  'Response.Write "tIDX : " & tIDX & "<br>"
  'Response.Write "tGameLevelIdx : " & tGameLevelIdx & "<br>"
  'Response.Write "tGameRequestTeamIdx : " & tGameRequestTeamIdx & "<br>"
  'Response.Write "tGameTitleName : " & tGameTitleName & "<br>"
  'Response.Write "tEnterType : " & tEnterType & "<br>"
  'Response.Write "tMemberIdx : " & tMemberIdx & "<br>"
  'Response.Write "tMemberName : " & tMemberName & "<br>"
  'Response.Write "tTeam : " & tTeam & "<br>"
  'Response.Write "tTeamName : " & tTeamName & "<br>"

  'Response.end
  LSQL = " SELECT GameRequestGroupIDX  " 
  LSQL = LSQL & "  FROM tblGameRequestGroup "
  LSQL = LSQL & "   where GameRequestTeamIDX = " & tGameRequestTeamIdx & " and DELYN = 'N' and GameTitleIDX = " & tIDX & " and GameLevelIdx = " & tGameLevelIdx
  'Response.Write "SQL :" & LSQL & "<BR>"
  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
      Do Until LRs.Eof
      GameRequestGroupIDX = LRs("GameRequestGroupIDX")
    LRs.MoveNext
    Loop
  End If  

  'Response.Write "GameRequestGroupIDX :" & GameRequestGroupIDX & "<BR>"
  '선수가 이미 등록되있는지 체크
  LSQL = " SET NOCOUNT ON insert into tblGameRequestPlayer " 
  LSQL = LSQL & " ( GameTitleIDX, GameLevelIDX, GameRequestGroupIDX ,MemberIDX, MemberName, Team, TeamName) "
  LSQL = LSQL & " values ('"&tIDX & "','" &  tGameLevelIdx & "' ,'"  &  GameRequestGroupIDX & "' ,'" & tMemberIdx & "','" & tMemberName & "','" & tTeam & "', '" & tTeamName &"')" 
  LSQL = LSQL & " SELECT @@IDENTITY as IDX "

  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
      Do Until LRs.Eof
      PlayerIdx = LRs("IDX")
    LRs.MoveNext
    Loop
  End If  
'
  ''Response.Write "SQL :" & LSQL & "<BR>"
  'IF tPlayType = "B0020002" Then
  '  LSQL = " SET NOCOUNT ON insert into tblGameRequestPlayer " 
  '  LSQL = LSQL & " ( GameTitleIDX, GameLevelIDX, GameRequestGroupIDX,MemberIDX, MemberName, TeamCode, TeamName) "
  '  LSQL = LSQL & " values ('"&tIDX & "','" &  tGameLevelIdx & "' ,'" & GroupRequestIdx & "' ,'" & tMemberIdx2 & "','" & tMemberName2 & "','" & tTeam1 & "', '" & tTeamName2 &"')" 
  '  LSQL = LSQL & " SELECT @@IDENTITY as IDX "
'
  '  Set LRs = DBCon.Execute(LSQL)
  '  IF NOT (LRs.Eof Or LRs.Bof) Then
  '      Do Until LRs.Eof
  '      PlayerIdx_2 = LRs("IDX")
  '    LRs.MoveNext
  '    Loop
  '  End IF
  'End IF
 
	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
%>

<%
  DBClose()
%>