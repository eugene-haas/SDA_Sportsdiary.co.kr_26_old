
<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  REQ = Request("REQ")
  'REQ = "{""CMD"":2,""tGameTitleIDX"":""DE06405500BB0584EDD42C189431D8AA"",""tGameLevelIdx"":""93C6CFBF8D2865C5B63BD45787FC134D"",""tGameRequestTeamIdx"":""EDA53EB24518F23F2730F910B5FDFA9D"",""tTeam"":""BA00038"",""tMemberName"":""김진규"",""tMemberIdx"":""6451D52A3707A6A3C018A45BF7504503"",""tTeamName"":""서울"",""NowPage"":1}"

  Set oJSONoutput = JSON.Parse(REQ)

	CMD = fInject(oJSONoutput.CMD)
   '------------------------대회 기본 정보-------------------------------
  tIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tGameTitleIDX))
  tGameLevelIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameLevelIdx))
  tGameRequestTeamIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameRequestTeamIdx))
  '---------------------------------------------------------------------
  '단체 선수
  tMemberIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tMemberIdx))
  tMemberName = fInject(oJSONoutput.tMemberName)
  tTeam = fInject(oJSONoutput.tTeam)
  tTeamName = fInject(oJSONoutput.tTeamName)
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



  LSQL = " SELECT	Top 1 Team"
  LSQL = LSQL & "  FROM tblMember a  "
  LSQL = LSQL & " WHERE a.DelYN = 'N' and MemberIDX = " & tMemberIdx 
	
  'Response.Write "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL" & LSQL & "<br>"
  Set LRs = DBCon.Execute(LSQL)
   IF NOT (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      tTeam_Origin = LRS("Team")
      LRs.MoveNext
    Loop
  End IF


  'Response.Write "GameRequestGroupIDX :" & GameRequestGroupIDX & "<BR>"
  '선수가 이미 등록되있는지 체크
  LSQL = " SET NOCOUNT ON insert into tblGameRequestPlayer " 
  LSQL = LSQL & " ( GameTitleIDX, GameLevelIDX, GameRequestTeamIDX ,GameRequestGroupIDX ,MemberIDX, MemberName, Team, TeamName, Team_Origin) "
  LSQL = LSQL & " values ('"&tIDX & "','" &  tGameLevelIdx & "' ,'" &  tGameRequestTeamIdx & "' ,'"  &  GameRequestGroupIDX & "' ,'" & tMemberIdx & "','" & tMemberName & "','" & tTeam & "', '" & tTeamName &"','" & tTeam_Origin & "')" 
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