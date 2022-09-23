<% 
'   ===============================================================================     
'    Purpose : binary search를 이용하여 대진표를 작성한다. 
'    Make    : 2019.12.20
'    Author  :                                                       By Aramdry
'   ===============================================================================    
%> 

<!-- #include virtual = "/pub/fn/badmt/res/res.pos.asp" -->  

<% 	  
	' '

'   ===============================================================================     
'     ary position  - 
'      fUse : user 할당 유무 
'      pos_kind : position 종류 - normal, seed, bye/Q (Qualification), firstMan ( 1장) 
'      pos_val   : normal - -1(사용안함) , seed position val (1, 2, 3.. ), bye/Q position val (1, 2, 3)
'
'     복식 : fUse, pos, pos_kind, pos_val, playerCode(gGroupIdx), teamOrder, cUser1, user1, cUser2, user2, cTeam1, team1, cTeam2, team2, player order
'             0,    1 ,   2     ,    3   ,    4                 ,    5  ,      6  ,    7  ,   8  ,    9  ,   10 ,   11  ,   12  ,  13  ,    14 
'     단식 : fUse, pos, pos_kind, pos_val, playerCode(gGroupIdx), teamOrder, cUser, user, cTeam, team, player order
'              0 ,  1 ,    2    ,    3   ,    4                 ,   5   ,       6 ,   7  ,   8 ,   9, 	10
'     ary user - 
'      fUse, teamNo, SeedNo, Ranking, dataOrder, PlayerOrder, GameRequestGroupIDX, GameRequestPlayerIDX, MemberIDX, MemberName, Team, TeamName, PrevTeam, PrevTeamName, cntTeam,	Sex, sameSex, UserIdx
'        0 ,   1   ,   2   ,    3   ,    4     ,     5  ,        6               ,        7            ,    8     ,     9  ,     10,     11    ,   12   ,      13     ,   14   ,  15,    16  ,   17             
'      fUse : user 할당 유무 
'      seed : seed Number
'
'     ary Team Info 
'        fUse, teamKind, teamOrder, cTeam, team, seedCnt, userCnt
'          0 ,   1     ,     2    ,   3  ,   4 ,   5    ,    6
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
' 			    nQ = (nTotal - nRound)  / 3 과 비슷한 공식 존재 - 소스 참조 
' 			    nUser = nTotal - nQ
' 			
' 			If( nTotal < nRound) nBye가 존재      : 전체 인원이 Tournament보다 작으면 Bye가 있다. 
' 			    nBye = nRound - nTotal 
' 			    nQ = 0
' 			    nUser = nTotal
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
'		인원 할당. 		
'			1. 인원은 player Order로 정렬되어 있다. ( 각팀의 1장.... , 2장....., 3장.. .... 순으로 )
'			2. 2파트로 나누어 인원을 할당한다. 
'			3. 각 파트별로 할당된 팀원의 수를 구한다. 
'			4. 팀원의 수가 적은 곳에 할당한다. 
'			5. 팀원 수가 동일할 경우 할당된 인원수가 적은쪽에 배치한다 
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
   Dim E_PART_A, E_PART_B, E_PART_C, E_PART_D, E_HALF_A, E_HALF_B, E_PART_ALL
   Dim CON_POSCOL_CNT_S, CON_POSCOL_CNT_D            '  aryPos - column count 
   Dim CON_POSVAL_NOUSE, CON_PLAYERCODE_EMPTY, CON_DEF_BLOCKSZ
   Dim CON_QGROUP_USER
   Dim szRound, SZ_BLOCK_MIN 	
	Dim cntSelfCall , maxSelfCall

	maxSelfCall 				= 10
	cntSelfCall					= 0

	CON_POSCOL_CNT_S        = 10 + 1          ' aryPos - 단식 column count
   CON_POSCOL_CNT_D        = 14 + 1          ' aryPos - 복식 column count
   
   CON_POSVAL_NOUSE        = -1              ' Position val 사용안함. 
   CON_PLAYERCODE_EMPTY    = "-1"              ' bye/Q (Qualification) Player Code
   CON_DEF_BLOCKSZ         = 4               ' default block size

   CON_QGROUP_USER         = 4               ' Q Group(예선조)는 4명 1조이다. 

   E_POS_NORMAL            = 0               ' 일반 자리 
   E_POS_SEED              = 1               ' Seed 자리 
   E_POS_BYE               = 2               ' Bye 자리 
   E_POS_Q                 = 3               ' 예선전 조 자리 
   E_POS_FIRST             = 4               ' 1장 자리 

   E_PART_A                = 0               ' A Part
   E_PART_B                = 1               ' B Part
   E_PART_C                = 2               ' A Part
   E_PART_D                = 3               ' B Part   
   E_HALF_A                = 4               ' A Part
   E_HALF_B                = 5               ' B Part
   E_PART_ALL              = 6               ' All part

	SZ_BLOCK_MIN	= 2					' block 최소 size - 이거보다 작으면 서치를 하지 않는다. 
	
	szRound			= 0
%>

<% 	  
'   ===============================================================================     
'     util function 
'   ===============================================================================   
	
'   ===============================================================================     
'      aryPos에서 sIdx, eIdx사이에 있는 Q Count를 구한다. 
'   ===============================================================================
	Function getQCountInBlock(rAryPos, sIdx, eIdx)
		Dim ub, Idx, cntQ 

		ub = UBound(rAryPos, 2)
		cntQ = 0

		If(sIdx < 0) Then sIdx = 0 End If 
		If(eIdx > ub) Then eIdx = ub End If 

		For Idx = sIdx To eIdx 
			If(rAryPos(2, Idx) = E_POS_Q) Then        ' Q(예선조)가 있다.. 
				cntQ = cntQ + 1
			End If 
		Next 		

		getQCountInBlock = cntQ 
	End Function 

'   ===============================================================================     
'      aryPos에서 sIdx, eIdx사이에 있는 Bye Count를 구한다. 
'   ===============================================================================
	Function getByeCountInBlock(rAryPos, sIdx, eIdx)
		Dim ub, Idx, cntBye 

		ub = UBound(rAryPos, 2)
		cntBye = 0

		If(sIdx < 0) Then sIdx = 0 End If 
		If(eIdx > ub) Then eIdx = ub End If 

		For Idx = sIdx To eIdx 
			If(rAryPos(2, Idx) = E_POS_BYE) Then        ' Q(예선조)가 있다.. 
				cntBye = cntBye + 1
			End If 
		Next 		

		getByeCountInBlock = cntBye 
	End Function 

'   ===============================================================================     
'      aryPos에서 sIdx, eIdx사이에 있는 Seed Count를 구한다. 
'   ===============================================================================
	Function getSeedCountInBlock(rAryPos, sIdx, eIdx)
		Dim ub, Idx, cntSeed 

		ub = UBound(rAryPos, 2)
		cntSeed = 0

		If(sIdx < 0) Then sIdx = 0 End If 
		If(eIdx > ub) Then eIdx = ub End If 

		For Idx = sIdx To eIdx 
			If(rAryPos(2, Idx) = E_POS_SEED) Then        ' Seed(시드)가 있다.. 
				cntSeed = cntSeed + 1
			End If 
		Next 		

		getSeedCountInBlock = cntSeed 
	End Function 

'   ===============================================================================     
'      aryPos에서 sIdx, eIdx사이에 있는 시드 혹은 1장 Count를 구한다. 
'   ===============================================================================
	Function getFirstCountInBlock(rAryPos, sIdx, eIdx)
		Dim ub, Idx, cntFirst 

		ub = UBound(rAryPos, 2)
		cntFirst = 0

		If(sIdx < 0) Then sIdx = 0 End If 
		If(eIdx > ub) Then eIdx = ub End If 

		For Idx = sIdx To eIdx 
			If(rAryPos(2, Idx) = E_POS_FIRST) Or (rAryPos(2, Idx) = E_POS_SEED)Then        ' 시드 혹은 1장이 있다.. 
				strLog = sprintf("getFirstCountInBlock Fisrt Or Seed user = {0}({1})", Array(rAryPos(7, Idx), rAryPos(9, Idx)) )
      		' ' ' ' ' ' Call TraceLog(SPORTS_LOG1, strLog) 
				cntFirst = cntFirst + 1
			End If 
		Next 		

		getFirstCountInBlock = cntFirst 
	End Function 

'   ===============================================================================     
'      aryPos에서 sIdx, eIdx사이에 있는 Team Count를 구한다. 
'   ===============================================================================
	Function getTeamCountInBlock(rAryPos, tNo, sIdx, eIdx)
		Dim ub, Idx, cntTeam , teamNo

		ub = UBound(rAryPos, 2)
		cntTeam = 0

		If(sIdx < 0) Then sIdx = 0 End If 
		If(eIdx > ub) Then eIdx = ub End If 

		For Idx = sIdx To eIdx 
         teamNo = CDbl(rAryPos(5, Idx))
			If(teamNo = tNo) Then        ' 같은 팀이 있다. 
				cntTeam = cntTeam + 1
			End If 
		Next 		

		getTeamCountInBlock = cntTeam 
	End Function 

'   ===============================================================================     
'      aryPos에서 할당된 Count를 구한다. 
'   ===============================================================================
	Function getAssignCountInBlock(rAryPos, sIdx, eIdx)
		Dim ub, Idx, cntAssign

		ub = UBound(rAryPos, 2)
		cntAssign = 0

		If(sIdx < 0) Then sIdx = 0 End If 
		If(eIdx > ub) Then eIdx = ub End If 

		For Idx = sIdx To eIdx 
			If(rAryPos(0, Idx) = "1") Then        ' 할당이 되었다. 
				If(rAryPos(2, Idx) <> E_POS_BYE) And (rAryPos(2, Idx) <> E_POS_Q) Then  '  Bye or Q자리가 아니다. 
					cntAssign = cntAssign + 1
				End If 
			End If 
		Next 		

		getAssignCountInBlock = cntAssign 
	End Function 

'   ===============================================================================     
'      aryPos에서 sIdx, eIdx사이에 있는 Empty Count를 구한다. 
' 		 파트너에 같은 팀이 없다면 빈공간으로 인정. / 아니면 풀     
'   ===============================================================================
	Function getEmptyCountInBlock(rAryPos, tNo, IsFirst, sIdx, eIdx)
		Dim ub, Idx, pos2, cntEmpty , teamNo, posKind

		ub = UBound(rAryPos, 2)
		cntEmpty = 0

		If(sIdx < 0) Then sIdx = 0 End If 
		If(eIdx > ub) Then eIdx = ub End If 
		
		If(IsFirst = 1) Then 								' 1장이면 1장이 없는 곳, sameTeam 이 없는곳 구한다. 
			For Idx = sIdx To eIdx 
				If(rAryPos(0, Idx) <> "1") Then        ' Empty갯수 
					pos2 = GetPartnerIdx(Idx)
					teamNo = CDbl(rAryPos(5, pos2))
					posKind = CDbl(rAryPos(2, pos2))
										
					' 파트너에 같은 팀이 없다면 빈공간으로 인정, 1장이면 파트너가 1장이면 안된다. 
					If(teamNo <> tNo) And ((posKind <> E_POS_FIRST) Or (posKind <> E_POS_SEED))Then        
						cntEmpty = cntEmpty + 1
					End If 
				End If 
			Next 		
		Else 														' sameTeam 이 없는곳 구한다. 
			For Idx = sIdx To eIdx 
				If(rAryPos(0, Idx) <> "1") Then        ' Empty갯수 
					pos2 = GetPartnerIdx(Idx)
					teamNo = CDbl(rAryPos(5, pos2))
					
					If(teamNo <> tNo) Then        ' 파트너에 같은 팀이 없다면 빈공간으로 인정. / 아니면 풀
						cntEmpty = cntEmpty + 1
					End If 
				End If 
			Next 		
		End If 
		getEmptyCountInBlock = cntEmpty 
	End Function 

'   ===============================================================================     
'      aryUser에서 할당되지 않은 빈 공간 Count를 구한다. 
'   ===============================================================================
	Function getEmptyCntInUserArray(rAryUser)
		Dim ub, Idx, cnt

		ub = UBound(rAryUser, 2)
		cnt = 0

		For Idx = 0 To ub 
			If(rAryUser(0, Idx) <> "1") Then        ' Empty갯수 
				cnt = cnt + 1
			End If 
		Next 		

		getEmptyCntInUserArray = cnt 
	End Function

'   ===============================================================================     
'      aryUser에서 할당된 Count를 구한다. 
'   ===============================================================================
	Function getAssignCntInUserArray(rAryUser)
		Dim ub, Idx, cnt, posVal

		ub = UBound(rAryUser, 2)
		cnt = 0

		For Idx = 0 To ub 
			If(rAryUser(0, Idx) = "1") Then       
				cnt = cnt + 1
			End If 
		Next 		

		getAssignCntInUserArray = cnt 
	End Function

'   ===============================================================================     
'      aryUser에서 teamNo로 할당된 Count를 구한다.  
'   ===============================================================================
	Function getTeamCntInUserArray(rAryUser, tNo)
		Dim ub, Idx, cnt, teamNo

		ub = UBound(rAryUser, 2)
		cnt = 0

		For Idx = 0 To ub 
			teamNo = CDbl(rAryUser(1, Idx))
			If(rAryUser(0, Idx) = "1") And (teamNo = tNo) Then        ' same team 
				cnt = cnt + 1
			End If 
		Next 		

		getTeamCntInUserArray = cnt 
	End Function

'   ===============================================================================     
'      같은팀의 teamOrder 차를 구하여 최소값을 반환한다. 
'			팀내 player order가 연속으로 같은 Part에 배치되면 안된다. 
'   ===============================================================================
	Function getPlayerOrderGapInUserArray(rAryUser, tNo, userOrder)
		Dim ub, Idx, cnt, teamNo, playerOrder, nGap, minGap

		ub = UBound(rAryUser, 2)
		cnt = 0
		minGap = 100

		For Idx = 0 To ub 
			teamNo = CDbl(rAryUser(1, Idx))			
			If(rAryUser(0, Idx) = "1") And (teamNo = tNo) Then        ' same team 
				playerOrder = CDbl(rAryUser(5, Idx))
				nGap = abs(userOrder - playerOrder)
				If(minGap > nGap) Then minGap = nGap End If 				
			End If 
		Next 		

		getPlayerOrderGapInUserArray = minGap 
	End Function

'   ===============================================================================     
'      QCnt를 입력받아 , 4개의 Part에 랜덤 배치하는 aryQPart를 반환한다.  
'		 aryQ는 
'		 aryQ[0],aryQ[1],aryQ[2],aryQ[3],aryQ[4],aryQ[5],aryQ[6],aryQ[7],aryQ[8],aryQ[9],.... 의 값은 
'		 partA, B, C, D의 4가지 값중의 1개를 4개의 block마다 1개씩 분배한다. 
'		 추후 Q를 배치할때 n번째 Q는 aryQ[n]의 값이 가리키는 Part 위치에(partA, B, C, D) 배치한다. 
'   ===============================================================================
	Function GetQAssignPart(QCnt)
		Dim Idx, ub, aryQ, aryUse, nPart 
	'	If(QCnt > 16) Then QCnt = 16 End If  		' why 16 limit? 
		
		ReDim aryQ(QCnt-1)
		ReDim aryUse(4-1)           ' 4개의 part에 대한 할당 유무 판단. 
		
		For Idx = 0 To (QCnt-1)
			nPart = GetRandomQPart(aryUse, Idx)
			aryQ(Idx) = nPart 
		Next 

		GetQAssignPart = aryQ 
	End Function 

'   ===============================================================================     
'      nIdx를 입력받아 4개의 Part에 랜덤하게 배치한다.  - rAryUse 배치 결과 Check array
'   ===============================================================================
	Function GetRandomQPart(rAryUse, nIdx)
		Dim Idx, ub, cntUse, nEmpty, nMaxUse, cnt 

		cntUse = 0
		ub = UBound(rAryuse)
		nMaxUse = ub + 1
		' 사용가능한 part의 갯수를 구한다. 
		For Idx = 0 To ub 
			If(rAryuse(Idx) = 1) Then cntUse = cntUse + 1 End If 
		Next 

		' 모두 사용했다. 초기화 하자. 
		If(cntUse >= (nMaxUse) ) Then 
			For Idx = 0 To ub 
					rAryuse(Idx) = 0
			Next 
			cntUse = 0       
		End If 

		nEmpty = nMaxUse - cntUse
		rNum = GetRandomNum(nEmpty) -1

		nPart = -1 
		cnt = 0
		For Idx = 0 To ub 
			If(rAryuse(Idx) <> 1) Then
					If(cnt = rNum) Then 
						nPart = Idx 
						rAryuse(Idx) = 1
						Exit For 
					End If 
					cnt = cnt + 1
			End If 
		Next 
		
		GetRandomQPart = nPart 
	End Function 
	
'   ===============================================================================     
'      nRound를 입력받아 Position Array를 반환한다. 
'   ===============================================================================
   Function GetPosArray(nRound, IsDblGame)
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

      GetPosArray = ary
   End Function 

'   ===============================================================================     
'     Seed를 할당한다. 
'   ===============================================================================  
   Function SetSeedToPos(rAryPos, rAryUser, nRound, IsDblGame )
      Dim arySeed, Idx, ub, pos, nSeed, nBase
      nBase = 1

      If(IsDblGame=1) Then nBase = 2

      arySeed = GetArySeedPos(nRound)	   ' seed pos은 미리 시스템에 정의 되어 있다. 
      ub = UBound(rAryUser, 2)
      ubb = UBound(rAryUser, 1)

      For Idx = 0 To ub Step nBase
         nSeed = rAryUser(2,Idx)
         If(nSeed <> 0) Then  ' Seed가 있다면 aryPos에 Seed를 설정한다. 
            pos = GetSeedPos(rAryPos, arySeed, nSeed)
            Call SetSeedData(rAryPos, rAryUser, pos, Idx, IsDblGame)  
         End If 
      Next 
   End Function 

