<!-- #include virtual = "/pub/header.RookieTennis.asp" -->
<%=CONST_HTMLVER%>

<head>
<!-- #include virtual = "/pub/html/RookieTennis/html.head.asp" -->


<script type="text/javascript">
<!--
      if ('addEventListener' in document) {
          document.addEventListener('DOMContentLoaded', function() {
              FastClick.attach(document.body);
          }, false);
      }

	var score =  score || {};

	score.gameSearch = function(tabletype){
		var searchstr1 = 1;
		var searchstr2 = 2;
		var searchstr3 = 3;
		localStorage.setItem('searchinfo', [searchstr1,searchstr2,searchstr3]); //현재상태 저장해두기
		mx.SendPacket('div-statresult', {'CMD':mx.CMD_GAMESEARCH,'S1':searchstr1,'S2':searchstr2,'S3':searchstr3,'TT':tabletype,'SIDX':0,'IDX':3 })	
	};
	
	score.showScore = function(){
		mx.SendPacket('round-res', {'CMD':mx.CMD_SETSCORE })			
	};

    /*--------------------$(document).ready(function()--------------------*/
    $(document).ready(function(){
		//현재 페이지정보 스토리지에 담기 백했을경우 모두 적용 ....
		score.gameSearch(21);
    });
    /*--------------------$(document).ready(function()--------------------*/

//    $(document).ajaxStart(function() {
//      apploading("AppBody", "조회 중 입니다.");
//    });
//    $(document).ajaxStop(function() {
//      $('#AppBody').oLoader('hide');
//    });
    //E:로딩바	
//-->
</script>

    

</head>
<body id="AppBody">

<!-- #include virtual = "/pub/html/RookieTennis/html.top.asp" -->

<!-- S: main -->
<div class="main container-fluid">
	<!-- #include file = "./body/statresult.body.asp" -->
</div>
 <!-- E: main -->

<!-- #include file = "./body/pop.point.asp" -->
<!-- #include file = "./body/pop.skill.asp" -->

<!-- #include virtual = "/pub/html/Rookietennis/html.footer.asp" -->	
 <script src="js/main.js"></script>
</body>
</html>










<%If a = 1 then%>

 
  </head>
  <body id="AppBody">


    <!-- S: main -->
    <div class="main container-fluid">
      <!-- S: input-select -->
      <div class="stat-select row">
        <div class="stat-type-wrap">
          <!-- S: tab-menu -->
          <div class="stat-type">
            <!-- S: tab-list -->
            <ul class="stat-list clearfix">
              <li>
                <a href="stat-winner-state.asp" class="grade-btn on"><span class="tab-img"><img src="images/tournerment/stat/icon-grade-on.png"></span><span>성적조회</span></a>
              </li>
              <!--//
              <li>
                <a href="stat-point-divide.html" class="point-btn"><span class="tab-img"><img src="images/tournerment/stat/icon-point-off.png" alt width="50" height="47"></span><span>득실점률</span></a>
              </li>
              -->
              <li>
                <a href="stat-winning-rate.html" class="medal-btn medal"><span class="tab-img"><img src="images/tournerment/stat/icon-medal-off.png"></span><span>순위</span></a>
              </li>
            </ul>
            <!-- E: tab-list -->
          </div>
        </div>
        <!-- E: tab-menu -->

        <!-- S: stat-result-menu -->
        <div class="grade-tab stat-result-menu">
          <!-- S: grade-tab -->
          <ul class="grade-list clearfix">
          <!--//
            <li>
              <a href="stat-winning-rate.html" class="result-search-list winning-rate">경기승률</a>
            </li>
          -->
            <li>
              <a href="stat-tourney-result.asp" class="result-search-list winner-state on">대진표로 보기</a>
            </li>
            <li>
              <a href="stat-result-list.asp" class="result-search-list grade-state">리스트로 보기</a>
            </li>
          </ul>
          <!-- E: stat-result-menu -->
        </div>
        <!-- E: grade-tab -->

        <!-- S: tourney -->
        <div class="tourney">
          <div class="result-content" id="DP_Medal">
            <!-- S: medal-tab -->
            <ul class="medal-tab tourney-result" id="DP_MedalList">
              <li class="team">
                  <span class="medal-img">
                    <img src="images/tournerment/tourney/champ1@3x.png" alt="1위" width="40" height="45">
                  </span>
                  <p>
                    <span class="player-name cut-clip">김영석</span>
                    <span class="belong cleafix">
                      <span class="brace-open">(</span>
                      <span class="player-school cut-ellip">서울체육고등학교</span>
                      <span class="brace-close">)</span>
                    </span>
                    <span class="player-name cut-clip">김영석</span>
                    <span class="belong clearfix">
                      <span class="brace-open">(</span>
                      <span class="player-school cut-ellip">서울체육고등학교</span>
                      <span class="brace-close">)</span>
                    </span>
                  </p>
              </li>
              <li class="team">
                 <span class="medal-img">
                  <img src="images/tournerment/tourney/champ2@3x.png" alt="2위" width="40" height="45">
                </span>
                <p>
                    <span class="player-name cut-clip">최보라</span>
                    <span class="belong cleafix">
                      <span class="brace-open">(</span>
                      <span class="player-school cut-ellip">강서어택, 강서구청</span>
                      <span class="brace-close">)</span>
                    </span>
                    <span class="player-name cut-clip">최보라</span>
                    <span class="belong clearfix">
                      <span class="brace-open">(</span>
                      <span class="player-school cut-ellip">강서어택, 강서구청</span>
                      <span class="brace-close">)</span>
                    </span>
                  </p>
              </li>
              <li class="team">
                 <span class="medal-img">
                  <img src="images/tournerment/tourney/champ3@3x.png" alt="3위" width="40" height="45">
                </span>
                <p>
                    <span class="player-name cut-clip">최보라</span>
                    <span class="belong cleafix">
                      <span class="brace-open">(</span>
                      <span class="player-school cut-ellip">강서어택, 강서구청</span>
                      <span class="brace-close">)</span>
                    </span>
                    <span class="player-name cut-clip">최보라</span>
                    <span class="belong clearfix">
                      <span class="brace-open">(</span>
                      <span class="player-school cut-ellip">강서어택, 강서구청</span>
                      <span class="brace-close">)</span>
                    </span>
                  </p>
              </li>
              <li class="team">
                 <span class="medal-img">
                  <img src="images/tournerment/tourney/champ3@3x.png" alt="3위" width="40" height="45">
                </span>
                <p>
                    <span class="player-name cut-clip">최보라</span>
                    <span class="belong cleafix">
                      <span class="brace-open">(</span>
                      <span class="player-school cut-ellip">강서어택, 강서구청</span>
                      <span class="brace-close">)</span>
                    </span>
                    <span class="player-name cut-clip">최보라</span>
                    <span class="belong clearfix">
                      <span class="brace-open">(</span>
                      <span class="player-school cut-ellip">강서어택, 강서구청</span>
                      <span class="brace-close">)</span>
                    </span>
                  </p>
              </li>
            </ul>
            <!-- E: medal-tab -->
          </div>
          <!-- S: include tourney-result -->
          <!-- #include file = './stat/tourney-result.asp' -->
          <!-- E: include tourney-result -->
        </div>
        <!-- E: tourney -->

      </div>
      <!-- E: stat-select row -->
    </div>
    <!-- E: main -->

    <!-- custom.js -->
    <script src="js/main.js"></script>
  </body>
</html>
<%End if%>