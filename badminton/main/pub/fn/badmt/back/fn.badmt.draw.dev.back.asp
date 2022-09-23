<% 
'   ===============================================================================     
'    Purpose : badminton 추첨에 들어가는 Util 함수 
'    Make    : 2019.07.01
'    Author  :                                                       By Aramdry
'   ===============================================================================    
%> 

<% 
'   ===============================================================================     
'        1. aryUser를 DB로 부터 구한다. 
'        2. aryUser를 이용하여 aryPos을 구한다. 
'        3. aryPos에 Bye를 셋팅한다. 
'        4. aryUser를 A, B part 2개로 나눈다. 이때 각 part의 cntBye를 저장한다. 
'        5. aryUserA, aryUserB에 할당할 인원을 나눈다. 
'           - cntUserA = (cntUser / 2) - cntByeA / cntUserB = (cntUser / 2) - cntByeB
'        6. aryUserA, aryUserB에 인원을 배분한다. 
'           - 6-1) Region인원수를 체크한다. 
'           - 6-2) Region인원수가 작은곳 부터 배분을 한다. 
'           - 6-3) Team 인원수가 작은 곳부터 배분을 한다. 
'           - 6-4) aryUserA, aryUserB순으로 번갈아 가면서 배분을 한다. 
'        7. aryUserA를 이용하여 aryPosA에 인원을 할당한다. 
'        8. aryUserB를 이용하여 aryPosB에 인원을 할당한다. 
'        9. 인원 할당이 모두 끝나면 aryPosA, aryPosB를 merge한다. 
'        10. 할당된 인원을 서버에 올린다. 
'
'     position은 2가지 : 고정된 배열로 존재 / 배열 Index순서대로 
'     bye자리 : 고정된 배열에서는 position의 맨 뒤부터 bye 갯수만큼 존재하고 
'               배열 Index순서대로 정해질 경우 Bye자리는 고정된 배열로 존재한다. 
'
'     column의 갯수는 단식일 경우 8, 복식일 경우 15이다. 
'     복식 : fUse, pos, playerCode(단체코드), cUser1, user1, cUser2, user2, cTeam1, team1, cTeam2, team2, cSido1, sido1, cSido2, sido2
'     단식 : fUse, pos, playerCode(memIdx), user, cTeam, team , cSido, sido
'   ===============================================================================    
%> 

<!-- #include virtual = "/pub/fn/fn.utiletc.asp" --> 

<% 	    
'   *******************************************************************************
'     const define and variable
'   ******************************************************************************* 
   Dim TCNT_NONE, TCNT_AVROVER, TCNT_HALFOVER, TCNT_NORMAL              ' Team Count 상수 
   Dim CON_APART, CON_BPART, CON_BYEFLAG

   TCNT_NONE         = -1           ' 팀인원이 없다. 
   TCNT_AVROVER      = 11           ' 팀인원이 평균보다 많다. 
   TCNT_NORMAL       = 10           ' 팀인원이 평균 이하이다. 
   TCNT_HALFOVER     = 9            ' 팀인원이 절반 보다 많다. 

   CON_APART         = 0            ' A Part
   CON_BPART         = 1            ' B Part
   CON_BYEFLAG       = "-1"
   

%>

<% 	    
'   *******************************************************************************
'     process function 
'   ******************************************************************************* 

'   ===============================================================================     
'      aryUser, IsDlbGame, IsFixedPos을 입력받는다. 
'      참가신청 사용자 배열 , 단식/복식 유무 , 토너먼트 pos유형 : 고정 / 순차 

'        1. aryUser를 이용하여 nRound(토너먼트 #강), nBye(bye 수), sBlock(search block)을 구한다. 
'        2. IsFixedPos 유무에 따라 aryPos을 구한후 aryPos에 bye값을 적용한다. 
'        3. aryPos을 반으로 나누어 A Part, B Part로 구분한다. 
'        4. A Part에 aryUserA, aryTeamA / B Part에 aryUserB, aryTeamB를 셋팅한다. 
'        5. bye가 적용된 aryPos으로부터 A Part , B Part에 각각 적용된 cntByeA, cntByeB를 구한다. 
'        6. A Part / B Part로 나누기 위해 aryUser로 부터 aryTeamInfo를 추출한다. 
'        7. aryTeamInfo로 부터 aryRegion을 추출한다. 
'        8. aryRegion을 cntRegion순으로 정렬하고 Order를 부여한다. 
'        9. aryRegion에 적용된 region Order를 aryTeamInfo에 적용한다. 
'        10. aryTeamInfo에 적용된 region Order로 정렬을 한다. 
'        11. aryTeamInfo에서 region Order가 2개 이상 동일하면 Block으로 잡는다. 
'        12. 설정된 Block안에서 cntTeam을 가지고 부분 sort를 한다. 
'        13. aryTeamInfo에 전체 Order를 부여한다. ( Region / Team cnt 반영)
'        14. aryTeamInfo를 기반으로 A Part, B Part에 User를 분배한다. 
'   ===============================================================================  
   Function duxAssignPosForTonament(rAryUser, IsDblGame, IsFixedPos)      
      Dim aryPos, aryUserA, aryUserB
      Dim strGroupIdxs
      strGroupIdxs = ""
      
      Call duxProcessDivPart(rAryUser, aryPos, aryUserA, aryUserB, IsDblGame, IsFixedPos)


      duxAssignPosForTonament = strGroupIdxs
   End Function 

   Function duxProcessDivPart(rAryUser, rAryPos, rAryUserA, rAryUserB, IsDblGame, IsFixedPos)
      Dim ub, Idx, nRound, nBye, sBlock, nUser       
      Dim aryTeamInfo, aryRegion, aryBye
      Dim cntByeA, cntByeB, nHalf, nCol, nRow 

'        1. aryUser를 이용하여 nRound(토너먼트 #강), nBye(bye 수), sBlock(search block)을 구한다. 
      printAryUserEx(rAryUser) 
      ub = UBound(rAryUser, 2)       

      nUser = ub + 1          ' count of user
      If(IsDblGame = 1) Then nUser = nUser / 2 End If 

      nRound = duxCalcRound(nUser)
      nBye = duxCalcEmpty(nUser, nRound)
      sBlock = duxCalcSearchBlock(nRound)
      nHalf  = nRound / 2

      nCol = UBound(rAryUser, 1) 
      nRow = nHalf

      strLog = strPrintf("IsDblGame = {0}, ub = {1}, nUser = {2}, nRound = {3}, nBye = {4}, sBlock = {5}, IsFixedPos = {6}<br>", _
                  Array(IsDblGame, ub, nUser, nRound, nBye, sBlock, IsFixedPos))

      response.write strLog

