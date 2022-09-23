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
   Dim CON_APART, CON_BPART, CON_BYEFLAG, CON_DEFBLOCK

   TCNT_NONE         = -1           ' 팀인원이 없다. 
   TCNT_AVROVER      = 11           ' 팀인원이 평균보다 많다. 
   TCNT_NORMAL       = 10           ' 팀인원이 평균 이하이다. 
   TCNT_HALFOVER     = 9            ' 팀인원이 절반 보다 많다. 

   CON_APART         = 0            ' A Part
   CON_BPART         = 1            ' B Part
   CON_BYEFLAG       = "-1"
   CON_DEFBLOCK      = 4
   

%>

<% 	    
'   *******************************************************************************
'     process function 
'   ******************************************************************************* 

  
   Function duxAssignPosForTonament(rAryUser, IsDblGame, IsFixedPos)      
      Dim aryPos, aryUserA, aryUserB
      Dim strGroupIdxs
      strGroupIdxs = ""
      
      Call duxProcessDivPart(rAryUser, aryPos, aryUserA, aryUserB, IsDblGame, IsFixedPos)
      Call duxProcessAssignPos(aryPos, aryUserA, aryUserB, IsDblGame)

      Response.Write "<br>*************************************<br><br>"
      Call printAryUserEx(aryUser)

      Response.Write "<br>*************************************<br><br>"
      strGroupIdxs = printAryPosWithSysLog_D(aryPos, IsDoubleGame)

      Response.Write "<br><br>" & strGroupIdxs
      Response.Write "<br>*************************************<br><br>"

      duxAssignPosForTonament = strGroupIdxs
   End Function 

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

      strLog = sprintf("IsDblGame = {0}, ub = {1}, nUser = {2}, nRound = {3}, nBye = {4}, sBlock = {5}, IsFixedPos = {6}<br>", _
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


      strLog = sprintf("nCol = {0}, nRow = {1}, cntByeA = {2}, IsDblGame = {3}<br>", _
                  Array(nCol, nRow, cntByeA, IsDblGame))
      response.write strLog

      rAryUserA = duxCreatePartAryUser(nCol, nRow, cntByeA, IsDblGame)
      rAryUserB = duxCreatePartAryUser(nCol, nRow, cntByeB, IsDblGame)

'      Call printInfoEx(rAryUserA, "rAryUserA")
'      Call printInfoEx(rAryUserB, "rAryUserB")


      strLog = sprintf("nHalf = {0}, nBye = {1}, cntByeA = {2}, cntByeB = {3}<br>", Array(nHalf, nBye, cntByeA, cntByeB))
      response.write strLog

'        6. A Part / B Part로 나누기 위해 aryUser로 부터 aryTeamInfo를 추출한다. 
      aryTeamInfo = duxCreateTeamInfo(aryUser)
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
'      Call printInfoEx(aryTeamInfo, "duxApplyTeamOrder aryTeamInfo")

      Call duxDivPartAB(aryUser, aryTeamInfo, rAryUserA, rAryUserB, IsDblGame) 

      Call duxResetAryPart(rAryUserA)
      Call duxResetAryPart(rAryUserB)
'      Call printInfoEx(rAryUserA, "Copy User rAryUserA")
'      Call printInfoEx(rAryUserB, "Copy User rAryUserB")
   End Function 

'   ===============================================================================     
'      aryUser, aryPos, aryUserA, aryUserB

'   ===============================================================================
   Function duxProcessAssignPos(rAryPos, rAryUserA, rAryUserB, IsDblGame)
      Dim aryTeamA, aryTeamB, aryPosA, aryPosB 

      Call printInfoEx(rAryUserA, "Copy User rAryUserA")
      Call printInfoEx(rAryUserB, "Copy User rAryUserB")

      aryTeamA = duxCreateTeam(rAryUserA)
      aryTeamB = duxCreateTeam(rAryUserB)

   '   Call printInfoEx(aryTeamA, "duxCreateTeam aryTeamA")
   '   Call printInfoEx(aryTeamB, "duxCreateTeam aryTeamB")

      aryPosA = duxDivAryPos(rAryPos, CON_APART)
      aryPosB = duxDivAryPos(rAryPos, CON_BPART)

   '   Call printInfoEx(rAryPos, "----- rAryPos -----")
   '   Call printInfoEx(aryPosA, "duxDivAryPos aryPosA")
   '   Call printInfoEx(aryPosB, "duxDivAryPos aryPosB")

      Call duxAssignPos(aryPosA, rAryUserA, aryTeamA, IsDblGame)
      Call duxAssignPos(aryPosB, rAryUserB, aryTeamB, IsDblGame)

      Call duxMergeAryPos(rAryPos, aryPosA, CON_APART)
      Call duxMergeAryPos(rAryPos, aryPosB, CON_BPART)

   '   Call printInfoEx(rAryPos, "----- duxMergeAryPos rAryPos -----")
   End Function 

   Function duxAssignPos(rAryPos, rAryUser, rAryTeam, IsDblGame)
      Dim i, ub, fLoop, cntLoop, nSelTeam, cTeam, nSelUser, sBlock, nRound 
      ' ================================================================================================
      ' allocate ary position
      Response.Write "* $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ <br><br>"

      fLoop = 1
      ub = UBound(rAryUser, 2)
      nRound = UBound(rAryPos, 2) + 1
      sBlock = duxCalcSearchBlock(nRound)

      '최승규 : 추첨시 playerCode = 0 으로 찍힐때 cntLoop  증가시켜야됨
      cntLoop = 20

      For i = 0 To ub
         nSelTeam = duxGetSelTeam(rAryTeam)

         strLog = sprintf("i = {0} , nSelTeam = {1}<br>", Array(i, nSelTeam))
         Response.Write strLog

         If (nSelTeam = -1 ) Then        ' Team 이 없다. 
            Exit For 
         End If

         cTeam = rAryTeam(3,nSelTeam)    
         nSelUser = duxGetSelUser(rAryUser, cTeam)

         If(nSelUser = -1) Then 
            Call duxRemoveTeam(rAryTeam, cTeam)   
            strLog = sprintf("11 uxRemoveTeamFromrAryTeam cTeam = {0} <br>", Array(cTeam))
            Response.Write strLog

            '최승규 : 추첨시 playerCode = 0 으로 찍힐때 cntLoop 증가시켜야됨
            cntLoop = 20
            fLoop = 1
            Do While fLoop
               nSelTeam = duxGetSelTeam(rAryTeam)
               
               If (nSelTeam <> -1 ) Then cTeam = rAryTeam(3,nSelTeam)  End If
               
               If (nSelTeam <> -1 ) Then        ' Team 이 있다                    
                  nSelUser = duxGetSelUser(rAryUser, cTeam)
                  If(nSelUser = -1) Then                         
                        Call duxRemoveTeam(rAryTeam, cTeam)

                        strLog = sprintf("22 uxRemoveTeamFromrAryTeam cTeam = {0} <br>", Array(cTeam))
                        Response.Write strLog                        
                  Else
                        fLoop = 0
                  End If
               Else 
                  fLoop = 0                    
               End If

               cntLoop = cntLoop -1
               If( cntLoop = 0) Then 
                  fLoop = 0 
               End If
            Loop            
         End If

         If (nSelUser = -1 ) Then        ' User Info가 없다. 
               Exit For             
         End If

         If(IsDblGame = 1) Then 
            Call duxSetGamePosDbl(rAryPos, rAryUser, nSelUser, sBlock)
         Else 
            Call duxSetGamePos(rAryPos, rAryUser, nSelUser, sBlock)
         End If 
      Next

      Response.Write "* $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ <br><br>"
   End Function 
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

      strLog = sprintf("duxSetByeToAryFixPos nBye = {0}, ub = {1}, nByeMark = {2}<br>", Array(nBye, ub, nByeMark))
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
'      aryTeam에서 Random하게 Team하나를 선택한다. 
'	    aryTeam에서 Team User Count가 팀 평균 Count보다 크면 (aryTeam(1,team) > average) 먼저 팀원을 배정한다. 
'	    aryTeam에서 Team User Count가 Half User 보다 크면 (aryTeam(1,team) > half)       제일 마지막 팀원을 배정한다. 
'      aryTeam에서 Team User Count가 팀 평균 Count보다 작으면 (aryTeam(1,team) < average) 랜덤하게 팀을 순환하면서  팀원을 배정한다. 
'      fUse, selOrder, cntUser, cTeam , team, cSigun, sigun
'   ===============================================================================
	Function duxGetSelTeam(byRef rAryTeam)
		Dim selTeam, selOrder, ub
		selOrder = TCNT_HALFOVER

		ub = UBound(rAryTeam, 2) 

      ' 삭제가 되지 않았고 , selOrder = TCNT_AVROVER로 셋팅이 되어 있으면 먼저 할당한다. 
      ' 삭제가 되지 않았고 , selOrder = TCNT_HALFOVER로 셋팅이 되어 있으면 제일 마지막에 할당한다. 
      ' 모든 사용자를 할당한 팀은 배열에서 삭제 해야 한다. 
      ' 물리적으로 삭제를 하지 않고 flag setting으로 삭제 유무 표시 : rAryTeam(0,Idx) = -1
		For Idx = 0 To ub
			If( rAryTeam(0,Idx) <> -1 ) And (rAryTeam(1, Idx) = TCNT_AVROVER) Then 
				selOrder = TCNT_AVROVER 
				Exit For
			End If
		Next

      ' 팀인원수에 평균 이상이 더이상 없다면 Normal을 체크한다. 
      IF( selOrder <> TCNT_AVROVER) Then 
         For Idx = 0 To ub
            If( rAryTeam(0,Idx) <> -1 ) And (rAryTeam(1, Idx) = TCNT_NORMAL) Then 
               selOrder = TCNT_NORMAL 
               Exit For
            End If
         Next
      End If
		
		If (selOrder = TCNT_AVROVER) Then                  ' 팀 인원수가 평균 이상 , 절반 이하면 제일 먼저 할당
			selTeam = duxGetSelTeamOverAve(rAryTeam, selOrder)
      ElseIf (selOrder = TCNT_NORMAL) Then          
			selTeam = duxGetSelTeamLowAve(rAryTeam, selOrder)
		Else           
         selTeam = duxGetSelTeamOverAve(rAryTeam, selOrder)               ' 팀 인원수가 절반 이상이면 제일 마지막에 할당 
		End If

		duxGetSelTeam = selTeam
	End Function

'   ===============================================================================     
'      aryTeam에서 Random하게 Team하나를 선택한다. 
'	    aryTeam(1,team) = TCNT_AVROVER Or aryTeam(1,team) = TCNT_HALFOVER 
'   ===============================================================================
	Function duxGetSelTeamOverAve(byRef rAryTeam, selOrder)
		Dim cntTeam, selTeam, Idx, ub, rNum, cnt      

		cntTeam = duxGetTeamCnt(rAryTeam, selOrder)
		
		If(cntTeam = 1) Then
			rNum = 0
		Else 
			rNum = GetRandomNum(cntTeam) - 1
		End If

	'   ===============================================================================   
	'	selTeam을 구한다. ( (rAryTeam(1, Idx) = TCNT_AVROVER or TCNT_HALFOVER) 것만 rNum과 cnt가 같을 때 까지 )
		ub = UBound(rAryTeam, 2) 
		cnt = 0
		selTeam = -1

      For Idx = 0 To ub
         If( rAryTeam(0,Idx) <> -1  And rAryTeam(1, Idx) = selOrder) Then 
            If(rNum = cnt) Then 			' 찾았다. 
               selTeam = Idx
               Exit For 
            End If
            cnt = cnt + 1
         End If
      Next

		duxGetSelTeamOverAve = selTeam
	End Function

'   ===============================================================================     
'      aryTeam에서 Random하게 Team하나를 선택한다. 
'	    aryTeam(1,team) = TCNT_NORMAL - 랜덤하게 팀을 순환하면서  팀원을 배정한다. 
'   ===============================================================================
	Function duxGetSelTeamLowAve(byRef rAryTeam, selOrder)
		Dim cntTeam, selTeam, Idx, ub, rNum, cnt

		cntTeam = duxGetTeamCnt(rAryTeam, selOrder)
		If (cntTeam = 0 ) Then 
			Call duxResetFUseTeam(rAryTeam) 
         cntTeam = duxGetTeamCnt(rAryTeam, selOrder)
		End If

		rNum = GetRandomNum(cntTeam) - 1
	'   ===============================================================================   
	'	selTeam을 구한다. ( fUse = 0인 것만이 대상 - rNum과 cnt가 같을 때 까지 ) fUse = -1 삭제 , fUse = 1 사용
		ub = UBound(rAryTeam, 2) 
		cnt = 0
		selTeam = -1

		For Idx = 0 To ub
			If(rAryTeam(0, Idx) = 0) Then 
				If(rNum = cnt) Then 			' 찾았다. 
					selTeam = Idx
					Exit For 
				End If
				cnt = cnt + 1
			End If
		Next

		If( selTeam <> -1 ) Then rAryTeam(0,selTeam) = 1	End If		' fUse Setting 

		duxGetSelTeamLowAve = selTeam
	End Function

'   ===============================================================================     
'      aryTeam에서 선택 가능한 팀 Count를 구한다.  
'     
'      selOrder = TCNT_AVROVER team 원 수가 average보다 큰 팀 카운트 
'      selOrder = TCNT_HALFOVER team 원 수가 Half보다 큰 팀 카운트 
'      selOrder = TCNT_NORMAL team 원 수가 average보다 작거나 같은 팀 카운트 
'
'      fUse, selOrder, cntUser, cTeam , team, cSigun, sigun
'   ===============================================================================
	Function duxGetTeamCnt(byRef rAryTeam, selOrder)
		Dim Idx , ub, cntTeam
		
		cntTeam = 0
		ub = UBound(rAryTeam, 2) 

      ' 먼저 할당해야 하는 것은 fUse를 사용하지 않는다. 
      If( selOrder = TCNT_AVROVER Or selOrder = TCNT_HALFOVER) Then 
         For Idx = 0 To ub 		
            If ( rAryTeam(0,Idx) <> -1)  And ( rAryTeam(1,Idx) = selOrder)Then 
               cntTeam = cntTeam + 1
            End If
         Next
      Else    
         For Idx = 0 To ub 		
            If ( rAryTeam(0, Idx) = 0 )Then 
               cntTeam = cntTeam + 1
            End If
         Next
      End If		

		duxGetTeamCnt = cntTeam
	End Function

'   ===============================================================================     
'      aryTeam : Reset fUse
'      aryTeam(0,ti) = -1 삭제 flag
'   ===============================================================================
   Function duxResetFUseTeam(byRef aryTeam)
		Dim Idx , ub

		ub = UBound(aryTeam, 2) 
		For Idx = 0 To ub 		
			If(aryTeam(0,Idx) <> -1) Then 
				aryTeam(0, Idx) = 0
			End If
		Next
	End Function

'   ===============================================================================     
'      aryTeam : Remove Team 
'      Redim 을 해야 하나 refrence로 물고 있으면 적용이 안되어 부득이 -1로 Del flag를 세웠다. 
'      삭제할 pos을 기점으로 배열을 한칸씩 당기고 제일 마지막 값에 Del flag를 세운다. 
'      fUse, selOrder, cntUser, cTeam , team, cSigun, sigun
'   ===============================================================================
	Function duxRemoveTeam(ByRef rAryTeam, cTeam)
		Dim Idx , ub, k

		ub = UBound(rAryTeam, 2) 
		For Idx = 0 To ub 		
			If( rAryTeam(3, Idx) = cTeam ) Then 
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

'   ===============================================================================     
'     team을 입력받아  rAryUser에서 User를 하나 선택한다. 
'     해당하는 Team에 더이상 선수가 없으면 -1을 Return한다. 
'     복식 / 단식 구분없이 실행한다. 
'   ===============================================================================
	Function duxGetSelUser(byRef rAryUser, cTeam)
		Dim selUser, Idx, ub, nCntUser, rNum, nCnt

	'   ===============================================================================   
	'	selUser을 구한다. ( fUse = 1인 것을 제외하고 strTeam과 team이 같을때 까지 )
		ub = UBound(rAryUser, 2) 		
		nCntUser = duxGetCntTeamUser(rAryUser, cTeam)
		rNum = GetRandomNum(nCntUser) - 1
		selUser = -1

		For Idx = 0 To ub
			If(rAryUser(0, Idx) = 0) And (rAryUser(4, Idx) = cTeam) Then 	' 찾았다. 
				If(rNum = nCnt) Then 
					selUser = Idx
					rAryUser(0, Idx) = 1		' fUse Setting 			
					Exit For 
				Else
					nCnt = nCnt + 1
				End If				
			End If
		Next

		duxGetSelUser = selUser
	End Function

'   ===============================================================================     
'     team을 입력받아  rAryUser에서 해당 Team원 수를 Return 한다. 
'     이때 팀원은 사용하지 않은 팀원에 한정한다.  fUse = 1인 것을 제외
'   ===============================================================================
	Function duxGetCntTeamUser(byRef rAryUser, cTeam)
		Dim Idx, ub, nCntUser

	'   ===============================================================================   
	'	selUser을 구한다. ( fUse = 1인 것을 제외하고 cTeam team이 같을때 까지 )
		ub = UBound(rAryUser, 2) 		
		nCntUser = 0

		For Idx = 0 To ub
			If(rAryUser(0, Idx) = 0) And (rAryUser(4, Idx) = cTeam) Then 	' 찾았다. 
				nCntUser = nCntUser + 1
			End If
		Next

		duxGetCntTeamUser = nCntUser
	End Function

'   ===============================================================================     
'    Block position을 입력받아 해당 Block에 있는 User수를 Count한다. 
'    strBlock = 0,1,2,3,4,5,6,7  넘어오는 값이 이런식이므로 
'    start position을 구할때 * sBase을 해야 실제 Block start position을 구할수 있다. 
'   ===============================================================================   
   Function duxGetUserCntInBlock(blockPos, sBlock, rAryPos)
      Dim sPos, ePos, cntUser, Idx 

      cntUser = 0
      sPos = blockPos * sBlock   
		ePos = sPos + sBlock -1
      For Idx = sPos To ePos		' insert position을 random하게 구한다. 
         If( rAryPos(0, Idx) = 1 ) Then 
            cntUser = cntUser + 1
         End If
      Next

      duxGetUserCntInBlock = cntUser
   End Function 


'   ===============================================================================     
'        aryUser를 입력받아 Team을 추출한다. 
'        복식일 경우도 단일팀으로 계산하여 구한다 
'        fUse, selOrder, cntUser, cTeam , team, cSigun, sigun
'        aryUser Info -  fUse, gGroupIdx, user, memIdx, cTeam, team, cSido, sido, ...  
'   ===============================================================================
   Function duxCreateTeam(rAryUser)
      Dim Idx, ub, aryTmp, aryTeam, cTeam, cntTeam       
      Dim nUser, nAve, nHalf, nTotal

      ub = UBound(rAryUser, 2)
      ReDim aryTmp(7, ub)

      nUser = ub + 1
      cntTeam = 0

      ' 실제 unique team 구하기 
      For Idx = 0 To ub
         If( CStr(rAryUser(1, Idx)) <> CON_BYEFLAG) Then          ' Bye는 사용하지 않는다. 
            cTeam = CStr(rAryUser(4, Idx))

            If( duxCheckTeam(aryTmp, cTeam) = 0 ) Then 
               aryTmp(0, cntTeam) = 1
               aryTmp(2, cntTeam) = 1
               aryTmp(3, cntTeam) = CStr(rAryUser(4, Idx))
               aryTmp(4, cntTeam) = CStr(rAryUser(5, Idx))
               aryTmp(5, cntTeam) = CStr(rAryUser(6, Idx))
               aryTmp(6, cntTeam) = CStr(rAryUser(7, Idx))

               cntTeam = cntTeam + 1
            End If 
         End If 
      Next

      ' 실제 aryTeam 할당 
      ReDim aryTeam(7, cntTeam-1)
      ub = cntTeam-1
      nAve = nUser / cntTeam                       ' 평균 팀 인원수 체크 
      nHalf = nUser / 2                            ' 인원수 절반 체크 

      nTotal = 0

      For Idx = 0 To ub 
         aryTeam(0, Idx) = 0
         aryTeam(2, Idx) = aryTmp(2, Idx)
         aryTeam(3, Idx) = aryTmp(3, Idx)
         aryTeam(4, Idx) = aryTmp(4, Idx)
         aryTeam(5, Idx) = aryTmp(5, Idx)
         aryTeam(6, Idx) = aryTmp(6, Idx)

         nTotal = nTotal + aryTmp(2, Idx)

         If( aryTeam(2, Idx) > nHalf ) Then      ' Half보다 인원수가 많으면 제일 마지막에 하자.. (2019.06.22 추가)
            aryTeam(1, Idx) = TCNT_HALFOVER              
         ElseIf( aryTeam(2, Idx) > nAve ) Then 	' 평균 보다 팀원이 많으면 선순위로 선수를 등록한다. 
            aryTeam(1, Idx) = TCNT_AVROVER
         Else 								            ' 평균보다 팀원이 적으면 랜덤하게 선수를 등록한다. 
            aryTeam(1, Idx) = TCNT_NORMAL
         End If
      Next

'      strLog = sprintf("cntTeam = {0}, nAve = {1}, nHalf = {2}, nTotal = {3}<br>" , Array(cntTeam, nAve, nHalf, nTotal))
'      response.write strLog 

      duxCreateTeam = aryTeam
   End Function 

'   ===============================================================================     
'      aryTeam Data 중복 체크 , ary, data
'      rAryTeam - fUse, selOrder, cntUser, cTeam , team, cSigun, sigun
'   ===============================================================================
   Function duxCheckTeam(rAryTeam, cTeam)
      Dim Idx, ub, is_duplicate

      is_duplicate = 0
      ub = UBound(rAryTeam, 2)

      For Idx = 0 To ub
         If( rAryTeam(0, Idx) <> 1) Then          ' data의 제일 마지막에 왔다. 
            Exit For
         End If 

         If(rAryTeam(3, Idx) = cTeam) Then        ' Team code가 일치한다. 
            rAryTeam(2, Idx) = rAryTeam(2, Idx) + 1
            is_duplicate = 1
            Exit For
         End If 
      Next

      duxCheckTeam = is_duplicate
   End Function 



'   ===============================================================================     
'        aryUser를 입력받아 Region, Team code를 Key로 하여 배열을 만들어 반환한다. 
'        aryUser를 aryUserA, aryUserB로 나눌때 사용할 팀 정보 배열 
'        aryTeamInfo - fUse, orderRegion, order, cntTeam, cRegion, cTeam
'        aryUser Info -  fUse, gGroupIdx, user, memIdx, cTeam, team, cSido, sido, ...  
'   ===============================================================================
   Function duxCreateTeamInfo(rAryUser)
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

      duxCreateTeamInfo = aryInfo
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
'               strLog = sprintf("SortPart2DimAryEx sPos = {0}, ePos = {1}, ub = {2}, nCnt = {3}, Idx = {4}<br>", Array(sPos, ePos, ub, nCnt, Idx))
'               response.write strLog 
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
'         strLog = sprintf("SortPart2DimAryEx ff sPos = {0}, ePos = {1}, ub = {2}, nCnt = {3}<br>", Array(sPos, ePos, ub, nCnt))
'         response.write strLog 
      End If 

      ' Region , Team Cnt를 적용한 전체 order를 적용한다. 
      For Idx = 0 To ub 
         rARyInfo(1, Idx) = Idx + 1
      Next

   '   Call printInfoEx(rAryInfo, "rAryInfo")
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

'   ===============================================================================     
'      aryPos배열을 2개로 나눈다. 
'   ===============================================================================
   Function duxDivAryPos(rAryPos, nPart)
      Dim Idx, ub, ary, sPos, ePos, nCol, nHalf, m
      ub = UBound(rAryPos, 2)
      nCol = UBound(rAryPos, 1)
      nHalf = ((ub+1) / 2) 

      If(nPart = CON_APART) Then 
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

      duxDivAryPos = ary 
   End Function 

'   ===============================================================================     
'      aryPos배열에 aryPosA, aryPosB를 merge한다. 
'   ===============================================================================
   Function duxMergeAryPos(rAryPos, rAryPart, nPart)
      Dim Idx, ub, ary, sPos, ePos, nCol, nHalf, m
      ub = UBound(rAryPos, 2)
      nCol = UBound(rAryPos, 1)
      nHalf = ((ub+1) / 2) 

      If(nPart = CON_APART) Then 
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
      strLog = sprintf(" ------------------------- {0}  <br>", Array(strTitle))
      response.write strLog

      strInfo = ""

      For Idx = 0 To ul 
         strInfo = sprintf("Idx = {0}, ", Array(Idx))
         For aj = 0 To ul2 
            strInfo = sprintf("{0} ({1} - {2})", Array(strInfo, aj, rAryInfo(aj, Idx)))             
         Next 
         response.write strInfo & "<br>"
      Next

      strLog = sprintf(" ------------------------- {0}  <br>", Array(strTitle))
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
            strLog = sprintf("fUse = {0}, firstSel = {1} , cntUser = {2}, cTeam = {3}, team = {4} , cSigun = {5}, sigun = {6}<br>", _ 
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
            strLog1 = sprintf("Idx = {0}, fUse = {1}, gGroupIdx = {2} , user = {3}, memIdx = {4}", _ 
                  Array(Idx, rAryUser(0,Idx), rAryUser(1,Idx), rAryUser(2,Idx), rAryUser(3,Idx)))
            strLog2 = sprintf("cTeam = {0}, team = {1} , cSido = {2}, sido = {3}", _ 
                  Array(rAryUser(4,Idx), rAryUser(5,Idx), rAryUser(6,Idx), rAryUser(7,Idx)))
            strLog = sprintf("{0} {1}<br>", Array(strLog1, strLog2))                      
            
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
               strLog1 = sprintf("Idx = {0}, fUse = {1}, pos = {2} , playerCode = {3}, cUser1 = {4}, user1 = {5},", _ 
                  Array(Idx+1, rAryPos(0,Idx), rAryPos(1,Idx), rAryPos(2,Idx), rAryPos(3,Idx), userN1))
               strLog2 = sprintf("cUser2 = {0}, user2 = {1} , cTeam1 = {2}, team1 = {3}, cTeam2 = {4},", _ 
                  Array(rAryPos(5,Idx), userN2, rAryPos(7,Idx), teamN1, rAryPos(9,Idx)))
               strLog3 = sprintf("team2 = {0}, cSido1 = {1} , sido1 = {2}, cSido2 = {3}, sido2 = {4}", _ 
                  Array(teamN2, rAryPos(11,Idx), rAryPos(12,Idx), rAryPos(13,Idx), rAryPos(14,Idx)))
               strLog = sprintf("{0} {1} {2} <br>", Array(strLog1, strLog2, strLog3))
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
               strLog1 = sprintf("Idx = {0}, fUse = {1}, pos = {2} , playerCode = {3}, user = {4},", _ 
                  Array(Idx+1, rAryPos(0,Idx), rAryPos(1,Idx), rAryPos(2,Idx), userN1))
               strLog2 = sprintf("cTeam = {0}, team = {1} , cSido = {2}, sido = {3}", _ 
                  Array(rAryPos(4,Idx), teamN1, rAryPos(6,Idx), rAryPos(7,Idx)))
               strLog = sprintf("{0} {1}<br>", Array(strLog1, strLog2))
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

   Function printAryPosWithSysLog_D(rAryPos, IsDoubleGame)
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
               strLog1 = sprintf("Idx = {0}, fUse = {1}, pos = {2} , playerCode = {3}, cUser1 = {4}, user1 = {5},", _ 
                  Array(Idx+1, rAryPos(0,Idx), rAryPos(1,Idx), rAryPos(2,Idx), rAryPos(3,Idx), userN1))
               strLog2 = sprintf("cUser2 = {0}, user2 = {1} , cTeam1 = {2}, team1 = {3}, cTeam2 = {4},", _ 
                  Array(rAryPos(5,Idx), userN2, rAryPos(7,Idx), teamN1, rAryPos(9,Idx)))
               strLog3 = sprintf("team2 = {0}, cSido1 = {1} , sido1 = {2}, cSido2 = {3}, sido2 = {4}", _ 
                  Array(teamN2, rAryPos(11,Idx), rAryPos(12,Idx), rAryPos(13,Idx), rAryPos(14,Idx)))
               strLog = sprintf("{0} {1} {2} <br>", Array(strLog1, strLog2, strLog3))
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
               strLog1 = sprintf("Idx = {0}, fUse = {1}, pos = {2} , playerCode = {3}, user = {4},", _ 
                  Array(Idx+1, rAryPos(0,Idx), rAryPos(1,Idx), rAryPos(2,Idx), userN1))
               strLog2 = sprintf("cTeam = {0}, team = {1} , cSido = {2}, sido = {3}", _ 
                  Array(rAryPos(4,Idx), teamN1, rAryPos(6,Idx), rAryPos(7,Idx)))
               strLog = sprintf("{0} {1}<br>", Array(strLog1, strLog2))
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
      printAryPosWithSysLog_D = strPlayerCode
   End Function 
%>

<%

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
	Function duxSetGamePosDbl(byRef rAryPos, byRef rAryUser, nSelUser, sBlock)
		Dim selPos, Idx, ub, sBase, fLoop, aryBlock, aryTmp, rNum, cntPos
      Dim nSelUser2, fCheckTeam        ' fCheckTeam : Team Code를 Check한다. 

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
      fCheckTeam = 0

      ' sigun을 먼저 체크하고 sigun에서 sBlock이 1이 되어도 넣을 곳이 없다면
      ' team을 체크한다. team에서도 넣을 곳이 없다면 빈곳에 아무 곳이나 insert한다. 
		Do While fLoop
			strBlock = duxCheckTeamInArrayPosDbl(rAryPos, rAryUser, nSelUser, nSelUser2, sBase, fCheckTeam)

			If( strBlock <> "" ) Or ( fCheckTeam = 1 And sBase = 1 )Then 
				fLoop = 0
         ElseIf ( fCheckTeam = 0 And sBase = 1 ) Then 
            sBase = sBlock 
            fCheckTeam = 1
			Else 
				sBase = sBase / 2
			End If			
		Loop

		If( strBlock <> "" ) Then 	' 찾았다.    인원수가 제일 적은 block순으로 배치한다. block size 4 보다 작거나 같은 데서 체크하자 
			aryBlock = split(strBlock, ",")
			ub = UBound(aryBlock) 

         Dim posBlock , minUserCnt , blockUserCnt, m
         posBlock = aryBlock(0)
         minUserCnt = 100
         blockUserCnt = 0

         ' block size 4 보다 작거나 같은 데서 체크하자   좀더 퍼트리자          
         If( sBase > CON_DEFBLOCK ) Then 
            nDiv = sBase / CON_DEFBLOCK
            nSize = (ub+1) * nDiv
            ReDim aryTmp(nSize-1) 
            
            m = 0
            For Idx = 0 To ub 
               For k = 0 To nDiv-1
                  aryTmp(m) = (aryBlock(Idx) * nDiv) + k
                  m = m + 1
               Next 
            Next

            sBase = CON_DEFBLOCK 

            For Idx = 0 To nSize-1 
               blockUserCnt = duxGetUserCntInBlock(aryTmp(Idx), sBase, rAryPos)
               if(minUserCnt > blockUserCnt) Then 
                  minUserCnt = blockUserCnt
                  posBlock = aryTmp(Idx)
               End If 
            Next 
         Else 
            For Idx = 0 To ub 
               blockUserCnt = duxGetUserCntInBlock(aryBlock(Idx), sBase, rAryPos)
               if(minUserCnt > blockUserCnt) Then 
                  minUserCnt = blockUserCnt
                  posBlock = aryBlock(Idx)
               End If 
            Next 
         End If       

'         For Idx = 0 To ub 
'            blockUserCnt = duxGetUserCntInBlock(aryBlock(Idx), sBase, rAryPos)
'            if(minUserCnt > blockUserCnt) Then 
'               minUserCnt = blockUserCnt
'               posBlock = aryBlock(Idx)
'            End If 
'         Next 

			' ex) strBlock = 0,1,2,3,4,5,6,7  넘어오는 값이 이런식이므로 
         '     start position을 구할때 * sBase을 해야 실제 Block start position을 구할수 있다. 
			sPos = posBlock * sBase   
			ePos = sPos + sBase -1

	'		cntPos = sBase - minUserCnt
         cntPos = 0
			For Idx = sPos To ePos		' count를 구한다. 
				If( rAryPos(0, Idx) = 0 ) Then 
					cntPos = cntPos + 1 
				End If
			Next

			rNum2 = GetRandomNum(cntPos) - 1

'		strLog = sprintf("--------------------strBlock = {0} , rNum = {1}, sPos = {2}, ePos = {3}, rNum2 = {4}, cntPos = {5}  <br>", _
'					 Array(strBlock, rNum, sPos, ePos, rNum2, cntPos))
'        Response.Write strLog

			cntPos2 = 0
			selPos = -1
			For Idx = sPos To ePos		' insert position을 random하게 구한다. 
				If( rAryPos(0, Idx) = 0 ) Then 
               If(rNum2 = cntPos2) Then 
					   selPos = Idx
					   Exit For
               Else 
                  cntPos2 = cntPos2 + 1 
				   End If
            End If
			Next
		End If	

      '   -----------------------------------------------------------------------
      '    빈자리를 못찾았으면 아무 빈자리나 넣는다. 
      If (selPos = -1) Then 
         selPos = duxGetPosByRandom(aryPos)
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

'			strLog = sprintf("--------------------strBlock = {0} , rNum = {1}, sPos = {2}, ePos = {3}, rNum2 = {4}, cntPos = {5}  <br>", _
'					 Array(strBlock, rNum, sPos, ePos, rNum2, cntPos))					 
'        	Response.Write strLog
		Else 
'			strLog = "****************** duplicate ..  <br>"					 
'        	Response.Write strLog
		End If

	End Function 

'   ===============================================================================
'     Team 중복 체크 ( block 단위 )  - block 갯수만큼 루프가 동작
'     fCheckTeam = 0 : sigun check , 1 : team check 
'   ===============================================================================
	Function duxCheckTeamInArrayPosDbl(byRef rAryPos, byRef rAryUser, sel1, sel2, sBlock, fCheckTeam)
		Dim strFind, sPos, ePos, nMax, ub, Idx, nPossible

		ub = UBound(rAryPos, 2) 
		nMax = (ub+1) / sBlock             ' block 갯수만큼 루프를 돈다. 
		
		strFind = ""
		sPos = 0

		For Idx = 0 To nMax-1
			nPossible = duxIsPossibleInsertPosDbl(rAryPos, rAryUser, sel1, sel2, sPos, sBlock, fCheckTeam)

			If(nPossible = 1) Then 
				If (strFind = "" ) Then 
					strFind = sprintf("{0}", Array(Idx))
				Else 
					strFind = sprintf("{0},{1}", Array(strFind, Idx))
				End If
			End If

			sPos = sPos + sBlock             ' block 갯수만큼 루프가 동작하므로 , 다음 start position = sPos + sBlock 이다. 
		Next	

		duxCheckTeamInArrayPosDbl = strFind		
	End Function

'   ===============================================================================
'     Team 중복 체크 ( block 단위 )
'     Block 이 꽉 차 있어도 안된다. 
'     UserInfo : fUse, gGroupIdx, user, memIdx, cTeam, team, cSido, sido, ...  
'           복식 : fUse, pos, playerCode(단체코드), cUser1, user1, cUser2, user2, cTeam1, team1, cTeam2, team2, cSido1, sido1, cSido2, sido2
'       fCheckTeam = 0 : sigun check / 1 : team check 
'   ===============================================================================
	Function duxIsPossibleInsertPosDbl(byRef rAryPos, rAryUser, sel1, sel2, sPos, sBlock, fCheckTeam)
		Dim Idx, nPossible , ePos, cntUsed
      Dim cTeam1, cTeam2, cSigun1, cSigun2
      Dim key1, key2, vKey, val1, val2

		nPossible = 1
		cntUsed = 0
		ePos = (sPos + sBlock) - 1

      If( fCheckTeam = 1 ) Then                 ' 팀을 체크한다. 
         key1 = 7             ' team1  in aryPos
         key2 = 9             ' team2  in aryPos
         vKey = 4             ' team in aryUser
      Else 
         key1 = 11            ' sido1  in aryPos
         key2 = 13            ' sido2  in aryPos
         vKey = 6             ' sido in aryUser
      End If 

      val1 = rAryUser(vKey, sel1)
      val2 = rAryUser(vKey, sel2)

      For Idx = sPos To ePos
         If( rAryPos(0, Idx) = 1 ) Then    ' Player가 배치 된 곳에서만 비교를 한다. 
            ' 복식이므로 cTeam or cSido 가 2개 있다. 
            If( rAryPos(key1, Idx) = val1 ) Or (rAryPos(key1, Idx) = val2 ) Or _ 
               ( rAryPos(key2, Idx) = val1 ) Or (rAryPos(key2, Idx) = val2 ) Then 
               nPossible = 0		 						' 같은 Team or sido 가 있다. 
               Exit For 
            End If

            cntUsed = cntUsed + 1
         End If
      Next

      ' 다 사용중 ( 할당할수 없다.) - 해당 Block내에 빈 공간이 없다. 
		If( cntUsed = sBlock ) Then nPossible = 0 End If			


		duxIsPossibleInsertPosDbl = nPossible		
	End Function

'   ===============================================================================
'     Get Random Position : 빈자리중 랜덤하게 한자리를 찾는다. 
'   ===============================================================================
	Function duxGetPosByRandom(byRef rAryPos)
		Dim strFind, Idx, ub, nCnt, rNum, nSelPos

		ub = UBound(rAryPos, 2) 
		nCnt = 0

      ' 빈자리 (rAryPos(0,Idx) = 0)의 갯수를 Count
		For Idx = 0 To ub
			If(rAryPos(0,Idx) <> 1) Then nCnt = nCnt+1 End If                
		Next	

      rNum = GetRandomNum(nCnt) - 1

      nCnt = 0
      nSelPos = 0
      For Idx = 0 To ub
         If(rAryPos(0,Idx) <> 1) Then 
            If(rNum = nCnt) Then 
               nSelPos = Idx
               Exit For
            Else 
               nCnt = nCnt+1
            End If
         End If
		Next	
		duxGetPosByRandom = nSelPos		
	End Function
%>

<%

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
	Function duxSetGamePos(byRef rAryPos, byRef rAryUser, nSelUser, sBlock)
		Dim selPos, Idx, ub, sBase, fLoop, aryBlock, aryTmp, rNum, cntPos, fCheckTeam

		sBase = sBlock 
		fLoop = 1
      fCheckTeam = 0

      ' sigun을 먼저 체크하고 sigun에서 sBlock이 1이 되어도 넣을 곳이 없다면
      ' team을 체크한다. team에서도 넣을 곳이 없다면 빈곳에 아무 곳이나 insert한다. 
		Do While fLoop
			strBlock = duxCheckTeamInArrayPos(rAryPos, rAryUser, nSelUser, sBase, fCheckTeam)

			If( strBlock <> "" ) Or ( fCheckTeam = 1 And sBase = 1 )Then 
				fLoop = 0
         ElseIf ( fCheckTeam = 0 And sBase = 1 ) Then 
            sBase = sBlock 
            fCheckTeam = 1
			Else 
				sBase = sBase / 2
			End If			
		Loop

		If( strBlock <> "" ) Then 	' 찾았다.    인원수가 제일 적은 block순으로 배치한다. 
			aryBlock = split(strBlock, ",")
			ub = UBound(aryBlock) 

         Dim posBlock , minUserCnt , blockUserCnt, m
         posBlock = aryBlock(0)
         minUserCnt = 100
         blockUserCnt = 0

         ' block size 4 보다 작거나 같은 데서 체크하자   좀더 퍼트리자          
         If( sBase > CON_DEFBLOCK ) Then 
            nDiv = sBase / CON_DEFBLOCK
            nSize = (ub+1) * nDiv
            ReDim aryTmp(nSize-1) 
            
            m = 0
            For Idx = 0 To ub 
               For k = 0 To nDiv-1
                  aryTmp(m) = (aryBlock(Idx) * nDiv) + k
                  m = m + 1
               Next 
            Next

            sBase = CON_DEFBLOCK 

            For Idx = 0 To nSize-1 
               blockUserCnt = duxGetUserCntInBlock(aryTmp(Idx), sBase, rAryPos)
               if(minUserCnt > blockUserCnt) Then 
                  minUserCnt = blockUserCnt
                  posBlock = aryTmp(Idx)
               End If 
            Next 
         Else 
            For Idx = 0 To ub 
               blockUserCnt = duxGetUserCntInBlock(aryBlock(Idx), sBase, rAryPos)
               if(minUserCnt > blockUserCnt) Then 
                  minUserCnt = blockUserCnt
                  posBlock = aryBlock(Idx)
               End If 
            Next 
         End If 

'         For Idx = 0 To ub 
'            blockUserCnt = duxGetUserCntInBlock(aryBlock(Idx), sBase, rAryPos)
'            if(minUserCnt > blockUserCnt) Then 
'               minUserCnt = blockUserCnt
'               posBlock = aryBlock(Idx)
'            End If 
'         Next 

         ' ex) strBlock = 0,1,2,3,4,5,6,7  넘어오는 값이 이런식이므로 
         '     start position을 구할때 * sBase을 해야 실제 Block start position을 구할수 있다. 
			sPos = posBlock * sBase
			ePos = sPos + sBase -1

      '   cntPos = sBase - minUserCnt
			cntPos = 0
			For Idx = sPos To ePos		' count를 구한다. 
				If( rAryPos(0, Idx) = 0 ) Then 
					cntPos = cntPos + 1 
				End If
			Next

			rNum2 = GetRandomNum(cntPos) - 1

'		strLog = sprintf("--------------------strBlock = {0} , rNum = {1}, sPos = {2}, ePos = {3}, rNum2 = {4}, cntPos = {5}  <br>", _
'					 Array(strBlock, rNum, sPos, ePos, rNum2, cntPos))
'        Response.Write strLog

			cntPos2 = 0
			selPos = -1
			For Idx = sPos To ePos		' insert position을 random하게 구한다. 
				If( rAryPos(0, Idx) = 0 ) Then 
               If(rNum2 = cntPos2) Then 
                  selPos = Idx
                  Exit For
               Else 
                  cntPos2 = cntPos2 + 1 
               End If
            End If 
			Next
		End If	

        '   -----------------------------------------------------------------------
        '    빈자리를 못찾았으면 아무 빈자리나 넣는다. 
        If (selPos = -1) Then 
            selPos = duxGetPosByRandom(aryPos)
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

'			strLog = sprintf("--------------------strBlock = {0} , rNum = {1}, sPos = {2}, ePos = {3}, rNum2 = {4}, cntPos = {5}  <br>", _
'					 Array(strBlock, rNum, sPos, ePos, rNum2, cntPos))					 
'        	Response.Write strLog
		Else 
'			strLog = "****************** duplicate ..  <br>"					 
'        	Response.Write strLog
		End If

	End Function


'   ===============================================================================
'     Team 중복 체크 ( block 단위 )  - block 갯수만큼 루프가 동작
'       fCheckTeam = 0 : sigun check / 1 : team check 
'   ===============================================================================
	Function duxCheckTeamInArrayPos(byRef rAryPos, byRef rAryUser, sel1, sBlock, fCheckTeam)
		Dim strFind, sPos, ePos, nMax, ub, Idx, nPossible

		ub = UBound(rAryPos, 2) 
		nMax = (ub+1) / sBlock       ' block 갯수만큼 루프를 돈다. 
		
		strFind = ""
		sPos = 0

		For Idx = 0 To nMax-1
			nPossible = duxIsPossibleInsertPos(rAryPos, rAryUser, sel1, sPos, sBlock, fCheckTeam)

			If(nPossible = 1) Then 
				If (strFind = "" ) Then 
					strFind = sprintf("{0}", Array(Idx))
				Else 
					strFind = sprintf("{0},{1}", Array(strFind, Idx))
				End If
			End If

			sPos = sPos + sBlock          ' block 갯수만큼 루프가 동작하므로 , 다음 start position = sPos + sBlock 이다.
		Next	

		duxCheckTeamInArrayPos = strFind		
	End Function

'   ===============================================================================
'     Team 중복 체크 ( block 단위 )
'     Block 이 꽉 차 있어도 안된다. 
'       UserInfo : fUse, gGroupIdx, user, memIdx, cTeam, team, cSido, sido, ...  
'       Pos 단식 : fUse, pos, playerCode(memIdx), user, cTeam, team , cSido, sido
'       fCheckTeam = 0 : sigun check / 1 : team check 
'   ===============================================================================
	Function duxIsPossibleInsertPos(byRef rAryPos, rAryUser, sel, sPos, sBlock, fCheckTeam)
		Dim Idx, nPossible , ePos, cntUsed      
      Dim key, vKey, val 

		nPossible = 1
		cntUsed = 0
		ePos = (sPos + sBlock) - 1

      If( fCheckTeam = 1 ) Then               ' 팀을 체크한다. 
         key = 4
         vKey = 4
      Else 
         key = 6
         vKey = 6
      End If 

      val = rAryUser(vKey, sel)  
      For Idx = sPos To ePos
         If( rAryPos(0, Idx) = 1 ) Then  
            If( rAryPos(key, Idx) = val ) Then 
               nPossible = 0		 						' 같은 팀이 있다.  
               Exit For 
            End If
            cntUsed = cntUsed + 1
         End If
      Next

      ' 다 사용중 ( 할당할수 없다.) - 해당 Block내에 빈 공간이 없다. 
		If( cntUsed = sBlock ) Then nPossible = 0 End If			


'		strLog = sprintf("cntUsed = {0} , nPossible = {1} <br>", Array(cntUsed, nPossible))
'        Response.Write strLog

		duxIsPossibleInsertPos = nPossible		
	End Function  
%>