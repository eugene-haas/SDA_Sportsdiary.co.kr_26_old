<% 
'   ===============================================================================     
'    Purpose : badminton Elite 추첨에 들어가는 Util 함수 
'    Make    : 2019.07.19
'    Author  :                                                       By Aramdry
'   ===============================================================================    
%> 

<!-- #include virtual = "/pub/fn/badmt/res/res.pos.asp" -->  


<% 	  
'   ===============================================================================     
'     ary position  - 
'      fUse : user 할당 유무 
'      pos_kind : position 종류 - normal, seed, bye/Q (Qualification)
'      pos_val   : normal - -1(사용안함) , seed position val (1, 2, 3.. ), bye/Q position val (1, 2, 3)
'
'     복식 : fUse, pos, pos_kind, pos_val, playerCode(gGroupIdx), cUser1, user1, cUser2, user2, cTeam1, team1, cTeam2, team2
'             0,    1 ,   2     ,    3   ,    4                 ,    5  ,   6  ,    7  ,   8  ,    9  ,   10 ,   11  ,   12     
'     단식 : fUse, pos, pos_kind, pos_val, playerCode(gGroupIdx), cUser, user, cTeam, team
'              0 ,  1 ,    2    ,    3   ,    4                 ,   5  ,   6 ,   7  ,   8
'     ary user - 
'      fUse, teamNo, SeedNo, Ranking, dataOrder, PlayerOrder, GameRequestGroupIDX, GameRequestPlayerIDX, MemberIDX, MemberName, Team, TeamName, PrevTeam, PrevTeamName
'        0 ,   1   ,   2   ,    3   ,    4     ,     5      ,        6           ,      7              ,    8     ,      9    ,   10,   11    ,    12    ,   13             
'      fUse : user 할당 유무 
'      seed : seed Number
'
'     ary Team Info 
'        fUse, selOrder, teamOrder, cTeam, team, seedCnt, userCnt
'   ===============================================================================   
%>

