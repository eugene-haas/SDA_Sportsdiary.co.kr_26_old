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
<!-- #include virtual = "/pub/fn/badmt/fn.elite.draw.asp" -->  

<% 
'   ===============================================================================     
'    Purpose : Elite 대진표 작성 - Seed No Info, Data Order Change Info를 입력받아 , Tournament를 만든다. 
'    Make    : 2019.07.24
'    Author  :                                                       By Aramdry
'   ===============================================================================    

'   ===============================================================================     
' 		공통	일단 본선을 4 Part로 나눈다.  (A, B, C, D)     - (Round / 2) / 2
' 			만약 예선이 있다면 본선인원, 예선 인원을 구한후 , 
' 			본선인원 = 전체 - 예선조 갯수 
' 			예선인원 = 전체 - 본선인원
' 			이유 : 데이터가 각 팀의 1장, 2장 , 3 장 순으로 / 그리고 각각은 다시 등록 순으로 정렬되어 있다. 
' 			          따라서 처음부터 특정 위치 까지 데이터를 자르면 거기 까지가 각 팀의 상위 선수가 들어간다. 
' 			
' 			전체인원수 : nTotal , 토너먼트 인원수 : nRound, 본선인원수 : nUser, 예선인원수 : nQ, Bye 수 : nBye
' 			
' 			nQ 와 nBye는 동시에 발생하지 않는다. 
' 			If( nTotal < nRound) nBye가 존재      : 전체 인원이 Tournament보다 작으면 Bye가 있다. 
' 			    nBye = nRound - nTotal 
' 			    nQ = 0
' 			    nUser = nTotal
' 			
' 			If( nTotal > nRound) nQ가 존재          : 전체 인원이 Tournament보다 많으면 예선조가 있다. 
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
    ' ' ' ''  ' ' ' ' ' ' Call TraceLog(SPORTS_LOG1, "lotteryElite_GamePlayer.asp --. start")    

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
Dim strSeedInfo, arySeed, aryReq
Dim aryPos, aryQPos
Dim nRound, cPlayType, nUserCnt, cGroupGameGB
Dim hasError
Dim strPos, strQPos
'############################################
   strReq = request("REQ")
    
   ' 사용예 ex) http://badmintonadmin.sportsdiary.co.kr/Ajax/GameTitleMenu/lotteryElite_MakeTournament_test.asp?test=t  
	If request("test") = "t" Then 
		strReq = "{""CMD"":30,""TIDX"":""1591"",""LVIDX"":""9060"",""PLAYTYPE"":""B0020002"",""SEEDINFO"":""100601,1|100609,2|100618,3"",""ROUND"":64,""USERCNT"":164,""GROUPGGB"":""B0030001""}"        
		 'strReq = "{""CMD"":30,""TIDX"":""1591"",""LVIDX"":""9061"",""PLAYTYPE"":""B0020001"",""SEEDINFO"":""100431,1|100438,2|100445,3"",""ROUND"":128,""USERCNT"":167,""GROUPGGB"":""B0030001""}"        
		' strReq = "{""CMD"":30,""TIDX"":""1591"",""LVIDX"":""9061"",""PLAYTYPE"":""B0020001"",""SEEDINFO"":""100431,1|100438,2|100445,3"",""ROUND"":128,""USERCNT"":165,""GROUPGGB"":""B0030001""}"        
      'strReq = "{""CMD"":30,""TIDX"":""1591"",""LVIDX"":""9061"",""PLAYTYPE"":""B0020001"",""TEAMORDER"":""1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,26,27,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,20,21,22,23,24,26,27,1,2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,20,21,22,23,24,26,27,1,2,3,4,5,8,9,10,11,12,13,14,15,16,17,18,20,21"",""SEEDINFO"":""100431,1|100438,2|100453,3|100445,4|100461,5|100469,6"",""ROUND"":128,""USERCNT"":120,""GROUPGGB"":""B0030001""}"        
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
		IsDblGame = IsDoublePlay(cPlayType)
   End If
   
   If hasown(oJSONoutput, "GROUPGGB") = "ok" Then       
      cGroupGameGB = oJSONoutput.GROUPGGB
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
      If(cGroupGameGB = "B0030001") Then            ' 개인전 
			If(IsDblGame = 1) Then 						' 복식 
				strSql = getSqlReqPlayerDbl(reqTitleIdx, reqLvIdx)
				' ' ' Call TraceLog(SPORTS_LOG1, "getSqlReqPlayerDbl = " & strSql)
			Else 												' 단식 
				strSql = getSqlReqPlayer(reqTitleIdx, reqLvIdx)
				' ' ' Call TraceLog(SPORTS_LOG1, "getSqlReqPlayer = " & strSql)
			End If 
      ElseIf(cGroupGameGB = "B0030002") Then         ' 단체전 
         strSql = getSqlReqTeam(reqTitleIdx, reqLvIdx)
			' ' ' Call TraceLog(SPORTS_LOG1, "getSqlReqTeam = " & strSql)
      End If 

      If( strSql <> "" ) Then 			
         Set rs = db.ExecSQLReturnRS(strSql , null, ConStr)             
         If Not (rs.Eof Or rs.Bof) Then 
            aryReq = rs.GetRows()
            Call oJSONoutput.Set("result", 1 )				
         Else 
            Call oJSONoutput.Set("result", 100 ) 
         End If         
      End If 

      If(IsArray(aryReq)) Then 
         Call ReduceAryUser(aryReq, nUserCnt)			
         If(IsArray(arySeed)) Then 
            Call applySeedInfo(aryReq, arySeed)
         End If

			' ' ' ' Call TraceLog2Dim(SAMALL_LOG1, aryReq, "Prev processTournamentInfo - aryReq")  
         Call processTournamentInfo(aryReq, aryPos, aryQPos, nRound, cPlayType)
      End If
		
      strPos   = uxGetStrFrom2DimAry(aryPos, "|", ",")
      strQPos   = uxGetStrFrom2DimAry(aryQPos, "|", ",")

      Call oJSONoutput.Set("POSARY", strPos )
      Call oJSONoutput.Set("QPOSARY", strQPos )

      strjson = JSON.stringify(oJSONoutput)
      Response.Write strjson
   End If 

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

      ' 1. rAryPos을 구한다.
      rAryPos = GetPosArray(nRound, IsDblGame)

      ' 2. rAryPos에 Seed정보를 적용한다. 
      Call SetSeedToPos(rAryPos, rAryReq, nRound, IsDblGame)   

		' ' ' ' Call TraceLog2Dim(SAMALL_LOG1, rAryPos, "after SetSeedToPos - rAryPos")

      ' 3. rAryPos에 Bye 정보를 적용한다. 
      Call ApplyByeToPos(rAryPos, nUser)

		' ' ' ' Call TraceLog2Dim(SAMALL_LOG1, rAryPos, "after ApplyByeToPos - rAryPos")

      ' 4. rAryPos에 aryUser로 부터 인원을 할당한다. 
      Call SetTournamentUser(rAryPos, rAryReq, IsDblGame)
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
      Dim aryUser, aryQTPos, aryQPart   

      nQMaxGroup = GetMaxQGroupCnt(nRound)     
      nMaxUser = (nRound - nQMaxGroup) + (nQMaxGroup * CON_QGROUP_USER)

      aryUser = rAryReq

      ' aryReq가 최대 허용 사용자 갯수를 넘으면 최대 갯수의 배열 데이터만 사용한다. 
      if(nUser > nMaxUser) Then     
         nNewUser = nMaxUser
         nUser = nMaxUser 

         If(IsDblGame = 1) Then nNewUser = 2*nNewUser End If 
         aryUser = CopyPartAry(rAryReq, nNewUser)
      End If 
      nQGroup = GetQGroupCnt(nUser, nRound)

      ' 1. rAryPos을 구한다.
      rAryPos = GetPosArray(nRound, IsDblGame)

      ' 2. rAryPos에 Seed정보를 적용한다. 
      Call SetSeedToPos(rAryPos, aryUser, nRound, IsDblGame)      

		strLog = sprintf("makeTournamentInfoWithQ nQGroup = {0}, ", Array(nQGroup ))
      ' ' ' Call TraceLog(SPORTS_LOG1, strLog) 

      ' 3. rAryPos에 Q 정보를 적용한다. 
	   aryQPart = GetQAssignPart(nQGroup)
		Call AssignQPos(rAryPos, aryQPart, E_PART_A)
		Call AssignQPos(rAryPos, aryQPart, E_PART_B)
		Call AssignQPos(rAryPos, aryQPart, E_PART_C)
		Call AssignQPos(rAryPos, aryQPart, E_PART_D)

	'	' ' ' Call TraceLog1Dim(SAMALL_LOG1, aryQPart, 1, "aryQPart")
	'	' ' ' Call TraceLog2Dim(SAMALL_LOG1, rAryPos, "GetQAssignPart - rAryPos")
   
      ' 4. aryUser, aryQUser를 aryReq로 부터 추출한다. 
      Call ExtractAryUser(aryUser, aryTUser, aryQUser, nQGroup, nRound, IsDblGame)

      Call ResetfUse(aryTUser)
      Call ResetfUse(aryQUser)

	'	' ' ' Call TraceLog2Dim(SAMALL_LOG1, aryUser, "After ExtractAryUser - aryUser")
	'	' ' ' Call TraceLog2Dim(SAMALL_LOG1, aryTUser, "After ExtractAryUser - aryTUser")
	'	' ' ' Call TraceLog2Dim(SAMALL_LOG1, aryQUser, "After ExtractAryUser - aryQUser")
		
		' 5. rAryPos에 aryUser로 부터 인원을 할당한다. 		
		Call SetTournamentUser(rAryPos, aryTUser, IsDblGame)

		' ' ' Call TraceLog2Dim(SAMALL_LOG1, rAryPos, "SetTournamentUser - rAryPos")
		
	  ' 6. rAryQPos을 구한다.       
      rAryQPos = GetQPosArray(nQGroup, IsDblGame)

      ' 7. rAryQPos에 Bye정보를 Setting한다. 		
      nQUser = UBound(aryQUser, 2) + 1
      Call SetByeInAryQPos(rAryQPos, nQUser, IsDblGame)

		' 8. rAryQPos에 aryQUser로 부터 인원을 할당한다. 
      Call SetQUser(aryQUser, rAryQPos, rAryPos, IsDblGame)

		' ' ' Call TraceLog2Dim(SAMALL_LOG1, aryQUser, "After SetQUser - aryQUser")
		' ' ' Call TraceLog2Dim(SAMALL_LOG1, rAryQPos, "After SetQUser - rAryQPos")

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
'      Entry Count보다 적은 수를 입력하면 그 인원수로 List및 Tournament를 만든다. 
'      각 팀의 1, 2, 3, .. 장 순으로 데이터를 정렬후 자른다. 
'   ===============================================================================
   Function ReduceAryUser(rAryReq, nUser)      
      Dim Idx, ub, ub2, aryTmp, pos
			
      ub = UBound(rAryReq, 2)
      nUser = CDbl(nUser)

      If(nUser >= (ub+1)) Then          
         Exit Function 
      End If 

      rAryReq = CopyPartAry(rAryReq, nUser)
   End Function 
%>

<% 
   Set rs = Nothing
	Call db.Dispose 
   Set db = Nothing
%>