<% 
'   ===============================================================================     
'    Purpose : badminton Elite 순위 
'    Make    : 2019.03.20
'    Author  :                                                       By Aramdry
'   ===============================================================================    
%> 

<!-- #include virtual = "/pub/fn/fn.utiletc.asp" -->  

<%
'   *******************************************************************************
   ' For Printer
'   *******************************************************************************

'   ===============================================================================     
'      대상 배열 - Rank, Order, Player1, Player2, memIdx1, memIdx2, Team1, Team2, cTeam1, cTeam2, TeamDtl, 승패득실차       
'      history 배열 (rAryHistory)- 
'      0-6, L_MemberNames,	L_MemberIDXs, L_TeamNames, L_Teams, L_TeamDtl,  R_MemberNames, R_MemberIDXs, 
'      7-15 R_TeamNames, R_Teams, R_TeamDtl,  L_SetJumsu	,L_MatchJumsu,	R_SetJumsu,R_MatchJumsu, L_Result, EnterType 

'      1. 승, 패 , 득, 실, 차 순으로 비교를 한다. 
'      2. 각 단계비교 이후 동률 값은 승자승 비교를 한다. 
'      3. 승자승 비교후 동률 값은 다음 단계의 값을 기준으로 비교를 한다. 
'      4. 승자승 비교에서 상대 전적을 알기 위해 history 경기를 찾는다. 이때 
'              개인전일 경우 uxFindPersonGameInfo()를 is_reverse = false, true로 2번 호출하여 비교하고 , 
'              팀전일 경우 uxFindTeamGameInfo()를 is_reverse = false, true로 2번 호출하여 비교한다.  
'   =============================================================================== 

'=================================================================================
	' 순위를 생성한다.     
'   1. 승,패,득,실,차를 기준으로 순위를 정한다. 
'   2. '승' Field를 기준으로 sort한다. sort후 Ranking을 셋팅해 준다. 
'   3. Ranking 값을 기준으로 동일값을 체크한다. 
'      - 동일 Ranking이 2명이면 승자승 체크가 되어 있으면 승자승 기준을 적용한다. 
'      - 승자승 기준을 적용하여 승자 구분이 되면 두 값을 바꾸어 준다. 
'      - 승자승 기준을 적용하여 승자 구분이 안되면 나머지 기준을 가지고 비교를 한다. 
'      - 승자승 기준에서 나머지 기준으로 비교를 해도 동일 하다면 랜덤하게 값을 준다. (거의 없음)
'      - 동일 Ranking이 2명이면 승자승 체크가 되어 있지 않으면 다음 기준값을 가지고 sort한다. 
'      - 동일 Ranking이 3명이상 이면 다음 기준값을 가지고 sort한다. 
'      - sort후 Ranking을 셋팅해 준다. 
'   4. 동일 Ranking이 없을때 까지 3번을 수행한다. 

    ' rAryRank : sort 대상
    '       Rank, Order, Player1, Player2, memIdx1, memIdx2, Team1, Team2, cTeam1, cTeam2, TeamDtl, 승패득실차       
    ' rAryHistory : 승자승 비교시 사용하는 게임 전적
    '           0-6, L_MemberNames,	L_MemberIDXs, L_TeamNames, L_Teams, L_TeamDtl,  R_MemberNames, R_MemberIDXs, 
    '           7-15 R_TeamNames, R_Teams, R_TeamDtl,  L_SetJumsu	,L_MatchJumsu,	R_SetJumsu,R_MatchJumsu, L_Result, EnterType 
    ' IsTeamGame : 팀게임 유무 , 승자승 비교시 개인전 : uxFindPersonGameInfo, 팀전 : uxFindTeamGameInfo 사용 
    ' useHistory : 승자승을 사용할 것인지 유무 , 사용을 안할 경우 승자승 비교는 무조건 0 (동률)을 return 
	'================================================================================= 
   Dim aryGameResult
'   ===============================================================================     
'    베드민턴 경기 결과 값 - tblGameResult Result field에서 사용
'   ===============================================================================
   aryGameResult = Array( _
                        Array("B5010001", "판정승"), _
                        Array("B5010002", "기권승(경기전)"), _
                        Array("B5010003", "기권승(경기중)"), _
                        Array("B5010004", "불참"), _
                        Array("B6010001", "판정패"), _
                        Array("B6010002", "기권패(경기전)"), _
                        Array("B6010003", "기권패(경기중)"), _
                        Array("B6010004", "불참") _
   )