<% 	  
'   ===============================================================================     
'    개발 개요 
'               	본선 Tournament만 있다.   cntUser <= round
'         cntUser <= round	
'            1.  참가 신청자가 Tournament 강수보다 작거나 같을 경우 예선조는 없다. 
'            2. Bye자리가 존재할수 있다. 
'            3. Seed가 존재할수 있다. 
'            
'         참가자 배정 - 1	
'            1. Bye가 존재할 경우 Bye를 aryPos에 적용한다. 
'            2. Seed가 존재할 경우 Seed를 aryPos에 적용한다. 
'            3. Tournament Round를 반으로 나누어 A part, B part로 구분한다. 
'            4. 참가 신청자( aryReq )를 A part, B part로 나눈다. 
'            5. A part, B part에 존재하는 Bye, Seed를 각각의 part에 배정한다. 
'            6. 참가 신청자를 특정 룰에 의거하여 A part, B part에 배정한다. 
'            
'         참가자 배정 - 2	
'            1. 참가 신청자에 Team이 존재할 경우 Team을 기준으로 참가자를 배정한다. 
'            2. 각 Team에는 해당팀별 순위별로 정렬되어 참가자가 존재한다. 
'            3. 각 Team의 1장서부터 번갈아 가면서 할당한다. 
'                  - 즉 A part : a1, b2, c1, d2 ... / B part : a2, b1, c2, d1... 
'            4. 인원을 할당할때 seed로 인하여 할당이 되었을 경우 , 다음 team에서 인원을 선택하여 인원을 할당한다. 
'            5. 현재 할당되는 Team내 order를 유지하고 있어야 한다. ( ex) 각팀의 3장 선수 할당중.. )
'            6. 인원을 할당한 team은 표시를 한다. 
'            7. 더이상 할당할 인원이 없는 Team은 할당리스트에서 제거한다. 
'            8. 예선조는 각 팀의 못하는 선수만 모아서 추린다. 
'                  - 이때 특정팀의 선수가 많이 있어도 그 안에서 최대한 겹치지 않게 꾸리면 된다. 
'                     ex) A team: 7명 , B team: 5명 ,  C team : 2, D team : 2 ... 일 경우 예선조 Ateam 5, B team : 3으로 구성될수도 있음. 
'                           협회와 협의 사항임. 
'            9. 각 팀마다 Team내 Order순으로 할당할 경우는 인원이 많은 팀에서 예선조가 나올수가 있다. 
'            
'         참가자 배정 - 3	
'            1. 인원을 A part / B part로 나누는 작업이 끝났다. 예선조는 없다. 
'            2. 이제는 각 part에 있는 인원을 가지고 random하게 인원을 할당하면 된다. 
'            3. aryPos에서 할당된 seed를 확인한 후 A part / B part에서 해당 player에 할당표시를 한다. 
'            4. team별로 인원을 count한다. 
'            5. 인원수를 가지고 team을 3가지로 구분한다. 
'               - a : half보다 큰팀 - 제일 마지막에 할당한다. 
'               - b : half보다 작고 average보다 큰팀 - 제일 먼저 할당한다. 
'               - c : b항을 다 할당한 다음에 할당한다. 이때 a항( half 큰팀)을 제외한 모든팀을 순차적으로 돌면서 할당한다. 
'               더이상 할당할 인원이 없는 경우 team을 제거한다. 
'            
'            6. aryPos도 aryPosA / aryPosB로 나누어 관리한다. 
'            
'         참가자 배정 - 4	position block을 구한후 인원을 할당. 
'            1. 할당할 team을 선택후 aryUserA / aryUserB에서 해당 team user를 선택한다. 
'            2. search block에 의하여 할당 가능한 block을 구하면 
'               block size > 4면 block size = 4로 바꾼 다음에 제일 인원수가 적은 block에 인원을 할당한다. 
'            
'            
'            본선 Tournament + 예선조    cntUser >  round
'         cntUser > round	
'            1.  참가 신청자가 Tournament 강수보다 클경우 Bye는 없다
'            2. 예선조가 존재한다. 
'            3. Seed가 존재할수 있다. 
'            
'         참가자 배정 - 1	
'            1. 예선조 Count를 구한다. 
'            2. Seed가 존재할 경우 Seed를 aryPos에 적용한다. 
'            3. 예선조를 A part / B part에 번갈아 가면서 할당한다. 
'            
'         참가자 배정 - 2	예선조 승자 본선 할당 
'            1. aryPosA , aryPosB로 나눈후 예선조 할당을 한다. 
'            2. 각 part에서 seed 갯수를 구한다. 
'            3. 예선조 갯수는 seed갯수가 차이가 있을 경우 seed가 많은쪽에 그 차이만큼 예선조를 덜 할당한다. 
'               ex) A part seed cnt = 3, B part seed cnt = 1 , 예선조 cnt = 8이라면
'                     halfQCnt = Int(QCnt - (ASeedCnt - BSeedCnt) / 2)
'                     AQCnt = halfQCnt, BQCnt = QCnt - halfQCnt
'            
'            4.search block으로 position block을 구한후 예선조 할당
'            5. search block에 의하여 할당 가능한 block을 구하면 
'               block size > 4면 block size = 4로 바꾼 다음에 제일 인원수가 적은 block에 인원을 할당한다. 
'            6. aryPosA / aryPosB를 aryPos으로 merge한다. 
'            
'            
'               예선조 할당 - 예선조 승자를 aryPos에 할당한다.
'               예선조는 기본적으로 4자리당 1개만 들어갈수 있다.
'               즉 최대 예선조 갯수는 nQMax = Round / 4 이다.  - 이것은 예선조 갯수를 구하는 공식에서도 사용한다.
'               예선조가 포함된 block에 최대 1개의 Seed가 존재 할수 있다.
'               기본 block(4)에는 최대 seed : 1개, Q : 1개가 존재 할수 있다.
'               예선조는 Seed가 없는 곳에 우선 배치한다.
'               QCnt + SeedCnt <= nQMax면 Q와 Seed는 겹치지 않는다.
'               QCnt + SeedCnt > nQMax이면 Q와 Seed는 겹칠수 있다.
'            
'         참가자 배정 - 3	본선 인원 할당
'            1. Seed, Q 가 aryPos에 할당되어 있다. 
'            3. Tournament Round를 반으로 나누어 A part, B part로 구분한다. 
'            4. 참가 신청자( aryReq )를 A part, B part로 나눈다. 
'            5. A part, B part에 존재하는 Q, Seed를 각각의 part에 배정한다. 
'            6. 참가 신청자를 특정 룰에 의거하여 A part, B part에 배정한다. 
'            
'            
'         참가자 배정 - 4	예선조 Player 할당
'            1. 예선조 인원을 구한다. 
'               QUserCnt = TotalUserCnt - TournamentUserCnt
'            2. 각 Team별 인원수를 구한다. 
'            3. 각 Team의 1장서부터 순차적으로 count를 한다. 
'            4. cnt > TournamentCnt면 이때 부터 aryQUser에 인원을 할당한다. 
'            
'         참가자 배정 - 5	예선조 position 할당
'            1. 예선조는 기본적으로 4인 1조이다. 
'            2. 예선조 인원이 적은 조는 Q1조 부터 배정한다. 즉 제일 적은 인원의 조부터 배열한다. 
'            3. 예선조 인원 <= 4이면 예선조는 1개 조이다. 
'            4. 예선조 인원이 <= 8 이면 예선조는 2개 조 이다. 
'               QCnt = 7 이면 Q1 = 3, Q2 = 4
'               QCnt = 6 이면 Q1 = 3, Q2 = 3
'               QCnt = 5 이면 Q1 = 2, Q2 = 3
'            5. 예선조 인원 <= 12이면 예선조는 3개조 이다. 
'               QCnt = 11 이면 Q1 = 3, Q2 = 4, Q3 = 4
'               QCnt = 10 이면 Q1 = 3, Q2 = 3, Q3 = 4
'               QCnt = 9 이면 Q1 = 3, Q2 = 3, Q3 = 3
'            
'            6. 예선조 인원 > 12이면 
'                  QCnt Mod 4 = 3 이면  Q1 = 3
'                  QCnt Mod 4 = 2 이면  Q1 = 3, Q2 = 3
'                  QCnt Mod 4 = 1 이면  Q1 = 3, Q2 = 3, Q3= 3
'            
'         참가자 배정 - 6	예선조 position 할당
'            1. team별로 인원을 count한다. 
'            2. team별 인원이 제일 많은 팀부터 인원을 할당한다. 
'            3. 모든 예선조에 한번씩 할당한다. 
'            4. 예선조에 할당 할때 Index는 1, 4, 3, 2순으로 한다. 
'               ( 그래야 같은 팀이 경기를 하는 것을 배제할수 있다. ) 
'            5. Bye가 있을 경우 다른 pos에 할당한다. 
'            6. 할당이 끝난 예선조는 할당 리스트에서 제거한다. 
'            
'         참가자 배정 - 7	
'            1. 참가 신청자에 Team이 존재할 경우 Team을 기준으로 참가자를 배정한다. 
'            2. 각 Team에는 해당팀별 순위별로 정렬되어 참가자가 존재한다. 
'            3. 각 Team의 1장서부터 번갈아 가면서 할당한다. 
'                  - 즉 A part : a1, b2, c1, d2 ... / B part : a2, b1, c2, d1... 
'            4. 인원을 할당할때 seed로 인하여 할당이 되었을 경우 , 다음 team에서 인원을 선택하여 인원을 할당한다. 
'            5. 현재 할당되는 Team내 order를 유지하고 있어야 한다. ( ex) 각팀의 3장 선수 할당중.. )
'            6. 인원을 할당한 team은 표시를 한다. 
'            7. 더이상 할당할 인원이 없는 Team은 할당리스트에서 제거한다. 
'            8. 예선조는 각 팀의 못하는 선수만 모아서 추린다. 
'                  - 이때 특정팀의 선수가 많이 있어도 그 안에서 최대한 겹치지 않게 꾸리면 된다. 
'                     ex) A team: 7명 , B team: 5명 ,  C team : 2, D team : 2 ... 일 경우 예선조 Ateam 5, B team : 3으로 구성될수도 있음. 
'                           협회와 협의 사항임. 
'            9. 각 팀마다 Team내 Order순으로 할당할 경우는 인원이 많은 팀에서 예선조가 나올수가 있다. 
'            
'         참가자 배정 - 8	
'            1. 인원을 A part / B part로 나누는 작업이 끝났다. 예선조가 있다. 
'            2. 이제는 각 part에 있는 인원을 가지고 random하게 인원을 할당하면 된다. 
'            3. aryPos에서 할당된 seed를 확인한 후 A part / B part에서 해당 player에 할당표시를 한다. 
'            4. team별로 인원을 count한다. 
'            5. 인원수를 가지고 team을 3가지로 구분한다. 
'               - a : half보다 큰팀 - 제일 마지막에 할당한다. 
'               - b : half보다 작고 average보다 큰팀 - 제일 먼저 할당한다. 
'               - c : b항을 다 할당한 다음에 할당한다. 이때 a항( half 큰팀)을 제외한 모든팀을 순차적으로 돌면서 할당한다. 
'               더이상 할당할 인원이 없는 경우 team을 제거한다. 
'            
'            6. Q가 할당되어 있을 경우 해당 Q의 player와 겹치지 않아야 한다. 
'               - 즉 Q가 포함된 block에서는 중첩체크를 block내 할당 인원 + Q 할당인원 을 가지고 한다. 
'            7. aryPos도 aryPosA / aryPosB로 나누어 관리한다. 
'            
'         참가자 배정 - 9	position block을 구한후 인원을 할당. 
'            1. 할당할 team을 선택후 aryUserA / aryUserB에서 해당 team user를 선택한다. 
'            2. search block에 의하여 할당 가능한 block을 구하면 
'               block size > 4면 block size = 4로 바꾼 다음에 제일 인원수가 적은 block에 인원을 할당한다. 
'       
'   ===============================================================================    
%>

