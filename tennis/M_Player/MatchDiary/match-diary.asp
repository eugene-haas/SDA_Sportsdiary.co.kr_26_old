<!-- S: config -->
<!-- #include file="../include/config.asp" -->
<!-- E: config -->
<%
    PlayerReln      =  decode(Request.Cookies("PlayerReln"),0)
    check_login()

 %>
<script type="text/javascript">
    var PlayerReln = "<%=PlayerReln %>";
    var subTopCate = 1;
</script>
<script  type="text/javascript" src="../js/match-diary.js"></script>
<body>
  <!-- S: sub-header -->
  <div class="sd-header sd-header-sub">
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <h1>대회일지</h1>
    <!-- #include file="../include/sub_header_gnb.asp" -->
  </div>
  <!-- #include file = "../include/gnb.asp" -->
  <!-- E: sub-header -->


<form name="frm" id="frmSave" method="post">
    <input type="hidden" name="Match_status" id="Match_status">
    <input type="hidden" name="F1_Mentcd" id="F1_Mentcd" >
    <input type="hidden" name="F1_Questionlist" id="F1_Questionlist" >
    <input type="hidden" name="F1_AdtWell"id="F1_AdtWell">
    <input type="hidden" name="F1_AdtNotWell"id="F1_AdtNotWell">
    <input type="hidden" name="F1_AdtMyDiay"id="F1_AdtMyDiay">
    <input type="hidden" name="F1_AdtAdvice"id="F1_AdtAdvice">
