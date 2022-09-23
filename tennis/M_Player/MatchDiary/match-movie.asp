<!-- S: config -->
<!-- #include file="../include/config.asp" -->
<!-- E: config -->
<%
p_lev =fInject(Request("p_lev"))
%>
<script type="text/javascript">
    //데회 번호 <쿠키:GameTitleIDX >
    //조회
    var p_lev = "<%=p_lev %>";

    if (p_lev=="") {
        p_lev="";
    }


    var GameTitleIDX_cookie = "";
    if (getCookie("GameTitleIDX") != "") {
        GameTitleIDX_cookie = getCookie("GameTitleIDX");
    } else {
        history.back();
    }


    $(document).ready(function () {

        window.onpopstate = function (event) {
            $(".close").click();
            console.log("window.onpopstate");
            $("#show-score").modal("hide");
            if (history.state == null) {

            } else {
                history.back();
            }
        };

        $('#show-score').on('hidden.bs.modal', function (e) {
            $("#show-score").modal("hide");
            if (history.state == null) {

            } else {
                history.back();
            }
        });



        //데이터 조회 일괄 처리
        $.ajax({
            url: "../select/match_diary_select.asp",
            type: 'POST',
            dataType: 'html',
            data: {
                id: "match_final",
                Tryear: "sd040001",
                p_lev: p_lev,
                GameTitleIDX: GameTitleIDX_cookie//$("#GameTitleIDX").val()
            },
            success: function (retDATA) {
                $("#match_final").html(retDATA);
                $("#match_final").iconFavo("#match_final");
            }, error: function (xhr, status, error) {
                if (error != '') {
                    alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!" + ' [' + xhr + ']' + ' [' + status + ']' + ' [' + error + ']');
                }
            }
        });
    });



    function iMovieLink(link1, link2, playeridx) {
        history.pushState({ page: 1, name: '팝업' }, '', '?link1=' + link1 + '&link2=' + link2 + '&playeridx=' + playeridx);
        if (link2 == "개인전") {
            var strAjaxUrl = "../Ajax/analysis-DetailScore-Game-Sch.asp";
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
                    if (error != '') {
                        alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!" + ' [' + xhr + ']' + ' [' + status + ']' + ' [' + error + ']');
                    }
                }
            });

        }
        else {
            var strAjaxUrl = "../Ajax/analysis-DetailScore-Game-Sch-Team.asp";
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
                    if (error != '') {
                        alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!" + ' [' + xhr + ']' + ' [' + status + ']' + ' [' + error + ']');
                    }
                }
            });

        }

        $("#show-score").modal('show');


    }

    function iFavLink(link1, playeridx) {
        var strAjaxUrl = "../Ajax/analysis-film-Mod.asp";
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
                if (error != '') {
                    alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!" + ' [' + xhr + ']' + ' [' + status + ']' + ' [' + error + ']');
                }
            }
        });
    }