'        2. IsFixedPos 유무에 따라 rAryPos을 구한후 rAryPos에 bye값을 적용한다. 
      IsFixedPos = 0
      
      If(IsFixedPos = 1) Then 
         rAryPos = duxCreateAryFixPos(nRound, IsDblGame)
         Call duxSetByeToAryFixPos(rAryPos, nBye)
      Else          
         rAryPos = duxCreateAryPos(nRound, IsDblGame)
         Call duxSetByeToAryPos(rAryPos, nUser)
      End If 

'      Call printrAryPosEx(rAryPos, IsDblGame)

'        5. bye가 적용된 rAryPos으로부터 A Part , B Part에 각각 적용된 cntByeA, cntByeB를 구한다. 
      cntByeA = duxGetByeCntPerPart(rAryPos, CON_APART)
      cntByeB = duxGetByeCntPerPart(rAryPos, CON_BPART)


      strLog = strPrintf("nCol = {0}, nRow = {1}, cntByeA = {2}, IsDblGame = {3}<br>", _
                  Array(nCol, nRow, cntByeA, IsDblGame))
      response.write strLog

      rAryUserA = duxCreatePartAryUser(nCol, nRow, cntByeA, IsDblGame)
      rAryUserB = duxCreatePartAryUser(nCol, nRow, cntByeB, IsDblGame)

'      Call printInfoEx(rAryUserA, "rAryUserA")
'      Call printInfoEx(rAryUserB, "rAryUserB")


      strLog = strPrintf("nHalf = {0}, nBye = {1}, cntByeA = {2}, cntByeB = {3}<br>", Array(nHalf, nBye, cntByeA, cntByeB))
      response.write strLog

'        6. A Part / B Part로 나누기 위해 aryUser로 부터 aryTeamInfo를 추출한다. 
      aryTeamInfo = CreateTeamInfo(aryUser)
      Call printInfoEx(aryTeamInfo, "aryTeamInfo")

'        7. aryTeamInfo로 부터 aryRegion을 추출한다. 
      aryRegion = CreateRegionInfo(aryTeamInfo)
      Call printInfoEx(aryRegion, "aryRegion")

'        8. aryRegion을 cntRegion순으로 정렬하고 Order를 부여한다. 
'        9. aryRegion에 적용된 region Order를 aryTeamInfo에 적용한다. 
'        10. aryTeamInfo에 적용된 region Order로 정렬을 한다. 
'        11. aryTeamInfo에서 region Order가 2개 이상 동일하면 Block으로 잡는다. 
'        12. 설정된 Block안에서 cntTeam을 가지고 부분 sort를 한다. 
'        13. aryTeamInfo에 전체 Order를 부여한다. ( Region / Team cnt 반영)
      Call duxApplyRegionOrder(aryRegion, aryTeamInfo)
      Call duxApplyTeamOrder(aryTeamInfo)
      Call printInfoEx(aryTeamInfo, "duxApplyTeamOrder aryTeamInfo")

      Call duxDivPartAB(aryUser, aryTeamInfo, rAryUserA, rAryUserB, IsDblGame) 

      Call duxResetAryPart(rAryUserA)
      Call duxResetAryPart(rAryUserB)
      Call printInfoEx(rAryUserA, "Copy User rAryUserA")
      Call printInfoEx(rAryUserB, "Copy User rAryUserB")
   End Function 

   Function duxProcessAssignPos()

   End Function 



