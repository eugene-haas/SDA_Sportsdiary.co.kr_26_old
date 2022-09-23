<!-- #include virtual = "/dev/config.asp"-->
<!-- #include virtual = "/classes/JSON_2.0.4.asp" -->
<!-- #include virtual = "/classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include virtual = "/classes/json2.asp" -->

<!-- #include virtual = "/pub/hdr.inc.bm.min.asp" -->  
<!-- #include virtual = "/pub/fn/badmt/res/res.pubcode.asp" -->  
<!-- #include virtual = "/pub/fn/badmt/res/res.teamGB.asp" -->  
<!-- #include virtual = "/dbwork/sql.lettery.elit.reg.asp" -->
<!-- #include virtual = "/pub/fn/fn.utiletc.asp" -->  
<!-- #include virtual = "/pub/fn/badmt/fn.util.rule.asp" -->  
<!-- #include virtual = "/pub/fn/badmt/fn.elite.draw.bin.asp" -->  

<% 
'   ===============================================================================     
'    Purpose : Elite 대진표 작성 - Seed No Info, Data Order Change Info를 입력받아 , Tournament를 만든다. 
'    Make    : 2019.07.24
'    Author  :                                                       By Aramdry
'   ===============================================================================    

'   ===============================================================================     
'     GameTitleIdx, GameLevelIDX를 입력받아 경기에 참가 신청한 Player 정보를 구한다. 
'     
'         예선조 적용	1. 우측 List에서 Seed를 설정한후 다음 버튼을 눌러 Ajax Call을 한다. 
'               - 이때 혼합팀 복식일 경우 List의 Order(순서)가 변경될수 있다. 
'               - order info, seed info, round, playtype(단/복식)을 parameter로 넘긴다. 
'            
'            2. aryReq를 다시 구한후 , 클라이언트에서 올라온 seed info를 적용한다. 
'            3. aryReq를 다시 구한후 , 클라이언트에서 올라온 order info를 적용한다.
'
'         예선조가 있다. 	
'            1. aryPos을 구한다. 
'            2. aryPos에 Seed정보를 적용한다. 
'            3. aryPos에 Q 정보를 적용한다. 
'            4. aryQUser를 aryReq로 부터 추출한다. 
'            5. aryUser를 aryReq로 부터 추출한다. 
'            6. aryQPos을 구한다. 
'            7. aryQPos에 Bye정보를 Setting한다. 
'            8. aryQPos에 aryQUser로 부터 인원을 할당한다. 
'            9. aryPos에 aryUser로 부터 인원을 할당한다. 
'            
'            
'         예선조가 없다	
'            1. aryPos을 구한다. 
'            2. aryPos에 Seed정보를 적용한다. 
'            3. aryPos에 Bye 정보를 적용한다. 
'            4. aryPos에 aryUser로 부터 인원을 할당한다. 
'   ===============================================================================  

%>

<%     
    Call TraceLog(SPORTS_LOG1, "lotteryElite_MakeTournament_test.asp --. start")    

    Dim db, rs, strSql
    Set db = new clsDBHelper
%>

<%
'   ////////////명령어////////////
      CMD_ELITEGAMEKIND = 1       
      CMD_SEARCHGAMETITLE = 13
      CMD_ELITESEEDPLAYER = 20        ' Get Seed Player   - 연동 대회 우수 선수 조회 
      CMD_ELITEGAMEPLAYER = 21        ' Get Elite Player  - 대회 선수 조회 
      CMD_ELITEMAKETOURNAMENT = 30    ' make Elite Tournament Info - 엘리트 선수 토너먼트를 연산한다. 
'   ////////////명령어////////////


