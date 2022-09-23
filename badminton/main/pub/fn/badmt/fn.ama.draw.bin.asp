<% 
'   ===============================================================================     
'    Purpose : 생활체육 대진표를 작성한다. 
'    Make    : 2020.01.31
'    Author  :                                                       By Aramdry
'   ===============================================================================    
%> 


<% 
'   ===============================================================================     
'     ary position  - 
'      fUse : user 할당 유무 
'      pos_kind : position 종류 - normal, bye
'      pos_val   : normal - -1(사용안함) , bye position val (1, 2, 3)
'
'     복식 : fUse, pos, pos_kind, pos_val, playerCode(gGroupIdx), teamNo, rgnNo, cUser1, user1, cUser2, user2, cTeam1, team1, cTeam2, team2, cRegion1, region1, cRegion2, region2
'             0,    1 ,   2     ,    3   ,    4                 ,    5  ,   6  ,   7  ,   8  ,    9  ,   10 ,   11  ,   12  ,  13   ,   14 ,    15   ,    16,      17   ,    18       
'     단식 : fUse, pos, pos_kind, pos_val, playerCode(gGroupIdx), teamNo, rgnNo, cUser, user, cTeam, team, cRegion, region 
'              0 ,  1 ,    2    ,    3   ,    4                 ,   5   ,   6 ,   7  ,   8 ,   9   ,  10 ,   11   ,   12
'     ary user : fUse, Idx, TeamNo, RgnNo, PIdx,  MemberIDX, MemberName, Team, TeamNm, Region, RegionNm, GameRequestGroupIDX, GameRequestPlayerIDX, CntRegion, CntTeam
'						 0 ,  1 ,   2   ,   3  ,   4,      5     ,      6   ,   7 ,    8  ,    9  ,    10   ,        11          ,      12             ,     13   ,    14
'   ===============================================================================   

%>

<% 	  
'   ===============================================================================     
' 		공통	일단 본선을 4 Part로 나눈다.  (A, B, C, D)     - (Round / 2) / 2
' 			
' 			전체인원수 : nTotal , 토너먼트 인원수 : nRound, Bye 수 : nBye
' 			
' 			If( nTotal < nRound) nBye가 존재      : 전체 인원이 Tournament보다 작으면 Bye가 있다. 

' 		Bye 배치	
' 			1. Bye는 nRound에 따라 그 갯수만큼 특정 자리가 정해져 있다. 
'  			
' 		본선 배치	본선은 토너먼트를 4개로 나눈 A, B, C, D Part로 나눈 후 각각의 Block에서 배치를 진행한다. 
' 			
' 		인원할당	본선 인원을 A, B, C, D 각각의 Block에 거의 균일하게 나눈다. 

' 		인원할당 룰 	
'			1. aryUser데이터는 인원수로 정렬되어 있다. (지역별/클럽별)
' 			2. Loop를 돌면서 User를 한명씩 분배한다.
' 			
' 		인원배치 - aryPos	
' 			4개의 Part에 (지역별/클럽별) 인원수 순으로 user가 할당되었다. 
' 			이과정에서 1차적으로 인원의 분산 배치가 이루어 진다. 
' 			
' 			이제 각 Part별로 인원을 (지역별/클럽별) 선택하여 대진표에 배치한다. 
' 			
' 		인원배치 룰 	각 Part에 할당된 User를 Binary Search 방식으로 배치한다. 
' 			1. 인원을 순차적으로 할당한다. 
' 			
' 			1. User를 한명 선택한다.
' 			2. 선택된 User의 teamNo, rgnNo을 추출한다.
' 			3. 해당 Part를 전체로 잡고 half로 나눈다. (A1, B1 Part)
' 			4. 각각의 Block에서 teamNo과 일치하는 User의 Count를 구한다.    nSameTeam
' 			5. 각각의 Block에서 rgnNo과 일치하는 User의 Count를 구한다.    nSameRgn
' 			5. 각 Block에 할당된 user Count를 구한다.    nAssignUser
' 			6. nSameRgn의 값이 제일 적은 팀 리스트를 구한다.  
' 			7. 이중 nSameTeam 값이 제일 적은 팀에 할당한다. 
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
'   ===============================================================================    
%>

<!-- #include virtual = "/pub/fn/badmt/res/res.pos.asp" -->  

<% 	  
'   ===============================================================================     
'     define variable
'   ===============================================================================   
	Dim E_POS_NORMAL, E_POS_BYE								' pos_kind : position 종류 - normal, Bye 
   Dim E_PART_A, E_PART_B, E_PART_C, E_PART_D, E_HALF_A, E_HALF_B, E_PART_ALL
   Dim CON_POSCOL_CNT_S, CON_POSCOL_CNT_D            	'  aryPos - column count 
   Dim CON_POSVAL_NOUSE, CON_PLAYERCODE_EMPTY, SZ_BLOCK_MIN 	
	Dim cntSelfCall , maxSelfCall, setRegionUser

	maxSelfCall 				= 10
	cntSelfCall					= 0
	setRegionUser				= false

	CON_POSCOL_CNT_S        = 13          ' aryPos - 단식 column count
   CON_POSCOL_CNT_D        = 19          ' aryPos - 복식 column count
   
   CON_POSVAL_NOUSE        = -1              ' Position val 사용안함. 
   CON_PLAYERCODE_EMPTY    = "-1"              ' bye Player Code
   
   E_POS_NORMAL            = 0               ' 일반 자리    
   E_POS_BYE               = 1               ' Bye 자리 

   E_PART_A                = 0               ' A Part
   E_PART_B                = 1               ' B Part
   E_PART_C                = 2               ' C Part
   E_PART_D                = 3               ' D Part   
   E_HALF_A                = 4               ' HALF A Part
   E_HALF_B                = 5               ' HALF B Part
   E_PART_ALL              = 6               ' All part

	SZ_BLOCK_MIN	= 2					' block 최소 size - 이거보다 작으면 서치를 하지 않는다. 
%>

<% 	  
'   ===============================================================================     
'     util function 
'   ===============================================================================  

'   ===============================================================================     
'      참여인원을 입력받아 Tonament Round를 계산한다. 
'   =============================================================================== 
	Function GetTournamentRound(cntUser)
		Dim base, tRound,cnt, fLoop, nMax 
		cnt = Cdbl(cntUser)
		
		tRound = 1
		base = 2
		fLoop = 1        

		' error check : 참여 인원이 2명 이하거나 256 보다 크면 토너먼트가 성립하지 않는다. 
		If (cnt < 2 Or cnt > 256) Then 
				GetTournamentRound = tRound
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
		GetTournamentRound = tRound		
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
'      aryPos에서 sIdx, eIdx사이에 있는 Bye Count를 구한다. 
'   ===============================================================================
	Function getByeCountInBlock(rAryPos, sIdx, eIdx)
		Dim ub, Idx, cntBye 

		ub = UBound(rAryPos, 2)
		cntBye = 0

		If(sIdx < 0) Then sIdx = 0 End If 
		If(eIdx > ub) Then eIdx = ub End If 

		For Idx = sIdx To eIdx 
			If(rAryPos(2, Idx) = E_POS_BYE) Then        ' Bye가 있다.. 
				cntBye = cntBye + 1
			End If 
		Next 		

		getByeCountInBlock = cntBye 
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
'      aryPos에서 sIdx, eIdx사이에 있는 Region Count를 구한다. 
'   ===============================================================================
	Function getRgnCountInBlock(rAryPos, rNo, sIdx, eIdx)
		Dim ub, Idx, cntRgn , rgnNo

		ub = UBound(rAryPos, 2)
		cntRgn = 0

		If(sIdx < 0) Then sIdx = 0 End If 
		If(eIdx > ub) Then eIdx = ub End If 

		For Idx = sIdx To eIdx 
         rgnNo = CDbl(rAryPos(6, Idx))
			If(rgnNo = rNo) Then        ' 같은 지역이 있다. 
				cntRgn = cntRgn + 1
			End If 
		Next 		

		getRgnCountInBlock = cntRgn 
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
				If(rAryPos(2, Idx) <> E_POS_BYE) Then     ' Bye가 아니면 Player 할당이다. 
					cntAssign = cntAssign + 1
				End If 
			End If 
		Next 		

		getAssignCountInBlock = cntAssign 
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
'      aryPos에서 sIdx, eIdx사이에 있는 Empty Count를 구한다. 
' 		 파트너에 같은 팀이 없다면 빈공간으로 인정. / 아니면 풀     
'   ===============================================================================
	Function getEmptyCountInBlock(rAryPos, tNo, sIdx, eIdx)
		Dim ub, Idx, pos2, cntEmpty , teamNo, posKind

		ub = UBound(rAryPos, 2)
		cntEmpty = 0

		If(sIdx < 0) Then sIdx = 0 End If 
		If(eIdx > ub) Then eIdx = ub End If 
															' sameTeam 이 없는곳 구한다. 
		For Idx = sIdx To eIdx 
			If(rAryPos(0, Idx) <> "1") Then        ' Empty갯수 
				pos2 = GetPartnerIdx(Idx)				' aryPos에서 파트너 포지션을 구한다. 
				teamNo = CDbl(rAryPos(5, pos2))
				
				If(teamNo <> tNo) Then        ' 파트너에 같은 팀이 없다면 빈공간으로 인정. / 아니면 풀
					cntEmpty = cntEmpty + 1
				End If 
			End If 
		Next 		
		
		getEmptyCountInBlock = cntEmpty 
	End Function 

