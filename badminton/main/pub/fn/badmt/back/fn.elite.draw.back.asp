<% 
'   ===============================================================================     
'    Purpose : badminton Elite 추첨에 들어가는 Util 함수 
'    Make    : 2019.05.23
'    Author  :                                                       By Aramdry
'   ===============================================================================    
%> 

<!-- #include virtual = "/pub/fn/badmt/res/res.pos.asp" -->  

<% 	  
'   ===============================================================================     
'     ary position  - 
'      fUse : user 할당 유무 
'      sz_block : block size : 4 - normal , 8 - Q(Qualification) 포함 
'      pos_kind : position 종류 - normal, seed, bye/Q (Qualification)
'      pos_val   : normal - -1(사용안함) , seed position val (1, 2, 3.. ), bye/Q position val (1, 2, 3)
'
'     복식 : fUse, pos, sz_block, pos_kind, pos_val, playerCode(단체코드), cUser1, user1, cUser2, user2, cTeam1, team1, cTeam2, team2
'     단식 : fUse, pos, sz_block, pos_kind, pos_val, playerCode(memIdx), user, cTeam, team

'     ary user - 
'      fUse, seed, gGroupIdx, user, memIdx, cTeam, team
'      fUse : user 할당 유무 
'      seed : seed Number
'   =============================================================================== 
   Dim POS_NORMAL, POS_SEED, POS_BYE, POS_Q, SZ_NORMAL, SZ_INCLUDEQ, SZ_Q, POSV_NOUSE
   Dim COLCNT_SINGLE, COLCNT_DOUBLE, EMPTY_PLAYER

   POS_NORMAL  = 0         ' 일반 자리 
   POS_SEED    = 1         ' Seed 자리 
   POS_BYE     = 2         ' Bye 자리 
   POS_Q       = 3         ' 예선전 조 자리 

   POSV_NOUSE  = -1        ' Position val 사용안함. 
   EMPTY_PLAYER = -1       ' bye/Q (Qualification)

   SZ_BLOCK    = 4         ' 대부분의 Block 크기 
   SZ_Q        = 4         ' 예선전 조의 Block 크기 
   SZ_INCLUDEQ = 8         ' 예선전 조를 포함한 Block 크기 (SZ_NORMAL + SZ_Q)

   COLCNT_SINGLE = 14      ' 복식 : fUse, pos, sz_block, pos_kind, pos_val, playerCode(단체코드), cUser1, user1, cUser2, user2, cTeam1, team1, cTeam2, team2
   COLCNT_DOUBLE = 9       ' 단식 : fUse, pos, sz_block, pos_kind, pos_val, playerCode(memIdx), user, cTeam, team
%>

<% 	  
'   ===============================================================================     
'      토너먼트 Round를 입력받아 Search Block 단위를 계산한다. 
'   =============================================================================== 
	Function uxElGetCntSearchBlock(tmRound)
		Dim searchBlock

		Select Case tmRound 
			Case 2,4,8,16,32	
				searchBlock = 4
			Case 64
				searchBlock = 8
			Case 128
				searchBlock = 16
			Case 256
				searchBlock = 32
		End Select

		uxElGetCntSearchBlock = searchBlock
	End Function

'   ===============================================================================     
'      참여인원, 강수를 입력받아 예선전이 있는지 유무를 확인한다. 
'   =============================================================================== 
   Function uxElIsOnlyTonament(cntUser, round)
		Dim cntDiff, bOnlyTonament
      bOnlyTonament = true

      cntDiff = cntUser - round
      If(cntDiff > 0) Then bOnlyTonament = false End If 

      uxElIsOnlyTonament = bOnlyTonament
   End Function

'   ===============================================================================     
'      참여인원, 강수를 입력받아 본선진출 인원및 예선 인원을 계산한다. 
'      예선 인원은 참여인원 - 본선진출 인원           - Elite Only 
'
'      1. cntUser(참여인원) <= round  : 본선 - cntUser , 예선 - 0
'      2. cntUser(참여인원) > round   :
'         참여인원과 강수의 차이를 구한다.                                    cntDiff = cntUser - round 
'         예선전 그룹수를 구한다. (참여인원과 강수의 차이 / 3)                 cntGroup = cntDiff / 3
'         예선전은 4인 1조로 구성하므로 /3을 해서 예선전 Group수를 구한후      if((cntGroup * 3) < cntDiff) cntGroup = cntGroup++
'         그 Group수 만큼 round에서 빼면 예선전 4인 1조를 구성할수 있다. 
'         따라서 round - 예선 Group수가 본선 진출 명수이다.                    cntTonament = round - cntGroup
'         예선전 인원은 참여인원 - 본선진출 인원                               cntPreliminary = cntUser - cntTonament 
'         
'   =============================================================================== 
   Function uxElGetTournamentUserCnt(cntUser, round)
		Dim cntDiff, cntGroup, cntTonament, cntPreliminary

      cntDiff = cntUser - round
      If(cntDiff < 0) Then 
         cntTonament = cntUser 
      Else 
         cntGroup = Fix(cntDiff / 3)
         If(cntDiff Mod 3 <> 0) Then cntGroup = cntGroup + 1 End If 
         cntTonament = round - cntGroup 
      End If 

      uxElGetTournamentUserCnt = cntTonament
   End Function

'   ===============================================================================     
'      예선 인원을 입력받아 예선전 Group수를 계산한다.  - Elite Only 
'
'      1. cntPreliminary / 4  : 예선전은 4인 1조로 구성    cntGroup = cntPreliminary / 4
'      2. 4명씩 조를 짜고도 나머지가 있으면                 cntGroup = cntGroup + 1'         
'   =============================================================================== 
   Function uxElGetPreliminaryGroupCnt(cntPreliminary)
		Dim cntGroup

      cntGroup = Fix(cntPreliminary / 4)
      If(cntPreliminary Mod 4 <> 0) Then cntGroup = cntGroup + 1 End If  

      uxElGetPreliminaryGroupCnt = cntGroup
   End Function

'   ===============================================================================     
'      예선 인원을 입력받아 예선전에서 3명 1조인 Group수를 계산한다.  - Elite Only 
'
'      1. cntPreliminary Mod 4  : 예선전은 4인 1조로 구성    cntGroup = cntPreliminary / 4
'      2. 4 - (cntPreliminary Mod 4) 를 한 값이 3명씩 조를 짜야 하는 Group 수 이다. Max 3
'   =============================================================================== 
   Function uxElGet3PersonGroupCnt(cntPreliminary)
		Dim cntRemain, cntGroup

      cntRemain = cntPreliminary Mod 4
      cntGroup = 4 - cntRemain
		If(cntRemain = 0) Then cntGroup = 0 End If 

      uxElGet3PersonGroupCnt = cntGroup
   End Function