<% 	  
'   ===============================================================================     
'     define variable
'   ===============================================================================   
   Dim E_POS_NORMAL, E_POS_SEED, E_POS_BYE, E_POS_Q   ' pos_kind : position 종류 - normal, seed, bye/Q (Qualification)
   Dim E_TEAMCNT_NONE, E_TEAMCNT_AVROVER, E_TEAMCNT_HALFOVER, E_TEAMCNT_NORMAL   ' Team Count에 따른 종류 - team 배분시 사용
   Dim E_PART_A, E_PART_B, E_PART_ALL
   Dim CON_POSCOL_CNT_S, CON_POSCOL_CNT_D , CON_USERCOL_CNT            '  aryPos - column count, aryUser - column count
   Dim CON_TEAMCOL_CNT                                                 ' aryTeam - column count
   Dim CON_POSVAL_NOUSE, CON_PLAYERCODE_EMPTY, CON_DEF_BLOCKSZ
   Dim CON_QGROUP_USER

   CON_POSCOL_CNT_S        = 9               ' aryPos - 단식 column count
   CON_POSCOL_CNT_D        = 13              ' aryPos - 복식 column count

   CON_USERCOL_CNT         = 14              ' aryUser - column count
   CON_TEAMCOL_CNT         = 7               ' aryTeam - column count

   CON_POSVAL_NOUSE        = -1              ' Position val 사용안함. 
   CON_PLAYERCODE_EMPTY    = "-1"              ' bye/Q (Qualification) Player Code
   CON_DEF_BLOCKSZ         = 4               ' default block size

   CON_QGROUP_USER         = 4               ' Q Group(예선조)는 4명 1조이다. 

   E_POS_NORMAL            = 0               ' 일반 자리 
   E_POS_SEED              = 1               ' Seed 자리 
   E_POS_BYE               = 2               ' Bye 자리 
   E_POS_Q                 = 3               ' 예선전 조 자리 

   E_TEAMCNT_NONE          = -1              ' 팀인원이 없다. 
   E_TEAMCNT_AVROVER       = 11              ' 팀인원이 평균보다 많다. 
   E_TEAMCNT_NORMAL        = 10              ' 팀인원이 평균 이하이다. 
   E_TEAMCNT_HALFOVER      = 9               ' 팀인원이 절반 보다 많다. 

   E_PART_A                = 0               ' A Part
   E_PART_B                = 1               ' B Part
   E_PART_ALL              = 2               ' All part
%>

<% 	  
'   ===============================================================================     
'     util function 
'   ===============================================================================   
'   ===============================================================================     
'      round로 seedPos을 얻는다. 
'   ===============================================================================
	Function exGetArySeedPos(nRound)		
		If(nRound < 4 Or nRound > 256) Then nRound = 4 End If
		
      Dim ary
		Select Case nRound
			Case 4
				ary = gAryR4Seed2
			Case 8
				ary = gAryR8Seed2      
			Case 16
				ary = gAryR16Seed4
			Case 32
				ary = gAryR32Seed8
			Case 64
				ary = gAryR64Seed16
			Case 128
				ary = gAryR128Seed16
			Case 256
				ary = gAryR256Seed16
		End Select
		exGetArySeedPos = ary
	End Function

   Function exGetSeedMax(nRound)
      Dim nMax 
      nMax = 0

      Select Case nRound 
         Case 4, 8
            nMax = 2
         Case 16
            nMax = 4
         Case 32
            nMax = 8
         Case 64, 128, 256
            nMax = 16         
      End Select

      exGetSeedMax = nMax
   End Function 

'   ===============================================================================     
'      Seed Order를 받아서 aryPos에서의 Seed position을 반환한다. 
'   =============================================================================== 
   Function exGetSeedPos(rArySeed, sOrder )
      Dim seedPos, ub, Idx

      Idx = sOrder - 1          ' sOrder (seed값은 1부터 , 배열은 0부터 )
      seedPos = -1
      ub = UBound(rArySeed)  
      If(Idx <=  ub) Then seedPos = rArySeed(Idx)-1 End If  ' seed data의 값으 1부터 , 실질적인 aryPos은 0 부터 
   
      exGetSeedPos = seedPos
   End Function 

'   ===============================================================================     
'      토너먼트 Round를 입력받아 Search Block 단위를 계산한다. 
'      tRound에 적절한 search Block을 반환한다. 
'   =============================================================================== 
   Function exCalcSearchBlock(nRound)
      Dim nBlock

      Select Case nRound 
         Case 2
				nBlock = 2
			Case 4,8
				nBlock = 4
         Case 16,32	
				nBlock = 8
			Case 64
				nBlock = 16
			Case 128
				nBlock = 32
			Case 256
				nBlock = 64
		End Select

      exCalcSearchBlock = nBlock
   End Function 

'   ===============================================================================     
'      참여인원, Round를 입력받아 cntBye를 계산한다. 
'      cntBye = nRound - nUser
'   ===============================================================================   
   Function exCalByeCnt(nUser, nRound)
      Dim cntBye
      
      If(nUser>nRound) Then 
         cntBye = 0
      Else 
         cntBye = nRound - nUser
      End If 

      exCalByeCnt = cntBye
   End Function 

'   ===============================================================================     
'     인원수로 ByePos을 얻는다. 
'     Bye position이 인원수 별로 정해져 있다. 그 array를 얻는다.  
'   ===============================================================================
	Function exGetAryBye(nUser)
      Dim nCnt       

		nCnt = nUser - 1 
		If(nCnt < 1 Or nCnt > 255) Then nCnt = 0 End If
		exGetAryBye = gAryByePos(nCnt)
	End Function

'   ===============================================================================     
'      Bye(Empty Seed) array에서 nPos값을 입력받아 Bye Position 인지 유무를 판단한다. 
'      rAryBye(0) = cntBye
'   ===============================================================================
	Function exIsByePos(rAryBye, nPos)
		Dim Idx, ub, isBye

		isBye = 0
		ub = UBound(rAryBye)  

		For Idx = 1 To ub
			If(rAryBye(Idx) = nPos) Then 
				isBye = 1
				Exit For
			End If
		Next

		duxIsByePos = isBye
	End Function

'   ===============================================================================     
'    round당 QGroup(예선조) 최대 Count를 구한다. 
'   ===============================================================================
   Function exGetMaxQGroupCnt(nRound)
      Dim QMax 

      QMax = nRound / CON_QGROUP_USER
      exGetMaxQGroupCnt = QMax
   End Function 


'   ===============================================================================     
'      QGroup(예선조) Count를 구한다. 
'     nCnt = cntUser - nRound 
'     If(nCnt <= 0) QCnt = 0 Else QCnt = Fix(nCnt / 3)
'     If(QCnt > 0 && QCnt Mod 3 <>0 )  QCnt = QCnt + 1
'   ===============================================================================
   Function exGetQGroupCnt(nUser, nRound)
      Dim nDiff, QCnt
      
      nDiff = nUser - nRound

'      strLog = sprintf("In exGetQGroupCnt nUser = {0}, nRound = {1}, nDiff = {2}, QCnt = {3}, QMod = {4}<br>", Array(nUser, nRound, nDiff, (nDiff/3), (nDiff Mod 3) ))
'      response.write strLog 

      If(nDiff <= 0) Then 
         QCnt = 0
      Else 
         QCnt = Fix(nDiff / 3)
         If(nDiff Mod 3 <> 0) Then QCnt = QCnt + 1 End If 
      End If 

      exGetQGroupCnt = QCnt
   End Function 
   
'   ===============================================================================     
'      Tournament User Cnt를 구한다. 
'     복식일 경우 retVal * 2를 해 줘야 한다. 
'   ===============================================================================
   Function exGetTourUserCnt(nUser, nRound)
      Dim QCnt , nTourUser

      QCnt = exGetQGroupCnt(nUser, nRound)      
      nTourUser = nRound - QCnt
      
      If(QCnt = 0) Then nTourUser = nUser
      exGetTourUserCnt = nTourUser
   End Function 

'   ===============================================================================     
'      Q User Cnt를 구한다. 
'     복식일 경우 retVal * 2를 해 줘야 한다. 
'   ===============================================================================
   Function exGetQUserCnt(nUser, nRound)
      Dim nTourUser, nQUser
   
      nTourUser = exGetTourUserCnt(nUser, nRound)     
      nQUser = nUser - nTourUser

      exGetQUserCnt = nQUser      
   End Function 

