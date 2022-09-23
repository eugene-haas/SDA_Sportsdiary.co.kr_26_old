<% 
'   ===============================================================================     
'    Purpose : badminton 추첨에 들어가는 Util 함수 
'    Make    : 2019.03.15
'    Author  :                                                       By Aramdry
'   ===============================================================================    
%> 

<!-- #include virtual = "/pub/fn/badmt/res/res.pos.asp" -->  

<% 
   ' 팀인원 Define 
   Dim TEAM_CNTAVROVER , TEAM_CNTNORMAL, TEAM_CNTHALFOVER, TEAM_CNTNONE

   TEAM_CNTAVROVER      = 11           ' 팀인원이 평균보다 많다. 
   TEAM_CNTNORMAL       = 10           ' 팀인원이 평균 이하이다. 
   TEAM_CNTHALFOVER     = 9            ' 팀인원이 절반 보다 많다. 
   TEAM_CNTNONE         = -1           ' 팀인원이 없다. 
%>

<% 	  
  
'   ===============================================================================     
'      참여인원을 입력받아 Tonament Round를 계산한다. 
'   =============================================================================== 
	Function uxGetTournamentRound(cntUser)
		Dim base, tRound,cnt, fLoop, nMax 
        cnt = Cdbl(cntUser)
        
        tRound = 1
        base = 2
        fLoop = 1        

        ' error check : 참여 인원이 2명 이하거나 256 보다 크면 토너먼트가 성립하지 않는다. 
        If (cnt < 2 Or cnt > 256) Then 
            uxGetTournamentRound = tRound
            Exit Function
        End If

        Do While fLoop = 1
			If( base >= cnt ) Then 
                fLoop = 0
            Else 
                base = base * 2
            End If
        Loop

        tRound = base
        uxGetTournamentRound = tRound		
	End Function

'   ===============================================================================     
'      참여인원, 토너먼트 Round를 입력받아 Empty Seed를 계산한다. 
'   =============================================================================== 
	Function uxGetEmptySeed(cntUser, tmRound)
		Dim emptySeed, cnt

        cnt = Cdbl(cntUser)

		emptySeed = tmRound - cntUser
        uxGetEmptySeed = emptySeed		
	End Function

'   ===============================================================================     
'      토너먼트 Round를 입력받아 Search Block 단위를 계산한다. 
'   =============================================================================== 
	Function uxGetCntSearchBlock(tmRound)
		Dim searchBlock

		Select Case tmRound 
			Case 2,4,8
				searchBlock = 4
         Case 16,32	
				searchBlock = 8
			Case 64
				searchBlock = 16
			Case 128
				searchBlock = 16
			Case 256
				searchBlock = 32
		End Select

		uxGetCntSearchBlock = searchBlock
	End Function

'   ===============================================================================     
'      고정된 토너먼트 pos을 Random으로 가져온다. (Position Game  - 리그에서 토너먼트로 )
'     복식 : fUse, pos, playerCode(단체코드), cUser1, user1, cUser2, user2, cTeam1, team1, cTeam2, team2, cSido1, sido1, cSido2, sido2
'     단식 : fUse, pos, playerCode(memIdx), user, cTeam, team , cSido, sido
'   ===============================================================================
	Function uxGetAryPosFix(tmRound, bDoubleGame)
		Dim aryPos, aryPosData 
		Dim strId, strTeam, pos, Idx, nDim1		

        ' column수 : 복식일 경우 15, 단식일 경우 8
        nDim1 = 8
        If( bDoubleGame = 1 ) Then nDim1 = 15  

        ReDim aryPos(nDim1, tmRound-1)
        aryPosData = uxGetAryPosForRound(tmRound)

        For Idx = 0 to tmRound-1
            pos = aryPosData(Idx)			
            aryPos(0, Idx) = 0
            aryPos(1, Idx) = pos
            aryPos(2, Idx) = "0"
            aryPos(3, Idx) = "0"
        Next

		uxGetAryPosFix = aryPos
	End Function

'   ===============================================================================     
'      토너먼트 pos을 순차적으로 가져온다. (Random Position Game     - 처음부터 토너먼트 )
'   ===============================================================================
	Function uxGetAryPos(tmRound, bDoubleGame)
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

		uxGetAryPos = aryPos
	End Function

'   ===============================================================================     
'      Round를 입력 받아 토너먼트 pos배열을 선택한다. 
'   ===============================================================================
	Function uxGetAryPosForRound(tmRound)
		Dim ary

		Select Case tmRound
			Case 4
				ary = gAryRound4
			Case 8
				ary = gAryRound8
			Case 16
				ary = gAryRound16
			Case 32
				ary = gAryRound32
			Case 64
				ary = gAryRound64
			Case 128
				ary = gAryRound128
			Case 256
				ary = gAryRound256	
		End Select

		uxGetAryPosForRound = ary
	End Function 


