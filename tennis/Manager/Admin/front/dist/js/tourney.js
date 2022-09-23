
      var PlayerGameNum=1;
      var PlayerResultNum=1;

      
      //댑스별로 상단에서 하단으로 내려오는 리스트 카운트하여 1/2 처리. 반드시 짝수여야 한다.(부전승은 2)
      var LLevelLineCount = 0;
      var RLevelLineCount = 0;

//      if ('addEventListener' in document) {
//          document.addEventListener('DOMContentLoaded', function () {
//              FastClick.attach(document.body);
//          }, false);
//      }

      var onLoad = function () {

          console.log("onLoad");
          document.addEventListener("deviceready", onDeviceReady, false);

          $("#tourney_title").html(localStorage.getItem("GameTitleName"));
          SettingSearch();

          localStorage.setItem("GroupGameGb", $('input:radio[name="game-type"]:checked').val());

          if (localStorage.getItem("BackPage") == "enter-score") {
              $("#search").trigger("click");
          }


          if (GroupGameGb != "") {
              $('input:radio[name=game-type]:input[value=' + GroupGameGb + ']').attr("checked", true);
              localStorage.setItem("GroupGameGb", $('input:radio[name="game-type"]:checked').val());
          } else {
              localStorage.setItem("GroupGameGb", $('input:radio[name="game-type"]:checked').val());
          }

          if (TeamGb != "") {
              localStorage.setItem("TeamGb", TeamGb);
          } else {
              localStorage.setItem("TeamGb", $("#TeamGb").val());
          }

          if (Sex != "") {
              localStorage.setItem("Sex", Sex);
          } else {
              localStorage.setItem("Sex", $("#SexLevel option:selected").attr("data-sex"));
          }

          if (Level != "") {
              localStorage.setItem("Level", Level);
          } else {
              localStorage.setItem("Level", $("#SexLevel option:selected").attr("data-level"));
          }
          localStorage.setItem("SexLevel", $('#SexLevel').val());

      }

      var SettingSearch = function () {

          console.log("SettingSearch");

          //경기스코어 입력을 통해 들어왔다면..
          if (localStorage.getItem("IntroIndex") == "1") {
              //색상별라운드 상태안내, 대진표 및 리스트탭, 메달결과
              $("#DP_Guide").css("display", "");
              $("#DP_Tab").css("display", "none");
              $("#DP_Medal").css("display", "none");
          }
          else {
              $("#DP_Guide").css("display", "none");
              $("#DP_Tab").css("display", "");
              $("#DP_Medal").css("display", "");
          }

          //이전버튼 눌러서 돌아왔을때는 담아놓은값으로 조회..
          if (localStorage.getItem("BackPage") == "enter-score") {
              var PromiseInjuryGb = $.when(m_SelTeamCode_NowGame("#TeamGb", localStorage.getItem("TeamGb")));

              console.log("BackPage");
          }
          else {
              var PromiseInjuryGb = $.when(m_SelTeamCode_NowGame("#TeamGb", localStorage.getItem("TeamGb")));

              console.log("else BackPage");
          }



          PromiseInjuryGb.done(function () {

              console.log("PromiseInjuryGb.done");

              //if(strBackPage == "enter-score"){
              if (localStorage.getItem("TeamGb") != "" && localStorage.getItem("Sex") != "") {
                  console.log("TeamGb Sex ! ''");
                  m_drLevelList_sum_NowGame("#SexLevel", localStorage.getItem("TeamGb"), localStorage.getItem("SexLevel"));
                  $("#search").click();
              }
              else {
                  console.log("TeamGb Sex =''");
                  if ($("#TeamGb").val() != "" && $("#SexLevel option:selected").attr("data-sex") != "") {
                      m_drLevelList_sum_NowGame("#SexLevel", $("#TeamGb").val(), "");
                  }
              }
          });
      }


      $(document).ready(function () {
          window.onpopstate = function (event) {
              if ( !($("#show-score,#groupshow-score").hasClass('in')) ) {
                  return;
              }
              $("#show-score,#groupshow-score").modal("hide");
              console.log('hide this = ', this);
              if (history.state == null) {

              } else {

                  history.back();
              }
          };


          $('#show-score,#groupshow-score').on('show.bs.modal', function (e) {

          });
          $('#show-score,#groupshow-score').on('hide.bs.modal', function (e) {
              if (history.state == null) {

              } else {

                  history.back();
              }
          });

          console.log("(document).ready");


          // $("#btnlookCheck").hide();
          $("#btnlookCheck_natfinal").hide();
          $("#sexLevelCheck").show();
          $("#sexLevelCheck_natfinal").show();


          localStorage.setItem("GroupGameGb", GroupGameGb);
          localStorage.setItem("TeamGb", TeamGb);
          localStorage.setItem("Level", Level);
          localStorage.setItem("Sex", Sex);
          localStorage.setItem("SexLevel", Sex + "|" + Level);


          if (localStorage.getItem("TeamGb") != "" && localStorage.getItem("Sex") != "") {

              console.log("(document).ready GroupGameGb TeamGb");
              if (localStorage.getItem("GroupGameGb") == "sd040002") {
                  m_drLevelList_sum_NowGame("#SexLevel", localStorage.getItem("TeamGb"), "");
              } else {
                  m_drLevelList_sum_NowGame("#SexLevel", localStorage.getItem("TeamGb"), localStorage.getItem("SexLevel"));
              }
          }



          /*검색*/
          $("#TeamGb").change(function () {
              if ($("#TeamGb").val() != "") {
                  m_drLevelList_sum_NowGame("#SexLevel", $("#TeamGb").val(), '');
              }
          });

          $("#Sex").change(function () {
              if ($("#TeamGb").val() != "" && $("#SexLevel option:selected").attr("data-sex") != "") {
                  m_drLevelList_sum_NowGame("#SexLevel", $("#TeamGb").val(), '');
              }
          });

          /*
          $(".tourney-mode").css("display", "none");

          $("#Btn_Tournament").click(function () {
          $(".list_league").css("display", "");
          });

          $("#Btn_ResultList").click(function () {
          $(".list_league").css("display", "none");
          });
          */


          $("#search").click(function () {

              $("#Btn_Tournament").click();

              if (localStorage.getItem("GroupGameGb") == "sd040002") {
                  $(".tourney-mode").addClass("group");
              } else {
                  $(".tourney-mode").removeClass("group");
                  if ($("#SexLevel").val() == "") {
                      alert("체급을 선택 하지 않았습니다.");
                      $("#SexLevel").focus();
                      $("#sexLevelCheck").show();
                      $("#sexLevelCheck_natfinal").show();
                      $("#btnlookCheck").hide();
                      $("#btnlookCheck_natfinal").hide();

                      $(".tourney-mode.tourney-result").hide();
                      return false;
                  } else {
                      $("#btnlookCheck").show();
                      $("#btnlookCheck_natfinal").show();
                      $("#sexLevelCheck").hide();
                      $("#sexLevelCheck_natfinal").hide();
                  }
              }

              /*
              if ($("#Btn_Tournament").attr("class") == "tab-btn on") {
              $(".list_league").css("display", "");
              $("#DP_ResultReport").css("display", "none");
              }
              else if ($("#Btn_Tournament").attr("class") == "tab-btn") {
              $(".list_league").css("display", "none");
              $("#DP_ResultReport").css("display", "");
              }
              */

              localStorage.setItem("TeamGb", $("#TeamGb").val());

              if ($("#SexLevel").val() != "") {
                  localStorage.setItem("SexLevel", $("#SexLevel").val());
                  localStorage.setItem("Sex", $("#SexLevel option:selected").attr("data-sex"));
                  localStorage.setItem("Level", $("#SexLevel option:selected").attr("data-level"));


                  $("#sexLevelCheck").hide();
              } else {
                  if (localStorage.getItem("GroupGameGb") == "sd040002") {
                      $("#SexLevel option:eq(1)").attr("selected", "selected");
                  }
              }

              //검색시 처리
              //if ($("#TeamGb").val() != "" && $("#Sex").val() != "" && $("#Level").val() != ""){
              if (localStorage.getItem("#TeamGb") != "" && localStorage.getItem("#Sex") != "" && localStorage.getItem("#Level") != "") {

                  var str_checkgamelevel = checkgamelevel();

                  view_result(str_checkgamelevel);

                  //리그전일때
                  if (str_checkgamelevel == "sd043001") {
                      //$(".tourney-mode").css("display", "none");
                      //$(".list_league").css("display", "");
                      //$(".tourney.clearfix").css("height", "0px");
                      //리그전 대진표 불러오기
                      //메달가져오기
                      select_medal();
                      load_league();
                      select_RoundList();

                  }
                  //최종평가전
                  else if (str_checkgamelevel == "sd043005") {

                      //$(".tourney-main").css("display","none");
                      //$(".league").css("display","none");
                      //$(".IJF_tourney").css("display","none");
                      //$(".natfinal_tourney").css("display","");     

                      var strBackPage = localStorage.getItem("BackPage");

                      //메달가져오기
                      select_medal();
                      //리스트보기
                      select_RoundList();

                      var loaddata_playnumber = $.when(playnumberCheck());

                      loaddata_playnumber.done(function (playnumber_sdata) {

                          var playnumber_myArr = JSON.parse(playnumber_sdata);

                          if (playnumber_myArr.length > 0) {
                              //패자부활전 토너먼트 보이게
                              if (Number(playnumber_myArr[0].strCount8) > 1 || Number(playnumber_myArr[0].strCount11) > 1) {
                                  $("#DP_natfinal_02").css("display", "");
                              }
                              else {
                                  $("#DP_natfinal_02").css("display", "none");
                              }
                              //패자부활전 토너먼트 보이게
                              if (Number(playnumber_myArr[0].strCount13) > 0) {
                                  $("#DP_natfinal_03").css("display", "");
                              }
                              else {
                                  $("#DP_natfinal_03").css("display", "none");
                              }
                              //패자부활전 토너먼트 보이게
                              if (Number(playnumber_myArr[0].strCount14) > 0) {
                                  $("#DP_natfinal_04").css("display", "");
                              }
                              else {
                                  $("#DP_natfinal_04").css("display", "none");
                              }
                              //패자부활전 토너먼트 보이게
                              if (Number(playnumber_myArr[0].strCount15) > 0) {
                                  $("#DP_natfinal_05").css("display", "");
                              }
                              else {
                                  $("#DP_natfinal_05").css("display", "none");
                              }
                          }
                      });


                      //좌측 토너먼트 준결승 선수 및 경기결과
                      var loaddata_Pro_1 = $.when(callRGameLevel("sd030001", strBackPage, ""), callRGameResult(strBackPage));

                      loaddata_Pro_1.done(function (sdata, sdata1) {


                          if (sdata.length > 2) {

                              LLevelLineCount = 0;
                              RLevelLineCount = 0;

                              var myArr_sdata = JSON.parse(sdata);

                              var myArr1_sdata1 = JSON.parse(sdata1);

                              //최종평가전 1대진표 첫경기번호
                              PlayerGameNum = 1;

                              //S: 최종평가전 1대진표 그리기
                              var loaddataPro1_natfinal_L_01 = $.when(setPlayerList(myArr_sdata, "#match_list_left_natfinal_01"), setPlayerLine(sdata, "#match_list_left_natfinal_01", "sd030001", sdata1, "#round_01_left_natfinal_01", "#round_01_right_natfinal_01", "01"), setPlayerName1(myArr_sdata, "#match_list_left_natfinal_01", "sd030001", myArr1_sdata1));

                              loaddataPro1_natfinal_L_01.done(function (sdata, varHeight) {

                              });

                              //우측호출
                              var loaddataR_Pro = $.when(callRGameLevel("sd030002", strBackPage, ""));

                              loaddataR_Pro.done(function (Rsdata) {

                                  var myArr_rsdata = JSON.parse(Rsdata);

                                  var loaddataPro1_natfinal_R_01 = $.when(setPlayerList(myArr_rsdata, "#match_list_right_natfinal_01"), setPlayerLine(Rsdata, "#match_list_right_natfinal_01", "sd030002", sdata1, "#round_01_left_natfinal_01", "#round_01_right_natfinal_01", "01"), setPlayerName1(myArr_rsdata, "#match_list_right_natfinal_01", "sd030002", myArr1_sdata1));

                                  loaddataPro1_natfinal_R_01.done(function (sdata, varHeight) {

                                  });

                              });

                              //2번째라인(좌)
                              setPlayerLineMid("natfinal_01", "sd030001", sdata1, "02", 4);
                              //2번째라인(우)
                              setPlayerLineMid("natfinal_01", "sd030002", sdata1, "02", 4);

                              setFinal("#final_div_natfinal_01", "sd030001", sdata1, "03", 8);

                              //E: 최종평가전 1대진표 그리기


                          }
                      });

                      //좌측 토너먼트 준결승 선수 및 경기결과
                      var loaddata_Pro_2 = $.when(callRGameLevel_NationalLoser("sd030001", strBackPage, ""), callRGameResult(strBackPage));

                      loaddata_Pro_2.done(function (sdata, sdata1) {

                          if (sdata.length > 2) {

                              LLevelLineCount = 0;
                              RLevelLineCount = 0;

                              var myArr_sdata = JSON.parse(sdata);

                              var myArr1_sdata1 = JSON.parse(sdata1);

                              //최종평가전 1대진표 첫경기번호
                              PlayerGameNum = 8;

                              //S: 최종평가전 1대진표 그리기
                              var loaddataPro1_natfinal_L_02 = $.when(setPlayerList(myArr_sdata, "#match_list_left_natfinal_02"), setPlayerLine(sdata, "#match_list_left_natfinal_02", "sd030001", sdata1, "#round_01_left_natfinal_02", "#round_01_right_natfinal_02", "01"), setPlayerName1(myArr_sdata, "#match_list_left_natfinal_02", "sd030001", myArr1_sdata1));

                              loaddataPro1_natfinal_L_02.done(function (sdata, varHeight) {

                              });

                              //우측호출
                              var loaddataR_Pro = $.when(callRGameLevel_NationalLoser("sd030002", strBackPage, ""));

                              loaddataR_Pro.done(function (Rsdata) {

                                  var myArr_rsdata = JSON.parse(Rsdata);

                                  var loaddataPro1_natfinal_R_02 = $.when(setPlayerList(myArr_rsdata, "#match_list_right_natfinal_02"), setPlayerLine(Rsdata, "#match_list_right_natfinal_02", "sd030002", sdata1, "#round_01_left_natfinal_02", "#round_01_right_natfinal_02", "01"), setPlayerName1(myArr_rsdata, "#match_list_right_natfinal_02", "sd030002", myArr1_sdata1));

                                  loaddataPro1_natfinal_R_02.done(function (sdata, varHeight) {

                                  });

                              });

                              console.log("asd" + sdata1);

                              //2번째라인(좌)
                              setPlayerLineMid("natfinal_02", "sd030001", sdata1, "02", 4);
                              //2번째라인(우)
                              setPlayerLineMid("natfinal_02", "sd030002", sdata1, "02", 4);

                              setFinal("#final_div_natfinal_02", "sd030001", sdata1, "03", 8);

                              //E: 최종평가전 1대진표 그리기


                          }
                      });

                      //패자부활전 부전
                      var loaddataR_Pro_2gang_01 = $.when(callRGameLevel_NationalLoser("", strBackPage, "13"));

                      loaddataR_Pro_2gang_01.done(function (sdata_01) {
                          elsegame_draw(sdata_01, "natfinal_03", "13");
                      });

                      //패자부활전 결승
                      var loaddataR_Pro_2gang_02 = $.when(callRGameLevel_NationalLoser("", strBackPage, "14"));

                      loaddataR_Pro_2gang_02.done(function (sdata_02) {
                          elsegame_draw(sdata_02, "natfinal_04", "14");
                      });

                      //패자부활전 재경기
                      var loaddataR_Pro_2gang_03 = $.when(callRGameLevel_NationalLoser("", strBackPage, "15"));

                      loaddataR_Pro_2gang_03.done(function (sdata_03) {
                          elsegame_draw(sdata_03, "natfinal_05", "15");

                      });


                  }

                  else {
                      //$(".list_league").css("display", "none");
                      $(".list_league").html("");
                      $("#DP_MedalList").show();

                      //대회별 결과보기 일 경우...
                      //if (localStorage.getItem("IntroIndex") == "2" || localStorage.getItem("IntroIndex") == "3" || localStorage.getItem("IntroIndex") == "4" || localStorage.getItem("IntroIndex") == "5") {
                      //메달가져오기
                      select_medal();

                      //리스트 몇강인지 가져오기
                      select_RoundList();

                      PlayerGameNum = 1;
                      PlayerResultNum = 1;

                      LLevelLineCount = 0;
                      RLevelLineCount = 0;

                      var strBackPage = localStorage.getItem("BackPage");

                      //좌측호출
                      var loaddata_Pro = $.when(callRGameLevel("sd030001", strBackPage), callRGameResult(strBackPage));

                      //sdata : callRGameLevel("sd030001") 의 return 값
                      //sdata1 : callRGameResult() 의 return 값
                      loaddata_Pro.done(function (sdata, sdata1) {

                          if (sdata.length > 2) {
                              $(".tourney-mode").css("display", "");

                              var myArr = JSON.parse(sdata);

                              //128강,64강
                              var varTotRound = myArr[0].TotRound;

                              //좌측선수리스트
                              PlayerList(sdata, "#match_list_left", "sd030001", sdata1);

                              //우측호출
                              var loaddataR_Pro = $.when(callRGameLevel("sd030002", strBackPage));

                              loaddataR_Pro.done(function (Rsdata) {
                                  //player list loading...

                                  //우측선수리스트
                                  PlayerList(Rsdata, "#match_list_right", "sd030002", sdata1);

                                  console.log("varTotRound:" + varTotRound);

                                  //128강
                                  if (varTotRound == "128") {

                                      //사이즈변경처리
                                      //$(".tourney").width("1260px");
                                      $(".tourney").height("4600px");


                                      //2번째라인(좌)
                                      setPlayerLineMid("", "sd030001", sdata1, "02", 4);

                                      //2번째승리자이름(좌)
                                      setPlayerNameMid("", "", "sd030001", sdata1, "02", 4);

                                      //2번째라인(우)
                                      setPlayerLineMid("", "sd030002", sdata1, "02", 4);

                                      //2번째승리자이름(우)
                                      setPlayerNameMid("", "", "sd030002", sdata1, "02", 4);

                                      //3번째라인(좌)
                                      setPlayerLineMid("", "sd030001", sdata1, "03", 8);

                                      //3번째승리자이름(좌)
                                      setPlayerNameMid("", "", "sd030001", sdata1, "03", 8);

                                      //3번째라인(우)
                                      setPlayerLineMid("", "sd030002", sdata1, "03", 8);

                                      //3번째승리자이름(우)
                                      setPlayerNameMid("", "", "sd030002", sdata1, "03", 8);


                                      //4번째라인(좌)
                                      setPlayerLineMid("", "sd030001", sdata1, "04", 16);

                                      //4번째승리자이름(좌)
                                      setPlayerNameMid("", "", "sd030001", sdata1, "04", 16);

                                      //4번째라인(우)
                                      setPlayerLineMid("", "sd030002", sdata1, "04", 16);

                                      //4번째승리자이름(우)
                                      setPlayerNameMid("", "", "sd030002", sdata1, "04", 16);


                                      //5번째라인(좌)
                                      setPlayerLineMid("", "sd030001", sdata1, "05", 32);

                                      //5번째승리자이름(좌)
                                      setPlayerNameMid("", "", "sd030001", sdata1, "05", 32);

                                      //5번째라인(우)
                                      setPlayerLineMid("", "sd030002", sdata1, "05", 32);

                                      //5번째승리자이름(우)
                                      setPlayerNameMid("", "", "sd030002", sdata1, "05", 32);


                                      //6번째라인(좌)
                                      setPlayerLineMid("", "sd030001", sdata1, "06", 64);

                                      //6번째승리자이름(좌)
                                      setPlayerNameMid("", "", "sd030001", sdata1, "06", 64);

                                      //6번째라인(우)
                                      setPlayerLineMid("", "sd030002", sdata1, "06", 64);

                                      //6번째승리자이름(우)
                                      setPlayerNameMid("", "", "sd030002", sdata1, "06", 64);

                                      $("#round_06_left").show();
                                      $("#winner_06_left").show();
                                      $("#round_06_right").show();
                                      $("#winner_06_right").show();

                                      $("#round_05_left").show();
                                      $("#winner_05_left").show();
                                      $("#round_05_right").show();
                                      $("#winner_05_right").show();

                                      $("#round_04_left").show();
                                      $("#winner_04_left").show();
                                      $("#round_04_right").show();
                                      $("#winner_04_right").show();

                                      $("#round_03_left").show();
                                      $("#winner_03_left").show();
                                      $("#round_03_right").show();
                                      $("#winner_03_right").show();

                                      $("#round_02_left").show();
                                      $("#winner_02_left").show();
                                      $("#round_02_right").show();
                                      $("#winner_02_right").show();

                                      $("#round_01_left").show();
                                      $("#winner_01_left").show();
                                      $("#round_01_right").show();
                                      $("#winner_01_right").show();

                                      setFinal("", "sd030001", sdata1, "07", 128);

                                  } else if (varTotRound == "64") {
                                      //64강

                                      //$(".tourney").width("1260px");
                                      $(".tourney").height("2300px");

                                      //2번째라인(좌)
                                      setPlayerLineMid("", "sd030001", sdata1, "02", 4);

                                      //2번째승리자이름(좌)
                                      setPlayerNameMid("", "", "sd030001", sdata1, "02", 4);

                                      //2번째라인(우)
                                      setPlayerLineMid("", "sd030002", sdata1, "02", 4);

                                      //2번째승리자이름(우)
                                      setPlayerNameMid("", "", "sd030002", sdata1, "02", 4);

                                      //3번째라인(좌)
                                      setPlayerLineMid("", "sd030001", sdata1, "03", 8);

                                      //3번째승리자이름(좌)
                                      setPlayerNameMid("", "", "sd030001", sdata1, "03", 8);

                                      //3번째라인(우)
                                      setPlayerLineMid("", "sd030002", sdata1, "03", 8);

                                      //3번째승리자이름(우)
                                      setPlayerNameMid("", "", "sd030002", sdata1, "03", 8);

                                      //4번째라인(좌)
                                      setPlayerLineMid("", "sd030001", sdata1, "04", 16);

                                      //4번째승리자이름(좌)
                                      setPlayerNameMid("", "", "sd030001", sdata1, "04", 16);

                                      //4번째라인(우)
                                      setPlayerLineMid("", "sd030002", sdata1, "04", 16);

                                      //4번째승리자이름(우)
                                      setPlayerNameMid("", "", "sd030002", sdata1, "04", 16);


                                      //5번째라인(좌)
                                      setPlayerLineMid("", "sd030001", sdata1, "05", 32);

                                      //5번째승리자이름(좌)
                                      setPlayerNameMid("", "", "sd030001", sdata1, "05", 32);

                                      //5번째라인(우)
                                      setPlayerLineMid("", "sd030002", sdata1, "05", 32);

                                      //5번째승리자이름(우)
                                      setPlayerNameMid("", "", "sd030002", sdata1, "05", 32);

                                      $("#round_06_left").hide();
                                      $("#winner_06_left").hide();
                                      $("#round_06_right").hide();
                                      $("#winner_06_right").hide();

                                      $("#round_05_left").show();
                                      $("#winner_05_left").show();
                                      $("#round_05_right").show();
                                      $("#winner_05_right").show();

                                      $("#round_04_left").show();
                                      $("#winner_04_left").show();
                                      $("#round_04_right").show();
                                      $("#winner_04_right").show();

                                      $("#round_03_left").show();
                                      $("#winner_03_left").show();
                                      $("#round_03_right").show();
                                      $("#winner_03_right").show();

                                      $("#round_02_left").show();
                                      $("#winner_02_left").show();
                                      $("#round_02_right").show();
                                      $("#winner_02_right").show();

                                      $("#round_01_left").show();
                                      $("#winner_01_left").show();
                                      $("#round_01_right").show();
                                      $("#winner_01_right").show();

                                      setFinal("", "sd030001", sdata1, "06", 64);

                                  } else if (varTotRound == "32") {
                                      //32강

                                      //$(".tourney").width("1400px");
                                      $(".tourney").height("1250px");

                                      //2번째라인(좌)
                                      setPlayerLineMid("", "sd030001", sdata1, "02", 4);

                                      //2번째승리자이름(좌)
                                      setPlayerNameMid("", "", "sd030001", sdata1, "02", 4);

                                      //2번째라인(우)
                                      setPlayerLineMid("", "sd030002", sdata1, "02", 4);

                                      //2번째승리자이름(우)
                                      setPlayerNameMid("", "", "sd030002", sdata1, "02", 4);

                                      //3번째라인(좌)
                                      setPlayerLineMid("", "sd030001", sdata1, "03", 8);

                                      //3번째승리자이름(좌)
                                      setPlayerNameMid("", "", "sd030001", sdata1, "03", 8);

                                      //3번째라인(우)
                                      setPlayerLineMid("", "sd030002", sdata1, "03", 8);

                                      //3번째승리자이름(우)
                                      setPlayerNameMid("", "", "sd030002", sdata1, "03", 8);

                                      //4번째라인(좌)
                                      setPlayerLineMid("", "sd030001", sdata1, "04", 16);

                                      //4번째승리자이름(좌)
                                      setPlayerNameMid("", "", "sd030001", sdata1, "04", 16);

                                      //4번째라인(우)
                                      setPlayerLineMid("", "sd030002", sdata1, "04", 16);

                                      //4번째승리자이름(우)
                                      setPlayerNameMid("", "", "sd030002", sdata1, "04", 16);



                                      $("#round_06_left").hide();
                                      $("#winner_06_left").hide();
                                      $("#round_06_right").hide();
                                      $("#winner_06_right").hide();

                                      $("#round_05_left").hide();
                                      $("#winner_05_left").hide();
                                      $("#round_05_right").hide();
                                      $("#winner_05_right").hide();

                                      $("#round_04_left").show();
                                      $("#winner_04_left").show();
                                      $("#round_04_right").show();
                                      $("#winner_04_right").show();

                                      $("#round_03_left").show();
                                      $("#winner_03_left").show();
                                      $("#round_03_right").show();
                                      $("#winner_03_right").show();

                                      $("#round_02_left").show();
                                      $("#winner_02_left").show();
                                      $("#round_02_right").show();
                                      $("#winner_02_right").show();

                                      $("#round_01_left").show();
                                      $("#winner_01_left").show();
                                      $("#round_01_right").show();
                                      $("#winner_01_right").show();


                                      setFinal("", "sd030001", sdata1, "05", 32);

                                  } else if (varTotRound == "16") {
                                      //16강

                                      //$(".tourney").width("1280px");
                                      $(".tourney").height("625px");

                                      //2번째라인(좌)
                                      setPlayerLineMid("", "sd030001", sdata1, "02", 4);

                                      //2번째승리자이름(좌)
                                      setPlayerNameMid("", "", "sd030001", sdata1, "02", 4);

                                      //2번째라인(우)
                                      setPlayerLineMid("", "sd030002", sdata1, "02", 4);

                                      //2번째승리자이름(우)
                                      setPlayerNameMid("", "", "sd030002", sdata1, "02", 4);

                                      //3번째라인(좌)
                                      setPlayerLineMid("", "sd030001", sdata1, "03", 8);

                                      //3번째승리자이름(좌)
                                      setPlayerNameMid("", "", "sd030001", sdata1, "03", 8);

                                      //3번째라인(우)
                                      setPlayerLineMid("", "sd030002", sdata1, "03", 8);

                                      //3번째승리자이름(우)
                                      setPlayerNameMid("", "", "sd030002", sdata1, "03", 8);



                                      $("#round_06_left").hide();
                                      $("#winner_06_left").hide();
                                      $("#round_06_right").hide();
                                      $("#winner_06_right").hide();

                                      $("#round_05_left").hide();
                                      $("#winner_05_left").hide();
                                      $("#round_05_right").hide();
                                      $("#winner_05_right").hide();

                                      $("#round_04_left").hide();
                                      $("#winner_04_left").hide();
                                      $("#round_04_right").hide();
                                      $("#winner_04_right").hide();

                                      $("#round_03_left").show();
                                      $("#winner_03_left").show();
                                      $("#round_03_right").show();
                                      $("#winner_03_right").show();

                                      $("#round_02_left").show();
                                      $("#winner_02_left").show();
                                      $("#round_02_right").show();
                                      $("#winner_02_right").show();

                                      $("#round_01_left").show();
                                      $("#winner_01_left").show();
                                      $("#round_01_right").show();
                                      $("#winner_01_right").show();


                                      setFinal("", "sd030001", sdata1, "04", 16);

                                  }

                                  else if (varTotRound == "8" || varTotRound == "14" || varTotRound == "15") {
                                      //8강

                                      console.log("강" + varTotRound);
                                      //$(".tourney").width("1280px");
                                      $(".tourney").height("312px");

                                      //2번째라인(좌)
                                      setPlayerLineMid("", "sd030001", sdata1, "02", 4);

                                      //2번째승리자이름(좌)
                                      setPlayerNameMid("", "", "sd030001", sdata1, "02", 4);

                                      //2번째라인(우)
                                      setPlayerLineMid("", "sd030002", sdata1, "02", 4);

                                      //2번째승리자이름(우)
                                      setPlayerNameMid("", "", "sd030002", sdata1, "02", 4);


                                      $("#round_06_left").hide();
                                      $("#winner_06_left").hide();
                                      $("#round_06_right").hide();
                                      $("#winner_06_right").hide();

                                      $("#round_05_left").hide();
                                      $("#winner_05_left").hide();
                                      $("#round_05_right").hide();
                                      $("#winner_05_right").hide();

                                      $("#round_04_left").hide();
                                      $("#winner_04_left").hide();
                                      $("#round_04_right").hide();
                                      $("#winner_04_right").hide();

                                      $("#round_03_left").hide();
                                      $("#winner_03_left").hide();
                                      $("#round_03_right").hide();
                                      $("#winner_03_right").hide();

                                      $("#round_02_left").show();
                                      $("#winner_02_left").show();
                                      $("#round_02_right").show();
                                      $("#winner_02_right").show();

                                      $("#round_01_left").show();
                                      $("#winner_01_left").show();
                                      $("#round_01_right").show();
                                      $("#winner_01_right").show();

                                      setFinal("", "sd030001", sdata1, "03", 8);

                                  }

                                  else if (varTotRound == "4") {
                                      //8강

                                      //$(".tourney").width("1280px");
                                      $(".tourney").height("661px");

                                      $("#round_06_left").hide();
                                      $("#winner_06_left").hide();
                                      $("#round_06_right").hide();
                                      $("#winner_06_right").hide();

                                      $("#round_05_left").hide();
                                      $("#winner_05_left").hide();
                                      $("#round_05_right").hide();
                                      $("#winner_05_right").hide();

                                      $("#round_04_left").hide();
                                      $("#winner_04_left").hide();
                                      $("#round_04_right").hide();
                                      $("#winner_04_right").hide();

                                      $("#round_03_left").hide();
                                      $("#winner_03_left").hide();
                                      $("#round_03_right").hide();
                                      $("#winner_03_right").hide();

                                      $("#round_02_left").hide();
                                      $("#winner_02_left").hide();
                                      $("#round_02_right").hide();
                                      $("#winner_02_right").hide();


                                      $("#round_01_left").show();
                                      $("#winner_01_left").show();
                                      $("#round_01_right").show();
                                      $("#winner_01_right").show();



                                      setFinal("", "sd030001", sdata1, "02", 4);

                                  }

                                  else if (varTotRound == "2") {

                                      console.log("final" + varTotRound);

                                      $("#round_06_left").hide();
                                      $("#winner_06_left").hide();
                                      $("#round_06_right").hide();
                                      $("#winner_06_right").hide();

                                      $("#round_05_left").hide();
                                      $("#winner_05_left").hide();
                                      $("#round_05_right").hide();
                                      $("#winner_05_right").hide();

                                      $("#round_04_left").hide();
                                      $("#winner_04_left").hide();
                                      $("#round_04_right").hide();
                                      $("#winner_04_right").hide();

                                      $("#round_03_left").hide();
                                      $("#winner_03_left").hide();
                                      $("#round_03_right").hide();
                                      $("#winner_03_right").hide();

                                      $("#round_02_left").hide();
                                      $("#winner_02_left").hide();
                                      $("#round_02_right").hide();
                                      $("#winner_02_right").hide();

                                      $("#round_01_left").hide();
                                      $("#winner_01_left").hide();
                                      $("#round_01_right").hide();
                                      $("#winner_01_right").hide();

                                      setFinal("", "sd030001", sdata1, "02", 2);


                                  }


                              });


                          } else {
                              //안드로이드 alert
                              //navigator.notification.alert("입력된 자료가 없습니다.",null,"sports diary","확인");
                              alert("입력된 자료가 없습니다.", null, "sports diary", "확인");
                              //$(".tourney-mode").hide();
                              $(".tourney-mode").css("display", "none");
                              $("#DP_MedalList").hide();
                              $(".tourney-mode.tourney-result").hide();

                          }

                          //이 시점에서 이전버튼으로 온 구분값 초기화
                          localStorage.setItem("BackPage", "");

                      });
                  }

              } else {
                  alert("소속구분 또는 체급을 선택하시기 바랍니다.", null, "sports diary", "확인");
                  $(".tourney-mode").css("display", "none");
                  $("#DP_MedalList").hide();
                  $(".tourney-mode.tourney-result").hide();
              }


              //팝업 닫을때 history back;
              //              $('#show-score,#groupshow-score').on('hidden.bs.modal', function (e) {
              //                  if (history.state == null) {

              //                  } else {
              //                      history.back();
              //                  }
              //              });
              //팝업 닫을때 Youtube영상 없애기
              $('#show-score').on('hide.bs.modal', function (event) {

                  //경기결과보기로 진입 시, 영상보기
                  //if (localStorage.getItem("IntroIndex") == "2") {
                  $("#DP_GameVideo").html("");

                  $("#DP_GameVideo").css("display", "none");
                  $("#DP_Record").css("display", "");

                  $("#btn_movie").css("display", "");
                  $("#btn_log").css("display", "none");
                  //}


              });

              //단체전팝업 닫을때 Youtube영상 없애기
              $('#groupshow-score').on('hide.bs.modal', function (event) {

                  //경기결과보기로 진입 시, 영상보기

                  $("#DP_GroupGameVideo").html("");

                  $("#DP_GroupGameVideo").css("display", "none");
                  $("#DP_GroupRecord").css("display", "");

                  $("#btn_groupmovie").css("display", "");
                  $("#btn_grouplog").css("display", "none");



              });



          });
          /*검색*/


          /*탭*/
          $("input[name='game-type']").click(function () {

              //alert($("input[name='game-type']:checked").val());

              localStorage.setItem("GroupGameGb", $("input[name='game-type']:checked").val());

              m_drLevelList_sum_NowGame("#SexLevel", $("#TeamGb").val(), "");
              //$("#Level").show();

              callRGameLevel();
          });

      });


      //S:로딩바

      $(document).ajaxStart(function () {

       

      });
      $(document).ajaxStop(function () {
       

      });
      //E:로딩바


      var setFinal = function (leftrightgb, lineleftrightgb, sdata1, number, deno) {
          var myArr1 = JSON.parse(sdata1);

          var lineleft = "";
          var lineleft1 = "";

          var varLeftRight = "";
          var MediaLink = "";
          /* 송팀장님이 잡아놓은 결승전 승리구분(잘못되어 수정)
          if (lineleftrightgb == "sd030001")
          {
          varLeftRight = "L";
          } else {
          varLeftRight = "R";
          }
          */

          //2강일때만 PlayerGameNum을 1로 바꿔준다
          if (deno == 2) {
              PlayerGameNum = "1";
          }

          var ChiefSignGb = "";

          lineleft += "<div class='line-div'>";

          for (var i1 = 0; i1 < myArr1.length; i1++) {
              var varGameNum = myArr1[i1].GameNum;
              var varLPlayerResult = myArr1[i1].LPlayerResult;
              var varLPlayerResultNm = myArr1[i1].LPlayerResultNm;

              var varRPlayerResult = myArr1[i1].RPlayerResult;
              var varRPlayerResultNm = myArr1[i1].RPlayerResultNm;
              var varLPlayerName = myArr1[i1].LPlayerName;
              var varRPlayerName = myArr1[i1].RPlayerName;

              var varChiefSign = myArr1[i1].ChiefSign;
              var varAssChiefSign1 = myArr1[i1].AssChiefSign1;
              var varAssChiefSign2 = myArr1[i1].AssChiefSign2;

              var varLJumsu = myArr1[i1].LJumsu;
              var varRJumsu = myArr1[i1].RJumsu;

              var varMediaLink = myArr1[i1].MediaLink;


              //루프돌면서 해당 게임넘버가 있는지 체크

              //console.log(PlayerGameNum,varGameNum);

              if (PlayerGameNum == varGameNum) {

                  if (myArr1[i1].LPlayerResult != "") {
                      varLeftRight = "L";
                  }
                  else {
                      varLeftRight = "R";
                  }

                  if (varLPlayerResult == "sd019001" || varLPlayerResult == "sd019002" || varLPlayerResult == "sd019003" || varLPlayerResult == "sd019004" || varLPlayerResult == "sd019005" || varLPlayerResult == "sd019006" || varLPlayerResult == "sd019013" || varLPlayerResult == "sd044001" || varLPlayerResult == "sd019015" || varLPlayerResult == "sd019017" || varLPlayerResult == "sd019019" || varLPlayerResult == "sd019022" || varLPlayerResult == "sd019025") {


                      lineleft1 += "<a onclick='editscore(this)' role='button' class='final-match-box winner' data-id='" + PlayerGameNum + "' data-toggle='modal' >";
                      lineleft1 += "  <p><span class='final-player'>" + varLPlayerName + "</span> 승</p>";
                      lineleft1 += "  <!--<p><span>" + varLPlayerResultNm + "</span>(" + varLJumsu + ")<i class='fa fa-plus' aria-hidden='true'></i></p>-->";
                      lineleft1 += "</a>";

                      lineleft1 += "  <img src='../../Webtournament/www/images/tournerment/" + String(parseInt(number) + 1) + "_win_" + varLeftRight + ".png' alt=''>";

                  } else if (varRPlayerResult == "sd019001" || varRPlayerResult == "sd019002" || varRPlayerResult == "sd019003" || varRPlayerResult == "sd019004" || varRPlayerResult == "sd019005" || varRPlayerResult == "sd019006" || varRPlayerResult == "sd019013" || varRPlayerResult == "sd044001" || varRPlayerResult == "sd019015" || varRPlayerResult == "sd019017" || varRPlayerResult == "sd019019" || varRPlayerResult == "sd019022" || varRPlayerResult == "sd019025") {

                      lineleft1 += "<a onclick='editscore(this)' role='button' class='final-match-box winner' data-id='" + PlayerGameNum + "' data-toggle='modal' >";
                      lineleft1 += "  <p><span class='final-player'>" + varRPlayerName + "</span> 승</p>";
                      lineleft1 += "  <!--<p><span>" + varRPlayerResultNm + "</span>(" + varRJumsu + ")<i class='fa fa-plus' aria-hidden='true'></i></p>-->";
                      lineleft1 += "</a>";

                      lineleft1 += "  <img src='../../Webtournament/www/images/tournerment/" + String(parseInt(number) + 1) + "_win_" + varLeftRight + ".png' alt=''>";
                  }
              }

              //감독사인여부처리
              if (varChiefSign != "" && PlayerGameNum == varGameNum) {
                  ChiefSignGb = "Y";
              }

              //영상등록여부
              if (varMediaLink != "" && PlayerGameNum == varGameNum) {
                  MediaLink = myArr1[i1].MediaLink;
              }

          }

          //시합결과가 있을경우
          if (lineleft1 != "") {
              lineleft += lineleft1;

              console.log("varMediaLink:-" + MediaLink + "-");

              lineleft += " <a onclick='editscore(this)' data-toggle='modal' data-id='" + PlayerGameNum + "' data-whatever='" + number + "' role='button' ";

              if (MediaLink != "") {
                  lineleft += "class='btn btn-danger btn-look time-out'";
              } else {
                  lineleft += "class='btn btn-danger btn-look no-movie-clip'";
              }

              lineleft += ">";
              lineleft += PlayerGameNum;

			  /*			
              if (MediaLink != "") {
                  lineleft += ".";
              }
			  */

              lineleft += "</a>";

          } else {
              lineleft += " <img src='../../Webtournament/www/images/tournerment/" + number + "_final.png' alt=''>";
              lineleft += " <a onclick='mov_enterscore(this);' data-id='" + PlayerGameNum + "' data-whatever='" + number + "' role='button' class='btn btn-primary btn-look '>" + PlayerGameNum + "</a>";
          }


          lineleft += "</div>";



			if (leftrightgb != "")
			{
					
				$(leftrightgb).html(lineleft);      
			}
			else{
				$("#final_div").html(lineleft);         
			}

      }
      
      
      
      var PlayerList = function (sdata,leftrightgb,lineleftrightgb,sdata1){

          var defer = $.Deferred();
        
          var myArr = JSON.parse(sdata);
          var myArr1 = JSON.parse(sdata1);
          
          var loopcount = 0;
          var matchgb = "";
        
          var winnerleft="";
          var winnerright="";
          var winnerloopcount = 0;
        
        
          //선수리스트,라인세팅1 세팅
        

//          var loaddataPro1 = $.when(setPlayerList(myArr,leftrightgb),setPlayerLine(sdata,leftrightgb,lineleftrightgb,sdata1,"#round_01_left","#round_01_right","01"),setPlayerName1(myArr,leftrightgb,lineleftrightgb,myArr1));
        
          var loaddataPro1 = $.when(setPlayerList(myArr,leftrightgb),setPlayerLine(sdata,leftrightgb,lineleftrightgb,sdata1,"#round_01_left","#round_01_right","01"),setPlayerName1(myArr,leftrightgb,lineleftrightgb,myArr1));

          loaddataPro1.done(function(sdata,varHeight) {
            
//            setPlayerLine2(leftrightgb,lineleftrightgb,sdata1,"#round_02_left","#round_02_right","02");

            //승리자표기1
            //console.log(sdata,leftrightgb,lineleftrightgb,sdata1);
            
          });
        
          return defer.promise();
        
      }

      
      //두번째라인부터 세팅
      var setPlayerLineMid = function (leftrightgb, lineleftrightgb, sdata1, number, deno) {

          var defer = $.Deferred();

          var LRHalfCount = "";

          var LHalfCount = LLevelLineCount / deno;
          var RHalfCount = RLevelLineCount / deno;


          //console.log(LLevelLineCount,RLevelLineCount);
          /* 개인전, 단체전에 따른 player-Info 높이 조절 */
          // $('.enter-type').changeType('.btn-list .btn');

          var lineloopcount = 0;
          var lineleft = "";
          var lineright = "";


          if (lineleftrightgb == "sd030001") {
              LRHalfCount = LHalfCount;
          } else {
              LRHalfCount = RHalfCount;
          }



          var myArr1 = JSON.parse(sdata1);

          //console.log(myArr1);

          for (var i = 0; i < LRHalfCount; i++) {

              var ChiefSignGb = "";       //감독사인여부처리
              var vardualresult = "";       //양선수부전패,무승부 Flag
              var vargplayercnt = 0;
              var vargamestatus = "";
              var MediaLink = "";

              var varLeftRight = "";
              if (lineleftrightgb == "sd030001") {
                  varLeftRight = "L";
              } else {
                  varLeftRight = "R";
              }


              var lineleft1 = "";

              lineleft += "<div class='line-div'>";

              //시합결과 적용하기

              for (var i1 = 0; i1 < myArr1.length; i1++) {
                  var varGameNum = myArr1[i1].GameNum;
                  var varLPlayerResult = myArr1[i1].LPlayerResult;
                  var varLPlayerResultNm = myArr1[i1].LPlayerResultNm;

                  var varRPlayerResult = myArr1[i1].RPlayerResult;
                  var varRPlayerResultNm = myArr1[i1].RPlayerResultNm;
                  var varLPlayerName = myArr1[i1].LPlayerName;
                  var varRPlayerName = myArr1[i1].RPlayerName;

                  var varChiefSign = myArr1[i1].ChiefSign;
                  var varAssChiefSign1 = myArr1[i1].AssChiefSign1;
                  var varAssChiefSign2 = myArr1[i1].AssChiefSign2;

                  var varLJumsu = myArr1[i1].LJumsu;
                  var varRJumsu = myArr1[i1].RJumsu;

                  var varMediaLink = myArr1[i1].MediaLink;


                  //루프돌면서 해당 게임넘버가 있는지 체크

                  //console.log(varChiefSign,varGameNum);

                  if (PlayerGameNum == varGameNum) {
                      if (varLPlayerResult == "sd019001" || varLPlayerResult == "sd019002" || varLPlayerResult == "sd019003" || varLPlayerResult == "sd019004" || varLPlayerResult == "sd019005" || varLPlayerResult == "sd019006" || varLPlayerResult == "sd019013" || varLPlayerResult == "sd044001" || varLPlayerResult == "sd019015" || varLPlayerResult == "sd019017" || varLPlayerResult == "sd019019" || varLPlayerResult == "sd019022" || varLPlayerResult == "sd019025") {

                          lineleft1 += "  <img src='../../Webtournament/www/images/tournerment/" + number + "_" + varLeftRight + "_top.png' alt=''>";
                      } else if (varRPlayerResult == "sd019001" || varRPlayerResult == "sd019002" || varRPlayerResult == "sd019003" || varRPlayerResult == "sd019004" || varRPlayerResult == "sd019005" || varRPlayerResult == "sd019006" || varRPlayerResult == "sd019013" || varRPlayerResult == "sd044001" || varRPlayerResult == "sd019015" || varRPlayerResult == "sd019017" || varRPlayerResult == "sd019019" || varRPlayerResult == "sd019022" || varRPlayerResult == "sd019025") {
                          lineleft1 += "  <img src='../../Webtournament/www/images/tournerment/" + number + "_" + varLeftRight + "_bottom.png' alt=''>";
                      }

                  }

                  //감독사인여부처리
                  if (varChiefSign != "" && PlayerGameNum == varGameNum) {
                      ChiefSignGb = "Y";
                  }

                  //영상등록여부
                  if (varMediaLink != "" && PlayerGameNum == varGameNum) {
                      MediaLink = myArr1[i1].MediaLink;
                  }



                  if ((varLPlayerResult != "" && varRPlayerResult != "") && PlayerGameNum == varGameNum) {
                      vardualresult = "Y";
                  }

                  //console.log(varLPlayerResult + ","+ varLPlayerResult + "," + PlayerGameNum + "," + varGameNum) ;

              }



              //시합결과가 있을경우
              if (lineleft1 != "") {
                  lineleft += lineleft1;

                  console.log("varMediaLink:-" + varMediaLink + "-");

                  lineleft += " <a onclick='editscore(this)' data-toggle='modal' data-id='" + PlayerGameNum + "' data-whatever='" + number + "' role='button' ";

                  if (MediaLink != "") {
                      lineleft += "class='btn btn-danger btn-look time-out'";
                  } else {
                      lineleft += "class='btn btn-danger btn-look no-movie-clip'";
                  }

                  lineleft += ">";
                  lineleft += PlayerGameNum;

                  lineleft += "</a>";

                  //console.log(lineleft,ChiefSignGb);


              } else {

                  lineleft += " <img src='../../Webtournament/www/images/tournerment/" + number + "_" + varLeftRight + "_basic.png' alt=''>";

                  if (vardualresult != "") {

                      lineleft += " <a onclick='editscore(this)' data-toggle='modal' data-id='" + PlayerGameNum + "' data-whatever='" + number + "' role='button' class='btn btn-danger btn-look handy'>" + PlayerGameNum + "</a>";
                  }
                  else {

                      if (localStorage.getItem("GroupGameGb") == "sd040002") {
                        /*
                          //단체전 선수등록된 Count
                          var array_gplayercnt = groupplayercnt(PlayerGameNum);

                          vargplayercnt = Number(array_gplayercnt[0]);

                          //단체전 선수 등록된 상태라면 선수등록색깔표시
                          if (vargplayercnt > 0) {
                              lineleft += " <a role='button' class='btn btn-danger btn-look enroll' onclick='mov_enterscore(this);' data-id='" + PlayerGameNum + "' data-whatever='" + number + "'>" + PlayerGameNum + "</a>";
                          }
                          else {
                              lineleft += " <a role='button' class='btn btn-primary btn-look' onclick='mov_enterscore(this);' data-id='" + PlayerGameNum + "' data-whatever='" + number + "'>" + PlayerGameNum + "</a>";
                          }
                          */
                          lineleft += " <a role='button' class='btn btn-primary btn-look' onclick='mov_enterscore(this);' data-id='" + PlayerGameNum + "' data-whatever='" + number + "'>" + PlayerGameNum + "</a>";

                      }
                      else {
                        /*
                          //개인전 경기 진행중 인지 종료인지 Result 코드
                          var array_gamestatus = load_gamestatus(PlayerGameNum);

                          vargamestatus = array_gamestatus[0];

                          //개인전 진행중 이라면 진행중 색깔표시
                          if (vargamestatus == "sd050001") {
                              lineleft += " <a role='button' class='btn btn-danger btn-look time-in' onclick='mov_enterscore(this);' data-id='" + PlayerGameNum + "' data-whatever='" + number + "'>" + PlayerGameNum + "</a>";
                          }
                          else {
                              lineleft += " <a role='button' class='btn btn-primary btn-look' onclick='mov_enterscore(this);' data-id='" + PlayerGameNum + "' data-whatever='" + number + "'>" + PlayerGameNum + "</a>";
                          }
                          */

                          lineleft += " <a role='button' class='btn btn-primary btn-look' onclick='mov_enterscore(this);' data-id='" + PlayerGameNum + "' data-whatever='" + number + "'>" + PlayerGameNum + "</a>";
                      }


                  }
              }          


              lineleft += "</div>";



              //시합번호 넘버링증가
              PlayerGameNum += 1;

              lineloopcount += 1;



          }


          //console.log(lineleft);

			if (leftrightgb != "")
			{
			  if (lineleftrightgb == "sd030001")
			  {
				$("#round_"+number+"_left_" + leftrightgb).html(lineleft);
			  } else {
				$("#round_"+number+"_right_"+ leftrightgb).html(lineleft);
				//console.log(lineleft);
			  }       
			}
			else
			{

			  if (lineleftrightgb == "sd030001")
			  {
				$("#round_"+number+"_left").html(lineleft);
			  } else {
				$("#round_"+number+"_right").html(lineleft);
				//console.log(lineleft);
			  }

			} 


          return defer.promise();

      }
  
      //스코어등록 화면 이동
      var mov_enterscore = function(obj){

          alert("경기가 완료되지 않았습니다.");
          return;
      
      }
      
      
      
      //라인 세팅
      var setPlayerLine = function (sdata, leftrightgb, lineleftrightgb, sdata1, LeftID, RightID, number) {


          //console.log(sdata1);


          var defer = $.Deferred();

          var lineloopcount = 0;
          var lineleft = "";
          var lineright = "";

          var myArr = JSON.parse(sdata);
          var myArr1 = JSON.parse(sdata1);



          for (var i = 0; i < myArr.length; i++) {

              var ChiefSignGb = "";       //감독사인여부처리

              var varSportsGb = myArr[i].SportsGb;
              var varGameTitleIDX = myArr[i].GameTitleIDX;
              var varTeamGb = myArr[i].TeamGb;
              var varSex = myArr[i].Sex;
              var varLevel = myArr[i].Level;
              var varGroupGameGb = myArr[i].GroupGameGb;
              var varTotRound = myArr[i].TotRound;
              var varGameDay = myArr[i].GameDay;
              var varGameTime = myArr[i].GameTime;
              var varUserName = myArr[i].UserName;
              var varPlayerNum = myArr[i].PlayerNum;
              var varUnearnWin = myArr[i].UnearnWin;
              var varLeftRightGb = myArr[i].LeftRightGb;
              var varSchIDX = myArr[i].SchIDX;
              var varSchoolName = myArr[i].SchoolName;

              var varLeftRight = "";
              if (lineleftrightgb == "sd030001") {
                  varLeftRight = "L";
              } else {
                  varLeftRight = "R";
              }


              //선수라인(세로방향) 부전승일경우
              if (varUnearnWin == "sd042002") {


                  var lineleft1 = "";
                  //부전승처리루틴
                  for (var i1 = 0; i1 < myArr1.length; i1++) {
                      var varGameNum = myArr1[i1].GameNum;
                      var varLPlayerResult = myArr1[i1].LPlayerResult;
                      var varLPlayerResultNm = myArr1[i1].LPlayerResultNm;

                      var varRPlayerResult = myArr1[i1].RPlayerResult;
                      var varRPlayerResultNm = myArr1[i1].RPlayerResultNm;
                      var varLPlayerName = myArr1[i1].LPlayerName;
                      var varRPlayerName = myArr1[i1].RPlayerName;

                      var varChiefSign = myArr1[i1].ChiefSign;
                      var varAssChiefSign1 = myArr1[i1].AssChiefSign1;
                      var varAssChiefSign2 = myArr1[i1].AssChiefSign2;
                      var varRound = myArr1[i1].Round;
                      var varLPlayerNum = myArr1[i1].LPlayerNum;
                      var varRPlayerNum = myArr1[i1].RPlayerNum;

                      //console.log(varPlayerNum,varLPlayerNum,varRPlayerNum,varLPlayerResult,varRPlayerResult);

                      //루프돌면서 해당 게임넘버가 있는지 체크
                      if (varRound == "2" && (varPlayerNum == varLPlayerNum) && (varLPlayerResult == "sd019001" || varLPlayerResult == "sd019002" || varLPlayerResult == "sd019003" || varLPlayerResult == "sd019004" || varLPlayerResult == "sd019005" || varLPlayerResult == "sd019006" || varLPlayerResult == "sd019013" || varLPlayerResult == "sd044001" || varLPlayerResult == "sd019015" || varLPlayerResult == "sd019017" || varLPlayerResult == "sd019019" || varLPlayerResult == "sd019022" || varLPlayerResult == "sd019025")) {

                          lineleft1 += "111";

                      } else if (varRound == "2" && (varPlayerNum == varRPlayerNum) && (varRPlayerResult == "sd019001" || varRPlayerResult == "sd019002" || varRPlayerResult == "sd019003" || varRPlayerResult == "sd019004" || varRPlayerResult == "sd019005" || varRPlayerResult == "sd019006" || varRPlayerResult == "sd019013" || varRPlayerResult == "sd044001" || varRPlayerResult == "sd019015" || varRPlayerResult == "sd019017" || varRPlayerResult == "sd019019" || varRPlayerResult == "sd019022" || varRPlayerResult == "sd019025")) {

                          lineleft1 += "222";

                      }

                  }


                  if (number == "01") {
                      //부전승승리표기
                      if (lineleft1 != "") {
                          lineleft += "<div class='line-div'>";
                          lineleft += " <img src='../../Webtournament/www/images/tournerment/" + number + "_R_center.png' alt=''>";
                          lineleft += "</div>";
                      } else {
                          lineleft += "<div class='line-div'>";
                          //lineleft += " <img src='../../Webtournament/www/images/tournerment/"+number+"_"+varLeftRight+"_basic_center.png' alt=''>";
                          lineleft += " <img src='../../Webtournament/www/images/tournerment/" + number + "_" + varLeftRight + "_center.png' alt=''>";
                          lineleft += "</div>";
                      }
                  }


                  lineloopcount = 0;

                  //부전승이 아닌경우에서 루프를 돌면서 다음게임의 참여 갯수를 로딩.
                  if (lineleftrightgb == "sd030001") {
                      LLevelLineCount += 2;
                  } else {
                      RLevelLineCount += 2;
                  }

              } else {


                  //부전승이 아닌경우에서 루프를 돌면서 다음게임의 참여 갯수를 로딩.
                  if (lineleftrightgb == "sd030001") {
                      LLevelLineCount += 1;
                  } else {
                      RLevelLineCount += 1;
                  }



                  //부전승이 아닌경우 루프돌면서 해당 시합결과 처리.(없으면 패스)

                  var vardualresult = "";
                  var vargplayercnt = 0;
                  var vargamestatus = "";
                  var MediaLink = "";

                  if (lineloopcount == 0) {

                      var lineleft1 = "";

                      lineleft += "<div class='line-div'>";

                      //시합결과 적용하기


                      for (var i1 = 0; i1 < myArr1.length; i1++) {
                          var varGameNum = myArr1[i1].GameNum;
                          var varLPlayerResult = myArr1[i1].LPlayerResult;
                          var varLPlayerResultNm = myArr1[i1].LPlayerResultNm;

                          var varRPlayerResult = myArr1[i1].RPlayerResult;
                          var varRPlayerResultNm = myArr1[i1].RPlayerResultNm;
                          var varLPlayerName = myArr1[i1].LPlayerName;
                          var varRPlayerName = myArr1[i1].RPlayerName;

                          var varChiefSign = myArr1[i1].ChiefSign;
                          var varAssChiefSign1 = myArr1[i1].AssChiefSign1;
                          var varAssChiefSign2 = myArr1[i1].AssChiefSign2;

                          var varMediaLink = myArr1[i1].MediaLink;


                          //루프돌면서 해당 게임넘버가 있는지 체크

                          if (PlayerGameNum == varGameNum) {
                              if (varLPlayerResult == "sd019001" || varLPlayerResult == "sd019002" || varLPlayerResult == "sd019003" || varLPlayerResult == "sd019004" || varLPlayerResult == "sd019005" || varLPlayerResult == "sd019006" || varLPlayerResult == "sd019013" || varLPlayerResult == "sd044001" || varLPlayerResult == "sd019015" || varLPlayerResult == "sd019017" || varLPlayerResult == "sd019019" || varLPlayerResult == "sd019022" || varLPlayerResult == "sd019025") {

                                  lineleft1 += "  <img src='../../Webtournament/www/images/tournerment/" + number + "_" + varLeftRight + "_top.png' alt=''>";
                              } else if (varRPlayerResult == "sd019001" || varRPlayerResult == "sd019002" || varRPlayerResult == "sd019003" || varRPlayerResult == "sd019004" || varRPlayerResult == "sd019005" || varRPlayerResult == "sd019006" || varRPlayerResult == "sd019013" || varRPlayerResult == "sd044001" || varRPlayerResult == "sd019015" || varRPlayerResult == "sd019017" || varRPlayerResult == "sd019019" || varRPlayerResult == "sd019022" || varRPlayerResult == "sd019025") {
                                  lineleft1 += "  <img src='../../Webtournament/www/images/tournerment/" + number + "_" + varLeftRight + "_bottom.png' alt=''>";
                              }

                          }


                          //감독사인여부처리
                          if (varChiefSign != "" && PlayerGameNum == varGameNum) {
                              ChiefSignGb = "Y";
                          }

                          //영상등록여부
                          if (varMediaLink != "" && PlayerGameNum == varGameNum) {
                              MediaLink = myArr1[i1].MediaLink;
                          }

                          if ((varLPlayerResult != "" && varRPlayerResult != "") && PlayerGameNum == varGameNum) {
                              vardualresult = "Y";
                          }

                      }



                      //시합결과가 있을경우
                      if (lineleft1 != "") {
                          lineleft += lineleft1;

                          console.log("varMediaLink:-" + MediaLink + "-");

                          lineleft += " <a onclick='editscore(this)' data-toggle='modal' data-id='" + PlayerGameNum + "' data-whatever='" + number + "' role='button' ";

                          if (MediaLink != "") {
                              lineleft += "class='btn btn-danger btn-look time-out'";
                          } else {
                              lineleft += "class='btn btn-danger btn-look no-movie-clip'";
                          }

                          lineleft += ">";
                          lineleft += PlayerGameNum;

						  /*
                          //동영상링크 있으면 .붙이기
                          if (MediaLink != "") {
                              lineleft += ".";
                          }
						  */

                          lineleft += "</a>";


                      } else {

                          lineleft += " <img src='../../Webtournament/www/images/tournerment/" + number + "_" + varLeftRight + "_basic.png' alt=''>";


                          if (vardualresult != "") {

                              lineleft += " <a role='button' class='btn btn-danger btn-look handy' data-id='" + PlayerGameNum + "' data-whatever='" + number + "' onclick='editscore(this);'>" + PlayerGameNum + "</a>";
                          }
                          else {

                              if (localStorage.getItem("GroupGameGb") == "sd040002") {
                                /*
                                  //단체전 선수등록된 Count
                                  var array_gplayercnt = groupplayercnt(PlayerGameNum);

                                  vargplayercnt = Number(array_gplayercnt[0]);

                                  if (vargplayercnt > 0) {
                                      lineleft += " <a role='button' class='btn btn-danger btn-look enroll' data-id='" + PlayerGameNum + "' data-whatever='" + number + "' onclick='mov_enterscore(this);'>" + PlayerGameNum + "</a>";
                                  }
                                  else {
                                      lineleft += " <a role='button' class='btn btn-primary btn-look' data-id='" + PlayerGameNum + "' data-whatever='" + number + "' onclick='mov_enterscore(this);'>" + PlayerGameNum + "</a>";
                                  } 
                                  */
                                  
                                  lineleft += " <a role='button' class='btn btn-primary btn-look' data-id='" + PlayerGameNum + "' data-whatever='" + number + "' onclick='mov_enterscore(this);'>" + PlayerGameNum + "</a>";

                              }
                              else {
                                /*
                                  //개인전 경기 진행중 인지 종료인지 Result 코드
                                  var array_gamestatus = load_gamestatus(PlayerGameNum);

                                  vargamestatus = array_gamestatus[0];

                                  //alert(PlayerGameNum+":" + vargamestatus);

                                  //개인전 진행중 이라면 진행중 색깔표시
                                  if (vargamestatus == "sd050001") {

                                      lineleft += " <a role='button' class='btn btn-danger btn-look time-in' data-id='" + PlayerGameNum + "' data-whatever='" + number + "' onclick='mov_enterscore(this);'>" + PlayerGameNum + "</a>";
                                  }
                                  else {
                                      lineleft += " <a role='button' class='btn btn-primary btn-look' data-id='" + PlayerGameNum + "' data-whatever='" + number + "' onclick='mov_enterscore(this);'>" + PlayerGameNum + "</a>";
                                  }
                                  */
                                  lineleft += " <a role='button' class='btn btn-primary btn-look' data-id='" + PlayerGameNum + "' data-whatever='" + number + "' onclick='mov_enterscore(this);'>" + PlayerGameNum + "</a>";
                              }

                          }


                      }


                      lineleft += "</div>";


                      //시합번호 넘버링증가
                      PlayerGameNum += 1;

                      lineloopcount += 1;

                  } else {

                      lineloopcount = 0;
                  }

              }


          }

          //console.log(lineleft);


          if (lineleftrightgb == "sd030001") {
              //선수라인리스트
              $(LeftID).html(lineleft);

          } else {
              //console.log(lineright);
              $(RightID).html(lineleft);
          }


          return defer.promise();

          //console.log("111");

      }
      
      
      
      
      //승리자표기1
      var setPlayerName1 = function(myArr,leftrightgb,lineleftrightgb,myArr1){

        
            var defer = $.Deferred();
        
        
            var winnerleft="";
            var winnerright="";
            var winnerloopcount = 0;

            
          //console.log(myArr);
        

            for (var i = 0; i < myArr.length; i++){

              var varSportsGb = myArr[i].SportsGb;
              var varGameTitleIDX = myArr[i].GameTitleIDX;
              var varTeamGb = myArr[i].TeamGb;
              var varSex = myArr[i].Sex;
              var varLevel = myArr[i].Level;
              var varGroupGameGb = myArr[i].GroupGameGb;
              var varTotRound = myArr[i].TotRound;
              var varGameDay = myArr[i].GameDay;
              var varGameTime = myArr[i].GameTime;
              var varUserName = myArr[i].UserName;
              var varPlayerNum = myArr[i].PlayerNum;
              var varUnearnWin = myArr[i].UnearnWin;
              var varLeftRightGb = myArr[i].LeftRightGb;
              var varSchIDX = myArr[i].SchIDX;
              var varSchoolName = myArr[i].SchoolName;
              
              
              //좌측승리자표기S
              
              //선수라인(세로방향) 부전승일경우
              if (varUnearnWin == "sd042002"){
                winnerleft += "<a onclick='editscore(this)' role='button' data-id='"+PlayerGameNum+"' data-toggle='modal' class='winner empty'></a>";

                winnerloopcount = 0;

              } else {

                //부전승이 아닌경우 루프돌면서 해당 시합결과 처리.(없으면 패스)

                //console.log(winnerloopcount);

                if (winnerloopcount == 0){

                  var testtext = "";
                  //시합결과 적용하기
                  for (var i1 = 0; i1 < myArr1.length; i1++){
                    
                      var winnerleft1 = "";
                    
                      var varGameNum = myArr1[i1].GameNum;
                      var varLPlayerResult = myArr1[i1].LPlayerResult;
                      var varLPlayerResultNm = myArr1[i1].LPlayerResultNm;

                      var varRPlayerResult = myArr1[i1].RPlayerResult;
                      var varRPlayerResultNm = myArr1[i1].RPlayerResultNm;
                      var varLPlayerName = myArr1[i1].LPlayerName;
                      var varRPlayerName = myArr1[i1].RPlayerName;

                      var varLJumsu = myArr1[i1].LJumsu;
                      var varRJumsu = myArr1[i1].RJumsu;


                      //루프돌면서 해당 게임넘버가 있는지 체크

                      //console.log(PlayerResultNum,varGameNum,varLPlayerResult,varRPlayerResult);
                    

                      if (PlayerResultNum == varGameNum){
                        if (varLPlayerResult == "sd019001" || varLPlayerResult == "sd019002" || varLPlayerResult == "sd019003" || varLPlayerResult == "sd019004" || varLPlayerResult == "sd019005" || varLPlayerResult == "sd019006" || varLPlayerResult == "sd019013" || varLPlayerResult == "sd044001" || varLPlayerResult == "sd019015" || varLPlayerResult == "sd019017" || varLPlayerResult == "sd019019" || varLPlayerResult == "sd019022" || varLPlayerResult == "sd019025" ){
                          winnerleft1 += "  <a onclick='editscore(this)' role='button' data-id='"+PlayerGameNum+"' data-toggle='modal' class='winner'><!--<span class='skill'>"+varLPlayerResultNm+"("+varLJumsu+")</span><i class='fa fa-plus' aria-hidden='true'></i>--></a>";
                        } else if (varRPlayerResult == "sd019001" || varRPlayerResult == "sd019002" || varRPlayerResult == "sd019003" || varRPlayerResult == "sd019004" || varRPlayerResult == "sd019005" || varRPlayerResult == "sd019006" || varRPlayerResult == "sd019013" || varRPlayerResult == "sd044001" || varRPlayerResult == "sd019015" || varRPlayerResult == "sd019017" || varRPlayerResult == "sd019019" || varRPlayerResult == "sd019022" || varRPlayerResult == "sd019025" ) {
                          winnerleft1 += "  <a onclick='editscore(this)' role='button' data-id='"+PlayerGameNum+"' data-toggle='modal' class='winner'><!--<span class='skill'>"+varRPlayerResultNm+"("+varRJumsu+")</span><i class='fa fa-plus' aria-hidden='true'></i>--></a>";
                        }
                    
                        testtext = "1";
                      }

                    
                      //시합결과가 있을경우
                      if (winnerleft1 != ""){
                        winnerleft += winnerleft1;
                      }

                  }
                  
                  //결과가 없을시 표기
                  if (testtext == ""){
                    winnerleft += "<a onclick='editscore(this)' role='button' data-id='"+PlayerGameNum+"' data-toggle='modal' class='winner empty'><span class='skill'></san></a>";
                  }

                  
                  
                  
                  testtext = "";

                  //console.log(PlayerResultNum,varPlayerNum,winnerleft);

                  //시합번호 넘버링증가
                  winnerloopcount += 1;
                  PlayerResultNum += 1;
                  
                  

                } else {

                  
                  winnerloopcount = 0;

                }

              }

              
              
            }
        
        
          if (lineleftrightgb == "sd030001"){
          //선수라인리스트
            $("#winner_01_left").html(winnerleft);
            
          } else {
            $("#winner_01_right").html(winnerleft);
          }
        
          return defer.promise();       
        
      }

      
      
      
      //승리자표기2
      var setPlayerNameMid = function(sdata,leftrightgb,lineleftrightgb,sdata1,number,deno){
        
        //console.log("setPlayerName2");

        var defer = $.Deferred();
        
        var LRHalfCount = "";
        
        var LHalfCount = LLevelLineCount/deno;
        var RHalfCount = RLevelLineCount/deno;

        
        var lineleft = "";
        var lineright = "";

        
        if (lineleftrightgb == "sd030001")
        {
          LRHalfCount = LHalfCount;
        } else {
          LRHalfCount = RHalfCount;
        }
        
        
        
        var myArr1 = JSON.parse(sdata1);
        
          
        for (var i = 0; i < LRHalfCount; i++){
          
          var ChiefSignGb = "";

          var varLeftRight = "";
          if (lineleftrightgb == "sd030001")
          {
            varLeftRight = "L";
          } else {
            varLeftRight = "R";
          }



            var testtext = "";
          
            //시합결과 적용하기

            for (var i1 = 0; i1 < myArr1.length; i1++){
              var varGameNum = myArr1[i1].GameNum;
              var varLPlayerResult = myArr1[i1].LPlayerResult;
              var varLPlayerResultNm = myArr1[i1].LPlayerResultNm;

              var varRPlayerResult = myArr1[i1].RPlayerResult;
              var varRPlayerResultNm = myArr1[i1].RPlayerResultNm;
              var varLPlayerName = myArr1[i1].LPlayerName;
              var varRPlayerName = myArr1[i1].RPlayerName;

              var varChiefSign = myArr1[i1].ChiefSign;
              var varAssChiefSign1 = myArr1[i1].AssChiefSign1;
              var varAssChiefSign2 = myArr1[i1].AssChiefSign2;

              var varLJumsu = myArr1[i1].LJumsu;
              var varRJumsu = myArr1[i1].RJumsu;
              

              //루프돌면서 해당 게임넘버가 있는지 체크
              
              if (PlayerResultNum == varGameNum){

                  if (varLPlayerResult == "sd019001" || varLPlayerResult == "sd019002" || varLPlayerResult == "sd019003" || varLPlayerResult == "sd019004" || varLPlayerResult == "sd019005" || varLPlayerResult == "sd019006" || varLPlayerResult == "sd019013" || varLPlayerResult == "sd044001" || varLPlayerResult == "sd019015" || varLPlayerResult == "sd019017" || varLPlayerResult == "sd019019" || varLPlayerResult == "sd019022" || varLPlayerResult == "sd019025" ){

                    lineleft += " <a onclick='editscore(this)' role='button' data-id='"+PlayerGameNum+"' data-toggle='modal' class='winner'><!--<span class='skill'>"+varLPlayerResultNm+"("+varLJumsu+")</span><i class='fa fa-plus' aria-hidden='true'></i>--></a>";
                    
                  } else if (varRPlayerResult == "sd019001" || varRPlayerResult == "sd019002" || varRPlayerResult == "sd019003" || varRPlayerResult == "sd019004" || varRPlayerResult == "sd019005" || varRPlayerResult == "sd019006" || varRPlayerResult == "sd019013" || varRPlayerResult == "sd044001" || varRPlayerResult == "sd019015" || varRPlayerResult == "sd019017" || varRPlayerResult == "sd019019" || varRPlayerResult == "sd019022" || varRPlayerResult == "sd019025" ) {
                    
                    lineleft += " <a onclick='editscore(this)' role='button' data-id='"+PlayerGameNum+"' data-toggle='modal' class='winner'><!--<span class='skill'>"+varRPlayerResultNm+"("+varRJumsu+")</span><i class='fa fa-plus' aria-hidden='true'></i>--></a>";
                    
                  }
                
                testtext = "1";
              }
              
              
              //감독사인여부처리
              if (varChiefSign != ""){
                ChiefSignGb="Y";
              }

              
            }

          
            //결과가 없을시 표기
            if (testtext == ""){
              lineleft += "<a onclick='editscore(this)' role='button' data-id='"+PlayerGameNum+"' data-toggle='modal' class='winner empty'><span class='skill'></san></a>";
            }
                  
            testtext = "";
          
          
          
            //시합번호 넘버링증가
            PlayerResultNum += 1;


          }

        

        if (lineleftrightgb == "sd030001")
        {
          $("#winner_"+number+"_left").html(lineleft);
        } else {
          $("#winner_"+number+"_right").html(lineleft);
          //console.log("#winner_"+number+"_right");
        }

        
        return defer.promise();
        

      }
      
      
      
      
      //선수리스트 세팅(좌우)
      var setPlayerList = function(myArr,leftrightgb){
          
        
          //console.log("setPlayerList");
        
          var defer = $.Deferred();
        
          var loopcount = 0;
        
          var responwe = "";
        
          for (var i = 0; i < myArr.length; i++){

              var varSportsGb = myArr[i].SportsGb;
              var varGameTitleIDX = myArr[i].GameTitleIDX;
              var varTeamGb = myArr[i].TeamGb;
              var varSex = myArr[i].Sex;
              var varLevel = myArr[i].Level;
              var varGroupGameGb = myArr[i].GroupGameGb;
              var varTotRound = myArr[i].TotRound;
              var varGameDay = myArr[i].GameDay;
              var varGameTime = myArr[i].GameTime;
              var varUserName = myArr[i].UserName;
              var varPlayerNum = myArr[i].PlayerNum;
              var varUnearnWin = myArr[i].UnearnWin;
              var varLeftRightGb = myArr[i].LeftRightGb;
              var varTeam = myArr[i].Team;
              var varTeamDtl = myArr[i].TeamDtl;
              var varSchoolName = myArr[i].SchoolName;


              if (varGroupGameGb == "sd040001")
              {
                if (varTeamDtl != "0")
                {
                  varSchoolName = varSchoolName + varTeamDtl;
                }
              }
              else{
                if (varTeamDtl != "0")
                {
                  varUserName = varUserName + varTeamDtl;
                }             
              }


              var varTitleResult = myArr[i].TitleResult;

              var varLPlayerDualResult = myArr[i].LPlayerDualResult;
              var varRPlayerDualResult = myArr[i].RPlayerDualResult;
          
              var varPlayername_Class="";

              //금메달이면 이름 앞에 메달 달아주기
              /*
              if (varTitleResult == "sd034001")
              {
                varPlayername_Class = "player-name winner-golden";
              }
              else if(varTitleResult == "sd034002"){
                varPlayername_Class = "player-name winner-silver";              
              }
              else if(varTitleResult == "sd034003"){
                varPlayername_Class = "player-name winner-bronze";              
              }
              else{
                varPlayername_Class = "player-name";
              }
              */

              varPlayername_Class = "player-name";

              if (varUserName.length > 7)
              {
                //varPlayername_Class += "  small-name";
              }
              
              //선수리스트(세로방향)
              if (varUnearnWin == "sd042002"){
                //부전승일경우
                responwe += "<div class='no-match'>";
                responwe += "<div class='player-info'>";

                if(varLPlayerDualResult != "" && varLPlayerDualResult != "")
                {
                  responwe += "<span class='" + varPlayername_Class + "'><strike>"+varUserName+"</strike></span>";
                  //responwe += "<span class='player-id'>"+varPlayerNum+"</span>";
                  responwe += "<span class='player-school'><strike>"+varSchoolName+"</strike></span>";                
                }
                else
                {
                  responwe += "<span class='" + varPlayername_Class + "'>"+varUserName+"</span>";
                  //responwe += "<span class='player-id'>"+varPlayerNum+"</span>";
                  responwe += "<span class='player-school'>"+varSchoolName+"</span>";
                }


                responwe += "</div>";
                responwe += "</div>";

                loopcount = 0;

              } else {
                
                if (loopcount == 0){
                  responwe += "<div class='match'>";
                  responwe += " <div class='player-info'>";

                  if(varLPlayerDualResult != "" && varLPlayerDualResult != "")
                  {
                    responwe += "   <span class='" + varPlayername_Class + "'><strike>"+varUserName+"</strike></span>";
                    //responwe += "   <span class='player-id'>"+varPlayerNum+"</span>";
                    responwe += "   <span class='player-school'><strike>"+varSchoolName+"</strike></span>";
                  }
                  else
                  {
                    responwe += "   <span class='" + varPlayername_Class + "'>"+varUserName+"</span>";
                    //responwe += "   <span class='player-id'>"+varPlayerNum+"</span>";
                    responwe += "   <span class='player-school'>"+varSchoolName+"</span>";                  
                  }


                  responwe += " </div>";

                  loopcount += 1;
                  
                } else {
                  
                  responwe += " <div class='player-info'>";

                  if(varLPlayerDualResult != "" && varRPlayerDualResult != "")
                  {
                    responwe += "   <span class='" + varPlayername_Class + "'><strike>"+varUserName+"</strike></span>";
                    //responwe += "   <span class='player-id'>"+varPlayerNum+"</span>";
                    responwe += "   <span class='player-school'><strike>"+varSchoolName+"</strike></span>";
                  }
                  else
                  {
                    responwe += "   <span class='" + varPlayername_Class + "'>"+varUserName+"</span>";
                    //responwe += "   <span class='player-id'>"+varPlayerNum+"</span>";
                    responwe += "   <span class='player-school'>"+varSchoolName+"</span>";                  
                  }
                  responwe += " </div>";
                  responwe += "</div>";
                  
                  loopcount = 0;

                }
                
                
              }
              
          }
        
                  //선수명단리스트
          $(leftrightgb).html(responwe);
          return defer.promise();

      }
      
      
      //공식대회남녀체급레벨조회
      var callRGameLevel=function(varLeftRightGb, strBackPage){

        var defer = $.Deferred();
        var obj = {};

        obj.SportsGb = localStorage.getItem("SportsGb");
        obj.GameTitleIDX = localStorage.getItem("GameTitleIDX");

        if(strBackPage == "enter-score"){
          
          obj.TeamGb = localStorage.getItem("TeamGb");
          obj.Sex = localStorage.getItem("Sex");
          obj.Level = localStorage.getItem("Level");
          
        }
        else{
          

          obj.TeamGb = $("#TeamGb").val();
          obj.Sex = $("#SexLevel option:selected").attr("data-sex");
          obj.Level = $("#SexLevel option:selected").attr("data-level");        
        }

        obj.GroupGameGb = localStorage.getItem("GroupGameGb");
        obj.LeftRightGb = varLeftRightGb;
        
        var jsonData = JSON.stringify(obj);

        //console.log(jsonData)

        //alert(jsonData);

        $.ajax({
            url: '../../ajax/judo_os/GGameSearchList.ashx',
            dataType: "text",
            type: 'post',
            data: jsonData,
            async:false,
            success: function (sdata) {

              //console.log(sdata);

              var myArr = JSON.parse(sdata);



              if (myArr.length > 0){
                  
                //localStorage.setItem("RGameLevelidx",myArr[0].RGameLevelidx);

              }

              /* 개인전, 단체전에 따른 player-info 높이 조절 */
              // $('.enter-type').changeType('.btn-list .btn');
              defer.resolve(sdata);
//              console.log(sdata);
            },
            error: function (errorText) {
              defer.reject(errorText);
            }
        });
        return defer.promise();
        
      }

      //해당 체급 정보(리그전)
      function checkgamelevel(){

        var defer = $.Deferred();
        var obj = {};

        obj.SportsGb = localStorage.getItem("SportsGb");
        obj.GameTitleIDX = localStorage.getItem("GameTitleIDX");

        if(localStorage.getItem("BackPage") == "enter-score"){
          
          obj.TeamGb = localStorage.getItem("TeamGb");
          obj.Sex = localStorage.getItem("Sex");
          obj.Level = localStorage.getItem("Level");
          
        }
        else{
          

          obj.TeamGb = $("#TeamGb").val();
          obj.Sex = $("#SexLevel option:selected").attr("data-sex");
          obj.Level = $("#SexLevel option:selected").attr("data-level");        
        }

        obj.GroupGameGb = localStorage.getItem("GroupGameGb");
        
        var jsonData = JSON.stringify(obj);

        var strGameType = "";

        $.ajax({
            url: '../../ajax/judo_os/GGameLevelInfo.ashx',
            dataType: "text",
            type: 'post',
            data: jsonData,
            async:false,
            success: function (sdata) {
              console.log(sdata);

              var myArr = JSON.parse(sdata);

              if (myArr.length > 0){
                
                strGameType = myArr[0].GameType

                localStorage.setItem("GameType",myArr[0].GameType);
                localStorage.setItem("RGameLevelidx",myArr[0].RGameLevelidx);
                //console.log("RGameLevelidx:" + myArr[0].RGameLevelidx);


                /***************임시경기***************/

                //여초 -52 3,4위전이라면
                if(myArr[0].RGameLevelidx == "454"){
                  $("#AddGame_12th").css("display","");
                  $("#AddGame_34th").css("display","none");
                } 
                //여초 -52전 이라면
                else if(myArr[0].RGameLevelidx == "318"){
                  $("#AddGame_12th").css("display","none");
                  $("#AddGame_34th").css("display","");               
                }
                else{
                  $("#AddGame_12th").css("display","none");
                  $("#AddGame_34th").css("display","none");                     
                }

                /****************임시경기***************/

              }

              defer.resolve(sdata);

            },
            error: function (errorText) {
              defer.reject(errorText);
            }
        });
        return strGameType;
        
      }
      
      
    //공식경기 시합결과
    var callRGameResult=function(strBackPage){

        var defer = $.Deferred();
        var obj = {};

        obj.SportsGb = localStorage.getItem("SportsGb");
        obj.GameTitleIDX = localStorage.getItem("GameTitleIDX");
        obj.GroupGameGb = localStorage.getItem("GroupGameGb");
        obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");
        //obj.TeamGb = $("#TeamGb").val();
        //obj.Sex = $("#Sex").val();
        //obj.Level = $("#Level").val();

        if(strBackPage == "enter-score"){
          obj.TeamGb = localStorage.getItem("TeamGb");
          obj.Sex = localStorage.getItem("Sex");
          obj.Level = localStorage.getItem("Level");
          
          //이 시점에서 이전버튼으로 온 구분값 초기화
          localStorage.setItem("BackPage","");
        }
        else{
          obj.TeamGb = $("#TeamGb").val();
          obj.Sex = $("#SexLevel option:selected").attr("data-sex");
          obj.Level = $("#SexLevel option:selected").attr("data-level");       
        }

        var jsonData = JSON.stringify(obj);


        $.ajax({
            url: '../../ajax/judo_os/GGameResultList.ashx',
            dataType: "text",
            type: 'post',
            data: jsonData,
            async:false,
            success: function (sdata1) {

              //console.log(sdata1);

              defer.resolve(sdata1);
            },
            error: function (errorText) {
              defer.reject(errorText);
            }
        });
      
        return defer.promise();
        
    }

    //S:대전선수명 및 승자 가져오기
    var loadwinresult = function (strPlayerGameNum) {
        var defer = $.Deferred();

        var obj = {};

        obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");
        obj.PlayerGameNum = strPlayerGameNum;

        var jsonData = JSON.stringify(obj);

        var events = "";


        $("#DP_L_GameResult").find("option").remove();
        $("#DP_R_GameResult").find("option").remove();

        $.ajax({
            url: '../../ajax/judo_os/GGameWinResult.ashx',
            type: 'post',
            data: jsonData,
            success: function (sdata) {


                //alert(sdata);

                var myArr = JSON.parse(sdata);

                if (myArr.length > 0) {

                    $("#DP_Edit_LPlayer").attr("class", "player-name");
                    $("#DP_Edit_RPlayer").attr("class", "player-name");

                    //modal 선수명 표시
                    $("#DP_Edit_LPlayer").html(myArr[0].LPlayerName);
                    $("#DP_Edit_RPlayer").html(myArr[0].RPlayerName);

                    $("#DP_Edit_LSCName").html(myArr[0].LSchoolName);
                    $("#DP_Edit_RSCName").html(myArr[0].RSchoolName);

                    localStorage.setItem("MediaLink", myArr[0].MediaLink);

                    if (localStorage.getItem("MediaLink") == "") {
                        $("#btn_movie").addClass("off").html('영상미등록'); //.text("영상미등록");
                    } else {
                        $("#btn_movie").removeClass("off").html('<span class="ic-deco"><img src="../images/stat/film-icon@3x.png" alt="">  </span>영상보기'); //.text("영상보기");
                    }

                    if (myArr[0].LResult != "") {
                        //승리자 트로피표시
                        $("#DP_Edit_LPlayer").attr("class", "player-name");
                        $("#DP_Edit_LPlayer").prev().attr("class", "disp-win");

                        //상단 승리표시
                        $("#DP_Win_Title").html(myArr[0].LResult);


                        //좌측선수 반칙,실격,부전/기권 승 selected
                        if (myArr[0].LPlayerResult == "sd019005" || myArr[0].LPlayerResult == "sd019013" || myArr[0].LPlayerResult == "sd019006" || myArr[0].LPlayerResult == "sd019022" || myArr[0].LPlayerResult == "sd019025" || myArr[0].LPlayerResult == "sd019026") {
                            $("#DP_L_GameResult").append("<option value='" + myArr[0].LPlayerResult + "'>" + myArr[0].LResult + "</option>");
                        }
                        else {
                            $("#DP_L_GameResult").append("<option value=''>" + "-" + "</option>");
                        }

                        if (myArr[0].LPlayerResult == "sd019012" || myArr[0].RPlayerResult == "sd019021") {
                            $("#DP_Edit_LPlayer").attr("class", "player-name");
                        }

                        $(".modal-body").find("h4 > span").html(myArr[0].LResult);
                    }
                    else {
                        $("#DP_L_GameResult").append("<option value=''>" + "-" + "</option>");
                        $("#DP_Edit_LPlayer").attr("class", "player-name");
                        $("#DP_Edit_LPlayer").prev().attr("class", "disp-none");
                    }

                    if (myArr[0].RResult != "") {
                        //승리자 트로피표시
                        $("#DP_Edit_RPlayer").attr("class", "player-name");
                        $("#DP_Edit_RPlayer").prev().attr("class", "disp-win");
                        //상단 승리표시
                        $("#DP_Win_Title").html(myArr[0].RResult);


                        //좌측선수 반칙,실격,부전/기권 승 selected
                        if (myArr[0].RPlayerResult == "sd019005" || myArr[0].RPlayerResult == "sd019013" || myArr[0].RPlayerResult == "sd019006" || myArr[0].RPlayerResult == "sd019022" || myArr[0].RPlayerResult == "sd019025" || myArr[0].RPlayerResult == "sd019026") {
                            $("#DP_R_GameResult").append("<option value='" + myArr[0].RPlayerResult + "'>" + myArr[0].RResult + "</option>");
                        }
                        else {
                            $("#DP_R_GameResult").append("<option value=''>" + "-" + "</option>");
                        }

                        if (myArr[0].RPlayerResult == "sd019012" || myArr[0].RPlayerResult == "sd019021") {
                            $("#DP_Edit_RPlayer").attr("class", "player-name");
                        }



                        $(".modal-body").find("h4 > span").html(myArr[0].RResult);

                    }
                    else {
                        $("#DP_R_GameResult").append("<option value=''>" + "-" + "</option>");
                        $("#DP_Edit_RPlayer").attr("class", "player-name");
                        $("#DP_Edit_RPlayer").prev().attr("class", "disp-none");
                    }


                }

                else {
                    $("#DP_L_GameResult").append("<option value=''>" + "-" + "</option>");
                    $("#DP_Edit_LPlayer").attr("class", "player-name");
                    $("#DP_R_GameResult").append("<option value=''>" + "-" + "</option>");
                    $("#DP_Edit_RPlayer").attr("class", "player-name");

                    $("#DP_Edit_LPlayer").html("불참자");
                    $("#DP_Edit_RPlayer").html("불참자");

                    $("#DP_Edit_LSCName").html("불참학교");
                    $("#DP_Edit_RSCName").html("불참학교");
                }

                $(".player-match-option.player-point").hide();
                $("#DP_L_GameResult").attr("disabled", "disabled");
                $("#DP_R_GameResult").attr("disabled", "disabled");

                defer.resolve(sdata);
            },
            error: function (errorText) {
                defer.reject(errorText);
            }
        });
        return defer.promise();
    }
    //E:대전선수명 및 승자 가져오기
      
    //S:현재점수 가져오기
    var nowscore = function(strPlayerGameNum){
      var defer = $.Deferred();

      var obj = {};

      obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");
      obj.PlayerGameNum = strPlayerGameNum;  

      var jsonData = JSON.stringify(obj);

      var events = "";

      $.ajax({
        url: '../../ajax/judo_os/GGameNowScore.ashx',
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
              //$("#RJumsuGb3").html(myArr[0].Right03);
              $("#RJumsuGb4").html(myArr[0].Right04);

            }
            else{

              $("#LJumsuGb1").html("0");
              $("#LJumsuGb2").html("0");
              //$("#LJumsuGb3").html("0");
              $("#LJumsuGb4").html("0");
              $("#RJumsuGb1").html("0");
              $("#RJumsuGb2").html("0");
              //$("#RJumsuGb3").html("0");
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
            //$("#RJumsuGb3").html("0");
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

        $.ajax({
            url: '../../ajax/judo_os/tblGameResultDtlSelect.ashx',
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
                  
                  if(myArr[i].OverTime == "1"){
                    strplaylog +="(연)"
                  }

                  strplaylog += "[<span class='record-time'>";

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
                
                $("#DP_result-list-title").html();
                $("#DP_result-list").html(strplaylog);


              } else {

               // $("#DP_result-list").html("");
                //다른 데이터 클릭 후 득실기록이 없는 데이터 클릴시 득실기록 초기화
                var strplaylog = "";
                strplaylog += "<li class='opponent recent'>";
                strplaylog += "</li>";
                $("#DP_result-list").html(strplaylog);
              }

            if (localStorage.getItem("MediaLink") == "") {
                $("#btn_movie").addClass("off").html('영상미등록'); //.text("영상미등록");
            } else {
                $("#btn_movie").removeClass("off").html('<span class="ic-deco"><img src="../images/stat/film-icon@3x.png" alt="">  </span>영상보기'); //.text("영상보기");
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
    function editscore(objbtn) {
        var objClass = $(objbtn).attr("class");
        console.log(localStorage.getItem("GroupGameGb"));
        //게임 번호 가져오기
        //단체전일때 단체전 구성페이지, 개인전일때 스코어 입력페이지
        if (localStorage.getItem("GroupGameGb") == "sd040001") {
            //몇라운드인지 담기
            localStorage.setItem("PlayerGameNum", objbtn.getAttribute("data-id"));
            //라운드 depth 담기(몇번째 강인지..)
            localStorage.setItem("PlayRound", objbtn.getAttribute("data-whatever"));

            //몇라운드인지 담기
            localStorage.setItem("GroupGameNum", "0");
            //라운드 depth 담기(몇번째 강인지..)
            localStorage.setItem("GroupRound", "0");

            //현재점수가져오기
            nowscore(objbtn.getAttribute("data-id"));

            //선수 & 승자가져오기
            loadwinresult(objbtn.getAttribute("data-id"));

            //현재 양측 부전패,무승부인지
            nowdualresult(objbtn.getAttribute("data-id"));

            //경기로그 가져오기
            loadplaylog(objbtn.getAttribute("data-id"));

            $("#show-score").modal("show");
            history.pushState({ page: 1, name: '팝업' }, '', '?GameTitleIDX=' + localStorage.getItem("GameTitleIDX") + '&GameTitleName=' + localStorage.getItem("GameTitleName"));
        }
        else {

            localStorage.setItem("GroupGameNum", objbtn.getAttribute("data-id"));
            //라운드 depth 담기(몇번째 강인지..)
            localStorage.setItem("GroupRound", objbtn.getAttribute("data-whatever"));

            //학교vs학교 결과 및 점수
            select_groupresult();

            //현재 양측 부전패,무승부인지
            nowGroupdualresult(objbtn.getAttribute("data-id"));

            //학교의 참가자
            select_rplayer();
            $("#groupshow-score").modal("show");
            history.pushState({ page: 1, name: '팝업' }, '', '?GameTitleIDX=' + localStorage.getItem("GameTitleIDX") + '&GameTitleName=' + localStorage.getItem("GameTitleName"));
        }
    }

    //S:등록했던 단체전 선수 불러오기
    function select_rplayer() {

        var defer = $.Deferred();

        var obj = {};

        obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");
        obj.GroupGameNum = localStorage.getItem("GroupGameNum");

        var jsonData = JSON.stringify(obj);

        var strhtml_left_title = "";
        var strhtml_right_title = "";

        var strhtml_left = "";
        var strhtml_right = "";

        strhtml_left_title = "<ul class='title clearfix'>";
        strhtml_left_title += "<li>선수명</li>";
        strhtml_left_title += "<li>체급항목</li>";
        strhtml_left_title += "<li>승패</li>";
        strhtml_left_title += "</ul>";

        strhtml_right_title = "<ul class='title clearfix'>";
        strhtml_right_title += "<li>승패</li>";
        strhtml_right_title += "<li>체급항목</li>";
        strhtml_right_title += "<li>선수명</li>";
        strhtml_right_title += "</ul>";


        //var arrayWinplayer = winplayer_select();  //승리한 선수 가져오기

        $.ajax({
            url: '../../ajax/judo_os/GGameGroupRPlayerSelect.ashx',
            type: 'post',
            data: jsonData,
            success: function (sdata) {

                var strlist = "";

                var myArr = JSON.parse(sdata);

                if (myArr.length > 0) {

                    var LName_FontSize = "";
                    var RName_FontSize = "";


                    for (var i = 0; i < myArr.length; i++) {

                        if (myArr[i].LUserName.length > 5) {
                            LName_FontSize = "style='font-size:7px'";
                        }
                        else {
                            LName_FontSize = "";
                        }

                        if (myArr[i].RUserName.length > 5) {
                            RName_FontSize = "style='font-size:7px'";
                        }
                        else {
                            RName_FontSize = "";
                        }


                        strhtml_left += "<ul class='clearfix'>";
                        strhtml_left += "<li>" + myArr[i].LUserName + "</li>";
                        strhtml_left += "<li>" + myArr[i].LLevelName + "</li>";
                        strhtml_left += "<li " + LName_FontSize + ">" + myArr[i].LPlayerResult + "</li>";
                        strhtml_left += "</ul>";

                        strhtml_right += "<ul class='clearfix'>";
                        strhtml_right += "<li>" + myArr[i].RPlayerResult + "</li>";
                        strhtml_right += "<li>" + myArr[i].RLevelName + "</li>";
                        strhtml_right += "<li " + RName_FontSize + ">" + myArr[i].RUserName + "</li>";
                        strhtml_right += "</ul>";

                        $("#DP_LeftGroup").html(strhtml_left_title + strhtml_left);
                        $("#DP_RightGroup").html(strhtml_right_title + strhtml_right);

                    }

                }
                else {
                    $("#DP_LeftGroup").html(strhtml_left_title);
                    $("#DP_RightGroup").html(strhtml_right_title);
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

          console.log("end_s:" + jsonData);

      var events = "";
      
      //var arrayWinplayer = winplayer_select();  //승리한 선수 가져오기
      
      $.ajax({
          url: '../../ajax/judo_os/GGameGroupWinEndCheck.ashx',
          type: 'post',
          data: jsonData,
          success: function (sdata) {
            var strlist = "";
            var i = 0;
      
            var myArr = JSON.parse(sdata);


            if (myArr.length > 0){
              //4승4패(25점)
              $("#DP_LSchoolName").html(myArr[0].LeftSchoolName);
              $("#DP_LResult").html(myArr[0].LeftWinCnt + "승" + myArr[0].LeftDrawCnt + "무" + myArr[0].LeftLoseCnt + "패(" + myArr[0].LeftJumsu + ")");
              $("#DP_RSchoolName").html(myArr[i].RightSchoolName);
              $("#DP_RResult").html(myArr[0].RightWinCnt + "승" + myArr[0].RightDrawCnt + "무" + myArr[0].RightLoseCnt + "패(" + myArr[0].RightJumsu + ")");

              localStorage.setItem("NowGroupGameCnt",myArr[0].GameCnt);

              localStorage.setItem("LeftWinCnt", myArr[0].LeftWinCnt);
              localStorage.setItem("RightWinCnt", myArr[0].RightWinCnt);

        localStorage.setItem("MediaLink",myArr[0].MediaLink);

        if (localStorage.getItem("MediaLink") == "") {
            $("#btn_groupmovie").addClass("off").html('영상미등록'); //.text("영상미등록");
        } else {
            $("#btn_groupmovie").removeClass("off").html('<span class="ic-deco"><img src="../images/stat/film-icon@3x.png" alt="">  </span>영상보기'); //.text("영상보기");
        }
              //상단 WIN표시 초기화
              $("#DP_LSchoolName").attr("class","");
              $("#DP_RSchoolName").attr("class","");

              //승패구분하여 승리팀 상단에 표시
              if (Number(myArr[0].LeftWinCnt) > myArr[0].RightWinCnt)
              {
                $("#DP_WinGroup").html( myArr[0].LeftSchoolName + "(" + myArr[0].LeftJumsu + ")");
                $("#DP_LSchoolName").attr("class","win");
              }
              else if(Number(myArr[0].LeftWinCnt) < myArr[0].RightWinCnt)
              {
                $("#DP_WinGroup").html( myArr[0].RightSchoolName + "(" + myArr[0].RightJumsu + ")");
                $("#DP_RSchoolName").attr("class","win");
              }
              else{
                if( Number(myArr[0].LeftJumsu) > Number(myArr[0].RightJumsu) ){
                  $("#DP_WinGroup").html( myArr[0].LeftSchoolName + "(" + myArr[0].LeftJumsu + ")");
                  $("#DP_LSchoolName").attr("class","win");
                }
                else if( Number(myArr[0].LeftJumsu) < Number(myArr[0].RightJumsu) ){
                  $("#DP_WinGroup").html( myArr[0].RightSchoolName + "(" + myArr[0].RightJumsu + ")");
                  $("#DP_RSchoolName").attr("class","win");
                }
                else{

                  if(myArr[0].LResult != "" && (myArr[0].LResult = myArr[0].RResult)){
                    $("#DP_WinGroup").html("양측" + " " + myArr[0].LResultNM);
                    $("#DP_LResult").html(myArr[0].LResultNM);
                    $("#DP_RResult").html(myArr[0].RResultNM);
                  }
                  else if(myArr[0].LResult == "sd019006"){
                    $("#DP_WinGroup").html(myArr[0].LeftSchoolName + " " + myArr[0].LResultNM);
                    $("#DP_LSchoolName").attr("class","win");
                    $("#DP_LResult").html("승(부전)");
                    $("#DP_RResult").html("패(부전)");
                  }
                  else if(myArr[0].RResult == "sd019006"){
                    $("#DP_WinGroup").html(myArr[0].RightSchoolName + " " + myArr[0].RResultNM);
                    $("#DP_LSchoolName").attr("class","win");
                    $("#DP_LResult").html("패(부전)");
                    $("#DP_RResult").html("승(부전)");
                  }

                  else{
                    $("#DP_WinGroup").html("동점");
                  }
                }
              }

              
              if ( myArr[0].LeftWinCnt == myArr[0].RightWinCnt)
              {
                if(myArr[0].LeftJumsu == myArr[0].RightJumsu){
                  //경기등록 확인창
                  $("#btn_groupcomplete").attr("data-target","#result-save-modal");
                }
                else{
                  //동점입니다 창
                  $("#btn_groupcomplete").attr("data-target","#same-score-modal");
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

    //S:경기결과 보기 시(localStorage.getItem("IntroIndex") == 2) 해당게임 메달가져오기
    function select_medal(){

      var defer = $.Deferred();
      
      var obj = {};

      obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");
      
      var jsonData = JSON.stringify(obj);

            //alert(jsonData);

      var strhtml = "";
      
      $.ajax({
          url: '../../ajax/judo_os/GGameMedalSelect.ashx',
          type: 'post',
          data: jsonData,
          success: function (sdata) {

            var strlist = "";
            var i = 0;

            //console.log(sdata);

            var myArr = JSON.parse(sdata);


            if (myArr.length > 0){

              for (var i = 0; i < myArr.length; i++){

                //개인전 메달결과..
                if(localStorage.getItem("GroupGameGb") == "sd040001"){
                  strhtml += "<li>"
                  strhtml += "<span class='medal-img'>"

                  //메달 : 금-sd034001, 은-sd034002, 동-sd034003
                  if(myArr[i].TitleResult == "sd034001"){
                      strhtml += "<img src='../../Webtournament/www/images/tournerment/tourney/golden-medal@3x.png' alt='금' width='39' height='56'>"
                  }
                  else if(myArr[i].TitleResult == "sd034002"){
                      strhtml += "<img src='../../Webtournament/www/images/tournerment/tourney/silver-medal@3x.png' alt='은' width='39' height='56'>"
                  }
                  else if(myArr[i].TitleResult == "sd034003"){
                      strhtml += "<img src='../../Webtournament/www/images/tournerment/tourney/bronze-medal@3x.png' alt='동' width='39' height='56'>"
                  }
                  strhtml += "</span>"
                  strhtml += "<p><span class='player-name' id=''>" + myArr[i].UserName + "</span><span class='player-school'>(" + myArr[i].SchoolName + ")</span></p>"
                  strhtml += "</li>"
                }
                //단체전 메달결과..
                else{
                  strhtml += "<li>"
                  strhtml += "<span class='medal-img'>"

                  //메달 : 금-sd034001, 은-sd034002, 동-sd034003
                  if(myArr[i].TitleResult == "sd034001"){
                      strhtml += "<img src='../../Webtournament/www/images/tournerment/tourney/golden-medal@3x.png' alt='금' width='39' height='56'>"
                  }
                  else if(myArr[i].TitleResult == "sd034002"){
                      strhtml += "<img src='../../Webtournament/www/images/tournerment/tourney/silver-medal@3x.png' alt='은' width='39' height='56'>"
                  }
                  else if(myArr[i].TitleResult == "sd034003"){
                      strhtml += "<img src='../../Webtournament/www/images/tournerment/tourney/bronze-medal@3x.png' alt='동' width='39' height='56'>"
                  }
                  strhtml += "</span>"
                  strhtml += "<p><span class='player-name' id=''>" +myArr[i].SchoolName + "</span></p>"
                  strhtml += "</li>"                
                }

              }

              $("#DP_MedalList").html(strhtml);
              
            } 
            else{
                strhtml = "<p class='result-content'><span class='playing-now' id=''></span></p>"; //해당 경기는 진행 준비중인 경기 입니다.
              $("#DP_MedalList").html(strhtml);
            }
            defer.resolve(sdata);
          },
          error: function (errorText) {
            defer.reject(errorText);
          }
      
          
      });
      return defer.promise();   
    }
    //E:경기결과 보기 시(localStorage.getItem("IntroIndex") == 2) 해당게임 메달가져오기

    //S:경기결과 보기의 리스트탭 불러오기_1
    function select_RoundList(){

      var defer = $.Deferred();
      
      var obj = {};
      
      obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");
      obj.GroupGameGb = localStorage.getItem("GroupGameGb");
      
      var jsonData = JSON.stringify(obj);

      var strhtml = "";

	  if(localStorage.getItem("GameType") == "sd043005"){
		
		strhtml += "<section class='match'>";
		strhtml += " <h4>최종평가전 리스트보기는 준비 중 입니다.</h4>";
		strhtml += "</section>";
		$("#DP_ResultReport").html(strhtml);
		return;
	  }

      //callRGameResult
      $.ajax({
          url: '../../ajax/judo_os/GGameRoundList.ashx',
          type: 'post',
          data: jsonData,
          success: function (sdata) {
              var i = 0;
              var myArr = JSON.parse(sdata);
              var strKang = "";

              if (myArr.length > 0) {

                  if (checkgamelevel() == "sd043001") {
                      strKang = "리그전";
                  }

                  for (var i = 0; i < myArr.length; i++) {
                      strhtml += " <section class='match'>";

                      if (strKang != "리그전") {
                          if (i == 1) {
                              strKang = "준결승";
                          }
                          else {
                              strKang = myArr[i].strGameClassNum;

                          }
                      }



                      strhtml += "<h4>" + strKang + "</h4>";

                      var loadRounddetail = $.when(select_RoundListDetail(myArr[i].strRound));

                      loadRounddetail.done(function (sdata1) {

                          var j = 0;

                          var myArr1 = JSON.parse(sdata1);


                          if (myArr1.length > 0) {
                              strhtml += "<ul class='match-info'>";
                              for (var j = 0; j < myArr1.length; j++) {

                                  var varMediaLink = myArr1[j].MediaLink;

                                  console.log("varMediaLink" + varMediaLink);

                                  strhtml += "<li class='clearfix'>";
                                  strhtml += "<a  class='clearfix' role='button' tabindex='-1' ";
                                  strhtml += " onclick='editscore(this)' data-toggle='modal' data-id='" + myArr1[j].GameNum + "' data-whatever='" + myArr[i].strRound + "'";
                                  strhtml += " > ";
                                  //time-in  time-out no-movie-clip
                                  // strhtml += "  role='button' class='btn btn-danger btn-look time-out' > ";
                                  strhtml += "<p class='number'>" + myArr1[j].GameNum + "</p>"
                                  strhtml += "<p class='me'>" + myArr1[j].LPlayerName + "";
                                  // no-movie-clip

                                  if (myArr1[j].LPlayerResult != "") {

                                      if (localStorage.getItem("GroupGameGb") == "sd040001") {
                                          strhtml += "(" + myArr1[j].GameResult.replace("승", "").replace("(", "").replace(")", "") + "";
                                          strhtml += "승)";
                                      }
                                  }

                                  strhtml += "<span></span> </p> <p class='vs'>VS</p>"

                                  strhtml += "<p class='you'>" + myArr1[j].RPlayerName + ""
                                  if (myArr1[j].RPlayerResult != "") {
                                      if (localStorage.getItem("GroupGameGb") == "sd040001") {
                                          strhtml += "(" + myArr1[j].GameResult.replace("승", "").replace("(", "").replace(")", "") + "";
                                          strhtml += "승)";
                                      }
                                  }
                                  strhtml += " <span></span></p></a>";
                                  strhtml += "</li>";

                              }
                              strhtml += "</ul>";
                          }


                      });
                      strhtml += "</dl>";
                  }

              }
              else {

                                    strhtml += "<section class='match'>";
                                    strhtml += " <h4>완료된 경기만 출력 됩니다.</h4>";
                                    strhtml += "</section>";

              }
              $("#DP_ResultReport").html(strhtml);
              defer.resolve(sdata);

          },
          error: function (errorText) {
              defer.reject(errorText);
          }


      });
      return defer.promise();   
    }

    //E:경기결과 보기의 리스트탭 불러오기_1

    //S:경기결과 보기의 리스트탭 상세불러오기_2
    function select_RoundListDetail(strRound) {

        var defer = $.Deferred();

        var obj = {};

        obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");
        obj.GroupGameGb = localStorage.getItem("GroupGameGb");
        obj.strRound = strRound;

        var jsonData = JSON.stringify(obj);

        var strhtml = "";


        $.ajax({
            url: '../../ajax/judo_os/GGameRoundListDetail.ashx',
            type: 'post',
            data: jsonData,
            async: false,
            success: function (sdata1) {

                var strlist = "";
                var i = 0;

                //console.log(sdata1);

                var myArr1 = JSON.parse(sdata1);

                if (myArr1.length > 0) {

                    /*
                    for (var i = 0; i < myArr1.length; i++){

                    strhtml = "<dd>";
                    strhtml = "<a href='#' role='button' tabindex='-1' data-toggle='modal' data-target='#show-score'>";
                    strhtml = "<span class='label'>" + myArr1[i].GameNum + "</span><span>" + myArr1[i].GameNum + "</span>" + myArr1[i].GameNum + " vs <span>" + myArr[i]1.GameNum + "</span> / <span>(" + myArr1[i].GameNum + ")</span>";
                    strhtml = "</a>";
                    strhtml = "</dd>";

                    }
                    */


                }
                else {


                }

                defer.resolve(sdata1);
            },
            error: function (errorText) {
                defer.reject(errorText);
            }


        });
        return defer.promise();
    }
    //E:경기결과 보기의 리스트탭 상세불러오기_2

    //S:끝나지않은 개인전 상위버튼 눌렀을때 이전게임 종료 요구
    function loadRoundYN(strPlayerGameNum, strGroupGameNum) {
        var defer = $.Deferred();

        var obj = {};

        obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");
        obj.GroupGameNum = strGroupGameNum;
        obj.PlayerGameNum = strPlayerGameNum;
        obj.GameType = localStorage.getItem("GameType");

        var jsonData = JSON.stringify(obj);

        //alert(jsonData);

        var events = "";

        var varloadRound = 0;

        $.ajax({
            url: '../../ajax/judo_os/GGameScoreDetail.ashx',
            type: 'post',
            data: jsonData,
            async: false,
            success: function (sdata) {

                //console.log(sdata);

                //alert(sdata);

                var myArr = JSON.parse(sdata);

                if (myArr.length > 0) {

                    varloadRound = myArr.length;

                }
                else {
                    varloadRound = 0;
                }

                //alert(varloadRound);

                defer.resolve(sdata);
            },
            error: function (errorText) {
                defer.reject(errorText);
            }
        });
        return varloadRound;
    }
    //E:끝나지않은 개인전 상위버튼 눌렀을때 이전게임 종료 요구

    //S:끝나지않은 단체전 상위버튼 눌렀을때 이전게임 종료 요구
    function loadGroupRoundYN(strGroupGameNum) {
        var defer = $.Deferred();

        var obj = {};

        obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");
        obj.PlayerGameNum = strGroupGameNum;

        var jsonData = JSON.stringify(obj);

        var events = "";

        var varloadRound = 0;

        $.ajax({
            url: '../../ajax/judo_os/GGameGroupScoreDetail.ashx',
            type: 'post',
            data: jsonData,
            async: false,
            success: function (sdata) {



                var myArr = JSON.parse(sdata);

                if (myArr.length > 0) {

                    varloadRound = myArr.length;

                }
                else {
                    varloadRound = 0;
                }

                //alert(varloadRound);

                defer.resolve(sdata);
            },
            error: function (errorText) {

                defer.reject(errorText);
            }


        });
        return varloadRound;
    }


    //E:끝나지않은 단체전 상위버튼 눌렀을때 이전게임 종료 요구



    //S:해당 단체전 라운드의 선수등록 유무 조회
    function groupplayercnt(strGroupGameNum){

      var defer = $.Deferred();

      var obj = {};

      obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");
      obj.GroupGameNum = strGroupGameNum;

      var jsonData = JSON.stringify(obj);

      var strGroupPlayerCnt = "";

      $.ajax({
        url: '../../ajax/judo_os/GGamePlayerCount.ashx',
        type: 'post',
        async:false,
        data: jsonData,
        success: function (sdata) {

          var myArr = JSON.parse(sdata);

          if (myArr.length > 0){

            strGroupPlayerCnt = myArr[0].GroupPlayerCnt;
            
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

      return [strGroupPlayerCnt];
    }
    //E:해당 단체전 라운드의 선수등록 유무 조회 

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
        url: '../../ajax/judo_os/GGameDualResultList.ashx',
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

    //S:양선수 부전패, 무승부 판정 가져오기
    function nowGroupdualresult(strPlayerGameNum){

      var defer = $.Deferred();

      var obj = {};

      obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");
      obj.GroupGameNum = strPlayerGameNum;

      var jsonData = JSON.stringify(obj);

      var events = "";

      $.ajax({
        url: '../../ajax/judo_os/GGameGroupDualResultList.ashx',
        type: 'post',
        data: jsonData,
        success: function (sdata) {

          //alert(sdata);

          $("#DP_LSchoolName").attr("class","");
          $("#DP_RSchoolName").attr("class","");

        

          var myArr = JSON.parse(sdata);


          if (myArr.length > 0){
                
            //양선수 부전패라면..

            $("#DP_LSchoolName").html(myArr[0].LSchoolName);
            $("#DP_RSchoolName").html(myArr[0].RSchoolName);

            if ( myArr[0].LResult != "" && (myArr[0].LResult == myArr[0].RResult))
            {
                
              if (myArr[0].LResult == "sd019012")
              {
                 $("#DP_WinGroup").html("양측 부전패");
              }
              //무승부(단체전)라면..
              else if (myArr[0].LResult == "sd019024")
              {
                 $("#DP_WinGroup").html("양측 무승부");
              }
                 
              else{
                $("#DP_WinGroup").html("ETC 결과");                 
              }                 

            }
            else{
              if(myArr[0].LResult != "")
              {
                $("#DP_WinGroup").html(myArr[0].LSchoolName + "(" + myArr[0].LResultName + ")");

                $("#DP_LSchoolName").attr("class","win");
                $("#DP_RSchoolName").attr("class","");
              }

              if(myArr[0].RResult != "")
              {
                $("#DP_WinGroup").html(myArr[0].RSchoolName + "(" + myArr[0].RResultName + ")");

                $("#DP_LSchoolName").attr("class","");
                $("#DP_RSchoolName").attr("class","win");
              }
            }

              if($("#DP_LResult").html() == "")
              {
                $("#DP_LResult").html("0승0무0패");
              }

              if($("#DP_RResult").html() == "")
              {
                $("#DP_RResult").html("0승0무0패");
              }

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

    //S:현재 경기상태 조회
    function load_gamestatus(strPlayerGameNum){
        var defer = $.Deferred();

        var obj = {};

        obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");

        //개인전만 쓰므로 0으로 처리
        //obj.GroupGameNum = localStorage.getItem("GroupGameNum");
        obj.GroupGameNum = "0";

        obj.GameNum = strPlayerGameNum;

        var jsonData = JSON.stringify(obj);

        var strGameResult = "";

        $.ajax({
            url: '../../ajax/judo_os/GGameNowGameStatus.ashx',
            type: 'post',
            async:false,
            data: jsonData,
            success: function (sdata) {

              var myArr = JSON.parse(sdata);

              if (myArr.length > 0){
                
                strGameResult = myArr[0].GameStatus;

              } 
                  
              else {
                

              }

              defer.resolve(sdata);
            },
            error: function (errorText) {
              defer.reject(errorText);
            }
        });

        return [strGameResult]; 
    }
    //E:현재 경기상태 조회

    //S:리그전 대진표
    function load_league(){

      var defer = $.Deferred();
      var obj = {};

        obj.SportsGb = localStorage.getItem("SportsGb");
        obj.GameTitleIDX = localStorage.getItem("GameTitleIDX");

      if( localStorage.getItem("BackPage") == "enter-score"){
          
        obj.TeamGb = localStorage.getItem("TeamGb");
        obj.Sex = localStorage.getItem("Sex");
        obj.Level = localStorage.getItem("Level");
          
      }
      else{
 
        obj.TeamGb = $("#TeamGb").val();
        obj.Sex = $("#SexLevel option:selected").attr("data-sex");
        obj.Level = $("#SexLevel option:selected").attr("data-level");        
      }

      obj.GroupGameGb = localStorage.getItem("GroupGameGb");
      obj.LeftRightGb = "sd030001";


      
      var jsonData = JSON.stringify(obj);

      $.ajax({
          url: '../../ajax/judo_os/GGameSearchList.ashx',
          dataType: "text",
          type: 'post',
          data: jsonData,
          async:false,
          success: function (sdata) {


            //선수 정보
            var myArr = JSON.parse(sdata);

            if (myArr.length > 0){

              //localStorage.setItem("RGameLevelidx",myArr[0].RGameLevelidx);

              //console.log(sdata);

              var result_data = "";

              //리그 경기결과확인
              var loaddata_league = $.when(callRGameResult(localStorage.getItem("BackPage")));
              loaddata_league.done(function(rsdata) {
                result_data = rsdata;
              });

              //리그 경기결과확인
              var resultArr = JSON.parse(result_data);
                
              var strhtml = "";
              var intRound = 0;
            
              strhtml = "<table border='1'>";
              strhtml += "<tr>";
              strhtml += "<td>제1조</td>";


                for(var i=0;i<=Number(myArr.length-1);i++){

                  var varNum_i = Number(i)+1;

                  var UserName_Cols = myArr[i].UserName;

                  if(localStorage.getItem("GroupGameGb") == "sd040002"){
                    if (myArr[i].TeamDtl != "0")
                    {
                      UserName_Cols = UserName_Cols + myArr[i].TeamDtl;
                    }
                  }
                  
                  strhtml += "<td width='100px;'>";
                  strhtml += "<p class='player-name'><span class='pre-num'>" + varNum_i + "</span> " + UserName_Cols + "</p>";
                  strhtml += "<p class='player-school'>" + myArr[i].SchoolName + "</p>";
                  strhtml += "</td>";
                }
                  
                strhtml += "<td class='score'>승패(점수)</td>";
                strhtml += "<td class='rank'>순위</td>";
                strhtml += "</tr>";

                for(var i=0;i<=Number(myArr.length-1);i++){

                  var varNum_i = Number(i)+1;

                  var UserName_Rows = myArr[i].UserName;

                  if(localStorage.getItem("GroupGameGb") == "sd040002"){
                    if (myArr[i].TeamDtl != "0")
                    {
                      UserName_Rows = UserName_Rows + myArr[i].TeamDtl;
                    }
                  }

                  strhtml += "<tr>";
                  strhtml += "<td width='100px;'>";
                  strhtml += "<p class='player-name'><span class='pre-num'>" + varNum_i + "</span> " + UserName_Rows  + "</p>";
                  strhtml += "<p class='player-school'>" + myArr[i].SchoolName + "</p>";
                  strhtml += "</td>";
                    
                  for(var j=0;j<=Number(myArr.length-1);j++){

                    if(i != j){

                      strhtml += "<td class='write'>";
                      strhtml += "<p class='player-name'>" + myArr[i].UserName + " vs " + myArr[j].UserName + "</p>";
                      if(i < j){

                        intRound = intRound + 1;

                        var varBtnHTML = "";
                        
                        if (varBtnHTML == "")
                        {

                          //경기결과 매칭
                          for(var k=0;k<=Number(resultArr.length-1);k++){
                            if(intRound == Number(resultArr[k].GameNum)){
                                //개인 리그전일때
                                //경기종료가 되어 경기 결과가 있다면..
                                if(resultArr[k].LPlayerResult != "" || resultArr[k].RPlayerResult != "")
                                {
                                    varBtnHTML = "<a  class='btn btn-write' onclick='editscore(this);' data-id='" + intRound + "' data-whatever='01'>" + intRound + " 경기</a>";               
                                }
                              break;
                            }
                          }
                        }
 
                        if (varBtnHTML == "")
                        {
                            varBtnHTML = "<a class='btn btn-primary btn-look' onclick='editscore(this);' data-id='" + intRound + "' data-whatever='01'>" + intRound + " 경기</a>"; 
                        }

                        if (varBtnHTML == "")
                        {
                          varBtnHTML = "<a class='btn btn-write' onclick='mov_enterscore(this);' data-id='"+intRound+"' data-whatever='01'>경기입력</a>";
                        } 
                        strhtml += varBtnHTML;

                      }
                      strhtml += "</td>";
                    }
                    else{
                      strhtml += "<td class='no'></td>";      
                    }
                  }

                  var array_lgplayer = "";
                  
                  if(localStorage.getItem("GroupGameGb") == "sd040001")
                  {
                      array_lgplayer = leagueplayerresult(myArr[i].UserIDX, "");
                  }
                  else
                  {
                      array_lgplayer = leagueplayerresult(myArr[i].Team, myArr[i].TeamDtl);
                  }

                  var strWinCnt = "";
                  var strDrawCnt = "";
                  var strLoseCnt = "";
                  var strJumsu = "";
                  var strRankNum = "";

                  if (array_lgplayer[0] == ""){strWinCnt = "0";}else{strWinCnt = array_lgplayer[0];}
                  if (array_lgplayer[1] == ""){strDrawCnt = "0";}else{strDrawCnt = array_lgplayer[1];}
                  if (array_lgplayer[2] == ""){strLoseCnt = "0";}else{strLoseCnt = array_lgplayer[2];}
                  if (array_lgplayer[3] == ""){strJumsu = "0";}else{strJumsu = array_lgplayer[3];}
                  if (array_lgplayer[4] == ""){strRankNum = "0";}else{strRankNum = array_lgplayer[4];}
                  
                  strhtml += "<td class='score'>" + strWinCnt + "승" + strDrawCnt + "무" + strLoseCnt + "패(" + strJumsu + ")</td>";
                  strhtml += "<td class='rank'>" + strRankNum + "</td>";
                  strhtml += "</tr>";
                }   
                strhtml += "</table>";

                $("#list_league").html(strhtml);
                        

            }
            defer.resolve(sdata);
          },
          error: function (errorText) {
            defer.reject(errorText);
          }
      });
      return defer.promise();
      
    }
    //E:리그전 대진표

    //S:리그 개인 성적 조회(1승1무1패(25점))
    function leagueplayerresult(strPlayerIDX, strTeamDtl){
        var defer = $.Deferred();

        var obj = {};

        obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");
        obj.GroupGameGb = localStorage.getItem("GroupGameGb");
        obj.PlayerIDX = strPlayerIDX;
        obj.TeamDtl = strTeamDtl;
        

        var jsonData = JSON.stringify(obj);

        console.log("jsonData:" + jsonData);

        var strWinCnt = "";
        var strDrawCnt = "";
        var strLoseCnt = "";
        var strJumsu = "";
        var strRankNum = "";

        $.ajax({
            url: '../../ajax/judo_os/GGameLeaguePlayerResult.ashx',
            type: 'post',
            async:false,
            data: jsonData,
            success: function (sdata) {

            //alert(sdata);
            console.log("sdata:" + sdata);

              var myArr = JSON.parse(sdata);

              if (myArr.length > 0){
                
                strWinCnt = myArr[0].WinCnt;
                strDrawCnt = myArr[0].DrawCnt;
                strLoseCnt = myArr[0].LoseCnt;
                strJumsu = myArr[0].Jumsu;
                strRankNum = myArr[0].RankNum;

              } 
                  
              else {
                

              }

              defer.resolve(sdata);
            },
            error: function (errorText) {
              defer.reject(errorText);
            }
        });

        return [strWinCnt, strDrawCnt, strLoseCnt, strJumsu, strRankNum]; 
    }
    //E:리그 개인 성적 조회(1승1무1패(25점))

    function check_tournament(strSex, strLevel, strTeamGb){

      localStorage.setItem("GroupGameGb", $('input:radio[name="game-type"]:checked').val());
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

      if(localStorage.getItem("MediaLink") == ""){
//        alert("등록된 영상이 없습니다.");
        return;
      }
      
      /*
      var strYoutubeLink = "<iframe width='568' height='318' src='https://www.youtube.com/embed/gzfCmCtSomQ?showinfo=0&autoplay=1&modestbranding=0&fs=1&vq=hd720&loop=1&playlist=gzfCmCtSomQ' frameborder='0' allowfullscreen></iframe>"
      */


    var strYoutubeLink = "<iframe width='568' height='318' src='" + localStorage.getItem("MediaLink") + "?showinfo=0&autoplay=1&modestbranding=0&fs=1&vq=hd720&loop=1&playlist=" + localStorage.getItem("MediaLink").replace("https://www.youtube.com/embed/", "") + "&rel=0&enablejsapi=1&api=1' frameborder='0' allowfullscreen></iframe>"
                

                /*
                var strYoutubeLink = "<iframe width='568' height='318' src=" + localStorage.getItem("MediaLink") + "?showinfo=0&autoplay=1&modestbranding=0&fs=1&vq=hd720&loop=1&playlist=" + localStorage.getItem("MediaLink") + "' frameborder='0' allowfullscreen></iframe>"
                */


      $("#DP_GameVideo").html(strYoutubeLink);

      $("#DP_GameVideo").css("display","");
      $("#DP_Record").css("display","none");

      $("#btn_movie").css("display","none");
      $("#btn_log").css("display","");                
      }
    }

    function changegroup_btn(){
      //기록보기 눌렀을 시
      if($("#btn_groupmovie").css("display") == "none"){

      $("#DP_GroupGameVideo").html("");

      $("#DP_GroupGameVideo").css("display","none");
      $("#DP_GroupRecord").css("display","inline-block");

      $("#btn_groupmovie").css("display","inline-block");
      $("#btn_grouplog").css("display","none");
      }
      else{

      if(localStorage.getItem("MediaLink") == ""){
//        alert("등록된 영상이 없습니다.");
        return;
      }
      
      /*
      var strYoutubeLink = "<iframe width='568' height='318' src='https://www.youtube.com/embed/gzfCmCtSomQ?showinfo=0&autoplay=1&modestbranding=0&fs=1&vq=hd720&loop=1&playlist=gzfCmCtSomQ' frameborder='0' allowfullscreen></iframe>"
      */


    var strYoutubeLink = "<iframe width='568' height='318' src='" + localStorage.getItem("MediaLink") + "?showinfo=0&autoplay=1&modestbranding=0&fs=1&vq=hd720&loop=1&playlist=" + localStorage.getItem("MediaLink").replace("https://www.youtube.com/embed/", "") + "' frameborder='0' allowfullscreen></iframe>"
                

                /*
                var strYoutubeLink = "<iframe width='568' height='318' src=" + localStorage.getItem("MediaLink") + "?showinfo=0&autoplay=1&modestbranding=0&fs=1&vq=hd720&loop=1&playlist=" + localStorage.getItem("MediaLink") + "' frameborder='0' allowfullscreen></iframe>"
                */


      $("#DP_GroupGameVideo").html(strYoutubeLink);

      $("#DP_GroupGameVideo").css("display","");
      $("#DP_GroupRecord").css("display","none");

      $("#btn_groupmovie").css("display","none");
      $("#btn_grouplog").css("display","");                
      }
    }

    var m_SelTeamCode_NowGame = function(id,selTeamGb)
    {
    
    
    var $d=$.Deferred();
    var obj = {};
    obj.SportsGb = localStorage.getItem("SportsGb");
    obj.EnterType = localStorage.getItem("EnterType");
    obj.GameTitleIDX = localStorage.getItem("GameTitleIDX");

      
      
    var jsonData = JSON.stringify(obj);

      $.ajax({
        url: '../../ajax/judo_OS/management/DirTeamNowGame.ashx',
        type: 'post',
        data: jsonData,
        success: function(data){fsuccess(data)},error:ferror
          });
    
        //훈련 select 세팅
        function fsuccess(data){


      var myArr = JSON.parse(data);

      //$(id).find("option").remove();
          $(id).children("option").not("[value='']").remove();
          
      if (myArr.length > 0)
      {
        for (var i = 0; i < myArr.length; i++)
        {

        var varSportsGb = myArr[i].SportsGb;
        var varTeamGb = myArr[i].TeamGb;
        var varTeamGbNm = myArr[i].TeamGbNm;

        if (varTeamGb == selTeamGb)
        {
          $(id).append("<option value='"+ varTeamGb +"' selected>"+ varTeamGbNm +"</option>");
        }
        else
        {
          $(id).append("<option value='"+ varTeamGb +"'>"+ varTeamGbNm +"</option>");
        }
        
        }
      }
      
      $d.resolve(data);
        }

        function ferror(error) {
      console.log(error);
          $d.reject(error);
        }

    return $d.progress();
    };

    //지도자버전에서 검색 체급목록 공통 SSG 20160802
    var m_drLevelList_sum_NowGame = function(id,TeamGb,sellevelcode)
    {


      var defer=$.Deferred();
      var obj = {};

      obj.SportsGb = localStorage.getItem("SportsGb");
      obj.TeamGb = TeamGb;
      obj.GameTitleIDX = localStorage.getItem("GameTitleIDX");

      var jsonData = JSON.stringify(obj);

      //console.log(obj);

      $.ajax({
          url: '../../Ajax/judo_OS/Management/LevelInfo_sum_NowGame.ashx',
          type: 'post',
          data: jsonData,
          success: function(data){fsuccess(data)},error:ferror
      });

      //훈련 select 세팅
      function fsuccess(data){


        //console.log(data);

        var myArr = JSON.parse(data);
        //$(id).children("option").not("[value='']").remove();
        $(id).children("option").remove();
        
        
        if (myArr.length > 0)
        {


          if(localStorage.getItem("GroupGameGb") == "" || localStorage.getItem("GroupGameGb") == "sd040001"){

            $(id).append("<option data-sex='' data-level='' value='' selected>::체급::</option>");

            for (var i = 0; i < myArr.length; i++)
            {
              var varSex = "";
              
              if(myArr[i].Sex == "Man"){
                varSex = "남자";
              }
              else{
                varSex = "여자";                
              }

              if ( myArr[i].Sex + "|" + myArr[i].Level == sellevelcode)
              {
                $(id).append("<option data-sex='" + myArr[i].Sex + "' data-level='" + myArr[i].Level + "' value='" + myArr[i].Sex + "|" + myArr[i].Level +"' selected>" +  /*varSex + " " +*/ myArr[i].LevelNm + "</option>");
              }
              else
              {
                $(id).append("<option data-sex='" + myArr[i].Sex + "' data-level='" + myArr[i].Level + "' value='" + myArr[i].Sex + "|" + myArr[i].Level +"'>" +  /*varSex + " " +*/ myArr[i].LevelNm +"</option>");
              }
              
            }
          }
          else if (localStorage.getItem("GroupGameGb") == "sd040002")
          {
            $(id).append("<option data-sex='' data-level='' value='' selected>::체급::</option>");
            $(id).append("<option data-sex='"+myArr[0].Sex+"' data-level='' value='WoMan' >무차별</option>");
          }
          else{

            //$(id).children("option").remove();
            //$(id).append("<option data-sex='Man' data-level='' value='Man' >남자</option>");
            //$(id).append("<option data-sex='WoMan' data-level='' value='WoMan' >여자</option>");


            $(id).append("<option data-sex='' data-level='' value='' selected>::체급::</option>");
          }
        }
        else{
          if(localStorage.getItem("GroupGameGb") == "" || localStorage.getItem("GroupGameGb") == "sd040001"){   
            $(id).append("<option data-sex='' data-level='' value='' selected>::체급::</option>");            
          }
          else{

            //$(id).children("option").remove();
            //$(id).append("<option data-sex='Man' data-level='' value='Man' >남자</option>");
            //$(id).append("<option data-sex='WoMan' data-level='' value='WoMan' >여자</option>");      
            $(id).append("<option data-sex='' data-level='' value='' selected>::체급::</option>");
            $(id).append("<option data-sex='' data-level='' value='' >무차별</option>");
          }
        }

        defer.resolve(data);

      }

      function ferror() {
        defer.reject(error);
      }
      return defer.progress();
    }





function iMovieLink(link1, link2, playeridx) {

    if (link2 == "개인전") {

        var strAjaxUrl = "/M_Player/Ajax/analysis-DetailScore-Game-Sch.asp";

        $.ajax({

            url: strAjaxUrl,

            type: 'POST',

            dataType: 'html',

            data: {

                iPlayerIDX: playeridx,

                iGameScoreIDX: link1,

                iGroupGameGbName: link2

            },

            success: function (retDATA) {

                // console.log(retDATA);

                if (retDATA) {

                    $('#detailScore').html(retDATA);

                    $('.film-modal').filmTab('.film-modal');

                    $('.groups-res').filmTab('.groups-res');

                } else {

                    $('#detailScore').html("");

                }

            }, error: function (xhr, status, error) {

                alert("오류발생! - 시스템관리자에게 문의하십시오!");

            }

        });


    }

    else {

        var strAjaxUrl = "/M_Player/Ajax/analysis-DetailScore-Game-Sch-Team.asp";

        $.ajax({

            url: strAjaxUrl,

            type: 'POST',

            dataType: 'html',

            data: {

                iPlayerIDX: playeridx,

                iGameScoreIDX: link1,

                iGroupGameGbName: link2

            },

            success: function (retDATA) {

                if (retDATA) {

                    $('#detailScore_Team').html(retDATA);

                    $('.film-modal').filmTab('.film-modal');

                    $('.groups-res').filmTab('.groups-res');

                } else {

                    $('#detailScore_Team').html("");

                }

            }, error: function (xhr, status, error) {

                alert("오류발생! - 시스템관리자에게 문의하십시오!");

            }

        });


    }


    $("#show-score").modal('show');



}


function iFavLink(link1, playeridx) {

    var strAjaxUrl = "/M_Player/Ajax/analysis-film-Mod.asp";

    $.ajax({

        url: strAjaxUrl,

        type: 'POST',

        dataType: 'html',

        data: {

            iPlayerIDX: playeridx,

            iPlayerResultIdx: link1

        },

        success: function (retDATA) {


        }, error: function (xhr, status, error) {

            alert("오류발생! - 시스템관리자에게 문의하십시오!");

        }

    });

}

//S:최종평가전의 패자부활전 및 결승전등 노출여부..
	//해당경기번호의 카운트가 0보다 크면 노출시킴
function playnumberCheck(){

  var defer = $.Deferred();

  var obj = {};

  obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");

  var jsonData = JSON.stringify(obj);

  var strGroupPlayerCnt = "";

  $.ajax({
    url: '/ajax/judo_os/GGamePlayNumberCheck.ashx',
    type: 'post',
    async:false,
    data: jsonData,
    success: function (sdata) {

      var myArr = JSON.parse(sdata);

      defer.resolve(sdata);
    },
    error: function (errorText) {
      defer.reject(errorText);
    }
  });
  
  return defer.promise();     

}
//E:최종평가전의 패자부활전 및 결승전등 노출여부..

//패자부활전 및 3,4위전 2강경기 그리기
//
//elsegame_draw(sdata_01, "natfinal_03", "13");
//
function elsegame_draw(str_sdata_01, str_idother, strgamenum){

  var myArr_sdata_01 = JSON.parse(str_sdata_01);    

  if (myArr_sdata_01.length > 0){

    //좌측선수명
    $("#LPlayerName_" + str_idother).html(myArr_sdata_01[0].UserName);
    //좌측선수소속명
    $("#LSchoolName_" + str_idother).html(myArr_sdata_01[0].SchoolName);

    if (myArr_sdata_01.length > 1){
    //우측선수명
    $("#RPlayerName_" + str_idother).html(myArr_sdata_01[1].UserName);
    //우측선수소속명
    $("#RSchoolName_" + str_idother).html(myArr_sdata_01[1].SchoolName);
    }
    //표색표시 및 버튼

    var load_winresult = $.when(loadwinresult(strgamenum));

    load_winresult.done(function(sdata_winresult) {

      var myArr_sdata_winresult = JSON.parse(sdata_winresult);    
      console.log("결과:" + sdata_winresult);

      var str_linebutton = "";

      if(myArr_sdata_winresult.length > 0){
        

        if(myArr_sdata_winresult[0].LPlayerResult != "" && myArr_sdata_winresult[0].RPlayerResult != ""){
          //양선수 패 및 무승부

        }
        else{

          if(myArr_sdata_winresult[0].LPlayerResult != '' && myArr_sdata_winresult[0].LPlayerResult != 'sd019012' && myArr_sdata_winresult[0].LPlayerResult != 'sd019024' && myArr_sdata_winresult[0].LPlayerResult != 'sd019021' && myArr_sdata_winresult[0].LPlayerResult != 'sd019026'){
              
            str_linebutton = "<a onclick='editscore(this)' role='button' class='final-match-box winner' data-id='" + strgamenum + "' data-toggle='modal'>  <p><span class='final-player'>" + myArr_sdata_winresult[0].LPlayerName + "</span> 승</p></a>"

            str_linebutton += "<img src='../../Webtournament/www/images/tournerment/3_win_L.png' alt=''>";

            str_linebutton += "<a role='button' data-toggle='modal' class='btn btn-danger btn-look time-out' onclick='editscore(this);' data-id='" + strgamenum + "' data-whatever='01'>" + strgamenum + "</a>";

          }
          else if(myArr_sdata_winresult[0].RPlayerResult != '' && myArr_sdata_winresult[0].RPlayerResult != 'sd019012' && myArr_sdata_winresult[0].RPlayerResult != 'sd019024' && myArr_sdata_winresult[0].RPlayerResult != 'sd019021' && myArr_sdata_winresult[0].RPlayerResult != 'sd019026'){

            str_linebutton = "<a onclick='editscore(this)' role='button' class='final-match-box winner' data-id='" + strgamenum + "' data-toggle='modal'>  <p><span class='final-player'>" + myArr_sdata_winresult[0].RPlayerName + "</span> 승</p></a>"
              
            str_linebutton += "<img src='../../Webtournament/www/images/tournerment/3_win_R.png' alt=''>";

            str_linebutton += "<a role='button' data-toggle='modal' class='btn btn-danger btn-look time-out' onclick='editscore(this);' data-id='" + strgamenum + "' data-whatever='01'>" + strgamenum + "</a>";

          }
        }

        $("#LineButton_" + str_idother).html(str_linebutton);
      }
      else{

        str_linebutton = "<img src='../../Webtournament/www/images/tournerment/02_final.png' alt=''>"; 

        //진행중 확인
        var array_gamestatus = load_gamestatus(strgamenum);

        vargamestatus = array_gamestatus[0];  

        //개인전 진행중 이라면 진행중 색깔표시
        if(vargamestatus == "sd050001"){
            str_linebutton += "<a role='button' class='btn btn-danger btn-look time-in' onclick='mov_enterscore(this);' data-id='" + strgamenum + "' data-whatever='01'>" + strgamenum + "</a>";        
        }
        else{
            str_linebutton += "<a role='button' class='btn btn-primary btn-look' onclick='mov_enterscore(this);' data-id='" + strgamenum + "' data-whatever='01'>" + strgamenum + "</a>";       
        }

        $("#LineButton_" + str_idother).html(str_linebutton);
      }
    });   
  }
}


//최종평가전 패자부활전 선수리스트
var callRGameLevel_NationalLoser=function(varLeftRightGb, strBackPage, strGameNumArray){

  var defer = $.Deferred();
  var obj = {};

  obj.SportsGb = localStorage.getItem("SportsGb");
  obj.GameTitleIDX = localStorage.getItem("GameTitleIDX");

  if(strBackPage == "enter-score"){
    
    obj.TeamGb = localStorage.getItem("TeamGb");
    obj.Sex = localStorage.getItem("Sex");
    obj.Level = localStorage.getItem("Level");
    
  }
  else{
    
    obj.TeamGb = $("#TeamGb").val();
    obj.Sex = $("#SexLevel option:selected").attr("data-sex");
    obj.Level = $("#SexLevel option:selected").attr("data-level");        
  }

  obj.GroupGameGb = localStorage.getItem("GroupGameGb");
  obj.LeftRightGb = varLeftRightGb;
  obj.GameNumArray = strGameNumArray;
  obj.GameType = localStorage.getItem("GameType");
  
  var jsonData = JSON.stringify(obj);

  $.ajax({
      url: '/ajax/judo_os/GGameSearchList_NationalLoser.ashx',
      dataType: "text",
      type: 'post',
      data: jsonData,
      async:false,
      success: function (sdata) {

        console.log(sdata);

        var myArr = JSON.parse(sdata);

        if (myArr.length > 0){
            
        }

        defer.resolve(sdata);
      },
      error: function (errorText) {
        defer.reject(errorText);
      }
  });
  return defer.promise();
  
}

function view_result(strType){


	

	if(strType == "B"){


		$("#DP_tourney").css("display","none");
		$("#DP_natfinal_tourney").css("display","none");  
		$("#list_league").css("display","none");  
		

		$("#DP_ResultReport").css("display","block"); 

		$("#Btn_Tournament").attr("class",""); 
		$("#Btn_ResultList").attr("class","on"); 
		
		
		
	}
	else{


		if(localStorage.getItem("GameType") == "sd043005")
		{
			$("#DP_tourney").css("display","none");
			$("#DP_natfinal_tourney").css("display","");  
			$("#list_league").css("display","none");  
		}
		else if(localStorage.getItem("GameType") == "sd043001")
		{
			$("#DP_tourney").css("display","none");
			$("#DP_natfinal_tourney").css("display","none");  
			$("#list_league").css("display","");  		
		}
		else{
			
			$("#DP_tourney").css("display","");
			$("#DP_natfinal_tourney").css("display","none");  
			$("#list_league").css("display","none");  
		}

		$("#DP_ResultReport").css("display","none");  

		$("#Btn_Tournament").attr("class","on"); 
		$("#Btn_ResultList").attr("class",""); 

	
	
	}
	

}