Dim strReq, oJSONoutput, reqCmd, strLog , aryGameKind, idx, ul
Dim strSeedInfo, strTeamOrder, arySeed, aryTeamOrder, aryReq
Dim aryPos, aryQPos
Dim nRound, cPlayType, nUserCnt, cGroupGameGB
Dim hasError
Dim strPos, strQPos
'############################################
   strReq = request("REQ")
    
   ' 사용예 ex) http://badmintonadmin.sportsdiary.co.kr/Ajax/GameTitleMenu/lotteryElite_MakeTournament_test.asp?test=t  
	If request("test") = "t" Then 
        strReq = "{""CMD"":30,""TIDX"":""1591"",""LVIDX"":""9058"",""PLAYTYPE"":""B0020001"",""TEAMORDER"":""1,2,3,4,5,6,7,8,1,2,3,5,6,7,8,1,2,5,6,7,8,8"",""SEEDINFO"":""98413,1|98416,2|98421,3|98419,4"",""ROUND"":32,""USERCNT"":22,""GROUPGGB"":""B0030001""}"
      '  strReq = strReq & ",""ROUND"":128,""USERCNT"":167}"

      'response.write strReq  
      'response.end       
   End if

	If strReq = "" Then	
       Response.End 
   End if

   If InStr(strReq, "CMD") >0 then
	    Set oJSONoutput = JSON.Parse(strReq)
		reqCmd = oJSONoutput.CMD
	Else
		reqCmd = strReq
	End if

   '   Json data 추출   
   If hasown(oJSONoutput, "TIDX") = "ok" Then       
      reqTitleIdx = oJSONoutput.TIDX
   End If	

   If hasown(oJSONoutput, "LVIDX") = "ok" Then       
      reqLvIdx = oJSONoutput.LVIDX
   End If

   If hasown(oJSONoutput, "ROUND") = "ok" Then       
      nRound = CDbl(oJSONoutput.ROUND)
   End If

   If hasown(oJSONoutput, "USERCNT") = "ok" Then       
      nUserCnt = CDbl(oJSONoutput.USERCNT)
   End If

   If hasown(oJSONoutput, "PLAYTYPE") = "ok" Then       
      cPlayType = oJSONoutput.PLAYTYPE
   End If
   
   If hasown(oJSONoutput, "GROUPGGB") = "ok" Then       
      cGroupGameGB = oJSONoutput.GROUPGGB
   End If

   If hasown(oJSONoutput, "TEAMORDER") = "ok" Then       
      strTeamOrder = oJSONoutput.TEAMORDER
      If(strTeamOrder <> "") Then 
         aryTeamOrder = Split(strTeamOrder, ",")
      End If 
   End If

   If hasown(oJSONoutput, "SEEDINFO") = "ok" Then       
      strSeedInfo = oJSONoutput.SEEDINFO
      If(strSeedInfo <> "") Then 
         arySeed = Split(strSeedInfo, "|")
      End If 
   End If
   
   Call oJSONoutput.Set("result", 100 )

   Dim strJson 
   ' ***********************************************************************************************
   ' DB Work
   ' =============================================================================================== 
   If (reqCmd = CMD_ELITEMAKETOURNAMENT ) Then 
   '   ===============================================================================   
   '        GameTitleIdx, GameLevelIDX를 입력받아 경기에 참가 신청한 Player 정보를 구한다. 
   '   =============================================================================== 
   '   strSql = getSqlEliteReqPlayer(reqTitleIdx, reqLvIdx)
      If(cGroupGameGB = "B0030001") Then            ' 개인전 
         strSql = getSqlEliteReqPlayer(reqTitleIdx, reqLvIdx)
      ElseIf(cGroupGameGB = "B0030002") Then         ' 단체전 
         strSql = getSqlEliteReqTeam(reqTitleIdx, reqLvIdx)
      End If 

      If( strSql <> "" ) Then 
         Set rs = db.ExecSQLReturnRS(strSql , null, ConStr)    
         Call TraceLog(SPORTS_LOG1, "MakeTournament getSqlEliteReqPlayer = " & strSql)
         
         If Not (rs.Eof Or rs.Bof) Then 
            aryReq = rs.GetRows()
            Call oJSONoutput.Set("result", 1 )
         Else 
            Call oJSONoutput.Set("result", 100 ) 
         End If         
      End If 

      If(IsArray(aryReq)) Then 
         ' Call TraceLogInfo(aryReq, " db req data " )
         Call ReduceAryUser(aryReq, nUserCnt)
          'Call TraceLogInfo(aryReq, " reduce db req data " )

         If(IsArray(arySeed)) Then 
            Call applySeedInfo(aryReq, arySeed)
            'Call TraceLogInfo(aryReq, " apply seed data " )
         End If

         If(IsArray(aryTeamOrder)) Then 
            Call applyTeamOrderInfo(aryReq, aryTeamOrder)

						'Call TraceLogInfo(aryReq, " apply order data " )
         End If         

				 Call applyTeamCnt(aryReq)  
				 Call TraceLogInfo(aryReq, " apply data from client " )

         Call processTournamentInfo(aryReq, aryPos, aryQPos, nRound, cPlayType)
      End If