'   ===============================================================================     
'     토너먼트 pos을 순차적으로 가져온다. 
'     복식 : fUse, pos, sz_block, pos_kind, pos_val, playerCode(단체코드), cUser1, user1, cUser2, user2, cTeam1, team1, cTeam2, team2
'     단식 : fUse, pos, sz_block, pos_kind, pos_val, playerCode(memIdx), user, cTeam, team
'   ===============================================================================
	Function uxElGetAryTonament(tmRound, bDoubleGame)
		Dim aryTonament, Idx, nDim1		

		' column수 : 복식일 경우 14, 단식일 경우 9
      nDim1 = COLCNT_SINGLE
      If( bDoubleGame = 1 ) Then nDim1 = COLCNT_DOUBLE

      ReDim aryTonament(nDim1, tmRound-1)
	
		For Idx = 0 to tmRound-1	
			aryPos(0, Idx) = 0
			aryPos(1, Idx) = Idx + 1
         aryPos(2, Idx) = POS_NORMAL
			aryPos(3, Idx) = POSV_NOUSE
         aryPos(4, Idx) = SZ_BLOCK
		Next

		uxElGetAryPos = aryTonament
	End Function

'   ===============================================================================     
'     aryTonament에 Seed, Bye를 셋팅한다. 
'     fUse, pos, sz_block, pos_kind, pos_val, playerCode
'   ===============================================================================
	Function uxElInitAryTonament1(rAryTonament, cntSeed, cntUser)
		Dim Idx, ub, posKind, arySeed, aryBye, nPos		

		ub = UBound(rAryTonament, 2)   

      ' seed Position을 구한다. 
      arySeed = uxElGetArySeedPos(ub+1)

      For Idx = 0 to ub	
         nPos = uxElIsSeedData(aryBye, Idx)
         If(nPos <> -1) Then 
            rAryTonament(2, Idx) = POS_SEED
            rAryTonament(3, Idx) = nPos
            rAryTonament(4, Idx) = SZ_BLOCK

            ' seed 갯수 만큼만 seed를 설정한다. 
            If( nPos = cntSeed) Then 
               Exit For
            End If 
			End If			
		Next

      ' Bye Position을 구한다. 
      aryBye = uxElGetAryByePos(cntUser)
	
		For Idx = 0 to ub	
         nPos = uxElIsByeData(aryBye, Idx)
         If(nPos <> -1) Then 
            rAryTonament(2, Idx) = POS_BYE
            rAryTonament(3, Idx) = nPos
            rAryTonament(4, Idx) = SZ_BLOCK
            rAryTonament(5, Idx) = EMPTY_PLAYER
			End If			
		Next
	End Function

   '   ===============================================================================     
'     aryTonament에 Seed, Q를 셋팅한다. 
'     Q position의 갯수는 예선조 갯수 이므로 round - 예선조 갯수를 해야 byePos을 구할수 있는 인원수를 구할수 있다.  
'     fUse, pos, sz_block, pos_kind, pos_val, playerCode
'   ===============================================================================
	Function uxElInitAryTonament2(rAryTonament, cntSeed, cntQGroup)
		Dim Idx, ub, posKind, arySeed, aryBye, nPos, cntUser	

		ub = UBound(rAryTonament, 2)   

      ' seed Position을 구한다. 
      arySeed = uxElGetArySeedPos(ub+1)

      For Idx = 0 to ub	
         nPos = uxElIsSeedData(arySeed, Idx)
         If(nPos <> -1) Then 
            rAryTonament(2, Idx) = POS_SEED
            rAryTonament(3, Idx) = nPos
            rAryTonament(4, Idx) = SZ_BLOCK

            ' seed 갯수 만큼만 seed를 설정한다. 
            If( nPos = cntSeed) Then 
               Exit For
            End If 
			End If			
		Next

      ' Bye Position을 구한다. 
      cntUser = (ub+1) - cntQGroup
      aryBye = uxElGetAryByePos(cntUser)
	
		For Idx = 0 to ub	
         nPos = uxElIsByeData(aryBye, Idx)
         If(nPos <> -1) Then 
            rAryTonament(2, Idx) = POS_Q
            rAryTonament(3, Idx) = nPos
            rAryTonament(4, Idx) = SZ_INCLUDEQ
            rAryTonament(5, Idx) = EMPTY_PLAYER
			End If			
		Next
	End Function

'   ===============================================================================     
'     Q(예선전) pos을 순차적으로 가져온다. 
'     복식 : fUse, pos, sz_block, pos_kind, pos_val, playerCode(단체코드), cUser1, user1, cUser2, user2, cTeam1, team1, cTeam2, team2
'     단식 : fUse, pos, sz_block, pos_kind, pos_val, playerCode(memIdx), user, cTeam, team
'   ===============================================================================
	Function uxElGetAryQ(cntPreliminary, bDoubleGame)
		Dim aryQ, Idx, nDim1, cntGroup, cntUser

		' column수 : 복식일 경우 14, 단식일 경우 9
      nDim1 = COLCNT_SINGLE
      If( bDoubleGame = 1 ) Then nDim1 = COLCNT_DOUBLE

      cntGroup = uxElGetPreliminaryGroupCnt(cntPreliminary)
      cntUser = cntGroup * SZ_Q

      ReDim aryQ(nDim1, cntUser-1)

      ' 앞부분에 4인 1조가 위치한다. 
		For Idx = 0 to cntUser-1	
			aryQ(0, Idx) = 0
			aryQ(1, Idx) = Idx + 1
         aryQ(2, Idx) = POS_NORMAL
			aryQ(3, Idx) = POSV_NOUSE
         aryQ(4, Idx) = SZ_BLOCK
		Next

		uxElGetAryQ = aryQ
	End Function

