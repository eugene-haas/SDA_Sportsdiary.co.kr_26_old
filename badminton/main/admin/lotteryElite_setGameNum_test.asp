<!-- #include virtual = "/pub/charset.asp" -->
<!-- #include virtual = "/pub/hdr.inc.bm.min.asp" -->
<!-- #include virtual = "/pub/fn/fn.utiletc.asp" -->
<!-- #include virtual = "/pub/fn/badmt/res/res.pubcode.asp" -->
<!-- #include virtual = "/pub/fn/badmt/res/res.teamGB.asp" -->
<!-- #include virtual = "/pub/fn/badmt/res/res.lvInfo.asp" -->

<%
   Dim strPos, strQPos, playType, strGroupGameGb, strPlayType, strGInfo, strGTitle, strGKind, aryGInfo
	 Dim manualSet

   strPos = Request.Form("pos")
   strQPos = Request.Form("q_pos")
   strPlayType = Request.Form("playType")
   strGroupGameGb = Request.Form("groupGameGb")
   strGInfo = Request.Form("gameInfo")
   aryGInfo = Split(strGInfo, ",")
   strGTitle = aryGInfo(0)
   strGKind = aryGInfo(1)
	 manualSet = aryGInfo(2)

'   strLog = sprintf("strPos = {0}<br><br>strQPos = {1}<br>", Array(strPos, strQPos))
'   Response.Write strLog
%>
<!DOCTYPE html>
<meta charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>대진표 미리보기</title>
<script type="text/javascript" src="/js/jquery-1.12.2.min.js"></script>
<link rel="stylesheet" href="/css/lib/jquery.timepicker.min.css">
<script type="text/javascript" src="/js/library/jquery.timepicker.min.js"></script>

<link rel="stylesheet" href="/css/lib/jquery-ui.min.css">
<link rel="stylesheet" href="/css/lib/bootstrap-datepicker.css">
<link rel="stylesheet" type="text/css" href="/css/bootstrap.css">
<link rel="stylesheet" type="text/css" href="/css/fontawesome-all.css">
<link rel="stylesheet" type="text/css" href="/css/style.css">
<link rel="stylesheet" href="http://img.sportsdiary.co.kr/lib/tournament/tournament.css">
<!-- 엘리트 대진추첨  css -->
<link rel="stylesheet" type="text/css" href="/css/lotteryElite_setGameNum.css">
<!-- sd_admin.css -->
<link rel="stylesheet" type="text/css" href="/css/admin/admin.d.style.css">

<script type="text/javascript" src="/js/library/bootstrap-datepicker.js"></script>
<script type="text/javascript" src="/js/jquery-migrate-1.4.1.min.js"></script>
<script type="text/javascript" src="/js/library/selectivizr-min.js"></script>
<script type="text/javascript" src="/js/library/jquery-ui.min.js"></script>
<script type="text/javascript" src="/js/library/jquery.easing.min.js"></script>
<script type="text/javascript" src="/js/library/bootstrap.min.js"></script>
<script src="/js/library/placeholders.min.js"></script>
<script type="text/javascript" src="/js/library/datepicker-ko.js"></script>
<script type="text/javascript" src="/dev/dist/Common_Js.js" ></script>
<script type="text/javascript" src="/js/CommonAjax.js?ver=1.0"></script>
<script type="text/javascript" src="/js/bdadmin.js"></script>
<script type="text/javascript" src="/pub/js/etc/tournament_modify/tournament.js"></script>
<script type="text/javascript" src="/pub/js/etc/utx.js<%=UTX_JSVER%>"></script>
<script type="text/javascript" src="/pub/js/etc/ctx.js<%=CTX_JSVER%>"></script>
<script type="text/javascript" src="/pub/js/etc/bmx.js<%=BMX_JSVER%>"></script>
<script type="text/javascript" src="/js/GameTitleMenu/LotteryElite.js?ver=1.1.7"></script>

