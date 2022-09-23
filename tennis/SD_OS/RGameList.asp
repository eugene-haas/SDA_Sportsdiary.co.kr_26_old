<!-- #include virtual = "/pub/header.tennis.asp" -->
<%=CONST_HTMLVER%>

<head>
<!-- #include virtual = "/pub/html/tennis/html.head.asp" -->
<script type="text/javascript">
<!--
      if ('addEventListener' in document) {
          document.addEventListener('DOMContentLoaded', function() {
              FastClick.attach(document.body);
          }, false);
      }     
 	
	var score =  score || {};
	score.smenu = null;
	score.gameSearch = function (tabletype) {
	    var Round_s = tabletype;
	    if (tabletype >= 10000) {
	        tabletype = 1;
	        Round_s = Round_s - 10000;
	    } else {
	        Round_s = "";
	    }

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
	        localStorage.setItem('searchinfo', [searchstr1, searchstr2, searchstr3, gameidx, tt, sidx, Round_s]);
	        mx.SendPacket('scoregametable', { 'CMD': mx.CMD_GAMESEARCH, 'IDX': gameidx, 'S1': searchstr1, 'S2': searchstr2, 'S3': searchstr3, 'TT': tt, 'SIDX': sidx, 'Round_s': Round_s });
	    }
	};
	
	score.showScore = function(pobj){
		pobj.CMD = mx.CMD_SETSCORE;
		mx.SendPacket('round-res', pobj);
	};

	//스코어 입력전 정보 생성
	score.inputScore = function(pobj){
		pobj.CMD = mx.CMD_FINDSCORE;
		var s1text;
		var gametitleidx = localStorage.getItem("GameTitleIDX");
		var gametitle = localStorage.getItem("GameTitleName");
		var entertype =   localStorage.getItem("EnterType");
		var searchstr1 = $('input:radio[name="game-type"]:checked').val();
		if (searchstr1 == 'tn001001'){
			s1text = "개인전";
		}
		else{
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
	score.inputMainScore = function(pobj){
		pobj.CMD = mx.CMD_FINDMAINSCORE;
		var s1text;
		var gametitleidx = localStorage.getItem("GameTitleIDX");
		var gametitle = localStorage.getItem("GameTitleName");
		var entertype =   localStorage.getItem("EnterType");
		var searchstr1 = $('input:radio[name="game-type"]:checked').val();
		if (searchstr1 == 'tn001001'){
			s1text = "개인전";
		}
		else{
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


     score.drLevelList = function(targetid,TeamGb, lineall) {
	    var obj = {};
		obj.SportsGb = localStorage.getItem("SportsGb");
		obj.GIDX = localStorage.getItem("GameTitleIDX");
		obj.TeamGb = TeamGb;
		obj.CMD = mx.CMD_TEAMCODERALLY;
		obj.LNALL = lineall;
		mx.SendPacket(targetid, obj);
	 };

     score.settingSearch = function() {
		score.smenu = localStorage.getItem('smenu'); //메뉴항목 가져오기

		if (score.smenu == "" || score.smenu == undefined){ //메뉴가 구성되지 않았다면
				score.drLevelList("#SexLevel", $("#TeamGb").val() ,'setmenu');
		}
		else{
				//메뉴다시그리고######################
				if( score.smenu.split(",")[0] == 0){//단식부
					$("#TeamGb").children("option").remove();
					if( score.smenu.split(",")[1] > 0){//개인복식
						$("#TeamGb").append("<option value='201' selected>복식</option>");
					}
					else{
						$("#_s1menu1").hide();
					}
				}
				else{
					var teamgbval =  $("#TeamGb option:selected").val();
					$("#TeamGb").children("option").remove();
					
					if (teamgbval = "200")	{
						$("#TeamGb").append("<option value='200' selected>단식</option>");
					}
					else{
						$("#TeamGb").append("<option value='200'>단식</option>");					
					}

					if( score.smenu.split(",")[1] > 0){//개인복식
						if (teamgbval = "200")	{						
							$("#TeamGb").append("<option value='201' selected>복식</option>");
						}
						else{
							$("#TeamGb").append("<option value='201'>복식</option>");
						}
					}
				}
				if( score.smenu.split(",")[2] == 0){//단체부
					$("#_s1menu2").hide();
				}				
				//메뉴다시그리고######################
				
				//스코어입력페이징에서 이전페이지버튼 눌렀을시.. 기존SELECT 선택된값 선택
				if(localStorage.getItem("BackPage") == "enter-score"){
					var selectinfo = localStorage.getItem('searchinfo').split(','); //조회 저장 정보

					$("input:radio[name='game-type']:input[value='"+ selectinfo[0] +"']").attr("checked",true);
					$("#TeamGb option[value=" + selectinfo[1]+ "]").attr('selected','selected');

					score.drLevelList("#SexLevel", $("#TeamGb").val(), 'no');
					mx.SendPacket('scoregametable', {'CMD':mx.CMD_GAMESEARCH,'IDX':selectinfo[3],'S1':selectinfo[0],'S2':selectinfo[1],'S3':selectinfo[2],'TT':selectinfo[4],'SIDX':selectinfo[5] })
					localStorage.setItem('BackPage','rgamelist');
				}
				else if(localStorage.getItem("BackPage") == "enter-score-tourn"){



					var selectinfo = localStorage.getItem('searchinfo').split(','); //조회 저장 정보

					$("input:radio[name='game-type']:input[value='"+ selectinfo[0] +"']").attr("checked",true);
					$("#TeamGb option[value=" + selectinfo[1]+ "]").attr('selected','selected');

					score.drLevelList("#SexLevel", $("#TeamGb").val(), 'no');
					mx.SendPacket('scoregametable', {'CMD':mx.CMD_GAMESEARCH,'IDX':selectinfo[3],'S1':selectinfo[0],'S2':selectinfo[1],'S3':selectinfo[2],'TT':selectinfo[4],'SIDX':selectinfo[5] })
					localStorage.setItem('BackPage','rgamelist');



				}
				else{
					localStorage.setItem("GroupGameGb",$('input:radio[name="game-type"]:checked').val());
					localStorage.setItem('BackPage','rgamelist');
					score.drLevelList("#SexLevel", $("#TeamGb").val() ,'no');
				}
		}
	  };

      function onDeviceReady() {
        document.addEventListener("backbutton", onBackKey, false);
      }
      function onBackKey() {
        var userAgent = navigator.userAgent || navigator.vendor || window.opera;
        if (userAgent.match(/iPad/i) || userAgent.match(/iPhone/i) || userAgent.match(/iPod/i)) {
          location.href="Calendar.asp"; // IOS DEVICE
        } else if (userAgent.match(/Android/i)) {
          location.href="Calendar.asp"; // ANDROID DEVICE
        } else {
          location.href="Calendar.asp";  // EVERY OTHER DEVICE
        }
      }
      

      $(document).ready(function()
      {
       //스코어입력 정보 삭제
		localStorage.removeItem('COURTPLAYERS');
		localStorage.removeItem('FIRSTPLAYERS');
		localStorage.removeItem('REQ');
       //스코어입력 정보 삭제
		//localStorage.removeItem('smenu'); //메뉴정보삭제 -다른대회로 접속시


        if (localStorage.getItem("IntroIndex") == "3"){
          $("#DP_Title_Left").html("경기운영본부");
        }
        else if(localStorage.getItem("IntroIndex") == "2"){
          $("#DP_Title_Left").html("대회별 결과 보기");
        }
        else if(localStorage.getItem("IntroIndex") == "5"){
          $("#DP_Title_Left").html("경기운영본부");
        }
        else{
          $("#DP_Title_Left").html("경기스코어 입력");
        }

		/*radio click*/
		$("input[name='game-type']").click(function(){
			localStorage.setItem("GroupGameGb",$("input[name='game-type']:checked").val());
			
			if ( $("input[name='game-type']:checked").val() == 'tn001001' ){ //개인전

				//메뉴다시그리고######################
				if( score.smenu.split(",")[0] == 0){//단식부
					$("#TeamGb").children("option").remove();
					if( score.smenu.split(",")[1] > 0){//개인복식
						$("#TeamGb").append("<option value='201' selected>복식</option>");
					}
					else{
						$("#_s1menu1").hide();
					}
				}
				else{
					$("#TeamGb").children("option").remove();
					$("#TeamGb").append("<option value='200' selected>단식</option>");
					if( score.smenu.split(",")[1] > 0){//개인복식
						$("#TeamGb").append("<option value='201'>복식</option>");
					}
				}
				//메뉴다시그리고######################				
			}
			else{
				$('#TeamGb').children("option").remove();
				$('#TeamGb').append("<option value='202'>복식</option>");
			}
			
			if (score.smenu == "" || score.smenu == undefined){ //메뉴가 구성되지 않았다면
				score.drLevelList("#SexLevel", $("#TeamGb").val() ,'setmenu');
			}
			else{
				score.drLevelList("#SexLevel", $("#TeamGb").val(), 'no');
			}
		});

        document.addEventListener("deviceready", onDeviceReady, false);
        $("#tourney_title").html(localStorage.getItem("GameTitleName"));
        score.settingSearch();      

      });  
	  
/*
      $(document).ajaxStart(function() {
        apploading("AppBody", "해당대회 화면으로 이동 중 입니다.");
      });
      $(document).ajaxStop(function() {
        $('#AppBody').oLoader('hide');
      });
*/                
 //-->
</script>
    

</head>
<body id="AppBody"><!-- onload="onLoad()" -->

<!-- #include virtual = "/pub/html/tennis/html.top.asp" -->

<!-- S: main -->
	<!-- #include file = "./body/rgamelist.body.asp" -->
 <!-- E: main -->

<!-- #include file = "./body/pop.point.asp" -->
<!-- #include file = "./body/pop.skill.asp" -->

<!-- #include virtual = "/pub/html/tennis/html.footer.asp" -->	
</body>
</html>