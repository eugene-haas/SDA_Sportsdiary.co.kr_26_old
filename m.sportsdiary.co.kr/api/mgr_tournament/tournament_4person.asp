<!--#include virtual="/app/api/_func/encoding.asp"-->
<!--#include virtual="/app/api/_conn/DBCon.asp"-->
<!--#include virtual="/app/api/_func/Utill.asp"-->
<!--#include virtual="/app/api/_Func/json2.asp"-->

<!--#include virtual="/app/api/_Func/utx_config.asp"-->
<% 	
	'=================================================================================
	'  Purpose  : 	유도 App - 대진표 - 리그 
	'  Author   : 															By Aramdry
	'================================================================================= 	
%>

<% 	
   
   '=================================================================================
   '  GameType		
   '     GameType : sd043006	4인(3,4위전)
   '     sd043002	토너먼트
   '     sd043004	5인(토너먼트+리그)
   '     sd043005	국가대표최종평가전
   '     sd043006	4인(3,4위전)
   '        
   '  UnearnWin		
   '     sd042001	일반전
   '     sd042002	부전승
   '        
   '  LeftRightGb		
   '     sd030001	왼쪽
   '     sd030002	오른쪽

   ' Result
   '    sd019001	승(한판)
   '    sd019002	승(절반)
   '    sd019003	승(유효)
   '    sd019004	승(지도)
   '    sd019005	승(반칙)
   '    sd019006	승(부전)
   '    sd019007	패(한판)
   '    sd019008	패(절반)
   '    sd019009	패(유효)
   '    sd019010	패(지도)
   '    sd019011	패(반칙)
   '    sd019012	패(부전)
   '    sd019015	승(우세1)
   '    sd019016	패(우세1)
   '    sd019021	불참
   '    sd019022	승(기권)
   '    sd019023	패(기권)
   '    sd019024	무승부
   '    sd019013	승(실격)
   '    sd019014	패(실격)
   '    sd019017	승(우세2)
   '    sd019018	패(우세2)
   '    sd019019	승(우세3)
   '    sd019020	패(우세3)
   '    sd019025	승(개체)
   '    sd019026	패(개체)
   '================================================================================= 

	'=================================================================================
	'  유도 App 대진표 리그 
   '        리그 개인전 
   '        리그 단체전 
	'================================================================================= 
%>

<%
' http://sdmain.sportsdiary.co.kr/app/api/mgr_tournament/tournament_4person.asp
%>


