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
'      pos_kind : position 종류 - normal, seed, bye/Q (Qualification), firstMan ( 1장) 
'      pos_val   : normal - -1(사용안함) , seed position val (1, 2, 3.. ), bye/Q position val (1, 2, 3)
'
'     복식 : fUse, pos, pos_kind, pos_val, playerCode(gGroupIdx), teamOrder, cUser1, user1, cUser2, user2, cTeam1, team1, cTeam2, team2
'             0,    1 ,   2     ,    3   ,    4                 ,    5  ,      6  ,    7  ,   8  ,    9  ,   10 ,   11  ,   12  ,  13   
'     단식 : fUse, pos, pos_kind, pos_val, playerCode(gGroupIdx), teamOrder, cUser, user, cTeam, team
'              0 ,  1 ,    2    ,    3   ,    4                 ,   5   ,       6 ,   7  ,   8 ,   9
'     ary user - 
'      fUse, teamNo, SeedNo, Ranking, dataOrder, PlayerOrder, GameRequestGroupIDX, GameRequestPlayerIDX, MemberIDX, MemberName, Team, TeamName, PrevTeam, PrevTeamName
'        0 ,   1   ,   2   ,    3   ,    4     ,     5      ,        6           ,      7              ,    8     ,      9    ,   10,   11    ,    12    ,   13             
'      fUse : user 할당 유무 
'      seed : seed Number
'
'     ary Team Info 
'        fUse, teamKind, teamOrder, cTeam, team, seedCnt, userCnt
'          0 ,   1     ,     2    ,   3  ,   4 ,   5    ,    6
'   ===============================================================================   

'   ===============================================================================   
'        Function parameter description 
' 
'           IsDblGame : 복식 게임인가? 
'   ===============================================================================   
%>

<% 	  
'   ===============================================================================     
' 		공통	일단 본선을 4 Part로 나눈다.  (A, B, C, D)     - (Round / 2) / 2
' 			만약 예선이 있다면 본선인원, 예선 인원을 구한후 , 
' 			본선인원 = 본선인원
' 			예선인원 = 전체 - 본선인원
' 			이유 : 데이터가 각 팀의 1장, 2장 , 3 장 순으로 / 그리고 각각은 다시 등록 순으로 정렬되어 있다. 
' 			          따라서 처음부터 특정 위치 까지 데이터를 자르면 거기 까지가 각 팀의 상위 선수가 들어간다. 
' 			
' 			전체인원수 : nTotal , 토너먼트 인원수 : nRound, 본선인원수 : nUser, 예선인원수 : nQ, Bye 수 : nBye
' 			
' 			nQ 와 nBye는 동시에 발생하지 않는다. 
' 			If( nTotal > nRound) nQ가 존재          : 전체 인원이 Tournament보다 많으면 예선조가 있다. 
' 			    nBye = nRound - nTotal 
' 			    nQ = 0
' 			    nUser = nTotal
' 			
' 			If( nTotal < nRound) nBye가 존재      : 전체 인원이 Tournament보다 작으면 Bye가 있다. 
' 			    nQ = (nTotal - nRound)  / 3 과 비슷한 공식 존재 - 소스 참조 
' 			    nUser = nTotal - nQ
' 			
' 			Q의 최대 갯수는 nRound / 4개 이다. 
' 			
' 		시드배치	제일 먼저 시드를 배치한다. 
' 			1. 1,2위 위치는 고정 
' 			2. 3/4 위치는 그 안에서 랜덤
' 			3. 5/8위치는 그 안에서 랜덤
' 			4. 9/16위치는 그 안에서 랜덤. 
' 			5. 시드 위치 랜덤은 현재 설정된 Seed갯수 안에서 위의 1,2,3,4룰을 적용한다. 
' 			6. 2,3,4 룰에서 팀이 겹칠 경우 해당 팀끼리 랜덤으로 위치 선정, 나머지 끼리 랜덤으로 위치 선정한다. 
' 			
' 		Bye 배치	
' 			1. Bye는 nRound에 따라 그 갯수만큼 특정 자리가 정해져 있다. 
' 			
' 		binary search 	
' 		본선 Q 배치 	Q의 갯수에 따라 A, B, C, D Part에 순차적으로 랜덤하게 배치한다. 
' 			각 파트에서 할당된 Q를 Binary Search 방식으로 배치한다 .
' 			1. 해당 Part를 전체로 잡고 half로 나눈다. (A1, B1 Part)
' 			2. 각각의 Block에서 Q의 갯수를 구한다. 
' 			3. Q의 갯수가 적은 쪽을 선택한다. 
' 			4. Q의 갯수가 0이 나올때 까지 1, 2, 3을 반복한다. 
' 			5. 최소 Block size는 4이고 Q의 갯수가 최대여도 szBlock = 4일 경우 겹치지 않는다. 
' 			    즉 Q는 모두 배치 할때까지 Q Count가 0인 block이 존재한다. 
' 			
' 		본선 배치	본선은 토너먼트를 4개로 나눈 A, B, C, D Part로 나눈 후 각각의 Block에서 배치를 진행한다. 
' 			
' 		인원할당	본선 인원을 A, B, C, D 각각의 Block에 거의 균일하게 나눈다. 
' 			1. 이미 선 배치된 Seed를 A, B, C, D 각각의 aryUser에 할당한다. 
' 			        - 인원을 배치할때 시드, 이미 배치된 인원을 검사하여 인원을 할당할 위치를 고려한다. 
' 			2. 각 팀의 1장, 2장, ... 등을 순차적으로 4개의 Part aryUser에 할당한다. 
' 			
' 		인원할당 룰 	1. User를 한명 선택한다. 
' 			2. 선택된 User의 code_team을 추출한다. 
' 			3. A, B, C, D 각 파트에서 code_team과 일치하는 User의 Count를 구한다.    nSameTeam
' 			4. 각 팀에 할당된 user Count를 구한다.    nAssignUser
' 			5. nSameTeam의 값이 제일 적은 팀에 할당한다. 
' 			6. 만약 nSameTeam의 최소값이  2개 이상 겹칠때는 nAssignUser의 갯수가 적은 Part을 선택한다. 
' 			7. nAssignUser의 최소값 마저 2개 이상 겹칠때는 Random하게 배치한다. 
' 			8. 1~7을 반복한다. 
' 			9. 이때 더이상 할당할 공간이 없는 Part가 발생할 경우 , 해당 Part를 제외하고 1~7을 반복한다. 
' 			
' 		인원배치 - aryPos	
' 			4개의 Part에 1장, 2장, 3장 순으로 user가 할당되었다. 
' 			이과정에서 1차적으로 인원의 분산 배치가 이루어 진다. 
' 			
' 			이제 각 Part별로 인원을 1장, 2장 .. 순으로 선택하여 대진표에 배치한다. 
' 			
' 		인원배치 룰 	각 Part에 할당된 User를 Binary Search 방식으로 배치한다. 
' 			1. 인원을 Player Order 순으로 정렬한다. 
' 			2. 인원의 절반을 순차적으로 할당한다. 
' 			3. 1장의 인원이 남아 있으면 1장이 없을때 까지 진행한다. 
' 			4. 인원을 Team Count순으로 정렬한다. 
' 			5. 인원을 순차적으로 할당한다. 
' 			
' 			1. User를 한명 선택한다.
' 			2. 선택된 User의 code_team을 추출한다.
' 			3. 해당 Part를 전체로 잡고 half로 나눈다. (A1, B1 Part)
' 			4. 각각의 Block에서 code_team과 일치하는 User의 Count를 구한다.    nSameTeam
' 			5. 각 Block에 할당된 user Count를 구한다.    nAssignUser
' 			6. nSameTeam의 값이 제일 적은 팀에 할당한다. 
' 			7. 만약 nSameTeam의 최소값이  2개 이상 겹칠때는 nAssignUser의 갯수가 적은 Part을 선택한다. 
' 			8. nAssignUser의 최소값 마저 2개 이상 겹칠때는 Random하게 배치한다. 
' 			9. nBlock Size = 4 가 될때까지 1~8을 반복한다. 
' 			10. nBlock Size = 4 인데 nSameTeam == 0인 Block을 찾았으면 그곳에 인원을 할당한다. 
' 			11. nBlock Size = 4 인데 nSameTeam == 0인 Block을 못 찾았으면 
' 			      해당 Block의 최상위 Block( 처음 반으로 나눈)에서 인원을 할당한다. 
' 			
' 			1차적으로 4부분으로 인원을 나누면서 동일팀 분산이 이루어 지고, 
' 			2차적으로 Binary Search 방식으로 동일팀 분산이 이루어 지며, 
' 			3차적으로 최대한 분산하여 User를 배치하기 때문에 인원의 분산이 효과적으로 이루어 질것이라 예상한다. 
' 			물론 100% 수작업과 같은 산출물은 도출하기 어렵다. 
' 			
' 			
' 		예선조 - 예선인원	
' 			1. 예선조는 기본적으로 4인 1조이다.
' 			2. 예선조 인원이 적은 조는 Q1조 부터 배정한다. 즉 제일 적은 인원의 조부터 배열한다.
' 			3. 예선조 인원 <= 4이면 예선조는 1개 조이다.
' 			4. 예선조 인원이 <= 8 이면 예선조는 2개 조 이다.
' 			      QCnt = 7 이면 Q1 = 3, Q2 = 4
' 			      QCnt = 6 이면 Q1 = 3, Q2 = 3
' 			      QCnt = 5 이면 Q1 = 2, Q2 = 3
' 			5. 예선조 인원 <= 12이면 예선조는 3개조 이다.
' 			      QCnt = 11 이면 Q1 = 3, Q2 = 4, Q3 = 4
' 			      QCnt = 10 이면 Q1 = 3, Q2 = 3, Q3 = 4
' 			      QCnt = 9 이면 Q1 = 3, Q2 = 3, Q3 = 3
' 			
' 			6. 예선조 인원 > 12이면
' 			      QCnt Mod 4 = 3 이면  Q1 = 3
' 			      QCnt Mod 4 = 2 이면  Q1 = 3, Q2 = 3
' 			      QCnt Mod 4 = 1 이면  Q1 = 3, Q2 = 3, Q3= 3
' 			
' 		예선조 할당	예선조에 Bye를 적용한다. 
' 			1. 인원을 Team Count순으로 정렬한다. 
' 			2. 인원을 순차적으로 할당한다 .
' 			
' 			1. User를 한명 선택한다.
' 			2. 선택된 User의 code_team을 추출한다.
' 			3. 각 예선조에서 code_team과 일치하는 User의 Count수를 구한다. nSameTeam 
' 			4. nSameTeam의 최소값을 갖는 예선조를 구한다. 
' 			5. 예선조를 감싸고 있는 본선조의 nSameTeam 을 구한다. 
' 			    n4BlockCnt, n8BlockCnt, n16BlockCnt를 구한다. 
' 			6. n4BlockCnt의 최소값을 갖는 예선조를 구한다. 
' 			7. n8BlockCnt의 최소값을 갖는 예선조를 구한다. 
' 			8. n16BlockCnt의 최소값을 갖는 예선조를 구한다. 
' 			9. 예선조를 할당한다. 
' 			10. 더이상 할당할 공간이 없는 예선조를 제외하고 1~9를 반복한다. 
'   ===============================================================================   
%>

<% 	  
'   ===============================================================================     
'     define variable
'   ===============================================================================   
   Dim E_POS_NORMAL, E_POS_SEED, E_POS_BYE, E_POS_Q, E_POS_FIRST   ' pos_kind : position 종류 - normal, seed, bye/Q (Qualification), First Man(1장)
   Dim E_TEAMCNT_NONE, E_TEAMCNT_AVEOVER, E_TEAMCNT_HALFOVER, E_TEAMCNT_NORMAL, E_TEAMCNT_QFIRST   ' Team Count에 따른 종류 - team 배분시 사용   
   Dim E_PART_A, E_PART_B, E_PART_C, E_PART_D, E_HALF_A, E_HALF_B, E_PART_ALL
   Dim CON_POSCOL_CNT_S, CON_POSCOL_CNT_D , CON_USERCOL_CNT            '  aryPos - column count, aryUser - column count
   Dim CON_TEAMCOL_CNT                                                 ' aryTeam - column count
   Dim CON_POSVAL_NOUSE, CON_PLAYERCODE_EMPTY, CON_DEF_BLOCKSZ
   Dim CON_QGROUP_USER

   CON_POSCOL_CNT_S        = 10 + 1          ' aryPos - 단식 column count
   CON_POSCOL_CNT_D        = 14 + 1          ' aryPos - 복식 column count

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
   E_POS_FIRST             = 4               ' 1장 자리 

   E_TEAMCNT_NONE          = -1              ' 팀인원이 없다. 
   E_TEAMCNT_QFIRST        = 12              ' 예선조에 있는 팀이다. (제일 우선순위가 높다.) 
   E_TEAMCNT_AVEOVER       = 11              ' 팀인원이 평균보다 많다. 
   E_TEAMCNT_NORMAL        = 10              ' 팀인원이 평균 이하이다. 
   E_TEAMCNT_HALFOVER      = 9               ' 팀인원이 절반 보다 많다. 

   E_PART_A                = 0               ' A Part
   E_PART_B                = 1               ' B Part
   E_PART_C                = 2               ' A Part
   E_PART_D                = 3               ' B Part   
   E_HALF_A                = 4               ' A Part
   E_HALF_B                = 5               ' B Part
   E_PART_ALL              = 6               ' All part
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
'      1, 2등은 고정 자리이다. (항상 같은자리)
'      3-4 / 5-8 / 9-16 등일 경우 각각의 자리는 해당 그룹에서 랜덤하게 위치한다. (3등은 3, 4위치 중 랜덤하게)
'   =============================================================================== 
   Function exGetSeedPos(rAryPos, rArySeed, sOrder )
      Dim seedPos, ub, Idx, aryTmpPos, nMax

      Idx = sOrder - 1          ' sOrder (seed값은 1부터 , 배열은 0부터 )
      seedPos = -1
      ub = UBound(rArySeed)  
      If(Idx <=  ub) Then 
        seedPos = rArySeed(Idx)-1        ' seed data의 값으 1부터 , 실질적인 aryPos은 0 부터 
      End If 
   
      exGetSeedPos = seedPos
   End Function 