'   ===============================================================================     
'      인원수로 ByePos을 얻는다. 
'   ===============================================================================
	Function uxGetAryByePos(userCnt)
		nCnt = userCnt - 1 
		If(nCnt < 1 Or nCnt > 255) Then nCnt = 0 End If
		uxGetAryByePos = gAryByePos(nCnt)
	End Function

'   ===============================================================================     
'      Bye(Empty Seed) Pos을 aryPos에 Setting 한다. 
'   ===============================================================================
	Function uxInitAryPosFix(byRef rAryPos, nEmpty)
		Dim pi, eBase, ub

		ub = UBound(rAryPos, 2)    
		eBase = ub - (nEmpty-1)
        
        For pi = 0 To ub
            If(rAryPos(1,pi) > eBase) Then 
                rAryPos(0,pi) = 1
                rAryPos(2,pi) = -1
            End If
        Next          
	End Function

'   ===============================================================================     
'      Bye(Empty Seed) Pos을 aryPos에 Setting 한다. 
'   ===============================================================================
	Function uxInitAryPos(byRef rAryPos,aryBye)
		Dim pi, eBase, emptyUser, emptyTeam, ub

		ub = UBound(rAryPos, 2)   

		For pi = 0 To ub
			If(FindByeData(aryBye, rAryPos(1,pi)) = 1) Then 
				rAryPos(0,pi) = 1
				rAryPos(2,pi) = -1
			End If
		Next
	End Function


'   ===============================================================================     
'      Bye(Empty Seed) array에서 nPos값을 입력받아 Bye Position 인지 유무를 판단한다. 
'      aryBye의 0 position에는 bye의 갯수가 저장되어 있다. 
'   ===============================================================================
	Function FindByeData(rAryBye, nPos)
		Dim uby, abi, nFind

		nFind = 0
		uby = UBound(rAryBye) 

		For abi = 1 To uby
			If(rAryBye(abi) = nPos) Then 
				nFind = 1
				Exit For
			End If
		Next
		FindByeData = nFind

	End Function

'   ===============================================================================     
'      Team을 Unique하게 구한다. 
'      복식일 경우도 단일팀으로 계산하여 구한다 .
'      fUse, firstSel, cntUser, cTeam , team, cSigun, sigun
'      사용유무, 팀코드, 팀이름, 시군코드, 시군이름, 팀원 숫자, 먼저 배치할지 유무 
'   ===============================================================================
    Function uxGetArrayTeam_Test(rAryUser)
		Dim ai, ul, aryTmp, aryTeam, cntTeam, cTeam, bDuplicate
		Dim nUser, nAve
		
		ub = UBound(rAryUser, 2) 
		ReDim aryTmp(7, ub+1)
		cntTeam = 0

		nUser = ub + 1					' count of User

        cTeam2 = rAryUser(3, 0)
        strLog = strPrintf("uxGetArrayTeam ub = {0}, cTeam2 = {1}<br>", Array(ub, cTeam2))
        'response.Write strLog

		' 실제 unique team 구하기 
		For ai = 0 To ub             
			cTeam = rAryUser(4, ai)
			bDuplicate = uxCheckDuplicateTeam(aryTmp, cTeam)
        
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

        strLog = strPrintf("uxGetArrayTeam cntTeam = {0}, cTeam2 = {1}<br>", Array(cntTeam, cTeam2))
        'response.Write strLog
  
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

		uxGetArrayTeam = aryTeam
	End Function  


   '   ===============================================================================     
'      Team을 Unique하게 구한다. 
'      복식일 경우도 단일팀으로 계산하여 구한다 .
'      fUse, firstSel, cntUser, cTeam , team, cSigun, sigun
'      사용유무, 팀코드, 팀이름, 시군코드, 시군이름, 팀원 숫자, 먼저 배치할지 유무 
'   ===============================================================================
    Function uxGetArrayTeam(rAryUser)
		Dim ai, ul, aryTmp, aryTeam, cntTeam, cTeam, bDuplicate
		Dim nUser, nAve, nHalf
		
		ub = UBound(rAryUser, 2) 
		ReDim aryTmp(7, ub+1)
		cntTeam = 0

		nUser = ub + 1					' count of User

        cTeam2 = rAryUser(3, 0)
        strLog = strPrintf("uxGetArrayTeam ub = {0}, cTeam2 = {1}<br>", Array(ub, cTeam2))
        'response.Write strLog

		' 실제 unique team 구하기 
		For ai = 0 To ub             
			cTeam = rAryUser(4, ai)
			bDuplicate = uxCheckDuplicateTeam(aryTmp, cTeam)
        
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

        strLog = strPrintf("uxGetArrayTeam cntTeam = {0}, cTeam2 = {1}<br>", Array(cntTeam, cTeam2))
        'response.Write strLog
  
		nAve = nUser / cntTeam                       ' 평균 팀 인원수 체크 
      nHalf = nUser / 2                            ' 인원수 절반 체크 

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

            If( aryTeam(2, ai) > nHalf ) Then      ' Half보다 인원수가 많으면 제일 마지막에 하자.. (2019.06.22 추가)
               aryTeam(1, ai) = TEAM_CNTHALFOVER              
				ElseIf( aryTeam(2, ai) > nAve ) Then 	' 평균 보다 팀원이 많으면 선순위로 선수를 등록한다. 
					aryTeam(1, ai) = TEAM_CNTAVROVER
				Else 								            ' 평균보다 팀원이 적으면 랜덤하게 선수를 등록한다. 
					aryTeam(1, ai) = TEAM_CNTNORMAL
				End If
			End If	
		Next

		uxGetArrayTeam = aryTeam
	End Function  

