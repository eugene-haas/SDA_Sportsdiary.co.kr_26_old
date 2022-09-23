<!-- #include virtual ='/tennis/manager/include/top_config.asp' -->
  <title>스포츠다이어리 테니스 관리자</title>
<!-- #include virtual = '/tennis/manager/include/bot_config.asp' -->
</head>
<body>
  <!-- S: header -->
  <!-- #include virtual ='/tennis/manager/include/header.asp' -->
  <!-- E: header -->

  <!-- S: container -->
  <div id="container" class="clearfix">
    <!-- S: navi left-navi 네비게이션 -->
    <!-- #include virtual = '/tennis/manager/include/nav.asp' -->
    <!-- E: navi left-navi 네비게이션 -->

    <!-- S: content -->
    <div id="content">
      <!-- S: 네비게이션 -->
      <div class="navigation_box">
        <strong>관리자 메인</strong>
      </div>
      <!-- E: 네비게이션 -->
      <!-- S: top-navi -->
      <div class="top-navi">

      <!-- S: search_top -->
      <div class="search_top">
        <!-- S: search_box -->
        <div class="search_box">
          <select name="selSearch" id="selSearch" class="title_select">
            <option >대회명</option>
          </select>
          <input type="text" id="txtSearch" name="txtSearch" class="title_input in_2">
          <a href="#" id="btnselSearch" name="btnselSearch" class="btn_skyblue">검색</a>
        </div>
        <!-- E: top-navi-inner -->
      </div>
      <!-- E: search_top -->

      <!-- S: table-list -->
      <table class="table-list">
        <colgroup>
          <col width="3%">
          <col width="12%">
          <col width="12%">
          <col width="31%">
          <col width="5%">
          <col width="22%">
        </colgroup>
        <thead>
          <tr>
            <th>년도</th>
            <th>대회기간</th>
            <th>주최</th>
            <th>대회명</th>
            <th>지역</th>
            <th>장소</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td><a href="#">5</a></td>
            <td>2017-09-09~2017-09-09 </td>
            <td>서울특별시유도회</td>
            <td>제1회 서울특별시 생활체육 유도연맹 최강전 유도대회</td>
            <td>서울</td>
            <td>KBS스포츠월드 제2체육관</td>
          </tr>
          <tr>
            <td><a href="#">4</a></td>
            <td>2017-09-20~2017-09-22</td>
            <td>한국대학유도연맹</td>
            <td>2017 추계대학유도연맹전</td>
            <td>전북</td>
            <td>순창실내체육관</td>
          </tr>
          <tr>
            <td><a href="#">3</a></td>
            <td>2017-07-18~2017-07-20</td>
            <td>대한유도회</td>
            <td>2017 교보생명컵 꿈나무 유도대회</td>
            <td>경북</td>
            <td>김천실내체육관</td>
          </tr>
          <tr>
            <td><a href="#">2</a></td>
            <td>2017-07-12~2017-07-14</td>
            <td>한국대학유도연맹</td>
            <td>2017 하계대학유도연맹전</td>
            <td>강원</td>
            <td>강원, 인제실내체육관</td>
          </tr>
          <tr>
            <td><a href="#">1</a></td>
            <td>2017-08-17~2017-08-20</td>
            <td>한국초중고등학교유도연맹</td>
            <td>2017 추계 전국 남.여 초중고등학교 유도연맹전</td>
            <td>강원</td>
            <td>동해체육관</td>
          </tr>
        </tbody>
      </table>
      <!-- E: table-list -->

      <!-- S: 더보기 -->
      <!-- <a href="javascript:view_frm('N');" class="btn-more-list"><span>더보기</span><i class="fa fa-caret-down" aria-hidden="true"></i></a> -->
      <!-- E: 더보기 -->

      <!-- S: pagination -->
      <ul class="pagination">
        <li class="prev">
          <a href="#"><i class="fa fa-angle-left"></i></a>
        </li>
        <li class="active">
          <a href="#">1</a>
        </li>
        <li class="next">
          <a href="#"><i class="fa fa-angle-right"></i></a>
        </li>
      </ul>
      <!-- E: pagination -->

      <!-- S: btn_list right -->
      <div class="btn_list right">
        <a href="/tennis/manager/Admin/Admin_Write.asp">관리자 등록</a>
      </div>
      <!-- E: btn_list right -->
      </div>
      <!-- E: top-navi -->
    </div>
    <!-- E: content -->
  </div>
  <!-- E: container -->
</body>
</html>