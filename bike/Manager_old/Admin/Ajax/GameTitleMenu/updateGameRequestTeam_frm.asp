

<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  REQ = Request("REQ")
  'REQ = "{""CMD"":5,""tGameRequestTeamIdx"":""61ECEF176F2452A6845BAF9C5EDC6DD8"",""tGameTitleIDX"":""B982ED46B36E629292ABE4DFB9242C60"",""tGameLevelIdx"":""890B09C57E3E5953C188AA071FCC1812"",""tGroupGameGb"":""400CCFC358DA360D5A863D04FD0C3136"",""tTeam"":""450116DFC45C5CC413FCBB3988E8D288"",""tTeamName"":""이천중"",""NowPage"":1}"

  Set oJSONoutput = JSON.Parse(REQ)
	CMD = oJSONoutput.CMD
  '--------------------------------대회 정보-------------------------------------
  tGameRequestTeamIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameRequestTeamIdx))
  tGameTitleIDX =fInject(crypt.DecryptStringENC(oJSONoutput.tGameTitleIDX))
  tGameLevelIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameLevelIdx))
  '--------------------------------대회 정보-------------------------------------

  '--------------------------------팀 정보-------------------------------------
  tTeam = fInject(crypt.DecryptStringENC(oJSONoutput.tTeam))
  tTeamName = oJSONoutput.tTeamName
  tTeamDtl = fInject(oJSONoutput.tTeamDtl)
  '--------------------------------팀 정보-------------------------------------
  
  NowPage = oJSONoutput.NowPage

  'Response.Write "tGameRequestGroupIDX : " & tGameRequestGroupIDX & "<br>"
  'Response.Write "tGameTitleIDX : " & tGameTitleIDX & "<br>"
  'Response.Write "tGameLevelIdx : " & tGameLevelIdx & "<br>"
  'Response.Write "tPlayType : " & tPlayType & "<br>"

  'Response.Write "tMemberName1 : " & tMemberName1 & "<br>"
  'Response.Write "tMemberIdx1 : " & tMemberIdx1 & "<br>"
  'Response.Write "tTeam1 : " & tTeam1 & "<br>"
  'Response.Write "tTeamName1 : " & tTeamName1 & "<br>"
  'Response.Write "tGameRequestPlayerIdx1 : " & tGameRequestPlayerIdx1 & "<br>"
  'Response.Write "NowPage : " & NowPage & "<br>"
  
  'Response.Write "tMemberName2 : " & tMemberName2 & "<br>"
  'Response.Write "tMemberIdx2 : " & tMemberIdx2 & "<br>"
  'Response.Write "tTeam2 : " & tTeam2 & "<br>"
  'Response.Write "tTeamName2 : " & tTeamName2 & "<br>"
  'Response.Write "tGameRequestPlayerIdx2 : " & tGameRequestPlayerIdx2 & "<br>"
  'Response.Write "NowPage : " & NowPage & "<br>"

  IF( cdbl(tGameRequestTeamIdx) > 0 ) Then
    LSQL = " Update tblGameRequestTeam " 
    LSQL = LSQL & " SET TeamName = '" & tTeamName & "', Team  =  '" & tTeam & "', TeamDtl = '" & tTeamDtl & "'"
    LSQL = LSQL & " Where GameRequestTeamIDX = '" & tGameRequestTeamIdx & "'"
    'Response.Write LSQL & "<br>"
    Set LRs = DBCon.Execute(LSQL)

    LSQL = " Update tblGameRequestGroup " 
    LSQL = LSQL & " SET Team  =  '" & tTeam & "', TeamDtl = '" & tTeamDtl & "'"
    LSQL = LSQL & " Where GameRequestTeamIDX = '" & tGameRequestTeamIdx & "'"
    'Response.Write LSQL & "<br>"
    Set LRs = DBCon.Execute(LSQL)

    LSQL = " Update tblGameRequestPlayer " 
    LSQL = LSQL & " SET Team  =  '" & tTeam & "', TeamDtl = '" & tTeamDtl & "'"
    LSQL = LSQL & " Where GameRequestTeamIDX = '" & tGameRequestTeamIdx & "'"
    'Response.Write LSQL & "<br>"
    Set LRs = DBCon.Execute(LSQL)
    
  End IF

  

  
  'Call oJSONoutput.Set("result", 0 )
	'strjson = JSON.stringify(oJSONoutput)
	'Response.Write strjson
  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"
%>

<%
  DBClose()
%>


