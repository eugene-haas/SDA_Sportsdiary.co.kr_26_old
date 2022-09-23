<!-- #include virtual = "/dev/config.asp"-->
<!-- #include virtual = "/classes/JSON_2.0.4.asp" -->
<!-- #include virtual = "/classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include virtual = "/classes/json2.asp" -->

<!-- #include virtual = "/pub/hdr.inc.bm.min.asp" -->  
<!-- #include virtual = "/pub/fn/badmt/res/res.pubcode.asp" -->  
<!-- #include virtual = "/pub/fn/badmt/res/res.teamGB.asp" -->  
<!-- #include virtual = "/dbwork/sql.lettery.elit.reg.asp" -->

<% 
'   ===============================================================================     
'    Purpose : Elite 대진표 작성 - 연동대회에서 상위 입상자를 구한다. 
'    Make    : 2019.05.29
'    Author  :                                                       By Aramdry
'   ===============================================================================    
'   ===============================================================================     
'     1. GameTitleIdx, 게임종별 Info(Sex, TeamGb, PlayType, GroupGameGb, Rank) 를 입력받아 GameLevelIdx를 구한다.  (tblGameLevel)
'       ex) playType = 단식, TeamGb = 일반부, Level = 30, Sex = 남자, GroupGameGb = 개인전, LevelJooName = A

'     2. GameTitleIDX, GameLevelIdx를 가지고 메달 선수 (공동 3위까지 구하는 정보)를 구한다. aryMedal (tblGameMedal & tblTourneyPlayer)
'     3. GameTitleIDX, GameLevelIdx를 가지고 nRank까지의 Player Info를 구한다. arySeed (tblGameOperate & tblTourneyPlayer & tblTeamInfo) 
'           - 토너먼트로 가정하고 구하고 그이후 rank값에 따라 리그에서 구할수도 있다. 
'      4. nRank까지의 Player Info가 없을 경우 
'         4-1) nRank <= 3위 이면 - 리그 데이터를 구한다. 
'         4-2) nRank > 3위 이면 Error이다. 
'      5. Player Info에 16강, 8강, 4강의 정보를 기술하기 위하여 
'         5-1) nRank > 8 이면 8강 정보를 구한다. (tblGameOperate) - aryRank8
'         5-2) nRank > 4 이면 4강 정보를 구한다. (tblGameOperate) - aryRank4
'
'      6. Client 에서는 aryRank4, aryRank8, aryMedal의 정보를 arySeed에 Merge하여 순위 정보가 있는 
'         상위 Player Info를 구한다. 
'
'   ===============================================================================  
'   Ranking 16강 데이터에 8강, 4강을 한번에 Merge하는 쿼리 - 길어서 안쓴다. 
'   Select TP.TourneyGroupIDX, 
'      (
'            Case When 
'                  Exists ( Select L_TourneyGroupIDX, R_TourneyGroupIDX From tblGameOperate  As GOP4 With (NoLock) 
'                        Where GOP4.DelYn = 'N' AND GOP4.GameTitleIDX = '1169' AND GOP4.GameLevelIDX = '5342' And GOP4.NowRoundName = '4강' 
'                        And (GOP4.L_TourneyGroupIDX = TP.TourneyGroupIDX Or GOP4.R_TourneyGroupIDX = TP.TourneyGroupIDX)  )
'                  Then 4
'               When 
'                  Exists ( Select L_TourneyGroupIDX, R_TourneyGroupIDX From tblGameOperate  As GOP8 With (NoLock) 
'                        Where GOP8.DelYn = 'N' AND GOP8.GameTitleIDX = '1169' AND GOP8.GameLevelIDX = '5342' And GOP8.NowRoundName = '8강' 
'                        And (GOP8.L_TourneyGroupIDX = TP.TourneyGroupIDX Or GOP8.R_TourneyGroupIDX = TP.TourneyGroupIDX)  )
'                  Then 8
'               Else 16
'            End 
'         ) As GameRanking, 
'      TP.MemberIDX, TP.UserName, TP.SEX, TP.TEAM 
'   From tblGameOperate  As GOP With (NoLock) 
'   Inner Join tblTourneyPlayer As TP With (NoLock) On TP.DelYN = 'N'
'      And (GOP.L_TourneyGroupIDX = TP.TourneyGroupIDX Or GOP.R_TourneyGroupIDX = TP.TourneyGroupIDX) 
'   Where GOP.DelYn = 'N' AND GOP.GameTitleIDX = '1169' AND GOP.GameLevelIDX = '5342' And GOP.NowRoundName = '16강'
'   Order By GameRanking
'
'   ===============================================================================  
'      위에 쿼리를 아래의 쿼리로 쪼개서 사용한다. 클라이언트에서 Ranking Merge 
'  Select TP.TourneyGroupIDX, '0' As GameRanking, TP.MemberIDX, TP.UserName, TP.SEX, TP.TEAM From tblGameOperate  As GOP With (NoLock) Inner Join tblTourneyPlayer As TP With (NoLock) On TP.DelYN = 'N' And (GOP.L_TourneyGroupIDX = TP.TourneyGroupIDX Or GOP.R_TourneyGroupIDX = TP.TourneyGroupIDX) Where GOP.DelYn = 'N' AND GOP.GameTitleIDX = '1169' AND GOP.GameLevelIDX = '5342' And GOP.NowRoundName = '16강'
'  
'  Select L_TourneyGroupIDX, R_TourneyGroupIDX From tblGameOperate  As GOP8 With (NoLock) Where GOP8.DelYn = 'N' AND GOP8.GameTitleIDX = '1169' AND GOP8.GameLevelIDX = '5342' And GOP8.NowRoundName = '8강'
'  Select L_TourneyGroupIDX, R_TourneyGroupIDX From tblGameOperate  As GOP4 With (NoLock) Where GOP4.DelYn = 'N' AND GOP4.GameTitleIDX = '1169' AND GOP4.GameLevelIDX = '5342' And GOP4.NowRoundName = '4강'
'   ===============================================================================  
%>