'      strjson = JSON.stringify(oJSONoutput)
'      Response.Write strjson
   End If 

	 response.End 

%>

<%
'   ===============================================================================     
      ' aryReq : position 변경 ( 혼합팀 복식일 경우 ) , seed 적용
      ' aryReq와 Round 정보를 가지고 tournament를 꾸린다. 
'   ===============================================================================
   Function processTournamentInfo(rAryReq, rAryPos, rAryQPos, nRound, playType)
      Dim IsDblGame, nUser, Idx, ub          ' 단식/복식 유무 , 참가자 수

      IsDblGame = IsDoublePlay(playType)
      ub = UBound(rAryReq, 2)
      nUser = ub + 1
      If(IsDblGame = 1) Then nUser = nUser / 2 End If    ' 복식이면 인원수를 반으로 줄인다. 

      strLog = sprintf("ub = {0}, nUser = {1}, IsDblGame = {2}, nRound = {3}, playType = {4}", Array(ub, nUser, IsDblGame, nRound, playType)) 
      Call TraceLog(SAMALL_LOG1, strLog)

      If(nUser <= nRound) Then 
         Call makeTournamentInfo(rAryReq, rAryPos, rAryQPos, nUser, nRound, IsDblGame)           ' 예선조가 없다. 
      Else
         Call makeTournamentInfoWithQ(rAryReq, rAryPos, rAryQPos, nUser, nRound, IsDblGame)      ' 예선조가 있다. 
      End If 

   End Function 

'   ===============================================================================     
      ' Tournament, Bye, Seed만 있다. nUser <= nRound
'          1. aryPos을 구한다. 
'          2. aryPos에 Seed정보를 적용한다. 
'          3. aryPos에 Bye 정보를 적용한다. 
'          4. aryPos에 aryUser로 부터 인원을 할당한다. 
'             aryPos, aryUser는 일단 반으로 나눈후 , 그 값을 다시 반으로 나누어 4등분한다. 
'   ===============================================================================
   Function makeTournamentInfo(rAryReq, rAryPos, rAryQPos, nUser, nRound, IsDblGame)      
      Dim nTourUser, nBye 
      Dim Idx, ub

      ' Call TraceLog(SAMALL_LOG1, "********************* Call makeTournamentInfo")

      ' 1. rAryPos을 구한다.
      rAryPos = exGetPosArray(nRound, IsDblGame)
      Call TraceLogInfo(rAryPos, "--- arypos allocate ---")

      ' 2. rAryPos에 Seed정보를 적용한다. 
      Call exSetSeedToPos(rAryPos, rAryReq, nRound, IsDblGame)   
      Call TraceLogInfo(rAryPos, "--- arypos seed apply ---")

      ' 3. rAryPos에 Bye 정보를 적용한다. 
      Call exApplyByeToPos(rAryPos, nUser)
      Call TraceLogInfo(rAryPos, "--- arypos bye apply ---")

'      ' 4. rAryPos에 aryUser로 부터 인원을 할당한다. rAryQPos는 사용하지 않는다. 
'      Call exSetTournamentUser(rAryPos, rAryReq, rAryQPos, IsDblGame)
'      ' ' Call TraceLogInfo(rAryPos, "--- arypos User apply ---")


      ' Call TraceLog(SAMALL_LOG1, "********************* Call makeTournamentInfo")
   End Function 

'   ===============================================================================     
      ' Tournament, Q, Seed만 있다. nUser > nRound    예선조가 있다. 