'   ===============================================================================     
'      aryTeam Data 중복 체크 , ary, data
'   ===============================================================================
	Function uxCheckDuplicateTeam(rAryTeam, cTeam) 
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

		uxCheckDuplicateTeam = bDuplicate
	End Function 

'   ===============================================================================     
'      aryTeam에서 Random하게 Team하나를 선택한다. 
'	    aryTeam에서 Team User Count가 팀 평균 Count보다 크면 (aryTeam(1,team) > average) 먼저 팀원을 배정한다. 
'	    aryTeam에서 Team User Count가 Half User 보다 크면 (aryTeam(1,team) > half)       제일 마지막 팀원을 배정한다. 
'      aryTeam에서 Team User Count가 팀 평균 Count보다 작으면 (aryTeam(1,team) < average) 랜덤하게 팀을 순환하면서  팀원을 배정한다. 
'      fUse, firstSel, cntUser, cTeam , team, cSigun, sigun
'   ===============================================================================
	Function uxGetSelTeam_Test(byRef rAryTeam)
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
			selTeam = uxGetSelTeamOverAve(rAryTeam)
		Else 
			selTeam = uxGetSelTeamLowAve(rAryTeam)
		End If

		uxGetSelTeam = selTeam
	End Function

'   ===============================================================================     
'      aryTeam에서 Random하게 Team하나를 선택한다. 
'	    aryTeam에서 Team User Count가 팀 평균 Count보다 크면 (aryTeam(1,team) > average) 먼저 팀원을 배정한다. 
'	    aryTeam에서 Team User Count가 Half User 보다 크면 (aryTeam(1,team) > half)       제일 마지막 팀원을 배정한다. 
'      aryTeam에서 Team User Count가 팀 평균 Count보다 작으면 (aryTeam(1,team) < average) 랜덤하게 팀을 순환하면서  팀원을 배정한다. 
'      fUse, firstSel, cntUser, cTeam , team, cSigun, sigun
'   ===============================================================================
	Function uxGetSelTeam(byRef rAryTeam)
		Dim selTeam, useSelOrder, ub1
		useSelOrder = TEAM_CNTNORMAL

		ub1 = UBound(rAryTeam, 2) 

        ' 삭제가 되지 않았고 , firstSel = TEAM_CNTAVROVER로 셋팅이 되어 있으면 먼저 할당한다. 
        ' 즉 Team User Count가 팀 평균 Count보다 크면 (aryTeam(1,team) > average) 먼저 팀원을 배정한다.
        ' 모든 사용자를 할당한 팀은 배열에서 삭제 해야 한다. 
        ' 물리적으로 삭제를 하지 않고 flag setting으로 삭제 유무 표시 : rAryTeam(0,Idx) = TEAM_CNTNONE
		For Idx = 0 To ub1
			If( rAryTeam(0,Idx) <> -1 ) And (rAryTeam(1, Idx) = TEAM_CNTAVROVER) Then 
				useSelOrder = TEAM_CNTAVROVER 
				Exit For
			End If
		Next

      ' 팀인원수에 평균 이상이 더이상 없다면 Normal을 체크한다. 
      IF( useSelOrder <> TEAM_CNTAVROVER) Then 
         For Idx = 0 To ub1
            If( rAryTeam(0,Idx) <> -1 ) And (rAryTeam(1, Idx) = TEAM_CNTNORMAL) Then 
               useSelOrder = TEAM_CNTNORMAL 
               Exit For
            End If
         Next
      End If

        strLog = strPrintf("uxGetSelTeam useSelOrder = {0}<br>", Array(useSelOrder))   
        response.Write strLog  
		
		If (useSelOrder = TEAM_CNTAVROVER) Then                  ' 팀 인원수가 평균 이상 , 절반 이하면 제일 먼저 할당
			selTeam = uxGetSelTeamOverAve(rAryTeam)
      ElseIf (useSelOrder = TEAM_CNTNORMAL) Then          
			selTeam = uxGetSelTeamLowAve(rAryTeam)
		Else           
         selTeam = uxGetSelTeamOverAve(rAryTeam)               ' 팀 인원수가 절반 이상이면 제일 마지막에 할당 
		End If

		uxGetSelTeam = selTeam
	End Function

