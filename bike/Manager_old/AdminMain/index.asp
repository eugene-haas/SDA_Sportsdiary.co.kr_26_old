<!-- S: head -->
<!-- #include file="include/head.asp" -->
<!-- E: head -->
<div class="content">
  <!-- S: left-gnb -->
  <!-- #include file="include/left-gnb.asp" -->
  <!-- E: left-gnb -->
  <!-- S: right-content -->
  <div class="right-content">
    <!-- S: navigation -->
    <div class="navigation">
      <i class="fas fa-home"></i>
      <i class="fas fa-chevron-right"></i>
      <span>메뉴1</span>
      <i class="fas fa-chevron-right"></i>
      <span>서브메뉴1</span>
    </div>
    <!-- E: navigation -->
    <!-- S: pd-15 -->
    <div class="pd-30">
      <!-- S: main -->
      <div class="main">
        <!-- S: main-line-one -->
        <div class="main-line-one">
          <!-- S: chart-1 -->
        <div class="chart-1">
          <h4 class="h-title">07월 요일별 통계</h4>
          <div class="box-shadow">
            <canvas id="myChart"></canvas>
            <script>
              var ctx = document.getElementById("myChart");
              var myChart = new Chart(ctx, {
                  type: 'bar',
                  data: {
                      labels: ["월", "화", "수", "목", "금", "토", "일"],
                      datasets: [{
                          label: '# 방문자수',
                          data: [1, 3,4, 7, 12, 33, 3],
                          backgroundColor: [
                              'rgba(255, 99, 132, 0.2)',
                              'rgba(54, 162, 235, 0.2)',
                              'rgba(255, 206, 86, 0.2)',
                              'rgba(75, 192, 192, 0.2)',
                              'rgba(153, 102, 255, 0.2)',
                              'rgba(255, 159, 64, 0.2)',
                              'rgba(53, 129, 154, 0.2)',
                          ],
                          borderColor: [
                              'rgba(255,99,132,1)',
                              'rgba(54, 162, 235, 1)',
                              'rgba(255, 206, 86, 1)',
                              'rgba(75, 192, 192, 1)',
                              'rgba(153, 102, 255, 1)',
                              'rgba(255, 159, 64, 1)',
                              'rgba(53, 129, 154, 1)',
                          ],
                          borderWidth: 1
                      }]
                  },
                  options: {
                      scales: {
                          yAxes: [{
                              ticks: {
                                  beginAtZero:true
                              }
                          }]
                      }
                  }
              });
              </script>
            </div>
          </div>
          <!-- E: chart-1 -->
          <!-- S: chart-2 -->
          <div class="chart-2">
            <h4 class="h-title">타이틀이 들어갑니다</h4>
            <div class="box-shadow">
              <canvas id="myBarChart"></canvas>
              <script>
                var ctx = document.getElementById("myBarChart");
                var myBarChart = new Chart(ctx, {
                  type: 'pie',
                  data: {
                      labels: ["pink", "yello", "blue"],
                      datasets: [{
                          label: '# of Votes',
                          data: [3, 2, 1],
                          backgroundColor: [
                              '#ff6384',
                              '#ffcd56',
                              '#36a2eb'
                          ],
                          borderWidth: 1
                      }]
                  },
                  options: {
                      scales: {
                          yAxes: [{
                              ticks: {
                                  beginAtZero:true
                              }
                          }]
                      }
                  }
              });
              </script>
            </div>
          </div>
          <!-- E: chart-2 -->
        </div>
        <!-- E: main-line-one -->
        <!-- S: main-line-tow -->
        <div class="main-line-tow">
          <h4 class="h-title">타이틀이 들어갑니다</h4>
          <!-- S: chart-3 -->
          <div class="chart-3">
            <div class="chart-list">
              <ul>
                <li class="chart1 box-shadow" data-percent="13">
                  <p class="p-title">전체 방문자</p>
                  <div class="middle">
                    <span>13</span>
                  </div>
                </li>
                <li class="chart2 box-shadow" data-percent="73">
                  <p class="p-title">전체 회원</p>
                  <div class="middle">
                    <span>73</span>
                  </div>
                </li>
                <li class="chart3 box-shadow" data-percent="56">
                  <p class="p-title">전체 게시물</p>
                  <div class="middle">
                    <span>56</span>
                  </div>
                </li>
                <li class="chart4 box-shadow" data-percent="23">
                  <p class="p-title">전체 포인트 발생내역</p>
                  <div class="middle">
                    <span>23</span>
                  </div>
                </li>
              </ul>
            </div>
            <script>
              $(function() {
                $('.chart1').easyPieChart({
                    //your options goes here
                    barColor:'#30a5ff',
                    size:130,
                });
                $('.chart2').easyPieChart({
                    //your options goes here
                    barColor:'#ffb53e',
                    size:130,
                });
                $('.chart3').easyPieChart({
                    //your options goes here
                    barColor:'#1ebfae',
                    size:130,
                });
                $('.chart4').easyPieChart({
                    //your options goes here
                    barColor:'#ef4040',
                    size:130,
                });
              });
            </script>
        </div>
        <!-- E: chart-3 -->
        </div>
        <!-- E: main-line-tow -->
        <!-- S: main-line-three -->
        <div class="main-line-three">
          <h4 class="h-title">신규가입회원 5건 목록</h4>
          <!-- S: new-user-list -->
          <div class="new-user-list">
            <div class="box-shadow">
              <table cellspacing="0" cellpadding="0">
                <tr>
                  <th>회원아이디</th>
                  <th>이름</th>
                  <th class="dis-none">닉네임</th>
                  <th class="dis-none">권한</th>
                  <th class="dis-none">포인트</th>
                  <th class="dis-none">수신</th>
                  <th class="dis-none">공개</th>
                  <th class="dis-none">인증</th>
                  <th class="dis-none">차단</th>
                  <th>그룹</th>
                </tr>
                <tr>
                  <td>
                    <span>administory</span>
                  </td>
                  <td>
                    <span>홍길동</span>
                  </td>
                  <td class="dis-none">
                    <span>홍길동</span>
                  </td>
                  <td class="dis-none">
                    <span>2</span>
                  </td>
                  <td class="dis-none">
                    <span>10,000</span>
                  </td>
                  <td class="dis-none">
                    <span>예</span>
                  </td>
                  <td class="dis-none">
                    <span>예</span>
                  </td>
                  <td class="dis-none">
                    <span>예</span>
                  </td>
                  <td class="dis-none">
                    <span>아니오</span>
                  </td>
                  <td>
                    <span>없음</span>
                  </td>
                </tr>
                <tr>
                  <td>
                    <span>administory</span>
                  </td>
                  <td>
                    <span>홍길동</span>
                  </td>
                  <td class="dis-none">
                    <span>홍길동</span>
                  </td>
                  <td class="dis-none">
                    <span>2</span>
                  </td>
                  <td class="dis-none">
                    <span>10,000</span>
                  </td>
                  <td class="dis-none">
                    <span>예</span>
                  </td>
                  <td class="dis-none">
                    <span>예</span>
                  </td>
                  <td class="dis-none">
                    <span>예</span>
                  </td>
                  <td class="dis-none">
                    <span>아니오</span>
                  </td>
                  <td>
                    <span>없음</span>
                  </td>
                </tr>
                <tr>
                  <td>
                    <span>administory</span>
                  </td>
                  <td>
                    <span>홍길동</span>
                  </td>
                  <td class="dis-none">
                    <span>홍길동</span>
                  </td>
                  <td class="dis-none">
                    <span>2</span>
                  </td>
                  <td class="dis-none">
                    <span>10,000</span>
                  </td>
                  <td class="dis-none">
                    <span>예</span>
                  </td>
                  <td class="dis-none">
                    <span>예</span>
                  </td>
                  <td class="dis-none">
                    <span>예</span>
                  </td>
                  <td class="dis-none">
                    <span>아니오</span>
                  </td>
                  <td>
                    <span>없음</span>
                  </td>
                </tr>
                <tr>
                  <td>
                    <span>administory</span>
                  </td>
                  <td>
                    <span>홍길동</span>
                  </td>
                  <td class="dis-none">
                    <span>홍길동</span>
                  </td>
                  <td class="dis-none">
                    <span>2</span>
                  </td>
                  <td class="dis-none">
                    <span>10,000</span>
                  </td>
                  <td class="dis-none">
                    <span>예</span>
                  </td>
                  <td class="dis-none">
                    <span>예</span>
                  </td>
                  <td class="dis-none">
                    <span>예</span>
                  </td>
                  <td class="dis-none">
                    <span>아니오</span>
                  </td>
                  <td>
                    <span>없음</span>
                  </td>
                </tr>
                <tr>
                  <td>
                    <span>administory</span>
                  </td>
                  <td>
                    <span>홍길동</span>
                  </td>
                  <td class="dis-none">
                    <span>홍길동</span>
                  </td>
                  <td class="dis-none">
                    <span>2</span>
                  </td>
                  <td class="dis-none">
                    <span>10,000</span>
                  </td>
                  <td class="dis-none">
                    <span>예</span>
                  </td>
                  <td class="dis-none">
                    <span>예</span>
                  </td>
                  <td class="dis-none">
                    <span>예</span>
                  </td>
                  <td class="dis-none">
                    <span>아니오</span>
                  </td>
                  <td>
                    <span>없음</span>
                  </td>
                </tr>
              </table>
            </div>
          </div>
          <!-- E: new-user-list -->
        </div>
        <!-- E: main-line-three -->
        <!-- S: main-line-four -->
        <div class="main-line-four">
          <h4 class="h-title">최근 포인트 발생내역</h4>
          <!-- S: new-user-list -->
          <div class="new-user-list">
            <div class="box-shadow">
              <table cellspacing="0" cellpadding="0">
                <tr>
                  <th>회원아이디</th>
                  <th class="dis-none">이름</th>
                  <th class="dis-none">닉네임</th>
                  <th>일시</th>
                  <th class="dis-none">포인트 내용</th>
                  <th>포인트</th>
                  <th class="dis-none">포인트합</th>
                </tr>
                <tr>
                  <td>
                    <span>administory</span>
                  </td>
                  <td class="dis-none">
                    <span>홍길동</span>
                  </td>
                  <td class="dis-none">
                    <span>홍길동</span>
                  </td>
                  <td>
                    <span>2017-07-26 00:15:49</span>
                  </td>
                  <td class="dis-none">
                    <span>회원가입 축하</span>
                  </td>
                  <td>
                    <span>1,000</span>
                  </td>
                  <td class="dis-none">
                    <span>20,000</span>
                  </td>
                </tr>
                <tr>
                  <td>
                    <span>administory</span>
                  </td>
                  <td class="dis-none">
                    <span>홍길동</span>
                  </td>
                  <td class="dis-none">
                    <span>홍길동</span>
                  </td>
                  <td>
                    <span>2017-07-26 00:15:49</span>
                  </td>
                  <td class="dis-none">
                    <span>회원가입 축하</span>
                  </td>
                  <td>
                    <span>1,000</span>
                  </td>
                  <td class="dis-none">
                    <span>20,000</span>
                  </td>
                </tr>
                <tr>
                  <td>
                    <span>administory</span>
                  </td>
                  <td class="dis-none">
                    <span>홍길동</span>
                  </td>
                  <td class="dis-none">
                    <span>홍길동</span>
                  </td>
                  <td>
                    <span>2017-07-26 00:15:49</span>
                  </td>
                  <td class="dis-none">
                    <span>회원가입 축하</span>
                  </td>
                  <td>
                    <span>1,000</span>
                  </td>
                  <td class="dis-none">
                    <span>20,000</span>
                  </td>
                </tr>
                <tr>
                  <td>
                    <span>administory</span>
                  </td>
                  <td class="dis-none">
                    <span>홍길동</span>
                  </td>
                  <td class="dis-none">
                    <span>홍길동</span>
                  </td>
                  <td>
                    <span>2017-07-26 00:15:49</span>
                  </td>
                  <td class="dis-none">
                    <span>회원가입 축하</span>
                  </td>
                  <td>
                    <span>1,000</span>
                  </td>
                  <td class="dis-none">
                    <span>20,000</span>
                  </td>
                </tr>
              </table>
            </div>
          </div>
          <!-- E: new-user-list -->
        </div>
        <!-- E: main-line-four -->
        <!-- S: main-line-five -->
        <div class="main-line-five">
          <h4 class="h-title">최근게시물</h4>
          <!-- S: new-user-list -->
          <div class="new-user-list">
            <div class="box-shadow">
              <table cellspacing="0" cellpadding="0">
                <tr>
                  <th class="dis-none">그룹</th>
                  <th class="dis-none">게시판</th>
                  <th>제목</th>
                  <th class="dis-none-2">이름</th>
                  <th>일시</th>
                </tr>
                <tr>
                  <td class="dis-none">
                    <span>쇼핑몰</span>
                  </td>
                  <td class="dis-none">
                    <span>질문답변</span>
                  </td>
                  <td>
                    <span>제목이 노출됩니다.제목이 노출됩니다.제목이 노출됩니다.</span>
                  </td>
                  <td class="dis-none-2">
                    <span>홍길동</span>
                  </td>
                  <td>
                    <span>2018-07-25</span>
                  </td>
                </tr>
                <tr>
                  <td class="dis-none">
                    <span>쇼핑몰</span>
                  </td>
                  <td class="dis-none">
                    <span>질문답변</span>
                  </td>
                  <td>
                    <span>제목이 노출됩니다.제목이 노출됩니다.제목이 노출됩니다.</span>
                  </td>
                  <td class="dis-none-2">
                    <span>홍길동</span>
                  </td>
                  <td>
                    <span>2018-07-25</span>
                  </td>
                </tr>
                <tr>
                  <td class="dis-none">
                    <span>쇼핑몰</span>
                  </td>
                  <td class="dis-none">
                    <span>질문답변</span>
                  </td>
                  <td>
                    <span>제목이 노출됩니다.제목이 노출됩니다.제목이 노출됩니다.</span>
                  </td>
                  <td class="dis-none-2">
                    <span>홍길동</span>
                  </td>
                  <td>
                    <span>2018-07-25</span>
                  </td>
                </tr>
                <tr>
                  <td class="dis-none">
                    <span>쇼핑몰</span>
                  </td>
                  <td class="dis-none">
                    <span>질문답변</span>
                  </td>
                  <td>
                    <span>제목이 노출됩니다.제목이 노출됩니다.제목이 노출됩니다.</span>
                  </td>
                  <td class="dis-none-2">
                    <span>홍길동</span>
                  </td>
                  <td>
                    <span>2018-07-25</span>
                  </td>
                </tr>
                <tr>
                  <td class="dis-none">
                    <span>쇼핑몰</span>
                  </td>
                  <td class="dis-none">
                    <span>질문답변</span>
                  </td>
                  <td>
                    <span>제목이 노출됩니다.제목이 노출됩니다.제목이 노출됩니다.</span>
                  </td>
                  <td class="dis-none-2">
                    <span>홍길동</span>
                  </td>
                  <td>
                    <span>2018-07-25</span>
                  </td>
                </tr>
              </table>
            </div>
          </div>
          <!-- E: new-user-list -->
        </div>
        <!-- E: main-line-five -->
      </div>
      <!-- E: main -->
    </div>
    <!-- E: pd-15 -->
  </div>
  <!-- E: right-content -->
</div>
<!-- S: footer -->
<!-- #include file="include/footer.asp" -->
<!-- E: footer -->