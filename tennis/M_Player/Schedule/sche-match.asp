<!-- S: config -->
<!-- #include file="../include/config.asp" -->
<!-- E: config -->
<%
  check_login()
  IDX  = fInject(request("GameTitleIDX"))  '대회IDX
%>
<script type="text/javascript">
$(document).ready(function () {
    var GameTitleIDX_cookie = <%=IDX %>;

    if (GameTitleIDX_cookie!="") {
        document.cookie = "GameTitleIDX" + "=" + GameTitleIDX_cookie + "; path=/;";
    }

    $(".show-film").on({
        "click": function (e) {
            e.preventDefault();
            var url = "./match-movie.asp";
            $(location).attr('href', url);
        }
    });

     $.ajax({
            url: "sche-match_JSON.asp",
            type: 'POST',
            dataType: 'html',
            data: {
                GameTitleIDX: GameTitleIDX_cookie
                ,ID:"GameTitleIDX"
            },
            success: function (retDATA) {
                if (retDATA == "]") {
                     $(location).attr('href',"../MatchDiary/match-diary.asp");
                } else {
                    var retDATAobj = eval(retDATA);
                    $("#SearchDate").val(retDATAobj[0].GameS);
                    var datestring = "대회날짜 : "+retDATAobj[0].GameSYY+"년 "+retDATAobj[0].GameSMM+"월 "+retDATAobj[0].GameSDD+"일("+retDATAobj[0].GameSNM+")";
                    var Edatestring = ""

                    if (retDATAobj[0].GameSYY !=retDATAobj[0].GameEYY) {
                        Edatestring =" ~ " +retDATAobj[0].GameEYY+"년 "+retDATAobj[0].GameEMM+"월 "+retDATAobj[0].GameEDD+"일("+retDATAobj[0].GameENM+")"
                    }else {
                         if (retDATAobj[0].GameSMM !=retDATAobj[0].GameEMM) {
                            Edatestring =" ~ " +retDATAobj[0].GameEMM+"월 "+retDATAobj[0].GameEDD+"일("+retDATAobj[0].GameENM+")"
                        }else {
                            if (retDATAobj[0].GameSDD !=retDATAobj[0].GameEDD) {
                                Edatestring =" ~ "+retDATAobj[0].GameEDD+"일("+retDATAobj[0].GameENM+")"
                            }
                        }
                    }
                    $(".match").text(datestring+Edatestring);
                    $(".match-name").text("대회명 : "+retDATAobj[0].GameTitleName);
                    //$("#condition").text(retDATAobj[0].MentlNm);
                     //'대회성적
                    chage_search("condition",GameTitleIDX_cookie);
                    //'대회성적
                    chage_search("GameTitle",GameTitleIDX_cookie);
                    // 평가
                    chage_search("match-question",GameTitleIDX_cookie);
                    //메모리
                    chage_search("memory",GameTitleIDX_cookie);
                    }

            }, error: function (xhr, status, error) {
               	if (error!='') {
					alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!"+' ['+xhr+']'+' ['+status+']'+' ['+error+']');
				}
            }
        });

    //닫기
    $(".btn-left,.btn-back").on({
        "click": function (e) {
         var SeqSerch=$("#SeqSerch").val();
         SeqSerch++;
         $("#SeqSerch").val(SeqSerch);
         console.log(SeqSerch);
            e.preventDefault();
            console.log(document.referrer);
            if (document.referrer.indexOf("sportsdiary.co.kr") > 0 ){
                if (document.referrer.indexOf("match-diary.asp")> 0) {
                    if (SeqSerch<=1) {
                        //history.back(-1);
                        document.location.href = "../Result/institute-search.asp?GameTitleIDX="+GameTitleIDX_cookie+"&SearchDate="+$("#SearchDate").val();
                    }else {
                        //history.back(-1);
                        document.location.href = "../Main/index.asp";
                    }
                }else {
                     history.back(-1);
                }
            }
            else {document.location.href = "../Main/index.asp";}
        }
    });

    //수정
    $(".btn-right").on({
        "click": function (e) {
            e.preventDefault();
             //대회일지
            var tblSvcGameRerd = "";
            //대회평가
            var tblSvcGameAsmt = "";

            var GameTitleIDX = GameTitleIDX_cookie;

             var url = "../MatchDiary/match-diary.asp?GameTitleIDX=" + GameTitleIDX;
                $(location).attr('href', url);

       /*
            var MentlCd = $("#condition").val();

            if (MentlCd == 0) {
                alert("심리적상태를 선택하여 주시기 바랍니다.");
                document.getElementById("condition").focus();
                return false;
            }

            var AdtWell = $("#AdtWell").val();//.replace(/\n/g, '<br>');
            var AdtNotWell = $("#AdtNotWell").val();//.replace(/\n/g, '<br>');
            var AdtMyDiay = $("#AdtMyDiay").val();//.replace(/\n/g, '<br>');
            var AdtAdvice = $("#AdtAdvice").val();//.replace(/\n/g, '<br>');
            var AdtAdviceRe = $("#AdtAdviceRe").val();//.replace(/\n/g, '<br>');

            if (AdtWell == "") {
                AdtWell = "";
            }
            if (AdtNotWell == "") {
                AdtNotWell = "";
            }
            if (AdtMyDiay == "") {
                AdtMyDiay = "";
            }
            if (AdtAdvice == "") {
                AdtAdvice = "";
            }
            if (AdtAdviceRe=="") {
                AdtAdviceRe = "";
            }

            var AdtWellCkYn = "N";
            var AdtNotWellCkYn = "N";
            var AdtMyDiayCklYn = "N";
            var AdtAdviceCkYn = "N";
            var AdtAdviceReCkYn = "N";
            var memory_txt = document.getElementsByName("memory-txt");

            for (var i = 0; i < memory_txt.length; i++) {
                if (memory_txt[i].checked) {
                    switch (i) {
                        case 0:
                            AdtWellCkYn = "Y";
                            break;
                        case 1:
                            AdtNotWellCkYn = "Y";
                            break;
                        case 2:
                            AdtMyDiayCklYn = "Y";
                            break;
                        case 3:
                            AdtAdviceCkYn = "Y";
                            break;
                        case 4:
                            AdtAdviceReCkYn = "Y";
                            break;
                    }
                }
            }

            tblSvcGameRerd = "" + GameTitleIDX + "|" + MentlCd + "|" + AdtWell + "|" + AdtNotWell + "|" + AdtMyDiay + "|" + AdtAdvice + "|" + AdtAdviceRe + "|";
            tblSvcGameRerd = tblSvcGameRerd + AdtWellCkYn + "|" + AdtNotWellCkYn + "|" + AdtMyDiayCklYn + "|" + AdtAdviceCkYn + "|" + AdtAdviceReCkYn + "|";

            var question = "match-question";
            var question_name = "";
            var match_question = "";

            var j = "0001";
            for (var i = 1; i < 11; i++) {
                if (i < 10) {
                    j = "000" + i;
                } else {
                    j = "00" + i;
                }
                question_name = question + j;
                var chek = 0;

                for (var c = 0; c < document.getElementsByName(question_name).length; c++) {
                    if (document.getElementsByName(question_name)[c].checked) {
                        chek = document.getElementsByName(question_name)[c].value;
                        tblSvcGameAsmt = tblSvcGameAsmt + chek + "|";
                    }
                }

                if (chek <= 0) {
                    document.getElementById("match-question").focus();
                    alert(" " + i + "번째 훈련평가를 마무리 하여 주시기 바랍니다.");
                    return false;
                }
            }


             $.ajax({
                url: "../Ajax/match-diary_OK.asp",
                type: 'POST',
                dataType: 'html',
                data: {
                    tblSvcGameRerd: tblSvcGameRerd,
                    tblSvcGameAsmt: tblSvcGameAsmt
                },
                success: function (retDATA) {
                    if (retDATA) {
                        if (retDATA == "TRUE") {
                            alert("수정 되었습니다.");
                            //저장 성공 후 이동
                            history.back();
                        } else {
                            alert("오류-저장실패 다시 시도 하여 주시기 바랍니다.");
                        }
                    }
                }, error: function (xhr, status, error) {
                    alert("오류발생! - 시스템관리자에게 문의하십시오!");
                }
            });

             */
          }
    });



//end
});