'   ===============================================================================     
'      aryPos에서 sIdx, eIdx사이에 있는 Empty Count를 구한다. 
' 		 파트너에 같은 팀이 없다면 빈공간으로 인정. / 아니면 풀     
'   ===============================================================================
	Function getEmptyCountInBlockRegion(rAryPos, rNo, sIdx, eIdx)
		Dim ub, Idx, pos2, cntEmpty , regionNo

		ub = UBound(rAryPos, 2)
		cntEmpty = 0

		If(sIdx < 0) Then sIdx = 0 End If 
		If(eIdx > ub) Then eIdx = ub End If 
															' sameTeam 이 없는곳 구한다. 
		For Idx = sIdx To eIdx 
			If(rAryPos(0, Idx) <> "1") Then        ' Empty갯수 
				pos2 = GetPartnerIdx(Idx)				' aryPos에서 파트너 포지션을 구한다. 
				regionNo = CDbl(rAryPos(6, pos2))
				
				If(regionNo <> rNo) Then        ' 파트너에 같은 지역이 없다면 빈공간으로 인정. / 아니면 풀
					cntEmpty = cntEmpty + 1
				End If 
			End If 
		Next 		
		
		getEmptyCountInBlockRegion = cntEmpty 
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
         ary(5, Idx) = 0                        ' teamNo : 0
			ary(6, Idx) = 0                        ' RegionNo : 0
      Next

      GetPosArray = ary
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
'      rAryBye(0) = cntBye  - aryBye의 처음값은 bye갯수이다. 
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
'      aryPos배열에 aryPosA, aryPosB를 merge한다. 
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
%>

<%
'   ===============================================================================     
'      Algorithm - 할당 
'   =============================================================================== 
	
%>

<%
'   ===============================================================================     
'      단식 
'   =============================================================================== 
	
'   ===============================================================================     
' 		인원배치 룰 	각 Part에 할당된 User를 Binary Search 방식으로 배치한다. 
' 			1. 인원을 순차적으로 할당한다. 

'			1. 지역만 가지고 유저의 중복을 찾아서 할당한다. 
'			2. 지역만으로 할당을 못한 사용자에 한하여 지역, 팀을 가지고 중복을 찾아서 할당한다. 
' 			
' 			1. User를 한명 선택한다.
' 			2. 선택된 User의 teamNo, rgnNo을 추출한다.
' 			3. 해당 Part를 전체로 잡고 half로 나눈다. (A1, B1 Part)
' 			4. 각각의 Block에서 teamNo과 일치하는 User의 Count를 구한다.    nSameTeam
' 			5. 각각의 Block에서 rgnNo과 일치하는 User의 Count를 구한다.    nSameRgn
' 			5. 각 Block에 할당된 user Count를 구한다.    nAssignUser
' 			6. nSameRgn의 값이 제일 적은 팀 리스트를 구한다.  
' 			7. 이중 nSameTeam 값이 제일 적은 팀에 할당한다. 
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
'   =============================================================================== 
	Function SetUserToPos(rAryPos, rAryUser)
		Dim ub, ubP, Idx
		
		ub = UBound(rAryUser, 2)
		ubP = UBound(rAryPos, 2)
		
		For Idx = 0 To ub 
			cntSelfCall	= 0     
			setRegionUser = false

			strLog = sprintf("-----------SetUserToPos user Idx = {0}, name = {1}({2})", Array(idx, rAryUser(6, Idx), rAryUser(8, Idx)) )
			' ' Call TraceLog(SPORTS_LOG1, strLog) 
			Call binSetUserToPos(rAryPos, rAryUser, Idx, 0, ubP)

			Call binSetUserToPosRegion(rAryPos, rAryUser, Idx, 0, ubP)
			If(setRegionUser = false) Then 
				cntSelfCall	= 0   
				Call binSetUserToPos(rAryPos, rAryUser, Idx, 0, ubP)
			End If 	
		Next 

	End Function 

'   ===============================================================================     
'      재귀 호출 .. 
'      block size <= 4일때 까지 혹은 teamNo가 0인 block을 만날때 까지 
'      block을 2개의 부분으로 나눈후 각각의 Block의 position value를 체크한다. 

' 		 각각의 Block에서 RegionNo과 일치하는 User의 Count를 구한다.    nSameRegion
' 		 각각의 Block에서 teamNo과 일치하는 User의 Count를 구한다.    nSameTeam
' 		 각 Block에 할당된 user Count를 구한다.    nAssignUser
'		 각 Block에 할당할수 있는 빈 공간 갯수를 구한다. nEmtpy 
'   =============================================================================== 
	Function binSetUserToPosRegion(rAryPos, rAryUser, uIdx, sp, ep)
		Dim Idx, ub
		Dim sp1, sp2, ep1, ep2, half, szBlock, regionNo
		Dim cntUser1, cntUser2, cntEmpty1, cntEmpty2, cntRgn1, cntRgn2

		szBlock = (ep - sp) + 1
		half = szBlock / 2

		strLog = sprintf("binSetUserToPosRegion uIdx = {0}, name = {1}({2}), sp = {3}, ep = {4}, szBlock = {5}, half = {6}, cntSelfCall = {7} ", _ 
									 Array(uIdx, rAryUser(6, uIdx), rAryUser(8, uIdx), sp, ep, szBlock, half, cntSelfCall) )
      ' ' Call TraceLog(SPORTS_LOG1, strLog) 

		If(szBlock <= SZ_BLOCK_MIN) Then 			' block size가 최소다.  그냥 Random하게 배치하자 
			setRegionUser = false
			Exit Function 
		End If 

		If(cntSelfCall >= maxSelfCall) Then 	' 재귀 호출이 maxCount를 넘었다. 이만 끝내자 
			setRegionUser = false
			Exit Function 
		End If 
		cntSelfCall = cntSelfCall + 1				' 재귀 호출 제어 카운트 
		
		sp1 = sp 
		ep1 = (sp + half) - 1
		sp2 = ep1 + 1 
		ep2 = ep 
		
		regionNo 	= CDbl(rAryUser(3, uIdx))

		' ---------------------------------------------------------------		
		cntUser1 	= getAssignCountInBlock(rAryPos, sp1, ep1)
		cntEmpty1 	= getEmptyCountInBlockRegion(rAryPos, regionNo, sp1, ep1)
		cntRgn1 		= getRgnCountInBlock(rAryPos, regionNo, sp1, ep1)

		cntUser2 	= getAssignCountInBlock(rAryPos, sp2, ep2)
		cntEmpty2 	= getEmptyCountInBlockRegion(rAryPos, regionNo, sp2, ep2)
		cntRgn2 		= getRgnCountInBlock(rAryPos, regionNo, sp2, ep2)
		' ---------------------------------------------------------------

		strLog = sprintf("binSetUserToPosRegion sp1 = {0}, ep1 = {1}, sp2 = {2}, ep2 = {3}, teamNo = {4}, regionNo = {5} ", _ 
									 Array(sp1, ep1, sp2, ep2, teamNo, regionNo) )
      ' ' Call TraceLog(SPORTS_LOG1, strLog) 

		strLog = sprintf("binSetUserToPosRegion cntUser1 = {0}, cntEmpty1 = {1}, cntTeam1 = {2}, cntRgn1 = {3} // cntUser2 = {4}, cntEmpty2 = {5}, cntTeam2 = {6}, cntRgn2 = {7} ", _ 
									 Array(cntUser1, cntEmpty1, cntTeam1, cntRgn1, cntUser2, cntEmpty2, cntTeam2, cntRgn2) )
      ' ' Call TraceLog(SPORTS_LOG1, strLog) 

		If( cntEmpty1 = 0 And cntEmpty2 = 0) Then 				' 빈공간이 없다.  그냥 Random하게 배치하자 
			setRegionUser = false
			Exit Function 
		ElseIf( cntEmpty1 = 0 Or cntEmpty2 = 0) Then 
			If(cntEmpty1 = 0) Then 				' A Part에 빈공간이 없다. B쪽을 찾자 
				If(cntRgn2 = 0) Then 
					' ' Call TraceLog(SPORTS_LOG1, "procSetUserToPos - 찾았다. 여기에 배치하자  ccntEmpty1 = 0 cntRgn2 = 0  #1") 	
					Call procSetUserToPos(rAryPos, rAryUser, uIdx, sp2, ep2)
					setRegionUser = true
				Else 
					Call binSetUserToPosRegion(rAryPos, rAryUser, uIdx, sp2, ep2)
				End If 
			Else										' B Part에 빈공간이 없다. A쪽을 찾자 
				If(cntRgn1 = 0) Then 
					' ' Call TraceLog(SPORTS_LOG1, "procSetUserToPos - 찾았다. 여기에 배치하자  cntEmpty2 = 0 cntRgn1 = 0 #3") 	
					Call procSetUserToPos(rAryPos, rAryUser, uIdx, sp1, ep1)
					setRegionUser = true
				Else 
					Call binSetUserToPosRegion(rAryPos, rAryUser, uIdx, sp1, ep1)						
				End If 				
			End If 
		Else 
			If(cntRgn1 <> 0) And (cntRgn2 <> 0) Then 		' 배치된 Same region Count Check 
				If(cntRgn1 > cntRgn2) Then 					' 배치된 User Count Check 
					Call binSetUserToPosRegion(rAryPos, rAryUser, uIdx, sp2, ep2)
				Else 
					Call binSetUserToPosRegion(rAryPos, rAryUser, uIdx, sp1, ep1)
				End If 
			Else 			' 찾았다. 여기에 배치하자 				
				If(cntRgn1 = 0) And (cntRgn2 = 0) Then 
					If(cntUser1 > cntUser2) Then 					' 배치된 User Count Check 
						' ' Call TraceLog(SPORTS_LOG1, "procSetUserToPos - 찾았다. 여기에 배치하자  cntRgn1,2 = 0 cntUser1 > cntUser2 #9") 			 
						Call procSetUserToPos(rAryPos, rAryUser, uIdx, sp2, ep2)
						setRegionUser = true
					Else 
						' ' Call TraceLog(SPORTS_LOG1, "procSetUserToPos - 찾았다. 여기에 배치하자  cntRgn1,2 = 0 cntUser1 <= cntUser2 #10") 			 
						Call procSetUserToPos(rAryPos, rAryUser, uIdx, sp1, ep1)
						setRegionUser = true
					End If 
				Else
					If(cntRgn1 = 0) Then 
						' ' Call TraceLog(SPORTS_LOG1, "procSetUserToPos - 찾았다. 여기에 배치하자  cntRgn1 = 0  #11") 			 
						Call procSetUserToPos(rAryPos, rAryUser, uIdx, sp1, ep1)
						setRegionUser = true
					Else 
						' ' Call TraceLog(SPORTS_LOG1, "procSetUserToPos - 찾았다. 여기에 배치하자  cntRgn2 = 0  #12") 	
						Call procSetUserToPos(rAryPos, rAryUser, uIdx, sp2, ep2)
						setRegionUser = true
					End If 
				End If 
			End If 
		End If 

	End Function 