'	Function exGetSeedPos(rAryPos, rArySeed, sOrder )
'		Dim seedPos, ub, Idx, aryTmpPos, nMax
'
'		Idx = sOrder - 1          ' sOrder (seed값은 1부터 , 배열은 0부터 )
'		seedPos = -1
'		ub = UBound(rArySeed)  
'		If(Idx <=  ub) Then 
'				If (Idx = 0 Or Idx = 1) Then        ' 1, 2등 
'					seedPos = rArySeed(Idx)-1        ' seed data의 값으 1부터 , 실질적인 aryPos은 0 부터 
'				Else 
'					If (Idx = 2 Or Idx = 3) Then     ' 3, 4 등 
'							nMax = 2
'							ReDim aryTmpPos(1, nMax-1) 
'							aryTmpPos(1, 0) = rArySeed(2)-1
'							aryTmpPos(1, 1) = rArySeed(3)-1
'
'					ElseIf (Idx = 4 Or Idx = 5 Or Idx = 6 Or Idx = 7) Then   ' 5, 6, 7, 8 등 
'							nMax = 4
'							ReDim aryTmpPos(1, nMax-1) 
'							aryTmpPos(1, 0) = rArySeed(4)-1
'							aryTmpPos(1, 1) = rArySeed(5)-1
'							aryTmpPos(1, 2) = rArySeed(6)-1
'							aryTmpPos(1, 3) = rArySeed(7)-1
'					Else                                ' 9, 10, 11, 12, 13, 14, 15, 16 등 
'							nMax = 8
'							ReDim aryTmpPos(1, nMax-1) 
'							aryTmpPos(1, 0) = rArySeed(8)-1
'							aryTmpPos(1, 1) = rArySeed(9)-1
'							aryTmpPos(1, 2) = rArySeed(10)-1
'							aryTmpPos(1, 3) = rArySeed(11)-1
'							aryTmpPos(1, 4) = rArySeed(12)-1
'							aryTmpPos(1, 5) = rArySeed(13)-1
'							aryTmpPos(1, 6) = rArySeed(14)-1
'							aryTmpPos(1, 7) = rArySeed(15)-1
'					End If 

'					seedPos = exGetSeedRandomPos(rAryPos, aryTmpPos, nMax)
'				End If 
'		End If 
'	
'		exGetSeedPos = seedPos
'	End Function 

'   ===============================================================================     
'      3-4 / 5-8 / 9-16 등일 경우 각각의 자리는 해당 그룹에서 랜덤하게 위치한다. (3등은 3, 4위치 중 랜덤하게)
'      Seed 자리 배열에서 Random하게 Seed자리를 추출한다. - aryPos은 빈값인 곳
'   =============================================================================== 
   Function exGetSeedRandomPos(rAryPos, rArySTmp, nMax)
      Dim seedPos, Idx, aryTmpPos, rNum, k, cnt
      cntPos = nMax 
      seedPos = -1
      
      For Idx = 0 To nMax - 1
         rNum = GetRandomNum(cntPos) -1

         cnt = 0         
         For k = 0 To nMax - 1
            If(rArySTmp(0, k) <> 1) Then 
               If(cnt = rNum) Then 
                  seedPos = rArySTmp(1, k)
                  rArySTmp(0, k) = 1               ' 한번 사용한 Seed Pos값은 fUse = 1로 셋팅한다. 
                  Exit For 
               End If 
               cnt = cnt + 1
            End If 
         Next 

         ' seedPos의 위치에 rAryPos값이 없는지 확인 
         If(rAryPos(0,seedPos) = 0) Then 
            Exit For
         End If 
         cntPos = cntPos -1 
      Next
   
      exGetSeedRandomPos = seedPos
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

		exIsByePos = isBye
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
         ary(0, Idx) = 0                        ' fUse
         ary(1, Idx) = Idx + 1                  ' pos
         ary(2, Idx) = 0                        ' pos kind normal 
         ary(3, Idx) = CON_POSVAL_NOUSE         ' pos val : not use
         ary(4, Idx) = CON_PLAYERCODE_EMPTY     ' player code : empty user 
         ary(5, Idx) = 0                        ' team order : 0
      Next

      exGetPosArray = ary
   End Function 

   '   ===============================================================================     
'      nRound를 입력받아 Position Array를 반환한다. 
'   ===============================================================================
   Function exGetQPosArray(nQGroup, IsDblGame)
      Dim ary, nCol, Idx, ub , nRow, pos 
      
      nRow = nQGroup * CON_QGROUP_USER
      nCol = CON_POSCOL_CNT_S
      If(IsDblGame = 1) Then nCol = CON_POSCOL_CNT_D End If
      
      ReDim ary(nCol-1, nRow-1)      
      ub = UBound(ary, 2)

      For Idx = 0 To ub
         pos = (Idx Mod CON_QGROUP_USER) + 1
         ary(0, Idx) = 0                        ' fUse
         ary(1, Idx) = pos                      ' pos
         ary(2, Idx) = 0                        ' pos kind normal 
         ary(3, Idx) = CON_POSVAL_NOUSE         ' pos val : not use
         ary(4, Idx) = CON_PLAYERCODE_EMPTY     ' player code : empty user 
         ary(5, Idx) = 0                        ' team order : 0
      Next

      exGetQPosArray = ary
   End Function 

'   ===============================================================================     
'      인원수를 입력받아 aryQPos에 Bye를 셋팅한다. 
'   ===============================================================================
   Function exSetByeInAryQPos(rAryPos, nQUser, IsDblGame)
      Dim szBlock

      szBlock = 4
      If(IsDblGame = 1) Then nQUser = nQUser / 2 End If 

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
         nQMod = nQUser Mod szBlock
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

         rAryPos(0, sp+1) = 1
         rAryPos(0, sp+2) = 1
         rAryPos(0, sp+3) = 1
      ElseIf(nUser = 2) Then           ' data: 1, 4 / bye: 2, 3
         rAryPos(2, sp+1) = E_POS_BYE         
         rAryPos(2, sp+2) = E_POS_BYE

         rAryPos(0, sp+1) = 1
         rAryPos(0, sp+2) = 1

      ElseIf(nUser = 3) Then           ' data: 1, 3, 4 / bye: 2
         rAryPos(2, sp+1) = E_POS_BYE
         rAryPos(0, sp+1) = 1         
      End If 
   End Function 

'   ===============================================================================     
'      aryPos배열을 4개로 나눈다. 
'   ===============================================================================
   Function exDivAryPos(rAryPos, nPart)
      Dim Idx, ub, ary, sPos, ePos, nCol, nCnt, m
      ub = UBound(rAryPos, 2)
      nCol = UBound(rAryPos, 1)
      nCnt = ((ub+1) / 4) 

      If(nPart = E_PART_A) Then 
         sPos = 0
         ePos = nCnt -1
      ElseIf(nPart = E_PART_B) Then  
         sPos = nCnt
         ePos = (nCnt*2)-1
      ElseIf(nPart = E_PART_C) Then  
         sPos = (nCnt*2)
         ePos = (nCnt*3)-1
      ElseIf(nPart = E_PART_D) Then   
         sPos = (nCnt*3)
         ePos = ub
      ElseIf(nPart = E_HALF_A) Then  
         sPos = 0
         ePos = (nCnt*2)-1
      ElseIf(nPart = E_HALF_B) Then  
         sPos = (nCnt*2)
         ePos = ub
      ElseIf(nPart = E_PART_ALL) Then  
         sPos = 0
         ePos = ub
      End If 

      ReDim ary( nCol, nCnt-1 )

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
      Dim Idx, ub, ary, sPos, ePos, nCol, nCnt, m
      ub = UBound(rAryPos, 2)
      nCol = UBound(rAryPos, 1)
      nCnt = ((ub+1) / 4) 

      If(nPart = E_PART_A) Then 
         sPos = 0
         ePos = nCnt -1
      ElseIf(nPart = E_PART_B) Then  
         sPos = nCnt
         ePos = (nCnt*2)-1
      ElseIf(nPart = E_PART_C) Then  
         sPos = (nCnt*2)
         ePos = (nCnt*3)-1
      ElseIf(nPart = E_PART_D) Then  
         sPos = (nCnt*3)
         ePos = ub
      ElseIf(nPart = E_HALF_A) Then  
         sPos = 0
         ePos = (nCnt*2)-1
      ElseIf(nPart = E_HALF_B) Then  
         sPos = (nCnt*2)
         ePos = ub
      ElseIf(nPart = E_PART_ALL) Then  
         sPos = 0
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
'      aryPos에 By값을 적용한다. 
'   ===============================================================================  
   Function exApplyByeToPos(rAryPos, nUser)
      Dim Idx, ub, aryBye

      aryBye = exGetAryBye(nUser)

      ub = UBound(rAryPos, 2)

      For Idx = 0 To ub
         If(exIsByePos(aryBye, Idx+1) = 1 ) Then  ' Bye 자리다.  
            rAryPos(0, Idx) = 1            
            rAryPos(2, Idx) = E_POS_BYE    
         End If 
      Next

   End Function 

'   ===============================================================================     
'      aryUser로 부터 aryPos에 User를 할당한다.                    - 단식 
'        1. aryPos에는 Seed, Q 가 할당되어 있다. 
'        2. aryPos을 aryPosA ,aryPosB, aryPosC, aryPosD로 나눈다. ( / 4)
'        3. aryUser를 aryUserA, aryUserB, aryUserC, aryUserD로 나눈다. 
'           3-1. aryUserA, aryUserB, aryUserC, aryUserD에 Seed를 적용한다. 
'           3-2. cntUserA = (posA size / 2) - (cntSeedA + cntQ)
'           3-3. aryUser에는 데이터가 순서대로 있으므로 각 데이터를 번갈아 가면서 배분한다. 
'        4. aryUserA, aryUserB, aryUserC, aryUserD를 이용하여 aryPosA ,aryPosB, aryPosC, aryPosD에 인원을 할당한다. 
'        4-1. 각조의 1장을 먼저 할당한다. (aryUser(PlayerOrder) = 1) 
'        4-2. A part, B part, C part, D part별로 team info를 구한다. 
'        4-3. team info에서 team user cnt별로 구분한다. ( halfover, ave over, normal )
'        4-4. team info에서 team order을 구한다. ( team 구하는 algorithm 적용) 
'        4-5. team order를 가지고 user를 구한다. 
'        4-6. search block을 구한후 , search block에서 user를 넣을수 있는지 검사한다.
'        4-7. block에 Q가 있을 경우 , 해당 Q(예선조)의 인원을 가져와서 중복 체크를 한다. 
'        4-8. user를 넣을수 있는 block이 여러개 있을 경우 , block size를 최소 사이즈로 적용한다. 
'        4-9. block 최소 size는 if(blocksize > 4) blocksize = 4 로한다. 
'        4-10. block에서 사용자가 제일 적게 할당된 block에 random하게 배분한다. 
'   =============================================================================== 
   Function exSetTournamentUser(rAryPos, rAryTUser, IsDblGame)
      If(IsDblGame = 1) Then 
         Call exSetTournamentUserDbl(rAryPos, rAryTUser, IsDblGame)
         Exit Function 
      End If 

      Dim aryPosA, aryPosB, aryPosC, aryPosD
      Dim aryUserA, aryUserB, aryUserC, aryUserD        

      ' 2. aryPos을 aryPosA, aryPosB, aryPosC, aryPosD로 나눈다. ( / 4)
      aryPosA = exDivAryPos(rAryPos, E_PART_A)
      aryPosB = exDivAryPos(rAryPos, E_PART_B)
      aryPosC = exDivAryPos(rAryPos, E_PART_C)
      aryPosD = exDivAryPos(rAryPos, E_PART_D)

'      '  3. aryUser를 aryUserA, aryUserB, aryUserC, aryUserD로 나눈다.  
      Call exDivAryUser(aryPosA, aryPosB, aryPosC, aryPosD, aryUserA, aryUserB, aryUserC, aryUserD, rAryTUser, IsDblGame)
      
      Call exAssignPos(aryPosA, aryUserA, IsDblGame)
      Call exAssignPos(aryPosB, aryUserB, IsDblGame)
      Call exAssignPos(aryPosC, aryUserC, IsDblGame)
      Call exAssignPos(aryPosD, aryUserD, IsDblGame)

      Call exMergeAryPos(rAryPos, aryPosA, E_PART_A)
      Call exMergeAryPos(rAryPos, aryPosB, E_PART_B)
      Call exMergeAryPos(rAryPos, aryPosC, E_PART_C)
      Call exMergeAryPos(rAryPos, aryPosD, E_PART_D)

   End Function

   Function exSetTournamentUserDbl(rAryPos, rAryTUser, IsDblGame)
      Dim aryPosA, aryPosB, aryPosC, aryPosD
      Dim aryUserA, aryUserB, aryUserC, aryUserD        

      ' 2. aryPos을 aryPosA, aryPosB, aryPosC, aryPosD로 나눈다. ( / 4)
      aryPosA = exDivAryPos(rAryPos, E_PART_A)
      aryPosB = exDivAryPos(rAryPos, E_PART_B)
      aryPosC = exDivAryPos(rAryPos, E_PART_C)
      aryPosD = exDivAryPos(rAryPos, E_PART_D)

      '  3. 3. aryUser를 aryUserA, aryUserB, aryUserC, aryUserD로 나눈다.    
      Call exDivAryUserDbl(aryPosA, aryPosB, aryPosC, aryPosD, aryUserA, aryUserB, aryUserC, aryUserD, rAryTUser, IsDblGame)  
      
      Call exAssignPos(aryPosA, aryUserA, IsDblGame)
      Call exAssignPos(aryPosB, aryUserB, IsDblGame)
      Call exAssignPos(aryPosC, aryUserC, IsDblGame)
      Call exAssignPos(aryPosD, aryUserD, IsDblGame)

      Call exMergeAryPos(rAryPos, aryPosA, E_PART_A)
      Call exMergeAryPos(rAryPos, aryPosB, E_PART_B)
      Call exMergeAryPos(rAryPos, aryPosC, E_PART_C)
      Call exMergeAryPos(rAryPos, aryPosD, E_PART_D)

   End Function

'   ===============================================================================     
'        4. aryUser를 이용하여 aryPos에 인원을 할당한다. 
'        4-1. 1장을 먼저 배치한다. 
'        4-2. team info를 구한다. 
'        4-3. team info에서 team user cnt별로 구분한다. ( halfover, ave over, normal )
'        4-4. team info에서 team order을 구한다. ( team 구하는 algorithm 적용) 
'        4-5. team order를 가지고 user를 구한다. 
'        4-6. search block을 구한후 , search block에서 user를 넣을수 있는지 검사한다.
'        4-7. block에 Q가 있을 경우 , 해당 Q(예선조)의 인원을 가져와서 중복 체크를 한다. 
'        4-8. user를 넣을수 있는 block이 여러개 있을 경우 , block size를 최소 사이즈로 적용한다. 
'        4-9. block 최소 size는 if(blocksize > 4) blocksize = 4 로한다. 
'        4-10. block에서 사용자가 제일 적게 할당된 block에 random하게 배분한다. 
'   =============================================================================== 
   Function exAssignPos(rAryPos, rAryUser, IsDblGame)
      Dim ub, Idx , sBlock, nRound
      Dim fLoop, cntLoop, teamOrder, userIdx, cntSeed
      Dim aryTeam, nStep, aryQTeam, cntAlignFirst  
      
      cntSeed = GetSeedCntAryUser(rAryUser)      
      ub = UBound(rAryUser, 2)     
      nRound = UBound(rAryPos, 2) + 1 
      sBlock = exCalcSearchBlock(nRound)
      nStep = 1
      If(IsDblGame = 1) Then nStep = 2 End If 

      ' 1. aryUser로 부터 aryTeam을 구한다. 
      aryTeam = exCreateTeamInfo(rAryUser)

      ' 1장 (PlayerOrder = 1)을 먼저 할당한다. 
      cntAlignFirst = 0                            ' 할당된 1장 갯수 
      For Idx = 0 To ub step nStep
         If(rAryUser(0, Idx) <> 1 And rAryUser(5, Idx) = "1") Then 
            userIdx = Idx 
            teamOrder = rAryUser(1, Idx) 
            rAryUser(0, Idx) = 1          ' fUse Setting 
            cntAlignFirst = cntAlignFirst + 1
            If(IsDblGame = 1) Then 
               Call exSetGamePosDbl(rAryPos, rAryUser, userIdx, teamOrder, sBlock)
            Else 
               Call exSetGamePos(rAryPos, rAryUser, userIdx, teamOrder, sBlock)
            End If 
         End If 
      Next 

      ub = (UBound(rAryUser, 2) + 1) - (cntSeed+cntAlignFirst)

      For Idx = 0 To ub step nStep         
         fLoop = 1
         cntLoop = 20

         while(fLoop=1)
            teamOrder = exGetSelTeam(aryTeam)

            If(teamOrder <> -1) Then 
               userIdx = exGetSelUser(rAryUser, teamOrder)
               If(userIdx = -1) Then 
                  Call exDelTeamInfo(aryTeam, teamOrder) 
               Else 
                  fLoop = 0
               End If 
            End If 

            cntLoop = cntLoop - 1

            If(cntLoop = 0) Then 
               fLoop = 0 
            End If 
         WEnd 

         If(userIdx = -1) Then      ' 사용자를 찾지 못했다. 
            strLog = sprintf("userIdx = {0}, teamOrder = {1}", Array(userIdx, teamOrder)) 
            Exit For 
         End If 

         If(IsDblGame = 1) Then 
            Call exSetGamePosDbl(rAryPos, rAryUser, userIdx, teamOrder, sBlock)
         Else 
            Call exSetGamePos(rAryPos, rAryUser, userIdx, teamOrder, sBlock)
         End If 
      Next 
   End Function 

