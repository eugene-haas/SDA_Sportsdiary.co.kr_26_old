
<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  REQ = Request("REQ")
  'REQ = "{""CMD"":2,""tGameTitleIDX"":""B982ED46B36E629292ABE4DFB9242C60"",""tGameLevelIdx"":""890B09C57E3E5953C188AA071FCC1812"",""tGroupGameGb"":""400CCFC358DA360D5A863D04FD0C3136"",""tTeam"":""90098A971308BB70DC82C6230679FA1A"",""tTeamName"":""김천여고"",""NowPage"":1}"

  Set oJSONoutput = JSON.Parse(REQ)

	CMD = fInject(oJSONoutput.CMD)
   '------------------------대회 기본 정보-------------------------------
  tIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tGameTitleIDX))
  tGameLevelIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameLevelIdx))
  tGroupGameGb = fInject(crypt.DecryptStringENC(oJSONoutput.tGroupGameGb))
  '---------------------------------------------------------------------

  '------------------------단체전-------------------------------
  tTeam = fInject(crypt.DecryptStringENC(oJSONoutput.tTeam))
  tTeamName = fInject(oJSONoutput.tTeamName)
  tTeamDtl = fInject(oJSONoutput.tTeamDtl)
  
  '---------------------------------------------------------------------

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
  'Response.Write "tGroupGameGb : " & tGroupGameGb & "<br>"
  'Response.Write "tGameTitleName : " & tGameTitleName & "<br>"
  'Response.Write "tEnterType : " & tEnterType & "<br>"
  'Response.Write "tTeam : " & tTeam & "<br>"
  'Response.Write "tTeamName : " & tTeamName & "<br>"
  
  if Len(tTeamDtl) = cdbl(0) Then
    tTeamDtl = "0"
  end if 

  LSQL = " SET NOCOUNT ON insert into tblGameRequestTeam " 
  LSQL = LSQL & " ( GameTitleIDX, GameLevelIDX, GameTitleName, Team, TeamName, TeamDtl ) "
  LSQL = LSQL & " values ('"&tIDX & "','" &  tGameLevelIdx & "','" & tGameTitleName & "','" & tTeam & "','" & tTeamName & "','" & tTeamDtl & "')" 
  LSQL = LSQL & " SELECT @@IDENTITY as IDX "
 
  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
      Do Until LRs.Eof
      GroupRequesTeamtIdx = LRs("IDX")
    LRs.MoveNext
    Loop
  End If  

  LSQL = " SET NOCOUNT ON insert into tblGameRequestGroup " 
  LSQL = LSQL & " ( GameTitleIDX, GameRequestTeamIDX, GameLevelIDX, GameTitleName, EnterType, Team, TeamDtl, GroupGameGb) "
  LSQL = LSQL & " values ('"&tIDX & "','" &  GroupRequesTeamtIdx & "','"&  tGameLevelIdx & "','" & tGameTitleName & "','" & tEnterType & "','" & tTeam & "','" & tTeamDtl & "','" & "B0030002" & "')" 
  LSQL = LSQL & " SELECT @@IDENTITY as IDX "
  'Response.Write "SQL :" & LSQL & "<BR>"
  
  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
      Do Until LRs.Eof
      GroupRequestGroupIdx = LRs("IDX")
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