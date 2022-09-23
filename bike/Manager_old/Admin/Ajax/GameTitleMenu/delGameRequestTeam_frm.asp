<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  REQ = Request("REQ")
  'REQ = "{""CMD"":4,""tGameRequestPlayerIDX"":""21"",""NowPage"":1}"
  'REQ = "{""CMD"":4,""tGameRequestTeamIdx"":""97F44DF026F183F8E7BB4D0D70466235"",""tGameTitleIDX"":""BF242F3A46C5952F1DF14D02620F1AB7"",""tGameLevelIdx"":""A5B4C73322375147805D9A7519F63EBD""}"
  'REQ = "{""CMD"":4,""tGameRequestTeamIdx"":""0FA933CDC0689A82642F2FBC8440C87A"",""tGameTitleIDX"":""BF242F3A46C5952F1DF14D02620F1AB7"",""tGameLevelIdx"":""914C43C3B71E560DDA51DC6BEA184578"",""NowPage"":1}"

  Set oJSONoutput = JSON.Parse(REQ)
  tGameRequestTeamIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameRequestTeamIdx))
  tGameLevelIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameLevelIdx))
  const TeamGroupGameGb ="B0030002"
  'Response.Write "CMD :" & CMD & "<BR>"

  IF( tGameRequestTeamIdx <> "") Then
    'LSQL = " DELETE FROM tblGameLevelDtl " 
    'LSQL = LSQL & "   WHERE GameLevelDtlidx = '" &  tGameLevelDtlIDX & "'"
    'Response.Write "SQL :" & LSQL & "<BR>"
    'Set LRs = DBCon.Execute(LSQL)
    LSQL = " SELECT Top 1 GameRequestGroupIDX "
    LSQL = LSQL & "   FROM  tblGameRequestGroup  "
    LSQL = LSQL & " WHERE GameRequestTeamIDX = '"  & tGameRequestTeamIdx  & "' and DelYn ='N' "
    'Response.write "LSQL" & LSQL & "<BR>"
    Set LRs = DBCon.Execute(LSQL)

    IF NOT (LRs.Eof Or LRs.Bof) Then
    arrayGroups = LRs.getrows()
    End If

    If IsArray(arrayGroups) Then
      For ar = LBound(arrayGroups, 2) To UBound(arrayGroups, 2) 
        tGameRequestGroupIDX    = arrayGroups(0, ar) 
        LSQL = " Update tblGameRequestPlayer Set DelYN = 'Y' " 
        LSQL = LSQL & "   WHERE GameRequestGroupIDX = '" &  tGameRequestGroupIDX & "'"
        'Response.Write "SQL :" & LSQL & "<BR>"
        Set LRs = DBCon.Execute(LSQL)

        LSQL = " Update tblGameRequestGroup Set DelYN = 'Y' " 
        LSQL = LSQL & "   WHERE GameRequestGroupIDX = '" &  tGameRequestGroupIDX & "'"
        'Response.Write "SQL :" & LSQL & "<BR>"
        Set LRs = DBCon.Execute(LSQL)

      Next
    End If   

    LSQL = " Update tblGameRequestTeam Set DelYN = 'Y' " 
    LSQL = LSQL & "   WHERE GameRequestTeamIDX = '" &  tGameRequestTeamIdx & "'"
    'Response.Write "SQL :" & LSQL & "<BR>"
    Set LRs = DBCon.Execute(LSQL)

    LSQL = " SELECT ISNULL(Count(*),0) as TouneyCnt " 
    LSQL = LSQL & " FROM tblGameRequestTouney  "
    LSQL = LSQL & " where RequestIDX = '" & tGameRequestTeamIdx &  "' and DelYN = 'N' and GroupGameGb = '" & TeamGroupGameGb & "'"
    'Response.Write "LSQL :" & LSQL & "<BR>"
    Set LRs = DBCon.Execute(LSQL)
    IF NOT (LRs.Eof Or LRs.Bof) Then
        Do Until LRs.Eof
        TouneyCnt = LRs("TouneyCnt")
      LRs.MoveNext
      Loop
    End If  
    
    IF( CDBL(TouneyCnt) > CDBL(0) )Then
      LSQL = " Update tblGameRequestTouney " 
      LSQL = LSQL & " SET DelYN = 'Y'" 
      LSQL = LSQL & " Where RequestIDX = '" & tGameRequestTeamIdx & "' and GroupGameGb = '" & TeamGroupGameGb & "'"
      'Response.Write "LSQL :" & LSQL & "<BR>"
      Set LRs = DBCon.Execute(LSQL)
    End If  
  

  End IF

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
  
  DBClose()
%>