'   ===============================================================================     
'     aryQ(예선전)에 Bye position을 셋팅한다. 
'     예선전 조는 4인 1조가 기본이며, 3인 + 1 Bye가 1조가 될수도 있다. 이때 (3인 + 1 Bye)는 맨 뒤에 위치한다. 
'     복식 : fUse, pos, sz_block, pos_kind, pos_val, playerCode(단체코드), cUser1, user1, cUser2, user2, cTeam1, team1, cTeam2, team2
'     단식 : fUse, pos, sz_block, pos_kind, pos_val, playerCode(memIdx), user, cTeam, team
'   ===============================================================================
	Function uxElInitAryQ(rAryQ, cntPreliminary)
		Dim aryQ, Idx, cnt3Group, cntUser, ub
      Dim byePos, aryBye		

		ub = UBound(rAryQ, 2)
      cnt3Group = uxElGet3PersonGroupCnt(cntPreliminary)      
      cntUser = (cnt3Group * SZ_Q)-1      

      ' Bye Position을 구한다. 
      aryBye = uxElGetAryByePos(4)
      byePos = aryBye(1)

      ' 뒷부분에 (3인 + 1 Bye) 1조가 위치한다.       
		For Idx = ub-cntUser to ub
         If( (Idx Mod 4) = byePos ) Then 
            rAryQ(0, Idx) = 0
            rAryQ(1, Idx) = Idx + 1
            rAryQ(2, Idx) = POS_BYE
            rAryQ(3, Idx) = 1
            rAryQ(4, Idx) = SZ_INCLUDEQ
            rAryQ(5, Idx) = EMPTY_PLAYER
         End If 
		Next

		uxElInitAryQ = rAryQ
	End Function


'   ===============================================================================     
'     토너먼트 pos을 순차적으로 가져온다. (Random Position Game     - 처음부터 토너먼트 )
'     복식 : fUse, pos, sz_block, pos_kind, pos_val, playerCode(단체코드), cUser1, user1, cUser2, user2, cTeam1, team1, cTeam2, team2
'     단식 : fUse, pos, sz_block, pos_kind, pos_val, playerCode(memIdx), user, cTeam, team
'   ===============================================================================
	Function uxElGetAryPos(tmRound, bDoubleGame)
		Dim aryPos, aryPosData 
		Dim strId, strTeam, pos, Idx, nDim1		

		' column수 : 복식일 경우 15, 단식일 경우 8
        nDim1 = 8
        If( bDoubleGame = 1 ) Then nDim1 = 15 

        ReDim aryPos(nDim1, tmRound-1)
	
		For Idx = 0 to tmRound-1	
			aryPos(0, Idx) = 0
			aryPos(1, Idx) = Idx + 1
		Next

		uxElGetAryPos = aryPos
	End Function

'   ===============================================================================     
'      인원수로 ByePos을 얻는다. 
'   ===============================================================================
	Function uxElGetAryByePos(userCnt)
		nCnt = userCnt - 1 
		If(nCnt < 1 Or nCnt > 255) Then nCnt = 0 End If
		uxElGetAryByePos = gAryByePos(nCnt)
	End Function

'   ===============================================================================     
'      round로 seedPos을 얻는다. 
'   ===============================================================================
	Function uxElGetArySeedPos(round)		
		If(round < 4 Or round > 256) Then round = 4 End If
		
      Dim ary
		Select Case round
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
		uxElGetArySeedPos = ary

	End Function

'   ===============================================================================     
'      Bye(Empty Seed) Pos을 aryPos에 Setting 한다. 
'   ===============================================================================
	Function uxElInitAryPos(byRef rAryPos,aryBye)
		Dim pi, eBase, emptyUser, emptyTeam, ub

		ub = UBound(rAryPos, 2)   

		For pi = 0 To ub
			If(uxElIsByeData(aryBye, rAryPos(1,pi)) = 1) Then 
				rAryPos(0,pi) = 1
				rAryPos(2,pi) = -1
			End If
		Next
	End Function


'   ===============================================================================     
'      Bye(Empty Seed) array에서 nPos값을 입력받아 Bye Position 인지 유무를 판단한다. 
'      aryBye의 0 position에는 bye의 갯수가 저장되어 있다. 
'   ===============================================================================
	Function uxElIsByeData(rAryBye, nPos)
		Dim ub, ai, nFind

		nFind = -1
		ub = UBound(rAryBye) 

		For ai = 1 To ub
			If(rAryBye(ai) = nPos) Then 
				nFind = ai
				Exit For
			End If
		Next
		uxElIsByeData = nFind

	End Function

'   ===============================================================================     
'      Bye(Empty Seed) array에서 nPos값을 입력받아 Bye Position 인지 유무를 판단한다. 
'      aryBye의 0 position에는 bye의 갯수가 저장되어 있다. 
'   ===============================================================================
	Function uxElIsSeedData(rArySeed, nPos)
		Dim ub, ai, nFind

		nFind = -1
		ub = UBound(rArySeed) 

		For ai = 0 To ub
			If(rArySeed(ai) = nPos) Then 
				nFind = ai+1
				Exit For
			End If
		Next
		uxElIsSeedData = nFind

	End Function

'   ===============================================================================     
'      Team을 Unique하게 구한다. 
'      복식일 경우도 단일팀으로 계산하여 구한다 .
'      fUse, firstSel, cntUser, cTeam , team
'      사용유무, 팀코드, 팀이름, 시군코드, 시군이름, 팀원 숫자, 먼저 배치할지 유무 
'   ===============================================================================
    Function uxElGetArrayTeam(rAryUser)
		Dim ai, ul, aryTmp, aryTeam, cntTeam, cTeam, bDuplicate
		Dim nUser, nAve
		
		ub = UBound(rAryUser, 2) 
		ReDim aryTmp(7, ub+1)
		cntTeam = 0

		nUser = ub + 1					' count of User

		' 실제 unique team 구하기 
		For ai = 0 To ub             
			cTeam = rAryUser(4, ai)
			bDuplicate = uxElCheckDuplicateTeam(aryTmp, cTeam)
        
			If (bDuplicate = 0) Then 
				aryTmp(0, cntTeam) = 1                
            aryTmp(2, cntTeam) = 1			    ' team count를 1로 초기화 ( 중복 일때만 카운트를 추가 하기 때문에 1로 셋팅해도 된다. )
				aryTmp(3, cntTeam) = rAryUser(4, ai)
            aryTmp(4, cntTeam) = rAryUser(5, ai)
            aryTmp(5, cntTeam) = rAryUser(6, ai)
            aryTmp(6, cntTeam) = rAryUser(7, ai)

				cntTeam = cntTeam + 1
			End If	
		Next	
  
		nAve = nUser / cntTeam 

		ReDim aryTeam(7, cntTeam-1)

		ub = UBound(aryTeam, 2) 
		For ai = 0 To ub 
			If (aryTmp(0, ai) = "1") Then 
				aryTeam(0, ai) = 0
				aryTeam(2, ai) = aryTmp(2, ai)
				aryTeam(3, ai) = aryTmp(3, ai)
                aryTeam(4, ai) = aryTmp(4, ai)
				aryTeam(5, ai) = aryTmp(5, ai)
				aryTeam(6, ai) = aryTmp(6, ai)

				If( aryTeam(2, ai) > nAve ) Then 	' 평균 보다 팀원이 많으면 선순위로 선수를 등록한다. 
					aryTeam(1, ai) = 1
				Else 								' 평균보다 팀원이 적으면 랜덤하게 선수를 등록한다. 
					aryTeam(1, ai) = 0
				End If
			End If	
		Next

		uxElGetArrayTeam = aryTeam
	End Function  