'   ===============================================================================     
'        aryUser로 부터 seed가 셋팅된 count를 반환한다. 
'   =============================================================================== 
   Function GetSeedCntAryUser(rAryUser)
      Dim Idx, ub, cnt 

      ub = UBound(rAryUser, 2)
      cnt = 0

      For Idx = 0 To ub 
         If(rAryUser(2, Idx) <> 0) Then 
            cnt = cnt + 1
         End If 
      Next 

      GetSeedCntAryUser = cnt 
   End Function 

'   ===============================================================================     
'        4. 실질적으로 aryPos에 userInfo를 setting한다. 
'   =============================================================================== 
   Function exSetGamePos(rAryPos, rAryUser, userIdx, teamOrder, sBlock)
      Dim ub, Idx, sBase, floop, rNum, strBlock 
      Dim aryBlock, aryTmp, IsFirst
      Dim sp, ep, nBlockUser, pos, cntPos, cnt , selPos      

      sBase = sBlock 
      fLoop = 1
      teamOrder = rAryUser(1, userIdx)
      selPos = -1
      IsFirst = 0
      If(rAryUser(5, userIdx) = "1") Then IsFirst = 1 End If      ' 1장 유무 

      While(fLoop)
         strBlock = exCheckTeamInPos(rAryPos, teamOrder, IsFirst, sBase)

         If(strBlock <> "") Or (sBase = 1) Then 
            fLoop = 0
         Else 
            sBase = sBase / 2 
         End If 
      wEnd 
      
      If(strBlock <> "") Then       ' 찾았다.    인원수가 제일 적은 block순으로 배치한다. 
         pos = exGetInsertBlock(rAryPos, strBlock, sBase)
         sp = pos * sBase
         ep = sp + (sBase - 1) 
         nBlockUser = exGetUserCntInBlock(rAryPos, pos, sBase)

         cntPos = sBase - nBlockUser
         rNum = GetRandomNum(cntPos) -1

         cnt = 0

         ' insert position을 random하게 구한다. 
         For Idx = sp To ep      
            If(rAryPos(0, Idx) = 0) Then 
               If(rNum = cnt) Then 
                  selPos = Idx 
                  Exit For 
               Else 
                  cnt = cnt + 1
               End IF 
            End If 
         Next 
      End If 

      '   -----------------------------------------------------------------------
      '    빈자리를 못찾았으면 아무 빈자리나 넣는다. 
      If (selPos = -1) Then 
         selPos = exGetRandomPos(rAryPos)   
      End If 

      ' fUse, pos, pos_kind, pos_val, playerCode(gGroupIdx), teamOrder, cUser, user, cTeam, team
      If (selPos <> -1 ) Then 
			rAryPos(0, selPos) = 1			
         
         If(IsFirst = 1) Then 
            rAryPos(2, selPos) = E_POS_FIRST                ' 1장을 할당했다. 
         Else 
            rAryPos(2, selPos) = E_POS_NORMAL 
         End If 
			
			rAryPos(4,selPos) = rAryUser(6,userIdx)         ' playerCode - GroupIdx
			rAryPos(5,selPos) = rAryUser(1,userIdx)         ' team order
			rAryPos(6,selPos) = rAryUser(8,userIdx)         ' cUser
			rAryPos(7,selPos) = rAryUser(9,userIdx)         ' user
			rAryPos(8,selPos) = rAryUser(10,userIdx)         ' cTeam
			rAryPos(9,selPos) = rAryUser(11,userIdx)         ' team
			rAryPos(10,selPos) = rAryUser(5,userIdx)       	' player order

		End If
   End Function 

'   ===============================================================================
'     strBlock을 받아서 인원수가 제일 적은 block position을 반환한다 
'     이때 sBlock > CON_DEF_BLOCKSZ 이면 sBlock = CON_DEF_BLOCKSZ(4)으로 변환하여 인원수 체크를 한다. (값의 쏠림 방지)
'   ===============================================================================
   Function exGetInsertBlock(rAryPos, strBlock, sBlock)
      Dim pos, nMinUser, nBlockUser, nDiv, nSize, hasQ
      Dim aryBlock, aryTmp, aryData , ub, Idx, m, k, spVal, IsEmpty

      aryBlock = Split(strBlock, ",")
      ub = UBound(aryBlock)

      pos = aryBlock(0)
      nMinUser = 100
      nBlockUser = 0 
      hasQ = 0

      ' block size 4 보다 작거나 같은 데서 체크하자   좀더 퍼트리자  
      If(sBlock > CON_DEF_BLOCKSZ) Then 
         nDiv = sBlock / CON_DEF_BLOCKSZ
         nSize = (ub+1) * nDiv 

         ReDim aryTmp(nSize-1)

         m = 0
         For Idx = 0 To ub 
            For k = 0 To nDiv-1
               aryTmp(m) = (aryBlock(Idx) * nDiv) + k
               m = m + 1
            Next 
         Next 

         sBlock = CON_DEF_BLOCKSZ
         aryData = aryTmp 
      Else 
         aryData = aryBlock 
      End If 

      ub = UBound(aryData) 

      ' Q가 있고, Q의 partner가 비어 있는지 먼저 체크 , 해당 block을 찾는다. 
      pos = -1 
      spVal = E_POS_Q
      For Idx = 0 To ub
         IsEmpty = exIsSpecialCellPartnerEmpty(rAryPos, spVal, aryData(Idx), sBlock)
         If(IsEmpty = 1) Then 
            pos = aryData(Idx)
            Exit For 
         End If 
      Next 

      ' Seed가 있고, Seed가의 partner가 비어 있는지 먼저 체크 , 해당 block을 찾는다. 
      If(pos = -1) Then 
         spVal = E_POS_SEED
         For Idx = 0 To ub
            IsEmpty = exIsSpecialCellPartnerEmpty(rAryPos, spVal, aryData(Idx), sBlock)
            If(IsEmpty = 1) Then  
               pos = aryData(Idx)
               Exit For 
            End If 
         Next 
      End If 

      ' sBlock = 2 이고 , 넣을 자리가 1개 이상이면, 
      ' sBlock을 4로 확장하여 Q의 유무를 검사한다. 이때 Q가 있으면 Q옆에 자리에 넣는다. 
      If(pos = -1) And (sBlock = 2) Then 
         For Idx = 0 To ub
            hasQ = exExtendBlockForCheckQ(rAryPos, aryData(Idx))
            If(hasQ = 1) Then                
               pos = aryData(Idx)
               Exit For 
            End If 
         Next 
      End If       

      ' Q의 Partner체크에서 찾지 못했으면 인원수가 제일 적은 block을 찾는다. 
      If(pos = -1) Then 
         For Idx = 0 To ub
            nBlockUser = exGetUserCntInBlock(rAryPos, aryData(Idx), sBlock)
            If(nMinUser > nBlockUser) Then 
               nMinUser = nBlockUser 
               
               pos = aryData(Idx)
            End If 
         Next 
      End If 
      
      exGetInsertBlock = pos
   End Function 

'   ===============================================================================
'     sBlock ary를 입력받아 Block을 4로 확장한 다음에 Q가 있는지 찾는다. 
'     szBlock = 2일때만 호출 -> 4로 확장하여 체크한다. 
'   ===============================================================================
   Function exExtendBlockForCheckQ(rAryPos, pos)
      Dim sp, ep, szExBlock, Idx , hasQ 

      hasQ = 0
      szExBlock = 4      
      sp = Fix(pos / 2) * szExBlock       ' szBlock이 2 이므로 4로 만들기 위해서 /2 한다. 
      ep = sp + (szExBlock - 1)

      For Idx = sp To ep
         If(rAryPos(2, Idx) = E_POS_Q) Then        ' Q(예선조)가 있다.. 이걸로 하자 
            hasQ = 1
            Exit For 
         End If 
      Next 

      exExtendBlockForCheckQ = hasQ
   End Function 

'   ===============================================================================
'     Team 중복 체크 ( block 단위 )  - block 갯수만큼 루프가 동작
'   ===============================================================================
   Function exCheckTeamInPos(rAryPos, teamOrder, IsFirst, sBlock)
      Dim Idx, ub, sp, ep, nMax, strFind, canInsert

      ub = UBound(rAryPos, 2)
      nMax = ((ub+1) / sBlock ) -1 
      strFind = ""

      For Idx = 0 To nMax
         canInsert = exCheckTeamInBlock(rAryPos, teamOrder, IsFirst, Idx, sBlock)

         If(canInsert = 1) Then 
            If(strFind = "") Then 
               strFind = sprintf("{0}", Array(Idx))
            Else 
               strFind = sprintf("{0},{1}", Array(strFind, Idx))
            End If 
         End If 
      Next 

      exCheckTeamInPos = strFind       
   End Function 

'   ===============================================================================
'     block내에서 team 중복 검사 - '     Block 이 꽉 차 있어도 안된다. 
'     IsFirst - 1장인가?
'   ===============================================================================
   Function exCheckTeamInBlock(rAryPos, teamOrder, IsFirst, pos, sBlock)
      Dim Idx, ub, sp, ep, cntUsed, canInsert, nQGroup

      canInsert = 1
      cntUsed = 0
      sp = pos * sBlock
      ep = sp + (sBlock - 1)
      ub = UBound(rAryPos, 2) 

      For Idx = sp To ep 
         If(rAryPos(0, Idx) = 1) Then        ' user가 할당되어 있다. 중복 체크를 하자 
            If(IsFirst = 1) Then 
							If(rAryPos(2, Idx) = E_POS_FIRST) Or (rAryPos(2, Idx) = E_POS_SEED)Then ' Seed Or 1장이 할당되었다. 다른곳에 넣자 
									canInsert = 0
							End If 
						Else 
							If(rAryPos(5, Idx) = teamOrder) Then   ' 할당된 position의 teamOrder를 체크한다. 
									canInsert = 0
							End If 
						End If 

            If(canInsert = 0) Then 
               Exit For 
            End If  
            cntUsed = cntUsed + 1
         End If 
      Next

      ' 다 사용중 ( 할당할수 없다.) - 해당 Block내에 빈 공간이 없다. 
		If( cntUsed = sBlock ) Then canInsert = 0 End If	

      exCheckTeamInBlock = canInsert
   End Function 

'   ===============================================================================     
'        4. 실질적으로 aryPos에 userInfo를 setting한다. 
'   =============================================================================== 
   Function exSetGamePosDbl(rAryPos, rAryUser, userIdx, teamOrder, sBlock)
      Dim ub, Idx, sBase, floop, rNum, strBlock 
      Dim aryBlock, aryTmp, IsFirst
      Dim sp, ep, nBlockUser, pos, cntPos, cnt , selPos
      Dim userIdx2, teamOrder2, tmpIdx

      ' get partner 
      userIdx2 = exGetPartnerIdx(userIdx)
      rAryUser(0, userIdx2) = 1

      If(userIdx > userIdx2) Then      ' 순서를 맞추기 위해서 swap          
         tmpIdx = userIdx
         userIdx = userIdx2
         userIdx = tmpIdx
      End If       

      sBase = sBlock 
      fLoop = 1
      teamOrder = rAryUser(1, userIdx)
      teamOrder2 = rAryUser(1, userIdx2)
      selPos = -1
      IsFirst = 0
      If(rAryUser(5, userIdx) = "1") Then IsFirst = 1 End If      ' 1장 유무 

      While(fLoop)
         strBlock = exCheckTeamInPosDbl(rAryPos, teamOrder, teamOrder2, IsFirst, sBase)

         If(strBlock <> "") Or (sBase = 1) Then 
            fLoop = 0
         Else 
            sBase = sBase / 2 
         End If 
      wEnd 

      If(strBlock <> "") Then       ' 찾았다.    인원수가 제일 적은 block순으로 배치한다. 
         pos = exGetInsertBlock(rAryPos, strBlock, sBase)
         sp = pos * sBase
         ep = sp + (sBase - 1) 
      
         nBlockUser = exGetUserCntInBlock(rAryPos, pos, sBase)

         cntPos = sBase - nBlockUser
         rNum = GetRandomNum(cntPos) -1

         cnt = 0

         ' insert position을 random하게 구한다. 
         For Idx = sp To ep      
            If(rAryPos(0, Idx) = 0) Then 
               If(rNum = cnt) Then 
                  selPos = Idx 
                  Exit For 
               Else 
                  cnt = cnt + 1
               End IF 
            End If 
         Next 
      End If 

      '   -----------------------------------------------------------------------
      '    빈자리를 못찾았으면 아무 빈자리나 넣는다. 
      If (selPos = -1) Then 
         selPos = exGetRandomPos(rAryPos)           
      End If 

      ' fUse, pos, pos_kind, pos_val, playerCode(gGroupIdx), teamOrder, cUser, user, cTeam, team
      If (selPos <> -1 ) Then 
			rAryPos(0, selPos) = 1	
         
         If(IsFirst = 1) Then 
            rAryPos(2, selPos) = E_POS_FIRST                ' 1장을 할당했다. 
         Else 
            rAryPos(2, selPos) = E_POS_NORMAL 
         End If 

			rAryPos(4,selPos) = rAryUser(6,userIdx)         ' playerCode - GroupIdx
			rAryPos(5,selPos) = rAryUser(1,userIdx)         ' team order
			rAryPos(6,selPos) = rAryUser(8,userIdx)         ' cUser
			rAryPos(7,selPos) = rAryUser(9,userIdx)         ' user
			rAryPos(8,selPos) = rAryUser(8,userIdx2)         ' cUser
			rAryPos(9,selPos) = rAryUser(9,userIdx2)         ' user
			rAryPos(10,selPos) = rAryUser(10,userIdx)         ' cTeam
			rAryPos(11,selPos) = rAryUser(11,userIdx)         ' team
			rAryPos(12,selPos) = rAryUser(10,userIdx2)         ' cTeam
			rAryPos(13,selPos) = rAryUser(11,userIdx2)         ' team
			rAryPos(14,selPos) = rAryUser(5,userIdx)       	' player order
		End If
   End Function 