'   ===============================================================================     
'      nRound를 입력받아 Position Array를 반환한다. 
'   ===============================================================================
   Function exGetPosArray(nRound, IsDblGame)
      Dim ary, nCol, Idx, ub 
      
      nCol = CON_POSCOL_CNT_S
      If(IsDblGame = 1) Then nCol = CON_POSCOL_CNT_D End If
      
      ReDim ary(nCol-1, nRound-1)      
      ub = UBound(ary, 2)

      For Idx = 0 To ub
         ary(0, Idx) = 0
         ary(1, Idx) = 0
         ary(2, Idx) = 0
         ary(3, Idx) = CON_POSVAL_NOUSE
         ary(4, Idx) = CON_PLAYERCODE_EMPTY
      Next

      exGetPosArray = ary
   End Function 

'   ===============================================================================     
'      QGropuCnt를 입력받아 Q Array를 반환한다. 
'      예선조는 기본 4명으로 구성된다. 
'   ===============================================================================
   Function exGetQPosArray(nQGroup, IsDblGame)
      Dim ary, nRow, nCol

      nRow = nQGroup * CON_QGROUP_USER
      nCol = CON_POSCOL_CNT_S

      If(IsDblGame = 1) Then nCol = CON_POSCOL_CNT_D End If
      
      ReDim ary(nCol-1, nRow-1)
      
      exGetQPosArray = ary
   End Function 

'   ===============================================================================     
'      인원수를 입력받아 aryQPos에 Bye를 셋팅한다. 
'   ===============================================================================
   Function exSetByeInAryQPos(rAryPos, nQUser)
      Dim szBlock

      szBlock = 4
      If(nQUser <= 4) Then 
         Call exSetByeInQBlock(rAryPos, 0, nQUser)
      ElseIf(nQUser <= 8) Then 
         If(nQUser = 7) Then                           ' QCnt = 7 이면 Q1 = 3, Q2 = 4         
            Call exSetByeInQBlock(rAryPos, 0, 3)
         ElseIf(nQUser = 6) Then                       ' QCnt = 6 이면 Q1 = 3, Q2 = 3
            Call exSetByeInQBlock(rAryPos, 0, 3)
            Call exSetByeInQBlock(rAryPos, szBlock, 3)
         ElseIf(nQUser = 5) Then                       ' QCnt = 5 이면 Q1 = 2, Q2 = 3
            Call exSetByeInQBlock(rAryPos, 0, 2)
            Call exSetByeInQBlock(rAryPos, szBlock, 3)
         End If
      ElseIf(nQUser <= 12) Then 
         If(nQUser = 11) Then                          ' QCnt = 11 이면 Q1 = 3, Q2 = 4, Q3 = 4
            Call exSetByeInQBlock(rAryPos, 0, 3)
         ElseIf(nQUser = 10) Then                      ' QCnt = 10 이면 Q1 = 3, Q2 = 3, Q3 = 4
            Call exSetByeInQBlock(rAryPos, 0, 3)
            Call exSetByeInQBlock(rAryPos, szBlock, 3)
         ElseIf(nQUser = 9) Then                       ' QCnt = 9 이면 Q1 = 3, Q2 = 3, Q3 = 3
            Call exSetByeInQBlock(rAryPos, 0, 3)
            Call exSetByeInQBlock(rAryPos, szBlock, 3)
            Call exSetByeInQBlock(rAryPos, 2*szBlock, 3)
         End If
      Else 
         If(nQMod = 3) Then                                    ' QCnt Mod 4 = 3 이면  Q1 = 3
            Call exSetByeInQBlock(rAryPos, 0, 3)
         ElseIf(nQMod = 2) Then                                ' QCnt Mod 4 = 2 이면  Q1 = 3, Q2 = 3
            Call exSetByeInQBlock(rAryPos, 0, 3)
            Call exSetByeInQBlock(rAryPos, szBlock, 3)
         ElseIf(nQMod = 1) Then                                ' QCnt Mod 4 = 1 이면  Q1 = 3, Q2 = 3, Q3= 3
            Call exSetByeInQBlock(rAryPos, 0, 3)
            Call exSetByeInQBlock(rAryPos, szBlock, 3)
            Call exSetByeInQBlock(rAryPos, (2)*szBlock, 3)
         End If
      End If 
   End Function 

'   ===============================================================================     
'      rAryPos에 sp로부터 bye position을 셋팅한다. nUser에 따라
'      sp: start pos
'   ===============================================================================

   Function exSetByeInQBlock(rAryPos, sp, nUser)
      If(nUser = 1) Then               ' data: 1 / bye: 2, 3, 4
         rAryPos(2, sp+1) = E_POS_BYE
         rAryPos(2, sp+2) = E_POS_BYE
         rAryPos(2, sp+3) = E_POS_BYE
      ElseIf(nUser = 2) Then           ' data: 1, 4 / bye: 2, 3
         rAryPos(2, sp+1) = E_POS_BYE         
         rAryPos(2, sp+2) = E_POS_BYE

      ElseIf(nUser = 3) Then           ' data: 1, 3, 4 / bye: 2
         rAryPos(2, sp+1) = E_POS_BYE
      End If 
   End Function 

'   ===============================================================================     
'      aryPos배열을 2개로 나눈다. 
'   ===============================================================================
   Function exDivAryPos(rAryPos, nPart)
      Dim Idx, ub, ary, sPos, ePos, nCol, nHalf, m
      ub = UBound(rAryPos, 2)
      nCol = UBound(rAryPos, 1)
      nHalf = ((ub+1) / 2) 

      If(nPart = E_PART_A) Then 
         sPos = 0
         ePos = nHalf -1
      Else 
         sPos = nHalf
         ePos = ub
      End If 

      ReDim ary( nCol, nHalf-1 )

      For Idx = sPos To ePos
         For k = 0 To nCol
            m = Idx-sPos
            ary(k, m) = rAryPos(k, Idx)
         Next
      Next

      exDivAryPos = ary 
   End Function 

'   ===============================================================================     
'      aryPos배열에 aryPosA, aryPosB를 merge한다. 
'   ===============================================================================
   Function exMergeAryPos(rAryPos, rAryPart, nPart)
      Dim Idx, ub, ary, sPos, ePos, nCol, nHalf, m
      ub = UBound(rAryPos, 2)
      nCol = UBound(rAryPos, 1)
      nHalf = ((ub+1) / 2) 

      If(nPart = E_PART_A) Then 
         sPos = 0
         ePos = nHalf -1
      Else 
         sPos = nHalf
         ePos = ub
      End If 

      For Idx = sPos To ePos
         For k = 0 To nCol
            m = Idx-sPos            
            rAryPos(k, Idx) = rAryPart(k, m)
         Next
      Next
   End Function 
%>

<% 	  
'   ===============================================================================     
'     algorithm function 
'   ===============================================================================   