'   ===============================================================================     
'     aryPos에 aryReq로 부터 seeddata를 Setting한다. 
'   ===============================================================================   
   Function SetSeedData(rAryPos, rAryUser, seedPos, userPos, IsDblGame)
      rAryPos(0,seedPos) = 1                          ' fuse - Seed를 할당하였다. 
		rAryPos(1,seedPos) = seedPos+1	               ' position 
      rAryPos(2,seedPos) = E_POS_SEED                 ' seed 
      rAryPos(3,seedPos) = rAryUser(2,userPos)         ' seed value
      rAryPos(4,seedPos) = rAryUser(6,userPos)         ' playerCode - GroupIdx
      rAryPos(5,seedPos) = rAryUser(1,userPos)         ' team order

      If(IsDblGame = 1) then          
         rAryPos(6,seedPos) = rAryUser(8,userPos)         ' cUser1
         rAryPos(7,seedPos) = rAryUser(9,userPos)         ' user1
         rAryPos(8,seedPos) = rAryUser(8,userPos+1)         ' cUser2
         rAryPos(9,seedPos) = rAryUser(9,userPos+1)         ' user2

         rAryPos(10,seedPos) = rAryUser(10,userPos)         ' cTeam1
         rAryPos(11,seedPos) = rAryUser(11,userPos)        ' team1
         rAryPos(12,seedPos) = rAryUser(10,userPos+1)        ' cTeam2
         rAryPos(13,seedPos) = rAryUser(11,userPos+1)        ' team2
			rAryPos(14,seedPos) = rAryUser(5,userPos+1)        ' player order
      Else 
         rAryPos(6,seedPos) = rAryUser(8,userPos)         ' cUser
         rAryPos(7,seedPos) = rAryUser(9,userPos)         ' user
         rAryPos(8,seedPos) = rAryUser(10,userPos)         ' cTeam
         rAryPos(9,seedPos) = rAryUser(11,userPos)         ' team
			rAryPos(10,seedPos) = rAryUser(5,userPos+1)        ' player order
      End If 
   End Function 

	'   ===============================================================================     
'      round로 seedPos을 얻는다. 
'   ===============================================================================
	Function GetArySeedPos(nRound)		
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
		GetArySeedPos = ary
	End Function

   Function GetSeedMax(nRound)
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

      GetSeedMax = nMax
   End Function 

'   ===============================================================================     
'      Seed Order를 받아서 aryPos에서의 Seed position을 반환한다. 
'      1, 2등은 고정 자리이다. (항상 같은자리)
'      3-4 / 5-8 / 9-16 등일 경우 각각의 자리는 해당 그룹에서 랜덤하게 위치한다. (3등은 3, 4위치 중 랜덤하게)
'   =============================================================================== 
   Function GetSeedPos(rAryPos, rArySeed, sOrder )
      Dim seedPos, ub, Idx, aryTmpPos, nMax

      Idx = sOrder - 1          ' sOrder (seed값은 1부터 , 배열은 0부터 )
      seedPos = -1
      ub = UBound(rArySeed)  
      If(Idx <=  ub) Then 
        seedPos = rArySeed(Idx)-1        ' seed data의 값으 1부터 , 실질적인 aryPos은 0 부터 
      End If 
   
      GetSeedPos = seedPos
   End Function 

	
'   ===============================================================================     
'      aryPos에 Bye값을 적용한다. 
'   ===============================================================================  
   Function ApplyByeToPos(rAryPos, nUser)
      Dim Idx, ub, aryBye

      aryBye = GetAryBye(nUser)

      ub = UBound(rAryPos, 2)

      For Idx = 0 To ub
         If(IsByePos(aryBye, Idx+1) = 1 ) Then  ' Bye 자리다.  
            rAryPos(0, Idx) = 1            
            rAryPos(2, Idx) = E_POS_BYE    
         End If 
      Next

   End Function 

'   ===============================================================================     
'     인원수로 ByePos을 얻는다. 
'     Bye position이 인원수 별로 정해져 있다. 그 array를 얻는다.  
'   ===============================================================================
	Function GetAryBye(nUser)
      Dim nCnt       

		nCnt = nUser - 1 
		If(nCnt < 1 Or nCnt > 255) Then nCnt = 0 End If
		GetAryBye = gAryByePos(nCnt)
	End Function

'   ===============================================================================     
'      Bye(Empty Seed) array에서 nPos값을 입력받아 Bye Position 인지 유무를 판단한다. 
'      rAryBye(0) = cntBye
'   ===============================================================================
	Function IsByePos(rAryBye, nPos)
		Dim Idx, ub, isBye

		isBye = 0
		ub = UBound(rAryBye)  

		For Idx = 1 To ub
			If(rAryBye(Idx) = nPos) Then 
				isBye = 1
				Exit For
			End If
		Next

		IsByePos = isBye
	End Function

'   ===============================================================================     
'      aryPos배열을 4개로 나눈다. 
'   ===============================================================================
   Function DivAryPos(rAryPos, nPart)
      Dim Idx, ub, ary, sPos, ePos, nCol, nCnt, nRow, m
      ub = UBound(rAryPos, 2)
      nCol = UBound(rAryPos, 1)
      nCnt = ((ub+1) / 4) 

		nRow = nCnt 
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
			nRow = nCnt * 2
      ElseIf(nPart = E_HALF_B) Then  
         sPos = (nCnt*2)
         ePos = ub
			nRow = nCnt * 2
      ElseIf(nPart = E_PART_ALL) Then  
         sPos = 0
         ePos = ub		
			nRow = (ub+1)	
      End If 

      ReDim ary( nCol, nRow-1 )

		strLog = sprintf("DivAryPos nPart = {0}, sPos = {1}, ePos = {2}, nCol = {3}, nRow = {4}", _ 
						Array(nPart, sPos, ePos, nCol, nRow))
		' ' ' ' ' ' ' Call TraceLog(SPORTS_LOG1, strLog) 

      For Idx = sPos To ePos
         For k = 0 To nCol
            m = Idx-sPos
            ary(k, m) = rAryPos(k, Idx)
         Next
      Next

      DivAryPos = ary 
   End Function 

'   ===============================================================================     
'     special position Count를 얻는다. 
'   ===============================================================================  
   Function GetSpecialPosCnt(rAryPos, specalVal, spPart)      
      Dim Idx, ub, nCntVal, sPos, ePos, nCnt
      ub = UBound(rAryPos, 2)
      nCnt = ((ub+1) / 4) 
      nCntVal = 0

      If(spPart = E_PART_A) Then 
         sPos = 0
         ePos = nCnt -1
      ElseIf(spPart = E_PART_B) Then  
         sPos = nCnt
         ePos = (nCnt*2)-1
      ElseIf(spPart = E_PART_C) Then  
         sPos = (nCnt*2)
         ePos = (nCnt*3)-1
      ElseIf(spPart = E_PART_D) Then  
         sPos = (nCnt*3)
         ePos = ub
      ElseIf(spPart = E_HALF_A) Then  
         sPos = 0
         ePos = (nCnt*2)-1
      ElseIf(spPart = E_HALF_B) Then  
         sPos = (nCnt*2)
         ePos = ub
      ElseIf(spPart = E_PART_ALL) Then  
         sPos = 0
         ePos = ub
      End If 

      For Idx = sPos To ePos
         If(rAryPos(2,Idx) = specalVal) Then nCntVal = nCntVal + 1 End If 
      Next

      GetSpecialPosCnt = nCntVal
   End Function

'   ===============================================================================     
'     special position Count를 얻는다. 
'   ===============================================================================  
   Function GetSpecialPosCntSelfCall(rAryPos, specalVal)      
      Dim Idx, ub, nCntVal
      ub = UBound(rAryPos, 2)

      For Idx = 0 To ub
         If(rAryPos(2,Idx) = specalVal) Then nCntVal = nCntVal + 1 End If 
      Next

      GetSpecialPosCntSelfCall = nCntVal
   End Function

'   ===============================================================================     
'     SeedNo를 가지고 aryUser로 부터 User Idx를 얻는다. 
'   =============================================================================== 
   Function FindUserWithSeed(rAryUser, seedNo)
      Dim ub, Idx, userIdx 

      userIdx = -1

      ub = UBound(rAryUser, 2)
      For Idx = 0 To ub
         If( rAryUser(2, Idx) = seedNo ) Then 
            userIdx = Idx 
            Exit For 
         End If 
      Next  

      FindUserWithSeed = userIdx 
   End Function 


'   ===============================================================================
'     복식에서 partner Idx를 찾는다. 
'   ===============================================================================   
   Function GetPartnerIdx(pos)
      Dim Idx 
      ' get partner 
         If(pos Mod 2 = 1) Then 
            Idx = pos - 1
         Else 
            Idx = pos + 1
         End If

      GetPartnerIdx = Idx 
   End Function 

'   ===============================================================================     
'      aryInfo : Reset fUse , aryPos, aryUser등의 fUse를 0으로 Reset
'   ===============================================================================
   Function ResetfUse(rAryInfo)
      Dim Idx, ub      
      ub = UBound(rAryInfo, 2)

      For Idx = 0 To ub 
         rAryInfo(0, Idx) = 0
      Next
   End Function 

'   ===============================================================================     
'      새로운 ary를 생성하여 arySrc를 cnt 만큼 aryNew에 copy한다.  - test 필요 
'   ===============================================================================
   Function CopyPartAry(rArySrc, nCnt)
      Dim Idx, ub, ary, nCol, nMax
      ub = UBound(rArySrc, 2)
      nCol = UBound(rArySrc, 1)      

      nMax = nCnt - 1      
      if(nMax > ub) Then nMax = ub End If 

      ReDim ary(nCol, nMax)

      For Idx = 0 To nMax
         Call CopyRows(rArySrc, ary, Idx, Idx)
      Next

      CopyPartAry = ary
   End Function 

'   ===============================================================================     
'      aryPos배열에 rAryPart를 merge한다. 
'   ===============================================================================
   Function MergeAryPos(rAryPos, rAryPart, nPart)
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

'   ===============================================================================     
'      aryReq로 부터 aryUser, aryQUser를 추출한다. 
'        - aryReq는 각팀 1장, 2장 순으로 정렬되어 있어서 
'          앞에서 부터 nTour만큼 자르면 본선 User, 그 뒤가 예선 User가 된다 .
'   ===============================================================================  
   Function ExtractAryUser(rAryUser, rAryTUser, rAryQUser, nQGroup, nRound, IsDblGame)
      Dim Idx, ub, ub2, nUser, nQUser, nTour, nCnt
      
      ' 복식일 경우는 따로 연산한다. 
      If(IsDblGame = 1) Then
         Call ExtractAryUserDbl(rAryUser, rAryTUser, rAryQUser, nQGroup, nRound, IsDblGame)
         Exit Function 
      End If 

      ub    = UBound(rAryUser, 2)
		ub2   = UBound(rAryUser, 1)
      nUser = ub + 1
      
      ' GetTourUserCnt 단식으로 계산한 결과를 올리므로 복식이면 *2를 한다. 
      nTour = GetTourUserCnt(nUser, nRound)
      nQUser = nUser - nTour 

      ' ary Tournament User, ary Qualifier User Redefine 
      ReDim rAryTUser(ub2, nTour-1)
      ReDim rAryQUser(ub2, nQUser-1)

      For Idx = 0 To ub 
         If(Idx < nTour) Then 				
            Call CopyRows(rAryUser, rAryTUser, Idx, Idx)
         Else 
            Call CopyRows(rAryUser, rAryQUser, Idx, Idx-nTour)
         End If 
      Next 
   End Function 

   Function ExtractAryUserDbl(rAryUser, rAryTUser, rAryQUser, nQGroup, nRound, IsDblGame)
      Dim Idx, ub, ub2, nUser, nQUser, nTour, nCnt

      ub    = UBound(rAryUser, 2)
		ub2   = UBound(rAryUser, 1)
      nUser = ub + 1
      nCnt = nUser / 2

      ' GetTourUserCnt 단식으로 계산한 결과를 올리므로 복식이면 *2를 한다. 
      nTour = GetTourUserCnt(nCnt, nRound)
      nTour = nTour * 2
      nQUser = nUser - nTour 

      ' ary Tournament User, ary Qualifier User Redefine 
      ReDim rAryTUser(ub2, nTour-1)
      ReDim rAryQUser(ub2, nQUser-1)

      For Idx = 0 To ub
         If(Idx < nTour) Then 
            Call CopyRows(rAryUser, rAryTUser, Idx, Idx)
         Else 
            Call CopyRows(rAryUser, rAryQUser, Idx, Idx-nTour)
         End If 
      Next 
   End Function 


'   ===============================================================================     
'    round당 QGroup(예선조) 최대 Count를 구한다. 
'   ===============================================================================
   Function GetMaxQGroupCnt(nRound)
      Dim QMax 

      QMax = nRound / CON_QGROUP_USER
      GetMaxQGroupCnt = QMax
   End Function 


'   ===============================================================================     
'      QGroup(예선조) Count를 구한다. 
'     nCnt = cntUser - nRound 
'     If(nCnt <= 0) QCnt = 0 Else QCnt = Fix(nCnt / 3)
'     If(QCnt > 0 && QCnt Mod 3 <>0 )  QCnt = QCnt + 1
'   ===============================================================================
   Function GetQGroupCnt(nUser, nRound)
      Dim nDiff, QCnt
      
      nDiff = nUser - nRound

'      strLog = sprintf("In GetQGroupCnt nUser = {0}, nRound = {1}, nDiff = {2}, QCnt = {3}, QMod = {4}<br>", Array(nUser, nRound, nDiff, (nDiff/3), (nDiff Mod 3) ))
'      response.write strLog 

      If(nDiff <= 0) Then 
         QCnt = 0
      Else 
         QCnt = Fix(nDiff / 3)
         If(nDiff Mod 3 <> 0) Then QCnt = QCnt + 1 End If 
      End If 

      GetQGroupCnt = QCnt
   End Function 
   
'   ===============================================================================     
'      Tournament User Cnt를 구한다. 
'     복식일 경우 retVal * 2를 해 줘야 한다. 
'   ===============================================================================
   Function GetTourUserCnt(nUser, nRound)
      Dim QCnt , nTourUser

      QCnt = GetQGroupCnt(nUser, nRound)      
      nTourUser = nRound - QCnt
      
      If(QCnt = 0) Then nTourUser = nUser
      GetTourUserCnt = nTourUser
   End Function 

'   ===============================================================================     
'      Q User Cnt를 구한다. 
'     복식일 경우 retVal * 2를 해 줘야 한다. 
'   ===============================================================================
   Function GetQUserCnt(nUser, nRound)
      Dim nTourUser, nQUser
   
      nTourUser = GetTourUserCnt(nUser, nRound)     
      nQUser = nUser - nTourUser

      GetQUserCnt = nQUser      
   End Function 


'   ===============================================================================     
'      nQGroup를 입력받아 QPosition Array를 반환한다. 
'   ===============================================================================
   Function GetQPosArray(nQGroup, IsDblGame)
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
         ary(2, Idx) = E_POS_NORMAL             ' pos kind normal 
         ary(3, Idx) = CON_POSVAL_NOUSE         ' pos val : not use
         ary(4, Idx) = CON_PLAYERCODE_EMPTY     ' player code : empty user 
         ary(5, Idx) = 0                        ' team order : 0
      Next

      GetQPosArray = ary
   End Function 


'   ===============================================================================     
'      인원수를 입력받아 aryQPos에 Bye를 셋팅한다. 
'   ===============================================================================
   Function SetByeInAryQPos(rAryPos, nQUser, IsDblGame)
      Dim szBlock

		strLog = sprintf("SetByeInAryQPos nQUser = {0}", Array(nQUser))
		' ' ' ' Call TraceLog(SAMALL_LOG1, strLog)


      szBlock = CON_QGROUP_USER
      If(IsDblGame = 1) Then nQUser = nQUser / 2 End If 

      If(nQUser <= 4) Then 
         Call SetByeInQBlock(rAryPos, 0, nQUser)
      ElseIf(nQUser <= 8) Then 
         If(nQUser = 7) Then                           ' QCnt = 7 이면 Q1 = 3, Q2 = 4         
            Call SetByeInQBlock(rAryPos, 0, 3)
         ElseIf(nQUser = 6) Then                       ' QCnt = 6 이면 Q1 = 3, Q2 = 3
            Call SetByeInQBlock(rAryPos, 0, 3)
            Call SetByeInQBlock(rAryPos, szBlock, 3)
         ElseIf(nQUser = 5) Then                       ' QCnt = 5 이면 Q1 = 2, Q2 = 3
            Call SetByeInQBlock(rAryPos, 0, 2)
            Call SetByeInQBlock(rAryPos, szBlock, 3)
         End If
      ElseIf(nQUser <= 12) Then 
         If(nQUser = 11) Then                          ' QCnt = 11 이면 Q1 = 3, Q2 = 4, Q3 = 4
            Call SetByeInQBlock(rAryPos, 0, 3)
         ElseIf(nQUser = 10) Then                      ' QCnt = 10 이면 Q1 = 3, Q2 = 3, Q3 = 4
            Call SetByeInQBlock(rAryPos, 0, 3)
            Call SetByeInQBlock(rAryPos, szBlock, 3)
         ElseIf(nQUser = 9) Then                       ' QCnt = 9 이면 Q1 = 3, Q2 = 3, Q3 = 3
            Call SetByeInQBlock(rAryPos, 0, 3)
            Call SetByeInQBlock(rAryPos, szBlock, 3)
            Call SetByeInQBlock(rAryPos, 2*szBlock, 3)
         End If
      Else 
         nQMod = nQUser Mod szBlock
         If(nQMod = 3) Then                                    ' QCnt Mod 4 = 3 이면  Q1 = 3
            Call SetByeInQBlock(rAryPos, 0, 3)
         ElseIf(nQMod = 2) Then                                ' QCnt Mod 4 = 2 이면  Q1 = 3, Q2 = 3
            Call SetByeInQBlock(rAryPos, 0, 3)
            Call SetByeInQBlock(rAryPos, szBlock, 3)
         ElseIf(nQMod = 1) Then                                ' QCnt Mod 4 = 1 이면  Q1 = 3, Q2 = 3, Q3= 3
            Call SetByeInQBlock(rAryPos, 0, 3)
            Call SetByeInQBlock(rAryPos, szBlock, 3)
            Call SetByeInQBlock(rAryPos, (2)*szBlock, 3)
         End If
      End If 
   End Function 

'   ===============================================================================     
'      rAryPos에 sp로부터 bye position을 셋팅한다. nUser에 따라
'      sp: start pos
'   ===============================================================================

   Function SetByeInQBlock(rAryPos, sp, nUser)
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
%>

<%
'   ===============================================================================     
'     단식 - utility 
'   =============================================================================== 

'   ===============================================================================     
'     aryUser에 aryPos으로 부터 Seed Data를 적용한다. seed no를 가지고 데이터를 할당한다. 
'   =============================================================================== 
   Function ApplySeedFromPos(rAryPos, rAryUser, rArySrc)
      Dim ub, Idx, seedNo, userIdx, cnt  

      cnt = 0
      ub = UBound(rAryPos, 2)
      For Idx = 0 To ub
         If(rAryPos(2,Idx) = E_POS_SEED) Then 
            seedNo = rAryPos(3,Idx)
            userIdx = FindUserWithSeed(rArySrc, seedNo)

            If(userIdx <> -1) Then 
               rArySrc(0, userIdx) = 1
               Call CopyRows(rArySrc, rAryUser, userIdx, cnt)
               cnt = cnt + 1
            End If 
         End If 
      Next  
   End Function 