'   ===============================================================================
'     Team 중복 체크 ( block 단위 )  - block 갯수만큼 루프가 동작
'   ===============================================================================
   Function exCheckTeamInPosDbl(rAryPos, teamOrder, teamOrder2, IsFirst, sBlock)
      Dim Idx, ub, sp, ep, nMax, strFind, canInsert

      ub = UBound(rAryPos, 2)
      nMax = ((ub+1) / sBlock ) -1 
      strFind = ""

      For Idx = 0 To nMax
         canInsert = exCheckTeamInBlockDbl(rAryPos, teamOrder, teamOrder2, IsFirst ,Idx, sBlock)

         If(canInsert = 1) Then 
            If(strFind = "") Then 
               strFind = sprintf("{0}", Array(Idx))
            Else 
               strFind = sprintf("{0},{1}", Array(strFind, Idx))
            End If 
         End If 
      Next 

      exCheckTeamInPosDbl = strFind       
   End Function 

'   ===============================================================================
'     block내에서 team 중복 검사 - '     Block 이 꽉 차 있어도 안된다. 
'   ===============================================================================
   Function exCheckTeamInBlockDbl(rAryPos, teamOrder, teamOrder2, IsFirst, pos, sBlock)
      Dim Idx, ub, sp, ep, cntUsed, canInsert, nQGroup

      canInsert = 1
      cntUsed = 0
      sp = pos * sBlock
      ep = sp + (sBlock - 1)
      ub = UBound(rAryPos, 2) 

      For Idx = sp To ep 
         If(rAryPos(0, Idx) = 1) Then        ' user가 할당되어 있다. 중복 체크를 하자 
            If(IsFirst = 1) Then 
							If(rAryPos(2, Idx) = E_POS_FIRST) Or (rAryPos(2, Idx) = E_POS_SEED)Then ' Seed Or 1장이 할당되었다. 다른곳에 넣자 
									canInsert = 0
							End If 
						Else 
							If(rAryPos(5, Idx) = teamOrder) Or (rAryPos(5, Idx) = teamOrder2)Then   ' 할당된 position의 teamOrder를 체크한다. 
									canInsert = 0
							End If 
						End If 

            If(canInsert = 0) Then 
               Exit For 
            End If  
            cntUsed = cntUsed + 1
         End If 
      Next

      ' 다 사용중 ( 할당할수 없다.) - 해당 Block내에 빈 공간이 없다. 
		If( cntUsed = sBlock ) Then canInsert = 0 End If	

      exCheckTeamInBlockDbl = canInsert
   End Function 
   
'   ===============================================================================     
'     3. aryUser를 aryUserA, aryUserB로 나눈다. 
'           3-1. aryUserA, aryUserB에 Seed를 적용한다. 
'           3-2. cntUserA = (posA size / 2) - (cntSeedA + cntQ)
'           3-3. aryUser에는 데이터가 순서대로 있으므로 각 데이터를 번갈아 가면서 배분한다. 
'           3-4. aryUserA, aryUserB에 이미 할당된 User중 teamOrder를 count한다. 
'           3-5. aryUserA, aryUserB에 이미 할당된 User를 count한다. 
'   =============================================================================== 
   Function exDivAryUser(rAryPosA, rAryPosB, rAryPosC, rAryPosD, rAryUserA, rAryUserB, rAryUserC, rAryUserD, rAryUser, IsDblGame)
      Dim cntPosA, cntPosB, cntPosC, cntPosD                   ' Count Of Position 
      Dim cntSeedA, cntSeedB, cntSeedC, cntSeedD               ' Count Of Seed
      Dim cntByeA, cntByeB, cntByeC, cntByeD                   ' Count Of Bye
      Dim cntUserA, cntUserB, cntUserC, cntUserD               ' Count Of User
      Dim cntQA, cntQB, cntQC, cntQD                           ' Count Of Qualify
      Dim aryUserA, aryUserB, aryUserC, aryUserD               ' array Of User
      Dim cntAssignA, cntAssignB, cntAssignC, cntAssignD       ' Count Of Assign User
      Dim cntFirstA, cntFirstB, cntFirstC, cntFirstD           ' 1장이 할당된 갯수 
      Dim cntTeamA, cntTeamB, cntTeamC, cntTeamD               ' Count Of Team - teamOrder와 일치하는 할당된 팀 User 수       
      Dim nCol, ub, Idx , assignPart, nCntOver

      cntPosA = UBound(rAryPosA, 2) + 1
      cntPosB = UBound(rAryPosB, 2) + 1
      cntPosC = UBound(rAryPosC, 2) + 1
      cntPosD = UBound(rAryPosD, 2) + 1

      nCntOver = cntPosA * 2

      nCol = UBound(rAryUser, 1)

      ' Seed Count를 구한다. 
      cntSeedA = exGetSpecialPosCnt(rAryPosA, E_POS_SEED, E_PART_ALL)
      cntSeedB = exGetSpecialPosCnt(rAryPosB, E_POS_SEED, E_PART_ALL)
      cntSeedC = exGetSpecialPosCnt(rAryPosC, E_POS_SEED, E_PART_ALL)
      cntSeedD = exGetSpecialPosCnt(rAryPosD, E_POS_SEED, E_PART_ALL)      

      ' Q(예선조) Count를 구한다. 
      cntQA = exGetSpecialPosCnt(rAryPosA, E_POS_Q, E_PART_ALL)
      cntQB = exGetSpecialPosCnt(rAryPosB, E_POS_Q, E_PART_ALL)
      cntQC = exGetSpecialPosCnt(rAryPosC, E_POS_Q, E_PART_ALL)
      cntQD = exGetSpecialPosCnt(rAryPosD, E_POS_Q, E_PART_ALL)

      ' Bye(Empty) Count를 구한다. 
      cntByeA = exGetSpecialPosCnt(rAryPosA, E_POS_BYE, E_PART_ALL)
      cntByeB = exGetSpecialPosCnt(rAryPosB, E_POS_BYE, E_PART_ALL)
      cntByeC = exGetSpecialPosCnt(rAryPosC, E_POS_BYE, E_PART_ALL)
      cntByeD = exGetSpecialPosCnt(rAryPosD, E_POS_BYE, E_PART_ALL)
      
      ' Q Count Or Bye Count 하나만 유효하다. (예선조가 있으면 Bye가 없고, Bye가 있으면 예선조가 없다. )
      cntUserA = cntPosA - (cntQA + cntByeA)
      cntUserB = cntPosB - (cntQB + cntByeB)
      cntUserC = cntPosC - (cntQC + cntByeC)
      cntUserD = cntPosD - (cntQD + cntByeD)            

      ReDim aryUserA(nCol, cntUserA-1)      
      ReDim aryUserB(nCol, cntUserB-1)
      ReDim aryUserC(nCol, cntUserC-1)
      ReDim aryUserD(nCol, cntUserD-1)

      ' 3-1. aryUserA, aryUserB에 Seed를 적용한다. 
      Call exApplySeedFromPos(rAryPosA, aryUserA, rAryUser)
      Call exApplySeedFromPos(rAryPosB, aryUserB, rAryUser)
      Call exApplySeedFromPos(rAryPosC, aryUserC, rAryUser)
      Call exApplySeedFromPos(rAryPosD, aryUserD, rAryUser)
			
			Call exAssignUser(aryUserA, aryUserB, aryUserC, aryUserD, rAryUser)
			
			rAryUserA = aryUserA
      rAryUserB = aryUserB
      rAryUserC = aryUserC
      rAryUserD = aryUserD

   End Function 

'   ===============================================================================     
'     aryUser에 aryPos으로 부터 Seed Data를 적용한다. seed no를 가지고 데이터를 할당한다. 
'   =============================================================================== 
   Function exMergeUserData(rAryUser, rArySrc)
      Dim ub, Idx, s_pos, k 

      cnt = 0
      ub = UBound(rAryUser, 2)
      For Idx = 0 To ub
         If(rAryUser(0,Idx) = "") Then 	' 빈 공간을 찾는다. 
					s_pos = Idx
					Exit For 
         End If 
      Next  

			k = 0
			For Idx = s_pos To ub 
				If(rArySrc(0,k) = "") Then  	' 데이터가 없다. 
					Exit For 
				Else 
					Call CopyRows(rArySrc, rAryUser, k, Idx)
					k = k+1
				End If 
			Next 
   End Function 

'   ===============================================================================     
'     aryUser데이터를 Part A, B, C, D에 나누어 할당한다. ( binary search )
'   =============================================================================== 
	 Function exAssignUser(rAryUserA, rAryUserB, rAryUserC, rAryUserD, rAryUser)
		Dim aryHalfA, aryHalfB
		Dim ubA, ubB, ubC, ubD, ubHA, ubHB , nCol 

		ubA = UBound(rAryUserA, 2)
		ubB = UBound(rAryUserB, 2)
		ubC = UBound(rAryUserC, 2)
		ubD = UBound(rAryUserD, 2)

		ubHA = (ubA + ubB) + 1
		ubHB = (ubC + ubD) + 1
		nCol = UBound(rAryUser, 1)

		ReDim aryHalfA(nCol, ubHA)      
    ReDim aryHalfB(nCol, ubHB)

		Call exMergeUserData(aryHalfA, rAryUserA)
		Call exMergeUserData(aryHalfA, rAryUserB)

		Call exMergeUserData(aryHalfB, rAryUserC)
		Call exMergeUserData(aryHalfB, rAryUserD)

		Call exAssignUserBinSearch(aryHalfA, aryHalfB, rAryUser)

		Call exAssignUserBinSearch(rAryUserA, rAryUserB, aryHalfA)
		Call exAssignUserBinSearch(rAryUserC, rAryUserD, aryHalfB)
	 End Function 

'   ===============================================================================     
'     aryUser데이터를 Part A, B에 나누어 할당한다. ( binary search )
' 		임시적으로 fUse Field rAry(0, Idx)에 team Count를 셋팅하여 데이터 정렬에 사용한다. 
'     rAryUser(0, Idx)에 team count를 넣고 이를 가지고 sort를 한다음 
'     그 데이터로 분배한다. 
'   =============================================================================== 
	Function exAssignUserBinSearch(rAryUserA, rAryUserB, rAryUser)
		Dim ub, Idx
		Dim player_orderA, player_orderB , cnt_teamA, cnt_teamB , team_order
		Dim set_cntA, set_cntB, user_cntA, user_cntB 
		Dim setOneSide, setDataPart
		Dim key, keyType, IsDesc

		user_cntA = UBound(rAryUserA, 2) + 1
		user_cntB = UBound(rAryUserB, 2) + 1
		ub 				= UBound(rAryUser, 2)

		setOneSide = -1
		setDataPart = 0

		' 임시적으로 fUse Field rAry(0, Idx)에 team Count를 셋팅하여 데이터 정렬에 사용한다. 
		Call exSetTeamCnt(rAryUser)

		key 				= 0				' team count
		keyType 		= 2				' data type is number 
		IsDesc 			= 1
		Call Sort2DimAryEx(rAryUser, key, keyType, IsDesc)	

		For Idx = 0 To ub 			
			If(CDbl(rAryUser(2, Idx)) = 0) Then 				' Seed가 아니면.. (seed는 이미 배치했다. )
				team_order = rAryUser(1, Idx)
			
				If(setOneSide = E_HALF_A) Then 						' Part A에만 데이터를 넣어라 
					If(user_cntA > set_cntA) Then 
						Call CopyRows(rAryUser, rAryUserA, Idx, set_cntA)
						set_cntA = set_cntA + 1
					End If 
				ElseIf(setOneSide = E_HALF_B) Then 				' Part B에만 데이터를 넣어라 
					If(user_cntB > set_cntB) Then 
						Call CopyRows(rAryUser, rAryUserB, Idx, set_cntB)
						set_cntB = set_cntB + 1
					End If 
				Else 																			' 이진 검색 결과에 의해 데이터를 넣어라 
					Call exFindTeamInfo(rAryUserA, team_order, player_orderA,cnt_teamA, set_cntA)
					Call exFindTeamInfo(rAryUserB, team_order, player_orderB,cnt_teamB, set_cntB)

					If(cnt_teamA > cnt_teamB) Then 								' Same Team이 PartA에 더 많다. 
						setDataPart = E_HALF_B		
					ElseIf(cnt_teamA < cnt_teamB) Then 						' Same Team이 PartB에 더 많다. 
						setDataPart = E_HALF_A
					Else																					' 같은팀의 갯수가 같다. 
						If(player_orderA > player_orderB)	Then					' SameTeam이고 player order가 A쪽이 더 크다면 B에 데이터를 넣는다. 
							setDataPart = E_HALF_B
						ElseIf(player_orderA < player_orderB)	Then 			' SameTeam이고 player order가 B쪽이 더 크다면 A에 데이터를 넣는다. 
							setDataPart = E_HALF_A
						Else 
							If(set_cntA > set_cntB) Then 							' Same TeamCnt, Same Player Order => 할당한 인원이 A가 많다면 B에 데이터를 넣는다.
								setDataPart = E_HALF_B
							Else 
								setDataPart = E_HALF_A
							End If 			' If(set_cntA > set_cntB)				
						End If 				' If(player_orderA > player_orderB)
					End If 					' If(cnt_teamA > cnt_teamB)

					If(setDataPart = E_HALF_A) Then 
						Call CopyRows(rAryUser, rAryUserA, Idx, set_cntA)
						set_cntA = set_cntA + 1
						If(set_cntA >= user_cntA) Then setOneSide = E_HALF_B End If 	' Part A가 풀이다. B에 넣자 
					ElseIf(setDataPart = E_HALF_B) Then 
						Call CopyRows(rAryUser, rAryUserB, Idx, set_cntB)
						set_cntB = set_cntB + 1		
						If(set_cntB >= user_cntB) Then setOneSide = E_HALF_A End If 	' Part B가 풀이다. A에 넣자 
					End If
				End If  
			End If 
		Next 

		' 임시적으로 사용한 fUse Field rAry(0, Idx)의 값을 초기화 한다. 
		Call exResetFUseTeamCnt(rAryUserA)
		Call exResetFUseTeamCnt(rAryUserB)
	End Function 

'   ===============================================================================     
'     aryUser에서 teamOrder를 입력받아 playerOrder, cntTeam, cntSet 를 계산하여 넘겨준다. 
				' playerOrder : 팀내 선수 Order ( 1, 2, 3 ... 장 선수 )
				' cntTeam: teamOrder와 같은 팀원 수 
				' cntSet : 전체 할당된 User 수 
