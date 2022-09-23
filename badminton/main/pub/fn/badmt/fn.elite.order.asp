<% 
'   ===============================================================================     
'    Purpose : badminton Elite 순위 
'    Make    : 2019.03.20
'    Author  :                                                       By Aramdry
'   ===============================================================================    
%> 

<% 	     
'   ===============================================================================     
'     print - ary Rank 
'      rank, a grade, b grade, c grade, d grade, win ,lose ,code team ,team
'   ===============================================================================
   '=================================================================================
	' 2차원 배열에서 row를 swap하는 함수 
    ' asp에서는 row의 배열 각각을 복사해야 한다. ( deep copy )
	'================================================================================= 
    Sub SwapRowsEx(ary,row1,row2)
    '== This proc swaps two rows of an array
    Dim x,tempvar
    For x = 0 to Ubound(ary,1)
        tempvar = ary(x,row1)   
        ary(x,row1) = ary(x,row2)
        ary(x,row2) = tempvar
    Next
    End Sub  'SwapRowsEx

    Function printAryRank(rAryRank)
        Dim ub, ai
        ub = UBound(rAryRank, 2)       

        Response.Write "<br><br>************************ print Rank *************<br>"
        For ai = 0 to ub          
             strLog1 = strPrintf("rank = {0} ,a grade = {1}, b grade = {2} ,c grade = {3} ,d grade = {4}", _
                    Array(rAryRank(0,ai), rAryRank(1,ai), rAryRank(2,ai), rAryRank(3,ai), rAryRank(4,ai) ))
                
             strLog2 = strPrintf("win = {0} ,lose = {1} ,code team = {2} ,team = {3}, result = {4}, winRate = {5}", _ 
                    Array(rAryRank(5,ai), rAryRank(6,ai), rAryRank(7,ai), rAryRank(8,ai), rAryRank(11,ai), rAryRank(12,ai) ))

            strLog = strPrintf("{0}, {1}<br>", Array(strLog1, strLog2))
            Response.Write strLog

            If (ai <> 0 And (ai+1) Mod 5 = 0) Then Response.Write "<br>" End If
        Next    
        Response.Write "<br>************************ print Rank *************<br><br>"
    End Function 
    
'   ===============================================================================     
'      swap function src to target
'   =============================================================================== 
	Function uxSwapRank(ary, s, t)
		Dim tRank, tA, tB, tC, tD, tWin, tLose, tcTeam, tTeam

        tRank   = ary(0, t)      ' rank 
        tA      = ary(1, t)      ' a grade
        tB      = ary(2, t)      ' b grade
        tC      = ary(3, t)      ' c grade
        tD      = ary(4, t)      ' d grade
        tWin    = ary(5, t)      ' win
        tLose   = ary(6, t)      ' lose
        tcTeam  = ary(7, t)      ' code team 
        tTeam   = ary(8, t)      ' team 

        ary(0, t) = ary(0, s)      ' rank 
        ary(1, t) = ary(1, s)      ' a grade
        ary(2, t) = ary(2, s)      ' b grade
        ary(3, t) = ary(3, s)      ' c grade
        ary(4, t) = ary(4, s)      ' d grade
        ary(5, t) = ary(5, s)      ' win
        ary(6, t) = ary(6, s)      ' lose
        ary(7, t) = ary(7, s)      ' code team 
        ary(8, t) = ary(8, s)      ' team 

        ary(0, s) = tRank     ' rank 
        ary(1, s) = tA        ' a grade
        ary(2, s) = tB        ' b grade
        ary(3, s) = tC        ' c grade
        ary(4, s) = tD        ' d grade
        ary(5, s) = tWin      ' win
        ary(6, s) = tLose     ' lose
        ary(7, s) = tcTeam    ' code team 
        ary(8, s) = tTeam     ' team

	End Function

    '=================================================================================
	' A Grade를 기준으로 sort한다. - 버블Sort
    ' key : 기준값 Court Number(StadiumNum) 이 들어 있는 배열 위치   
	'================================================================================= 
    Function uxSortAryRank(key, ByRef AryData, IsDesc)        
        Dim sul, si, sj
        Dim val1, val2

        sul = UBOUND(AryData, 2)

        For si=0 To sul-1            
            For sj=0 To (sul-si)-1    
                val1 = CDbl(AryData(key, sj))
                val2 = CDbl(AryData(key, sj+1))

                If( IsDesc ) Then 
                    If ( val1 < val2 ) Then     
                   '     Call uxSwapRank(AryData, sj, sj+1)
                        Call SwapRowsEx(AryData, sj, sj+1)
                    End If                
                Else
                    If ( val1 > val2 ) Then 
                    '    Call uxSwapRank(AryData, sj, sj+1)
                        Call SwapRowsEx(AryData, sj, sj+1)
                    End If                
                End If
            Next
        Next
   End Function

    Function uxSortPartAryRank(ByRef AryData, key, sIdx, eIdx, IsDesc)        
        Dim sul, spi, spj
        Dim grade1, grade2
 
        For spi=sIdx To eIdx
            For spj=sIdx To (eIdx-1)   
                grade1 = CDbl(AryData(key, spj))
                grade2 = CDbl(AryData(key, spj+1))

                If( IsDesc ) Then 
                    If ( grade1 < grade2 ) Then     
                      '  Call uxSwapRank(AryData, spj, spj+1)
                        Call SwapRowsEx(AryData, spj, spj+1)
                    End If                
                Else
                    If ( grade1 > grade2 ) Then 
                     '   Call uxSwapRank(AryData, spj, spj+1)
                        Call SwapRowsEx(AryData, spj, spj+1)
                    End If                
                End If
            Next
        Next
   End Function