'   ===============================================================================     
'      aryReq로 부터 aryUser, aryQUser를 추출한다. 
'      1. aryReq로 부터 aryTeam을 생성한다. 
'      2. nUser, nQUser, nTour를 계산한다. 
'      3. aryReq에서 Seed를 찾아 aryReq에 배분한다. 
'      4. aryTeam을 차례로 돌면서 nTour만큼 Player를 aryUser에 배분한다. 
'      5. Seed가 있을 경우 SeedCnt만큼 할당하지 않는다. ( 먼저 배분하였기 때문 )
'      6. aryUser에 배분이 끝났으면, nQUser만큼 aryQUser에 할당한다. 
'   ===============================================================================  
   Function exExtractAryUser(rAryReq, rAryTUser, rAryQUser, nQGroup, nRound, IsDblGame)
      Dim Idx, ub, nUser, nQUser, nTour, nCnt
      Dim aryTeam, userCnt 
      Dim teamOrder, LoopCnt1, LoopCnt2, userIdx, userIdx2, tIdx

      strLog = sprintf("nUser = {0}, nRound = {1}, IsDblGame = {2}", Array(nUser, nRound, IsDblGame))
      Call TraceLog(SAMALL_LOG1, strLog)

      ' 복식일 경우는 따로 연산한다. 
      If(IsDblGame = 1) Then
         Call exExtractAryUserDbl(rAryReq, rAryTUser, rAryQUser, nQGroup, nRound, IsDblGame)
         Exit Function 
      End If 

      ub    = UBound(rAryReq, 2)
      nUser = ub + 1
      nCnt = nUser

      ' exGetTourUserCnt 단식으로 계산한 결과를 올리므로 복식이면 *2를 한다. 
      nTour = exGetTourUserCnt(nCnt, nRound)
      nQUser = nUser - nTour 

      strLog = sprintf("nUser = {0}, nQUser = {1}, nTour = {2}, nRound = {3}, IsDblGame = {4}", Array(nUser, nQUser, nTour, nRound, IsDblGame))
      Call TraceLog(SAMALL_LOG1, strLog)

      ' ary Tournament User, ary Qualifier User Redefine 
      ReDim rAryTUser(CON_USERCOL_CNT-1, nTour-1)
      ReDim rAryQUser(CON_USERCOL_CNT-1, nQUser-1)

      aryTeam = exCreateTeamInfo(rAryReq)
      Call TraceLogInfo(aryTeam, " team info " )

      ' seed를 aryTUser에 배분한다. 
      userCnt = 0
      For Idx = 0 To ub 
         If(rAryReq(2, Idx) <> 0) Then 
            rAryReq(0, Idx) = 1
            Call CopyRows(rAryReq, rAryTUser, Idx, userCnt)
            userCnt = userCnt + 1
         End If 
      Next

      Call TraceLogInfo(rAryTUser, " aryTUser seed apply " )
      
      ' user를 nTour만큼 aryTUser에 배분, 나머지는 rAryQUser에 배분 한다.   
      teamOrder   = 0
      LoopCnt1    = 0 
      LoopCnt2    = 0

      strLog = sprintf("userCnt = {0} nUser = {1}", Array(userCnt, nUser))
      Call TraceLog(SAMALL_LOG1, strLog)

      While(nUser > userCnt) 
         userIdx = -1

         While(userIdx = -1)            
            teamOrder = exGetTeamCodeForUserAssign(aryTeam, IsDblGame)            
            If(teamOrder = -1) Then 
               Call exResetTeamfUse(aryTeam)
               teamOrder = exGetTeamCodeForUserAssign(aryTeam, IsDblGame)
            End If 

            userIdx = exGetUserForUserAssign(rAryReq, teamOrder)
        
            If(userIdx = -1) Then 
               Call exDelTeamInfo(aryTeam, teamOrder)
            End If 

            LoopCnt2 = LoopCnt2 + 1
            If(LoopCnt2 > 100) Then 
               Exit Function 
            End If 
         WEnd 

         If(userCnt < nTour) Then 
            tIdx = userCnt

            rAryReq(0, userIdx) = 1
            Call CopyRows(rAryReq, rAryTUser, userIdx, tIdx)
            userCnt = userCnt + 1
         Else 
            tIdx = userCnt-nTour

            rAryReq(0, userIdx) = 1
            Call CopyRows(rAryReq, rAryQUser, userIdx, tIdx)
            userCnt = userCnt + 1
         End If 
         LoopCnt1 = LoopCnt1 + 1

         If(LoopCnt1 > 1000) Then 
            userCnt = nUser + 1
         End If 
      WEnd 

      Call TraceLogInfo(rAryTUser, " aryTUser assign " )
      Call TraceLogInfo(rAryQUser, " rAryQUser assign " )
   End Function 

   Function exExtractAryUserDbl(rAryReq, rAryTUser, rAryQUser, nQGroup, nRound, IsDblGame)
      Dim Idx, ub, nUser, nQUser, nTour, nCnt
      Dim aryTeam, userCnt 
      Dim teamOrder, LoopCnt1, LoopCnt2, userIdx, userIdx2, tIdx

      ub    = UBound(rAryReq, 2)
      nUser = ub + 1
      nCnt = nUser / 2

      ' exGetTourUserCnt 단식으로 계산한 결과를 올리므로 복식이면 *2를 한다. 
      nTour = exGetTourUserCnt(nCnt, nRound)
      nTour = nTour * 2
      nQUser = nUser - nTour 

      strLog = sprintf("nUser = {0}, nQUser = {1}, nTour = {2}, nRound = {3}, IsDblGame = {4}", Array(nUser, nQUser, nTour, nRound, IsDblGame))
      Call TraceLog(SAMALL_LOG1, strLog)

      ' ary Tournament User, ary Qualifier User Redefine 
      ReDim rAryTUser(CON_USERCOL_CNT-1, nTour-1)
      ReDim rAryQUser(CON_USERCOL_CNT-1, nQUser-1)

      aryTeam = exCreateTeamInfo(rAryReq)
      Call TraceLogInfo(aryTeam, " team info " )

      ' seed를 aryTUser에 배분한다. 
      userCnt = 0
      For Idx = 0 To ub step 2
         If(rAryReq(2, Idx) <> 0) Then 
            If(Idx Mod 2 = 1) Then 
               userIdx2 = Idx - 1 
            Else 
               userIdx2 = Idx + 1
            End If 

            rAryReq(0, Idx) = 1
            Call CopyRows(rAryReq, rAryTUser, Idx, userCnt)

            rAryReq(0, userIdx2) = 1
            Call CopyRows(rAryReq, rAryTUser, userIdx2, userCnt+1)
            userCnt = userCnt + 2
         End If 
      Next

      Call TraceLogInfo(rAryTUser, " aryTUser seed apply " )
      
      ' user를 nTour만큼 aryTUser에 배분, 나머지는 rAryQUser에 배분 한다.   
      teamOrder   = 0
      LoopCnt1    = 0 
      LoopCnt2    = 0

      strLog = sprintf("userCnt = {0} nUser = {1}", Array(userCnt, nUser))
      Call TraceLog(SAMALL_LOG1, strLog)

      While(nUser > userCnt) 
         userIdx = -1

         While(userIdx = -1)            
            teamOrder = exGetTeamCodeForUserAssign(aryTeam, IsDblGame)            
            If(teamOrder = -1) Then 
               Call exResetTeamfUse(aryTeam)
               teamOrder = exGetTeamCodeForUserAssign(aryTeam, IsDblGame)
            End If 

            userIdx = exGetUserForUserAssign(rAryReq, teamOrder)
        
            If(userIdx = -1) Then 
               Call exDelTeamInfo(aryTeam, teamOrder)
            End If 

            LoopCnt2 = LoopCnt2 + 1
            If(LoopCnt2 > 100) Then 
               Exit Function 
            End If 
         WEnd 

         If(Idx Mod 2 = 1) Then 
            userIdx2 = userIdx - 1 
         Else 
            userIdx2 = userIdx + 1
         End If

         If(userCnt < nTour) Then 
            tIdx = userCnt

            rAryReq(0, userIdx) = 1
            Call CopyRows(rAryReq, rAryTUser, userIdx, tIdx)

            rAryReq(0, userIdx2) = 1
            Call CopyRows(rAryReq, rAryTUser, userIdx2, tIdx+1)
            userCnt = userCnt + 2
            
         Else 
            tIdx = userCnt-nTour

            rAryReq(0, userIdx) = 1
            Call CopyRows(rAryReq, rAryQUser, userIdx, tIdx)

            rAryReq(0, userIdx2) = 1
            Call CopyRows(rAryReq, rAryQUser, userIdx2, tIdx+1)

            userCnt = userCnt + 2
         End If 
         LoopCnt1 = LoopCnt1 + 1

         If(LoopCnt1 > 1000) Then 
            userCnt = nUser + 1
         End If 
      WEnd 

      Call TraceLogInfo(rAryTUser, " aryTUser assign " )
      Call TraceLogInfo(rAryQUser, " rAryQUser assign " )      
   End Function 