'   =============================================================================== 
	Function exFindTeamInfo(rAryUser, teamOrder, ByRef playerOrder, ByRef cntTeam, ByRef cntSet )
		Dim ub, Idx 

		playerOrder = 0
		cntTeam			= 0
		cntSet			= 0

		ub = UBound(rAryUser, 2)

		For Idx = 0 To ub 
			If(rAryUser(0, Idx) = "") Then 
				Exit For 	
			Else 
				cntSet = cntSet + 1		
			End If 
		Next 

		For Idx = 0 To cntSet-1
			If(rAryUser(1, Idx) = teamOrder) Then 
				cntTeam = cntTeam + 1
				If(playerOrder < CDbl(rAryUser(5, Idx)) ) Then playerOrder = CDbl(rAryUser(5, Idx)) End If 
			End If 
		Next 

	End Function  

   Function exDivAryUserDbl(rAryPosA, rAryPosB, rAryPosC, rAryPosD, rAryUserA, rAryUserB, rAryUserC, rAryUserD, rAryUser, IsDblGame)
      Dim cntPosA, cntPosB, cntPosC, cntPosD                   ' Count Of Position 
      Dim cntSeedA, cntSeedB, cntSeedC, cntSeedD               ' Count Of Seed
      Dim cntByeA, cntByeB, cntByeC, cntByeD                   ' Count Of Bye
      Dim cntUserA, cntUserB, cntUserC, cntUserD               ' Count Of User
      Dim cntQA, cntQB, cntQC, cntQD                           ' Count Of Qualify
      Dim aryUserA, aryUserB, aryUserC, aryUserD               ' array Of User
      Dim cntAssignA, cntAssignB, cntAssignC, cntAssignD       ' Count Of Assign User
      Dim cntFirstA, cntFirstB, cntFirstC, cntFirstD           ' 1장이 할당된 갯수 
      Dim cntTeamA, cntTeamB, cntTeamC, cntTeamD               ' Count Of Team - teamOrder와 일치하는 할당된 팀 User 수       
      Dim nCol, ub, Idx , assignPart, nCntOver

      cntPosA = UBound(rAryPosA, 2) + 1
      cntPosB = UBound(rAryPosB, 2) + 1
      cntPosC = UBound(rAryPosC, 2) + 1
      cntPosD = UBound(rAryPosD, 2) + 1

      nCntOver = cntPosA * 4

      nCol = UBound(rAryUser, 1)

      ' Seed Count를 구한다. 
      cntSeedA = exGetSpecialPosCnt(rAryPosA, E_POS_SEED, E_PART_ALL)
      cntSeedB = exGetSpecialPosCnt(rAryPosB, E_POS_SEED, E_PART_ALL)
      cntSeedC = exGetSpecialPosCnt(rAryPosC, E_POS_SEED, E_PART_ALL)
      cntSeedD = exGetSpecialPosCnt(rAryPosD, E_POS_SEED, E_PART_ALL)   

      ' Q(예선조) Count를 구한다. 
      cntQA = exGetSpecialPosCnt(rAryPosA, E_POS_Q, E_PART_ALL)
      cntQB = exGetSpecialPosCnt(rAryPosB, E_POS_Q, E_PART_ALL)
      cntQC = exGetSpecialPosCnt(rAryPosC, E_POS_Q, E_PART_ALL)
      cntQD = exGetSpecialPosCnt(rAryPosD, E_POS_Q, E_PART_ALL)

      ' Bye(Empty) Count를 구한다. 
      cntByeA = exGetSpecialPosCnt(rAryPosA, E_POS_BYE, E_PART_ALL)
      cntByeB = exGetSpecialPosCnt(rAryPosB, E_POS_BYE, E_PART_ALL)
      cntByeC = exGetSpecialPosCnt(rAryPosC, E_POS_BYE, E_PART_ALL)
      cntByeD = exGetSpecialPosCnt(rAryPosD, E_POS_BYE, E_PART_ALL)
      
      ' Q Count Or Bye Count 하나만 유효하다. (예선조가 있으면 Bye가 없고, Bye가 있으면 예선조가 없다. )
      cntUserA = (cntPosA - (cntQA + cntByeA)) * 2
      cntUserB = (cntPosB - (cntQB + cntByeB)) * 2
      cntUserC = (cntPosC - (cntQC + cntByeC)) * 2
      cntUserD = (cntPosD - (cntQD + cntByeD)) * 2

      ReDim aryUserA(nCol, cntUserA-1)      
      ReDim aryUserB(nCol, cntUserB-1)
      ReDim aryUserC(nCol, cntUserC-1)
      ReDim aryUserD(nCol, cntUserD-1)

      ' 3-1. aryUserA, aryUserB에 Seed를 적용한다. 
      Call exApplySeedFromPosDbl(rAryPosA, aryUserA, rAryUser)
      Call exApplySeedFromPosDbl(rAryPosB, aryUserB, rAryUser)
      Call exApplySeedFromPosDbl(rAryPosC, aryUserC, rAryUser)
      Call exApplySeedFromPosDbl(rAryPosD, aryUserD, rAryUser)

			Call exAssignUserDbl(aryUserA, aryUserB, aryUserC, aryUserD, rAryUser)

      rAryUserA = aryUserA
      rAryUserB = aryUserB
      rAryUserC = aryUserC
      rAryUserD = aryUserD
   End Function 

	 
'   ===============================================================================     
'     aryUser데이터를 Part A, B, C, D에 나누어 할당한다. ( binary search )
'   =============================================================================== 
	 Function exAssignUserDbl(rAryUserA, rAryUserB, rAryUserC, rAryUserD, rAryUser)
		Dim aryHalfA, aryHalfB
		Dim ubA, ubB, ubC, ubD, ubHA, ubHB , nCol 

		ubA = UBound(rAryUserA, 2)
		ubB = UBound(rAryUserB, 2)
		ubC = UBound(rAryUserC, 2)
		ubD = UBound(rAryUserD, 2)

		ubHA = (ubA + ubB) + 1
		ubHB = (ubC + ubD) + 1
		nCol = UBound(rAryUser, 1)

		ReDim aryHalfA(nCol, ubHA)      
    ReDim aryHalfB(nCol, ubHB)

		Call exMergeUserData(aryHalfA, rAryUserA)
		Call exMergeUserData(aryHalfA, rAryUserB)

		Call exMergeUserData(aryHalfB, rAryUserC)
		Call exMergeUserData(aryHalfB, rAryUserD)

		Call exAssignUserBinSearchDbl(aryHalfA, aryHalfB, rAryUser)

		Call exAssignUserBinSearchDbl(rAryUserA, rAryUserB, aryHalfA)
		Call exAssignUserBinSearchDbl(rAryUserC, rAryUserD, aryHalfB)

	 End Function 

'   ===============================================================================     
'     aryUser데이터를 Part A, B에 나누어 할당한다. ( binary search )
' 		임시적으로 fUse Field rAry(0, Idx)에 team Count를 셋팅하여 데이터 정렬에 사용한다. 
'     rAryUser(0, Idx)에 team count를 넣고 이를 가지고 sort를 한다음 
'     그 데이터로 분배한다. 
'   =============================================================================== 
	Function exAssignUserBinSearchDbl(rAryUserA, rAryUserB, rAryUser)
		Dim ub, Idx
		Dim player_orderA, player_orderB , cnt_teamA, cnt_teamB , team_order
		Dim set_cntA, set_cntB, user_cntA, user_cntB 
		Dim setOneSide, setDataPart
		Dim key, keyType, IsDesc
		
		user_cntA = UBound(rAryUserA, 2) + 1
		user_cntB = UBound(rAryUserB, 2) + 1
		ub 				= UBound(rAryUser, 2)

		setOneSide = -1
		setDataPart = 0

		' 임시적으로 fUse Field rAry(0, Idx)에 team Count를 셋팅하여 데이터 정렬에 사용한다. 
		Call exSetTeamCnt(rAryUser)

		key 				= 0				' team count
		keyType 		= 2				' data type is number 
		IsDesc 			= 1
		Call Sort2DimAryEx(rAryUser, key, keyType, IsDesc)	

		For Idx = 0 To ub Step 2			
			If(CDbl(rAryUser(2, Idx)) = 0) Then 				' Seed가 아니면.. (seed는 이미 배치했다. )
				team_order = rAryUser(1, Idx)
			
				If(setOneSide = E_HALF_A) Then 						' Part A에만 데이터를 넣어라 
					If(user_cntA > set_cntA) Then 
						Call CopyRows(rAryUser, rAryUserA, Idx, set_cntA)
						Call CopyRows(rAryUser, rAryUserA, Idx+1, set_cntA+1)
						set_cntA = set_cntA + 2						
					End If 
				ElseIf(setOneSide = E_HALF_B) Then 				' Part B에만 데이터를 넣어라 
					If(user_cntB > set_cntB) Then 
						Call CopyRows(rAryUser, rAryUserB, Idx, set_cntB)
						Call CopyRows(rAryUser, rAryUserB, Idx+1, set_cntB+1)
						set_cntB = set_cntB + 2
					End If 
				Else 																			' 이진 검색 결과에 의해 데이터를 넣어라 
					Call exFindTeamInfo(rAryUserA, team_order, player_orderA,cnt_teamA, set_cntA)
					Call exFindTeamInfo(rAryUserB, team_order, player_orderB,cnt_teamB, set_cntB)

					If(cnt_teamA > cnt_teamB) Then 								' Same Team이 PartA에 더 많다. 
						setDataPart = E_HALF_B		
					ElseIf(cnt_teamA < cnt_teamB) Then 						' Same Team이 PartB에 더 많다. 
						setDataPart = E_HALF_A
					Else																					' 같은팀의 갯수가 같다. 
						If(player_orderA > player_orderB)	Then					' SameTeam이고 player order가 A쪽이 더 크다면 B에 데이터를 넣는다. 
							setDataPart = E_HALF_B
						ElseIf(player_orderA < player_orderB)	Then 			' SameTeam이고 player order가 B쪽이 더 크다면 A에 데이터를 넣는다. 
							setDataPart = E_HALF_A
						Else 
							If(set_cntA+user_cntB > set_cntB+user_cntA) Then 							' Same TeamCnt, Same Player Order => 할당한 인원이 A가 많다면 B에 데이터를 넣는다.
								setDataPart = E_HALF_B
							Else 
								setDataPart = E_HALF_A
							End If 			' If(set_cntA > set_cntB)				
						End If 				' If(player_orderA > player_orderB)
					End If 					' If(cnt_teamA > cnt_teamB)

					If(setDataPart = E_HALF_A) Then 
						Call CopyRows(rAryUser, rAryUserA, Idx, set_cntA)
						Call CopyRows(rAryUser, rAryUserA, Idx+1, set_cntA+1)
						set_cntA = set_cntA + 2
						If(set_cntA >= user_cntA) Then setOneSide = E_HALF_B End If 	' Part A가 풀이다. B에 넣자 
					ElseIf(setDataPart = E_HALF_B) Then 
						Call CopyRows(rAryUser, rAryUserB, Idx, set_cntB)
						Call CopyRows(rAryUser, rAryUserB, Idx+1, set_cntB+1)
						set_cntB = set_cntB + 2		
						If(set_cntB >= user_cntB) Then setOneSide = E_HALF_A End If 	' Part B가 풀이다. A에 넣자 
					End If 
				End If  
			End If 
		Next 

		' 임시적으로 사용한 fUse Field rAry(0, Idx)의 값을 초기화 한다. 
		Call exResetFUseTeamCnt(rAryUserA)
		Call exResetFUseTeamCnt(rAryUserB)
	End Function 

'   ===============================================================================     
'     임시적으로 fUse Field rAry(0, Idx)에 team Count를 셋팅하여 데이터 정렬에 사용한다. 
'     ' 1장은 인원수 1000으로 셋팅 - 인원수에 상관없이 제일 먼저 분배 되어야 한다. 
'   =============================================================================== 
	Function exSetTeamCnt(rAryUser)
		Dim ub, Idx, cntTeam, s_pos, e_pos
		Dim key, keyType, IsDesc, team_order, team_cnt 

		ub = UBound(rAryUser, 2)

		key 				= 1				' player order
		keyType 		= 2				' data type is number 
		IsDesc 			= 0
		Call Sort2DimAryEx(rAryUser, key, keyType, IsDesc)		

		team_order = -1
		s_pos = -1
		e_pos = -1
		team_cnt = 0

		For Idx = 0 To ub 
			If team_order <> rAryUser(1, Idx) Then 
				If(s_pos = -1) Then 
					s_pos = Idx 
					team_cnt = 1
				Else 
					e_pos = Idx -1 
					Call exSetTeamCntInBlock(rAryUser, s_pos, e_pos, team_cnt) 
					s_pos = Idx 
					team_cnt = 1
				End If
				team_order = rAryUser(1, Idx)
			Else 
				team_cnt = team_cnt + 1
			End If 
		Next 

		e_pos = Idx -1 
		Call exSetTeamCntInBlock(rAryUser, s_pos, e_pos, team_cnt) 

	End Function 

'   ===============================================================================     
'     ary block을 받아 team_cnt를 셋팅한다. 
'   =============================================================================== 
	Function exSetTeamCntInBlock(rAryUser, s_pos, e_pos, team_cnt)
		Dim Idx 

		' 1장은 인원수 1000으로 셋팅 - 인원수에 상관없이 제일 먼저 분배 되어야 한다. 
		For Idx = s_pos To e_pos 
			If(CDbl(rAryUser(5, Idx)) = 1) Then 
				rAryUser(0, Idx) = 1000 
			Else 
				rAryUser(0, Idx) = team_cnt 
			End If 	
		Next 
	End Function 

'   ===============================================================================     
'     임시적으로 fUse Field rAry(0, Idx)에 team Count를 셋팅하였던 것을 초기화 한다. 
'   =============================================================================== 
	Function exResetFUseTeamCnt(rAryUser)
		Dim ub, Idx 
		ub = UBound(rAryUser, 2) 

		For Idx = 0 To ub 
			If(CDbl(rAryUser(2, Idx)) <> 0) Then 				' Seed이면 이미 배치 했으므로 1을 셋팅 
				rAryUser(0, Idx) = 1
			Else 
				rAryUser(0, Idx) = 0
			End If 	
		Next 
	End Function 

'   ===============================================================================     
'     aryUser에 aryPos으로 부터 Seed Data를 적용한다. seed no를 가지고 데이터를 할당한다. 
'   =============================================================================== 
   Function exApplySeedFromPos(rAryPos, rAryUser, rArySrc)
      Dim ub, Idx, seedNo, userIdx, cnt  

      cnt = 0
      ub = UBound(rAryPos, 2)
      For Idx = 0 To ub
         If(rAryPos(2,Idx) = E_POS_SEED) Then 
            seedNo = rAryPos(3,Idx)
            userIdx = exFindUserWithSeed(rArySrc, seedNo)

            If(userIdx <> -1) Then 
               rArySrc(0, userIdx) = 1
               Call CopyRows(rArySrc, rAryUser, userIdx, cnt)
               cnt = cnt + 1
            End If 
         End If 
      Next  
   End Function 

'   ===============================================================================     
'     SeedNo를 가지고 aryUser로 부터 User Idx를 얻는다. 
'   =============================================================================== 
   Function exFindUserWithSeed(rAryUser, seedNo)
      Dim ub, Idx, userIdx 

      userIdx = -1

      ub = UBound(rAryUser, 2)
      For Idx = 0 To ub
         If( rAryUser(2, Idx) = seedNo ) Then 
            userIdx = Idx 
            Exit For 
         End If 
      Next  

      exFindUserWithSeed = userIdx 
   End Function 