'   ===============================================================================     
'      aryTeam에서 Random하게 Team하나를 선택한다. 
'	    aryTeam에서 Team User Count가 팀 평균 Count보다 크면 (aryTeam(1,team) > average) 먼저 팀원을 배정한다. 
'      aryTeam에서 Team User Count가 팀 평균 Count보다 작으면 (aryTeam(1,team) < average) 랜덤하게 팀을 순환하면서  팀원을 배정한다. 
'   ===============================================================================
	Function uxGetSelTeamOverAve(byRef rAryTeam)
		Dim cntTeam, selTeam, tIdx1, tub1, rNum, cnt, bFirstSel
      bFirstSel = 1        

		cntTeam = uxGetTeamCnt(rAryTeam, bFirstSel)
		
		If(cntTeam = 1) Then
			rNum = 0
		Else 
			rNum = GetRandomNum(cntTeam) - 1
		End If

	'   ===============================================================================   
	'	selTeam을 구한다. ( (rAryTeam(1, tIdx1) = 1) 것만 rNum과 cnt가 같을 때 까지 )
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

		uxGetSelTeamOverAve = selTeam
	End Function

'   ===============================================================================     
'      aryTeam에서 Random하게 Team하나를 선택한다. 
'	   aryTeam에서 Team User Count가 팀 평균 Count보다 크면 (aryTeam(1,team) > average) 먼저 팀원을 배정한다. 
'      aryTeam에서 Team User Count가 팀 평균 Count보다 작으면 (aryTeam(1,team) < average) 랜덤하게 팀을 순환하면서  팀원을 배정한다. 
'   ===============================================================================
	Function uxGetSelTeamLowAve(byRef rAryTeam)
		Dim cntTeam, selTeam, tIdx, tub, rNum, cnt, bFirstSel
      bFirstSel = 0        

		cntTeam = uxGetTeamCnt(rAryTeam, bFirstSel)
		If (cntTeam = 0 ) Then 
			Call uxResetFUseInAryTeam(rAryTeam) 
         cntTeam = uxGetTeamCnt(rAryTeam, bFirstSel)
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

		uxGetSelTeamLowAve = selTeam
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
	Function uxGetTeamCnt(byRef rAryTeam, bFirstSel)
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

		uxGetTeamCnt = cntTeam
	End Function

'   ===============================================================================     
'      aryTeam : Reset fUse
'      aryTeam(0,ti) = -1 삭제 flag
'   ===============================================================================
	Function uxResetFUseInAryTeam(byRef aryTeam)
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
	Function uxRemoveTeamFromAryTeam(ByRef rAryTeam, cTeam)
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
	Function uxGetSelUser(byRef rAryUser, cTeam)
		Dim selUser, uIdx, ub, nCntUser, rNum, nCnt

	'   ===============================================================================   
	'	selUser을 구한다. ( fUse = 1인 것을 제외하고 strTeam과 team이 같을때 까지 )
		ub = UBound(rAryUser, 2) 		
		nCntUser = uxGetCntTeamUser(rAryUser, cTeam)
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

		uxGetSelUser = selUser
	End Function

'   ===============================================================================     
'     team을 입력받아  rAryUser에서 해당 Team원 수를 Return 한다. 
'     이때 팀원은 사용하지 않은 팀원에 한정한다.  fUse = 1인 것을 제외
'   ===============================================================================
	Function uxGetCntTeamUser(byRef rAryUser, cTeam)
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

		uxGetCntTeamUser = nCntUser
	End Function

'   ===============================================================================     
'    Block position을 입력받아 해당 Block에 있는 User수를 Count한다. 
'    strBlock = 0,1,2,3,4,5,6,7  넘어오는 값이 이런식이므로 
'    start position을 구할때 * sBase을 해야 실제 Block start position을 구할수 있다. 
'   ===============================================================================   
   Function GetUserCntInBlock(blockPos, sBlock, rAryPos)
      Dim sPos, ePos, cntUser, pai 

      cntUser = 0
      sPos = blockPos * sBlock   
		ePos = sPos + sBlock -1
      For pai = sPos To ePos		' insert position을 random하게 구한다. 
         If( rAryPos(0, pai) = 1 ) Then 
            cntUser = cntUser + 1
         End If
      Next

      GetUserCntInBlock = cntUser
   End Function 

' ************************************************************************************************
' ************************************************************************************************
' 복식 