function chage_search(id_value,GameTitleIDX) {
    //데이터 조회 일괄 처리
    var I_id = id_value;

    if (id_value=="match-question") {
        I_id=id_value+"-sch";
    }else if (id_value=="memory") {
        I_id=id_value+"-sch";
    }else {
        I_id= id_value;
    }
    console.log(I_id);

    $.ajax({
        url: "../select/match_diary_select.asp",
        type: 'POST',
        dataType: 'html',
        data: {
            id: I_id,
            Tryear:"",
            GameTitleIDX: GameTitleIDX
        },
        success: function (retDATA) {
            document.getElementById(id_value).innerHTML = retDATA
        }, error: function (xhr, status, error) {
               	if (error!='') {
					alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!"+' ['+xhr+']'+' ['+status+']'+' ['+error+']');
				}
            }
    });
}

function memoryChk(id_name, seq) {

    var on = "icon-on-favorite";
    var off = "icon-off-favorite";

    if ($("input:checkbox[id=" + id_name + "]").is(":checked")) {
        $("input:checkbox[id=" + id_name + "]").prop("checked", false);
        $("#" + id_name).parent().find('span').removeClass(on);
        $("#" + id_name).parent().find('span').addClass(off);
    } else {
        $("input:checkbox[id=" + id_name + "]").prop("checked", true);
        $("#" + id_name).parent().find('span').removeClass(off);
        $("#" + id_name).parent().find('span').addClass(on);
    }
}