</script>
<body>
  <!-- S: sub-header -->
  <div class="sd-header sd-header-sub">
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <h1>대회영상모음</h1>
    <!-- #include file="../include/sub_header_gnb.asp" -->
  </div>
  <!-- #include file = "../include/gnb.asp" -->
  <!-- E: sub-header -->

  <!-- S: sub -->
  <div class="sub">
    <!-- S: main stat-record -->
    <div id="match_final" class="main stat-record">

      <!-- E: 개인전 stat-film -->
    </div>
    <!-- E: main stat-record -->
  </div>
  <!-- E : sub -->

  <!-- S: footer -->
  <div class="footer">
    <!-- S: bottom-menu -->
    <!-- #include file="../include/bottom_menu.asp" -->
    <!-- E: bottom-menu -->
  </div>
  <!-- E: footer -->

  <!-- S: 영상보기 모달 modal -->

    <div class="modal fade film-modal" id="show-score" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="false">
    <div class="modal-backdrop fade in"></div>
      <div id="detailScore" style="display:block;">

      </div>
  </div>


  <div class="modal fade film-modal" id="" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="false"><div class="modal-backdrop fade in"></div>
  <!-- S: modal-dialog -->
  <div class="modal-dialog">
    <!-- S: modal-content -->
    <div class="modal-content">
      <div class="modal-header clearfix">
        <h3 class="center">상세 스코어</h3>
        <a href="#" data-dismiss="modal">&times;</a>
      </div>
      <!-- E: modal-content -->
      <!-- S: modal-body -->
      <div class="modal-body">
        <!-- S: pracice-score -->
         <div id="modal_score" class="pracice-score" style="width: 100%">
          <h4><span>한판승</span></h4>
            <!-- S: pop-point-display -->
            <div class="pop-point-display">
              <!-- S: display-board -->
              <div class="display-board clearfix">
                <!-- S: point-display -->
                <div class="point-display clearfix">
                  <ul class="point-title flex">
                    <li>선수</li>
                    <li>한판</li>
                    <li>절반</li>
                    <!-- <li>유효</li> -->
                    <li>지도</li>
                    <li>반칙/실격/<br>부전/기권 승</li>
                  </ul>
                  <ul class="player-1-point player-point flex">
                    <li>
                      <a onClick="#"><span class="disp-none"></span><span class="player-name" id="DP_Edit_LPlayer">홍길동</span>
                      <p class="player-school" id="">충남체육고</p></a>
                      <p class="vs">vs</p>
                    </li>
                    <li class="tgClass">
                     <a class="" onClick="#" name="a_jumsugb"><span class="score" id="LJumsuGb1">0</span></a>
                    </li>
                    <li class="tgClass">
                      <a class="" onClick="#" name="a_jumsugb"><span class="score" id="LJumsuGb2">0</span></a>
                    </li>
                    <!-- <li class="tgClass">
                      <a class="" onclick="#" name="a_jumsugb"><span class="score" id="LJumsuGb3">0</span></a>
                    </li> -->
                    <li class="tgClass">
                      <a class="" onClick="#" name="a_jumsugb"><span class="score txt-orange" id="LJumsuGb4">0</span></a>
                    </li>
                    <li>
                      <select class="select-win select-box" id="DP_R_GameResult">
                        <option value="">선택</option>
                        <option value="">반칙</option>
                        <option value="">실격</option>
                        <option value="">부전</option>
                        <option value="">기권</option>
                      </select>
                    </li>
                  </ul>
                  <ul class="player-2-point player-point flex">
                    <li>
                      <a onClick="#"><span class="disp-none"></span><span class="player-name" id="DP_Edit_RPlayer">이의준</span>
                      <p class="player-school" id="">서울명덕초</p></a>
                    </li>
                    <li class="tgClass">
                      <a class="" onClick="#" name="a_jumsugb"><span class="score" id="RJumsuGb1">0</span></a>
                    </li>
                    <li class="tgClass">
                      <a class="" onClick="#" name="a_jumsugb"><span class="score" id="RJumsuGb2">0</span></a>
                    </li>
                    <!-- <li class="tgClass">
                      <a class="" onclick="#" name="a_jumsugb"><span class="score" id="RJumsuGb3">0</span></a>
                    </li> -->
                    <li class="tgClass">
                      <a class="" onClick="#" name="a_jumsugb"><span class="score txt-orange" id="RJumsuGb4">0</span></a>
                    </li>
                    <li>
                      <select class="select-win select-box" id="DP_R_GameResult">
                        <option value="">선택</option>
                        <option value="">반칙</option>
                        <option value="">실격</option>
                        <option value="">부전</option>
                        <option value="">기권</option>
                      </select>
                    </li>
                  </ul>
                  <!-- E: point-display -->
                </div>
                <!-- E: point-display -->
                </div>
              <!-- E: display-board -->
            </div>
            <!-- E: pop-point-display -->
          </div>
          <!-- E: pracice-score -->
        </div>
        <!-- E: -->
        <!-- S: container -->
        <div class="container" >
          <!-- S: 기록보기 record-box -->
          <div  id="modal_container" class="record-box panel" style="display: block;">
            <h3>득실기록</h3>
            <ul class="plactice-txt">

            </ul>
          </div>
          <!-- E: 기록보기 record-box -->
          <!-- S: 영상보기 film-box -->
          <div class="film-box panel" id ="filmbox" style="display: none;">
            <iframe  width="100%" height="160" src="https://www.youtube.com/embed/CtVHss3U3WA" frameborder="0" allowfullscreen=""></iframe>
          </div>
          <!-- E: 영상보기 film-box -->
        </div>
        <!-- E: container -->
      </div>
      <!-- E: modal-body -->
      <!-- S: modal-footer -->
      <div class="modal-footer">
        <!-- S: btn-list -->
        <div class="btn-list flex">
          <button type="button" class="btn btn-orange btn-film" style="display: block;"><span class="ic-deco"><img src="http://img.sportsdiary.co.kr/sdapp/stats/film-icon@3x.png" alt=""></span>영상보기</button>
           <button type="button" class="btn btn-orange btn-record" style="display: none;">기록보기</button>
          <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
        </div>
        <!-- E: btn-list -->
    </div>
    <!-- E: modal-footer -->
  </div>
  <!-- E: modal-dialog -->
