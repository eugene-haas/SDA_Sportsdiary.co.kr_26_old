<!DOCTYPE html>
<html lang="ko">
<head>
	<!-- #include file="../include/head.asp" -->
	<!-- #include file="../include/config.asp" -->

	<link rel="stylesheet" href="../css/tourney.css?20190531">
	<style type="text/css">
		.sub.tourney .tourney{overflow:inherit;padding-bottom:150px;}
	</style>
	<%
	'파라미터

	%>

	<%

	  iLIUserID = Request.Cookies("SD")("UserID")
	  iLIMemberIDX = Request.Cookies(SportsGb)("MemberIDX")
	  iLIMemberIDXd = decode(Request.Cookies(SportsGb)("MemberIDX"),0)
	  iLISportsGb = SportsGb

		LocateIDX_1 = "14"
		'LocateIDX_2 = "10"
		LocateIDX_3 = "15"

	%>

	<script src="../../webtournament/www/js/global.js"></script>
	<script src="../../SD_OS/js/tennis.js?ver=2" type="text/javascript"></script>
	<script type="text/javascript">
		var scorefreshCnt = 10;
		var scorefreshR;
		function scorefreshStart() {
			// console.log("scorefreshR 실행");
			// console.log(scorefreshCnt);

			if (scorefreshCnt > 100) {
				clearInterval(scorefreshR);
				// console.log("scorefreshR 종료");
			} else {
				if (scorefreshCnt > 1) {
					scorefreshCnt--;
					$("#scorefreshCnt").text(" " + scorefreshCnt + " 초 후 새로고침");
				} else {
					$("#scorefreshCnt").click();
				}
			}
		}

		function scorefreshClear() {
			scorefreshCnt = 999;
			clearInterval(scorefreshR);
			// console.log("scorefreshR 종료");
		}

		var score = score || {};
		score.smenu = null;
		score.gameSearch = function (tabletype) {

			//본선 정보제공은 회원제 서비스로 전환합니다.[통합회원가입:1001]
			//본선정보

			if(tabletype=='1'){
				var CHK_VALUE = CHK_JOINMEMBER();
				//if(CHK_VALUE==1001){
        //
				//	//초기화
				//	$('#scoregametable').html('');
        //
				//	if(confirm('회원정보가 필요한 서비스입니다. 로그인 또는 회원가입을 해주세요.\n로그인페이지로 이동하시겠습니까?')){
				//		$(location).attr('href','http://sdmain.sportsdiary.co.kr/sdmain/login.asp');
				//	}
				//	else{
				//		score.gameSearch("0");
				//		$('#Btn_Tournament').addClass('on');
				//		$('#Btn_ResultList').removeClass('on');
				//		return;
				//	}
				//}
				//else{
					$('#Btn_Tournament').removeClass('on');
					$('#Btn_ResultList').addClass('on');

					scorefreshClear();
					var Round_s = tabletype;

					if (tabletype >= 10000) {
						$("#H_GameType").val(1);
						tabletype = 1;
						Round_s = Round_s - 10000;
					}
					else {
						$("#H_GameType").val(tabletype);
						Round_s = "";
					}
						// $("#H_GameType").val(tabletype);

					var gameidx = localStorage.getItem("GameTitleIDX"); //경기인덱스
					var searchstr1 = $('input:radio[name="game-type"]:checked').val();
					var searchstr2 = $("#TeamGb").val();
					var searchstr3 = $("#SexLevel").val();

					if (searchstr3 == '' || searchstr3 == undefined || searchstr3 == false) {
						alert("종목을 선택해 주세요.");
						return;
					}
					else {
						var tt, sidx; //sidx 조별 인덱스
						if (typeof tabletype == "object") {
							tt = tabletype.TT; //넘겨야할 TT값 설정( 스코어 ,결과 , 운영 에서 같은 ajax api 를 사용하므로 이를 구분할 값이 필요함
							sidx = tabletype.SIDX;
							Round_s = tabletype.Round_s;
						}
						else {
							tt = tabletype;
							sidx = 0;
							Round_s = Round_s;
						}

						//백버튼적용을 위해 검색내용 저장
						var entertype = localStorage.getItem("EnterType"); //K S 카타 SD 대회 구분
						localStorage.setItem('searchinfo', [searchstr1, searchstr2, searchstr3, gameidx, tt, sidx, entertype]);
						mx.SendPacket('scoregametable', { 'CMD': mx.CMD_GAMESEARCH_app, 'IDX': gameidx, 'S1': searchstr1, 'S2': searchstr2, 'S3': searchstr3, 'TT': tt, 'SIDX': sidx , 'Round_s': Round_s, 'EnterType': entertype });
					}
				//}
			}
			else{ //예선정보는 비회원제 사용가능합니다.
				$('#Btn_Tournament').addClass('on');
				$('#Btn_ResultList').removeClass('on');

				scorefreshClear();
				var Round_s = tabletype;

				if (tabletype >= 10000) {
					$("#H_GameType").val(1);
					tabletype = 1;
					Round_s = Round_s - 10000;
				}
				else {
					$("#H_GameType").val(tabletype);
					Round_s = "";
				}
				//$("#H_GameType").val(tabletype);

				var gameidx = localStorage.getItem("GameTitleIDX"); //경기인덱스
				var searchstr1 = $('input:radio[name="game-type"]:checked').val();
				var searchstr2 = $("#TeamGb").val();
				var searchstr3 = $("#SexLevel").val();

				if (searchstr3 == '' || searchstr3 == undefined || searchstr3 == false) {
					alert("종목을 선택해 주세요.");
					return;
				}
				else {
					var tt, sidx; //sidx 조별 인덱스

					if (typeof tabletype == "object") {
						tt = tabletype.TT; //넘겨야할 TT값 설정( 스코어 ,결과 , 운영 에서 같은 ajax api 를 사용하므로 이를 구분할 값이 필요함
						sidx = tabletype.SIDX;
						Round_s = tabletype.Round_s;
					}
					else {
						tt = tabletype;
						sidx = 0;
						Round_s = Round_s;
					}

					//백버튼적용을 위해 검색내용 저장
					var entertype = localStorage.getItem("EnterType"); //K S 카타 SD 대회 구분
					localStorage.setItem('searchinfo', [searchstr1, searchstr2, searchstr3, gameidx, tt, sidx, entertype]);
					mx.SendPacket('scoregametable', { 'CMD': mx.CMD_GAMESEARCH_app, 'IDX': gameidx, 'S1': searchstr1, 'S2': searchstr2, 'S3': searchstr3, 'TT': tt, 'SIDX': sidx , 'Round_s': Round_s, 'EnterType': entertype });
				}
			}
		}

		score.showScore = function (pobj) {

			//뷰포트 크기조점 막아서 정상으로 보이도록
			var $viewport = $('head meta[name="viewport"]');
			$viewport.attr('content','width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no');

			$(".modal-header").removeClass("livescore");
			$("#modalTitle").html("상세스코어").removeClass("livescore");

			pobj.CMD = mx.CMD_ScoreBoard;
			pobj.sitegubun = localStorage.getItem("EnterType"); //K S 카타 SD 구분
			mx.SendPacket('ScoreBoard', pobj);

			//점수판
			pobj.CMD = mx.CMD_ScoreDetailBoard;

			//상세내역
			pobj.CMD = mx.CMD_ScoreDetailBoardLive;
			pobj.s2key = $("#TeamGb").val(); // '단식 복식 구분
			pobj.entertype = "A"; //    ''엘리트 E 아마추어 A


			mx.SendPacket('ScoreList', pobj);
			//영상
			// mx.SendPacket('videoBoard', pobj);
			$(".tn_modal").modal("show");

		};

		score.showScoreLive = function (pobj) {
			$(".modal-header").addClass("livescore");
			$("#modalTitle").html("LiveScore").addClass("livescore");
			//점수판
			pobj.CMD = mx.CMD_ScoreBoardLive;
			pobj.sitegubun = localStorage.getItem("EnterType"); //K S 카타 SD 구분
			mx.SendPacket('ScoreBoard', pobj);

			//상세내역
			pobj.CMD = mx.CMD_ScoreDetailBoardLive;
			pobj.s2key = $("#TeamGb").val(); // '단식 복식 구분
			pobj.entertype = "A"; //    ''엘리트 E 아마추어 A

			mx.SendPacket('ScoreList', pobj);
			$(".tn_modal").modal("show");
			scorefreshClear();
			scorefreshCnt = 10;
			scorefreshR = setInterval(scorefreshStart, 1000);

		};

		//스코어 입력전 정보 생성
		score.inputScore = function (pobj) {
			pobj.CMD = mx.CMD_FINDSCORE;
			var s1text;
			var gametitleidx = localStorage.getItem("GameTitleIDX");
			var gametitle = localStorage.getItem("GameTitleName");
			var entertype = localStorage.getItem("EnterType");
			var searchstr1 = $('input:radio[name="game-type"]:checked').val();
			if (searchstr1 == 'tn001001') {
					s1text = "개인전";
			}
			else {
					s1text = "단체전";
			}
			var searchkey2 = $("#TeamGb option:checked").val();
			var searchstr2 = $("#TeamGb option:checked").text();
			var searchkey3 = $("#SexLevel option:checked").val();
			var searchstr3 = $("#SexLevel option:checked").text();

			pobj.S1KEY = searchstr1;
			pobj.GIDX = gametitleidx;
			pobj.GTITLE = gametitle;
			pobj.S1STR = s1text;
			pobj.S2STR = searchstr2;
			pobj.S3STR = searchstr3;
			pobj.S2KEY = searchkey2;
			pobj.S3KEY = searchkey3;
			pobj.ETYPE = entertype;

			mx.SendPacket(null, pobj);
		};

		//스코어 입력전 정보 생성
		score.inputMainScore = function (pobj) {};

		score.drLevelList = function (targetid, TeamGb, lineall) {
			var obj = {};
			obj.SportsGb = localStorage.getItem("SportsGb");
			obj.GIDX = localStorage.getItem("GameTitleIDX");
			obj.BOOCD = localStorage.getItem("T_TeamGb");
			obj.EnterType = localStorage.getItem("EnterType");
			obj.TeamGb = TeamGb;
			obj.CMD = mx.CMD_TEAMCODERALLY;
			obj.LNALL = lineall;
			mx.SendPacket(targetid, obj);
		};

		score.settingSearch = function () {
			score.smenu = localStorage.getItem('smenu'); //메뉴항목 가져오기

			if (score.smenu == "" || score.smenu == undefined) { //메뉴가 구성되지 않았다면
				score.drLevelList("#SexLevel", $("#TeamGb").val(), 'setmenu');
			}
			else {
				//메뉴다시그리고######################
				if (score.smenu.split(",")[0] == 0) {//단식부
					$("#TeamGb").children("option").remove();
					if (score.smenu.split(",")[1] > 0) {//개인복식
						$("#TeamGb").append("<option value='201' selected>복식</option>");
					}
					else {
						$("#_s1menu1").hide();
					}
				}
				else {
					var teamgbval = $("#TeamGb option:selected").val();
					$("#TeamGb").children("option").remove();

					if(teamgbval = "200"){ $("#TeamGb").append("<option value='200' selected>단식</option>"); }
					else{ $("#TeamGb").append("<option value='200'>단식</option>"); }

					if(score.smenu.split(",")[1] > 0) {//개인복식
						if(teamgbval = "200"){ $("#TeamGb").append("<option value='201' selected>복식</option>"); }
						else{ $("#TeamGb").append("<option value='201'>복식</option>"); }
					}
				}

				//단체부
				if (score.smenu.split(",")[2] == 0) {
					$("#_s1menu2").hide();
				}
				//메뉴다시그리고######################

				//스코어입력페이징에서 이전페이지버튼 눌렀을시.. 기존SELECT 선택된값 선택
				if (localStorage.getItem("BackPage") == "enter-score") {
					var selectinfo = localStorage.getItem('searchinfo').split(','); //조회 저장 정보

					$("input:radio[name='game-type']:input[value='" + selectinfo[0] + "']").attr("checked", true);
					$("#TeamGb option[value=" + selectinfo[1] + "]").attr('selected', 'selected');

					score.drLevelList("#SexLevel", $("#TeamGb").val(), 'no');
					mx.SendPacket('scoregametable', { 'CMD': mx.CMD_GAMESEARCH_app, 'IDX': selectinfo[3], 'S1': selectinfo[0], 'S2': selectinfo[1], 'S3': selectinfo[2], 'TT': selectinfo[4], 'SIDX': selectinfo[5], 'Round_s': selectinfo[6], 'EnterType': selectinfo[7] })
					localStorage.setItem('BackPage', 'rgamelist');
				}
				else if(localStorage.getItem("BackPage") == "enter-score-tourn"){

					var selectinfo = localStorage.getItem('searchinfo').split(','); //조회 저장 정보

					$("input:radio[name='game-type']:input[value='" + selectinfo[0] + "']").attr("checked", true);
					$("#TeamGb option[value=" + selectinfo[1] + "]").attr('selected', 'selected');

					score.drLevelList("#SexLevel", $("#TeamGb").val(), 'no');
					mx.SendPacket('scoregametable', { 'CMD': mx.CMD_GAMESEARCH_app, 'IDX': selectinfo[3], 'S1': selectinfo[0], 'S2': selectinfo[1], 'S3': selectinfo[2], 'TT': selectinfo[4], 'SIDX': selectinfo[5], 'Round_s': selectinfo[6], 'EnterType': selectinfo[7] })
					localStorage.setItem('BackPage', 'rgamelist');

				}
				else {
					localStorage.setItem("GroupGameGb", $('input:radio[name="game-type"]:checked').val());
					localStorage.setItem('BackPage', 'rgamelist');
					score.drLevelList("#SexLevel", $("#TeamGb").val(), 'no');
				}
			}
		}


		$(document).ready(function () {
			//스코어입력 정보 삭제
			localStorage.removeItem('COURTPLAYERS');
			localStorage.removeItem('FIRSTPLAYERS');
			localStorage.removeItem('REQ');
			//스코어입력 정보 삭제

			/*선수검색 */
			$('#Btn_Tournament').click(function(){ mx.findtype= 'leg'; });
			$('#Btn_ResultList').click(function(){ mx.findtype= 'tourn'; });

			/*선수검색 */
			$('#round-res-live').on('hidden.bs.modal', function(e){ scorefreshClear(); });

			/*radio click*/
			$("input[name='game-type']").click(function(){
				localStorage.setItem("GroupGameGb", $("input[name='game-type']:checked").val());

				if($("input[name='game-type']:checked").val() == 'tn001001'){ //개인전
					//메뉴다시그리고######################
					if (score.smenu.split(",")[0] == 0) {//단식부
						$("#TeamGb").children("option").remove();
						if(score.smenu.split(",")[1] > 0) {//개인복식
							$("#TeamGb").append("<option value='201' selected>복식</option>");
						}
						else{
							$("#_s1menu1").hide();
						}
					}
					else{
						$("#TeamGb").children("option").remove();
						$("#TeamGb").append("<option value='200' selected>단식</option>");
						if(score.smenu.split(",")[1] > 0) {//개인복식
							$("#TeamGb").append("<option value='201'>복식</option>");
						}
					}
					//메뉴다시그리고######################
				}
				else {
					$('#TeamGb').children("option").remove();
					$('#TeamGb').append("<option value='202'>복식</option>");
				}

				if (score.smenu == "" || score.smenu == undefined) { //메뉴가 구성되지 않았다면
					score.drLevelList("#SexLevel", $("#TeamGb").val(), 'setmenu');
				}
				else {
					score.drLevelList("#SexLevel", $("#TeamGb").val(), 'no');
				}
			});

			$("#tourney_title").html(localStorage.getItem("GameTitleName"));
			score.settingSearch();
	});
	</script>
	<script>

		// 텍스트 검색 로직 : S
			// function DocFinder($input, $findArea, matchedClassname, highlightClassname){
			// 	this.init($input, $findArea, matchedClassname, highlightClassname);
			// }
			// DocFinder.prototype = {
			// 	init: function($input, $findArea, matchedClassname, highlightClassname){
			// 		var that = this;
			// 		this.$finder = ($input.jquery) ? $input : $($input);
			// 		this.$findArea = ($findArea.jquery) ? $findArea : $($findArea);
			// 		this.highlightClassname = highlightClassname || 'highlighted';
			// 		this.matchedClassname = matchedClassname || 'matched';
			// 		this.$matched = null;
			// 		this.highlightIndex = -1;
			// 		this.word = '';
			// 		// this.hightlightIndex = 0;
			// 	},
			// 	_hasWord : function($area, word){
			// 		var regEx = new RegExp(word.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&'), "ig");
			// 		return $area.text().match(regEx);
			// 	},
			// 	_setWord : function(word){
			// 		this.word = word;
			// 	},
			// 	_getWord : function(){
			// 		return this.word;
			// 	},
			// 	_unmapping : function($matched){
			// 		if(!$matched) return;
			// 		$matched.each(function(index, item){
			// 			var $item = $(item);
			// 			var $parent = $item.parent();
			// 			$item.replaceWith($item.html());
			//
			// 			$parent.html($parent.html());
			//
			// 		});
			// 	},
			// 	_mapping : function($area, word, classname){
			// 		var regExp = new RegExp(word.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&').replace(/&/g, '&amp;'), "ig");
			//
			// 		var textNodes = mapping($area[0], regExp, classname);
			// 		function mapping(node){
			// 			for( node=node.firstChild; node; node=node.nextSibling ){
			// 				if( node.nodeType==3 && node.textContent.trim() ){
			// 					if( node.textContent.match(regExp) ){
			//
			// 						var text = node.textContent;
			// 						var temp = document.createElement('div');
			// 						temp.innerHTML = text.replace(regExp, '<span class="'+ classname +'">' + word + '</span>');
			// 						while (temp.firstChild) {
			// 							node.parentNode.insertBefore(temp.firstChild, node);
			// 						}
			// 						node.parentNode.removeChild(node);
			// 					};
			// 				}
			// 				else{
			// 					mapping(node)
			// 				}
			// 			}
			// 		}
			// 		return $area.find('.' + classname);
			// 	},
			// 	_initHighlighting : function(index){
			// 		this.highlightIndex = -1;
			// 	},
			// 	_highlighting: function($matched, highlightIndex){
			// 		if(!this.$matched || !this.$matched.length) return;
			//
			// 		this.$matched.eq(this.highlightIndex).removeClass(this.highlightClassname).addClass(this.matchedClassname);
			// 		if((this.$matched.length - 1) == this.highlightIndex ){ this.highlightIndex = 0; }else{ this.highlightIndex += 1; }
			// 		this.$matched.eq(this.highlightIndex).removeClass(this.matchedClassname).addClass(this.highlightClassname);
			// 	},
			// 	find: function(value){
			// 		if(value == '' || value == undefined || value == null){
			// 			this._unmapping(this.$matched);
			// 			this._setWord('');
			// 			return;
			// 		}
			// 		if(!this._hasWord(this.$findArea, value)){
			// 			this._unmapping(this.$matched);
			// 			alert('검색한 내용이 존재 하지 않습니다.');
			// 		}
			// 		else if(value != this._getWord()){
			// 			this._setWord(value);
			// 			this._unmapping(this.$matched);
			// 			this.$matched = this._mapping(this.$findArea, value, this.matchedClassname);
			//
			// 			this._initHighlighting();
			// 		}
			// 		this._highlighting();
			//
			// 		return this.$matched.eq(this.highlightIndex);
			// 	},
			// }
		// 텍스트 검색 로직 : E

		$(function(){

			var finder = new DocFinder($('#playernm'), $('#scoregametable'), 'sd-matched', 'sd-highlighted');
			$('#playernm').on('keyup', function(evt){
				if(evt.keyCode == 13){
					// finder._findMatched(this.value);
					var $highlightedElem = finder.find(this.value);
					// $(document).scrollTop( $highlightedElem.position().top - 90 );
					// $(".preli-table").scrollLeft( $highlightedElem.parent().position().left);
				}
				else if(evt.keyCode == 8 || evt.keyCode == 46){
					var $highlightedElem = finder.find();
				}
			});

		});
	</script>