'      Function duxAssignPosForTonament(rAryUser, IsDblGame, IsFixedPos)
'         Dim ub, Idx, nRound, nBye, sBlock, nUser 
'         Dim aryPos, aryBye, aryUserA, aryUserB, aryTeamA, aryTeamB
'         Dim aryTeamInfo, aryRegion
'         Dim cntByeA, cntByeB, nHalf, nCol, nRow 
'         Dim strGroupIdxs
'         strGroupIdxs = ""
'
'         ' duxProcessDivPart(rAryUser, rAryPos, rAryUserA, rAaryUserB)
'         duxProcessDivPart(rAryUser, aryPos, aryUserA, aryUserB, IsDblGame, IsFixedPos)
'
'   '        1. aryUser를 이용하여 nRound(토너먼트 #강), nBye(bye 수), sBlock(search block)을 구한다. 
'         printAryUserEx(rAryUser) 
'         ub = UBound(rAryUser, 2)       
'
'         nUser = ub + 1          ' count of user
'         If(IsDblGame = 1) Then nUser = nUser / 2 End If 
'
'         nRound = duxCalcRound(nUser)
'         nBye = duxCalcEmpty(nUser, nRound)
'         sBlock = duxCalcSearchBlock(nRound)
'         nHalf  = nRound / 2
'
'         nCol = UBound(rAryUser, 1) 
'         nRow = nHalf
'
'         strLog = strPrintf("IsDblGame = {0}, ub = {1}, nUser = {2}, nRound = {3}, nBye = {4}, sBlock = {5}, IsFixedPos = {6}<br>", _
'                     Array(IsDblGame, ub, nUser, nRound, nBye, sBlock, IsFixedPos))
'
'         response.write strLog
'
'   '        2. IsFixedPos 유무에 따라 aryPos을 구한후 aryPos에 bye값을 적용한다. 
'         IsFixedPos = 0
'         
'         If(IsFixedPos = 1) Then 
'            aryPos = duxCreateAryFixPos(nRound, IsDblGame)
'            Call duxSetByeToAryFixPos(aryPos, nBye)
'         Else          
'            aryPos = duxCreateAryPos(nRound, IsDblGame)
'            Call duxSetByeToAryPos(aryPos, nUser)
'         End If 
'
'   '      Call printAryPosEx(aryPos, IsDblGame)
'
'   '        5. bye가 적용된 aryPos으로부터 A Part , B Part에 각각 적용된 cntByeA, cntByeB를 구한다. 
'         cntByeA = duxGetByeCntPerPart(aryPos, CON_APART)
'         cntByeB = duxGetByeCntPerPart(aryPos, CON_BPART)
'
'
'         strLog = strPrintf("nCol = {0}, nRow = {1}, cntByeA = {2}, IsDblGame = {3}<br>", _
'                     Array(nCol, nRow, cntByeA, IsDblGame))
'         response.write strLog
'
'         aryUserA = duxCreatePartAryUser(nCol, nRow, cntByeA, IsDblGame)
'         aryUserB = duxCreatePartAryUser(nCol, nRow, cntByeB, IsDblGame)
'
'         Call printInfoEx(aryUserA, "aryUserA")
'         Call printInfoEx(aryUserB, "aryUserB")
'
'
'         strLog = strPrintf("nHalf = {0}, nBye = {1}, cntByeA = {2}, cntByeB = {3}<br>", Array(nHalf, nBye, cntByeA, cntByeB))
'         response.write strLog
'
'   '        6. A Part / B Part로 나누기 위해 aryUser로 부터 aryTeamInfo를 추출한다. 
'         aryTeamInfo = CreateTeamInfo(aryUser)
'         Call printInfoEx(aryTeamInfo, "aryTeamInfo")
'
'   '        7. aryTeamInfo로 부터 aryRegion을 추출한다. 
'         aryRegion = CreateRegionInfo(aryTeamInfo)
'         Call printInfoEx(aryRegion, "aryRegion")
'
'   '        8. aryRegion을 cntRegion순으로 정렬하고 Order를 부여한다. 
'   '        9. aryRegion에 적용된 region Order를 aryTeamInfo에 적용한다. 
'   '        10. aryTeamInfo에 적용된 region Order로 정렬을 한다. 
'   '        11. aryTeamInfo에서 region Order가 2개 이상 동일하면 Block으로 잡는다. 
'   '        12. 설정된 Block안에서 cntTeam을 가지고 부분 sort를 한다. 
'   '        13. aryTeamInfo에 전체 Order를 부여한다. ( Region / Team cnt 반영)
'         Call duxApplyRegionOrder(aryRegion, aryTeamInfo)
'         Call duxApplyTeamOrder(aryTeamInfo)
'         Call printInfoEx(aryTeamInfo, "duxApplyTeamOrder aryTeamInfo")
'
'         Call duxDivPartAB(aryUser, aryTeamInfo, aryUserA, aryUserB, IsDblGame) 
'
'   '      Call duxResetAryPart(aryUserA)
'   '      Call duxResetAryPart(aryUserB)
'         Call printInfoEx(aryUserA, "Copy User aryUserA")
'         Call printInfoEx(aryUserB, "Copy User aryUserB")
'
'
'         duxAssignPosForTonament = strGroupIdxs
'   End Function 

%>

<% 	    
'   *******************************************************************************
'     public utility 
'   ******************************************************************************* 

'   ===============================================================================     
'      참여인원을 입력받아 Tonament Round를 계산한다. 
'      1. base = 2로 초기화 
'      2. base = base * 2로 값을 증가 , 만일 base >= cntUser 이면 Round를 찾았다. 
'   ===============================================================================    
   Function duxCalcRound(nUser)
      Dim base, tRound, nCnt 

      tRound = 1
      base = 2
      nUser = CDbl(nUser)    

      If Not (nUser < 2 Or nUser > 256) Then 
         Do While (base < nUser)
            base = base * 2
         Loop
         tRound = base
      End If 

      duxCalcRound = tRound
   End Function 

'   ===============================================================================     
'      참여인원, Round를 입력받아 cntBye를 계산한다. 
'      cntBye = nRound - nUser
'   ===============================================================================    
   Function duxCalcEmpty(nUser, nRound)
      duxCalcEmpty = nRound - nUser
   End Function 

'   ===============================================================================     
'      토너먼트 Round를 입력받아 Search Block 단위를 계산한다. 
'      tRound에 적절한 search Block을 반환한다. 
'   =============================================================================== 
   Function duxCalcSearchBlock(nRound)
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
				nBlock = 16
			Case 256
				nBlock = 32
		End Select

      duxCalcSearchBlock = nBlock
   End Function 


'   ===============================================================================     
'      Round를 입력 받아 토너먼트 pos배열을 선택한다. 
'   ===============================================================================
	Function duxGetAryFixPos(nRound)
		Dim ary

		Select Case nRound
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

		duxGetAryFixPos = ary
	End Function 

'   ===============================================================================     
'     인원수로 ByePos을 얻는다. 
'     Bye position이 인원수 별로 정해져 있다. 그 array를 얻는다.  
'   ===============================================================================
	Function duxGetAryFixBye(nUser)
      Dim nCnt 
		nCnt = nUser - 1 
		If(nCnt < 1 Or nCnt > 255) Then nCnt = 0 End If
		duxGetAryFixBye = gAryByePos(nCnt)
	End Function

'   ===============================================================================     
'      Bye(Empty Seed) array에서 nPos값을 입력받아 Bye Position 인지 유무를 판단한다. 
'      rAryBye(0) = cntBye
'   ===============================================================================
	Function duxIsByePos(rAryBye, nPos)
		Dim Idx, ub, is_bye

		is_bye = 0
		ub = UBound(rAryBye)  

		For Idx = 1 To ub
			If(rAryBye(Idx) = nPos) Then 
				is_bye = 1
				Exit For
			End If
		Next

		duxIsByePos = is_bye
	End Function

'   ===============================================================================     
'      aryPos에 Bye를 적용한후 , APart / BPart로 구분하여 cntBye를 각각 구할때 사용
'   ===============================================================================
	Function duxGetByeCntPerPart(rAryPos, nPart)
		Dim Idx, ub, nHalf, sp, ep, nBye

      nBye = 0
		ub = UBound(rAryPos, 2) 
      nHalf = (ub+1) / 2

      If( nPart = CON_APART ) Then           ' A Part 
         sp = 0
         ep = nHalf - 1
      ElseIf( nPart = CON_BPART ) Then       ' B Part 
         sp = nHalf
         ep = ub
      End If 

		For Idx = sp To ep
			If(rAryPos(2, Idx) = -1) Then 
				nBye = nBye + 1
			End If
		Next

		duxGetByeCntPerPart = nBye
	End Function
%>

<% 	    
'   *******************************************************************************
'     algorithm utility 
'   ******************************************************************************* 

'   ===============================================================================     
'     round를 입력받아 aryPos을 반환한다 . - Fixed position array
'     column의 갯수는 단식일 경우 8, 복식일 경우 15이다. 
'   ===============================================================================
   Function duxCreateAryFixPos(nRound, IsDblGame)
      Dim ary, aryFixPos, Idx, nColumn, nMax

      nColumn = 8
      If(IsDblGame = 1) Then nColumn = 15 End If 
      ReDim ary(nColumn, nRound-1)
      aryFixPos = duxGetAryFixPos(nRound)

      nMax = nRound-1
      For Idx = 0 to nMax
         ary(0, Idx) = 0                  ' init pos 
         ary(1, Idx) = aryFixPos(Idx)     ' 토너먼트 배치 position 
      Next

      duxCreateAryFixPos = ary
   End Function 

'   ===============================================================================     
'     round를 입력받아 aryPos을 반환한다 . - Indexed array
'     column의 갯수는 단식일 경우 8, 복식일 경우 15이다. 
'   ===============================================================================
   Function duxCreateAryPos(nRound, IsDblGame)
      Dim ary, Idx, nColumn, nMax

      nColumn = 8
      If(IsDblGame = 1) Then nColumn = 15 End If 
      ReDim ary(nColumn, nRound-1)

      nMax = nRound-1
      For Idx = 0 to nMax
         ary(0, Idx) = 0               ' init pos 
         ary(1, Idx) = Idx+1           ' 토너먼트 배치 position 
      Next

      duxCreateAryPos = ary
   End Function 

'   ===============================================================================     
'    Bye(Empty Seed) Pos을 aryPos에 Setting 한다.  
'    bye자리 : 고정된 배열에서는 position의 맨 뒤부터 bye 갯수만큼 존재. 
'   ===============================================================================   
   Function duxSetByeToAryFixPos(rAryPos, nBye)
      Dim Idx, ub, nByeMark

      ub = UBound(rAryPos, 2)
      nByeMark = ub - (nBye-1)

      strLog = strPrintf("duxSetByeToAryFixPos nBye = {0}, ub = {1}, nByeMark = {2}<br>", Array(nBye, ub, nByeMark))
      response.write strLog 

      For Idx = 0 To ub 
         If( rAryPos(1, Idx) > nByeMark ) Then  ' Bye 자리다 
            rAryPos(0, Idx) = 1            ' position을 할당했다. 
            rAryPos(2, Idx) = -1           ' bye의 playerCode = -1
         End If 
      Next 
   End Function 

'   ===============================================================================     
'    Bye(Empty Seed) Pos을 aryPos에 Setting 한다.  
'    bye자리 : 배열 Index순서대로 정해질 경우 Bye자리는 고정된 배열로 존재한다. 
'   ===============================================================================   
   Function duxSetByeToAryPos(rAryPos, nUser)
      Dim Idx, ub, aryBye

      aryBye = duxGetAryFixBye(nUser)
      ub = UBound(rAryPos, 2)

      For Idx = 0 To ub 
         If( duxIsByePos(aryBye, rAryPos(1, Idx)) ) Then  ' Bye 자리다 
            rAryPos(0, Idx) = 1            ' position을 할당했다. 
            rAryPos(2, Idx) = -1           ' bye의 playerCode = -1
         End If 
      Next 
   End Function 

'   ===============================================================================     
'        aryUser를 입력받아 Region, Team code를 Key로 하여 배열을 만들어 반환한다. 
'        aryUser를 aryUserA, aryUserB로 나눌때 사용할 팀 정보 배열 
'        aryTeamInfo - fUse, orderRegion, order, cntTeam, cRegion, cTeam
'        aryUser Info -  fUse, gGroupIdx, user, memIdx, cTeam, team, cSido, sido, ...  
'   ===============================================================================
   Function CreateTeamInfo(rAryUser)
      Dim Idx, ub, aryTmp, aryInfo, cTeam, cntTeam       

      ub = UBound(rAryUser, 2)
      ReDim aryTmp(5, ub)

      cntTeam = 0

      ' 실제 unique team 구하기 
      For Idx = 0 To ub
         cTeam = CStr(rAryUser(4, Idx))

         If( duxCheckTeamInfo(aryTmp, cTeam) = 0 ) Then 
            aryTmp(0, cntTeam) = 1
            aryTmp(3, cntTeam) = 1
            aryTmp(4, cntTeam) = CStr(rAryUser(6, Idx))
            aryTmp(5, cntTeam) = CStr(rAryUser(4, Idx))

            cntTeam = cntTeam + 1
         End If 
      Next

      ' 실제 aryTeamInfo 할당 
      ReDim aryInfo(5, cntTeam-1)
      ub = cntTeam-1

      For Idx = 0 To ub 
         aryInfo(0, Idx) = 0
         aryInfo(3, Idx) = aryTmp(3, Idx)
         aryInfo(4, Idx) = aryTmp(4, Idx)
         aryInfo(5, Idx) = aryTmp(5, Idx)
      Next

      CreateTeamInfo = aryInfo
   End Function 

'   ===============================================================================     
'      aryTeam Data 중복 체크 , ary, data
'      aryTeamInfo - fUse, orderRegion, order, cntTeam, cRegion, cTeam
'   ===============================================================================
   Function duxCheckTeamInfo(rAryTInfo, cTeam)
      Dim Idx, ub, is_duplicate

      is_duplicate = 0
      ub = UBound(rAryTInfo, 2)

      For Idx = 0 To ub
         If( rAryTInfo(0, Idx) <> 1) Then          ' data의 제일 마지막에 왔다. 
            Exit For
         End If 

         If(rAryTInfo(5, Idx) = cTeam) Then        ' Team code가 일치한다. 
            rAryTInfo(3, Idx) = rAryTInfo(3, Idx) + 1
            is_duplicate = 1
            Exit For
         End If 
      Next

      duxCheckTeamInfo = is_duplicate
   End Function 

'   ===============================================================================     
'      aryTeamInfo를 입력받아 aryRegion을 만들어 반환한다. 
'      aryTeamInfo - fUse, orderRegion, order, cntTeam, cRegion, cTeam
'      aryRegion - fUse, order, cntRegion, cRegion
'   ===============================================================================
   Function CreateRegionInfo(rAryInfo)
      Dim Idx, ub, aryTmp, aryRegion, cRegion, cntRegion , idx_find      

      ub = UBound(rAryInfo, 2)
      ReDim aryTmp(4, ub)

      cntRegion = 0

      ' 실제 unique team 구하기 
      For Idx = 0 To ub
         cRegion = rAryInfo(4, Idx)
         idx_find = duxCheckRegionInfo(aryTmp, cRegion)

         If( idx_find = -1 ) Then 
            aryTmp(0, cntRegion) = 1
            aryTmp(2, cntRegion) = rAryInfo(3, Idx)
            aryTmp(3, cntRegion) = rAryInfo(4, Idx)

            cntRegion = cntRegion + 1
         Else
            aryTmp(2, idx_find) = aryTmp(2, idx_find) + rAryInfo(3, Idx)
         End If 
      Next

      ' 실제 aryTeamInfo 할당 
      ReDim aryRegion(4, cntRegion-1)
      ub = cntRegion-1

      For Idx = 0 To ub 
         aryRegion(0, Idx) = 0
         aryRegion(2, Idx) = aryTmp(2, Idx)
         aryRegion(3, Idx) = aryTmp(3, Idx)
         aryRegion(4, Idx) = aryTmp(4, Idx)
      Next

      CreateRegionInfo = aryRegion
   End Function 

'   ===============================================================================     
'      aryRegion Data 중복 체크 , ary, data
'      aryRegion - fUse, order, cntRegion, cRegion
'   ===============================================================================
   Function duxCheckRegionInfo(rAryInfo, cRegion)
      Dim Idx, ub, idx_find

      idx_find = -1
      ub = UBound(rAryInfo, 2)

      For Idx = 0 To ub
         If( rAryInfo(0, Idx) <> 1) Then          ' data의 제일 마지막에 왔다. 
            Exit For
         End If 

         If(rAryInfo(3, Idx) = cRegion) Then        ' Region code가 일치한다.             
            idx_find = Idx
            Exit For
         End If 
      Next

      duxCheckRegionInfo = idx_find
   End Function    
   
'   ===============================================================================     
'      aryRegion을 count순으로 정렬한 다음 정렬 정보를 TeamInfo에 적용한다. 
'      aryTeamInfo - fUse, orderRegion, order, cntTeam, cRegion, cTeam
'      aryRegion - fUse, order, cntRegion, cRegion
'   ===============================================================================
   Function duxApplyRegionOrder(rAryRegion, rAryInfo)
      Dim ub, Idx, cRegion, prevOrder, sPos, ePos
      Dim sort_type, sort_desc

      sort_type = 2
      sort_desc = 0

      ' 인원수를 기준으로 sort한다. 
      Call Sort2DimAryEx(rAryRegion, 2, sort_type, sort_desc)

      ub = UBound(rAryRegion, 2)

      ' aryRegion에 인원수에 대한 Order를 셋팅한다. 
      For Idx = 0 To ub
         rAryRegion(1,Idx) = Idx + 1
      Next

      ' aryTeamInfo에 aryRegion Order를 셋팅한다. 
      ub = UBound(rAryInfo, 2)

      For Idx = 0 To ub
         cRegion = rAryInfo(4,Idx)
         rAryInfo(2,Idx) = duxGetRegionOrder(rAryRegion, cRegion)
      Next

'      Call printInfoEx(rAryRegion, "rAryRegion")

      ' aryRegion Order를 기준으로 sort한다. 
      Call Sort2DimAryEx(rAryInfo, 2, sort_type, sort_desc)
'      Call printInfoEx(rAryInfo, "rAryInfo")
   End Function 

'   ===============================================================================     
'      rAryInfo에 Region Order순으로 sort한후, 
'      Region Order가 같은게 2개 이상 있을 경우 block으로 처리하여 CntTeam으로 정렬한다. 
'      그후 total ordering을 한다. 
'   ===============================================================================
   Function duxApplyTeamOrder(rAryInfo)
      Dim ub, Idx, prevOrder, sPos, ePos, nCnt
      Dim sort_type, sort_desc

      sort_type = 2
      sort_desc = 0
      prevOrder = 0
      sPos = 0
      ePos = 0
      nCnt = 0

      ub = UBound(rAryInfo, 2)

      For Idx = 0 To ub 
         If( rARyInfo(2, Idx) <> prevOrder ) Then 
            ' Region Order가 같은게 2개 이상 있을 경우 block으로 처리하여 CntTeam으로 정렬한다. 
            If(nCnt > 1) Then        
               ePos = Idx-1
               ' CntTeam를 기준으로 부분 sort한다. 
               Call SortPart2DimAryEx(rAryInfo, 3, sPos, ePos, sort_type, sort_desc)
               strLog = strPrintf("SortPart2DimAryEx sPos = {0}, ePos = {1}, ub = {2}, nCnt = {3}, Idx = {4}<br>", Array(sPos, ePos, ub, nCnt, Idx))
               response.write strLog 
            End If 

            nCnt = 1
            prevOrder = rARyInfo(2, Idx)
            sPos = Idx
         Else 
            nCnt = nCnt + 1
         End If
      Next

      If(nCnt > 1) Then        
         ePos = ub
         ' CntTeam를 기준으로 부분 sort한다. 
         Call SortPart2DimAryEx(rAryInfo, 3, sPos, ePos, sort_type, sort_desc)
         strLog = strPrintf("SortPart2DimAryEx ff sPos = {0}, ePos = {1}, ub = {2}, nCnt = {3}<br>", Array(sPos, ePos, ub, nCnt))
         response.write strLog 
      End If 

      ' Region , Team Cnt를 적용한 전체 order를 적용한다. 
      For Idx = 0 To ub 
         rARyInfo(1, Idx) = Idx + 1
      Next

      Call printInfoEx(rAryInfo, "rAryInfo")
   End Function 
'   ===============================================================================     
'      cRegion를 입력받아 aryRegion에서 Order를 반환한다. 
'      aryRegion - fUse, order, cntRegion, cRegion
'   ===============================================================================
   Function duxGetRegionOrder(rAryRegion, cRegion)
      Dim ub, Idx, nOrder

      nOrder = 0
      ub = UBound(rAryRegion, 2)

      For Idx = 0 To ub
         If(rAryRegion(3,Idx) = cRegion) Then 
            nOrder = rAryRegion(1,Idx)
            Exit For 
         End If 
      Next

      duxGetRegionOrder = nOrder
   End Function 

   Function duxCreateAryUserAB(aryUserA, aryUserB, nHalf, cntByeA, cntByeB)

   End Function 

'   ===============================================================================     
'      nCol, nRow를 받아 aryUser Part A / B를 만든다. 
'      cntBye만큼 뒤에서 fUse = 1, gGroupIdx = -1로 셋팅 한다. ( bye자리 )
'      AryUser Info -  fUse, gGroupIdx, user, memIdx, cTeam, team, cSido, sido, ...  
'   ===============================================================================
   Function duxCreatePartAryUser(nCol, nRow, cntBye, IsDblGame)
      Dim Idx, ub, ary, nMax, sBye

      nMax = nRow-1
      sBye = nMax - cntBye
      If(IsDblGame = 1) Then          
         nMax = (nRow * 2) -1
         sBye = nMax - (cntBye*2)  
      End If 

      ReDim ary( nCol, nMax )

      For Idx = 0 To nMax
         If(Idx > sBye) Then 
            ary(0, Idx) = 1
            ary(1, Idx) = CON_BYEFLAG
            ary(2, Idx) = Idx + 1
         Else 
            ary(0, Idx) = 0
            ary(1, Idx) = ""
            ary(2, Idx) = Idx + 1
         End If 
      Next

      duxCreatePartAryUser = ary 
   End Function 

'   ===============================================================================     
'      aryUser의 데이터를 aryTeamInfo를 기반으로 aryUserA, aryUserB로 나눈다. 
'     1.aryTeamInfo에서 순서적으로 Team을 선택하여 사용자를 배분한다. 
'     2.복식일 경우와 단식일 경우 나누어서 생각하자. 
'     3.aryTeamInfo에서 Team을 하나 선택할 때 마다 해당 인원수를 -1해준다. 
'     4.복식일 경우 선택된 인원의 나머지 팀도 -1을 해 준다. 
'     5.만약 팀의 인원수가 0이 되면 해당 팀의 fUse = -1로 설정한다.   
'     6.선택한 cTeam을 가지고 user를 선택한다. 
'     7. PartA or PartB에 사용자를 추가해 준다. 
'     8. 복식일 경우 2명을 추가해 준다. 
'     9. 만약 selUser = -1이면 할당이 끝났다. 반환한다. 
'      AryUser Info -  fUse, gGroupIdx, user, memIdx, cTeam, team, cSido, sido, ...  
'   ===============================================================================
   Function duxDivPartAB(rAryUser, rAryInfo, aryA, aryB, IsDblGame)
      If( IsDblGame = 1 ) Then 
         Call duxDivPartAB_2Play(rAryUser, rAryInfo, aryA, aryB)
      Else 
         Call duxDivPartAB_1Play(rAryUser, rAryInfo, aryA, aryB)
      End If 
   End Function

   Function duxDivPartAB_2Play(rAryUser, rAryInfo, aryA, aryB)
      Dim Idx, ub, cTeam, cTeam2, sel1, sel2, nPart
      Dim nRet, nFix  
      nPart = CON_APART
      nFix = 0

      ub = UBound(rAryUser, 2)
      For Idx = 0 To ub
         cTeam = duxSelTeamForDiv(rAryInfo)

         If(cTeam = -1) Then              ' team이 더이상 없다.  
            Exit For 
         End If 

         sel1 = duxSelUserForDiv(rAryUser, cTeam)

         If(sel1 = -1) Then              ' User가 더이상 없다.  
            Exit For 
         End If 

         '   -----------------------------------------------------------------------
         ' 복식이기 때문에 user Info를 2개 가지고 사용해야 한다. 
         If( sel1 Mod 2 ) = 1 Then 
            sel2 = sel1 -1
         Else 
            sel2 = sel1 + 1
         End If

         If( nFix = 1 ) Then 
            If( nPart = CON_APART ) Then 
               nRet = duxCopyUserInfo(rAryUser, aryA, sel1)
               nRet = duxCopyUserInfo(rAryUser, aryA, sel2)     
            Else 
               nRet = duxCopyUserInfo(rAryUser, aryB, sel1)
               nRet = duxCopyUserInfo(rAryUser, aryB, sel2)
            End If 
         Else 
            ' PartA or PartB에 사용자를 추가해 준다.
            If( nPart = CON_APART ) Then 
               nRet = duxCopyUserInfo(rAryUser, aryA, sel1)
               nRet = duxCopyUserInfo(rAryUser, aryA, sel2)               
               nPart = CON_BPART

               If(nRet = -1) Then 
                  nFix = 1
                  nRet = duxCopyUserInfo(rAryUser, aryB, sel1)
                  nRet = duxCopyUserInfo(rAryUser, aryB, sel2)
               End If 
            Else 
               nRet = duxCopyUserInfo(rAryUser, aryB, sel1)
               nRet = duxCopyUserInfo(rAryUser, aryB, sel2)
               nPart = CON_APART

               If(nRet = -1) Then 
                  nFix = 1
                  nRet = duxCopyUserInfo(rAryUser, aryA, sel1)
                  nRet = duxCopyUserInfo(rAryUser, aryA, sel2)  
               End If 
            End If  
         End If 
                 
         ' partner 팀도 count를 센다. 
         cTeam2 = rAryUser(4, sel2)
         Call duxUsedTeamForDiv(rAryInfo, cTeam2)
      Next
   End Function

   Function duxDivPartAB_1Play(rAryUser, rAryInfo, aryA, aryB)
      Dim Idx, ub, cTeam, sel, nPart
      Dim nRet, nFix  
      nPart = CON_APART
      nFix = 0

      ub = UBound(rAryUser, 2)
      For Idx = 0 To ub
         cTeam = duxSelTeamForDiv(rAryInfo)

         If(cTeam = -1) Then              ' team이 더이상 없다.  
            Exit For 
         End If 

         sel = duxSelUserForDiv(rAryUser, cTeam)

         If(sel = -1) Then              ' User가 더이상 없다.  
            Exit For 
         End If 

         If( nFix = 1 ) Then 
            If( nPart = CON_APART ) Then 
               nRet = duxCopyUserInfo(rAryUser, aryA, sel)
            Else 
               nRet = duxCopyUserInfo(rAryUser, aryB, sel)
            End If 
         Else 
            ' PartA or PartB에 사용자를 추가해 준다.
            If( nPart = CON_APART ) Then 
               nRet = duxCopyUserInfo(rAryUser, aryA, sel)
               nPart = CON_BPART

               If(nRet = -1) Then 
                  nFix = 1
                  nRet = duxCopyUserInfo(rAryUser, aryB, sel)
               End If 
            Else 
               nRet = duxCopyUserInfo(rAryUser, aryB, sel)
               nPart = CON_APART

               If(nRet = -1) Then 
                  nFix = 1
                  nRet = duxCopyUserInfo(rAryUser, aryA, sel)
               End If 
            End If  
         End If 
      Next
   End Function

'   ===============================================================================     
'      A, B Part로 인원을 나누기 위해 Team을 선택한다. 
'      aryTeamInfo - fUse, orderRegion, order, cntTeam, cRegion, cTeam
'      1. fUse <> -1인 것중에서 위에서 부터 순차적으로 Team을 선택한다. 
'      2. 선택한 cntTeam = cntTeam -1을 한다. 
'      3. 만약 cntTeam = 0이면 fUse = 0으로 설정한다 .
'   ===============================================================================
   Function duxSelTeamForDiv(rAryInfo)
      Dim Idx, ub, selTeam, cntTeam  

      selTeam = -1
      ub = UBound(rAryInfo, 2)

      For Idx = 0 To ub 
         If( rAryInfo(0,Idx) <> -1 ) Then 
            selTeam = rAryInfo(5, Idx)
            cntTeam = rAryInfo(3,Idx) - 1

            If(cntTeam = 0) Then 
               rAryInfo(0,Idx) = -1
            Else 
               rAryInfo(3,Idx) = cntTeam
            End If   
            Exit For           
         End If  
      Next 

      duxSelTeamForDiv = selTeam
   End Function 

'   ===============================================================================     
'      복식일 경우 사용 , partner Team code를 입력하여 team Count를 줄인다. 
'      aryTeamInfo - fUse, orderRegion, order, cntTeam, cRegion, cTeam
'      1. 선택한 cntTeam = cntTeam -1을 한다. 
'      2. 만약 cntTeam = 0이면 fUse = 0으로 설정한다 .
'   ===============================================================================
   Function duxUsedTeamForDiv(rAryInfo, cTeam)
      Dim Idx, ub, cntTeam  

      ub = UBound(rAryInfo, 2)
      For Idx = 0 To ub 
         If( rAryInfo(0,Idx) <> -1 And rAryInfo(5, Idx) = cTeam ) Then             
            cntTeam = rAryInfo(3,Idx) - 1

            If(cntTeam = 0) Then 
               rAryInfo(0,Idx) = -1
            Else 
               rAryInfo(3,Idx) = cntTeam
            End If   
            Exit For           
         End If  
      Next 
   End Function 

'   ===============================================================================     
'      team code를 입력받아 aryUser에서 해당 팀의 User Idx를 반환한다. 
'      AryUser Info -  fUse, gGroupIdx, user, memIdx, cTeam, team, cSido, sido, ... 
'      1. 선택한 UserIdx의 fUse = 1로 바꾼다. 
'      2. 만약 모두 선택이 되었다면 selIdx = -1을 반환한다. (할당이 완료되었다.)
'   ===============================================================================
   Function duxSelUserForDiv(rAryUser, cTeam)
      Dim Idx, ub, selIdx

      selIdx = -1
      ub = UBound(rAryUser, 2)

      For Idx = 0 To ub 
         If( rAryUser(0,Idx) <> 1 And rAryUser(4, Idx) = cTeam ) Then          ' 같은 팀을 찾았다.    
            selIdx = Idx  
            rAryUser(0,Idx) = 1
            Exit For           
         End If  
      Next 

      duxSelUserForDiv = selIdx 
   End Function 

'   ===============================================================================     
'      aryUser로 부터 UserInfo를 copy한다. aryUser(sel)
'     위에서 부터 순차적으로 copy하며 ary(0,Idx) = 0인 곳에 copy를 한다 .
'     userInfo를 copy한후 ary(0,Idx) = 1로 변경한다. 
'   ===============================================================================
   Function duxCopyUserInfo(rAryUser, aryPart, sel)
      Dim Idx, ub, nCol, k, ret 
      
      ret = -1
      ub = UBound(aryPart, 2)
      nCol = UBound(aryPart, 1)

      For Idx = 0 To ub 
         If( aryPart(0,Idx) = 0 ) Then          ' 빈곳을 찾았다. user info를 copy한다. 
            For k = 0 To nCol
               aryPart(k, Idx) = rAryUser(k, sel)
            Next

            aryPart(0,Idx) = 1
            rAryUser(0,sel) = 1
            ret = 1
            Exit For           
         End If  
      Next 
      duxCopyUserInfo = ret
   End Function 

'   ===============================================================================     
'     aryUserA, aryUserB의 fUse 값을 초기화 한다 .
'     AryUser Info -  fUse, gGroupIdx, user, memIdx, cTeam, team, cSido, sido, ... 
'     if(gGroupIdx <> -1) fUse = 0  ' bye 자리는 초기화 하지 않는다 .
'   ===============================================================================
   Function duxResetAryPart(rAryPart)
      Dim Idx, ub
      
      ub = UBound(rAryPart, 2)

      For Idx = 0 To ub 
         If( CStr(rAryPart(1,Idx)) <> CON_BYEFLAG ) Then          ' Bye 자리가 아니다. 그러면 fUse를 초기화 하자
            rAryPart(0,Idx) = 0    
         End If  
      Next 
   End Function 

%>

<%
   Function printInfoEx(rAryInfo, strTitle)
      Dim Idx, aj , ul, ul2, strInfo
      ul = UBound(rAryInfo,2)
      ul2 = UBound(rAryInfo,1)
      
      If(strTitle = "") Then strTitle = "printInfoEx" End If 
      strLog = strPrintf(" ------------------------- {0}  <br>", Array(strTitle))
      response.write strLog

      strInfo = ""

      For Idx = 0 To ul 
         strInfo = strPrintf("Idx = {0}, ", Array(Idx))
         For aj = 0 To ul2 
            strInfo = strPrintf("{0} ({1} - {2})", Array(strInfo, aj, rAryInfo(aj, Idx)))             
         Next 
         response.write strInfo & "<br>"
      Next

      strLog = strPrintf(" ------------------------- {0}  <br>", Array(strTitle))
      response.write strLog
   End Function 

   '   ===============================================================================     
   '     print - ary team 
   '      fUse, firstSel, cntUser, cTeam , team, cSigun, sigun
   '   ===============================================================================
   Function printAryTeamEx(rAryTeam)
      Dim ub, Idx
      ub = UBound(rAryTeam, 2)       
      Response.Write "<br><br>************************ Dev print Team *************<br>"
      For Idx = 0 to ub            
            strLog = strPrintf("fUse = {0}, firstSel = {1} , cntUser = {2}, cTeam = {3}, team = {4} , cSigun = {5}, sigun = {6}<br>", _ 
               Array(rAryTeam(0,Idx), rAryTeam(1,Idx), rAryTeam(2,Idx), rAryTeam(3,Idx), _
                     rAryTeam(4,Idx), rAryTeam(5,Idx), rAryTeam(6,Idx)))
            Response.Write strLog
      Next    
      Response.Write "<br>************************ Dev print Team *************<br><br>"
   End Function 
   '   ===============================================================================     
   '     print - ary user
   '     aryUser Info 
   '           fUse, gGroupIdx, user, memIdx, cTeam, team, cSido, sido, ...         
   '   ===============================================================================
   Function printAryUserEx(rAryUser)
      Dim ub, Idx
      ub = UBound(rAryUser, 2)       
      Response.Write "<br><br>************************ Dev print User *************<br>"
      For Idx = 0 to ub            
            strLog1 = strPrintf("Idx = {0}, fUse = {1}, gGroupIdx = {2} , user = {3}, memIdx = {4}", _ 
                  Array(Idx, rAryUser(0,Idx), rAryUser(1,Idx), rAryUser(2,Idx), rAryUser(3,Idx)))
            strLog2 = strPrintf("cTeam = {0}, team = {1} , cSido = {2}, sido = {3}", _ 
                  Array(rAryUser(4,Idx), rAryUser(5,Idx), rAryUser(6,Idx), rAryUser(7,Idx)))
            strLog = strPrintf("{0} {1}<br>", Array(strLog1, strLog2))                      
            
            Response.Write strLog
      Next    
      Response.Write "<br>************************ Dev print User *************<br><br>"
   End Function 
   '   ===============================================================================     
   '     print - ary pos
   '     aryPos Info 
   '       복식 : fUse, pos, playerCode(단체코드), cUser1, user1, cUser2, user2, cTeam1, team1, cTeam2, team2, cSido1, sido1, cSido2, sido2
   '       단식 : fUse, pos, playerCode(memIdx), user, cTeam, team , cSido, sido
   '   ===============================================================================
   Function printAryPosEx(rAryPos, IsDoubleGame)
      Dim ub, Idx, teamN1, teamN2, userN1, userN2
      Dim strPlayerCode, playerCode
      ub = UBound(rAryPos, 2)       
      Response.Write "<br><br>************************ Dev print Position  *************<br>"
      If ( IsDoubleGame = 1 ) Then 
            For Idx = 0 to ub    
               teamN1 = rAryPos(8,Idx)
               teamN2 = rAryPos(10,Idx)
               userN1 = rAryPos(4,Idx)
               userN2 = rAryPos(6,Idx)
               If( CDbl(rAryPos(2,Idx)) = -1 ) Then   ' Empty User        
'                If( rAryPos(2,Idx) = "-1" ) Then   ' Empty User        
                  teamN1 = "Empty"
                  teamN2 = "Empty"
                  userN1 = "Empty"
                  userN2 = "Empty"
                  playerCode = 0
               Else 
                  teamN1 = rAryPos(8,Idx)
                  teamN2 = rAryPos(10,Idx)
                  userN1 = rAryPos(4,Idx)
                  userN2 = rAryPos(6,Idx)
                  playerCode = rAryPos(2,Idx)
               End If
               strLog1 = strPrintf("Idx = {0}, fUse = {1}, pos = {2} , playerCode = {3}, cUser1 = {4}, user1 = {5},", _ 
                  Array(Idx+1, rAryPos(0,Idx), rAryPos(1,Idx), rAryPos(2,Idx), rAryPos(3,Idx), userN1))
               strLog2 = strPrintf("cUser2 = {0}, user2 = {1} , cTeam1 = {2}, team1 = {3}, cTeam2 = {4},", _ 
                  Array(rAryPos(5,Idx), userN2, rAryPos(7,Idx), teamN1, rAryPos(9,Idx)))
               strLog3 = strPrintf("team2 = {0}, cSido1 = {1} , sido1 = {2}, cSido2 = {3}, sido2 = {4}", _ 
                  Array(teamN2, rAryPos(11,Idx), rAryPos(12,Idx), rAryPos(13,Idx), rAryPos(14,Idx)))
               strLog = strPrintf("{0} {1} {2} <br>", Array(strLog1, strLog2, strLog3))
               Response.Write strLog
               If( Idx = 0 ) Then 
                  strPlayerCode = playerCode
               Else
                  strPlayerCode = strPlayerCode & "," & playerCode
               End If
            Next    
      Else 
            For Idx = 0 to ub                   
               If( CDbl(rAryPos(2,Idx)) = -1 ) Then   ' Empty User    
                  teamN1 = "Empty"
                  userN1 = "Empty"
                  playerCode = 0
               Else 
                  teamN1 = rAryPos(5,Idx)
                  userN1 = rAryPos(3,Idx)
                  playerCode = rAryPos(2,Idx)
               End If
               strLog1 = strPrintf("Idx = {0}, fUse = {1}, pos = {2} , playerCode = {3}, user = {4},", _ 
                  Array(Idx+1, rAryPos(0,Idx), rAryPos(1,Idx), rAryPos(2,Idx), userN1))
               strLog2 = strPrintf("cTeam = {0}, team = {1} , cSido = {2}, sido = {3}", _ 
                  Array(rAryPos(4,Idx), teamN1, rAryPos(6,Idx), rAryPos(7,Idx)))
               strLog = strPrintf("{0} {1}<br>", Array(strLog1, strLog2))
               Response.Write strLog
               If( Idx = 0 ) Then 
                  strPlayerCode = playerCode
               Else
                  strPlayerCode = strPlayerCode & "," & playerCode
               End If
            Next     
      End If        
      
      Response.Write "<br>************************ Dev print Position  *************<br><br>"
      printAryPosEx = strPlayerCode
   End Function 

   Function printAryPosExWithSysLog_D(rAryPos, IsDoubleGame)
      Dim ub, Idx, teamN1, teamN2, userN1, userN2
      Dim strPlayerCode, playerCode
      ub = UBound(rAryPos, 2)       
      Response.Write "<br><br>************************ Dev print Position  *************<br>"
      Call writeSysLog(SYS_LOG1, "************************ Dev print Position  *************") 
      If ( IsDoubleGame = 1 ) Then 
            For Idx = 0 to ub    
               teamN1 = rAryPos(8,Idx)
               teamN2 = rAryPos(10,Idx)
               userN1 = rAryPos(4,Idx)
               userN2 = rAryPos(6,Idx)
               If( CDbl(rAryPos(2,Idx)) = -1 ) Then   ' Empty User        
'                If( rAryPos(2,Idx) = "-1" ) Then   ' Empty User        
                  teamN1 = "Empty"
                  teamN2 = "Empty"
                  userN1 = "Empty"
                  userN2 = "Empty"
                  playerCode = 0
               Else 
                  teamN1 = rAryPos(8,Idx)
                  teamN2 = rAryPos(10,Idx)
                  userN1 = rAryPos(4,Idx)
                  userN2 = rAryPos(6,Idx)
                  playerCode = rAryPos(2,Idx)
               End If
               strLog1 = strPrintf("Idx = {0}, fUse = {1}, pos = {2} , playerCode = {3}, cUser1 = {4}, user1 = {5},", _ 
                  Array(Idx+1, rAryPos(0,Idx), rAryPos(1,Idx), rAryPos(2,Idx), rAryPos(3,Idx), userN1))
               strLog2 = strPrintf("cUser2 = {0}, user2 = {1} , cTeam1 = {2}, team1 = {3}, cTeam2 = {4},", _ 
                  Array(rAryPos(5,Idx), userN2, rAryPos(7,Idx), teamN1, rAryPos(9,Idx)))
               strLog3 = strPrintf("team2 = {0}, cSido1 = {1} , sido1 = {2}, cSido2 = {3}, sido2 = {4}", _ 
                  Array(teamN2, rAryPos(11,Idx), rAryPos(12,Idx), rAryPos(13,Idx), rAryPos(14,Idx)))
               strLog = strPrintf("{0} {1} {2} <br>", Array(strLog1, strLog2, strLog3))
               Response.Write strLog
               Call writeSysLog(SYS_LOG1, strLog) 
               If( Idx = 0 ) Then 
                  strPlayerCode = playerCode
               Else
                  strPlayerCode = strPlayerCode & "," & playerCode
               End If
            Next    
      Else 
            For Idx = 0 to ub                   
               If( CDbl(rAryPos(2,Idx)) = -1 ) Then   ' Empty User    
                  teamN1 = "Empty"
                  userN1 = "Empty"
                  playerCode = 0
               Else 
                  teamN1 = rAryPos(5,Idx)
                  userN1 = rAryPos(3,Idx)
                  playerCode = rAryPos(2,Idx)
               End If
               strLog1 = strPrintf("Idx = {0}, fUse = {1}, pos = {2} , playerCode = {3}, user = {4},", _ 
                  Array(Idx+1, rAryPos(0,Idx), rAryPos(1,Idx), rAryPos(2,Idx), userN1))
               strLog2 = strPrintf("cTeam = {0}, team = {1} , cSido = {2}, sido = {3}", _ 
                  Array(rAryPos(4,Idx), teamN1, rAryPos(6,Idx), rAryPos(7,Idx)))
               strLog = strPrintf("{0} {1}<br>", Array(strLog1, strLog2))
               Response.Write strLog
               Call writeSysLog(SYS_LOG1, strLog) 
               If( Idx = 0 ) Then 
                  strPlayerCode = playerCode
               Else
                  strPlayerCode = strPlayerCode & "," & playerCode
               End If
            Next     
      End If        
      Call writeSysLog(SYS_LOG1, strPlayerCode) 
      Response.Write "<br>************************ Dev print Position  *************<br><br>"
      Call writeSysLog(SYS_LOG1, "************************ Dev print Position  *************") 
      printAryPosExWithSysLog_D = strPlayerCode
   End Function 
%>