'   ===============================================================================     
'      aryTeam Data 중복 체크 , ary, data
'   ===============================================================================
	Function uxElCheckDuplicateTeam(rAryTeam, cTeam) 
		Dim dai, ub, bDuplicate

		bDuplicate = 0		
      ub = UBound(rAryTeam, 2)   

		For dai=0 To ub	    
         If( CStr(rAryTeam(3,dai)) = CStr(cTeam) ) Then 
				rAryTeam(2,dai) = rAryTeam(2,dai) + 1              ' Team에 소속한 User Count
				bDuplicate = 1
				Exit For
			End If

         If ( rAryTeam(0, dai) <> 1 ) Then                     ' rAryTeam(0, dai) = 1 이 있어야 데이터가 있는 것이다. 
               Exit For                                        ' 배열의 크기보다 들어 있는 데이터가 작기 때문에 
         End If                                                ' rAryTeam(0, dai) <> 1 배열의 모든 데이터를 검색했다는 의미다. 
		Next

		uxElCheckDuplicateTeam = bDuplicate
	End Function 

'   ===============================================================================     
'      aryTeam에서 Random하게 Team하나를 선택한다. 
'	    aryTeam에서 Team User Count가 팀 평균 Count보다 크면 (aryTeam(1,team) > average) 먼저 팀원을 배정한다. 
'      aryTeam에서 Team User Count가 팀 평균 Count보다 작으면 (aryTeam(1,team) < average) 랜덤하게 팀을 순환하면서  팀원을 배정한다. 
'      fUse, firstSel, cntUser, cTeam , team, cSigun, sigun
'   ===============================================================================
	Function uxElGetSelTeam(byRef rAryTeam)
		Dim selTeam, useOverTeam, ub1
		useOverTeam = 0

		ub1 = UBound(rAryTeam, 2) 

        ' 삭제가 되지 않았고 , firstSel = 1로 셋팅이 되어 있으면 먼저 할당한다. 
        ' 즉 Team User Count가 팀 평균 Count보다 크면 (aryTeam(1,team) > average) 먼저 팀원을 배정한다.
        ' 모든 사용자를 할당한 팀은 배열에서 삭제 해야 한다. 
        ' 물리적으로 삭제를 하지 않고 flag setting으로 삭제 유무 표시 : rAryTeam(0,Idx) = -1
		For Idx = 0 To ub1
			If( rAryTeam(0,Idx) <> -1 ) And (rAryTeam(1, Idx) = 1) Then 
				useOverTeam = 1 
				Exit For
			End If
		Next
		
		If (useOverTeam = 1) Then    
			selTeam = uxElGetSelTeamOverAve(rAryTeam)
		Else 
			selTeam = uxElGetSelTeamLowAve(rAryTeam)
		End If

		uxElGetSelTeam = selTeam
	End Function

'   ===============================================================================     
'      aryTeam에서 Random하게 Team하나를 선택한다. 
'	    aryTeam에서 Team User Count가 팀 평균 Count보다 크면 (aryTeam(1,team) > average) 먼저 팀원을 배정한다. 
'      aryTeam에서 Team User Count가 팀 평균 Count보다 작으면 (aryTeam(1,team) < average) 랜덤하게 팀을 순환하면서  팀원을 배정한다. 
'   ===============================================================================
	Function uxElGetSelTeamOverAve(byRef rAryTeam)
		Dim cntTeam, selTeam, tIdx1, tub1, rNum, cnt, bFirstSel
      bFirstSel = 1        

		cntTeam = uxElGetTeamCnt(rAryTeam, bFirstSel)
		
		If(cntTeam = 1) Then
			rNum = 0
		Else 
			rNum = GetRandomNum(cntTeam) - 1
		End If

	'   ===============================================================================   
	'	selTeam을 구한다. ( (rAryTeam(1, tIdx1) = 1) 것만 rNum과 cnt가 같을 때 까지 ) 
   '  Team User Count가 팀 평균 Count보다 큰 팀만 count한다. 
		tub1 = UBound(rAryTeam, 2) 
		cnt = 0
		selTeam = -1

		For tIdx1 = 0 To tub1
			If(rAryTeam(1, tIdx1) = 1) Then 
				If(rNum = cnt) Then 			' 찾았다. 
					selTeam = tIdx1
					Exit For 
				End If
				cnt = cnt + 1
			End If
		Next

		uxElGetSelTeamOverAve = selTeam
	End Function

'   ===============================================================================     
'      aryTeam에서 Random하게 Team하나를 선택한다. 
'	    aryTeam에서 Team User Count가 팀 평균 Count보다 크면 (aryTeam(1,team) > average) 먼저 팀원을 배정한다. 
'      aryTeam에서 Team User Count가 팀 평균 Count보다 작으면 (aryTeam(1,team) < average) 랜덤하게 팀을 순환하면서  팀원을 배정한다. 
'   ===============================================================================
	Function uxElGetSelTeamLowAve(byRef rAryTeam)
		Dim cntTeam, selTeam, tIdx, tub, rNum, cnt, bFirstSel
      bFirstSel = 0        

		cntTeam = uxElGetTeamCnt(rAryTeam, bFirstSel)
		If (cntTeam = 0 ) Then 
			Call uxElResetFUseInAryTeam(rAryTeam) 
         cntTeam = uxElGetTeamCnt(rAryTeam, bFirstSel)
		End If

		rNum = GetRandomNum(cntTeam) - 1
	'   ===============================================================================   
	'	selTeam을 구한다. ( fUse = 0인 것만이 대상 - rNum과 cnt가 같을 때 까지 ) fUse = -1 삭제 , fUse = 1 사용
		tub = UBound(rAryTeam, 2) 
		cnt = 0
		selTeam = -1

		For tIdx = 0 To tub
			If(rAryTeam(0, tIdx) = 0) Then 
				If(rNum = cnt) Then 			' 찾았다. 
					selTeam = tIdx
					Exit For 
				End If
				cnt = cnt + 1
			End If
		Next

		If( selTeam <> -1 ) Then rAryTeam(0,selTeam) = 1	End If		' fUse Setting 

		uxElGetSelTeamLowAve = selTeam
	End Function