'   ===============================================================================     
'     result code를 입력받아 win / lose를 판정한다. 
'     aryGameResult(0~3) 승 aryGameResult(4~7) 패 
'   ===============================================================================
   Function IsGameResultWin(rstCode) 
      Dim bWin , ai, aul
      aul = UBound(aryGameResult)

      For ai = 0 To aul 
        If (aryGameResult(ai)(0) = rstCode) Then 
            If(ai < 4) Then     ' 승 
                bWin = 1 
            Else                ' 패 
                bWin = 0
            End If 
            Exit For
        End If 
      Next
         
      IsGameResultWin = bWin
   End Function 


   Function printInfoEx(rAryInfo)
      Dim ai, aj , ul, ul2, strInfo
      ul = UBound(rAryInfo,2)
      ul2 = UBound(rAryInfo,1)
      
      strLog = " ------------------------- printInfoEx  <br>"
      response.write strLog

      strInfo = ""

      For ai = 0 To ul 
         strInfo = ""
         For aj = 0 To ul2 
            strInfo = strPrintf("{0} ({1} - {2})", Array(strInfo, aj, rAryInfo(aj, ai)))             
         Next 
         response.write strInfo & "<br>"
      Next

      strLog = " ------------------------- printInfoEx  <br>"
      response.write strLog
   End Function 

'   =================================================================================
	 ' 순위를 생성한다. - Like mssql - Rank() ( ary[key]를 기준으로 순위를 생성한다. ) 
    ' 이때 생성한 순위는 중복 될수 있다. 
    ' 중복된 순위는 나중에 순위를 구하는 Block이 된다. 
    ' key - data Idx
    ' rKey - rank key 
	'================================================================================= 
   Function uxMakeRankByKey(rAryRank, key)
      Dim ul, ai
      Dim prevVal, prevRank

      prevVal = 0
      prevRank = 0
      rKey    = 0
      
      ul = UBOUND(rAryRank, 2)

      For ai=0 To ul
         If( rAryRank(key, ai) = prevVal ) Then 
               rAryRank(rKey, ai) = prevRank
         Else 
               rAryRank(rKey, ai) = ai + 1
               prevRank = rAryRank(rKey, ai)
         End If

         prevVal = rAryRank(key, ai)
      Next

   End Function

