<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  REQ = Request("REQ")
  'REQ = "{""CMD"":5,""tGameRequestGroupIDX"":""2B3ECBA38A7C3E5089B73C81CDBD6F66"",""tGameTitleIDX"":""526FFDE5660B3F06ACFE218964EC6917"",""tGameLevelIdx"":""60B0AEEEA15C3605E7742D82FC4D172C"",""tPlayType"":""A932F76713F8A9728D92A52C4795E4B7"",""tPlayTypeNm"":""복식"",""tMemberName1"":""임승현"",""tMemberIdx1"":""409162BDAAF0A4FA358A28AEEBD6BC89"",""tTeam1"":""76A26DB02EF1918E82141B6DF24278C7"",""tTeamName1"":""화순중"",""tGameRequestPlayerIdx1"":""673FD300511B1E392E4DD695B1F853B0"",""tMemberName2"":""김소정"",""tMemberIdx2"":""409162BDAAF0A4FA358A28AEEBD6BC89"",""tTeam2"":""06136170564FED4613B7653DFC23F7EF"",""tTeamName2"":""전주성심여고"",""tGameRequestPlayerIdx2"":""DB40B1E863E0E38E5155CCE85DEF2498"",""NowPage"":1,""tMajorTeam"":""Team2""}"

  Set oJSONoutput = JSON.Parse(REQ)
	CMD = oJSONoutput.CMD
  '--------------------------------대회 정보-------------------------------------
  tGameRequestGroupIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tGameRequestGroupIDX))
  tGameTitleIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tGameTitleIDX))
  tGameLevelIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameLevelIdx))
  tPlayType = fInject(crypt.DecryptStringENC(oJSONoutput.tPlayType))
  tMajorTeam = fInject(oJSONoutput.tMajorTeam)
  

  '--------------------------------대회 정보-------------------------------------

  '--------------------------------1 플레이어-------------------------------------
  tMemberName1 = fInject(oJSONoutput.tMemberName1)
  tMemberIdx1 = fInject(crypt.DecryptStringENC(oJSONoutput.tMemberIdx1))
  tTeam1 = fInject(crypt.DecryptStringENC(oJSONoutput.tTeam1))
  tTeamName1 = fInject(oJSONoutput.tTeamName1)
  tGameRequestPlayerIdx1 = fInject(crypt.DecryptStringENC(oJSONoutput.tGameRequestPlayerIdx1))
  '--------------------------------1 플레이어-------------------------------------
  
  '--------------------------------2 플레이어-------------------------------------
  IF tPlayType  = "B0020002" Then 
  tMemberName2 = fInject(oJSONoutput.tMemberName2)
  tMemberIdx2 = fInject(crypt.DecryptStringENC(oJSONoutput.tMemberIdx2))
  tTeam2 = fInject(crypt.DecryptStringENC(oJSONoutput.tTeam2))
  tTeamName2 = fInject(oJSONoutput.tTeamName2)
  tGameRequestPlayerIdx2 = fInject(crypt.DecryptStringENC(oJSONoutput.tGameRequestPlayerIdx2))
  End IF
  '--------------------------------2 플레이어-------------------------------------
  NowPage = fInject(oJSONoutput.NowPage)
  
  if(tMajorTeam = "Team1") Then
    tMajorTeam = tTeam1
  Elseif (tMajorTeam = "Team2") Then
    tMajorTeam = tTeam2
  Else
    tMajorTeam = tTeam1
  End IF

  'response.write "tMajorTeam" & tMajorTeam & "<br>"
  'response.write "tTeam2" & tTeam2 & "<br>"
  'response.write "tTeam2" & tTeam1 & "<br>"



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

    LSQL = " Update tblGameRequestGroup " 
    'LSQL = LSQL & " SET EntryCnt = '" & tEntryCnt & "', PlayLevelType  =  '" & tPlayLevelType & "',  GameType  =  '" & tGameType & "', StadiumNumber  = '" & tStadiumNumber &"'  , TotRound  = '" & tTotalRound & "'  , GameDay  = '"  & tGameDay & "'  , GameTime  = '" & tGameTime & "', ViewYN = '" & ViewYN & "', LevelJooName = '" & tLevelJoo & "',LevelJooNum = '" & tLevelJooNum & "'" 
    LSQL = LSQL & " SET Team = '" & tMajorTeam & "'"
    LSQL = LSQL & " Where GameRequestGroupIDX = '" & tGameRequestGroupIDX & "'"
    'Response.Write LSQL & "<br>"
    Set LRs = DBCon.Execute(LSQL)


  IF tGameRequestPlayerIdx1 <> "" Then
    IF( cdbl(tGameRequestPlayerIdx1) > 0 ) Then
      LSQL = " Update tblGameRequestPlayer " 
      'LSQL = LSQL & " SET EntryCnt = '" & tEntryCnt & "', PlayLevelType  =  '" & tPlayLevelType & "',  GameType  =  '" & tGameType & "', StadiumNumber  = '" & tStadiumNumber &"'  , TotRound  = '" & tTotalRound & "'  , GameDay  = '"  & tGameDay & "'  , GameTime  = '" & tGameTime & "', ViewYN = '" & ViewYN & "', LevelJooName = '" & tLevelJoo & "',LevelJooNum = '" & tLevelJooNum & "'" 
      LSQL = LSQL & " SET TeamName = '" & tTeamName1 & "', Team  =  '" & tTeam1 & "',  MemberName  =  '" & tMemberName1 & "', MemberIDX  = '" & tMemberIdx1 &"'"
      LSQL = LSQL & " Where GameRequestPlayerIDX = '" & tGameRequestPlayerIdx1 & "'"
      'Response.Write LSQL & "<br>"
      Set LRs = DBCon.Execute(LSQL)
    End IF
  End IF

  IF tGameRequestPlayerIdx2 <> "" Then
    IF tPlayType  = "B0020002" Then 
      IF( cdbl(tGameRequestPlayerIdx2) > 0 ) Then
        LSQL = " Update tblGameRequestPlayer " 
        'LSQL = LSQL & " SET EntryCnt = '" & tEntryCnt & "', PlayLevelType  =  '" & tPlayLevelType & "',  GameType  =  '" & tGameType & "', StadiumNumber  = '" & tStadiumNumber &"'  , TotRound  = '" & tTotalRound & "'  , GameDay  = '"  & tGameDay & "'  , GameTime  = '" & tGameTime & "', ViewYN = '" & ViewYN & "', LevelJooName = '" & tLevelJoo & "',LevelJooNum = '" & tLevelJooNum & "'" 
        LSQL = LSQL & " SET TeamName = '" & tTeamName2 & "', Team  =  '" & tTeam2 & "',  MemberName  =  '" & tMemberName2 & "', MemberIDX  = '" & tMemberIdx2 &"'"
        LSQL = LSQL & " Where GameRequestPlayerIDX = '" & tGameRequestPlayerIdx2 & "'"
        'Response.Write LSQL & "<br>"
        Set LRs = DBCon.Execute(LSQL)
      End IF
    End IF
  END IF

  
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