'           1. rAryPos을 구한다. 
'           2. rAryPos에 Seed정보를 적용한다. 
'           3. rAryPos에 Q 정보를 적용한다. 
'           4. aryQUser를 aryReq로 부터 추출한다. 
'           5. aryUser를 aryReq로 부터 추출한다. 
'           6. rAryQPos을 구한다. 
'           7. rAryQPos에 Bye정보를 Setting한다. 
'           8. rAryQPos에 aryQUser로 부터 인원을 할당한다. 
'           9. rAryPos에 aryUser로 부터 인원을 할당한다. 
'   ===============================================================================
   Function makeTournamentInfoWithQ(rAryReq, rAryPos, rAryQPos, nUser, nRound, IsDblGame)      
      Dim nQUser, nQGroup, nQMaxGroup           ' 예선전 출전자수, 예선조 수, 예선조 최대수 
      Dim aryTUser, aryQUser                    ' tournament 참가자, 예선조 참가자 
      Dim Idx, ub, nQPos, nMaxUser, nNewUser     
      Dim aryUser   

      'Call TraceLog(SAMALL_LOG1, "Call makeTournamentInfoWithQ")

      nQMaxGroup = exGetMaxQGroupCnt(nRound)     
      nMaxUser = (nRound - nQMaxGroup) + (nQMaxGroup * CON_QGROUP_USER)

      aryUser = rAryReq

      ' aryReq가 최대 허용 사용자 갯수를 넘으면 최대 갯수의 배열 데이터만 사용한다. 
      if(nUser > nMaxUser) Then     
         nNewUser = nMaxUser
         nUser = nMaxUser 

         If(IsDblGame = 1) Then nNewUser = 2*nNewUser End If 
         aryUser = exCopyPartAry(rAryReq, nNewUser)

      '   Call TraceLogInfo(aryUser, "--- realloc new ary ---")
      End If 
      nQGroup = exGetQGroupCnt(nUser, nRound)

      strLog = sprintf("nUser = {0}, nRound = {1}, nQGroup = {2}, nQMaxGroup = {3}, nMaxUser = {4}", _ 
                  Array(nUser, nRound, nQGroup, nQMaxGroup, nMaxUser))    
      Call TraceLog(SAMALL_LOG1, strLog)

      ' 1. rAryPos을 구한다.
      rAryPos = exGetPosArray(nRound, IsDblGame)
      ' ' ' Call TraceLogInfo(rAryPos, "--- arypos allocate ---")

      ' 2. rAryPos에 Seed정보를 적용한다. 
      Call exSetSeedToPos(rAryPos, aryUser, nRound, IsDblGame)      

      ' 3. rAryPos에 Q 정보를 적용한다. 
      Call exSetQualifierToPos(rAryPos, nQGroup, nQMaxGroup)
      'Call TraceLogInfo(rAryPos, "--- arypos set Q Pos ---")   

      ' 4. aryUser, aryQUser를 aryReq로 부터 추출한다. 
      Call exExtractAryUser(aryUser, aryTUser, aryQUser, nQGroup, nRound, IsDblGame)

      Call exResetfUse(aryTUser)
      Call exResetfUse(aryQUser)
      'Call TraceLogInfo(aryUser, " aryUser assign " )
      'Call TraceLogInfo(aryTUser, " aryTUser assign " )
      'Call TraceLogInfo(aryQUser, " aryQUser assign " )
      
      ' 6. rAryQPos을 구한다.       
      rAryQPos = exGetQPosArray(nQGroup, IsDblGame)
    '  ' ' Call TraceLogInfo(rAryQPos, "--- rAryQPos allocate ---")

      ' 7. rAryQPos에 Bye정보를 Setting한다. 
      nQUser = UBound(aryQUser, 2) + 1
      Call exSetByeInAryQPos(rAryQPos, nQUser, IsDblGame)

      strLog = sprintf("nQGroup = {0}, nQUser = {1}", Array(nQGroup, nQUser)) 
      Call TraceLog(SAMALL_LOG1, strLog)

   '   Call TraceLogInfo(rAryQPos, "--- rAryQPos bye apply ---")

      ' 8. rAryQPos에 aryQUser로 부터 인원을 할당한다. 
      Call exSetQUser(rAryQPos, aryQUser, IsDblGame)

      ' ' Call TraceLogInfo(rAryQPos, "--- rAryQPos user apply ---")
   
      ' 9. rAryPos에 aryUser로 부터 인원을 할당한다. 
      Call exSetTournamentUser(rAryPos, aryTUser, rAryQPos, IsDblGame)

   End Function 