'   ===============================================================================     
'      재귀 호출 .. 
'      block size <= 4일때 까지 혹은 teamNo가 0인 block을 만날때 까지 
'      block을 2개의 부분으로 나눈후 각각의 Block의 position value를 체크한다. 

' 		 각각의 Block에서 RegionNo과 일치하는 User의 Count를 구한다.    nSameRegion
' 		 각각의 Block에서 teamNo과 일치하는 User의 Count를 구한다.    nSameTeam
' 		 각 Block에 할당된 user Count를 구한다.    nAssignUser
'		 각 Block에 할당할수 있는 빈 공간 갯수를 구한다. nEmtpy 
'   =============================================================================== 
	Function binSetUserToPos(rAryPos, rAryUser, uIdx, sp, ep)
		Dim Idx, ub
		Dim sp1, sp2, ep1, ep2, half, szBlock
		Dim teamNo, regionNo
		Dim cntUser1, cntUser2, cntEmpty1, cntEmpty2, cntTeam1, cntTeam2, cntRgn1, cntRgn2

		szBlock = (ep - sp) + 1
		half = szBlock / 2

		strLog = sprintf("binSetUserToPos uIdx = {0}, name = {1}({2}), sp = {3}, ep = {4}, szBlock = {5}, half = {6}, cntSelfCall = {7} ", _ 
									 Array(uIdx, rAryUser(6, uIdx), rAryUser(8, uIdx), sp, ep, szBlock, half, cntSelfCall) )
      ' ' Call TraceLog(SPORTS_LOG1, strLog) 

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

		teamNo 		= CDbl(rAryUser(2, uIdx))
		regionNo 	= CDbl(rAryUser(3, uIdx))

		' ---------------------------------------------------------------		
		cntUser1 	= getAssignCountInBlock(rAryPos, sp1, ep1)
		cntEmpty1 	= getEmptyCountInBlock(rAryPos, teamNo, sp1, ep1)
		cntTeam1 	= getTeamCountInBlock(rAryPos, teamNo, sp1, ep1)
		cntRgn1 		= getRgnCountInBlock(rAryPos, regionNo, sp1, ep1)

		cntUser2 	= getAssignCountInBlock(rAryPos, sp2, ep2)
		cntEmpty2 	= getEmptyCountInBlock(rAryPos, teamNo, sp2, ep2)
		cntTeam2 	= getTeamCountInBlock(rAryPos, teamNo, sp2, ep2)
		cntRgn2 		= getRgnCountInBlock(rAryPos, regionNo, sp2, ep2)
		' ---------------------------------------------------------------

		strLog = sprintf("binSetUserToPos sp1 = {0}, ep1 = {1}, sp2 = {2}, ep2 = {3}, teamNo = {4}, regionNo = {5} ", _ 
									 Array(sp1, ep1, sp2, ep2, teamNo, regionNo) )
      ' ' Call TraceLog(SPORTS_LOG1, strLog) 

		strLog = sprintf("binSetUserToPos cntUser1 = {0}, cntEmpty1 = {1}, cntTeam1 = {2}, cntRgn1 = {3} // cntUser2 = {4}, cntEmpty2 = {5}, cntTeam2 = {6}, cntRgn2 = {7} ", _ 
									 Array(cntUser1, cntEmpty1, cntTeam1, cntRgn1, cntUser2, cntEmpty2, cntTeam2, cntRgn2) )
      ' ' Call TraceLog(SPORTS_LOG1, strLog) 

		If( cntEmpty1 = 0 And cntEmpty2 = 0) Then 				' 빈공간이 없다.  그냥 Random하게 배치하자 
			' ' Call TraceLog(SPORTS_LOG1, "randomSetUserToPos - 빈공간이 없다.  그냥 Random하게 배치하자   ") 
			Call randomSetUserToPos(rAryPos, rAryUser, uIdx)
			Exit Function 
		ElseIf( cntEmpty1 = 0 Or cntEmpty2 = 0) Then 
			If(cntEmpty1 = 0) Then 				' A Part에 빈공간이 없다. B쪽을 찾자 
				If(cntRgn2 = 0) Then 
					' ' Call TraceLog(SPORTS_LOG1, "procSetUserToPos - 찾았다. 여기에 배치하자  ccntEmpty1 = 0 cntRgn2 = 0  #1") 	
					Call procSetUserToPos(rAryPos, rAryUser, uIdx, sp2, ep2)
				Else 
					If(cntTeam2 = 0) Then 
						' ' Call TraceLog(SPORTS_LOG1, "procSetUserToPos - 찾았다. 여기에 배치하자  ccntEmpty1 = 0 cntTeam2 = 0  #2") 	
						Call procSetUserToPos(rAryPos, rAryUser, uIdx, sp2, ep2)
					Else 
						Call binSetUserToPos(rAryPos, rAryUser, uIdx, sp2, ep2)
					End If 
				End If 
			Else										' B Part에 빈공간이 없다. A쪽을 찾자 
				If(cntRgn1 = 0) Then 
					' ' Call TraceLog(SPORTS_LOG1, "procSetUserToPos - 찾았다. 여기에 배치하자  cntEmpty2 = 0 cntRgn1 = 0 #3") 	
					Call procSetUserToPos(rAryPos, rAryUser, uIdx, sp1, ep1)
				Else 
					IF(cntTeam1 = 0) Then 
						' ' Call TraceLog(SPORTS_LOG1, "procSetUserToPos - 찾았다. 여기에 배치하자  cntEmpty2 = 0 cntTeam1 = 0 #4") 	
						Call procSetUserToPos(rAryPos, rAryUser, uIdx, sp1, ep1)
					Else 
						Call binSetUserToPos(rAryPos, rAryUser, uIdx, sp1, ep1)
					End If 						
				End If 				
			End If 
		Else 
			If(cntRgn1 <> 0) And (cntRgn2 <> 0) Then 		' 배치된 Same region Count Check 
				If(cntTeam1 <> 0) And (cntTeam2 <> 0) Then 		' team count check 
					If(cntTeam1 > cntTeam2) Then 
						Call binSetUserToPos(rAryPos, rAryUser, uIdx, sp2, ep2)
					ElseIf(cntTeam1 < cntTeam2) Then  
						Call binSetUserToPos(rAryPos, rAryUser, uIdx, sp1, ep1)
					Else 
						If(cntUser1 > cntUser2) Then 					' 배치된 User Count Check 
							Call binSetUserToPos(rAryPos, rAryUser, uIdx, sp2, ep2)
						Else 
							Call binSetUserToPos(rAryPos, rAryUser, uIdx, sp1, ep1)
						End If 
					End If 
				Else 
					If(cntTeam1 = 0) And (cntTeam2 = 0) Then 
						If(cntUser1 > cntUser2) Then 					' 배치된 User Count Check 
							' ' Call TraceLog(SPORTS_LOG1, "procSetUserToPos - 찾았다. 여기에 배치하자  cntTeam1,2 = 0 cntUser1 > cntUser2 #5") 			 
							Call procSetUserToPos(rAryPos, rAryUser, uIdx, sp2, ep2)
						Else 
							' ' Call TraceLog(SPORTS_LOG1, "procSetUserToPos - 찾았다. 여기에 배치하자  cntTeam11,2 = 0 cntUser1 <= cntUser2 #6") 			 
							Call procSetUserToPos(rAryPos, rAryUser, uIdx, sp1, ep1)
						End If 
					Else
						If(cntTeam1 = 0) Then 
							' ' Call TraceLog(SPORTS_LOG1, "procSetUserToPos - 찾았다. 여기에 배치하자  cntTeam1 = 0  #7") 			 
							Call procSetUserToPos(rAryPos, rAryUser, uIdx, sp1, ep1)
						Else 
							' ' Call TraceLog(SPORTS_LOG1, "procSetUserToPos - 찾았다. 여기에 배치하자  cntTeam2 = 0  #8") 	
							Call procSetUserToPos(rAryPos, rAryUser, uIdx, sp2, ep2)
						End If 
					End If 
				End If 
			Else 			' 찾았다. 여기에 배치하자 				
				If(cntRgn1 = 0) And (cntRgn2 = 0) Then 
					If(cntUser1 > cntUser2) Then 					' 배치된 User Count Check 
						' ' Call TraceLog(SPORTS_LOG1, "procSetUserToPos - 찾았다. 여기에 배치하자  cntRgn1,2 = 0 cntUser1 > cntUser2 #9") 			 
						Call procSetUserToPos(rAryPos, rAryUser, uIdx, sp2, ep2)
					Else 
						' ' Call TraceLog(SPORTS_LOG1, "procSetUserToPos - 찾았다. 여기에 배치하자  cntRgn1,2 = 0 cntUser1 <= cntUser2 #10") 			 
						Call procSetUserToPos(rAryPos, rAryUser, uIdx, sp1, ep1)
					End If 
				Else
					If(cntRgn1 = 0) Then 
						' ' Call TraceLog(SPORTS_LOG1, "procSetUserToPos - 찾았다. 여기에 배치하자  cntRgn1 = 0  #11") 			 
						Call procSetUserToPos(rAryPos, rAryUser, uIdx, sp1, ep1)
					Else 
						' ' Call TraceLog(SPORTS_LOG1, "procSetUserToPos - 찾았다. 여기에 배치하자  cntRgn2 = 0  #12") 	
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

		' fUse, pos, pos_kind, pos_val, playerCode(gGroupIdx), teamNo, cUser, user, cTeam, team
		If(pos = -1) Then 
			Call randomSetUserToPos(rAryPos, rAryUser, uIdx)
		Else		
			strLog = sprintf("-----------procSetUserToPos user uIdx = {0}, name = {1}({2}), pos = {3}", Array(uIdx, rAryUser(6, uIdx), rAryUser(8, uIdx), pos) )
      	' ' Call TraceLog(SPORTS_LOG1, strLog) 

			rAryUser(0, uIdx) = 1 

			rAryPos(0, pos) = 1								' fUse
			rAryPos(1, pos) = pos+1							' pos
			rAryPos(2, pos) = E_POS_NORMAL  				' pos_kind
			rAryPos(3, pos) = CON_POSVAL_NOUSE  		' pos_val

			rAryPos(4,pos) = rAryUser(11,uIdx)        ' playerCode - GroupIdx
			rAryPos(5,pos) = rAryUser(2,uIdx)         ' teamNo
			rAryPos(6,pos) = rAryUser(3,uIdx)         ' rgnNo
			rAryPos(7,pos) = rAryUser(5,uIdx)         ' cUser
			rAryPos(8,pos) = rAryUser(6,uIdx)         ' user
			rAryPos(9,pos) = rAryUser(7,uIdx)         ' cTeam
			rAryPos(10,pos) = rAryUser(8,uIdx)       	' team
			rAryPos(11,pos) = rAryUser(9,uIdx)        ' cRegion
			rAryPos(12,pos) = rAryUser(10,uIdx)       ' region
		End If 
	End Function 

	Function randomSetUserToPos(rAryPos, rAryUser, uIdx)
		Dim Idx, ub, cntEmpty, rNum, cnt, pos 
		Dim aryBlock, sBase, fLoop, strBlock , teamNo 

		fLoop = 1
		sBase = 16
		ub = UBound(rAryPos, 2)
		If(sBase > ub+1) Then sBase = ub+1 End If 

		teamNo = CDbl(rAryUser(2, uIdx))

		strLog = sprintf("-----------randomSetUserToPos user = {0}({1}), teamNo = {2}, sBase = {3}", Array(rAryUser(6, uIdx), rAryUser(8, uIdx), teamNo, sBase))
      ' ' Call TraceLog(SPORTS_LOG1, strLog) 

		While(fLoop)
			strBlock = CheckEmptyPos(rAryPos, teamNo, sBase)

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

			strLog = sprintf("strBlock 찾았다.  aryBlock({0}) = {1}, sp = {2}, ep = {2}, sBase = {3}, pos = {4}", Array(rNum, aryBlock(rNum), sp, ep, sBase, pos))
         ' ' Call TraceLog(SPORTS_LOG1, strLog) 
		End If 

		'   -----------------------------------------------------------------------
      '    빈자리를 못찾았으면 아무 빈자리나 넣는다. 
      If (pos = -1) Then 
         ' ' Call TraceLog(SPORTS_LOG1, "빈자리를 못찾았으면 아무 빈자리나 넣는다.") 
         pos = GetEmptyPosByRandom(rAryPos)           
      End If 

      If(pos <> -1) Then 
			strLog = sprintf("-----------randomSetUserToPos user uIdx = {0}, name = {1}, pos = {2}", Array(uIdx, rAryUser(9, uIdx), pos) )
      	' ' Call TraceLog(SPORTS_LOG1, strLog) 

         rAryPos(0, pos) = 1								' fUse
			rAryPos(1, pos) = pos+1							' pos
			rAryPos(2, pos) = E_POS_NORMAL  				' pos_kind
			rAryPos(3, pos) = CON_POSVAL_NOUSE  		' pos_val

			rAryPos(4,pos) = rAryUser(11,uIdx)        ' playerCode - GroupIdx
			rAryPos(5,pos) = rAryUser(2,uIdx)         ' teamNo
			rAryPos(6,pos) = rAryUser(3,uIdx)         ' rgnNo
			rAryPos(7,pos) = rAryUser(5,uIdx)         ' cUser
			rAryPos(8,pos) = rAryUser(6,uIdx)         ' user
			rAryPos(9,pos) = rAryUser(7,uIdx)         ' cTeam
			rAryPos(10,pos) = rAryUser(8,uIdx)       	' team
			rAryPos(11,pos) = rAryUser(9,uIdx)        ' cRegion
			rAryPos(12,pos) = rAryUser(10,uIdx)       ' region
      Else 
         strLog = "**************** randomSetUserToPos Error !! "
         '' ' ' ' ' ' Call TraceLog(SPORTS_LOG1, strLog) 
      End If 
	End Function 

	Function CheckEmptyPos(rAryPos, tNo, sBlock)
		Dim Idx, ub, sp, ep, nMax, strRet, ret 

		ub = UBound(rAryPos, 2)
		nMax = ((ub+1) / sBlock) -1 

		strRet = "" 

		For Idx = 0 To nMax
			sp = Idx * sBlock 
			ep = (sp + sBlock) -1
			ret = checkEmptyPosInBlock(rAryPos, tNo, sp, ep)

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

	Function checkEmptyPosInBlock(rAryPos, tNo, sp, ep)
		Dim Idx , ret, teamNo , szBlock , cntUsed

		szBlock = (ep-sp) + 1
		ret = 1 
		cntUsed = 0 

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
'      aryUser로 부터 aryPos에 User를 할당한다.                    - 단식 
'   =============================================================================== 
	Function SetTournamentUser(rAryPos, rAryUser, IsDblGame)		
		Dim aryPosA, aryPosB, aryPosC, aryPosD
      Dim aryUserA, aryUserB, aryUserC, aryUserD
		Dim aryPosHalfA, aryPosHalfB, aryHalfA, aryHalfB, aryData

		ReDim aryData(4-1)

      If(IsDblGame = 1) Then 
         Call SetTournamentUserDbl(rAryPos, rAryUser)
         Exit Function 
      End If         
		
		' User를 HalfA, HalfB에 할당하고 , Pos도 HalfPosA , HalfPosB에 할당한다. 		
		Call binSetTournamentUser(rAryPos, rAryUser, aryData, E_HALF_A)
		aryHalfA 	= aryData(0)
		aryHalfB 	= aryData(1)
		aryPosHalfA = aryData(2)
		aryPosHalfB = aryData(3)

		' HalfA User를 aryA, aryB에 할당한다. 
		Call binSetTournamentUser(aryPosHalfA, aryHalfA, aryData, E_HALF_A)
		aryUserA 	= aryData(0)
		aryUserB 	= aryData(1)
		aryPosA 		= aryData(2)
		aryPosB 		= aryData(3)

		' HalfB User를 aryC, aryD에 할당한다. 
		Call binSetTournamentUser(aryPosHalfB, aryHalfB, aryData, E_HALF_A)
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
'      aryUser로 부터 2 Part에 인원을 분산할당 한다. - aryPartUser
'      aryPos을 2 Part로 나눈다. 
'   =============================================================================== 
	Function binSetTournamentUser(rAryPos, rAryUser, rAryData, nPart)
		Dim aryPosA, aryPosB
		Dim aryUserA, aryUserB 
		Dim cntByeA, cntByeB , cntUserA, cntUserB , cntPosA, cntPosB  
		Dim Idx, ub, half, ub_pos, half_pos, nCol 
				
		ub = UBound(rAryPos, 2)
		half = (ub+1) / 2 
		nCol = UBound(rAryUser, 1)

		' aryPos을 aryPosA, aryPosB 로 나눈다. ( / 2)
      aryPosA = DivAryPos(rAryPos, E_HALF_A)
      aryPosB = DivAryPos(rAryPos, E_HALF_B)

		cntPosA = UBound(aryPosA, 2) + 1
		cntPosB = UBound(aryPosB, 2) + 1

		'' ' ' ' ' ' Call TraceLog2Dim(SAMALL_LOG1, aryPosA, "DivAryPos(rAryPos, E_HALF_A)")
		'' ' ' ' ' ' Call TraceLog2Dim(SAMALL_LOG1, aryPosB, "DivAryPos(rAryPos, E_HALF_B)")

      ' Bye(Empty) Count를 구한다. 
      cntByeA = GetSpecialPosCnt(aryPosA, E_POS_BYE, E_PART_ALL)
      cntByeB = GetSpecialPosCnt(aryPosB, E_POS_BYE, E_PART_ALL)
            
      cntUserA = cntPosA - cntByeA
      cntUserB = cntPosB - cntByeB

		strLog = sprintf("binSetTournamentUser cntPosA = {0}, cntUserA = {1} , cntByeA = {2}, cntPosB = {3}, cntUserB = {4}, cntByeB = {5}", _ 
						Array(cntPosA, cntUserA, cntByeA, cntPosB, cntUserB, cntByeB))
		' ' Call TraceLog(SAMALL_LOG1, strLog)
		
		ReDim aryUserA(nCol, cntUserA-1)      
      ReDim aryUserB(nCol, cntUserB-1)

		Call binAssignUser(aryUserA, aryUserB, rAryUser)		

		rAryData(0) = aryUserA
		rAryData(1) = aryUserB		
		rAryData(2) = aryPosA
		rAryData(3) = aryPosB
	End Function 