'   ===============================================================================     
'     aryUser에 aryPos으로 부터 Seed Data를 적용한다. seed no를 가지고 데이터를 할당한다. 
'   =============================================================================== 
   Function exApplySeedFromPos(rAryPos, rAryUser, rArySrc)
      Dim ub, Idx, seedNo, userIdx, cnt  

      cnt = 0
      ub = UBound(rAryPos, 2)
      For Idx = 0 To ub
         If(rAryPos(2,Idx) = E_POS_SEED) Then 
            seedNo = rAryPos(3,Idx)
            userIdx = exFindUserWithSeed(rArySrc, seedNo)

            If(userIdx <> -1) Then 
               rArySrc(0, userIdx) = 1
               Call CopyRows(rArySrc, rAryUser, userIdx, cnt)
               cnt = cnt + 1
            End If 
         End If 
      Next  
   End Function 

'   ===============================================================================     
'     aryUser에 aryPos으로 부터 Seed Data를 적용한다. seed no를 가지고 데이터를 할당한다. 
'   =============================================================================== 
   Function exApplySeedFromPosDbl(rAryPos, rAryUser, rArySrc)
      Dim ub, Idx, seedNo, userIdx, userIdx2, cnt  

      cnt = 0
      ub = UBound(rAryPos, 2)
      For Idx = 0 To ub
         If(rAryPos(2,Idx) = E_POS_SEED) Then 
            seedNo = rAryPos(3,Idx)
            userIdx = exFindUserWithSeed(rArySrc, seedNo)

            ' get partner 
            userIdx2 = exGetPartnerIdx(userIdx)

            If(userIdx <> -1) Then 
               rArySrc(0, userIdx) = 1
               rArySrc(0, userIdx2) = 1
               Call CopyRows(rArySrc, rAryUser, userIdx, cnt)
               Call CopyRows(rArySrc, rAryUser, userIdx2, cnt+1)
               cnt = cnt + 2
            End If 
         End If 
      Next  
   End Function 

'   ===============================================================================     
'     SeedNo를 가지고 aryUser로 부터 User Idx를 얻는다. 
'   =============================================================================== 
   Function exFindUserWithSeed(rAryUser, seedNo)
      Dim ub, Idx, userIdx 

      userIdx = -1

      ub = UBound(rAryUser, 2)
      For Idx = 0 To ub
         If( rAryUser(2, Idx) = seedNo ) Then 
            userIdx = Idx 
            Exit For 
         End If 
      Next  

      exFindUserWithSeed = userIdx 
   End Function 

'   ===============================================================================     
'     aryUser에 할당된 인원수를 반환한다. 
'   =============================================================================== 
   Function exGetCntAssign(rAry)
      Dim ub, Idx , cnt 

      ub = UBound(rAry, 2)
      cnt = 0

      For Idx = 0 To ub 
         If(rAry(0, Idx) = "") Then 
            Exit For 
         Else 
            cnt = cnt + 1
         End If 
      Next 

      exGetCntAssign = cnt 
   End Function 

'   ===============================================================================     
'     aryUser에 할당된 1장 (PlayerOrder = 1) Count 반환한다. 
'   =============================================================================== 
   Function exGetCntAssignFirstMan(rAry)
      Dim ub, Idx , cnt 

      ub = UBound(rAry, 2)
      cnt = 0

      For Idx = 0 To ub 
         If(rAry(0, Idx) = "") Then 
            Exit For 
         Else 
            If(rAry(5, Idx) = "1") Then cnt = cnt + 1 End If 
         End If 
      Next 

      exGetCntAssignFirstMan = cnt 
   End Function 

'   ===============================================================================     
'     aryUser에 할당된 인원중 teamOrder를 가지고 있는 인원을 반환한다. 
'   =============================================================================== 
   Function exGetCntAssignTeam(rAry, teamOrder)
      Dim ub, Idx , cnt 

      ub = UBound(rAry, 2)
      cnt = 0

      For Idx = 0 To ub 
         If(rAry(0, Idx) = "") Then 
            Exit For 
         Else 
            If(rAry(1, Idx) = teamOrder) Then 
               cnt = cnt + 1
            End If
         End If 
      Next 

      exGetCntAssignTeam = cnt 
   End Function 

'   ===============================================================================     
'      aryQUser로 부터 aryQPos에 User를 할당한다.                    - 단식 
'        1. aryQUser로 부터 aryTeam을 구한다. 
'        2. aryTeam을 인원수 많은 순으로 sort한다. 
'        3. aryTeam의 인원을 순차적으로 aryQPos에 배분한다. 
'        4. 인원은 szBlock단위로 배분한다. 
'        5. 인원은 1, 4, 2, 3의 순으로 배분한다. 
'        6. block에 더이상 공간이 없으면 다음 block으로 넘어간다. 
'   ===============================================================================  

	Function exSetQUser(rAryQPos, rAryQUser, rAryQTPos, IsDblGame)
		Dim Idx, ub, teamOrder , userIdx
		Dim sort_type, sort_desc, sort_key
		Dim fLoop, nLoopCnt, nLoopMax, emptyPos
		Dim szBlock, nQGroup, nQMax, sp
		Dim key, keyType, IsDesc

		szBlock = CON_QGROUP_USER 

		If(IsDblGame = 1) Then 
				Call exSetQUserDbl(rAryQPos, rAryQUser, rAryQTPos, IsDblGame)
				Exit Function 
		End If 

		' 임시적으로 fUse Field rAry(0, Idx)에 team Count를 셋팅하여 데이터 정렬에 사용한다. 
		Call exSetTeamCnt(rAryQUser)

		key 				= 0				' team count
		keyType 		= 2				' data type is number 
		IsDesc 			= 1
		Call Sort2DimAryEx(rAryQUser, key, keyType, IsDesc)	

		ub = UBound(rAryQUser, 2)

		For Idx = 0 To ub 
			Call exSetUserToQPos(rAryQPos, rAryQTPos, rAryQUser, Idx)
		Next 
	End Function 

'   ===============================================================================     
'      실제적으로 aryQPos에 사용자를 할당한다. 
'      본선의 QBlock Data와 할당된 QPos Data를 teamOrder로 비교하여 값을 할당할 위치를 찾는다. 
'      1. 본선의 QBlock Data, 할당된 QPos Data 와 겹치는게 없다. 
'      2. 할당된 QPos Data 와 겹치는게 없다.
'      3. 할당된 QPos Data의 최소값에서 위치를 찾는다. 
'      4. 위치를 할당 하지 못했을 경우 빈자리를 찾는다. 
'      5. 랜덤하게 할당한다. 
'   ===============================================================================  
	Function exSetUserToQPos(rAryQPos, rAryQTPos, rAryQUser, userIdx)
		Dim ub, Idx, nQMax, strQCnt, strQDataCnt
		Dim aryQCnt, aryQDataCnt , aryInsert
		Dim teamOrder , minQCnt, cntQ, cntQData 
		Dim strPossible, aryPossible, nCnt 

		ub = UBound(rAryQPos, 2)
		nQMax = (ub+1) / CON_QGROUP_USER

		teamOrder = rAryQUser(1, userIdx)
		strQCnt 	= exGetSameTeamCntFromQPos(rAryQPos, teamOrder)
		strQDataCnt = exGetSameTeamCntFromQPos(rAryQTPos, teamOrder)

		aryQCnt = Split(strQCnt, ",")
		aryQDataCnt = Split(strQDataCnt, ",")

		ReDim aryInsert(nQMax-1)
		minQCnt 			= 100
		
		For Idx = 0 To nQMax-1
			cntQ 					= CDbl(aryQCnt(Idx))
			cntQData 			= CDbl(aryQDataCnt(Idx))

			' 최소값을 구한다. 
			If(minQCnt > cntQ) Then minQCnt = cntQ End If 
					
			If(cntQ = 0 And cntQData = 0) Then 
				If(strPossible = "") Then 
					strPossible = sprintf("{0}", Array(Idx))
				Else 
					strPossible = sprintf("{0},{1}", Array(strPossible, Idx))
				End If 
			End If
		Next 
		
		If(strPossible = "") Then 
			strPossible = FindQInsertPos(aryQCnt, aryQDataCnt, minQCnt)
		End If 

		If(strPossible = "") Then 			' 위치를 못찾았다. 빈자리에 Random하게 넣자 
			strPossible = FindEmptyQBlock(rAryQPos)
		End If 

		If(strPossible <> "") Then 											
			aryPossible = Split(strPossible, ",")
		End If 

		' 넣을 위치를 랜덤하게 찾는다. 
		ub = UBound(aryPossible)
		rNum = GetRandomNum(ub+1) -1

		pos = CDbl(aryPossible(rNum)) * CON_QGROUP_USER

'		strLog = sprintf("user = {0}, team = {1}, rNum = {2}, aryPossible(rNum) = {3}, pos = {4}", _ 
'											Array(rAryQUser(9, userIdx), rAryQUser(11, userIdx), rNum, aryPossible(rNum), pos ) )
'		Call TraceLog(SAMALL_LOG1, strLog)

		Call exSetQUserInBlock(rAryQPos, rAryQUser, userIdx, pos, CON_QGROUP_USER)

	End Function 

	Function FindQInsertPos(rAryQCnt, rAryQDataCnt, minQCnt)
		Dim ub, Idx, strRet, minCnt , cntQ, cntQData  

		ub = UBound(rAryQCnt)
		minCnt = 100

		' rAryQCnt가 최소값일때 rAryQDataCnt의 최소값을 구함. 
		For Idx = 0 To ub
			cntQ 			= CDbl(rAryQCnt(Idx))
			cntQData 	= CDbl(rAryQDataCnt(Idx))

			If( cntQ = minQCnt) Then 
				If( minCnt > cntQData ) Then minCnt = cntQData End If 
			End If 
		Next 

		For Idx = 0 To ub
			cntQ 			= CDbl(rAryQCnt(Idx))
			cntQData 	= CDbl(rAryQDataCnt(Idx))

			If( cntQ = minQCnt) And ( cntQData = minCnt) Then 
				If(strRet = "") Then 
					strRet = sprintf("{0}", Array(Idx))
				Else 
					strRet = sprintf("{0},{1}", Array(strRet, Idx))
				End If 
			End If 
		Next 

		FindQInsertPos = strRet 
	End Function 

	Function FindEmptyQBlock(rAryQPos)
		Dim ub, Idx, strRet , s_pos, e_pos, has_empty

		ub = UBound(rAryQCnt)

		For Idx = 0 To ub Step CON_QGROUP_USER
			s_pos = Idx
			e_pos = (s_pos + CON_QGROUP_USER) -1

			has_empty = 0
			For k = s_pos To e_pos
				If(rAryQPos(0, k) = 0) Then 
					has_empty = 1
					Exit For 
				End If  
			Next 

			If(has_empty = 1) Then 
				If(strRet = "") Then 
					strRet = sprintf("{0}", Array(Idx))
				Else 
					strRet = sprintf("{0},{1}", Array(strRet, Idx))
				End If 
			End If 				
		Next 

		FindEmptyQBlock = strRet 
	End Function 

	Function exGetSameTeamCntFromQPos(rAryPos, teamOrder)
		Dim ub, Idx, strCnt, nCnt , s_pos, e_pos , alloc_cnt
		ub = UBound(rAryPos, 2)
		
		For Idx = 0 To ub Step CON_QGROUP_USER
			s_pos = Idx 
			e_pos = (Idx + CON_QGROUP_USER) -1 
			
			nCnt = 0
			alloc_cnt = 0
			For m = s_pos To e_pos
				If(rAryPos(5, m) = teamOrder) Then 
					nCnt = nCnt + 1
				End If 
				If(rAryPos(0, m) = 1) Then 
					alloc_cnt = alloc_cnt + 1
				End If 
			Next 

			If(alloc_cnt = CON_QGROUP_USER) Then nCnt = CON_QGROUP_USER End If 

			If(Idx = 0) Then 
				strCnt = sprintf("{0}", Array(nCnt))
			Else 
				strCnt = sprintf("{0},{1}", Array(strCnt, nCnt))
			End If 
		Next 
		

		exGetSameTeamCntFromQPos = strCnt 
	End Function 

'   ===============================================================================     
'      aryQUser로 부터 aryQPos에 User를 할당한다.              - 복식 
'        1. aryQUser로 부터 aryTeam을 구한다. 
'        2. aryTeam을 인원수 많은 순으로 sort한다. 
'        3. aryTeam의 인원을 순차적으로 aryQPos에 배분한다. 
'        4. 인원은 szBlock단위로 배분한다. 
'        5. 인원은 1, 4, 2, 3의 순으로 배분한다. 
'        6. block에 더이상 공간이 없으면 다음 block으로 넘어간다. 
'   ===============================================================================  
   	Function exSetQUserDbl(rAryQPos, rAryQUser, rAryQTPos, IsDblGame)
		Dim Idx, ub, teamOrder , userIdx
		Dim sort_type, sort_desc, sort_key
		Dim fLoop, nLoopCnt, nLoopMax, emptyPos
		Dim szBlock, nQGroup, nQMax, sp
		Dim key, keyType, IsDesc

		szBlock = CON_QGROUP_USER 

		' 임시적으로 fUse Field rAry(0, Idx)에 team Count를 셋팅하여 데이터 정렬에 사용한다. 
		Call exSetTeamCnt(rAryQUser)

		key 				= 0				' team count
		keyType 		= 2				' data type is number 
		IsDesc 			= 1
		Call Sort2DimAryEx(rAryQUser, key, keyType, IsDesc)	
			
		ub = UBound(rAryQUser, 2)

		For Idx = 0 To ub Step 2
			Call exSetUserToQPosDbl(rAryQPos, rAryQTPos, rAryQUser, Idx)
		Next 
	End Function 

'   ===============================================================================     
'      실제적으로 aryQPos에 사용자를 할당한다. 
'      본선의 QBlock Data와 할당된 QPos Data를 teamOrder로 비교하여 값을 할당할 위치를 찾는다. 
'      1. 본선의 QBlock Data, 할당된 QPos Data 와 겹치는게 없다. 
'      2. 할당된 QPos Data 와 겹치는게 없다.
'      3. 할당된 QPos Data의 최소값에서 위치를 찾는다. 
'      4. 위치를 할당 하지 못했을 경우 빈자리를 찾는다. 
'      5. 랜덤하게 할당한다. 
'   ===============================================================================  
	Function exSetUserToQPosDbl(rAryQPos, rAryQTPos, rAryQUser, userIdx)
		Dim ub, Idx, nQMax, strQCnt, strQDataCnt
		Dim aryQCnt, aryQDataCnt , aryInsert
		Dim minQCnt, cntQ, cntQData 
		Dim strPossible, aryPossible, nCnt 
		Dim userIdx2, teamOrder, teamOrder2

		ub = UBound(rAryQPos, 2)
		nQMax = (ub+1) / CON_QGROUP_USER

		userIdx2  = userIdx + 1

		teamOrder = rAryQUser(1, userIdx)		

		strQCnt 	= exGetSameTeamCntFromQPos(rAryQPos, teamOrder)
		strQDataCnt = exGetSameTeamCntFromQPos(rAryQTPos, teamOrder)

		aryQCnt = Split(strQCnt, ",")
		aryQDataCnt = Split(strQDataCnt, ",")

		ReDim aryInsert(nQMax-1)
		minQCnt 			= 100
		
		For Idx = 0 To nQMax-1
			cntQ 					= CDbl(aryQCnt(Idx))
			cntQData 			= CDbl(aryQDataCnt(Idx))

			' 최소값을 구한다. 
			If(minQCnt > cntQ) Then minQCnt = cntQ End If 
					
			If(cntQ = 0 And cntQData = 0) Then 
				If(strPossible = "") Then 
					strPossible = sprintf("{0}", Array(Idx))
				Else 
					strPossible = sprintf("{0},{1}", Array(strPossible, Idx))
				End If 
			End If
		Next 
		
		If(strPossible = "") Then 
			strPossible = FindQInsertPos(aryQCnt, aryQDataCnt, minQCnt)
		End If 

		If(strPossible = "") Then 			' 위치를 못찾았다. 빈자리에 Random하게 넣자 
			strPossible = FindEmptyQBlock(rAryQPos)
		End If 

		If(strPossible <> "") Then 											
			aryPossible = Split(strPossible, ",")
		End If 

		' 넣을 위치를 랜덤하게 찾는다. 
		ub = UBound(aryPossible)
		rNum = GetRandomNum(ub+1) -1

		pos = CDbl(aryPossible(rNum)) * CON_QGROUP_USER

