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

'코드가 없으면 실행 안함
If GameTitleIDX = "" Then
	isGame = 0
Else
	'대회 정보 조회
	SQL = "SELECT " & _ 
		"SportsGb,GameTitleIDX,GameTitleName,GameYear, GameSm, GameEm,GameRcvDateS,GameRcvDateE,ViewYN,MatchYN,ViewState,hostname,titleCode,titleGrade,GameArea,sum(convert(bigint,chek_1))chek_1,sum(convert(bigint,chek_2))chek_2,sum(convert(bigint,chek_3))chek_3,sum(convert(bigint,chek_4))chek_4, summary " & _ 
		"FROM (SELECT SportsGb,GameTitleIDX,GameTitleName,GameYear,convert(date,GameS,112) GameSm,convert(date,GameE,112) GameEm,GameRcvDateS,GameRcvDateE,ViewYN,MatchYN,ViewState,hostname,titleCode,titleGrade,GameArea ,chek_1,chek_2,chek_3,chek_4, summary=CONVERT(varchar(8000),summary) FROM dbo.View_game_title_list WHERE GameTitleIDX=" & GameTitleIDX & " AND SportsGb='tennis') AS a " & _ 
		"GROUP BY a.SportsGb,a.GameTitleIDX,a.GameTitleName,a.GameYear,a.GameSm,a.GameEm,a.GameRcvDateS,a.GameRcvDateE,a.ViewYN,a.MatchYN,a.ViewState,a.hostname,a.titleCode,a.titleGrade,a.GameArea, a.summary ORDER BY GameSm "

	Set gameData = Dbcon.Execute(SQL)

	If gameData.eof Then
		isGame = 0
		GameTitleIDX = ""
		GameTitleName = ""
		summary = ""
	Else
		isGame = 1
		GameTitleIDX = gameData("GameTitleIDX")
		GameTitleName = gameData("GameTitleName")
		'summary = Replace(gameData("summary"), "&amp;", "&")
	End If
	'별도 화면 제작
	summary = "./hanabank_202210_summary.asp"
End If



%>
<html>
<head>
	<title>KATA Tennis 대회 참가신청</title>
