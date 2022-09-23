<!doctype html>
<html lang="ko">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge, Chrome=1">
    <!--<meta name="viewport" content="width=device-width, initial-scale=1">-->
    <meta name="viewport" content="width=device-width, minimum-scale=1, initial-scale=1, user-scalable=no">
    <title>스포츠 다이어리</title>
    <meta name="apple-mobile-web-app-title" content="스포츠 다이어리">
    <!-- font-awesome -->
    <link rel="stylesheet" type="text/css" href="css/library/font-awesome.min.css">
    <link rel="stylesheet" href="css/bootstrap.css">
    <link rel="stylesheet" href="css/bootstrap-theme.css">
    <!-- custom css -->
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <!-- <link rel="stylesheet" type="text/css" href="css/style.bak_20161103.css"> -->
    <script src="js/library/jquery-1.12.2.min.js"></script>
    <script src="js/bootstrap.js"></script>

    <script src="js/global.js"></script>
    <script>
      /*--------------------$(document).ready(function()--------------------*/
      $(document).ready(function()
      {
        //해당라운드 스코어 조회해야할 정보 가져오기 (localStorage 정보)
        var varGameTitleIDX = localStorage.getItem("GameTitleIDX");
        var varTeamGb = localStorage.getItem("TeamGb");
        var varSex = localStorage.getItem("Sex");
        var varLevel = localStorage.getItem("Level");
        var varGroupGameGb = localStorage.getItem("GroupGameGb");
        //var varPlayerGameNum = localStorage.getItem("PlayerGameNum");
        //var varPlayRound = parseInt(localStorage.getItem("PlayRound"));
        var varGroupGameNum = localStorage.getItem("GroupGameNum");
        var varGroupRound = localStorage.getItem("GroupRound");

        //출전선수 등록 카운트. 초기진입엔 0으로 시작
        localStorage.setItem("LNumCnt", "0");
        localStorage.setItem("RNumCnt", "0");

        //출전선수 순서 Array
        localStorage.setItem("L_PlayerIdx_Array", "");
        localStorage.setItem("L_PlayerName_Array", "");
        localStorage.setItem("L_LevelName_Array", "");
        localStorage.setItem("L_LevelIdx_Array", "");

        localStorage.setItem("R_PlayerIdx_Array", "");
        localStorage.setItem("R_PlayerName_Array", "");
        localStorage.setItem("R_LevelName_Array", "");
        localStorage.setItem("R_LevelIdx_Array", "");

        //S:해당 라운드의 스코어 가져오기
        var loadscore=function(){
            var defer = $.Deferred();

            var obj = {};
            
            obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");
            obj.PlayerGameNum = localStorage.getItem("GroupGameNum");
            obj.GameType = localStorage.getItem("GameType");

            var jsonData = JSON.stringify(obj);

            console.log(jsonData);

            var events = "";

            //var arrayWinplayer = winplayer_select();  //승리한 선수 가져오기

            $.ajax({
                url: '/ajax/tennis_os/GGameGroupScoreDetail.ashx',
                type: 'post',
                data: jsonData,
                success: function (sdata) {

									console.log(sdata);

                  var myArr = JSON.parse(sdata);

                  //양 학교의 IDX
                  var varNoJoin1_Team = "22369"
                  var varNoJoin1_TeamDtl = "22369"
                  var varNoJoin2_Team = "22369"
                  var varNoJoin2_TeamDtl = "22369"
                  var varNoJoin1_SchNum = "0"
                  var varNoJoin2_SchNum = "0"

                  var varNoJoin1_SchoolName = "불참학교"
                  var varNoJoin2_SchoolName = "불참학교"

                  var var_EntryCnt = "0";

                  if (myArr.length > 0){

                    //이전 경기가 양소속불참, 양소속무승부일때 소속목록이 myArr.length 1로 나옴 
                    if (myArr.length == 1)
                    {
          
                      var teamcolor = "";
                      var listnum = "";

                      //도복색 결정
											if (myArr[0].TeamLeftRight == "Left")
                      {
												teamcolor = "white";
                      }
                      else{
												teamcolor = "blue";
                      }                     

                      var strSchoolName_0 = myArr[0].SchoolName;

                      //조(A조,B조) 로 등록 되어있을경우 소속 뒤에 조이름 추가
                      if (myArr[0].TeamDtl != "0")
                      {
                        strSchoolName_0 = strSchoolName_0 + myArr[0].TeamDtl;
                      }
                      

                      if(teamcolor == "white"){

                        $("#DP_player-school_Up").html(strSchoolName_0);
                        $("#DP_player-school_Up2").html(strSchoolName_0);
                        $("#DP_modal-school_Up").html(strSchoolName_0);   //팝업학교명(좌)

                        $("#DP_player-school_Down").html(varNoJoin1_SchoolName);
                        $("#DP_player-school_Down2").html(varNoJoin1_SchoolName);
                        $("#DP_modal-school_Down").html(varNoJoin1_SchoolName);   //팝업학교명(우)

                        localStorage.setItem("LTeam",myArr[0].Team);
                        localStorage.setItem("LTeamDtl",myArr[0].TeamDtl);
                        localStorage.setItem("LSchNum",myArr[0].SchNum);
                        localStorage.setItem("LSchoolName",strSchoolName_0);

                        localStorage.setItem("RTeam",varNoJoin1_Team);
                        localStorage.setItem("RTeamDtl",varNoJoin1_TeamDtl);
                        localStorage.setItem("RSchNum",varNoJoin1_SchNum);                        
                        localStorage.setItem("RSchoolName",varNoJoin1_SchoolName);

                        loadplayer(myArr[0].Team, myArr[0].TeamDtl, "DP_LGroup");
                        loadplayer(varNoJoin1_Team, varNoJoin1_TeamDtl, "DP_RGroup");

                      }
                      else{

                        $("#DP_player-school_Up").html(varNoJoin1_SchoolName);
                        $("#DP_player-school_Up2").html(varNoJoin1_SchoolName);
                        $("#DP_modal-school_Up").html(varNoJoin1_SchoolName);   //팝업학교명(좌)

                        $("#DP_player-school_Down").html(strSchoolName_0);
                        $("#DP_player-school_Down2").html(strSchoolName_0);
                        $("#DP_modal-school_Down").html(strSchoolName_0);   //팝업학교명(우)

                        localStorage.setItem("LTeam",varNoJoin1_Team);
                        localStorage.setItem("LTeamDtl",varNoJoin1_TeamDtl);
                        localStorage.setItem("LSchNum",varNoJoin1_SchNum);
                        localStorage.setItem("LSchoolName",varNoJoin1_SchoolName);

                        localStorage.setItem("RTeam",myArr[0].Team);
                        localStorage.setItem("RTeamDtl",myArr[0].TeamDtl);
                        localStorage.setItem("RSchNum",myArr[0].SchNum);
                        localStorage.setItem("RSchoolName",strSchoolName_0);

                        loadplayer(varNoJoin1_Team, varNoJoin1_TeamDtl, "DP_LGroup");
                        loadplayer(myArr[0].Team, myArr[0].TeamDtl, "DP_RGroup");


                      }

                    }
                    //정상경기라면
                    else
                    {

                      /*
                      //경기날짜
                      $("#DP_play-date").html(myArr[0].GameDate);
                      //타이틀
                      $("#DP_play-title").html(myArr[0].GameTitleName);
                      //개인전
                      $("#DP_play-division").html(myArr[0].GroupGameGbName);
                      //고등학교
                      $("#DP_play-belong").html(myArr[0].TeamGbName);
                      //남자
                      $("#DP_play-type").html(myArr[0].SexName);
                      //체급
                      $("#DP_play-weight").html(myArr[0].LevelName);
                      //16강
                      $("#DP_play-round").html(myArr[0].TotRoundName + "강");
                      //라운드
                      $("#DP_play-num").html(varGroupGameNum + "경기");
                      */

                      
                      //승리한 선수가 있다면..
                      /*
                      if(arrayWinplayer[0] != ""){
                        $("#WinPlayer").append("<option value='"+ arrayWinplayer[0] +"'>"+ arrayWinplayer[1] +"</option>");
                      }
                      else{
                        $("#WinPlayer").append("<option value='' selected>승자 선수 선택</option>");
                        $("#WinPlayer").append("<option value='"+ myArr[0].PlayerIDX +"'>"+ myArr[0].UserName +"</option>");
                        $("#WinPlayer").append("<option value='"+ myArr[1].PlayerIDX +"'>"+ myArr[1].UserName +"</option>");                      
                      }
                      */

                      var strSchoolName_0 = myArr[0].SchoolName;
                      var strSchoolName_1 = myArr[1].SchoolName;

                      //조(A조,B조) 로 등록 되어있을경우 소속 뒤에 조이름 추가
                      if (myArr[0].TeamDtl != "0")
                      {
                        strSchoolName_0 = strSchoolName_0 + myArr[0].TeamDtl;
                      }

                      if (myArr[1].TeamDtl != "0")
                      {
                        strSchoolName_1 = strSchoolName_1 + myArr[1].TeamDtl;
                      }

                      //선수학교
                      $("#DP_player-school_Up").html(strSchoolName_0);
                      $("#DP_player-school_Up2").html(strSchoolName_0);
                      $("#DP_modal-school_Up").html(strSchoolName_0);   //팝업학교명(좌)

                      $("#DP_player-school_Down").html(strSchoolName_1);
                      $("#DP_player-school_Down2").html(strSchoolName_1);
                      $("#DP_modal-school_Down").html(strSchoolName_1);   //팝업학교명(우)
                      
                      //양 학교의 IDX
                      localStorage.setItem("LTeam",myArr[0].Team);
                      localStorage.setItem("LTeamDtl",myArr[0].TeamDtl);
                      localStorage.setItem("LSchNum",myArr[0].SchNum);
                      localStorage.setItem("LSchoolName",strSchoolName_0);

                      localStorage.setItem("RTeam",myArr[1].Team);
                      localStorage.setItem("RTeamDtl",myArr[1].TeamDtl);
                      localStorage.setItem("RSchNum",myArr[1].SchNum);
                      localStorage.setItem("RSchoolName",strSchoolName_1);

                      //단체전 엔트리카운트
                      /*
                      localStorage.setItem("EntryCnt",myArr[0].EntryCnt);
                      localStorage.setItem("RGameLevelidx",myArr[0].RGameLevelidx);
                      */

                      loadplayer(myArr[0].Team, myArr[0].TeamDtl, "DP_LGroup");
                      loadplayer(myArr[1].Team, myArr[1].TeamDtl, "DP_RGroup");

                    }

                    select_rplayer();
                    select_groupresult(); //학교VS학교 점수및 게임결과
                  } 
                  
                  //양측부전패라면(조회된데이터 없을시)..
                  else {
                    
                      //선수학교
                      $("#DP_player-school_Up").html(varNoJoin1_SchoolName);
                      $("#DP_player-school_Up2").html(varNoJoin1_SchoolName);
                      $("#DP_modal-school_Up").html(varNoJoin1_SchoolName);   //팝업학교명(좌)

                      $("#DP_player-school_Down").html(varNoJoin2_SchoolName);
                      $("#DP_player-school_Down2").html(varNoJoin2_SchoolName);
                      $("#DP_modal-school_Down").html(varNoJoin2_SchoolName);   //팝업학교명(우)
                      
                      //양 학교의 IDX
                      localStorage.setItem("LTeam",varNoJoin1_Team);
                      localStorage.setItem("LTeamDtl",varNoJoin1_TeamDtl);
                      localStorage.setItem("LSchNum",varNoJoin1_SchNum);
                      localStorage.setItem("LSchoolName",varNoJoin1_SchoolName);

                      localStorage.setItem("RTeam",varNoJoin2_Team);
                      localStorage.setItem("RTeamDtl",varNoJoin2_TeamDtl);
                      localStorage.setItem("RSchNum",varNoJoin2_SchNum);
                      localStorage.setItem("RSchoolName",varNoJoin2_SchoolName);

                      //단체전 엔트리카운트
                      /*
                      localStorage.setItem("EntryCnt",myArr[0].EntryCnt);
                      localStorage.setItem("RGameLevelidx",myArr[0].RGameLevelidx);
                      */

                      loadplayer(varNoJoin1_Team, varNoJoin1_TeamDtl, "DP_LGroup");
                      loadplayer(varNoJoin2_Team, varNoJoin2_TeamDtl, "DP_RGroup");
                  }

                  defer.resolve(sdata);
                },
                error: function (errorText) {
                  defer.reject(errorText);
                }

                
            });
            return defer.promise();
        }


        //E:해당 라운드의 스코어 가져오기

        //S:출전대기 선수리스트
        var loadplayer=function(strTeam, strTeamDtl, listobj){
            var defer = $.Deferred();

            var obj = {};

            obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");
            obj.Team = strTeam;
            obj.TeamDtl = strTeamDtl;

            var jsonData = JSON.stringify(obj);

            var events = "";

            //var arrayWinplayer = winplayer_select();  //승리한 선수 가져오기

            $.ajax({
                url: '/ajax/tennis_os/GGameGroupPlayerList.ashx',
                type: 'post',
                data: jsonData,
                success: function (sdata) {



                  var myArr = JSON.parse(sdata);

                  var dpstr = "";

                  var num_nowEntryCnt = 0;

                  //불참자IDX
                  var str_nojoinidx = "";

                  var str_UserName_fontsize = "";

                  if (myArr.length > 0){

                    for (var i = 0; i < myArr.length; i++){

                      if (myArr[i].UserName.length > 9){
                        str_UserName_fontsize = "style='font-size:11px'";
                      }

                      //value= 123456|최승규|-70kg|
                      dpstr += "<dt><label><input type='checkbox' value='" + myArr[i].PlayerIDX + "|" + myArr[i].UserName + "|" + myArr[i].LevelName + "|" + myArr[i].LevelIdx + "' name='" + listobj + "_check' data-whatever='" + i + "' onclick=checkplayer(this) ><span id='DP_Num_" + myArr[i].PlayerIDX + "' name='" + listobj + "_span'></span></label></dt>";
                      dpstr += "<dd " + str_UserName_fontsize + " >" + myArr[i].UserName + "(" + myArr[i].LevelName +")</dd>";

                      num_nowEntryCnt = i;
                      
                    }

                    //출전대기선수 Count
                    num_nowEntryCnt = num_nowEntryCnt + 1;

                    if (localStorage.getItem("Sex") == "WoMan")
                    {
                      str_nojoinidx = "1496";
                    }
                    else{
                      str_nojoinidx = "1497";
                    }

                    //해당체급에 필요한 Entry까지 불참자를 추가해준다
                    while( Number(num_nowEntryCnt) < Number(localStorage.getItem("EntryCnt")) + 3 ){

                        /*
                        dpstr += "<dt><label><input type='checkbox' value='" + str_nojoinidx + "|불참자|" + myArr[i].LevelName + "|" + myArr[i].LevelIdx + "' name='" + listobj + "_check' onclick=checkplayer(this)><span id='DP_Num_" + str_nojoinidx + String(num_nowEntryCnt) + "' name='" + listobj + "_span'></span></label></dt>";
                        dpstr += "<dd>불참자</dd>";
                        */
                        dpstr += "<dt><label><input type='checkbox' value='" + str_nojoinidx + "|불참자||' name='" + listobj + "_check' data-whatever='" + num_nowEntryCnt + "' onclick=checkplayer(this)><span id='DP_Num_" + str_nojoinidx + String(num_nowEntryCnt) + "' name='" + listobj + "_span'></span></label></dt>";
                        dpstr += "<dd>불참자</dd>";

        

                        num_nowEntryCnt++;
                    }                   

                    $("#"+listobj).html(dpstr);
                    // $('.group-list-wrap').radioInput('.group-content dt label input');
                  } 

                  defer.resolve(sdata);
                },
                //error: function(xhr, status, error);
                error: function (errorText) {
                  defer.reject(errorText);
                }

                
            });
            return defer.promise();
        }
        //E:출전대기 선수리스트


        /*script 시작부*/
        loadgametitle(); 
        loadscore();
        loadgroupsign(); //심판싸인 불러오기
        /*script 시작부*/
      

        /*--------------------싸인관련--------------------*/
         var canvas = document.getElementById('game_signature');
         //canvas.width = screen.width;
         var context = canvas.getContext('2d');
         context.lineWidth=10;
         context.lineCap="round";

         $(canvas).bind({"touchstart mousedown": function(event){
          
          event.preventDefault();
          
          if(event.type == 'touchstart'){
           event = event.originalEvent.targetTouches[0];
          }
          
          $(this).data("flag", "1");
          var position = $(this).offset();
          var x = event.pageX - position.left;
          var y = event.pageY - position.top;
        
          context.beginPath();
          context.moveTo(x,y);

         }, "mousemove touchmove" : function(event) {
          
          event.preventDefault();
          
          if(event.type == 'touchmove'){
           event = event.originalEvent.targetTouches[0];
          }  

          var flag = $(this).data("flag");
          if(flag == 1){
           var position = $(this).offset();
           var x = event.pageX - position.left;
           var y = event.pageY - position.top; 
           
    
          }
          context.lineTo(x, y);
          context.stroke();
         }, "mouseup touchend mouseleave" : function(event) {
          
          event.preventDefault();

        
          if(event.type == 'touchend'){
           event = event.originalEvent.changedTouches[0];   
          }   

          $(this).data("flag", "0");
          var position = $(this).offset();
          
          var x = event.pageX - position.left;
          var y = event.pageY - position.top; 
          
      

         //  context.lineTo(x, y);
         //  context.stroke();
         }
         
         }); 

         $("#id_clear").click(function(){
          canvas.width = canvas.width;
          context.lineWidth=10;
          context.lineCap="round";
         });

         //싸인 승인완료
         $("#signature_copy").click(function(){

          //var imageData = context.getImageData(0,0,canvas.width, canvas.height);
          //var data = imageData.data;

      
          /*
          var canvasCopy = document.createElement("canvas");
          var copyContext = canvasCopy.getContext("2d");
          
          var w = 80;
          var h = 50;
          canvasCopy.width = w;
          canvasCopy.height = h;

          copyContext.drawImage(canvas, 0, 0, w, h);

          */
          var pngUrl = canvas.toDataURL();
          //var copyPngUrl = canvasCopy.toDataURL();

          /*
          console.log("원본이미지 사이즈: " + pngUrl.length);
          console.log("스몰이미지 사이즈: " + copyPngUrl.length);

          console.log("url type: " + typeof(copyPngUrl));
          console.log("스몰이미지 url: " + copyPngUrl);
          console.log("스몰이미지 url: " + copyPngUrl.replace("data:image/png;base64,", ""));
          */

          //해당 싸인 DB Insert
          groupsign_insert(pngUrl, $("#game_signature").attr("data-id") );

          if($("#game_signature").attr("data-id") == "chiefSign"){
            id_signcopy = "#chiefSign_copy";

            $("#btn_chiefSign").css("display","none");
            $("#result_chiefSign").css("display","block");
          }
          else if($("#game_signature").attr("data-id") == "asschiefSign1"){
            id_signcopy = "#asschiefSign1_copy";

            $("#btn_asschiefSign1").css("display","none");
            $("#result_asschiefSign1").css("display","block");
          }
          else if($("#game_signature").attr("data-id") == "asschiefSign2"){
            id_signcopy = "#asschiefSign2_copy";

            $("#btn_asschiefSign2").css("display","none");
            $("#result_asschiefSign2").css("display","block");
          }

          $(id_signcopy).html("");
          $(id_signcopy).html("<img src='"+pngUrl+"' width='188' height='69'>");


          /*
          $("<img>", {

           src: pngUrl,
           width:188,
           height:69,
           onload: function(){console.log("img loaded..");}

          }).appendTo(id_signcopy);
          */

          $('#sign-modal').modal('hide');

          //캔버스삭제
          canvas.width = canvas.width;
          context.lineWidth=10;
          context.lineCap="round";

        

          //delete canvasCopy;
         });
        /*--------------------싸인관련--------------------*/

        /*--------------------싸인모달 띄울때--------------------*/
        $('#sign-modal').on('show.bs.modal', function (event) {

          /*
          var arrayWinplayer = winplayer_select();

          if(arrayWinplayer[0] == ""){
            alert('해당 라운드 승패 결정 후, 승인 가능합니다.');
            $('#sign-modal').modal('hide');
            return;
          }
          */

         //클릭 이벤트된 버튼 obj
         var button = $(event.relatedTarget); 

         //클릭 이벤트된 버튼 data-whatever의 value
         var strbutton_data = button.data('whatever');
          
         //캔버스의 data-id에 값 입력
         $("#game_signature").attr("data-id", strbutton_data);

        });


        //출전선수 등록버튼
        $("#btn_playerModal").click(function(){
          //출전선수가 이미 등록되어있다면..
          if ($("#div_resultsave").css("display") == "block")
          {
            alert('출전선수가 이미 등록되어있습니다.');
            return;
          }

          //연장경기구분값
          localStorage.setItem("GroupAddGame", "0");
          //출전선수등록
          $("#btn_playerreg").attr("onclick","complete_selectplayer()"); 
          $("#player-modal").modal();
        });



        //연장전 추가버튼
        $("#btn_addplayerModal").click(function(){

          //연장경기구분값         
          localStorage.setItem("GroupAddGame", "1");
          //연장전등록
          $("#btn_playerreg").attr("onclick","complete_addselectplayer()"); 
          $("#player-modal").modal();
        });


        //다시등록하기 버튼
        $("#btn_resaveModal").click(function(){
          //출전선수가 이미 등록되어있다면..
          if ($("#div_resultsave").css("display") == "block")
          {
            alert('출전선수가 이미 등록되어있습니다.');
            return;
          }

          //연장경기구분값
          localStorage.setItem("GroupAddGame", "0");
          //출전선수등록
          $("#btn_playerreg").attr("onclick","complete_selectplayer()"); 
          $("#player-modal").modal();
        });


        //동점일때 클릭 시, modal창 띄울때
        $('#same-score-modal').on('show.bs.modal', function (event) {

          //총게임 Cnt != 등록된선수들의 판정완료된경기
          /*
          if(localStorage.getItem("GroupGameCnt") != localStorage.getItem("NowGroupGameCnt")){
            alert('판정이 정해지지않은 경기가 있습니다. 해당 단체전 경기가 전부완료 후, 기록 가능합니다.1');
            return false;
          }
          */
          
        });

        //단체전 경기기록 확인창 클릭 시, modal창 띄울때
        $('#result-save-modal').on('show.bs.modal', function (event) {

          //총게임 Cnt != 등록된선수들의 판정완료된경기
          //2017/01/02 판정이 정해지지않은 경기가 있어도 경기완료시킬 수 있게 처리
          /*
          if(localStorage.getItem("GroupGameCnt") != localStorage.getItem("NowGroupGameCnt")){
            alert('판정이 정해지지않은 경기가 있습니다. 해당 단체전 경기가 전부완료 후, 기록 가능합니다.2');
            return false;
          }
          */


					var str_StadiumNumber = "";

          //선택된 경기장
          $.each($("label[name='LB_GYM']"), function() {
            if ($(this).attr("class") == "on")
            {
              str_StadiumNumber = $(this).attr("data-id");
            }
          });

					if(str_StadiumNumber == ""){
						alert("해당경기의 경기장을 선택하세요.");
						return false;
					}
          

          if( localStorage.getItem("GroupGameCnt") != localStorage.getItem("NowGroupGameCnt") && (Number(localStorage.getItem("NowGroupGameCnt")) < 1 ) ){
            alert('판정이 정해지지않은 경기가 있습니다. 해당 단체전 경기가 전부완료 후, 기록 가능합니다.2');
            return false;
          }

        });

      });

      //S:심판싸인 저장(modal팝업의 승인완료버튼)
      function groupsign_insert(strimage, strsigngubun){
          var defer = $.Deferred();

          var obj = {};

          obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");
          obj.GroupGameNum = localStorage.getItem("GroupGameNum");

          obj.SignData = strimage;
          obj.Signgubun = strsigngubun;

          var jsonData = JSON.stringify(obj);

          var events = "";


          $.ajax({
              url: '/ajax/tennis_os/GGameGroupSignUpdate.ashx',
              type: 'post',
              data: jsonData,
              success: function (sdata) {


                /*
                var myArr = JSON.parse(sdata);


                
                if (myArr.length > 0){
                  
                  

                } else {
                  
                  var varMessage="<dd><label>등록된 기술이 없습니다.</label></dd>";
                }
                */

                defer.resolve(sdata);
              },
              error: function (errorText) {
                defer.reject(errorText);
              }
          });
          return defer.promise();           
      }
      //E:심판싸인 저장(modal팝업의 승인완료버튼)

        //S:심판 싸인가져오기
        function loadgroupsign(){
            var defer = $.Deferred();

            var obj = {};

            obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");
            obj.GroupGameNum = localStorage.getItem("GroupGameNum");

            var jsonData = JSON.stringify(obj);

            var events = "";

            $.ajax({
                url: '/ajax/tennis_os/GGameGroupSignSelect.ashx',
                type: 'post',
                data: jsonData,
                success: function (sdata) {


                  var myArr = JSON.parse(sdata);

                  if (myArr.length > 0){

                    //주심1 싸인
                    if (myArr[0].ChiefSign != "")
                    {
                      
                      /*
                      $("<img>", {
                       src: myArr[0].ChiefSign,
                       width:188,
                       height:69,
                       onload: function(){console.log("img loaded..");
                      }
                      }).appendTo("#chiefSign_copy");
                      */
                      
                      $("#chiefSign_copy").html("");
                      $("#chiefSign_copy").html("<img src='" + myArr[0].ChiefSign + "' width='188' height='69'>");

                      $("#btn_chiefSign").css("display","none");
                      $("#result_chiefSign").css("display","block");
                    }
                    else{

                      $("#btn_chiefSign").css("display","block");
                      $("#result_chiefSign").css("display","none");                   
                    }


                    //부심1 싸인
                    if (myArr[0].AssChiefSign1 != "")
                    {
                      /*
                      $("<img>", {
                       src: myArr[0].AssChiefSign1,
                       width:188,
                       height:69,
                       onload: function(){console.log("img loaded..");
                      }
                      }).appendTo("#asschiefSign1_copy");
                      */

                      $("#asschiefSign1_copy").html("");
                      $("#asschiefSign1_copy").html("<img src='" + myArr[0].AssChiefSign1 + "' width='188' height='69'>");

                      $("#btn_asschiefSign1").css("display","none");
                      $("#result_asschiefSign1").css("display","block");
                    }
                    else{

                      $("#btn_asschiefSign1").css("display","block");
                      $("#result_asschiefSign1").css("display","none");                   
                    }



                    //부심2 싸인
                    if (myArr[0].AssChiefSign2 != "")
                    {
                      /*
                      $("<img>", {
                       src: myArr[0].AssChiefSign2,
                       width:188,
                       height:69,
                       onload: function(){console.log("img loaded..");
                      }
                      }).appendTo("#asschiefSign2_copy");
                      */

                      $("#asschiefSign2_copy").html("");
                      $("#asschiefSign2_copy").html("<img src='" + myArr[0].AssChiefSign2 + "' width='188' height='69'>");

                      $("#btn_asschiefSign2").css("display","none");
                      $("#result_asschiefSign2").css("display","block");
                    }
                    else{

                      $("#btn_asschiefSign2").css("display","block");
                      $("#result_asschiefSign2").css("display","none");                   
                    }
                  } 
                  
                  else {
                    
                  }

                  defer.resolve(sdata);
                },
                error: function (errorText) {
                  defer.reject(errorText);
                }
            });
            return defer.promise();       
        }
        //E:심판 싸인가져오기

      /*--------------------$(document).ready(function()--------------------*/

      function checkplayer(checkobj){

        //해당 obj의 name가져오기
        var strcheckobj_index = $(checkobj).attr("data-whatever");

        var strcheckobj = $(checkobj).val();

        var array_checkobj = strcheckobj.split("|");

        var numarea = "DP_Num_" + array_checkobj[0];

        gubun = $(checkobj).attr("name");

        //왼쪽팀
        if (gubun == "DP_LGroup_check")
        {
          int_LNumCnt = Number(localStorage.getItem("LNumCnt")) + 1

          //count 담기
          localStorage.setItem("LNumCnt", String(int_LNumCnt));

          //선수 count display
          //$("#" + numarea).html(localStorage.getItem("LNumCnt"));

          //선택된 name의 index를 찾아 번호부여

          $("span[name=DP_LGroup_span]").eq(strcheckobj_index).html(localStorage.getItem("LNumCnt"));

          //왼쪽선수 체크한 순서한 대로의 배열
          if (localStorage.getItem("L_PlayerIdx_Array") == "")
          {
            localStorage.setItem("L_PlayerIdx_Array", array_checkobj[0]);
            localStorage.setItem("L_PlayerName_Array", array_checkobj[1]);
            localStorage.setItem("L_LevelName_Array", array_checkobj[2]);
            localStorage.setItem("L_LevelIdx_Array", array_checkobj[3]);
          }
          else
          {
            localStorage.setItem("L_PlayerIdx_Array", localStorage.getItem("L_PlayerIdx_Array") + "," + array_checkobj[0] );
            localStorage.setItem("L_PlayerName_Array", localStorage.getItem("L_PlayerName_Array") + "," + array_checkobj[1] );
            localStorage.setItem("L_LevelName_Array", localStorage.getItem("L_LevelName_Array") + "," + array_checkobj[2] );          
            localStorage.setItem("L_LevelIdx_Array", localStorage.getItem("L_LevelIdx_Array") + "," + array_checkobj[3] );  
          }

          //체크는 한번만되게
          $(checkobj).attr("disabled", "disabled");

        }
        else{
          int_RNumCnt = Number(localStorage.getItem("RNumCnt")) + 1

          //count 담기
          localStorage.setItem("RNumCnt", String(int_RNumCnt));

          //선수 count display
          //$("#" + numarea).html(localStorage.getItem("RNumCnt"));   

          //선택된 name의 index를 찾아 번호부여
          $("span[name=DP_RGroup_span]").eq(strcheckobj_index).html(localStorage.getItem("RNumCnt"));
          
          //오른쪽선수 체크한 순서한 대로의 배열
          if (localStorage.getItem("R_PlayerIdx_Array") == "")
          {
            localStorage.setItem("R_PlayerIdx_Array", array_checkobj[0]);
            localStorage.setItem("R_PlayerName_Array", array_checkobj[1]);
            localStorage.setItem("R_LevelName_Array", array_checkobj[2]);
            localStorage.setItem("R_LevelIdx_Array", array_checkobj[3]);
          }
          else
          {
            localStorage.setItem("R_PlayerIdx_Array", localStorage.getItem("R_PlayerIdx_Array") + "," + array_checkobj[0] );
            localStorage.setItem("R_PlayerName_Array", localStorage.getItem("R_PlayerName_Array") + "," + array_checkobj[1] );
            localStorage.setItem("R_LevelName_Array", localStorage.getItem("R_LevelName_Array") + "," + array_checkobj[2] );          
            localStorage.setItem("R_LevelIdx_Array", localStorage.getItem("R_LevelIdx_Array") + "," + array_checkobj[3] );          
          }

          //체크는 한번만되게
          $(checkobj).attr("disabled", "disabled");

        }

        
      
      }

      //S:각 단체전 초기화
      function checkplayer_reset(str){
        if(str == "DP_LGroup"){
          localStorage.setItem("LNumCnt", "0");
          localStorage.setItem("L_PlayerIdx_Array", "");
          localStorage.setItem("L_PlayerName_Array", "");
          localStorage.setItem("L_LevelName_Array", "");
          localStorage.setItem("L_LevelIdx_Array", "");
          
          $('input:checkbox[name="DP_LGroup_check"]').each(function(){
            this.checked = false;
            $(this).removeAttr("disabled");
          });

          $('span[name="DP_LGroup_span"]').each(function(){
            $(this).html("");
          });
        }
        else{
          localStorage.setItem("RNumCnt", "0");
          localStorage.setItem("R_PlayerIdx_Array", "");
          localStorage.setItem("R_PlayerName_Array", "");
          localStorage.setItem("R_LevelName_Array", "");
          localStorage.setItem("R_LevelIdx_Array", "");
          
          $('input:checkbox[name="DP_RGroup_check"]').each(function(){
            this.checked = false;
            $(this).removeAttr("disabled");
          });   

          $('span[name="DP_RGroup_span"]').each(function(){
            $(this).html("");         
          });
        }
      }
      //E:각 단체전 초기화

    //S:단체전 1차등록
    function complete_selectplayer(){


    
      if( localStorage.getItem("LNumCnt") == "0" || localStorage.getItem("RNumCnt") == "0" ){
        alert('단체전 선수를 순서에 맞게 체크해 주시기 바랍니다.');
        return;
      }

      if (localStorage.getItem("LNumCnt") != localStorage.getItem("RNumCnt"))
      {
        alert('단체전 대전상대 선수인원이 동일하지 않습니다.');
        return;
      }
      

      var strlist = "";
      
      var split_LPlayerIdx = localStorage.getItem("L_PlayerIdx_Array").split(",");
      var split_LPlayerName = localStorage.getItem("L_PlayerName_Array").split(",");
      var split_LLevelName = localStorage.getItem("L_LevelName_Array").split(",");
      var split_LLevelIdx = localStorage.getItem("L_LevelIdx_Array").split(",");

      var split_RPlayerIdx = localStorage.getItem("R_PlayerIdx_Array").split(",");
      var split_RPlayerName = localStorage.getItem("R_PlayerName_Array").split(",");
      var split_RLevelName = localStorage.getItem("R_LevelName_Array").split(",");
      var split_RLevelIdx = localStorage.getItem("R_LevelIdx_Array").split(",");

      var i = 0;

      while(i <= split_LPlayerIdx.length - 1){
          strlist += "<ul>";
          strlist += "<li>" + split_LPlayerName[i] + "</li>";
          strlist += "<li>" + split_LLevelName[i] + "</li>";
          strlist += "<li>-</li>";
          strlist += "<li>-</li>";
          strlist += "<li>-</li>";
          strlist += "<li></li>";
          strlist += "<li>-</li>";
          strlist += "<li>-</li>";
          strlist += "<li>-</li>";
          strlist += "<li>" + split_RLevelName[i] + "</li>";
          strlist += "<li>" + split_RPlayerName[i] + "</li>";
          strlist += "</ul>";       

          i++;
      }

      while(i <= 10){
          strlist += "<ul>";
          strlist += "<li></li>";
          strlist += "<li></li>";
          strlist += "<li></li>";
          strlist += "<li></li>";
          strlist += "<li></li>";
          strlist += "<li></li>";
          strlist += "<li></li>";
          strlist += "<li></li>";
          strlist += "<li></li>";
          strlist += "<li></li>";
          strlist += "<li></li>";
          strlist += "</ul>";       

          i++;
      }

      //양측 부전패,무승부 bottom
      $("#div_groupresult").css("display","none");

      $("#div_playerorder").css("display","block");
      $("#span_playerorder").css("display","block");
      $("#div_resultsave").css("display","none");
      $("#div_signature").css("display","none");

      $("#grouplist").html(strlist);

      $("#player-modal").modal("hide");

    }
    //E:단체전 1차등록

    //S:단체전 2차등록
    function insert_playerlist(){

        var defer = $.Deferred();
        
        var obj = {};
        
        obj.GameTitleIDX = localStorage.getItem("GameTitleIDX");
        obj.TeamGb = localStorage.getItem("TeamGb");
        obj.Sex = localStorage.getItem("Sex");
        obj.Level = localStorage.getItem("Level");
        obj.GroupGameGb = localStorage.getItem("GroupGameGb");
        obj.GroupGameNum = localStorage.getItem("GroupGameNum");
        obj.SportsGb = localStorage.getItem("SportsGb");

        obj.LTeam = localStorage.getItem("LTeam");
        obj.LTeamDtl = localStorage.getItem("LTeamDtl");
        obj.L_PlayerIdx_Array = localStorage.getItem("L_PlayerIdx_Array");
        obj.L_PlayerName_Array = localStorage.getItem("L_PlayerName_Array");
        obj.L_LevelName_Array = localStorage.getItem("L_LevelName_Array");
        obj.L_LevelIdx_Array = localStorage.getItem("L_LevelIdx_Array");

        obj.RTeam = localStorage.getItem("RTeam");
        obj.RTeamDtl = localStorage.getItem("RTeamDtl");
        obj.R_PlayerIdx_Array = localStorage.getItem("R_PlayerIdx_Array");
        obj.R_PlayerName_Array = localStorage.getItem("R_PlayerName_Array");
        obj.R_LevelName_Array = localStorage.getItem("R_LevelName_Array");
        obj.R_LevelIdx_Array = localStorage.getItem("R_LevelIdx_Array");

        console.log("L_LevelName_Array:" + localStorage.getItem("L_LevelName_Array"));
        console.log("R_LevelName_Array:" + localStorage.getItem("R_LevelName_Array"));

        console.log("L_LevelIdx_Array:" + localStorage.getItem("L_LevelIdx_Array"));
        console.log("R_LevelIdx_Array:" + localStorage.getItem("R_LevelIdx_Array"));

        obj.GroupAddGame = localStorage.getItem("GroupAddGame");

        obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");

        obj.GameType = localStorage.getItem("GameType");
        
        var jsonData = JSON.stringify(obj);

        
        
        $.ajax({
            url: '/ajax/tennis_os/GGameGroupPlayerInsert.ashx',
            type: 'post',
            data: jsonData,
            success: function (sdata) {
              
              console.log(sdata);
        
              //등록했던 단체전 선수 불러오기
              select_rplayer();
              
              //양측 부전패,무승부 bottom
              $("#div_groupresult").css("display","none");

              $("#div_playerorder").css("display","none");
              $("#span_playerorder").css("display","none");
              $("#div_resultsave").css("display","block");
              $("#div_signature").css("display","block");

              $("#save-modal").modal("hide");

              defer.resolve(sdata);
            },
            error: function (errorText) {
              defer.reject(errorText);
            }
        
        });
        return defer.promise();
    }
    //E:단체전 2차등록

    //S:단체전 연장전 등록
    function complete_addselectplayer(){


      var defer = $.Deferred();
        
      var obj = {};

      obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");
      obj.GroupGameNum = localStorage.getItem("GroupGameNum");

      if( localStorage.getItem("LNumCnt") == "0" || localStorage.getItem("RNumCnt") == "0" ){
        alert('연장 단체전 선수를 순서에 맞게 체크해 주시기 바랍니다.');
        return;
      }

      if (localStorage.getItem("LNumCnt") != localStorage.getItem("RNumCnt"))
      {
        alert('연장 단체전 대전상대 선수인원이 동일하지 않습니다.');
        return;
      }
      
      var strlist = "";
      
      var split_LPlayerIdx = localStorage.getItem("L_PlayerIdx_Array").split(",");
      var split_LPlayerName = localStorage.getItem("L_PlayerName_Array").split(",");
      var split_LLevelName = localStorage.getItem("L_LevelName_Array").split(",");
      var split_LLevelIdx = localStorage.getItem("L_LevelIdx_Array").split(",");

      var split_RPlayerIdx = localStorage.getItem("R_PlayerIdx_Array").split(",");
      var split_RPlayerName = localStorage.getItem("R_PlayerName_Array").split(",");
      var split_RLevelName = localStorage.getItem("R_LevelName_Array").split(",");
      var split_RLevelIdx = localStorage.getItem("R_LevelIdx_Array").split(",");


      var jsonData = JSON.stringify(obj);


      var events = "";
      
      //var arrayWinplayer = winplayer_select();  //승리한 선수 가져오기
      
      $.ajax({
          url: '/ajax/tennis_os/GGameGroupRPlayerSelect.ashx',
          type: 'post',
          data: jsonData,
          success: function (sdata) {



            var strlist = "";
            var i = 0;
            var j = 0;
      
            var myArr = JSON.parse(sdata);

						console.log("1" + sdata);

            if (myArr.length > 0){

              //해당단체전의 총 대전해야할 카운트
              localStorage.setItem("GroupGameCnt",myArr.length);
      
              while(i <= myArr.length - 1){
                  strlist += "<ul>";
                  strlist += "<li>"; 
          
                  if(myArr[i].LGroupAddGame == "1"){
                    strlist += "<span class='icon-overtime'>연장</span>";
                  }

                  strlist += myArr[i].LUserName + "</li>";
                  strlist += "<li>" + myArr[i].LLevelName + "</li>";
                  strlist += "<li>" + myArr[i].LPlayerResult + "</li>";
                  strlist += "<li>" + myArr[i].LJumsu + "</li>";
                  strlist += "<li>" + myArr[i].LFinalSkill + "</li>";
                  strlist += "<li>";

                  if(myArr[i].LPlayerResult == "" && myArr[i].RPlayerResult == ""){
                    strlist += "<a onclick='mov_enterscore(this)' data-id='" + myArr[i].GameNum + "' role='button' class='btn btn-repair-write'>스코어 입력 <i class='fa fa-angle-right' aria-hidden='true'></i></a>";
                  }
                  else{
                    strlist += "<a onclick='editscore(this)' data-toggle='modal' data-target='#round-res' data-id='" + myArr[i].GameNum + "' role='button' class='btn btn-repair'>스코어 수정 <i class='fa fa-angle-right' aria-hidden='true'></i></a>";
                  }

                  strlist += "</li>";
                  strlist += "<li>" + myArr[i].LFinalSkill + "</li>";
                  strlist += "<li>" + myArr[i].RJumsu + "</li>";
                  strlist += "<li>" + myArr[i].RPlayerResult + "</li>";
                  strlist += "<li>" + myArr[i].RLevelName + "</li>";
                  strlist += "<li>";

                  if(myArr[i].RGroupAddGame == "1"){
                    strlist += "<span class='icon-overtime'>연장</span>";
                  }

                  strlist += myArr[i].RUserName + "</li>";
                  strlist += "</ul>";       

                  i++;
              }

              

              while(j <= split_LPlayerIdx.length - 1){
                  strlist += "<ul>";
                  strlist += "<li>";

                  if(localStorage.getItem("GroupAddGame") == "1"){
                    strlist += "<span class='icon-overtime'>연장</span>";
                  }

                  strlist += split_LPlayerName[j] + "</li>";
                  strlist += "<li>" + split_LLevelName[j] + "</li>";
                  strlist += "<li>-</li>";
                  strlist += "<li>-</li>";
                  strlist += "<li>-</li>";
                  strlist += "<li></li>";
                  strlist += "<li>-</li>";
                  strlist += "<li>-</li>";
                  strlist += "<li>-</li>";
                  strlist += "<li>" + split_RLevelName[j] + "</li>";
                  strlist += "<li>";

                  if(localStorage.getItem("GroupAddGame") == "1"){
                    strlist += "<span class='icon-overtime'>연장</span>";
                  }

                  strlist += split_RPlayerName[j] + "</li>";
                  strlist += "</ul>";       

                  i++;
                  j++;
              }


              while(i <= 10){
                  strlist += "<ul>";
                  strlist += "<li></li>";
                  strlist += "<li></li>";
                  strlist += "<li></li>";
                  strlist += "<li></li>";
                  strlist += "<li></li>";
                  strlist += "<li></li>";
                  strlist += "<li></li>";
                  strlist += "<li></li>";
                  strlist += "<li></li>";
                  strlist += "<li></li>";
                  strlist += "<li></li>";
                  strlist += "</ul>";   
                
                  i++;
              }

              //양측 부전패,무승부 bottom
              $("#div_groupresult").css("display","none");

              $("#div_playerorder").css("display","block");
              $("#span_playerorder").css("display","block");
              $("#div_resultsave").css("display","none");
              $("#div_signature").css("display","none");

              $("#grouplist").html(strlist);
              $("#player-modal").modal("hide");
            } 
            else{

              //해당단체전의 총 대전해야할 카운트
              localStorage.setItem("GroupGameCnt","0");

              //양측 부전패,무승부 bottom
              $("#div_groupresult").css("display","none");

              $("#div_playerorder").css("display","none");
              $("#span_playerorder").css("display","none");
              $("#div_resultsave").css("display","block");
              $("#div_signature").css("display","block");
            }
      
            defer.resolve(sdata);
          },
          error: function (errorText) {
            defer.reject(errorText);
          }
      
          
      });
      return defer.promise(); 
    }
    //E:단체전 연장전 등록

    //S:등록했던 단체전 선수 불러오기
    function select_rplayer(){

      var defer = $.Deferred();
      
      var obj = {};
      
      obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");
      obj.GroupGameNum = localStorage.getItem("GroupGameNum");
      
      var jsonData = JSON.stringify(obj);

    
    
      var events = "";
      
      //var arrayWinplayer = winplayer_select();  //승리한 선수 가져오기
      
      $.ajax({
          url: '/ajax/tennis_os/GGameGroupRPlayerSelect.ashx',
          type: 'post',
          data: jsonData,
          success: function (sdata) { 
          
                      console.log(sdata);

            var strlist = "";
            var i = 0;

          
      
            var myArr = JSON.parse(sdata);            
      
            if (myArr.length > 0){

              //해당단체전의 총 대전해야할 카운트
              localStorage.setItem("GroupGameCnt",myArr.length);
      
              while(i <= myArr.length - 1){
                  strlist += "<ul>";
                  strlist += "<li>";
                  if(myArr[i].LGroupAddGame == "1"){
                    strlist += "<span class='icon-overtime'>연장</span>";
                  }
                  strlist += myArr[i].LUserName + "</li>";
                  strlist += "<li>" + myArr[i].LLevelName + "</li>";
                  strlist += "<li>" + myArr[i].LPlayerResult + "</li>";
                  strlist += "<li>" + myArr[i].LJumsu + "</li>";
                  strlist += "<li>" + myArr[i].LFinalSkill + "</li>";
                  strlist += "<li>";

                  if(myArr[i].LPlayerResult == "" && myArr[i].RPlayerResult == ""){
                    strlist += "<a onclick='mov_enterscore(this)' data-id='" + myArr[i].GameNum + "' role='button' class='btn btn-repair-write'>스코어 입력 <i class='fa fa-angle-right' aria-hidden='true'></i></a>";
                  }
                  else{
                    strlist += "<a onclick='editscore(this)' data-toggle='modal' data-target='#round-res' data-id='" + myArr[i].GameNum + "' role='button' class='btn btn-repair'>스코어 수정 <i class='fa fa-angle-right' aria-hidden='true'></i></a>";
                  }

                  strlist += "</li>";
                  strlist += "<li>" + myArr[i].RFinalSkill + "</li>";
                  strlist += "<li>" + myArr[i].RJumsu + "</li>";
                  strlist += "<li>" + myArr[i].RPlayerResult + "</li>";
                  strlist += "<li>" + myArr[i].RLevelName + "</li>";
                  strlist += "<li>"; 
                  if(myArr[i].RGroupAddGame == "1"){
                    strlist += "<span class='icon-overtime'>연장</span>";
                  }
                  strlist += myArr[i].RUserName + "</li>";
                  strlist += "</ul>";       

                  i++;
              }

              while(i <= 10){
                  strlist += "<ul>";
                  strlist += "<li></li>";
                  strlist += "<li></li>";
                  strlist += "<li></li>";
                  strlist += "<li></li>";
                  strlist += "<li></li>";
                  strlist += "<li></li>";
                  strlist += "<li></li>";
                  strlist += "<li></li>";
                  strlist += "<li></li>";
                  strlist += "<li></li>";
                  strlist += "<li></li>";
                  strlist += "</ul>";   
                  

                  i++;
              }

              //출전선수버튼 회색으로
              $("#btn_playerModal").attr("class","btn btn-enter-player");
              //연장경기버튼 붉은색으로
              $("#btn_addplayerModal").attr("class","btn btn-add-match on");

              //양측 부전패,무승부 bottom
              $("#div_groupresult").css("display","none");

              $("#div_playerorder").css("display","none");
              $("#span_playerorder").css("display","none");
              $("#div_resultsave").css("display","block");
              $("#div_signature").css("display","block");
              
              $("#grouplist").html(strlist);
            } 
            else{

              //해당단체전의 총 대전해야할 카운트
              localStorage.setItem("GroupGameCnt","0");

              //출전선수버튼 붉은색으로
              $("#btn_playerModal").attr("class","btn btn-enter-player on");
              //연장경기버튼 회색으로
              $("#btn_addplayerModal").attr("class","btn btn-add-match");

              //하단영역 순서대로경기등록으로 보여지기
              //$("#div_playerorder").css("display","block");
              //$("#span_playerorder").css("display","none");
              //$("#div_resultsave").css("display","none");
              //$("#div_signature").css("display","none");

              //양측 부전패,무승부 bottom
              $("#div_groupresult").css("display","block");

              $("#div_playerorder").css("display","none");
              $("#span_playerorder").css("display","none");
              $("#div_resultsave").css("display","none");
              $("#div_signature").css("display","none");


            }
      
            defer.resolve(sdata);
          },
          error: function (errorText) {
            defer.reject(errorText);
          }
      
          
      });
      return defer.promise();   
    }
    //E:등록했던 단체전 선수 불러오기

    //S:학교VS학교 점수및 결과가져오기
    function select_groupresult(){

      var defer = $.Deferred();
      
      var obj = {};
      
      obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");
      obj.GroupGameNum = localStorage.getItem("GroupGameNum");
      
      var jsonData = JSON.stringify(obj);

      var events = "";


      
      //var arrayWinplayer = winplayer_select();  //승리한 선수 가져오기
      
      $.ajax({
          url: '/ajax/tennis_os/GGameGroupWinResult.ashx',
          type: 'post',
          data: jsonData,
          success: function (sdata) {
        
            var strlist = "";
            var i = 0;

          
            console.log("1-s:" + sdata);
      
            var myArr = JSON.parse(sdata);

            if (myArr.length > 0){

              var strLSchoolName = myArr[0].LeftSchoolName;
              var strRSchoolName = myArr[0].RightSchoolName;

              if (myArr[0].LTeamDtl != "0")
              {
                strLSchoolName = strLSchoolName + myArr[0].LTeamDtl
              }

              if (myArr[0].RTeamDtl != "0")
              {
                strRSchoolName = strRSchoolName + myArr[0].RTeamDtl
              }

              //4승4패(25점)
              $("#DP_LSchoolName").html(strLSchoolName);
              $("#DP_LResult").html(myArr[0].LeftWinCnt + "승" + myArr[0].LeftDrawCnt + "무" + myArr[0].LeftLoseCnt + "패(" + myArr[0].LeftJumsu + ")");
              $("#DP_RSchoolName").html(strRSchoolName);
              $("#DP_RResult").html(myArr[0].RightWinCnt + "승" + myArr[0].RightDrawCnt + "무" + myArr[0].RightLoseCnt + "패(" + myArr[0].RightJumsu + ")");
 
              //현재까지 진행된 단체전의 개인카운트
              localStorage.setItem("NowGroupGameCnt",myArr[0].GameCnt);

              $("#DP_Total_LJumsu").html(myArr[0].LeftJumsu);
              $("#DP_Total_RJumsu").html(myArr[0].RightJumsu);

              //총진행할게임수 == 진행된게임수
              //if(localStorage.getItem("GroupGameCnt") == localStorage.getItem("NowGroupGameCnt")){
                
                if(Number(myArr[0].LeftWinCnt) > Number(myArr[0].RightWinCnt)){
                  //좌측승(선수표)
                  $("#DP_Total_LResult").html("승");
                  $("#DP_Total_RResult").html("패");

                  //좌측승(팝업 트로피표시)
                  $("#DP_LWinTitle").attr("class","win");
                  $("#DP_RWinTitle").attr("class","");
                  
                }
                else if(Number(myArr[0].LeftWinCnt) < Number(myArr[0].RightWinCnt)){
                  //우측승(선수표)
                  $("#DP_Total_LResult").html("패");
                  $("#DP_Total_RResult").html("승");     
                  //좌측승(팝업 트로피표시)
                  $("#DP_LWinTitle").attr("class","");      
                  $("#DP_RWinTitle").attr("class","win");
                }
                else{
                  //동승률일때 점수비교
                  if( Number(myArr[0].LeftJumsu) > Number(myArr[0].RightJumsu) ){
                    $("#DP_Total_LResult").html("승");
                    $("#DP_Total_RResult").html("패");   

                    $("#DP_LWinTitle").attr("class","win");
                    $("#DP_RWinTitle").attr("class","");                    

                  }
                  else if( Number(myArr[0].LeftJumsu) < Number(myArr[0].RightJumsu) ){
                    $("#DP_Total_LResult").html("패");
                    $("#DP_Total_RResult").html("승");

                    $("#DP_LWinTitle").attr("class","");      
                    $("#DP_RWinTitle").attr("class","win");                   
                  }

                }
                
              //}

              //각 승리카운트
              localStorage.setItem("LeftWinCnt", myArr[0].LeftWinCnt);
              localStorage.setItem("RightWinCnt", myArr[0].RightWinCnt);

              //각 점수합산
              localStorage.setItem("LeftJumsu", myArr[0].LeftJumsu);
              localStorage.setItem("RightJumsu", myArr[0].RightJumsu);
              
              if ( myArr[0].LeftWinCnt == myArr[0].RightWinCnt)
              {
                if(myArr[0].LeftJumsu == myArr[0].RightJumsu){
                  //동점입니다 창
                  $("#btn_groupcomplete").attr("data-target","#same-score-modal");
                }
                else{
                  //경기등록 확인창
                  $("#btn_groupcomplete").attr("data-target","#result-save-modal");                 
                }
                  
              }
              else{
                  //경기등록 확인창
                  $("#btn_groupcomplete").attr("data-target","#result-save-modal");
              }
            

              
            } 
            else{

            }
      
            defer.resolve(sdata);
          },
          error: function (errorText) {
            defer.reject(errorText);
          }
      
          
      });
      return defer.promise();   
    }
    //E:학교VS학교 점수및 결과가져오기

    //S:대전선수명 및 승자 가져오기
    var loadwinresult=function(strPlayerGameNum){
        var defer = $.Deferred();
    
        var obj = {};
    
        obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");
        obj.GroupGameNum = localStorage.getItem("GroupGameNum");
        obj.PlayerGameNum = strPlayerGameNum;
    
        var jsonData = JSON.stringify(obj);

        console.log("3_j:" + jsonData);
    
        var events = "";

				$("#DP_L_GameResult").find("option").remove();
				$("#DP_R_GameResult").find("option").remove();
    
        $.ajax({
            url: '/ajax/tennis_os/GGameWinResult.ashx',
            type: 'post',
            data: jsonData,
            success: function (sdata) {

                    console.log("3_s:" + sdata);
              
              var myArr = JSON.parse(sdata);
    
    
              if (myArr.length > 0){

								$("#DP_Edit_LPlayer").attr("class","player-name");
								$("#DP_Edit_RPlayer").attr("class","player-name");
                  
                //modal 선수명 표시
                $("#DP_Edit_LPlayer").html(myArr[0].LPlayerName);
                $("#DP_Edit_RPlayer").html(myArr[0].RPlayerName);


                //판정판 초기화
                $("#DP_L_sd019005").attr("class","");
                $("#DP_L_sd019013").attr("class","");
                $("#DP_L_sd019006").attr("class","");
                $("#DP_R_sd019005").attr("class","");
                $("#DP_R_sd019013").attr("class","");
                $("#DP_R_sd019006").attr("class","");

                if(myArr[0].LResult != ""){
                  //승리자 트로피표시
                  $("#DP_Edit_LPlayer").attr("class","player-name disp-win");
                  //상단 승리표시
                  $("#DP_Win_Title").html(myArr[0].LResult);
                  //반칙승,부전승 체크표시
                  //$("#DP_L_" + myArr[0].LPlayerResult).attr("class","on");

                  //좌측선수 반칙,실격,부전/기권 승 selected
                  if(myArr[0].LPlayerResult == "sd019005" || myArr[0].LPlayerResult == "sd019013" || myArr[0].LPlayerResult == "sd019006" || myArr[0].LPlayerResult == "sd019022" || myArr[0].LPlayerResult == "sd019025" || myArr[0].LPlayerResult == "sd019026"){
                    $("#DP_L_GameResult").append("<option value='"+ myArr[0].LPlayerResult +"'>"+ myArr[0].LResult +"</option>");
                  }
                  else{
                    $("#DP_L_GameResult").append("<option value=''>"+ "-" +"</option>");
                  }

									if(myArr[0].LPlayerResult == "sd019012" || myArr[0].RPlayerResult == "sd019021")
									{
										$("#DP_Edit_LPlayer").attr("class","player-name");
									}

                }
                else{
									$("#DP_L_GameResult").append("<option value=''>"+ "-" +"</option>");
                  $("#DP_Edit_LPlayer").attr("class","player-name");
                }

                if(myArr[0].RResult != ""){
                  //승리자 트로피표시
                  $("#DP_Edit_RPlayer").attr("class","player-name disp-win");
                  //상단 승리표시
                  $("#DP_Win_Title").html(myArr[0].RResult);
                  //반칙승,부전승 체크표시
                  //$("#DP_R_" + myArr[0].RPlayerResult).attr("class","on");

                  //좌측선수 반칙,실격,부전/기권 승 selected
                  if(myArr[0].RPlayerResult == "sd019005" || myArr[0].RPlayerResult == "sd019013" || myArr[0].RPlayerResult == "sd019006" || myArr[0].RPlayerResult == "sd019022" || myArr[0].RPlayerResult == "sd019025" || myArr[0].RPlayerResult == "sd019026"){
                    $("#DP_R_GameResult").append("<option value='"+ myArr[0].RPlayerResult +"'>"+ myArr[0].RResult +"</option>");
                  }
                  else{
                    $("#DP_R_GameResult").append("<option value=''>"+ "-" +"</option>");
                  }

									if(myArr[0].RPlayerResult == "sd019012" || myArr[0].RPlayerResult == "sd019021")
									{
										$("#DP_Edit_RPlayer").attr("class","player-name");
									}

                }
                else{
                  $("#DP_R_GameResult").append("<option value=''>"+ "-" +"</option>");
                  $("#DP_Edit_RPlayer").attr("class","player-name");
                }


              } 
              
              else {
                  $("#DP_L_GameResult").append("<option value=''>"+ "-" +"</option>");
                  $("#DP_Edit_LPlayer").attr("class","player-name");                
                  $("#DP_R_GameResult").append("<option value=''>"+ "-" +"</option>");
                  $("#DP_Edit_RPlayer").attr("class","player-name");

                  $("#DP_Edit_LPlayer").html("불참자");
                  $("#DP_Edit_RPlayer").html("불참자");
              }
    
              defer.resolve(sdata);
            },
            error: function (errorText) {
              defer.reject(errorText);
            }
        });
        return defer.promise();
    }
    //E:해당 대전선수명 및 승자 가져오기

        //E:유도 경기로그 가져오기


        //S:현재점수 가져오기
        function nowscore(){

          var defer = $.Deferred();

          var obj = {};

          obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");
          obj.GroupGameNum = localStorage.getItem("GroupGameNum");
          obj.PlayerGameNum = localStorage.getItem("PlayerGameNum");

          var jsonData = JSON.stringify(obj);

          var events = "";

          $.ajax({
            url: '/ajax/tennis_os/GGameNowScore.ashx',
            type: 'post',
            data: jsonData,
            success: function (sdata) {
              
              var myArr = JSON.parse(sdata);

              if (myArr.length > 0){

                  if (myArr[0].Left01 != "")
                  {
                    $("#LJumsuGb1").html(myArr[0].Left01);
                    $("#LJumsuGb2").html(myArr[0].Left02);
                    //$("#LJumsuGb3").html(myArr[0].Left03);
                    $("#LJumsuGb4").html(myArr[0].Left04);
                    $("#RJumsuGb1").html(myArr[0].Right01);
                    $("#RJumsuGb2").html(myArr[0].Right02);
                    $("#RJumsuGb3").html(myArr[0].Right03);
                    $("#RJumsuGb4").html(myArr[0].Right04);
                  }
                  else{
                    $("#LJumsuGb1").html("0");
                    $("#LJumsuGb2").html("0");
                    //$("#LJumsuGb3").html("0");
                    $("#LJumsuGb4").html("0");
                    $("#RJumsuGb1").html("0");
                    $("#RJumsuGb2").html("0");
                    $("#RJumsuGb3").html("0");
                    $("#RJumsuGb4").html("0");               
                  }


              } 
              else {
                    
                $("#LJumsuGb1").html("0");
                $("#LJumsuGb2").html("0");
                //$("#LJumsuGb3").html("0");
                $("#LJumsuGb4").html("0");
                $("#RJumsuGb1").html("0");
                $("#RJumsuGb2").html("0");
                $("#RJumsuGb3").html("0");
                $("#RJumsuGb4").html("0");
                
              }

              defer.resolve(sdata);
            },
            error: function (errorText) {
              defer.reject(errorText);
            }
          });
            return defer.promise();     

        }
        //E:현재점수 가져오기

    //S:유도 경기로그 가져오기
    function loadplaylog(strPlayerGameNum){
        var defer = $.Deferred();

        var obj = {};

        obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");
        obj.GroupGameNum = localStorage.getItem("GroupGameNum");
        obj.PlayerGameNum = strPlayerGameNum;
        

        var jsonData = JSON.stringify(obj);

        var events = "";

        //승리한 선수가 있다면..
        

        $.ajax({
            url: '/ajax/tennis_os/tblGameResultDtlSelect.ashx',
            type: 'post',
            data: jsonData,
            success: function (sdata) {      
            


              var myArr = JSON.parse(sdata);


              if (myArr.length > 0){
                
                var strplaylog = "";

                for (var i = 0; i < myArr.length; i++)
                {

                  if(myArr[i].PlayerPosition == "LPlayer"){
                    if (myArr[i].JumsuGb == "")
                    {
                      strplaylog += "<li class='opponent recent'>";                        
                    }
                    else
                    {
                      strplaylog += "<li class='opponent'>";                        
                    }

                  }
                  else{
                    if (myArr[i].JumsuGb == "")
                    {
                      strplaylog += "<li class='mine recent'>";                        
                    }
                    else
                    {
                      strplaylog += "<li class='mine'>";
                    }
                  }
                  
                  strplaylog += "[<span class='record-time'>";

                  if(myArr[i].OverTime == "1"){
                    strplaylog +="(연장)"
                  }

                  strplaylog += myArr[i].CheckTime + "</span>]<span class='record-type'>" + myArr[i].PlayerName + "</span>:";
                  strplaylog += "";

                  if (myArr[i].JumsuGb == "지도")
                  {
                    strplaylog += ": <span class='skill'>" + myArr[i].JumsuGb +  "</span>";
                  }
                  else{
                    strplaylog += ": <span class='skill'>" + myArr[i].JumsuGb +  " " + myArr[i].SpecialtyGb + "</span>(<span class='skill'>" + myArr[i].SpecialtyDtl + "</span>)";
                  }
                  
                  strplaylog += "</li>";

                }                   

                $("#DP_result-list").html(strplaylog);


              } else {
                
                $("#DP_result-list").html("");
              }

              defer.resolve(sdata);
            },
            error: function (errorText) {
              defer.reject(errorText);
            }
        });
        return defer.promise();
    }

    //E:유도 경기로그 가져오기

    //S:스코어 수정버튼 눌렀을 시..
    function editscore(objbtn){

      //몇라운드인지 담기
      localStorage.setItem("PlayerGameNum",objbtn.getAttribute("data-id"));
      //라운드 depth 담기(몇번째 강인지..)
      localStorage.setItem("PlayRound",objbtn.getAttribute("data-whatever"));

      //현재점수가져오기
      nowscore(objbtn.getAttribute("data-id"));

      //선수 & 승자가져오기
      loadwinresult(objbtn.getAttribute("data-id"));

      //현재 양측 부전패,무승부인지
      nowdualresult(objbtn.getAttribute("data-id"));

      //경기로그 가져오기
      loadplaylog(objbtn.getAttribute("data-id"));
    }

    //스코어등록 화면 이동
    var mov_enterscore = function(obj){

    
      //몇라운드인지 담기


      localStorage.setItem("PlayerGameNum",obj.getAttribute("data-id"));
      //라운드 depth 담기(몇번째 강인지..)
      //localStorage.setItem("GroupRound",obj.getAttribute("data-whatever"));

        location.href="enter-score.html";       
      

    }

    //S:양선수 부전패, 무승부 판정 가져오기
    function nowdualresult(strPlayerGameNum){

      var defer = $.Deferred();

      var obj = {};

      obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");
      obj.GroupGameNum = localStorage.getItem("GroupGameNum");
      obj.PlayerGameNum = strPlayerGameNum;

      var jsonData = JSON.stringify(obj);

      var events = "";

      $.ajax({
        url: '/ajax/tennis_os/GGameDualResultList.ashx',
        type: 'post',
        data: jsonData,
        success: function (sdata) {

      

          var myArr = JSON.parse(sdata);

          if (myArr.length > 0){

                //양선수 부전패라면..
                if (myArr[0].LPlayerResult == "sd019012")
                {
                  $("#LRResult_Lose").attr("class", "tgClass default on");

                  if(localStorage.getItem("GroupGameGb") == "sd040001")
                  {
                    $("#LRResult_Draw").attr("class", "tgClass no-attend");
                  }
                  else
                  {
                    $("#LRResult_Draw").attr("class", "tgClass draw");
                  }

                  //양선수 이름상단 (패)로 표기
                  $("#DP_Edit_LPlayer").attr("class","player-name");
                  $("#DP_Edit_RPlayer").attr("class","player-name");

                }
                //무승부(단체전)라면..
                else if (myArr[0].LPlayerResult == "sd019024")
                {

                  $("#LRResult_Lose").attr("class", "tgClass default");
                  $("#LRResult_Draw").attr("class", "tgClass draw on");    
									
                  //양선수 이름상단 (패)로 표기
                  $("#DP_Edit_LPlayer").attr("class","player-name");
                  $("#DP_Edit_RPlayer").attr("class","player-name");


                }
                //불참(단체전)라면..
                else if (myArr[0].LPlayerResult == "sd019021")
                {
                  $("#LRResult_Lose").attr("class", "tgClass default");
                  $("#LRResult_Draw").attr("class", "tgClass no-attend on");            

                  $("#DP_Edit_LPlayer").attr("class","player-name");
                  $("#DP_Edit_RPlayer").attr("class","player-name");
                }
                else{
                  $("#LRResult_Lose").attr("class", "tgClass default");
                  $("#LRResult_Draw").attr("class", "tgClass no-attend");                 
                }
          } 
          else {
                
            $("#LRResult_Lose").attr("class", "tgClass default");
            $("#LRResult_Draw").attr("class", "tgClass no-attend");               
            
          }

          defer.resolve(sdata);
        },
        error: function (errorText) {
          defer.reject(errorText);
        }
      });
        return defer.promise();     

    }
    //E:양선수 부전패, 무승부 판정 가져오기

    //S:해당 경기번호의 출전가능 소속 conunt
    function groupcntcheck(){
      var defer = $.Deferred();

      var obj = {};

      obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");
      obj.GroupGameNum = localStorage.getItem("GroupGameNum");

      var jsonData = JSON.stringify(obj);

      var events = "";

      $.ajax({
        url: '/ajax/tennis_os/GGameGroupCntCheck.ashx',
        type: 'post',
        data: jsonData,
        async:false,
        success: function (sdata1) {

          var myArr1 = JSON.parse(sdata1);
        
          defer.resolve(sdata1);
        },
        error: function (errorText) {
          defer.reject(errorText);
        }
      });
        return defer.promise();           
    }
    //S:해당 경기번호의 출전가능 소속 conunt

    //S:해당경기 정보가져오기
    function loadgametitle(){
      var defer = $.Deferred();

      var obj = {};

        obj.GameTitleIDX = localStorage.getItem("GameTitleIDX");
        obj.TeamGb = localStorage.getItem("TeamGb");
        obj.Sex = localStorage.getItem("Sex");
        obj.Level = localStorage.getItem("Level");
        obj.GroupGameGb = localStorage.getItem("GroupGameGb");
        obj.PlayerGameNum = localStorage.getItem("PlayerGameNum");
        obj.SportsGb = localStorage.getItem("SportsGb");
        obj.GroupGameNum = localStorage.getItem("GroupGameNum");

      var jsonData = JSON.stringify(obj);


      console.log("gametitle:" + jsonData);

      var events = "";

      $.ajax({
        url: '/ajax/tennis_os/GGameTitle.ashx',
        type: 'post',
        data: jsonData,
        async:false,
        success: function (sdata) {

        

          var myArr = JSON.parse(sdata);

          if (myArr.length > 0){

            //타이틀

						if(myArr[0].GameTitleName.length > 25){
							$("#DP_play-title").html("<font size='3'>" + myArr[0].GameTitleName + "</font>");								
						}
						else{
						  $("#DP_play-title").html(myArr[0].GameTitleName);																
						}

            //개인전
            $("#DP_play-division").html(myArr[0].GroupGameGbName);
            //고등학교
            $("#DP_play-belong").html(myArr[0].TeamGbName);
            //남자
            $("#DP_play-type").html(myArr[0].SexName);
            //16강
            $("#DP_play-round").html(myArr[0].TotRoundName + "강");
            //라운드
            $("#DP_play-num").html(localStorage.getItem("GroupGameNum") + "경기");

            //경기장 번호 체크
						
            if (myArr[0].Tmp_StadiumNumber != "")
            {
              //$("#LB_GYM" + myArr[0].StadiumNumber).attr("class","on");
              $.each($("label[name='LB_GYM']"), function() {
                if ($(this).attr("data-id") == myArr[0].Tmp_StadiumNumber)
                {
                  $(this).attr("class","on");
                }
                else{
                  $(this).attr("class","");
                }
              });
            }
						

            localStorage.setItem("EntryCnt",myArr[0].EntryCnt);
            localStorage.setItem("RGameLevelidx",myArr[0].RGameLevelidx);
            localStorage.setItem("GameType",myArr[0].GameType);
            

          }
          else{
            localStorage.setItem("GameType","");
            alert('진행 중인 경기 정보가 없습니다.');
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

  
    function clickBackbtn(){

      localStorage.setItem("BackPage","enter-score");
      location.href='RGameList.html';
    }


    //E:등록했던 단체전 선수 불러오기
    </script>
  </head>
  <body>
    <!-- S: header -->
    <div class="header container-fluid">
      <div class="row">
        <div class="pull-left">
          <a onclick="clickBackbtn();" role="button" class="prev-btn"><span class="icon-prev"><i class="fa fa-angle-left" aria-hidden="true"></i></span>단체전 입력</a>
        </div>
        <div>
         <h1 class="logo">
          <img src="images/tournerment/header/judo-logo.png" alt="대한유도회">
        </h1>
        </div>
        <div class="pull-right">
          <span class="sd-logo">
            <img src="images/tournerment/header/logo@3x.png" alt="스포츠 다이어리" width="100">
          </span>
          <a href="index.html" role="button" class="home-link"><span class="icon-home"><i class="fa fa-home" aria-hidden="true"></i></span></a>
        </div>
      </div>
    </div>
    <!-- E: header -->

   <!-- S : bg-black -->
   <div class="bg-black">

    <!-- S: main -->
    <div class="main enter-group container-fluid">
      <!-- S: score-enter -->
      <div class="score-enter row">
          <!-- S: dl 날짜/대회명/대회구분 -->
          <dl class="selected-list">
            <dt>
              <p><label for="gym1" id="LB_GYM1" name="LB_GYM" data-id="1"><input type="checkbox" id="gym1" name="StadiumNumber" value="1"/> <span>1경기장</span></label></p>
              <p><label for="gym2" id="LB_GYM2" name="LB_GYM" data-id="2"><input type="checkbox" id="gym2" name="StadiumNumber" value="2"/> <span>2경기장</span></label></p>
              <p><label for="gym3" id="LB_GYM3" name="LB_GYM" data-id="3"><input type="checkbox" id="gym3" name="StadiumNumber" value="3"/> <span>3경기장</span></label></p>
              <p><label for="gym4" id="LB_GYM4" name="LB_GYM" data-id="4"><input type="checkbox" id="gym4" name="StadiumNumber" value="4"/> <span>4경기장</span></label></p>
              <p><label for="gym5" id="LB_GYM5" name="LB_GYM" data-id="5"><input type="checkbox" id="gym5" name="StadiumNumber" value="5"/> <span>5경기장</span></label></p>
              <p><label for="gym6" id="LB_GYM6" name="LB_GYM" data-id="6"><input type="checkbox" id="gym6" name="StadiumNumber" value="6"/> <span>6경기장</span></label></p>
            </dt>
            <dd><span id="DP_play-num">1경기</span> / <span id="DP_play-round">64강</span></dd>
            <dd class="play-division" id="DP_play-division">단체전</dd>
            <dd class="play-belong" id="DP_play-belong">고등부</dd>
            <dd class="play-type" id="DP_play-type">남자</dd>
            <!-- <dd class="play-weight" id="DP_play-weight">-66kg</dd> -->
            <dd class="play-title" id="DP_play-title">제9회 청풍기 전국유도대회</dd>
          </dl>
          <!-- E: dl 날짜/대회명/대회구분 -->

          <!-- S : inner -->
          <div class="inner">

                <!-- S : top-navi-list -->
                <div class="top-navi-list">
                  <ul class="top-navi-1">
                    <li id="DP_player-school_Up2"><!--우석고등학교--></li>
                    <li class="top-navi-btn">
                        <a href="#" role="button" class="btn btn-enter-player" data-whatever="splayerModal" id="btn_playerModal">출전선수 등록하기</a>
                        <a href="#" role="button" class="btn btn-add-match" data-whatever="splayerModal" id="btn_addplayerModal">연장경기 추가하기</a>
                    </li>
                    <li id="DP_player-school_Down2"><!--송도고등학교--></li>
                  </ul>
                  <ul class="top-navi-2">
                    <li class="player-name">선수명</li>
                    <li>체급항목</li>
                    <li>승패</li>
                    <li class="score-num">점수</li>
                    <li class="btn-score-modify">기술명(득실점 내역)</li>
                    <li class="score-num">점수</li>
                    <li>승패</li>
                    <li>체급항목</li>
                    <li class="player-name">선수명</li>
                  </ul>
                </div>
                <!-- E : top-navi-list -->

                <!-- S : 선수별 경기 내역 표시 
                  <div class="list-score-wrap"> : 스크롤 없는 버전
                  <div class="list-score-scroll"> : 스크롤 있는 버전
                  타블렛에서 확인하면 스크롤이 깨지지 않고 보입니다.
                  table 내용은 11줄이 기본으로 노출됩니다.
                -->
                <div class="list-score-scroll">
                    <div class="list-score" id="grouplist">
                      <!--
                      <ul>
                        <li>
                          <select name="" id="">
                            <option value="" selected>배동현이</option>
                            <option value="">서현영</option>
                            <option value="">전도원</option>
                            <option value="">임정열</option>
                            <option value="">전홍민</option>
                            <option value="">유지민</option>
                            <option value="">이승규</option>
                          </select>
                        </li>
                        <li>
                          -63kg
                        </li>
                        <li>
                          <span class="result">승</span>(<span class="play-result">지도승</span>)
                        </li>
                        <li>
                          <span>3</span>
                        </li>
                        <li>
                          <span>기타 누으며 메치기</span>
                        </li>
                        <li>
                          <a href="enter-score.html" role="button" class="btn btn-repair-write">스코어 입력 <i class="fa fa-angle-right" aria-hidden="true"></i></a>
                        </li>
                        <li>
                          <span></span>
                        </li>
                        <li>
                          <span>-</span>
                        </li>
                        <li>
                          <span class="result">패</span>(<span class="play-result">지도패</span>)
                        </li>
                        <li>
                          -63kg
                        </li>
                        <li>
                          <select name="">
                            <option value="">최종민</option>
                            <option value="" selected>윤동열</option>
                            <option value="">조규민</option>
                            <option value="">강지용</option>
                            <option value="">이종우</option>
                            <option value="">남대우</option>
                            <option value="">이경한</option>
                          </select>
                        </li>
                      </ul>
                      
                      <ul>
                        <li>
                          <select name="" id="">
                            <option value="" selected>배동현</option>
                            <option value="">서현영</option>
                            <option value="">전도원</option>
                            <option value="">임정열</option>
                            <option value="">전홍민</option>
                            <option value="">유지민</option>
                            <option value="">이승규</option>
                          </select>
                        </li>
                        <li>
                          -63kg
                        </li>
                        <li>
                          <span class="result">승</span>(<span class="play-result">지도승</span>)
                        </li>
                        <li>
                          <span>3</span>
                        </li>
                        <li>
                          <span>기타 누으며 메치기</span>
                        </li>
                        <li>
                          <a href="enter-score.html" role="button" class="btn btn-repair">스코어 수정 <i class="fa fa-angle-right" aria-hidden="true"></i></a>
                        </li>
                        <li>
                          <span></span>
                        </li>
                        <li>
                          <span>-</span>
                        </li>
                        <li>
                          <span class="result">패</span>(<span class="play-result">지도패</span>)
                        </li>
                        <li>
                          -63kg
                        </li>
                        <li>
                          <select name="">
                            <option value="">최종민</option>
                            <option value="" selected>윤동열</option>
                            <option value="">조규민</option>
                            <option value="">강지용</option>
                            <option value="">이종우</option>
                            <option value="">남대우</option>
                            <option value="">이경한</option>
                          </select>
                        </li>
                      </ul>
                      -->
                      <ul>
                        <li>
                          
                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                      </ul>
                      <ul>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                      </ul>
                      <ul>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                      </ul>
                      <ul>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                      </ul>
                      <ul>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                      </ul>
                      <ul>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                      </ul>
                      <ul>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                      </ul>
                      <ul>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                      </ul>
                      <ul>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                      </ul>
                      <ul>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                      </ul>
                      <ul>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                        <li>

                        </li>
                      </ul>
                    </div>
                </div>
                <!-- E : 선수별 경기 내역 표시 -->

                <!-- S : 등록하기-->
                <div class="score-btm-save" id="div_groupresult" style="display:block">
                  <!-- 출전선수 등록 이전 페이지에선 이 부분을 감춰주세요-->
                  <span id="span_groupresultbtn" style="display:block">
                  <p>양측 소속이 모두 불참 하였을 시, 무승부 및 부전패 처리</p>

                  <a onclick="complete_Result('sd019006','L');" class="btn btn-save-btm" id="btn_leftwin">좌측팀 부전승</a>
                  <a onclick="complete_dualResult('sd019012');" class="btn btn-save-btm" id="btn_duallose">양측 부전패</a>
                  <a onclick="complete_dualResult('sd019024');" class="btn btn-cancel-btm" id="btn_dualdraw">양측 무승부</a>
                  <a onclick="complete_Result('sd019006','R');" class="btn btn-save-btm" id="btn_rightwin">우측팀 부전승</a>
                  </span>
                  <!-- 출전선수 등록 이전 페이지에선 이 부분을 감춰주세요-->
                </div>

                <div class="score-btm-save" id="div_playerorder" style="display:none">
                  <!-- 출전선수 등록 이전 페이지에선 이 부분을 감춰주세요-->
                  <span id="span_playerorder" style="display:none">
                  <p>출전선수의 명단 순서가 맞으면 등록완료 버튼을 눌러주시기 바랍니다.</p>
                  <a href="#" class="btn btn-save-btm" data-toggle="modal" data-target="#save-modal" data-whatever="saveModal" id="btn_saveModal">등록완료</a>
                  <a href="#" class="btn btn-cancel-btm" id="btn_resaveModal">다시 등록하기</a>
                  </span>
                  <!-- 출전선수 등록 이전 페이지에선 이 부분을 감춰주세요-->
                </div>
                <!-- E : 등록하기 -->

                <!-- S : 결과 저장하기 -->
                <div class="score-result-save" id="div_resultsave" style="display:none">
                  <ul>
                    <li>
                      <span>결과</span>
                    </li>
                    <li id="DP_Total_LResult">
                      -<!--승-->
                    </li>
                    <li>
                      <span class="point-sum" id="DP_Total_LJumsu">-<!--27.5--></span>
                    </li>
                    <li>
                      <a href="#" class="btn btn-save" data-toggle="modal" data-target="#result-save-modal" id="btn_groupcomplete">기록완료</a>
                    </li>
                    <li>
                      <span class="point-sum" id="DP_Total_RJumsu">-<!--10--></span>
                    </li>
                    <li id="DP_Total_RResult">
                      -<!--패-->
                    </li>
                    <li>
                      <span>결과</span>
                    </li>
                  </ul>
                </div>
                <!-- E : 결과 저장하기 -->

                <!-- S: sign-list -->
                <ul class="sign-list group-play clearfix" id="div_signature" style="display:none">
                  <li class="chief">
                    <span class="judge">주심</span>
                    <span class="sign-mark" id="chiefSign_copy"></span>
                    <button class="btn btn-accept" data-toggle="modal" data-target="#sign-modal" data-whatever="chiefSign" id="btn_chiefSign" style="display:block">승인하기 <span class="icon"><i class="fa fa-angle-right" aria-hidden="true"></i></span></button>
                    <span class="accept-end" id="result_chiefSign" style="display:none"><span class="icon"><i class="fa fa-check" aria-hidden="true"></i></span>승인완료</span>
                  </li>
                  <li class="assistant">
                    <span class="judge">부심</span>
                    <span class="sign-mark" id="asschiefSign1_copy"></span>
                    <button class="btn btn-accept" data-toggle="modal" data-target="#sign-modal" data-whatever="asschiefSign1" id="btn_asschiefSign1" style="display:block">승인하기 <span class="icon"><i class="fa fa-angle-right" aria-hidden="true"></i></span></button>
                    <span class="accept-end" id="result_asschiefSign1" style="display:none"><span class="icon"><i class="fa fa-check" aria-hidden="true" ></i></span>승인완료</span>
                  </li>
                  <li class="assistant">
                    <span class="judge">부심</span>
                    <span class="sign-mark" id="asschiefSign2_copy"></span>
                    <button class="btn btn-accept" data-toggle="modal" data-target="#sign-modal" data-whatever="asschiefSign2" id="btn_asschiefSign2" style="display:block">승인하기 <span class="icon"><i class="fa fa-angle-right" aria-hidden="true"></i></span></button>
                    <span class="accept-end" id="result_asschiefSign2" style="display:none"><span class="icon"><i class="fa fa-check" aria-hidden="true"></i></span>승인완료</span>
                  </li>
                </ul>

                <!-- E: sign-list -->
            </div>
            <!-- E: score-enter -->

          </div>
          <!-- E : inner -->
   </div>
   <!-- E : bg-black -->

      <!-- S: 사인 모달 modal -->
      <div class="modal fade" id="sign-modal" tabindex="-1" role="dialog" aria-labelledby="sign-modal-title" aria-hidden="true">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header sign-modal-header">
              <!-- <button type="button" class="close" data-dismiss="modal" aria-label="close"><span aria-hidden="true"><i class="fa fa-times" aria-hidden="true"></i></span></button> -->
              <h3 class="modal-title" id="sign-modal-title">승인하기</h3>
            </div>
            <div class="modal-body sign-modal-body">
              

              <!-- 여기에 입력해 주세요. -->
               <canvas id="game_signature" width="570" height="250" data-id="">
               </canvas>
              <!-- 여기에 입력해 주세요. -->


            </div>
            <div class="modal-footer sign-modal-footer">
              <a href="#" role="button" class="btn btn-repair" id="signature_copy">저장하기</a>
              <a href="#" role="button" class="btn btn-close" data-dismiss="modal">닫기</a>
            </div>

          </div> <!-- ./ modal-content -->
        </div> <!-- ./modal-dialog -->
      </div>
      <!-- E: 사인 모달 modal -->

      <!-- S: 저장하기 모달 modal -->
      <div class="modal fade" id="save-modal" tabindex="-1" role="dialog" aria-labelledby="save-modal-title" aria-hidden="true">
        <div class="modal-dialog">
          <div class="modal-content modal-small">
            <div class="modal-body">
            <!-- 텍스트와 하단 버튼 -->
              <div class="modal-txt-wrap">
                <p class="modal-txt">본 경기 순서대로 등록하시겠습니까?</p>
                <a onclick="insert_playerlist();" role="button" class="btn btn-modal-yes">예</a>
                <a href="#" role="button" class="btn btn-modal-no" data-dismiss="modal">아니요</a>
              </div>
            </div>
            <!-- 텍스트와 하단 버튼 -->
          </div> <!-- ./ modal-content -->
        </div> <!-- ./modal-dialog -->
      </div>
      <!-- E: 저장하기 모달 modal -->

      <!-- S: 동점 모달 modal -->
      
      <div class="modal fade" id="same-score-modal" tabindex="-1" role="dialog" aria-labelledby="same-score-modal-title" aria-hidden="true">
        <div class="modal-dialog">
          <div class="modal-content modal-small">
            <div class="modal-body">
              <!-- 동점 -->
              <div class="same-score">
                <ul>
                  <li>
                    우석고등학교<br />
                    <span>4승4패(25점)</span>
                  </li>
                  <li>VS</li>
                  <li>
                    송도고등학교<br />
                    <span>4승4패(25점)</span>
                  </li>
                </ul>
                <p>동점입니다.<br />
                연장경기를 추가해주시기 바랍니다.</p>
                <a href="#" role="button" class="btn btn-modal-close" data-dismiss="modal">확인</a>
              </div>
              <!-- 동점 -->
            </div>
          </div> <!-- ./ modal-content -->
        </div> <!-- ./modal-dialog -->
      </div>
      <!-- E: 동점 모달 modal -->

      <script>
        //S:경기완료
        function complete_groupgame(){

          var defer = $.Deferred();

          var obj = {};


          obj.GameTitleIDX = localStorage.getItem("GameTitleIDX");
          obj.TeamGb = localStorage.getItem("TeamGb");
          obj.Sex = localStorage.getItem("Sex");
          obj.GroupGameNum = localStorage.getItem("GroupGameNum");
          obj.SportsGb = localStorage.getItem("SportsGb");
          obj.GroupRound = localStorage.getItem("GroupRound");
          obj.GroupGameGb = localStorage.getItem("GroupGameGb");
          obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");

          obj.LTeam = localStorage.getItem("LTeam");
          obj.LTeamDtl = localStorage.getItem("LTeamDtl");
          obj.RTeam = localStorage.getItem("RTeam");
          obj.RTeamDtl = localStorage.getItem("RTeamDtl");

          //선택된 경기장
          $.each($("label[name='LB_GYM']"), function() {
            if ($(this).attr("class") == "on")
            {
              obj.StadiumNumber = $(this).attr("data-id");
            }
          });


					if(!obj.StadiumNumber){
						alert("해당경기의 경기장을 선택하세요.");
						return;
					}


          if(Number(localStorage.getItem("LeftWinCnt")) > Number(localStorage.getItem("RightWinCnt"))){
            obj.LResult = "sd044001";
            obj.RResult = "";
          }
          else if(Number(localStorage.getItem("LeftWinCnt")) < Number(localStorage.getItem("RightWinCnt"))){
            obj.LResult = "";
            obj.RResult = "sd044001"; 
          }
          else{

            if( Number(localStorage.getItem("LeftJumsu")) > Number(localStorage.getItem("RightJumsu")) ){
              obj.LResult = "sd044001";
              obj.RResult = "";   
            }
            else if( Number(localStorage.getItem("LeftJumsu")) < Number(localStorage.getItem("RightJumsu")) ){
              obj.LResult = "";
              obj.RResult = "sd044001";     
            }
            else{
              alert('동점입니다. 연장경기를 추가해 주시기 바랍니다.');
              return;
            }
          
          }

          obj.LJumsu = localStorage.getItem("LeftJumsu");
          obj.RJumsu = localStorage.getItem("RightJumsu");

          obj.GameType = localStorage.getItem("GameType");

          obj.LSchNum = localStorage.getItem("LSchNum");
          obj.RSchNum = localStorage.getItem("RSchNum");

          var jsonData = JSON.stringify(obj);



          $.ajax({
              url: '/ajax/tennis_os/GGameRGameGroupInsert.ashx',
              type: 'post',
              data: jsonData,
              success: function (sdata) {

                console.log(sdata);
              

                localStorage.setItem("BackPage","enter-score");
                location.href='RgameList.html';
                /*
                var myArr = JSON.parse(sdata);

                if (myArr.length > 0){
                  
                } 
                
                else {
                  
                }
                */

                defer.resolve(sdata);
              },
              error: function (errorText) {
                defer.reject(errorText);
              }

          });
          return defer.promise();

        }
        //S:경기완료

        //S:양측무승부, 양측부전패
        function complete_dualResult(strResult){
          
          //sd019012 : 부전패
          //sd019024 : 무승부
          var defer = $.Deferred();

          var obj = {};

          obj.GameTitleIDX = localStorage.getItem("GameTitleIDX");
          obj.TeamGb = localStorage.getItem("TeamGb");
          obj.Sex = localStorage.getItem("Sex");
          obj.GroupGameNum = localStorage.getItem("GroupGameNum");
          obj.SportsGb = localStorage.getItem("SportsGb");
          obj.GroupRound = localStorage.getItem("GroupRound");
          obj.GroupGameGb = localStorage.getItem("GroupGameGb");
          obj.RGameLevelidx =   localStorage.getItem("RGameLevelidx");

          obj.LTeam = localStorage.getItem("LTeam");
          obj.LTeamDtl = localStorage.getItem("LTeamDtl");
          obj.RTeam = localStorage.getItem("RTeam");
          obj.RTeamDtl = localStorage.getItem("RTeamDtl");

          obj.LResult = strResult;
          obj.RResult = strResult;  

          obj.LSchNum = localStorage.getItem("LSchNum");
          obj.RSchNum = localStorage.getItem("RSchNum");

          obj.GameType = localStorage.getItem("GameType");

          //선택된 경기장
          $.each($("label[name='LB_GYM']"), function() {
            if ($(this).attr("class") == "on")
            {
              obj.StadiumNumber = $(this).attr("data-id");
              //alert($(this).attr("data-id"));
            }
          });

          var strMsg = "";

          if (strResult == "sd019012")
          {
            strMsg = "양측 부전패";
          }
          else if (strResult == "sd019024"){
            strMsg = "양측 무승부";          
          }

          if(!confirm("해당 단체전 경기를 " + strMsg + " 처리합니다. 동의하시면 확인버튼을 눌러주세요.")){
            return;
          }

          var jsonData = JSON.stringify(obj);



          $.ajax({
              url: '/ajax/tennis_os/GGameRGameGroupInsert.ashx',
              type: 'post',
              data: jsonData,
              success: function (sdata) {

                localStorage.setItem("BackPage","enter-score");
                location.href='RgameList.html';
                /*
                var myArr = JSON.parse(sdata);

                if (myArr.length > 0){
                  
                } 
                
                else {
                  
                }
                */

                defer.resolve(sdata);
              },
              error: function (errorText) {
                defer.reject(errorText);
              }

          });
          return defer.promise();

        }
        //E:양측무승부, 양측부전패

        //S:양측무승부, 양측부전패
        function complete_Result(strResult, strLeftRight){
          
          //sd019012 : 부전패
          //sd019024 : 무승부
          var defer = $.Deferred();

          var obj = {};

          obj.GameTitleIDX = localStorage.getItem("GameTitleIDX");
          obj.TeamGb = localStorage.getItem("TeamGb");
          obj.Sex = localStorage.getItem("Sex");
          obj.GroupGameNum = localStorage.getItem("GroupGameNum");
          obj.SportsGb = localStorage.getItem("SportsGb");
          obj.GroupRound = localStorage.getItem("GroupRound");
          obj.GroupGameGb = localStorage.getItem("GroupGameGb");
          obj.RGameLevelidx =   localStorage.getItem("RGameLevelidx");

          obj.LTeam = localStorage.getItem("LTeam");
          obj.LTeamDtl = localStorage.getItem("LTeamDtl");
          obj.RTeam = localStorage.getItem("RTeam");
          obj.RTeamDtl = localStorage.getItem("RTeamDtl");

          if(strLeftRight == "L")
          {
            obj.LResult = strResult;
            obj.RResult = ""; 
          }
          else
          {
            obj.LResult = "";
            obj.RResult = strResult;            
          }

          //선택된 경기장
          $.each($("label[name='LB_GYM']"), function() {
            if ($(this).attr("class") == "on")
            {
              obj.StadiumNumber = $(this).attr("data-id");
              //alert($(this).attr("data-id"));
            }
          });

          obj.GameType = localStorage.getItem("GameType");

          obj.LSchNum = localStorage.getItem("LSchNum");
          obj.RSchNum = localStorage.getItem("RSchNum");

          var strMsg = "";

          if (strLeftRight == "L")
          {
            strMsg = "좌측 부전승";
          }
          else{
            strMsg = "우측 부전승";          
          }

          if(!confirm("해당 단체전 경기를 " + strMsg + " 처리합니다. 동의하시면 확인버튼을 눌러주세요.")){
            return;
          }

          var jsonData = JSON.stringify(obj);


          $.ajax({
              url: '/ajax/tennis_os/GGameRGameGroupInsert.ashx',
              type: 'post',
              data: jsonData,
              success: function (sdata) {
      
                console.log(sdata);
                
                localStorage.setItem("BackPage","enter-score");
                location.href='RgameList.html';
                /*
                var myArr = JSON.parse(sdata);

                if (myArr.length > 0){
                  
                } 
                
                else {
                  
                }
                */

                defer.resolve(sdata);
              },
              error: function (errorText) {
                defer.reject(errorText);
              }

          });
          return defer.promise();

        }
        //E:양측무승부, 양측부전패
      </script>

      <!-- S: 경기승패저장 모달 modal -->
      <div class="modal fade" id="result-save-modal" tabindex="-1" role="dialog" aria-labelledby="result-save-modal-title" aria-hidden="true">
        <div class="modal-dialog">
          <div class="modal-content modal-small">
            <div class="modal-body">
              <!-- 동점 -->
              <div class="save-score">
                <ul>
                  <li class="win" id="DP_LWinTitle">
                    <span id="DP_LSchoolName">우석고등학교</span><br />
                    <span id="DP_LResult">4승4패(25점)</span>
                  </li>
                  <li>VS</li>
                  <li id="DP_RWinTitle">
                    <span id="DP_RSchoolName">송도고등학교</span><br />
                    <span id="DP_RResult">4승4패(25점)</span>
                  </li>
                </ul>
                  <p id="DP_ModalMsg1">
                    남은 경기는 무승부 처리됩니다<br>
                    본 경기 기록으로 저장하시겠습니까?
                  </p>
                  <a onclick="complete_groupgame();" role="button" id="btn_ok" class="btn btn-modal-yes">저장</a>
                  <a href="#" role="button" id="btn_close" class="btn btn-modal-no" data-dismiss="modal">닫기</a>
                  <!--
                  <p>동점입니다.<br />
                  연장경기를 추가해주시기 바랍니다.</p>
                  <a href="#" role="button" class="btn btn-modal-close" data-dismiss="modal">확인</a>                 
                  -->
              </div>
              <!-- 동점 -->
            </div>
          </div> <!-- ./ modal-content -->
        </div> <!-- ./modal-dialog -->
      </div>
      <!-- E: 경기승패저장 modal -->


      <!--<div>-->
      <!-- S: 출전 선수 등록하기 모달 modal -->
      <div class="modal fade" id="player-modal" tabindex="-1" role="dialog" aria-labelledby="player-modal-title" aria-hidden="true">
        <div class="modal-dialog">
          <div class="modal-content modal-player">
            <div class="modal-body group-list-wrap">
              <!-- 왼쪽 학교 리스트 -->
              <div class="left-group-list">
                <p class="tit-group" id="DP_modal-school_Up">우석고등학교</p>
                <ul class="group-top">
                  <li>순서</li>
                  <li>선수명(체급)</li>
                  <li>순서</li>
                  <li>선수명(체급)</li>
                </ul>
                <dl class="group-content" id="DP_LGroup">
                  <!--
                  <dt><label class="on"><input type="checkbox">1</label></dt>
                  <dd>배동현이(-55kg)</dd>
                  <dt><label><input type="checkbox">2</label></dt>
                  <dd>서현영(-60kg)</dd>
                  <dt><label><input type="checkbox">3</label></dt>
                  <dd>전도원(-66kg)</dd>
                  <dt><label><input type="checkbox">4</label></dt>
                  <dd>임정열(-73kg)</dd>
                  <dt><label><input type="checkbox">5</label></dt>
                  <dd>전홍민(-81kg)</dd>
                  <dt><label><input type="checkbox">6</label></dt>
                  <dd>임선국(-90kg)</dd>
                  <dt><label><input type="checkbox">7</label></dt>
                  <dd>이승규(-100kg)</dd>
                  <dt></dt>
                  <dd></dd>
                  <dt></dt>
                  <dd></dd>
                  <dt></dt>
                  <dd></dd>
                  <dt></dt>
                  <dd></dd>
                  <dt></dt>
                  <dd></dd>
                  <dt></dt>
                  <dd></dd>
                  <dt></dt>
                  <dd></dd>
                  <dt></dt>
                  <dd></dd>
                  <dt></dt>
                  <dd></dd>
                  -->
                </dl>
                <a onclick="checkplayer_reset('DP_LGroup')" role="button" class="btn btn-modal-reset">초기화</a>
              </div>
              <!-- 왼쪽 학교 리스트-->
              <div class="modal-player-vs">vs</div>
              <!-- 오른쪽 학교 리스트 -->
              <div class="right-group-list">
                <p class="tit-group" id="DP_modal-school_Down">송도고등학교</p>
                <ul class="group-top">
                  <li>순서</li>
                  <li>선수명(체급)</li>
                  <li>순서</li>
                  <li>선수명(체급)</li>
                </ul>
                <dl class="group-content" id="DP_RGroup">
                  <!--
                  <dt><label class="on"><input type="checkbox">1</label></dt>
                  <dd>배동현이(-55kg)</dd>
                  <dt><label><input type="checkbox">2</label></dt>
                  <dd>서현영(-60kg)</dd>
                  <dt><label><input type="checkbox">3</label></dt>
                  <dd>전도원(-66kg)</dd>
                  <dt><label><input type="checkbox">4</label></dt>
                  <dd>임정열(-73kg)</dd>
                  <dt><label><input type="checkbox">5</label></dt>
                  <dd>전홍민(-81kg)</dd>
                  <dt><label><input type="checkbox">6</label></dt>
                  <dd>임선국(-90kg)</dd>
                  <dt><label><input type="checkbox">7</label></dt>
                  <dd>이승규(-100kg)</dd>
                  <dt></dt>
                  <dd></dd>
                  <dt></dt>
                  <dd></dd>
                  <dt></dt>
                  <dd></dd>
                  <dt></dt>
                  <dd></dd>
                  <dt></dt>
                  <dd></dd>
                  <dt></dt>
                  <dd></dd>
                  <dt></dt>
                  <dd></dd>
                  <dt></dt>
                  <dd></dd>
                  <dt></dt>
                  <dd></dd>
                  -->
                </dl>
                <a onclick="checkplayer_reset('DP_RGroup')" role="button" class="btn btn-modal-reset">초기화</a>
              </div>
              <!-- 오른쪽 학교 리스트 -->
            </div>
            <a onclick="complete_selectplayer();" role="button" class="btn btn-modal-end" id="btn_playerreg">등록하기</a>
            <a href="#" role="button" class="btn-modal-close-x" data-dismiss="modal"><img src="images/tournerment/score/btn_modal_close.png" alt="닫기" /></a>
          </div> <!-- ./ modal-content -->
        </div> <!-- ./modal-dialog -->
      </div>
      <!-- E: 출전 선수 등록하기 모달 modal -->

      <!-- S: 전체 저장하기 모달 modal -->
      <div class="modal fade" id="" tabindex="-1" role="dialog" aria-labelledby="" aria-hidden="true">
        <div class="modal-dialog">
          <div class="modal-content modal-small">
            <div class="modal-body">
              <!-- 텍스트와 하단 버튼 -->
              <div class="modal-txt-wrap">
                <p class="modal-txt">전체 경기 결과를 저장하시기 바랍니다.</p>
                <a href="#" role="button" class="btn btn-modal-close" data-dismiss="modal">닫기</a>
              </div>
            </div>
            <!-- 텍스트와 하단 버튼 -->
          </div> <!-- ./ modal-content -->
        </div> <!-- ./modal-dialog -->
      </div>
      <!-- E: 전체 저장하기 모달 modal -->

      <!-- S: Winner  result Modal -->
      <div class="round-res modal" id="round-res" tabindex="-1" role="dialog" aria-labelledby="modal-title" aria-hidden="true">
        <div class="modal-dialog">
          <div class="modal-content">
            <!-- S: modal-header -->
            <div class="modal-header chk-score">
              <h4 class="modal-title" id="modal-title">SCORE</h4>
            </div>
            <!-- E: modal-header -->
            <div class="modal-body">
              <h2><span class="left-arrow"><img src="images/tournerment/tourney/yellow-larr.png" alt></span><span id="DP_Win_Title">반칙 승</span><span class="right-arrow"><img src="images/tournerment/tourney/yellow-rarr.png" alt></span></h2>
              <!-- S: result-table -->
              <!-- <table class="table result-table">
                <caption class="sr-only">경기 결과 요약</caption>
                <thead>
                  <tr>
                    <th colspan="2">신재진</th>
                    <th colspan="1">구분</th>
                    <th colspan="2">김영석</th>
                  </tr>
                </thead>
                <tbody>
                    <td></td>
                    <td></td>
                    <th>한판</th>
                    <td></td>
                    <td></td>
                  </tr>
                  <tr>
                    <td>한팔 빗당겨치기</td>
                    <td>  </td>
                    <th>절반</th>
                    <td></td>
                    <td></td>
                  </tr>
                  <tr>
                    <td>뒤허리안아 메치기</td>
                    <td>1</td>
                    <th>유효</th>
                    <td>1</td>
                    <td>기타 누으며 메치기</td>
                  </tr>
                  <tr>
                    <td></td>
                    <td></td>
                    <th>지도</th>
                    <td></td>
                    <td></td>
                  </tr>
                </tbody>
              </table> -->
              <!-- E: result-table -->
              <!-- S: board -->
              <div class="board">
                <!-- S: pop-point-display -->
                <div class="pop-point-display">
                  <!-- S: display-board -->
                  <div class="display-board clearfix">
                    <!-- S: point-display -->
                    <div class="point-display clearfix">
                    <!-- S : 2016-12-08 수정 -->
                      <ul class="point-title clearfix">
                        <li>선수</li> 
                        <li>한판</li>
                        <li>절반</li>
                        <!--<li>유효</li>-->
                        <li>지도</li>
                        <li class="no-yuhyo">반칙/실격/<br />부전/기권 승</li>
                        <li class="no-yuhyo-end">양선수</li>
                      </ul>
                      <ul class="player-1-point player-point clearfix">
                        <li>
                          <a onclick="#"><span class="player-name" id="DP_Edit_LPlayer"><!--player-name disp-win-->김영석</span></a>
                        </li>
                        <li class="tgClass">
                         <a class="" onclick="#" name="a_jumsugb"><span class="score" id="LJumsuGb1" >0</span></a>
                        </li>
                        <li class="tgClass">
                          <a class="" onclick="#" name="a_jumsugb"><span class="score" id="LJumsuGb2" >0</span></a>
                        </li>
                        <!--
                        <li class="tgClass">
                          <a class="" onclick="#" name="a_jumsugb"><span class="score" id="LJumsuGb3" >0</span></a>
                        </li>
                        -->
                        <li class="tgClass">
                          <a class="" onclick="#" name="a_jumsugb"><span class="score txt-orange" id="LJumsuGb4" >0</span></a>
                        </li>
                        <li class="select-box-li no-yuhyo">
                          <select class="select-win select-box" id="DP_L_GameResult" >
                          </select>
                        </li>

                      </ul>
                      <p class="vs">vs</p>
                      <ul class="player-2-point player-point clearfix">
                        <li>
                          <a onclick="#"><span class="player-name" id="DP_Edit_RPlayer"><!--player-name disp-win-->최보라</span></a>
                        </li>
                        <li class="tgClass">
                          <a class="" onclick="#" name="a_jumsugb"><span class="score" id="RJumsuGb1">0</span></a>
                        </li>
                        <li class="tgClass">
                          <a class="" onclick="#" name="a_jumsugb"><span class="score" id="RJumsuGb2">0</span></a>
                        </li>
                        <!--
                        <li class="tgClass">
                          <a class="" onclick="#" name="a_jumsugb"><span class="score" id="RJumsuGb3">0</span></a>
                        </li>
                        -->
                        <li class="tgClass">
                          <a class="" onclick="#" name="a_jumsugb"><span class="score txt-orange" id="RJumsuGb4">0</span></a>
                        </li>
                        <li class="select-box-li no-yuhyo">
                          <select class="select-win select-box" id="DP_R_GameResult" >
                          </select>
                        </li>

                      </ul>

                      <div class="player-match-option player-point no-yuhyo">
                        <label for="player-match-option-01" class="tgClass default" id="LRResult_Lose"><input type="checkbox" id="player-match-option-01" /><span>부전패</span></label>
                        <label for="player-match-option-02" class="tgClass draw" id="LRResult_Draw"><input type="checkbox" id="player-match-option-02" /><span>무승부</span></label>
                      </div>
                      <!-- E: point-display -->
                      <!-- E : 2016-12-08 수정 -->
                    </div>
                    <!-- E: point-display -->
                    </div>
                  <!-- E: display-board -->
                </div>
                <!-- E: pop-point-display -->
              </div>
              <!-- E: board -->
              <!-- S: record -->
              <div class="record" id="DP_Record"  style="display:block">
                <h3>득실기록</h3>
                <ul id="DP_result-list">
                  <!--
                  <li class="mine">
                      [<span class="record-time">01:00~00:01</span>]<span class="record-type"> 본인 </span>: <span class="skill">누으며메치기</span>
                  </li>
                  <li class="mine recent">
                      [<span class="record-time">01:00~00:01</span>]<span class="record-type"> 본인 </span>: <span class="skill">절반 손기술(한팔 빗당겨치기)</span>
                  </li>
                  <li class="opponent">
                      [<span class="record-time">01:00~00:01</span>]<span class="record-type"> 상대 </span>: <span class="skill">허리기술(허리띄기)</span>
                  </li>
                  <li class="opponent recent">
                      [<span class="record-time">01:00~00:01</span>]<span class="record-type"> 상대 </span>: <span class="skill">유효 누으며 메치기(기타 누으며 메치기)</span>
                  </li>
                  <li class="opponent">
                      [<span class="record-time">01:00~00:01</span>]<span class="record-type"> 상대 </span>: <span class="skill">손기술(한소매 업어치기)</span>
                  </li>
                  <li class="mine">
                      [<span class="record-time">01:00~00:01</span>]<span class="record-type"> 본인 </span>: <span class="skill">유효 허리기술(뒤허리안아 메치기)</span>
                  </li>
                  <li class="mine">
                      [<span class="record-time">01:00~00:01</span>]<span class="record-type"> 본인 </span>: <span class="skill">유효 허리기술(뒤허리안아 메치기)</span>
                  </li>
                  <li class="mine">
                      [<span class="record-time">01:00~00:01</span>]<span class="record-type"> 본인 </span>: <span class="skill">유효 허리기술(뒤허리안아 메치기)</span>
                  </li>
                  <li class="opponent">
                      [<span class="record-time">01:00~00:01</span>]<span class="record-type"> 본인 </span>: <span class="skill">유효 허리기술(뒤허리안아 메치기)</span>
                  </li>
                  <li class="opponent">
                      [<span class="record-time">01:00~00:01</span>]<span class="record-type"> 본인 </span>: <span class="skill">유효 허리기술(뒤허리안아 메치기)</span>
                  </li>
                  -->
                </ul>
              </div>
              <div class="record" id="DP_GameVideo" style="display:none">
              </div>
              <!-- E: record -->
             <!-- S: modal footer -->
             <div class="modal-footer">
              <p class="wrong-pass" id="DP_wrong-pass"><!--비밀번호를 잘못 입력하셨습니다. 다시 확인해주세요.--></p>
              <span class="ins_group">
                <label for="ins_code">비밀번호</label>
                <input type="password" id="RoundResPwd" class="ins_code">
              </span>

              <script>
                function change_btn(){
                  //기록보기 눌렀을 시
                  if($("#btn_movie").css("display") == "none"){

                    $("#DP_GameVideo").html("");

                    $("#DP_GameVideo").css("display","none");
                    $("#DP_Record").css("display","");

                    $("#btn_movie").css("display","");
                    $("#btn_log").css("display","none");
                  }
                  else{

                    var strYoutubeLink = "<iframe width='568' height='318' src='https://www.youtube.com/embed/gzfCmCtSomQ?showinfo=0&autoplay=1&modestbranding=0&fs=1&vq=hd720&loop=1&playlist=gzfCmCtSomQ' frameborder='0' allowfullscreen></iframe>"
                    $("#DP_GameVideo").html(strYoutubeLink);

                    
                    $("#DP_GameVideo").css("display","");
                    $("#DP_Record").css("display","none");

                    $("#btn_movie").css("display","none");
                    $("#btn_log").css("display","");                
                  }
                }
              </script>

             <script>
              function checkPwd(btnobj){
                if($(btnobj).attr("class") == "btn btn-repair btn-ins"){
                  if($("#grouppwd").val() == ""){
                    alert('비밀번호를 입력하세요.');
                    return;
                  }

                  //몇라운드인지 담기
                  localStorage.setItem("PageMode","Score_Edit");

                  //단체전일때 단체전 구성페이지, 개인전일때 스코어 입력페이지

                  location.href="enter-score.html";       

                }
              }
             </script>

              <!--경기기록실 진입 시 보이는버튼-->
              <a onclick="change_btn();" id="btn_movie" role="button" class="btn btn-movielog btn-check" style="display:none">영상보기</a>
              <a onclick="change_btn();" id="btn_log" role="button" class="btn btn-movielog btn-check" style="display:none">경기기록보기</a>

              <a onclick="checkPwd(this);" id="btnEditcheck" role="button" class="btn btn-repair" data-toggle="modal" data-target="#repair-modal">수정하기</a>
              <a href="#" role="button" class="btn btn-close" data-dismiss="modal">닫기</a>
             </div>
             <!--E: modal-footer -->
            </div>
           <!-- E: modal-body -->
          </div><!-- modal-content -->
        </div> <!-- modal-dialog -->
      <!-- E: Winner-1 result Modal -->

    </div>
    <!-- E: main -->

    <!-- custom.js -->
    <script src="js/main.js"></script>

  </body>
</html>