<!--#include file="../../dev/dist/config.asp"-->
<!--#include file="../../include/head.asp"-->

<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->


<style>
  #left-navi{display:none;}
  #header{display:none;}
</style>
<script>
  var locationStr;
</script>
<!-- S: content -->
<div class="Game_operation">
  <h2 class="t_title">경기운영관리</h2>
  <!-- s: 대회선택 -->
  <div class="competition_select">
    <select>
      <option>::대회 선택::</option>
    </select>
  </div>
  <!-- e: 대회선택 -->
  <!-- s: 대진표/경기진행 순서/경기진행 결과/상품수령 관리 탭 -->
  <div class="tab">
    <ul>
      <li class="on">
         <a href="#">대진표</a>
      </li>
      <li>
        <a href="#">경기진행 순서</a>
      </li>
      <li>
        <a href="#">경기진행 결과</a>
      </li>
      <li>
        <a href="#">상품수령 관리</a>
      </li>
    </ul>
  </div>
  <!-- e: 대진표/경기진행 순서/경기진행 결과/상품수령 관리 탭 -->
  <!-- s: 연선 조 순위 결과 -->
  <div class="ranking_result">
    <label>
      <input type="radio" name="matchType" checked="checked">
      <span>개인전</span>
    </label>
    <label>
      <input type="radio" name="matchType">
      <span>단체전</span>
    </label>
    <select>
      <option>::부서 선택::</option>
    </select>
    <select>
      <option>::종목 선택::</option>
    </select>
    <select>
      <option>::종목 선택::</option>
    </select>
    <a href="javascript:popupOpen('ranking_result_popup.asp');" class="red_btn">예선 조순위 결과 <i class="fas fa-angle-right"></i></a>
  </div>
  <!-- e: 연선 조 순위 결과 -->
  <!-- s: 검색 -->
  <div class="search_box">
    <select>
      <option>::경기장소 선택::</option>
    </select>
    <select>
      <option>코트 선택</option>
    </select>
    <input type="text" placeholder="이름을 검색하세요">
    <a href="#" class="gray_btn">검색</a>
  </div>
  <!-- e: 검색 -->
  <!-- s: 태아불 상단 버튼 -->
  <div class="top_btn_list">
    <a href="#">
      <i class="fas fa-print"></i>
      <span>경기진행 순서 출력</span>
    </a>
    <a href="#">
      <i class="fas fa-print"></i>
      <span>경기기록지 출력</span>
    </a>
  </div>
  <!-- e: 태아불 상단 버튼 -->
  <!-- s: 리스트 table -->
  <table cellspacing="0" cellpadding="0">
    <tr>
      <th>경기번호</th>
      <th>코트번호</th>
      <th>단체전 오더등록</th>
      <th>종목</th>
      <th>대진표</th>
      <th colspan="2">팀1</th>
      <th colspan="2">팀2</th>
      <th>승패결과</th>
      <th>그외판정</th>
      <th>승자서명</th>
    </tr>
    <tr>
      <td>
        <span>1</span>
      </td>
      <td>
        <span>1</span>
      </td>
      <td>
        <a href="#" class="blue_btn" data-toggle="modal" data-target=".group-order">출전선수 오더</a>
      </td>
      <td>
        <span>혼합복식 40D</span>
      </td>
      <td>
        <span>예선7조</span>
      </td>
      <td>
        <span>강원</span>
      </td>
      <td>
        <span>최보라</span> / 
        <span>이준희</span>
      </td>
      <td>
        <span>부산</span>
      </td>
      <td>
        <span>홍원표</span>/ 
        <span>김정연</span>
      </td>
      <td>
        <a href="#" class="red_btn" data-toggle="modal" data-target=".live-score">경기중</a>
      </td>
      <td>
        <a href="#" class="red_btn" data-toggle="modal" data-target=".etc-judge">경기중</a>
      </td>
      <td>
        <a href="#" class="red_btn" data-toggle="modal" data-target=".winner-sign">경기중</a>
      </td>
    </tr>
    <tr>
      <td>
        <span>2</span>
      </td>
      <td>
        <span>2</span>
      </td>
      <td>
        <a href="#" class="blue_btn" data-toggle="modal" data-target=".group-order">출전선수 오더</a>
      </td>
      <td>
        <span>혼합복식 40D</span>
      </td>
      <td>
        <span>예선7조</span>
      </td>
      <td>
        <span>강원</span>
      </td>
      <td>
        <span>최보라</span> / 
        <span>이준희</span>
      </td>
      <td>
        <span>부산</span>
      </td>
      <td>
        <span>홍원표</span>/ 
        <span>김정연</span>
      </td>
      <td>
        <a href="#" class="gray_btn">선택</a>
      </td>
      <td>
        <a href="#" class="gray_btn">선택</a>
      </td>
      <td>
        <a href="#" class="gray_btn">선택</a>
      </td>
    </tr>
  </table>
  <!-- e: 리스트 table -->
  <script>
    function popupOpen(addrs, w, h){
      if (w === undefined)
        w = 1280;
      if (h === undefined)
        h = 747;
      var popWidth = w; // 팝업창 넓이
      var popHeight = h; // 팝업창 높이
      var winWidth = document.body.clientWidth; // 현재창 넓이
      var winHeight = document.body.clientHeight; // 현재창 높이
      var winX = window.screenX || window.screenLeft || 0; // 현재창의 x좌표
      var winY = window.screenY || window.screenTop || 0; // 현재창의 y좌표
      var popLeftPos = (winX + (winWidth - popWidth) / 2); // 팝업 x 가운데
      var popTopPos = (winY + (winHeight - popHeight) / 2)-100; // 팝업 y 가운데


      var popUrl = addrs; //팝업창에 출력될 페이지 URL
      var popOption = "left="+popLeftPos+", top="+popTopPos+", width="+popWidth+", height="+popHeight+", resizable=no, scrollbars=yes, status=no;";    //팝업창 옵션(optoin)
      window.open(popUrl,"",popOption);
    }
  </script>
</div>
<!-- E: content -->

<!-- S: group-order -->
<!-- #include file = "../../include/modal/group.order.asp" -->
<!-- E: group-order -->

<!-- S: live-score -->
<!-- #include file = "../../include/modal/live.score.asp" -->
<!-- E: live-score -->

<!-- S: etc-judge -->
<!-- #include file = "../../include/modal/etc.judge.asp" -->
<!-- E: etc-judge -->

<!-- S: winner-sign -->
<!-- #include file = "../../include/modal/winner.sign.asp" -->
<!-- E: winner-sign -->

<!--#include file="../../include/footer.asp"-->

<script>
  $(".group-order").modal();
</script>

<%
  DBClose()
%>