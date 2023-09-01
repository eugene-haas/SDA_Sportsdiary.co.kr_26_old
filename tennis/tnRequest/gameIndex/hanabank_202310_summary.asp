<!--#include file = "../include/config_top.asp" -->
<!--#include file = "../Library/ajax_config.asp"-->
<!-- #include virtual = "/pub/fn/fn_tennis.asp" --> 
<%
sUserAgent=Ucase(Request.ServerVariables("HTTP_USER_AGENT"))
Years     = fInject(Request("Years"))
Months     = fInject(Request("Months"))
GameTitleIDX     =  Request.QueryString("gtidx")
GameTitleName     = fInject(Request("GameTitleName"))
ChekMode     = fInject(Request("ChekMode"))
isGame = 1


If Years="" then 
	Years=year(date)
End If 

If Months = "" Then
	Months = month(date)
End If

today = Date()
%>
<html>
<head>
	<title>KATA Tennis 대회 참가신청</title>
	<link href="https://cdn.jsdelivr.net/gh/moonspam/NanumSquare@2.0/nanumsquare.css" rel="stylesheet">
</head>
<body>
<style>

	:root {
		--body_fontsize: 1.0em;
		--page_fontsize: 0.7rem;
		--page_small_fontsize: 0.6rem;
		--cell_fontsize: 0.8rem;
		--page_width: calc(100% - 26px);
		--page_padding: 10px;
		--page_border: 3px solid #158575;
		--page_lignheight: 1rem;
		--cell_padding: 5px;
	}
	html {
		margin:0;
		padding:0;
		width:100%;
		height:100%;
		font-size: 16px;
	}
	body {
		margin: 0;
		padding: 0;
		width: 100%;
		height: 100%;
		font-family: 'NanumSquare', sans-serif;
	}
	caption {
		display: none;
	}
	p, h1, h2, dt, dd {
		margin: 0;
		padding: 0;
	}
	.fbold {
		font-weight: bold;
	}
	.fsmall {
		font-size: var(--page_small_fontsize);
	}
	.page {
		display: flex;
		flex-direction: column;
		width: var(--page_width);
		min-width: 250px;
		padding: var(--page_padding);
		border: var(--page_border);
		margin: 0 auto;
		font-size: var(--page_fontsize);
		line-height: var(--page_lignheight);
		overflow: hidden;
	}
	.color-black {
		color: #000;
	}
	.color-blue {
		color: #0068b7;
	}
	.color-green {
		color: #158575;
	}
	.color-red {
		color: #e60012;
	}
	.string-narrow {
		letter-spacing: -0.02rem;
	}
	.page__head {
		margin: 40px 0 15px 0;
	}
	.page__title {
		font-size: 1.3rem;
		font-weight: bold;
		line-height:1.5rem;
		margin-bottom: 10px;
	}
	.page__subtitle {
		font-size: 1.0rem;
		font-weight: 200;
	}
	table.summary {
		width: 100%;
		border-collapse: collapse;
		outline: 2px solid #158575;
		table-layout: fixed;
		margin: 15px 0;
	}
	table.summary th, table.summary td {
		padding: var(--cell_padding);
		font-size: var(--cell_fontsize);
	}
	table.summary th {
		width: 20%;
		color: #158575;
		text-align: justify;
		line-height: 0;
	}
	table.summary th:before {
		content: "";
		display: inline-block;
		width: 100%;
	}
	table.summary th:after {
		content: "";
		display: inline-block;
		width: 100%;
	}
	table.summary td {
		width: 80%;
	}
	dl.division {
		display: flex;
		flex-direction: row;
		flex-wrap: wrap;
		width: 100%;
		margin: 15px 0 0 0;
	}
	dl.division dt {
		display: inline-block;
		width: 80%;
		height: 16px;
		text-align: left;
		white-space: wrap;
		word-break: keep-all;
		margin-bottom: 5px;
		line-height: 0.5rem;
		letter-spacing: -0.02rem;
	}
	dl.division dt span.dt__justify {
		display: inline-block;
		width: auto;
		padding-top: 0.3rem;
	}
	.dt__br {
		display: inline-block;
		font-size: var(--page_fontsize);
		line-height: 1.2rem;
	}
	dl.division dd {
		width: 90%;
	}
	dl.division dd span.string__header {
		display: inline-block;
		width: 24%;
		text-align: justify;
		line-height: 0;
	}
	dl.division dd span.string__header:before {
		content: "";
		display: inline-block;
		width: 100%;
	}
	dl.division dd span.string__header:after {
		content: "";
		display: inline-block;
		width: 100%;
	}
	dl.division dd span.string__body {
		padding-left: 5px;
		letter-spacing: -0.005rem;
	}
	.paragraph__title {
		/* font-size: 1.0rem; */
		font-weight: bold;
		margin: 10px 0 5px 0;
		padding-left: 0.9rem;
		text-indent: -0.9rem;
	}
	.paragraph__body {
		display: inline-block;
		padding-left: 10px;
		margin-bottom: 5px;
	}
	.paragraph__body:before {
		content: "-";
		display: inline-block;
		margin-left: -0.5rem;
	}
	dl.division dd p.paragraph__title:first-child {
		margin-top: 0px;
	}
	table.detail {
		width: 100%;
		border-collapse: collapse;
		border: 1px solid #000000;
		table-layout: fixed;
		margin-top: 1.5rem;
	}
	table.detail th, table.detail td {
		border: 1px solid #000000;
		padding: var(--cell_padding);
	}
	table.detail thead {
		border: none;
		background-color: #148475;
		color: #ffffff;
		font-size: 1.2rem;
		font-weight: bold;
		text-align: center;
	}
	table.detail thead td {
		border: 1px solid #148475;
		padding: 0.6rem;
		font-size: calc(var(--page_fontsize) + 0.2rem);
	}
	table.detail span.tf-indent {
		display: inline-block;
		padding-left: 1rem;
		/* text-indent: -1rem; */
	}
	table.detail span.tf-indent:before {
		content: ' \203B ';
		display: inline-block;
		margin-left: -0.7rem;
	}

	@media(min-width: 320px) {
		html {
			font-size: 18px;
		}
		.fsmall {
			--page_small_fontsize: 0.7rem;
		}
		.page {
			--page_width: calc(100% - 26px);
			--page_border: 3px solid #158575;
			--page_padding: 10px;
			--page_fontsize: 0.7rem;
			--page_lignheight: 0.9rem;
		}
		table.summary th, table.summary td {
			--cell_padding: 8px;
		}
		dl.division dt {
			width: 25%;
			height: auto;
			padding-right: 10px;
			text-align: justify;
		}
		dl.division dt span.dt__justify {
			width: 100%;
		}
		dl.division dt span.dt__justify:after {
			content: "";
			display: inline-block;
			width: 100%;
		}
		dl.division dd {
			width: calc(75% - 10px);
		}
		dl.division dd span.string__header {
			width: 27%;
		}
	}
	@media(min-width: 360px) {
		.fsmall {
			--page_small_fontsize: 0.7rem;
		}
		dl.division dt {
			width: 80px;
			height: auto;
			padding-right: 15px;
			text-align: justify;
		}
		dl.division dt span.dt__justify {
			width: 100%;
		}
		dl.division dt span.dt__justify:after {
			content: "";
			display: inline-block;
			width: 100%;
		}
		dl.division dd {
			width: calc(100% - 95px);
		}
	}
	@media(min-width: 480px) {
		html {
			font-size: 18px;
		}
		.fsmall {
			--page_small_fontsize: 0.7rem;
		}
		.page {
			--page_width: calc(100% - 36px);
			--page_border: 6px solid #158575;
			--page_padding: 12px;
			--page_fontsize: 0.9rem;
			--page_lignheight: 1.1rem;
		}
		table.summary th, table.summary td {
			--cell_padding: 8px;
		}
		dl.division dt {
			width: 25%;
			height: auto;
			padding-right: 20px;
			text-align: justify;
		}
		dl.division dt span.dt__justify {
			width: 100%;
		}
		dl.division dt span.dt__justify:after {
			content: "";
			display: inline-block;
			width: 100%;
		}
		dl.division dd {
			width: calc(75% - 20px);
		}
		dl.division dd span.string__header {
			width: 27%;
		}
		.dt__br {
			display: block;
		}
	}
	@media(min-width: 800px) {
		.page {
			--page_width: calc(100% - 36px);
			--page_border: 8px solid #158575;
			--page_padding: 10px;
			--page_fontsize: 1rem;
			--page_lignheight: 1.2rem;
		}
		dl.division dt {
			width: 20%;
			height: auto;
			padding-right: 30px;
			text-align: justify;
		}
		dl.division dd {
			width: calc(80% - 30px);
		}
	}
	@media(min-width: 1024px) {
		.page {
			--page_width: calc(100% - 82px);
			--page_border: 11px solid #158575;
			--page_padding: 30px;
			--page_fontsize: 1rem;
			--page_lignheight: 1.2rem;
		}
	}
	@media(min-width: 1280px) {
		.page {
			--page_width: 1280px;
			--page_border: 22px solid #158575;
			--page_padding: 20px;
			--page_fontsize: 1rem;
			--page_lignheight: 1.3rem;
		}
	}