</div>
  <!-- E: 영상보기 모달 modal -->


  <script>

      //상세 스코어 보기
      function mod_Match_Proc(id_value, GAME_idx, GAME_NUM, movie_url) {
          //alert("  id_value  :" + id_value + " GAME_idx  : " + GAME_idx + "  GAME_NUM  : " + GAME_NUM + "  movie_url : " + movie_url + "");
          //데이터 조회 일괄 처리


          var id_name = id_value;

          $.ajax({
              url: "../select/match_diary_select.asp",
              type: 'POST',
              dataType: 'html',
              data: {
                  id: id_name,
                  Tryear: GAME_NUM,
                  GameTitleIDX: GAME_idx
              },
              success: function (retDATA) {
                  $("#" + id_name).html(retDATA);

                  id_name = "modal_container";
                  $.ajax({
                      url: "../select/match_diary_select.asp",
                      type: 'POST',
                      dataType: 'html',
                      data: {
                          id: id_name,
                          Tryear: GAME_NUM,
                          GameTitleIDX: GAME_idx
                      },
                      success: function (retDATA) {
                          $("#" + id_name).html(retDATA);
                      }, error: function (xhr, status, error) {
                          if (error != '') {
                              alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!" + ' [' + xhr + ']' + ' [' + status + ']' + ' [' + error + ']');
                          }
                      }
                  });
              }, error: function (xhr, status, error) {
                  if (error != '') {
                      alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!" + ' [' + xhr + ']' + ' [' + status + ']' + ' [' + error + ']');
                  }
              }
          });
          movie_url = "https://youtube.com/embed/qvVDtlS1lsc";
          if (movie_url=="") {
              $("#filmbox").html(" <iframe  width='100%' src='https://www.youtube.com/embed/CtVHss3U3WA' frameborder='0' allowfullscreen=''></iframe>");
          } else {
              $("#filmbox").html(" <iframe  width='100%'  src='" + movie_url + "' frameborder='0' allowfullscreen=''></iframe>");
          }

          $("#show-score").modal('show');
      }

      //팝업 닫을때 Youtube영상 없애기
      $('#show-score').on('hide.bs.modal', function (event) {
          //경기결과보기로 진입 시, 영상보기
          if (localStorage.getItem("IntroIndex") == "2") {
              $("#DP_GameVideo").html("");

              $("#DP_GameVideo").css("display", "none");
              $("#DP_Record").css("display", "");

              $("#btn_movie").css("display", "");
              $("#btn_log").css("display", "none");
          }
      });

  </script>




  <!-- S: bot-config -->
  <!-- #include file= "../include/bot_config.asp" -->
  <!-- E: bot-config -->
</body>
