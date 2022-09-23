<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file="../include/head.asp" -->
	<!-- #include file="../include/config.asp" -->
	<%
	  Dim path : path = request("path")

		If path = "2" Then
			url = "chuncheon/bg_chuncheon_header02.jpg"
		ElseIf path = "3" Then
			url = "chuncheon/bg_chuncheon_header03.jpg"
		ElseIf path = "4" Then
			url = "chuncheon/bg_chuncheon_header04.jpg"
		Else
			url = "chuncheon/bg_chuncheon_header01.jpg"
		End If
	%>
</head>
<body>
<div class="l">

	<!-- #include file = "../include/gnb.asp" -->

	<div class="l_header">
		<div class="m_header s_sub">
			<!-- #include file="../include/header_back.asp" -->
			<h1 class="m_header__tit">춘천 시티 투어</h1>
			<!-- #include file="../include/header_gnb.asp" -->
		</div>
	</div>
	<!-- E: sub-header -->

	<style>
		.t_bgWhite{ background-color:#fff; }
		.t_disappear{font-size:0;}

		.chuncheonHeader{}
		.chuncheonHeader>.headerImg{width:100%;}
		.chuncheonHeader>.txt{padding:13px 10px 15px 10px; background-color:#717071; font-size:12px; color:#fff; letter-spacing:-0.02em; text-align:center; line-height:17px;}
		.chuncheonHeader>.txt>.emphasis{display:inline-block; margin-bottom:5px; font-size:14px; letter-spacing:initial; line-height:100%; }

		.chuncheonContent{ margin-top:18px; padding:0 10px; border-bottom:10px solid #6fbbc3;}
		.chuncheonContent .contWrap{ border-bottom:1px dotted #6fbbc3; padding-bottom:10px; margin-top:10px;}
		.chuncheonContent .contWrap:last-child{border-bottom:0;}

		.chuncheonContent .contWrap>.contTit{color:#6fbbc3;}
		.chuncheonContent .contWrap>.contTit>.number{ display:inline-block; width:28px; height:28px; border:1px solid #6fbbc3; border-radius:50%; padding-top:6px; font-size:14px; letter-spacing:-0.08em; text-align:center; line-height:100%; font-weight:400; } .chuncheonContent .contTit>.txt{line-height:100%; font-size:14px; letter-spacing:-0.02em; padding-left:5px;}
	  .chuncheonContent .contList{margin-top:10px; padding-left:17px; font-size:12px; overflow:hidden;}

		.chuncheonContent .contList .item{width:50%; float:left; white-space:normal; word-break:break-all; }

		@media all and (orientation:landscape){
			.chuncheonContent .contList .item{width:36%; }
		}
		.chuncheonContent .contList .item:nth-of-type(2n-1){padding-right:9px;}
		.chuncheonContent .contList .item.s_reservation{padding-left:40px; min-height:44px; background:url('chuncheon/bg_chuncheon01.jpg') no-repeat left top/32px auto;}
		.chuncheonContent .contList .item.s_receipt{padding-left:40px; min-height:44px; background:url('chuncheon/bg_chuncheon02.jpg') no-repeat left top 1px/32px auto;}
		.chuncheonContent .contList .item>.itemTit{color:#6fbbc3; line-height:100%; font-weight:500;}
		.chuncheonContent .contList .item>.itemTxt{color:#3e3a39; line-height:110%; font-size:11px;}
		.chuncheonContent .contList .item>.itemTxt>.detail{font-size:10px;}
		.chuncheonContent .contList .item>.itemTxt>.emphasis{font-weight:700; margin-right:5px;}

		.chuncheonContent .contList .item.s_adult{padding-left:64px; min-height:44px; background:url('chuncheon/bg_chuncheon03.jpg') no-repeat left top/auto 42px; }
		.chuncheonContent .contList .item.s_etc{padding-left:40px;min-height:44px; background:url('chuncheon/bg_chuncheon04.jpg') no-repeat left top 2px/auto 42px; }
		.chuncheonContent .contList .itemTxt2{ display:inline-block; color:#6fbbc3; text-align:center; line-height:100%; font-size:11px; }
		.chuncheonContent .contList .itemTxt2.s_adult{width:42px;}
		.chuncheonContent .contList .itemTxt2.s_etc{width:87px;}
		.chuncheonContent .contList .itemTxt2>.emphasis{display:inline-block; margin-bottom:2px; padding:3px 0 0px 0; background-color:#6fbbc3; color:#fff; text-align:center; line-height:100%; }
		.chuncheonContent .contList .itemTxt2>.emphasis.s_adult{width:42px;}
		.chuncheonContent .contList .itemTxt2>.emphasis.s_etc{width:66px;}
		.chuncheonContent .contList .itemTxt2>.price{display:inline-block; margin-top:4px; text-indent:2px;}
		.chuncheonContent .contList .itemTxt2>.detail{display:inline-block; font-size:10px; color:#3e3a39; line-height:100%; text-indent:2px;}

		.chuncheonContent .contList .item.s_start{ padding-left:45px; min-height:74px; background:url('chuncheon/bg_chuncheon05.jpg') no-repeat left top/32px auto;}
		.chuncheonContent .contList .item.s_arrival{ padding-left:45px; min-height:74px; background:url('chuncheon/bg_chuncheon06.jpg') no-repeat left top/32px auto;}

		.chuncheonContent .tourList{ font-size:10px; padding-left:15px;}
		.chuncheonContent .toruListItem{ margin-bottom:4px; overflow:hidden;}
		.chuncheonContent .toruListItem>.day{ float:left; display:inline-block; width:30px; padding:2px 1px 0 1px; margin-right:2px; color:#fff; border-radius:2px; background-color:#6fbbc3; line-height:110%;}
		.chuncheonContent .toruListItem>.course{ display:block; width:calc(100% - 35px); float:left; line-height:120%; padding-top:1px; }

		.chuncheonContent .contWrap>.txt{font-size:10px; color:#6fbbc3; text-align:center; line-height:110%; margin-top:8px;}
		@media all and (orientation:landscape){
			.chuncheonContent .contWrap>.txt{text-align:left; margin-left:20px;}
		}
	</style>
	<div class="l_content m_scroll chuncheon t_bgWhite [ _content _scroll ]">
		<header class="chuncheonHeader">
			<img class="headerImg" src="<%=url%>" />
			<h1 class="t_disappear">춘천시티투어</h1>
			<p class="txt">
				<span class="emphasis">춘천 관광을 한방에 OK!</span><br />
				<span class="">매일 아침에 출발하는 시티투어버스를 이용하면 교통편을 몰라도 스케줄 관리도 필요 없이 버스에 몸을 맡기면 모든 걸 알아서 척척 해준다. 관람료까지 할인해주니 꿀 이득!</span>
			</p>
		</header>
		<article class="chuncheonContent">
			<div class="contWrap">
				<h2 class="contTit"><span class="number">01</span><span class="txt">이용방법</span></h2>
				<ul class="contList">
					<li class="item s_reservation">
						<span class="itemTit">사전예약</span><br />

						<% if (IPHONEYN() = "0") then %>
						<a href="http://tour.chuncheon.go.kr" class="itemTxt" target="_blank">tour.chuncheon.go.kr</a>
				    <% else %>
						<a class="itemTxt" onclick="alert('sportsdiary://urlblank=http://tour.chuncheon.go.kr');">tour.chuncheon.go.kr</a>
				    <% end if %>

					</li>
					<li class="item s_receipt">
						<span class="itemTit">현장접수</span><br />
						<p class="itemTxt">
						 <span class="emphasis">문의</span>
						 <a href="tel:033-250-4312">
							 춘천역관광안내소<br/>
							 033-250-4312
						 </a>
						</p>
					</li>
				</ul>
				<p class="txt">
					*시티투어일정은 당일 날씨 또는 현지사정에 의하여 일정이 변경될 수 있습니다.<br />
					또한 요일별로 시티투어 일정이 다르니 홈페이지 참조바랍니다.
				</p>
			</div>

			<div class="contWrap">
				<h2 class="contTit"><span class="number">02</span><span class="txt">차량이용요금</span></h2>
				<ul class="contList">
					<li class="item s_adult">
						<p class="itemTxt2 s_adult">
							<span class="emphasis s_adult">성인</span><br />
							<span class="price">6,000원</span>
						</p>
					</li>
					<li class="item s_etc">
						<p class="itemTxt2 s_etc">
							<span class="emphasis s_etc">청소년, 소인,</span><br />
							<span class="emphasis s_etc">경로, 장애인</span><br />
							<span class="price">4,000원</span><br />
							<span class="detail">(만 65세 신분증 지참)</span>
						</p>
					</li>
				</ul>
				<p class="txt">
					*중식비 별도 / 만 36개월 이하 무료 / 각 명소 입장료는 별도<br />
					*시티투어 코스 이용요금은 변경될 수 있습니다.
				</p>
			</div>

			<div class="contWrap">
				<h2 class="contTit"><span class="number">03</span><span class="txt">시티투어코스</span></h2>
				<ul class="contList">
					<li class="item s_start">
						<span class="itemTit">출발장소</span><br />
						<p class="itemTxt">
							<span>춘천역 시티투어 승차장</span><br />
							<span class="detail">(오전 10시30분 출발)</span>
						</p>
					</li>
					<li class="item s_arrival">
						<span class="itemTit">도착장소</span><br />
						<p class="itemTxt">
							<span>춘천역</span><br />
							<span class="detail">(오후 5시30분)</span>
						</p>
					</li>
				</ul>
				<ul class="tourList">
					<li class="toruListItem"> <span class="day">일요일</span><span class="course">춘천역 - 스카이워크 - 김유정문학마을 - 레일바이크 - 토이로봇관 - 장절공묘역 - 춘천역</span> </li>
					<li class="toruListItem"> <span class="day">월요일</span><span class="course">춘천역 - 소양댐 - 청평사 - 옥광산 - 스카이워크 - 소양강처녀상 - 춘천역</span> </li>
					<li class="toruListItem"> <span class="day">화요일</span><span class="course">춘천역 - 김유정문학마을 - 레일바이크 - 구곡폭포 - 춘천국립박물관 - 스카이워크 - 소양강처녀상 - 춘천역</span> </li>
					<li class="toruListItem"> <span class="day">수요일</span><span class="course">춘천역 - 물레길 - 의암호스카이워크 - 소양댐 - 옥광산 - 도립화목원 - 소양강처녀상 - 춘천역</span> </li>
					<li class="toruListItem"> <span class="day">목요일</span><span class="course">춘천역 - 김유정문학마을 - 레일바이크 - 소양댐 - 도립화목원 - 스카이워크 - 소양강처녀상 - 춘천역</span> </li>
					<li class="toruListItem"> <span class="day">금요일</span><span class="course">춘천역 - 옥광산 - 김유정문학마을 - 등선폭포 - 제이드가든 - 스카이워크 - 소양강처녀상 - 춘천역</span> </li>
					<li class="toruListItem"> <span class="day">토요일</span><span class="course">춘천역 - 소양댐 - 청평사 - 도립화목원 - 장절공묘역 - 스카이워크 - 춘천역</span> </li>
				</ul>

				<p class="txt">
					*시티투어 코스는 계절 및 기타 상황에 따라서 변경될 수 있습니다.
				</p>
			</div>

		</article>
	</div>

  <!-- #include file="../include/bottom_menu.asp" -->
  <!-- #include file= "../include/bot_config.asp" -->

</div>
</body>
</html>
