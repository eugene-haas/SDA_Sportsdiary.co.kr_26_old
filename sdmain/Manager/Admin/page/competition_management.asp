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
      <span>대회관리</span>
      <i class="fas fa-chevron-right"></i>
      <span>대회정보관리</span>
    </div>
    <!-- E: navigation -->
    <!-- S: pd-15 -->
    <div class="pd-30">
      <!-- S: sub-content -->
      <div class="sub-content">
        <!-- S: search-box -->
        <div class="box-shadow">
          <div class="search-box">
            <ul>
              <li>
                <span class="l-title">그룹/종목</span>
                <span class="r-con">
                  <select name="" id="">
                    <option value="">대분류</option>
                  </select>
                </span>
              </li>
              <li>
                <span class="l-title">대회명</span>
                <span class="r-con">
                  <input type="text" placeholder="대회명을 입력해 주세요.">
                </span>
              </li>
              <li>
                <span class="l-title">대회유형</span>
                <span class="r-con">
                  <select name="" id="">
                    <option value="">== 선택 ==</option>
                  </select>
                </span>
              </li>
              <li>
                <span class="l-title">장소(지역)</span>
                <span class="r-con">
                  <input type="text" placeholder="주소">
                </span>
              </li>
              <li>
                <span class="l-title">경기장명</span>
                <span class="r-con">
                  <input type="text" placeholder="경기장명을 입력해 주세요.">
                </span>
              </li>
            </ul>
            <ul>
              <li>
                <span class="l-title">대회일자</span>
                <span class="r-con">
                  <input type="text" placeholder="시작일" class="in-data">
                  <span class="s-txt">~</span>
                  <input type="text" placeholder="종료일" class="in-data">
                </span>
              </li>
              <li>
                <span class="l-title">신청기간</span>
                <span class="r-con">
                  <input type="text" placeholder="시작일" class="in-data">
                  <span class="s-txt">~</span>
                  <input type="text" placeholder="종료일" class="in-data">
                </span>
              </li>
              <li>
                <span class="l-title">대회주최</span>
                <span class="r-con">
                  <select name="" id="">
                    <option value="">= 대회주최 =</option>
                  </select>
                </span>
              </li>
            </ul>
          </div>
        </div>
        <!-- E: search-box -->
        <!-- S: competition_management -->
        <div class="competition_management">
          <!-- S: t-btn-box -->
          <div class="t-btn-box">
            <a href="#" class="navy-btn">등록(I)</a>
            <a href="#" class="navy-btn">수정(E)</a>
            <a href="#" class="white-btn">삭제(R)</a>
          </div>
          <!-- E: t-btn-box -->
          <!-- S: table-box -->
          <div class="table-box basic-table-box">
            <table cellspacing="0" cellpadding="0">
              <tr>
                <th>번호</th>
                <th>기간</th>
                <th>지역</th>
                <th>대회명</th>
                <th>참가신청/달력/대진표</th>
                <th>대회요강</th>
                <th>대회부목록</th>
              </tr>
              <tr>
                <td>
                  <span>25</span>
                </td>
                <td>
                  <span>2018.07.01 ~ 2018.07.02</span>
                </td>
                <td>
                  <span>서울</span>
                </td>
                <td class="text-left">
                  <span>제1회 양양군수배 스포츠다이어리 랭킹 리그전</span>
                </td>
                <td>
                  <div class="toggle toggle-sm">
                    <input type="checkbox" id="small" name="small-setting" checked/>
                    <label for="small">small</label>
                  </div>
                  <div class="toggle toggle-sm">
                    <input type="checkbox" id="small1" name="small-setting" checked/>
                    <label for="small1">small</label>
                  </div>
                  <div class="toggle toggle-sm">
                    <input type="checkbox" id="small2" name="small-setting" checked/>
                    <label for="small2">small</label>
                  </div>
                </td>
                <td>
                  <a href="#" class="white-btn" data-toggle="modal" data-target="#refund_modal" data-backdrop="static"  data-keyboard="false">부(경기유형)관리</a>
                </td>
                <td>
                  <a href="#" class="white-btn">대회요강</a>
                </td>
              </tr>
              <tr>
                <td>
                  <span>25</span>
                </td>
                <td>
                  <span>2018.07.01 ~ 2018.07.02</span>
                </td>
                <td>
                  <span>서울</span>
                </td>
                <td class="text-left">
                  <span>제1회 양양군수배 스포츠다이어리 랭킹 리그전</span>
                </td>
                <td>
                  <div class="toggle toggle-sm">
                    <input type="checkbox" id="small3" name="small-setting" checked/>
                    <label for="small3">small</label>
                  </div>
                  <div class="toggle toggle-sm">
                    <input type="checkbox" id="small4" name="small-setting" checked/>
                    <label for="small4">small</label>
                  </div>
                  <div class="toggle toggle-sm">
                    <input type="checkbox" id="small5" name="small-setting" checked/>
                    <label for="small5">small</label>
                  </div>
                </td>
                <td>
                  <a href="#" class="white-btn" data-toggle="modal" data-target="#refund_modal" data-backdrop="static"  data-keyboard="false">부(경기유형)관리</a>
                </td>
                <td>
                  <a href="#" class="white-btn">대회요강</a>
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
        <!-- #include file="../include/modal/refund_modal.asp" -->
        <!-- E: competition_management -->
      </div>
      <!-- E: sub-content -->
    </div>
    <!-- E: pd-15 -->
  </div>
  <!-- E: right-content -->
</div>
<!-- S: footer -->
<!-- #include file="../include/footer.asp" -->
<!-- E: footer -->