'   ===============================================================================     
'     UserInfo를 입력받아 rAryPos에 배치한다. 
'     Team 중복 체크 ( block 단위 )
'     AryPos Info 
'       복식 : fUse, pos, playerCode(단체코드), cUser1, user1, cUser2, user2, cTeam1, team1, cTeam2, team2, cSido1, sido1, cSido2, sido2
'       단식 : fUse, pos, playerCode(memIdx), user, cTeam, team , cSido, sido
'     AryUser Info 
'           fUse, gGroupIdx, user, memIdx, cTeam, team, cSido, sido, ...  
'   ===============================================================================
	Function uxSetGamePosDbl(byRef rAryPos, byRef rAryUser, nSelUser, sBlock)
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
			strBlock = uxCheckTeamInArrayPosDbl(rAryPos, rAryUser, nSelUser, nSelUser2, sBase, fCkTeam)

			If( strBlock <> "" ) Or ( fCkTeam = 1 And sBase = 1 )Then 
				fLoop = 0
         ElseIf ( fCkTeam = 0 And sBase = 1 ) Then 
            sBase = sBlock 
            fCkTeam = 1
			Else 
				sBase = sBase / 2
			End If			
		Loop

		If( strBlock <> "" ) Then 	' 찾았다.    인원수가 제일 적은 block순으로 배치한다. 
			aryBlock = split(strBlock, ",")
			ub = UBound(aryBlock) 

         Dim posBlock , minUserCnt , blockUserCnt
         posBlock = aryBlock(0)
         minUserCnt = 100
         blockUserCnt = 0

         For pai = 0 To ub 
            blockUserCnt = GetUserCntInBlock(aryBlock(pai), sBase, rAryPos)
            if(minUserCnt > blockUserCnt) Then 
               minUserCnt = blockUserCnt
               posBlock = aryBlock(pai)
            End If 
         Next 

			' ex) strBlock = 0,1,2,3,4,5,6,7  넘어오는 값이 이런식이므로 
         '     start position을 구할때 * sBase을 해야 실제 Block start position을 구할수 있다. 
			sPos = posBlock * sBase   
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
         selPos = uxGetPosByRandom(aryPos)
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
'     UserInfo를 입력받아 rAryPos에 배치한다. 
'     Team 중복 체크 ( block 단위 )
'     AryPos Info 
'       복식 : fUse, pos, playerCode(단체코드), cUser1, user1, cUser2, user2, cTeam1, team1, cTeam2, team2, cSido1, sido1, cSido2, sido2
'       단식 : fUse, pos, playerCode(memIdx), user, cTeam, team , cSido, sido
'     AryUser Info 
'           fUse, gGroupIdx, user, memIdx, cTeam, team, cSido, sido, ...  
'   ===============================================================================
	Function uxSetGamePosDbl_Test(byRef rAryPos, byRef rAryUser, nSelUser, sBlock)
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
			strBlock = uxCheckTeamInArrayPosDbl(rAryPos, rAryUser, nSelUser, nSelUser2, sBase, fCkTeam)

			If( strBlock <> "" ) Or ( fCkTeam = 1 And sBase = 1 )Then 
				fLoop = 0
         ElseIf ( fCkTeam = 0 And sBase = 1 ) Then 
            sBase = sBlock 
            fCkTeam = 1
			Else 
				sBase = sBase / 2
			End If			
		Loop

		If( strBlock <> "" ) Then 	' 찾았다.    인원수가 제일 적은 block순으로 배치한다. 
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
         selPos = uxGetPosByRandom(aryPos)
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
	Function uxCheckTeamInArrayPosDbl(byRef rAryPos, byRef rAryUser, sel1, sel2, sBlock, fCkTeam)
		Dim strFind, sPos, ePos, nMax, ubp, apIdx, nPossible

		ubp = UBound(rAryPos, 2) 
		nMax = (ubp+1) / sBlock             ' block 갯수만큼 루프를 돈다. 
		
		strFind = ""
		sPos = 0

		For apIdx = 0 To nMax-1
			nPossible = uxIsPossibleInsertPosDbl(rAryPos, rAryUser, sel1, sel2, sPos, sBlock, fCkTeam)

			If(nPossible = 1) Then 
				If (strFind = "" ) Then 
					strFind = strPrintf("{0}", Array(apIdx))
				Else 
					strFind = strPrintf("{0},{1}", Array(strFind, apIdx))
				End If
			End If

			sPos = sPos + sBlock             ' block 갯수만큼 루프가 동작하므로 , 다음 start position = sPos + sBlock 이다. 
		Next	

		uxCheckTeamInArrayPosDbl = strFind		
	End Function

'   ===============================================================================
'     Team 중복 체크 ( block 단위 )
'     Block 이 꽉 차 있어도 안된다. 
'       UserInfo : fUse, gGroupIdx, user, memIdx, cTeam, team, cSido, sido, ...  
'       Pos 복식 : fUse, pos, playerCode(단체코드), cUser1, user1, cUser2, user2, cTeam1, team1, cTeam2, team2, cSido1, sido1, cSido2, sido2
'       fCkTeam = 0 : sigun check / 1 : team check 
'   ===============================================================================
	Function uxIsPossibleInsertPosDbl(byRef rAryPos, rAryUser, sel1, sel2, sPos, sBlock, fCkTeam)
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

		uxIsPossibleInsertPosDbl = nPossible		
	End Function

'   ===============================================================================
'     Get Random Position : 빈자리중 랜덤하게 한자리를 찾는다. 
'   ===============================================================================
	Function uxGetPosByRandom(byRef rAryPos)
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
		uxGetPosByRandom = nSelPos		
	End Function