%>

<%
'   ===============================================================================     
'     복식 - utility
'   =============================================================================== 

'   ===============================================================================     
'     aryUser에 aryPos으로 부터 Seed Data를 적용한다. seed no를 가지고 데이터를 할당한다. 
'   =============================================================================== 
   Function ApplySeedFromPosDbl(rAryPos, rAryUser, rArySrc)
      Dim ub, Idx, seedNo, userIdx, userIdx2, cnt  

      cnt = 0
      ub = UBound(rAryPos, 2)
      For Idx = 0 To ub
         If(rAryPos(2,Idx) = E_POS_SEED) Then 
            seedNo = rAryPos(3,Idx)
            userIdx = FindUserWithSeed(rArySrc, seedNo)

            ' get partner 
            userIdx2 = GetPartnerIdx(userIdx)

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
%>

<% 	  
	Dim cntBinCall 
	cntBinCall = 0
'   ===============================================================================     
'     algorithm function 
'   ===============================================================================  

'   ===============================================================================     
'     예선조를 aryQPos에 배치한다. 		- 단식 
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
	Function SetQUser(rAryQUser, rAryQPos, rAryPos, IsDblGame)
		Dim Idx, ub, key, keyType, IsDesc

		If(IsDblGame = 1) Then 
			Call SetQUserDbl(rAryQUser, rAryQPos, rAryPos)
			Exit Function 
		End If 

		ub = UBound(rAryQUser, 2)

		'' ' ' ' Call TraceLog2Dim(SAMALL_LOG1, rAryQUser, "SetQUser - Prev SetTeamCntToUserAry rAryQUser")
		Call SetTeamCntToUserAry(rAryQUser)		' aryUser에 teamCount를 셋팅한다. - 추후 sort에서 사용한다. 

		' 팀별 정렬후 , 인원수로 정렬한다. 
		key = 1
		keyType = 2
		IsDesc = 0 
		Call Sort2DimAryEx(rAryQUser, key, keyType, IsDesc)	

		key = 14
		keyType = 2
		IsDesc = 1 
		Call Sort2DimAryEx(rAryQUser, key, keyType, IsDesc)	

		'' ' ' ' Call TraceLog2Dim(SAMALL_LOG1, rAryQUser, "SetQUser - rAryQUser")
		'' ' ' ' Call TraceLog2Dim(SAMALL_LOG1, rAryPos, "SetQUser - rAryPos")
		'' ' ' ' Call TraceLog2Dim(SAMALL_LOG1, rAryQPos, "SetQUser - rAryQPos")

		

		For Idx = 0 To ub 
			strLog = sprintf("User[{0}] = {1}, team = {2}-{3}", Array(Idx, rAryQUser(9, Idx), rAryQUser(1, Idx), rAryQUser(11, Idx)))
			' ' Call TraceLog(SPORTS_LOG1, strLog) 
			Call SetQUserToPos(rAryQUser, rAryQPos, rAryPos, Idx)	
		Next 		
	End Function 

'   ===============================================================================     
'     user를 선택하여 aryQPos에 할당한다. 
'     teamNo와 일치하는 SameCount 최소값의 예선조를 구한다. 
'     구해진 예선조들에서 본선 Tournament Block4에서의 최소 SameCount 예선조를 구한다. 
'     구해진 예선조들에서 본선 Tournament Block8에서의 최소 SameCount 예선조를 구한다. 
'     구해진 예선조들에서 본선 Tournament Block16에서의 최소 SameCount 예선조를 구한다. 

'     예선조 부터 최소값을 구하여 재귀적으로 최소값을 구한 값이기 때문에 
'     block16에서 구해진 예선조가 있으면 그 예선조들 중에 랜덤하게 배치한다.  
'     block8에서 구해진 예선조가 있으면 그 예선조들 중에 랜덤하게 배치한다. 
'     block4에서 구해진 예선조가 있으면 그 예선조들 중에 랜덤하게 배치한다. 
'     예선조에서 구해진 예선조가 있으면 그 예선조들 중에 랜덤하게 배치한다. 
'   =============================================================================== 
	Function SetQUserToPos(rAryQUser, rAryQPos, rAryPos, uIdx)				
		Dim ub, Idx, cntQ, teamNo, sameTeamCnt, QNum, rNum, cnt
		Dim aryQArea, aryQOutArea, aryAssign, cntAssign, blockIdx
		Dim sp, ep , minCnt 

		ub = UBound(rAryQPos, 2)		
		cntQ = (ub+1) / CON_QGROUP_USER

		teamNo = CDbl(rAryQUser(1, uIdx))
		cntAssign = 0

		strLog = sprintf("In SetQUserToPos User[{0}] = {1}, team = {2}-{3}, cntQ = {4}, teamNo = {5}", _ 
				Array(uIdx, rAryQUser(9, uIdx), rAryQUser(1, uIdx), rAryQUser(11, uIdx), cntQ, teamNo))
		' ' Call TraceLog(SPORTS_LOG1, strLog) 

		' 0 : assign 가능 여부 , 1: 현재 할당된 Count
		ReDim aryAssign(2-1, cntQ-1)

		' 현재 할당된 인원수를 셋팅한다. 
		For Idx = 0 To cntQ - 1
			sp = Idx * CON_QGROUP_USER
			ep = sp + (CON_QGROUP_USER - 1)
			aryAssign(1, Idx) = GetCntAssignBlockOfQ(rAryQPos, sp, ep)
		Next 

		aryQArea 		= GetInsertAryQArea(rAryQPos, teamNo, cntQ)
		aryQOutArea		= GetInsertAryQOutArea(rAryPos, aryQArea, teamNo, cntQ)

		' 먼저 block16, 8, 4의 값들을 순차적으로 검사한다. 
		blockIdx = 2  ' 2: 16, 1: 8, 0: 4		
		For Idx = 0 To 3-1
			cntAssign = 0
			For m = 0 To cntQ-1
				If(aryQOutArea(blockIdx, m) = 1) Then 
					aryAssign(0, m) = 1
					cntAssign = cntAssign + 1
				Else
					aryAssign(0, m) = 0
				End If 
			Next

			If(cntAssign > 0) Then 		' 배치할 곳을 찾았다. 
				Exit For 
			End If 

			blockIdx = blockIdx - 1
		Next 

		' ' Call TraceLog1Dim(SPORTS_LOG1, aryQArea, 20, "--------------- aryQArea ")
		' ' Call TraceLog2Dim(SAMALL_LOG1, aryQOutArea, "IN SetQUserToPos - aryQOutArea")

		If(cntAssign = 0) Then 
			For Idx = 0 To cntQ - 1
				If(aryQArea(Idx) = 1) Then 
					aryAssign(0, Idx) = 1
					cntAssign = cntAssign + 1
				Else
					aryAssign(0, Idx) = 0
				End If 
			Next 
		End If 

		' 인원이 적은쪽에 배치한다. 
		QNum = -1
		minCnt = 100

		If(cntAssign > 0) Then 		' 배치할 곳을 찾았다.		
			For Idx = 0 To cntQ - 1 
				If(aryAssign(0, Idx) = 1) Then 
					If(minCnt > aryAssign(1, Idx)) Then 
						minCnt = aryAssign(1, Idx)
						QNum = Idx 
					End If 
				End If 
			Next 

			For Idx = 0 To cntQ - 1 
				If(aryAssign(0, Idx) = 1) Then 
					If(minCnt <> aryAssign(1, Idx)) Then 
						aryAssign(0, Idx) = 0
						cntAssign = cntAssign - 1
					End If 
				End If 
			Next 
		End If 

		QNum = -1
		If(cntAssign > 0) Then 		' 배치할 곳을 찾았다.
			rNum = GetRandomNum(cntAssign) -1
			cnt = 0			
			For Idx = 0 To cntQ - 1 
				If(aryAssign(0, Idx) = 1) Then 
						If(cnt = rNum) Then 						
							QNum = Idx 
							Exit For 
						End If 
						cnt = cnt + 1
				End If 
			Next 
		End If 

		strLog = sprintf("In SetQUserToPos cntAssign = {0}, rNum = {1}, QNum = {2}", _ 
				Array(cntAssign, rNum, QNum))
		' ' ' ' Call TraceLog(SPORTS_LOG1, strLog) 
		
		If(QNum > -1) Then 			
			Call SetQUserInBlock(rAryQPos, rAryQUser, uIdx, QNum) 
		Else 

		End If 
	End Function 	

'   ===============================================================================     
'      aryQPos에 aryQUser를 할당한다.        - 단식 
'      sp로 부터 block 단위로 구분한다. 
'      1, 4, 3, 2 순으로 user를 배치한다. - 의미 없음. 
'      빈자리는 Bye로 채워 지기 때문에 빈자리에 채우기만 하면 된다. 
'   ===============================================================================  
   Function SetQUserInBlock(rAryQPos, rAryQUser, uIdx, q_num)
      Dim Idx, ub, ret, pos, sp, ep 
		Dim rNum, nEmpty , cnt 

		sp = q_num * CON_QGROUP_USER
		ep = (sp + CON_QGROUP_USER) - 1

		pos = -1
		nEmpty = 0
		For Idx = sp To ep          
         If(rAryQPos(0, Idx) = 0) Then 
            nEmpty = nEmpty + 1
				pos = Idx 					' 임시 - position을 못찾을 경우를 대비해서 셋팅 
         End If 
      Next  

		rNum = GetRandomNum(nEmpty) - 1

		cnt = 0 		
		For Idx = sp To ep    
         If(rAryQPos(0, Idx) = 0) Then 
				If(rNum = cnt) Then 
					pos = Idx				' 값을 찾았다.  
					Exit For 
				End If 
            cnt = cnt + 1 
         End If 
      Next     

		strLog = sprintf("********* In SetQUserInBlock User[{0}] = {1}, q_num = {2}, sp = {3}, ep = {4}, nEmpty = {5}, rNum = {6}, pos = {7}", _ 
				Array(uIdx, rAryQUser(9, uIdx), q_num, sp, ep, nEmpty, rNum, pos))
		' ' Call TraceLog(SPORTS_LOG1, strLog) 

		If(pos <> -1) Then 
			' pos에 넣기만 하면 된다. fUse, pos, pos_kind, pos_val, playerCode(gGroupIdx), cUser, user, cTeam, team
			rAryQPos(0, pos) 	= 1       						 ' fUse      
			rAryQPos(4, pos) 	= rAryQUser(6, uIdx)        ' playerCode
			rAryQPos(5, pos) 	= rAryQUser(1, uIdx)        ' teamOrder
			rAryQPos(6, pos) 	= rAryQUser(8, uIdx)        ' cUser
			rAryQPos(7, pos) 	= rAryQUser(9, uIdx)        ' user
			rAryQPos(8, pos) 	= rAryQUser(10, uIdx)       ' cTeam
			rAryQPos(9, pos) 	= rAryQUser(11, uIdx)       ' team
			rAryQPos(10, pos) = rAryQUser(5, uIdx)        ' player Order
		End If 
      
   End Function 

'   ===============================================================================     
'     aryQPos에서 t_no와 일치하는 Count를 추출한다. 

'   ===============================================================================  
	Function GetInsertAryQArea(rAryQPos, teamNo, cntQ)
		Dim Idx, ub , minCnt, teamCnt 
		Dim aryTeamCnt, aryQArea

		Call GetSameTeamInQPos(rAryQPos, aryTeamCnt, teamNo)

		ReDim aryQArea(cntQ-1)
		minCnt = 100

		' aryQTeam에서 최소값을 구한다. 		
		For Idx = 0 To (cntQ-1)
			teamCnt = CDbl(aryTeamCnt(1, Idx))
			If(teamCnt < minCnt) Then minCnt = teamCnt End If 
		Next 

		' aryTeamCnt에서 최소값을 가지는 Block을 구한다. 
		For Idx = 0 To (cntQ-1)
			teamCnt = CDbl(aryTeamCnt(1, Idx))

			If(teamCnt = minCnt) Then 
				aryQArea(Idx) = 1
			Else 
				aryQArea(Idx) = 0
			End If 
		Next 

		GetInsertAryQArea = aryQArea
	End Function 

'   ===============================================================================     
'     aryQPos에서 t_no와 일치하는 Count를 추출한다. 
'     단 이때 Full인 Block은 4을 셋팅한다. 
'   ===============================================================================   
	Function GetSameTeamInQPos(rAryQPos, rAryTeamCnt, t_no)
		Dim Idx, ub, sp, ep , cnt , cntQ

		ub = UBound(rAryQPos, 2)		
		cntQ = (ub+1) / CON_QGROUP_USER

		ReDim rAryTeamCnt(2, cntQ)
		cnt = 0

		

		For Idx = 0 To ub Step CON_QGROUP_USER
			sp = Idx 
			ep = (sp + CON_QGROUP_USER) - 1

			rAryTeamCnt(0, cnt) = (Idx / CON_QGROUP_USER) + 1
			rAryTeamCnt(1, cnt) = CheckSameTeamInQBlock(rAryQPos, t_no, sp, ep)
			cnt = cnt + 1
		Next 
	End Function  

'   ===============================================================================     
'     Q Block에서 teamNo와 일치하는 position count를 한다. 
'     단 이때 Full인 Block은 4을 셋팅한다. 
'   =============================================================================== 
	Function CheckSameTeamInQBlock(rAryQPos, t_no, s_pos, e_pos)
		Dim Idx, teamNo, cntUsed, fUse , cntTeam   

		'strLog = sprintf("********* In CheckSameTeamInQBlock t_no = {0}, s_pos = {1}, e_pos = {2}", Array(t_no, s_pos, e_pos))
		'' ' ' ' Call TraceLog(SPORTS_LOG1, strLog) 

		cntUsed 	= 0
		cntTeam	= 0 
		For Idx = s_pos To e_pos 
			fUse = CDbl(rAryQPos(0, Idx))
			If(fUse = 1) Then 
				teamNo = CDbl(rAryQPos(5, Idx))

				If(teamNo = t_no) Then 
					cntTeam = cntTeam + 1
					'strLog = sprintf("------------ SameTeam In QBlock t_no = {0}, QPos = {1}", Array(t_no, Idx))
					'' ' ' ' Call TraceLog(SPORTS_LOG1, strLog) 
				End If 
				cntUsed = cntUsed + 1
			End If 
		Next 

		If(cntUsed = CON_QGROUP_USER) Then cntTeam = CON_QGROUP_USER End If 
		CheckSameTeamInQBlock = cntTeam 
	End Function 

	Function GetInsertAryQOutArea(rAryPos, rAryInsert, teamNo, cntQ)
		Dim Idx, ub , minCnt, teamCnt, IsInsert 
		Dim aryTeamCnt, aryQArea

		Call GetSameQTeamInTournament(rAryPos, aryTeamCnt, teamNo, cntQ)

		ReDim aryQArea(3-1, cntQ-1)
		minCnt = 100

		' --------------------------- block size 4 Check 
		' rAryInsert 에서 1인 값 중에서만 체크  - aryQTeam에서 최소값을 구한다. 		
		For Idx = 0 To (cntQ-1)
			If(rAryInsert(Idx) = 1) Then 
				teamCnt = CDbl(aryTeamCnt(1, Idx))
				If(teamCnt < minCnt) Then minCnt = teamCnt End If 
			End If 
		Next 

		' aryTeamCnt에서 최소값을 가지는 Block을 구한다. 
		For Idx = 0 To (cntQ-1)
			If(rAryInsert(Idx) = 1) Then
				teamCnt = CDbl(aryTeamCnt(1, Idx))

				If(teamCnt = minCnt) Then 
					aryQArea(0, Idx) = 1
				Else 
					aryQArea(0, Idx) = 0
				End If 
			Else 
				aryQArea(0, Idx) = 0
			End If 
		Next 

		' --------------------------- block size 8 Check 
		' aryQArea(0, Idx) 에서 1인 값 중에서만 체크  - aryQTeam에서 최소값을 구한다. 		
		For Idx = 0 To (cntQ-1)
			If(aryQArea(0, Idx) = 1) Then 
				teamCnt = CDbl(aryTeamCnt(2, Idx))
				If(teamCnt < minCnt) Then minCnt = teamCnt End If 
			End If 
		Next 

		' aryTeamCnt에서 최소값을 가지는 Block을 구한다. 
		For Idx = 0 To (cntQ-1)
			If(aryQArea(0, Idx) = 1) Then 
				teamCnt = CDbl(aryTeamCnt(2, Idx))

				If(teamCnt = minCnt) Then 
					aryQArea(1, Idx) = 1
				Else 
					aryQArea(1, Idx) = 0
				End If 
			Else 
				aryQArea(1, Idx) = 0
			End If 
		Next

		' --------------------------- block size 16 Check 
		' aryQArea(1, Idx) 에서 1인 값 중에서만 체크  - aryQTeam에서 최소값을 구한다. 		
		For Idx = 0 To (cntQ-1)
			If(aryQArea(1, Idx) = 1) Then 
				teamCnt = CDbl(aryTeamCnt(3, Idx))
				If(teamCnt < minCnt) Then minCnt = teamCnt End If 
			End If 
		Next 

		' aryTeamCnt에서 최소값을 가지는 Block을 구한다. 
		For Idx = 0 To (cntQ-1)
			If(aryQArea(1, Idx) = 1) Then 
				teamCnt = CDbl(aryTeamCnt(3, Idx))

				If(teamCnt = minCnt) Then 
					aryQArea(2, Idx) = 1
				Else 
					aryQArea(2, Idx) = 0
				End If 
			Else 
				aryQArea(2, Idx) = 0
			End If 
		Next

		GetInsertAryQOutArea = aryQArea
	End Function 

