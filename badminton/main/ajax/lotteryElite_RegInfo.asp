<!-- #include virtual = "/dev/config.asp"-->
<!-- #include virtual = "/classes/JSON_2.0.4.asp" -->
<!-- #include virtual = "/classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include virtual = "/classes/json2.asp" -->

<!-- #include virtual = "/pub/hdr.inc.bm.min.asp" -->  
<!-- #include virtual = "/pub/fn/fn.utiletc.asp" -->  
<!-- #include virtual = "/dbwork/sql.lettery.elit.reg.asp" -->


<% 
'   ===============================================================================     
'        -------------------------------------------------------------------------
'        기본 Info 
'        Purpose: Elite 대진표를 등록한다. (여기서는 토너먼트만 다룬다. 예선조: 토너먼트, 본선: 토너먼트 )
'           - reqTitleIdx 	- Game Title Idx
'           - reqLvIdx 		- Game Level Idx
'           - nRound 		- 본선 Round
'           - nQGroup 		- 예선전 조 갯수 
'           - IsQFinal 		- 예선전이 4강이 기본인데 / 결승전으로 처리할지 유무 
'           - aryPos 		- 본선 진출자 Position 정보및 Game Group Idx 
'           - aryQPos 		- 예선조 Position 정보및 Game Group Idx    
'           - arySeed 		- Seed Info
'
'        1. GameLevelIdx로 GameLevel Info를 가져온다. 
'            GroupGameGb(개인전/단체전), EnterType(엘리트 : E , 아마추어 : A), PlayType(단식, 복식, 혼합복식)
'        2. nQGroup != "" 이면 예선조가 존재한다. 
'        3. 예선조의 JooRank(설정된 순위까지만 본선진출)는 1명이다 - 토너먼트 이므로 
'        4. 예선조 기본 강수는 4강, IsQFinal = 1일 경우만 2강(결승)이다
'        5. 본선의 강수는 nRound 이다. 
'        -----------------------------------------------------------------------
'        개인전 process 
'        1. tblGameLevelDtl에 gameLevelDtl을 추가한다. 
'           추가 갯수 = nQGroup(예선갯수) + 1 (본선갯수)
'        2. gameLevelDtl을 추가하면서 생성되는 gameLevelDtlIdx을 저장하여 추후 다른테이블 작업시 참조한다. 
'           예선조의 GameLevelDtlIdx은 aryQDtlInfo에 저장한다.
'           본선조의 GameLevelDtlIdx은 FinalDtlInfo에 저장한다.
'        3. 예선조, 본선조의 Position Info를 가지고 tblGameRequestTouney를 Insert한다. 
'           이때 Bye, Q는 추가하지 않는다. (실제 reqGroupIdx값이 있는 경우만 추가)
'        4. 예선조, 본선조의 Position Info를 가지고 table에 Insert한다. 
'            개인전인 경우 
'            4-1. tblTourneyGroup을 Insert한다. 
'            4-2. tblTourneyPlayer을 Insert한다. 
'            4-3. tblTourney을 Insert한다.	
'            단체전인 경우 
'            4-4. tblTourneyTeam을 Insert한다.	
'        5. GameTitle : GameLevel = 1: N 
'            GameLevel : GameLevelDtl = 1:N 
'            GameLevelDtl : tblGameRequestTouney = 1:N
'            GameLevelDtl : tblTourneyGroup = 1:N
'            GameLevelDtl : tblTourney = 1:N
'            GameLevelDtl : tblTourneyTeam = 1:N
'            
'            tblTourney : tblTourneyGroup  = 1:1
'            tblTourneyGroup : tblTourneyPlayer  = 1:1 / 1:2 (단식/복식)
'        -----------------------------------------------------------------------
'        단체전 process 
'        1. tblGameLevelDtl에 gameLevelDtl을 추가한다. 
'           추가 갯수 = nQGroup(예선갯수) + 1 (본선갯수)
'        2. gameLevelDtl을 추가하면서 생성되는 gameLevelDtlIdx을 저장하여 추후 다른테이블 작업시 참조한다. 
'           예선조의 GameLevelDtlIdx은 aryQDtlInfo에 저장한다.
'           본선조의 GameLevelDtlIdx은 FinalDtlInfo에 저장한다.
'        3. 예선조, 본선조의 Position Info를 가지고 tblGameRequestTouney를 Insert한다. 
'           이때 Bye, Q는 추가하지 않는다. (실제 reqGroupIdx값이 있는 경우만 추가)


'        4. 예선조, 본선조의 Position Info를 가지고 table에 Insert한다. 
'            개인전인 경우 
'            4-1. tblTourneyGroup을 Insert한다. 
'            4-2. tblTourneyPlayer을 Insert한다. 
'            4-3. tblTourney을 Insert한다.	
'            단체전인 경우 
'            4-4. tblTourneyTeam을 Insert한다.	
'        5. GameTitle : GameLevel = 1: N 
'            GameLevel : GameLevelDtl = 1:N 
'            GameLevelDtl : tblGameRequestTouney = 1:N
'            GameLevelDtl : tblTourneyGroup = 1:N
'            GameLevelDtl : tblTourney = 1:N
'            GameLevelDtl : tblTourneyTeam = 1:N
'            
'            tblTourney : tblTourneyGroup  = 1:1
'            tblTourneyGroup : tblTourneyPlayer  = 1:1 / 1:2 (단식/복식)

'   ===============================================================================    


%>

<%     
    ' ' ' ' '' Call TraceLog(SPORTS_LOG1, "lotteryElite_RegInfo.asp --. start")    

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
      CMD_ELITEREGINFO = 40           ' Elite Tonament Info를 등록한다. 
'   ////////////명령어////////////