'   =================================================================================
'   1. 승,패,득,실,차를 기준으로 순위를 정한다. 
'   2. '승' Field를 기준으로 sort한다. sort후 Ranking을 셋팅해 준다. 
'   3. Ranking 값을 기준으로 동일값을 체크한다. 
'      - 동일 Ranking이 2명이면 승자승 체크가 되어 있으면 승자승 기준을 적용한다. 
'      - 승자승 기준을 적용하여 승자 구분이 되면 두 값을 바꾸어 준다. 
'      - 승자승 기준을 적용하여 승자 구분이 안되면 나머지 기준을 가지고 비교를 한다. 
'      - 승자승 기준에서 나머지 기준으로 비교를 해도 동일 하다면 랜덤하게 값을 준다. (거의 없음)
'      - 동일 Ranking이 2명이면 승자승 체크가 되어 있지 않으면 다음 기준값을 가지고 sort한다. 
'      - 동일 Ranking이 3명이상 이면 다음 기준값을 가지고 sort한다. 
'      - sort후 Ranking을 셋팅해 준다. 
'   4. 동일 Ranking이 없을때 까지 3번을 수행한다. 

    ' key - data Idx
    ' rKey - rank key 
	'=================================================================================    
   Function uxMakeRankForPrint(rAryRank, rAryHistory, IsTeamGame, useHistory)
      Dim ul, ai, prevRank, nCnt, sPos, nGrade
      Dim key, rKey, IsDesc, sortDataType
      
      prevRank = 0
      nCnt = 0      

      key = 11
      rKey = 0
      sortDataType = 2        ' key가 가리키는 데이터가 숫자이다. 숫자 비교 
      IsDesc = 1 

      ' 1: 승으로 먼저 배열을 sort한다. 
      Call Sort2DimAryEx(rAryRank, key, sortDataType, IsDesc)
   
      ' 승을 기준으로 sort한 데이터를 가지고 rank값을 설정한다.       
      Call uxMakeRankByKey(rAryRank, key)
      Call printInfoEx(rAryRank)

      ul = UBOUND(rAryRank, 2)
      key = key+1

      strLog  = strPrintf("uxMakeRankForPrint .. key = {0}<br>", Array(key))
      response.write strLog

      For ai=0 To ul
         If( rAryRank(rKey, ai) = prevRank ) Then 
               nCnt = nCnt + 1
         Else      
               If(nCnt > 1 ) Then 
                  Call uxRankForPrint(rAryRank, rAryHistory, sPos, nCnt, key, IsTeamGame, useHistory)
                  strLog = strPrintf("uxMakeRankForPrint sPos = {0}, nCnt = {1}<br>" , Array(sPos, nCnt))
                  response.write strLog
               End If           
               prevRank = rAryRank(rKey, ai)
               sPos = ai
               nCnt = 1
         End If
      Next

      If(nCnt > 1 ) Then 
         Call uxRankForPrint(rAryRank, rAryHistory, sPos, nCnt, key, IsTeamGame, useHistory)
         strLog = strPrintf("uxMakeRankForPrint22 sPos = {0}, nCnt = {1}<br>" , Array(sPos, nCnt))
         response.write strLog
      End If      
   End Function 

   '=================================================================================
	' Block 단위에서 순위를 생성한다. 
    ' 1. sPos, nCnt, 
    ' Rank, Order, Player1, Player2, memIdx1, memIdx2, Team1, Team2, cTeam1, cTeam2, TeamDtl, 승패득실차  
    ' key - data Idx
    ' rKey - rank key      
	'================================================================================= 
   Function uxRankForPrint(rAryRank, rAryHistory, sPos, nCnt, key, IsTeamGame, useHistory)
      Dim sIdx, eIdx, nRet 
      Dim strLog

      sIdx = sPos 
      eIdx = sIdx + (nCnt-1) 
      strLog = strPrintf("uxRankForPrint -- sIdx = {0}, eIdx = {1}, nCnt = {2}, key = {3}<br>" , Array(sIdx, eIdx, nCnt, key))
      response.write strLog

      If(nCnt = 2 And useHistory = 1 ) Then                                        
         nRet = uxCheckWinner(rAryHistory, rAryRank, sIdx, IsTeamGame)            
      Else             
         eIdx = sIdx + (nCnt-1) 
         Call uxCalcRank(rAryHistory, rAryRank, key, sIdx, eIdx, IsTeamGame, useHistory)
      End If
   End Function

   '=================================================================================
	' Block에서 특정 키를 비교하여 순위를 생성한다. 
    ' Rank, Order, Player1, Player2, memIdx1, memIdx2, Team1, Team2, cTeam1, cTeam2, TeamDtl, 승패득실차  
    ' key - data Idx
    ' rKey - rank key 
	'================================================================================= 
    Function uxCalcRank(rAryHistory, rAryRank, key, sPos, ePos, IsTeamGame, useHistory)
      Dim rri, IsDesc, rKey 
      Dim prevVal, prevRank, col, nCnt, sKey, sortDataType 
      
      prevVal = 0
      prevRank = 0
      IsDesc = 1 
      sortDataType = 2        ' key가 가리키는 데이터가 숫자이다. 숫자 비교 
      rKey = 0

      strLog = strPrintf("uxCalcRank -- key = {0}, sPos = {1}, ePos = {2}<br>" , Array(key, sPos, ePos))
      response.write strLog

      If(key > 15) Then     ' rank비교를 더이상 할게 없다.             
         Exit Function 
      End If

      strLog  = strPrintf("uxCalcRank222 .. key = {0}, sPos = {1}, ePos = {2}<br>", Array(key,sPos,ePos))
      response.write strLog
      ' key에 의존하여 배열을 재 정렬한다. 
      Call SortPart2DimAryEx(rAryRank, key, sPos, ePos, sortDataType, IsDesc)    
      Call printInfoEx(rAryRank)  

      strLog  = "sort after count rank<br>"
      response.write strLog

      ' 정렬후 순위를 매긴다. 
      For rri = sPos To ePos
         If( rAryRank(key, rri) = prevVal ) Then 
            rAryRank(rKey, rri) = prevRank
         Else 
            rAryRank(rKey, rri) = rri + 1
            prevRank = rAryRank(rKey, rri)                
         End If
         prevVal = rAryRank(key, rri)

         strLog  = strPrintf("For .. i = {0}, val = {1}, rank = {2}<br>", Array(rri, rAryRank(key, rri), rAryRank(rKey, rri)))
         response.write strLog
      Next

      Call printInfoEx(rAryRank)

      ' 겹치는 순위가 있는지 확인하여 순위를 구한다. 
      sKey = key + 1
      nCnt = 0
      prevRank = 0
      sBlock = 0

       For rri = sPos To ePos
           If( rAryRank(rKey, rri) = prevRank ) Then 
               nCnt = nCnt + 1
           Else      
               If(nCnt > 1 ) Then                     
                  Call uxRankForPrint(rAryRank, rAryHistory, sBlock, nCnt, sKey, IsTeamGame, useHistory)
            strLog = strPrintf("sBlock = {0}, nCnt = {1}, sKey = {2}, rKey = {3}<br>" , Array(sBlock, nCnt, sKey, rKey))
            response.write strLog
               End If           
               prevRank = rAryRank(rKey, rri)
               sBlock = rri
               nCnt = 1
           End If

           prevVal = rAryRank(1, rri)
       Next

   strLog = strPrintf("uxCalcRank sPos = {0}, ePos = {1}, sKey = {2}<br>" , Array(sPos, ePos, sKey))
   response.write strLog

      If(nCnt > 1 ) Then             
         Call uxRankForPrint(rAryRank, rAryHistory, sBlock, nCnt, sKey, IsTeamGame, useHistory)
         strLog = strPrintf("sBlock = {0}, nCnt = {1}, sKey = {2}<br>" , Array(sBlock, nCnt, sKey))
         response.write strLog
      End If

   End Function

   '   ===============================================================================     