</head>
<body id="AppBody">
<div class="l">

  <!--<a href="#" data-target="#show-tourney-pop" data-toggle="modal" class="init_btn"></a>-->

	<!-- #include file = "../include/gnb.asp" -->

  <div class="l_header">
		<div class="m_header s_sub">
	    <!-- #include file="../include/header_back.asp" -->
	    <h1 class="m_header__tit">대진표</h1>
	    <!-- #include file="../include/header_gnb.asp" -->
		</div>

		<!-- S: main banner 01 -->
	  <%
	    imType = "1"
	    imSportsGb = "tennis"
	    imLocateIDX = LocateIDX_1

	    LSQL = "EXEC AD_View_S '" & imType & "','" & imSportsGb & "','" & imLocateIDX & "','','','','',''"
	    'response.Write "LSQL="&LSQL&"<br>"
	    'response.End

	    Set LRs = DBCon6.Execute(LSQL)
	    If Not (LRs.Eof Or LRs.Bof) Then
	  %>
	  <div class="major_banner">
	    <div class="banner banner_<%=LRs("LocateGb")%> carousel">
	  	  <div <% if LRs("TypeOutput") = "S" then %>class="bxslider"<% end if %>>
	  		<!-- #include file="../include/banner_Include.asp" -->
	  		</div>
	  	</div>
	  </div>
	  <%
	    End If
	    LRs.close
	  %>
	  <!-- E: main banner 01 -->
  </div>

	<!-- <div class="sub tourney h-fix l_content m_scroll [ _content _scroll ]"> -->

	<div class="l_content m_scroll [ _content _scroll ]">

    <!-- S: tourney-title -->
    <div class="sd_subTit s_blue01">
			<h3 id="tourney_title" class="sd_subTit__tit"></h3>
		</div>
    <!-- E: tourney-title -->

    <!-- S: tourney-sel -->
    <div class="tourney-sel">
      <ul class="clearfix">
        <li class="game-type" id="_s1menu1">
            <label>
            <label for="game-typeA" class="type-text">개인전</label>
            <span><input type="radio" name="game-type" id="game-typeA" value="tn001001" checked=""></span>
            </label>
        </li>
        <li class="game-type" id="_s1menu2" style="display: none;">
            <label>
            <label for="game-typeB" class="type-text">단체전</label>
            <input type="radio" name="game-type" id="game-typeB" value="tn001002">
            </label>
        </li>
        <li class="sel_box">
            <select id="TeamGb" onChange="score.settingSearch();" data-native-menu="false">  <option value="201" selected="">복식</option></select>
        </li>
        <li class="sel_box">
          <select name="SexLevel" id="SexLevel"  data-native-menu="false"><option value="20101002" selected="">개나리부 (구리)</option></select>
        </li>
        <li>
          <button type="button" id="search" class="btn-gray" onmousedown='score.gameSearch($("#H_GameType").val())'>조회</button>
        </li>
      </ul>
    </div>
		<!-- E: tourney-sel -->

		<!-- !@# 추가 S: 메달리스트 추가 -->
		<!-- <div class="medal-list" id="DP_Medal">
      <ul class="clearfix scroll-x" id="DP_MedalList">
				<li><span class="medal-img"></span></li>
				<li class="golden"><span class="medal"></span><span class="player">이성민</span><span class="belong">(도개고등학교)</span></li>
				<li><span class="medal-img"></span></li>
				<li class="silver"><span class="medal"></span><span class="player">김진석</span><span class="belong">(해동고등학교)</span></li>
				<li><span class="medal-img"></span></li>
				<li class="bronze"><span class="medal"></span><span class="player">김민수</span><span class="belong">(인천체육고등학교)</span></li>
				<li><span class="medal-img"></span></li>
				<li class="bronze"><span class="medal"></span><span class="player">김태윤</span><span class="belong">(보성고등학교)</span></li>
			</ul>
    </div> -->
		<!-- !@# 추가 E: 메달리스트 추가 -->

		<div class="sd_finder">
		  <label class="sd_finder__label">참가자검색</label>
		  <input type="text" id="playernm" class="sd_finder__keyword" placeholder="검색어를 입력해 주세요.">
		</div>

	  <!-- S: show-btn -->
	  <div class="show-btn">
	    <ul class="flex">
	      <li onclick='score.gameSearch("0")'><a href="#" class="tab-btn tourney-result result-search-list on" id="Btn_Tournament">예선</a></li>
	      <li onclick='score.gameSearch("1")'><a href="#" class="tab-btn result-report result-search-list" id="Btn_ResultList">본선</a></li>
		  <!-- <li onclick='alert("예선전 종료후 본선대진표 공개됩니다")'><a href="#" class="tab-btn result-report result-search-list" id="Btn_ResultList">본선</a></li>  -->
	    </ul>
	  </div>
	  <!-- E: show-btn -->


		<!-- S: tn_live_tab -->
	  <!-- <div class="tn_live_tab">

	    <div class="btn_list btn_2">
	      <ul class="flex">
	       <li>
	          <a href="./tourney.asp" class="btn btn-normal on">전체</a>
	        </li>
	        <li>
	          <a href="./live_score.asp" class="btn btn-normal btn-live-score"><span class="ic_deco live">LIVE</span>LIVE SCORE <span class="ic_deco"><i class="fa fa-wifi"></i></span></a>
	        </li>
	      </ul>
	    </div>

	  </div> -->
	  <!-- E: tn_live_tab -->


		<div class="sub tourney">

		  <!-- S: hidden-main -->
		  <input type="hidden" id="H_GameType" name="H_GameType" value="0">
			<!-- E: hidden-main -->

		  <div class="tourney-mode" id="scoregametable"></div>

		  <!-- S: tourney-list -->
		  <div class="tourney-list result-report" id ="DP_ResultReport"></div>
		  <!-- E: tourney-list -->


	    <!-- S: dir_arr -->
	   	<!--  <div class="dir_arr">
	      <div class="up_arr">
	        <i class="fa fa-arrow-circle-up" aria-hidden="true"></i>
	      </div>
	      <div class="down_arr">
	        <i class="fa fa-arrow-circle-down" aria-hidden="true"></i>
	      </div>
	      <div class="right_arr">
	        <i class="fa fa-arrow-circle-right" aria-hidden="true"></i>
	      </div>
	      <div class="left_arr">
	        <i class="fa fa-arrow-circle-left" aria-hidden="true"></i>
	      </div>
	    </div> -->
	    <!-- E: dir_arr -->

		</div>


  </div>
	<!-- E: sub sub-main -->

  <!-- S: 테니스 상세스코어 모달 -->
  <!-- #include file="../include/modal/tn_score_record.asp" -->
  <!-- E: 테니스 상세스코어 모달 -->


	<!-- #include file="../include/bottom_menu.asp" -->
  <!-- #include file= "../include/bot_config.asp" -->

</div>
</body>
</html>
<% AD_DBClose() %>
<!-- #include file="../Library/sub_config.asp" -->
