<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->


<%
  '상수 데이터
  Const constProPlayLevelType = "B0100001"
  Const constFinalPlayLevelType = "B0100002"
  Const constLeagueGameType  = "B0040001"
  Const constTournamentGameType  = "B0040002"
  Const constNonCnt = "0"
  Const constGroupGameGb_Person = "B0030001"
  Const constGroupGameGb_Team = "B0030002"
%>

<%
  Function GetMaxLeague2(value)
   LEAGUE_RESULT = value MOD 2
    IF CDBL(LEAGUE_RESULT) = 1 Then  
      MaxPrePosition = Ceil(value / 3) '홀수 경기수
    ELSE
      MaxPrePosition = Ceil(value / 2) '짝수 경기수
    End IF
    GetMaxLeague = MaxPrePosition 
  End Function

  Function GetMaxLeague(value)
    MaxPrePosition = Ceil(value / 2) '짝수 경기수
    GetMaxLeague = MaxPrePosition 
  End Function

  '소수점 올림 함수
  Function Ceil(ByVal intParam)  
    Ceil = -(Int(-(intParam)))  
  End Function  

  Sub All_Display (ByVal tGameTitleIdx, ByVal tStadiumIDX)
    LSQL = " SELECT GameLevelIdx,PrePosition, MaxPrePosition, FinalPosition, MaxFinalPosition, PlayLevelTypePosition, MaxPlayLevelType,GameOrder,GameNum, ProOrderYN "
    LSQL = LSQL & " FROM tblGameProOrder "
    LSQL = LSQL & " WHERE DelYN = 'N' and GameTitleIDX ='" & tGameTitleIdx & "' and StadiumIDX='" & tStadiumIDX &"'"
    Set LRs = DBCon.Execute(LSQL)
    If Not (LRs.Eof Or LRs.Bof) Then
      Do Until LRs.Eof
          GameLevelIdx = LRs("GameLevelIdx")
          GameOrder = LRs("GameOrder")
          GameNum = LRs("GameNum")
          
          PrePosition = LRs("PrePosition")
          MaxPrePosition = LRs("MaxPrePosition")
          FinalPosition = LRs("FinalPosition")
          MaxFinalPosition = LRs("MaxFinalPosition")
          PlayLevelTypePosition = LRs("PlayLevelTypePosition")
          MaxPlayLevelType = LRs("MaxPlayLevelType")
          ProOrderYN = LRs("ProOrderYN")
          
          'Response.Write "GameLevelIdx : " & GameLevelIdx
          'Response.Write ", GameOrder : " & GameOrder 
          'Response.Write ", GameNum : " & GameNum 
          'Response.Write ", PrePosition : " & PrePosition 
          'Response.Write ", MaxPrePosition : " & MaxPrePosition
          'Response.Write ", FinalPosition : " & FinalPosition
          'Response.Write ", MaxFinalPosition : " & MaxFinalPosition 
          'Response.Write ", PlayLevelTypePosition : " & PlayLevelTypePosition 
          'Response.Write ", MaxPlayLevelType : " & MaxPlayLevelType
          'Response.Write ", GameOrderPosition : " & GameOrderPosition
          'Response.Write ", ProOrderYN : " & ProOrderYN
          'Response.Write "<BR/>"
        LRs.MoveNext
      Loop
    End If
    LRs.close
    
   
  END SUB

  Sub Display (ByVal GameProOrderIdx)
    LSQL = " SELECT GameLevelIdx,PrePosition, MaxPrePosition, FinalPosition, MaxFinalPosition, PlayLevelTypePosition, MaxPlayLevelType,GameOrder,GameNum, ProOrderYN "
    LSQL = LSQL & " FROM tblGameProOrder "
    LSQL = LSQL & " WHERE DelYN = 'N' and GameProOrderIdx ='" & GameProOrderIdx & "'"
    Set LRs = DBCon.Execute(LSQL)
    If Not (LRs.Eof Or LRs.Bof) Then
      Do Until LRs.Eof
          GameLevelIdx = LRs("GameLevelIdx")
          GameOrder = LRs("GameOrder")
          GameNum = LRs("GameNum")
          
          PrePosition = LRs("PrePosition")
          MaxPrePosition = LRs("MaxPrePosition")
          FinalPosition = LRs("FinalPosition")
          MaxFinalPosition = LRs("MaxFinalPosition")
          PlayLevelTypePosition = LRs("PlayLevelTypePosition")
          MaxPlayLevelType = LRs("MaxPlayLevelType")
          ProOrderYN = LRs("ProOrderYN")
          
          'Response.Write "GameLevelIdx : " & GameLevelIdx
          'Response.Write ", GameOrder : " & GameOrder 
          'Response.Write ", GameNum : " & GameNum 
          'Response.Write ", PrePosition : " & PrePosition 
          'Response.Write ", MaxPrePosition : " & MaxPrePosition
          'Response.Write ", FinalPosition : " & FinalPosition
          'Response.Write ", MaxFinalPosition : " & MaxFinalPosition 
          'Response.Write ", PlayLevelTypePosition : " & PlayLevelTypePosition 
          'Response.Write ", MaxPlayLevelType : " & MaxPlayLevelType
          'Response.Write ", GameOrderPosition : " & GameOrderPosition
          'Response.Write ", ProOrderYN : " & ProOrderYN
          'Response.Write "<BR/>"
        LRs.MoveNext
      Loop
    End If
    LRs.close
    
   
  END SUB

  Sub DisplayUpdate (ByVal GameProOrderIdx,ByVal Before_PlayLevelTypePosition)
    LSQL = " SELECT GameLevelIdx,PrePosition, MaxPrePosition, FinalPosition, MaxFinalPosition, PlayLevelTypePosition, MinPlayLevelType,MaxPlayLevelType,GameOrder,GameNum, ProOrderYN "
    LSQL = LSQL & " FROM tblGameProOrder "
    LSQL = LSQL & " WHERE DelYN = 'N' and GameProOrderIdx ='" & GameProOrderIdx & "'"
    Set LRs = DBCon.Execute(LSQL)
    If Not (LRs.Eof Or LRs.Bof) Then
      Do Until LRs.Eof
          GameLevelIdx = LRs("GameLevelIdx")
          GameOrder = LRs("GameOrder")
          GameNum = LRs("GameNum")
          PlayLevelTypePosition = LRs("PlayLevelTypePosition")
          MaxPlayLevelType = LRs("MaxPlayLevelType")
          ProOrderYN = LRs("ProOrderYN")
          
          'Response.Write " GameLevelIdx : " & GameLevelIdx
          'Response.Write ", GameOrder : " & GameOrder 
          'Response.Write ", GameNum : " & GameNum
          'Response.Write ", Before_PlayLevelTypePosition : " & Before_PlayLevelTypePosition 
          'Response.Write ", PlayLevelTypePosition : " & PlayLevelTypePosition 
          'Response.Write ", MaxPlayLevelType : " & MaxPlayLevelType
          'Response.Write ", GameOrderPosition : " & GameOrderPosition
          'Response.Write ", ProOrderYN : " & ProOrderYN
          'Response.Write "<BR/>"
        LRs.MoveNext
      Loop
    End If
    LRs.close
    
   
  END SUB

  Sub SetGameNumber(ByVal GameLevelIdx, ByVal PlayLevelType, ByVal GameNum, ByVal GroupGameGb, ByVal MaxPosition, ByVal GameType, ByVal GameCount)
    LSQL = " SELECT a.TourneyIDX, a.GameLevelDtlidx , a.GameNum , "
    LSQL = LSQL & " (Select max(GameNum) From tblTourney where GameLevelDtlidx = A.GameLevelDtlidx AND DelYN='N' and PlayLevelType ='" & PlayLevelType & "') as maxCount ,"
    LSQL = LSQL & " C.GameType,"
    LSQL = LSQL & " dbo.FN_NameSch(C.GameType, 'PubCode') as GameTypeNM,"
    LSQL = LSQL & " C.PlayLevelType,"
    LSQL = LSQL & " dbo.FN_NameSch(C.PlayLevelType, 'PubCode') AS PlayLevelTypeNM, "
    LSQL = LSQL & " C.LevelJooNum "
    LSQL = LSQL & " FROM tblTourney A "
    LSQL = LSQL & " INNER JOIN tblTourney B ON B.GameLevelDtlidx = A.GameLevelDtlidx AND B.TeamGameNum = A.TeamGameNum AND B.GameNum = A.GameNum AND B.DelYN='N' "
    LSQL = LSQL & " LEFT JOIN tblGameLevelDtl C ON A.GameLevelDtlidx = C.GameLevelDtlidx AND C.DelYN='N' "
    LSQL = LSQL & " WHERE A.DelYN = 'N' AND "
    LSQL = LSQL & " A.GameLevelIdx = '" & GameLevelIdx & "' AND  "
    LSQL = LSQL & " C.PlayLevelType = '" & PlayLevelType & "' AND  "
    IF GroupGameGb = constGroupGameGb_Person Then
      IF GameType = constLeagueGameType Then
        LSQL = LSQL & " A.GameNum = '" & GameNum & "' AND  "
      ELSE
        LSQL = LSQL & " A.Round = '" & GameNum & "' AND  "
      END IF
    ELSEIF GroupGameGb = constGroupGameGb_Team Then 
      IF GameType = constTournamentGameType Then
        LSQL = LSQL & " A.TeamGameNum = '" & GameNum & "' AND  "
      ELSE
        LSQL = LSQL & " A.Round = '" & GameNum & "' AND  "
      END IF
    END IF
    LSQL = LSQL & " A.ORDERBY < B.ORDERBY "
    LSQL = LSQL & " ORDER BY A.GameNum, A.GameLevelDtlidx DESC  "

    'Response.Write "LSQL : " & LSQL & "<br/>"
    Set LRs = DBCon.Execute(LSQL)
    IF NOT (LRs.Eof Or LRs.Bof) Then
      arrTourney = LRs.getrows()
    End If
    LRs.close

    If IsArray(arrTourney) Then
      For ar = LBound(arrTourney, 2) To UBound(arrTourney, 2) 
        TourneyIDX   = arrTourney(0, ar) 
        GameLevelDtlidx = arrTourney(1, ar) 
        Tourney_GameNum = arrTourney(2, ar) 
        MaxCount = arrTourney(3, ar) 
        Tourney_GameType = arrTourney(4, ar) 

        IF Tourney_GameType  = constLeagueGameType Then
          Redim ArrDataCount(MaxPosition)
          '1.초기화 포지션 배열에 있는 값 
          for i= 0 to uBound(ArrDataCount)
            ArrDataCount(i) = 0 
          Next 

          for i= 1 to GameCount
            arryI = (i mod MaxPosition)
            if  cdbl(arryI) = 0 Then
              arryI = MaxPosition
            END IF
            ArrDataCount(arryI) = ArrDataCount(arryI)  + 1
          Next 

          'Response.Write "GameNum" & ArrDataCount(GameNum) & "<BR>"

          IF cdbl(ArrDataCount(GameNum)) > 1 Then
            GetDataNum2 = Tourney_GameNum * 2 
            GetDataNum1 = GetDataNum2 - 1

            LSQL = " SELECT a.TourneyIDX ,a.GameLevelDtlidx ,a.GameNum , (Select max(GameNum) From tblTourney where GameLevelDtlidx = A.GameLevelDtlidx AND DelYN='N' and PlayLevelType ='" & PlayLevelType & "') as maxCount "
            LSQL = LSQL &  " ,dbo.FN_NameSch(C.PlayLevelType, 'PubCode') AS PlayLevelTypeNM, C.LevelJooNum "
            LSQL = LSQL & " FROM  tblTourney  A "
            LSQL = LSQL & " INNER JOIN tblTourney B ON B.GameLevelDtlidx = A.GameLevelDtlidx AND B.TeamGameNum = A.TeamGameNum AND B.GameNum = A.GameNum AND B.DelYN='N' "
            LSQL = LSQL & " LEFT JOIN tblGameLevelDtl C ON A.GameLevelDtlidx = C.GameLevelDtlidx AND C.DelYN='N' "
            LSQL = LSQL & " WHERE A.DelYN = 'N' "
            LSQL = LSQL & " AND A.GameLevelDtlidx = '" & GameLevelDtlidx &"' "
            LSQL = LSQL & " AND C.PlayLevelType = '" & PlayLevelType  &"' "
            LSQL = LSQL & " AND A.ORDERBY < B.ORDERBY "
            LSQL = LSQL & " AND (A.GameNum = '" & GetDataNum1 & "' or A.GameNum = '" & GetDataNum2 & "')"
            LSQL = LSQL & " ORDER BY A.GameNum, A.GameLevelDtlidx desc "
            'Response.Write "LSQL : " & LSQL  & "<bR/><bR/><bR/>"
            Set LRs = DBCon.Execute(LSQL)
            IF NOT (LRs.Eof Or LRs.Bof) Then
              arrayToureny2 = LRs.getrows()
            End If
            LRs.close

            If IsArray(arrayToureny2) Then
              For arToureny2 = LBound(arrayToureny2, 2) To UBound(arrayToureny2, 2) 
                TourneyIDX2   = arrayToureny2(0, arToureny2) 
                GameLevelDtlidx2= arrayToureny2(1, arToureny2) 
                GameNum2 = arrayToureny2(2, arToureny2) 
                maxCount2 = arrayToureny2(3, arToureny2) 

                LSQL = " UPDATE tblTourney "
                LSQL = LSQL & " Set TurnNum = '" & TurnNumPosition & "',"
                LSQL = LSQL & " StadiumIDX = '" & tStadiumIDX & "',"
                LSQL = LSQL & " StadiumNum = '" & CourtPosition & "',"
                LSQL = LSQL & " StadiumOrder = '" & CourtGroupPosition & "',"
                LSQL = LSQL & " GameDay = '" & tGameS & "',"
                LSQL = LSQL & " UpdateGameOrderDate = getdate() "
                LSQL = LSQL & " WHERE GameLevelDtlidx = '" & GameLevelDtlidx2 & "'"
                LSQL = LSQL & " AND GameNum = '" & GameNum2 & "' "
                Set LRs = DBCon.Execute(LSQL)
                'Response.Write "LSQL  : " & LSQL   & "<bR/>"
                CourtPosition = CourtPosition + 1
                IF CDBL(MaxCourt) < CDBL(CourtPosition) Then
                  CourtPosition = 1
                  CourtGroupPosition = CourtGroupPosition + 1
                End IF 
                TurnNumPosition = TurnNumPosition + 1
              Next
            End If  
          ELSE
            LSQL = " UPDATE tblTourney "
            LSQL = LSQL & " Set TurnNum = '" & TurnNumPosition & "',"
            LSQL = LSQL & " StadiumIDX = '" & tStadiumIDX & "',"
            LSQL = LSQL & " StadiumNum = '" & CourtPosition & "',"
            LSQL = LSQL & " StadiumOrder = '" & CourtGroupPosition & "',"
            LSQL = LSQL & " GameDay = '" & tGameS & "',"
            LSQL = LSQL & " UpdateGameOrderDate = getdate() "
            LSQL = LSQL & " WHERE GameLevelDtlidx = '" & GameLevelDtlidx & "'"
            LSQL = LSQL & " AND GameNum = '" & GameNum & "' "
            
            Set LRs = DBCon.Execute(LSQL)


            CourtPosition = CourtPosition + 1
            IF CDBL(MaxCourt) < CDBL(CourtPosition) Then
              CourtPosition = 1
              CourtGroupPosition = CourtGroupPosition + 1
            End IF 
            TurnNumPosition = TurnNumPosition + 1
          End IF  
        ELSEIF Tourney_GameType  = constTournamentGameType Then

          LSQL = " UPDATE tblTourney "
          LSQL = LSQL & " Set TurnNum = '" & TurnNumPosition & "',"
          LSQL = LSQL & " StadiumIDX = '" & tStadiumIDX & "',"
          LSQL = LSQL & " StadiumNum = '" & CourtPosition & "',"
          LSQL = LSQL & " StadiumOrder = '" & CourtGroupPosition & "',"
          LSQL = LSQL & " GameDay = '" & tGameS & "',"
          LSQL = LSQL & " UpdateGameOrderDate = getdate() "
          LSQL = LSQL & " WHERE GameLevelDtlidx = '" & GameLevelDtlidx & "'"
          LSQL = LSQL & " AND Round = '" & GameNum & "' "
          
          Set LRs = DBCon.Execute(LSQL)

          CourtPosition = CourtPosition + 1
          IF CDBL(MaxCourt) < CDBL(CourtPosition) Then
            CourtPosition = 1
            CourtGroupPosition = CourtGroupPosition + 1
          End IF 
          TurnNumPosition = TurnNumPosition + 1
        End IF
        
      Next
    End If  
    
  END SUB