'   ===============================================================================     
'     예선조의 본선 토너먼트 에서의 teamNo 중복 Count를 얻는다. 
' 			rAryTeamCnt : 0 : 예선조 No, 1: szBlock = 4, 2: szBlock = 8, 3: szBlock = 16
'   ===============================================================================   
	Function GetSameQTeamInTournament(rAryPos, rAryTeamCnt, t_no, cntQ)
		Dim Idx, arySameCnt

		' 0 : 예선조 No, 1: szBlock = 4, 2: szBlock = 8, 3: szBlock = 16
		ReDim rAryTeamCnt(4-1, cntQ-1)		

		For Idx = 0 To cntQ-1						
			rAryTeamCnt(0, Idx) = Idx + 1
			Call GetQTeamCntInTournamentBlock(rAryPos, arySameCnt, Idx + 1, t_no)
			
			rAryTeamCnt(1, Idx) = arySameCnt(1, 0)
			rAryTeamCnt(2, Idx) = arySameCnt(1, 1)
			rAryTeamCnt(3, Idx) = arySameCnt(1, 2)			
		Next 

		strLog = sprintf("GetSameQTeamInTournament - rAryTeamCnt t_no = {0}, cntQ = {1}", Array(t_no, cntQ))
      ' ' ' ' Call TraceLog2Dim(SAMALL_LOG1, rAryTeamCnt, strLog)
	End Function  

'   ===============================================================================     
'     예선조 조 번호를 입력받아 본선 토너먼트로 부터 TeamCount를 얻는다. 
' 		1. 본선 Tournament의 Q Position을 구한다. 
' 		2. szBlock >= 16이면 16, 8, 4 / 그 이하면 그 이하의 값의 Block에서 Same teamCount를 구한다. 
'   ===============================================================================   
	Function GetQTeamCntInTournamentBlock(rAryPos, rArySameCnt, nQ, t_no)
		Dim Idx, ub, QNum , QPos, szBlock
		Dim aryTmp, sp, ep, teamCnt , teamNo, cnt
		Dim key, keyType, IsDesc, posKind

		' nQ을 입력받아 해당 예선조 번호의 본선 대진표 pos을 구한다. 
      QPos = -1 
		ub = UBound(rAryPos, 2)
		For Idx = 0 To ub          
         posKind = CDbl(rAryPos(2,Idx))
         If(posKind = E_POS_Q) Then 
            QNum = CDbl(rAryPos(3,Idx))

            If(QNum = nQ) Then 
               QPos = Idx 					' 본선 Tournament의 Q Position을 구했다. 				
               Exit For 
            End If 
         End If 
		Next 

		If(QPos = -1) Then 
         ' ' ' ' Call TraceLog(SAMALL_LOG1, "Error QPos In GetQTeamCntInTournamentBlock---------------" )
         Exit Function 
      End If 

		' ----------------------------------------------		
		ReDim rArySameCnt(4-1, 3-1)		' 0:size block , 1 : Count, / 4, 8, 16 block 

		For Idx = 0 To 3-1
			rArySameCnt(0,Idx) = 512 			' sort를 위해 기본값을 512로 셋팅. 값이 없으면 제일 뒤로 정렬된다. 
		Next             
		
		szBlock = GetOutBlockSizeOfQ(ub + 1)
		teamNo = t_no 
		cnt = 3-1

		While( (szBlock > 2) And (cnt > -1) )      
			Call GetRangeInBlock(QPos, szBlock, sp, ep)

			rArySameCnt(0,cnt) = szBlock 
  			rArySameCnt(1,cnt) = GetCntSameTeamInOutBlockOfQ(rAryPos, teamNo, sp, ep)			
			rArySameCnt(2,cnt) = sp 
			rArySameCnt(3,cnt) = ep 
			szBlock = szBlock / 2 
			cnt = cnt - 1
		wEnd		

'		' szBlock 4, 8, 16 순으로 Count를 정렬한다. 
'		key 				= 0				' szBlock 4, 8, 16
'		keyType 			= 2				' data type is number 
'		IsDesc 			= 0
'		Call Sort2DimAryEx(rArySameCnt, key, keyType, IsDesc)	
		' ----------------------------------------------

		'strLog = sprintf("GetQTeamCntInTournamentBlock - arySameCnt t_no = {0}, nQ = {1}, QPos = {2}", Array(t_no, nQ, QPos))
		'' ' ' ' Call TraceLog2Dim(SAMALL_LOG1, rArySameCnt, strLog)
	End Function 

'   ===============================================================================     
'     block에서 teamNo와 일치하는 Count를 반환한다. 
'   ===============================================================================
	Function GetCntSameTeamInOutBlockOfQ(rAryPos, t_no, s_pos, e_pos)
		Dim Idx, ub , cntTeam, teamNo 

		ub = UBound(rAryPos, 2)
		If(s_pos < 0) Or (e_pos > ub) Then 
			Exit Function 
		End If

		cntTeam = 0
		For Idx = s_pos To e_pos
			teamNo = CDbl(rAryPos(5, Idx))

			If(teamNo = t_no) Then 
				cntTeam = cntTeam + 1
			End If 
		Next 
		GetCntSameTeamInOutBlockOfQ = cntTeam 
   End Function 

'   ===============================================================================     
'     block에서 할당된 인원의 Count를 센다. 
'   ===============================================================================
	Function GetCntAssignBlockOfQ(rAryQPos, s_pos, e_pos)
		Dim Idx, ub , cntAssign

		ub = UBound(rAryQPos, 2)
		If(s_pos < 0) Or (e_pos > ub) Then 
			Exit Function 
		End If

		cntAssign = 0
		For Idx = s_pos To e_pos
			If (CDbl(rAryQPos(0, Idx)) = 1) Then 
				cntAssign = cntAssign + 1
			End If 
		Next 
		GetCntAssignBlockOfQ = cntAssign 
   End Function 

'   ===============================================================================     
'     pos을 입력받아 position이 위치한 block의 start , end point를 반환한다. 
'   ===============================================================================
	Function GetRangeInBlock(nPos, szBlock, ByRef refSp, ByRef refEp)
		refSp = (Fix(nPos / szBlock)) * szBlock 
		refEp = refSp + szBlock - 1
   End Function 

    
'   ===============================================================================     
'     Q를 배치할때 참고할 본선의 Block size를 구한다. 
'   ===============================================================================
	Function GetOutBlockSizeOfQ(nRound)
		Dim size 

		Select Case nRound
			Case 4
				size = 2
			Case 8
				size = 4
			Case 16
				size = 4
			Case 32
				size = 8
			Case 64
				size = 16
			Case 128
				size = 16
			Case 256
				size = 16
			Case Else	
				size = 1
		End Select

		GetOutBlockSizeOfQ = size 
	End Function 

'   ===============================================================================     
'     본선에 Q 자리를 셋팅한다. 
'     rAryPart에는 각 Q를 Part A,B,C,D중 어디에 할당할지를 셋팅한 위치값이 들어 있다. 
'     s_pos : rAryPos을 Part A,B,C,D로 나누었을때 block start position 
'     e_pos : rAryPos을 Part A,B,C,D로 나누었을때 block end position 
'		szMin : Q를 배치할 block의 최소 size ( Q는 최대 4 position 에 1개씩 배치할 수 있다. )
'     Q를 배치하는데 nPart와 일치하는 Q만 배치한다. 
'         따라서 AssignQPos(... E_PART_A), AssignQPos(... E_PART_B), AssignQPos(... E_PART_C), AssignQPos(... E_PART_D)
'			 와 같이 4번 호출하여야 한다. 
'   ===============================================================================   
	Function AssignQPos(rAryPos, rAryPart, nPart)
		Dim ub, ubP, Idx, szMin
		Dim s_pos, e_pos	

		szMin = 	CON_QGROUP_USER
		ubP = UBound(rAryPos, 2)
		ub = UBound(rAryPart)

		nCnt = ((ubP+1) / 4) 

		' aryPos을 4개의 part로 나눈다. 
		If(nPart = E_PART_A) Then 
			s_pos = 0
			e_pos = nCnt -1
		ElseIf(nPart = E_PART_B) Then  
			s_pos = nCnt
			e_pos = (nCnt*2)-1
		ElseIf(nPart = E_PART_C) Then  
			s_pos = (nCnt*2)
			e_pos = (nCnt*3)-1
		ElseIf(nPart = E_PART_D) Then   
			s_pos = (nCnt*3)
			e_pos = ubP
		End If 

		' Q를 배치하는데 nPart와 일치하는 Q만 배치한다. 
		For Idx = 0 To ub 
			If(rAryPart(Idx) = nPart) Then 				
				Call binaryAssignQPos(rAryPos, s_pos, e_pos, Idx+1, szMin)
			End If 
		Next 
	End Function 

'   ===============================================================================     
'     본선에 Q 자리를 셋팅한다. - 
'			1. Q의 갯수를 입력받아 A, B, C, D 4개의 파트에 균일한 갯수를 랜덤하게 할당한다. 
'			2. 4개 단위로 Random하게 Q를 배치한다 .
'			3. Q는 최대 4개 단위의 Block에 1개씩 들어 가도록 되어 있기 때문에
'			   Block을 두개로 나누어서 , 각 Part에 있는 Q의 갯수가 적은데를 찾는다. 
'			4. Q의 갯수가 0개인 block이 나오면 Q를 랜덤하게 할당한다. 
'   ===============================================================================   
	Function binaryAssignQPos(rAryPos, sPos, ePos, QIdx, szMin)
		Dim szArea, szHalf, cntQ1, cntQ2, s_pos, e_pos
		Dim sp1, sp2, ep1, ep2 				' position 

		s_pos = sPos 
		e_pos = ePos 
		
		szArea = (e_pos - s_pos) + 1  
		szHalf = szArea / 2
		
		' For Debug -----------------------------------
		If(cntBinCall > 20) Then 
			cntBinCall = 0
			Exit Function 
		End If 
		cntBinCall = cntBinCall + 1
		' For Debug -----------------------------------

		strLog = sprintf("binaryAssignQPos s_pos = {0}, e_pos = {1}, QIdx = {2}, szMin = {3}, szArea = {4}, szHalf = {5}", _ 
						Array(s_pos, e_pos, QIdx, szMin, szArea, szHalf))
		'' ' ' ' ' ' ' Call TraceLog(SPORTS_LOG1, strLog) 

		If(szArea <= szMin) Then 
			Call SetQPos(rAryPos, s_pos, e_pos, QIdx)
		Else 
			' A part, B part area 
			sp1 = s_pos
			ep1 = s_pos + (szHalf) - 1
			sp2 = ep1 + 1
			ep2 = e_pos 

			cntQ1 = getQCountInBlock(rAryPos, sp1, ep1)
			cntQ2 = getQCountInBlock(rAryPos, sp2, ep2)

			strLog = sprintf("sp1 = {0}, ep1 = {1}, sp2 = {2}, ep2 = {3}, cntQ1 = {4}, cntQ2 = {5}", _ 
						Array(sp1, ep1, sp2, ep2, cntQ1, cntQ2))
		'	' ' ' ' ' ' ' Call TraceLog(SPORTS_LOG1, strLog) 

			If(cntQ1 > cntQ2) Then 
				If(cntQ2 = 0) Then 
					Call SetQPos(rAryPos, sp2, ep2, QIdx)
				Else 
					Call binaryAssignQPos(rAryPos, sp2, ep2, QIdx, szMin)
				End If 
			Else 
				If(cntQ1 = 0) Then 
					Call SetQPos(rAryPos, sp1, ep1, QIdx)
				Else 
					Call binaryAssignQPos(rAryPos, sp1, ep1, QIdx, szMin)
				End If 
			End If 
		End If 
	End Function 

'   ===============================================================================     
'     Q를 셋팅할 Block을 찾았다. 
'		Block안에서 Random하게 배치하자. 
'   ===============================================================================   
	Function SetQPos(rAryPos, sPos, ePos, QIdx)
		Dim Idx, ub , nEmpty, cnt, rNum
		Dim s_pos, e_pos

		s_pos = sPos 
		e_pos = ePos 

		ub = UBound(rAryPos, 2)
		If(s_pos < 0) Then s_pos = 0 End If 
		If(e_pos > ub) Then e_pos = ub End If 

		nEmpty = 0 
		For Idx = s_pos To e_pos 
			If(rAryPos(0, Idx) <> 1) Then 
				nEmpty = nEmpty + 1
			End If 
		Next 

		rNum = GetRandomNum(nEmpty) -1

		cnt = 0
		For Idx = s_pos To e_pos 
			If(rAryPos(0, Idx) <> 1) Then 
				If(cnt = rNum) Then 						
					rAryPos(0, Idx) = 1                   ' fuse - Q를 할당하였다. 
					rAryPos(2, Idx) = E_POS_Q
					rAryPos(3, Idx) = QIdx
					Exit For 
				End If 
				cnt = cnt + 1
			End If 
		Next 

		strLog = sprintf("SetQPos s_pos = {0}, e_pos = {1}, QIdx = {2}, Idx = {3}, nEmpty = {4}, rNum = {5}", _ 
						Array(s_pos, e_pos, QIdx, Idx, nEmpty, rNum))
	'	' ' ' ' ' ' ' Call TraceLog(SPORTS_LOG1, strLog) 
	End Function 

%>


<% 	  
'   ===============================================================================     
'     algorithm function 
'   ===============================================================================  

'   ===============================================================================     
'     예선조를 aryQPos에 배치한다. 		- 복식 
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
	Function SetQUserDbl(rAryQUser, rAryQPos, rAryPos)
		Dim Idx, ub, key, keyType, IsDesc
		ub = UBound(rAryQUser, 2)

		'' ' ' ' Call TraceLog2Dim(SAMALL_LOG1, rAryQUser, "SetQUser - Prev SetTeamCntToUserAry rAryQUser")
		Call SetTeamCntToUserAry(rAryQUser)		' aryUser에 teamCount를 셋팅한다. - 추후 sort에서 사용한다. 

		' 팀별 정렬후 , 인원수로 정렬한다. 
		key = 1
		keyType = 2
		IsDesc = 0 
		Call Sort2DimAryEx(rAryQUser, key, keyType, IsDesc)	

		key = 14
		keyType = 2
		IsDesc = 1 
		Call Sort2DimAryEx(rAryQUser, key, keyType, IsDesc)	

		'' ' ' ' Call TraceLog2Dim(SAMALL_LOG1, rAryQUser, "SetQUser - rAryQUser")
		'' ' ' ' Call TraceLog2Dim(SAMALL_LOG1, rAryPos, "SetQUser - rAryPos")
		'' ' ' ' Call TraceLog2Dim(SAMALL_LOG1, rAryQPos, "SetQUser - rAryQPos")

		

		For Idx = 0 To ub Step 2		' 복식이므로 2명씩 
			strLog = sprintf("User[{0}] = {1}, team = {2}-{3}, User[{4}] = {5}, team = {6}-{7}", _ 
				Array(Idx, rAryQUser(9, Idx), rAryQUser(1, Idx), rAryQUser(11, Idx), Idx+1, rAryQUser(9, Idx+1), rAryQUser(1, Idx+1), rAryQUser(11, Idx+1)))
			' ' Call TraceLog(SPORTS_LOG1, strLog) 
			Call SetQUserToPosDbl(rAryQUser, rAryQPos, rAryPos, Idx)	
		Next 		
	End Function 

'   ===============================================================================     
'     user를 선택하여 aryQPos에 할당한다. 
'     teamNo와 일치하는 SameCount 최소값의 예선조를 구한다. 
'     구해진 예선조들에서 본선 Tournament Block4에서의 최소 SameCount 예선조를 구한다. 
'     구해진 예선조들에서 본선 Tournament Block8에서의 최소 SameCount 예선조를 구한다. 
'     구해진 예선조들에서 본선 Tournament Block16에서의 최소 SameCount 예선조를 구한다. 

'     예선조 부터 최소값을 구하여 재귀적으로 최소값을 구한 값이기 때문에 
'     block16에서 구해진 예선조가 있으면 그 예선조들 중에 랜덤하게 배치한다.  
'     block8에서 구해진 예선조가 있으면 그 예선조들 중에 랜덤하게 배치한다. 
'     block4에서 구해진 예선조가 있으면 그 예선조들 중에 랜덤하게 배치한다. 
'     예선조에서 구해진 예선조가 있으면 그 예선조들 중에 랜덤하게 배치한다. 
'   =============================================================================== 
	Function SetQUserToPosDbl(rAryQUser, rAryQPos, rAryPos, uIdx)				
		Dim ub, Idx, cntQ, teamNo, sameTeamCnt, QNum, rNum, cnt
		Dim aryQArea, aryQOutArea, aryAssign, cntAssign, blockIdx
		Dim sp, ep , minCnt 

		ub = UBound(rAryQPos, 2)		
		cntQ = (ub+1) / CON_QGROUP_USER

		teamNo = CDbl(rAryQUser(1, uIdx))
		cntAssign = 0

		strLog = sprintf("In SetQUserToPos User[{0}] = {1}, team = {2}-{3}, cntQ = {4}, teamNo = {5}", _ 
				Array(uIdx, rAryQUser(9, uIdx), rAryQUser(1, uIdx), rAryQUser(11, uIdx), cntQ, teamNo))
		' ' Call TraceLog(SPORTS_LOG1, strLog) 

		' 0 : assign 가능 여부 , 1: 현재 할당된 Count
		ReDim aryAssign(2-1, cntQ-1)

		' 현재 할당된 인원수를 셋팅한다. 
		For Idx = 0 To cntQ - 1
			sp = Idx * CON_QGROUP_USER
			ep = sp + (CON_QGROUP_USER - 1)
			aryAssign(1, Idx) = GetCntAssignBlockOfQ(rAryQPos, sp, ep)
		Next 

		aryQArea 		= GetInsertAryQArea(rAryQPos, teamNo, cntQ)
		aryQOutArea		= GetInsertAryQOutArea(rAryPos, aryQArea, teamNo, cntQ)

		' 먼저 block16, 8, 4의 값들을 순차적으로 검사한다. 
		blockIdx = 2  ' 2: 16, 1: 8, 0: 4		
		For Idx = 0 To 3-1
			cntAssign = 0
			For m = 0 To cntQ-1
				If(aryQOutArea(blockIdx, m) = 1) Then 
					aryAssign(0, m) = 1
					cntAssign = cntAssign + 1
				Else
					aryAssign(0, m) = 0
				End If 
			Next

			If(cntAssign > 0) Then 		' 배치할 곳을 찾았다. 
				Exit For 
			End If 

			blockIdx = blockIdx - 1
		Next 

		' ' Call TraceLog1Dim(SPORTS_LOG1, aryQArea, 20, "--------------- aryQArea ")
		' ' Call TraceLog2Dim(SAMALL_LOG1, aryQOutArea, "IN SetQUserToPos - aryQOutArea")

		If(cntAssign = 0) Then 
			For Idx = 0 To cntQ - 1
				If(aryQArea(Idx) = 1) Then 
					aryAssign(0, Idx) = 1
					cntAssign = cntAssign + 1
				Else
					aryAssign(0, Idx) = 0
				End If 
			Next 
		End If 

		' 인원이 적은쪽에 배치한다. 
		QNum = -1
		minCnt = 100

		If(cntAssign > 0) Then 		' 배치할 곳을 찾았다.		
			For Idx = 0 To cntQ - 1 
				If(aryAssign(0, Idx) = 1) Then 
					If(minCnt > aryAssign(1, Idx)) Then 
						minCnt = aryAssign(1, Idx)
						QNum = Idx 
					End If 
				End If 
			Next 

			For Idx = 0 To cntQ - 1 
				If(aryAssign(0, Idx) = 1) Then 
					If(minCnt <> aryAssign(1, Idx)) Then 
						aryAssign(0, Idx) = 0
						cntAssign = cntAssign - 1
					End If 
				End If 
			Next 
		End If 

		QNum = -1
		If(cntAssign > 0) Then 		' 배치할 곳을 찾았다.
			rNum = GetRandomNum(cntAssign) -1
			cnt = 0			
			For Idx = 0 To cntQ - 1 
				If(aryAssign(0, Idx) = 1) Then 
						If(cnt = rNum) Then 						
							QNum = Idx 
							Exit For 
						End If 
						cnt = cnt + 1
				End If 
			Next 
		End If 

		strLog = sprintf("In SetQUserToPos cntAssign = {0}, rNum = {1}, QNum = {2}", _ 
				Array(cntAssign, rNum, QNum))
		' ' ' ' Call TraceLog(SPORTS_LOG1, strLog) 
		
		If(QNum > -1) Then 			
			Call SetQUserInBlockDbl(rAryQPos, rAryQUser, uIdx, QNum) 
		Else 

		End If 
	End Function 	