<style>
	html,body{height:100%;}
	html, body, div, ul, li, dl, dd, p, h1, h2, h3, h4, h5, h6, span, table, tr, td, th{padding:0;margin:0;}
	li{list-style:none;}
	input,select{height:35px;line-height:35px;border:1px solid #ddd;padding:5px;}

	.lotteryElite .content-warp .btn-box{display:table;width:100%;margin-top:10px;text-align:right;}
	.lotteryElite .content-warp .btn-box a{line-height:35px;background:#2f6fc1;color:#fff;min-width:100px;padding:0 15px;font-size:14px;text-align:center;border-radius:3px;margin:0 3px;}

	.lotteryElite{min-width:1200px;}
	.lotteryElite .top-title{background: #0f335b;line-height:50px;text-align:center;color:#fff;font-size:18px;font-family: 'NanumGothicB';}
	.lotteryElite .content-warp{display:table;width:100%;padding:15px;max-width:1600px;margin:auto;min-width:1200px;}
	.lotteryElite .left-con{float:left;width:49%;}

	.lotteryElite .left-con .title{position:relative;line-height:40px;background:#2f6fc1;color:#fff;text-align:center;font-size:16px;font-family:'NanumGothicB';}
	.lotteryElite .left-con .title__inp{background-color:#2f6fc1;color:#fff;height:40px;border:2px solid #2f6fc1;outline:none;padding-left:10px;padding-right:60px;}
	.lotteryElite .left-con .title__inp:focus{background-color:#fff;color:#000;}
	.lotteryElite .left-con .title__inp::placeholder{color:#fae05a;}
	.lotteryElite .left-con .title__inp:focus::placeholder{color:#bdbdbd;}
	.lotteryElite .left-con .title__inp~.dropdown-menu{width:100%;color:#000;padding:0 10px;}
	.lotteryElite .left-con .title__inp:focus~.title__toggle{display:none;}
	.lotteryElite .left-con .title__toggle{position:absolute;width:60px;padding:0 5px;box-sizing:border-box;right:0;top:0;font-size:12px;background:none;border:0;}

	.lotteryElite .left-con .top-search{position:relative;background:#dbe1e8;display:table;width:100%;padding:15px;display:block;border: 1px solid #ccc;border-bottom:0;}
	.lotteryElite .left-con .top-search.on{display:none;}
	.lotteryElite .left-con .top-search .in-se-list{float:left;width:49%;box-sizing: border-box;}
	.lotteryElite .left-con .top-search .in-se-list li{padding:0 5px;box-sizing: border-box;margin-bottom:5px;display:table;width:100%;}
	.lotteryElite .left-con .top-search .in-se-list li:last-child{margin-bottom:0;}
	.lotteryElite .left-con .top-search .in-se-list li .l-name{float:left;width:30%;line-height:35px;color:#333;font-size:14px;font-family: 'NanumGothicB';}
	.lotteryElite .left-con .top-search .in-se-list li .r-con{float:left;width:70%;}
	.lotteryElite .left-con .top-search .in-se-list li .r-con input{width:100%;background:#fff;}
	.lotteryElite .left-con .top-search .in-se-list li .r-con input~.dropdown-menu{width:100%;}
	.lotteryElite .left-con .top-search .in-se-list li .r-con select{width:100%;background:#fff;}


	.lotteryElite .left-con .top-search .r-ranking-box{float:left;width:49%;box-sizing: border-box;margin-left:2%;}
	.lotteryElite .left-con .top-search .r-ranking-box .tab{font-size:16px;font-family:'NanumGothicB';line-height:35px;background:#758290;color:#fff;text-align:center;}
	.lotteryElite .left-con .top-search .r-ranking-box .tab__radio.s_igno{position:relative;top:3px;margin-left:5px;cursor:pointer;}
	.lotteryElite .left-con .top-search .r-ranking-box .tab__menu{margin:10px 5px 10px 0px;cursor:pointer;}
	.lotteryElite .left-con .top-search .r-ranking-box .tab__panel{display:none;border-top:1px solid #fff;margin:0 10px;padding:10px 0;font-size:14px;overflow:hidden;}
	.lotteryElite .left-con .top-search .r-ranking-box #AssignAuto:checked ~ .tab__panel.s_auto{display:block;}
	.lotteryElite .left-con .top-search .r-ranking-box #AssignCheck:checked ~ .tab__panel.s_check{display:block;}
	.lotteryElite .left-con .top-search .r-ranking-box #AssignMenual:checked ~ .tab__panel.s_menual{display:block;}
	.lotteryElite .left-con .top-search .r-ranking-box .tab__panel label{float:left;display:block;width:29%;margin:0 0 0 3%;line-height:24px;}
	.lotteryElite .left-con .top-search .r-ranking-box .tab__panel label span{display:inline-block;width:70%;}
	.lotteryElite .left-con .top-search .r-ranking-box .tab__panel label input{position:relative;top:4px;}

	.lotteryElite .left-con .middle-btns{width:100%;margin-top:10px;}
	.lotteryElite .left-con .middle-btns button{width:50%;height:30px;background-color:#2F6FC1;color:#fff;border:0;}
	.lotteryElite .left-con .middle-btns button.s_active{background-color:#ff8300;}

	.lotteryElite .left-con .bottom-list{padding:15px;background:#f2f2f2;background:#fffaf5;overflow:auto;border: 1px solid #ccc;}

	.lotteryElite .right-con{float:left;width:49%;margin-left:2%;}
	.lotteryElite .right-con .searching{position:relative;}
	.lotteryElite .right-con .searching__input{padding-left:30px;}
	.lotteryElite .right-con .searching__del{position:absolute;width:30px;left:0;top:0;bottom:0;margin:auto;font-size:14px;color:#ddd;background:none;border:none;}
	.lotteryElite .right-con .searching__del:hover{color:#333;}

	.lotteryElite .right-con .entryBox{border: 1px solid #758290;margin-top:10px;display:inline-block;width:100%;text-align:center;}
	.lotteryElite .right-con .entryBox__header,
	.lotteryElite .right-con .entryBox__footer{background:#758290;color:#fff;font-family:'NanumGothicB';width:100%;line-height:41px;}
	.lotteryElite .right-con .entryBox__body{overflow:auto;max-height:714px;height:100%;}
	.lotteryElite .right-con .entryBox__row{display:table;width:100%;border-bottom:1px solid #ddd;}
	.lotteryElite .right-con .entryBox__col{float:left;overflow:hidden;}
	.lotteryElite .right-con .entryBox__header .entryBox__col:nth-child(1){width:20%;border-right:1px solid #eee;}
	.lotteryElite .right-con .entryBox__header .entryBox__col:nth-child(2){width:65%;border-right:1px solid #eee;}
	.lotteryElite .right-con .entryBox__header .entryBox__col:nth-child(3){width:15%;}
	/* .lotteryElite .right-con .entryBox__body .entryBox__col:nth-child(1){width:20%;border-right:1px solid #eee; line-height:112px;} */
	.lotteryElite .right-con .entryBox__body .entryBox__col:nth-child(1){width:20%;border-right:1px solid #eee;height:112px;display:flex;align-items:center;}
  .lotteryElite .right-con .entryBox__body .entryBox__col:nth-child(1)>span{margin:auto;}
	.lotteryElite .right-con .entryBox__body .entryBox__col:nth-child(2){width:65%;border-right:1px solid #eee;}
	.lotteryElite .right-con .entryBox__body .entryBox__col:nth-child(3){width:15%;line-height:102px;}
	.lotteryElite .right-con .entryBox__footer .entryBox__row{border-bottom:0;}
	.lotteryElite .right-con .entryBox__footer .entryBox__col:nth-child(1){width:85%;border-right:1px solid #eee;}
	.lotteryElite .right-con .entryBox__footer .entryBox__col:nth-child(2){width:15%;}
	.lotteryElite .right-con .entry{width:100%;padding:16px 10px;white-space:nowrap;overflow:auto;line-height:normal;text-align:left;}
	.lotteryElite .right-con .entry__item{text-align:center;display:inline-block;width:70px;background:#dbe1e8;border-radius:3px;padding:5px;border:0;margin:1px;}
	.lotteryElite .right-con .entry__item.s_related{background:#ff8300;color:#fff;font-family:'NanumGothicB';user-select: none;cursor:pointer;}
	.lotteryElite .right-con .entry__item.s_related input{color:#333;}
	.lotteryElite .right-con .entry__item.s_selected{border:1px dashed #dbe1e8;background:#f5f5f5;color:#bdbdbd;}
	.lotteryElite .right-con .entry__input{max-width:60px;line-height:26px;height:26px;border:0;margin-top:5px;text-align:center;}
	.lotteryElite .right-con .entry__matchNo{height:26px; line-height:26px;}


	.modal-warp{display:none;}
	.modal-warp.on{position:fixed;top:50%;left:0;right:0;margin:auto;width:100%;background:#fff;padding:20px; -webkit-box-shadow: 0px 0px 10px;-moz-box-shadow: 0px 0px 10px;box-shadow: 0px 0px 10px;border-radius:3px;}
	.fixed-bg.on{position:fixed;width:100%;height:100%;background:#000;top:0;left:0;opacity:0.8;}

	.modal-warp.modal-one{text-align:center;max-width:300px;margin-top:-78px;}
	.modal-warp.modal-one .p-name{color:#387cb0;font-family:'NanumGothicB';font-size:16px;}
	.modal-warp.modal-one .p-ranking{font-size:20px;font-family:'NanumGothicB';color:#333;margin:15px 0;  }
	.modal-warp.modal-one .btn{min-width:80px;}
	.modal-warp.modal-tow{text-align:center;max-width:300px;margin-top:-78px;}
	.modal-warp.modal-tow select{width:100%;margin-bottom:10px;}
	.modal-warp.modal-tow .p-txt span{font-family:'NanumGothicB';}
	.modal-warp.modal-tow .b-txt{margin-top:15px;}
	.modal-warp.modal-tow .btn-box .btn{min-width:80px;}
	.modal-warp.modal-three{text-align:center;max-width:300px;margin-top:-78px;}
	.modal-warp.modal-three .btn-box{margin-top:10px;}
	.modal-warp.modal-three .btn-box .btn{min-width:80px;}
	.modal-warp.modal-three .red-font{color:#e60000;}

	.modal-warp.modal-four{text-align:center;max-width:300px;margin-top:-78px;}
	.modal-warp.modal-four .btn-box{margin-top:10px;}

	::-webkit-scrollbar {
		width: 4px;
		height:10px;
		background: none;
	}
	::-webkit-scrollbar-thumb {
	    background: #ddd;
	    opacity: .4;
	}
	::-webkit-scrollbar-track {
	    background: none;
	}
	.bg-title{background:#758290;}
</style>
<style>

	.lotteryMatch{ position:absolute; width:100%; height:44px; margin:auto; box-sizing:border-box; overflow:hidden;
		border-color:#f2f2f2; border-style:solid;
		display:flex;
		opacity:0.5;
	}
  .tour_single .lotteryMatch{height:22px;}
	.lotteryMatch.s_selected{border:2px solid #ff8300;}
	.lotteryMatch.s_duplicate{border:2px solid #2db23c;}

	/* !@# */
	.lotteryMatch.s_filled{opacity:1;}

	.lotteryMatch_first{ bottom:50%;
		/* border-width:0 0 1px 0; */
		border-radius:4px 4px 0 0;
	}
	.lotteryMatch_second{ top:50%;
		/* border-width:1px 0 0 0; */
		border-radius:0 0 4px 4px;
	}

  .lotteryMatch_first .lotteryMatch__seedWrap{ bottom:50%;
    border-style:solid;
    border-width:1px 1px 1px 1px;
    border-radius:4px 0px 0 0;
    border-color:#ccc;
  }
  .lotteryMatch_second .lotteryMatch__seedWrap{ top:50%;
    border-style:solid;
    border-width:0px 1px 1px 1px;
    border-radius:0 0 0px 4px;
    border-color:#ccc;
  }
  .lotteryMatch_first .lotteryMatch__playerWrap{ bottom:50%;
    border-style:solid;
    border-width:1px 1px 1px 0;
    border-color:#ccc;
    border-radius:0 4px 0 0px;
  }
  .lotteryMatch_second .lotteryMatch__playerWrap{ top:50%;
    border-style:solid;
    border-width:0px 1px 1px 0;
    border-color:#ccc;
    border-radius:0 0 4px 0px;
  }

	.lotteryMatch__seedWrap1{
		display:block;
		width:16%;
		height:100%; text-align:left; text-indent:5px; font-size:13px; letter-spacing:-0.05em; line-height:26px;
	}
	.lotteryMatch__seedWrap{
		display:block;
		width:20%;
		height:100%; text-align:left; text-indent:5px; font-size:13px; letter-spacing:-0.05em; line-height:26px;
		background-color:#dbe1e8;
	}
	.lotteryMatch__playerWrap{
		display:flex;flex-direction:column;justify-content:center;
		width:64%;
		height:100%;padding:0 4px;box-sizing:border-box;text-align:left;
		background-color:#b3c1d1;
		background-color:#b6c3d2;
	}
	.lotteryMatch__playerInner{
		width:100%;display:block;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;
	}
	.lotteryMatch__player{display:inline;font-size:13px;font-weight:700;line-height:18px;}
	.lotteryMatch__belong{display:inline;font-size:12px;line-height:18px;}

  .bocsic.modal-warp{max-width:400px;}

  /* @media print{ */
    .lotteryMatch{border:1px solid #ccc;border:none;}
    .lotteryMatch+.lotteryMatch{border-top:none;}
    .lotteryMatch__seedWrap, .lotteryMatch__playerWrap{background-color:transparent;}
    .round_line, .round_line+.tournament__round{margin-top:-1px;}
    /* } */
    .tournament_info{margin-top:10px;border-bottom: 2px solid #333;}
    .tournament_info~.tournament_info{margin-top:20px;}
    .tournament_info h3{font-size:15px;font-weight:bold;}
    .tournament_info p{}
    .tournament_info strong{}
    .tournament_info span{margin-left:20px;text-decoration:underline;}
</style>

<script>
   /* ==================================================================================
      전역 변수
      참여 인원 정보, 연동대회 상위입상자 정보를 저장하기 위한 전역 배열
   ================================================================================== */
   var gAryPos = null;                 // Tonament 참가자 배치 Position Array
   var gAryQPos = null;                 // 예선조 참가자 배치 Position Array
   var gStrPos = "<%=strPos%>";
   var gStrQPos = "<%=strQPos%>";
   var gPlayType = "<%=strPlayType%>";
   var gGroupGameGB = "<%=strGroupGameGb%>";    // 개인전, 단체전
   var gStrGTitle = "<%=strGTitle%>";        // Game Title
	 var gStrGKind = "<%=strGKind%>";          // Game Kind
	 var gManualSet = Number("<%=manualSet%>");        // Manual Set


   var E_POS_NORMAL, E_POS_SEED, E_POS_BYE, E_POS_Q, E_POS_FIRST, E_POS_MANUAL;
   var E_PART_Q, E_PART_F;             // 예선, 본선

   E_POS_NORMAL            = 0;               // 일반 자리
   E_POS_SEED              = 1;               // Seed 자리
   E_POS_BYE               = 2;               // Bye 자리
   E_POS_Q                 = 3;               // 예선전 조 자리
   E_POS_FIRST             = 4;               // 1장 자리
   E_POS_MANUAL            = 5;               // 수동 배정 자리


   E_PART_Q                = 0;               // 예선
   E_PART_F                = 1;               // 본선

</script>

<div class="lotteryElite">
	<!-- s: top-title -->
	<div class="top-title">
		배드민턴 엘리트 대진추첨
	</div>
	<!-- e: top-title -->
	<!-- s: content-warp -->
	<div class="content-warp">

  		<!-- s: bottom-list  예선전 tournament-->
      <div id="div_QTournamentInfo" class="tournament_info">
      </div>

      <div id="div_QTournament_body" class="bottom-list cls_QTournament">
            <!-- 예선 대진표자리 -->
      </div>

      <!-- s: bottom-list  본선 tournament-->

      <div id="div_TournamentInfo" class='tournament_info'> </div>

      <div id="div_FTournament" class="bottom-list cls_FTournament">
            대진표자리
      </div>
      <script>



      </script>
	</div>
	<!-- e: content-warp -->
</div>

<div class="fixed-bg"></div>

<!-- content height setting -->
<script>

	var $windowHeight = $(window).height(); /* 윈도창 높이 */
	var $bottomlistHeight = $(".lotteryElite .content-warp .left-con .bottom-list");
	var $toptitleHeight = $(".lotteryElite .top-title").outerHeight(true);
	var $topsearchHeight =$(".lotteryElite .content-warp .left-con .top-search").outerHeight(true);
	var $btnbtnboxHeight =$(".btm-btn-box").outerHeight(true);
	var $rtableHeight = $(".entryBox__body");
	$bottomlistHeight.css("height", $windowHeight - $toptitleHeight - $btnbtnboxHeight - $topsearchHeight - 110);
	$rtableHeight.css("height", $windowHeight -254);

	var $topSearchbox = $(".lotteryElite .content-warp .left-con .top-search");
	$('._toggleTitle').click(function(){
		if(!($topSearchbox.hasClass("on"))){
			$topSearchbox.addClass("on");
			$(this).addClass("on").text("펼치기");
			$bottomlistHeight.css("height", $windowHeight - $toptitleHeight - $btnbtnboxHeight - 110);
		}else{
			$topSearchbox.removeClass("on")
			$(this).removeClass("on").text("닫기")
			$bottomlistHeight.css("height", $windowHeight - $toptitleHeight - $btnbtnboxHeight - $topsearchHeight - 110);
		}
	});

</script>

<script>

    $(document).ready(function () {
      if(gStrPos != "") {
         gAryPos =  utx.Get2DAryFromStr(gStrPos, "|", ",");
         createTournament(gAryPos);
      }
    });
</script>

<script>
   // **********************************************************************************
   //
   // **********************************************************************************


/* ==================================================================================
      round depth를 구한다.
   ================================================================================== */
	function getRoundDepth(round) {
		var i = 0, base = 2, f_loop = 1, loop_max = 20, round_depth = 0, loop_cnt = 1;

		while(f_loop) {
			round = round / base;
			round_depth++;
			if(round == 1) {
				f_loop = 0;
			}

			loop_cnt++;
			if(loop_cnt > loop_max) {
				f_loop = 0;
			}
		}

		return round_depth;
	}

/* ==================================================================================
      aryPos을 받아서 본선 토너먼트를 생성한다.
   ================================================================================== */
   function createTournament(rAryPos)
   {
      var aryData, i = 0, len = 0, obj, IsDblPlay = 1, round = 0, round_depth = 0, cur_round = 0;
      var f_tournament, strInfo, cntUser, nScale = 1, nBlockHeight = 48, pos_info = 0;
		var nFirstBoarderGap = 0, nBoardWidth = 0;
      aryData = new Array();

		round = rAryPos.length;
		round_depth = getRoundDepth(round);

      IsDblPlay = bmx.IsDoublePlay(gPlayType);

      cntUser = GetUserCntInPos(rAryPos);
      strInfo = GetStrGInfoFinal(gStrGTitle, gStrGKind, cntUser);
      ctx.appendHtmlToDiv("div_TournamentInfo", strInfo);

		utx.printInfo2DAry(rAryPos, "In createTournament");

		for(i = 0; i<round_depth; i++)
      {
         aryData[i] = new Array();
      }

      for(i = 0; i< round; i+=2)
      {
         if(gGroupGameGB == "B0030001")         // 개인전
         {
            obj = fillUserInfo(i, rAryPos[i], rAryPos[i+1], IsDblPlay);
         }
         else if(gGroupGameGB == "B0030002")    // 단체전
         {
            obj = fillTeamUserInfo(i, rAryPos[i], rAryPos[i+1], IsDblPlay);
         }

         aryData[0].push(obj)
		}

		var empty_round = round / 2;
		pos_info = round / 2;
		for(i = 1; i < round_depth; i++)
      {
			pos_info = MakeEmptyData(aryData[i], empty_round, pos_info);
			empty_round = empty_round / 2;
      }

      if(IsDblPlay == 1)
      {
         nBlockHeight = 48;
			nFirstBoarderGap = 320, nBoardWidth = 60;

         if(round == 32) {
            if(gStrQPos != "" )
            {
               nBlockHeight = 46;
               nScale = 0.99;
            }
            else
            {
               nBlockHeight = 44;
               nScale = 1;
            }
         }
         else if(round == 64) {
            nBlockHeight = 48;
            if(gStrQPos != "" ) nScale = 0.98;
            else {
               nBlockHeight = 48;
               nScale = 0.93;
            }
         }
         f_tournament = makeTournamentDouble("div_FTournament", nScale, nBlockHeight,nBoardWidth, nFirstBoarderGap );
      }
      else
      {
         nBlockHeight = 24;
			nFirstBoarderGap = 320, nBoardWidth = 60;
         if(round == 64) {
            if(gStrQPos != "" )
            {
               nBlockHeight = 22;
               nScale = 1;
            }
            else
            {
               nBlockHeight = 22;
               nScale = 1;
            }
         }
         else if(round == 128) {
            if(gStrQPos != "" ) {
               nBlockHeight = 24;
               nScale = 0.98;
            }
            else {
               nBlockHeight = 23;
               nScale = 0.97;
            }
         }

         f_tournament = makeTournamentSingle("div_FTournament", nScale, nBlockHeight, nBoardWidth, nFirstBoarderGap);
		}

      drawTournamentEx2(f_tournament, round, round_depth, aryData);
	}

	/* ==================================================================================
   draw Tonament - tonament Object, round, data를 입력받아 tonament를 그린다.
================================================================================== */
   function drawTournamentEx2(objT, round, round_kind, rAryData)
   {
      var roundData = {};

      var i = 0, key = "";
      for(var i = 0; i< round_kind; i++)
      {
         key = utx.strPrintf("round_{0}", i+1);
         roundData[key] = rAryData[i];
      }


      objT.draw({
         limitedStartRoundOf: 0, //16    integer(짝수)  default:0 전체, 그리기 시작할 라운드 ex)8강 부터
         limitedEndRoundOf: 0, //8       integer(짝수)  default:0 전체, 그리기 끝날 라운드 ex)4강 까지
         roundOf:round,
         data: roundData,
      });
   }

	function MakeEmptyData(rAryEmpty, empty_round, pos_info)
   {
      var i = 0;

      for(i=0; i<empty_round; i += 2)
      {
         rAryEmpty.push({
            matchNo: pos_info++,
            l_player:'', l_team:'',
            r_player:'', r_team:'',
         });
		}

		return pos_info;
   }


/* ==================================================================================
      tournament에 사용할 data object을 만든다.
   ================================================================================== */
   function fillTeamUserInfo(Idx, l_info, r_info, IsDblPlay)
   {
      var obj = {};

      // i, i+1을 합쳐서 하나의 Obj을 만들므로 기본 셋팅은 i%2=0에서 한번만
      obj.matchNo    =  Idx / 2;
      obj.bDblPlay   =  IsDblPlay;
      obj.l_fill     =  true;
      obj.l_sel      =  false;
      obj.l_dup      =  false;
      obj.r_fill     =  true;
      obj.r_sel      =  false;
      obj.r_dup      =  false;
      obj.l_pcode    = l_info[4];
      obj.r_pcode    = r_info[4];
      obj.l_spVal    =  " ";
      obj.r_spVal    =  " ";
      obj.l_firstMan    =  0;
		obj.r_firstMan    =  0;
		obj.l_order    =  0;
		obj.r_order    =  0;
		obj.round_1		= 1;

      if(l_info[0] == 1) obj.l_dup = true;
      if(r_info[0] == 1) obj.r_dup = true;

      // Bye position
      if(l_info[2] == E_POS_BYE) {
         obj.l_player   =  "BYE";
         obj.l_team     =  "";
         obj.l_pcode    = "BYE";
      }
      else if(l_info[2] == E_POS_MANUAL) {      // Manual pos
         obj.l_player   =  " ";
         obj.l_team     =  "";
         obj.l_pcode    = utx.sprintf("E_POS_MANUAL_{0}", Idx);
      }
      else if(l_info[2] == E_POS_Q) {
         obj.l_player   =  "Q";
         obj.l_team     =  utx.sprintf("({0}조)", l_info[3]);
         obj.l_pcode    = utx.sprintf("qno_{0}", l_info[3]);

         obj.l_spVal    =  utx.sprintf("Q{0}", l_info[3]);
      }
      else
      {
         if(l_info[2] == E_POS_SEED) obj.l_spVal      =  getStrSeed(l_info[3]);
         if(l_info[2] == E_POS_FIRST) obj.l_firstMan      =  1;
         obj.l_player   =  (IsDblPlay == 0)? l_info[7] : utx.sprintf("{0},{1}",l_info[7], l_info[9]);
         obj.l_team     =  (IsDblPlay == 0)? bmx.GetSimpleTeamName(l_info[9]) : utx.sprintf("{0},{1}",bmx.GetSimpleTeamName(l_info[11]), bmx.GetSimpleTeamName(l_info[13]));

         obj.l_player = bmx.GetSimpleTeamName(l_info[9]);
         obj.l_player = utx.getBlockData(obj.l_player, "", "/");
         if (l_info[6] != "" && l_info[6] != "0") obj.l_player = utx.sprintf("{0}-{1}", obj.l_player, l_info[6]);

         obj.l_team     =  "";
      }

      // Bye position
      if(r_info[2] == E_POS_BYE) {
         obj.r_player   =  "BYE";
         obj.r_team     =  "";
         obj.r_pcode    = "BYE";
      }
      else if(r_info[2] == E_POS_MANUAL) {     // Manual pos
         obj.r_player   =  " ";
         obj.r_team     =  "";
         obj.r_pcode    =  utx.sprintf("E_POS_MANUAL_{0}", Idx+1);
      }
      else if(r_info[2] == E_POS_Q) {
         obj.r_player   =  "Q";
         obj.r_team     =  utx.sprintf("({0}조)", r_info[3]);
         obj.r_pcode    = utx.sprintf("qno_{0}", r_info[3]);

         obj.r_spVal    =  utx.sprintf("Q{0}", r_info[3]);
      }
      else
      {
         if(r_info[2] == E_POS_SEED) obj.r_spVal      =  getStrSeed(l_info[3]);
         if(l_info[2] == E_POS_FIRST) obj.r_firstMan      =  1;
         obj.r_player = bmx.GetSimpleTeamName(r_info[9]);
         obj.r_player = utx.getBlockData(obj.r_player, "", "/");
         if (r_info[6] != "" && r_info[6] != "0") obj.r_player = utx.sprintf("{0}-{1}", obj.r_player, r_info[6]);

         obj.r_team     =  "";
      }
      return obj;
   }

/* ==================================================================================
      tournament에 사용할 data object을 만든다.
   ================================================================================== */
   function fillUserInfo(Idx, l_info, r_info, IsDblPlay)
   {
      var obj = {};

      // i, i+1을 합쳐서 하나의 Obj을 만들므로 기본 셋팅은 i%2=0에서 한번만
      obj.matchNo    =  Idx / 2;
      obj.bDblPlay   =  IsDblPlay;
      obj.l_fill     =  true;
      obj.l_sel      =  false;
      obj.r_fill     =  true;
      obj.r_sel      =  false;
      obj.l_pcode    = l_info[4];
      obj.r_pcode    = r_info[4];
      obj.l_spVal    =  " ";
      obj.r_spVal    =  " ";
      obj.l_firstMan    =  0;
      obj.r_firstMan    =  0;
		obj.l_order    =  (IsDblPlay == 0)? l_info[10] : l_info[14];
		obj.r_order    =  (IsDblPlay == 0)? r_info[10] : r_info[14];
		obj.round_1		= 1;

      // Bye position
      if(l_info[2] == E_POS_BYE) {
         obj.l_player   =  "BYE";
         obj.l_team     =  "";
         obj.l_pcode    = "BYE";
      }
      else if(l_info[2] == E_POS_MANUAL) {      // Manual pos
         obj.l_player   =  " ";
         obj.l_team     =  "";
         obj.l_pcode    = utx.sprintf("E_POS_MANUAL_{0}", Idx);
      }
      else if(l_info[2] == E_POS_Q) {
         obj.l_player   =  "Q";
         obj.l_team     =  utx.sprintf("({0}조)", l_info[3]);
         obj.l_pcode    = utx.sprintf("qno_{0}", l_info[3]);

         obj.l_spVal    =  utx.sprintf("Q{0}", l_info[3]);
      }
      else
      {
         if(l_info[2] == E_POS_SEED) obj.l_spVal      =  getStrSeed(l_info[3]);
         if(l_info[2] == E_POS_FIRST) obj.l_firstMan      =  1;
         obj.l_player   =  (IsDblPlay == 0)? l_info[7] : utx.sprintf("{0},{1}",l_info[7], l_info[9]);
         obj.l_team     =  (IsDblPlay == 0)? bmx.GetSimpleTeamName(l_info[9]) : utx.sprintf("{0},{1}",bmx.GetSimpleTeamName(l_info[11]), bmx.GetSimpleTeamName(l_info[13]));

         // obj.l_team     =  (IsDblPlay == 0)? l_info[9] : utx.sprintf("{0},{1}",l_info[11], l_info[13]);
      }

      // Bye position
      if(r_info[2] == E_POS_BYE) {
         obj.r_player   =  "BYE";
         obj.r_team     =  "";
         obj.r_pcode    = "BYE";
      }
      else if(r_info[2] == E_POS_MANUAL) {     // Manual pos
         obj.r_player   =  " ";
         obj.r_team     =  "";
         obj.r_pcode    =  utx.sprintf("E_POS_MANUAL_{0}", Idx+1);
      }
      else if(r_info[2] == E_POS_Q) {
         obj.r_player   =  "Q";
         obj.r_team     =  utx.sprintf("({0}조)", r_info[3]);
         obj.r_pcode    = utx.sprintf("qno_{0}", r_info[3]);

         obj.r_spVal    =  utx.sprintf("Q{0}", r_info[3]);
      }
      else
      {
         if(r_info[2] == E_POS_SEED) obj.r_spVal      =  getStrSeed(r_info[3]);
         if(r_info[2] == E_POS_FIRST) obj.r_firstMan      =  1;
         obj.r_player   =  (IsDblPlay == 0)? r_info[7] : utx.sprintf("{0},{1}",r_info[7], r_info[9]);
         // obj.r_team     =  (IsDblPlay == 0)? r_info[9] : utx.sprintf("{0},{1}",r_info[11], r_info[13]);
         obj.r_team     =  (IsDblPlay == 0)? bmx.GetSimpleTeamName(r_info[9]) : utx.sprintf("{0},{1}",bmx.GetSimpleTeamName(r_info[11]), bmx.GetSimpleTeamName(r_info[13]));
      }
      return obj;
   }



/* ==================================================================================
   make Tonament - div id를 입력받아 tonament Object을 생성하고 , 반환한다.
================================================================================== */
function makeTournamentDouble(id_div, nScale, nBlockHeight, nBoardWidth, nFirstBoardWidth)
{
  var tournament = new Tournament();
  tournament.setOption({
    blockBoardWidth: nBoardWidth, // integer board 너비
	 blockBoardWidthFirst: nFirstBoardWidth, // integer board 너비
    blockBranchWidth: 30, // integer 트리 너비
   //  blockHeight : 48, // integer 블럭 높이(board 간 간격 조절)
    blockHeight : nBlockHeight, // integer 블럭 높이(board 간 간격 조절)
    branchWidth : 1, // integer 트리 두께
    //branchColor : '#dddddd', // string 트리 컬러
    branchColor : '#888888', // string 트리 컬러
    roundOf_textSize : 14, // integer 배경 라운드 텍스트 크기
    scale : nScale, // mix decimal or 'auto' 'auto'면 화면 너비에 맞게 스케일 조정
    //scale : 0.5, // mix decimal or 'auto' 'auto'면 화면 너비에 맞게 스케일 조정
    board : true, // boolean  default:true  false면 1round 제외 board 가리기(대진추첨용)
    el:document.getElementById(id_div) // element must have id
  });

   tournament.setStyle('#'+id_div);
   $("#"+id_div).addClass("tour_double")
   tournament.boardInner = function(data){
      if(data && data.bDblPlay == 1) return boardInner_DoubleEx(data);
      return boardInner_singleEx(data);
   }
  return tournament;
}

function makeTournamentSingle(id_div, nScale, nBlockHeight, nBoardWidth, nFirstBoardWidth)
{
   var tournament = new Tournament();
   tournament.setOption({
      blockBoardWidth: nBoardWidth, // integer board 너비
	 	blockBoardWidthFirst: nFirstBoardWidth, // integer board 너비
      blockBranchWidth: 20, // integer 트리 너비
      // blockHeight : 24, // integer 블럭 높이(board 간 간격 조절)
      blockHeight : nBlockHeight, // integer 블럭 높이(board 간 간격 조절)
      branchWidth : 1, // integer 트리 두께
      //branchColor : '#dddddd', // string 트리 컬러
      branchColor : '#ccc', // string 트리 컬러
      roundOf_textSize : 14, // integer 배경 라운드 텍스트 크기
      scale : nScale, // mix decimal or 'auto' 'auto'면 화면 너비에 맞게 스케일 조정
   //   scale : 1, // mix decimal or 'auto' 'auto'면 화면 너비에 맞게 스케일 조정
      board : true, // boolean  default:true  false면 1round 제외 board 가리기(대진추첨용)
      el:document.getElementById(id_div) // element must have id
   });

   tournament.setStyle('#'+id_div);
   $("#"+id_div).addClass("tour_single")
   tournament.boardInner = function(data){
      if(data && data.bDblPlay == 1) return boardInner_DoubleEx(data);
      return boardInner_singleEx(data);
   }
  return tournament;
}


/* ==================================================================================
   data set-  tonament block - single game
   dat를 입력받아 싱글 게임일때 block을 그린다.
================================================================================== */
function boardInner_singleEx(data)
{
  sindou=0;
   var l_player, l_team;
   var r_player, r_team;
   var l_sel, r_sel;
   var l_fill, r_fill;
   var l_no, r_no;
   var l_spVal, r_spVal;
   var l_firstMan, r_firstMan;
   var l_pcode, r_pcode;
   var matchNo = 0;
   var r_param, l_param;
   var l_param_id, r_param_id;
	 var l_id, r_id;
	 var l_order, r_order;
	 var round_1 = 0;

   if(data){
		matchNo = data.matchNo;
		round_1 = data.round_1;

      l_player  = data.l_player;
      l_team    = data.l_team;
      l_spVal   = data.l_spVal;
      l_firstMan   = data.l_firstMan;
			l_pcode   = data.l_pcode;
			l_order   = data.l_order;

      r_player  = data.r_player;
      r_team    = data.r_team;
      r_spVal   = data.r_spVal;
      r_firstMan   = data.r_firstMan;
			r_pcode   = data.r_pcode;
			r_order   = data.r_order;


      l_fill = data.l_fill ? 's_filled' : '';
      r_fill = data.r_fill ? 's_filled' : '';

      l_sel = data.l_sel ? 's_selected' : '';
			r_sel = data.r_sel ? 's_selected' : '';

			if(gManualSet == 0) {		// 수동 배정이 아닐때만 보여준다.
				if(l_order != ' ') l_player = utx.sprintf("{0}-({1})", l_player, l_order);			// for test
				if(r_order != ' ') r_player = utx.sprintf("{0}-({1})", r_player, r_order);			// for test
			}

      if(l_firstMan == 1) l_player = utx.sprintf("* {0}", l_player);
      if(r_firstMan == 1) r_player = utx.sprintf("* {0}", r_player);

      // 재고.....
      l_no = (matchNo * 2) + 1;
      r_no = (matchNo * 2 + 1) + 1;

      l_id = utx.sprintf("\"pid_{0}\"", l_pcode);
      r_id = utx.sprintf("\"pid_{0}\"", r_pcode);

      l_param_id = utx.sprintf("pid_{0}", l_pcode);
      r_param_id = utx.sprintf("pid_{0}", r_pcode);

      l_param = utx.sprintf("'{0}','{1}','{2}','{3}'", l_no, l_spVal, l_pcode, l_param_id);
      r_param = utx.sprintf("'{0}','{1}','{2}','{3}'", r_no, r_spVal, r_pcode, r_param_id);
   }

	var html = '';

	if(round_1) {
    	html = [
			'<p id = '+l_id+' class="lotteryMatch lotteryMatch_first [ _match ] '+ l_sel + ' ' + l_fill + '" data-match-no="'+matchNo+'" data-player-no="'+ (matchNo * 2) +'">',
				'<span class="lotteryMatch__seedWrap"><span>'+l_no+'</span></span>',
				'<span class="lotteryMatch__playerWrap">',
					'<span class="lotteryMatch__playerInner">',
						'<span class="lotteryMatch__player [ _player1 ]">'+l_player+'</span>',
						'<span class="lotteryMatch__belong [ _belong1 ]">'+l_team+'</span>',
					'</span>',
				'</span>',
        '<span class="lotteryMatch__matchNo"><input class="cls_matchNum" type="number" id="eliteMatch_'+matchNo+'"></span>',
			'</p>',
			'<p id = '+r_id+' class="lotteryMatch lotteryMatch_second [ _match ] '+ r_sel + ' ' + r_fill + '" data-match-no="'+matchNo+'" data-player-no="'+ (matchNo * 2 + 1) +'">',
				'<span class="lotteryMatch__seedWrap"><span>'+r_no+'</span></span>',
				'<span class="lotteryMatch__playerWrap">',
					'<span class="lotteryMatch__playerInner">',
					'<span class="lotteryMatch__player [ _player1 ]">'+r_player+'</span>',
						'<span class="lotteryMatch__belong [ _belong1 ]">'+r_team+'</span>',
					'</span>',
				'</span>',
        '<span class="lotteryMatch__matchNo"></span>',
			'</p>'
		].join('');
	}
	else {
		html = [
			'<p id = '+l_id+' class="lotteryMatch lotteryMatch_first [ _match ] '+ l_sel + ' ' + l_fill + '" data-match-no="'+matchNo+'" data-player-no="'+ (matchNo * 2) +'">',
        '<span class="lotteryMatch__matchNo"><input class="cls_matchNum" type="number" id="eliteMatch_'+matchNo+'"></span>',
			'</p>',
			'<p id = '+r_id+' class="lotteryMatch lotteryMatch_second [ _match ] '+ r_sel + ' ' + r_fill + '" data-match-no="'+matchNo+'" data-player-no="'+ (matchNo * 2 + 1) +'">',
        '<span class="lotteryMatch__matchNo"></span>',
			'</p>'
		].join('');
	}

   // utx.strReplaceAll(html, "l_param", l_param);
   // utx.strReplaceAll(html, "r_param", r_param);

   // String(html).replace("l_param", l_param);
   // String(html).replace("r_param", r_param);
   return html;
}

/* ==================================================================================
   data set-  tonament block - double game
   data를 입력받아 복식 게임일때 block을 그린다.
================================================================================== */
function boardInner_DoubleEx(data)
{
  sindou=1;
   var aryl_player, aryl_team;
   var aryr_player, aryr_team;
   var l_sel, r_sel;
   var l_fill, r_fill;
   var l_no, r_no;
   var l_spVal, r_spVal;
   var l_firstMan, r_firstMan;
   var l_pcode, r_pcode;
   var matchNo = 0;
   var r_param, l_param;
   var l_id, r_id;
	var l_param_id, r_param_id;
	var l_order, r_order;
	var round_1 = 0;

   if(data){
		matchNo = data.matchNo;
		round_1 = data.round_1;

      aryl_player  = (data.l_player.indexOf(',') == -1) ? [data.l_player, ""] : data.l_player.split(',');
      aryl_team    = (data.l_team.indexOf(',') == -1)   ? [data.l_team, ""]   : data.l_team.split(',');
      aryr_player  = (data.r_player.indexOf(',') == -1) ? [data.r_player, ""] : data.r_player.split(',');
      aryr_team    = (data.r_team.indexOf(',') == -1)   ? [data.r_team, ""]   : data.r_team.split(',');

      l_spVal        = data.l_spVal;
      l_firstMan     = data.l_firstMan;
			l_pcode        = data.l_pcode;
			l_order   		 = data.l_order;

      r_spVal        = data.r_spVal;
      r_firstMan     = data.r_firstMan;
			r_pcode        = data.r_pcode;
			r_order   		 = data.r_order;

      l_fill = data.l_fill ? 's_filled' : '';
      r_fill = data.r_fill ? 's_filled' : '';

      l_sel = data.l_sel ? 's_selected' : '';
			r_sel = data.r_sel ? 's_selected' : '';

			if(gManualSet == 0) {		// 수동 배정이 아닐때만 보여준다.
				if(l_order != ' ') aryl_player[0] = utx.sprintf("{0}-({1})", aryl_player[0], l_order);			// for test
				if(r_order != ' ') aryr_player[0] = utx.sprintf("{0}-({1})", aryr_player[0], r_order);			// for test
			}

      if(l_firstMan == 1) {
            aryl_player[0] = utx.sprintf("* {0}", aryl_player[0]);
            aryl_player[1] = utx.sprintf("* {0}", aryl_player[1]);
      }
      if(r_firstMan == 1) {
            aryr_player[0] = utx.sprintf("* {0}", aryr_player[0]);
            aryr_player[1] = utx.sprintf("* {0}", aryr_player[1]);
      }

      // 재고.....
      l_no = (matchNo * 2) + 1;
      r_no = (matchNo * 2 + 1) + 1;

      l_id = utx.sprintf("\"pid_{0}\"", l_pcode);
      r_id = utx.sprintf("\"pid_{0}\"", r_pcode);

      l_param_id = utx.sprintf("pid_{0}", l_pcode);
      r_param_id = utx.sprintf("pid_{0}", r_pcode);

      l_param = utx.sprintf("'{0}','{1}','{2}','{3}'", l_no, l_spVal, l_pcode, l_param_id);
      r_param = utx.sprintf("'{0}','{1}','{2}','{3}'", r_no, r_spVal, r_pcode, r_param_id);
   }

	var html = '';
	if(round_1) {
   	html = [
			'<p id = '+l_id+' class="lotteryMatch lotteryMatch_first [ _match ] '+ l_sel + ' ' + l_fill + '" data-match-no="'+matchNo+'" data-player-no="'+ (matchNo * 2) +'">',
				'<span class="lotteryMatch__seedWrap"><span>'+l_no+'</span></span>',
				'<span class="lotteryMatch__playerWrap">',
					'<span class="lotteryMatch__playerInner">',
						'<span class="lotteryMatch__player [ _player1 ]">'+aryl_player[0]+'</span>',
						'<span class="lotteryMatch__belong [ _belong1 ]">'+aryl_team[0]+'</span>',
					'</span>',
					'<span class="lotteryMatch__playerInner">',
						'<span class="lotteryMatch__player [ _player2 ]">'+aryl_player[1]+'</span>',
						'<span class="lotteryMatch__belong [ _belong2 ]">'+aryl_team[1]+'</span>',
					'</span>',
				'</span>',
        '<span class="lotteryMatch__matchNo"><input class="cls_matchNum" type="number" id="eliteMatch_'+matchNo+'"></span>',
			'</p>',
			'<p id = '+r_id+' class="lotteryMatch lotteryMatch_second [ _match ] '+ r_sel + ' ' + r_fill + '" data-match-no="'+matchNo+'" data-player-no="'+ (matchNo * 2 + 1) +'">',
				'<span class="lotteryMatch__seedWrap"><span>'+r_no+'</span></span>',
				'<span class="lotteryMatch__playerWrap">',
					'<span class="lotteryMatch__playerInner">',
					'<span class="lotteryMatch__player [ _player1 ]">'+aryr_player[0]+'</span>',
						'<span class="lotteryMatch__belong [ _belong1 ]">'+aryr_team[0]+'</span>',
					'</span>',
					'<span class="lotteryMatch__playerInner">',
						'<span class="lotteryMatch__player [ _player2 ]">'+aryr_player[1]+'</span>',
						'<span class="lotteryMatch__belong [ _belong2 ]">'+aryr_team[1]+'</span>',
					'</span>',
				'</span>',
        '<span class="lotteryMatch__matchNo"></span>',
			'</p>'
		].join('');
	}
	else {
		html = [
			'<p id = '+l_id+' class="lotteryMatch lotteryMatch_first [ _match ] '+ l_sel + ' ' + l_fill + '" data-match-no="'+matchNo+'" data-player-no="'+ (matchNo * 2) +'">',
				'<span class="lotteryMatch__seedWrap1">'+l_spVal+'</span>',
				'<span class="lotteryMatch__seedWrap">'+l_no+'</span>',
				'<span class="lotteryMatch__playerWrap">',
					'<span class="lotteryMatch__playerInner">',
						'<span class="lotteryMatch__player [ _player1 ]">'+aryl_player[0]+'</span>',
						'<span class="lotteryMatch__belong [ _belong1 ]">'+aryl_team[0]+'</span>',
					'</span>',
					'<span class="lotteryMatch__playerInner">',
						'<span class="lotteryMatch__player [ _player2 ]">'+aryl_player[1]+'</span>',
						'<span class="lotteryMatch__belong [ _belong2 ]">'+aryl_team[1]+'</span>',
					'</span>',
				'</span>',
			'</p>',
			'<p id = '+r_id+' class="lotteryMatch lotteryMatch_second [ _match ] '+ r_sel + ' ' + r_fill + '" data-match-no="'+matchNo+'" data-player-no="'+ (matchNo * 2 + 1) +'">',
				'<span class="lotteryMatch__seedWrap1">'+r_spVal+'</span>',
				'<span class="lotteryMatch__seedWrap">'+r_no+'</span>',
				'<span class="lotteryMatch__playerWrap">',
					'<span class="lotteryMatch__playerInner">',
					'<span class="lotteryMatch__player [ _player1 ]">'+aryr_player[0]+'</span>',
						'<span class="lotteryMatch__belong [ _belong1 ]">'+aryr_team[0]+'</span>',
					'</span>',
					'<span class="lotteryMatch__playerInner">',
						'<span class="lotteryMatch__player [ _player2 ]">'+aryr_player[1]+'</span>',
						'<span class="lotteryMatch__belong [ _belong2 ]">'+aryr_team[1]+'</span>',
					'</span>',
				'</span>',
			'</p>'
		].join('');
	}

   // utx.strReplaceAll(html, "l_param", l_param);
   // utx.strReplaceAll(html, "r_param", r_param);

   // String(html).replace("l_param", l_param);
   // String(html).replace("r_param", r_param);
   return html;
}

/* ==================================================================================
      본선 Title String을 얻는다.
   ================================================================================== */
   function GetStrGInfoFinal(strGTitle, strGKind, nUserCnt)
   {
      var strInfoTitle, strInfoKind, strInfoUser;
      var strInfo = utx.sprintf("   \
        <h3>{0}</h3>    \
        <p><strong>[{1} 본선] </strong> <span>참가선수: {2}팀</span></p>  ", strGTitle, strGKind, nUserCnt);
      return strInfo;
   }

/* ==================================================================================
      aryPos에서 Bye를 뺀 Player Count를 반환한다.
   ================================================================================== */
   function GetUserCntInPos(rAryPos)
   {
      var i = 0, len = rAryPos.length, nCnt = 0;
      for(i = 0; i< len; i++)
      {
         if(rAryPos[i][2] != E_POS_BYE ) nCnt++;
      }

      return nCnt;
   }

   /* ==================================================================================
      make Tonament div - 예선전 토너먼트 생성시 사용
      container tournament obj -
   ================================================================================== */
function createDivForTonamentEx(id_parent, id_div, id_divInfo, bPageBreak)
{
   var strHtml, strInfoHtml;
   strInfoHtml = utx.strPrintf("<div id='{0}' class='tournament_info'> </div>", id_divInfo );
   if(bPageBreak == true) {
      strHtml = utx.strPrintf("<div id='{0}' class='bottom-list div_QTournament' style='page-break-after: always;'> </div>", id_div );
   }
   else {
      strHtml = utx.strPrintf("<div id='{0}' class='bottom-list div_QTournament'> </div>", id_div );
   }
   ctx.appendHtmlToDiv(id_parent, strInfoHtml);
   ctx.appendHtmlToDiv(id_parent, strHtml);
}

</script>