' ************************************************************************************************
' ************************************************************************************************
' 단식 

'   ===============================================================================     
'     UserInfo를 입력받아 rAryPos에 배치한다. 
'     Team 중복 체크 ( block 단위 )
'     AryPos Info 
'       복식 : fUse, pos, playerCode(단체코드), cUser1, user1, cUser2, user2, cTeam1, team1, cTeam2, team2, cSido1, sido1, cSido2, sido2
'       단식 : fUse, pos, playerCode(memIdx), user, cTeam, team , cSido, sido
'     AryUser Info 
'           fUse, gGroupIdx, user, memIdx, cTeam, team, cSido, sido, ...  
'   ===============================================================================
	Function uxSetGamePos(byRef rAryPos, byRef rAryUser, nSelUser, sBlock)
		Dim selPos, uIdx, ub, sBase, fLoop, aryBlock, rNum, cntPos
      Dim nSelUser2, fCkTeam

		sBase = sBlock 
		fLoop = 1
      fCkTeam = 0

      ' sigun을 먼저 체크하고 sigun에서 sBlock이 1이 되어도 넣을 곳이 없다면
      ' team을 체크한다. team에서도 넣을 곳이 없다면 빈곳에 아무 곳이나 insert한다. 
		Do While fLoop
			strBlock = uxCheckTeamInArrayPos(rAryPos, rAryUser, nSelUser, sBase, fCkTeam)

			If( strBlock <> "" ) Or ( fCkTeam = 1 And sBase = 1 )Then 
				fLoop = 0
         ElseIf ( fCkTeam = 0 And sBase = 1 ) Then 
            sBase = sBlock 
            fCkTeam = 1
			Else 
				sBase = sBase / 2
			End If			
		Loop

		If( strBlock <> "" ) Then 	' 찾았다.    인원수가 제일 적은 block순으로 배치한다. 
			aryBlock = split(strBlock, ",")
			ub = UBound(aryBlock) 

         Dim posBlock , minUserCnt , blockUserCnt
         posBlock = aryBlock(0)
         minUserCnt = 100
         blockUserCnt = 0

         For pai = 0 To ub 
            blockUserCnt = GetUserCntInBlock(aryBlock(pai), sBase, rAryPos)
            if(minUserCnt > blockUserCnt) Then 
               minUserCnt = blockUserCnt
               posBlock = aryBlock(pai)
            End If 
         Next 

         ' ex) strBlock = 0,1,2,3,4,5,6,7  넘어오는 값이 이런식이므로 
         '     start position을 구할때 * sBase을 해야 실제 Block start position을 구할수 있다. 
			sPos = posBlock * sBase
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
            selPos = uxGetPosByRandom(aryPos)
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
'     UserInfo를 입력받아 rAryPos에 배치한다. 
'     Team 중복 체크 ( block 단위 )
'     AryPos Info 
'       복식 : fUse, pos, playerCode(단체코드), cUser1, user1, cUser2, user2, cTeam1, team1, cTeam2, team2, cSido1, sido1, cSido2, sido2
'       단식 : fUse, pos, playerCode(memIdx), user, cTeam, team , cSido, sido
'     AryUser Info 
'           fUse, gGroupIdx, user, memIdx, cTeam, team, cSido, sido, ...  
'   ===============================================================================
	Function uxSetGamePos_Test(byRef rAryPos, byRef rAryUser, nSelUser, sBlock)
		Dim selPos, uIdx, ub, sBase, fLoop, aryBlock, rNum, cntPos
      Dim nSelUser2, fCkTeam

		sBase = sBlock 
		fLoop = 1
      fCkTeam = 0

      ' sigun을 먼저 체크하고 sigun에서 sBlock이 1이 되어도 넣을 곳이 없다면
      ' team을 체크한다. team에서도 넣을 곳이 없다면 빈곳에 아무 곳이나 insert한다. 
		Do While fLoop
			strBlock = uxCheckTeamInArrayPos(rAryPos, rAryUser, nSelUser, sBase, fCkTeam)

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
            selPos = uxGetPosByRandom(aryPos)
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
	Function uxCheckTeamInArrayPos(byRef rAryPos, byRef rAryUser, sel1, sBlock, fCkTeam)
		Dim strFind, sPos, ePos, nMax, ubp, apIdx, nPossible

		ubp = UBound(rAryPos, 2) 
		nMax = (ubp+1) / sBlock       ' block 갯수만큼 루프를 돈다. 
		
		strFind = ""
		sPos = 0

		For apIdx = 0 To nMax-1
			nPossible = uxIsPossibleInsertPos(rAryPos, rAryUser, sel1, sPos, sBlock, fCkTeam)

			If(nPossible = 1) Then 
				If (strFind = "" ) Then 
					strFind = strPrintf("{0}", Array(apIdx))
				Else 
					strFind = strPrintf("{0},{1}", Array(strFind, apIdx))
				End If
			End If

			sPos = sPos + sBlock          ' block 갯수만큼 루프가 동작하므로 , 다음 start position = sPos + sBlock 이다.
		Next	

		uxCheckTeamInArrayPos = strFind		
	End Function

