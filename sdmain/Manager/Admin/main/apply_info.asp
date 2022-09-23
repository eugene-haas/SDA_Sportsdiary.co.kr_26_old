<!-- S: head -->
<!-- #include file="../include/head1.asp" -->
<!-- E: head -->
<div class="content">
  <!-- S: left-gnb -->
  <!-- #include file="../include/left-gnb1.asp" -->
  <!-- E: left-gnb -->
  <!-- S: right-content -->
  <div class="right-content">
    <!-- S: navigation -->
    <div class="navigation">
      <i class="fas fa-home"></i>
      <i class="fas fa-chevron-right"></i>
      <span>대회신청관리</span>
      <i class="fas fa-chevron-right"></i>
      <span>신청취소자정보</span>
    </div>
    <!-- E: navigation -->
    <!-- S: pd-15 -->
    <div class="pd-30">
      <!-- S: sub-content -->
      <div class="sub-content">
        <!-- S: search-box -->
        <div class="box-shadow">
          <div class="search-box-1">
            <select name="" id="">
              <option value="">개인</option>
              <option value="">단체</option>
            </select>
            <select name="" id="">
              <option value="">전체</option>
              <option value="">입금전</option>
              <option value="">입금완료</option>
            </select>
            <select name="" id="">
              <option value="">선수명</option>
              <option value="">입금자명</option>
              <option value="">대회명</option>
            </select>
            <input type="text" placeholder="검색어 입력">
            <a href="#" class="navy-btn search-btn">검색</a>
          </div>
        </div>
        <!-- E: search-box -->
        <!-- S: apply_info -->
        <div class="apply_info">
          <!-- S: all-list-number -->
          <div class="all-list-number">
            <span class="l-txt">
              전체<span class="red-font font-bold">69</span>건
            </span>
          </div>
          <!-- E: all-list-number -->
          <!-- S: table-box -->
          <div class="table-box basic-table-box">
            <table cellspacing="0" cellpadding="0">
              <tr>
                <th>번호</th>
                <th>대회명</th>
                <th>부명</th>
                <th>개인/단체</th>
                <th>선수명</th>
                <th>입금자명</th>
                <th>입금금액</th>
                <th>입금상태</th>
                <th>환불신청정보</th>
                <th>환불날짜</th>
              </tr>
              <tr>
                <td>
                  <span>25</span>
                </td>
                <td>
                  <span>제1회 양양군수배 스포츠다이어리 랭킹 리그전</span>
                </td>
                <td>
                  <span>팀스프린트</span>
                </td>
                <td>
                  <span>단체</span>
                </td>
                <td>
                  <span>백승훈(남)</span>
                </td>
                <td>
                  <span>홍길동</span>
                </td>
                <td>
                  <span>30,000</span>
                </td>
                <td>
                  <span class="red-font">입금</span>
                </td>
                <td>
                  <a href="#" class="white-btn" data-toggle="modal" data-target="#refund_modal" data-backdrop="static" data-keyboard="false"
                  >정보확인</a>
                </td>
                <td>
                  <span>2018-02-23</span>
                </td>
              </tr>
              <tr>
                <td>
                  <span>25</span>
                </td>
                <td>
                  <span>제1회 양양군수배 스포츠다이어리 랭킹 리그전</span>
                </td>
                <td>
                  <span>팀스프린트</span>
                </td>
                <td>
                  <span>단체</span>
                </td>
                <td>
                  <span>백승훈(남)</span>
                </td>
                <td>
                  <span>홍길동</span>
                </td>
                <td>
                  <span>30,000</span>
                </td>
                <td>
                  <span>미입금</span>
                </td>
                <td>
                  <a href="#" class="white-btn" data-toggle="modal" data-target="#refund_modal" data-backdrop="static" data-keyboard="false"
                  >정보확인</a>
                </td>
                <td>
                  <span>2018-02-23</span>
                </td>
              </tr>
            </table>
          </div>
          <!-- E: table-box -->
          <!-- S: paging -->
          <div class="paging">
            <a href="#" class="icon-btn">
              <i class="fas fa-angle-double-left"></i>
            </a>
            <a href="#" class="icon-btn">
              <i class="fas fa-angle-left"></i>
            </a>
            <a href="#" class="active">
              <span>1</span>
            </a>
            <a href="#">
              <span>2</span>
            </a>
            <a href="#">
              <span>3</span>
            </a>
            <a href="#">
              <span>4</span>
            </a>
            <a href="#">
              <span>5</span>
            </a>
            <a href="#" class="icon-btn">
              <i class="fas fa-angle-right"></i>
            </a>
            <a href="#" class="icon-btn">
              <i class="fas fa-angle-double-right"></i>
            </a>
          </div>
          <!-- E: paging -->
        </div>
        <!-- E: apply_info -->
      </div>
      <!-- E: sub-content -->
    </div>
    <!-- E: pd-15 -->
  </div>
  <!-- E: right-content -->
</div>
<!-- S: 환불모달 -->
<!-- #include file="../include/modal/refund_modal.asp" -->
<!-- E: 환불모달 -->
<!-- S: footer -->
<!-- #include file="../include/footer.asp" -->
<!-- E: footer -->