</form>
  <!-- E: sub-header -->
  <!-- S: sub -->
  <div class="sub match">
    <div class="top-icon-menu">
         <%
        '회원구분에 따른 메뉴 include
        SELECT CASE decode(request.Cookies("PlayerReln"), 0)
          CASE "D"
          %>
          <!-- S: include top-menu -->
          <!-- #include file = '../include/sub_topmenu/monoType/topmenu.asp' -->
          <!-- E: include top-menu -->
          <%
          CASE "A", "B", "Z"
          %>
          <!-- S: include parents-type 보호자 회원 menu -->
          <!-- #include file = '../include/sub_topmenu/parentsType/topmenu.asp' -->
          <!-- E: include parents-type 보호자 회원 menu -->
          <%
          CASE ELSE
          %>
          <!-- S: include player-type 선수 회원 menu-->
          <!-- 엘리트, 국가대표, 생활체육 선수 -->
          <!-- #include file = '../include/sub_topmenu/playerType/topmenu.asp' -->
          <!-- E: include player-type 선수 회원 menu-->

          <%
        END SELECt
      %>
      <p>이번 대회에서의 <span>경기 총평을 기록</span>하고</br> 다음 대회를 준비해 보세요.</p>
    </div>
    <!-- S: calendar-header -->
    <div class="calendar-header schedule-list container">
      <!-- S: line-1 -->
      <div class="line-1 clearfix">
        <div class="select-list clearfix">
          <button class="prev-btn" type="button">&lt;</button>
          <!-- <select name="" id class="year">
            <option value="">2016년</option>
            <option value="">2017년</option>
            <option value="">2018년</option>
          </select> -->
          <span class="year">2017년</span>
          <input id="year" type="hidden" numberonly="true"  value=2017 />
          <button class="next-btn" type="button">&gt;</button>
        </div>
      </div>
      <!-- E: line-1 -->
      <!-- S: line-2 -->
      <div class="line-2">
        <select id="GameTitleIDX">
          <option value="" selected>:: 대회명을 선택하세요 ::</option>
          <option value="40">2016 회장기 전국 유도대회</option>
          <option value="41">2016 추계 전국 남,여 중고등학교 유도연맹전</option>
          <option value="20">2016 추계 전국 남,여 대학교 유도연</option>
        </select>
      </div>
      <!-- E: line-2 -->
    </div>
    <!-- E: calendar-header -->
    <h2>대회성적</h2>
    <ul id="GameTitle" class="navyline-top-list">
      <!-- 개인, 단체전에서 좋은 성적을 몇 개 노출. 현재페이지에서만 메달노출, 상세페이지엔 메달x -->
    </ul>
    <!-- S : 컨디션 -->
    <h2>컨디션</h2>
    <div class="navyline-top-list">
      <label for="condition">심리적상태</label>
      <select id="condition">
        <option>심리적상태</option>
        <option>매우좋음</option>
        <option>좋음</option>
        <option>보통</option>
        <option>나쁨</option>
        <option>매우나쁨</option>
      </select>
    </div>
    <!-- E : 컨디션 -->
    <!-- S : 대회평가 -->
    <h2>대회평가</h2>
    <table id="match-question"  class="navy-top-table">
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
            <td><label for="match-question01">1.컨디션(식사,수면,휴식)관리가 잘 되었나요?</label></td>
            <td><input type="radio" id="match-question01-1" name="match-question01" checked /></td>
            <td><input type="radio" id="match-question01-2" name="match-question01" /></td>
            <td><input type="radio" id="match-question01-3" name="match-question01" /></td>
          </tr>
          <tr>
            <td><label for="match-question02">2.상대선수를 파악/분석하고 경기에 임했나요?</label></td>
            <td><input type="radio" id="match-question02-1" name="match-question02" checked /></td>
            <td><input type="radio" id="match-question02-2" name="match-question02" /></td>
            <td><input type="radio" id="match-question02-3" name="match-question02" /></td>
          </tr>
          <tr>
            <td><label for="match-question03">3.경기 중 체력적인 한계를 느꼈나요?</label></td>
            <td><input type="radio" id="match-question03-1" name="match-question03" checked /></td>
            <td><input type="radio" id="match-question03-2" name="match-question03" /></td>
            <td><input type="radio" id="match-question03-3" name="match-question03" /></td>
          </tr>
          <tr>
            <td><label for="match-question04">4.훈련한대로 기술구사가 되었나요?</label></td>
            <td><input type="radio" id="match-question04-1" name="match-question04" checked /></td>
            <td><input type="radio" id="match-question04-2" name="match-question04" /></td>
            <td><input type="radio" id="match-question04-3" name="match-question04" /></td>
          </tr>
          <tr>
            <td><label for="match-question05">5.경기운영을 잘 했다고 생각하나요?</label></td>
            <td><input type="radio" id="match-question05-1" name="match-question05" checked /></td>
            <td><input type="radio" id="match-question05-2" name="match-question05" /></td>
            <td><input type="radio" id="match-question05-3" name="match-question05" /></td>
          </tr>
          <tr>
            <td><label for="match-question06">6.경기에 임할 때 자신감이 있었나요?</label></td>
            <td><input type="radio" id="match-question06-1" name="match-question06" checked /></td>
            <td><input type="radio" id="match-question06-2" name="match-question06" /></td>
            <td><input type="radio" id="match-question06-3" name="match-question06" /></td>
          </tr>
          <tr>
            <td><label for="match-question07">7.경기에 집중할 수 있는 환경이었나요?</label></td>
            <td><input type="radio" id="match-question07-1" name="match-question07" checked /></td>
            <td><input type="radio" id="match-question07-2" name="match-question07" /></td>
            <td><input type="radio" id="match-question07-3" name="match-question07" /></td>
          </tr>
          <tr>
            <td><label for="match-question08">8.후회없는 경기를 했나요?</label></td>
            <td><input type="radio" id="match-question08-1" name="match-question08" checked /></td>
            <td><input type="radio" id="match-question08-2" name="match-question08" /></td>
            <td><input type="radio" id="match-question08-3" name="match-question08" /></td>
          </tr>
          <tr>
            <td><label for="match-question09">9.경기내용과 결과에 만족하나요?</label></td>
            <td><input type="radio" id="match-question09-1" name="match-question09" checked /></td>
            <td><input type="radio" id="match-question09-2" name="match-question09" /></td>
            <td><input type="radio" id="match-question09-3" name="match-question09" /></td>
          </tr>
          <tr>
            <td><label for="match-question10">10.보다 나은 다음 경기를 위해 노력할건가요?</label></td>
            <td><input type="radio" id="match-question10-1" name="match-question10" checked /></td>
            <td><input type="radio" id="match-question10-2" name="match-question10" /></td>
            <td><input type="radio" id="match-question10-3" name="match-question10" /></td>
          </tr>
        </tbody>
      </thead>
    </table>
    <!-- E : 대회평가 -->
    <!-- S : 메모리 -->
    <h2>메모리</h2>
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
    <%if PlayerReln="A" OR PlayerReln="B" OR PlayerReln="Z" THEN %>
    <%ELSE %>
    <!-- E : 메모리 -->
    <div class="container btnfull">
      <a  class="btn-full" id="Match_save">저장</a>
    </div>
     <%END IF %>
  </div>
  <!-- E : sub -->
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

  <script>
    /**
   * 훈련일지, 대회일지, 체력측정 top-icon-menu 인덱싱
   */
    function subMenuCate(menu, cateIdx){
      var $menu = null; // top-icon-menu
      var $menuImg = null; // 메뉴 이미지
      var $menuLi = null; // 메뉴 li
      var menuImgSrc = []; // 메뉴 이미지 src

      if (cateIdx == undefined) {
        return;
      }

      function _init(menu){
        $menu = $(menu);
        $menuImg = $('img', $menu);
        $menuLi = $('li', $menu);
        $menuImg.each(function(){
          menuImgSrc.push($(this).context.src)
        });
      }

      function _evt(cateIdx){
        var onImg;
        var onIdx;
        for (var i in menuImgSrc) {
          onImg = menuImgSrc[i].match('_on');
          onIdx = i;
          break;
        }
        var findOnImg = onImg.input.replace('_on', '_off');
        _solveOnImg(onIdx, findOnImg);
        _chkOnImg(cateIdx);
      }

      function _chkOnImg(cateIdx){
        var onSrc = menuImgSrc[cateIdx].replace('_off','_on');
        $menuLi.eq(cateIdx).find('img').attr('src', onSrc);
      }

      function _solveOnImg(idx, findOnImg) {
        $menuLi.eq(idx).find('img').attr('src', findOnImg);
      }

      _init(menu);
      _evt(cateIdx)
    }

    subMenuCate('.top-icon-menu', subTopCate); // top-icon-menu 인덱싱
  </script>
</body>