'   ===============================================================================     
'     Team을 순서대로 얻는다. 
'   ===============================================================================  
   Function exGetTeamCodeForUserAssign(rAryTeam, IsDblGame)
      Dim Idx, ub, retCode, nMinus
      retCode = -1
      nMinus = 1
      If(IsDblGame = 1) Then nMinus = 2 End If     ' 복식이면 Seed를 2개씩 지운다. 

      ub = UBound(rAryTeam, 2)

      For Idx = 0 To ub
         If(rAryTeam(0,Idx) = 0) Then 
            rAryTeam(0,Idx) = 1

            If(rAryTeam(5, Idx) <> 0) Then             ' seed가 있으면 seed count를 1개 줄여 준다. (이미 할당했다.) 
               rAryTeam(5, Idx) = rAryTeam(5, Idx) - nMinus
            Else 
               retCode = rAryTeam(2, Idx)
               Exit For
            End If 
         End If 
      Next

      exGetTeamCodeForUserAssign = retCode
   End Function 

'   ===============================================================================     
'     User를 순서대로 얻는다. 
'   ===============================================================================  
   Function exGetUserForUserAssign(rAryReq, teamOrder)
      Dim Idx, ub, retCode
      retCode = -1

      ub = UBound(rAryReq, 2)

      For Idx = 0 To ub
         If(rAryReq(1,Idx) = teamOrder) And (rAryReq(0,Idx) = 0) Then 
            rAryReq(0,Idx) = 1
            retCode = Idx
            Exit For
         End If 
      Next

      exGetUserForUserAssign = retCode
   End Function 



'   ===============================================================================     
'     Qualifier를 할당한다. 
'        1. nSeedA , nSeedB를 구한다. 
'        2. nSeedCnt = nSeedA + nSeedB 
'        3. nTotal = nSeedCnt + nQGroup를 구한다. 
'        4. QMaxGroup과 Total을 비교한다. 
'        5. Seed와 겹치지 않는 부분에 Q를 할당한다. 
'        6. Q할당이 끝난후 If( nQGroup > (nQOrder-1) ) Then         ' Q와 Seed가 겹치는 부분이 남았다. 
'        7. Q를 Seed가 있는 Block에 할당한다. 
'   ===============================================================================  
   Function exSetQualifierToPos(rAryPos, nQGroup, nQMaxGroup)      
      Dim nSeedCnt, nSeedA, nSeedB, nSeedDiff      ' Seed Count 관련 변수 
      Dim nTotal, nRemain , nLoopMax, tmpA, tmpB  
      Dim nQOrder, Idx , IsDupSeed

      nQOrder = 1
      nLoopMax = 100

      ' Seed Count를 구한다. 
      nSeedA = exGetSeedCnt(rAryPos, E_PART_A)
      nSeedB = exGetSeedCnt(rAryPos, E_PART_B)
      nSeedCnt = nSeedA + nSeedB 
      nSeedDiff = Abs(nSeedA - nSeedB)

      ' Q Count를 구한다. 
      IsDupSeed = 0
      tmpA = nSeedA
      tmpB = nSeedB 
      For Idx = 0 To nQMaxGroup-1     ' Q와 Seed는 겹치지 않는다. Q를 갯수만큼 Random하게 배치한다. 
         If(Idx Mod 2 = 0) Then 
            If (tmpA = 0) Then         ' Empty Block에 Q를 할당한다. 
               Call exSetQPos(rAryPos, IsDupSeed, nQOrder, E_PART_A)
               nQOrder = nQOrder + 1
            Else 
               tmpA = tmpA - 1
            End If 
         Else 
            If (tmpB = 0) Then         ' Empty Block에 Q를 할당한다. 
               Call exSetQPos(rAryPos, IsDupSeed, nQOrder, E_PART_B)
               nQOrder = nQOrder + 1
            Else 
               tmpB = tmpB - 1
            End If 
         End If 

         If( nQOrder = nQGroup+1) Then 
            Exit For 
         End If 
      Next

      If( nQGroup > (nQOrder-1) ) Then         ' Q와 Seed가 겹치는 부분이 남았다. 
         IsDupSeed = 1
         nRemain = nQGroup - (nQOrder-1)
        
         While(nRemain > 0)                             
            If(nSeedA <> 0) Then 
               Call exSetQPos(rAryPos, IsDupSeed, nQOrder, E_PART_A)
               nQOrder = nQOrder + 1               
               nSeedA = nSeedA - 1
               nRemain = nRemain - 1

            End If 
            
            If(nSeedB <> 0 And nRemain > 0) Then 
               Call exSetQPos(rAryPos, IsDupSeed, nQOrder, E_PART_B)
               nQOrder = nQOrder + 1
               nSeedB = nSeedB - 1
               nRemain = nRemain - 1
            End If 
            nLoopMax = nLoopMax - 1

            If(nLoopMax = 0) Then 
               nRemain = 0
            End If 
         WEnd 

      End If 

   End Function 
   
'   ===============================================================================     
'     Q를 A part/B part에 배치한다. 
'    If(IsDupSeed = 1) Then  seed가 있는 Block과 같은 block에 Q를 배치한다. 
'    Else seed가 없는 Block에 Q를 배치한다.  
'   ===============================================================================  
   Function exSetQPos(rAryPos, IsDupSeed, nQOrder, nPart)
      Dim ub, Idx, sp, ep , nHalf, nBlockCnt, rNum, spVal , cnt 
      Dim sp1, ep1, posQ
      ub = UBound(rAryPos, 2)
      nHalf = (ub + 1) / 2
      nBlockCnt = 0
      rNum = 0
      cnt  = 0

      If(ub+1 < 4) Then       ' aryPos size < 4이면 Q가 없다. 
         Exit Function 
      End If       
      
      If(nPart = E_PART_A) Then 
         sp = 0
         ep = nHalf - 1
      ElseIf(nPart = E_PART_B) Then 
         sp = nHalf
         ep = ub
      End If  

      If(ub+1 = 4) Then       ' aryPos size = 4이면 block은 1개다. 
         sp = 0
         ep = ub
      End If       
      
      If(IsDupSeed = 1) Then            ' seed가 있는 Block과 같은 block에 Q를 배치한다. 
         spVal = E_POS_SEED 
      Else                          ' Empty block에 Q를 배치한다. 
         spVal = E_POS_NORMAL 
      End If 

      ' Special Val block count를 구한다
      For Idx = sp To ep step CON_DEF_BLOCKSZ         ' Q or Seed 는 4개 pos에 1개 위치할수 있다. 
         sp1 = Idx
         ep1 = sp1 + (CON_DEF_BLOCKSZ-1)
         
         If(exHasOnlyValBlock(rAryPos, sp1, ep1, spVal) = 1) Then nBlockCnt = nBlockCnt + 1 End If 
      Next

      If(nBlockCnt = 1) Then
         rNum = 0
      Else 
         rNum = GetRandomNum(nBlockCnt) - 1
      End If

      ' Q를 해당 Block에 배치한다.   block position 중요도 순 나열 : 1, 4, 3, 2   
      For Idx = sp To ep step CON_DEF_BLOCKSZ         ' Q or Seed 는 4개 pos에 1개 위치할수 있다. 
         sp1 = Idx
         ep1 = sp1 + (CON_DEF_BLOCKSZ-1)
         
         If(exHasOnlyValBlock(rAryPos, sp1, ep1, spVal) = 1) Then 
            If(cnt = rNum) Then 
               If(nPart = E_PART_A) Then              ' A part seed pos = 1, Q pos = 3
                  posQ = sp1 + 2
               ElseIf(nPart = E_PART_B) Then          ' B part seed pos = 4, Q pos = 2
                  posQ = sp1 + 1
               End If 
               rAryPos(2, posQ) = E_POS_Q
               rAryPos(3, posQ) = nQOrder
               Exit Function 
            End If 
            cnt = cnt + 1 
         End If 
      Next
   End Function 

