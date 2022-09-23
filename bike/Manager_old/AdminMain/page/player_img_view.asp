<!-- S: head -->
<!-- #include file="../include/head.asp" -->
<!-- E: head -->
<div class="content">
  <!-- S: left-gnb -->
  <!-- #include file="../include/left-gnb.asp" -->
  <!-- E: left-gnb -->
  <!-- S: right-content -->
  <div class="right-content">
    <!-- S: navigation -->
    <div class="navigation">
      <i class="fas fa-home"></i>
      <i class="fas fa-chevron-right"></i>
      <span>게시물관리</span>
      <i class="fas fa-chevron-right"></i>
      <span>대회이미지</span>
      <i class="fas fa-chevron-right"></i>
      <span>상세보기</span>
    </div>
    <!-- E: navigation -->
    <!-- S: pd-15 -->
    <div class="pd-30">
      <!-- S: sub-content -->
      <div class="sub-content">
        
        <!-- S: player_video_view -->
        <div class="player_video_view">
          <!-- S: box-shadow -->
          <div class="box-shadow">
            <!-- S: table-box -->
            <div class="table-box basic-view">
              <table cellspacing="0" cellpadding="0">
                <tr>
                  <th>대회선택</th>
                  <td>
                    <select name="" id="">
                      <option value="">2018</option>
                    </select>
                    <select name="" id="">
                      <option value="">대회선택</option>
                    </select>
                  </td>
                </tr>
                <tr>
                  <th>종목선택</th>
                  <td>
                    <select name="" id="">
                      <option value="">종목선택</option>
                    </select>
                  </td>
                </tr>
                <tr>
                  <th>제목</th>
                  <td>
                    <input type="text" placeholder="제목을 입력하세요" class="in-style-1">
                  </td>
                </tr>
                <tr>
                  <th>워터마크 포함</th>
                  <td>
                    <select name="" id="">
                      <option value="">워터마크</option>
                    </select>
                  </td>
                </tr>
                <tr>
                  <th>작성일</th>
                  <td>
                    <span>2018-08-20</span>
                  </td>
                </tr>
                <tr>
                  <th>조회수</th>
                  <td>
                    <span>20</span>
                  </td>
                </tr>
                <tr>
                  <th>이미지-1</th>
                  <td>
                    <label class="lable-img">
                      <img src="http://tennisadmin.sportsdiary.co.kr/ADImgR/tennis/banner_md6.png" class="list-thumbnail" alt="">
                      <input type="checkbox" class="in-check">
                    </lable>
                    <!-- <a href="#" class="delete-btn gray-btn">삭제</a> -->
                  </td>
                </tr>
                <tr>
                  <th>이미지-2</th>
                  <td>
                    <label class="lable-img">
                      <img src="http://tennisadmin.sportsdiary.co.kr/ADImgR/tennis/banner_md6.png" class="list-thumbnail" alt="">
                      <input type="checkbox" class="in-check">
                    </lable>
                  </td>
                </tr>
              </table>
              <!-- S: 선택삭제 -->
              <div class="delet-btn">
                <a href="#" class="black-btn">선택삭제</a>
              </div>
              <!-- E: 선택삭제 -->
              <div></div>
            </div>
            <!-- E: table-box -->
          </div>
          <!-- E: box-shadow -->
          <!-- S: bt-btn-box -->
          <div class="bt-btn-box txt-right">
            <a href="player_video.asp" class="white-btn">목록</a>
            <a href="#" class="white-btn">취소</a>
            <a href="#" class="gray-btn">삭제</a>
          </div>
          <!-- E: bt-btn-box -->
        </div>
        <!-- E: player_video_view -->
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