%>


<%
  REQ = Request("Req")
  'REQ = "{""CMD"":5,""tIDX"":""4AC9519B3F35C40A5D496D69A6B07B65"",""tStadiumIdx"":""040F9E5C3294000D22467CC44F74AAFB"",""tGameS"":""2018-04-24""}"
  'REQ = "{""CMD"":5,""tIDX"":""4AC9519B3F35C40A5D496D69A6B07B65"",""tStadiumIdx"":""3DC036B1B81E9002C2BC1F689BCBF4C3"",""tGameS"":""2018-04-24""}"

  Set oJSONoutput = JSON.Parse(REQ)
  tGameTitleIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tIDX)) 
  tStadiumIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tStadiumIdx)) 
  tGameS = fInject(oJSONoutput.tGameS)

  LSQL = " SELECT StadiumIDX, GameTitleIDX, StadiumName, StadiumCourt, StadiumTime, StadiumAddr, StadiumAddrDtl, DelYN, EditDate, WriteDate "
  LSQL = LSQL & " FROM  tblStadium "
  LSQL = LSQL & " WHERE DelYN = 'N' and StadiumIDX ='" & tStadiumIDX & "'"

  Set LRs = DBCon.Execute(LSQL)
  If Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
        tStadiumCourt= LRs("StadiumCourt")
      LRs.MoveNext
    Loop
  End If
  LRs.close

  '변수 데이터
  Dim MaxCourt : MaxCourt = tStadiumCourt 
  Dim CourtPosition : CourtPosition = 1 
  Dim CourtGroupPosition : CourtGroupPosition = 1 
  Dim TurnNumPosition : TurnNumPosition = 1
  Dim GameOrderPosition : GameOrderPosition = 1
 
  
  '2. 코트에 지정된 종별 전체 가져오기
  LSQL = " SELECT GameLevelIdx, GameNumber, GameOrder, GroupGameGB"
  LSQL = LSQL & " FROM  tblGameLevel "
  LSQL = LSQL & " WHERE DelYN = 'N' and UseYN='Y' and GameTitleIDX ='" & tGameTitleIdx & "' and StadiumNum='" & tStadiumIDX &"'"
  LSQL = LSQL & " Order by GameORder, GameNumber "
  
  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    arrGameOrderLevel = LRs.getrows()
  End If
  LRs.close

  If IsArray(arrGameOrderLevel)  Then
    LSQL = " UPDATE tblGameProOrder "
    LSQL = LSQL & " SET DELYN = 'Y'"
    LSQL = LSQL & " where GameTitleIdx =  '" & tGameTitleIdx & "'"
    LSQL = LSQL & " AND StadiumIdx =  '" & tStadiumIDX & "'"
    Set LRs = DBCon.Execute(LSQL)

    'LSQL = " DELETE FROM tblGameProOrder "
    'LSQL = LSQL & " where GameTitleIdx =  '" & tGameTitleIdx & "'"
    'LSQL = LSQL & " AND StadiumIdx =  '" & tStadiumIDX & "'"
    'Set LRs = DBCon.Execute(LSQL)


    For ar = LBound(arrGameOrderLevel, 2) To UBound(arrGameOrderLevel, 2) 
      GameLevelIdx   = arrGameOrderLevel(0, ar) 
      GameNumber = arrGameOrderLevel(1, ar) 
      GameOrder = arrGameOrderLevel(2, ar) 
      GroupGameGB = arrGameOrderLevel(3, ar) 

      LSQL = "  select max(C.PlayLevelType) as MaxPlayLevelType, min(C.PlayLevelType) as MinPlayLevelType "
      LSQL = LSQL & " FROM tblTourney A  "
      LSQL = LSQL & " INNER JOIN tblTourney B ON B.GameLevelDtlidx = A.GameLevelDtlidx AND B.TeamGameNum = A.TeamGameNum AND B.GameNum = A.GameNum AND B.DelYN='N' "
      LSQL = LSQL & " LEFT JOIN tblGameLevelDtl C ON A.GameLevelDtlidx = C.GameLevelDtlidx AND C.DelYN='N'  "
      LSQL = LSQL & " WHERE A.DelYN = 'N' "
      LSQL = LSQL & " AND A.GameLevelIdx =  '" & GameLevelIdx & "'"
      LSQL = LSQL & " AND A.TeamGameNum = '0' "

      Set LRs = DBCon.Execute(LSQL)
      If Not (LRs.Eof Or LRs.Bof) Then
        Do Until LRs.Eof
            MAXPlayLevelType = LRs("MaxPlayLevelType")
            MINPlayLevelType = LRs("MinPlayLevelType")
          LRs.MoveNext
        Loop
      ELSE
        MAXPlayLevelType = "" 
        MINPlayLevelType = ""
      End If
      LRs.close
      
      LSQL = " SELECT ISNULL(max(CAST(A.GameNum AS INT)),0) as LeagueRound, ISNULL(MAX(a.Round),0) as TournamentRound, ISNULL(Max(C.GameType),'') as GameType "
      LSQL = LSQL & " FROM tblTourney A  "
      LSQL = LSQL & " INNER JOIN tblTourney B ON B.GameLevelDtlidx = A.GameLevelDtlidx AND B.TeamGameNum = A.TeamGameNum AND B.GameNum = A.GameNum AND B.DelYN='N' "
      LSQL = LSQL & " LEFT JOIN tblGameLevelDtl C ON A.GameLevelDtlidx = C.GameLevelDtlidx AND C.DelYN='N'  "
      LSQL = LSQL & " WHERE A.DelYN = 'N' "
      LSQL = LSQL & " AND A.GameLevelIdx =  '" & GameLevelIdx & "'"
      LSQL = LSQL & " AND A.TeamGameNum = '0' "
      LSQL = LSQL & " AND C.PlayLevelType = 'B0100001'  "
      LSQL = LSQL & " AND A.ORDERBY < B.ORDERBY  "
      'RESPONSE.WRITE "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL "& LSQL&  "<BR><BR>"
      Set LRs = DBCon.Execute(LSQL)
      If Not (LRs.Eof Or LRs.Bof) Then
        Do Until LRs.Eof
          MaxPre_LeagueRound = LRs("LeagueRound")
          MaxPre_TournamentRound = LRs("TournamentRound")
          MaxPre_GameType = LRs("GameType")
          LRs.MoveNext
        Loop
      End If
      LRs.close
      'Response.Write "MaxPre_LeagueRound : " & MaxPre_LeagueRound & "<br>"
      IF MaxPre_GameType = constLeagueGameType Then
        IF CDBL(MaxPre_LeagueRound) > 0 THEN
          MaxPrePosition = GetMaxLeague(MaxPre_LeagueRound)
          IF CDBL(MaxPrePosition) < 3 Then 
            MaxPrePosition = 3
          END IF 
        END IF 
      ELSEIF MaxPre_GameType = constTournamentGameType Then
        MaxPrePosition = MaxPre_TournamentRound
        MaxPre_LeagueRound = 0
      ELSE
        MaxPrePosition = constNonCnt
      End IF

      LSQL = " SELECT ISNULL(max(CAST(A.GameNum AS INT)),0) as LeagueRound, ISNULL(MAX(a.Round),0) as TournamentRound, ISNULL(Max(C.GameType),'') as GameType  "
      LSQL = LSQL & " FROM tblTourney A "
      LSQL = LSQL & " LEFT JOIN tblGameLevelDtl C ON A.GameLevelDtlidx = C.GameLevelDtlidx AND C.DelYN='N'  "
      LSQL = LSQL & " WHERE A.DelYN = 'N' "
      LSQL = LSQL & " AND A.GameLevelIdx =  '" & GameLevelIdx & "'"
      LSQL = LSQL & " AND A.TeamGameNum = '0' "
      LSQL = LSQL & " AND C.PlayLevelType = 'B0100002'  "
      'RESPONSE.WRITE "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL "& LSQL&  "<BR><BR>"
      Set LRs = DBCon.Execute(LSQL)
      If Not (LRs.Eof Or LRs.Bof) Then
        Do Until LRs.Eof
            MaxFinal_LeagueRound = LRs("LeagueRound")
            MaxFinal_TournamentRound = LRs("TournamentRound")
            MaxFinal_GameType = LRs("GameType")
          LRs.MoveNext
        Loop
      End If
      LRs.close

      IF MaxFinal_GameType = constLeagueGameType Then
        IF CDBL(MaxFinal_LeagueRound) > 0 THEN
          MaxFinalPosition = GetMaxLeague(MaxFinal_LeagueRound)
          IF CDBL(MaxFinalPosition) < 3 Then 
            MaxFinalPosition = 3
          END IF 
        END IF 
      ELSEIF MaxFinal_GameType = constTournamentGameType Then
        MaxFinalPosition = MaxFinal_TournamentRound
        MaxFinal_LeagueRound = 0
      ELSE
        MaxFinalPosition = constNonCnt
      End IF

      LSQL = " INSERT INTO tblGameProOrder "
      LSQL = LSQL & " (GameTitleIdx ,StadiumIdx ,GameLevelIdx ,GameOrder ,GameNum, MaxPrePosition, MaxPreGameCount, PreGameType, MaxFinalPosition, MaxFinalGameCount, FinalGameType ,PlayLevelTypePosition,MinPlayLevelType,MaxPlayLevelType, GroupGameGB) "
      LSQL = LSQL & " Values "
      LSQL = LSQL & " ('" & tGameTitleIdx &"','" & tStadiumIDX & "','" & GameLevelIdx & "','" & GameOrder & "','" & GameNumber & "','" & MaxPrePosition & "','" & MaxPre_LeagueRound & "','" & MaxPre_GameType  & "','" & MaxFinalPosition & "','" & MaxFinal_LeagueRound  & "','"& MaxFinal_GameType & "','"& MINPlayLevelType  & "','"& MINPlayLevelType   &"','"& MAXPlayLevelType  &"','" & GroupGameGB & "')"
      Set LRs = DBCon.Execute(LSQL)
    Next
  End If    

  LSQL = "  SELECT  ISNULL(MAX(GameOrder),0) as MaxGameOrder   "
  LSQL = LSQL & " FROM tblGameProOrder "
  LSQL = LSQL & " WHERE DelYN = 'N' and GameTitleIDX ='" & tGameTitleIdx & "' and StadiumIDX='" & tStadiumIDX &"'"
  Set LRs = DBCon.Execute(LSQL)
  If Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
        MaxGameOrder = LRs("MaxGameOrder")
      LRs.MoveNext
    Loop
  End If
  LRs.close

  LSQL = "  SELECT ISNULL((SELECT SUM(MaxPrePosition) FROM tblGameProOrder  WHERE DelYN = 'N' and GameTitleIDX ='" & tGameTitleIdx & "' and StadiumIDX='" & tStadiumIDX &"' AND MinPlayLevelType = 'B0100001') +  SUM(MaxFinalPosition), 0) AS ExitLoopCnt "
  LSQL = LSQL & " FROM tblGameProOrder "
  LSQL = LSQL & " WHERE DelYN = 'N' and GameTitleIDX ='" & tGameTitleIdx & "' and StadiumIDX='" & tStadiumIDX &"'"
  'Response.Write "LSQL : " & LSQL & "<br/>"
  Set LRs = DBCon.Execute(LSQL)
  If Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
        MAXExitLoopCnt = LRs("ExitLoopCnt")
      LRs.MoveNext
    Loop
  End If
  LRs.close


  IF CDBL(MaxGameOrder) > 0 Then 
    MaxGameOrder = MaxGameOrder + 1
    LSQL = " UPDATE tblGameProOrder "
    LSQL = LSQL & " SET ProOrderYN ='Y'"
    LSQL = LSQL & " where GameTitleIdx =  '" & tGameTitleIdx & "'"
    LSQL = LSQL & " AND StadiumIdx =  '" & tStadiumIDX & "'"
    LSQL = LSQL & " AND GameOrder =  '1'"
    LSQL = LSQL & " AND DELYN =  'N'"
    Set LRs = DBCon.Execute(LSQL)
    TempMaxGameOrder = MaxGameOrder - 1
  END IF
  'Response.Write "MaxGameOrder : " & MaxGameOrder & "<br/>"
  Dim SaveGameOrderPosition : SaveGameOrderPosition = GameOrderPosition
  Dim LoopCnt : LoopCnt = 0 
  'Response.End
  Dim LoopMax :  LoopMax = MAXExitLoopCnt
  Do WHile (cdbl(MaxGameOrder) > CDBL(GameOrderPosition))
    
    
    IF(CDBL(LoopCnt) =cdbl(LoopMax)) Then
      'Response.Write "1 LoopCnt:" & LoopCnt & "<br/>"
      Exit Do
    End IF

    IF CDBL(SaveGameOrderPosition) <> CDBL(GameOrderPosition) Then
      LSQL = " UPDATE tblGameProOrder "
      LSQL = LSQL & " SET ProOrderYN ='Y'"
      LSQL = LSQL & " where GameTitleIdx =  '" & tGameTitleIdx & "'"
      LSQL = LSQL & " AND StadiumIdx =  '" & tStadiumIDX & "'"
      LSQL = LSQL & " AND GameOrder =  '" & GameOrderPosition & "'"
      LSQL = LSQL & " AND DELYN =  'N'"
      Set LRs = DBCon.Execute(LSQL)
      SaveGameOrderPosition = GameOrderPosition
    End IF 

    LSQL = " SELECT GameProOrderIdx, PrePosition, MaxPrePosition, FinalPosition, MaxFinalPosition, PlayLevelTypePosition, MaxPlayLevelType, GameOrder, GameLevelIdx, GroupGameGB, PreGameType, FinalGameType, MaxPreGameCount, MaxFinalGameCount"
    LSQL = LSQL & " FROM  tblGameProOrder "
    LSQL = LSQL & " WHERE DelYN = 'N' and ProOrderYN='Y' and GameTitleIDX ='" & tGameTitleIdx & "' and StadiumIdx='" & tStadiumIDX &"'"
    LSQL = LSQL & " Order by (gameorder+0) DESC, (gamenum+0) ASC "

    Set LRs = DBCon.Execute(LSQL)
    IF NOT (LRs.Eof Or LRs.Bof) Then
      arrGameProOrder = LRs.getrows()
    End If
    LRs.close

    For arGameProOrder = LBound(arrGameProOrder, 2) To UBound(arrGameProOrder, 2) 
      IF(CDBL(LoopCnt) =cdbl(LoopMax)) Then
        'Response.Write "2 LoopCnt:" & LoopCnt & "<br/>"
        Exit Do
      End IF

      GameProOrderIdx = arrGameProOrder(0, arGameProOrder) 
      PrePosition   = arrGameProOrder(1, arGameProOrder) 
      MaxPrePosition   = arrGameProOrder(2, arGameProOrder) 
      FinalPosition   = arrGameProOrder(3, arGameProOrder) 
      MaxFinalPosition   = arrGameProOrder(4, arGameProOrder) 
      PlayLevelTypePosition   = arrGameProOrder(5, arGameProOrder) 
      MaxPlayLevelType   = arrGameProOrder(6, arGameProOrder) 
      GameProOrder  = arrGameProOrder(7, arGameProOrder) 
      GameLevelIdx  = arrGameProOrder(8, arGameProOrder) 
      GroupGameGB  = arrGameProOrder(9, arGameProOrder)  
      PreGameType  = arrGameProOrder(10, arGameProOrder)  
      FinalGameType = arrGameProOrder(11, arGameProOrder)  
      MaxPreGameCount = arrGameProOrder(12, arGameProOrder)  
      MaxFinalGameCount = arrGameProOrder(13, arGameProOrder)  

      'Response.Write "PrePosition : " & PrePosition & "<BR/>"
      'Response.Write "MaxPrePosition : " & MaxPrePosition & "<BR/>"
      'Response.Write "FinalPosition : " & FinalPosition & "<BR/>"
      'Response.Write "MaxFinalPosition : " & MaxFinalPosition & "<BR/>"
      'Response.Write "SaveGameOrderPosition : " & SaveGameOrderPosition & "<BR/>"
      'Response.Write "GameOrderPosition : " & GameOrderPosition & "<BR/>"
      
          
      IF (PlayLevelTypePosition = constProPlayLevelType) Then
        IF CDBL(PrePosition) < CDBL(MaxPrePosition) Then
          IF cdbl(PrePosition) = 0 Then
            SetPrePosition = 1
          ELSE
            SetPrePosition = PrePosition + 1  
          END IF

          
          LSQL = " UPDATE tblGameProOrder "
          LSQL = LSQL & " SET PrePosition ='" & SetPrePosition &"'"
          LSQL = LSQL & " where GameProOrderIdx =  '" & GameProOrderIdx & "'"
          Set LRs = DBCon.Execute(LSQL)
          Call SetGameNumber(GameLevelIdx,  PlayLevelTypePosition,  SetPrePosition,  GroupGameGb, MaxPrePosition, PreGameType, MaxPreGameCount)
          Call Display(GameProOrderIdx)
          LoopCnt = LoopCnt + 1
          
        ELSE
          PlayLevelTypePosition2 = PlayLevelTypePosition
          LSQL = " UPDATE tblGameProOrder "
          LSQL = LSQL & " SET PlayLevelTypePosition ='" & constFinalPlayLevelType &"'"
          LSQL = LSQL & " where GameProOrderIdx =  '" & GameProOrderIdx & "'"
          Set LRs = DBCon.Execute(LSQL)
          CALL DisplayUpdate(GameProOrderIdx, PlayLevelTypePosition2)
          IF CDBL(GameProOrder) = CDBL(GameOrderPosition) Then
            IF CDBL(TempMaxGameOrder) <> CDBL(GameOrderPosition) Then
              GameOrderPosition = GameOrderPosition + 1
            END IF
          END IF
        End IF

      ElseIf (PlayLevelTypePosition = constFinalPlayLevelType) Then
        IF CDBL(FinalPosition) < CDBL(MaxFinalPosition) Then
          IF cdbl(FinalPosition) = 0 Then
            SetPrePosition = 1
          ELSE
            SetPrePosition = FinalPosition + 1  
          END IF

          LSQL = " UPDATE tblGameProOrder "
          LSQL = LSQL & " SET FinalPosition ='" & SetPrePosition &"'"
          LSQL = LSQL & " where GameProOrderIdx =  '" & GameProOrderIdx & "'"
          Set LRs = DBCon.Execute(LSQL)
          Call SetGameNumber(GameLevelIdx,  PlayLevelTypePosition,  SetPrePosition, GroupGameGb, MaxFinalPosition, FinalGameType, MaxFinalGameCount)
          Call Display(GameProOrderIdx)
          LoopCnt = LoopCnt + 1
        END IF
      End IF
    
      ' 마지막 종별을 돌리는 중에 프로세스 중인 것이 없으면 While 종료
      IF CDBL(TempMaxGameOrder) = CDBL(GameOrderPosition) Then
        LSQL = "  SELECT Count(*) as ProOrderYNCNT  "
        LSQL = LSQL & " FROM tblGameProOrder "
        LSQL = LSQL & " WHERE DelYN = 'N'"
        LSQL = LSQL & " and GameTitleIDX ='" & tGameTitleIdx & "'"
        LSQL = LSQL & " and StadiumIDX='" & tStadiumIDX &"'"
        LSQL = LSQL & " and ProOrderYN = 'Y'"
        Set LRs = DBCon.Execute(LSQL)
        
        If Not (LRs.Eof Or LRs.Bof) Then
          Do Until LRs.Eof
              ProOrderYNCNT = LRs("ProOrderYNCNT")
            LRs.MoveNext
          Loop
        End If
        LRs.close
        
        IF CDBL(ProOrderYNCNT) = 0 Then
          GameOrderPosition = GameOrderPosition + 1
        End IF
      END IF
      
      '끝난 종별을 프로세스에서 뻄
      IF MaxPlayLevelType = PlayLevelTypePosition and ((CDBL(FinalPosition)) >= CDBL(MaxFinalPosition)) Then
        LSQL = " UPDATE tblGameProOrder "
        LSQL = LSQL & " SET ProOrderYN ='N'"
        LSQL = LSQL & " where GameProOrderIdx =  '" & GameProOrderIdx & "'"
        LSQL = LSQL & " AND DELYN =  'N'"

        'Response.WRite "LSQL : " & LSQL & "<br>"
        Set LRs = DBCon.Execute(LSQL)
      END IF

      'Response.WRite "LoopCnt : " & LoopCnt & "<br>"
      'Call All_Display(tGameTitleIdx, tStadiumIDX)
    Next
  loop
%>

<%
	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
%>

<%
  DBClose()
%>