'   ===============================================================================     
'     Q를 A part/B part에 cnt만큼 랜덤하게 적용한다. 
'     1. Seed Block을 제외한 빈 Block 갯수를 구한다. nEmpty
'     2. QCnt가 0이 될때까지 nEmpty를 이용하여 Random하게 배치한다. 
'     3. block의 기본크기는 4이다. 
'   ===============================================================================  
   Function exSetQRanPos(rAryPos, nQCnt, nSeedCnt, nPart)

   End Function 

'   ===============================================================================     
'     Q를 A part/B part에 cnt만큼 적용한다. 
'     Q의 갯수가 빈 Block보다 많아서 seed block과 겹칠수 있다. 
'     1. 빈 Block에 Q를 배치한다. 
'     2. Seed와 겹치는 Q Cntrk 0이 될때까지 nSeedCnt를 이용하여 Random하게 배치한다. 
'     3. block의 기본크기는 4이다. 
'   ===============================================================================  
   Function exSetQDupSeedPos(rAryPos, nQCnt, nSeedCnt, nPart)
      Dim nHalf, ub, Idx         ' Position Count 관련 변수 
      Dim nDupQ                  ' Q Count 관련 변수 

      ub = UBound(rAryPos)      
      nHalf  = ub / 2 

      nDupQA = nHalf - nQA  
   End Function 

'   ===============================================================================     
'     Seed를 할당한다. 
'   ===============================================================================  
   Function exSetSeedToPos(rAryPos, rAryReq, nRound, IsDblGame )
      Dim arySeed, Idx, ub, pos, nSeed, nBase
      nBase = 1

      If(IsDblGame=1) Then nBase = 2

      arySeed = exGetArySeedPos(nRound)	
      ub = UBound(rAryReq, 2)
      ubb = UBound(rAryReq, 1)

      For Idx = 0 To ub Step nBase
         nSeed = rAryReq(2,Idx)
         If(nSeed <> 0) Then  ' Seed가 있다면 aryPos에 Seed를 설정한다. 
            pos = exGetSeedPos(arySeed, nSeed)
            Call exSetSeedData(rAryPos, rAryReq, pos, Idx, IsDblGame)  
         End If 
      Next 
   End Function 

'   ===============================================================================     
'     aryPos에 aryReq로 부터 seeddata를 Setting한다. 
'   ===============================================================================   
   Function exSetSeedData(rAryPos, rAryReq, seedPos, userPos, IsDblGame)
      rAryPos(2,seedPos) = E_POS_SEED                 ' seed 
      rAryPos(3,seedPos) = rAryReq(2,userPos)         ' seed value
      rAryPos(4,seedPos) = rAryReq(6,userPos)         ' playerCode - GroupIdx

      If(IsDblGame = 1) then          
         rAryPos(5,seedPos) = rAryReq(8,userPos)         ' cUser1
         rAryPos(6,seedPos) = rAryReq(9,userPos)         ' user1
         rAryPos(7,seedPos) = rAryReq(8,userPos+1)         ' cUser2
         rAryPos(8,seedPos) = rAryReq(9,userPos+1)         ' user2

         rAryPos(9,seedPos) = rAryReq(10,userPos)         ' cTeam1
         rAryPos(10,seedPos) = rAryReq(11,userPos)        ' team1
         rAryPos(11,seedPos) = rAryReq(10,userPos+1)        ' cTeam2
         rAryPos(12,seedPos) = rAryReq(11,userPos+1)        ' team2
      Else 
         rAryPos(5,seedPos) = rAryReq(8,userPos)         ' cUser
         rAryPos(6,seedPos) = rAryReq(9,userPos)         ' user
         rAryPos(7,seedPos) = rAryReq(10,userPos)         ' cTeam
         rAryPos(8,seedPos) = rAryReq(11,userPos)         ' team
      End If 
   End Function 

'   ===============================================================================     
'     seed Count를 얻는다. 
'   ===============================================================================  
   Function exGetSeedCnt(rAryPos, nPart)      
      Dim Idx, ub, nCntSeed, sPos, ePos, nHalf
      ub = UBound(rAryPos, 2)
      nHalf = ((ub+1) / 2) 
      nCntSeed = 0

      If(nPart = E_PART_A) Then 
         sPos = 0
         ePos = nHalf -1
      ElseIf(nPart = E_PART_B) Then  
         sPos = nHalf
         ePos = ub
      ElseIf(nPart = E_PART_ALL) Then  
         sPos = 0
         ePos = ub
      Else
      End If 

      For Idx = sPos To ePos
         If(rAryPos(2,Idx) = E_POS_SEED) Then nCntSeed = nCntSeed + 1 End If 
      Next

      exGetSeedCnt = nCntSeed
   End Function