'		strLog = sprintf("user = {0}, team = {1}, rNum = {2}, aryPossible(rNum) = {3}, pos = {4}", _ 
'											Array(rAryQUser(9, userIdx), rAryQUser(11, userIdx), rNum, aryPossible(rNum), pos ) )
'		Call TraceLog(SAMALL_LOG1, strLog)
		Call exSetQUserInBlockDbl(rAryQPos, rAryQUser, userIdx, userIdx2, pos, CON_QGROUP_USER)

	End Function 

'   ===============================================================================     
'      aryQPos에 aryQUser를 할당한다.        - 단식 
'      sp로 부터 block 단위로 구분한다. 
'      1, 4, 3, 2 순으로 user를 배치한다. 
'   ===============================================================================  
   Function exSetQUserInBlock(rAryQPos, rAryQUser, userIdx, sp, szBlock)
      Dim Idx, ub, ret, aryIdx, strIdx, pos
      strIdx = "1,4,3,2"
      aryIdx = Split(strIdx, ",")
      ub = UBound(aryIdx)      

      For Idx = 0 To ub
         pos = (aryIdx(Idx) + sp) - 1        ' position은 0 Idx부터 시작 
         If(rAryQPos(0, pos) = 0) Then 
            Exit For
         End If 
      Next 

      ' pos에 넣기만 하면 된다. fUse, pos, pos_kind, pos_val, playerCode(gGroupIdx), cUser, user, cTeam, team
      rAryQPos(0, pos) = 1       ' fUse      
      rAryQPos(4, pos) = rAryQUser(6, userIdx)        ' playerCode
      rAryQPos(5, pos) = rAryQUser(1, userIdx)        ' teamOrder
      rAryQPos(6, pos) = rAryQUser(8, userIdx)        ' cUser
      rAryQPos(7, pos) = rAryQUser(9, userIdx)        ' user
      rAryQPos(8, pos) = rAryQUser(10, userIdx)       ' cTeam
      rAryQPos(9, pos) = rAryQUser(11, userIdx)       ' team
			rAryQPos(10, pos) = rAryQUser(5, userIdx)       ' player Order
      
   End Function 

'   ===============================================================================     
'      aryQPos에 aryQUser를 할당한다.        - 복식 
'      sp로 부터 block 단위로 구분한다. 
'      1, 4, 3, 2 순으로 user를 배치한다. 
'   ===============================================================================  
   Function exSetQUserInBlockDbl(rAryQPos, rAryQUser, userIdx, userIdx2, sp, szBlock)
      Dim Idx, ub, ret, aryIdx, strIdx, pos, user1, user2
      strIdx = "1,4,3,2"
      aryIdx = Split(strIdx, ",")
      ub = UBound(aryIdx)      

      For Idx = 0 To ub
         pos = (aryIdx(Idx) + sp) - 1        ' position은 0 Idx부터 시작 
         If(rAryQPos(0, pos) = 0) Then 
            Exit For
         End If 
      Next 

      If(userIdx > userIdx2) Then 
         user1 = userIdx2
         user2 = userIdx
      Else
         user1 = userIdx
         user2 = userIdx2
      End If 

      ' pos에 넣기만 하면 된다. 
      ' fUse, pos, pos_kind, pos_val, playerCode(gGroupIdx), cUser1, user1, cUser2, user2, cTeam1, team1, cTeam2, team2
      rAryQPos(0, pos) = 1       ' fUse      
      rAryQPos(4, pos) = rAryQUser(6, user1)        ' playerCode
      rAryQPos(5, pos) = rAryQUser(1, user1)        ' cUser
      rAryQPos(6, pos) = rAryQUser(8, user1)        ' cUser
      rAryQPos(7, pos) = rAryQUser(9, user1)        ' user
      rAryQPos(8, pos) = rAryQUser(8, user2)        ' cUser
      rAryQPos(9, pos) = rAryQUser(9, user2)        ' user
      rAryQPos(10, pos) = rAryQUser(10, user1)       ' cTeam
      rAryQPos(11, pos) = rAryQUser(11, user1)       ' team
      rAryQPos(12, pos) = rAryQUser(10, user2)       ' cTeam
      rAryQPos(13, pos) = rAryQUser(11, user2)       ' team
			rAryQPos(14, pos) = rAryQUser(5, user2)       ' player Order
      
   End Function 

'   ===============================================================================     
'      aryQPos의 block에 빈 공간이 있는지 확인한다. 
'   ===============================================================================  
   Function exHasPlaceInBlock(rAryPos, sp, szBlock)
      Dim Idx, ub, ret
      ub = sp + szBlock - 1
      ret = 0

      For Idx = sp To ub         
         If(rAryPos(0, Idx) = 0) Then 
            ret = 1
            Exit For
         End If 
      Next 

      exHasPlaceInBlock = ret
   End Function 

'   ===============================================================================     
'      team order를 입력받아 , userIdx를 구한다. 
'   ===============================================================================  
   Function exGetUserIdx(rAryUser, teamOrder)
      Dim Idx, ub, ret
      ub = UBound(rAryUser, 2)
      ret = -1

      For Idx = sp To ub         
         If(rAryUser(0, Idx) = 0) And (rAryUser(1, Idx) = teamOrder) Then 
            ret = Idx
            rAryUser(0, Idx) = 1
            Exit For
         End If 
      Next 

      exGetUserIdx = ret
   End Function 
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

      ' ary Tournament User, ary Qualifier User Redefine 
      ReDim rAryTUser(CON_USERCOL_CNT-1, nTour-1)
      ReDim rAryQUser(CON_USERCOL_CNT-1, nQUser-1)

      For Idx = 0 To ub 
         If(Idx < nTour) Then 
            Call CopyRows(rAryReq, rAryTUser, Idx, Idx)
         Else 
            Call CopyRows(rAryReq, rAryQUser, Idx, Idx-nTour)
         End If 
      Next 
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

      ' ary Tournament User, ary Qualifier User Redefine 
      ReDim rAryTUser(CON_USERCOL_CNT-1, nTour-1)
      ReDim rAryQUser(CON_USERCOL_CNT-1, nQUser-1)

      For Idx = 0 To ub Step 2
         If(Idx < nTour) Then 
            Call CopyRows(rAryReq, rAryTUser, Idx, Idx)
            Call CopyRows(rAryReq, rAryTUser, Idx+1, Idx+1)
         Else 
            Call CopyRows(rAryReq, rAryQUser, Idx, Idx-nTour)
            Call CopyRows(rAryReq, rAryQUser, Idx+1, (Idx+1)-nTour)
         End If 
      Next 
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
      nSeedA = exGetSpecialPosCnt(rAryPos, E_POS_SEED, E_HALF_A)
      nSeedB = exGetSpecialPosCnt(rAryPos, E_POS_SEED, E_HALF_B)
      nSeedCnt = nSeedA + nSeedB 
      nSeedDiff = Abs(nSeedA - nSeedB)

      ' Q Count를 구한다. 
      IsDupSeed = 0
      tmpA = nSeedA
      tmpB = nSeedB 
      For Idx = 0 To nQMaxGroup-1     ' Q와 Seed는 겹치지 않는다. Q를 갯수만큼 Random하게 배치한다. 
         If(Idx Mod 2 = 0) Then 
            If (tmpA = 0) Then         ' Empty Block에 Q를 할당한다. 
               Call exSetQPos(rAryPos, IsDupSeed, nQOrder, E_HALF_A)
               nQOrder = nQOrder + 1
            Else 
               tmpA = tmpA - 1
            End If 
         Else 
            If (tmpB = 0) Then         ' Empty Block에 Q를 할당한다. 
               Call exSetQPos(rAryPos, IsDupSeed, nQOrder, E_HALF_B)
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
               Call exSetQPos(rAryPos, IsDupSeed, nQOrder, E_HALF_A)
               nQOrder = nQOrder + 1               
               nSeedA = nSeedA - 1
               nRemain = nRemain - 1

            End If 
            
            If(nSeedB <> 0 And nRemain > 0) Then 
               Call exSetQPos(rAryPos, IsDupSeed, nQOrder, E_HALF_B)
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
      
      If(nPart = E_HALF_A) Then 
         sp = 0
         ep = nHalf - 1
      ElseIf(nPart = E_HALF_B) Then 
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
      cnt  = 0
      For Idx = sp To ep step CON_DEF_BLOCKSZ         ' Q or Seed 는 4개 pos에 1개 위치할수 있다. 
         sp1 = Idx
         ep1 = sp1 + (CON_DEF_BLOCKSZ-1)
         
         If(exHasOnlyValBlock(rAryPos, sp1, ep1, spVal) = 1) Then 
            If(cnt = rNum) Then 
               If(nPart = E_HALF_A) Then              ' A part seed pos = 1, Q pos = 3
                  posQ = sp1 + 2
               ElseIf(nPart = E_HALF_B) Then          ' B part seed pos = 4, Q pos = 2
                  posQ = sp1 + 1
               End If 
               rAryPos(0, posQ) = 1                   ' fuse - Q를 할당하였다. 
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
'     Seed를 할당한다. 
'   ===============================================================================  
   Function exSetSeedToPos(rAryPos, rAryReq, nRound, IsDblGame )
      Dim arySeed, Idx, ub, pos, nSeed, nBase
      nBase = 1

      If(IsDblGame=1) Then nBase = 2

      arySeed = exGetArySeedPos(nRound)	   ' seed pos은 미리 시스템에 정의 되어 있다. 
      ub = UBound(rAryReq, 2)
      ubb = UBound(rAryReq, 1)

      For Idx = 0 To ub Step nBase
         nSeed = rAryReq(2,Idx)
         If(nSeed <> 0) Then  ' Seed가 있다면 aryPos에 Seed를 설정한다. 
            pos = exGetSeedPos(rAryPos, arySeed, nSeed)
            Call exSetSeedData(rAryPos, rAryReq, pos, Idx, IsDblGame)  
         End If 
      Next 
   End Function 

'   ===============================================================================     
'     aryPos에 aryReq로 부터 seeddata를 Setting한다. 
'   ===============================================================================   
   Function exSetSeedData(rAryPos, rAryReq, seedPos, userPos, IsDblGame)
      rAryPos(0,seedPos) = 1                          ' fuse - Seed를 할당하였다. 
      rAryPos(2,seedPos) = E_POS_SEED                 ' seed 
      rAryPos(3,seedPos) = rAryReq(2,userPos)         ' seed value
      rAryPos(4,seedPos) = rAryReq(6,userPos)         ' playerCode - GroupIdx
      rAryPos(5,seedPos) = rAryReq(1,userPos)         ' team order

      If(IsDblGame = 1) then          
         rAryPos(6,seedPos) = rAryReq(8,userPos)         ' cUser1
         rAryPos(7,seedPos) = rAryReq(9,userPos)         ' user1
         rAryPos(8,seedPos) = rAryReq(8,userPos+1)         ' cUser2
         rAryPos(9,seedPos) = rAryReq(9,userPos+1)         ' user2

         rAryPos(10,seedPos) = rAryReq(10,userPos)         ' cTeam1
         rAryPos(11,seedPos) = rAryReq(11,userPos)        ' team1
         rAryPos(12,seedPos) = rAryReq(10,userPos+1)        ' cTeam2
         rAryPos(13,seedPos) = rAryReq(11,userPos+1)        ' team2
				 rAryPos(14,seedPos) = rAryReq(5,userPos+1)        ' player order
      Else 
         rAryPos(6,seedPos) = rAryReq(8,userPos)         ' cUser
         rAryPos(7,seedPos) = rAryReq(9,userPos)         ' user
         rAryPos(8,seedPos) = rAryReq(10,userPos)         ' cTeam
         rAryPos(9,seedPos) = rAryReq(11,userPos)         ' team
				 rAryPos(10,seedPos) = rAryReq(5,userPos+1)        ' player order
      End If 
   End Function 

'   ===============================================================================     
'     special position Count를 얻는다. 
'   ===============================================================================  
   Function exGetSpecialPosCnt(rAryPos, specalVal, nPart)      
      Dim Idx, ub, nCntVal, sPos, ePos, nCnt
      ub = UBound(rAryPos, 2)
      nCnt = ((ub+1) / 4) 
      nCntVal = 0

      If(nPart = E_PART_A) Then 
         sPos = 0
         ePos = nCnt -1
      ElseIf(nPart = E_PART_B) Then  
         sPos = nCnt
         ePos = (nCnt*2)-1
      ElseIf(nPart = E_PART_C) Then  
         sPos = (nCnt*2)
         ePos = (nCnt*3)-1
      ElseIf(nPart = E_PART_D) Then  
         sPos = (nCnt*3)
         ePos = ub
      ElseIf(nPart = E_HALF_A) Then  
         sPos = 0
         ePos = (nCnt*2)-1
      ElseIf(nPart = E_HALF_B) Then  
         sPos = (nCnt*2)
         ePos = ub
      ElseIf(nPart = E_PART_ALL) Then  
         sPos = 0
         ePos = ub
      End If 

      For Idx = sPos To ePos
         If(rAryPos(2,Idx) = specalVal) Then nCntVal = nCntVal + 1 End If 
      Next

      exGetSpecialPosCnt = nCntVal
   End Function

'   ===============================================================================     
'     aryUser로 부터 TeamInfo ary를 얻는다. 
'   =============================================================================== 
   Function exCreateTeamInfo(rAryUser)
      Dim ub, Idx, aryInfo, aryTmp, teamOrder, cnt, tIdx
      Dim nAve, nHalf, nUser, nTotal, nCntUser
      Dim sort_type, sort_desc, sort_key

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
            aryInfo(1, Idx) = E_TEAMCNT_AVEOVER
         Else
            aryInfo(1, Idx) = E_TEAMCNT_NORMAL
         End If 
      Next 

      ' 2. aryTeam을 인원수 많은 순으로 sort한다. 
      sort_type = 2
      sort_desc = 1
      sort_key  = 6
      Call Sort2DimAryEx(aryInfo, sort_key, sort_type, sort_desc)

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
'      aryInfo : Reset fUse , aryPos, aryUser등의 fUse를 0으로 Reset
'   ===============================================================================
   Function exResetfUse(rAryInfo)
      Dim Idx, ub      
      ub = UBound(rAryInfo, 2)

      For Idx = 0 To ub 
         rAryInfo(0, Idx) = 0
      Next
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
				rAryTeam(0, k) = -1               ' 제일 마지막에 삭제 표시를 한후 한칸 당기면, 기존에 삭제 표시된 것도 한칸 앞으도 당겨진다. 
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

