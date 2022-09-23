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
        <strong>관리자 관리</strong> > 관리자리스트
      </div>
      <!-- E: 네비게이션 -->
      <!-- S: top-navi -->
      <div class="top-navi">
        <!-- S: top-navi-inner -->
        <div class="top-navi-inner sticky">
        <!-- S : top-navi-tp 접혔을 때-->
        <div class="top-navi-tp">
          <h3 class="top-navi-tit">
            <strong>관리자리스트</strong>
          </h3>
          <a href="#frm" id="input_button_type" class="btn-top-sdr close" title="닫기"></a>
        </div>
        <!--입력폼 S-->
        <form name="frm" id="frm" class="col-tg" method="post">
        <!-- S: top-navi-btm 종목-->
        <div class="top-navi-btm" id="input_area">
          <!-- S: navi-tp-table-wrap -->
          <div class="navi-tp-table-wrap">
            <table class="navi-tp-table">
              <tbody><tr>
                <td>종목</td>
                <td>
                  <select name="SportsGb" id="SportsGb">
                    <option value="">=선택=</option>
                    <option value="judo">유도</option>
                    <option value="wres">레슬링</option>
                  </select>
                </td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
              </tr>
              <tr>
                <td>관리자아이디</td>
                <td>
                  <input type="text" name="UserID" id="UserID" class="input-small">
                  <a href="#" class="btn" onclick="chk_id()">중복확인</a>
                </td>
                <td>관리자 비밀번호</td>
                <td><input type="password" name="UserPass" id="UserPass" class="input-small"></td>
                <td>관리자 비밀번호 확인</td>
                <td><input type="password" name="UserPass_Re" id="UserPass_Re" class="input-small"><a href="#" class="btn">초기화</a>
                </td>
              </tr>
              <tr>
                <td>관리자명</td>
                <td><input type="text" name="UserName" id="UserName" class="input-small"></td>
                <td>관리자구분</td>
                <td>
                  <select name="UserGubun" id="UserGubun">
                    <option value="ad001001">관리자</option>
                    <option value="ad001002">부관리자</option>
                    <option value="ad001004">한국중고등학교유도연맹</option>
                    <option value="ad001005">한국대학유도연맹</option>
                    <option value="ad001006">한국실업유도연맹</option>
                    <option value="ad001003">대한유도회</option>
                    <option value="ad001007">서울특별시유도회</option>
                  </select>
                </td>
                <td>협회구분</td>
                <td>
                  <select name="HostCode" id="HostCode">
                    <option value="">==미선택==</option>
                    <option value="sd053001">대한유도회</option>
                    <option value="sd053002">한국초중고등학교유도연맹</option>
                    <option value="sd053003">한국대학유도연맹</option>
                    <option value="sd053004">한국실업유도연맹</option>
                    <option value="sd053005">대한체육회</option>
                    <option value="sd053006">서울특별시유도회</option>
                    <option value="sd053007">위드라인</option>
                  </select>
                </td>
                </tr>
                <tr>
                  <td>관리자연락처</td>
                  <td><input type="text" name="HandPhone" id="HandPhone" class="input-small"></td>
                  <td>관리자협회명</td>
                  <td><input type="text" name="Company" id="Company" class="input-small"></td>
                  <td>사용여부</td>
                  <td>
                    <select name="DelYN" id="DelYN">
                      <option value="">==선택==</option>
                      <option value="N">사용중</option>
                      <option value="Y">사용안함</option>
                    </select>
                  </td>
                </tr>
              </tbody>
            </table>
            </div>
            <!-- E: navi-tp-table-wrap -->
          </div>
          <!-- E: top-navi-btm -->
          <!-- S : btn-right-list 버튼 -->
          <div class="btn-right-list">
            <a href="#" id="btnsave" class="btn" onclick="input_frm();" accesskey="i">등록(I)</a>
            <a href="#" id="btnupdate" class="btn" onclick="update_frm();" accesskey="e">수정(E)</a>
            <a href="#" id="btndel" class="btn btn-delete" onclick="del_frm();" accesskey="r">삭제(R)</a>
            <!--<a href="#" class="btn">목록보기</a>-->
          </div>
          <!-- E : btn-right-list 버튼 -->
        </form>
        <!-- E : top-navi-btm 펼쳤을 때 보이는 부분 -->
      </div>

      <!-- S: search_top -->
      <div class="search_top">
        <!-- S: search_box -->
        <div class="search_box">
          <select name="selSearch" id="selSearch" class="title_select">
            <option value="N">성명</option>
            <option value="I">ID</option>
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
          <col width="5%">
          <col width="15%">
          <col width="15%">
          <col width="25%">
          <col width="20%">
          <col width="20%">
        </colgroup>
        <thead>
          <tr>
            <th>순번</th>
            <th>ID</th>
            <th>성명</th>
            <th>작성일</th>
            <th>사용유무</th>
            <th>어드민권한</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td><a href="#">5</a></td>
            <td>a21991663</td>
            <td>이광철</td>
            <td>2017-08-21</td>
            <td>사용중</td>
            <td>어드민</td>
          </tr>
          <tr>
            <td><a href="#">4</a></td>
            <td>ssong</td>
            <td>쏭근호</td>
            <td>2017-08-16</td>
            <td>사용중</td>
            <td>어드민</td>
          </tr>
          <tr>
            <td><a href="#">3</a></td>
            <td>juniya</td>
            <td>주니야</td>
            <td>2017-08-10</td>
            <td>미사용</td>
            <td>어드민</td>
          </tr>
          <tr>
            <td><a href="#">2</a></td>
            <td>junida</td>
            <td>주니다</td>
            <td>2017-08-10</td>
            <td>사용중</td>
            <td>어드민</td>
          </tr>
          <tr>
            <td><a href="#">1</a></td>
            <td>admin</td>
            <td>관리자</td>
            <td>2017-08-10</td>
            <td>사용중</td>
            <td>최고 관리자</td>
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