'   ===============================================================================     
'      aryTeam에서 선택 가능한 팀 Count를 구한다.  
'     
'      bFirstSel = 1 team 원 수가 average보다 큰 팀 카운트 
'        조건 : rAryTeam(1,aci) = 1 : 먼저 선택해야 한다는 flag 
'      bFirstSel = 0 team 원 수가 average보다 작거나 같은 팀 카운트 
'        조건 : rAryTeam(0, aci) = 0 
'      team 원 수가 average보다 큰 팀 카운트 
'      fUse, firstSel, cntUser, cTeam , team, cSigun, sigun
'   ===============================================================================
	Function uxElGetTeamCnt(byRef rAryTeam, bFirstSel)
		Dim aci , ucb, cntTeam
		
		cntTeam = 0
		ucb = UBound(rAryTeam, 2) 

        ' 먼저 할당해야 하는 것은 fUse를 사용하지 않는다. 
        If( bFirstSel = 1 ) Then 
            For aci = 0 To ucb 		
                If ( rAryTeam(0,aci) <> -1)  And ( rAryTeam(1,aci) = 1)Then 
                    cntTeam = cntTeam + 1
                End If
            Next
        Else    
            For aci = 0 To ucb 		
                If ( rAryTeam(0, aci) = 0 ) And ( rAryTeam(0,aci) <> -1) Then 
                    cntTeam = cntTeam + 1
                End If
            Next
        End If		

		uxElGetTeamCnt = cntTeam
	End Function

'   ===============================================================================     
'      aryTeam : Reset fUse
'      aryTeam(0,ti) = -1 삭제 flag
'   ===============================================================================
	Function uxElResetFUseInAryTeam(byRef aryTeam)
		Dim ti , ubt

		ubt = UBound(aryTeam, 2) 
		For ti = 0 To ubt 		
			If(aryTeam(0,ti) <> -1) Then 
				aryTeam(0, ti) = 0
			End If
		Next
	End Function

'   ===============================================================================     
'      aryTeam : Remove Team 
'      Redim 을 해야 하나 refrence로 물고 있으면 적용이 안되어 부득이 -1로 Del flag를 세웠다. 
'      삭제할 pos을 기점으로 배열을 한칸씩 당기고 제일 마지막 값에 Del flag를 세운다. 
'      fUse, firstSel, cntUser, cTeam , team, cSigun, sigun
'   ===============================================================================
	Function uxElRemoveTeamFromAryTeam(ByRef rAryTeam, cTeam)
		Dim ti , ubt, jj

		ubt = UBound(rAryTeam, 2) 
		For ti = 0 To ubt 		
			If( rAryTeam(3, ti) = cTeam ) Then 
				For jj = ti To ubt-1               '      삭제할 pos을 기점으로 배열을 한칸씩 당기고 제일 마지막 값에 Del flag를 세운다. 
					rAryTeam(0, jj) = rAryTeam(0, jj+1)
					rAryTeam(1, jj) = rAryTeam(1, jj+1)
               rAryTeam(2, jj) = rAryTeam(2, jj+1)
					rAryTeam(3, jj) = rAryTeam(3, jj+1)
               rAryTeam(4, jj) = rAryTeam(4, jj+1)
					rAryTeam(5, jj) = rAryTeam(5, jj+1)
               rAryTeam(6, jj) = rAryTeam(6, jj+1)					
				Next
				rAryTeam(0, jj) = -1
				Exit For 
			End If
		Next

	End Function

'   ===============================================================================     
'     team을 입력받아  rAryUser에서 User를 하나 선택한다. 
'     해당하는 Team에 더이상 선수가 없으면 -1을 Return한다. 
'     복식 / 단식 구분없이 실행한다. 
'   ===============================================================================
	Function uxElGetSelUser(byRef rAryUser, cTeam)
		Dim selUser, uIdx, ub, nCntUser, rNum, nCnt

	'   ===============================================================================   
	'	selUser을 구한다. ( fUse = 1인 것을 제외하고 strTeam과 team이 같을때 까지 )
		ub = UBound(rAryUser, 2) 		
		nCntUser = uxElGetCntTeamUser(rAryUser, cTeam)
		rNum = GetRandomNum(nCntUser) - 1
		selUser = -1

		For uIdx = 0 To ub
			If(rAryUser(0, uIdx) = 0) And (rAryUser(4, uIdx) = cTeam) Then 	' 찾았다. 
				If(rNum = nCnt) Then 
					selUser = uIdx
					rAryUser(0, uIdx) = 1		' fUse Setting 			
					Exit For 
				Else
					nCnt = nCnt + 1
				End If				
			End If
		Next

		uxElGetSelUser = selUser
	End Function

'   ===============================================================================     
'     team을 입력받아  rAryUser에서 해당 Team원 수를 Return 한다. 
'     이때 팀원은 사용하지 않은 팀원에 한정한다.  fUse = 1인 것을 제외
'   ===============================================================================
	Function uxElGetCntTeamUser(byRef rAryUser, cTeam)
		Dim userIdx, userub, nCntUser

	'   ===============================================================================   
	'	selUser을 구한다. ( fUse = 1인 것을 제외하고 cTeam team이 같을때 까지 )
		userub = UBound(rAryUser, 2) 		
		nCntUser = 0

		For userIdx = 0 To userub
			If(rAryUser(0, userIdx) = 0) And (rAryUser(4, userIdx) = cTeam) Then 	' 찾았다. 
				nCntUser = nCntUser + 1
			End If
		Next

		uxElGetCntTeamUser = nCntUser
	End Function

' ************************************************************************************************
' ************************************************************************************************
' 복식 

