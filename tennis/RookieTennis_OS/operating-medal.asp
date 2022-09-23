<!DOCTYPE html>
<html>

  <head>
    <title>스포츠 다이어리</title>
    <meta http-equiv="Content-type" content="text/html; charset=utf-8">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="-1">

    <!-- <meta name="viewport" content="width=device-width, minimum-scale=1, initial-scale=1"> -->
    <meta name="viewport" content="width=device-width, minimum-scale=1, initial-scale=1, user-scalable=no">
    <!-- <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=yes, minimum-scale=1, maximum-scale=2"> -->

    <style>
    /* following three (cascaded) are equivalent to above three meta viewport statements */
    /* see http://www.quirksmode.org/blog/archives/2014/05/html5_dev_conf.html */
    /* see http://dev.w3.org/csswg/css-device-adapt/ */
        @-ms-viewport { width: 100vw ; min-zoom: 100% ; zoom: 100% ; }          @viewport { width: 100vw ; min-zoom: 100% zoom: 100% ; }
        @-ms-viewport { user-zoom: fixed ; min-zoom: 100% ; }                   @viewport { user-zoom: fixed ; min-zoom: 100% ; }
        /*@-ms-viewport { user-zoom: zoom ; min-zoom: 100% ; max-zoom: 200% ; }   @viewport { user-zoom: zoom ; min-zoom: 100% ; max-zoom: 200% ; }*/
    </style>

		<style>
			#calendar {
				max-width: 100%;
				margin: 0 auto;
			}
			
			.fc h2 {
				 font-size: 20px;
			}
			
			.fc-sun {
		/*	  background-color: #FF0000; */
				color: #FF0000;
			}
			.fc-sat {
				color: blue;
			}
			
		</style>
		
		
		<!-- font-awesome -->
    <link rel="stylesheet" type="text/css" href="css/library/font-awesome.min.css">
    <link rel="stylesheet" href="css/bootstrap.css">
    <link rel="stylesheet" href="css/bootstrap-theme.css">

    <link href="css/fullcalendar.css" rel="stylesheet">
    <link href="css/fullcalendar.print.css" rel="stylesheet" media="print">
    <!-- custom css -->
    <link rel="stylesheet" type="text/css" href="css/style.css">
		
		
		<script src="js/library/jquery-1.12.2.min.js"></script>
		<script src="js/jquery.oLoader.min.js"></script><!--로딩바-->
		<script type="application/javascript" src="js/fastclick.js"></script><!--클릭반응속도up-->
    <script src="js/bootstrap.js"></script>
		
		<script src="cordova.js" id="xdkJScordova_"></script>

    <script src="js/app.js"></script>           <!-- for your event code, see README and file comments for details -->
    <script src="js/init-app.js"></script>      <!-- for your init code, see README and file comments for details -->
    <script src="xdk/init-dev.js"></script>     <!-- normalizes device and document ready events, see file for details -->

		
		<script src="lib/moment.min.js"></script>

		<script src="js/fullcalendar.min.js"></script>
		<script src="js/language/ko.js"></script>

		<script src="js/global.js"></script>

    <script>
      
      if ('addEventListener' in document) {
          document.addEventListener('DOMContentLoaded', function() {
              FastClick.attach(document.body);
          }, false);
      }     
      
			/*S:--------------------$(document).ready(function()--------------------*/
      $(document).ready(function(){

			//해당대회 날짜 가져오기
			select_gamedate();

      });
			/*E:--------------------$(document).ready(function()--------------------*/

			/*S:script 시작부*/

			/*E:script 시작부*/

			//S:해당대회 날짜 가져오기
			function select_gamedate(){
				var defer = $.Deferred();

				var obj = {};

				obj.GameTitleIDX = localStorage.getItem("GameTitleIDX");
				obj.SportsGb = localStorage.getItem("SportsGb");

				var jsonData = JSON.stringify(obj);

				var events = "";

        var d = new Date();
   
        var nowyear  = d.getFullYear();
        var nowmonth = d.getMonth() + 1; // 0부터 시작하므로 1더함 더함
        var nowday   = d.getDate();
    
        if (("" + nowmonth).length == 1) { nowmonth = "0" + nowmonth; }
        if (("" + nowday).length   == 1) { nowday   = "0" + nowday;   }


				$.ajax({
					url: '/Ajax/tennis_os/Management/GameDay.ashx',
					type: 'post',
					data: jsonData,
					success: function (sdata) {

						var myArr = JSON.parse(sdata);
					
						if (myArr.length > 0)
						{
							 //대회명
							 $("#tourney_title").html(localStorage.getItem("GameTitleName"));

               for (var i = 0; i < myArr.length; i++)
               {
								 if(myArr[i].GameDay == nowyear + "-" + nowmonth + "-" + nowday)
								 {
									$("#GameDay").append("<option value='" + myArr[i].GameDay + "' selected>" + myArr[i].GameDay + "</option>");
								 }
								 	$("#GameDay").append("<option value='" + myArr[i].GameDay + "'>" + myArr[i].GameDay + "</option>");
							 }
						} 
						else
						{
							alert('해당 대회일자가 없습니다.');
							$("#GameDay").append("<option value=''>일정없음</option>");
						}

						defer.resolve(sdata);
					},
					error: function (errorText) {
						defer.reject(errorText);
					}
				});
					return defer.promise();           
			}
			//E:해당대회 날짜 가져오기

			//S:조회하기
			function list_search(){
				var defer = $.Deferred();

				var obj = {};

				obj.GameTitleIDX = localStorage.getItem("GameTitleIDX");
				obj.SportsGb = localStorage.getItem("SportsGb");
				obj.GameDay = $("#GameDay").val();

				var jsonData = JSON.stringify(obj);

				var events = "";


				$.ajax({
					url: '/Ajax/tennis_os/Result/operating-medal_list.ashx',
					type: 'post',
					data: jsonData,
					async:false,
					success: function (sdata) {

						var myArr = JSON.parse(sdata);

						var strHtml = "";
					
						if (myArr.length > 0)
						{
               for (var i = 0; i < myArr.length; i++)
               {

									var varTeamGb = myArr[i].TeamGb;
									var varGroupGameGb = myArr[i].GroupGameGb;
									var varTeamGbName = myArr[i].TeamGbName;

									strHtml += "<div class='operating-medal' >";
									strHtml += "<table class='table table-bordered table-striped operating-medal-table'>";
								  strHtml += "<caption id=''>" + varTeamGbName + "</caption>";
								  strHtml += "<thead>";
								  strHtml += "<tr>";
								  strHtml += "<th>구분</th>";
								  strHtml += "<th>대전방식</th>";
								  strHtml += "<th>소속</th>";
								  strHtml += "<th>성별</th>";
								  strHtml += "<th>체급</th>";
								  strHtml += "<th><span class='gold-medal'><img src='images/tournerment/stat/gold-medal.png' alt width='23' height='30'></span>금</th>";
								  strHtml += "<th><span class='silver-medal'><img src='images/tournerment/stat/silver-medal.png' alt width='23' height='30'></span>은</th>";
								  strHtml += "<th><span class='bronze-medal'><img src='images/tournerment/stat/bronze-medal.png' alt width='23' height='30'></span>동</th>";
								  strHtml += "<th><span class='bronze-medal'><img src='images/tournerment/stat/bronze-medal.png' alt width='23' height='30'></span>동</th>";
								  strHtml += "<th>대진보기</th>";
								  strHtml += "<th>확인</th>";
								  strHtml += "</tr>";
								  strHtml += "</thead>";
								  strHtml += "<tbody>";


									var loadListdetail = $.when(list_search_detail(varTeamGb, varGroupGameGb));  
								
									loadListdetail.done(function(sdata1) {		




										var j = 0;

										var myArr1 = JSON.parse(sdata1);



										if (myArr1.length > 0){


				
											for (var j = 0; j < myArr1.length; j++){
				
												strHtml += "<tr>";
												strHtml += "	<td>" + myArr1[j].GroupGameGbName + "</td>";
												strHtml += "	<td>" + myArr1[j].GameType + "</td>";
												strHtml += "	<td>" + myArr1[j].TeamGbName + "</td>";
												
												if (myArr1[j].Sex == "Man"){
													strHtml += "	<td class='man'>남자</td>";												
												}
												else{
													strHtml += "	<td class='man'>여자</td>";	
												}
												
												strHtml += "	<td>" + myArr1[j].LevelName + "</td>";
												strHtml += "	<td>";
												if (myArr1[j].GoldUserName != "")
												{
													strHtml += "		<p class='player'>" + myArr1[j].GoldUserName + "</p>";
													strHtml += "		<p class='school'>(" + myArr1[j].GoldSCName + ")</p>";
												}
												else{
													strHtml += "		<p class='school'>" + myArr1[j].GoldSCName + "</p>";
												}
												strHtml += "	</td>";
												strHtml += "	<td>";

												if (myArr1[j].SilverUserName != "")
												{
													strHtml += "		<p class='player'>" + myArr1[j].SilverUserName + "</p>";
													strHtml += "		<p class='school'>(" + myArr1[j].SilverSCName + ")</p>";
												}
												else{
													strHtml += "		<p class='school'>" + myArr1[j].SilverSCName + "</p>";
												}

												strHtml += "	</td>";
												strHtml += "	<td>";

												if (myArr1[j].BronzeUserName1 != "")
												{
													strHtml += "		<p class='player'>" + myArr1[j].BronzeUserName1 + "</p>";
													strHtml += "		<p class='school'>(" + myArr1[j].BronzeSCName1 + ")</p>";
												}
												else{
													strHtml += "		<p class='school'>" + myArr1[j].BronzeSCName1 + "</p>";
												}

												strHtml += "	</td>";
												strHtml += "	<td>";

												if (myArr1[j].BronzeUserName2 != "")
												{
													strHtml += "		<p class='player'>" + myArr1[j].BronzeUserName2 + "</p>";
													strHtml += "		<p class='school'>(" + myArr1[j].BronzeSCName2 + ")</p>";
												}
												else{
													strHtml += "		<p class='school'>" + myArr1[j].BronzeSCName2 + "</p>";
												}

												strHtml += "	</td>";
												strHtml += "	<td>";
												strHtml += "		<button class='btn btn-default' type='button' onclick=check_tournament('" + myArr1[j].GroupGameGb + "','" + myArr1[j].Sex + "','" + myArr1[j].Level + "','" + myArr1[j].TeamGb + "');>보기</button>";
												strHtml += "	</td>";
												strHtml += "	<td>";
												strHtml += "		<p class='medal-check'><label> <input type='checkbox' /> ";
												strHtml += "		<span>확인</span></label></p>";
												strHtml += "	</td>";
												strHtml += "</tr>";




											}
											

										}
										else{
										
										}
									});


								 strHtml += "</tbody>";
								 strHtml += "</table>";
								 strHtml += "</div>";
							 }

						} 
						else
						{
							alert('조회된 데이터가 없습니다.');
						}


						$("#list_body").html(strHtml);

						defer.resolve(sdata);
					},
					error: function (errorText) {
						defer.reject(errorText);
					}
				});
					return defer.promise();           
			}
			//E:조회하기

			//S:해당대회 날짜 가져오기
			function list_search_detail(strTeamGb, strGroupGameGb){
				var defer = $.Deferred();

				var obj = {};

				obj.GameTitleIDX = localStorage.getItem("GameTitleIDX");
				obj.SportsGb = localStorage.getItem("SportsGb");
				obj.GameDay = $("#GameDay").val();
				obj.TeamGb = strTeamGb;
				obj.GroupGameGb = strGroupGameGb;
				
				var jsonData = JSON.stringify(obj);

				var events = "";

				$.ajax({
					url: '/Ajax/tennis_os/Result/operating-medal_detail.ashx',
					type: 'post',
					data: jsonData,
					async:false,
					success: function (sdata1) {

									console.log(sdata1);

						var myArr1 = JSON.parse(sdata1);
					
						if (myArr1.length > 0)
						{
						} 
						else
						{
						}

						defer.resolve(sdata1);
					},
					error: function (errorText) {
						defer.reject(errorText);
					}
				});
					return defer.promise();           
			}
			//E:해당대회 날짜 가져오기

			//S:보기 버튼 누를 시, 해당 토너먼트 대진표로 이동
			function check_tournament(strGroupGameGb, strSex, strLevel, strTeamGb){

				localStorage.setItem("GroupGameGb", strGroupGameGb);
				localStorage.setItem("TeamGb", strTeamGb);
				localStorage.setItem("Sex", strSex);
				localStorage.setItem("Level", strLevel);

				//단체전일때 배열로 만듬
				if (localStorage.getItem("GroupGameGb") == "sd040001")
				{
					localStorage.setItem("SexLevel", strSex + "|" + strLevel);
				}
				else
				{
					localStorage.setItem("SexLevel", strSex );
				}

				localStorage.setItem("BackPage","enter-score");

				location.href = 'RgameList.html';

			}
			//E:보기 버튼 누를 시, 해당 토너먼트 대진표로 이동

			//S:로딩바
			$(document).ajaxStart(function() {

					
				apploading("AppBody", "조회 중 입니다.");


			});
			$(document).ajaxStop(function() {

							
				$('#AppBody').oLoader('hide');

			});
			//E:로딩바

		</script>
		
  </head>
  <body id="AppBody">
    <!-- S: header -->
    <div class="header container-fluid">
      <div class="row">
        <div class="pull-left">
          <a href="index.html" role="button" class="prev-btn"><span class="icon-prev"><i class="fa fa-angle-left" aria-hidden="true"></i></span><span class="prev-txt">대회별 현황보기</span></a>
        </div>
        <div>
         <h1 class="logo">
          <img src="images/tournerment/header/judo-logo@3x.png" alt="대한유도회" width="140" height="37">
        </h1>
        </div>
        <div class="pull-right">
          <span class="sd-logo"><img src="images/tournerment/header/logo@3x.png" alt="스포츠 다이어리" width="100" height="32"></span>
          <a href="index.html" role="button" class="home-link"><span class="icon-home"><i class="fa fa-home" aria-hidden="true"></i></span></a>
        </div>
      </div>
    </div>
    <!-- E: header -->
    
    <!-- S: main -->
    <div class="main main-operating container-fluid">
     <h2 class="stage-title row" id="tourney_title" class="stage-title row"><!--제16회 제주컵 유도대회--></h2>
      <!-- S: input-select -->
      <div class="input-select ent-sel row">
        <!-- S: tab-menu -->
        <div class="enter-type tab-menu">
          <ul class="clearfix">
            <li class="type-sel">
              <select id="GameDay" data-native-menu="false">
								<!--// 날짜별 선택 -->
              </select>
            </li>
            <li class="btn-list">
              <button type="button" id="search" class="btn btn-warning btn-search" onclick="list_search();">조 회</button>
            </li>
          </ul>
        </div>
        <!-- E: tab-menu -->
      </div>
      <!-- E: input-select -->
		</div>
    <!-- E: main -->

		<!-- S: operating-tab -->
		<div class="operating-tab">
			<ul class="operating-list">
				<li>
					<a href="stadium-state.html" >경기순서</a>
				</li>
				<li>
					<a href="operating-state.html">진행현황</a>
				</li>
				<li>
					<a href="operating-medal.html" class="on">수상현황</a>
				</li>
			</ul>
		</div>
		<!-- E: operating-tab -->

		<div id="list_body">
			<div class="operating-medal" >
				<table class="table table-bordered table-striped operating-medal-table">
					<caption id="">검색</caption>
					<thead>
						<tr>
							<th>구분</th>
							<th>대전방식</th>
							<th>소속</th>
							<th>성별</th>
							<th>체급</th>
							<th><span class="gold-medal"><img src="images/tournerment/stat/gold-medal.png" alt width="23" height="30"></span>금</th>
							<th><span class="silver-medal"><img src="images/tournerment/stat/silver-medal.png" alt width="23" height="30"></span>은</th>
							<th><span class="bronze-medal"><img src="images/tournerment/stat/bronze-medal.png" alt width="23" height="30"></span>동</th>
							<th><span class="bronze-medal"><img src="images/tournerment/stat/bronze-medal.png" alt width="23" height="30"></span>동</th>
							<th>대진보기</th>
							<th>확인</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td colspan="11">조회 조건을 선택 후, 조회버튼을 눌러주세요.</td>
						</tr>
					</tbody>
				</table>
			</div>
			<!--
			<div class="operating-medal" >
				<!-- S: operating-medal 개인전 ->
				
				<table class="table table-bordered table-striped operating-medal-table">
					<caption id="">중등부</caption>
					<thead>
						<tr>
							<th>구분</th>
							<th>대전방식</th>
							<th>소속</th>
							<th>성별</th>
							<th>체급</th>
							<th><span class="gold-medal"><img src="images/tournerment/stat/gold-medal.png" alt width="23" height="30"></span>금</th>
							<th><span class="silver-medal"><img src="images/tournerment/stat/silver-medal.png" alt width="23" height="30"></span>은</th>
							<th><span class="bronze-medal"><img src="images/tournerment/stat/bronze-medal.png" alt width="23" height="30"></span>동</th>
							<th><span class="bronze-medal"><img src="images/tournerment/stat/bronze-medal.png" alt width="23" height="30"></span>동</th>
							<th>대진보기</th>
							<th>확인</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>개인전</td>
							<td>토너먼트</td>
							<td>중등부</td>
							<td class="man">남자</td>
							<td>-45kg</td>
							<td>
								<p class="player">박민우</p>
								<p class="school">(야음중)</p>
							</td>
							<td>
								<p class="player">김성진</p>
								<p class="school">(창녕중)</p>
							</td>
							<td>
								<p class="player">이태호</p>
								<p class="school">(대전대성중)</p>
							</td>
							<td>
								<p class="player">이현석</p>
								<p class="school">(전북중)</p>
							</td>
							<td>
								<button class="btn btn-default" type="button">보기</button>
							</td>
							<td>
								<p class="medal-check"><label> <input type="checkbox" /> 
								<span>확인</span></label></p>
							</td>
						</tr>
						<tr>
							<td>개인전</td>
							<td>토너먼트</td>
							<td>중등부</td>
							<td class="woman">여자</td>
							<td>-45kg</td>
							<td>
								<p class="player">박민우</p>
								<p class="school">(야음중)</p>
							</td>
							<td>
								<p class="player">김성진</p>
								<p class="school">(창녕중)</p>
							</td>
							<td>
								<p class="player">이태호</p>
								<p class="school">(대전대성중)</p>
							</td>
							<td>
								<p class="player">이현석</p>
								<p class="school">(전북중)</p>
							</td>
							<td>
								<button class="btn btn-default" type="button">보기</button>
							</td>
							<td>
								<p class="medal-check"><label> <input type="checkbox" /> 
								<span>확인</span></label></p>
							</td>
						</tr>
					</tbody>
				</table>
				
				<!-- E: operating-medal 개인전 ->
				<!-- S: operating-medal 단체전 ->
				
				<table class="table table-bordered table-striped operating-medal-table">
					<caption id="" class="hidden">중등부</caption>
					<thead class="hidden">
						<tr>
							<th>구분</th>
							<th>대전방식</th>
							<th>소속</th>
							<th>성별</th>
							<th>체급</th>
							<th><span class="gold-medal"><img src="images/tournerment/stat/gold-medal.png" alt width="23" height="30"></span>금</th>
							<th><span class="silver-medal"><img src="images/tournerment/stat/silver-medal.png" alt width="23" height="30"></span>은</th>
							<th><span class="bronze-medal"><img src="images/tournerment/stat/bronze-medal.png" alt width="23" height="30"></span>동</th>
							<th><span class="bronze-medal"><img src="images/tournerment/stat/bronze-medal.png" alt width="23" height="30"></span>동</th>
							<th>대진보기</th>
							<th>확인</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>단체전</td>
							<td>토너먼트</td>
							<td>중등부</td>
							<td class="man">남자</td>
							<td>-45kg</td>
							<td>
								<p class="player">박민우</p>
								<p class="school">(야음중)</p>
							</td>
							<td>
								<p class="player">김성진</p>
								<p class="school">(창녕중)</p>
							</td>
							<td>
								<p class="player">이태호</p>
								<p class="school">(대전대성중)</p>
							</td>
							<td>
								<p class="player">이현석</p>
								<p class="school">(전북중)</p>
							</td>
							<td>
								<button class="btn btn-default" type="button">보기</button>
							</td>
							<td>
								<p class="medal-check"><label> <input type="checkbox" /> 
								<span>확인</span></label></p>
							</td>
						</tr>
						<tr>
							<td>단체전</td>
							<td>토너먼트</td>
							<td>중등부</td>
							<td class="woman">여자</td>
							<td>-45kg</td>
							<td>
								<p class="player">박민우</p>
								<p class="school">(야음중)</p>
							</td>
							<td>
								<p class="player">김성진</p>
								<p class="school">(창녕중)</p>
							</td>
							<td>
								<p class="player">이태호</p>
								<p class="school">(대전대성중)</p>
							</td>
							<td>
								<p class="player">이현석</p>
								<p class="school">(전북중)</p>
							</td>
							<td>
								<button class="btn btn-default" type="button">보기</button>
							</td>
							<td>
								<p class="medal-check"><label> <input type="checkbox" /> 
								<span>확인</span></label></p>
							</td>
						</tr>
					</tbody>
				</table>
				
				<!-- E: operating-medal 단체전 ->
			</div>
				-->
		</div>
		<!--
		<div class="operating-medal">
			<!-- S: operating-medal 개인전 ->
			<table class="table table-bordered table-striped operating-medal-table">
				<caption id="">고등부</caption>
				<thead>
					<tr>
						<th>구분</th>
						<th>대전방식</th>
						<th>소속</th>
						<th>성별</th>
						<th>체급</th>
						<th><span class="gold-medal"><img src="images/tournerment/stat/gold-medal.png" alt width="23" height="30"></span>금</th>
						<th><span class="silver-medal"><img src="images/tournerment/stat/silver-medal.png" alt width="23" height="30"></span>은</th>
						<th><span class="bronze-medal"><img src="images/tournerment/stat/bronze-medal.png" alt width="23" height="30"></span>동</th>
						<th><span class="bronze-medal"><img src="images/tournerment/stat/bronze-medal.png" alt width="23" height="30"></span>동</th>
						<th>대진보기</th>
						<th>확인</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>개인전</td>
						<td>토너먼트</td>
						<td>고등부</td>
						<td class="man">남자</td>
						<td>-45kg</td>
						<td>
							<p class="player">박민우</p>
							<p class="school">(야음중)</p>
						</td>
						<td>
							<p class="player">김성진</p>
							<p class="school">(창녕중)</p>
						</td>
						<td>
							<p class="player">이태호</p>
							<p class="school">(대전대성중)</p>
						</td>
						<td>
							<p class="player">이현석</p>
							<p class="school">(전북중)</p>
						</td>
						<td>
							<button class="btn btn-default" type="button">보기</button>
						</td>
						<td>
							<p class="medal-check"><label> <input type="checkbox" /> 
							<span>확인</span></label></p>
						</td>
					</tr>
					<tr>
						<td>개인전</td>
						<td>토너먼트</td>
						<td>고등부</td>
						<td class="woman">여자</td>
						<td>-45kg</td>
						<td>
							<p class="player">박민우</p>
							<p class="school">(야음중)</p>
						</td>
						<td>
							<p class="player">김성진</p>
							<p class="school">(창녕중)</p>
						</td>
						<td>
							<p class="player">이태호</p>
							<p class="school">(대전대성중)</p>
						</td>
						<td>
							<p class="player">이현석</p>
							<p class="school">(전북중)</p>
						</td>
						<td>
							<button class="btn btn-default" type="button">보기</button>
						</td>
						<td>
							<p class="medal-check"><label> <input type="checkbox" /> 
							<span>확인</span></label></p>
						</td>
					</tr>
				</tbody>
			</table>
			<!-- E: operating-medal 개인전 ->
			<!-- S: operating-medal 단체전 ->
			<table class="table table-bordered table-striped operating-medal-table">
				<caption id="" class="hidden">중등부</caption>
				<thead class="hidden">
					<tr>
						<th>구분</th>
						<th>대전방식</th>
						<th>소속</th>
						<th>성별</th>
						<th>체급</th>
						<th><span class="gold-medal"><img src="images/tournerment/stat/gold-medal.png" alt width="23" height="30"></span>금</th>
						<th><span class="silver-medal"><img src="images/tournerment/stat/silver-medal.png" alt width="23" height="30"></span>은</th>
						<th><span class="bronze-medal"><img src="images/tournerment/stat/bronze-medal.png" alt width="23" height="30"></span>동</th>
						<th><span class="bronze-medal"><img src="images/tournerment/stat/bronze-medal.png" alt width="23" height="30"></span>동</th>
						<th>대진보기</th>
						<th>확인</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>단체전</td>
						<td>토너먼트</td>
						<td>고등부</td>
						<td class="man">남자</td>
						<td>-45kg</td>
						<td>
							<p class="player">박민우</p>
							<p class="school">(야음중)</p>
						</td>
						<td>
							<p class="player">김성진</p>
							<p class="school">(창녕중)</p>
						</td>
						<td>
							<p class="player">이태호</p>
							<p class="school">(대전대성중)</p>
						</td>
						<td>
							<p class="player">이현석</p>
							<p class="school">(전북중)</p>
						</td>
						<td>
							<button class="btn btn-default" type="button">보기</button>
						</td>
						<td>
							<p class="medal-check"><label> <input type="checkbox" /> 
							<span>확인</span></label></p>
						</td>
					</tr>
					<tr>
						<td>단체전</td>
						<td>토너먼트</td>
						<td>고등부</td>
						<td class="woman">여자</td>
						<td>-45kg</td>
						<td>
							<p class="player">박민우</p>
							<p class="school">(야음중)</p>
						</td>
						<td>
							<p class="player">김성진</p>
							<p class="school">(창녕중)</p>
						</td>
						<td>
							<p class="player">이태호</p>
							<p class="school">(대전대성중)</p>
						</td>
						<td>
							<p class="player">이현석</p>
							<p class="school">(전북중)</p>
						</td>
						<td>
							<button class="btn btn-default" type="button">보기</button>
						</td>
						<td>
							<p class="medal-check"><label> <input type="checkbox" /> 
							<span>확인</span></label></p>
						</td>
					</tr>
				</tbody>
			</table>
			<!-- E: operating-medal 단체전 ->
		</div>
		-->


    <!-- custom.js -->
    <script src="js/main.js"></script>
  </body>
</html>