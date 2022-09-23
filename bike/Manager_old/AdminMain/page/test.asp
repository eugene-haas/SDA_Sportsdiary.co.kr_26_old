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
      <span>환경설정</span>
      <i class="fas fa-chevron-right"></i>
      <span>기본환경설정</span>
    </div>
    <!-- E: navigation -->
    <!-- S: pd-15 -->
    <div class="pd-30">
      <!-- S: sub-content -->
      <div class="sub-content">
        <!-- S: basic_setting -->
        <div class="basic_setting">
          <div role="tabpanel">
            <!-- Nav tabs -->
            <ul class="nav nav-tabs" role="tablist">
              <li role="presentation" class="active"><a href="#tab1" aria-controls="tab1" role="tab" data-toggle="tab">기본환경</a></li>
              <li role="presentation"><a href="#tab2" aria-controls="tab2" role="tab" data-toggle="tab">게시판기본</a></li>
              <li role="presentation"><a href="#tab4" aria-controls="tab4" role="tab" data-toggle="tab">기본메일환경</a></li>
              <li role="presentation"><a href="#tab5" aria-controls="tab5" role="tab" data-toggle="tab">글작성메일</a></li>
              <li role="presentation"><a href="#tab6" aria-controls="tab6" role="tab" data-toggle="tab">가입메일</a></li>
              <li role="presentation"><a href="#tab7" aria-controls="tab7" role="tab" data-toggle="tab">투표메일</a></li>
              <li role="presentation"><a href="#tab8" aria-controls="tab8" role="tab" data-toggle="tab">SNS</a></li>
              <li role="presentation"><a href="#tab10" aria-controls="tab10" role="tab" data-toggle="tab">SMS</a></li>
            </ul>
            <!-- Tab panes -->
            <div class="tab-content">
              <!-- S: 기본환경 -->
              <div role="tabpanel" class="tab-pane tab-1 active" id="tab1">
                <!-- S: box-shadow -->
                <div class="box-shadow">
                  <!-- S: seting-list -->
                  <div class="seting-list">
                    <ul>
                      <li>
                        <span class="l-name">
                          <span class="middle-box">홈페이지 제목</span>
                        </span>
                        <span class="r-con">
                          <span class="middle-box">
                            <input type="text" value="영카트5">
                          </span>
                        </span>
                      </li>
                      <li>
                        <span class="l-name">
                          <span class="middle-box">
                            최고관리자
                          </span>
                        </span>
                        <span class="r-con">
                          <span class="middle-box">
                            <select name="" id="">
                              <option value="">선택안함</option>
                            </select>
                          </span>
                        </span>
                      </li>
                      <li>
                        <span class="l-name">
                          <span class="middle-box">
                            관리자 메일 주소
                          </span>
                        </span>
                        <span class="r-con">
                          <span class="middle-box">
                            <p class="p-ment">관리자가 보내고 받는 용도로 사용하는 메일 주소를 입력합니다. (회원가입, 인증메일, 테스트, 회원메일발송 등에서 사용)</p>
                            <input type="text" value="admin@naver.com">
                          </span>
                        </span>
                      </li>
                      <li>
                        <span class="l-name">
                          <span class="middle-box">
                            관리자 메일 발송이름
                          </span>
                        </span>
                        <span class="r-con">
                          <span class="middle-box">
                            <p class="p-ment">관리자가 보내고 받는 용도로 사용하는 메일의 발송이름을 입력합니다. (회원가입, 인증메일, 테스트, 회원메일발송 등에서 사용)</p>
                            <input type="text" value="영카트5데모">
                          </span>
                        </span>
                      </li>
                      <li>
                        <span class="l-name">
                          <span class="middle-box">
                            포인트 사용
                          </span>
                        </span>
                        <span class="r-con">
                          <span class="middle-box">
                            <label for="checbox-1">
                              <input type="checkbox" id="checbox-1" class="checkbox">
                              <span class="txt">사용</span>
                            </label>
                          </span>
                        </span>
                      </li>
                      <li>
                        <span class="l-name">
                          <span class="middle-box">
                            로그인시 포인트
                          </span>
                        </span>
                        <span class="r-con">
                          <span class="middle-box">
                            <p class="p-ment">회원이 로그인시 하루에 한번만 적립</p>
                            <p class="p-bottom">
                              <input type="text" value="100">
                              <span class="txt">점</span>
                            </p>
                          </span>
                        </span>
                      </li>
                      <li>
                        <span class="l-name">
                          <span class="middle-box">
                            쪽지보낼시 차감 포인트
                          </span>
                        </span>
                        <span class="r-con">
                          <span class="middle-box">
                            <p class="p-ment">양수로 입력하십시오. 0점은 쪽지 보낼시 포인트를 차감하지 않습니다.</p>
                            <p class="p-bottom">
                              <input type="text" value="500">
                              <span class="txt">점</span>
                            </p>
                          </span>
                        </span>
                      </li>
                      <li>
                        <span class="l-name">
                          <span class="middle-box">
                            이름(닉네임) 표시
                          </span>
                        </span>
                        <span class="r-con">
                          <span class="middle-box">
                            <p class="p-bottom">
                              <input type="text" value="15">
                              <span class="txt">자리만 표시</span>
                            </p>
                          </span>
                        </span>
                      </li>
                      <li>
                        <span class="l-name">
                          <span class="middle-box">
                            닉네임 수정
                          </span>
                        </span>
                        <span class="r-con">
                          <span class="middle-box">
                            <p class="p-bottom">
                              <span class="txt">수정하면</span>
                              <input type="text" value="60">
                              <span class="txt">일 동안 바꿀 수 없음</span>
                            </p>
                          </span>
                        </span>
                      </li>
                      <li>
                        <span class="l-name">
                          <span class="middle-box">
                            정보공개 수정
                          </span>
                        </span>
                        <span class="r-con">
                          <span class="middle-box">
                            <p class="p-bottom">
                              <span class="txt">수정하면</span>
                              <input type="text" value="0">
                              <span class="txt">일 동안 바꿀 수 없음</span>
                            </p>
                          </span>
                        </span>
                      </li>
                      <li>
                        <span class="l-name">
                          <span class="middle-box">
                            정보공개 수정
                          </span>
                        </span>
                        <span class="r-con">
                          <span class="middle-box">
                            <p class="p-bottom">
                              <span class="txt">수정하면</span>
                              <input type="text" value="0">
                              <span class="txt">일 동안 바꿀 수 없음</span>
                            </p>
                          </span>
                        </span>
                      </li>
                      <li>
                        <span class="l-name">
                          <span class="middle-box">
                            최근게시물 삭제
                          </span>
                        </span>
                        <span class="r-con">
                          <span class="middle-box">
                            <p class="p-bottom">
                              <input type="text" value="30">
                              <span class="txt">일</span>
                            </p>
                          </span>
                        </span>
                      </li>
                      <li>
                        <span class="l-name">
                          <span class="middle-box">
                            쪽지 삭제
                          </span>
                        </span>
                        <span class="r-con">
                          <span class="middle-box">
                            <p class="p-bottom">
                              <span class="txt">수정하면</span>
                              <input type="text" value="180">
                              <span class="txt">일</span>
                            </p>
                          </span>
                        </span>
                      </li>
                      <li>
                        <span class="l-name">
                          <span class="middle-box">
                            접속자로그 삭제
                          </span>
                        </span>
                        <span class="r-con">
                          <span class="middle-box">
                            <p class="p-bottom">
                              <span class="txt">설정일이 지난 접속자 로그 자동 삭제</span>
                              <input type="text" value="180">
                              <span class="txt">일</span>
                            </p>
                          </span>
                        </span>
                      </li>
                      <li>
                        <span class="l-name">
                          <span class="middle-box">
                            인기검색어 삭제
                          </span>
                        </span>
                        <span class="r-con">
                          <span class="middle-box">
                            <p class="p-bottom">
                              <span class="txt">설정일이 지난 인기검색어 자동 삭제</span>
                              <input type="text" value="180">
                              <span class="txt">일</span>
                            </p>
                          </span>
                        </span>
                      </li>
                      <li>
                        <span class="l-name">
                          <span class="middle-box">
                            현재 접속자
                          </span>
                        </span>
                        <span class="r-con">
                          <span class="middle-box">
                            <p class="p-bottom">
                              <span class="txt">설정값 이내의 접속자를 현재 접속자로 인정</span>
                              <input type="text" value="10">
                              <span class="txt">분</span>
                            </p>
                          </span>
                        </span>
                      </li>
                      <li>
                        <span class="l-name">
                          <span class="middle-box">
                            최근게시물 라인수
                          </span>
                        </span>
                        <span class="r-con">
                          <span class="middle-box">
                            <p class="p-bottom">
                              <span class="txt">목록 한페이지당 라인수</span>
                              <input type="text" value="15">
                              <span class="txt">라인</span>
                            </p>
                          </span>
                        </span>
                      </li>
                      <li>
                        <span class="l-name">
                          <span class="middle-box">
                            한페이지당 라인수
                          </span>
                        </span>
                        <span class="r-con">
                          <span class="middle-box">
                            <p class="p-bottom">
                              <span class="txt">목록(리스트) 한페이지당 라인수</span>
                              <input type="text" value="15">
                              <span class="txt">라인</span>
                            </p>
                          </span>
                        </span>
                      </li>
                      <li>
                        <span class="l-name">
                          <span class="middle-box">
                            모바일 한페이지당 라인수
                          </span>
                        </span>
                        <span class="r-con">
                          <span class="middle-box">
                            <p class="p-bottom">
                              <span class="txt">모바일 목록 한페이지당 라인수</span>
                              <input type="text" value="15">
                              <span class="txt">라인</span>
                            </p>
                          </span>
                        </span>
                      </li>
                      <li>
                        <span class="l-name">
                          <span class="middle-box">
                            페이지 표시 수
                          </span>
                        </span>
                        <span class="r-con">
                          <span class="middle-box">
                            <p class="p-bottom">
                              <input type="text" value="10">
                              <span class="txt">페이지씩 표시</span>
                            </p>
                          </span>
                        </span>
                      </li>
                    </ul>
                  </div>
                  <!-- E: seting-list -->
                </div>
                <!-- E: box-shadow -->
              </div>
              <!-- E: 기본환경 -->
              <!-- S: 게시판기본 -->
              <div role="tabpanel" class="tab-pane tab-2" id="tab2">
                <!-- S: box-shadow -->
                <div class="box-shadow">
                  게시판기본
                </div>
                <!-- E: box-shadow -->
              </div>
              <!-- E: 게시판기본 -->
              <!-- S: 기본메일환경 -->
              <div role="tabpanel" class="tab-pane tab-4" id="tab4">
                <!-- S: box-shadow -->
                <div class="box-shadow">
                    기본메일환경
                </div>
                <!-- E: box-shadow -->
              </div>
              <!-- E: 기본메일환경 -->
              <!-- S: 글작성메일 -->
              <div role="tabpanel" class="tab-pane tab-5" id="tab5">
                <!-- S: box-shadow -->
                <div class="box-shadow">
                    글작성메일
                </div>
                <!-- E: box-shadow -->
              </div>
              <!-- E: 글작성메일 -->
              <!-- S: 가입메일 -->
              <div role="tabpanel" class="tab-pane tab-6" id="tab6">
                <!-- S: box-shadow -->
                <div class="box-shadow">
                    가입메일
                </div>
                <!-- E: box-shadow -->
              </div>
              <!-- E: 가입메일 -->
              <!-- S: 투표메일 -->
              <div role="tabpanel" class="tab-pane tab-7" id="tab7">
                <!-- S: box-shadow -->
                <div class="box-shadow">
                    투표메일
                </div>
                <!-- E: box-shadow -->
              </div>
              <!-- E: 투표메일 -->
              <!-- S: SNS -->
              <div role="tabpanel" class="tab-pane tab-8" id="tab8">
                <!-- S: box-shadow -->
                <div class="box-shadow">
                    SNS
                </div>
                <!-- E: box-shadow -->
              </div>
              <!-- E: SNS -->
              <!-- S: SMS -->
              <div role="tabpanel" class="tab-pane tab-10" id="tab10">
                <!-- S: box-shadow -->
                <div class="box-shadow">
                    SMS
                </div>
                <!-- E: box-shadow -->
              </div>
              <!-- E: SMS -->
            </div>
          </div>
        </div>
        <!-- E: basic_setting -->
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