'   ===============================================================================     
'     UserInfo를 입력받아 rAryPos에 배치한다. 
'     Team 중복 체크 ( block 단위 )
'     AryPos Info 
'     복식 : fUse, pos, sz_block, pos_kind, pos_val, playerCode(단체코드), cUser1, user1, cUser2, user2, cTeam1, team1, cTeam2, team2
'     단식 : fUse, pos, sz_block, pos_kind, pos_val, playerCode(memIdx), user, cTeam, team
'     AryUser Info 
'           fUse, seed, gGroupIdx, user, memIdx, cTeam, team
'   ===============================================================================
	Function uxElSetGamePosDbl(byRef rAryPos, byRef rAryUser, nSelUser, sBlock)
		Dim selPos, uIdx, ub, sBase, fLoop, aryBlock, rNum, cntPos
      Dim nSelUser2, fCkTeam        ' fCkTeam : Team Code를 Check한다. 

   '   -----------------------------------------------------------------------
      ' 복식이기 때문에 user Info를 2개 가지고 사용해야 한다. 
      If( nSelUser Mod 2 ) = 1 Then 
         nSelUser2 = nSelUser -1
      Else 
         nSelUser2 = nSelUser + 1
      End If

      rAryUser(0, nSelUser2) = 1		' fUse Setting 	    복식일 경우 파트너도 fUse를 1로 셋팅한다. 
    '   -----------------------------------------------------------------------

		sBase = sBlock 
		fLoop = 1
      fCkTeam = 0

      ' sigun을 먼저 체크하고 sigun에서 sBlock이 1이 되어도 넣을 곳이 없다면
      ' team을 체크한다. team에서도 넣을 곳이 없다면 빈곳에 아무 곳이나 insert한다. 
		Do While fLoop
			strBlock = uxElCheckTeamInArrayPosDbl(rAryPos, rAryUser, nSelUser, nSelUser2, sBase, fCkTeam)

			If( strBlock <> "" ) Or ( fCkTeam = 1 And sBase = 1 )Then 
				fLoop = 0
         ElseIf ( fCkTeam = 0 And sBase = 1 ) Then 
            sBase = sBlock 
            fCkTeam = 1
			Else 
				sBase = sBase / 2
			End If			
		Loop

		If( strBlock <> "" ) Then 	' 찾았다. 
			aryBlock = split(strBlock, ",")
			ub = UBound(aryBlock) 
			rNum = GetRandomNum(ub+1) - 1

			' ex) strBlock = 0,1,2,3,4,5,6,7  넘어오는 값이 이런식이므로 
         '     start position을 구할때 * sBase을 해야 실제 Block start position을 구할수 있다. 
			sPos = aryBlock(rNum) * sBase   
			ePos = sPos + sBase -1

			cntPos = 0
			For pai = sPos To ePos		' count를 구한다. 
				If( rAryPos(0, pai) = 0 ) Then 
					cntPos = cntPos + 1 
				End If
			Next

			rNum2 = GetRandomNum(cntPos) - 1

'		strLog = strPrintf("--------------------strBlock = {0} , rNum = {1}, sPos = {2}, ePos = {3}, rNum2 = {4}, cntPos = {5}  <br>", _
'					 Array(strBlock, rNum, sPos, ePos, rNum2, cntPos))
'        Response.Write strLog

			cntPos2 = 0
			selPos = -1
			For pai = sPos To ePos		' insert position을 random하게 구한다. 
				If( rAryPos(0, pai) = 0 ) And (rNum2 = cntPos2) Then 
					selPos = pai

'					strLog = strPrintf("^^^^^^^^^^^^^rNum2 = {0} , cntPos2 = {1}, selPos = {2}, pai = {3}<br>", _
'					Array(rNum2, cntPos2, selPos, pai))
'        			Response.Write strLog
					Exit For
				Else 
					If( rAryPos(0, pai) = 0 ) Then 
						cntPos2 = cntPos2 + 1 
					End If
				End If
			Next
		End If	

      '   -----------------------------------------------------------------------
      '    빈자리를 못찾았으면 아무 빈자리나 넣는다. 
      If (selPos = -1) Then 
         selPos = uxElGetPosByRandom(aryPos)
      End If 
      '   -----------------------------------------------------------------------
            
		If (selPos <> -1 ) Then 
			rAryPos(0, selPos) = 1
			rAryPos(2, selPos) = rAryUser(1,nSelUser)
			rAryPos(3, selPos) = rAryUser(3,nSelUser)   ' cUser
         rAryPos(4, selPos) = rAryUser(2,nSelUser)   ' user
			rAryPos(5, selPos) = rAryUser(3,nSelUser2)
         rAryPos(6, selPos) = rAryUser(2,nSelUser2)
			rAryPos(7, selPos) = rAryUser(4,nSelUser)   ' cTeam 
         rAryPos(8, selPos) = rAryUser(5,nSelUser)   ' team
			rAryPos(9, selPos) = rAryUser(4,nSelUser2)
         rAryPos(10, selPos) = rAryUser(5,nSelUser2)
			rAryPos(11, selPos) = rAryUser(6,nSelUser)  ' cSigun
         rAryPos(12, selPos) = rAryUser(7,nSelUser)  ' sigun 
			rAryPos(13, selPos) = rAryUser(6,nSelUser2)
         rAryPos(14, selPos) = rAryUser(7,nSelUser2)

'			strLog = strPrintf("--------------------strBlock = {0} , rNum = {1}, sPos = {2}, ePos = {3}, rNum2 = {4}, cntPos = {5}  <br>", _
'					 Array(strBlock, rNum, sPos, ePos, rNum2, cntPos))					 
'        	Response.Write strLog
		Else 
'			strLog = "****************** duplicate ..  <br>"					 
'        	Response.Write strLog
		End If

	End Function

'   ===============================================================================
'     Team 중복 체크 ( block 단위 )  - block 갯수만큼 루프가 동작
'     fCkTeam = 0 : sigun check , 1 : team check 
'   ===============================================================================
	Function uxElCheckTeamInArrayPosDbl(byRef rAryPos, byRef rAryUser, sel1, sel2, sBlock, fCkTeam)
		Dim strFind, sPos, ePos, nMax, ubp, apIdx, nPossible

		ubp = UBound(rAryPos, 2) 
		nMax = (ubp+1) / sBlock             ' block 갯수만큼 루프를 돈다. 
		
		strFind = ""
		sPos = 0

		For apIdx = 0 To nMax-1
			nPossible = uxElIsPossibleInsertPosDbl(rAryPos, rAryUser, sel1, sel2, sPos, sBlock, fCkTeam)

			If(nPossible = 1) Then 
				If (strFind = "" ) Then 
					strFind = strPrintf("{0}", Array(apIdx))
				Else 
					strFind = strPrintf("{0},{1}", Array(strFind, apIdx))
				End If
			End If

			sPos = sPos + sBlock             ' block 갯수만큼 루프가 동작하므로 , 다음 start position = sPos + sBlock 이다. 
		Next	

		uxElCheckTeamInArrayPosDbl = strFind		
	End Function