'   ===============================================================================     
'     aryUser데이터를 Part A, B에 나누어 할당한다. ( binary search )
' 		데이터가 정렬되어 있으므로 순서적으로 나누기만 하면 된다. 
' 		Part A부터 번갈아 가면서 데이터를 setting한다. 
'     더이상 공간이 없을 경우 , 나머지 Part에 데이터를 넣는다. 
'   =============================================================================== 
	Function binAssignUser(rAryUserA, rAryUserB, rAryUser)
		Dim ub, Idx, nMaxA, nMaxB , setDataPart

		ub 		 = UBound(rAryUser, 2)
		nMaxA 	 = UBound(rAryUserA, 2) + 1
		nMaxB 	 = UBound(rAryUserB, 2) + 1
		setDataPart = E_HALF_A
		
		For Idx = 0 To ub 			
			cntA = getAssignCntInUserArray(rAryUserA)
			cntB = getAssignCntInUserArray(rAryUserB)	

			If(cntA = nMaxA) And (cntB = nMaxB) Then 		' 양쪽다 풀이다. 그만 하자. 
				Exit For 
			End If 

			If(cntA = nMaxA) Then 				' Part A가 풀이다. B에 넣자 
				setDataPart = E_HALF_B
			ElseIf(cntB = nMaxB) Then			' Part B가 풀이다. A에 넣자 
				setDataPart = E_HALF_A
			End If

			If(setDataPart = E_HALF_A) Then 
				Call CopyRows(rAryUser, rAryUserA, Idx, cntA)
				rAryUserA(0,cntA) = 1
				setDataPart = E_HALF_B
			ElseIf(setDataPart = E_HALF_B) Then 
				Call CopyRows(rAryUser, rAryUserB, Idx, cntB)
				rAryUserB(0,cntB) = 1
				setDataPart = E_HALF_A
			End If
		Next 

	End Function 