'      Check winer
'      left, right player code를 입력받아 서로의 전적을 비교한다. 
'      rAryRank :  Rank, Order, Player1, Player2, memIdx1, memIdx2, Team1, Team2, cTeam1, cTeam2, TeamDtl, 승패득실차  
'      rAryHistory :    result, cLTeam, LTeam, cRTeam, RTeam
'      cntWin > 0  => LPlayer Win
'      cntWin < 0  => RPlayer Win
'      cntWin = 0  => LPlayer = RPlayer 승자승을 비교했는데 무승부다.. 남은 값들을 비교하고 그래도 같으면 Random으로 처리 
'   =============================================================================== 
	Function uxCheckWinner(rAryHistory, rAryRank, sPos, rKey, IsTeamGame)
      Dim cntWin, cidx, cub, l_pos, r_pos, nRank, is_reverse, infoIdx
      Dim l_player1, l_team1, l_player2, l_team2, r_player1, r_team1, r_player2, r_team2
      Dim l_teamDtl, r_teamDtl, game_result

      l_pos = sPos
      r_pos = sPos + 1

      nRank    = rAryRank(rKey, l_pos)        ' 순위       
      cub = UBound(rAryHistory, 2)  
      cntWin = 0

      If( IsTeamGame = 1 ) Then 
         l_team1        = rAryRank(7, l_pos)             
         l_teamDtl      = rAryRank(9, l_pos)
         r_team1        = rAryRank(7, l_pos)
         r_teamDtl      = rAryRank(9, l_pos)
      Else 
         l_player1      = rAryRank(3, l_pos)             
         l_player2      = rAryRank(4, l_pos)
         l_team1        = rAryRank(7, l_pos)
         l_team2        = rAryRank(8, l_pos)
         r_player1      = rAryRank(3, r_pos)             
         r_player2      = rAryRank(4, r_pos)
         r_team1        = rAryRank(7, r_pos)
         r_team2        = rAryRank(8, r_pos)
      End If 

      is_reverse = 0
      For cidx = 0 to cub    
         If( IsTeamGame = 1 ) Then         
            infoIdx = uxFindPersonGameInfo(rAryHistory, l_player1, l_team1, l_player2, l_team2, r_player1, r_team1, r_player2, r_team2, is_reverse )
         Else
            infoIdx = uxFindTeamGameInfo(rAryHistory, l_team1,l_teamDtl, r_team1,r_teamDtl, is_reverse )
         End If
         If(infoIdx <> -1) Then
            game_result = IsGameResultWin(rAryHistory(14,infoIdx))
            If(game_result = 1) Then 
               cntWin = cntWin + 1
            Else
               cntWin = cntWin - 1
            End If 
         End If 
      Next

      is_reverse = 1
      For cidx = 0 to cub    
         If( IsTeamGame = 1 ) Then           
            infoIdx = uxFindPersonGameInfo(rAryHistory, l_player1, l_team1, l_player2, l_team2, r_player1, r_team1, r_player2, r_team2, is_reverse )
         Else
            infoIdx = uxFindTeamGameInfo(rAryHistory, l_team1,l_teamDtl, r_team1,r_teamDtl, is_reverse )
         End If 

         If(infoIdx <> -1) Then
            game_result = IsGameResultWin(rAryHistory(14,infoIdx))
            If(game_result = 1) Then 
               cntWin = cntWin - 1
            Else
               cntWin = cntWin + 1
            End If 
         End If 
      Next

      If( cntWin = 0 ) Then ' 승자승 비교로 동률이면 나머지 grade로 비교를 하자 
         cntWin = uxCheckWinnerByGrade(rAryRank, sPos, rKey)
      End If

      ' 순위를 적용한다. 
      If (cntWin > 0) Then 
         rAryRank(rKey, r_pos)  = nRank + 1
      Else    ' 순위가 바뀐다. swap 
         rAryRank(rKey, l_pos)  = nRank + 1      
         Call SwapRows(rAryRank, l_pos, r_pos)
      End If 

      uxCheckWinner = cntWin
   End Function 

   '   ===============================================================================     