'   =================================================================================
	' 순위를 생성한다. - Like mssql - Rank() ( a grade를 기준으로 순위를 생성한다. ) 
    ' 이때 생성한 순위는 중복 될수 있다. 
    ' 중복된 순위는 나중에 순위를 구하는 Block이 된다. 
    ' Rank	AJumsu	BJumsu	CJumsu	DJumsu	WinCnt	LoseCnt	Team	TeamName	TeamDtl	GameLeveldtlIDX	Result	WinRate
	'================================================================================= 
    Function uxMakeRankByAGrade(rAryRank)
        Dim rul, ri
        Dim prevVal, prevRank

        prevVal = 0
        prevRank = 0
        
        rul = UBOUND(rAryRank, 2)

        For ri=0 To rul
            If( rAryRank(1, ri) = prevVal ) Then 
                rAryRank(0, ri) = prevRank
            Else 
                rAryRank(0, ri) = ri + 1
                prevRank = rAryRank(0, ri)
            End If

            prevVal = rAryRank(1, ri)
        Next
   End Function

   '=================================================================================
	' 순위를 생성한다.  - 위치값에 의해 - 겹치지 않는다. 
    ' 승패 string을 생성한다. 
    ' 승률 string을 생성한다. 
    ' result와 winrate도 채워 넣는다. 
    ' Rank	AJumsu	BJumsu	CJumsu	DJumsu	WinCnt	LoseCnt	Team	TeamName	TeamDtl	GameLeveldtlIDX	Result	WinRate
	'================================================================================= 
    Function uxMakeRankByPos(rAryRank)
        Dim rul, ri, strResult, strRate, winRate, total
        Dim prevVal, prevRank

        prevVal = 0
        prevRank = 0
        winRate  = 0
        
        rul = UBOUND(rAryRank, 2)

        For ri=0 To rul
            rAryRank(0, ri) = ri + 1
            strResult = strPrintf("{0}승{1}패", Array(rAryRank(5, ri), rAryRank(6, ri)))
            total     = rAryRank(5, ri) + rAryRank(6, ri)
            If( total <> 0 ) Then winRate   = (rAryRank(5, ri) / total) * 100 End If
            strRate = strPrintf("{0}%", Array(Round(winRate, 0)))

            rAryRank(11, ri) = strResult
            rAryRank(12, ri) = strRate 
        Next
   End Function

   '=================================================================================
	' Team Code와 Team Detail Code를 입력받아 해당 Data의 Index를 구한다.     
    ' Rank	AJumsu	BJumsu	CJumsu	DJumsu	WinCnt	LoseCnt	Team	TeamName	TeamDtl	GameLeveldtlIDX	Result	WinRate
	'================================================================================= 
    Function uxGetRankIdx(rAryRank, cTeam, cDtl)
        Dim rul, ri, ret 
        
        ret = 0
        rul = UBOUND(rAryRank, 2)

        For ri=0 To rul
            If( rAryRank(7, ri) = cTeam And rAryRank(9, ri) = cDtl ) Then 
                ret = ri
                Exit For
            End If 
        Next

        uxGetRankIdx = ret
   End Function

   '=================================================================================
	' 순위를 생성한다. 
    ' 1. 1차 순위는 생성이 되어 있다.
    ' 1. Block을 구분한다. ( a grade가 동일한 것을 가지고 동일 Rank를 생성한다. )
    ' 2. Block 단위로 순위를 구한다.     
    ' rank, a grade, b grade, c grade, d grade, win ,lose ,code team ,team
	'================================================================================= 
    Function uxMakeRankOrder(rAryRank, rAryHistory)
        Dim rul, ri
        Dim prevVal, prevRank, nCnt, sPos, nGrade

        prevVal = 0
        prevRank = 0
        nCnt = 0
        nGrade = 2
        
        rul = UBOUND(rAryRank, 2)

        For ri=0 To rul
            If( rAryRank(0, ri) = prevRank ) Then 
                nCnt = nCnt + 1
            Else      
                If(nCnt > 1 ) Then 
                    Call uxMakeRankOrderEx(rAryRank, rAryHistory, sPos, nCnt, nGrade)
                End If           
                prevRank = rAryRank(0, ri)
                sPos = ri
                nCnt = 1
            End If

            prevVal = rAryRank(1, ri)
        Next

        If(nCnt > 1 ) Then 
            Call uxMakeRankOrderEx(rAryRank, rAryHistory, sPos, nCnt, nGrade)
        End If
   End Function

   '=================================================================================
	' Block 단위에서 순위를 생성한다. 
    ' 1. sPos, nCnt, 
    ' rank, a grade, b grade, c grade, d grade, win ,lose ,code team ,team
	'================================================================================= 
   Function uxMakeRankOrderEx(rAryRank, rAryHistory, sPos, nCnt, nGrade)
        Dim sIdx, eIdx, nRet 
        Dim strLog

        sIdx = sPos 
  
        If(nCnt = 2) Then                     
              nRet = uxCheckWinner(rAryHistory, rAryRank, sIdx)            
        Else             
            eIdx = sIdx + (nCnt-1) 
            Call uxMakeRankByGrade(rAryHistory, rAryRank, nGrade, sIdx, eIdx)
        End If
   End Function

    '=================================================================================
	' 순위를 생성한다. 
    ' rank, a grade, b grade, c grade, d grade, win ,lose ,code team ,team
	'================================================================================= 
    Function uxMakeRankByGrade(rAryHistory, rAryRank, nGrade, sPos, ePos)
        Dim rri, IsDesc
        Dim prevVal, prevRank, col, nCnt, sGrade 
        
        prevVal = 0
        prevRank = 0
        IsDesc = 1 

        If(nGrade > 4) Then     ' grade비교를 더이상 할게 없다.             
            Exit Function 
        End If

         ' nGrade에 의존하여 배열을 재 정렬한다. 
  '      Call printAryRank(rAryRank)
        Call uxSortPartAryRank(rAryRank, nGrade, sPos, ePos, IsDesc)
   '     Call printAryRank(rAryRank)

        ' 정렬후 순위를 매긴다. 
        For rri = sPos To ePos
            If( rAryRank(nGrade, rri) = prevVal ) Then 
                rAryRank(0, rri) = prevRank
            Else 
                rAryRank(0, rri) = rri + 1
                prevRank = rAryRank(0, rri)                
            End If
            prevVal = rAryRank(nGrade, rri)
        Next
    
        ' 겹치는 순위가 있는지 확인하여 순위를 구한다. 
        sGrade = nGrade + 1
        nCnt = 0
        prevRank = 0
        sBlock = 0

        For rri = sPos To ePos
            If( rAryRank(0, rri) = prevRank ) Then 
                nCnt = nCnt + 1
            Else      
                If(nCnt > 1 ) Then                     
                    Call uxMakeRankOrderEx(rAryRank, rAryHistory, sBlock, nCnt, sGrade)
                End If           
                prevRank = rAryRank(0, rri)
                sBlock = rri
                nCnt = 1
            End If

            prevVal = rAryRank(1, rri)
        Next

        If(nCnt > 1 ) Then             
            Call uxMakeRankOrderEx(rAryRank, rAryHistory, sBlock, nCnt, sGrade)
        End If

   End Function