</head>
<body>
<style>
	@import url(http://fonts.googleapis.com/earlyaccess/notosanskr.css);
	@font-face {
		font-family: "HanaCM";
		src: url('./fonts/HanaCM.woff') format('woff'),
			url('./fonts/HanaCM.woff2') format('woff2'),
			url('./fonts/HanaCM.svg#HanaCM') format('svg'),
			url('./fonts/HanaCM.eot'),
			url('./fonts/HanaCM.eot?#iefix') format('embedded-opentype'),
			url('./fonts/HanaCM.ttf') format('truetype');

		font-weight: normal;
		font-style: normal;
		font-display: swap;
	}
	html {
		margin:0;
		padding:0;
		width:100%;
		height:100%;
		overflow:hidden;
	}
	body {
		background-color: #EAEFEF;
		margin: 0;
		/* padding: 10% 5%; */
		width: 100%;
		height: 100%;
		overflow:hidden;
	}
	form {
		display: none;
	}
	.page {
		position: absolute;
		z-index: 10;
		top: 50%;
		left: 50%;
		display: flex;
		flex-direction: column;
		justify-content: space-between;
		align-items: center;
		width: 90%;
		height: 90%;
		transform: translate(-50%, -50%);
	}
	.page__head {
		display: flex;
		flex-direction: column;
		justify-content: center;
		align-items: flex-start;
		width: 100%;
		height: auto;
	}
	.page__logo {
		display: block;
		width: 36%;
		height: auto;
	}
	.page__logo > img {
		max-width: 100%;
	}
	.page__title {
		display: block;
		width: 88%;
		height: auto;
		margin-top: 1rem;
	}
	.page__title > img {
		max-width: 100%;
	}
	.page__desc {
		width: 100%;
		text-align: right;
		margin-bottom: 1.5em;
	}
	.page__reload {
		width: 5em;
		height: 5em;
		border-radius: 50%;
		background-color: #edf6f6;
		color: #188576;
		font-size: 1.2rem;
		font-weight: bold;
		border: 0;
		outline: 0;
		padding-top: 0.4rem;
		word-break: keep-all;
		-webkit-box-shadow: 3px 3px 10px 0px rgba(0,0,0,0.5); 
		box-shadow: 3px 3px 10px 0px rgba(0,0,0,0.5);
	}
	.page__button {
		width: 100%;
		height: auto;
	}
	.button__group {
		display: flex;
		flex-direction: column;
	}
	.button {
		border: 0;
		outline: 0;
		border-radius: 0.5rem;
		background-color: #ffffff;
		color: #000000;
		font-size: 1.4rem;
		font-weight: 600;
		padding: 12px 0;
		-webkit-box-shadow: 3px 3px 10px 0px rgba(0,0,0,0.5); 
		box-shadow: 3px 3px 10px 0px rgba(0,0,0,0.5);
	}
	button:disabled {
		background-color: #cccccc;
		color: #666666;
	}
	.button__group .button:nth-child(2) {
		margin: 1em 0;
	}
	.bg__group {
		position: relative;
		top: 40%;
		left: 0;
		width: 100vw;
		height: 100%;
		z-index: 0;
	}
	.bg1 {
		position: absolute;
		width: 100%;
		height: calc(100% - 3em);
		transform-origin: right top;
		transform: rotate(-18deg);
		background-color: #e8515e;
		outline: 3em solid #f4aa39;
	}
	.bg2 {
		position: absolute;
		top: -3em;
		left: 0;
		width: 300%;
		height: 300%;
		transform-origin: left top;
		transform: rotate(20deg);
		background-color: #009DA0;
	}
	.container__popup {
		position: fixed;
		top: 0;
		left: 0;
		width: 100%;
		height: 100%;
		z-index: 100;
		background-color: rgba(0, 0, 0, 0.5);
		display: flex;
		justify-content: center;
		align-items: center;
	}
	.popup {
		position: relative;
		width: 80%;
		min-width: 224px;
		height: auto;
		background-color: #ffffff;
	}
	.popup__close {
		position: absolute;
		top: 1rem;
		right: 1rem;
		width: 2rem;
		height: 2rem;
		border: 0;
		outline: 0;
		background-color: transparent;
		cursor: pointer;
		color: #ffffff;
	}
	.popup__close:after {
		display: inline-block;
		content: "\00d7";
		font-size: 3rem;
		font-family: 'times new roman';
		line-height: 0;
	}
	.popup__head {
		display: flex;
		flex-direction: column;
		justify-content: center;
		align-items: center;
		width: calc(100% - 6rem);
		height: auto;
		background-color: #008a8b;
		word-break: keep-all;
		padding: 1.4rem 3rem;
		line-height: 2.2rem;
	}
	.popup__title {
		display: block;
		width: 100%;
		height: auto;
		font-family: 'HanaCM';
		font-size: 2rem;
		font-weight: 100;
		text-align: center;
		color: #ffffff;
		margin: 0;
	}
	.popup__content {
		display: flex;
		flex-direction: column;
		justify-content: center;
		align-items: center;
		width: calc(100% - 2rem);
		height: auto;
		font-family: 'Noto Sans KR';
		font-size: 1.1rem;
		padding: 1rem;
	}
	.button__detail {
		width: auto;
		height: auto;
		font-family: 'Noto Sans KR';
		padding: 0.5rem 2.5rem;
		background-color: #f39800;
		outline: 1px solid #000000;
		margin: 1rem;
		text-decoration: none;
		color: #000000;
		word-break: keep-all;
		text-align: center;
	}
	@media(max-width: 320px) {
		.page__title {
			font-size: 1.5rem;
		}
		.page__reload {
			width: 4.6em;
			height: 4.6em;
			font-size: 0.8em;
		}
		.button {
			font-size: 1.2em;
		}
	}
	@media(min-width: 640px) {
		.popup {
			width: 550px;
		}
	}
</style>
<form method="post" name="search_frm" id="search_frm" > 
	<input  type="hidden" name="Years" id="Years" value="<%=Years %>"/> 
	<input  type="hidden" name="Months" id="Months" value="<%=Months %>"/> 
	<input  type="hidden" name="GameTitleIDX" id="GameTitleIDX" value="<%=GameTitleIDX %>"/> 
	<input  type="hidden" name="GameTitleName" id="GameTitleName" value="<%=GameTitleName %>"/>
	<input  type="hidden" name="ChekMode" id="ChekMode" value="<%=ChekMode %>"/>
</form>
<div class="bg__group">
	<div class="bg1"></div>
	<div class="bg2"></div>
</div>
<article class="page">
	<section class="page__head">
		<!--<h1 class="page__title">하나은행컵<br />KATA<br />전국 테니스대회<br />접수하기</h1>-->
		<div class="page__logo">
			<img src="./img/logo.png" alt="하나은행">
		</div>
		<div class="page__title">
			<img src="./img/title.png" alt="전국테니스대회">
		</div>
	</section>
	<section class="page__button">
		<div class="page__desc">
			<button class="page__reload" name="reload" type="button">새로고침<br />하기</button>
		</div>
		<div class="button__group">
		<% If isGame = 1 Then %>
			<button class="button button__apply" type="button" name="apply">신청하기</a>
			<button class="button button__list" type="button" name="list">신청목록</a>
			<button class="button button__summary" type="button" name="summary">요강보기</a>
		<% Else %>
			<button class="button button__apply" type="button" disabled>신청하기</a>
			<button class="button button__list" type="button" disabled>신청목록</a>
			<button class="button button__summary" type="button" disabled>요강보기</a>
		<% End If %>
		</div>
	</section>
</article>
<div class="container__popup">
	<div class="popup">
		<button class="popup__close" type="button" name="close"></button>
		<div class="popup__head">
			<p class="popup__title">2022 하나은행컵 접수요령</p>
		</div>
		<div class="popup__content">
			<p>2022 하나은행컵은 타 대회와는 다른 방식으로 참가접수가 진행됩니다.<br />세부사항을 반드시 확인하셔서 참가접수에 혼란없으시기 바랍니다.</p>
			<a href="http://www.ikata.org/board/bbs/board.php?bo_table=free&wr_id=13577" target="_blank" class="button__detail">세부사항 확인하기</a>
		</div>
	</div>
</div>

<script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
<script src="/pub/js/tennis_Request.js?ver=10" type="text/javascript"></script>
<script type="text/javascript">
	//popup close
	$('.popup__close').on('click', function() {
		$('.container__popup').hide();
	});
	//reload
	var clickEvent = (function() {
	if ('ontouchstart' in document.documentElement === true) {
		return 'touchstart';
	} else {
		return 'click';
	}
	})();
	//touch event
	const target = document.querySelectorAll('[type="button"]');
	target.forEach((el) => { 
		el. addEventListener(clickEvent,function(){
		switch(this.name) {
			case "reload":
				location.reload();
				break;
			case "apply":
				chk_frm(3, <%=GameTitleIDX %>)
				break;
			case "list":
				chk_frm(4, <%=GameTitleIDX %>)
				break;
			case "summary":
				location.href=validUrl(`<%=summary %>`);
				break;
			}
		});
	});
	//check url
	function validUrl(url) {
		var expression = /^[(http(s)?):\/\/(www\.)?a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)/gi;
		var regex = new RegExp(expression);

		url = decodeURIComponent(url);
		if (url.match(regex)) {
			return url
		} else {
			alert('잘못된 URL입니다.');
			return ''
		}
	}
	//go url
	function chk_frm(val, vsGu) {
		var sf = document.search_frm;

		if (val == "FND") {
			sf.action = "../list.asp" + ver;
		} else {
			$("#GameTitleIDX").val(vsGu);
			$("#GameTitleName").val($("#GameTitleName_" + vsGu).val());
			$("#ChekMode").val(0);

			var obja = {}; //INFO_Request; 
			obja.CMD = mx_player.CMD_PageMove;
			obja.GameTitleIDX = $("#GameTitleIDX").val();
			obja.GameTitleName = $("#GameTitleName").val();
			obja.tidx = $("#GameTitleIDX").val();
			obja.title = $("#GameTitleName").val();
			obja.Years = $("#Years").val();
			obja.Months = $("#Months").val();

			if (val == 1) {
				sf.action = "../write.asp" + ver;
				$("#ChekMode").val(0);
				obja.ChekMode = $("#ChekMode").val();
			}

			if (val == 2) {
				sf.action = "../list_repair.asp" + ver;
			}

			if (val == 3) {
				sf.action = "../write.asp" + ver;
				obja.ChekMode = $("#ChekMode").val();
				$("#ChekMode").val(0);
			}

			if (val == 4) {
				sf.action = "../info_list.asp" + ver + "&tidx=" + vsGu;
				$("#ChekMode").val(1);
				obja.ChekMode = $("#ChekMode").val();
			}

			if (val == 5) {
				sf.action = "../list_game.asp" + ver;
				$("#ChekMode").val(1);
				obja.ChekMode = $("#ChekMode").val();
			}

			if (val == 6) {
				sf.action = "../info_list.asp" + ver;
				$("#ChekMode").val(1);
				obja.Years = "";
				obja.Months = "";
				obja.GameTitleIDX = "";
				obja.GameTitleName = "";
				obja.tidx = "";
				obja.title = "";
				obja.ChekMode = $("#ChekMode").val();
			}
			localStorage.setItem('INFO_Request', JSON.stringify(obja));
		}
	sf.submit();
	}


</script>






</body>
</html>