<%     
    ' Call TraceLog(SPORTS_LOG1, "lotteryElite_SeedPlayer.asp --. start")    

    Dim db, rs, strSql
    Set db = new clsDBHelper
%>

<%
'   ////////////명령어////////////
      CMD_ELITEGAMEKIND = 1       
      CMD_SEARCHGAMETITLE = 13
      CMD_ELITESEEDPLAYER = 20        ' Get Seed Player   - 연동 대회 우수 선수 조회 
      CMD_ELITEGAMEPLAYER = 21        ' Get Elite Player  - 대회 선수 조회 
'   ////////////명령어////////////


Dim strReq, oJSONoutput, reqCmd, strLog , aryGameKind, idx, ul
Dim hasError, cTitleIdx, cSex, cTeamGB, cPlayType, cGroupGameGB, nRank 
'############################################
   strReq = request("REQ")
    
   ' 사용예 ex) http://badmintonadmin.sportsdiary.co.kr/Ajax/GameTitleMenu/lotteryElite_SeedPlayer.asp?test=t  
	If request("test") = "t" Then 
        strReq = "{""CMD"":20,""ENCTIDX"":""5BE7B297A6F7069EC9375F25E036E46B"",""RANK"":4,""SEX"":""Man"",""TEAMGB"":""15001"",""PTYPE"":""B0020002"",""GROUPGGB"":""B0030001""}"
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
   If hasown(oJSONoutput, "ENCTIDX") = "ok" Then       
      cTitleIdx = fInject(crypt.DecryptStringENC(oJSONoutput.ENCTIDX))
   End If	
   
   If hasown(oJSONoutput, "RANK") = "ok" Then       
      nRank = CDbl(oJSONoutput.RANK)
   End If

   If hasown(oJSONoutput, "SEX") = "ok" Then       
      cSex = oJSONoutput.SEX
   End If

   If hasown(oJSONoutput, "TEAMGB") = "ok" Then       
      cTeamGB = oJSONoutput.TEAMGB
   End If

   If hasown(oJSONoutput, "PTYPE") = "ok" Then       
      cPlayType = oJSONoutput.PTYPE
   End If

   If hasown(oJSONoutput, "GROUPGGB") = "ok" Then       
      cGroupGameGB = oJSONoutput.GROUPGGB
   End If

   
   Call oJSONoutput.Set("result", 100 )

   strLog = strPrintf("titleIdx = {0}, cSex = {1}, cTeamGB = {2}, cPlayType = {3}, cGroupGameGB = {4}, rank = {5}", _ 
                     Array(cTitleIdx, cSex, cTeamGB, cPlayType, cGroupGameGB, nRank))

   ' ' ' Call TraceLog(SAMALL_LOG1, strLog) 

   Dim strJson 
   ' ***********************************************************************************************
   ' DB Work
   ' =============================================================================================== 
   If (reqCmd = CMD_ELITESEEDPLAYER ) Then 
   '   ===============================================================================   
   '     GameTitleIdx, 게임종별 Info(Sex, TeamGb, PlayType, GroupGameGb, Rank) 를 입력받아 GameLevelIdx를 구한다. 
   '     GameLevelIdx 이 없거나 1개 이상일 경우 문제가 있다. ( 본선일 경우는 무조건 해당 종별이 하나다)
   '
   '     GameLevelIdx의 구해진 Count를 알기 위해 recordset.RecordCount 
   '
   '     1. GameTitleIdx, Sex, TeamGb, PlayType, GroupGameGb, Rank 를 입력받아 GameLevelIdx를 구한다. (tblGameLevel)
   '       ex) playType = 단식, TeamGb = 일반부, Level = 30, Sex = 남자, GroupGameGb = 개인전, LevelJooName = A

   '     2. GameTitleIDX, GameLevelIdx를 가지고 메달 선수 (공동 3위까지 구하는 정보)를 구한다. aryMedal (tblGameMedal & tblTourneyPlayer)
   '     3. GameTitleIDX, GameLevelIdx를 가지고 nRank까지의 Player Info를 구한다. arySeed (tblGameOperate & tblTourneyPlayer) 
   '           - 토너먼트로 가정하고 구하고 그이후 rank값에 따라 리그에서 구할수도 있다. 
   '      4. nRank까지의 Player Info가 없을 경우 
   '         4-1) nRank <= 3위 이면 - 리그 데이터를 구한다. 
   '         4-2) nRank > 3위 이면 Error이다. 
   '      5. Player Info에 16강, 8강, 4강의 정보를 기술하기 위하여 
   '         5-1) nRank > 8 이면 8강 정보를 구한다. (tblGameOperate) - aryRank8
   '         5-2) nRank > 4 이면 4강 정보를 구한다. (tblGameOperate) - aryRank4
   '
   '      6. Client 에서는 aryRank4, aryRank8, aryMedal의 정보를 arySeed에 Merge하여 순위 정보가 있는 
   '         상위 Player Info를 구한다. 
   '   =============================================================================== 

      ' 1. GameTitleIdx, Sex, TeamGb, PlayType, GroupGameGb, Rank 를 입력받아 GameLevelIdx를 구한다. (tblGameLevel)
      strSql = getSqlEliteAssociateGameLevel(cTitleIdx, cSex, cTeamGB, cPlayType, cGroupGameGB)
      If( strSql <> "" ) Then 
         Set rs = db.ExecSQLReturnRS(strSql , null, ConStr)    
         ' Call TraceLog(SPORTS_LOG1, "getSqlEliteAssociateGameLevel = " & strSql)
         
         Dim gameLvIdx
         If Not (rs.Eof Or rs.Bof) Then             
            gameLvIdx = rs("GameLevelidx")            

            ' GameLevelidx 가 1개가 아니면 에러다. ( 없거나 2개 이상일 경우 )
            If( rs.RecordCount <> 1 ) Then            
               Call oJSONoutput.Set("result", 101 )
               rs.Close
            Else 
               Dim err_Medal, err_Rank
               err_Medal = 1
               err_Rank = 1
               rs.Close

               ' 2강 이하면 2강으로 하고 데이터를 구한다. ( tblGameOperate에 2강 까지의 정보만 존재 - 1강은 없다. )
               If( nRank < 2 ) Then nRank = 2 End If 

               '     1. GameTitleIDX, GameLevelIdx, rank를 가지고 Player정보를 구한다.  - 토너먼트로 가정하고 
               strRank = strPrintf("{0}강", Array(nRank))
               strSql = getSqlEliteRankPlayer(cTitleIdx, gameLvIdx, strRank)
               
               If( strSql <> "" ) Then 
                  Set rs = db.ExecSQLReturnRS(strSql , null, ConStr)    
                  ' ' ' Call TraceLog(SPORTS_LOG1, "getSqlEliteRankPlayer = " & strSql)

                  If Not (rs.Eof Or rs.Bof) Then 
                     err_Rank = 0
                     strJson = rsTojson_arr(rs)
                     ' ' ' Call TraceLog(SPORTS_LOG1, strJson) 
                     Call oJSONoutput.Set("result", 1 )
                     Call oJSONoutput.Set("RANKPLAYER", strJson )
                     rs.Close
                  Else 
                     ' 선택한 강수 데이터가 없고 nRank <= 3면 리그에서 데이터를 조회해 본다. 
                     if(nRank <= 3) Then 
                        strRank = "리그"
                        strSql = getSqlEliteRankPlayer(cTitleIdx, gameLvIdx, strRank)

                         If( strSql <> "" ) Then 
                           Set rs = db.ExecSQLReturnRS(strSql , null, ConStr)    
                           ' ' ' Call TraceLog(SPORTS_LOG1, "리그 getSqlEliteRankPlayer = " & strSql)

                           If Not (rs.Eof Or rs.Bof) Then 
                              err_Rank = 0
                              strJson = rsTojson_arr(rs)
                              ' ' ' Call TraceLog(SPORTS_LOG1, strJson) 
                              Call oJSONoutput.Set("result", 1 )
                              Call oJSONoutput.Set("LEAGUE", 1 )
                              Call oJSONoutput.Set("RANKPLAYER", strJson )
                              rs.Close
                           End If 
                        End If 
                     End If 
                  End If 
               End If 

               '     2. GameTitleIDX, GameLevelIdx, rank를 가지고 8강 정보를 구한다.  - groupIdx만 있음
               If(nRank = 16) Then                
                  strRank = "8강"
                  strSql = getSqlEliteRankInfo(cTitleIdx, gameLvIdx, strRank)
                  
                  If( strSql <> "" ) Then 
                     Set rs = db.ExecSQLReturnRS(strSql , null, ConStr)    
                     ' ' ' Call TraceLog(SPORTS_LOG1, "8강 getSqlEliteRankInfo = " & strSql)

                     If Not (rs.Eof Or rs.Bof) Then                         
                        strJson = rsTojson_arr(rs)
                        ' ' ' Call TraceLog(SPORTS_LOG1, strJson) 
                        Call oJSONoutput.Set("result", 1 )
                        Call oJSONoutput.Set("RANK8", strJson )
                        rs.Close
                     End If 
                  End If                  
               
               End If 

               '     3. GameTitleIDX, GameLevelIdx, rank를 가지고 4강 정보를 구한다.  - groupIdx만 있음 
               If(nRank >= 8) Then 
                  strRank = "4강"
                  strSql = getSqlEliteRankInfo(cTitleIdx, gameLvIdx, strRank)
                  
                  If( strSql <> "" ) Then 
                     Set rs = db.ExecSQLReturnRS(strSql , null, ConStr)    
                     ' ' ' Call TraceLog(SPORTS_LOG1, "4강 getSqlEliteRankInfo = " & strSql)

                     If Not (rs.Eof Or rs.Bof) Then                         
                        strJson = rsTojson_arr(rs)
                        ' ' ' Call TraceLog(SPORTS_LOG1, strJson) 
                        Call oJSONoutput.Set("result", 1 )
                        Call oJSONoutput.Set("RANK4", strJson )
                        rs.Close
                     End If 
                  End If
               End If

               '     GameTitleIDX, GameLevelIdx를 가지고 Medal 정보를 구한다.                
               strSql = getSqlEliteMedalPlayer(cTitleIdx, gameLvIdx)
               
               If( strSql <> "" ) Then 
                  Set rs = db.ExecSQLReturnRS(strSql , null, ConStr)    
                  ' ' ' Call TraceLog(SPORTS_LOG1, "getSqlEliteMedalPlayer = " & strSql)

                  If Not (rs.Eof Or rs.Bof) Then 
                     err_Medal = 0
                     strJson = rsTojson_arr(rs)
                     ' ' ' Call TraceLog(SPORTS_LOG1, strJson)  
                     Call oJSONoutput.Set("result", 1 )
                     Call oJSONoutput.Set("MEDAL", strJson )
                     rs.Close
                  End If 
               End If 

               If (err_Medal = 1 Or err_Rank = 1) Then 
                  Call oJSONoutput.Set("result", 102 )
               End If 

            End If 
         Else 
            Call oJSONoutput.Set("result", 100 )
         End If         
      End If 

      strjson = JSON.stringify(oJSONoutput)
      Response.Write strjson
   End If 