'   ===============================================================================
'     Team 중복 체크 ( block 단위 )
'     Block 이 꽉 차 있어도 안된다. 
'       UserInfo : fUse, seed, gGroupIdx, user, memIdx, cTeam, team
'     복식 : fUse, pos, sz_block, pos_kind, pos_val, playerCode(단체코드), cUser1, user1, cUser2, user2, cTeam1, team1, cTeam2, team2
'     단식 : fUse, pos, sz_block, pos_kind, pos_val, playerCode(memIdx), user, cTeam, team
'       fCkTeam = 0 : sigun check / 1 : team check 
'   ===============================================================================
	Function uxElIsPossibleInsertPosDbl(byRef rAryPos, rAryUser, sel1, sel2, sPos, sBlock, fCkTeam)
		Dim ckIdx, nPossible , ePos, cntUsed
      Dim cTeam1, cTeam2, cSigun1, cSigun2

		nPossible = 1
		cntUsed = 0
		ePos = (sPos + sBlock) - 1

      If( fCkTeam = 1 ) Then                 ' 팀을 체크한다. 
         cTeam1 = rAryUser(4, sel1)
         cTeam2 = rAryUser(4, sel2)

         For ckIdx = sPos To ePos
            If( rAryPos(0, ckIdx) = 1 ) Then    ' Player가 배치 된 곳에서만 비교를 한다. 
               ' 복식이므로 Team Code가 2개 있다. rAryPos(7, ckIdx), rAryPos(9, ckIdx)
               If( rAryPos(7, ckIdx) = cTeam1 ) Or (rAryPos(7, ckIdx) = cTeam2 ) Or _ 
                  ( rAryPos(9, ckIdx) = cTeam1 ) Or (rAryPos(9, ckIdx) = cTeam2 ) Then 
                  nPossible = 0		 						' 같은 Team이 있다. 
                  Exit For 
               End If

               cntUsed = cntUsed + 1
            End If
         Next
      Else                                   ' 시군을 체크한다. 
         cSigun1 = rAryUser(6, sel1)
         cSigun2 = rAryUser(6, sel2)

         For ckIdx = sPos To ePos
            If( rAryPos(0, ckIdx) = 1 ) Then    ' Player가 배치 된 곳에서만 비교를 한다. 
               ' 복식이므로 시군 Code가 2개 있다. rAryPos(11, ckIdx), rAryPos(13, ckIdx)
               If( rAryPos(11, ckIdx) = cSigun1 ) Or (rAryPos(11, ckIdx) = cSigun2 ) Or _ 
                  ( rAryPos(13, ckIdx) = cSigun1 ) Or (rAryPos(13, ckIdx) = cSigun2 ) Then 
                  nPossible = 0								' 같은 시군이 있다. 
                  Exit For 
               End If

               cntUsed = cntUsed + 1
            End If
         Next
      End If

      ' 다 사용중 ( 할당할수 없다.) - 해당 Block내에 빈 공간이 없다. 
		If( cntUsed = sBlock ) Then nPossible = 0 End If			


'		strLog = strPrintf("cntUsed = {0} , nPossible = {1} <br>", Array(cntUsed, nPossible))
'        Response.Write strLog

		uxElIsPossibleInsertPosDbl = nPossible		
	End Function

'   ===============================================================================
'     Get Random Position : 빈자리중 랜덤하게 한자리를 찾는다. 
'   ===============================================================================
	Function uxElGetPosByRandom(byRef rAryPos)
		Dim strFind, rai, rub, nCnt, rNum, nSelPos

		rub = UBound(rAryPos, 2) 
		nCnt = 0

      ' 빈자리 (rAryPos(0,rai) = 0)의 갯수를 Count
		For rai = 0 To rub
			If(rAryPos(0,rai) <> 1) Then nCnt = nCnt+1 End If                
		Next	

      rNum = GetRandomNum(nCnt) - 1

      nCnt = 0
      nSelPos = 0
      For rai = 0 To rub
         If(rAryPos(0,rai) <> 1) Then 
            If(rNum = nCnt) Then 
               nSelPos = rai
               Exit For
            Else 
               nCnt = nCnt+1
            End If
         End If
		Next	
		uxElGetPosByRandom = nSelPos		
	End Function

' ************************************************************************************************
' ************************************************************************************************
' 단식 

'   ===============================================================================     
'     UserInfo를 입력받아 rAryPos에 배치한다. 
'     Team 중복 체크 ( block 단위 )
'     AryPos Info 
'     복식 : fUse, pos, sz_block, pos_kind, pos_val, playerCode(단체코드), cUser1, user1, cUser2, user2, cTeam1, team1, cTeam2, team2
'     단식 : fUse, pos, sz_block, pos_kind, pos_val, playerCode(memIdx), user, cTeam, team
'     AryUser Info 
'           fUse, seed, gGroupIdx, user, memIdx, cTeam, team
'   ===============================================================================
	Function uxElSetGamePos(byRef rAryPos, byRef rAryUser, nSelUser, sBlock)
		Dim selPos, uIdx, ub, sBase, fLoop, aryBlock, rNum, cntPos
      Dim nSelUser2, fCkTeam

		sBase = sBlock 
		fLoop = 1
      fCkTeam = 0

      ' sigun을 먼저 체크하고 sigun에서 sBlock이 1이 되어도 넣을 곳이 없다면
      ' team을 체크한다. team에서도 넣을 곳이 없다면 빈곳에 아무 곳이나 insert한다. 
		Do While fLoop
			strBlock = uxElCheckTeamInArrayPos(rAryPos, rAryUser, nSelUser, sBase, fCkTeam)

			If( strBlock <> "" ) Or ( fCkTeam = 1 And sBase = 1 )Then 
				fLoop = 0
         ElseIf ( fCkTeam = 0 And sBase = 1 ) Then 
            sBase = sBlock 
            fCkTeam = 1
			Else 
				sBase = sBase / 2
			End If			
		Loop

		If( strBlock <> "" ) Then 	' 찾았다. 
			aryBlock = split(strBlock, ",")
			ub = UBound(aryBlock) 
			rNum = GetRandomNum(ub+1) - 1

         ' ex) strBlock = 0,1,2,3,4,5,6,7  넘어오는 값이 이런식이므로 
         '     start position을 구할때 * sBase을 해야 실제 Block start position을 구할수 있다. 
			sPos = aryBlock(rNum) * sBase
			ePos = sPos + sBase -1

			cntPos = 0
			For pai = sPos To ePos		' count를 구한다. 
				If( rAryPos(0, pai) = 0 ) Then 
					cntPos = cntPos + 1 
				End If
			Next

			rNum2 = GetRandomNum(cntPos) - 1