'   ===============================================================================     
'      aryQPos에 aryQUser를 할당한다.        - 단식 
'      sp로 부터 block 단위로 구분한다. 
'      1, 4, 3, 2 순으로 user를 배치한다. - 의미 없음. 
'      빈자리는 Bye로 채워 지기 때문에 빈자리에 채우기만 하면 된다. 
'   ===============================================================================  
   Function SetQUserInBlockDbl(rAryQPos, rAryQUser, uIdx, q_num)
      Dim Idx, ub, ret, pos, sp, ep 
		Dim rNum, nEmpty , cnt 

		sp = q_num * CON_QGROUP_USER
		ep = (sp + CON_QGROUP_USER) - 1

		pos = -1
		nEmpty = 0
		For Idx = sp To ep          
         If(rAryQPos(0, Idx) = 0) Then 
            nEmpty = nEmpty + 1
				pos = Idx 					' 임시 - position을 못찾을 경우를 대비해서 셋팅 
         End If 
      Next  

		rNum = GetRandomNum(nEmpty) - 1

		cnt = 0 		
		For Idx = sp To ep    
         If(rAryQPos(0, Idx) = 0) Then 
				If(rNum = cnt) Then 
					pos = Idx				' 값을 찾았다.  
					Exit For 
				End If 
            cnt = cnt + 1 
         End If 
      Next     

		strLog = sprintf("********* In SetQUserInBlock User[{0}] = {1}, User[{2}] = {3}, q_num = {4}, sp = {5}, ep = {6}, nEmpty = {7}, rNum = {8}, pos = {9}", _ 
				Array(uIdx, rAryQUser(9, uIdx), uIdx+1, rAryQUser(9, uIdx+1), q_num, sp, ep, nEmpty, rNum, pos))
		' ' Call TraceLog(SPORTS_LOG1, strLog) 

		If(pos <> -1) Then 
			' pos에 넣기만 하면 된다. fUse, pos, pos_kind, pos_val, playerCode(gGroupIdx), cUser, user, cTeam, team
			uIdx2 = uIdx + 1 
			rAryQPos(0, pos) 	= 1       						' fUse      
			rAryQPos(4,pos) = rAryQUser(6,uIdx)         	' playerCode - GroupIdx
			rAryQPos(5,pos) = rAryQUser(1,uIdx)         	' team order

			rAryQPos(6,pos) = rAryQUser(8,uIdx)         	' cUser
			rAryQPos(7,pos) = rAryQUser(9,uIdx)         	' user			
			rAryQPos(8,pos) = rAryQUser(8,uIdx2)         	' cUser
			rAryQPos(9,pos) = rAryQUser(9,uIdx2)         	' user			

			rAryQPos(10,pos) = rAryQUser(10,uIdx)         ' cTeam
			rAryQPos(11,pos) = rAryQUser(11,uIdx)         ' team			
			rAryQPos(12,pos) = rAryQUser(10,uIdx2)        ' cTeam
			rAryQPos(13,pos) = rAryQUser(11,uIdx2)        ' team

			rAryQPos(14,pos) = rAryQUser(5,uIdx)       	' player order
		End If 
      
   End Function 
%>





<%
'   ===============================================================================     
'      단식 
'   =============================================================================== 
	
'   ===============================================================================     
'      aryUser로 부터 aryPos에 User를 할당한다.                    
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
'			6. 각 Block에 할당할수 있는 빈 공간 갯수를 구한다. nEmtpy 
'			7. 만약 nEmpty가 하나도 없으면 반대편 Block을 선택한다. 
'			8. nEmptyA, nEmptyB가 둘다 있다면 비교를 시작한다 .
' 			9. nSameTeam의 값이 제일 적은 팀에 할당한다. 
' 			10. 만약 nSameTeam의 최소값이  2개 이상 겹칠때는 nAssignUser의 갯수가 적은 Part을 선택한다. 
' 			11. nAssignUser의 최소값 마저 2개 이상 겹칠때는 Random하게 배치한다. 
' 			12. nBlock Size = 4 가 될때까지 1~11을 반복한다. 
' 			13. nBlock Size = 4 인데 nSameTeam == 0인 Block을 찾았으면 그곳에 인원을 할당한다. 
' 			14. nBlock Size = 4 인데 nSameTeam == 0인 Block을 못 찾았으면 
' 			      해당 Block의 최상위 Block( 처음 반으로 나눈)에서 인원을 할당한다. 
'   =============================================================================== 
	Function SetUserToPos(rAryPos, rAryUser)
		Dim ub, ubP, Idx, nChangeAssign   		
		Dim key, keyType, IsDesc , seedNo
		
		ub = UBound(rAryUser, 2)
		ubP = UBound(rAryPos, 2)

		nChangeAssign = GetAssignChangeBase(rAryUser) - 1
      
		For Idx = 0 To nChangeAssign
			cntSelfCall	= 0
         seedNo = CDbl(rAryUser(2, Idx))

         If(seedNo < 1) Then 
				strLog = sprintf("-----------user Idx = {0}, name = {1}({2})", Array(idx, rAryUser(9, Idx), rAryUser(11, Idx)) )
				' ' Call TraceLog(SPORTS_LOG1, strLog) 
				Call binSetUserToPos(rAryPos, rAryUser, Idx, 0, ubP)
			Else 
				strLog = sprintf("-----------Seed No Set --- user Idx = {0}, name = {1}({2})",  Array(idx, rAryUser(9, Idx), rAryUser(11, Idx)) )
				' ' Call TraceLog(SPORTS_LOG1, strLog)          				
			End If 
		Next 

		' 2차 할당 - teamCount순		
		Call SetTeamCntToUserAry(rAryUser)		' aryUser에 teamCount를 셋팅한다. - 추후 sort에서 사용한다. 

		key = 14
		keyType = 2
		IsDesc = 1 
		Call Sort2DimAryEx(rAryUser, key, keyType, IsDesc)	

		For Idx = 0 To ub 
			If(rAryUser(0, Idx) <> 1) Then 	' 할당하지 않은 
				cntSelfCall	= 0        
            seedNo = CDbl(rAryUser(2, Idx))

            If(seedNo < 1) Then 
					strLog = sprintf("-----------user Idx = {0}, name = {1}({2})",  Array(idx, rAryUser(9, Idx), rAryUser(11, Idx)) )
					' ' Call TraceLog(SPORTS_LOG1, strLog) 
					Call binSetUserToPos(rAryPos, rAryUser, Idx, 0, ubP)
				Else 
					strLog = sprintf("-----------Seed No Set --- user Idx = {0}, name = {1}({2})",  Array(idx, rAryUser(9, Idx), rAryUser(11, Idx)) )			
					' ' Call TraceLog(SPORTS_LOG1, strLog)          				
				End If 
			End If 
		Next 

	End Function 

'   ===============================================================================     
'      재귀 호출 .. 
'      block size <= 4일때 까지 혹은 teamNo가 0인 block을 만날때 까지 
'      block을 2개의 부분으로 나눈후 각각의 Block의 position value를 체크한다. 

' 		 각각의 Block에서 code_team과 일치하는 User의 Count를 구한다.    nSameTeam
' 		 각 Block에 할당된 user Count를 구한다.    nAssignUser
'		 각 Block에 할당할수 있는 빈 공간 갯수를 구한다. nEmtpy 
'   =============================================================================== 
	Function binSetUserToPos(rAryPos, rAryUser, uIdx, sp, ep)
		Dim Idx, ub
		Dim sp1, sp2, ep1, ep2, half, szBlock , IsFirst
		Dim teamNo, cntUser1, cntUser2, cntEmpty1, cntEmpty2, cntCheck1, cntCheck2

		szBlock = (ep - sp) + 1
		half = szBlock / 2
		
		If(szBlock <= SZ_BLOCK_MIN) Then 			' block size가 최소다.  그냥 Random하게 배치하자 
			' ' Call TraceLog(SPORTS_LOG1, "randomSetUserToPos - block size가 최소다.  그냥 Random하게 배치하자 ") 
			Call randomSetUserToPos(rAryPos, rAryUser, uIdx)
			Exit Function 
		End If 

		If(cntSelfCall >= maxSelfCall) Then 	' 재귀 호출이 maxCount를 넘었다. 이만 끝내자 
			' ' Call TraceLog(SPORTS_LOG1, "randomSetUserToPos - 재귀 호출이 maxCount를 넘었다. 이만 끝내자  ") 
			Call randomSetUserToPos(rAryPos, rAryUser, uIdx)
			Exit Function 
		End If 
		cntSelfCall = cntSelfCall + 1				' 재귀 호출 제어 카운트 
		
		sp1 = sp 
		ep1 = (sp + half) - 1
		sp2 = ep1 + 1 
		ep2 = ep 

		teamNo = CDbl(rAryUser(1, uIdx))
		IsFirst = 0
		If(rAryUser(5, uIdx) = "1") Then IsFirst = 1 End If 		' 1장 선수이다. 

		' ---------------------------------------------------------------
		' 1장이면 teamCheck대신 1장 체크를 한다. 
		cntUser1 	= getAssignCountInBlock(rAryPos, sp1, ep1)
		cntEmpty1 	= getEmptyCountInBlock(rAryPos, teamNo, IsFirst, sp1, ep1)
		If(IsFirst) Then 
			cntCheck1 	= getFirstCountInBlock(rAryPos, sp1, ep1)
		Else 			
			cntCheck1 	= getTeamCountInBlock(rAryPos, teamNo, sp1, ep1)
		End If 

		cntUser2 	= getAssignCountInBlock(rAryPos, sp2, ep2)
		cntEmpty2 	= getEmptyCountInBlock(rAryPos, teamNo, IsFirst, sp2, ep2)
		If(IsFirst) Then 
			cntCheck2 	= getFirstCountInBlock(rAryPos, sp2, ep2)
		Else 			
			cntCheck2 	= getTeamCountInBlock(rAryPos, teamNo, sp2, ep2)
		End If 
		' ---------------------------------------------------------------

		strLog = sprintf("binSetUserToPos uIdx = {0}, name = {1}({2}), sp = {3}, ep = {4}, szBlock = {5}, half = {6}, cntSelfCall = {7}, teamNo = {8}, IsFirst = {9}  ", _ 
									 Array(uIdx, rAryUser(9, uIdx), rAryUser(11, uIdx), sp, ep, szBlock, half, cntSelfCall, teamNo, IsFirst) )
      ' ' Call TraceLog(SPORTS_LOG1, strLog) 

		strLog = sprintf("binSetUserToPos cntUser1 = {0}, cntEmpty1 = {1}, cntCheck1 = {2} // cntUser2 = {3}, cntEmpty2 = {4}, cntCheck2 = {5} ", _ 
									 Array(cntUser1, cntEmpty1, cntCheck1, cntUser2, cntEmpty2, cntCheck2) )
      ' ' Call TraceLog(SPORTS_LOG1, strLog) 

		If( cntEmpty1 = 0 And cntEmpty2 = 0) Then 				' 빈공간이 없다.  그냥 Random하게 배치하자 
			' ' Call TraceLog(SPORTS_LOG1, "randomSetUserToPos - 빈공간이 없다.  그냥 Random하게 배치하자   ") 
			Call randomSetUserToPos(rAryPos, rAryUser, uIdx)
			Exit Function 
		ElseIf( cntEmpty1 = 0 Or cntEmpty2 = 0) Then 
			If(cntEmpty1 = 0) Then 				' A Part에 빈공간이 없다. B쪽을 찾자 
				If(cntCheck2 = 0) Then 
					' ' Call TraceLog(SPORTS_LOG1, "procSetUserToPos - 찾았다. 여기에 배치하자  cntCheck2 = 0  #1") 	
					Call procSetUserToPos(rAryPos, rAryUser, uIdx, sp2, ep2)
				Else 
					Call binSetUserToPos(rAryPos, rAryUser, uIdx, sp2, ep2)
				End If 
			Else										' B Part에 빈공간이 없다. A쪽을 찾자 
				If(cntCheck1 = 0) Then 
					' ' Call TraceLog(SPORTS_LOG1, "procSetUserToPos - 찾았다. 여기에 배치하자  cntCheck1 = 0  #1") 	
					Call procSetUserToPos(rAryPos, rAryUser, uIdx, sp1, ep1)
				Else 
					Call binSetUserToPos(rAryPos, rAryUser, uIdx, sp1, ep1)
				End If 				
			End If 
		Else 
			If(cntCheck1 <> 0) And (cntCheck2 <> 0) Then 		' 배치된 Same Team Count Check 
				If(cntCheck1 > cntCheck2) Then 
					Call binSetUserToPos(rAryPos, rAryUser, uIdx, sp2, ep2)
				ElseIf(cntCheck1 < cntCheck2) Then  
					Call binSetUserToPos(rAryPos, rAryUser, uIdx, sp1, ep1)
				Else 
					If(cntUser1 > cntUser2) Then 					' 배치된 User Count Check 
						Call binSetUserToPos(rAryPos, rAryUser, uIdx, sp2, ep2)
					Else 
						Call binSetUserToPos(rAryPos, rAryUser, uIdx, sp1, ep1)
					End If 
				End If 
			Else 			' 찾았다. 여기에 배치하자 				
				If(cntCheck1 = 0) And (cntCheck2 = 0) Then 
					If(cntUser1 > cntUser2) Then 					' 배치된 User Count Check 
						' ' Call TraceLog(SPORTS_LOG1, "procSetUserToPos - 찾았다. 여기에 배치하자  cntCheck1,2 = 0 cntUser1 > cntUser2 #2") 			 
						Call procSetUserToPos(rAryPos, rAryUser, uIdx, sp2, ep2)
					Else 
						' ' Call TraceLog(SPORTS_LOG1, "procSetUserToPos - 찾았다. 여기에 배치하자  cntCheck1,2 = 0 cntUser1 <= cntUser2 #3") 			 
						Call procSetUserToPos(rAryPos, rAryUser, uIdx, sp1, ep1)
					End If 
				Else
					If(cntCheck1 = 0) Then 
						' ' Call TraceLog(SPORTS_LOG1, "procSetUserToPos - 찾았다. 여기에 배치하자  cntCheck1 = 0  #4") 			 
						Call procSetUserToPos(rAryPos, rAryUser, uIdx, sp1, ep1)
					Else 
						' ' Call TraceLog(SPORTS_LOG1, "procSetUserToPos - 찾았다. 여기에 배치하자  cntCheck2 = 0  #5") 	
						Call procSetUserToPos(rAryPos, rAryUser, uIdx, sp2, ep2)
					End If 
				End If 
			End If 
		End If 

	End Function 

	Function procSetUserToPos(rAryPos, rAryUser, uIdx, sp, ep)
		Dim Idx, ub , cntEmpty, rNum, cnt , pos

		ub = UBound(rAryPos, 2)
		If(sp < 0) Then sp = 0 End If 
		If(ep > ub) Then ep = ub End If 

		cntEmpty = 0
		cnt = 0
		rNum = 0 
		pos = -1 

		For Idx = sp To ep 
			If(rAryPos(0,Idx) <> 1) Then 
				cntEmpty = cntEmpty + 1
			End If 
		Next 

		rNum = GetRandomNum(cntEmpty) -1

		For Idx = sp To ep 
			If(rAryPos(0,Idx) <> 1) Then 
				If(cnt >= rNum) Then 
					pos = Idx 
					Exit For 
				End If 
				cnt = cnt + 1 
			End If 
		Next 

		' fUse, pos, pos_kind, pos_val, playerCode(gGroupIdx), teamOrder, cUser, user, cTeam, team
		If(pos = -1) Then 
			' ' Call TraceLog(SPORTS_LOG1, "-----------procSetUserToPos pos = -1 .. so randomSetUserToPos") 
			Call randomSetUserToPos(rAryPos, rAryUser, uIdx)
		Else		
			strLog = sprintf("-----------procSetUserToPos user uIdx = {0}, name = {1}({2}), pos = {3}", Array(uIdx, rAryUser(9, uIdx), rAryUser(11, uIdx), pos) )
      	' ' Call TraceLog(SPORTS_LOG1, strLog) 

			rAryUser(0, uIdx) = 1 
			rAryPos(0, pos) = 1		

			If(rAryUser(5, uIdx) = "1") Then 			' 1장 유무 
				rAryPos(2, pos) = E_POS_FIRST          ' 1장을 할당했다. 
			Else 
				rAryPos(2, pos) = E_POS_NORMAL 
			End If    

			rAryPos(4,pos) = rAryUser(6,uIdx)         ' playerCode - GroupIdx
			rAryPos(5,pos) = rAryUser(1,uIdx)         ' team order
			rAryPos(6,pos) = rAryUser(8,uIdx)         ' cUser
			rAryPos(7,pos) = rAryUser(9,uIdx)         ' user
			rAryPos(8,pos) = rAryUser(10,uIdx)         ' cTeam
			rAryPos(9,pos) = rAryUser(11,uIdx)         ' team
			rAryPos(10,pos) = rAryUser(5,uIdx)       	' player order
		End If 
	End Function 

	Function randomSetUserToPos(rAryPos, rAryUser, uIdx)
		Dim Idx, ub, cntEmpty, rNum, cnt, pos 
		Dim aryBlock, sBase, fLoop, strBlock , teamNo , IsFirst

		fLoop = 1
		sBase = 16
		ub = UBound(rAryPos, 2)
		If(sBase > ub+1) Then sBase = ub+1 End If 

		teamNo = CDbl(rAryUser(1, uIdx))
		IsFirst = 0
		If(rAryUser(5, uIdx) = "1") Then IsFirst = 1 End If 		' 1장 선수이다. 

		While(fLoop)
			strBlock = CheckEmptyPos(rAryPos, teamNo, IsFirst, sBase)

         strLog = sprintf("-----------randomSetUserToPos strBlock = {0}, teamNo = {1}, sBase = {2}", Array(strBlock, teamNo, sBase))
         ' ' ' ' ' ' Call TraceLog(SPORTS_LOG1, strLog) 

			If(strBlock <> "") Or (sBase = 1) Then 
				fLoop = 0
			Else 
				sBase = sBase / 2
			End If 
		wEnd 

		pos = -1
		If(strBlock <> "") Then 			' 찾았다. 
			aryBlock = Split(strBlock, ",")
      	ub = UBound(aryBlock)

			rNum = GetRandomNum(ub+1) -1

			sp = aryBlock(rNum) * sBase 
			ep = (sp + sBase) - 1

         strLog = sprintf("-----------If(strBlock <> "") aryBlock({0}) = {1}, sp = {2}, ep = {2}", Array(rNum, aryBlock(rNum), sp, ep))
         ' ' ' ' ' ' Call TraceLog(SPORTS_LOG1, strLog) 

			For Idx = sp To ep 
				If(rAryPos(0,Idx) <> 1) Then 
					cntEmpty = cntEmpty + 1
				End If 
			Next 

			rNum = GetRandomNum(cntEmpty) -1
         cnt = 0 

			For Idx = sp To ep 
				If(rAryPos(0,Idx) <> 1) Then 
					If(cnt >= rNum) Then 
						pos = Idx 
						Exit For 
					End If 
					cnt = cnt + 1 
				End If 
			Next 
		End If 

      strLog = sprintf("-----------get pos rNum= {0}, cntEmpty = {1}, cnt = {2}, pos = {3}", Array(rNum, cntEmpty, cnt, pos))
      ' ' ' ' ' ' Call TraceLog(SPORTS_LOG1, strLog) 

		'   -----------------------------------------------------------------------
      '    빈자리를 못찾았으면 아무 빈자리나 넣는다. 
      If (pos = -1) Then 
         ' ' Call TraceLog2Dim(SAMALL_LOG1, rAryPos, "IN GetEmptyPosByRandom - rAryPos")
         pos = GetEmptyPosByRandom(rAryPos)           
      End If 

      If(pos <> -1) Then 
			strLog = sprintf("-----------randomSetUserToPos user uIdx = {0}, name = {1}({2})0, pos = {3}", Array(uIdx, rAryUser(9, uIdx), rAryUser(11, uIdx), pos) )
      	' ' Call TraceLog(SPORTS_LOG1, strLog) 

         rAryUser(0, uIdx) = 1 
         rAryPos(0, pos) = 1				
         If(rAryUser(5, uIdx) = "1") Then 			' 1장 유무 
            rAryPos(2, pos) = E_POS_FIRST          ' 1장을 할당했다. 
         Else 
            rAryPos(2, pos) = E_POS_NORMAL 
         End If    

         rAryPos(4,pos) = rAryUser(6,uIdx)         ' playerCode - GroupIdx
         rAryPos(5,pos) = rAryUser(1,uIdx)         ' team order
         rAryPos(6,pos) = rAryUser(8,uIdx)         ' cUser
         rAryPos(7,pos) = rAryUser(9,uIdx)         ' user
         rAryPos(8,pos) = rAryUser(10,uIdx)         ' cTeam
         rAryPos(9,pos) = rAryUser(11,uIdx)         ' team
         rAryPos(10,pos) = rAryUser(5,uIdx)       	' player order
      Else 
         strLog = "**************** randomSetUserToPos Error !! "
         '' ' ' ' ' ' Call TraceLog(SPORTS_LOG1, strLog) 
      End If 
	End Function 

	Function CheckEmptyPos(rAryPos, tNo, IsFirst, sBlock)
		Dim Idx, ub, sp, ep, nMax, strRet, ret 

		ub = UBound(rAryPos, 2)
		nMax = ((ub+1) / sBlock) -1 

		strRet = "" 

		For Idx = 0 To nMax
			sp = Idx * sBlock 
			ep = (sp + sBlock) -1
			ret = checkEmptyPosInBlock(rAryPos, tNo, IsFirst, sp, ep)

			If(ret = 1) Then 
            If(strRet = "") Then 
               strRet = sprintf("{0}", Array(Idx))
            Else 
               strRet = sprintf("{0},{1}", Array(strRet, Idx))
            End If 
         End If 
		Next 

		CheckEmptyPos = strRet 
	End Function 

	Function checkEmptyPosInBlock(rAryPos, tNo, IsFirst, sp, ep)
		Dim Idx , ret, teamNo , szBlock , cntUsed, posKind

		szBlock = (ep-sp) + 1
		ret = 1 
		cntUsed = 0 

		If(IsFirst = 1) Then 
			For Idx = sp To ep 
				If(rAryPos(0, Idx) = 1) Then 
					teamNo = CDbl(rAryPos(5, Idx))
					posKind = CDbl(rAryPos(2, Idx))

					cntUsed = cntUsed + 1
					If(tNo = teamNo) Or (posKind = E_POS_FIRST) Or (posKind = E_POS_SEED)Then 					
						ret = 0
						Exit For 
					End If 
				End If 
			Next 
		Else 
			For Idx = sp To ep 
				If(rAryPos(0, Idx) = 1) Then 
					teamNo = CDbl(rAryPos(5, Idx))
					cntUsed = cntUsed + 1
					If(tNo = teamNo) Then 					
						ret = 0
						Exit For 
					End If 
				End If 
			Next 
		End If 
		

		' 다 사용중 ( 할당할수 없다.) - 해당 Block내에 빈 공간이 없다. 
		If( cntUsed = szBlock ) Then ret = 0 End If

		checkEmptyPosInBlock = ret 
	End Function 