'   ===============================================================================     
'      Check winer
'      left, right player code를 입력받아 서로의 전적을 비교한다. 
'      rAryRank :       rank, a grade, b grade, c grade, d grade, win ,lose ,code team ,team
'      rAryHistory :    result, cLTeam, LTeam, cRTeam, RTeam
'      cntWin > 0  => LPlayer Win
'      cntWin < 0  => RPlayer Win
'      cntWin = 0  => LPlayer = RPlayer 승자승을 비교했는데 무승부다.. 남은 값들을 비교하고 그래도 같으면 Random으로 처리 
'   =============================================================================== 
	Function uxCheckWinner(rAryHistory, rAryRank, sPos)
        Dim cntWin, cidx, cub, cLPlayer, cRPlayer
        Dim lPos, rPos, nRank
        lPos = sPos
        rPos = sPos + 1

        cLPlayer = rAryRank(7, lPos)
        cRPlayer = rAryRank(7, rPos)
        nRank    = rAryRank(0, lPos)        ' 순위 
        
        cub = UBound(rAryHistory, 2)  
        cntWin = 0

        For cidx = 0 to cub            
            If( rAryHistory(1, cidx) = cLPlayer And rAryHistory(3, cidx) = cRPlayer ) Then ' 찾았다.  
                If( rAryHistory(0, cidx) = "WIN" ) Then 
                    cntWin = cntWin + 1
                ElseIf( rAryHistory(0, cidx) = "LOSE" ) Then  
                    cntWin = cntWin - 1 
                End If
            ElseIf( rAryHistory(1, cidx) = cRPlayer And rAryHistory(3, cidx) = cLPlayer ) Then ' 찾았다. 
                If( rAryHistory(0, cidx) = "WIN" ) Then 
                    cntWin = cntWin - 1
                ElseIf( rAryHistory(0, cidx) = "LOSE" ) Then  
                    cntWin = cntWin + 1
                End If
            End If
        Next

        If( cntWin = 0 ) Then ' 승자승 비교로 동률이면 나머지 grade로 비교를 하자 
            cntWin = uxCheckWinnerByGrade(rAryRank, sPos)
        End If

        ' 순위를 적용한다. 
        If (cntWin > 0) Then 
            rAryRank(0, rPos)  = nRank + 1
        Else    ' 순위가 바뀐다. swap 
            rAryRank(0, lPos)  = nRank + 1
        '   Call uxSwapRank(rAryRank, lPos, rPos)
           Call SwapRowsEx(rAryRank, lPos, rPos)
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
'      rAryRank :       rank, a grade, b grade, c grade, d grade, win ,lose ,code team ,team
'   =============================================================================== 
	Function uxCheckWinnerByGrade(rAryRank, sPos)
        
        Dim ret , lPos, rPos
        lPos = sPos
        rPos = sPos + 1

        ' grade가 음수값을 인식 하지 못하여 CInt()로 Convert하여 대소비교를 수행한다. 
        ' b Grade 비교 
        If( CInt(rAryRank(2, lPos)) > CInt(rAryRank(2, rPos)) ) Then 
            ret = 1
        ElseIf( CInt(rAryRank(2, lPos)) < CInt(rAryRank(2, rPos)) ) Then  
            ret = -1
        Else 
            ' c Grade 비교 
            If( CInt(rAryRank(3, lPos)) > CInt(rAryRank(3, rPos)) ) Then 
                ret = 1
            ElseIf( CInt(rAryRank(3, lPos)) < CInt(rAryRank(3, rPos)) ) Then  
                ret = -1
            Else 
                ' d Grade 비교 
                If( CInt(rAryRank(4, lPos)) > CInt(rAryRank(4, rPos)) ) Then 
                    ret = 1
                ElseIf( CInt(rAryRank(4, lPos)) < CInt(rAryRank(4, rPos)) ) Then  
                    ret = -1
                Else 
                    ' a, b, c, d grade / 전적이 다 동률이다. Random으로 결정하자                     
                    ret = -1
                    rNum = GetRandomNum(2)
                    If (rNum = 1) Then ret = 1 End If
                End If 
            End If 
        End If 

'        strLog = strPrintf("uxCheckWinnerByGrade ret = {0}, b1 = {1}, b2 = {2}, c1 = {3}, c2 = {4}, d1 = {5}, d2 = {6},<br>", _
'            Array(ret, rAryRank(2, lPos), rAryRank(2, rPos), rAryRank(3, lPos), rAryRank(3, rPos), rAryRank(4, lPos), rAryRank(4, rPos) ))
'        
'        Response.Write strLog

        uxCheckWinnerByGrade = ret 
    End Function   
%>