'   ===============================================================================     
'     team을 입력받아  rAryUser에서 User를 하나 선택한다. 
'     해당하는 Team에 더이상 선수가 없으면 -1을 Return한다. 
'     복식 / 단식 구분없이 실행한다. 
'   ===============================================================================
   Function exGetSelUser(rAryUser, teamOrder)
      Dim Idx, ub, selUser, rNum, cnt, cntUser 

      cntUser = exGetUserCntInTeam(rAryUser, teamOrder)
      rNum = GetRandomNum(cntUser) - 1
      selUser = -1
      ub = UBound(rAryUser, 2)

      cnt = 0
      For Idx = 0 To ub
         If(rAryUser(0,Idx) = 0) And (rAryUser(1,Idx) = teamOrder) Then 
            If(cnt = rNum) Then 
               selUser = Idx
               rAryUser(0, Idx) = 1          ' fUse Setting 
               Exit For 
            End If 
            cnt = cnt + 1
         End If 
      Next 

      exGetSelUser = selUser 
   End Function 

'   ===============================================================================     
'     team을 입력받아  rAryUser에서 해당 Team원 수를 Return 한다. 
'     이때 팀원은 사용하지 않은 팀원에 한정한다.  fUse = 1인 것을 제외
'   ===============================================================================
   Function exGetUserCntInTeam(rAryUser, teamOrder)
      Dim Idx, ub, cnt 

      ub = UBound(rAryUser, 2)
      cnt = 0

      For Idx = 0 To ub
         If(rAryUser(0, Idx) = 0) And (rAryUser(1,Idx) = teamOrder) Then 
            cnt = cnt + 1
         End If 
      Next 

      exGetUserCntInTeam = cnt 
   End Function 

'   ===============================================================================     
'    Block position을 입력받아 해당 Block에 있는 User수를 Count한다. 
'    strBlock = 0,1,2,3,4,5,6,7  넘어오는 값이 이런식이므로 
'    start position을 구할때 * sBase을 해야 실제 Block start position을 구할수 있다. 
'   ===============================================================================  
   Function exGetUserCntInBlock(rAryPos, pos, sBlock)
      Dim Idx, ub, cnt , sp, ep
      
      cnt = 0
      sp = pos * sBlock 
      ep = sp + (sBlock - 1) 

      For Idx = sp To ep
         If(rAryPos(0,Idx) = 1) Then 
            cnt = cnt + 1
         End If 
      Next 

      exGetUserCntInBlock = cnt 
   End Function 

'   ===============================================================================
'     special val(Q, Seed)가 있는 Block이 Insert가능하고, special val(Q, Seed)의 Partner가 비어있으면.. 그곳에 먼저 Insert
'   ===============================================================================
   Function exIsSpecialCellPartnerEmpty(rAryPos, spVal, pos, sBlock)
      Dim Idx, ub, sp, ep, Idx2, IsEmpty
      
      cnt = 0
      sp = pos * sBlock 
      ep = sp + (sBlock - 1) 
      Idx2 = -1
      IsEmpty = 0

      For Idx = sp To ep
         If(rAryPos(2,Idx) = spVal) Then 
            Idx2 = exGetPartnerIdx(Idx)          
            If(rAryPos(0,Idx2) = 0) Then 
               IsEmpty = 1
               Exit For 
            End If 
         End If 
      Next 

      exIsSpecialCellPartnerEmpty = IsEmpty 
   End Function 

'   ===============================================================================
'     복식에서 partner Idx를 찾는다. 
'   ===============================================================================   
   Function exGetPartnerIdx(pos)
      Dim Idx 
      ' get partner 
         If(pos Mod 2 = 1) Then 
            Idx = pos - 1
         Else 
            Idx = pos + 1
         End If

      exGetPartnerIdx = Idx 
   End Function 


'   ===============================================================================
'     aryPos에서 빈자리중 랜덤하게 한자리를 찾는다. 
'   ===============================================================================
   Function exGetRandomPos(rAryPos)
      Dim Idx, ub, pos, rNum, nEmpty, cnt  

      ub = UBound(rAryPos, 2)
      nEmpty = 0

      ' 빈자리 (rAryPos(0,Idx) = 0)의 갯수를 Count
      For Idx = 0 To ub 
         If(rAryPos(0, Idx) = 0) Then nEmpty = nEmpty + 1 End If 
      Next 

      rNum = GetRandomNum(nEmpty) - 1
      cnt = 0
      pos = -1

      For Idx = 0 To ub 
         If(rAryPos(0, Idx) = 0) Then 
            If(rNum = cnt) Then 
               pos = Idx 
               Exit For 
            Else 
               cnt = cnt + 1
            End If 
         End If 
      Next 
      exGetRandomPos = pos 
   End Function 



'   ===============================================================================     
'      aryTeam에서 Random하게 Team하나를 선택한다. 
'	    aryTeam에서 Team User Count가 팀 평균 Count보다 크면 E_TEAMCNT_AVEOVER 먼저 팀원을 배정한다. 
'	    aryTeam에서 Team User Count가 Half User 보다 크면 E_TEAMCNT_HALFOVER       제일 마지막 팀원을 배정한다. 
'      aryTeam에서 Team User Count가 팀 평균 Count보다 작으면 E_TEAMCNT_NORMAL 랜덤하게 팀을 순환하면서  팀원을 배정한다. ]
'        삭제가 되지 않았고 , teamKind = TCNT_AVROVER로 셋팅이 되어 있으면 먼저 할당한다. 
'        삭제가 되지 않았고 , teamKind = TCNT_HALFOVER로 셋팅이 되어 있으면 제일 마지막에 할당한다. 
'        모든 사용자를 할당한 팀은 배열에서 삭제 해야 한다. 
'        물리적으로 삭제를 하지 않고 flag setting으로 삭제 유무 표시 : rAryTeam(0,Idx) = -1
'        Team 선택 순서 : E_TEAMCNT_AVEOVER > E_TEAMCNT_NORMAL > E_TEAMCNT_HALFOVER
'   ===============================================================================
   Function exGetSelTeam(rAryTeam)
      Dim Idx, ub, teamKind, teamOrder 
      
      teamKind = E_TEAMCNT_HALFOVER
      ub = UBound(rAryTeam, 2)

      ' E_TEAMCNT_QFIRST 팀이 있는지 체크 
      For Idx = 0 To ub
         If(rAryTeam(0, Idx) <> -1) And (rAryTeam(1, Idx) = E_TEAMCNT_QFIRST) Then 
            teamKind = E_TEAMCNT_QFIRST    
            Exit For
         End If 
      Next

      ' E_TEAMCNT_AVEOVER 팀이 있는지 체크 
      If(teamKind <> E_TEAMCNT_QFIRST) Then 
         For Idx = 0 To ub
            If(rAryTeam(0, Idx) <> -1) And (rAryTeam(1, Idx) = E_TEAMCNT_AVEOVER) Then 
               teamKind = E_TEAMCNT_AVEOVER
               Exit For
            End If 
         Next
      End If

      ' E_TEAMCNT_NORMAL 팀이 있는지 체크  
      If(teamKind <> E_TEAMCNT_QFIRST) And (teamKind <> E_TEAMCNT_AVEOVER) Then 
         For Idx = 0 To ub
            If(rAryTeam(0, Idx) <> -1) And (rAryTeam(1, Idx) = E_TEAMCNT_NORMAL) Then 
               teamKind = E_TEAMCNT_NORMAL
               Exit For
            End If 
         Next 
      End If 

      If(teamKind = E_TEAMCNT_NORMAL) Then 
         teamOrder = exGetSelTeamLowAve(rAryTeam, teamKind)
      Else 
         teamOrder = exGetSelTeamOverAve(rAryTeam, teamKind)
      End If 

      exGetSelTeam = teamOrder 
   End Function 

   Function exGetSelTeamLowAve(rAryTeam, teamKind)
      Dim Idx, ub, teamOrder, rNum, cnt, cntTeam

      cntTeam = exGetTeamCnt(rAryTeam, teamKind) 
      If(cntTeam = 0) Then 
         Call exResetTeamfUse(rAryTeam)
         cntTeam = exGetTeamCnt(rAryTeam, teamKind) 
      End If 

      rNum = GetRandomNum(cntTeam) - 1

      '   ===============================================================================   
	   '	selTeam을 구한다. ( fUse = 0인 것만이 대상 - rNum과 cnt가 같을 때 까지 ) fUse = -1 삭제 , fUse = 1 사용
      ub = UBound(rAryTeam, 2)
      cnt = 0
      teamOrder = -1

      For Idx = 0 To ub
         If(rAryTeam(0, Idx) = 0) Then 
            If(rNum = cnt) Then 
               teamOrder = rAryTeam(2,Idx)
               rAryTeam(0,Idx) = 1
               Exit For 
            End If 
            cnt = cnt + 1  
         End If                 
      Next
      exGetSelTeamLowAve = teamOrder 
   End Function 

   Function exGetSelTeamOverAve(rAryTeam, teamKind)
      Dim Idx, ub, teamOrder, rNum, cnt, cntTeam

      cntTeam = exGetTeamCnt(rAryTeam, teamKind) 
      rNum = GetRandomNum(cntTeam) - 1

      '   ===============================================================================   
	   '	selTeam을 구한다. ( (rAryTeam(1, Idx) = TCNT_AVROVER or TCNT_HALFOVER) 것만 rNum과 cnt가 같을 때 까지 )
      ub = UBound(rAryTeam, 2)
      cnt = 0
      teamOrder = -1

      For Idx = 0 To ub 
         If(rAryTeam(0,Idx) <> -1) And (rAryTeam(1,Idx) = teamKind) Then 
            If(rNum = cnt) Then 
               teamOrder = rAryTeam(2,Idx)
               Exit For 
            End If 
            cnt = cnt + 1
         End If 
      Next 

      exGetSelTeamOverAve = teamOrder 
   End Function 

'   ===============================================================================     
'     aryTeam에서 teamKind가 같은 Team의 갯수를 반환한다. ( Random 선택시 사용)
'     E_TEAMCNT_AVEOVER/E_TEAMCNT_HALFOVER/E_TEAMCNT_QFIRST 는 해당 User를 할당 할때까지 중복 선택이 가능 
'     E_TEAMCNT_NORMAL은 모든 팀을 한번씩 선택하여야 한다. 
'   ===============================================================================
   Function exGetTeamCnt(rAryTeam, teamKind)
      Dim ub, Idx, cnt 

      ub = UBound(rAryTeam, 2)
      cnt = 0

      For Idx = 0 To ub 
         ' 삭제 되지 않았고, teamKind가 동일한 Team의 갯수를 센다. 
         If(teamKind <> E_TEAMCNT_NORMAL) Then 
            If(rAryTeam(0,Idx) <> -1) And (rAryTeam(1,Idx) = teamKind) Then 
               cnt = cnt + 1
            End If 
         Else  ' 아직 사용하지 않은 Team의 갯수를 센다. 
            If(rAryTeam(0,Idx) = 0) Then 
               cnt = cnt + 1
            End If 
         End If 
      Next
      exGetTeamCnt = cnt       
   End Function

'   ===============================================================================     
'      새로운 ary를 생성하여 arySrc를 cnt 만큼 aryNew에 copy한다.  - test 필요 
'   ===============================================================================
   Function exCopyPartAry(rArySrc, nCnt)
      Dim Idx, ub, ary, nCol, nMax
      ub = UBound(rArySrc, 2)
      nCol = UBound(rArySrc, 1)      

      nMax = nCnt - 1      
      if(nMax > ub) Then nMax = ub End If 

      ReDim ary(nCol, nMax)

      For Idx = 0 To nMax
         Call CopyRows(rArySrc, ary, Idx, Idx)
      Next

      exCopyPartAry = ary
   End Function 

'   ===============================================================================     
'      4개의 숫자를 입력받아 가장 작은 숫자의 Part를 반환한다. 
'   ===============================================================================
   Function exGetMinPart(val1, val2, val3, val4)
      Dim ret, min1, min2, minVal 
      min1 = etcGetMin(val1, val2)
      min2 = etcGetMin(val3, val4)
      minVal  = etcGetMin(min1, min2)

      ret = E_PART_A
      If(minVal = val1) Then 
         ret = E_PART_A
      ElseIf(minVal = val2) Then 
         ret = E_PART_B
      ElseIf(minVal = val3) Then 
         ret = E_PART_C
      ElseIf(minVal = val4) Then 
         ret = E_PART_D
      End If 

      exGetMinPart = ret
   End Function 

'   ===============================================================================     
'      2개의 숫자를 입력받아 작은 값을 반환한다. 
'   ===============================================================================
   Function etcGetMin(val1, val2)
      Dim ret 
      If(val1 > val2) Then 
         ret = val2    
      Else 
         ret = val1    
      End If 

      etcGetMin = ret
   End Function 

'   ===============================================================================     
'      aryPos으로 부터 Q Block Data를 추출한다. ( Q1, Q2, Q3, Q4 ... )
'   ===============================================================================
	Function exSetQBlockData(rAryPos, aryQTPos, nQGroup)
		Dim Idx, ub, nQIdx

		For Idx = 1 To nQGroup
			Call exExtractQBlockData(rAryPos, aryQTPos, Idx)
		Next 
	End Function 

'   ===============================================================================     
'      Q Idx를 입력받아 aryQTPos에 Block Data를 copy한다. 
'   ===============================================================================
	Function exExtractQBlockData(rAryPos, aryQTPos, QIdx)
		Dim ub, Idx, s_pos, e_pos, q_pos 

		ub = UBound(rAryPos, 2)
		q_pos = (QIdx-1) * CON_QGROUP_USER				' aryQTPos data copy start pos

		For Idx = 0 To ub 
			If(CDbl(rAryPos(2, Idx)) = E_POS_Q) And (CDbl(rAryPos(3, Idx)) = QIdx) Then 
				s_pos = exFindStartBlockPos(Idx)
				e_pos = (s_pos + CON_QGROUP_USER) -1

				For k = s_pos To e_pos
					Call CopyRows(rAryPos, aryQTPos, k, q_pos)
					q_pos = q_pos + 1
				Next 
				Exit For 
			End If 
		Next 
	End Function 	

'   ===============================================================================     
'      position을 입력받아 block size = 4의 시작 위치를 반환한다. 
'   ===============================================================================
	Function exFindStartBlockPos(nPos)
		Dim nBlockSz, s_pos, remain

		nBlockSz = 4

		remain = Fix(nPos / nBlockSz)
		s_pos = remain * nBlockSz 

		exFindStartBlockPos = s_pos
	 End Function 
%>