'   ===============================================================================
'     aryPos에서 빈자리중 랜덤하게 한자리를 찾는다. 
'   ===============================================================================
   Function GetEmptyPosByRandom(rAryPos)
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

      strLog = sprintf("In GetEmptyPosByRandom pos = {0}, rNum = {0}, nEmpty = {0}, cnt = {0}", Array(pos, rNum, nEmpty, cnt))
      ' ' ' ' ' ' Call TraceLog(SPORTS_LOG1, strLog) 
      GetEmptyPosByRandom = pos 
   End Function 

'   ===============================================================================     
'      aryUser로 부터 user 할당의 방식 변경 시점을 구한다. 
'      cntFirst > half ? cntFirst : half 
'   =============================================================================== 
	Function GetAssignChangeBase(rAryUser)
		Dim ub, Idx, half, cntFirst, playerOrder, ret 

		ub = UBound(rAryUser, 2)		
		half = Fix( (ub + 1) / 2 )
		cntFirst = 0

		For Idx = 0 To ub 			
			playerOrder = CDbl(rAryUser(5, Idx))
			If(playerOrder = 1) Then 				' 1장 이다.  
				cntFirst = cntFirst + 1
			Else 
				Exit For 
			End If 
		Next 

      strLog = sprintf("GetAssignChangeBase half = {0}, cntFirst = {1}", _ 
						Array(half, cntFirst))
		' ' ' ' ' ' Call TraceLog(SPORTS_LOG1, strLog) 

		ret = half 
		If(cntFirst > ret) Then ret = cntFirst End If 

		GetAssignChangeBase = ret 
	End Function 


'   ===============================================================================     
'      aryUser로 부터 team을 구분하여 TeamCount를 구하여, aryUser에 셋팅한다. aryUser(15)
'   =============================================================================== 
	Function SetTeamCntToUserAry(rAryUser)
		Dim ub, Idx, tIdx, cnt, teamCnt  
		Dim aryTeam, teamNo 

		ub = UBound(rAryUser, 2)

		ReDim aryTeam(3, ub)
		cnt = 0

		For Idx = 0 To ub 
			teamNo = CDbl(rAryUser(1, Idx))
			tIdx = checkTeamNo(aryTeam, teamNo)

			If(tIdx = -1) Then 
				aryTeam(0, cnt) = 1					' fUse
				aryTeam(1, cnt) = teamNo 			' teamNo 
				aryTeam(2, cnt) = 1					' team Count 
				cnt = cnt + 1
			Else 
				aryTeam(2, tIdx) = aryTeam(2, tIdx) + 1
			End If 
		Next 

		For Idx = 0 To ub 
			teamNo = CDbl(rAryUser(1, Idx))
			teamCnt = GetTeamCount(aryTeam, teamNo)
			rAryUser(14, Idx) = teamCnt
		Next 

	End Function 

'   ===============================================================================     
'     teamNo를 입력받아 동일한 Team인지 Check한다. 
'   ===============================================================================   
   Function checkTeamNo(rAryTeam, tNo)
      Dim ub, Idx, ret, teamNo

      ret = -1
      ub = UBound(rAryTeam, 2)

      For Idx = 0 To ub       
         If(rAryTeam(0, Idx) <> 1) Then            ' data의 제일 마지막에 왔다. 
            Exit For
         End If 

         teamNo = CDbl(rAryTeam(1, Idx))
         If(teamNo = tNo) Then     ' teamNo가 일치한다. 
            ret = Idx 
            Exit For
         End If 
      Next 
      checkTeamNo = ret
   End Function 

'   ===============================================================================     
'     teamNo를 입력받아 team Count를 반환한다. 
'   ===============================================================================   
   Function GetTeamCount(rAryTeam, tNo)
      Dim ub, Idx, ret, teamNo

      ret = -1
      ub = UBound(rAryTeam, 2)

      For Idx = 0 To ub       
         If(rAryTeam(0, Idx) <> 1) Then            ' data의 제일 마지막에 왔다. 
            Exit For
         End If 

         teamNo = CDbl(rAryTeam(1, Idx))

         If( teamNo = tNo) Then     ' teamNo가 일치한다. 
            ret = rAryTeam(2, Idx) 
            Exit For
         End If 
      Next 
      GetTeamCount = ret
   End Function 


'   ===============================================================================     
'      aryUser로 부터 aryPos에 User를 할당한다.                    - 단식 
'   =============================================================================== 
	Function SetTournamentUser(rAryPos, rAryTUser, IsDblGame)		
		Dim aryPosA, aryPosB, aryPosC, aryPosD
      Dim aryUserA, aryUserB, aryUserC, aryUserD
		Dim aryPosHalfA, aryPosHalfB, aryHalfA, aryHalfB, aryData

		ReDim aryData(4-1)

      If(IsDblGame = 1) Then 
         Call SetTournamentUserDbl(rAryPos, rAryTUser)
         Exit Function 
      End If         
		
		' User를 HalfA, HalfB에 할당하고 , Pos도 HalfPosA , HalfPosB에 할당한다. 		
		Call binSetTournamentUser(rAryPos, rAryTUser, aryData)
		aryHalfA 	= aryData(0)
		aryHalfB 	= aryData(1)
		aryPosHalfA = aryData(2)
		aryPosHalfB = aryData(3)

		' HalfA User를 aryA, aryB에 할당한다. 
		Call binSetTournamentUser(aryPosHalfA, aryHalfA, aryData)
		aryUserA 	= aryData(0)
		aryUserB 	= aryData(1)
		aryPosA 		= aryData(2)
		aryPosB 		= aryData(3)

		' HalfB User를 aryC, aryD에 할당한다. 
		Call binSetTournamentUser(aryPosHalfB, aryHalfB, aryData)
		aryUserC 	= aryData(0)
		aryUserD 	= aryData(1)
		aryPosC 		= aryData(2)
		aryPosD 		= aryData(3)

      Call ResetfUse(aryUserA)
      Call ResetfUse(aryUserB)
      Call ResetfUse(aryUserC)
      Call ResetfUse(aryUserD)

'		' ' ' ' ' ' Call TraceLog2Dim(SAMALL_LOG1, aryUserA, "prev SetUserToPos - aryUserA")
'		' ' ' ' ' ' Call TraceLog2Dim(SAMALL_LOG1, aryUserB, "prev SetUserToPos - aryUserB")
'		' ' ' ' ' ' Call TraceLog2Dim(SAMALL_LOG1, aryUserC, "prev SetUserToPos - aryUserC")
'		' ' ' ' ' ' Call TraceLog2Dim(SAMALL_LOG1, aryUserD, "prev SetUserToPos - aryUserD")
'
'		' ' ' ' ' ' Call TraceLog2Dim(SAMALL_LOG1, aryPosA, "prev SetUserToPos - aryPosA")
'		' ' ' ' ' ' Call TraceLog2Dim(SAMALL_LOG1, aryPosB, "prev SetUserToPos - aryPosB")
'		' ' ' ' ' ' Call TraceLog2Dim(SAMALL_LOG1, aryPosC, "prev SetUserToPos - aryPosC")
'		' ' ' ' ' ' Call TraceLog2Dim(SAMALL_LOG1, aryPosD, "prev SetUserToPos - aryPosD")

      Call SetUserToPos(aryPosA, aryUserA)
		Call SetUserToPos(aryPosB, aryUserB)
		Call SetUserToPos(aryPosC, aryUserC)
		Call SetUserToPos(aryPosD, aryUserD)

'		' ' ' ' ' ' Call TraceLog2Dim(SAMALL_LOG1, aryPosA, "after SetUserToPos - aryPosA")
'		' ' ' ' ' ' Call TraceLog2Dim(SAMALL_LOG1, aryPosB, "after SetUserToPos - aryPosB")
'		' ' ' ' ' ' Call TraceLog2Dim(SAMALL_LOG1, aryPosC, "after SetUserToPos - aryPosC")
'		' ' ' ' ' ' Call TraceLog2Dim(SAMALL_LOG1, aryPosD, "after SetUserToPos - aryPosD")

		Call MergeAryPos(rAryPos, aryPosA, E_PART_A)
      Call MergeAryPos(rAryPos, aryPosB, E_PART_B)
      Call MergeAryPos(rAryPos, aryPosC, E_PART_C)
      Call MergeAryPos(rAryPos, aryPosD, E_PART_D)

   End Function

'   ===============================================================================     
'      aryUser로 부터 4 Part에 인원을 분산할당 한다. - aryPartUser
'   =============================================================================== 
	Function binSetTournamentUser(rAryPos, rAryUser, rAryData)
		Dim aryPosA, aryPosB
		Dim aryUserA, aryUserB 
		Dim cntSeedA, cntSeedB, cntQA, cntQB, cntByeA, cntByeB , cntUserA, cntUserB , cntPosA, cntPosB  
		Dim Idx, ub, half, ub_pos, half_pos, nCol
				
		ub = UBound(rAryPos, 2)
		half = (ub+1) / 2 
		nCol = UBound(rAryUser, 1)

		' aryPos을 aryPosA, aryPosB 로 나눈다. ( / 2)
      aryPosA = DivAryPos(rAryPos, E_HALF_A)
      aryPosB = DivAryPos(rAryPos, E_HALF_B)

		cntPosA = UBound(aryPosA, 2) + 1
		cntPosB = UBound(aryPosB, 2) + 1

		' Seed Count를 구한다. 
      cntSeedA = GetSpecialPosCntSelfCall(aryPosA, E_POS_SEED)
      cntSeedB = GetSpecialPosCntSelfCall(aryPosB, E_POS_SEED)   

      ' Q(예선조) Count를 구한다. 
      cntQA = GetSpecialPosCntSelfCall(aryPosA, E_POS_Q)
      cntQB = GetSpecialPosCntSelfCall(aryPosB, E_POS_Q)

      ' Bye(Empty) Count를 구한다. 
      cntByeA = GetSpecialPosCntSelfCall(aryPosA, E_POS_BYE)
      cntByeB = GetSpecialPosCntSelfCall(aryPosB, E_POS_BYE)
      
      ' Q Count Or Bye Count 하나만 유효하다. (예선조가 있으면 Bye가 없고, Bye가 있으면 예선조가 없다. )
      cntUserA = (cntPosA) - (cntQA + cntByeA)
      cntUserB = (cntPosB) - (cntQB + cntByeB)

		strLog = sprintf("cntSeedA = {0}, cntSeedB = {1}, cntQA = {2}, cntQB = {3}, cntByeA = {4}, cntByeB = {5} , cntUserA = {6}, cntUserB = {7}, cntPosA = {8}, cntPosB = {9}", _ 
						Array(cntSeedA, cntSeedB, cntQA, cntQB, cntByeA, cntByeB , cntUserA, cntUserB, cntPosA, cntPosB))
		' ' ' ' ' ' Call TraceLog(SAMALL_LOG1, strLog)
		
		ReDim aryUserA(nCol, cntUserA-1)      
      ReDim aryUserB(nCol, cntUserB-1)

		' 3-1. aryUserA, aryUserB에 Seed를 적용한다. 
      Call ApplySeedFromPos(aryPosA, aryUserA, rAryUser)
      Call ApplySeedFromPos(aryPosB, aryUserB, rAryUser)

		Call binAssignUser(aryUserA, aryUserB, rAryUser)		

		rAryData(0) = aryUserA
		rAryData(1) = aryUserB		
		rAryData(2) = aryPosA
		rAryData(3) = aryPosB
	End Function 

