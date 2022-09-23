<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  REQ = Request("Req")
  Set oJSONoutput = JSON.Parse(REQ)
  'Response.Write "CMD" & oJSONoutput.CMD & "<br>"
  'Response.Write "data" & oJSONoutput.data
  GameNumbers = Split(oJSONoutput.data,"%")
  StadiumIDX = fInject(crypt.DecryptStringENC(oJSONoutput.StaDiumIDX)) 
  Const PersonGame = "B0030001"
  Const GroupGame = "B0030002"

  for each a in GameNumbers 
    Values = Split(a,"^")
    GameNumTourneyDtlIDX = fInject(crypt.DecryptStringENC(Values(0))) 
    GameNumTourney = fInject(Values(1))
    TurnNum = fInject(Values(2))
    GameDay = fInject(Values(3))
    StadiumNum = fInject(Values(4))
    GroupGameGb = fInject(crypt.DecryptStringENC(Values(5)))
    TourneyIDX = fInject(crypt.DecryptStringENC(Values(6)))
    GameOrder = fInject(Values(7))

    'Response.Write " GroupGameGb : " & GroupGameGb & "<br/>"
    IF PersonGame = GroupGameGb Then

      LSQL = " SELECT a.TourneyIDX, a.GameLevelDtlidx, a.GameNum, b.StadiumNum"
      LSQL = LSQL & " FROM  tblTourney a "
      LSQL = LSQL & " inner Join tblGameLevel b on a.GameLevelIdx = b.GameLevelidx "
      LSQL = LSQL & " WHERE a.DelYN = 'N' and a.TourneyIDX ='"& TourneyIDX &"'"
      'Response.Write "LSQL :" & LSQL & "<br>"
      Set LRs = DBCon.Execute(LSQL)
      IF NOT (LRs.Eof Or LRs.Bof) Then
        arrTourney = LRs.getrows()
      End If
      LRs.close


       If IsArray(arrTourney) Then
        For ar = LBound(arrTourney, 2) To UBound(arrTourney, 2) 
          arrTourneyIDX	= arrTourney(0, ar) 
          arrGameLevelDtlidx	= arrTourney(1, ar) 
          arrGameNum	= arrTourney(2, ar) 
          arrStadiumIDX	= arrTourney(3, ar) 
          
          LSQL = " SELECT TourneyIDX,GameLevelDtlidx,GameNum "
          LSQL = LSQL & " FROM  tblTourney "
          LSQL = LSQL & " WHERE DelYN = 'N' and GameNum ='"& arrGameNum &"' and GameLevelDtlidx ='" & arrGameLevelDtlidx & "'"
          'Response.Write "LSQL :" & LSQL & "<br>"
          Set LRs = DBCon.Execute(LSQL)
          IF NOT (LRs.Eof Or LRs.Bof) Then
            arrTourneyUpdates = LRs.getrows()
          End If
          LRs.close

          If IsArray(arrTourneyUpdates) Then
            For ar2 = LBound(arrTourneyUpdates, 2) To UBound(arrTourneyUpdates, 2) 
              arrTourneyIDX2	= arrTourneyUpdates(0, ar2) 
              arrGameLevelDtlidx	= arrTourneyUpdates(1, ar2) 
              arrTeamGameNum	= arrTourneyUpdates(2, ar2) 
              'Response.Write "arrTourneyTeamIDX :" & arrTourneyTeamIDX & "<br>"
              'Response.Write "arrGameLevelDtlidx :" & arrGameLevelDtlidx & "<br>"
              'Response.Write "arrTeamGameNum :" & arrTeamGameNum & "<br>"
              LSQL = " UPDATE tblTourney "
              LSQL = LSQL & " Set TurnNum = '" & TurnNum & "', GameDay= '" & GameDay & "', StadiumNum = '" & StadiumNum & "', StadiumIDX = '" & arrStadiumIDX & "', UpdateGameOrderDate = getdate(), StadiumOrder = '" & GameOrder & "'"
              LSQL = LSQL & " WHERE DelYN = 'N' and TourneyIDX = '" & arrTourneyIDX2 & "'"
              Set LRs = DBCon.Execute(LSQL)
              'Response.Write "LSQL :" & LSQL & "<br>"
            Next
          End If
        Next
      End If	
    ELSEIF GroupGame = GroupGameGb Then
      'Response.Write " LSQL : " & LSQL & "<br/>"
      'Set LRs = DBCon.Execute(LSQL)
      'Response.write "TourneyIDX" & TourneyIDX & "<br>"
      LSQL = " SELECT a.TourneyTeamIDX,a.GameLevelDtlidx,a.TeamGameNum,b.StadiumNum"
      LSQL = LSQL & " FROM  tblTourneyTeam a"
      LSQL = LSQL & " inner Join tblGameLevel b on a.GameLevelIdx = b.GameLevelidx "
      LSQL = LSQL & " WHERE a.DelYN = 'N' and a.TourneyTeamIDX ='"& TourneyIDX &"'"
      'Response.Write "LSQL :" & LSQL & "<br>"
      Set LRs = DBCon.Execute(LSQL)
      IF NOT (LRs.Eof Or LRs.Bof) Then
        arrTourneyTeam = LRs.getrows()
      End If
      LRs.close

      If IsArray(arrTourneyTeam) Then
        For ar = LBound(arrTourneyTeam, 2) To UBound(arrTourneyTeam, 2) 
          arrTourneyTeamIDX	= arrTourneyTeam(0, ar) 
          arrGameLevelDtlidx	= arrTourneyTeam(1, ar) 
          arrTeamGameNum	= arrTourneyTeam(2, ar) 
          arrStadiumIDX	= arrTourney(3, ar) 
          
          LSQL = " SELECT TourneyTeamIDX,GameLevelDtlidx,TeamGameNum "
          LSQL = LSQL & " FROM  tblTourneyTeam "
          LSQL = LSQL & " WHERE DelYN = 'N' and TeamGameNum ='"& arrTeamGameNum &"' and GameLevelDtlidx ='" & arrGameLevelDtlidx & "'"
          'Response.Write "LSQL :" & LSQL & "<br>"
          Set LRs = DBCon.Execute(LSQL)
          IF NOT (LRs.Eof Or LRs.Bof) Then
            arrTourneyTeamUpdates = LRs.getrows()
          End If
          LRs.close

          If IsArray(arrTourneyTeamUpdates) Then
            For ar2 = LBound(arrTourneyTeamUpdates, 2) To UBound(arrTourneyTeamUpdates, 2) 
              arrTourneyTeamIDX2	= arrTourneyTeamUpdates(0, ar2) 
              arrGameLevelDtlidx	= arrTourneyTeamUpdates(1, ar2) 
              arrTeamGameNum	= arrTourneyTeamUpdates(2, ar2) 
              'Response.Write "arrTourneyTeamIDX :" & arrTourneyTeamIDX & "<br>"
              'Response.Write "arrGameLevelDtlidx :" & arrGameLevelDtlidx & "<br>"
              'Response.Write "arrTeamGameNum :" & arrTeamGameNum & "<br>"
              LSQL = " UPDATE tblTourneyTeam "
              LSQL = LSQL & " Set TurnNum = '" & TurnNum & "', GameDay= '" & GameDay & "', StadiumNum = '" & StadiumNum & "', StadiumIDX = '" & arrStadiumIDX & "', UpdateGameOrderDate = getdate(), StadiumOrder = '" & GameOrder & "'"
              LSQL = LSQL & " WHERE DelYN = 'N' and TourneyTeamIDX = '" & arrTourneyTeamIDX2 & "'"
              Set LRs = DBCon.Execute(LSQL)
              'Response.Write "LSQL :" & LSQL & "<br>"
            Next
          End If
        Next
      End If		
    End IF
    
    

    'Response.Write "LSQL :" & LSQL& "<br>"
    'Response.Write "GameNumTourneyDtlIDX :" & GameNumTourneyDtlIDX & "<br>"
    'Response.Write "GameNumTourney :" & GameOrder & "<br>"
    'Response.Write "TurnNum :" & TurnNum & "<br>"
    
  next
  
	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
%>

<%
  DBClose()
%> 