<%
	'=================================================================================
	'  Sql Query Function 
	'=================================================================================
   '=================================================================================
   '  Purpose  : 	App 대진표 - 대진표  - 개인전/단체전 구분 
   '           gameLevelIdx를 이용하여 단체전인지 유무를 확인한다. 
   '================================================================================= 
	Function getSqlIsGroupGame(gameLevelIdx)
		Dim strSql, err_no
		
		If(gameLevelIdx = "") Then err_no = 1 End If 

		If( err_no <> 1 ) Then 
         strSql = strSql & " Select Case When GroupGameGb = 'sd040002' Then 1 Else 0 End As IsGroupGame "
         strSql = strSql & sprintf("    From tblRGameLevel Where DelYN = 'N' And RGameLevelidx = {0} ", Array(gameLevelIdx))
 		End If  

       getSqlIsGroupGame = strSql 
	End Function


	'=================================================================================
   '  Purpose  : 	App 대진표 - 대진표  - GameType : sd043006	4인(3,4위전)	토너먼트 개인전 (sd040001)
   '           Player List :  UnearnWin, LeftRightGb
   '================================================================================= 
	Function getSqlTournament(gameLevelIdx)
		Dim strSql, err_no
		
		If(gameLevelIdx = "") Then err_no = 1 End If 

		If( err_no <> 1 ) Then 
         strSql = strSql & " Select P.RPlayerIDX, P.PlayerIDX, P.UserName,  "
         strSql = strSql & "    Case When P.UnearnWin = 'sd042002' Then 1 Else 0 End As unearned_win, "
         strSql = strSql & "    Case When P.LeftRightGb = 'sd030001' Then 1 Else 0 End As is_left,  "
         strSql = strSql & "    P.WeightFailYN As Absence, P.Team,  "
         strSql = strSql & "    Case When TeamDtl = '0' Then IsNull(T.TeamNm, '') Else IsNull(T.TeamNm, '')+ TeamDtl End As TeamNm "
         strSql = strSql & "    From tblRPlayer As P "
         strSql = strSql & "    Left Join tblTeamInfo As T On T.Team = P.Team  "
         strSql = strSql & sprintf("    Where P.DelYN = 'N' And P.SportsGb = 'judo' And P.RGameLevelidx = {0} ", Array(gameLevelIdx))
         strSql = strSql & "    And T.DelYN = 'N' And T.SportsGb = 'judo' "
         strSql = strSql & "    Order By P.RPlayerIDX "
 		End If  

       getSqlTournament = strSql 
	End Function

   '=================================================================================
   '  Purpose  : 	App 대진표 - 대진표  - GameType : sd043006	4인(3,4위전)	토너먼트 개인전 (sd040001)
   '           Game List :  대회 리스트 
   '================================================================================= 
	Function getSqlGameList(gameLevelIdx)
		Dim strSql, err_no
		
		If(gameLevelIdx = "") Then err_no = 1 End If 

		If( err_no <> 1 ) Then 
         ' 경기 결과 Text를 구한다.  "
         strSql = strSql & " ;with cte_result As ( "
         strSql = strSql & "    Select PubCode, PubName From tblPubCode Where DelYN = 'N' And SportsGb = 'judo' And pubCode like 'sd0190%' "
         strSql = strSql & " ) "
       
         ' 출전 선수 정보를 구한다.  "
         strSql = strSql & " , cte_player As ( "
         strSql = strSql & "    Select P.PlayerIDX, P.UserName, P.Team,   "
         strSql = strSql & "    Case When TeamDtl = '0' Then IsNull(T.TeamNm, '') Else IsNull(T.TeamNm, '')+ TeamDtl End As TeamNm "
         strSql = strSql & "    From tblRPlayer As P "
         strSql = strSql & "    Left Join tblTeamInfo As T On T.Team = P.Team  "
         strSql = strSql & sprintf("    Where P.DelYN = 'N' And P.SportsGb = 'judo' And P.RGameLevelidx = {0} ", Array(gameLevelIdx))
         strSql = strSql & "    And T.DelYN = 'N' And T.SportsGb = 'judo' "
         strSql = strSql & " ) "
      
         ' 경기 정보를 구한다.  "
         strSql = strSql & " , cte_info As ( "
         strSql = strSql & "    Select PlayerResultIdx, RGameLevelidx, NowRoundNM, NowRound, GroupGameNum, GameNum, LPlayerIDX, RPlayerIDX, LResult, RResult,  "
         strSql = strSql & "       Case When Len(LResult) > 1 Then  "
         strSql = strSql & "          Case When LResult = 'sd019021' Then 10 "
         strSql = strSql & "             When LResult = 'sd019024' Then 0 "
         strSql = strSql & "             Else 1 End  "
         strSql = strSql & "       When LResult Is Null And RResult Is Null Then 10 "
         strSql = strSql & "    Else 2 End As winPart,  "

         strSql = strSql & "    Case When Len(LResult) > 1 Then  "
         strSql = strSql & "       Case When LResult = 'sd019021' Then '불참' "
         strSql = strSql & "          When LResult = 'sd019024' Then '무승부'				  "
         strSql = strSql & "          Else IsNull((Select PubName From cte_result Where PubCode = LResult), '') End  "
         strSql = strSql & "       When LResult Is Null And RResult Is Null Then '무승부' "
         strSql = strSql & "    Else IsNull((Select PubName From cte_result Where PubCode = RResult), '') End As strWin,  "

         strSql = strSql & "    IsNull(MediaLink, '') As MediaLink, RECORD_VIDEO_SEQ, GAME_STIME, GAME_ETIME,  "
         strSql = strSql & "    Case When RECORD_VIDEO_SEQ > 0 Then 2 "
         strSql = strSql & "       When MediaLink Is Not Null And Len(MediaLink) > 1 Then 1 "
         strSql = strSql & "       Else 0 End As VIDEO_FLAG "
         strSql = strSql & "       From tblPlayerResult "
         strSql = strSql & sprintf("       Where DelYN = 'N' And SportsGb = 'judo' And RGameLevelidx = {0} ", Array(gameLevelIdx))
         strSql = strSql & " )  "
       
         ' 경기 정보 + 출전 선수 정보를 Display한다 . "
         ' 4인(3,4위전) DISPLAY_POS: 31: 토너먼트 4강  , 32: 패자 부활전 결승  "
         strSql = strSql & " Select I.PlayerResultIdx, I.RGameLevelidx, I.NowRoundNM, I.NowRound, I.GroupGameNum, I.GameNum,  "
         strSql = strSql & " Case When I.GameNum In ('1', '2', '3') Then 31  "
         strSql = strSql & "       When I.GameNum In ('4') Then 32 "
         strSql = strSql & " End As DISPLAY_POS,  "
         strSql = strSql & "    I.LPlayerIDX, IsNull(L.UserName, '') As LUserName, IsNull(L.Team, '')As LTeam, IsNull(L.TeamNm, '')As LTeamNm, "
         strSql = strSql & "    I.RPlayerIDX, IsNull(R.UserName, '') As RUserName, IsNull(R.Team, '')As RTeam, IsNull(R.TeamNm, '')As RTeamNm, "
         strSql = strSql & "    I.LResult, I.RResult, I.winPart,  "
         strSql = strSql & " Case When I.winPart In (0, 10) Then strWin "
         strSql = strSql & "       Else (Replace(Replace(I.strWin, '승(',''), ')', '') + '승') End As strWin,  "
         strSql = strSql & "       IsNull(MediaLink, '') As MediaLink, RECORD_VIDEO_SEQ, GAME_STIME, GAME_ETIME, VIDEO_FLAG "
         strSql = strSql & "    From cte_info As I  "
         strSql = strSql & "    Left Join cte_player As L On L.PlayerIDX = I.LPlayerIDX "
         strSql = strSql & "    Left Join cte_player As R On R.PlayerIDX = I.RPlayerIDX "
         strSql = strSql & "    Order By Cast(GameNum As Int) Desc "
 		End If  

       getSqlGameList = strSql 
	End Function

   '=================================================================================
   '  Purpose  : 	App 대진표 - 대진표  - GameType : sd043006	4인(3,4위전)	토너먼트 단체전 (sd040002)
   '           Player List :  UnearnWin, LeftRightGb
   '================================================================================= 
	Function getSqlTournamentGroup(gameLevelIdx)
		Dim strSql, err_no
		
		If(gameLevelIdx = "") Then err_no = 1 End If 

		If( err_no <> 1 ) Then 
         strSql = strSql & " Select G.RGameGroupSchoolIdx, G.SchIDX, G.SchoolName,  "
         strSql = strSql & "    Case When G.UnearnWin = 'sd042002' Then 1 Else 0 End As unearned_win,  "
         strSql = strSql & "    Case When G.LeftRightGb = 'sd030001' Then 1 Else 0 End As is_left, "
         strSql = strSql & "    G.WeightFailYN As Absence, G.Team,  "
         strSql = strSql & "    Case When TeamDtl = '0' Then IsNull(T.TeamNm, '') Else IsNull(T.TeamNm, '')+ TeamDtl End As TeamNm "
         strSql = strSql & "    From tblrgamegroupschool As G "
         strSql = strSql & "    Left Join tblTeamInfo As T On T.Team = G.Team  "
         strSql = strSql & sprintf("    Where G.DelYN = 'N' And G.SportsGb = 'judo' And G.RGameLevelidx = {0} ", Array(gameLevelIdx))
         strSql = strSql & "    And T.DelYN = 'N' And T.SportsGb = 'judo' "
         strSql = strSql & "    Order By G.RGameGroupSchoolIdx "
 		End If  

       getSqlTournamentGroup = strSql 
	End Function

   '=================================================================================
   '  Purpose  : 	App 대진표 - 대진표  - GameType : sd043006	4인(3,4위전)	토너먼트 단체전 (sd040002)
   '           Game List :  대회 리스트 
   '================================================================================= 
	Function getSqlGroupGameList(gameLevelIdx)
		Dim strSql, err_no
		
		If(gameLevelIdx = "") Then err_no = 1 End If 

		If( err_no <> 1 ) Then 
         ' 단체전 경기 상세 "
         ' 경기 결과 Text를 구한다.  "
         strSql = strSql & " ;with cte_result As ( "
         strSql = strSql & "    Select PubCode, PubName From tblPubCode Where DelYN = 'N' And SportsGb = 'judo' And pubCode like 'sd0190%' "
         strSql = strSql & " ) "
        
         ' 출전 팀 정보를 구한다.  "
         strSql = strSql & " , cte_team As ( "
         strSql = strSql & "    Select G.RGameGroupSchoolIdx, G.SchIDX, G.SchoolName, G.UnearnWin, G.LeftRightGb, G.Team, G.TeamDtl,  "
         strSql = strSql & " Case When TeamDtl = '0' Then IsNull(T.TeamNm, '') Else IsNull(T.TeamNm, '')+ TeamDtl End As TeamNm "
         strSql = strSql & "    From tblrgamegroupschool As G "
         strSql = strSql & "    Left Join tblTeamInfo As T On T.Team = G.Team  "
         strSql = strSql & sprintf("    Where G.DelYN = 'N' And G.SportsGb = 'judo' And G.RGameLevelidx = {0} ", Array(gameLevelIdx))
         strSql = strSql & "    And T.DelYN = 'N' And T.SportsGb = 'judo'       "
         strSql = strSql & " ) "
      
         ' 경기 정보를 구한다.  "
         strSql = strSql & " , cte_info As ( "
         strSql = strSql & "    Select PlayerResultIdx, RGameLevelidx, [round] As NowRound,  "
         strSql = strSql & "    Case When NowRoundNM Is Null Then dbo.fn_strRound(7734, [round]) Else NowRoundNM End As NowRoundNM,  "
         strSql = strSql & "    GroupGameNum, GameNum, LTeam, LTeamDtl, RTeam, RTeamDtl, LResult, RResult,  "
         strSql = strSql & "    Case When Len(LResult) > 1 Then  "
         strSql = strSql & "          Case When LResult = 'sd019021' Then 10 "
         strSql = strSql & "             When LResult = 'sd019024' Then 0 "
         strSql = strSql & "             Else 1 End  "
         strSql = strSql & "       When LResult Is Null And RResult Is Null Then 10 "
         strSql = strSql & "    Else 2 End As winPart,  "

         strSql = strSql & "    Case When Len(LResult) > 1 Then  "
         strSql = strSql & "       Case When LResult = 'sd019021' Then '불참' "
         strSql = strSql & "          When LResult = 'sd019024' Then '무승부'				  "
         strSql = strSql & "          Else IsNull((Select PubName From cte_result Where PubCode = LResult), '') End  "
         strSql = strSql & "       When LResult Is Null And RResult Is Null Then '무승부' "
         strSql = strSql & "    Else IsNull((Select PubName From cte_result Where PubCode = RResult), '') End As strWin,  "

         strSql = strSql & "    MediaLink, RECORD_VIDEO_SEQ, GAME_STIME, GAME_ETIME,  "
         strSql = strSql & "    Case When RECORD_VIDEO_SEQ > 0 Then 2 "
         strSql = strSql & "    When MediaLink Is Not Null And Len(MediaLink) > 1 Then 1 "
         strSql = strSql & "    Else 0 End As VIDEO_FLAG "
         strSql = strSql & "       From tblPlayerResult "
         strSql = strSql & sprintf("       Where DelYN = 'N' And SportsGb = 'judo' And RGameLevelidx = {0} ", Array(gameLevelIdx))
         strSql = strSql & "    And GameNum = 0 "
         strSql = strSql & " )  "
       
         ' 경기 정보 + 출전 선수 정보를 Display한다 . "
         ' DISPLAY_POS: 1: 토너먼트  "
         strSql = strSql & " Select I.PlayerResultIdx, I.RGameLevelidx, I.NowRoundNM, I.NowRound, I.GroupGameNum, I.GameNum,  "
         strSql = strSql & " Case When I.GroupGameNum In ('1', '2', '3') Then 31  "
         strSql = strSql & "       When I.GroupGameNum In ('4') Then 32 "
         strSql = strSql & " End As DISPLAY_POS,  "
         strSql = strSql & " '' As LPlayerIdx, '' As LPlayerName, I.LTeam, IsNull(L.TeamNm, '') As LTeamNm,  "
         strSql = strSql & " '' As RPlayerIdx, '' As RPlayerName, I.RTeam, IsNull(R.TeamNm, '') As RTeamNm, "
         strSql = strSql & " I.LResult, I.RResult, I.winPart,  "
         strSql = strSql & " Case When I.winPart In (0, 10) Then strWin "
         strSql = strSql & "       Else (Replace(Replace(I.strWin, '승(',''), ')', '') + '승') End As strWin,  "
         strSql = strSql & " IsNull(MediaLink, '') As MediaLink, RECORD_VIDEO_SEQ, GAME_STIME, GAME_ETIME, VIDEO_FLAG "
         strSql = strSql & "    From cte_info As I  "
         strSql = strSql & "    Left Join cte_team As L On L.Team = I.LTeam And L.TeamDtl = I.LTeamDtl "
         strSql = strSql & "    Left Join cte_team As R On R.Team = I.RTeam And R.TeamDtl = I.RTeamDtl "
         strSql = strSql & "    Order By Cast(GroupGameNum As Int) Desc "
 		End If  

       getSqlGroupGameList = strSql 
	End Function