%>

<%
'   ===============================================================================     
'      복식
'   =============================================================================== 
	
'   ===============================================================================     
' 		인원배치 룰 	각 Part에 할당된 User를 Binary Search 방식으로 배치한다. 
' 			1. 인원을 순차적으로 할당한다. 
'
'			1. 지역만 가지고 유저의 중복을 찾아서 할당한다. 
'			2. 지역만으로 할당을 못한 사용자에 한하여 지역, 팀을 가지고 중복을 찾아서 할당한다. 
' 			
' 			1. User를 한명 선택한다.
' 			2. 선택된 User의 teamNo, rgnNo을 추출한다.
' 			3. 해당 Part를 전체로 잡고 half로 나눈다. (A1, B1 Part)
' 			4. 각각의 Block에서 teamNo과 일치하는 User의 Count를 구한다.    nSameTeam
' 			5. 각각의 Block에서 rgnNo과 일치하는 User의 Count를 구한다.    nSameRgn
' 			5. 각 Block에 할당된 user Count를 구한다.    nAssignUser
' 			6. nSameRgn의 값이 제일 적은 팀 리스트를 구한다.  
' 			7. 이중 nSameTeam 값이 제일 적은 팀에 할당한다. 
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
'   =============================================================================== 
	Function SetUserToPosDbl(rAryPos, rAryUser)
		Dim ub, ubP, Idx
		Dim sp1, sp2, ep1, ep2
		
		ub = UBound(rAryUser, 2)
		ubP = UBound(rAryPos, 2)
	
		For Idx = 0 To ub Step 2
			cntSelfCall	= 0      
			setRegionUser = false

			strLog = sprintf("-----------SetUserToPosDbl user Idx = {0}, user1 = {1}({2}), user2 = {3}({4})", _ 
						Array(idx, rAryUser(6, Idx), rAryUser(8, Idx), rAryUser(6, Idx+1), rAryUser(8, Idx+1)) )
			Call binSetUserDblByRegion(rAryPos, rAryUser, Idx, 0, ubP)
			If(setRegionUser = false) Then 
				cntSelfCall	= 0   
				Call binSetUserToPosDbl(rAryPos, rAryUser, Idx, 0, ubP)
			End If 			
		Next 

	End Function 


'   ===============================================================================     
'      재귀 호출 .. 
'      1. 지역을 기준으로 빈공간을 찾는다. ( 지역이 겹치지 않게.. )
' 		 2. szBlock이 SZ_BLOCK_MIN보다 작을때 까지 지역이 겹치면 이때 팀으로 구분한다. 
' 
'      block size <= 4일때 까지 혹은 teamNo가 0인 block을 만날때 까지 
'      block을 2개의 부분으로 나눈후 각각의 Block의 position value를 체크한다. 

' 		 각각의 Block에서 RegionNo과 일치하는 User의 Count를 구한다.    nSameRegion
' 		 각각의 Block에서 teamNo과 일치하는 User의 Count를 구한다.    nSameTeam
' 		 각 Block에 할당된 user Count를 구한다.    nAssignUser
'		 각 Block에 할당할수 있는 빈 공간 갯수를 구한다. nEmtpy 
'   =============================================================================== 
	Function binSetUserDblByRegion(rAryPos, rAryUser, uIdx, sp, ep)
		Dim Idx, ub
		Dim sp1, sp2, ep1, ep2, half, szBlock, regionNo
		Dim cntUser1, cntUser2, cntEmpty1, cntEmpty2, cntTeam1, cntTeam2, cntRgn1, cntRgn2

		szBlock = (ep - sp) + 1
		half = szBlock / 2

		strLog = sprintf("binSetUserToPosDbl uIdx = {0}, user1 = {1}({2}), user2 = {3}({4}), sp = {5}, ep = {6}, szBlock = {7}, half = {8}, cntSelfCall = {9} ", _ 
									 Array(uIdx, rAryUser(6, uIdx), rAryUser(8, uIdx), rAryUser(6, uIdx+1), rAryUser(8, uIdx+1), sp, ep, szBlock, half, cntSelfCall) )
      ' ' Call TraceLog(SPORTS_LOG1, strLog) 

		If(szBlock <= SZ_BLOCK_MIN) Then 			' block size가 최소다.  그냥 Random하게 배치하자 
			setRegionUser = false
			Exit Function 
		End If 

		If(cntSelfCall >= maxSelfCall) Then 	' 재귀 호출이 maxCount를 넘었다. 이만 끝내자 
			' Call TraceLog(SPORTS_LOG1, "재귀 호출이 maxCount를 넘었다. 이만 끝내자  ") 
			setRegionUser = false
			Exit Function 
		End If 
		cntSelfCall = cntSelfCall + 1				' 재귀 호출 제어 카운트 
		
		sp1 = sp 
		ep1 = (sp + half) - 1
		sp2 = ep1 + 1 
		ep2 = ep 
		
		regionNo 	= CDbl(rAryUser(3, uIdx))

		' ---------------------------------------------------------------		
		cntUser1 	= getAssignCountInBlock(rAryPos, sp1, ep1)
		cntEmpty1 	= getEmptyCountInBlockRegion(rAryPos, regionNo, sp1, ep1)
		cntRgn1 		= getRgnCountInBlock(rAryPos, regionNo, sp1, ep1)

		cntUser2 	= getAssignCountInBlock(rAryPos, sp2, ep2)
		cntEmpty2 	= getEmptyCountInBlockRegion(rAryPos, regionNo, sp2, ep2)
		cntRgn2 		= getRgnCountInBlock(rAryPos, regionNo, sp2, ep2)
		' ---------------------------------------------------------------

		strLog = sprintf("binSetUserToPosDbl sp1 = {0}, ep1 = {1}, sp2 = {2}, ep2 = {3}, teamNo = {4}, regionNo = {5} ", _ 
									 Array(sp1, ep1, sp2, ep2, teamNo, regionNo) )
      ' Call TraceLog(SPORTS_LOG1, strLog) 

		strLog = sprintf("binSetUserToPosDbl cntUser1 = {0}, cntEmpty1 = {1}, cntTeam1 = {2}, cntRgn1 = {3} // cntUser2 = {4}, cntEmpty2 = {5}, cntTeam2 = {6}, cntRgn2 = {7} ", _ 
									 Array(cntUser1, cntEmpty1, cntTeam1, cntRgn1, cntUser2, cntEmpty2, cntTeam2, cntRgn2) )
      ' Call TraceLog(SPORTS_LOG1, strLog) 

		If( cntEmpty1 = 0 And cntEmpty2 = 0) Then 				' 빈공간이 없다.  그냥 Random하게 배치하자 
			setRegionUser = false
			Exit Function 
		ElseIf( cntEmpty1 = 0 Or cntEmpty2 = 0) Then 
			If(cntEmpty1 = 0) Then 				' A Part에 빈공간이 없다. B쪽을 찾자 
				If(cntRgn2 = 0) Then 
					' Call TraceLog(SPORTS_LOG1, "procSetUserToPosDbl - 찾았다. 여기에 배치하자  cntRgn2 = 0  #1") 	
					Call procSetUserToPosDbl(rAryPos, rAryUser, uIdx, sp2, ep2)
					setRegionUser = true
				Else 					
					Call binSetUserDblByRegion(rAryPos, rAryUser, uIdx, sp2, ep2)
				End If 
			Else										' B Part에 빈공간이 없다. A쪽을 찾자 
				If(cntRgn1 = 0) Then 
					' Call TraceLog(SPORTS_LOG1, "procSetUserToPosDbl - 찾았다. 여기에 배치하자  cntRgn1 = 0  #3") 	
					Call procSetUserToPosDbl(rAryPos, rAryUser, uIdx, sp1, ep1)
					setRegionUser = true
				Else 								
					Call binSetUserDblByRegion(rAryPos, rAryUser, uIdx, sp1, ep1)
				End If 				
			End If 
		Else 
			If(cntRgn1 <> 0) And (cntRgn2 <> 0) Then 				' 배치된 Same region Count Check 
				If(cntRgn1 > cntRgn2) Then 					' 배치된 User Count Check 
					Call binSetUserDblByRegion(rAryPos, rAryUser, uIdx, sp2, ep2)
				Else 
					Call binSetUserDblByRegion(rAryPos, rAryUser, uIdx, sp1, ep1)
				End If 
			Else 					' 찾았다. 여기에 배치하자 				
				If(cntRgn1 = 0) And (cntRgn2 = 0) Then 
					If(cntUser1 > cntUser2) Then 					' 배치된 User Count Check 
						' ' Call TraceLog(SPORTS_LOG1, "procSetUserToPosDbl - 찾았다. 여기에 배치하자  cntRgn1 = 0 cntUser1 > cntUser2 #9") 			 
						Call procSetUserToPosDbl(rAryPos, rAryUser, uIdx, sp2, ep2)
						setRegionUser = true
					Else 
						' ' Call TraceLog(SPORTS_LOG1, "procSetUserToPosDbl - 찾았다. 여기에 배치하자  cntRgn1 = 0 cntUser1 <= cntUser2 #10") 			 
						Call procSetUserToPosDbl(rAryPos, rAryUser, uIdx, sp1, ep1)
						setRegionUser = true
					End If 					
				Else
					If(cntRgn1 = 0) Then 
						' ' Call TraceLog(SPORTS_LOG1, "procSetUserToPosDbl - 찾았다. 여기에 배치하자  cntRgn1 = 0  #11") 			 
						Call procSetUserToPosDbl(rAryPos, rAryUser, uIdx, sp1, ep1)
						setRegionUser = true
					Else 
						' ' Call TraceLog(SPORTS_LOG1, "procSetUserToPosDbl - 찾았다. 여기에 배치하자  cntRgn2 = 0  #12") 	
						Call procSetUserToPosDbl(rAryPos, rAryUser, uIdx, sp2, ep2)
						setRegionUser = true
					End If 
				End If 
			End If 
		End If 

	End Function 

