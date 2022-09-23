<!-- S: include config -->
<!-- #include file = './include/config.asp' -->
<!-- E: include config -->
    <script>
  localStorage.setItem('BackPage', 'enter-score'); //백했을경우 화면 유지를 위해 넣어준다.


    /*script 시작부 로 검색*/

      if ('addEventListener' in document) {
          document.addEventListener('DOMContentLoaded', function() {
              FastClick.attach(document.body);
          }, false);
      }

      /*--------------------$(document).ready(function()--------------------*/
      $(document).ready(function()
      {
        //해당라운드 스코어 조회해야할 정보 가져오기 (localStorage 정보)
        var varGameTitleIDX = localStorage.getItem("GameTitleIDX");
        var varTeamGb = localStorage.getItem("TeamGb");
        var varSex = localStorage.getItem("Sex");
        var varLevel = localStorage.getItem("Level");
        var varGroupGameGb = localStorage.getItem("GroupGameGb");
        var varPlayerGameNum = localStorage.getItem("PlayerGameNum");
        var varPlayRound = parseInt(localStorage.getItem("PlayRound"));
        var varGroupRound = parseInt(localStorage.getItem("GroupRound"));



        //페이지 진입시 선택된 값 리셋
        localStorage.setItem("LJGubun","");
        localStorage.setItem("LJJumsu","");
        localStorage.setItem("SkillLeftRight","");

        //개인전은 GroupGameNum = 0
        if(localStorage.getItem("GroupGameGb") == "sd040001"){
          localStorage.setItem("GroupGameNum","0");
        }


        //개인전일때 양선수 불참버튼, 단체전일때 무승부 버튼으로 바뀜
        if(localStorage.getItem("GroupGameGb") == "sd040001"){
          $("#DP_DualResult_Text").html("불참");
          $("#LRResult_Draw").attr("class", "tgClass no-attend");
          
        }
        else{
          $("#DP_DualResult_Text").html("무승부");   
          $("#LRResult_Draw").attr("class", "tgClass draw");          
        }

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
                //$("#DP_play-type").html(myArr[0].SexName + " " + myArr[0].LevelName );
                $("#DP_play-type").html( myArr[0].LevelName );
                //16강
                $("#DP_play-round").html(myArr[0].TotRoundName + "강");
                //라운드
                $("#DP_play-num").html(varPlayerGameNum + "경기");

                //alert(myArr[0].StadiumNumber);

                //경기장 번호 체크
                /*
                if (myArr[0].StadiumNumber != "")
                {
                  //$("#LB_GYM" + myArr[0].StadiumNumber).attr("class","on");
                  $.each($("label[name='LB_GYM']"), function() {
                    if ($(this).attr("data-id") == myArr[0].StadiumNumber)
                    {
                      $(this).attr("class","on");
                    }
                    else{
                      $(this).attr("class","");
                    }
                  });
                }
                */

                localStorage.setItem("RGameLevelidx",myArr[0].RGameLevelidx);
                localStorage.setItem("GameType",myArr[0].GameType);
              }
              else{
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

        //S:해당경기 정보가져오기
        var loadscore=function(){

            var defer = $.Deferred();

            var obj = {};

            obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");
            obj.GroupGameNum = localStorage.getItem("GroupGameNum");
            obj.PlayerGameNum = localStorage.getItem("PlayerGameNum");
            obj.GameType = localStorage.getItem("GameType");
            obj.GroupGameGb = localStorage.getItem("GroupGameGb");

            var jsonData = JSON.stringify(obj);

            console.log(jsonData);

            var events = "";

            var arrayWinplayer = winplayer_select();  //승리한 선수 가져오기

            $.ajax({
                url: '/ajax/tennis_os/GGameScoreDetail.ashx',
                type: 'post',
                data: jsonData,
                async:false,
                success: function (sdata) {

                console.log(sdata);
                  
                  var myArr = JSON.parse(sdata);

                  console.log("1s:" + sdata);

                  //양선수 무승부 및 부전패 일때는 불참자로 처리한다.
                  var varNojoin1_PlayerIDX = "";
                  var varNojoin2_PlayerIDX = "";
                  var varNojoin1_PlayerNum = 0;
                  var varNojoin2_PlayerNum = 0;
                  var varNojoin1_Team = "22369";
                  var varNojoin1_TeamDtl = "22369";
                  var varNojoin2_Team = "22369";
                  var varNojoin2_TeamDtl = "22369";
                  var varNojoin1_UserName = "불참자";
                  var varNojoin2_UserName = "불참자";

                  if(localStorage.getItem("Sex") == "Man"){
                    //남자불참자 IDX
                    varNojoin1_PlayerIDX = "1496";
                    varNojoin2_PlayerIDX = "1499";
                  }
                  else{
                    //여자불참자 IDX
                    varNojoin1_PlayerIDX = "1497";                      
                    varNojoin2_PlayerIDX = "1500";
                  }

                  if (myArr.length > 0){

                    //이전 경기가 양선수불참, 양선수무승부일때 선수목록이 myArr.length 1로 나옴 
                    if (myArr.length == 1)
                    {
                      //도복색 결정
                      if (myArr[0].PlayerLeftRight == "Left")
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

                        $("#DP_player-name_Up").html(myArr[0].UserName + "<span>(" + strSchoolName_0 + ")</span>");
                        $("#DP_player-name_Down").html(varNojoin1_UserName);

                        localStorage.setItem("LPlayerIDX",myArr[0].PlayerIDX);
                        localStorage.setItem("LPlayerNum",myArr[0].PlayerNum);
                        localStorage.setItem("LTeam",myArr[0].Team);
                        localStorage.setItem("LTeamDtl",myArr[0].TeamDtl);
                        localStorage.setItem("LPlayerName",myArr[0].UserName);

                        localStorage.setItem("RPlayerIDX",varNojoin1_PlayerIDX);
                        localStorage.setItem("RPlayerNum",varNojoin1_PlayerNum);
                        localStorage.setItem("RTeam",varNojoin1_Team);
                        localStorage.setItem("RTeamDtl",varNojoin1_TeamDtl);
                        localStorage.setItem("RPlayerName",varNojoin1_UserName);

                      }
                      else{

                        $("#DP_player-name_Up").html(varNojoin1_UserName);
                        $("#DP_player-name_Down").html(myArr[0].UserName + "<span>(" + strSchoolName_0 + ")</span>");

                        localStorage.setItem("LPlayerIDX",varNojoin1_PlayerIDX);
                        localStorage.setItem("LPlayerNum",varNojoin1_PlayerNum);
                        localStorage.setItem("LTeam",varNojoin1_Team);
                        localStorage.setItem("LTeamDtl",varNojoin1_TeamDtl);
                        localStorage.setItem("LPlayerName",varNojoin1_UserName);

                        localStorage.setItem("RPlayerIDX",myArr[0].PlayerIDX);
                        localStorage.setItem("RPlayerNum",myArr[0].PlayerNum);
                        localStorage.setItem("RTeam",myArr[0].Team);
                        localStorage.setItem("RTeamDtl",myArr[0].TeamDtl);
                        localStorage.setItem("RPlayerName",myArr[0].UserName);                      
                      }


                    }
                    //정상경기 myArr.length 2
                    else
                    {

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


                      //선수명
                      $("#DP_player-name_Up").html(myArr[0].UserName + "<span>(" + strSchoolName_0 + ")</span>");
                      $("#DP_player-name_Down").html(myArr[1].UserName + "<span>(" + strSchoolName_1 + ")</span>");
                      //스코어보드 선수명
                      $("#DP_ScorePname_Up").html(myArr[0].UserName);
                      $("#DP_ScorePname_Down").html(myArr[1].UserName);
                      
                      //승리한 선수가 있다면..
                      if(arrayWinplayer[0] != ""){
                        $("#WinPlayer").append("<option value='"+ arrayWinplayer[0] +"'>"+ arrayWinplayer[1] +"</option>");
                      }
                      else{
                        $("#WinPlayer").append("<option value='' selected>승자 선수 선택</option>");
                        $("#WinPlayer").append("<option value='"+ myArr[0].PlayerIDX +"'>"+ myArr[0].UserName +"</option>");
                        $("#WinPlayer").append("<option value='"+ myArr[1].PlayerIDX +"'>"+ myArr[1].UserName +"</option>");                      
                      }
                      
                      //양선수의 IDX 및 출전번호
                      localStorage.setItem("LPlayerIDX",myArr[0].PlayerIDX);
                      localStorage.setItem("LPlayerNum",myArr[0].PlayerNum);
                      localStorage.setItem("RPlayerIDX",myArr[1].PlayerIDX);
                      localStorage.setItem("RPlayerNum",myArr[1].PlayerNum);
                      localStorage.setItem("LTeam",myArr[0].Team);
                      localStorage.setItem("LTeamDtl",myArr[0].TeamDtl);
                      localStorage.setItem("RTeam",myArr[1].Team);
                      localStorage.setItem("RTeamDtl",myArr[1].TeamDtl);
                      localStorage.setItem("LPlayerName",myArr[0].UserName);
                      localStorage.setItem("RPlayerName",myArr[1].UserName);

                    }

                    nowscore();       //현재점수 불러오기
                    nowdualresult(); //양선수 부전패,무승부인지 불러오기
            
                    //loadplaylog(); //유도 로그가져오기                    

                  } 
                  
                  //부전패로 올라와서 아무도 조회가 안될때
                  else {



                    $("#DP_player-name_Up").html(varNojoin1_UserName);
                    $("#DP_player-name_Down").html(varNojoin2_UserName);

                    localStorage.setItem("LPlayerIDX",varNojoin1_PlayerIDX);
                    localStorage.setItem("LPlayerNum",varNojoin1_PlayerNum);
                    localStorage.setItem("LTeam",varNojoin1_Team);
                    localStorage.setItem("LTeamDtl",varNojoin1_TeamDtl);
                    localStorage.setItem("LPlayerName",varNojoin1_UserName);

                    localStorage.setItem("RPlayerIDX",varNojoin2_PlayerIDX);
                    localStorage.setItem("RPlayerNum",varNojoin2_PlayerNum);
                    localStorage.setItem("RTeam",varNojoin2_Team);
                    localStorage.setItem("RTeamDtl",varNojoin2_TeamDtl);
                    localStorage.setItem("RPlayerName",varNojoin2_UserName);
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

        //S:해당대회 날짜 가져오기
        function playercntcheck(){
          var defer = $.Deferred();

          var obj = {};

          obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");
          obj.GroupGameNum = localStorage.getItem("GroupGameNum");
          obj.GameNum = localStorage.getItem("PlayerGameNum");

          var jsonData = JSON.stringify(obj);


          var events = "";

          $.ajax({
            url: '/ajax/tennis_os/GGamePlayerCntCheck.ashx',
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
        //E:해당대회 날짜 가져오기

        //S:유도 경기결과 (승리종류) 가져오기
        var loadwin=function(){
            var defer = $.Deferred();

            var obj = {};

            obj.SportsGb = localStorage.getItem("SportsGb");
            obj.PPubCode = "sd023";
            obj.PubCode = "sd023005,sd023006,sd023007,sd023008";

            var jsonData = JSON.stringify(obj);

            var events = "";

            var arrayWinplayer = winplayer_select();  //승리한 선수 가져오기

            $.ajax({
                url: '/Ajax/tennis_os/management/DirPPubCodeList_Search.ashx',
                type: 'post',
                data: jsonData,
                success: function (sdata) {
                  
                  var myArr = JSON.parse(sdata);

                  if (myArr.length > 0){
                    
                    //승리한 선수가 있다면

                    $("#L_gameresult").append("<option value='' selected>선택</option>");
                    $("#R_gameresult").append("<option value='' selected>선택</option>");
                    for (var i = 0; i < myArr.length; i++)
                    {
                      var varPubCode = myArr[i].PubCode;
                      var varPubName = myArr[i].PubName;
                      var varPPubCode = myArr[i].PPubCode;
                      var varPPubName = myArr[i].PPubName;
                      var varOrderBy = myArr[i].OrderBy;

                      $("#L_gameresult").append("<option value='"+ varPubCode +"'>"+ varPubName +"</option>");
                      $("#R_gameresult").append("<option value='"+ varPubCode +"'>"+ varPubName +"</option>");
                    }       
                    // selectBox 선택시 배경 변경
                    $('.point-display').selectBox('.select-box');
          
                  } else {
                    
                    var varMessage="<span style='font-size:12px;'>해당기간에 맞는 승률이 없습니다.</span>";
                  }

                  defer.resolve(sdata);
                },
                error: function (errorText) {
                  defer.reject(errorText);
                }

            });
            return defer.promise();
        }
        //E:유도 경기결과 (승리종류) 가져오기

        //S:현재 경기상태 조회
        function load_gamestatus(){
            var defer = $.Deferred();

            var obj = {};

            obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");
            obj.GroupGameNum = localStorage.getItem("GroupGameNum");
            obj.GameNum = localStorage.getItem("PlayerGameNum");

            var jsonData = JSON.stringify(obj);

            $.ajax({
                url: '/ajax/tennis_os/GGameNowGameStatus.ashx',
                type: 'post',
                data: jsonData,
                success: function (sdata) {

                  var myArr = JSON.parse(sdata);

                  if (myArr.length > 0){
                    
                    //$("#btn_gamestart").css("display","none");
                    //$("#btn_gameend").css("display","block");



                    //경기장 번호 체크
                    
                    if (myArr[0].StadiumNumber != "")
                    {
                      //$("#LB_GYM" + myArr[0].StadiumNumber).attr("class","on");
                      $.each($("label[name='LB_GYM']"), function() {
                        if ($(this).attr("data-id") == myArr[0].StadiumNumber)
                        {
                          $(this).attr("class","on");
                        }
                        else{
                          $(this).attr("class","");
                        }
                      });
                    }
                    

                    localStorage.setItem("GameProgress",myArr[0].GameStatus);
                  } 
                  
                  else {
                    

                    $("#start-modal").modal({backdrop: 'static', keyboard: false});
                    //$("#btn_gamestart").css("display","block");
                    //$("#btn_gameend").css("display","none");

                    //경기 진행중이지 않음
                    localStorage.setItem("GameProgress","");
                  }

                  defer.resolve(sdata);
                },
                error: function (errorText) {
                  defer.reject(errorText);
                }
            });
            return defer.promise();       
        }
        //E:현재 경기상태 조회

        //S:유도 기술정보가져오기
        function load_skill(strSkillnm,strSkillCd,objnm){
            var defer = $.Deferred();

            var obj = {};

            obj.SportsGb = localStorage.getItem("SportsGb");
            obj.PPubCode = strSkillCd; //손기술

            var jsonData = JSON.stringify(obj);

            var events = "";


            $.ajax({
                url: '/ajax/tennis_os/management/DirPubCodeList_spec.ashx',
                type: 'post',
                data: jsonData,
                success: function (sdata) {

                  var myArr = JSON.parse(sdata);

                  var strhandskill = "<dt>" + strSkillnm + "</dt>"

                  if (myArr.length > 0){
                    
                    for (var i = 0; i < myArr.length; i++){
                      strhandskill += strhandskill = "<dd><label name='label_skill_list'>";
                      strhandskill += strhandskill = "<input type='checkbox' name='skill_list' value='" + myArr[i].PubCode + "'>";
                      strhandskill += strhandskill = myArr[i].PubName;
                      strhandskill += strhandskill = "</label></dd>";

                    }
    
                    $(objnm).html(strhandskill);
                    
                    $('.skill-group').radioInput('.skill-group input');

                    //체크박스
                    //$('.skill-group').radioInput();

                  } else {
                    
                    var varMessage="<dd><label>등록된 기술이 없습니다.</label></dd>";
                  }

                  defer.resolve(sdata);
                },
                error: function (errorText) {
                  defer.reject(errorText);
                }
            });
            return defer.promise();       
        }
        //E:유도 기술정보가져오기

        //S:심판싸인 저장(modal팝업의 승인완료버튼)
        function sign_insert(strimage, strsigngubun){
            var defer = $.Deferred();

            var obj = {};

            obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");
            obj.GroupGameNum = localStorage.getItem("GroupGameNum");
            obj.PlayerGameNum = localStorage.getItem("PlayerGameNum");
            obj.SignData = strimage;
            obj.Signgubun = strsigngubun;

            var jsonData = JSON.stringify(obj);

            var events = "";


            $.ajax({
                url: '/ajax/tennis_os/GGameSignUpdate.ashx',
                type: 'post',
                data: jsonData,
                success: function (sdata) {
    
                  console.log(sdata);

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
        function loadsign(){
            var defer = $.Deferred();

            var obj = {};

            obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");
            obj.GroupGameNum = localStorage.getItem("GroupGameNum");
            obj.PlayerGameNum = localStorage.getItem("PlayerGameNum");

            var jsonData = JSON.stringify(obj);

            var events = "";


            $.ajax({
                url: '/ajax/tennis_os/GGameSignSelect.ashx',
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

        
        /*script 시작부*/

        //skillleftright_info('sd030001'); //페이지 첫진입시 좌측기술로 default
        
        //$("#btn_rightskill").trigger("click");
        
        loadgametitle(); //해당 경기정보
        loadscore();  //해당 라운드 스코어가져오기
        
        loadwin(); //승패

        loadwinresult(); //해당 판정 불러오기
        
        loadplaylog(); //유도 로그

        //각 기술 가져오기
        load_skill("손기술","sp001","#DP_hand-skill");       
        load_skill("발기술","sp003","#DP_foot-skill");       
        load_skill("허리기술","sp002","#DP_waist-skill");       
        load_skill("누우며 메치기","sp004","#DP_lie-skill");        
        //load_skill("되치기","sp006","#DP_counterattack-skill");
        load_skill("굳히기/기타","sp005","#DP_hold-skill");
        
        loadsign(); //심판싸인 불러오기

        load_gamestatus(); //현재경기 진행상태 조회

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
          console.log("start x: " + x + ", y: " + y);
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
           
           //console.log("move x: " + x + ", y: " + y);
          }
          context.lineTo(x, y);
          context.stroke();
         }, "mouseup touchend mouseleave" : function(event) {
          
          event.preventDefault();

          console.log("type: " + event.type);
          if(event.type == 'touchend'){
           event = event.originalEvent.changedTouches[0];   
          }   

          $(this).data("flag", "0");
          var position = $(this).offset();
          
          var x = event.pageX - position.left;
          var y = event.pageY - position.top; 
          
          console.log("end: " + x + ", y: " + y);

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

          //console.log(canvas.width + ": " + canvas.height);

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
          sign_insert(pngUrl, $("#game_signature").attr("data-id") );

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

          var arrayWinplayer = winplayer_select();

          if(arrayWinplayer[0] == ""){
            alert('해당 라운드 승패 결정 후, 승인 가능합니다.');
            $('#sign-modal').modal('hide');
            return false;
          }

         //클릭 이벤트된 버튼 obj
         var button = $(event.relatedTarget); 

         //클릭 이벤트된 버튼 data-whatever의 value
         var strbutton_data = button.data('whatever');
          
         //캔버스의 data-id에 값 입력
         $("#game_signature").attr("data-id", strbutton_data);

        });
        

      });
      /*--------------------$(document).ready(function()--------------------*/

        //S:기술 입력
        function insert_gamedtl(){

          var defer = $.Deferred();

          var varskilllist = "";

          
          //                  $('.injury-mark').tgClass('.injury-mark label');
          //                  $('.score-enter-main').tgClass('.tgClass a');
          //                   var a = $('#OverTime').is(':checked');
           //console.log("test:"+ $("#OverTime").typeOf(":checked"));
          // console.log("test-" + $(a).typeof());


          //게임 승패 가져오기
          var arrayWinplayer = winplayer_select();

          if (localStorage.getItem("GameProgress") == "")
          {
            alert("점수 입력은 경기 시작 후, 입력 가능합니다.");
            return;
          }


          var chk_stadium = "";

          //선택된 경기장
          $.each($("label[name='LB_GYM']"), function() {
            if ($(this).attr("class") == "on")
            {
              chk_stadium = $(this).attr("data-id");
            }
          });


          if(chk_stadium == ""){
            alert("해당경기의 경기장을 선택하세요.");
            return;
          }

          /*경기테스트로 인한 임시 권한해제
          if(arrayWinplayer[0] != ""){
            alert("승패가 확정된 게임은 스코어입력을 하실 수 없습니다.");
            return;
          }
          */

          //현재 한판1 OR 지도4회 일 경우, 스코어 입력이 안되게..
          if(
            parseInt($("#LJumsuGb1").html()) >= 1 ||
            parseInt($("#RJumsuGb1").html()) >= 1 ||
            parseInt($("#LJumsuGb4").html()) >= 3 ||
            parseInt($("#RJumsuGb4").html()) >= 3 )
          {
            alert('한판 1회,지도3회 판정이 있을 경우, 점수 입력을 하실 수 없습니다.');
            return;
          }

          if(localStorage.getItem("LJJumsu") == ""){
            alert('본인,상대 또는 해당 판정을 선택 바랍니다.');
            return;
          }

          //백팀이 점수판의 지도,실격승,반칙승,기권승을 제외한 점수 선택시, 기술체크 필요
          if(
              localStorage.getItem("LJJumsu") != "sd023004" &&
              localStorage.getItem("LJJumsu") != "sd023005" &&
              localStorage.getItem("LJJumsu") != "sd023006" &&
              localStorage.getItem("LJJumsu") != "sd023007" &&
              localStorage.getItem("LJJumsu") != "sd023008" 
             )
          {
            $.each($("input[name='skill_list']:checked"), function() {
                varskilllist += $(this).val()+",";
            });

            
            //선택한 기술 코드
            varskilllist = varskilllist.replace(",","");    

            if(varskilllist != "sp005001" && varskilllist != "sp005002" && varskilllist != "sp005003" && varskilllist != "sp005004"){
              if (localStorage.getItem("SkillLeftRight") == ""){
                alert('좌측기술 또는 우측기술을 체크하세요.');
                return;           
              }
            }

            if (varskilllist =="")
            {
              alert('기술을 선택하세요.');
              return;
            }           
          }



          //기술이 조르기거나 꺽기라면 한판만 입력 가능 sp005002 - 조르기, sp005003 - 꺽기
          if (varskilllist == "sp005002" || varskilllist == "sp005003")
          {
            //sd023001 - 한판
            if (localStorage.getItem("LJJumsu") != "sd023001")
            {
              alert("조르기, 꺽기 기술은 한판으로만 입력 가능합니다.");
              return;
            }
          }

          var strtimecheck= "Y";
          var strchecktime="";

          //경기시간 3자리 입력했는지 체크
          $.each($("li[name='gameTime']"), function() {
              if($(this).html() == ""){
                strtimecheck = "N";
                return false;
              }
              else{
                strchecktime += $(this).html();
              }
          }); 

          if (strtimecheck == "N")
          {
            alert('경기시간 3자리를 입력하시기 바랍니다.');
            return;
          }

          // 0 + 1 + : + 23 (01분23초)
          strchecktime = "0" + strchecktime.substring(0,1) + ":" + strchecktime.substring(1,3);

          var obj = {};

          obj.GameTitleIDX = localStorage.getItem("GameTitleIDX");
          obj.TeamGb = localStorage.getItem("TeamGb");
          obj.Sex = localStorage.getItem("Sex");
          obj.Level = localStorage.getItem("Level");
          obj.GroupGameGb = localStorage.getItem("GroupGameGb");
          obj.PlayerGameNum = localStorage.getItem("PlayerGameNum");
          obj.SportsGb = localStorage.getItem("SportsGb");

          obj.LPlayerIDX = localStorage.getItem("LPlayerIDX");
          obj.LPlayerNum = localStorage.getItem("LPlayerNum");
          obj.RPlayerIDX = localStorage.getItem("RPlayerIDX");
          obj.RPlayerNum = localStorage.getItem("RPlayerNum");

          obj.GroupGameNum = localStorage.getItem("GroupGameNum");

          obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");

          
          
          if (localStorage.getItem("LJGubun") == "L")
          {
            //기술만 들어갔을경우.. 점수없음(윗선수)
            if(localStorage.getItem("LJJumsu") == "sd021001"){
              obj.LJumsuGb = "";
            }
            else{
              obj.LJumsuGb = localStorage.getItem("LJJumsu");
            }

            obj.LLeftRight = localStorage.getItem("SkillLeftRight");
            obj.LSpecialtyGb = varskilllist.substring(0,5); //윗선수 기술구분
            obj.LSpecialtyDtl = varskilllist; //윗선수 기술상세

            obj.RJumsuGb = "";      //아래선수 점수
            obj.RSpecialtyGb = "";  //아래선수 기술구분

          }
          else
          {
            //기술만 들어갔을경우.. 점수없음(아래선수)

            obj.LJumsuGb = "";
            obj.LSpecialtyGb = "";
            obj.LSpecialtyDtl = "";

            if(localStorage.getItem("LJJumsu") == "sd021002"){
              obj.RJumsuGb = "";
            }
            else{
              obj.RJumsuGb = localStorage.getItem("LJJumsu");
            }
            
            obj.RLeftRight = localStorage.getItem("SkillLeftRight");
            obj.RSpecialtyGb = varskilllist.substring(0,5);
            obj.RSpecialtyDtl = varskilllist; 
            
          }

          obj.CheckTime = strchecktime; //경기시간
        
          //연장전 구분값
          if($("#DP_OverTime").attr("class") == "on"){
            obj.OverTime = "1"; 
          }
          else{
            obj.OverTime = "0"; 
          }         

          var jsonData = JSON.stringify(obj);

          var events = "";

          $.ajax({
            url: '/ajax/tennis_os/tblRGameResultDtlInsert.ashx',
            type: 'post',
            data: jsonData,
            success: function (sdata) {
              
              nowscore();
              nowdualresult(); //양선수 부전패,무승부인지 불러오기
              loadplaylog();

              //시간삭제
              display_inputTime('Delete');

              //선택된 기술, 점수, 기술좌우 리셋
              localStorage.setItem("LJGubun","");
              localStorage.setItem("LJJumsu","");
              localStorage.setItem("SkillLeftRight","");

              //기술 체크박스 전체해제
              $.each($("input[name='skill_list']:checked"), function() {
                  
                  $(this).attr('checked', false);
              });    
              
              //기술 체크박스 체크스타일 리셋
              $.each($("label[name='label_skill_list']"), function() {
                  $(this).removeAttr('class');
              });              

              //점수판 체크스타일 리셋
              $.each($("a[name='a_jumsugb']"), function() {
                  $(this).removeAttr('class');
              });   
              
              //연장전 체크박스 해제
              $("#DP_OverTime").attr("class","");

              //연장전 체크박스 해제
              $("#btn_leftskill").attr("class","btn left-skill");   
              $("#btn_rightskill").attr("class","btn left-skill");

              $("#img_leftskill").attr("src","images/tournerment/enter/radio-off.png");   
              $("#img_rightskill").attr("src","images/tournerment/enter/radio-off.png");    

              localStorage.setItem("SkillLeftRight","");
              

              /*
              var myArr = JSON.parse(sdata);
              
              if (myArr.length > 0){

              } 
              else {
                    
                alert("DB오류");
                return;
                
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
        //E:기술 입력

        //S:게임로그 삭제
        function delete_gamedtl(stridx, strchecktime){

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

          obj.Idx = stridx;
          obj.CheckTime = strchecktime;
          
          var jsonData = JSON.stringify(obj);

          $.ajax({
            url: '/ajax/tennis_os/tblRGameResultDtlDelete.ashx',
            type: 'post',
            data: jsonData,
            success: function (sdata) {   

              nowscore();
              loadwinresult(); //현재판정 불러오기
              nowdualresult(); //양선수 부전패,무승부인지 불러오기
              loadplaylog();
              defer.resolve(sdata);
            },
            error: function (errorText) {
              defer.reject(errorText);
            }
          });
            return defer.promise();               
        }
        //E:게임로그 삭제

        //S:유도 경기로그 가져오기
        function loadplaylog(){
            var defer = $.Deferred();

            var obj = {};

            obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");
            obj.GroupGameNum = localStorage.getItem("GroupGameNum");
            obj.PlayerGameNum = localStorage.getItem("PlayerGameNum");

            var jsonData = JSON.stringify(obj);

            console.log(jsonData);

            var events = "";

            //승리한 선수가 있다면..
            var arrayWinplayer = winplayer_select();  //승리한 선수 가져오기

            $.ajax({
                url: '/ajax/tennis_os/tblGameResultDtlSelect.ashx',
                type: 'post',
                data: jsonData,
                success: function (sdata) {             

                  var myArr = JSON.parse(sdata);

                  if (myArr.length > 0){
                    
                    var strplaylog = "";

                    console.log(sdata);

                    for (var i = 0; i < myArr.length; i++)
                    {


                      if(myArr[i].PlayerPosition == "LPlayer"){
                        if (myArr[i].JumsuGb == "")
                        {
                          strplaylog += "<li class='mine-2'>";                        
                        }
                        else
                        {
                          strplaylog += "<li class='mine'>";                        
                        }

                      }
                      else{
                        if (myArr[i].JumsuGb == "")
                        {
                          strplaylog += "<li class='opponent-2'>";                        
                        }
                        else
                        {
                          strplaylog += "<li class='opponent'>";
                        }
                      }
                      
                      strplaylog += "<p>";

                      if(myArr[i].OverTime == "1"){
                        strplaylog +="(연)"
                      }

                      strplaylog += "[<span class='score-time'>";

                      strplaylog += myArr[i].CheckTime + "</span>]<span class='player-name'>" + myArr[i].PlayerName + "</span>";
                      strplaylog += "";

                      if (myArr[i].JumsuGb == "지도")
                      {
                        strplaylog += ": <span class=''>" + myArr[i].JumsuGb +  "</span>";
                      }
                      else{
                        strplaylog += ": <span class=''>" + myArr[i].JumsuGb +  " " + myArr[i].SpecialtyGb + "</span>(<span class='skill'>" + myArr[i].SpecialtyDtl + "</span>)";
                      }
                      
                      /*경기테스트로 인한 임시 권한해제                     
                      if(arrayWinplayer[0] == ""){
                        strplaylog += " <button class='btn btn-del' type='button' onclick=delete_gamedtl('" + myArr[i].Idx + "','" + myArr[i].CheckTime + "') ><i class='fa fa-times' aria-hidden='true'></i>";
                        strplaylog += " <span class='sr-only'>닫기</span></button>";
                      }
                      */
                        strplaylog += " <button class='btn btn-del' type='button' onclick=delete_gamedtl('" + myArr[i].Idx + "','" + myArr[i].CheckTime + "') ><i class='fa fa-times' aria-hidden='true'></i>";
                        strplaylog += " <span class='sr-only'>닫기</span></button>";
                      
                      strplaylog += "</p>";
                      strplaylog += "</li>";

                    }                   
                    

                    $("#DP_result-list").html(strplaylog);

                    $('.btn-del').delList();

                  } else {
                    
                  
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

                    //백팀점수판
                    $("#LJumsuGb1").html(myArr[0].Left01);
                    $("#LJumsuGb2").html(myArr[0].Left02);
                    $("#LJumsuGb3").html(myArr[0].Left03);
                    $("#LJumsuGb4").html(myArr[0].Left04);

                    /*
                    //백팀 실격승,반칙승,부전승 체크
                    if( parseInt(myArr[0].Left05) > 0 ){
                      //$("#DP_L_sd019013").attr("class","on");
                      $("#L_gameresult").val("sd023005");
                    }

                    if( parseInt(myArr[0].Left06) > 0 || Number(myArr[0].Right04) >= 4){
                      //$("#DP_L_sd019005").attr("class","on");
                      $("#L_gameresult").val("sd023006");
                    }

                    if( parseInt(myArr[0].Left07) > 0 ){
                      //$("#DP_L_sd019006").attr("class","on");
                      $("#L_gameresult").val("sd023007");
                    }
                    */





                    //청팀점수판
                    $("#RJumsuGb1").html(myArr[0].Right01);
                    $("#RJumsuGb2").html(myArr[0].Right02);
                    $("#RJumsuGb3").html(myArr[0].Right03);
                    $("#RJumsuGb4").html(myArr[0].Right04);

                    /*
                    //백팀 실격승,반칙승,부전승 체크
                    if( parseInt(myArr[0].Right05) > 0 ){
                      //$("#DP_R_sd019013").attr("class","on");
                      $("#R_gameresult").val("sd023005");
                    }

                    if( parseInt(myArr[0].Right06) > 0 ||  Number(myArr[0].Left04) >= 4){
                      //$("#DP_R_sd019005").attr("class","on");
                      $("#R_gameresult").val("sd023006");
                    }

                    if( parseInt(myArr[0].Right07) > 0 ){
                      //$("#DP_R_sd019006").attr("class","on");
                      $("#R_gameresult").val("sd023007");
                    }
                    */

                    
                  }
                  else{
                    //백팀점수판
                    $("#LJumsuGb1").html("0");
                    $("#LJumsuGb2").html("0");
                    $("#LJumsuGb3").html("0");
                    $("#LJumsuGb4").html("0");
                    //$("#DP_L_sd019013").attr("class","");
                    //$("#DP_L_sd019005").attr("class","");
                    //$("#DP_L_sd019006").attr("class","");
                    $("#L_gameresult").val("");

                    //청팀점수판
                    $("#RJumsuGb1").html("0");
                    $("#RJumsuGb2").html("0");
                    $("#RJumsuGb3").html("0");
                    $("#RJumsuGb4").html("0");  
                    //$("#DP_R_sd019013").attr("class","");
                    //$("#DP_R_sd019005").attr("class","");
                    //$("#DP_R_sd019006").attr("class","");
                    $("#R_gameresult").val("");
                  }

              } 
              else {
                    
                //백팀점수판
                $("#LJumsuGb1").html("0");
                $("#LJumsuGb2").html("0");
                $("#LJumsuGb3").html("0");
                $("#LJumsuGb4").html("0");

                //청팀점수판
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

        //S:양선수 부전패, 무승부 판정 가져오기
        function nowdualresult(){

          var defer = $.Deferred();

          var obj = {};

          obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");
          obj.GroupGameNum = localStorage.getItem("GroupGameNum");
          obj.PlayerGameNum = localStorage.getItem("PlayerGameNum");

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
                }
                //무승부(단체전)라면..
                else if (myArr[0].LPlayerResult == "sd019024")
                {
                  $("#LRResult_Lose").attr("class", "tgClass default");
                  $("#LRResult_Draw").attr("class", "tgClass draw on");           
                }
                //불참(단체전)라면..
                else if (myArr[0].LPlayerResult == "sd019021")
                {
                  $("#LRResult_Lose").attr("class", "tgClass default");
                  $("#LRResult_Draw").attr("class", "tgClass no-attend on");            
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
        //E:현재점수 가져오기


        //S:경기결과저장(저장버튼 Click)
        function result_save(){
          var defer = $.Deferred();

          //점수 새로 불러오기
          nowscore();
          //판정 불러오기
          loadwinresult();
          //양선수 부전패,무승부인지 불러오기
          nowdualresult();

          var obj = {};

          obj.GameTitleIDX = localStorage.getItem("GameTitleIDX");
          obj.TeamGb = localStorage.getItem("TeamGb");
          obj.Sex = localStorage.getItem("Sex");
          obj.Level = localStorage.getItem("Level");
          obj.GroupGameGb = localStorage.getItem("GroupGameGb");
          obj.PlayerGameNum = localStorage.getItem("PlayerGameNum");
          obj.SportsGb = localStorage.getItem("SportsGb");
          obj.PlayRound = localStorage.getItem("PlayRound");
          obj.GroupRound = localStorage.getItem("GroupRound")

          obj.LPlayerIDX = localStorage.getItem("LPlayerIDX");
          obj.LPlayerNum = localStorage.getItem("LPlayerNum");
          obj.RPlayerIDX = localStorage.getItem("RPlayerIDX");
          obj.RPlayerNum = localStorage.getItem("RPlayerNum");

          

          obj.LTeam = localStorage.getItem("LTeam");
          obj.LTeamDtl = localStorage.getItem("LTeamDtl");
          obj.RTeam = localStorage.getItem("RTeam");
          obj.RTeamDtl = localStorage.getItem("RTeamDtl");

          obj.LPlayerName = localStorage.getItem("LPlayerName");
          obj.RPlayerName = localStorage.getItem("RPlayerName");

          obj.GroupGameNum = localStorage.getItem("GroupGameNum");

          obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");

          obj.GameType = localStorage.getItem("GameType");

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



          var strmsg = "";

          //각선수 점수
          var str_LJumsuGb1 = $("#LJumsuGb1").html();
          var str_LJumsuGb2 = $("#LJumsuGb2").html();
          var str_LJumsuGb3 = $("#LJumsuGb3").html();
          var str_LJumsuGb4 = $("#LJumsuGb4").html();
          var str_RJumsuGb1 = $("#RJumsuGb1").html();
          var str_RJumsuGb2 = $("#RJumsuGb2").html();
          var str_RJumsuGb3 = $("#RJumsuGb3").html();
          var str_RJumsuGb4 = $("#RJumsuGb4").html();

          
          //각가의 해당판정이 동점이거나, 부전판정이 체크되어있지 않을 시, 경기완료 못시킴;
          if(
            (parseInt($("#LJumsuGb1").html()) == parseInt($("#RJumsuGb1").html()) ) &&
            (parseInt($("#LJumsuGb2").html()) == parseInt($("#RJumsuGb2").html()) ) &&
            //(parseInt($("#LJumsuGb3").html()) == parseInt($("#RJumsuGb3").html()) ) &&
            (parseInt($("#LJumsuGb4").html()) == parseInt($("#RJumsuGb4").html()) ) &&

            ($("#L_gameresult").val() == "" && $("#R_gameresult").val() == "" ) &&

            ($("#LRResult_Lose").attr("class") == "tgClass default" && ( $("#LRResult_Draw").attr("class") == "tgClass draw" || $("#LRResult_Draw").attr("class") == "tgClass no-attend" ))
          ){
            alert('경기기록을 완료할 수 없습니다. 점수를 확인해 주시기 바랍니다.');
            //alert($("#DP_L_sd019005").attr("class"));
            return;
          }
          else{
        
                      
          }

          var strResultYN = "";

          //L선수 실격승
          if( strResultYN == "" ){
            //if($("#DP_L_sd019013").attr("class") == "on"){
            if($("#L_gameresult").val() == "sd023005"){
              obj.LPlayerResult = "sd019013";
              obj.RPlayerResult = "";
              strmsg = localStorage.getItem("LPlayerName") + " 선수를 실격(승)으로 기록합니다. 동의하시면 확인버튼을 눌러주세요.";
              strResultYN = "Y";      
            }
          }

          //R선수 실격승
          if( strResultYN == "" ){
            //if($("#DP_R_sd019013").attr("class") == "on"){
            if($("#R_gameresult").val() == "sd023005"){
              obj.LPlayerResult = "";
              obj.RPlayerResult = "sd019013";
              strmsg = localStorage.getItem("RPlayerName") + " 선수를 실격(승)으로 기록합니다. 동의하시면 확인버튼을 눌러주세요.";
              strResultYN = "Y";      
            }
          }
          //L선수 반칙승
          if( strResultYN == "" ){
            //if($("#DP_L_sd019005").attr("class") == "on"){
            if($("#L_gameresult").val() == "sd023006"){
              obj.LPlayerResult = "sd019005";
              obj.RPlayerResult = "";
              strmsg = localStorage.getItem("LPlayerName") + " 선수를 반칙(승)으로 기록합니다. 동의하시면 확인버튼을 눌러주세요.";
              strResultYN = "Y";      
            }
          }
          //R선수 반칙승
          if( strResultYN == "" ){
            //if($("#DP_R_sd019005").attr("class") == "on"){
            if($("#R_gameresult").val() == "sd023006"){
              obj.LPlayerResult = "";
              obj.RPlayerResult = "sd019005";
              strmsg = localStorage.getItem("RPlayerName") + " 선수를 반칙(승)으로 기록합니다. 동의하시면 확인버튼을 눌러주세요.";
              strResultYN = "Y";      
            }
          }
          //L선수 부전승
          if( strResultYN == "" ){
            //if($("#DP_L_sd019006").attr("class") == "on"){
            if($("#L_gameresult").val() == "sd023007"){
              obj.LPlayerResult = "sd019006";
              obj.RPlayerResult = "";
              strmsg = localStorage.getItem("LPlayerName") + " 선수를 부전(승)으로 기록합니다. 동의하시면 확인버튼을 눌러주세요.";
              strResultYN = "Y";      
            }
          }
          //R선수 부전승
          if( strResultYN == "" ){
            //if($("#DP_R_sd019006").attr("class") == "on"){
            if($("#R_gameresult").val() == "sd023007"){
              obj.LPlayerResult = "";
              obj.RPlayerResult = "sd019006";
              strmsg = localStorage.getItem("RPlayerName") + " 선수를 부전(승)으로 기록합니다. 동의하시면 확인버튼을 눌러주세요.";
              strResultYN = "Y";      
            }
          }
          //L선수 기권승
          if( strResultYN == "" ){
            //if($("#DP_L_sd019006").attr("class") == "on"){
            if($("#L_gameresult").val() == "sd023008"){
              obj.LPlayerResult = "sd019022";
              obj.RPlayerResult = "";
              strmsg = localStorage.getItem("LPlayerName") + " 선수를 기권(승)으로 기록합니다. 동의하시면 확인버튼을 눌러주세요.";
              strResultYN = "Y";      
            }
          }
          //R선수 기권승
          if( strResultYN == "" ){
            //if($("#DP_R_sd019006").attr("class") == "on"){
            if($("#R_gameresult").val() == "sd023008"){
              obj.LPlayerResult = "";
              obj.RPlayerResult = "sd019022";
              strmsg = localStorage.getItem("RPlayerName") + " 선수를 기권(승)으로 기록합니다. 동의하시면 확인버튼을 눌러주세요.";
              strResultYN = "Y";      
            }
          }


          var varLRResult = "";

          if( strResultYN == "" ){
            
            //양선수 부전패,무승부 체크
            if ($("#LRResult_Lose").attr("class") == "tgClass default on")
            {
              obj.LPlayerResult = "sd019012";
              obj.RPlayerResult = "sd019012";
              strmsg = "양선수를 부전(패)으로 기록합니다. 동의하시면 확인버튼을 눌러주세요.";
              strResultYN = "Y";
            }

            if ($("#LRResult_Draw").attr("class") == "tgClass no-attend on" || $("#LRResult_Draw").attr("class") == "tgClass draw on")
            {
              if(localStorage.getItem("GroupGameGb") == "sd040001"){
                obj.LPlayerResult = "sd019021";
                obj.RPlayerResult = "sd019021";
                strmsg = "양선수를 불참으로 기록합니다. 동의하시면 확인버튼을 눌러주세요.";
                strResultYN = "Y";
              }
              else{
                obj.LPlayerResult = "sd019024";
                obj.RPlayerResult = "sd019024";
                strmsg = "양선수를 무승부로 기록합니다. 동의하시면 확인버튼을 눌러주세요.";
                strResultYN = "Y";              
              }
            }
          }

          //지도 3회 이상 시..
          if( strResultYN == "" ){

          console.log("testlog"+ str_LJumsuGb4 + "," + str_RJumsuGb4);

            if( Number(str_LJumsuGb4) > Number(str_RJumsuGb4) ){  

                    
              if( Number(str_LJumsuGb4) > 2)
              {
                obj.RPlayerResult = "sd019004"; 
                obj.LPlayerResult = "";
                    
                strmsg = localStorage.getItem("RPlayerName") + " 선수를 지도(승)으로 기록합니다. 동의하시면 확인버튼을 눌러주세요.";
                strResultYN = "Y";                
              }
            }
            else if( Number(str_LJumsuGb4) < Number(str_RJumsuGb4) ){

                    
              if ( Number(str_RJumsuGb4) > 2){

                obj.LPlayerResult = "sd019004";
                obj.RPlayerResult = ""; 
                    
                strmsg = localStorage.getItem("LPlayerName") + " 선수를 지도(승)으로 기록합니다. 동의하시면 확인버튼을 눌러주세요.";
                strResultYN = "Y";                
              }
            }
          }

          if (strResultYN == "")
          {

            var strReturn = "";
            var strTitle = "";

            //각선수 한판,절반,유효 점수
            //str_LJumsu = $("#LJumsuGb1").html() + $("#LJumsuGb2").html() +  $("#LJumsuGb3").html() +  $("#RJumsuGb4").html();
            //str_RJumsu = $("#RJumsuGb1").html() + $("#RJumsuGb2").html() +  $("#RJumsuGb3").html() +  $("#LJumsuGb4").html();

            str_LJumsu = $("#LJumsuGb1").html() + $("#LJumsuGb2").html() +  $("#RJumsuGb4").html();
            str_RJumsu = $("#RJumsuGb1").html() + $("#RJumsuGb2").html() +  $("#LJumsuGb4").html();

          

            //한판승
            if( strReturn == "" ){
              if( Number(str_LJumsuGb1) > 0 || Number(str_RJumsuGb1) > 0){
                strReturn = "sd019001";
                strTitle = "한판(승)"
              }
            }

            //절반승
            if( strReturn == "" ){
              if( Number(str_LJumsuGb2) > 0 || Number(str_RJumsuGb2) > 0){
                strReturn = "sd019002";
                strTitle = "절반(승)"
              }
            }

            //유효승
            /*
            if( strReturn == "" ){
              if( Number(str_LJumsuGb3) > 0 || Number(str_RJumsuGb3) > 0){
                strReturn = "sd019003";
                strTitle = "유효(승)"
              }
            }
            */
            
            if (strReturn != ""){
              if(Number(str_LJumsu) > Number(str_RJumsu)){
                obj.LPlayerResult = strReturn;
                obj.RPlayerResult = "";
                strmsg = localStorage.getItem("LPlayerName") + " 선수를 " + strTitle + "으로 기록합니다. 동의하시면 확인버튼을 눌러주세요.";
                strResultYN = "Y";      
              }
              else{
                obj.LPlayerResult = "";
                obj.RPlayerResult = strReturn;            
                strmsg = localStorage.getItem("RPlayerName") + " 선수를 " + strTitle + "으로 기록합니다. 동의하시면 확인버튼을 눌러주세요2.";
                strResultYN = "Y";      
              }
            }
          }

          //각각의 선수 지도가 3개 이상이면 반칙(승), 3개미만이면 우세(승)
  
          
          if( strResultYN == "" ){


            if( Number(str_LJumsuGb4) > Number(str_RJumsuGb4) ){  

                    
              if( Number(str_LJumsuGb4) < 3 && Number(str_LJumsuGb4) > 0)
              {


                if(Number(str_LJumsuGb4) == 1){
                  obj.RPlayerResult = "sd019015";   
                }
                else if(Number(str_LJumsuGb4) == 2){
                  obj.RPlayerResult = "sd019017";   
                }
                /*
                else if(Number(str_LJumsuGb4) == 3){
                  obj.RPlayerResult = "sd019019";   
                }
                */
                else{
                  obj.RPlayerResult = "sd019015"; 
                }
                    
                obj.LPlayerResult = "";
                    
                strmsg = localStorage.getItem("RPlayerName") + " 선수를 우세(승)으로 기록합니다. 동의하시면 확인버튼을 눌러주세요.";
                strResultYN = "Y";  
              }

              else{
                obj.RPlayerResult = "sd019004"; 
                obj.LPlayerResult = "";
                    
                strmsg = localStorage.getItem("RPlayerName") + " 선수를 지도(승)으로 기록합니다. 동의하시면 확인버튼을 눌러주세요.";
                strResultYN = "Y";                
              }
            }
            else if( Number(str_LJumsuGb4) < Number(str_RJumsuGb4) ){

                    
              if ( Number(str_RJumsuGb4) < 3 && Number(str_RJumsuGb4) > 0 )
              {


                if(Number(str_RJumsuGb4) == 1){
                  obj.LPlayerResult = "sd019015";   
                }
                else if(Number(str_RJumsuGb4) == 2){
                  obj.LPlayerResult = "sd019017";   
                }
                /*
                else if(Number(str_RJumsuGb4) == 3){
                  obj.LPlayerResult = "sd019019";   
                }
                */
                else{
                  obj.LPlayerResult = "sd019015"; 
                }                 

                obj.RPlayerResult = "";         
                strmsg = localStorage.getItem("LPlayerName") + " 선수를 우세(승)으로 기록합니다. 동의하시면 확인버튼을 눌러주세요.";    
                strResultYN = "Y";  
              }

              else{
                obj.LPlayerResult = "sd019004";
                obj.RPlayerResult = ""; 
                    
                strmsg = localStorage.getItem("RPlayerName") + " 선수를 지도(승)으로 기록합니다. 동의하시면 확인버튼을 눌러주세요.";
                strResultYN = "Y";                
              }
            }
          }

          var jsonData = JSON.stringify(obj);

          console.log("결과:" + strmsg);

          var events = "";

          //승리한 선수가 있다면..
          /*
          var arrayWinplayer = winplayer_select();  //승리한 선수 가져오기

          if(arrayWinplayer[0] != ""){
            alert("승패가 확정된 라운드는 다시 저장 하실 수 없습니다.");
            return;
          }
          */

          //승패 확인창
          if(!confirm(strmsg)){
            return;
          }


          $.ajax({
            url: '/ajax/tennis_os/tblRGameResultInsert.ashx',
            type: 'post',
            data: jsonData,
            success: function (sdata) {

              console.log("result:" + sdata);

              if(sdata == "Insert_Success" || sdata == "Update_Success"){
                alert('경기결과 등록이 완료되었습니다.');

                //진행 중 해제
                localStorage.setItem("GameProgress", "");

                clickBackbtn();
              }
              else{
                alert('경기결과 등록에 실패했습니다.' + sdata);
              }

              //승리한 선수가 있다면..
              var arrayWinplayer = winplayer_select();  //승리한 선수 가져오기

              if(arrayWinplayer[0] != ""){
                $("#WinPlayer").html("");
                $("#WinPlayer").append("<option value='"+ arrayWinplayer[0] +"'>"+ arrayWinplayer[1] +"</option>");
              }

              /*
              if(arrayWinplayer[0] != ""){
                $("#gameresult").html("");
                $("#gameresult").append("<option value='"+ arrayWinplayer[2] +"'>"+ arrayWinplayer[3] +"</option>");
              }
              */

              loadplaylog();
              
              
              /*
              var myArr = JSON.parse(sdata);

              if (myArr.length > 0){

                  if (myArr[0].Left01 != "")
                  {
                    $("#LJumsuGb1").html(addzero(myArr[0].Left01));
                    $("#LJumsuGb2").html(addzero(myArr[0].Left02));
                    $("#LJumsuGb3").html(addzero(myArr[0].Left03));
                    $("#LJumsuGb4").html(addzero(myArr[0].Left04));
                    $("#RJumsuGb1").html(addzero(myArr[0].Right01));
                    $("#RJumsuGb2").html(addzero(myArr[0].Right02));
                    $("#RJumsuGb3").html(addzero(myArr[0].Right03));
                    $("#RJumsuGb4").html(addzero(myArr[0].Right04));
                  }
                  else{
                    $("#LJumsuGb1").html("00");
                    $("#LJumsuGb2").html("00");
                    $("#LJumsuGb3").html("00");
                    $("#LJumsuGb4").html("00");
                    $("#RJumsuGb1").html("00");
                    $("#RJumsuGb2").html("00");
                    $("#RJumsuGb3").html("00");
                    $("#RJumsuGb4").html("00");               
                  }


              } 
              else {
                    
                $("#LJumsuGb1").html("00");
                $("#LJumsuGb2").html("00");
                $("#LJumsuGb3").html("00");
                $("#LJumsuGb4").html("00");
                $("#RJumsuGb1").html("00");
                $("#RJumsuGb2").html("00");
                $("#RJumsuGb3").html("00");
                $("#RJumsuGb4").html("00");
                
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
        //E:경기결과저장(저장버튼 Click)

        //S:현재 라운드의 승리자 가져오기
        function winplayer_select(){

          var defer = $.Deferred();

          var obj = {};

          obj.GameTitleIDX = localStorage.getItem("GameTitleIDX");
          obj.TeamGb = localStorage.getItem("TeamGb");
          obj.Sex = localStorage.getItem("Sex");
          obj.Level = localStorage.getItem("Level");
          obj.GroupGameGb = localStorage.getItem("GroupGameGb");
          obj.PlayerGameNum = localStorage.getItem("PlayerGameNum");
          obj.SportsGb = localStorage.getItem("SportsGb");
          obj.PlayerGameNum = localStorage.getItem("PlayerGameNum");
          obj.GroupGameNum = localStorage.getItem("GroupGameNum");

          var jsonData = JSON.stringify(obj);

          var strResult = "";

          var strPlayerIDX = "";
          var strPlayerName = "";
          var strPlayerResult = "";
          var strPubName = "";

          $.ajax({
            url: '/ajax/tennis_os/GGameWinPlayerSelect.ashx',
            type: 'post',
            async:false,
            data: jsonData,
            success: function (sdata) {

              var myArr = JSON.parse(sdata);

              if (myArr.length > 0){

                strPlayerIDX = myArr[0].PlayerIDX;
                strPlayerName = myArr[0].PlayerName;
                strPlayerResult = myArr[0].PlayerResult;
                strPubName = myArr[0].PubName;
                
              } 
              else {
                
              }

              defer.resolve(sdata);
            },
            error: function (errorText) {
              defer.reject(errorText);
            }
          });
          
          //return defer.promise();     

          return [strPlayerIDX, strPlayerName, strPlayerResult, strPubName];
        }
        //E:현재 라운드의 승리자 가져오기  


        //S:현재 라운드의 실격승, 반칙승 Log가 있는지 없는지의 Count..
        function nowfoul(){

          var defer = $.Deferred();

          var obj = {};

          obj.GameTitleIDX = localStorage.getItem("GameTitleIDX");
          obj.TeamGb = localStorage.getItem("TeamGb");
          obj.Sex = localStorage.getItem("Sex");
          obj.Level = localStorage.getItem("Level");
          obj.GroupGameGb = localStorage.getItem("GroupGameGb");
          obj.PlayerGameNum = localStorage.getItem("PlayerGameNum");
          obj.SportsGb = localStorage.getItem("SportsGb");
          obj.PlayerGameNum = localStorage.getItem("PlayerGameNum");
          obj.GroupGameNum = localStorage.getItem("GroupGameNum");

          var jsonData = JSON.stringify(obj);

          var strFoulCnt = "";

          $.ajax({
            url: '/ajax/tennis_os/GGameFoulSelect.ashx',
            type: 'post',
            async:false,
            data: jsonData,
            success: function (sdata) {

              var myArr = JSON.parse(sdata);

              if (myArr.length > 0){

                strFoulCnt = myArr[0].FoulCnt;
                
              } 
              else {
                strFoulCnt = "0";
              }

              defer.resolve(sdata);
            },
            error: function (errorText) {
              defer.reject(errorText);
            }
          });
          
          //return defer.promise();     

          return strFoulCnt;
        }
        //E:현재 라운드의 승리자 가져오기  
        

        //S:스코어보드 점수선택
        function jumsu_info(btnobj, strLRgubun, strJumsu){

          
          //Number(nowfoul()) > 0 일때는 실격승,반칙승,부전승 체크가 풀리거나, 체크된 상태가 되지 않아야함
          if(parseInt(Number(nowfoul())) > 0){
            $('.tgClass').addClass('fixed');
            alert('실격승, 반칙승, 부전승 판정이 있는경우, 점수를 더 입력하실 수 없습니다.');
            return;
          }
          //Number(nowfoul()) < 1 일때는 실격승,반칙승,부전승 체크를 자유롭게 할 수 있어야 함
          else{

            $('.tgClass').removeClass('fixed');
          }

          if( Number($("#LJumsuGb4").html()) >= 4 || Number($("#RJumsuGb4").html()) >= 4){
            $('.tgClass').addClass('fixed');
            alert('지도 4회 시, 점수를 더 입력하실 수 없습니다.');
            return;
          }

          if( Number($("#LJumsuGb1").html()) >= 1 || Number($("#RJumsuGb1").html()) >= 1){
            $('.tgClass').addClass('fixed');
            alert('한판 1회 시, 점수를 더 입력하실 수 없습니다.');
            return;
          }

          //해당조건의 반대상황으로 볼것
          if($(btnobj).attr("class") == "on"){
            localStorage.setItem("LJGubun",""); 
            localStorage.setItem("LJJumsu","");                   
          }

          else{
            localStorage.setItem("LJGubun",strLRgubun); 
            localStorage.setItem("LJJumsu",strJumsu);         
          }
                  
        }
        //E:스코어보드 점수선택

        //S:좌,우기술 선택
        function skillleftright_info(strskillleftright){
  
          localStorage.setItem("SkillLeftRight",strskillleftright);
                  
        }
        //E:좌,우기술 선택

        //S:백버튼 Click
        function clickBackbtn(){

          localStorage.setItem("BackPage","enter-score");

          //진행중 코드:sd050001 이면
          if (localStorage.getItem("GameProgress") == "sd050001")
          {
            if(confirm("경기가 진행 중 입니다. 화면이동 시, 해당 경기가 리셋됩니다. 동의 하시면 확인버튼을 눌러주세요."))
            {
              //경기리셋;
              resetgame();
            }
            else{
              return;
            }
          }
        
          if (localStorage.getItem("GroupGameGb") == "sd040001")
          {
            location.href='RGameList.html';
          }
          else{
            location.href='enter-group.html';         
          }
        }
        //E:백버튼 Click

        //S:홈버튼 Click
        function clickHomebtn(){

          //진행중 코드:sd050001 이면
          if (localStorage.getItem("GameProgress") == "sd050001")
          {
            if(confirm("경기가 진행 중 입니다. 화면이동 시, 해당 경기가 리셋됩니다. 동의 하시면 확인버튼을 눌러주세요."))
            {
              //경기리셋;
              resetgame();
            }
            else{
              return;
            }
          }

          location.href='index.asp';     
        
        }
        //S:홈버튼 Click

        //S:시간입력
        function display_inputTime(str){
          if (str == "Delete")
          {
            jQuery.fn.reverse = [].reverse;

            //each문 거꾸로..
            $($("li[name='gameTime']").get().reverse()).each(function() { 
                //if($(this).html() != ""){
                //  $(this).html("");
                //  return false;
                $(this).html("");
                //}
            }); 
                      
          }
          else{
            $.each($("li[name='gameTime']"), function() {
                if($(this).html() == ""){

                  if($(this).attr("data-id") == "3"){
                    if(Number(str) > 9){
                      return false;
                    }
                  }

                  if($(this).attr("data-id") == "2"){
                    if(Number(str) > 5){
                      return false;
                    }
                  }

                  $(this).html(str);
                  return false;
                }
            }); 
          }
        }
        //E:시간입력


        //S:판정선택 - 반칙,실격,부전,기권
        function select_gameresult(str){

          //부전승 일때 숫자 넣어주기 0분00초
          if($("#L_gameresult").val() == "sd023007" || $("#R_gameresult").val() == "sd023007"){

            $.each($("li[name='gameTime']"), function() {
              $(this).html("0")
            }); 
          }
          else{
            $.each($("li[name='gameTime']"), function() {
              $(this).html("")
            });           
          }

          if(str == "L"){
            $("#R_gameresult").val("");

            localStorage.setItem("LJGubun",str); 
            localStorage.setItem("LJJumsu",$("#L_gameresult").val()); 
          }
          else{
            $("#L_gameresult").val("");
            localStorage.setItem("LJGubun",str); 
            localStorage.setItem("LJJumsu",$("#R_gameresult").val()); 
          }
        }
        //E:판정선택 - 반칙,실격,부전,기권

        //S:경기시작
        function game_start(){
            var defer = $.Deferred();

              
            if($("#StartTime1").val() == ""){
              alert("시간을 입력하세요.");
              return;
            }
            if($("#StartTime2").val() == ""){
              alert("시간을 입력하세요.");
              return;
            }

            if($("#StartTime3").val() == ""){
              alert("분을 입력하세요.");
              return;
            }
            if($("#StartTime4").val() == ""){
              alert("분을 입력하세요.");
              return;
            }

            var obj = {};

            obj.SportsGb = localStorage.getItem("SportsGb");
            obj.GameTitleIDX = localStorage.getItem("GameTitleIDX");
            obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");
            obj.GroupGameNum = localStorage.getItem("GroupGameNum");
            obj.GameNum = localStorage.getItem("PlayerGameNum");

            obj.LPlayerIDX = localStorage.getItem("LPlayerIDX");
            obj.LTeam = localStorage.getItem("LTeam");
            obj.LTeamDtl = localStorage.getItem("LTeamDtl");
            obj.LPlayerName = localStorage.getItem("LPlayerName");

            obj.RPlayerIDX = localStorage.getItem("RPlayerIDX");
            obj.RTeam = localStorage.getItem("RTeam");
            obj.RTeamDtl = localStorage.getItem("RTeamDtl");
            obj.RPlayerName = localStorage.getItem("RPlayerName");

            obj.StartHour = $("#StartTime1").val() + $("#StartTime2").val();
            obj.StartMinute = $("#StartTime3").val() + $("#StartTime4").val();

            //선택된 경기장
            $.each($("label[name='LB_GYM']"), function() {
              if ($(this).attr("class") == "on")
              {
                obj.StadiumNumber = $(this).attr("data-id");
              }
            });
      

            var jsonData = JSON.stringify(obj);
            
            $.ajax({
                url: '/ajax/tennis_os/GGameNowGameStatus_Insert.ashx',
                type: 'post',
                data: jsonData,
                success: function (sdata) {


                if(sdata == "Insert_False2"){

                  alert("경기시작에 실패했습니다.");

                  //$("#btn_gamestart").css("display","none");
                  //$("#btn_gameend").css("display","block");
                }
                else{

                  $("#start-modal").modal({backdrop: 'static', keyboard: false});
                  $("#start-modal").modal("hide");
                  //$("#btn_gamestart").css("display","none");
                  //$("#btn_gameend").css("display","block");

                  localStorage.setItem("GameProgress","sd050001");
                }

                  defer.resolve(sdata);
                },
                error: function (errorText) {
                  defer.reject(errorText);
                }
            });
            return defer.promise();         
        }
        //E:경기시작

        //S:경기리셋
        function resetgame(){

           var defer = $.Deferred();

            var obj = {};

            obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");
            obj.GroupGameNum = localStorage.getItem("GroupGameNum");
            obj.PlayerGameNum = localStorage.getItem("PlayerGameNum");

            var jsonData = JSON.stringify(obj);

            
            $.ajax({
                url: '/ajax/tennis_os/GGameResultDtlReset.ashx',
                type: 'post',
                data: jsonData,
                success: function (sdata) {

                if(sdata == "DELETE_Success"){

                  alert("경기리셋을 완료하였습니다.");

                }
                else{

                  alert("해당경기를 리셋 할 수 없습니다. 관리자에게 문의 바랍니다.");
                  return;
                }

                  defer.resolve(sdata);
                },
                error: function (errorText) {
                  defer.reject(errorText);
                }
            });
            return defer.promise(); 
        
        } 
        //E:경기리셋

        //S:경기시간체크
        function chk_StartTime(obj, ornum){

          if($(obj).val() == "" || $.isNumeric($(obj).val()) == false){

            alert("시간은 숫자만 입력하세요.");
            $(obj).val("");
            return;
            
          }

          if (ornum == 1)
          {
            if(Number($(obj).val()) < 0 || Number($(obj).val()) > 2){
              alert("시간은 0~2 숫자로 입력하세요.");
              $(obj).val("");
              return;
            }
          }

          if (ornum == 2)
          {
            if(Number($(obj).val()) < 0 || Number($(obj).val()) > 9){
              alert("시간은 0~9 숫자로 입력하세요.");
              $(obj).val("");
              return;
            }
          }

          if (ornum == 3)
          {
            if(Number($(obj).val()) < 0 || Number($(obj).val()) > 5){
              alert("분은 01~59 숫자로 입력하세요.");
              $(obj).val("");
              return;
            }
          }

          if (ornum == 4)
          {
            if(Number($(obj).val()) < 0 || Number($(obj).val()) > 9){
              alert("분은 01~59 숫자로 입력하세요.");
              $(obj).val("");
              return;
            }
          }


          if(ornum != 4){
            $("#StartTime" + String(ornum + 1)).focus();
          }
        }
        //E:경기시간체크

        //S:대전선수명 및 승자 가져오기
        var loadwinresult=function(strPlayerGameNum){
            var defer = $.Deferred();
        
            var obj = {};
        
            obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");
            obj.GroupGameNum = localStorage.getItem("GroupGameNum");
            obj.PlayerGameNum = localStorage.getItem("PlayerGameNum");
        
            var jsonData = JSON.stringify(obj);

            console.log("1_s:" + jsonData);
        
            var events = "";
        
            $.ajax({
                url: '/ajax/tennis_os/GGameWinResult.ashx',
                type: 'post',
                data: jsonData,
                success: function (sdata) {
                  
                  console.log("1:" + sdata);

                  var myArr = JSON.parse(sdata);
        
                  if (myArr.length > 0){

                    if(myArr[0].LResult != ""){

                      //좌측선수 반칙,실격,부전/기권 승 selected
                      if(myArr[0].LSkillResult == "sd023005" || myArr[0].LSkillResult == "sd023006" || myArr[0].LSkillResult == "sd023007" || myArr[0].LSkillResult == "sd023008"){

                        $("#L_gameresult").val(myArr[0].LSkillResult);
                      }
                      else{
                        $("#L_gameresult").val("");
                      }
                    }
                    else{
                      $("#L_gameresult").val("");
                    }

                    if(myArr[0].RResult != ""){

                      //우측선수 반칙,실격,부전/기권 승 selected
                      if(myArr[0].RSkillResult == "sd023005" || myArr[0].RSkillResult == "sd023006" || myArr[0].RSkillResult == "sd023007" || myArr[0].RSkillResult == "sd023008"){
                        $("#R_gameresult").val(myArr[0].RSkillResult);
                      }
                      else{
                        $("#R_gameresult").val("");
                      }

                    }
                    else{
                      $("#R_gameresult").val("");
                    }


                  } 
                  
                  else {
                    
                    var varMessage="<span style='font-size:12px;'>해당 경기결과가 없습니다.</span>";
                  }
        
                  defer.resolve(sdata);
                },
                error: function (errorText) {
                  defer.reject(errorText);
                }
            });
            return defer.promise();
        }
        //E:대전선수명 및 승자 가져오기

        $(document).ajaxStart(function() {

          
          apploading("AppBody", "조회 중 입니다.");


        });
        $(document).ajaxStop(function() {

              
          $('#AppBody').oLoader('hide');

        });
                

    </script>
  </head>
  <body id="AppBody">
    <!-- S: header -->
    <div class="header container-fluid">
      <div class="row">
        <div class="pull-left">
          <a onclick="clickBackbtn();" role="button" class="prev-btn">
            <span class="icon-prev">
              <i class="fa fa-angle-left" aria-hidden="true"></i>
            </span>
            <span class="prev-txt">경기스코어 입력</span>
          </a>
        </div>
        
        <!-- S: include header -->
        <!-- #include file = './include/header.asp' -->
        <!-- E: include header -->

        </div>
      </div>
    </div>
    <!-- E: header -->
    
    <!-- S: main -->
    <div class="main container-fluid">
      <!-- S: score-enter -->
      <div class="score-enter row">
        <!-- S: select-court -->
        <ul class="select-court clearfix">
          <li>
            <select name="">
              <option value="1">1번 코트</option>
              <option value="2">2번 코트</option>
              <option value="3">3번 코트</option>
              <option value="4">4번 코트</option>
              <option value="5">5번 코트</option>
              <option value="6">6번 코트</option>
              <option value="7">7번 코트</option>
              <option value="8">8번 코트</option>
            </select>
          </li>
          <li>
            <select name="">
              <option value="">클레이코트</option>
              <option value="">하드코트</option>
              <option value="">카펫코트</option>
              <option value="">론코트</option>
              <option value="">앙투카코트</option>
            </select>
          </li>
        </ul>
        <ul class="match-info clearfix">
          <li id="DP_play-division">개인전</li>
          <li>복식</li>
          <li>신인부</li>
          <li class="match-round">
            <p>
              <span id="DP_play-num">1경기</span>
              <span>/</span>
              <span id="DP_play-round">16강</span>
            </p>
          </li>
          <li class="play-title" id="DP_play-title">>
            
          </li>
        </ul>
        <!-- E: select-court -->
          
          <!-- S: score-enter-main -->
          <div class="score-enter-main clearfix">
            <!-- S: display-board -->
            <div class="display-board clearfix">
              <!-- S: player-list -->
              <div class="player-list">
                <ul class="player-display group-a clearfix">
                  <li class="player-1">
                    <span class="name">김재범</span>
                    <span class="belong">비봉고등학교</span>
                  </li>
                  <li class="player-2">
                    <span class="name">최보라</span>
                    <span class="belong">중앙여자고등학교</span>
                  </li>
                </ul>
                <ul class="player-display group-b clearfix">
                  <li class="player-3">
                    <span class="name">최보라</span>
                    <span class="belong">강서어택,강서용어택단</span>
                  </li>
                  <li class="player-4">
                    <span class="name">김선영</span>
                    <span class="belong">클로,한양1</span>
                  </li>
                </ul>
              </div>
              <!-- E: player-list -->

              <!-- S: sel-result -->
              <ul class="sel-result clearfix">
                <li>
                  <select name="">
                    <option value="">::그 외 판정결과 선택해주세요::</option>
                    <option value="">::그 외 판정결과 선택해주세요::</option>
                  </select>
                </li>
                <li>
                  <select name="" class="win-type">
                    <option value="">기권승</option>
                    <option value="">부전승</option>
                    <option value="">실격</option>
                    <option value="">양선수 부전패</option>
                  </select>
                </li>
              </ul>
              <!-- E: sel-result -->

              <!-- S: score-board -->
              <div class="score-board">
                <!-- S: point-display -->
                <div class="point-display clearfix">
                  <ul>
                    <li class="total">
                      <span class="tit">TOTAL</span>
                      <span class="point">1</span>
                    </li>
                    <li>
                      <span class="tit">3SET</span>
                      <span class="point">-</span>
                      <span class="sub-point"></span>
                    </li>
                    <li>
                      <span class="tit">2SET</span>
                      <span class="point">-</span>
                      <span class="sub-point"></span>
                    </li>
                    <li>
                      <span class="tit">1SET</span>
                      <span class="point">7</span>
                      <span class="sub-point"></span>
                    </li>
                  </ul>
                  <span class="v-s">VS</span>
                  <ul>
                    <li>
                      <span class="tit">1SET</span>
                      <span class="point">6</span>
                      <span class="sub-point">(5)</span>
                    </li>
                    <li>
                      <span class="tit">2SET</span>
                      <span class="point">-</span>
                      <span class="sub-point"></span>
                    </li>
                    <li>
                      <span class="tit">3SET</span>
                      <span class="point">-</span>
                      <span class="sub-point"></span>
                    </li>
                    <li class="total">
                      <span class="tit">TOTAL</span>
                      <span class="point">-</span>
                    </li>
                  </ul>
                </div>
                <!-- E: point-display -->

                <!-- S: player-court -->
                <div class="player-court">
                  <!-- S: court-header -->
                  <div class="court-header">
                    <h2>
                      <span class="ic-deco"><img src="images/tournerment/public/tennis_ball_on@3x.png" alt></span>
                      <span>PLAYER COURT CHOICE</span>
                    </h2>
                    <a href="#" class="btn-modify">저장</a>
                  </div>
                  <!-- E: court-header -->

                  <!-- S: court -->
                  <div class="court">
                    <!-- S: point-box -->
                    <ul class="point-box left-box clearfix">
                      <li class="l-side">AD</li>
                      <li class="center v-s">VS</li>
                      <li class="r-side">40</li>
                    </ul>
                    <!-- E: point-box -->
                  </div>

                  <!-- S: player-box -->
                  <div class="player-box">
                    <!-- S: l-side -->
                    <ul class="l-side">
                      <li>
                        <select name="">
                          <option value="" selected>최보라</option>
                          <option value="">김선영</option>
                          <option value="">나윤주</option>
                          <option value="">지춘희</option>
                        </select>
                        <a href="#" class="btn player-btn">최보라</a>
                        <a href="#" class="serve on">
                          <span class="ic-deco">
                            <img src="images/tournerment/public/tennis_ball_on@3x.png" alt>
                          </span>
                        </a>
                      </li>
                      <li>
                        <select name="">
                          <option value="">최보라</option>
                          <option value="" selected>김선영</option>
                          <option value="">나윤주</option>
                          <option value="">지춘희</option>
                        </select>
                        <a href="#" class="btn player-btn">최보라</a>
                        <a href="#" class="serve">
                          <span class="ic-deco">
                            <img src="images/tournerment/public/tennis_ball_off@3x.png" alt>
                          </span>
                        </a>
                      </li>
                    </ul>
                    <!-- E: l-side -->
                  </div>
                  <!-- E: player-box -->
                  
                  <!-- S: player-box -->
                  <div class="player-box right-box clearfix">
                    <!-- S: r-side -->
                    <ul class="r-side">
                      <li>
                        <select name="">
                          <option value="">최보라</option>
                          <option value="">김선영</option>
                          <option value="" selected>나윤주</option>
                          <option value="">지춘희</option>
                        </select>
                        <a href="#" class="btn player-btn">최보라</a>
                        <a href="#" class="serve">
                          <span class="ic-deco">
                            <img src="images/tournerment/public/tennis_ball_off@3x.png" alt>
                          </span>
                        </a>
                      </li>
                      <li>
                        <select name="">
                          <option value="" >최보라</option>
                          <option value="">김선영</option>
                          <option value="">나윤주</option>
                          <option value="" selected>지춘희</option>
                        </select>
                        <a href="#" class="btn player-btn">최보라</a>
                        <a href="#" class="serve">
                          <span class="ic-deco">
                            <img src="images/tournerment/public/tennis_ball_off@3x.png" alt>
                          </span>
                        </a>
                      </li>
                    </ul>
                    <!-- E: r-side -->
                  </div>
                  <!-- E: player-box -->

                  <!-- S: recorder -->
                  <div class="recorder">
                    <dl>
                      <dt>기록관</dt>
                      <dd>황인창</dd>
                    </dl>
                  </div>
                  <!-- E: recorder -->
                <!-- E: court -->
                </div>
                <!-- E: player-court -->

                <!-- S: win-error -->
                <div class="win-error">
                  <dl class="win-type">
                    <dt>WIN</dt>
                    <dd>
                      <a href="#" class="btn btn-win-type on">IN</a>
                    </dd>
                    <dd>
                      <a href="#" class="btn btn-win-type">ACE</a>
                    </dd>
                  </dl>
                  <dl class="error-type">
                    <dt>ERROR</dt>
                    <dd>
                      <a href="#" class="btn btn-win-type">NET</a>
                    </dd>
                    <dd>
                      <a href="#" class="btn btn-win-type">OUT</a>
                    </dd>
                  </dl>
                </div>
                <!-- E: win-error -->

                <!-- S: point-end-box -->
                <div class="point-end-box">
                  <a href=".point-ipt-modal" class="btn btn-point-ipt" data-toggle="modal">게임 포인트 입력</a>
                  <a href="#" class="btn btn-game-over">경기종료</a>
                </div>
                <!-- E: point-end-box -->
              </div>
              <!-- E: display-board -->
            </div>
            <!-- E: score-enter-main -->
  
            <!-- S: skill-record-main -->
            <div class="skill-record-main">
              <!-- S: skill-btn -->
              <div class="skill-btn">
                <!-- S: shot -->
                <section class="shot">
                  <h3>SHOT</h3>
                  <ul class="clearfix">
                    <li><a href="#" class="btn btn-skill on">퍼스트서브</a></li>
                    <li><a href="#" class="btn btn-skill">스매싱</a></li>
                    <li><a href="#" class="btn btn-skill">F.리턴</a></li>
                    <li><a href="#" class="btn btn-skill">F.스트로크</a></li>
                    <li><a href="#" class="btn btn-skill">F.발리</a></li>
                    <li><a href="#" class="btn btn-skill">세컨 서브</a></li>
                    <li><a href="#" class="btn btn-skill">그라운드<br>스매싱</a></li>
                    <li><a href="#" class="btn btn-skill">B.리턴</a></li>
                    <li><a href="#" class="btn btn-skill">B.스트로크</a></li>
                    <li><a href="#" class="btn btn-skill">B.발리</a></li>
                  </ul>
                </section>
                <!-- E: shot -->
                
                <!-- S: technic type -->
                <section class="technic-type">
                  <h3>TECHNIC TYPE</h3>
                  <ul class="clearfix">
                    <li><a href="#" class="btn btn-skill">일반/수비</a></li>
                    <li><a href="#" class="btn btn-skill">어프로치</a></li>
                    <li><a href="#" class="btn btn-skill">패싱</a></li>
                    <li><a href="#" class="btn btn-skill">드롭</a></li>
                    <li><a href="#" class="btn btn-skill">포칭</a></li>
                  </ul>
                </section>
                <!-- E: technic type -->

                <!-- S: course -->
                <section class="course">
                  <h3>COURSE</h3>
                  <ul class="clearfix">
                    <li><a href="#" class="btn btn-skill">크로스</a></li>
                    <li><a href="#" class="btn btn-skill">스트레이트</a></li>
                    <li><a href="#" class="btn btn-skill">역크로스</a></li>
                    <li><a href="#" class="btn btn-skill">센터</a></li>
                    <li><a href="#" class="btn btn-skill">로브</a></li>
                  </ul>
                </section>
                <!-- E: course -->
              </div>
              <!-- E: skill-btn -->

              <!-- S: match-result -->
              <div class="match-result">
                <h3>득실기록</h3>
                <section class="clearfix">
                  <!-- S: set -->
                  <div class="set">
                    <h4>3SET</h4>
                    <ul class="result-list">
                      <li>나윤주 <span class="serve">(s)</span></li>
                      <li class="you">40 : 15</li>
                      <li>포핸드 스트로크 /</li>
                      <li>패싱 /</li>
                      <li>스트레이트 /</li>
                      <li>Out</li>
                      <li>
                        <a href="#" class="btn-del">
                          <span class="ic-deco"><i class="fa fa-times" aria-hidden="true"></i></span>
                          <span class="txt">삭제</span>
                        </a></li>
                    </ul>
                    <ul class="result-list">
                      <li>나윤주</li>
                      <li class="me">40 : 15</li>
                      <li>포핸드 스트로크 /</li>
                      <li>패싱 /</li>
                      <li>스트레이트 /</li>
                      <li>Out</li>
                      <li>
                        <a href="#" class="btn-del">
                          <span class="ic-deco"><i class="fa fa-times" aria-hidden="true"></i></span>
                          <span class="txt">삭제</span>
                        </a></li>
                    </ul>
                    <ul class="result-list">
                      <li>나윤주</li>
                      <li class="you">40 : 15</li>
                      <li>포핸드 스트로크 /</li>
                      <li>패싱 /</li>
                      <li>스트레이트 /</li>
                      <li>Out</li>
                      <li>
                        <a href="#" class="btn-del">
                          <span class="ic-deco"><i class="fa fa-times" aria-hidden="true"></i></span>
                          <span class="txt">삭제</span>
                        </a></li>
                    </ul>
                    <ul class="result-list">
                      <li>나윤주</li>
                      <li class="me">40 : 15</li>
                      <li>포핸드 스트로크 /</li>
                      <li>패싱 /</li>
                      <li>스트레이트 /</li>
                      <li>Out</li>
                      <li>
                        <a href="#" class="btn-del">
                          <span class="ic-deco"><i class="fa fa-times" aria-hidden="true"></i></span>
                          <span class="txt">삭제</span>
                        </a></li>
                    </ul>
                    <ul class="result-list">
                      <li>나윤주</li>
                      <li class="you">40 : 15</li>
                      <li>포핸드 스트로크 /</li>
                      <li>패싱 /</li>
                      <li>스트레이트 /</li>
                      <li>Out</li>
                      <li>
                        <a href="#" class="btn-del">
                          <span class="ic-deco"><i class="fa fa-times" aria-hidden="true"></i></span>
                          <span class="txt">삭제</span>
                        </a></li>
                    </ul>
                    <ul class="result-list">
                      <li>나윤주</li>
                      <li class="me">40 : 15</li>
                      <li>포핸드 스트로크 /</li>
                      <li>패싱 /</li>
                      <li>스트레이트 /</li>
                      <li>Out</li>
                      <li>
                        <a href="#" class="btn-del">
                          <span class="ic-deco"><i class="fa fa-times" aria-hidden="true"></i></span>
                          <span class="txt">삭제</span>
                        </a></li>
                    </ul>
                  </div>
                  <!-- E: set -->
                  <!-- S: set -->
                  <div class="set">
                    <h4>2SET</h4>
                    <ul class="result-list">
                      <li>나윤주 <span class="serve">(s)</span></li>
                      <li class="you">40 : 15</li>
                      <li>포핸드 스트로크 /</li>
                      <li>패싱 /</li>
                      <li>스트레이트 /</li>
                      <li>Out</li>
                      <li>
                        <a href="#" class="btn-del">
                          <span class="ic-deco"><i class="fa fa-times" aria-hidden="true"></i></span>
                          <span class="txt">삭제</span>
                        </a></li>
                    </ul>
                    <ul class="result-list">
                      <li>나윤주</li>
                      <li class="me">40 : 15</li>
                      <li>포핸드 스트로크 /</li>
                      <li>패싱 /</li>
                      <li>스트레이트 /</li>
                      <li>Out</li>
                      <li>
                        <a href="#" class="btn-del">
                          <span class="ic-deco"><i class="fa fa-times" aria-hidden="true"></i></span>
                          <span class="txt">삭제</span>
                        </a></li>
                    </ul>
                    <ul class="result-list">
                      <li>나윤주</li>
                      <li class="you">40 : 15</li>
                      <li>포핸드 스트로크 /</li>
                      <li>패싱 /</li>
                      <li>스트레이트 /</li>
                      <li>Out</li>
                      <li>
                        <a href="#" class="btn-del">
                          <span class="ic-deco"><i class="fa fa-times" aria-hidden="true"></i></span>
                          <span class="txt">삭제</span>
                        </a></li>
                    </ul>
                    <ul class="result-list">
                      <li>나윤주</li>
                      <li class="me">40 : 15</li>
                      <li>포핸드 스트로크 /</li>
                      <li>패싱 /</li>
                      <li>스트레이트 /</li>
                      <li>Out</li>
                      <li>
                        <a href="#" class="btn-del">
                          <span class="ic-deco"><i class="fa fa-times" aria-hidden="true"></i></span>
                          <span class="txt">삭제</span>
                        </a></li>
                    </ul>
                    <ul class="result-list">
                      <li>나윤주</li>
                      <li class="you">40 : 15</li>
                      <li>포핸드 스트로크 /</li>
                      <li>패싱 /</li>
                      <li>스트레이트 /</li>
                      <li>Out</li>
                      <li>
                        <a href="#" class="btn-del">
                          <span class="ic-deco"><i class="fa fa-times" aria-hidden="true"></i></span>
                          <span class="txt">삭제</span>
                        </a></li>
                    </ul>
                    <ul class="result-list">
                      <li>나윤주</li>
                      <li class="me">40 : 15</li>
                      <li>포핸드 스트로크 /</li>
                      <li>패싱 /</li>
                      <li>스트레이트 /</li>
                      <li>Out</li>
                      <li>
                        <a href="#" class="btn-del">
                          <span class="ic-deco"><i class="fa fa-times" aria-hidden="true"></i></span>
                          <span class="txt">삭제</span>
                        </a></li>
                    </ul>
                  </div>
                  <!-- E: set -->
                  <!-- S: set -->
                  <div class="set">
                    <h4>1SET</h4>
                    <ul class="result-list">
                      <li>나윤주 <span class="serve">(s)</span></li>
                      <li class="you">40 : 15</li>
                      <li>포핸드 스트로크 /</li>
                      <li>패싱 /</li>
                      <li>스트레이트 /</li>
                      <li>Out</li>
                      <li>
                        <a href="#" class="btn-del">
                          <span class="ic-deco"><i class="fa fa-times" aria-hidden="true"></i></span>
                          <span class="txt">삭제</span>
                        </a></li>
                    </ul>
                    <ul class="result-list">
                      <li>나윤주</li>
                      <li class="me">40 : 15</li>
                      <li>포핸드 스트로크 /</li>
                      <li>패싱 /</li>
                      <li>스트레이트 /</li>
                      <li>Out</li>
                      <li>
                        <a href="#" class="btn-del">
                          <span class="ic-deco"><i class="fa fa-times" aria-hidden="true"></i></span>
                          <span class="txt">삭제</span>
                        </a></li>
                    </ul>
                    <ul class="result-list">
                      <li>나윤주</li>
                      <li class="you">40 : 15</li>
                      <li>포핸드 스트로크 /</li>
                      <li>패싱 /</li>
                      <li>스트레이트 /</li>
                      <li>Out</li>
                      <li>
                        <a href="#" class="btn-del">
                          <span class="ic-deco"><i class="fa fa-times" aria-hidden="true"></i></span>
                          <span class="txt">삭제</span>
                        </a></li>
                    </ul>
                    <ul class="result-list">
                      <li>나윤주</li>
                      <li class="me">40 : 15</li>
                      <li>포핸드 스트로크 /</li>
                      <li>패싱 /</li>
                      <li>스트레이트 /</li>
                      <li>Out</li>
                      <li>
                        <a href="#" class="btn-del">
                          <span class="ic-deco"><i class="fa fa-times" aria-hidden="true"></i></span>
                          <span class="txt">삭제</span>
                        </a></li>
                    </ul>
                    <ul class="result-list">
                      <li>나윤주</li>
                      <li class="you">40 : 15</li>
                      <li>포핸드 스트로크 /</li>
                      <li>패싱 /</li>
                      <li>스트레이트 /</li>
                      <li>Out</li>
                      <li>
                        <a href="#" class="btn-del">
                          <span class="ic-deco"><i class="fa fa-times" aria-hidden="true"></i></span>
                          <span class="txt">삭제</span>
                        </a></li>
                    </ul>
                    <ul class="result-list">
                      <li>나윤주</li>
                      <li class="me">40 : 15</li>
                      <li>포핸드 스트로크 /</li>
                      <li>패싱 /</li>
                      <li>스트레이트 /</li>
                      <li>Out</li>
                      <li>
                        <a href="#" class="btn-del">
                          <span class="ic-deco"><i class="fa fa-times" aria-hidden="true"></i></span>
                          <span class="txt">삭제</span>
                        </a></li>
                    </ul>
                  </div>
                  <!-- E: set -->
                </section>
              </div>
              <!-- E: match-result -->
            </div>
            <!-- E: skill-record-main -->
          </div>
          <!-- E: score-board -->
    </div>
    <!-- E: main -->

    <!-- S: start-modal -->
    <div class="modal fade start-modal">
      <div class="modal-dialog">
        <!-- S: modal-content -->
        <div class="modal-content">
          <!-- S: modal-header -->
          <div class="modal-header">
            <h3>기록관의 이름을 입력해주세요.</h3>
            <input type="text" placeholder="홍길동">
          </div>
          <!-- E: modal-header -->
          <!-- S: modal-body -->
          <div class="modal-body">
            <h4>경기시작</h4>
            <!-- S: ipt-time -->
            <div class="ipt-time">
              <ul class="time-list">
                <li>
                  <!-- <a href="#">0</a> -->
                  <input type="text" placeholder="0" maxlength="2">
                </li>
                <li>
                  <!-- <a href="#">0</a> -->
                  <input type="text" placeholder="0" maxlength="2">
                </li>
                <li class="divn"><span>:</span></li>
                <li>
                  <!-- <a href="#">0</a> -->
                  <input type="text" placeholder="0" maxlength="2">
                </li>
                <li>
                  <!-- <a href="#">0</a> -->
                  <input type="text" placeholder="0" maxlength="2">
                </li>
              </ul>
              <p class="ipt-guide">경기 시작시간을 입력해주세요.</p>
            </div>
            <!-- E: ipt-time -->
          </div>
          <!-- E: modal-body -->
          <!-- S: modal-footer -->
          <div class="modal-footer">
            <a href="#" class="btn btn-repair" data-toggle="modal" data-target=".start-modal" role="button">경기시작</a>
            <a href="#" class="btn btn-close" role="button">대진표 바로가기</a>
          </div>
          <!-- E: modal-footer -->
        </div>
        <!-- E: modal-content -->
      </div>
    </div>
    <!-- E: start-modal -->

    <!-- S: game-point-modal -->
    <!-- #include file = './modal/game_point.asp' -->
    <!-- E: game-point-modal -->

    <!-- custom.js -->
    <script src="js/main.js"></script>
    <script>
      // $('.start-modal').modal('show');
      $('.point-ipt-modal').modal('show');
    </script>
  </body>
</html>