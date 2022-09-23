<!-- #include virtual = "/dev/config.asp"-->
<!-- #include virtual = "/classes/JSON_2.0.4.asp" -->
<!-- #include virtual = "/classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include virtual = "/classes/json2.asp" -->

<!-- #include virtual = "/pub/hdr.inc.bm.min.asp" -->
<!-- #include virtual = "/pub/fn/badmt/res/res.pubcode.asp" -->
<!-- #include virtual = "/pub/fn/badmt/res/res.teamGB.asp" -->
<!-- #include virtual = "/pub/fn/badmt/res/res.lvInfo.asp" -->
<!-- #include virtual = "/pub/fn/badmt/fn.rule.asp" -->
<!-- #include virtual = "/pub/fn/badmt/fn.util.rule.asp" -->
<!-- #include virtual = "/pub/fn/fn.utiletc.asp" -->
<!-- #include virtual = "/pub/fn/badmt/fn.elite.order.printer.asp" -->

<%
'   ===============================================================================
'      /pub/js/badmt/bmutx.js   - bmutx로 시작하는 js function이 정의 되어 있다.
'   ===============================================================================
%>

<%

   ' tempnum - tblgameoperate
	GameTitleIDX = fInject(crypt.DecryptStringENC(Request("GameTitleIDX")))
	GameLevelIDX = fInject(crypt.DecryptStringENC(Request("GameLevelIDX")))
  GameLevelDtlIDX = fInject(crypt.DecryptStringENC(Request("GameLevelDtlIDX")))

	GSQL = "SELECT B.GameLevelDtlidx, A.GameTitleName"
	GSQL = GSQL & " FROM tblGameTitle A"
	GSQL = GSQL & " INNER JOIN tblGameLevelDtl B ON B.GametitleIDX = A.GametitleIDX"
	GSQL = GSQL & " WHERE A.DelYN = 'N'"
	GSQL = GSQL & " AND B.DelYN = 'N'"

	If GameLevelIDX <> "" Then
		GSQL = GSQL & " AND B.GameLevelIDX = '" & GameLevelIDX & "'"
   ElseIf GameLevelDtlIDX <> "" Then
		GSQL = GSQL & " AND B.GameLevelDtlIDX = '" & GameLevelDtlIDX & "'"
	Else
		GSQL = GSQL & " AND B.GameTitleIDX = '" & GameTitleIDX & "'"
	End If

	Set GRs = Dbcon.Execute(GSQL)

  ' response.write GSQL & "<br>"

	If Not(GRs.Eof Or GRs.Bof) Then
		Arr_GameLevelDtlIDX = GRs.GetRows()

	Else
		Response.Write "ERR:[0]등록된종목없음"
		Response.END
	End If

	GRs.Close


	If IsArray(Arr_GameLevelDtlIDX) = True Then
		Top_GameTitleName = Arr_GameLevelDtlIDX(1,0)
	End If

%>


<%
   Dim CNT_RESULT_INFO, CNT_GAMEPER_INFO, cntQTournament, cntPrint
   CNT_RESULT_INFO = 6              ' 게임 결과 정보 : 승, 패, 득, 실, 차 , 순위
   CNT_GAMEPER_INFO = 3             ' 각 게임마다 정보 : LScore, RScore, Result
   cntQTournament  = 0              ' 토너먼트 예선전은 2게임 마다 1장씩 프린트 해야 한다. 그때 사용하는 변수
   cntPrint = 0                     ' print count - 프린트 할 갯수가 몇개인가?


   '   ===============================================================================
'      순위를 구하기 위한 배열을 구한다 .
'      Rank, Order, Player1, Player2, memIdx1, memIdx2, Team1, Team2, cTeam1, cTeam2, TeamDtl, 승패득실차
'      PlayerInfo + aryInfo
'      승, 패, 득, 실, 차에서
'      패, 실은 적은 값이 더 큰값이므로 sort를 할때 하나의 룰로 만들기 위해 값을 보정한다.
'      패 = 1000 - 패, 실 = 1000 - 실 : 패, 실이 적으면 보정값은 커진다.
'   ===============================================================================
   Function GetAryResultInfo(rAryPlayer, rAryInfo)
      Dim ai, ul, aryGameInfo, info_kind
      info_kind = 16

      ul = UBound(rAryPlayer,2)
      ReDim aryGameInfo(info_kind, ul)

      For ai = 0 To ul
         aryGameInfo(0,ai) = -1
         aryGameInfo(1,ai) = ai+1
         aryGameInfo(2,ai) = rAryPlayer(1,ai)
         aryGameInfo(3,ai) = rAryPlayer(2,ai)
         aryGameInfo(4,ai) = rAryPlayer(3,ai)
         aryGameInfo(5,ai) = rAryPlayer(4,ai)
         aryGameInfo(6,ai) = rAryPlayer(5,ai)
         aryGameInfo(7,ai) = rAryPlayer(6,ai)
         aryGameInfo(8,ai) = rAryPlayer(7,ai)
         aryGameInfo(9,ai) = rAryPlayer(8,ai)
         aryGameInfo(10,ai) = rAryPlayer(9,ai)

         aryGameInfo(11,ai)  = rAryInfo(ul+1,ai)                     '승
     '    aryGameInfo(12,ai) = rAryInfo(ul+2,ai)         '패
         If( IsNull(rAryInfo(ul+2,ai)) ) Then
            aryGameInfo(12,ai) = 0
         Else
            aryGameInfo(12,ai) = 1000 - CDbl(rAryInfo(ul+2,ai))         '패
         End If
         aryGameInfo(13,ai) = rAryInfo(ul+3,ai)                      '득

         If( IsNull(rAryInfo(ul+4,ai)) ) Then
            aryGameInfo(14,ai) = 0
         Else
            aryGameInfo(14,ai) = 1000 - CDbl(rAryInfo(ul+4,ai))         '실
         End If
      '   aryGameInfo(14,ai) = 1000 - CDbl(rAryInfo(ul+4,ai))         '실

         aryGameInfo(15,ai) = rAryInfo(ul+5,ai)                      '차
      Next

      GetAryResultInfo = aryGameInfo
   End Function

   Function ApplyRanking(rAryInfo, rAryResult, pos_rank)
      Dim key, ai, ul, IsDesc, sortDataType, rKey

      key = 1                 ' order key
      sortDataType = 2        ' key가 가리키는 데이터가 숫자이다. 숫자 비교
      IsDesc = 0

      ' order에 의해 sort한다.
      Call Sort2DimAryEx(rAryResult, key, sortDataType, IsDesc)

      ul = UBOUND(rAryInfo, 2)

      key = 1                 ' rank key
      For ai=0 To ul
         rAryInfo(pos_rank, ai) = rAryResult(0, ai)
      Next

   End Function