%>

<% 
   Set rs = Nothing
	Call db.Dispose 
   Set db = Nothing
    ' ' ' ' Call TraceLog(SAMALL_LOG1, "req.badmt.asp --. end")
%>


<%
'   /*
'	16강, 8강 구하는 정보 
'   */
'
'   -- base
'   Select * From tblGameOperate
'   WHERE DelYn = 'N' 
'   AND GameTitleIDX = '1169'
'   AND GameLevelIDX = '5338'
'   And NowRoundName = '16강'
'
'   -- lv 1 
'   Select TP.TourneyGroupIDX, '0' As GameRanking, TP.MemberIDX, TP.UserName, TP.SEX, TP.TEAM From tblGameOperate As GOP 
'   Inner Join tblTourneyPlayer As TP 
'      On TP.DelYN = 'N' And (GOP.L_TourneyGroupIDX = TP.TourneyGroupIDX Or GOP.R_TourneyGroupIDX = TP.TourneyGroupIDX)
'   WHERE GOP.DelYn = 'N' 
'   AND GOP.GameTitleIDX = '1169'
'   AND GOP.GameLevelIDX = '5338'
'   And GOP.NowRoundName = '8강'
'
'   /*
'	   메달 선수 (공동 3위까지 구하는 정보)
'   */
'   SELECT GM.TourneyGroupIDX, GM.GameRanking, TP.MemberIDX, TP.UserName, TP.SEX, TP.TEAM
'   FROM tblGameMedal As GM
'   Inner Join (
'      Select IGM.TourneyGroupIDX, max(IGM.GameMedalIDX) As GameMedalIDX 
'      From tblGameMedal As IGM
'      Where DelYN = 'N' 
'      AND GameTitleIDX = '1169'
'      AND GameLevelIDX = '5338'
'      Group By IGM.TourneyGroupIDX
'   ) As SGM 
'   On GM.GameMedalIDX = SGM.GameMedalIDX
'
'   Inner Join tblTourneyPlayer As TP On GM.TourneyGroupIDX = TP.TourneyGroupIDX And TP.DelYN = 'N'
'   Order By  GM.TourneyGroupIDX
%> 