'   ===============================================================================     
'      재귀 호출 .. 
'      block size <= 4일때 까지 혹은 teamNo가 0인 block을 만날때 까지 
'      block을 2개의 부분으로 나눈후 각각의 Block의 position value를 체크한다. 

' 		 각각의 Block에서 RegionNo과 일치하는 User의 Count를 구한다.    nSameRegion
' 		 각각의 Block에서 teamNo과 일치하는 User의 Count를 구한다.    nSameTeam
' 		 각 Block에 할당된 user Count를 구한다.    nAssignUser
'		 각 Block에 할당할수 있는 빈 공간 갯수를 구한다. nEmtpy 
'   =============================================================================== 
	Function binSetUserToPosDbl(rAryPos, rAryUser, uIdx, sp, ep)
		Dim Idx, ub
		Dim sp1, sp2, ep1, ep2, half, szBlock
		Dim teamNo, regionNo
		Dim cntUser1, cntUser2, cntEmpty1, cntEmpty2, cntTeam1, cntTeam2, cntRgn1, cntRgn2

		szBlock = (ep - sp) + 1
		half = szBlock / 2

		strLog = sprintf("binSetUserToPosDbl uIdx = {0}, user1 = {1}({2}), user2 = {3}({4}), sp = {5}, ep = {6}, szBlock = {7}, half = {8}, cntSelfCall = {9} ", _ 
									 Array(uIdx, rAryUser(6, uIdx), rAryUser(8, uIdx), rAryUser(6, uIdx+1), rAryUser(8, uIdx+1), sp, ep, szBlock, half, cntSelfCall) )
      ' ' Call TraceLog(SPORTS_LOG1, strLog) 

		If(szBlock <= SZ_BLOCK_MIN) Then 			' block size가 최소다.  그냥 Random하게 배치하자 
			' Call TraceLog(SPORTS_LOG1, "randomSetUserToPosDbl - block size가 최소다.  그냥 Random하게 배치하자 ") 
			Call randomSetUserToPosDbl(rAryPos, rAryUser, uIdx)
			Exit Function 
		End If 

		If(cntSelfCall >= maxSelfCall) Then 	' 재귀 호출이 maxCount를 넘었다. 이만 끝내자 
			' Call TraceLog(SPORTS_LOG1, "randomSetUserToPosDbl - 재귀 호출이 maxCount를 넘었다. 이만 끝내자  ") 
			Call randomSetUserToPosDbl(rAryPos, rAryUser, uIdx)
			Exit Function 
		End If 
		cntSelfCall = cntSelfCall + 1				' 재귀 호출 제어 카운트 
		
		sp1 = sp 
		ep1 = (sp + half) - 1
		sp2 = ep1 + 1 
		ep2 = ep 

		teamNo 		= CDbl(rAryUser(2, uIdx))
		regionNo 	= CDbl(rAryUser(3, uIdx))

		' ---------------------------------------------------------------		
		cntUser1 	= getAssignCountInBlock(rAryPos, sp1, ep1)
		cntEmpty1 	= getEmptyCountInBlock(rAryPos, teamNo, sp1, ep1)
		cntTeam1 	= getTeamCountInBlock(rAryPos, teamNo, sp1, ep1)
		cntRgn1 		= getRgnCountInBlock(rAryPos, regionNo, sp1, ep1)

		cntUser2 	= getAssignCountInBlock(rAryPos, sp2, ep2)
		cntEmpty2 	= getEmptyCountInBlock(rAryPos, teamNo, sp2, ep2)
		cntTeam2 	= getTeamCountInBlock(rAryPos, teamNo, sp2, ep2)
		cntRgn2 		= getRgnCountInBlock(rAryPos, regionNo, sp2, ep2)
		' ---------------------------------------------------------------

		strLog = sprintf("binSetUserToPosDbl sp1 = {0}, ep1 = {1}, sp2 = {2}, ep2 = {3}, teamNo = {4}, regionNo = {5} ", _ 
									 Array(sp1, ep1, sp2, ep2, teamNo, regionNo) )
      ' Call TraceLog(SPORTS_LOG1, strLog) 

		strLog = sprintf("binSetUserToPosDbl cntUser1 = {0}, cntEmpty1 = {1}, cntTeam1 = {2}, cntRgn1 = {3} // cntUser2 = {4}, cntEmpty2 = {5}, cntTeam2 = {6}, cntRgn2 = {7} ", _ 
									 Array(cntUser1, cntEmpty1, cntTeam1, cntRgn1, cntUser2, cntEmpty2, cntTeam2, cntRgn2) )
      ' Call TraceLog(SPORTS_LOG1, strLog) 

		If( cntEmpty1 = 0 And cntEmpty2 = 0) Then 				' 빈공간이 없다.  그냥 Random하게 배치하자 
			' Call TraceLog(SPORTS_LOG1, "randomSetUserToPosDbl - 빈공간이 없다.  그냥 Random하게 배치하자   ") 
			Call randomSetUserToPosDbl(rAryPos, rAryUser, uIdx)
			Exit Function 
		ElseIf( cntEmpty1 = 0 Or cntEmpty2 = 0) Then 
			If(cntEmpty1 = 0) Then 				' A Part에 빈공간이 없다. B쪽을 찾자 
				If(cntRgn2 = 0) Then 
					' Call TraceLog(SPORTS_LOG1, "procSetUserToPosDbl - 찾았다. 여기에 배치하자  cntRgn2 = 0  #1") 	
					Call procSetUserToPosDbl(rAryPos, rAryUser, uIdx, sp2, ep2)
				Else 
					If(cntTeam2 = 0) Then 
						' Call TraceLog(SPORTS_LOG1, "procSetUserToPosDbl - 찾았다. 여기에 배치하자  cntTeam2 = 0  #2") 	
						Call procSetUserToPosDbl(rAryPos, rAryUser, uIdx, sp2, ep2)
					Else 
						Call binSetUserToPosDbl(rAryPos, rAryUser, uIdx, sp2, ep2)
					End If 
				End If 
			Else										' B Part에 빈공간이 없다. A쪽을 찾자 
				If(cntRgn1 = 0) Then 
					' Call TraceLog(SPORTS_LOG1, "procSetUserToPosDbl - 찾았다. 여기에 배치하자  cntRgn1 = 0  #3") 	
					Call procSetUserToPosDbl(rAryPos, rAryUser, uIdx, sp1, ep1)
				Else 
					If(cntTeam1 = 0) Then 
						' ' Call TraceLog(SPORTS_LOG1, "procSetUserToPosDbl - 찾았다. 여기에 배치하자  cntTeam1 = 0  #4") 	
						Call procSetUserToPosDbl(rAryPos, rAryUser, uIdx, sp1, ep1)
					Else 					
						Call binSetUserToPosDbl(rAryPos, rAryUser, uIdx, sp1, ep1)
					End IF 
				End If 				
			End If 
		Else 
			If(cntRgn1 <> 0) And (cntRgn2 <> 0) Then 				' 배치된 Same region Count Check 
				If(cntTeam1 <> 0) And (cntTeam2 <> 0) Then 		' 배치된 Same Team Count Check 
					If(cntTeam1 > cntTeam2) Then 
						Call binSetUserToPosDbl(rAryPos, rAryUser, uIdx, sp2, ep2)
					ElseIf(cntTeam1 < cntTeam2) Then  
						Call binSetUserToPosDbl(rAryPos, rAryUser, uIdx, sp1, ep1)
					Else 
						If(cntUser1 > cntUser2) Then 					' 배치된 User Count Check 
							Call binSetUserToPosDbl(rAryPos, rAryUser, uIdx, sp2, ep2)
						Else 
							Call binSetUserToPosDbl(rAryPos, rAryUser, uIdx, sp1, ep1)
						End If 
					End If 
				Else 			' 찾았다. 여기에 배치하자 				
					If(cntTeam1 = 0) And (cntTeam2 = 0) Then 
						If(cntUser1 > cntUser2) Then 					' 배치된 User Count Check 
							' ' Call TraceLog(SPORTS_LOG1, "procSetUserToPosDbl - 찾았다. 여기에 배치하자  cntTeam1,2 = 0 cntUser1 > cntUser2 #5") 			 
							Call procSetUserToPosDbl(rAryPos, rAryUser, uIdx, sp2, ep2)
						Else 
							' ' Call TraceLog(SPORTS_LOG1, "procSetUserToPosDbl - 찾았다. 여기에 배치하자  cntTeam1,2 = 0 cntUser1 <= cntUser2 #6") 			 
							Call procSetUserToPosDbl(rAryPos, rAryUser, uIdx, sp1, ep1)
						End If 
					Else
						If(cntTeam1 = 0) Then 
							' ' Call TraceLog(SPORTS_LOG1, "procSetUserToPosDbl - 찾았다. 여기에 배치하자  cntTeam1 = 0  #7") 			 
							Call procSetUserToPosDbl(rAryPos, rAryUser, uIdx, sp1, ep1)
						Else 
							' ' Call TraceLog(SPORTS_LOG1, "procSetUserToPosDbl - 찾았다. 여기에 배치하자  cntTeam2 = 0  #8") 	
							Call procSetUserToPosDbl(rAryPos, rAryUser, uIdx, sp2, ep2)
						End If 
					End If 
				End If 
			Else 					' 찾았다. 여기에 배치하자 				
				If(cntRgn1 = 0) And (cntRgn2 = 0) Then 
					If(cntUser1 > cntUser2) Then 					' 배치된 User Count Check 
						' ' Call TraceLog(SPORTS_LOG1, "procSetUserToPosDbl - 찾았다. 여기에 배치하자  cntRgn1 = 0 cntUser1 > cntUser2 #9") 			 
						Call procSetUserToPosDbl(rAryPos, rAryUser, uIdx, sp2, ep2)
					Else 
						' ' Call TraceLog(SPORTS_LOG1, "procSetUserToPosDbl - 찾았다. 여기에 배치하자  cntRgn1 = 0 cntUser1 <= cntUser2 #10") 			 
						Call procSetUserToPosDbl(rAryPos, rAryUser, uIdx, sp1, ep1)
					End If 
				Else
					If(cntRgn1 = 0) Then 
						' ' Call TraceLog(SPORTS_LOG1, "procSetUserToPosDbl - 찾았다. 여기에 배치하자  cntRgn1 = 0  #11") 			 
						Call procSetUserToPosDbl(rAryPos, rAryUser, uIdx, sp1, ep1)
					Else 
						' ' Call TraceLog(SPORTS_LOG1, "procSetUserToPosDbl - 찾았다. 여기에 배치하자  cntRgn2 = 0  #12") 	
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

		' fUse, pos, pos_kind, pos_val, playerCode(gGroupIdx), teamNo, cUser, user, cTeam, team
		If(pos = -1) Then 
			Call randomSetUserToPosDbl(rAryPos, rAryUser, uIdx)
		Else		
			uIdx2 = uIdx + 1

			strLog = sprintf("-----------procSetUserToPosDbl user uIdx = {0}, user1 = {1}({2}), user2 = {3}({4}), pos = {5}, uIdx2 = {6}", _ 
						Array(uIdx, rAryUser(6, uIdx), rAryUser(8, uIdx), rAryUser(6, uIdx+1), rAryUser(8, uIdx+1), pos, uIdx2) )
      	' ' Call TraceLog(SPORTS_LOG1, strLog) 

			rAryUser(0, uIdx) = 1 
			rAryUser(0, uIdx2) = 1 

			rAryPos(0, pos) = 1								' fUse
			rAryPos(1, pos) = pos+1							' pos
			rAryPos(2, pos) = E_POS_NORMAL  				' pos_kind
			rAryPos(3, pos) = CON_POSVAL_NOUSE  		' pos_val

			rAryPos(4,pos) = rAryUser(11,uIdx)        ' playerCode - GroupIdx
			rAryPos(5,pos) = rAryUser(2,uIdx)         ' teamNo
			rAryPos(6,pos) = rAryUser(3,uIdx)         ' rgnNo

			rAryPos(7,pos) = rAryUser(5,uIdx)         ' cUser
			rAryPos(8,pos) = rAryUser(6,uIdx)         ' user
			rAryPos(9,pos) = rAryUser(5,uIdx2)         ' cUser
			rAryPos(10,pos) = rAryUser(6,uIdx2)         ' user
			
			rAryPos(11,pos) = rAryUser(7,uIdx)         ' cTeam
			rAryPos(12,pos) = rAryUser(8,uIdx)       	' team
			rAryPos(13,pos) = rAryUser(7,uIdx2)         ' cTeam
			rAryPos(14,pos) = rAryUser(8,uIdx2)       	' team

			rAryPos(15,pos) = rAryUser(9,uIdx)        ' cRegion
			rAryPos(16,pos) = rAryUser(10,uIdx)       ' region
			rAryPos(17,pos) = rAryUser(9,uIdx2)        ' cRegion
			rAryPos(18,pos) = rAryUser(10,uIdx2)       ' region
		End If 
	End Function 

	Function randomSetUserToPosDbl(rAryPos, rAryUser, uIdx)
		Dim Idx, ub, cntEmpty, rNum, cnt, pos 
		Dim aryBlock, sBase, fLoop, strBlock , teamNo

		fLoop = 1
		sBase = 16
		ub = UBound(rAryPos, 2)
		If(sBase > ub+1) Then sBase = ub+1 End If 

		teamNo = CDbl(rAryUser(2, uIdx))

		strLog = sprintf("-----------randomSetUserToPosDbl user uIdx = {0}, user1 = {1}({2}), user2 = {3}({4}), teamNo = {5}, sBase = {6}", _ 
					Array(uIdx, rAryUser(6, uIdx), rAryUser(8, uIdx), rAryUser(6, uIdx+1), rAryUser(8, uIdx+1), teamNo, sBase) )
		' ' Call TraceLog(SPORTS_LOG1, strLog) 

		While(fLoop)
			strBlock = CheckEmptyPos(rAryPos, teamNo, sBase)
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

			'strLog = sprintf("strBlock 찾았다.  aryBlock({0}) = {1}, sp = {2}, ep = {3}, sBase = {4}, pos = {5}", Array(rNum, aryBlock(rNum), sp, ep, sBase, pos))
			strLog = sprintf("*******************strBlock 찾았다.  aryBlock({0}) = {1}, sp = {2}, ep = {3}, sBase = {4}, pos = {5}", Array(rNum, 0, sp, ep, sBase, pos))
         'Call TraceLog(SPORTS_LOG1, strLog) 
		End If 

		'   -----------------------------------------------------------------------
      '    빈자리를 못찾았으면 아무 빈자리나 넣는다. 
      If (pos = -1) Then 
         ' ' Call TraceLog(SPORTS_LOG1, "randomSetUserToPosDbl 빈자리를 못찾았으면 아무 빈자리나 넣는다.") 
         pos = GetEmptyPosByRandom(rAryPos)           
      End If 

      If(pos <> -1) Then 
			strLog = sprintf("-----------randomSetUserToPosDbl user uIdx = {0}, user1 = {1}({2}), user2 = {3}({4}), pos = {5}", _ 
						Array(uIdx, rAryUser(6, uIdx), rAryUser(8, uIdx), rAryUser(6, uIdx+1), rAryUser(8, uIdx+1), pos) )
      	' ' Call TraceLog(SPORTS_LOG1, strLog) 

			uIdx2 = uIdx + 1

         rAryUser(0, uIdx) = 1 
			rAryUser(0, uIdx2) = 1 

			rAryPos(0, pos) = 1								' fUse
			rAryPos(1, pos) = pos+1							' pos
			rAryPos(2, pos) = E_POS_NORMAL  				' pos_kind
			rAryPos(3, pos) = CON_POSVAL_NOUSE  		' pos_val

			rAryPos(4,pos) = rAryUser(11,uIdx)        ' playerCode - GroupIdx
			rAryPos(5,pos) = rAryUser(2,uIdx)         ' teamNo
			rAryPos(6,pos) = rAryUser(3,uIdx)         ' rgnNo

			rAryPos(7,pos) = rAryUser(5,uIdx)         ' cUser
			rAryPos(8,pos) = rAryUser(6,uIdx)         ' user
			rAryPos(9,pos) = rAryUser(5,uIdx2)         ' cUser
			rAryPos(10,pos) = rAryUser(6,uIdx2)         ' user
			
			rAryPos(11,pos) = rAryUser(7,uIdx)         ' cTeam
			rAryPos(12,pos) = rAryUser(8,uIdx)       	' team
			rAryPos(13,pos) = rAryUser(7,uIdx2)         ' cTeam
			rAryPos(14,pos) = rAryUser(8,uIdx2)       	' team

			rAryPos(15,pos) = rAryUser(9,uIdx)        ' cRegion
			rAryPos(16,pos) = rAryUser(10,uIdx)       ' region
			rAryPos(17,pos) = rAryUser(9,uIdx2)        ' cRegion
			rAryPos(18,pos) = rAryUser(10,uIdx2)       ' region
      Else 
         strLog = "**************** randomSetUserToPos Error !! "
         '' ' ' ' ' ' Call TraceLog(SPORTS_LOG1, strLog) 
      End If 
	End Function 
	
