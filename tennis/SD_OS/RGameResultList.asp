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
	score.gameSearch = function (tabletype) {
	    var Round_s = tabletype;
	    if (tabletype >= 10000) {
	        $("#H_GameType").val(1);
	        tabletype = 1;
	        Round_s = Round_s - 10000;
	    } else {
	        $("#H_GameType").val(tabletype);
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
	        var tt, sidx;
	        if (typeof tabletype == "object") {
	            tt = tabletype.TT;
	            sidx = tabletype.SIDX; //넘겨야할 TT값 설정( 스코어 ,결과 , 운영 에서 같은 ajax api 를 사용하므로 이를 구분할 값이 필요함
	        }
	        else {
	            tt = tabletype;
	            sidx = 0;
	        }

	        localStorage.setItem('searchinfo', [searchstr1, searchstr2, searchstr3, Round_s]); //현재상태 저장해두기
	        mx.SendPacket('scoregametable', { 'CMD': mx.CMD_GAMESEARCH, 'IDX': gameidx, 'S1': searchstr1, 'S2': searchstr2, 'S3': searchstr3, 'TT': tt, 'SIDX': sidx, 'Round_s': Round_s });
	    }
	};
	
	score.showScore = function(pobj){
		pobj.CMD = mx.CMD_SETSCORE;
		mx.SendPacket('round-res', pobj);
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
					$("#TeamGb").children("option").remove();
					$("#TeamGb").append("<option value='200' selected>단식</option>");
					if( score.smenu.split(",")[1] > 0){//개인복식
						$("#TeamGb").append("<option value='201'>복식</option>");
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
				else{
					localStorage.setItem("GroupGameGb",$('input:radio[name="game-type"]:checked').val());
					localStorage.setItem('BackPage','rgamelist');
					score.drLevelList("#SexLevel", $("#TeamGb").val() ,'no');
				}
		}
	  };
//      var onLoad=function(){
//        document.addEventListener("deviceready", onDeviceReady, false);
//        $("#tourney_title").html(localStorage.getItem("GameTitleName"));
//        SettingSearch();      
//      };



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
		/*radio click*/
		$("input[name='game-type']").click(function(){
			localStorage.setItem("GroupGameGb",$("input[name='game-type']:checked").val());
			
			if ( $("input[name='game-type']:checked").val() == 'tn001001' ){ //개인전
				$('#TeamGb').children("option").remove();
				$('#TeamGb').append("<option value='200' selected>단식</option>");
				$('#TeamGb').append("<option value='201'>복식</option>");
			}
			else{
				$('#TeamGb').children("option").remove();
				$('#TeamGb').append("<option value='202'>복식</option>");
			}
			
			drLevelList_sum("#SexLevel",$("#TeamGb").val(),"");
		});


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


        document.addEventListener("deviceready", onDeviceReady, false);
        $("#tourney_title").html(localStorage.getItem("GameTitleName"));
        score.settingSearch();      


      });  
	  


//      $(document).ajaxStart(function() {
//        apploading("AppBody", "해당대회 화면으로 이동 중 입니다.");
//      });
//      $(document).ajaxStop(function() {
//        $('#AppBody').oLoader('hide');
//      });
//                
 
//-->
</script>
    

</head>
<body  id="AppBody"><!-- onload="onLoad()" -->

<!-- #include virtual = "/pub/html/tennis/html.top.asp" -->

<!-- S: main -->
	<!-- #include file = "./body/rgameresultlist.body.asp" -->
 <!-- E: main -->

<!-- #include file = "./body/pop.point.asp" -->
<!-- #include file = "./body/pop.skill.asp" -->

<!-- #include virtual = "/pub/html/tennis/html.footer.asp" -->	
 <script src="js/main.js"></script>

</body>
</html>