Dim strReq, oJSONoutput, reqCmd, strLog , aryGameKind, idx, ul
Dim strPos, strQPos, strSeedInfo, strGameNo, strQGameNo
Dim aryPos, aryQPos, arySeed, aryGameNo, aryQGameNo
Dim nRound, IsQFinal, nQGroup
Dim hasError
'############################################
   strReq = request("REQ")   
    
   ' 사용예 ex) http://badmintonadmin.sportsdiary.co.kr/Ajax/GameTitleMenu/lotteryElite_RegInfo.asp?test=t  
	If request("test") = "t" Then 
        'strReq = "{""CMD"":40,""TIDX"":""1591"",""LVIDX"":""9058"",""QFINAL"":0,""POSINFO"":""98413,0,98417,0,98422,0,98430,98433,98419,0,98426,98424,98415,0,98435,98428,98414,98418,0,98421,98434,98425,0,98423,98420,98427,0,98432,0,98429,0,98416"",""QPOSINFO"":"""",""GAMENO"":""0,0,0,1,0,2,0,3,4,0,5,0,6,0,0,0,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21"",""QGAMENO"":"""",""SEEDINFO"":""0,1|31,2"",""ROUND"":32,""QGROUP"":0}"
		  strReq = "{""CMD"":40,""TIDX"":""1591"",""LVIDX"":""9066"",""QFINAL"":0,""POSINFO"":""98356,98374,98365,Q1,98362,Q2,98369,98360,98363,98357,98366,98367,98364,98371,98368,98359"",""QPOSINFO"":""98361,0,98370,98372|98358,0,98373,98375"",""GAMENO"":""1,2,3,4,5,6,7,8,9,10,11,12,13,14,15"",""QGAMENO"":""0,1,0,2,3,4"",""SEEDINFO"":""0,1|15,2"",""ROUND"":16,""QGROUP"":2}"
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
   If hasown(oJSONoutput, "TIDX") = "ok" Then            ' Game Title Idx 
      reqTitleIdx = oJSONoutput.TIDX
   End If	

   If hasown(oJSONoutput, "LVIDX") = "ok" Then           ' Game Level Idx
      reqLvIdx = oJSONoutput.LVIDX
   End If

   If hasown(oJSONoutput, "ROUND") = "ok" Then           ' 본선 Round
      nRound = CDbl(oJSONoutput.ROUND)
   End If

   If hasown(oJSONoutput, "QGROUP") = "ok" Then          ' 예선전 조 갯수 
      nQGroup = CDbl(oJSONoutput.QGROUP)
   End If

   If hasown(oJSONoutput, "QFINAL") = "ok" Then          ' 예선전이 4강이 기본인데 / 결승전으로 처리할지 유무 
      IsQFinal = oJSONoutput.QFINAL
   End If


'   ===============================================================================     
'    strPos =95932,95951,Q4,95946,95940,95930,Q2,95927,95936,Q3,95947,95931,95933,Q1,95926,95943
'    Data : GroupIdx,  0 : Bye, Q1, Q2...: 예선 1조, 2조...
'   ===============================================================================    
   If hasown(oJSONoutput, "POSINFO") = "ok" Then         ' 본선 진출자 Position 정보및 Game Group Idx 
      strPos = oJSONoutput.POSINFO
      If(strPos <> "") Then 
         aryPos = Split(strPos, ",")
         ' ' ' ' ' '' Call TraceLog1Dim(SPORTS_LOG1, aryPos, 5, "-------------- aryPos ------------------")
      End If 
   End If	

'   ===============================================================================     
'    strQPos =95937,0,95952,95949|95938,0,95953,95950|95939,95934,95928,95941|95948,95935,95929,95942
'     | 을 기준으로 예선조를 구분한다. 
'    예선조 값은 , 로 구분되어 있다. 
'    Data : GroupIdx,  0 : Bye
'    예외) strQPos =95937,95952 와 같이 값이 2개만 있을 경우 예선조가 1개이고, 결승으로 셋팅한다. 
'          예선조 나머지는 4강 토너먼트 이다. 
'   ===============================================================================  
   If hasown(oJSONoutput, "QPOSINFO") = "ok" Then        ' 예선조 Position 정보및 Game Group Idx    
      strQPos = oJSONoutput.QPOSINFO
      If(strQPos <> "") Then 
         aryQPos = Split(strQPos, "|")
         ' ' ' ' ' '' Call TraceLog1Dim(SPORTS_LOG1, aryQPos, 5, "-------------- aryQPos ------------------")
      End If 
   End If    

'   ===============================================================================     
'		strGameNo : "1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31"
'    Data : Tournament Game Info , 0 : Bye
'   ===============================================================================    
   If hasown(oJSONoutput, "GAMENO") = "ok" Then         ' 본선 Game No 
      strGameNo = oJSONoutput.GAMENO
      If(strGameNo <> "") Then 
         aryGameNo = Split(strGameNo, ",")
         ' ' '' Call TraceLog(SPORTS_LOG1, "strGameNo = "& strGameNo)
      End If 
   End If	

'   ===============================================================================     
'    strQGameNo: "1,2,3,4,5,6,7,8,9"
'    Data : Tournament Game Info , 0 : Bye
'   ===============================================================================    
   If hasown(oJSONoutput, "QGAMENO") = "ok" Then         ' 예선 GameNo 
      strQGameNo = oJSONoutput.QGAMENO
      If(strQGameNo <> "") Then 
         aryQGameNo = Split(strQGameNo, ",")
         ' ' '' Call TraceLog(SPORTS_LOG1, "strQGameNo = "& strQGameNo)
      End If 
   End If	

