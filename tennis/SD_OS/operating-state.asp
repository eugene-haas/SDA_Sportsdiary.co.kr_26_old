<!-- #include virtual = "/pub/header.tennis.asp" -->
<%=CONST_HTMLVER%>

<head>
<!-- #include virtual = "/pub/html/tennis/html.head.asp" -->


<script type="text/javascript">
<!--
      var onLoad=function(){
        $("#tourney_title").html(localStorage.getItem("GameTitleName"));

		//기존SELECT 선택된값 보이기
        if(localStorage.getItem("BackPage") == "rgameresultlist"){
			//나중에		
		}	  
	  };

	var score =  score || {};

	score.gameSearch = function(tabletype,key3){
		var gameidx = localStorage.getItem("GameTitleIDX"); //경기인덱스
		if (key3 !="" && key3 != undefined){
			localStorage.setItem("key3", key3); //검색키
		}
		else{
			var key3 = localStorage.getItem("key3");
		}

		var tt , sidx;
		if (typeof tabletype== "object" ){
			tt = tabletype.TT;
			sidx = tabletype.SIDX; //넘겨야할 TT값 설정( 스코어 ,결과 , 운영 에서 같은 ajax api 를 사용하므로 이를 구분할 값이 필요함
		}
		else{
			tt = tabletype;
			sidx = 0;
		}

		//백버튼적용을 위해 검색내용 저장
		//localStorage.setItem('searchinfo', [searchstr1,searchstr2,searchstr3,gameidx,tt,sidx]);
		mx.SendPacket('list_body', {'CMD':mx.CMD_GAMESEARCH,'IDX':gameidx,'S1':'','S2':'','S3':key3,'TT':tt,'SIDX':sidx });	
	};

	
	score.statusSearch = function(tabletype){
		var gameidx = localStorage.getItem("GameTitleIDX"); //대회인덱스
		var searchstr1 = $("#StatusGB").val();  //진행현황 수상현황 s01 s02
		localStorage.setItem('searchinfo', [searchstr1,tabletype]); //현재상태 저장해두기
		mx.SendPacket('statustable', {'CMD':mx.CMD_STATUSSEARCH,'S1':searchstr1,'TT':tabletype,'GIDX':gameidx }); //tabletype 0전체 기타 세부
	};
	
	score.showScore = function(pobj){
		pobj.CMD = mx.CMD_SETSCORE;
		mx.SendPacket('round-res', pobj);
	};

//-->
</script>

</head>
<body onload="onLoad()" id="AppBody">

<!-- #include virtual = "/pub/html/tennis/html.top.asp" -->

<!-- S: main -->
	<!-- #include file = "./body/operatingstate.body.asp" -->
 <!-- E: main -->

<!-- #include file = "./body/pop.point.asp" -->
<!-- #include file = "./body/pop.skill.asp" -->

<!-- #include virtual = "/pub/html/tennis/html.footer.asp" -->	
 <script src="js/main.js"></script>
</body>
</html>