function showfilmclick(p_idx,p_lev,p_grgb) {
    var url = "../MatchDiary/match-movie.asp?p_lev=" + p_lev;
    $(location).attr('href', url);

}

</script>
<body>

  <!-- S: sub-header -->
  <div class="sd-header sd-header-sub">
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <h1>대회일지</h1>
    <!-- #include file="../include/sub_header_gnb.asp" -->
  </div>
  <!-- #include file = "../include/gnb.asp" -->
  <!-- E: sub-header -->

  <!-- S: sub -->
  <div class="sub sche train">
    <h2 class="date match">대회기간 : </h2>
    <!-- S: match-info 대회명, 대회성정 -->
    <section class="match-info">
        <input type=hidden id ="SeqSerch" />
        <input type=hidden id ="SearchDate" />
      <h3 class="match-name sub-title">대회명 :</h3>
      <h3 class="match-result sub-title">대회성적</h3>
        <ul id="GameTitle" class="navyline-top-list"> </ul>

    </section>
    <!-- E: match-info 대회명, 대회성정 -->
    <!-- S: 기본정보 -->
    <section class="basic-info">
      <h3 class="sub-title">기본정보</h3>
      <ul>
        <li>
          <span class="title">컨디션 :
          <select id ="condition"></select></span>
          <!--<span id ="condition" class="txt">매우 좋음</span>-->
        </li>
      </ul>
    </section>
    <!-- E: 기본정보 -->
    <!-- S : 대회평가 -->
    <h2>대회평가</h2>
    <table id ="match-question" class="navy-top-table">
      <thead>
        <tr>
          <th rowspan="2">평가 내용</th>
          <th colspan="3">만족도</th>
        </tr>
        <tr>
          <th>상</th>
          <th>중</th>
          <th>하</th>
        </tr>
        <tbody>
          <tr>
            <td><label for="tranin-question01">1.컨디션(식사,수면,휴식)관리가 잘 되었나요?</label></td>
            <td><input type="radio" id="tranin-question01-1" name="tranin-question01" checked /></td>
            <td><input type="radio" id="tranin-question01-2" name="tranin-question01" /></td>
            <td><input type="radio" id="tranin-question01-3" name="tranin-question01" /></td>
          </tr>
          <tr>
            <td><label for="tranin-question02">2.상대선수를 파악/분석하고 경기에 임했나요?</label></td>
            <td><input type="radio" id="tranin-question02-1" name="tranin-question02" checked /></td>
            <td><input type="radio" id="tranin-question02-2" name="tranin-question02" /></td>
            <td><input type="radio" id="tranin-question02-3" name="tranin-question02" /></td>
          </tr>
          <tr>
            <td><label for="tranin-question03">3.경기 중 체력적인 한계를 느꼈나요?</label></td>
            <td><input type="radio" id="tranin-question03-1" name="tranin-question03" checked /></td>
            <td><input type="radio" id="tranin-question03-2" name="tranin-question03" /></td>
            <td><input type="radio" id="tranin-question03-3" name="tranin-question03" /></td>
          </tr>
          <tr>
            <td><label for="tranin-question04">4.훈련한대로 기술구사가 되었나요?</label></td>
            <td><input type="radio" id="tranin-question04-1" name="tranin-question04" checked /></td>
            <td><input type="radio" id="tranin-question04-2" name="tranin-question04" /></td>
            <td><input type="radio" id="tranin-question04-3" name="tranin-question04" /></td>
          </tr>
          <tr>
            <td><label for="tranin-question05">5.경기운영을 잘 했다고 생각하나요?</label></td>
            <td><input type="radio" id="tranin-question05-1" name="tranin-question05" checked /></td>
            <td><input type="radio" id="tranin-question05-2" name="tranin-question05" /></td>
            <td><input type="radio" id="tranin-question05-3" name="tranin-question05" /></td>
          </tr>
          <tr>
            <td><label for="tranin-question06">6.경기에 임할 때 자신감이 있었나요?</label></td>
            <td><input type="radio" id="tranin-question06-1" name="tranin-question06" checked /></td>
            <td><input type="radio" id="tranin-question06-2" name="tranin-question06" /></td>
            <td><input type="radio" id="tranin-question06-3" name="tranin-question06" /></td>
          </tr>
          <tr>
            <td><label for="tranin-question07">7.경기에 집중할 수 있는 환경이었나요?</label></td>
            <td><input type="radio" id="tranin-question07-1" name="tranin-question07" checked /></td>
            <td><input type="radio" id="tranin-question07-2" name="tranin-question07" /></td>
            <td><input type="radio" id="tranin-question07-3" name="tranin-question07" /></td>
          </tr>
          <tr>
            <td><label for="tranin-question08">8.후회없는 경기를 했나요?</label></td>
            <td><input type="radio" id="tranin-question08-1" name="tranin-question08" checked /></td>
            <td><input type="radio" id="tranin-question08-2" name="tranin-question08" /></td>
            <td><input type="radio" id="tranin-question08-3" name="tranin-question08" /></td>
          </tr>
          <tr>
            <td><label for="tranin-question09">9.경기내용과 결과에 만족하나요?</label></td>
            <td><input type="radio" id="tranin-question09-1" name="tranin-question09" checked /></td>
            <td><input type="radio" id="tranin-question09-2" name="tranin-question09" /></td>
            <td><input type="radio" id="tranin-question09-3" name="tranin-question09" /></td>
          </tr>
          <tr>
            <td><label for="tranin-question10">10.보다 나은 다음 경기를 위해 노력할건가요?</label></td>
            <td><input type="radio" id="tranin-question10-1" name="tranin-question10" checked /></td>
            <td><input type="radio" id="tranin-question10-2" name="tranin-question10" /></td>
            <td><input type="radio" id="tranin-question10-3" name="tranin-question10" /></td>
          </tr>
        </tbody>
      </thead>
    </table>
    <!-- E : 대회평가 -->
		<!-- S : 메모리 -->
    <ul id ="memory" class="memory">
      <li>
        <a href="#" class="sw-char">
        <span class="icon-off-favorite">★</span>
        <input type="checkbox" id="memory-txt01"  name ="memory-txt" value="1">
        <label for="memory-txt01">잘된점</label></a>
        <p><textarea id="memory-txt01" placeholder="잘된점을 입력하세요"></textarea></p>
      </li>
      <li>
        <a href="#" class="sw-char">
        <span class="icon-off-favorite">★</span>
        <input type="checkbox" id="memory-txt02"  name ="memory-txt" value="2" >
        <label for="memory-txt02">보완점</label></a>
        <p><textarea id="memory-txt02" placeholder="보완점을 입력하세요."></textarea></p>
      </li>
      <li>
        <a href="#" class="sw-char">
        <span class="icon-off-favorite">★</span>
        <input type="checkbox" id="memory-txt03"  name ="memory-txt"  value="3">
        <label for="memory-txt03">나의일기</label></a>
        <p><textarea id="memory-txt03" placeholder="나만의 일기를 작성해 보세요. (비공개)"></textarea></p>
      </li>
      <li>
        <a href="#" class="sw-char">
        <span class="icon-off-favorite">★</span>
        <input type="checkbox" id="memory-txt04"  name ="memory-txt"  value="4"><label for="memory-txt04">지도자상담</label></a>
        <p><textarea id="memory-txt04" placeholder="코치님 또는 감독님에게 하고 싶은 말을 입력하세요."></textarea></p>
      </li>
      <li>
        <a href="#" class="sw-char">
        <span class="icon-off-favorite">★</span>
        <input type="checkbox" id="memory-txt05"  name ="memory-txt" value="5" >
        <label for="memory-txt05">지도자답변</label></a>
        <p><textarea id="memory-txt05"></textarea></p>
      </li>
    </ul>
    <!-- E : 메모리 -->
    <div class="container btn-list train-btn clearfix">
      <a href="#" class="btn-left">닫기</a>
      <a href="#" class="btn-right">수정</a>
    </div>
  </div>
    <!-- S: 영상보기 모달 modal -->
  <div class="modal fade film-modal" id="show-score" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="false"><div class="modal-backdrop fade in"></div>
    <div class="modal-dialog">
      <div class="modal-content">
            <div class="modal-header clearfix">
              <h3 class="center">상세 스코어</h3>
              <a href="#" data-dismiss="modal"><img src="http://img.sportsdiary.co.kr/sdapp/stats/x@3x.png" alt="닫기"></a>
            </div>
            <div class="modal-body">
                <div class="pracice-score" style="width: 100%">
                    <!-- S: pop-point-display -->
            <div class="pop-point-display">
              <!-- S: display-board -->
              <div class="display-board clearfix">
                <!-- S: point-display -->
                     <div class="point-display clearfix">
                      <ul class="point-title flex">
                        <li>&nbsp;</li>
                        <li>한판</li>
                        <li>절반</li>
                        <li>유효</li>
                        <li>지도</li>
                        <li>반칙/실격/<br>부전/기권 승</li>
                      </ul>
                      <ul class="player-1-point player-point flex">
                        <li>
                          <a onClick="#"><span class="disp-win"></span><span class="player-name" id="DP_Edit_LPlayer">홍길동</span>
                          <p class="player-school" id="">충남체육고</p></a>
                        </li>
                        <li class="tgClass">
                          <a class="" onClick="#" name="a_jumsugb"><span class="score" id="LJumsuGb1">0</span></a>
                        </li>
                        <li class="tgClass">
                          <a class="" onClick="#" name="a_jumsugb"><span class="score" id="LJumsuGb2">0</span></a>
                        </li>
                        <li class="tgClass">
                          <a class="" onClick="#" name="a_jumsugb"><span class="score" id="LJumsuGb3">0</span></a>
                        </li>
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
                      <p class="vs">vs</p>
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
                        <li class="tgClass">
                          <a class="" onClick="#" name="a_jumsugb"><span class="score" id="RJumsuGb3">0</span></a>
                        </li>
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
        </div>
         <div class="container">
            <!-- S: 기록보기 record-box -->
            <div class="record-box panel" style="display: block;">
              <h3>득실기록</h3>
              <ul class="plactice-txt">
               <!-- <li class="pratice-txt-white">[2:13]홍길동: 절반(기타누으며 메치기)</li>
                <li class="pratice-txt-blue">[3:20]이의준: 지도(허리채기)</li>
                <li class="pratice-txt-blue">[3:20]이의준: 지도(허리채기)</li>
                <li class="pratice-txt-white">[2:13]홍길동: 절반(기타누으며 메치기)</li>
                <li class="pratice-txt-white">[2:13]홍길동: 절반(기타누으며 메치기)</li>
                <li class="pratice-txt-blue">[3:20]이의준: 지도(허리채기)</li>
                <li class="pratice-txt-white">[2:13]홍길동: 절반(기타누으며 메치기)</li>
                <li class="pratice-txt-blue">[3:20]이의준: 지도(허리채기)</li>
                <li class="pratice-txt-white">[2:13]홍길동: 절반(기타누으며 메치기)</li>-->
              </ul>
            </div>
            <!-- E: 기록보기 record-box -->
            <!-- S: 영상보기 film-box -->
            <div class="film-box panel" style="display: none;">
              <iframe width="100%" height="160" src="https://www.youtube.com/embed/CtVHss3U3WA" frameborder="0" allowfullscreen=""></iframe>
            </div>
            <!-- E: 영상보기 film-box -->
          </div>
            <div class="modal-footer">
              <div class="btn-list flex">
                <button type="button" class="btn btn-orange btn-film" style="display: block;">
                <span class="ic-deco"><img src="http://img.sportsdiary.co.kr/sdapp/stats/film-icon@3x.png" alt=""></span>영상보기</button>
                <button type="button" class="btn btn-orange btn-record" style="display: none;">기록보기</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
              </div>
            </div>
    </div>
    </div>
  </div>
  <!-- E: 영상보기 모달 modal -->
  <!-- E : sub -->

  <!-- S: footer -->
  <div class="footer">
    <!-- S: bottom-menu -->
    <!-- #include file="../include/bottom_menu.asp" -->
    <!-- E: bottom-menu -->
  </div>
  <!-- E: footer -->
  <!-- S: bot-config -->
  <!-- #include file= "../include/bot_config.asp" -->
  <!-- E: bot-config -->
</body>