'   ===============================================================================     
'     aryUser데이터를 Part A, B에 나누어 할당한다. ( binary search )
'   =============================================================================== 
	Function binAssignUser(rAryUserA, rAryUserB, rAryUser)
		Dim ub, Idx
		Dim nTeamA, nTeamB , teamNo 
		Dim nEmptyA, nEmptyB, cntA, cntB, userOrder , orderGapA, orderGapB 
		Dim setOneSide, setDataPart
		Dim key, keyType, IsDesc
		
		ub 		 = UBound(rAryUser, 2)
		setOneSide = -1
		setDataPart = 0

		nEmptyA 		= 0 
		nEmptyB 		= 0 

		For Idx = 0 To ub 			
			strLog = sprintf("binAssignUser Idx = {0}, user = {1}({2})", Array(Idx, rAryUser(9, Idx), rAryUser(11, Idx) ))
			' Call TraceLog(SPORTS_LOG1, strLog) 

			If(CDbl(rAryUser(2, Idx)) = 0) Then 				' Seed가 아니면.. (seed는 이미 배치했다. )
				teamNo 		= CDbl(rAryUser(1, Idx))
				userOrder	= CDbl(rAryUser(5, Idx))

				nEmptyA = getEmptyCntInUserArray(rAryUserA)
				nEmptyB = getEmptyCntInUserArray(rAryUserB)

				nTeamA = getTeamCntInUserArray(rAryUserA, teamNo)
				nTeamB = getTeamCntInUserArray(rAryUserB, teamNo)

				cntA = getAssignCntInUserArray(rAryUserA)
				cntB = getAssignCntInUserArray(rAryUserB)

				orderGapA = getPlayerOrderGapInUserArray(rAryUserA, teamNo, userOrder)
				orderGapB = getPlayerOrderGapInUserArray(rAryUserB, teamNo, userOrder)


				strLog = sprintf("Idx = {0}, teamNo = {1}, nEmptyA = {2}, nEmptyB = {3}, nTeamA = {4}, nTeamB = {5}, cntA = {6}, cntB = {7}, orderGapA = {8}, orderGapB = {7}, setOneSide = {9}", _ 
							Array(Idx, teamNo, nEmptyA, nEmptyB, nTeamA, nTeamB, cntA, cntB, orderGapA, orderGapB, setOneSide))
				' Call TraceLog(SPORTS_LOG1, strLog) 

				' 더이상 넣을 공간이 없다. 끝내자 
				If((nEmptyA <= 0) And (nEmptyB <= 0)) Then 
					Exit For 
				End If 

				If(nEmptyA <= 0) Then setOneSide = E_HALF_B End If 	' Part A가 풀이다. B에 넣자 
				If(nEmptyB <= 0) Then setOneSide = E_HALF_A End If 	' Part B가 풀이다. A에 넣자 
			
				If(setOneSide = E_HALF_A) Then 						' Part A에만 데이터를 넣어라 					
					Call CopyRows(rAryUser, rAryUserA, Idx, cntA)
					rAryUserA(0,cntA) = 1					
				ElseIf(setOneSide = E_HALF_B) Then 				' Part B에만 데이터를 넣어라 					
					Call CopyRows(rAryUser, rAryUserB, Idx, cntB)
					rAryUserB(0,cntB) = 1
				Else 		
					If(nTeamA > nTeamB) Then 								' Same Team이 PartA에 더 많다. 
						setDataPart = E_HALF_B		
					ElseIf(nTeamA < nTeamB) Then 							' Same Team이 PartB에 더 많다. 
						setDataPart = E_HALF_A
					Else															' 같은팀의 갯수가 같다. 
						If(orderGapA < orderGapB) Then 					' A에 연속된 번호가 있다. B에 넣자 
							setDataPart = E_HALF_B
						ElseIf(orderGapA > orderGapB) Then				' B에 연속된 번호가 있다. A에 넣자 
							setDataPart = E_HALF_A
						Else 
							If(cntA > cntB)	Then								' SameTeam이고 nEmpty가 B가 더 많다면 B에 데이터를 넣는다. 
								setDataPart = E_HALF_B
							Else 													' 빈곳이 A가 더 많거나 같으면 A에 데이터를 넣는다. 
								setDataPart = E_HALF_A	
							End If 				' If(nEmptyA < nEmptyB)
						End If 
					End If 					' If(cnt_teamA > cnt_teamB)

					If(setDataPart = E_HALF_A) Then 
						Call CopyRows(rAryUser, rAryUserA, Idx, cntA)
						rAryUserA(0,cntA) = 1
					ElseIf(setDataPart = E_HALF_B) Then 
						Call CopyRows(rAryUser, rAryUserB, Idx, cntB)
						rAryUserB(0,cntB) = 1
					End If
				End If  
			End If 
		Next 

	End Function 
%>

<%
'   ===============================================================================     
'      복식
'   =============================================================================== 
	
'   ===============================================================================     
'      aryUser로 부터 aryPos에 User를 할당한다.                  
'   =============================================================================== 
	'   ===============================================================================     
'      aryUser로 부터 aryPos에 User를 할당한다.                    
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
'			6. 각 Block에 할당할수 있는 빈 공간 갯수를 구한다. nEmtpy 
'			7. 만약 nEmpty가 하나도 없으면 반대편 Block을 선택한다. 
'			8. nEmptyA, nEmptyB가 둘다 있다면 비교를 시작한다 .
' 			9. nSameTeam의 값이 제일 적은 팀에 할당한다. 
' 			10. 만약 nSameTeam의 최소값이  2개 이상 겹칠때는 nAssignUser의 갯수가 적은 Part을 선택한다. 
' 			11. nAssignUser의 최소값 마저 2개 이상 겹칠때는 Random하게 배치한다. 
' 			12. nBlock Size = 4 가 될때까지 1~11을 반복한다. 
' 			13. nBlock Size = 4 인데 nSameTeam == 0인 Block을 찾았으면 그곳에 인원을 할당한다. 
' 			14. nBlock Size = 4 인데 nSameTeam == 0인 Block을 못 찾았으면 
' 			      해당 Block의 최상위 Block( 처음 반으로 나눈)에서 인원을 할당한다. 
'   =============================================================================== 
	Function SetUserToPosDbl(rAryPos, rAryUser)
		Dim ub, ubP, Idx, nChangeAssign   
		Dim sp1, sp2, ep1, ep2
		Dim key, keyType, IsDesc , seedNo
		
		ub = UBound(rAryUser, 2)
		ubP = UBound(rAryPos, 2)

		nChangeAssign = GetAssignChangeBase(rAryUser) - 1
      
		For Idx = 0 To nChangeAssign Step 2
			cntSelfCall	= 0
         seedNo = CDbl(rAryUser(2, Idx))

         If(seedNo < 1) Then 
				strLog = sprintf("-----------user Idx = {0}, name = {1}({2})", Array(idx, rAryUser(9, Idx), rAryUser(11, Idx)) )
				' ' Call TraceLog(SPORTS_LOG1, strLog) 
				Call binSetUserToPosDbl(rAryPos, rAryUser, Idx, 0, ubP)				 
			Else 
				strLog = sprintf("-----------Seed user No Set --- Idx = {0}, name = {1}({2})", Array(idx, rAryUser(9, Idx), rAryUser(11, Idx)) )
				' ' Call TraceLog(SPORTS_LOG1, strLog)               
			End If 
		Next 

		' 2차 할당 - teamCount순		
		Call SetTeamCntToUserAry(rAryUser)		' aryUser에 teamCount를 셋팅한다. - 추후 sort에서 사용한다. 

		key = 14
		keyType = 2
		IsDesc = 1 
		Call Sort2DimAryEx(rAryUser, key, keyType, IsDesc)	

		For Idx = 0 To ub Step 2
			If(rAryUser(0, Idx) <> 1) Then 	' 할당하지 않은 
				cntSelfCall	= 0        
            seedNo = CDbl(rAryUser(2, Idx))

            If(seedNo < 1) Then 
					strLog = sprintf("-----------user Idx = {0}, name = {1}({2})", Array(idx, rAryUser(9, Idx), rAryUser(11, Idx)) )
					' ' Call TraceLog(SPORTS_LOG1, strLog) 
					Call binSetUserToPosDbl(rAryPos, rAryUser, Idx, 0, ubP)				 
				Else 
					strLog = sprintf("-----------Seed user No Set --- Idx = {0}, name = {1}({2})", Array(idx, rAryUser(9, Idx), rAryUser(11, Idx)) )
					' ' Call TraceLog(SPORTS_LOG1, strLog)               
				End If
			End If 
		Next 

	End Function 

'   ===============================================================================     
'      재귀 호출 .. 
'      block size <= 4일때 까지 혹은 teamNo가 0인 block을 만날때 까지 
'      block을 2개의 부분으로 나눈후 각각의 Block의 positino value를 체크한다. 

' 		 각각의 Block에서 code_team과 일치하는 User의 Count를 구한다.    nSameTeam
' 		 각 Block에 할당된 user Count를 구한다.    nAssignUser
'		 각 Block에 할당할수 있는 빈 공간 갯수를 구한다. nEmtpy 
'   =============================================================================== 
	Function binSetUserToPosDbl(rAryPos, rAryUser, uIdx, sp, ep)
		Dim Idx, ub
		Dim sp1, sp2, ep1, ep2, half, szBlock , IsFirst
		Dim teamNo, cntUser1, cntUser2, cntEmpty1, cntEmpty2, cntCheck1, cntCheck2

		szBlock = (ep - sp) + 1
		half = szBlock / 2

		strLog = sprintf("binSetUserToPosDbl uIdx = {0}, user1 = {1}({2}), user2 = {3}({4}), sp = {5}, ep = {6}, szBlock = {7}, half = {8}, cntSelfCall = {9} ", _ 
									 Array(uIdx, rAryUser(9, uIdx), rAryUser(11, uIdx), rAryUser(9, uIdx+1), rAryUser(11, uIdx+1), sp, ep, szBlock, half, cntSelfCall) )
      ' ' Call TraceLog(SPORTS_LOG1, strLog) 

		If(szBlock <= SZ_BLOCK_MIN) Then 			' block size가 최소다.  그냥 Random하게 배치하자 
			' ' Call TraceLog(SPORTS_LOG1, "randomSetUserToPosDbl - block size가 최소다.  그냥 Random하게 배치하자 ") 
			Call randomSetUserToPosDbl(rAryPos, rAryUser, uIdx)
			Exit Function 
		End If 

		If(cntSelfCall >= maxSelfCall) Then 	' 재귀 호출이 maxCount를 넘었다. 이만 끝내자 
			' ' Call TraceLog(SPORTS_LOG1, "randomSetUserToPosDbl - 재귀 호출이 maxCount를 넘었다. 이만 끝내자  ") 
			Call randomSetUserToPosDbl(rAryPos, rAryUser, uIdx)
			Exit Function 
		End If 
		cntSelfCall = cntSelfCall + 1				' 재귀 호출 제어 카운트 
		
		sp1 = sp 
		ep1 = (sp + half) - 1
		sp2 = ep1 + 1 
		ep2 = ep 

		teamNo = CDbl(rAryUser(1, uIdx))
		IsFirst = 0
		If(rAryUser(5, uIdx) = "1") Then IsFirst = 1 End If 		' 1장 선수이다. 

		' ---------------------------------------------------------------
		' 1장이면 teamCheck대신 1장 체크를 한다. 
		cntUser1 	= getAssignCountInBlock(rAryPos, sp1, ep1)
		cntEmpty1 	= getEmptyCountInBlock(rAryPos, teamNo, IsFirst, sp1, ep1)
		If(IsFirst) Then 
			cntCheck1 	= getFirstCountInBlock(rAryPos, sp1, ep1)
		Else 			
			cntCheck1 	= getTeamCountInBlock(rAryPos, teamNo, sp1, ep1)
		End If 

		cntUser2 	= getAssignCountInBlock(rAryPos, sp2, ep2)
		cntEmpty2 	= getEmptyCountInBlock(rAryPos, teamNo, IsFirst, sp2, ep2)
		If(IsFirst) Then 
			cntCheck2 	= getFirstCountInBlock(rAryPos, sp2, ep2)
		Else 			
			cntCheck2 	= getTeamCountInBlock(rAryPos, teamNo, sp2, ep2)
		End If 
		' ---------------------------------------------------------------

		strLog = sprintf("binSetUserToPosDbl sp1 = {0}, ep1 = {1}, sp2 = {2}, ep2 = {3}, teamNo = {4}, teamNo = {5} ", _ 
									 Array(sp1, ep1, sp2, ep2, teamNo, IsFirst) )
       ' ' Call TraceLog(SPORTS_LOG1, strLog) 

		strLog = sprintf("binSetUserToPosDbl cntUser1 = {0}, cntEmpty1 = {1}, cntCheck1 = {2} // cntUser2 = {3}, cntEmpty2 = {4}, cntCheck2 = {5} ", _ 
									 Array(cntUser1, cntEmpty1, cntCheck1, cntUser2, cntEmpty2, cntCheck2) )
      ' ' Call TraceLog(SPORTS_LOG1, strLog) 

		If( cntEmpty1 = 0 And cntEmpty2 = 0) Then 				' 빈공간이 없다.  그냥 Random하게 배치하자 
			' ' Call TraceLog(SPORTS_LOG1, "randomSetUserToPosDbl - 빈공간이 없다.  그냥 Random하게 배치하자   ") 
			Call randomSetUserToPosDbl(rAryPos, rAryUser, uIdx)
			Exit Function 
		ElseIf( cntEmpty1 = 0 Or cntEmpty2 = 0) Then 
			If(cntEmpty1 = 0) Then 				' A Part에 빈공간이 없다. B쪽을 찾자 
				If(cntCheck2 = 0) Then 
					' ' Call TraceLog(SPORTS_LOG1, "procSetUserToPosDbl - 찾았다. 여기에 배치하자  cntCheck2 = 0  #1") 	
					Call procSetUserToPosDbl(rAryPos, rAryUser, uIdx, sp2, ep2)
				Else 
					Call binSetUserToPosDbl(rAryPos, rAryUser, uIdx, sp2, ep2)
				End If 
			Else										' B Part에 빈공간이 없다. A쪽을 찾자 
				If(cntCheck1 = 0) Then 
					' ' Call TraceLog(SPORTS_LOG1, "procSetUserToPosDbl - 찾았다. 여기에 배치하자  cntCheck1 = 0  #2") 	
					Call procSetUserToPosDbl(rAryPos, rAryUser, uIdx, sp1, ep1)
				Else 
					Call binSetUserToPosDbl(rAryPos, rAryUser, uIdx, sp1, ep1)
				End If 				
			End If 
		Else 
			If(cntCheck1 <> 0) And (cntCheck2 <> 0) Then 		' 배치된 Same Team Count Check 
				If(cntCheck1 > cntCheck2) Then 
					Call binSetUserToPosDbl(rAryPos, rAryUser, uIdx, sp2, ep2)
				ElseIf(cntCheck1 < cntCheck2) Then  
					Call binSetUserToPosDbl(rAryPos, rAryUser, uIdx, sp1, ep1)
				Else 
					If(cntUser1 > cntUser2) Then 					' 배치된 User Count Check 
						Call binSetUserToPosDbl(rAryPos, rAryUser, uIdx, sp2, ep2)
					Else 
						Call binSetUserToPosDbl(rAryPos, rAryUser, uIdx, sp1, ep1)
					End If 
				End If 
			Else 			' 찾았다. 여기에 배치하자 				
				If(cntCheck1 = 0) And (cntCheck2 = 0) Then 
					If(cntUser1 > cntUser2) Then 					' 배치된 User Count Check 
						' ' Call TraceLog(SPORTS_LOG1, "procSetUserToPosDbl - 찾았다. 여기에 배치하자  cntCheck1,2 = 0 cntUser1 > cntUser2 #3") 			 
						Call procSetUserToPosDbl(rAryPos, rAryUser, uIdx, sp2, ep2)
					Else 
						' ' Call TraceLog(SPORTS_LOG1, "procSetUserToPosDbl - 찾았다. 여기에 배치하자  cntCheck1,2 = 0 cntUser1 <= cntUser2 #4") 			 
						Call procSetUserToPosDbl(rAryPos, rAryUser, uIdx, sp1, ep1)
					End If 
				Else
					If(cntCheck1 = 0) Then 
						' ' Call TraceLog(SPORTS_LOG1, "procSetUserToPosDbl - 찾았다. 여기에 배치하자  cntCheck1 = 0  #5") 			 
						Call procSetUserToPosDbl(rAryPos, rAryUser, uIdx, sp1, ep1)
					Else 
						' ' Call TraceLog(SPORTS_LOG1, "procSetUserToPosDbl - 찾았다. 여기에 배치하자  cntCheck2 = 0  #6") 	
						Call procSetUserToPosDbl(rAryPos, rAryUser, uIdx, sp2, ep2)
					End If 
				End If 
			End If 
		End If 

	End Function 

	Function procSetUserToPosDbl(rAryPos, rAryUser, uIdx, sp, ep)
		Dim Idx, ub , cntEmpty, rNum, cnt , pos, uIdx2

		ub = UBound(rAryPos, 2)
		If(sp < 0) Then sp = 0 End If 
		If(ep > ub) Then ep = ub End If 

		cntEmpty = 0
		cnt = 0
		rNum = 0 
		pos = -1 

		For Idx = sp To ep 
			If(rAryPos(0,Idx) <> 1) Then 
				cntEmpty = cntEmpty + 1
			End If 
		Next 

		rNum = GetRandomNum(cntEmpty) -1

		For Idx = sp To ep 
			If(rAryPos(0,Idx) <> 1) Then 
				If(cnt >= rNum) Then 
					pos = Idx 
					Exit For 
				End If 
				cnt = cnt + 1 
			End If 
		Next 

		' fUse, pos, pos_kind, pos_val, playerCode(gGroupIdx), teamOrder, cUser, user, cTeam, team
		If(pos = -1) Then 
			Call randomSetUserToPosDbl(rAryPos, rAryUser, uIdx)
		Else		
			strLog = sprintf("-----------procSetUserToPosDbl user uIdx = {0}, user1 = {1}({2}), user2 = {3}({4}), pos = {5}", _ 
				 			Array(uIdx, rAryUser(9, uIdx), rAryUser(11, uIdx), rAryUser(9, uIdx+1), rAryUser(11, uIdx+1), pos) )
      	' ' Call TraceLog(SPORTS_LOG1, strLog) 

			uIdx2 = uIdx + 1

			rAryUser(0, uIdx) = 1 
			rAryUser(0, uIdx2) = 1 

			rAryPos(0, pos) = 1				
			If(rAryUser(5, uIdx) = "1") Then 		' 1장 유무 
				rAryPos(2, pos) = E_POS_FIRST                ' 1장을 할당했다. 
			Else 
				rAryPos(2, pos) = E_POS_NORMAL 
			End If    

			rAryPos(4,pos) = rAryUser(6,uIdx)         ' playerCode - GroupIdx
			rAryPos(5,pos) = rAryUser(1,uIdx)         ' team order

			rAryPos(6,pos) = rAryUser(8,uIdx)         ' cUser
			rAryPos(7,pos) = rAryUser(9,uIdx)         ' user			
			rAryPos(8,pos) = rAryUser(8,uIdx2)         ' cUser
			rAryPos(9,pos) = rAryUser(9,uIdx2)         ' user			

			rAryPos(10,pos) = rAryUser(10,uIdx)         ' cTeam
			rAryPos(11,pos) = rAryUser(11,uIdx)         ' team			
			rAryPos(12,pos) = rAryUser(10,uIdx2)         ' cTeam
			rAryPos(13,pos) = rAryUser(11,uIdx2)         ' team

			rAryPos(14,pos) = rAryUser(5,uIdx)       	' player order
		End If 
	End Function 

	Function randomSetUserToPosDbl(rAryPos, rAryUser, uIdx)
		Dim Idx, ub, cntEmpty, rNum, cnt, pos 
		Dim aryBlock, sBase, fLoop, strBlock , teamNo , IsFirst

		fLoop = 1
		sBase = 16
		ub = UBound(rAryPos, 2)
		If(sBase > ub+1) Then sBase = ub+1 End If 

		teamNo = CDbl(rAryUser(1, uIdx))
		IsFirst = 0
		If(rAryUser(5, uIdx) = "1") Then IsFirst = 1 End If 		' 1장 선수이다. 

		While(fLoop)
			strBlock = CheckEmptyPos(rAryPos, teamNo, IsFirst, sBase)

         strLog = sprintf("-----------randomSetUserToPos strBlock = {0}, teamNo = {1}, sBase = {2}", Array(strBlock, teamNo, sBase))
         ' ' ' ' ' ' Call TraceLog(SPORTS_LOG1, strLog) 

			If(strBlock <> "") Or (sBase = 1) Then 
				fLoop = 0
			Else 
				sBase = sBase / 2
			End If 
		wEnd 

		pos = -1
		If(strBlock <> "") Then 			' 찾았다. 
			aryBlock = Split(strBlock, ",")
      	ub = UBound(aryBlock)

			rNum = GetRandomNum(ub+1) -1

			sp = aryBlock(rNum) * sBase 
			ep = (sp + sBase) - 1

         strLog = sprintf("-----------If(strBlock <> "") aryBlock({0}) = {1}, sp = {2}, ep = {2}", Array(rNum, aryBlock(rNum), sp, ep))
         ' ' ' ' ' ' Call TraceLog(SPORTS_LOG1, strLog) 

			For Idx = sp To ep 
				If(rAryPos(0,Idx) <> 1) Then 
					cntEmpty = cntEmpty + 1
				End If 
			Next 

			rNum = GetRandomNum(cntEmpty) -1
         cnt = 0 

			For Idx = sp To ep 
				If(rAryPos(0,Idx) <> 1) Then 
					If(cnt >= rNum) Then 
						pos = Idx 
						Exit For 
					End If 
					cnt = cnt + 1 
				End If 
			Next 
		End If 

      strLog = sprintf("-----------get pos rNum= {0}, cntEmpty = {1}, cnt = {2}, pos = {3}", Array(rNum, cntEmpty, cnt, pos))
      ' ' ' ' ' ' Call TraceLog(SPORTS_LOG1, strLog) 

      strLog = sprintf("----------- pos = {0}", Array(pos))
      ' ' ' ' ' ' Call TraceLog(SPORTS_LOG1, strLog) 

		'   -----------------------------------------------------------------------
      '    빈자리를 못찾았으면 아무 빈자리나 넣는다. 
      If (pos = -1) Then 
         '' ' ' ' ' ' Call TraceLog2Dim(SAMALL_LOG1, rAryPos, "IN GetEmptyPosByRandom - rAryPos")
         pos = GetEmptyPosByRandom(rAryPos)           
      End If 

      If(pos <> -1) Then 
			strLog = sprintf("-----------randomSetUserToPos user uIdx = {0}, user1 = {1}({2}), user2 = {3}({4}), pos = {5}", _ 
						Array(uIdx, rAryUser(9, uIdx), rAryUser(11, uIdx), rAryUser(9, uIdx+1), rAryUser(11, uIdx+1), pos) )
      	' ' Call TraceLog(SPORTS_LOG1, strLog) 

			uIdx2 = uIdx + 1

         rAryUser(0, uIdx) = 1 
			rAryUser(0, uIdx2) = 1 

         rAryPos(0, pos) = 1				
         If(rAryUser(5, uIdx) = "1") Then 		' 1장 유무 
            rAryPos(2, pos) = E_POS_FIRST                ' 1장을 할당했다. 
         Else 
            rAryPos(2, pos) = E_POS_NORMAL 
         End If    

         rAryPos(4,pos) = rAryUser(6,uIdx)         ' playerCode - GroupIdx
			rAryPos(5,pos) = rAryUser(1,uIdx)         ' team order

			rAryPos(6,pos) = rAryUser(8,uIdx)         ' cUser
			rAryPos(7,pos) = rAryUser(9,uIdx)         ' user			
			rAryPos(8,pos) = rAryUser(8,uIdx2)         ' cUser
			rAryPos(9,pos) = rAryUser(9,uIdx2)         ' user			

			rAryPos(10,pos) = rAryUser(10,uIdx)         ' cTeam
			rAryPos(11,pos) = rAryUser(11,uIdx)         ' team			
			rAryPos(12,pos) = rAryUser(10,uIdx2)         ' cTeam
			rAryPos(13,pos) = rAryUser(11,uIdx2)         ' team

			rAryPos(14,pos) = rAryUser(5,uIdx)       	' player order
      Else 
         strLog = "**************** randomSetUserToPos Error !! "
         '' ' ' ' ' ' Call TraceLog(SPORTS_LOG1, strLog) 
      End If 
	End Function 

	
