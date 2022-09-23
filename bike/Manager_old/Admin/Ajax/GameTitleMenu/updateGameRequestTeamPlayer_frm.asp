

<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  REQ = Request("REQ")
  'REQ = "{""CMD"":5,""tGameTitleIDX"":""615CE2208D20BCBF3DF8EB8C6240BBA2"",""tGameLevelIdx"":""9C1846994AF0A312E5A4B8FD02667808"",""tGameRequestTeamIdx"":""D5D981BDA40FF38FC85F96AFB1CF7D3B"",""tGameRequestPlayerIDX"":""AEE941B80A33376EBB971201BCA270E8"",""tTeam"":""BA00027"",""tTeamName"":""정읍중"",""tMemberName"":""김진"",""tMemberIdx"":""05C9D8A38164BD0FE8BDC1FB9672386F""}"

  Set oJSONoutput = JSON.Parse(REQ)
	CMD = oJSONoutput.CMD
  '--------------------------------대회 정보-------------------------------------
  tGameTitleIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tGameTitleIDX))
  tGameLevelIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameLevelIdx))
  '--------------------------------대회 정보-------------------------------------

  '--------------------------------플레이어-------------------------------------
  tMemberName =fInject(oJSONoutput.tMemberName)
  tMemberIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tMemberIdx))
  tTeam = fInject(oJSONoutput.tTeam)
  tTeamName = fInject(oJSONoutput.tTeamName)
  tGameRequestPlayerIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tGameRequestPlayerIDX))
  '--------------------------------플레이어-------------------------------------
  NowPage = fInject(oJSONoutput.NowPage)
  'Response.Write "tGameRequestGroupIDX : " & tGameRequestGroupIDX & "<br>"
  'Response.Write "tGameTitleIDX : " & tGameTitleIDX & "<br>"
  'Response.Write "tGameLevelIdx : " & tGameLevelIdx & "<br>"
  'Response.Write "tMemberName : " & tMemberName & "<br>"
  'Response.Write "tMemberIdx : " & tMemberIdx & "<br>"
  'Response.Write "tTeam : " & tTeam & "<br>"
  'Response.Write "tTeamName : " & tTeamName & "<br>"
  'Response.Write "tGameRequestPlayerIdx : " & tGameRequestPlayerIDX & "<br>"
  'Response.Write "NowPage : " & NowPage & "<br>"
  'Response.Write "tMemberName2 : " & tMemberName2 & "<br>"
  'Response.Write "tMemberIdx2 : " & tMemberIdx2 & "<br>"
  'Response.Write "tTeam2 : " & tTeam2 & "<br>"
  'Response.Write "tTeamName2 : " & tTeamName2 & "<br>"
  'Response.Write "tGameRequestPlayerIdx2 : " & tGameRequestPlayerIdx2 & "<br>"
  'Response.Write "NowPage : " & NowPage & "<br>"



  IF( cdbl(tGameRequestPlayerIDX) > 0 ) Then
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

    LSQL = " Update tblGameRequestPlayer " 
    LSQL = LSQL & " SET TeamName = '" & tTeamName & "', Team  =  '" & tTeam & "',  MemberName  =  '" & tMemberName & "', MemberIDX  = '" & tMemberIdx &"', Team_Origin = '" & tTeam_Origin & "'"
    LSQL = LSQL & " Where GameRequestPlayerIDX = '" & tGameRequestPlayerIDX & "'"
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