'      Check winer
'      0. a grade는 같기 때문에 승자승 비교로 넘어 왔고, 
'          승패 비교로 동률이면 이 함수로 넘어온다. 
'      1. left, right Player의 b, c, d grade를 비교하여 승자를 결정한다. 
'      2. 1의 결과로 비겼으면 Random으로 승자를 결정한다. 
'      ret > 0 : sPos 승 , ret < 0 : sPos 패 
'
'      rAryRank :  Rank, Order, Player1, Player2, memIdx1, memIdx2, Team1, Team2, cTeam1, cTeam2, TeamDtl, 승패득실차  
'      key - data Idx
'      rKey - rank key 
'   =============================================================================== 
	Function uxCheckWinnerByGrade(rAryRank, sPos, rKey)
        
        Dim ret , lPos, rPos, key
        lPos = sPos
        rPos = sPos + 1

        ' rAryRank(key)가 음수값을 인식 하지 못하여 CInt()로 Convert하여 대소비교를 수행한다. 
        ' 패 비교 
        key = 12 
        If( CInt(rAryRank(key, lPos)) > CInt(rAryRank(key, rPos)) ) Then 
            ret = 1
        ElseIf( CInt(rAryRank(key, lPos)) < CInt(rAryRank(key, rPos)) ) Then  
            ret = -1
        Else 
            ' 득 비교 
            key = key + 1
            If( CInt(rAryRank(key, lPos)) > CInt(rAryRank(key, rPos)) ) Then 
                ret = 1
            ElseIf( CInt(rAryRank(key, lPos)) < CInt(rAryRank(key, rPos)) ) Then  
                ret = -1
            Else 
                ' 실 비교 
                key = key + 1
                If( CInt(rAryRank(key, lPos)) > CInt(rAryRank(key, rPos)) ) Then 
                    ret = 1
                ElseIf( CInt(rAryRank(key, lPos)) < CInt(rAryRank(key, rPos)) ) Then  
                    ret = -1
                Else 
                    ' 차 비교 
                    key = key + 1                
                     If( CInt(rAryRank(key, lPos)) > CInt(rAryRank(key, rPos)) ) Then 
                        ret = 1
                     ElseIf( CInt(rAryRank(key, lPos)) < CInt(rAryRank(key, rPos)) ) Then  
                        ret = -1
                     Else 
                        ' a, b, c, d grade / 전적이 다 동률이다. Random으로 결정하자                     
                        ret = -1
                        rNum = GetRandomNum(2)
                        If (rNum = 1) Then ret = 1 End If
                     End If 
               End If 
            End If
        End If 

