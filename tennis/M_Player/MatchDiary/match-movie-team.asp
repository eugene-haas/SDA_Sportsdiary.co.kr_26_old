<!-- S: config -->
<!-- #include file="../include/config.asp" -->
<!-- E: config -->
<script type="text/javascript">
    //데회 번호 <쿠키:GameTitleIDX >
    //조회

    var GameTitleIDX_cookie = "";
    if (getCookie("GameTitleIDX") != "") {
        GameTitleIDX_cookie = getCookie("GameTitleIDX");
    } else {
        history.back();
    }

    $(document).ready(function () {
        //데이터 조회 일괄 처리
        $.ajax({
            url: "../select/match_diary_select.asp",
            type: 'POST',
            dataType: 'html',
            data: {
                id: "match_final_team",
                Tryear: "sd040002",
                GameTitleIDX: GameTitleIDX_cookie
            },
            success: function (retDATA) {
                document.getElementById("match_final_team").innerHTML = retDATA;
                $("#match_final_team").iconFavo("#match_final_team");
            }, error: function (xhr, status, error) {
                if (error != '') {
                    alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!" + ' [' + xhr + ']' + ' [' + status + ']' + ' [' + error + ']');
                }
            }
        });

    });

    function iMovieLink(link1, link2, playeridx) {
        console.log(link1); console.log(link2); console.log(playeridx);
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
                    if (retDATA) {
                        //alert(retDATA);
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
    <div  id="match_final_team" class="main stat-record">
      <!-- S: 단체전 stat-film -->

      <!-- E: 단체전 stat-film -->
    </div>
    <!-- E: main stat-record -->
  </div>
  <!-- E : sub -->

  <!-- S: 단체전 영상보기 모달 modal -->
  <div class="modal fade round-res in groups-res" id="groupround-res" tabindex="-1" role="dialog" aria-labelledby="modal-title" aria-hidden="false"><div class="modal-backdrop fade in"></div>
    <div class="modal-dialog" id="detailScore_Team">

    </div>
    <!-- modal-dialog -->
  </div>
  <!-- E: 단체전 영상보기 모달 modal -->

  <!-- S: footer -->
  <div class="footer">
    <!-- S: bottom-menu -->
    <!-- #include file="../include/bottom_menu.asp" -->
    <!-- E: bottom-menu -->
  </div>
  <!-- E: footer -->

  <!-- S: 영상보기 모달 modal -->
  <!-- #include file="../include/modal/film_modal.asp" -->
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


          //영상 전달
          //판정 전달



          $("#show-score").modal('show');
      }


  </script>


  <!-- S: bot-config -->
  <!-- #include file= "../include/bot_config.asp" -->
  <!-- E: bot-config -->
</body>