'		strLog = strPrintf("--------------------strBlock = {0} , rNum = {1}, sPos = {2}, ePos = {3}, rNum2 = {4}, cntPos = {5}  <br>", _
'					 Array(strBlock, rNum, sPos, ePos, rNum2, cntPos))
'        Response.Write strLog

			cntPos2 = 0
			selPos = -1
			For pai = sPos To ePos		' insert position을 random하게 구한다. 
				If( rAryPos(0, pai) = 0 ) And (rNum2 = cntPos2) Then 
					selPos = pai

'					strLog = strPrintf("^^^^^^^^^^^^^rNum2 = {0} , cntPos2 = {1}, selPos = {2}, pai = {3}<br>", _
'					Array(rNum2, cntPos2, selPos, pai))
'        			Response.Write strLog
					Exit For
				Else 
					If( rAryPos(0, pai) = 0 ) Then 
						cntPos2 = cntPos2 + 1 
					End If
				End If
			Next
		End If	

        '   -----------------------------------------------------------------------
        '    빈자리를 못찾았으면 아무 빈자리나 넣는다. 
        If (selPos = -1) Then 
            selPos = uxElGetPosByRandom(aryPos)
        End If 
        '   -----------------------------------------------------------------------          
		If (selPos <> -1 ) Then 
			rAryPos(0, selPos) = 1			
			rAryPos(2, selPos) = rAryUser(3,nSelUser)   ' cUser
         rAryPos(3, selPos) = rAryUser(2,nSelUser)   ' user
			rAryPos(4, selPos) = rAryUser(4,nSelUser)   ' cTeam 
         rAryPos(5, selPos) = rAryUser(5,nSelUser)   ' team
			rAryPos(6, selPos) = rAryUser(6,nSelUser)   ' cSigun
         rAryPos(7, selPos) = rAryUser(7,nSelUser)   ' sigun 

'			strLog = strPrintf("--------------------strBlock = {0} , rNum = {1}, sPos = {2}, ePos = {3}, rNum2 = {4}, cntPos = {5}  <br>", _
'					 Array(strBlock, rNum, sPos, ePos, rNum2, cntPos))					 
'        	Response.Write strLog
		Else 
'			strLog = "****************** duplicate ..  <br>"					 
'        	Response.Write strLog
		End If

	End Function

'   ===============================================================================
'     Team 중복 체크 ( block 단위 )  - block 갯수만큼 루프가 동작
'       fCkTeam = 0 : sigun check / 1 : team check 
'   ===============================================================================
	Function uxElCheckTeamInArrayPos(byRef rAryPos, byRef rAryUser, sel1, sBlock, fCkTeam)
		Dim strFind, sPos, ePos, nMax, ubp, apIdx, nPossible

		ubp = UBound(rAryPos, 2) 
		nMax = (ubp+1) / sBlock       ' block 갯수만큼 루프를 돈다. 
		
		strFind = ""
		sPos = 0

		For apIdx = 0 To nMax-1
			nPossible = uxElIsPossibleInsertPos(rAryPos, rAryUser, sel1, sPos, sBlock, fCkTeam)

			If(nPossible = 1) Then 
				If (strFind = "" ) Then 
					strFind = strPrintf("{0}", Array(apIdx))
				Else 
					strFind = strPrintf("{0},{1}", Array(strFind, apIdx))
				End If
			End If

			sPos = sPos + sBlock          ' block 갯수만큼 루프가 동작하므로 , 다음 start position = sPos + sBlock 이다.
		Next	

		uxElCheckTeamInArrayPos = strFind		
	End Function

'   ===============================================================================
'     Team 중복 체크 ( block 단위 )
'     Block 이 꽉 차 있어도 안된다. 
'       UserInfo : fUse, seed, gGroupIdx, user, memIdx, cTeam, team
'       Pos 단식 : fUse, pos, playerCode(memIdx), user, cTeam, team , cSido, sido
'       fCkTeam = 0 : sigun check / 1 : team check 
'   ===============================================================================
	Function uxElIsPossibleInsertPos(byRef rAryPos, rAryUser, sel1, sPos, sBlock, fCkTeam)
		Dim ckIdx, nPossible , ePos, cntUsed
        Dim cTeam1, cTeam2, cSigun1, cSigun2

		nPossible = 1
		cntUsed = 0
		ePos = (sPos + sBlock) - 1

        If( fCkTeam = 1 ) Then               ' 팀을 체크한다. 
            cTeam1 = rAryUser(4, sel1)            

            For ckIdx = sPos To ePos
               If( rAryPos(0, ckIdx) = 1 ) Then  
                  If( rAryPos(4, ckIdx) = cTeam1 ) Then 
                     nPossible = 0		 						' 같은 팀이 있다.  
                     Exit For 
                  End If

                  cntUsed = cntUsed + 1
               End If
            Next
        Else                                 ' 시군을 체크한다. 
            cSigun1 = rAryUser(6, sel1)

            For ckIdx = sPos To ePos
               If( rAryPos(0, ckIdx) = 1 ) Then 
                  If( rAryPos(6, ckIdx) = cSigun1) Then 
                     nPossible = 0								' 같은 시군이 있다.  
                     Exit For 
                  End If

                  cntUsed = cntUsed + 1
               End If
            Next
        End If

      ' 다 사용중 ( 할당할수 없다.) - 해당 Block내에 빈 공간이 없다. 
		If( cntUsed = sBlock ) Then nPossible = 0 End If			


'		strLog = strPrintf("cntUsed = {0} , nPossible = {1} <br>", Array(cntUsed, nPossible))
'        Response.Write strLog

		uxElIsPossibleInsertPos = nPossible		
	End Function
%>