'        strLog = strPrintf("uxCheckWinnerByGrade ret = {0}, b1 = {1}, b2 = {2}, c1 = {3}, c2 = {4}, d1 = {5}, d2 = {6},<br>", _
'            Array(ret, rAryRank(2, lPos), rAryRank(2, rPos), rAryRank(3, lPos), rAryRank(3, rPos), rAryRank(4, lPos), rAryRank(4, rPos) ))
'        
'        Response.Write strLog

        uxCheckWinnerByGrade = ret
    End Function  





'   ===============================================================================     
'      개인전 정보를 얻는다. 
'      0-6, L_MemberNames,	L_MemberIDXs, L_TeamNames, L_Teams, L_TeamDtl,  R_MemberNames, R_MemberIDXs, 
'      7-15 R_TeamNames, R_Teams, R_TeamDtl,  L_SetJumsu	,L_MatchJumsu,	R_SetJumsu,R_MatchJumsu, L_Result, EnterType 
'   =============================================================================== 
   Function uxFindPersonGameInfo(rAry, l_player1, l_team1, l_player2, l_team2, r_player1, r_team1, r_player2, r_team2, is_reverse)
      Dim ai, ul, aryLP, aryRP, aryLT, aryRT, retIdx

      ul = UBound(rAry,2)
      retIdx = -1

      For ai = 0 To ul 
         If(InStr(rAry(0, ai), "|")) Then 
            if(is_reverse = 1) Then 
               aryLP = split(rAry(6, ai), "|")               
               aryLT = split(rAry(8, ai), "|")
               aryRP = split(rAry(1, ai), "|")
               aryRT = split(rAry(3, ai), "|")
            Else 
               aryLP = split(rAry(1, ai), "|")               
               aryLT = split(rAry(3, ai), "|")
               aryRP = split(rAry(6, ai), "|")
               aryRT = split(rAry(8, ai), "|")
            End If 

            If(aryLP(0) = l_player1 And aryLP(1) = l_player2) And (aryLT(0) = l_team1 And aryLT(1) = l_team2) And _
              (aryRP(0) = r_player1 And aryRP(1) = r_player2) And (aryRT(0) = r_team1 And aryRT(1) = r_team2) Then 
              retIdx = ai
              Exit For 
            End If 
         Else 
            If(rAry(1, ai) = l_player1 Or rAry(1, ai) = l_player2) And (rAry(3, ai) = l_team1 Or rAry(3, ai) = l_team2) And _
              (rAry(6, ai) = r_player1 Or rAry(6, ai) = r_player2) And (rAry(8, ai) = r_team1 And rAry(8, ai) = r_team2) Then 
              retIdx = ai
              Exit For 
            End If 
         End If          
      Next

      uxFindPersonGameInfo = retIdx
   End Function

   
'   ===============================================================================     
'      팀전 정보를 얻는다. 
'      0-6, L_MemberNames,	L_MemberIDXs, L_TeamNames, L_Teams, L_TeamDtl,  R_MemberNames, R_MemberIDXs, 
'      7-15 R_TeamNames, R_Teams, R_TeamDtl,  L_SetJumsu	,L_MatchJumsu,	R_SetJumsu,R_MatchJumsu, L_Result, EnterType 
'   =============================================================================== 
   Function uxFindTeamGameInfo(rAry, l_team1,l_teamDtl, r_team1,r_teamDtl, is_reverse)
      Dim ai, ul, l_team, l_dtl, r_team, r_dtl 

      ul = UBound(rAry,2)
      retIdx = -1

      For ai = 0 To ul 
         If( is_reverse = 1 ) Then 
            l_team   = rAry(8, ai)
            l_dtl    = rAry(9, ai)
            r_team   = rAry(3, ai)
            r_dtl    = rAry(4, ai) 
         Else
            l_team   = rAry(3, ai)
            l_dtl    = rAry(4, ai)
            r_team   = rAry(8, ai)
            r_dtl    = rAry(9, ai) 
         End If 

         If(l_team = l_team1 And l_dtl = l_teamDtl) And (r_team = r_team1 And r_dtl = r_teamDtl) Then 
            retIdx = ai
            Exit For 
         End If         
      Next

      uxFindTeamGameInfo = retIdx  
   End Function


%>