'   ===============================================================================     
'      aryReq에 SeedInfo를 적용한다. 
'   ===============================================================================
   Function applySeedInfo(rAryReq, rArySeed)
      Dim Idx, ub, aryData, ut, strInfo
      ub = UBound(rArySeed)

      For Idx = 0 To ub
         strInfo = rArySeed(Idx)
         aryData = split(strInfo, ",")

         Call setSeedInfo(rAryReq, aryData(0), aryData(1))      
      Next
   End Function 

'   ===============================================================================     
'      aryReq에 groupIdx가 일치하는 row를 찾아서 seedNo를 셋팅해 준다. 
'   ===============================================================================
   Function setSeedInfo(rAryReq, groupIdx, seedNo)
      Dim Idx, ub
      ub = UBound(rAryReq, 2)

      For Idx = 0 To ub
         If(CStr(rAryReq(6,Idx)) = groupIdx) Then 
            rAryReq(2,Idx) = seedNo
         End If 
      Next
   End Function 

'   ===============================================================================     
'      aryReq에 OrderInfo를 적용한다. 
'   ===============================================================================
   Function applyOrderInfo(rAryReq, rAryOrder, cPlayType)      
      Dim Idx, ub, ub2, aryTmp, pos

      IsDblGame = IsDoublePlay(cPlayType)
      If(IsDblGame = 1) Then 
         Call applyOrderInfoDbl(rAryReq, rAryOrder)  
         ' Call TraceLog(SAMALL_LOG1, "Call applyOrderInfoDbl")

         Exit Function 
      End If 

      ' Call TraceLog(SAMALL_LOG1, "--------------------- Call applyOrderInfo")

      ub = UBound(rAryReq, 2)
      ub2 = UBound(rAryReq, 1)

      ReDim aryTmp(ub2, ub)

      ' Move Postion 
      For Idx = 0 To ub   
         pos = (rAryOrder(Idx)-1)    
         strLog = sprintf("  rAryOrder({0}) = {1}", Array(Idx, pos))
'         ' Call TraceLog(SAMALL_LOG1, strLog)
         Call CopyRows(rAryReq, aryTmp, pos, Idx)
      Next

      ' Copy array To source
      For Idx = 0 To ub
         Call CopyRows(aryTmp, rAryReq, Idx, Idx) 
      Next

      ' Call TraceLog(SAMALL_LOG1, "--------------------- Call applyOrderInfo")
   End Function 

   Function applyOrderInfoDbl(rAryReq, rAryOrder)      
      Dim Idx, ub, ub2, aryTmp, pos
      ub = UBound(rAryReq, 2)
      ub2 = UBound(rAryReq, 1)

      ReDim aryTmp(ub2, ub)

      ' Move Postion 
      For Idx = 0 To ub Step 2         
         pos = (rAryOrder(Idx)-1) * 2         ' 복식이므로 *2를 한다. 
         Call CopyRows(rAryReq, aryTmp, pos, Idx)
         Call CopyRows(rAryReq, aryTmp, pos+1, Idx+1)
      Next

      ' Copy array To source
      For Idx = 0 To ub
         Call CopyRows(aryTmp, rAryReq, Idx, Idx)
      Next
   End Function 