'   ===============================================================================
'     Team 중복 체크 ( block 단위 )
'     Block 이 꽉 차 있어도 안된다. 
'       UserInfo : fUse, gGroupIdx, user, memIdx, cTeam, team, cSido, sido, ...  
'       Pos 단식 : fUse, pos, playerCode(memIdx), user, cTeam, team , cSido, sido
'       fCkTeam = 0 : sigun check / 1 : team check 
'   ===============================================================================
	Function uxIsPossibleInsertPos(byRef rAryPos, rAryUser, sel1, sPos, sBlock, fCkTeam)
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

		uxIsPossibleInsertPos = nPossible		
	End Function
%>

<%
'   *******************************************************************************
'     조별 추첨을 위해 추가하는 함수 
'   *******************************************************************************    
'   ===============================================================================     
'      Region을 Unique하게 구한다. 
'      fUse, cntUser, cSigun, sigun
'      사용유무, 팀원 숫자, 시군코드, 시군이름
'   ===============================================================================
    Function uxGetArrayRegion(rAryUser)
		Dim ai, ul, aryTmp, aryRegion, cntRegion, csido, bDuplicate
		Dim nUser, nAve
		
		ub = UBound(rAryUser, 2) 
		ReDim aryTmp(7, ub+1)
		cntRegion = 0

		nUser = ub + 1					' count of User
        
		' 실제 unique Region 구하기 
		For ai = 0 To ub             
			csido = rAryUser(6, ai)
			bDuplicate = uxCheckDuplicateRegion(aryTmp, csido)
            
			If (bDuplicate = "0") Then 
				aryTmp(0, cntRegion) = 1                
                aryTmp(1, cntRegion) = 1			    ' region count를 1로 초기화 ( 중복 일때만 카운트를 추가 하기 때문에 1로 셋팅해도 된다. )
				aryTmp(2, cntRegion) = rAryUser(6, ai)
                aryTmp(3, cntRegion) = rAryUser(7, ai)

				cntRegion = cntRegion + 1
			End If	
		Next	

        strLog = strPrintf("uxGetArrayRegion cntRegion = {0}<br>", Array(cntRegion))
        'response.Write strLog
  
		ReDim aryRegion(7, cntRegion-1)

		ub = UBound(aryRegion, 2) 
		For ai = 0 To ub 
			If (aryTmp(0, ai) = "1") Then 
				aryRegion(0, ai) = 0
                aryRegion(1, ai) = aryTmp(1, ai)
				aryRegion(2, ai) = aryTmp(2, ai)
				aryRegion(3, ai) = aryTmp(3, ai)
			End If	
		Next

		uxGetArrayRegion = aryRegion
	End Function  

'   ===============================================================================     
'      aryRegion Data 중복 체크 , ary, data
'      fUse, cntUser, cSigun, sigun
'   ===============================================================================
	Function uxCheckDuplicateRegion(rAry, cRegion)
		Dim dai, ub, bDuplicate

		bDuplicate = 0		
        ub = UBound(rAry, 2)   

		For dai=0 To ub	    
            If( CStr(rAry(2,dai)) = CStr(cRegion) ) Then 
				rAry(1,dai) = rAry(1,dai) + 1
				bDuplicate = 1
				Exit For
			End If

            ' data가 없으면 For문을 빠져 나간다 .
            If ( rAry(0, dai) <> 1 ) Then       
                Exit For
            End If
		Next

		uxCheckDuplicateRegion = bDuplicate
	End Function 

'   ===============================================================================     
'      aryRegion Data 중복 체크 , ary, data
'      fUse, cntUser, cSigun, sigun
'   ===============================================================================
	Function uxCheckDuplicateRegion(rAry, cRegion)
		Dim dai, ub, bDuplicate

		bDuplicate = 0		
        ub = UBound(rAry, 2)   

		For dai=0 To ub	    
            If( CStr(rAry(2,dai)) = CStr(cRegion) ) Then 
				rAry(1,dai) = rAry(1,dai) + 1
				bDuplicate = 1
				Exit For
			End If

            ' data가 없으면 For문을 빠져 나간다 .
            If ( rAry(0, dai) <> 1 ) Then       
                Exit For
            End If
		Next

		uxCheckDuplicateRegion = bDuplicate
	End Function 

'   ===============================================================================     
'      Used aryRegion Data         - 사용했다. set fUse = 1
'      fUse, cntUser, cSigun, sigun
'   ===============================================================================
	Function uxUsedRegion(rAry, code)
		Dim aIdx, rub
        
		rub = UBound(rAry, 2)   

		For aIdx=0 To rub	    
            If( rAry(2,aIdx) = code  ) Then 
				rAry(0,aIdx) = 1
				Exit For
			End If
		Next
	End Function 

