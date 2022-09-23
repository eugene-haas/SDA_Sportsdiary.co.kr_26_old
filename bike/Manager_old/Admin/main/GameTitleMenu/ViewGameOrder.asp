<!--#include file="../../dev/dist/config.asp"-->
<!--#include file="../../include/head.asp"-->

<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->
<script src="../../dev/dist/Common_Js.js"></script>
 <script src="../../js/GameNumber/ViewGameOrder.js"></script>
<style>
  #left-navi{display:none;}
  #header{display:none;}
</style>
<!-- S: content -->
<div class="SetGameOrder">
  <h2 class="t_title">경기운영관리</h2>
  <!-- s: 검색 -->
  <div class="search_box">
		<input type="text">
    <select>
      <option>코트</option>
    </select>
    <select>
      <option>대회명</option>
    </select>
    <input type="text" placeholder="경기번호 입력">
    <a href="#" class="gray_btn">검색</a>
  </div>
			<a href="javascript:setGameNumber();"  class="btn btn-red">진행순서 설정</a>
  <!-- e: 검색 -->
	<div class="list_table">
		<!-- s: 리스트 table -->
		<table cellspacing="0" cellpadding="0">
			<tr>
				<th rowspan="2">게임번호</th>
				<th rowspan="2">예약시간</th>
				<th rowspan="2">코트</th>
				<th rowspan="2">종목</th>
				<th rowspan="2">대진표</th>
				<th colspan="2">팀1</th>
				<th colspan="2">팀2</th>
			</tr>
			<tr>
				<th>소속</th>
				<th>선수명</th>
				<th>소속</th>
				<th>선수명</th>
			</tr>
			<tr>
				<td>
					<span>1</span>
				</td>
				<td>
					<span>08:00</span>
				</td>
				<td>
					<select name="" id="">
						<option value="">1코트</option>
					</select>
				</td>
				<td>
					<span>부자-60-일반1</span>
				</td>
				<td>
					<span>예선11조</span>
				</td>
				<td>
					<span>대구</span>
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
			</tr>
			<tr>
				<td>
					<span>1</span>
				</td>
				<td>
					<span>08:00</span>
				</td>
				<td>
					<select name="" id="">
						<option value="">1코트</option>
					</select>
				</td>
				<td>
					<span>부자-60-일반1</span>
				</td>
				<td>
					<span>예선11조</span>
				</td>
				<td>
					<span>대구</span>
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
			</tr>
		</table>
		<!-- e: 리스트 table -->
	</div>
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
  //$(".group-order").modal();
</script>

<%
  DBClose()
%>