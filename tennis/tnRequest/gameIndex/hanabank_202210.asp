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
		summary = Replace(gameData("summary"), "&amp;", "&")
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
		background-color: #E7FCF2;
		color: #30AA69;
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
		color: #1F9B96;
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
		background-color: #FB3081;
		outline: 3em solid #FB9630;
	}
	.bg2 {
		position: absolute;
		top: -3em;
		left: 0;
		width: 300%;
		height: 300%;
		transform-origin: left top;
		transform: rotate(20deg);
		background-color: #25DD8B;
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
</article>


<script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
<script src="/pub/js/tennis_Request.js?ver=10" type="text/javascript"></script>
<script type="text/javascript">
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