'   ===============================================================================     
'    strSeedInfo =1,1|12,3|16,2  (pos,seedNum|pos,seedNum.. )
'     | 을 기준으로 SeedInfo를 구분한다. 
'   ===============================================================================  
   If hasown(oJSONoutput, "SEEDINFO") = "ok" Then        
      strSeedInfo = oJSONoutput.SEEDINFO
      If(strSeedInfo <> "") Then 
         arySeed = Split(strSeedInfo, "|")
         ' ' ' ' '' Call TraceLog1Dim(SPORTS_LOG1, arySeed, 5, "-------------- arySeed ------------------")
      End If 
   End If  

   strLog = sprintf("lotteryElite_RegInfo.asp reqTitleIdx = {0}, reqLvIdx = {1}, IsQFinal = {2}, nRound = {3}, nQGroup = {4}", _
            Array(reqTitleIdx , reqLvIdx, IsQFinal, nRound, nQGroup))
   '' Call TraceLog(SPORTS_LOG1, strLog)

	'response.End 
   
   Call oJSONoutput.Set("result", 100 )

   
   ' ***********************************************************************************************
   ' gameType : B0040001	리그, B0040002	토너먼트
   ' gameGb   : B0010001	국내대회, B0010002	국제대회
   ' groupGameGb : B0030001	개인전, B0030002	단체전
   ' entryType : E Elite, A : Ama
   ' playType : B0020001	단식, B0020002	복식
   ' =============================================================================================== 
   Dim strJson 
   Dim gameType, gameGb, totalRound, jooRank   
   Dim groupGameGb, entryType, playType
   Dim aryQDtlIdx, strQDtlIdx, strFDtlIdx, strDtlIdx
   ' ***********************************************************************************************
   ' DB Work
   ' =============================================================================================== 
   If (reqCmd = CMD_ELITEREGINFO ) Then 
      gameType       = "B0040002"         ' 토너먼트      

   ' For test
   '   For Idx = 0 To 16
   '      seedPos = GetSeedPos(arySeed, Idx)
   '      ' strLog = sprintf("pos = {0}, seedPos = {1}", Array(Idx, seedPos))
   '      ' ' ' ' ' '' Call TraceLog(SPORTS_LOG1, strLog)
   '   Next 

	' =============================================================================================== 
   '      이전 데이터를 지워준다. - tblGameTitle
   ' =============================================================================================== 
      strSql = getSqlResetAutoTonament(reqTitleIdx) 
      strLog = sprintf("getSqlResetAutoTonament = {0}", Array(strSql))               
      ' ' ' ' '' Call TraceLog(SPORTS_LOG1, strLog)                                
      If( strSql <> "" ) Then 
         Call db.execSQLRs(strSql , null, ConStr)  
      End If

	' =============================================================================================== 
   '      이전 데이터를 지워준다. - tblGameLevelDtl
   ' =============================================================================================== 
   '   strSql = getSqlDelLevelDtl(reqTitleIdx , reqLvIdx) 
   '   strLog = sprintf("getSqlDelLevelDtl = {0}", Array(strSql))               
   '   ' ' ' ' '' Call TraceLog(SPORTS_LOG1, strLog)                                
   '   If( strSql <> "" ) Then 
   '      Call db.execSQLRs(strSql , null, ConStr)  
   '   End If

   ' =============================================================================================== 
   '      이전 데이터를 지워준다. - tblGameLevelDtl
   ' =============================================================================================== 
      strSql = getSqlDelLevelDtl(reqTitleIdx , reqLvIdx) 
      strLog = sprintf("getSqlDelLevelDtl = {0}", Array(strSql))               
      ' ' ' ' '' Call TraceLog(SPORTS_LOG1, strLog)                                
      If( strSql <> "" ) Then 
         Call db.execSQLRs(strSql , null, ConStr)  
      End If

   ' =============================================================================================== 
   '      이전 데이터를 지워준다. - tblGameRequestTouney
   ' =============================================================================================== 
      strSql = getSqlDelRequestTourney(reqTitleIdx , reqLvIdx) 
      strLog = sprintf("getSqlDelRequestTourney = {0}", Array(strSql))               
      ' ' ' ' '' Call TraceLog(SPORTS_LOG1, strLog)                                
      If( strSql <> "" ) Then 
         Call db.execSQLRs(strSql , null, ConStr)  
      End If

   ' =============================================================================================== 
   '      이전 데이터를 지워준다. - tblTourney
   ' =============================================================================================== 
      strSql = getSqlDelTourney(reqTitleIdx , reqLvIdx) 
      strLog = sprintf("getSqlDelTourney = {0}", Array(strSql))               
      ' ' ' ' '' Call TraceLog(SPORTS_LOG1, strLog)                                
      If( strSql <> "" ) Then 
         Call db.execSQLRs(strSql , null, ConStr)  
      End If

   ' =============================================================================================== 
   '      이전 데이터를 지워준다. - tblTourneyTeam
   ' =============================================================================================== 
      strSql = getSqlDelTourneyTeam(reqTitleIdx , reqLvIdx) 
      strLog = sprintf("getSqlDelTourneyTeam = {0}", Array(strSql))               
      ' ' ' ' '' Call TraceLog(SPORTS_LOG1, strLog)                                
      If( strSql <> "" ) Then 
         Call db.execSQLRs(strSql , null, ConStr)  
      End If

   ' =============================================================================================== 
   '      이전 데이터를 지워준다. - tblTourneyGroup
   ' =============================================================================================== 
      strSql = getSqlDelTourneyGroup(reqTitleIdx , reqLvIdx) 
      strLog = sprintf("getSqlDelTourneyGroup = {0}", Array(strSql))               
      ' ' ' ' '' Call TraceLog(SPORTS_LOG1, strLog)                                
      If( strSql <> "" ) Then 
         Call db.execSQLRs(strSql , null, ConStr)  
      End If

   ' =============================================================================================== 
   '      이전 데이터를 지워준다. - tblTourneyPlayer
   ' ===============================================================================================    
      strSql = getSqlDelTourneyPlayer(reqTitleIdx , reqLvIdx) 
      strLog = sprintf("getSqlDelTourneyPlayer = {0}", Array(strSql))               
      ' ' ' ' '' Call TraceLog(SPORTS_LOG1, strLog)                                
      If( strSql <> "" ) Then 
         Call db.execSQLRs(strSql , null, ConStr)  
      End If

   ' =============================================================================================== 
   '      이전 데이터를 지워준다. - tblGameOperate   경기진행순서 최신화 PROC
   ' =============================================================================================== 
   '   strSql = getSqlDelTourneyPlayer(reqTitleIdx , reqLvIdx) 
      strSql = getSqlDelGameOperate(reqTitleIdx , reqLvIdx) 
      strLog = sprintf("getSqlDelGameOperate = {0}", Array(strSql))               
      ' ' ' ' '' Call TraceLog(SPORTS_LOG1, strLog)                                
      If( strSql <> "" ) Then 
         Call db.execSQLRs(strSql , null, ConStr)  
      End If

	' =============================================================================================== 
   '      GameTitleIdx를 입력받아 tblGameTitle에 자동 대진 셋팅 Flag를 set한다. 
   ' ===============================================================================================    
      strSql = getSqlSetAutoTonament(reqTitleIdx) 
      strLog = sprintf("getSqlSetAutoTonament = {0}", Array(strSql))               
      '' Call TraceLog(SPORTS_LOG1, strLog)                                
      If( strSql <> "" ) Then 
         Call db.execSQLRs(strSql , null, ConStr)  
      End If

   
   ' =============================================================================================== 
   '      GameLevelDtlIdx를 추가한다. 
   ' =============================================================================================== 
      If(nQGroup <> "") Then     ' 예선조를 추가한다. 
         gameGb         = "B0100001"         ' 예선                   
         jooRank        = 1
         totalRound     = 4
         If(IsQFinal = 1) Then totalRound = 2 End IF     ' 예선조가 1개이고 인원이 2명이면 결승이다. 

         For Idx = 1 To nQGroup
            strSql = getSqlInsertGameLvDtl(reqTitleIdx, reqLvIdx, gameGb, gameType, totalRound, Idx, jooRank ) 
            If( strSql <> "" ) Then 
               Set rs = db.ExecSQLReturnRS(strSql , null, ConStr)    
               '' Call TraceLog(SPORTS_LOG1, "lotteryElite_RegInfo.asp - 예선 getSqlInsertGameLvDtl " & strSql)               
               
               If Not (rs.Eof Or rs.Bof) Then   
                  If(Idx = 1) Then 
                     strQDtlIdx = rs("Seq")
                  Else 
                     strQDtlIdx = sprintf("{0},{1}", Array(strQDtlIdx, rs("Seq")))
                  End If 
                  rs.Close
               End If
            End If
         Next 
      End If 

      ' 본선조를 추가한다. 
      gameGb         = "B0100002"         ' 본선 
      totalRound     = nRound
      jooRank        = 1   

      strSql = getSqlInsertGameLvDtl(reqTitleIdx, reqLvIdx, gameGb, gameType, totalRound, 1, jooRank ) 
      If( strSql <> "" ) Then 
         Set rs = db.ExecSQLReturnRS(strSql , null, ConStr)    
         '' Call TraceLog(SPORTS_LOG1, "lotteryElite_RegInfo.asp - 본선 getSqlInsertGameLvDtl " & strSql)              
         
         If Not (rs.Eof Or rs.Bof) Then   
            strFDtlIdx = rs("Seq")
            rs.Close
         End If
      End If

   ' =============================================================================================== 
   '      Level Info를 얻는다. 
   ' =============================================================================================== 
      strSql = getSqlLevelInfo(reqLvIdx) 
      If( strSql <> "" ) Then  
         Set rs = db.ExecSQLReturnRS(strSql , null, ConStr)    
         '' Call TraceLog(SPORTS_LOG1, "lotteryElite_RegInfo.asp - getSqlLevelInfo " & strSql)              
         
         If Not (rs.Eof Or rs.Bof) Then               
            groupGameGb = rs("GroupGameGb")
            entryType = rs("EnterType")
            playType = rs("PlayType")
            rs.Close
         End If
      End If

      If(groupGameGb = "B0030001") Then 
         '' Call TraceLog(SPORTS_LOG1, " ********************** 개인전 ")    
      ElseIf(groupGameGb = "B0030002") Then  
         '' Call TraceLog(SPORTS_LOG1, " ********************** 단체전 ")    
      End IF 

   ' =============================================================================================== 
   '      tblGameRequestTouney를 추가한다. 
   '      tblGameRequestTouney를 추가할 때, Bye나 Q는 추가하지 않는다. 
   '      ReqGroupIdx가 있는 경우만 추가한다. 
   '      ex) 예선1조 4강 : 인원3   -> tblGameRequestTouney에서 3개만 검색됨   
   '      ex) 본선 16강 : 인원9   -> tblGameRequestTouney에서 9개만 검색됨   
   ' =============================================================================================== 
      Dim k, ul2, strTmp, aryQTmp, requestIdx
      If(nQGroup <> "") Then     ' 예선조를 추가한다.          
         aryQDtlIdx = Split(strQDtlIdx, ",")
         ul = UBound(aryQDtlIdx)         

         For idx = 0 To ul 
            strDtlIdx = aryQDtlIdx(idx)
            strTmp    = aryQPos(idx)
            aryQTmp = Split(strTmp, ",")  ' 예선조가 1조씩 strTmp에 , 로 구분되어 들어 있다. 이를 배열로 저장

            ul2 = UBound(aryQTmp)    
         
            For k = 0 To ul2              ' 각 예선조 안의 예선 인원 만큼 Loop를 돈다. 
               requestIdx = aryQTmp(k)
               strSql = getSqlInsertRequestTourney(reqTitleIdx, reqLvIdx, strDtlIdx, requestIdx, groupGameGb) 
               strLog = sprintf("예선 {0}번째 requestIdx = {1}, getSqlInsertRequestTourney = {2}", Array(k, requestIdx, strSql))               
              ' Call TraceLog(SPORTS_LOG1, strLog)                                
               If( strSql <> "" ) Then 
                  Call db.execSQLRs(strSql , null, ConStr)        
               End If
            Next
         Next
      End If 

      ' 본선조를 추가한다. aryPos
      ul = UBound(aryPos)         

      For idx = 0 To ul 
         requestIdx = aryPos(idx)
         strSql = getSqlInsertRequestTourney(reqTitleIdx, reqLvIdx, strFDtlIdx, requestIdx, groupGameGb) 
         strLog = sprintf("본선 {0}번째 requestIdx = {1}, getSqlInsertRequestTourney = {2}", Array(idx, requestIdx, strSql))               
        ' Call TraceLog(SPORTS_LOG1, strLog)                                
         If( strSql <> "" ) Then 
            Call db.execSQLRs(strSql , null, ConStr)  
         End If
      Next
   End If 

   ' =============================================================================================== 
   '      GameLevelDtl Info를 얻는다. 
   ' ===============================================================================================
   Dim aryDtlInfo
   strSql = getSqlSelectGameLvDtl(reqTitleIdx, reqLvIdx) 
   If( strSql <> "" ) Then  
      Set rs = db.ExecSQLReturnRS(strSql , null, ConStr)    
      '' Call TraceLog(SPORTS_LOG1, "lotteryElite_RegInfo.asp - getSqlSelectGameLvDtl " & strSql)              
      
      If Not (rs.Eof Or rs.Bof) Then               
         aryDtlInfo = rs.GetRows()
         rs.Close

         '' Call TraceLogInfo(aryDtlInfo, " GameLevelDtl Info " )
      End If
   End If  

   ' ===============================================================================================    
   '      tblTourneyGroup를 추가한다. 
   '      tblTourneyPlayer를 추가한다. 
   '      tblTourneyGroup, tblTourneyPlayer를 추가할 때, Bye나 Q는 추가하지 않는다. 
   '      ReqGroupIdx가 있는 경우만 추가한다. 
   '      ex) 예선1조 4강 : 인원3   -> tblGameRequestTouney에서 3개만 검색됨   
   '      ex) 본선 16강 : 인원9   -> tblGameRequestTouney에서 9개만 검색됨   
   '  GameTitleIDX, GameLevelIdx, GameLevelDtlIdx, PlayLevelType, TeamGb, GroupGameGb, Level, LevelDtlName, Sex, TotRound, CntRound
   ' =============================================================================================== 
   If(IsArray(aryDtlInfo)) Then 
      ub =  UBound(aryDtlInfo, 2)

      Dim rTitleIdx, rLvIdx, rLvDtlIdx, rPlayLvType, rTeamGb, rGroupGameGb
      Dim rLv, rLvDtlName, rSex, rRound, rCntRound, aryTmp
      Dim ub2

      Dim TourneyGroupIDX, GameNum, TourneyGroupNum, TourneyNum, OrderBy
      Dim rQ, rBye, rSeed, retKind

		Dim cntNo, cntQNo, gameNo, cntQFNo  

		cntNo = 0
		cntQNo = 0
		cntQFNo = (nQGroup * 2)-1	' 예선전 결승 Game Num은 예선전 Group 갯수 * 2

		strLog = sprintf("aryDtlInfo cnt = {0}, cntQFNo = {1}", Array(ub, cntQFNo))
		'' Call TraceLog(SPORTS_LOG1, strLog)  
	'	response.End 

      For Idx = 0 To ub                ' ------------------------ game Level Dtl Loop start

         rTitleIdx         = aryDtlInfo(0, Idx)         'GameTitleIDX
         rLvIdx            = aryDtlInfo(1, Idx)         'GameLevelIdx
         rLvDtlIdx         = aryDtlInfo(2, Idx)         'GameLevelDtlIdx
         rPlayLvType       = aryDtlInfo(3, Idx)         'PlayLevelType
         rTeamGb           = aryDtlInfo(4, Idx)         'TeamGb
         rGroupGameGb      = aryDtlInfo(5, Idx)         'GroupGameGb
         rLv               = aryDtlInfo(6, Idx)         'Level
         rLvDtlName        = aryDtlInfo(7, Idx)         'LevelDtlName
         rSex              = aryDtlInfo(8, Idx)         'Sex
         rRound            = aryDtlInfo(9, Idx)         'TotRound
         rCntRound         = aryDtlInfo(10, Idx)        'CntRound
         rRound            = CDbl(rRound)
         rCntRound         = CDbl(rCntRound)

         If(rPlayLvType = "B0100001") Then      ' 예선 
            strTmp      = aryQPos(Idx)
            aryTmp      = Split(strTmp, ",")
         Else 
            aryTmp      = aryPos                ' 본선
         End If 

         strLog = sprintf(" rCntRound = {0}, rRound = {1}, rGroupGameGb = {2}, rPlayLvType = {3}", Array(rCntRound, rRound, rGroupGameGb, rPlayLvType))
         '' Call TraceLog(SPORTS_LOG1, strLog )    

         ' ***********************************************************************************************
         ' ***********************************************************************************************
         If(rGroupGameGb = "B0030001") Then      ' 개인전 

            ' -----------------------------------------------------------------------------------------------
            '      예선조, 본선조의 Position Info를 가지고 table에 Insert한다. 
            '        개인전인 경우 
            '        4-1. tblTourneyGroup을 Insert한다. 
            '        4-2. tblTourneyPlayer을 Insert한다. 
            '        4-3. tblTourney을 Insert한다.	
            '        4-4. Empty Round tblTourney을 Insert한다.	
            ' -----------------------------------------------------------------------------------------------
               ub2 = UBound(aryTmp)            

               TourneyGroupNum       = 100          ' 101부터 시작 
               TourneyNum     = 100          ' 101부터 시작 
               GameNum        = 0            ' 실제적인 Tourney구분자 , 2개에 1씩 증가 
               Def_Round      = "1"
               Def_teamGameNum      = "0"
               For k = 0 To ub2           ' ------------------------ aryQPos/aryPos Loop start
                  reqGroupIdx = aryTmp(k)
                  rQ = NULL 
                  rBye = "N"
                  rSeed = 0
                  TourneyGroupIDX = "0"

                  TourneyNum  = TourneyNum + 1
                  OrderBy     = k + 1

						If(rPlayLvType = "B0100001") Then      ' 예선 
							If(k <> 0 And k Mod 2 = 0) Then 	cntQNo 		= cntQNo + 1 End If 	' 2 개가 1개의 게임이다. 
							gameNo 		= aryQGameNo(cntQNo)												
						Else 
							If(k <> 0 And k Mod 2 = 0) Then 	cntNo 		= cntNo + 1 End If 	' 2 개가 1개의 게임이다. 
							gameNo 		= aryGameNo(cntNo)								
						End If 

						If(gameNo = 0) Then gameNo = NULL End If 


                  If(OrderBy Mod 2) = 1 Then GameNum = GameNum + 1 End If  ' gameNum setting 

                  retKind = GetKindReqGroupIdx(reqGroupIdx)      ' 1 : reqGroupIdx, 2: Bye, 3: Q 
                  If( retKind = 1 ) Then           
                     TourneyGroupNum = TourneyGroupNum + 1

                     ' -----------------------------------------------------------------------------------------------
                     '      4-1. tblTourneyGroup을 Insert한다.
                     ' -----------------------------------------------------------------------------------------------                  
                     strSql = getSqlInsertTourneyGroup( reqTitleIdx, rLvDtlIdx, rTeamGb, rLv, rLvDtlName, TourneyGroupNum)

							strLog = sprintf(" reqTitleIdx = {0} , rLvDtlIdx = {1}, rTeamGb = {2}, rLv = {3}, rLvDtlName = {4}, TourneyGroupNum = {5}", Array(reqTitleIdx, rLvDtlIdx, rTeamGb, rLv, rLvDtlName, TourneyGroupNum))
                  	'' Call TraceLog(SPORTS_LOG1, strLog )  

							strLog = sprintf(" getSqlInsertTourneyGroup strSql = {0}", Array(strSql))
                  	'' Call TraceLog(SPORTS_LOG1, strLog )  

                     If( strSql <> "" ) Then  
                       	strLog = sprintf(" getSqlInsertTourneyGroup ({0}, {1}) reqIdx = {2}=> {3}", Array(Idx, k, aryTmp(k), strSql))
                  		'' Call TraceLog(SPORTS_LOG1, strLog )          
                        Set rs = db.ExecSQLReturnRS(strSql , null, ConStr)                             
                        
                        If Not (rs.Eof Or rs.Bof) Then               
                           TourneyGroupIDX = rs("Seq")
                           rs.Close
                        End If
                     End If  

                     ' -----------------------------------------------------------------------------------------------
                     '      4-2. tblTourneyPlayer을 Insert한다.
                     ' -----------------------------------------------------------------------------------------------                                    
                     strSql = getSqlInsertTourneyPlayer( reqTitleIdx, rLvDtlIdx, rTeamGb, rLv, rLvDtlName, TourneyGroupIDX, rSex, reqGroupIdx) 
                     If( strSql <> "" ) Then  
                        strLog = sprintf(" getSqlInsertTourneyPlayer ({0}, {1}) reqIdx = {2}=> {3}", Array(Idx, k, aryTmp(k), strSql))
                     	'' Call TraceLog(SPORTS_LOG1, strLog )          
                        Call db.execSQLRs(strSql , null, ConStr)                          
                     End If  
                     
                  Else     ' Q 나 Bye다 
                     If(retKind = 2) Then                         ' Bye 이면 
                        rBye = "Y"        
                     ElseIf(retKind = 3) Then                     ' Q이면 
                        rQ = etcGetBlockData(reqGroupIdx, "Q", "")
                        reqGroupIdx = "0"
                     End If 
                  End If 

                  ' 본선에서만 Seed값 체크 
                  If(rPlayLvType = "B0100002") Then  rSeed = GetSeedPos(arySeed, k) End If 
                  
                  strLog = sprintf(" ({0}, {1}) reqGroupIdx = {2}, seed = {3}, bye = {4}, , Q = {5}", Array(Idx, k, reqGroupIdx, rSeed, rBye, rQ))
                  '' Call TraceLog(SPORTS_LOG1, strLog )  

                  ' -----------------------------------------------------------------------------------------------
                  '      4-3. tblTourney을 Insert한다.
                  ' -----------------------------------------------------------------------------------------------                                                   
                  strSql = getSqlInsertTourney( reqTitleIdx, reqLvIdx, rLvDtlIdx, rTeamGb, rGroupGameGb, rLv, rLvDtlName, reqGroupIdx, _
                                                TourneyGroupIDX, TourneyNum, Def_Round, Def_teamGameNum, GameNum, OrderBy, rBye, rQ, rSeed, gameNo ) 
                  If( strSql <> "" ) Then  
                     strLog = sprintf(" getSqlInsertTourney ({0}, {1}) reqIdx = {2}=> {3}", Array(Idx, k, aryTmp(k), strSql))
                  	'' Call TraceLog(SPORTS_LOG1, strLog )          
                     Call db.execSQLRs(strSql , null, ConStr)                          
                  End If 

               Next                       ' ------------------------ aryQPos/aryPos Loop end

            ' =============================================================================================== 
            '      빈 강수를 추가한다. tblTourney
            '        결승일때는 추가 하지 않는다. 최소 4강 이하.. 
            ' ===============================================================================================   
               If(rRound > 2) Then  
                  nRoundVal         = rRound
                  Empty_OrderBy     = rRound 
                  Empty_GameNum     = GameNum
                  Empty_Round       = 1
                  Empty_ReqGroupIdx       = ""
                  Empty_TourneyGroupIDX   = "0"
                  Empty_TourneyNum        = ""


                  Empty_Bye         = "N"
                  Empty_Q           = ""
                  Empty_Seed       = "0"

                  For m = 1 To (rCntRound -1)               ' ------------------------ Insert Empty Round Loop Start
                     nRoundVal = nRoundVal / 2
                     Empty_Round = Empty_Round + 1

							If(rPlayLvType = "B0100001") Then      ' 예선 
								cntQFNo 		= cntQFNo + 1									
							Else 
								cntNo 		= cntNo + 1							
							End If 

                     For n = 1 To nRoundVal
								If(rPlayLvType = "B0100001") Then      ' 예선 
									If(n <> 1 And n Mod 2 = 1) Then 	cntQFNo 		= cntQFNo + 1 End If 	' 2 개가 1개의 게임이다. 
									gameNo 		= aryQGameNo(cntQFNo)									
								Else 
									If(n <> 1 And n Mod 2 = 1) Then 	cntNo 		= cntNo + 1 End If 	' 2 개가 1개의 게임이다. 	
									gameNo 		= aryGameNo(cntNo)									
								End If 

								If(gameNo = 0) Then gameNo = NULL End If 

                        Empty_OrderBy = Empty_OrderBy + 1
                        If(Empty_OrderBy Mod 2) = 1 Then Empty_GameNum = Empty_GameNum + 1 End If  ' gameNum setting 

                        strSql = getSqlInsertTourney( reqTitleIdx, reqLvIdx, rLvDtlIdx, rTeamGb, rGroupGameGb, rLv, rLvDtlName, _ 
                                                      Empty_ReqGroupIdx, Empty_TourneyGroupIDX, Empty_TourneyNum, Empty_Round, "0", _ 
                                                      Empty_GameNum, Empty_OrderBy, Empty_Bye, Empty_Q, Empty_Seed, gameNo ) 
                        If( strSql <> "" ) Then  
                           strLog = sprintf(" Empty getSqlInsertTourney ({0}, {1}) => {2}", Array(m, n, strSql))
                           '' Call TraceLog(SPORTS_LOG1, strLog )          
                           Call db.execSQLRs(strSql , null, ConStr)                          
                        End If 
                     Next 
                  Next                                      ' ------------------------ Insert Empty Round Loop End
               End If 

				' =============================================================================================== 
            '      부전승자 진출 PROC   - 
            ' ===============================================================================================
             strSql = sprintf("UPDATE_BYE '{0}'", Array(rLvDtlIdx))
            ' ' ' ' ' '' Call TraceLog(SPORTS_LOG1, strSql )    
             Call db.execSQLRs(strSql , null, ConStr)  

				' =============================================================================================== 
            '      게임 수 
            ' ===============================================================================================
            strSql = sprintf("UPDATE_GameCnt '{0}', '{1}', '{2}'", Array(reqTitleIdx, reqLvIdx, rLvDtlIdx))
            ' ' ' ' ' '' Call TraceLog(SPORTS_LOG1, strSql )    
             Call db.execSQLRs(strSql , null, ConStr)  

            ' =============================================================================================== 
            '      tblGameOperate를 추가한다.  경기진행순서 최신화 PROC   
            ' ===============================================================================================
            strSql = sprintf("Insert_tblGameOperate '{0}','','{1}','',''", Array(reqTitleIdx, rLvDtlIdx))
            '' Call TraceLog(SPORTS_LOG1, strSql )    
            Call db.execSQLRs(strSql , null, ConStr)    

            ' ***********************************************************************************************
            ' ***********************************************************************************************                 
         ElseIf(rGroupGameGb = "B0030002") Then      ' 단체전  
            ' -----------------------------------------------------------------------------------------------
            '      예선조, 본선조의 Position Info를 가지고 table에 Insert한다. 
            '        단체전인 경우 
            '        4-1. tblTourneyTeam을 Insert한다.	
            '        4-2. Empty Round tblTourneyTeam을 Insert한다.	
            ' -----------------------------------------------------------------------------------------------       
            
               ub2 = UBound(aryTmp)            
               
               TourneyTeamNum     = 100          ' 101부터 시작 
               TeamGameNum        = 0            ' 실제적인 Tourney구분자 , 2개에 1씩 증가 
               Def_Round      = "1"
               For k = 0 To ub2           ' ------------------------ aryQPos/aryPos Loop start
                  reqGroupIdx = aryTmp(k)
                  rQ = NULL 
                  rBye = "N"
                  rSeed = 0
                  TourneyGroupIDX = "0"

                  TourneyTeamNum  = TourneyTeamNum + 1
                  OrderBy     = k + 1


                  If(OrderBy Mod 2) = 1 Then TeamGameNum = TeamGameNum + 1 End If  ' TeamGameNum setting 

                  retKind = GetKindReqGroupIdx(reqGroupIdx)      ' 1 : reqGroupIdx, 2: Bye, 3: Q 
                  If(retKind = 2) Then                         ' Bye 이면 
                     rBye = "Y"        
                  ElseIf(retKind = 3) Then                     ' Q이면 
                     rQ = etcGetBlockData(reqGroupIdx, "Q", "")
                     reqGroupIdx = "0"
                  End If 

						If(rPlayLvType = "B0100001") Then      ' 예선 
							If(k <> 0 And k Mod 2 = 0) Then 	cntQNo 		= cntQNo + 1 End If 	' 2 개가 1개의 게임이다. 
							gameNo 		= aryQGameNo(cntQNo)							
						Else 
							If(k <> 0 And k Mod 2 = 0) Then 	cntNo 		= cntNo + 1 End If 	' 2 개가 1개의 게임이다. 
							gameNo 		= aryGameNo(cntNo)							
						End If 

						If(gameNo = 0) Then gameNo = NULL End If 

                  ' 본선에서만 Seed값 체크 
                  If(rPlayLvType = "B0100002") Then  rSeed = GetSeedPos(arySeed, k) End If 
                  
                   strLog = sprintf(" ({0}, {1}) reqGroupIdx = {2}, seed = {3}, bye = {4}, , Q = {5}", Array(Idx, k, reqGroupIdx, rSeed, rBye, rQ))
                   '' Call TraceLog(SPORTS_LOG1, strLog )  

                  ' -----------------------------------------------------------------------------------------------
                  '      4-3. tblTourneyTeam을 Insert한다.
                  ' -----------------------------------------------------------------------------------------------                                                   
                  strSql = getSqlInsertTourneyTeam( reqTitleIdx, reqLvIdx, rLvDtlIdx, rTeamGb, rLv, rLvDtlName, _
                                                reqGroupIdx, TourneyTeamNum, Def_Round, TeamGameNum, OrderBy, rBye, rQ, rSeed, gameNo )
                  If( strSql <> "" ) Then  
                     strLog = sprintf(" getSqlInsertTourneyTeam ({0}, {1}) reqIdx = {2}=> {3}", Array(Idx, k, aryTmp(k), strSql))
                  	'' Call TraceLog(SPORTS_LOG1, strLog )          
                     Call db.execSQLRs(strSql , null, ConStr)                            
                  End If 

               Next                       ' ------------------------ aryQPos/aryPos Loop end

            ' =============================================================================================== 
            '      빈 강수를 추가한다. tblTourneyTeam
            '        결승일때는 추가 하지 않는다. 최소 4강 이하.. 
            ' ===============================================================================================   
               If(rRound > 2) Then  
                  nRoundVal         = rRound
                  Empty_OrderBy     = rRound 
                  Empty_TeamGameNum     = TeamGameNum
                  Empty_Round       = 1
                  Empty_ReqGroupIdx       = ""
                  Empty_TourneyTeamNum        = ""


                  Empty_Bye         = "N"
                  Empty_Q           = ""
                  Empty_Seed       = "0"

                  For m = 1 To (rCntRound -1) 
                     nRoundVal = nRoundVal / 2
                     Empty_Round = Empty_Round + 1

							If(rPlayLvType = "B0100001") Then      ' 예선 
								cntQFNo 		= cntQFNo + 1									
							Else 
								cntNo 		= cntNo + 1					
							End If 

                     For n = 1 To nRoundVal
								If(rPlayLvType = "B0100001") Then      ' 예선 
									If(n <> 1 And n Mod 2 = 1) Then 	cntQFNo 		= cntQFNo + 1 End If 	' 2 개가 1개의 게임이다. 
									gameNo 		= aryQGameNo(cntQFNo)									
								Else 
									If(n <> 1 And n Mod 2 = 1) Then 	cntNo 		= cntNo + 1 End If 	' 2 개가 1개의 게임이다. 	
									gameNo 		= aryGameNo(cntNo)									
								End If 

								If(gameNo = 0) Then gameNo = NULL End If 

                        Empty_OrderBy = Empty_OrderBy + 1
                        If(Empty_OrderBy Mod 2) = 1 Then Empty_TeamGameNum = Empty_TeamGameNum + 1 End If  ' gameNum setting 

                        strSql = getSqlInsertTourneyTeam( reqTitleIdx, reqLvIdx, rLvDtlIdx, rTeamGb, rLv, rLvDtlName, _ 
                                          Empty_ReqGroupIdx, Empty_TourneyTeamNum, Empty_Round, Empty_TeamGameNum, Empty_OrderBy, _
                                          Empty_Bye, Empty_Q, Empty_Seed, gameNo )
                        
                        If( strSql <> "" ) Then  
                           strLog = sprintf(" Empty getSqlInsertTourneyTeam ({0}, {1}) => {2}", Array(m, n, strSql))
                        	'' Call TraceLog(SPORTS_LOG1, strLog )          
                           Call db.execSQLRs(strSql , null, ConStr)                          
                        End If 
                     Next 
                  Next 
               End If 

				' =============================================================================================== 
            '      부전승자 진출 PROC   - 
            ' ===============================================================================================
             strSql = sprintf("UPDATE_BYE '{0}'", Array(rLvDtlIdx))
            ' ' ' ' ' '' Call TraceLog(SPORTS_LOG1, strSql )    
             Call db.execSQLRs(strSql , null, ConStr)  

				' =============================================================================================== 
            '      게임 수 
            ' ===============================================================================================
            strSql = sprintf("UPDATE_GameCnt '{0}', '{1}', '{2}'", Array(reqTitleIdx, reqLvIdx, rLvDtlIdx))
            ' ' ' ' ' '' Call TraceLog(SPORTS_LOG1, strSql )    
            Call db.execSQLRs(strSql , null, ConStr)  


            ' =============================================================================================== 
            '      tblGameOperate를 추가한다.  경기진행순서 최신화 PROC   
            ' ===============================================================================================
             strSql = sprintf("Insert_tblGameOperate '{0}','','{1}','',''", Array(reqTitleIdx, rLvDtlIdx))
            ' ' ' ' ' '' Call TraceLog(SPORTS_LOG1, strSql )    
             Call db.execSQLRs(strSql , null, ConStr)   
         End If 

			If(rPlayLvType = "B0100001") Then      ' 예선 
				cntQNo 		= cntQNo + 1								
			End If 

      Next                             ' ------------------------ game Level Dtl Loop end       


    LSQL = " UPDATE tblTourney SET KR_DPGameNum = dbo.FN_LeagueGameNum_KR(A.GameLeveldtlIDX, GameType, A.TourneyGroupIDX, '', GroupGameGb, TeamGameNum, GameNum) "
    LSQL = LSQL & " FROM tblTourney A"
    LSQL = LSQL & " INNER JOIN tblGameLevelDtl B ON B.GameLeveldtlIDx = A.GameLeveldtlIDX"
    LSQL = LSQL & " WHERE A.DelYN = 'N'"
    LSQL = LSQL & " AND B.DelYN = 'N'"
    LSQL = LSQL & " AND A.GameLevelDtlIDX = '" & reqLvIdx & "'"
    Call db.execSQLRs(LSQL , null, ConStr)    

	Call oJSONoutput.Set("result", 1 )
	strjson = JSON.stringify(oJSONoutput)   

	Response.Clear
	Response.Write strjson
	Response.End

   End If 


   