%>

<%
	'=================================================================================
	'  Sub Function 
	'================================================================================= 

%>

<%
DBOpen()
	Dim JsonStr, JsonObj, strSql  	
	Dim RS_DATA, strData, dataCnt, err_no, user_id, client_ip
   Dim gameLevelIdx, isGroupGame 
	Dim player_cnt, player_info, game_info, game_cnt  

	Set JsonObj 		  	= JSON.Parse(JsonData)
   
   gameLevelIdx 	= InjectionChk(JsonObj.get("gameLevelIdx"))
   
	If(gameLevelIdx = "") Then err_no = 1 End If 

	If( err_no <> 1 ) Then 		
      '  ----------------------------------------------------
		' gameLevelIdx를 이용하여 단체전인지 유무를 확인한다. 
      strSql = getSqlIsGroupGame(gameLevelIdx)
      RS_DATA = ExecuteReturn(strSql, DB)
      
      strLog = sprintf("getSqlIsGroupGame = {0} ", Array(strSql))
      Call utxLog(DEV_LOG1, strLog)

      If(IsArray(RS_DATA)) Then
         IsGroupGame = RS_DATA(0,0)
         IsGroupGame = CDbl(IsGroupGame)
      End If
      
      If(IsGroupGame = 0) Then 
      '  ----------------------------------------------------
		' 개인전
      '  ----------------------------------------------------
      
         '  ----------------------------------------------------
         ' Player List - GameType : sd043006	4인(3,4위전) 개인전 (sd040001)
         strSql = getSqlTournament(gameLevelIdx)
         RS_DATA = ExecuteReturn(strSql, DB)
         
         strLog = sprintf("getSqlTournament = {0} ", Array(strSql))
         Call utxLog(DEV_LOG1, strLog)

         If(IsArray(RS_DATA)) Then
            strKeys = "seq, playerIdx, user_name, unearned_win, is_left, absence, team_code, team"
            aryKey = Split(strKeys, ",")

            player_info = utx2DAryToJsonStr(aryKey, RS_DATA)
            player_cnt = UBound(RS_DATA, 2) + 1
         End If

         '  ----------------------------------------------------
         ' Game List :  대회 리스트 - GameType : sd043006	4인(3,4위전) 개인전 (sd040001)
         strSql = getSqlGameList(gameLevelIdx)
         RS_DATA = ExecuteReturn(strSql, DB)
         
         strLog = sprintf("getSqlGameList = {0} ", Array(strSql))
         Call utxLog(DEV_LOG1, strLog)

         If(IsArray(RS_DATA)) Then
            strKeys = "playerResultIdx, rGameLevelIdx, round, round_code, groupGameNum, gameNum, display_pos, l_PlayerIdx, l_playerName, l_teamCode, l_team"
            strKeys = strKey & sprintf("{0}, r_PlayerIdx, r_playerName, r_teamCode, r_team, l_result, r_result, win_part, str_win", Array(strKeys))
            strKeys = strKey & sprintf("{0}, media_link, record_video_seq, game_sTime, game_eTime, video_flag", Array(strKeys))
            aryKey = Split(strKeys, ",")

            game_info = utx2DAryToJsonStr(aryKey, RS_DATA)
            game_cnt = UBound(RS_DATA, 2) + 1
         End If
      Else 
      '  ----------------------------------------------------
		' 단체전
      '  ----------------------------------------------------

         '  ----------------------------------------------------
         ' Player List - GameType : sd043006	4인(3,4위전) 단체전 (sd040002)
         strSql = getSqlTournamentGroup(gameLevelIdx)
         RS_DATA = ExecuteReturn(strSql, DB)
         
         strLog = sprintf("getSqlTournamentGroup = {0} ", Array(strSql))
         Call utxLog(DEV_LOG1, strLog)

         If(IsArray(RS_DATA)) Then
            strKeys = "seq, playerIdx, user_name, unearned_win, is_left, absence, team_code, team"
            aryKey = Split(strKeys, ",")

            player_info = utx2DAryToJsonStr(aryKey, RS_DATA)
            player_cnt = UBound(RS_DATA, 2) + 1
         End If

         '  ----------------------------------------------------
         ' Game List :  대회 리스트 - GameType : sd043006	4인(3,4위전) 단체전 (sd040002)
         strSql = getSqlGroupGameList(gameLevelIdx)
         RS_DATA = ExecuteReturn(strSql, DB)
         
         strLog = sprintf("getSqlGroupGameList = {0} ", Array(strSql))
         Call utxLog(DEV_LOG1, strLog)

         If(IsArray(RS_DATA)) Then
            strKeys = "playerResultIdx, rGameLevelIdx, round, round_code, groupGameNum, gameNum, display_pos, l_PlayerIdx, l_playerName, l_teamCode, l_team"
            strKeys = strKey & sprintf("{0}, r_PlayerIdx, r_playerName, r_teamCode, r_team, l_result, r_result, win_part, str_win", Array(strKeys))
            strKeys = strKey & sprintf("{0}, media_link, record_video_seq, game_sTime, game_eTime, video_flag", Array(strKeys))
            aryKey = Split(strKeys, ",")

            game_info = utx2DAryToJsonStr(aryKey, RS_DATA)
            game_cnt = UBound(RS_DATA, 2) + 1
         End If
      End If 

      JsonStr = utxAryToJsonStr(Array("state", "errorcode", "player_cnt", "player_info", "game_cnt", "game_info"), Array("true", "SUCCESS", player_cnt, player_info, game_cnt , game_info))	
	Else
		JsonStr = utxAryToJsonStr(Array("state", "errorcode"), Array("false", "ERR-110"))	' parameter miss 
	End If 

	Response.Clear
	Response.Write JsonStr
	
	Set JsonObj = Nothing
DBClose()
%>