'   ===============================================================================
'    리그전 - 개인전/팀전 경기 결과를 배열에 담는다.
'     같은 번호는 대각선 값이다. 이값은 비어있다.
'        대각선 위에 있는 값은 Index가 정상 / 대각선 아래에 있는 값은 Index를 뒤집는다. ( 같은 정보를 역으로 뿌려주기 때문 )
'     rAryLeague
'      0-6, L_MemberNames,	L_MemberIDXs, L_TeamNames, L_Teams, L_TeamDtl,  R_MemberNames, R_MemberIDXs,
'      7-15 R_TeamNames, R_Teams, R_TeamDtl,  L_SetJumsu	,L_MatchJumsu,	R_SetJumsu,R_MatchJumsu, L_Result, EnterType
'     rAryPlayer
'       0-9  GamelevelDtlIDX	Player1	Player2	memIdx1	memIdx2	Team1	Team2	cTeam1	cTeam2	TeamDtl
'
'     Score Text LScore, RScore, Result,
'     Reverse일경우 LScore 와 RScore를 바꾸고 , 결과도 바꾼다.
'     점수 * Cnt_Arr_Player + 승패득실차순위 + (LScore,RScore,Result)*Cnt_Arr_Player
'   ===============================================================================
   Function SetLeagueGameInfo(rAryLeague, rAryPlayer, rAryInfo, IsTeamGame)
      Dim ai, aj , ul, ul2, infoIdx , idx1, idx2, strScore, bReverse
      Dim pos_base, pos_info, pos_result, game_result, l_score,r_score, entry_type
      Dim cnt_win, cnt_lose, win_score, lose_score, diff_score, order, is_reverse
      ul = UBound(Arr_Player,2)
      ul2 = UBound(rAryInfo,1)
      is_reverse = false

			'      strLog = " ------------------------- SetLeagueGameInfo <br>"
			'      response.write strLog

      For ai = 0 To ul
         For aj = 0 To ul
            bReverse = false
            If( ai <> aj ) Then              ' 같은 번호는 대각선 값이다. 이값은 비어있다.
               If( ai > aj ) Then            ' 대각선 위에 있는 값은 Index가 정상
                  idx1 = aj
                  idx2 = ai
                  bReverse = true
               Else                          ' 대각선 아래에 있는 값은 Index를 뒤집는다. ( 같은 정보를 역으로 뿌려주기 때문 )
                  idx1 = ai
                  idx2 = aj
               End If

			'               strLog = strPrintf("({0},{1}) = ({2},{3})", Array(ai, aj, idx1, idx2))
			'               response.write strLog

               If( IsTeamGame = 0 ) Then
			'                  strLog = strPrintf("({0},{1},{2},{3}) / ({4},{5},{6},{7})<br>", _
			'                     Array(rAryPlayer(3,idx1), rAryPlayer(7,idx1), rAryPlayer(4,idx1), rAryPlayer(8,idx1), rAryPlayer(3,idx2), rAryPlayer(7,idx2), rAryPlayer(4,idx2), rAryPlayer(8,idx2)))
			'                  response.write strLog

                  infoIdx = uxFindPersonGameInfo(rAryLeague, rAryPlayer(3,idx1), rAryPlayer(7,idx1), rAryPlayer(4,idx1), rAryPlayer(8,idx1), _
                                 rAryPlayer(3,idx2), rAryPlayer(7,idx2), rAryPlayer(4,idx2), rAryPlayer(8,idx2), is_reverse )
               Else
			'                  strLog = strPrintf("({0},{1},{2},{3})<br>", _
			'                     Array(rAryPlayer(7,idx1), rAryPlayer(9,idx1), rAryPlayer(7,idx2), rAryPlayer(9,idx2)))
			'                  response.write strLog

                  infoIdx = uxFindTeamGameInfo(rAryLeague, rAryPlayer(7,idx1), rAryPlayer(9,idx1), rAryPlayer(7,idx2), rAryPlayer(9,idx2), is_reverse )
               End If
			'
			'               strLog = strPrintf("find idx = {0}<br>", Array(infoIdx))
			'               response.write strLog

               ' Score Text LScore, RScore, Result,
               ' Reverse일경우 LScore 와 RScore를 바꾸고 , 결과도 바꾼다.
               ' 점수 * Cnt_Arr_Player + 승패득실차순위 + (LScore,RScore,Result)*Cnt_Arr_Player

               ' game_result, l_score,r_score, entry_type
               If(infoIdx <> -1) Then ' 정보를 찾았다. 셋팅을 하자.
                  pos_base = ul + CNT_RESULT_INFO + 1
                  pos_info = pos_base + (aj * CNT_GAMEPER_INFO)
                  entry_type = rAryLeague(15,infoIdx)

                  If( IsNull(rAryLeague(14,infoIdx)) ) Then
                     game_result = -1
                  Else
                     game_result = IsResultWin(rAryLeague(14,infoIdx))
                  End If

                  if(entry_type = "A") Then ' ama이면  score를 L_SetJumsu	,R_SetJumsu로 사용
                     l_score = rAryLeague(10,infoIdx)
                     r_score = rAryLeague(12,infoIdx)
                  Else                      ' elite이면 score를 L_MatchJumsu,	R_MatchJumsu로 사용
                     l_score = rAryLeague(11,infoIdx)
                     r_score = rAryLeague(13,infoIdx)
                  End If

                  If( bReverse = true ) Then       ' 정보를 역으로 바꾸어 저장한다.
                     strScore = strPrintf("{0} - {1}", Array(r_score, l_score))
                     rAryInfo(aj, ai) = strScore
                     rAryInfo(pos_info, ai)     = r_score                        ' LScore
                     rAryInfo(pos_info+1, ai)   = l_score                        ' RScore
                     rAryInfo(pos_info+2, ai)   = Reverse0And1(game_result)      ' Result
                  Else
                     strScore = strPrintf("{0} - {1}", Array(l_score, r_score))
                     rAryInfo(aj, ai) = strScore
                     rAryInfo(pos_info, ai)     = l_score                        ' LScore
                     rAryInfo(pos_info+1, ai)   = r_score                        ' RScore
                     rAryInfo(pos_info+2, ai)   = game_result                    ' Result
                  End If