'   ===============================================================================     
'      aryUser로 부터 aryPos에 User를 할당한다.                    
'   =============================================================================== 
	Function SetTournamentUserDbl(rAryPos, rAryTUser)		
      Dim aryPosA, aryPosB, aryPosC, aryPosD
      Dim aryUserA, aryUserB, aryUserC, aryUserD
		Dim aryPosHalfA, aryPosHalfB, aryHalfA, aryHalfB, aryData

		ReDim aryData(4-1)

		' User를 HalfA, HalfB에 할당하고 , Pos도 HalfPosA , HalfPosB에 할당한다. 		
		Call binSetTournamentUserDbl(rAryPos, rAryTUser, aryData)
		aryHalfA 	= aryData(0)
		aryHalfB 	= aryData(1)
		aryPosHalfA = aryData(2)
		aryPosHalfB = aryData(3)

		' HalfA User를 aryA, aryB에 할당한다. 
		Call binSetTournamentUserDbl(aryPosHalfA, aryHalfA, aryData)
		aryUserA 	= aryData(0)
		aryUserB 	= aryData(1)
		aryPosA 		= aryData(2)
		aryPosB 		= aryData(3)

		' HalfB User를 aryC, aryD에 할당한다. 
		Call binSetTournamentUserDbl(aryPosHalfB, aryHalfB, aryData)
		aryUserC 	= aryData(0)
		aryUserD 	= aryData(1)
		aryPosC 		= aryData(2)
		aryPosD 		= aryData(3)

      Call ResetfUse(aryUserA)
      Call ResetfUse(aryUserB)
      Call ResetfUse(aryUserC)
      Call ResetfUse(aryUserD)

'		' ' Call TraceLog2Dim(SAMALL_LOG1, rAryTUser, "prev SetUserToPos - rAryTUser")
'		' ' Call TraceLog2Dim(SAMALL_LOG1, aryHalfA, "prev SetUserToPos - aryHalfA")
'		' ' Call TraceLog2Dim(SAMALL_LOG1, aryHalfB, "prev SetUserToPos - aryHalfB")
'
'		' ' Call TraceLog2Dim(SAMALL_LOG1, aryUserA, "prev SetUserToPos - aryUserA")
'		' ' Call TraceLog2Dim(SAMALL_LOG1, aryUserB, "prev SetUserToPos - aryUserB")
'		' ' Call TraceLog2Dim(SAMALL_LOG1, aryUserC, "prev SetUserToPos - aryUserC")
'		' ' Call TraceLog2Dim(SAMALL_LOG1, aryUserD, "prev SetUserToPos - aryUserD")

'		'' ' ' ' ' Call TraceLog2Dim(SAMALL_LOG1, rAryTUser, "prev SetUserToPos - rAryTUser")
'		'' ' ' ' ' Call TraceLog2Dim(SAMALL_LOG1, aryUserA, "prev SetUserToPos - aryUserA")
'		'' ' ' ' ' Call TraceLog2Dim(SAMALL_LOG1, aryUserB, "prev SetUserToPos - aryUserB")
'		'' ' ' ' ' Call TraceLog2Dim(SAMALL_LOG1, aryUserC, "prev SetUserToPos - aryUserC")
'		'' ' ' ' ' Call TraceLog2Dim(SAMALL_LOG1, aryUserD, "prev SetUserToPos - aryUserD")
'
'		' ' ' ' ' ' Call TraceLog2Dim(SAMALL_LOG1, aryPosA, "prev SetUserToPos - aryPosA")
'		' ' ' ' ' ' Call TraceLog2Dim(SAMALL_LOG1, aryPosB, "prev SetUserToPos - aryPosB")
'		' ' ' ' ' ' Call TraceLog2Dim(SAMALL_LOG1, aryPosC, "prev SetUserToPos - aryPosC")
'		' ' ' ' ' ' Call TraceLog2Dim(SAMALL_LOG1, aryPosD, "prev SetUserToPos - aryPosD")
'
      Call SetUserToPosDbl(aryPosA, aryUserA)
		Call SetUserToPosDbl(aryPosB, aryUserB)
		Call SetUserToPosDbl(aryPosC, aryUserC)
		Call SetUserToPosDbl(aryPosD, aryUserD)

		' ' ' ' ' ' Call TraceLog2Dim(SAMALL_LOG1, aryPosA, "after SetUserToPos - aryPosA")
		' ' ' ' ' ' Call TraceLog2Dim(SAMALL_LOG1, aryPosB, "after SetUserToPos - aryPosB")
		' ' ' ' ' ' Call TraceLog2Dim(SAMALL_LOG1, aryPosC, "after SetUserToPos - aryPosC")
		' ' ' ' ' ' Call TraceLog2Dim(SAMALL_LOG1, aryPosD, "after SetUserToPos - aryPosD")

		Call MergeAryPos(rAryPos, aryPosA, E_PART_A)
      Call MergeAryPos(rAryPos, aryPosB, E_PART_B)
      Call MergeAryPos(rAryPos, aryPosC, E_PART_C)
      Call MergeAryPos(rAryPos, aryPosD, E_PART_D)

   End Function

	
'   ===============================================================================     
'      aryUser로 부터 4 Part에 인원을 분산할당 한다. - aryPartUser
'   =============================================================================== 
	Function binSetTournamentUserDbl(rAryPos, rAryUser, rAryData)
		Dim aryPosA, aryPosB
		Dim aryUserA, aryUserB 
		Dim cntSeedA, cntSeedB, cntQA, cntQB, cntByeA, cntByeB , cntUserA, cntUserB , cntPosA, cntPosB 
		Dim Idx, ub, half, ub_pos, half_pos, nCol , nCallStep
				
		ub = UBound(rAryPos, 2)
		half = (ub+1) / 2 
		nCol = UBound(rAryUser, 1)

		' aryPos을 aryPosA, aryPosB 로 나눈다. ( / 2)
      aryPosA = DivAryPos(rAryPos, E_HALF_A)
      aryPosB = DivAryPos(rAryPos, E_HALF_B)

		cntPosA = UBound(aryPosA, 2) + 1
		cntPosB = UBound(aryPosB, 2) + 1

		' Seed Count를 구한다. 
      cntSeedA = GetSpecialPosCntSelfCall(aryPosA, E_POS_SEED)
      cntSeedB = GetSpecialPosCntSelfCall(aryPosB, E_POS_SEED)   

      ' Q(예선조) Count를 구한다. 
      cntQA = GetSpecialPosCntSelfCall(aryPosA, E_POS_Q)
      cntQB = GetSpecialPosCntSelfCall(aryPosB, E_POS_Q)

      ' Bye(Empty) Count를 구한다. 
      cntByeA = GetSpecialPosCntSelfCall(aryPosA, E_POS_BYE)
      cntByeB = GetSpecialPosCntSelfCall(aryPosB, E_POS_BYE)
      
      ' Q Count Or Bye Count 하나만 유효하다. (예선조가 있으면 Bye가 없고, Bye가 있으면 예선조가 없다. )
      cntUserA = ((cntPosA) - (cntQA + cntByeA)) * 2
      cntUserB = ((cntPosB) - (cntQB + cntByeB)) * 2

		strLog = sprintf("cntSeedA = {0}, cntSeedB = {1}, cntQA = {2}, cntQB = {3}, cntByeA = {4}, cntByeB = {5} , cntUserA = {6}, cntUserB = {7}, cntPosA = {8}, cntPosB = {9}", _ 
						Array(cntSeedA, cntSeedB, cntQA, cntQB, cntByeA, cntByeB , cntUserA, cntUserB, cntPosA, cntPosB))
		' ' Call TraceLog(SAMALL_LOG1, strLog)
		
		ReDim aryUserA(nCol, cntUserA-1)      
      ReDim aryUserB(nCol, cntUserB-1)

		' 3-1. aryUserA, aryUserB에 Seed를 적용한다. 
      Call ApplySeedFromPosDbl(aryPosA, aryUserA, rAryUser)
      Call ApplySeedFromPosDbl(aryPosB, aryUserB, rAryUser)

		Call binAssignUserDbl(aryUserA, aryUserB, rAryUser)		

		rAryData(0) = aryUserA
		rAryData(1) = aryUserB		
		rAryData(2) = aryPosA
		rAryData(3) = aryPosB
	End Function 

'   ===============================================================================     
'     aryUser데이터를 Part A, B에 나누어 할당한다. ( binary search )
'   =============================================================================== 
	Function binAssignUserDbl(rAryUserA, rAryUserB, rAryUser)
		Dim ub, Idx
		Dim nTeamA, nTeamB , teamNo 
		Dim nEmptyA, nEmptyB, cntA, cntB, userOrder , orderGapA, orderGapB   
		Dim setOneSide, setDataPart
		Dim key, keyType, IsDesc
		
		ub 		 = UBound(rAryUser, 2)
		setOneSide = -1
		setDataPart = 0

		nEmptyA 		= 0 
		nEmptyB 		= 0 

		For Idx = 0 To ub Step 2			
			strLog = sprintf("binAssignUserDbl Idx = {0}, user1 = {1}({2}), user2 = {3}({4})", _ 
					Array(Idx, rAryUser(9, Idx), rAryUser(11, Idx), rAryUser(9, Idx+1), rAryUser(11, Idx+1) ))
'			' ' Call TraceLog(SPORTS_LOG1, strLog) 

			If(CDbl(rAryUser(2, Idx)) = 0) Then 				' Seed가 아니면.. (seed는 이미 배치했다. )
				teamNo = CDbl(rAryUser(1, Idx))
				userOrder	= CDbl(rAryUser(5, Idx))

				nEmptyA = getEmptyCntInUserArray(rAryUserA)
				nEmptyB = getEmptyCntInUserArray(rAryUserB)

				nTeamA = getTeamCntInUserArray(rAryUserA, teamNo)
				nTeamB = getTeamCntInUserArray(rAryUserB, teamNo)

				cntA = getAssignCntInUserArray(rAryUserA)
				cntB = getAssignCntInUserArray(rAryUserB)

				orderGapA = getPlayerOrderGapInUserArray(rAryUserA, teamNo, userOrder)
				orderGapB = getPlayerOrderGapInUserArray(rAryUserB, teamNo, userOrder)


				strLog = sprintf("Idx = {0}, teamNo = {1}, nEmptyA = {2}, nEmptyB = {3}, nTeamA = {4}, nTeamB = {5}, cntA = {6}, cntB = {7}, orderGapA = {8}, orderGapB = {7}, setOneSide = {9}", _ 
							Array(Idx, teamNo, nEmptyA, nEmptyB, nTeamA, nTeamB, cntA, cntB, orderGapA, orderGapB, setOneSide))
				'' Call TraceLog(SPORTS_LOG1, strLog) 

				' 더이상 할당할 공간이 없다. 나가자. 
				If(nEmptyA <= 0) And (nEmptyB <= 0) Then 
					Exit For 
				End If 

				If(nEmptyA <= 0) Then setOneSide = E_HALF_B End If 	' Part A가 풀이다. B에 넣자 
				If(nEmptyB <= 0) Then setOneSide = E_HALF_A End If 	' Part B가 풀이다. A에 넣자 
			
				If(setOneSide = E_HALF_A) Then 						' Part A에만 데이터를 넣어라 
					Call CopyRows(rAryUser, rAryUserA, Idx, cntA)
					Call CopyRows(rAryUser, rAryUserA, Idx+1, cntA+1)
					rAryUserA(0,cntA) = 1
					rAryUserA(0,cntA+1) = 1
				ElseIf(setOneSide = E_HALF_B) Then 				' Part B에만 데이터를 넣어라 
					Call CopyRows(rAryUser, rAryUserB, Idx, cntB)
					Call CopyRows(rAryUser, rAryUserB, Idx+1, cntB+1)
					rAryUserB(0,cntB) = 1
					rAryUserB(0,cntB+1) = 1
				Else 		
					If(nTeamA > nTeamB) Then 								' Same Team이 PartA에 더 많다. 
						setDataPart = E_HALF_B		
					ElseIf(nTeamA < nTeamB) Then 							' Same Team이 PartB에 더 많다. 
						setDataPart = E_HALF_A
					Else															' 같은팀의 갯수가 같다. 
						If(orderGapA < orderGapB) Then 					' A에 연속된 번호가 있다. B에 넣자 
							setDataPart = E_HALF_B
						ElseIf(orderGapA > orderGapB) Then				' B에 연속된 번호가 있다. A에 넣자 
							setDataPart = E_HALF_A
						Else 
							If(cntA > cntB)	Then								' SameTeam이고 nEmpty가 B가 더 많다면 B에 데이터를 넣는다. 
								setDataPart = E_HALF_B
							Else 													' 빈곳이 A가 더 많거나 같으면 A에 데이터를 넣는다. 
								setDataPart = E_HALF_A	
							End If 				' If(nEmptyA < nEmptyB)
						End If 
					End If 					' If(cnt_teamA > cnt_teamB)

					If(setDataPart = E_HALF_A) Then 
						Call CopyRows(rAryUser, rAryUserA, Idx, cntA)
						Call CopyRows(rAryUser, rAryUserA, Idx+1, cntA+1)
						rAryUserA(0,cntA) = 1
						rAryUserA(0,cntA+1) = 1
					ElseIf(setDataPart = E_HALF_B) Then 
						Call CopyRows(rAryUser, rAryUserB, Idx, cntB)
						Call CopyRows(rAryUser, rAryUserB, Idx+1, cntB+1)
						rAryUserB(0,cntB) = 1
						rAryUserB(0,cntB+1) = 1
					End If
				End If  
			End If 
		Next 

	End Function 
%>