'   ===============================================================================     
'      aryReq에 TeamOrderInfo를 적용한다. 
'      aryReq의 column 갯수를 1개 더 늘린다. - Team Count 컬럼 하나 추가. 
'   ===============================================================================
   Function applyTeamOrderInfo(rAryReq, rAryOrder)      
      Dim Idx, ub, ub2, aryTmp, pos, k , m 
      ub = UBound(rAryReq, 2)
      ub2 = UBound(rAryReq, 1)

      ReDim aryTmp(ub2+1, ub)

      ' Set Team Order
      For Idx = 0 To ub                
        'rAryReq(1, Idx) = rAryOrder(Idx)				
				For k = 0 To ub2
					If(k = 0 Or k = 1) Then 
						aryTmp(0, Idx) = rAryReq(0, Idx)
						aryTmp(1, Idx) = 0
						aryTmp(2, Idx) = rAryOrder(Idx)
						m = 3
					Else 						
						aryTmp(m, Idx) = rAryReq(k, Idx)
						m = m+1
					End If 
				Next 
      Next

			rAryReq = aryTmp
   End Function 

'   ===============================================================================     
'      Entry Count보다 적은 수를 입력하면 그 인원수로 List및 Tournament를 만든다. 
'      각 팀의 1, 2, 3, .. 장 순으로 데이터를 정렬후 자른다. 
'   ===============================================================================
   Function ReduceAryUser(rAryReq, nUser)      
      Dim Idx, ub, ub2, aryTmp, pos
			Dim key, keyType, IsDesc
			
      ub = UBound(rAryReq, 2)
      nUser = CDbl(nUser)

			key 				= 5				' player order
			keyType 		= 2				' data type is number 
			IsDesc 			= 0

			Call Sort2DimAryEx(rAryReq, key, keyType, IsDesc)

      If(nUser >= (ub+1)) Then          
         Exit Function 
      End If 

      rAryReq = exCopyPartAry(rAryReq, nUser)
   End Function 

'   ===============================================================================     
'      aryUser에 각 팀의 인원수를 셋팅한다 .
'        1. team Order 순으로 정렬한다. 
'        2. team Order 갯수를 Count하여 Team 별 Count를 구한다. 
'        3. 해당 block에 team Count를 셋팅한다. 
'        4. player order 순으로 정렬한다. ( 1, 2, 3, .. 장 순)
'   ===============================================================================
   Function applyTeamCnt(ByRef rAryReq)      
      Dim Idx, ub, s_pos, e_pos, cnt_team, order_team 
			Dim key, keyType, IsDesc
			
      ub = UBound(rAryReq, 2)
      nUser = CDbl(nUser)

			' -------------------------------------------------------
			key 				= 2				' team order
			keyType 		= 2				' data type is number 
			IsDesc 			= 0

			Call Sort2DimAryEx(rAryReq, key, keyType, IsDesc)
			' -------------------------------------------------------
			order_team = -1
			e_pos = -1
			s_pos = -1

			For Idx = 0 To ub
				If( order_team <> rAryReq(2, Idx) ) Then 	
					If(s_pos = -1) Then 		' 제일 처음이면 s_pos만 셋팅한다. 
						s_pos = Idx 
					Else 
						e_pos = Idx-1 						
						Call setTeamCntBlock(rAryReq, s_pos, e_pos, cnt_team)
						
						s_pos = Idx
					End If 

					order_team = rAryReq(2, Idx)					
					cnt_team = 1
				Else 
					cnt_team = cnt_team + 1
				End If 
			Next 

			e_pos = Idx-1
			Call setTeamCntBlock(rAryReq, s_pos, e_pos, cnt_team)		

			' -------------------------------------------------------
			key 				= 6				' player order
			keyType 		= 2				' data type is number 
			IsDesc 			= 0

			Call Sort2DimAryEx(rAryReq, key, keyType, IsDesc)		
			' -------------------------------------------------------      
   End Function 

'   ===============================================================================     
'      aryUser에 s_pos, e_pos block에 cnt_team을 셋팅한다. 
'   ===============================================================================
	Function setTeamCntBlock(ByRef rAryReq, sPos, ePos, cnt_team)
		Dim Idx 

		For Idx = sPos To ePos 
			rAryReq(1, Idx) = cnt_team 
		Next 
	End Function 

%>

<% 
   Set rs = Nothing
	Call db.Dispose 
   Set db = Nothing
    ' ' ' Call TraceLog(SAMALL_LOG1, "req.badmt.asp --. end")
%>