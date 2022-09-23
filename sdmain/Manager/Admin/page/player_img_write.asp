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
      <span>게시물관리</span>
      <i class="fas fa-chevron-right"></i>
      <span>대회이미지</span>
      <i class="fas fa-chevron-right"></i>
      <span>등록</span>
    </div>
    <!-- E: navigation -->
    <!-- S: pd-15 -->
    <div class="pd-30">
      <!-- S: sub-content -->
      <div class="sub-content">
        
        <!-- S: player_video_write -->
        <div class="player_video_write">
          <!-- S: box-shadow -->
          <div class="box-shadow">
            <!-- S: table-box -->
            <div class="table-box basic-write">
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
                  <th>이미지등록 640px~</th>
                  <td>
                    <input type="file" class="in-file" multiple>
                    <a href="#" class="icon-btn">
                      <i class="fas fa-plus-circle"></i>
                    </a>
                  </td>
                </tr>
              </table>
            </div>
            <!-- E: table-box -->
          </div>
          <!-- E: box-shadow -->
          <!-- S: bt-btn-box -->
          <div class="bt-btn-box txt-right">
            <a href="player_video.asp" class="white-btn">취소</a>
            <a href="player_video.asp" class="blue-btn">등록</a>
          </div>
          <!-- E: bt-btn-box -->
        </div>
        <!-- E: player_video_write -->
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