'                  strLog = strPrintf("({0},{1}) = {2}<br>", Array(aj, ai, strScore))
'                  response.write strLog
               End If
            Else
               rAryInfo(aj, ai) = "-"
               rAryInfo(ul+1, ai) = -1
            End If
         Next
      Next
   End function

   Function printInfo(rAryInfo)
      Dim ai, aj , ul, ul2, strInfo
      ul = UBound(rAryInfo,2)
      ul2 = UBound(rAryInfo,1)

      strLog = " ------------------------- printInfo  <br>"
      response.write strLog

      strInfo = ""

      For ai = 0 To ul
         strInfo = ""
         For aj = 0 To ul2
            strInfo = strPrintf("{0} ({1},{2})", Array(strInfo, aj, rAryInfo(aj, ai)))
         Next
         response.write strInfo & "<br>"
      Next

      strLog = " ------------------------- printInfo  <br>"
      response.write strLog
   End Function





  %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=Edge">

  <script type="text/javascript" src="/js/jquery-1.12.2.min.js"></script>
  <!-- <link rel="stylesheet" href="/css/lib/jquery.timepicker.min.css">
  <script type="text/javascript" src="/js/library/jquery.timepicker.min.js"></script> -->

  <!-- <link rel="stylesheet" href="/css/lib/jquery-ui.min.css">
  <link rel="stylesheet" href="/css/lib/bootstrap-datepicker.css"> -->
  <!-- <link rel="stylesheet" type="text/css" href="/css/bootstrap.css"> -->
  <!-- <link rel="stylesheet" type="text/css" href="/css/fontawesome-all.css"> -->
  <!-- <link rel="stylesheet" type="text/css" href="/css/style.css"> -->
  <!-- <link rel="stylesheet" href="http://img.sportsdiary.co.kr/lib/tournament/tournament.css"> -->

  <!-- sd_admin.css -->
  <!-- <link rel="stylesheet" type="text/css" href="/css/admin/admin.d.style.css"> -->

  <!-- <script type="text/javascript" src="/js/library/bootstrap-datepicker.js"></script>
  <script type="text/javascript" src="/js/jquery-migrate-1.4.1.min.js"></script>
  <script type="text/javascript" src="/js/library/selectivizr-min.js"></script>
  <script type="text/javascript" src="/js/library/jquery-ui.min.js"></script>
  <script type="text/javascript" src="/js/library/jquery.easing.min.js"></script>
  <script type="text/javascript" src="/js/library/bootstrap.min.js"></script> -->
  <!-- <script src="/js/library/placeholders.min.js"></script> -->
  <!-- <script type="text/javascript" src="/js/library/datepicker-ko.js"></script> -->
  <script type="text/javascript" src="/dev/dist/Common_Js.js" ></script>
  <script type="text/javascript" src="/js/CommonAjax.js?ver=1.0"></script>
  <script type="text/javascript" src="/js/bdadmin.js"></script>
  <script type="text/javascript" src="http://img.sportsdiary.co.kr/lib/tournament/2.0/tournament.js"></script>
  <script type="text/javascript" src="/pub/js/etc/utx.js<%=UTX_JSVER%>"></script>
  <script type="text/javascript" src="/pub/js/etc/bmx.js<%=BMX_JSVER%>"></script>
  <script type="text/javascript" src="/pub/js/etc/ctx.js<%=CTX_JSVER%>"></script>
  <script type="text/javascript" src="/pub/js/badmt/bmutx.js<%=BMUTX_JSVER%>"></script>

  <script type="text/javascript" src="/js/GameTitleMenu/LotteryElite.js?ver=1.1.7"></script>
  <style>
		*{margin:0;padding:0;}
		html{width:200mm;height:100%;font-family:Calibri, Arial, Helvetica, sans-serif;background-color:white;}
		table{border-collapse:collapse;}
    li{list-style:none;}
		.wrapper{width:100%;padding-top:3mm;box-sizing:border-box;}

		.header{position:relative;text-align:left;border-bottom:.5mm solid #333;box-sizing:border-box;}
		.header>.title{font-size:10pt;font-weight:bold;}
		.header>.moreInfo{position:relative;margin-bottom:1mm;}
		.header>.moreInfo>.team{max-width:117mm;font-weight:700;font-size:10pt;margin:auto;margin-right:5mm;}
		.header>.moreInfo>.attend{font-size:9pt;font-weight:700;}
		.header>.moreInfo>.attend>span{font-weight:400;text-decoration:underline;}

		.main{width:100%;}

		.footer{position:relative;height:15mm;border-top:2px solid #333;padding-top:2mm;overflow:hidden;box-sizing:border-box;}
		.footer>.bot_logo{float:left;}
		.footer>.bot_logo>img{height:12mm;}
		.footer>.print_date{float:right;}
		.footer>.print_date>img{height:12mm;}
   </style>
	 <!-- tournament -->
	 <style>
		.main.tournamentTree{margin:2mm 0 5mm 0mm;padding:0 3mm;box-sizing:border-box;}

		.tt{height:0;}
		.tt__inner{white-space:nowrap;transform-origin:top left;display:table;}

		.tt__item{margin:0;}
		.tt__round{ position:relative; display:inline-block; margin:0; padding:0; vertical-align:top;}
		.tt__break{page-break-before:always;border:1px dashed #eee;}

		.tt__block{position:relative; box-sizing:border-box; margin:0; padding:0; list-style:none;}
		.tt__branch{position:absolute;display:block;width:100%;height:100%;border-color:#666;border-style:solid;box-sizing:border-box;border-width:0;}
		.tt__block.s_odd .tt__branch.s_middle{border-width:0 0 1px 0;}
		.tt__block.s_even .tt__branch.s_middle{border-width:1px 0 0 0;}

		.tt__block.s_odd .tt__branch.s_horizon{border-width:0 0 1px 0;}
		.tt__block.s_even .tt__branch.s_horizon{border-width:1px 0 0 0;}
		.tt__block.s_down .tt__branch.s_horizon{border-width:1px 1px 0 0;}
		.tt__block.s_up .tt__branch.s_horizon{border-width:0 1px 1px 0;}

		.tt__roundOf{position:absolute;width:100%;text-align:center;margin:0;padding:0;font-size:15px;transform:translateY(-50%);}
		.tt__roundOf{font-size:10px;}

		.tt__board{position:absolute;display:flex;width:100%;margin:auto;box-sizing:border-box;background-color:#fff;overflow:hidden;border-color:#666;border-style:solid;border-width:0.1px;}
		.tt__block.s_odd .tt__board{ bottom:0; }
		.tt__block.s_even .tt__board{ top:0; }

		.tt__seedWrap{display:none;flex-direction:column;justify-content:center;flex-shrink:0;align-items:center;width:14%;height:100%;text-align:left;text-indent:2px;font-size:8pt;letter-spacing:-0.05em;}
		.tt__seedWrap>span:first-child{width:100%;height:50%;text-align:left;}
		.tt__seedWrap>span:last-child{width:100%;height:50%;text-align:right;}
		.s_round_1 .tt__block .tt__seedWrap{display:flex;}

		.tt__board_playerWrap{display:flex;flex-direction:column;justify-content:center;min-width:0;width:100%;height:100%;padding:0 2px;box-sizing:border-box; white-space:nowrap;text-overflow:ellipsis;overflow:hidden;}
		/* .s_round_1 .tt__board_playerWrap{width:71%;} */

		/* !@# */
		.tt__board_playerInner{width:100%;display:flex;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;}
		/* .tt__board_playerInner>span{display:inline-block;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;} */

		.tt__board_player{font-size:8pt;font-weight:bold;padding-right:2px;}
		.tt__board_belong{font-size:8pt;font-weight:normal;}

		.tt__board_score{flex-shrink:0;flex-grow:0;width:15%;border-left:1px solid #666;display:flex;align-items:center;justify-content:center;font-size:10pt;}


		/* 256, 128, 64 */
		.tt__item.s_roundOf_256 .tt__block.s_block_1,
		.tt__item.s_roundOf_128 .tt__block.s_block_1,
		.tt__item.s_roundOf_64 .tt__block.s_block_1{height:16px;}
		.tt__item.s_roundOf_256 .tt__block.s_block_2,
		.tt__item.s_roundOf_128 .tt__block.s_block_2,
		.tt__item.s_roundOf_64 .tt__block.s_block_2{height:32px;}
		.tt__item.s_roundOf_256 .tt__block.s_block_3,
		.tt__item.s_roundOf_128 .tt__block.s_block_3,
		.tt__item.s_roundOf_64 .tt__block.s_block_3{height:64px;}
		.tt__item.s_roundOf_256 .tt__block.s_block_4,
		.tt__item.s_roundOf_128 .tt__block.s_block_4,
		.tt__item.s_roundOf_64 .tt__block.s_block_4{height:128px;}
		.tt__item.s_roundOf_256 .tt__block.s_block_5,
		.tt__item.s_roundOf_128 .tt__block.s_block_5,
		.tt__item.s_roundOf_64 .tt__block.s_block_5{height:256px;}
		.tt__item.s_roundOf_256 .tt__block.s_block_6,
		.tt__item.s_roundOf_128 .tt__block.s_block_6,
		.tt__item.s_roundOf_64 .tt__block.s_block_6{height:512px;}
		.tt__item.s_roundOf_256 .tt__block.s_block_7,
		.tt__item.s_roundOf_128 .tt__block.s_block_7,
		.tt__item.s_roundOf_64 .tt__block.s_block_7{height:1024px;}
		.tt__item.s_roundOf_256 .tt__block.s_block_8,
		.tt__item.s_roundOf_128 .tt__block.s_block_8,
		.tt__item.s_roundOf_64 .tt__block.s_block_8{height:2048px;}
		.tt__item.s_roundOf_256 .tt__block.s_block_9,
		.tt__item.s_roundOf_128 .tt__block.s_block_9,
		.tt__item.s_roundOf_64 .tt__block.s_block_9{height:4096px;}


		.tt__item.s_roundOf_256 .tt__block.s_match{width:95px;}
		.tt__item.s_roundOf_256 .tt__block.s_branch{width:5px;}

		.tt__item.s_roundOf_128 .tt__block.s_match{width:95px;}
		.tt__item.s_roundOf_128 .tt__block.s_branch{width:5px;}

		.tt__item.s_roundOf_64 .tt__block.s_match{width:114px;}
		.tt__item.s_roundOf_64 .tt__block.s_branch{width:5px;}


		.tt__item.s_roundOf_256 .tt__board,
		.tt__item.s_roundOf_128 .tt__board,
		.tt__item.s_roundOf_64 .tt__board{height:15px;}

		.tt__item.s_roundOf_256 .tt__seedWrap,
		.tt__item.s_roundOf_128 .tt__seedWrap,
		.tt__item.s_roundOf_64 .tt__seedWrap{font-size:4pt;}

		.tt__item.s_roundOf_256 .tt__board_player,
		.tt__item.s_roundOf_128 .tt__board_player,
		.tt__item.s_roundOf_64 .tt__board_player{font-size:4pt;}

		.tt__item.s_roundOf_256 .tt__board_belong,
		.tt__item.s_roundOf_128 .tt__board_belong,
		.tt__item.s_roundOf_64 .tt__board_belong{font-size:4pt;}

		.tt__item.s_roundOf_256 .tt__board_score,
		.tt__item.s_roundOf_128 .tt__board_score,
		.tt__item.s_roundOf_64 .tt__board_score{font-size:6pt;border-left:.1px solid #666;}





		/* 32, 16, 8, 4 */
		.tt__item.s_roundOf_32 .tt__block.s_block_1,
		.tt__item.s_roundOf_16 .tt__block.s_block_1,
		.tt__item.s_roundOf_8 .tt__block.s_block_1{height:32px;}

		.tt__item.s_roundOf_32 .tt__block.s_block_2,
		.tt__item.s_roundOf_16 .tt__block.s_block_2,
		.tt__item.s_roundOf_8 .tt__block.s_block_2{height:64px;}

		.tt__item.s_roundOf_32 .tt__block.s_block_3,
		.tt__item.s_roundOf_16 .tt__block.s_block_3,
		.tt__item.s_roundOf_8 .tt__block.s_block_3{height:128px;}

		.tt__item.s_roundOf_32 .tt__block.s_block_4,
		.tt__item.s_roundOf_16 .tt__block.s_block_4,
		.tt__item.s_roundOf_8 .tt__block.s_block_4{height:256px;}

		.tt__item.s_roundOf_32 .tt__block.s_block_5,
		.tt__item.s_roundOf_16 .tt__block.s_block_5,
		.tt__item.s_roundOf_8 .tt__block.s_block_5{height:512px;}

		.tt__item.s_roundOf_32 .tt__block.s_block_6,
		.tt__item.s_roundOf_16 .tt__block.s_block_6,
		.tt__item.s_roundOf_8 .tt__block.s_block_6{height:1024px;}

		.tt__item.s_roundOf_32 .tt__block.s_block_7,
		.tt__item.s_roundOf_16 .tt__block.s_block_7,
		.tt__item.s_roundOf_8 .tt__block.s_block_7{height:2048px;}

		.tt__item.s_roundOf_32 .tt__block.s_block_8,
		.tt__item.s_roundOf_16 .tt__block.s_block_8,
		.tt__item.s_roundOf_8 .tt__block.s_block_8{height:4096px;}

		.tt__item.s_roundOf_32 .tt__block.s_block_9,
		.tt__item.s_roundOf_16 .tt__block.s_block_9,
		.tt__item.s_roundOf_8 .tt__block.s_block_9{height:8192px;}


		.tt__item.s_roundOf_4 .tt__block.s_block_1{height:35px;}
		.tt__item.s_roundOf_4 .tt__block.s_block_2{height:70px;}

		.tt__item.s_roundOf_2 .tt__block.s_block_1{height:32px;}

		.tt__item.s_roundOf_32 .tt__board,
		.tt__item.s_roundOf_16 .tt__board,
		.tt__item.s_roundOf_8 .tt__board{height:28px;}

		.tt__item.s_roundOf_4 .tt__board,
		.tt__item.s_roundOf_2 .tt__board{height:30px;}

		.tt__item.s_roundOf_32 .tt__block.s_match{width:130.5px;}
		.tt__item.s_roundOf_32 .tt__block.s_branch{width:10px;}
		.tt__item.s_roundOf_16 .tt__block.s_match{width:168.5px;}
		.tt__item.s_roundOf_16 .tt__block.s_branch{width:10px;}

		.tt__item.s_roundOf_8 .tt__block.s_match{width:231px;}
		.tt__item.s_roundOf_8 .tt__block.s_branch{width:10px;}

		.tt__item.s_roundOf_4 .tt__block.s_match{width:357px;}
		.tt__item.s_roundOf_4 .tt__block.s_branch{width:10px;}

		.tt__item.s_roundOf_2 .tt__block.s_match{width:735px;}
		.tt__item.s_roundOf_2 .tt__block.s_branch{width:10px;}
   </style>

	 <!-- league -->
	 <style>
		 .main.league{margin:2mm 0 5mm 0mm;padding:0 3mm;position:relative;display:flex;align-items:center;box-sizing:border-box;}
		 .league>div{width:100%;}
		 .league table{width:100%;}
		 .league table th{height:12mm;text-align:center;border:.1mm solid #333;font-size:11pt;line-height:1.2;}
		 .league table td{height:12mm;text-align:center;border:.1mm solid #333;font-size:14pt;}
		 .sil{width:10mm;}
	 </style>
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
  <title><%=Top_GameTitleName%></title>
	<script>
		function displayTonament(id_div, aryUser, playType, PlayLevelType, GroupGameGb)
	  {
  		var strLog
      strLog = utx.strPrintf("displayTonament id_div = {0}, playType = {1}, PlayLevelType = {2}, GroupGameGb = {3}", id_div, playType, PlayLevelType, GroupGameGb);
      // console.log(strLog);
	    // console.log(aryUser);

	    var aryData, i = 0, len = 0, obj, IsDblPlay = 1, round = 0, round_kind = 0, cur_round = 0;
      var IsFinal = 1;              // 본선
      aryData = new Array();

      len = aryUser.length;
      round_kind = Number(aryUser[0]["MaxRound"]);
      round = Math.pow(2,round_kind);

      for(i = 0; i<round_kind; i++)
      {
         aryData[i] = new Array();
      }

      if(!playType || playType == undefined  || playType == "B0020001") IsDblPlay = 0;        // 단식
      if(PlayLevelType == undefined || PlayLevelType == "B0100001") IsFinal = 0;     // 예선

      var order = 0, prev_round = 0;
      for(i = 0; i<len; i++)
      {
         cur_round = Number(aryUser[i]["ROUND"])-1;

         // block 앞에 넣는 번호 , Round가 바뀌면 초기화 한다.
         if(cur_round != prev_round)
         {
            prev_round = cur_round;
            order = 0;
         }
         
         obj = fillUserInfo(cur_round, order, aryUser[i], GroupGameGb, IsDblPlay, IsFinal);
         aryData[cur_round].push(obj);
         order++;
      }

      var base = 2;
      for(i = round_kind-1; i > cur_round; i--)
      {
         MakeEmptyData(aryData[i], base);
         base *= 2;
      }

	     var f_tournament = makeTournament(id_div);
	     drawTournament(f_tournament, round, round_kind, aryData);
	   }

	   // GameLevelDtlIDX	ORDERBY	Team1	Team2	Player1	Player2	TeamDtl	JoNum	WriteDate	ByeYN	GameByeYN	JoNum_Cross	JoNum_Ranking	TourneyCnt

	   // GameLevelDtlIDX, ORDERBY, Player1, Player2, Team1, Team2, ByeYN, WriteDate,
	   // 0: 13375, 1: 1, 2: "허범만", 3: "박진철", 4: "순천공업고등학교", 5: "순천공업고등학교", 6: "N", 7: "2019-06-13 오후 2:21:24",
	   // TeamDtl, JoNum,GameByeYN, JoNum_Cross, JoNum_Ranking, TourneyCnt
	   // 8: "", 9: null, 10: null, 11: null, 12: null, 13: "0"
   	function fillUserInfo(cur_round, Idx, info, GroupGameGb, IsDblPlay, IsFinal)
      {
         var obj = {};
         var l_player1, l_player2, l_team1, l_team2, l_teamDtl, l_Q;
         var r_player1, r_player2, r_team1, r_team2, r_teamDtl, r_Q;

         // i, i+1을 합쳐서 하나의 Obj을 만들므로 기본 셋팅은 i%2=0에서 한번만
         obj.matchNo    =  Idx;
         obj.bDblPlay   =  IsDblPlay;
         obj.bFinal     =  IsFinal;
         obj.l_fill     =  true;
         obj.l_sel      =  false;
         obj.r_fill     =  true;
         obj.r_sel      =  false;
         obj.l_score    =  (info["LJumsu"] == null) ? 0 : info["LJumsu"];
         obj.r_score    =  (info["RJumsu"] == null) ? 0 : info["RJumsu"];
         obj.l_seedNo   =  Number(info["LSeedNum"]);
         obj.r_seedNo   =  Number(info["RSeedNum"]);
         
         l_Q        =  Number(info["LQualifier"]);
         r_Q        =  Number(info["RQualifier"]);      

         // short name replace
         l_player1   = (info['LPlayer1'] == null) ? "" : bmx.TeamGBtoSimple(info['LPlayer1']);
         l_player2   = (info['LPlayer2'] == null) ? "" : bmx.TeamGBtoSimple(info['LPlayer2']);
         l_team1     = (info['LTeam1'] == null) ? "" : bmx.TeamGBtoSimple(info['LTeam1']);
         l_team2     = (info['LTeam2'] == null) ? "" : bmx.TeamGBtoSimple(info['LTeam2']);
         l_teamDtl   =  info["LTeamDtl"];

         r_player1   = (info['RPlayer1'] == null) ? "" : bmx.TeamGBtoSimple(info['RPlayer1']);
         r_player2   = (info['RPlayer2'] == null) ? "" : bmx.TeamGBtoSimple(info['RPlayer2']);
         r_team1     = (info['RTeam1'] == null) ? "" : bmx.TeamGBtoSimple(info['RTeam1']);
         r_team2     = (info['RTeam2'] == null) ? "" : bmx.TeamGBtoSimple(info['RTeam2']);
         r_teamDtl   =  info["RTeamDtl"];

         if(GroupGameGb == "B0030002") 
         {
            if(l_teamDtl != "0" && l_teamDtl != "") l_team1 = utx.strPrintf("{0}-{1}", l_team1, l_teamDtl); 
            if(r_teamDtl != "0" && r_teamDtl != "") r_team1 = utx.strPrintf("{0}-{1}", r_team1, r_teamDtl); 
         }

         // Bye position
         if(info['LByeYN'] == 'Y') {
            obj.l_player   =  "BYE";
            obj.l_team     =  "";
         }
         else
         {
            if(l_player1 != "" && l_player1 != null)  { // player가 있다.
               if(l_player1 == l_player2) obj.l_player   =  l_player1;
               else obj.l_player   =  (IsDblPlay == 0)? l_player1 : utx.strPrintf("{0},{1}",l_player1, l_player2);
               obj.l_team     =  (IsDblPlay == 0)? l_team1 : utx.strPrintf("{0},{1}",l_team1, l_team2);
            }
            else if( (l_player1 == "" || l_player1 == null) && (l_team1 != "" && l_team1 != null) )
            {
               if(l_team1 == l_team2) obj.l_player   =  l_team1;
               else obj.l_player  =  (IsDblPlay == 0)? l_team1 : utx.strPrintf("{0},{1}",l_team1, l_team2);
               obj.l_team     =  "";
            }
            else if( (l_player1 == "" || l_player1 == null) && (l_team1 == "" || l_team1 == null) )
            {
               if(l_Q > 0) obj.l_player  = utx.strPrintf("※예선 {0}조",l_Q);
               else obj.l_player  = "";
               obj.l_team     =  "";
            }
         }

         // Bye position
         if(info['RByeYN'] == 'Y') {
            obj.r_player   =  "BYE";
            obj.r_team     =  "";
         }
         else
         {
            if(r_player1 != "" && r_player1 != null)  { // player가 있다.
               if(r_player1 == r_player2) obj.r_player   =  r_player1;
               else obj.r_player   =  (IsDblPlay == 0)? r_player1 : utx.strPrintf("{0},{1}",r_player1, r_player2);
               obj.r_team     =  (IsDblPlay == 0)? r_team1 : utx.strPrintf("{0},{1}",r_team1, r_team2);
            }
            else if( (r_player1 == "" || r_player1 == null) && (r_team1 != "" && r_team1 != null) )
            {
               if(r_team1 == r_team2) obj.r_player   =  r_team1;
               else obj.r_player  =  (IsDblPlay == 0)? r_team1 : utx.strPrintf("{0},{1}",r_team1, r_team2);
               obj.r_team     =  "";
            }
            else if( (r_player1 == "" || r_player1 == null) && (r_team1 == "" || r_team1 == null) )
            {
               if(r_Q > 0) obj.r_player  = utx.strPrintf("※예선 {0}조",r_Q);
               else obj.r_player  = " ";
               obj.r_team     =  "";
            }
         }
         return obj;
      }


	</script>

	<script>

		/* ==================================================================================
		   make Tonament - div id를 입력받아 tonament Object을 생성하고 , 반환한다.
		================================================================================== */
		function makeTournament(id_div)
		{
			var tournament = new Tournament();

			tournament.setOption({
				style:{
					blockHeight: 34,
					blockMatchWidth: 120,
					blockBranchWidth: 10,

					boardWidth: 120,
					boardHeight: 28,

					branchWidth : 1,
					branchColor : '#666',

					roundOf_textSize : 10,
				},
				scale : '1', // mix decimal or 'auto' 'auto'면 화면 너비에 맞게 스케일 조정
				el:document.getElementById(id_div) // element must have id
			});

			// tournament.setStyle();

			tournament.board = function(data){
				if(data && data.bDblPlay == 1) return boardInner_Double(data);
				return boardInner_single(data);

				return html
			}
			return tournament;
		}

		/* ==================================================================================
		   draw Tonament - tonament Object, round, data를 입력받아 tonament를 그린다.
		================================================================================= */
		function drawTournament(objT, round, round_kind, rAryData)
		{
			var roundData = {};

			var i = 0, key = "";
			for(var i = 0; i< round_kind; i++)
			{
				key = utx.strPrintf("round_{0}", i+1);
				roundData[key] = rAryData[i];
			}

			var data = {};
			for(key in roundData){
				data[key] = []
				roundData[key].forEach(function(item, index, array){				
            data[key].push({player:item.l_player, score:item.l_score, team:item.l_team, fill:item.l_fill, sel:item.l_sel, matchNo:item.matchNo, bDblPlay:item.bDblPlay, bFinal:item.bFinal, seedNo:item.l_seedNo })
				data[key].push({player:item.r_player, score:item.r_score, team:item.r_team, fill:item.r_fill, sel:item.r_sel, matchNo:item.matchNo, bDblPlay:item.bDblPlay, bFinal:item.bFinal, seedNo:item.r_seedNo })
				})
			}

			var divide = 1;
			switch(round){
				case 256: divide = 4; break;
				case 128: divide = 2; break;
				default: divide = 1; break;
			}

			objT.draw({
				roundOf:round,
				data: data,
				divisions: divide,
			});
		}


		/* ==================================================================================
		   data set-  tonament block - single game
		   dat를 입력받아 싱글 게임일때 block을 그린다.
		================================================================================== */
		function boardInner_single(data)
		{

			var matchNo, no, player, team, score, Qstr;

			if(data){
			   matchNo = data.matchNo;
				 no = data.index + 1;
				 player = data.player.split(',')[0];
				 team = data.team;
				 score = data.score;
				 Qstr = '';

				 // 확인 필요
			   if(data.hasOwnProperty('seedNo'))
            {
               if(data.seedNo != "0") no = utx.strPrintf("{0} _{1}", no, data.seedNo);
            }
			}

			var html = [
				'<p class="tt__board">',
					(data.bFinal) ? '<span class="tt__seedWrap"><span>'+no+'</span><span>'+Qstr+'</span></span>' : '',
		      '<span class="tt__board_playerWrap">',
		        '<span class="tt__board_playerInner">',
		          '<span class="tt__board_player">'+player+'</span>',
		          '<span class="tt__board_belong">'+team+'</span>',
		        '</span>',
		      '</span>',
		      '<span class="tt__board_score">'+score+'</span>',
		    '</p>',
			].join('')

			return html;
		}

		/* ==================================================================================
		   data set-  tonament block - double game
		   data를 입력받아 복식 게임일때 block을 그린다.
		================================================================================== */
		function boardInner_Double(data)
		{

			var matchNo, no, ary_player, ary_team, score, Qstr;
			// console.log(data);

			if(data){
			   matchNo = data.matchNo;

				 no = data.index + 1;

				 if(data.player == "" || data.player == undefined) ary_player  = [" ", " "]
			   else ary_player = (data.player.indexOf(',') == -1) ? [data.player, " "] : data.player.split(',');

				 if(data.team == "" || data.team == undefined) ary_team  = [" ", " "]
			   else ary_team  = (data.team.indexOf(',') == -1) ? [data.team, " "] : data.team.split(',');

				 score = data.score;
				 Qstr = '';
				 
			    // 확인 필요
			   if(data.hasOwnProperty('seedNo'))
            {
               if(data.seedNo != "0") no = utx.strPrintf("{0} _{1}", no, data.seedNo);
            }
			}




			var html = [
				'<p class="tt__board">',
					(data.bFinal) ? '<span class="tt__seedWrap"><span>'+no+'</span><span>'+Qstr+'</span></span>' : '',
					'<span class="tt__board_playerWrap">',
						'<span class="tt__board_playerInner">',
								'<span class="tt__board_player">'+ary_player[0]+'</span>',
								'<span class="tt__board_belong">'+ary_team[0]+'</span>',
						'</span>',

						'<span class="tt__board_playerInner">',
	 						'<span class="tt__board_player">'+ary_player[1]+'</span>',
	 						'<span class="tt__board_belong">'+ary_team[1]+'</span>',
						'</span>',

					'</span>',
					'<span class="tt__board_score">'+score+'</span>',
				'</p>',
			].join('')

			return html;
		}
	</script>
</head>
<body>
	<div>


<%
   Dim strJson

	If IsArray(Arr_GameLevelDtlIDX) = False Then
		Response.Write "ERR:[1]등록된종목없음"
		Response.END
	End If

   cntPrint = UBound(Arr_GameLevelDtlIDX,2) + 1

	For i = 0 To UBound(Arr_GameLevelDtlIDX,2)
%>
  <%
  '대회정보 선택==========================================================================================
      TSQL = "SELECT GameTitleName,"
      TSQL = TSQL & " A.Sex, A.PlayType, A.TeamGb, A.Level, A.LevelJooName, B.GameType, "
      TSQL = TSQL & " A.LevelJooNum, B.LevelJooNum AS LevelJooNumDtl,  B.LevelDtlName, GameLevelDtlIDX, "
      TSQL = TSQL & " B.GameType, B.PlayLevelType, A.GroupGameGb, A.GameType, "
      TSQL = TSQL & " B.GameType AS GameTypeDtl, B.TotRound AS TotRound"
      TSQL = TSQL & " FROM tblGameTitle C"
      TSQL = TSQL & " INNER JOIN tblGameLevel A ON A.GameTitleIDX = C.GameTitleIDX"
      TSQL = TSQL & " INNER JOIN tblGameLevelDtl B ON B.GameLevelidx = A.GameLevelIDX"
      TSQL = TSQL & " WHERE A.DelYN = 'N'"
      TSQL = TSQL & " AND B.DelYN = 'N'"
      TSQL = TSQL & " AND C.DelYN = 'N'"
      TSQL = TSQL & " AND B.GameLevelDtlidx = '" & Arr_GameLevelDtlIDX(0,i) & "'"


  Set TRs = Dbcon.Execute(TSQL)

  If Not(TRs.Eof Or TRs.Bof) Then
      GameTitleName 		   = TRs("GameTitleName")
      SexName         	   = rxPubGetName(TRs("Sex"))
      PlayTypeName         = rxPubGetName(TRs("PlayType"))
      PlayType             = TRs("PlayType")
      TeamGbName				= rxTeamGBGetName(TRs("TeamGb"))
      LevelName				= rxLevelName(TRs("Level"))
      LevelJooName			= rxPubGetName(TRs("LevelJooName"))
      LevelJooNum				= TRs("LevelJooNum")
      LevelJooNumDtl		   = TRs("LevelJooNumDtl")
      LevelDtlName			= TRs("LevelDtlName")
      GameTypeName			= rxPubGetName(TRs("GameType"))
      PlayLevelTypeName	   = rxPubGetName(TRs("PlayLevelType"))
      PlayLevelType			= TRs("PlayLevelType")
      GroupGameGbName		= rxPubGetName(TRs("GroupGameGb"))
      GroupGameGb				= TRs("GroupGameGb")
      GameType					= TRs("GameType")
      GameTypeDtl				= TRs("GameTypeDtl")
      TotRound					= TRs("TotRound")
	ELSE
      GameTitleName 		   = "-"
      SexName         	   = "-"
      PlayTypeName         = "-"
      PlayType             = ""
      TeamGbName				= "-"
      LevelName				= "-"
      LevelJooName			= "-"
      LevelJooNum				= ""
      LevelJooNumDtl		   = ""
      LevelDtlName			= "-"
      GameTypeName			= "-"
      PlayLevelTypeName	   = "-"
      PlayLevelType			= ""
      GroupGameGbName		= "-"
      GroupGameGb				= ""
      GameType					= ""
      GameTypeDtl				= ""
      TotRound					= "0"
  End If

	TRs.Close
  '대회정보 선택==========================================================================================

  '참가선수 카운팅========================================================================================

  '참가선수 카운팅========================================================================================

  '참가선수 카운팅========================================================================================
          '개인전
          If GroupGameGb = "B0030001" Then

              CSQL = "SELECT COUNT(*) AS PlayerCnt"
              CSQL = CSQL & " FROM "
              CSQL = CSQL & " ("
              CSQL = CSQL & " SELECT TourneyGroupIDX "
              CSQL = CSQL & " FROM tblTourney "
              CSQL = CSQL & " WHERE DelYN = 'N'"
              CSQL = CSQL & " AND GameLevelDtlidx = '" & Arr_GameLevelDtlIDX(0,i) & "'"
              CSQL = CSQL & " AND ISNULL(TourneyGroupIDX,'0') <> '0'"
              CSQL = CSQL & " AND [Round] = '1'"
              CSQL = CSQL & " GROUP BY TourneyGroupIDX"
              CSQL = CSQL & " ) AS AA			"

          Else
          '단체전

              CSQL = "SELECT COUNT(*) AS PlayerCnt"
              CSQL = CSQL & " FROM "
              CSQL = CSQL & " ("
              CSQL = CSQL & " SELECT Team, TeamDtl"
              CSQL = CSQL & " FROM tblTourneyTeam "
              CSQL = CSQL & " WHERE DelYN = 'N'"
              CSQL = CSQL & " AND GameLevelDtlidx = '" & Arr_GameLevelDtlIDX(0,i) & "'"
              CSQL = CSQL & " AND ISNULL(Team,'') <> ''"
              CSQL = CSQL & " AND [Round] = '1'"
              CSQL = CSQL & " GROUP BY Team, TeamDtl"
              CSQL = CSQL & " ) AS AA"

          End If


  Set CRs = Dbcon.Execute(CSQL)

  If Not(CRs.Eof Or CRs.Bof) Then
  	PlayerCnt = CRs("PlayerCnt")
	Else
		PlayerCnt = "0"
  End If

	CRs.Close
  '참가선수 카운팅========================================================================================
  %>


	<%
		If GameTypeDtl = "B0040002" Then
	%>
	<!-- S: 토너먼트대진표-->
   <%
         if PlayLevelType = "B0100001" Then
            cntQTournament = cntQTournament + 1
            if(cntQTournament Mod 2 = 1) Then
               %> <div class="wrapper"> <%
            Else
               %> <div class="wrapper">  <%
            End If
         Else
            cntQTournament = 0

						if cntPrint <> 1 Then
	 						%> <div class="wrapper" style="page-break-before:always;"> <%
	          End If
         End If



   %>

    <!-- S: header -->
    <div class="header">
      <h1 class="title"><%=GameTitleName%></h1>
        <!--<p class="date"> ~  / &nbsp; &nbsp;</p>-->
			<div class="moreInfo">
        <span class="team">
					[<%=SexName & PlayTypeName & " " &  TeamGbName & " " & LevelName & " " & LevelJooName & LevelJooNum & " "%>

					<%
						if PlayLevelType = "B0100001" Then
							Response.Write "예선" & LevelJooNumDtl & "조"
						ElseIf PlayLevelType = "B0100002" Then
							Response.Write "본선"
						Else
							Response.Write "-"
						End If
					%>]
        </span>
				<span class="attend"><span>참가선수: <%=PlayerCnt%><%If GroupGameGb = "B0030001" Then%>명<%Else%>팀<%End If%></span></span>
      </div>
    </div>

    <!-- s: bottom-list  본선 tournament-->
		<div class="main tournamentTree">
      <div id="div_Tournament_<%=i%>" class="bottom-list cls_Tournament">
        대진표자리
      </div>

      <%
         '&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
         '좌측선수정보셀렉트=========================================================
         LSQL = "EXEC tblGameTourneyChart_SearchedAll '" & Arr_GameLevelDtlIDX(0,i) & "'"
         Set LRs = Dbcon.Execute(LSQL)
   '      response.write LSQL
         If Not(LRs.Eof Or LRs.Bof) Then
            strJson = rsTojson_arrEx(LRs)
      %>         
         <script> displayTonament("div_Tournament_<%=i%>", <%=strJson%>, '<%=PlayType%>', '<%=PlayLevelType%>', '<%=GroupGameGb%>'); </script>
      <%
         End If
			LRs.Close
      %>
      <input type="hidden" id="hide_tourData_<%=i%>" value='<%=strJson%>'>
    </div>

    <!-- S: footer -->
    <!-- <div class="footer">
      <div class="bot_logo">
        <img src="../../Images/print/logo_badminton.png" alt="대한배드민턴협회">
      </div>
      <div class="print_date">
      	<img src="./logo/sd_gray.png">
      </div>
    </div> -->
    <!-- E: footer -->
  </div>
	<!-- E: 토너먼트대진표-->

	<%
		Else

			USQL = "tblGameTourneyChartLeague_SearchedAll '" & Arr_GameLevelDtlIDX(0,i) & "'"
 '        USQL2 = "tblGameTourneyChartLeague_Searched '" & Arr_GameLevelDtlIDX(0,i) & "'"

			Set URs = Dbcon.Execute(USQL)

			If Not(URs.Bof Or URs.Eof) Then

				Arr_Player = URs.Getrows()
				Cnt_Arr_Player = UBound(Arr_Player,2)

				WriteDate = Arr_Player(11,0)

				ReDim ReturnSTR(Cnt_Arr_Player)

				For j = 0 To Cnt_Arr_Player
					ReturnSTR(j) = Arr_Player(0,j) & "," & Arr_Player(1,j) & "," & Arr_Player(2,j) & "," & Arr_Player(3,j) & "," & Arr_Player(4,j) & "," & Arr_Player(5,j)
				Next
			End If

			URs.Close

			'리그전번호 가져오기
			LSQL = " SELECT  LeagueGameNumIDX, GameNum, LeagueGameNum, MemberCnt, DelYN, WriteDate"
			LSQL = LSQL & " FROM  TblLeagueGameNum "
			LSQL = LSQL & " WHERE DelYN = 'N'"
			'LSQL = LSQL & " AND MemberCnt = '" & UBOUND(Arr_Player,2) + 1 & "'"
			 LSQL = LSQL & " AND MemberCnt = '" & Cnt_Arr_Player  + 1 & "'"
			Set LRs = Dbcon.Execute(LSQL)

			If Not (LRs.Eof Or LRs.Bof) Then
					Array_DBLeagueGameNum = LRs.getrows()
			End If
			LRs.Close


			If GroupGameGb = "B0030001" Then

				LSQL = "SELECT CASE WHEN MAX(ISNULL(WriteDate,0)) < '2018-08-01 17:40:13.820' THEN 'Y' ELSE 'N' END AS OldData "
				LSQL = LSQL & " FROM tblTourney"
				LSQL = LSQL & " WHERE DelYN = 'N'"
				LSQL = LSQL & " AND GameLevelDtlidx = '" & Arr_GameLevelDtlIDX(0,arrnum) & "'"

				Set LRs = Dbcon.Execute(LSQL)
            ' response.write "개인전  = " & LSQL & "<br>"

				If Not (LRs.Eof Or LRs.Bof) Then
					OldLeagueNumYN = LRs("OldData")
				Else
					OldLeagueNumYN = "N"
				End If
				LRs.Close

			Else

			End If

         Dim aryLeague, aryPLeague, aryTLeague, aryInfo, len_colum, cnt_player, IsTeamGame, aryResult
         Dim useHistory, pos_rank

         cnt_player = Cnt_Arr_Player + 1
         pos_rank   = cnt_player + CNT_RESULT_INFO -1
         ' 점수 * Cnt_Arr_Player + 승패득실차순위 + (LScore,RScore,Result)*Cnt_Arr_Player
         len_colum = cnt_player + CNT_RESULT_INFO + (cnt_player * CNT_GAMEPER_INFO) - 1

         aryLeague = null
         aryPLeague = null
         aryTLeague = null
         aryInfo    = null
         aryResult  = null

         ReDim aryInfo(len_colum, cnt_player-1)

'         strLog = strPrintf("len_colum = {0}, Cnt_Arr_Player = {1}", Array(len_colum, cnt_player))
'         response.write strLog
'         response.End

         '개인전일때
         If GroupGameGb = "B0030001" Then
            CSQL = "Select L_MemberNames,	L_MemberIDXs, L_TeamNames, L_Teams, L_TeamDtl, "
            CSQL = CSQL & " R_MemberNames, R_MemberIDXs, R_TeamNames, R_Teams, R_TeamDtl, "
            CSQL = CSQL & " L_SetJumsu	,L_MatchJumsu,	R_SetJumsu,R_MatchJumsu, L_Result, TGT.EnterType"
            CSQL = CSQL & " From tblGameOperate As TGO WITH(NOLOCK)"
            CSQL = CSQL & " Inner Join tblGameTitle TGT WITH(NOLOCK) On TGT.GametitleIDX = TGO.GametitleIDX And TGT.DelYN = 'N'"
            CSQL = CSQL & " WHERE TGO.DelYN = 'N' AND TGO.GameLevelDtlIDX = '" & Arr_GameLevelDtlIDX(0,i) & "'"
            CSQL = CSQL & " AND ((GroupGameGB = 'B0030001' AND TeamGameNum = '0'))  Order By GameNum"
            Set CRs = Dbcon.Execute(CSQL)

            If Not (CRs.Eof Or CRs.Bof) Then
					aryLeague = CRs.GetRows()
				End If
            CRs.Close
            ' response.write "개인전일때 리그  = " & CSQL & "<br>"

            IsTeamGame = 0
            useHistory = 0
'            Call printInfo(aryLeague)
            Call SetLeagueGameInfo(aryLeague, Arr_Player, aryInfo, IsTeamGame)
'            Call printInfo(aryInfo)
         '단체전일때
         Else
            CSQL = "Select L_MemberNames,	L_MemberIDXs, L_TeamNames, L_Teams, L_TeamDtl, "
            CSQL = CSQL & " R_MemberNames, R_MemberIDXs, R_TeamNames, R_Teams, R_TeamDtl, "
            CSQL = CSQL & " L_SetJumsu	,L_MatchJumsu,	R_SetJumsu,R_MatchJumsu, L_Result, TGT.EnterType"
            CSQL = CSQL & " FROM tblGameOperate TGO WITH(NOLOCK)"
            CSQL = CSQL & " Inner Join tblGameTitle TGT WITH(NOLOCK) On TGT.GametitleIDX = TGO.GametitleIDX And TGT.DelYN = 'N'"
            CSQL = CSQL & " WHERE TGO.DelYN = 'N' AND TGO.GameLevelDtlidx = '" & Arr_GameLevelDtlIDX(0,i) & "'"
            CSQL = CSQL & " AND ((GroupGameGB = 'B0030002' AND GameNum = '0')) Order By TeamGameNum"
            Set CRs = Dbcon.Execute(CSQL)

            If Not (CRs.Eof Or CRs.Bof) Then
					aryLeague = CRs.GetRows()
				End If
            CRs.Close

            ' response.write "단체전일때 리그  = " & CSQL & "<br>"

            IsTeamGame = 1
            useHistory = 1
'            Call printInfo(aryLeague)
            Call SetLeagueGameInfo(aryLeague, Arr_Player, aryInfo, IsTeamGame)
'            Call printInfo(aryInfo)

         End If

'         Call printInfo(aryInfo)
         aryResult = GetAryResultInfo(Arr_Player, aryInfo)
'         response.write " --------------- print aryResult ----------------- <br>"
'         Call printInfo(aryResult)
'         response.write " --------------- print aryResult ----------------- <br>"

         useHistory = 1

'         Call printInfo(aryResult)
         Call uxMakeRankForPrint(aryResult, aryLeague, IsTeamGame, useHistory)
'         Call printInfo(aryResult)

         Call ApplyRanking(aryInfo, aryResult, pos_rank)
'         Call printInfo(aryResult)

'         strLog = strPrintf(" ul = {0}, ul2 = {1}, Cnt_Arr_Player = {2}<br>", Array(ul, ul2, Cnt_Arr_Player))
'         response.write strLog

	%>
	<!-- S: 리그대진표-->
  <div class="wrapper">
		<!-- S: header -->
		<div class="header">
			<h1 class="title"><%=GameTitleName%></h1>
				<!--<p class="date"> ~  / &nbsp; &nbsp;</p>-->
			<div class="moreInfo">
				<span class="team">
					[<%=SexName & PlayTypeName & " " &  TeamGbName & " " & LevelName & " " & LevelJooName & LevelJooNum & " "%>
					<%
						if PlayLevelType = "B0100001" Then
							Response.Write "예선" & LevelJooNumDtl & "조"
						ElseIf PlayLevelType = "B0100002" Then
							If GameTypeDtl  = "B0040001" AND FullGameYN = "Y" Then
								Response.Write "풀리그"
							Else
								Response.Write "본선"
							End If
						Else
							Response.Write "-"
						End If
					%>]
				</span>
				<span class="attend"><span>참가선수: <%=UBOUND(Arr_Player,2) + 1%><%If GroupGameGb = "B0030001" Then%>명<%Else%>팀<%End If%></span></span>
			</div>
		</div>

		<!-- E: header -->
		<!-- S: main -->
		<div class="main league">

			<div class="line_area">
			<%
				If Cnt_Arr_Player <> "" Then
			%>
				<table class="table">
					<tbody>
						<tr>
							<th class="team">구분</th>

                     <% ' ========================== 선수명 ==================================== %>
							<%
								'해당되는 선수수만큼 Loop
								For k = 0 To Cnt_Arr_Player
							%>
							<th class="playerTH">
								<div class="number">
									<!--<span class="round"><%=k+1%></span>-->
								</div>
								<div class="player">
                        <%If GroupGameGb = "B0030001" Then%>
                           <span class="name"><%=TeamGBtoSimple(Arr_Player(1,k))%><font style="font-size:16px">(<%=TeamGBtoSimple(Arr_Player(5,k))%>)</font></span>

                           <%If Arr_Player(2,k) <> "" AND Not ISNULL(Arr_Player(2,k)) Then%>

                           <span class="name"><%=TeamGBtoSimple(Arr_Player(2,k))%><font style="font-size:16px">(<%=TeamGBtoSimple(Arr_Player(6,k))%>)</font></span>

                           <%End If%>
                        <%Else%>
                           <span class="name">

                              <%=TeamGBtoSimple(Arr_Player(5,k))%>
                              <%
                                 If Arr_Player(9,k) <> "0" Then
                                    Response.Write Arr_Player(9,k)
                                 End If
                              %>
                           </span>
                        <%End If%>
								</div>
							</th>
							<%
								Next
							%>

                     <% ' ========================== 선수명 ==================================== %>
						</tr>
						<%
							leagueGameNum = 0
							For k = 0 To Cnt_Arr_Player
						%>

						<tr>
                     <% ' ========================== 선수명 ==================================== %>
							<th>
								<div class="number">
									<!--<span class="round"><%=k+1%></span>-->
								</div>
								<div class="player">
								<% If GroupGameGb = "B0030001" Then%>

                              <span class="name"><%=TeamGBtoSimple(Arr_Player(1,k))%><font style="font-size:16px">(<%=TeamGBtoSimple(Arr_Player(5,k))%>)</font></span>

                              <%If Arr_Player(2,k) <> "" AND Not ISNULL(Arr_Player(2,k)) Then%>

                              <span class="name"><%=TeamGBtoSimple(Arr_Player(2,k))%><font style="font-size:16px">(<%=TeamGBtoSimple(Arr_Player(6,k))%>)</font></span>

                              <%End If%>
                           <%Else%>
                              <span class="name">
                                 <%=TeamGBtoSimple(Arr_Player(5,k))%>
                                 <%
                                    If Arr_Player(9,k) <> "0" Then
                                       Response.Write Arr_Player(9,k)
                                    End If
                                 %>
                              </span>
                           <%End If %>
								</div>
							</th>

							<%
								For m = 0 To Cnt_Arr_Player
                     %>
                           <td >
                              <%=aryInfo(m,k)%>
                           </td>
                     <%
								Next
							%>
                     <% ' ========================== 선수명 ==================================== %>
						</tr>
						<%
							Next
						%>
					</tbody>
				</table>
				<%
					End If
				%>
			</div>
		</div>
		<!-- E: main -->
		<!-- S: footer -->
		<!-- <div class="footer">
			<div class="bot_logo">
				<img src="../../Images/print/logo_badminton.png" alt="대한배드민턴협회">
			</div>
			<div class="print_date">
				<img src="./logo/sd_gray.png">
			</div>
		</div> -->
		<!-- E: footer -->
	</div>
	<!-- E: 리그대진표-->
	<%
		End If
	%>
<%
	Next
%>




	</div>
</body>
</html>