'   ===============================================================================     
'      Select aryRegion Data      
'      Region은 사람순으로 Sort되어 있는 데이터다. 미리 sort - Sort2DimAryByKey() 
'      순차적으로 검색하여 fUse=0이면 인원수가 제일 많은 지역이다. 
'      fUse, cntUser, cSigun, sigun
'   ===============================================================================
	Function uxGetRegionCode(rAry)
		Dim aIdx, rub, ret
        ret = "0"

		rub = UBound(rAry, 2)   

		For aIdx=0 To rub	    
            If( rAry(0,aIdx) = 0 ) Then 
				ret = rAry(2,aIdx)
				Exit For
			End If
		Next

		uxGetRegionCode = ret
	End Function 

'   ===============================================================================     
'      Delete aryRegion Data         - 사용했다. set fUse = 1
'      fUse, firstSel, cntUser, cTeam , team, cSigun, sigun
'   ===============================================================================
	Function uxUsedTeam(rAry, code)
		Dim aIdx, rub
        
		rub = UBound(rAry, 2)   

		For aIdx=0 To rub	    
            If( rAry(3,aIdx) = code  ) Then 
				rAry(0,aIdx) = 1
				Exit For
			End If
		Next
	End Function 

'   ===============================================================================     
'      Select aryTeam Data         - 
'      Team은 사람순으로 Sort되어 있는 데이터다.  미리 sort - Sort2DimAryByKey() 
'      순차 비교시 rCode와 일치하고 fUse = 0이면 인원수가 제일 많은 팀이 선택 된다. 
'      fUse, firstSel, cntUser, cTeam , team, cSigun, sigun
'   ===============================================================================
    Function uxGetTeamCode(rAry, rCode)
		Dim aIdx, rub, tCode
        tCode = "0"
		rub = UBound(rAry, 2)   

        strLog = strPrintf("---------------------------uxGetTeamCode rCode = {0}<br>" , Array(rCode))
   '     response.Write strLog

        If(rCode = "15012" Or rCode = 15012) Then 
            strLog = strPrintf("-In --------------------------uxGetTeamCode rCode = {0}<br>" , Array(rCode))
    '        response.Write strLog

            For aIdx=0 To rub	    
                If( rAry(0,aIdx) = 0 And rAry(5,aIdx) = rCode ) Then 
                    tCode = rAry(3,aIdx)
                    Exit For
                End If

                strLog = strPrintf("fUse = {0}, rCode = {1}, tCode = {2}<br>" , Array(rAry(0,aIdx), rAry(5,aIdx), rAry(3,aIdx)))
    '            response.Write strLog
            Next
        End If

		For aIdx=0 To rub	    
            If( rAry(0,aIdx) = 0 And rAry(5,aIdx) = rCode ) Then 
                tCode = rAry(3,aIdx)
                Exit For
			End If
		Next

		uxGetTeamCode = tCode
	End Function

'   ===============================================================================     
'      organize group by user
'      team code와 같은 사용자를 찾아 해당 group에 할당한다. 
'       nGroup, gGroupIdx, user, memIdx, cTeam, team, cSido, sido
'   ===============================================================================
	Function uxDistributeUserToGroup(rAry, tCode, nCur, IsDoubleGame)
		Dim aIdx, uub, retVal        
		uub = UBound(rAry, 2)   
        retVal = 0        

		For aIdx=0 To uub	    
            If( rAry(0,aIdx) = 0 And rAry(4,aIdx) = tCode ) Then 
                rAry(0,aIdx) = nCur
                If(IsDoubleGame = 1) Then       ' 복식일 경우 2명이 1개팀 
                    If(aIdx Mod 2 ) = 1 Then 
                        rAry(0,aIdx-1) = nCur 
                    Else 
                        rAry(0,aIdx+1) = nCur 
                    End If
                End If  
                retVal = 1
                Exit For
			End If
		Next

        uxDistributeUserToGroup = retVal
	End Function 

'   ===============================================================================     
'      Group Number를 구한다. 
'      Group의 총 갯수를 넘지 않고 순환해야 하므로 Mod 를 사용 ( 0 ~ nMax-1 )
'   ===============================================================================
	Function uxGetNextGroup(nCur, nMax)
        nCur = (nCur Mod nMax) + 1
        uxGetNextGroup = nCur
	End Function 

'   ===============================================================================     
'      Replace sido "" val To "999", sidoName "" To "Empty"
'   ===============================================================================
	Function uxReplaceSidoNull(rAryUser)
        Dim rai, rul
		
		rul = UBound(rAryUser, 2) 

        For rai = 0 To rul
            If( rAryUser(6,rai) = "" ) Then rAryUser(6,rai) = "999" End If
            If( rAryUser(7,rai) = "" ) Then rAryUser(7,rai) = "Empty" End If
        Next
        
	End Function 

%>