'   ===============================================================================     
'     Team Info를 생성한다. 
'   ===============================================================================   
'   Function exCreateTeamInfo(rAryUser)
'      Dim ub, Idx, aryInfo, aryTmp, teamOrder, cnt, tIdx
'      Dim nAve, nHalf, nUser, nTotal, nCntUser
'
'      cnt = 0
'      ub = UBound(rAryUser, 2)
'      nUser = ub + 1 
'      ReDim aryTmp(CON_TEAMCOL_CNT-1, ub)
'
'       For Idx = 0 To ub 
'         teamOrder = rAryUser(1, Idx)
'      Next 
'      
'
'      ' 실제 unique team 구하기 
'      For Idx = 0 To ub 
'         teamOrder = CDbl(rAryUser(1, Idx))
'         tIdx = exCheckTeamInfo(aryTmp, teamOrder)
'         If( tIdx = -1 ) Then 
'            aryTmp(0, cnt) = 1                                             ' fUse
'            aryTmp(2, cnt) = teamOrder    
'            cnt = cnt + 1
'         End If 
'      Next 
'
'      ReDim aryInfo(CON_TEAMCOL_CNT-1, cnt-1)
'      ub = cnt - 1
'      nAve = Fix(nUser / cnt)
'      nHalf = Fix(nUser / 2)
'
'      strLog = sprintf("teamCnt = {0}, nAve = {1}, nHalf = {2}", _
'                  Array(cnt, nAve, nHalf))         
'         Call TraceLog(SAMALL_LOG1, strLog)
'
'      For Idx = 0 To ub 
'         aryInfo(0, Idx) = 0                                           ' fUse
'         aryInfo(2, Idx) = aryTmp(2, Idx)                              ' teamOrder
'         aryInfo(3, Idx) = aryTmp(3, Idx)                              ' cTeam
'         aryInfo(4, Idx) = aryTmp(4, Idx)                              ' team
'         aryInfo(5, Idx) = aryTmp(5, Idx)                              ' seedCnt
'         aryInfo(6, Idx) = aryTmp(6, Idx)                              ' userCnt
'
'         nCntUser = aryInfo(6, Idx)
'         nTotal = nTotal + nCntUser
'
'         If(nCntUser > nHalf) Then 
'            aryInfo(1, Idx) = E_TEAMCNT_HALFOVER
'         ElseIf(nCntUser > nAve) Then 
'            aryInfo(1, Idx) = E_TEAMCNT_AVROVER
'         Else
'            aryInfo(1, Idx) = E_TEAMCNT_NORMAL
'         End If 
'      Next 
'
'      exCreateTeamInfo = aryInfo
'   End Function 

   Function exCreateTeamInfo(rAryUser)
      Dim ub, Idx, aryInfo, aryTmp, teamOrder, cnt, tIdx
      Dim nAve, nHalf, nUser, nTotal, nCntUser

      cnt = 0
      ub = UBound(rAryUser, 2)
      nUser = ub + 1 
      ReDim aryTmp(CON_TEAMCOL_CNT-1, ub)

      ' 실제 unique team 구하기 
      For Idx = 0 To ub 
         teamOrder = rAryUser(1, Idx)
         tIdx = exCheckTeamInfo(aryTmp, teamOrder)
         If( tIdx = -1 ) Then 
            aryTmp(0, cnt) = 1                                             ' fUse
            aryTmp(2, cnt) = teamOrder                                     ' teamOrder
            aryTmp(3, cnt) = rAryUser(10, Idx)                             ' cTeam
            aryTmp(4, cnt) = rAryUser(11, Idx)                             ' team
            aryTmp(5, cnt) = 0
            aryTmp(6, cnt) = 1                                             ' userCnt
            If( rAryUser(2, Idx) <> 0 ) Then aryTmp(5, cnt) = 1 End If     ' seedCnt

            cnt = cnt + 1
         Else 
            aryTmp(6, tIdx) = aryTmp(6, tIdx) + 1        ' userCnt
            If( rAryUser(2, Idx) <> 0 ) Then             ' seedCnt
               aryTmp(5, tIdx) = aryTmp(5, tIdx) + 1 
            End If     
         End If 
      Next 

      ReDim aryInfo(CON_TEAMCOL_CNT-1, cnt-1)
      ub = cnt - 1
      nAve = Fix(nUser / cnt)
      nHalf = Fix(nUser / 2)

      For Idx = 0 To ub 
         aryInfo(0, Idx) = 0                                           ' fUse
         aryInfo(2, Idx) = aryTmp(2, Idx)                              ' teamOrder
         aryInfo(3, Idx) = aryTmp(3, Idx)                              ' cTeam
         aryInfo(4, Idx) = aryTmp(4, Idx)                              ' team
         aryInfo(5, Idx) = aryTmp(5, Idx)                              ' seedCnt
         aryInfo(6, Idx) = aryTmp(6, Idx)                              ' userCnt

         nCntUser = aryInfo(6, Idx)
         nTotal = nTotal + nCntUser

         If(nCntUser > nHalf) Then 
            aryInfo(1, Idx) = E_TEAMCNT_HALFOVER
         ElseIf(nCntUser > nAve) Then 
            aryInfo(1, Idx) = E_TEAMCNT_AVROVER
         Else
            aryInfo(1, Idx) = E_TEAMCNT_NORMAL
         End If 
      Next 

      exCreateTeamInfo = aryInfo
   End Function 

'   ===============================================================================     
'     Team Order를 입력받아 동일한 Team인지 Check한다. 
'   ===============================================================================   
   Function exCheckTeamInfo(rAryTeam, teamOrder)
      Dim ub, Idx, ret

      ret = -1
      ub = UBound(rAryTeam, 2)

      For Idx = 0 To ub         

         If(rAryTeam(0, Idx) <> 1) Then            ' data의 제일 마지막에 왔다. 
            Exit For
         End If 

         If(rAryTeam(2, Idx) = teamOrder) Then     ' team order가 일치한다. 
            ret = Idx 
            Exit For
         End If 
      Next 
      exCheckTeamInfo = ret
   End Function 

'   ===============================================================================     
'      aryTeam : Reset fUse
'      aryTeam(0,Idx) = -1 삭제 flag
'   ===============================================================================
   Function exResetTeamfUse(rAryTeam)
      Dim Idx, ub
      
      ub = UBound(rAryTeam, 2)

      For Idx = 0 To ub 
         If(rAryTeam(0, Idx) <> -1) Then rAryTeam(0, Idx) = 0 End If 
      Next
   End Function 

'   ===============================================================================     
'      aryTeam : Remove Team 
'      Redim 을 해야 하나 refrence로 물고 있으면 적용이 안되어 부득이 -1로 Del flag를 세웠다. 
'      삭제할 pos을 기점으로 배열을 한칸씩 당기고 제일 마지막 값에 Del flag를 세운다. 
'   ===============================================================================
   Function exDelTeamInfo(rAryTeam, teamOrder)
      Dim Idx, ub, k 

      ub = UBound(rAryTeam, 2)

      For Idx = 0 To ub
         If(rAryTeam(2,Idx) = teamOrder) Then 
            For k = Idx To ub-1               '      삭제할 pos을 기점으로 배열을 한칸씩 당기고 제일 마지막 값에 Del flag를 세운다. 
					rAryTeam(0, k) = rAryTeam(0, k+1)
					rAryTeam(1, k) = rAryTeam(1, k+1)
               rAryTeam(2, k) = rAryTeam(2, k+1)
					rAryTeam(3, k) = rAryTeam(3, k+1)
               rAryTeam(4, k) = rAryTeam(4, k+1)
					rAryTeam(5, k) = rAryTeam(5, k+1)
               rAryTeam(6, k) = rAryTeam(6, k+1)					
				Next
				rAryTeam(0, k) = -1
				Exit For 
         End If 
      Next 
   End Function 
%>

<% 	  
'   ===============================================================================     
'     Sub Function 
'   ===============================================================================   


'   ===============================================================================     
'     해당 block안에 요구하는 data만 존재 있는가? E_POS_NORMAL, E_POS_SEED, E_POS_BYE, E_POS_Q
'   ===============================================================================   
   Function exHasOnlyValBlock(rAryPos, spos, epos, blockVal)
      Dim Idx , ret      

      If (blockVal = E_POS_NORMAL) Then 
         ret = exIsEmptyBlock(rAryPos, spos, epos)
         exHasOnlyValBlock = ret 
         Exit Function 
      End If 

      ret = 1
      For Idx = spos To epos 

         If( rAryPos(2, Idx) <> blockVal And rAryPos(2, Idx) <> E_POS_NORMAL ) Then 
            ret = 0            
            Exit For 
         End If 
      Next

      exHasOnlyValBlock = ret 
   End Function    


'   ===============================================================================     
'     해당 block이 비어 있는가?
'   ===============================================================================   
   Function exIsEmptyBlock(rAryPos, spos, epos)
      Dim Idx , ret      
      ret = 1

      For Idx = spos To epos 
         If( rAryPos(2, Idx) <> E_POS_NORMAL ) Then 
            ret = 0
            Exit For 
         End If 
      Next 

      exIsEmptyBlock = ret 
   End Function    
%>