'   ===============================================================================     
'      aryUser로 부터 aryPos에 User를 할당한다.                    
'   =============================================================================== 
	Function SetTournamentUserDbl(rAryPos, rAryUser)		
      Dim aryPosA, aryPosB, aryPosC, aryPosD
      Dim aryUserA, aryUserB, aryUserC, aryUserD
		Dim aryPosHalfA, aryPosHalfB, aryHalfA, aryHalfB, aryData

		ReDim aryData(4-1)

		' User를 HalfA, HalfB에 할당하고 , Pos도 HalfPosA , HalfPosB에 할당한다. 		
		Call binSetTournamentUserDbl(rAryPos, rAryUser, aryData)
		aryHalfA 	= aryData(0)
		aryHalfB 	= aryData(1)
		aryPosHalfA = aryData(2)
		aryPosHalfB = aryData(3)

	' 	' Call TraceLog2Dim(SAMALL_LOG1, rAryUser, "prev SetUserToPos - rAryUser")
	' 	' Call TraceLog2Dim(SAMALL_LOG1, aryHalfA, "prev SetUserToPos - aryHalfA")
	' 	' Call TraceLog2Dim(SAMALL_LOG1, aryHalfB, "prev SetUserToPos - aryHalfB")
	' 	' Call TraceLog2Dim(SAMALL_LOG1, aryPosHalfA, "prev SetUserToPos - aryPosHalfA")
	' 	' Call TraceLog2Dim(SAMALL_LOG1, aryPosHalfB, "prev SetUserToPos - aryPosHalfB")

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