</style>
<article class="page">
	<section class="page__head">
		<h1 class="page__title color-green">
			<span class="color-black">2022</span><br />
			하나은행컵 KATA TOUR 대회
		</h1>
		<h2 class="page__subtitle color-gray">
			[2022 KATA TOUR GA그룹]
		</h2>
	</section>
	<table class="summary">
		<tr>
			<th>장 소</th>
			<td>육사테니스장 / 인천송도국제테니스장외 보조경기장</td>
		</tr>
		<tr>
			<th>주 최</th>
			<td>(사)한국테니스진흥협회[KATA]</td>
		</tr>
		<tr>
			<th>주 관</th>
			<td>(사)한국테니스진흥협회[KATA]</td>
		</tr>
		<tr>
			<th>후 원</th>
			<td>하나은행</td>
		</tr>
		<tr>
			<th>시 합 구</th>
			<td>바볼랏</td>
		</tr>
	</table>
	<dl class="division">
		<dt class="color-green">
			<span class="dt__justify">부 서 별 일 정</span>
		</dt>
		<dd class="string-narrow">
			(1)  국 화 부 : 11/09(수) 09:30 송도<br />
			(2)  개나리부 : 11/11(금) 09:30 육사/송도<br />
			(3)  베테랑부 : 11/12(토) 09:00 육사<br />
			(4)  오픈부(A) : 11/12(토) 09:00 송도<br />
			(5)  신인부(A) : 11/13(일) 09:00 육사/송도<br />
			<span class="color-blue fsmall">
			*  각부 4강-결승<br />
			- 국화 / 개나리 / 베테랑 / 오픈 : 11/12(일) 육사<br />
			- 신인 : 추후공지
			</span>
		</dd>
	</dl>
	<dl class="division">
		<dt class="color-green">
			<span class="dt__justify">시 상 내 역</span>
			<span class="dt__br">(팀당)</span>
		</dt>
		<dd>
			<span class="string__header">우 승</span><span class="string__body">:  상패 및 상품교환권 240만원</span><br />
			<span class="string__header">준 우 승</span><span class="string__body">:  상패 및 상품교환권 160만원</span><br />
			<span class="string__header">공 동 3 위</span><span class="string__body">:  상패 및 상품교환권   80만원</span><br />
			<span class="string__header">8 강</span><span class="string__body">:  소정의 상품</span><br />
		</dd>
	</dl>
	<dl class="division">
		<dt class="color-green">
			<span class="dt__justify">참 가 상 품</span>
		</dt>
		<dd>
			생활용품SET
		</dd>
	</dl>
	<dl class="division">
		<dt class="color-green">
			<span class="dt__justify">신 청 방 법</span>
		</dt>
		<dd>
			<span>하나은행 모바일앱 하나원큐에서 접수 : 메뉴>고객센터>새소식</span><br />
			<span class="color-blue">※ 하나원큐 회원가입 및 로그인 필수</span>
		</dd>
	</dl>
	<dl class="division">
		<dt class="color-green">
			<span class="dt__justify">신 청 절 차</span>
			<span class="dt__br">(필독)</span>
		</dt>
		<dd>
			<p class="paragraph__title">1) 참가접수시 : 입금대기팀으로 편성 / 제한팀수 초과시 신청대기팀으로 편성</p>
			<span class="paragraph__body fsmall"> <span class="color-blue">참가신청시 선수명 입력 후 해당 선수가 나열되면 반드시 그 선수를 선택하시고 연락처, 소속클럽 등의 변경필요시 절대 신규등록하지 마시고 일단 기존 이름으로 신청한 후 선수정보변경신청(1:1문의)을 통하여 변경하시기 바랍니다.</span></span>
			<span class="paragraph__body fsmall"> 입금관련등 제반 대회정보의 수령을 위해서는 선수정보에 반드시 올바른연락처(휴대폰)가 기재되어야 합니다.</span>
			<span class="paragraph__body fsmall"> 참가신청시 설정하는 비번은 변경/취소/계좌확인시 필요하므로 기억하기 쉬운 숫자만 입력가능합니다.</span>
			<p class="paragraph__title">2) 참가비입금시 입금대기팀에서 신청완료</p>
			<span class="paragraph__body  fsmall"> 접수 후 (신청대기팀은 참가자로 전환후)<span class="color-red">24시간내 입금하셔야 신청완료되며, 미입금시 신청취소</span>됩니다.(<span class="color-red">대회일 사흘전 신청 또는 참가자로 전환시에는 3시간내에, 이틀 전부터는 즉시 입금</span>하셔야 합니다.)</span>
			<span class="paragraph__body fsmall"> 신청대기팀은 계좌가 발급되지 않아 입금하실 수 없으며, 참가자(입금대기자)로 전환시 계좌가 발급됩니다.</span>
			<p class="paragraph__title">3) 참가신청내역 변경 및 취소</p>
			<span class="paragraph__body fsmall"> <span class="color-red">신청내역에서 해당 신청건을 검색하여 참가접수시 설정한 비번을 입력하고 직접 변경 및 삭제하셔야 합니다.(참가신청변경요청게시판에 올려진 변경 및 취소요청은 반영되지 않으므로 반드시 직접 처리하시기 바랍니다.)</span></span>
			<span class="paragraph__body fsmall"> <span class="color-red">출전권의 양도로 인한 폐해를 방지하기 위하여[선수1]의 변경은 불가합니다.</span></span>
			<span class="paragraph__body fsmall"> <span class="color-blue">대회 이틀 전 부터는 취소환불이 불가능</span>하며, 이경우 문의처로 연락하셔서 상황별 조치를 받으시기 바랍니다.</span>
			<span class="paragraph__body fsmall"> 입금 후 취소시 환불은 해당 대회 종료 후 이틀 내에 정산과정에서 일괄처리 되므로 기간 경과 후에도 미환불 시에는 아래 대회운영관련 문의처로 문의하시기 바랍니다.</span>
			<p class="paragraph__title">4) 현장 접수는 예선 대진 작성 후 엔트리의 여분이 있을 경우, 랭킹포인트 등을 감안하여 제한적으로 허용됩니다.</p>
		</dd>
	</dl>
	<dl class="division">
		<dt class="color-green">
			<span class="dt__justify">참 가 비</span>
		</dt>
		<dd>
			<p class="fbold">팀당 <span class="color-red">60,000원</span>(체육발전기금 4,000원포함)<br />[현장접수시 65,000원]</p>
		</dd>
	</dl>
	<dl class="division">
		<dt class="color-green">
			<span class="dt__justify">입 금 계 좌</span>
			<span class="dt__br">(필독)</span>
		</dt>
		<dd>
			<p class="paragraph__title">1) 신청시 참가신청건별로 발급되는 팀별 고유입금계좌로 입금하시기 바랍니다.</p>
			<p class="paragraph__title">2) <span class="color-blue">신청내역을 검색하여 참가접수시 설정한 비번을 입력하면 해당팀의 입금계좌를 보실 수 있습니다.</span></p>
			<span class="paragraph__body"> 여러 대회에 참가신청을 한 경우, 입금 전 반드시 입금하고자 하는 대회의 계좌를 확인하시기 바라며, 입금 후에는 신청목록에서 신청완료표시를 확인하시면 오류입금에 의한 불이익을 방지할 수 있습니다.</span>
		</dd>
	</dl>
	<dl class="division">
		<dt class="color-green">
			<span class="dt__justify">경 기 영 상 등</span>
			<span class="fsmall dt__br">제작/사용관련</span>
		</dt>
		<dd>
			<p class="paragraph__title">1) 대회참가신청을 한 선수는 경기사진,영상 등을 제작/사용하는데 동의한 것으로 간주되며, 추가로 현장에서 동의서를 작성할 경우, 이에 협조하여야 한다.</p>
			<p class="paragraph__title">2) 제작된 경기영상 등의 소유 및 사용에 관한 모든 권리는 KATA에 귀속된다.</p>
			<span class="paragraph__body"> 여러 대회에 참가신청을 한 경우, 입금 전 반드시 입금하고자 하는 대회의 계좌를 확인하시기 바라며, 입금 후에는 신청목록에서 신청완료표시를 확인하시면 오류입금에 의한 불이익을 방지할 수 있습니다.</span>
		</dd>
	</dl>
	<dl class="division">
		<dt class="color-green">
			<span class="dt__justify">문 의 처</span>
		</dt>
		<dd>
			<p class="fbold">대회운영, 규정, 요강, 참가신청 및 입금관련<br />: 이정우 KATA사무국장(010-6390-5910)</p>
		</dd>
	</dl>
	<table class="detail">
		<caption>부서별 세부사항</caption>
		<colgroup>
			<col style="width: 20%;">
			<col style="width: 30%;">
			<col style="width: 50%;">
		<thead>
			<tr>
				<td colspan="3">부서별 세부사항</td>
			</tr>
		</thead>
		<tbody>
			<tr>
				<th rowspan="2">국화부</th>
				<td colspan="2">- KATA 규정에 준함(만25세 이상 순수 동호인)</td>
			</tr>
			<tr>
				<td>
					<span class="color-blue">* 페어요건</span><br />
					<span class="color-red fsamll">
						1) A + F<br />
						2) B(3,4회) +E<br />
						3) B(2회) + D<br />
						4) C + C<br />
					</span>
				</td>
				<td>
					<span class="color-blue">* 선수출신의 출전범위</span><br />
					<span class="color-red fsamll">
						1) 중등이하연식 : 만50세이상<br />
						2) 중등이하 : 만55세이상(+비입상자)<br />
						3) 고교이상(연식포함) : 출전불가
					</span>
				</td>
			</tr>
			<tr>
				<th>개나리부</th>
				<td colspan="2">
					- KATA 규정에 준함(만25세 이상 순수 동호인)<br />
					- 2018년 이후 KATA/KATO 외 개나리부 우승자 분리출전
				</td>
			</tr>
			<tr>
				<th rowspan="2">베테랑부</th>
				<td colspan="2">
					- KATA 규정에 준함(만50세 이상 순수 동호인)
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<span class="color-blue">* 페어요건</sapn><br />
					<span class="color-red">
					1) 고교이상 선수 출신 + 비입상자<br />
					2) 중등이하 선수 및 지도자 출신 + F등급<br />
					3) A + E등급 이하<br />
					4) B(3,4회) + D등급 이하<br />
					5) B(2회) + C등급 이하<br />
					</span>
					<br />
					<span class="color-blue">* 힙산연령</span><br />
					1) C등급 : 만105세 이상<br />
					2) A/B등급 : 만107세 이상<br />
					<span class="color-red">
					3) 비선수출신지도자 : 만110세 이상<br />
					4) 중등이하선수출신 : 만115세 이상<br />
					5) 고교이상선수출신 : 만120세 이상
					</span>
				</td>
			</tr>
			<tr>
				<th>오픈부(A)</th>
				<td colspan="2">
					- KATA 규정에 준함<br />
					- 만25세 이상 순수 동호인<br />
					<span class="color-red fsmall">선수, 지도자 출신의 출전범위 <span class="color-red">[파트너요건 : 전국대회 비우승자]</span></span><br />
					1) 만45세 이상 초등선수 및 비선수 출신 지도자<br />
					2) 만50세 이상 중등선수 출신<br />
					3) 만55세 이상 고교이상선수 출신
				</td>
			</tr>
			<tr>
				<th>신인부(A)</th>
				<td colspan="2">
					- KATA 규정에 준함<br />
					- 만25세 이상 순수 동호인<br />
					- E등급 선수간 분리출전
				</td>
			</tr>
		</tbody>
		<tfooter>
			<tr>
				<td colspan="3">
					<span class="tf-indent"> 기타 명기되지 않은 사항은 (사)한국테니스진흥협회 규정에 준함.</span><br />
					<span class="tf-indent"> 출전선수는 개인별로 생활체육 공제보험에 가입을 권장하며, 경기 중 부상시 대회본부는 일체의 책임을 지지 않음.</span><br />
					<span class="tf-indent"> <span class="color-red">요강상 공지된 4강-결승일자에 불참한 경우, 원칙적으로 시상하지 않으며, 고의우승회피의 정황으로 인정될 경우 상벌조치할 수 있음.</span></span><br />
				</td>
			</tr>
	</table>
</article>	


<script type="text/javascript">

</script>

</body>
</html>