%>

<%
   ' =============================================================================================== 
   '      pos에 seed가 존재 하는지 유무 - 존재하면 1이상 , 없으면 0
   ' ===============================================================================================
   Function GetSeedPos(rArySeed, pos)
      Dim Idx, ub , seedPos, strData, aryData
      seedPos = 0

      If(IsArray(rArySeed)) Then 
         ub = UBound(rArySeed)
         For Idx = 0 To ub 
            strData = rArySeed(Idx)
            aryData = Split(strData, ",")

            If(CDbl(aryData(0)) = pos) Then 
               seedPos = CDbl(aryData(1))
               Exit For
            End If 
         Next 
      End If 

      GetSeedPos = seedPos 
   End Function 

   ' =============================================================================================== 
   '      reqGroupIdx가 GroupIdx값이면 return 1
   '                    bye(0) 이면    return 2 
   '                    Q (Q1, Q2...)일 경우 return 3
   ' ===============================================================================================
   Function GetKindReqGroupIdx(reqGroupIdx)
      Dim ret 
      ret = 1

      If(reqGroupIdx = "") Or (reqGroupIdx = "0") Then   ' bye
         ret = 2           
      ElseIf(Instr(reqGroupIdx, "Q") <> 0) Then          ' Q 
         ret = 3
      End If 
      GetKindReqGroupIdx = ret
   End Function 
%>

<% 
   Set rs = Nothing
	Call db.Dispose 
   Set db = Nothing
    ' ' ' ' ' ' ' ' '' Call TraceLog(SAMALL_LOG1, "req.badmt.asp --. end")
%>