'		' Call TraceLog2Dim(SAMALL_LOG1, rAryUser, "prev SetUserToPos - rAryUser")
'		' Call TraceLog2Dim(SAMALL_LOG1, aryHalfA, "prev SetUserToPos - aryHalfA")
'		' Call TraceLog2Dim(SAMALL_LOG1, aryHalfB, "prev SetUserToPos - aryHalfB")
'		' Call TraceLog2Dim(SAMALL_LOG1, aryUserA, "prev SetUserToPos - aryUserA")
'		' Call TraceLog2Dim(SAMALL_LOG1, aryUserB, "prev SetUserToPos - aryUserB")
'		' Call TraceLog2Dim(SAMALL_LOG1, aryUserC, "prev SetUserToPos - aryUserC")
'		' Call TraceLog2Dim(SAMALL_LOG1, aryUserD, "prev SetUserToPos - aryUserD")

'
' 		' ' Call TraceLog2Dim(SAMALL_LOG1, aryPosA, "prev SetUserToPos - aryPosA")
'		' ' Call TraceLog2Dim(SAMALL_LOG1, aryPosB, "prev SetUserToPos - aryPosB")
'		' ' Call TraceLog2Dim(SAMALL_LOG1, aryPosC, "prev SetUserToPos - aryPosC")
'		' ' Call TraceLog2Dim(SAMALL_LOG1, aryPosD, "prev SetUserToPos - aryPosD")
'
      Call SetUserToPosDbl(aryPosA, aryUserA)
		Call SetUserToPosDbl(aryPosB, aryUserB)
		Call SetUserToPosDbl(aryPosC, aryUserC)
		Call SetUserToPosDbl(aryPosD, aryUserD)	 	
 
 		Call MergeAryPos(rAryPos, aryPosA, E_PART_A)
      Call MergeAryPos(rAryPos, aryPosB, E_PART_B)
      Call MergeAryPos(rAryPos, aryPosC, E_PART_C)
      Call MergeAryPos(rAryPos, aryPosD, E_PART_D)
		
		' ' Call TraceLog2Dim(SAMALL_LOG1, aryPosA, "after SetUserToPos - aryPosA")
	 	' ' Call TraceLog2Dim(SAMALL_LOG1, aryPosB, "after SetUserToPos - aryPosB")
	 	' ' Call TraceLog2Dim(SAMALL_LOG1, aryPosC, "after SetUserToPos - aryPosC")
	 	' ' Call TraceLog2Dim(SAMALL_LOG1, aryPosD, "after SetUserToPos - aryPosD")
		' ' Call TraceLog2Dim(SAMALL_LOG1, rAryPos, "after MergeAryPos - rAryPos")

   End Function

	
'   ===============================================================================     
'      aryUser로 부터 2 Part에 인원을 분산할당 한다. - aryPartUser
'      aryPos을 2 Part로 나눈다. 
'   =============================================================================== 
	Function binSetTournamentUserDbl(rAryPos, rAryUser, rAryData)
		Dim aryPosA, aryPosB
		Dim aryUserA, aryUserB 
		Dim cntByeA, cntByeB , cntUserA, cntUserB , cntPosA, cntPosB 
		Dim Idx, ub, half, ub_pos, half_pos, nCol , nCallStep
				
		ub = UBound(rAryPos, 2)
		half = (ub+1) / 2 
		nCol = UBound(rAryUser, 1)

		' aryPos을 aryPosA, aryPosB 로 나눈다. ( / 2)
      aryPosA = DivAryPos(rAryPos, E_HALF_A)
      aryPosB = DivAryPos(rAryPos, E_HALF_B)

		cntPosA = UBound(aryPosA, 2) + 1
		cntPosB = UBound(aryPosB, 2) + 1

      ' Bye(Empty) Count를 구한다. 
      cntByeA = GetSpecialPosCnt(aryPosA, E_POS_BYE, E_PART_ALL)
      cntByeB = GetSpecialPosCnt(aryPosB, E_POS_BYE, E_PART_ALL)
            
      cntUserA = (cntPosA - cntByeA) * 2
      cntUserB = (cntPosB - cntByeB) * 2

		strLog = sprintf("binSetTournamentUserDbl cntPosA = {0}, cntUserA = {1} , cntByeA = {2}, cntPosB = {3}, cntUserB = {4}, cntByeB = {5}", _ 
						Array(cntPosA, cntUserA, cntByeA, cntPosB, cntUserB, cntByeB))
		' ' Call TraceLog(SAMALL_LOG1, strLog)
		
		ReDim aryUserA(nCol, cntUserA-1)      
      ReDim aryUserB(nCol, cntUserB-1)

		Call binAssignUserDbl(aryUserA, aryUserB, rAryUser)		

		rAryData(0) = aryUserA
		rAryData(1) = aryUserB		
		rAryData(2) = aryPosA
		rAryData(3) = aryPosB
	End Function 

'   ===============================================================================     
'     aryUser데이터를 Part A, B에 나누어 할당한다. ( binary search )
' 		데이터가 정렬되어 있으므로 순서적으로 나누기만 하면 된다. 
' 		Part A부터 번갈아 가면서 데이터를 setting한다. 
'     더이상 공간이 없을 경우 , 나머지 Part에 데이터를 넣는다. 
'   =============================================================================== 
	Function binAssignUserDbl(rAryUserA, rAryUserB, rAryUser)
		Dim ub, Idx, nMaxA, nMaxB , setDataPart
		
		ub 		 = UBound(rAryUser, 2)		
		nMaxA 	 = UBound(rAryUserA, 2) + 1
		nMaxB 	 = UBound(rAryUserB, 2) + 1
		setDataPart = E_HALF_A

		For Idx = 0 To ub Step 2	

			cntA = getAssignCntInUserArray(rAryUserA)
			cntB = getAssignCntInUserArray(rAryUserB)

			If(cntA = nMaxA) And (cntB = nMaxB) Then 		' 양쪽다 풀이다. 그만 하자. 
				Exit For 
			End If 
			
			If(cntA = nMaxA) Then 				' Part A가 풀이다. B에 넣자 
				setDataPart = E_HALF_B
			ElseIf(cntB = nMaxB) Then			' Part B가 풀이다. A에 넣자 
				setDataPart = E_HALF_A
			End If

			If(setDataPart = E_HALF_A) Then 
				Call CopyRows(rAryUser, rAryUserA, Idx, cntA)
				Call CopyRows(rAryUser, rAryUserA, Idx+1, cntA+1)
				rAryUserA(0,cntA) = 1
				rAryUserA(0,cntA+1) = 1

				setDataPart = E_HALF_B
			ElseIf(setDataPart = E_HALF_B) Then 
				Call CopyRows(rAryUser, rAryUserB, Idx, cntB)
				Call CopyRows(rAryUser, rAryUserB, Idx+1, cntB+1)
				rAryUserB(0,cntB) = 1
				rAryUserB(0,cntB+1) = 1

				setDataPart = E_HALF_A
			End If
		Next 

	End Function 
%>
