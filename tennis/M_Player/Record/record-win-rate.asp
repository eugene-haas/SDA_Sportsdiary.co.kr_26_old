<!-- #include file="../include/config.asp" -->
<body>
  <!-- S: sub-header -->
  <div class="sd-header sd-header-sub">
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <h1>경기 기록실</h1>
    <!-- #include file="../include/sub_header_gnb.asp" -->
  </div>
  <!-- #include file = "../include/gnb.asp" -->
  <!-- E: sub-header -->

  <!-- S: record-menu -->
  <div class="record-menu">
    <div class="menu-list big-cat flex">
      <a href="#" class="btn">성적조회</a>
      <a href="#" class="btn on">순위</a>
    </div>
    <div class="menu-list mid-cat">
      <ul class="record-mid clearfix" style="display: none;">
        <li><a href="record-srch-win.asp">입상현황</a></li>
        <li><a href="record-srch-winner.asp" class="on">입상자(단체)조회</a></li>
      </ul>
      <ul class="rank-mid clearfix" style="display: block;">
        <li><a href="record-rank.asp" >점수득점</a></li>
        <li><a href="record-skill-point.asp" class="on">기술득점</a></li>
        <li><a href="">경기승률</a></li>
        <li><a href="">메달순위</a></li>
        <li><a href="">메달합계</a></li>
      </ul>
    </div>
    <div class="menu-list small-cat flex"></div>
  </div>
  <!-- E: record-menu -->
  <!-- S: record-input -->
  <div class="record-input">
    <!-- S: sel-list -->
    <div class="sel-list">
      <!-- S: 기간 -->
      <dl class="clearfix">
        <dt>기간</dt>
        <dd>
          <select name="">
            <option value="">2016년</option>
            <option value="">2017년</option>
            <option value="">2018년</option>
          </select>
        </dd>
      </dl>
      <!-- E: 기간 -->
      <!-- S: 소속구분 -->
      <dl class="clearfix">
        <dt>소속구분</dt>
        <dd>
          <select name="">
            <option value="">:: 소속구분 선택 ::</option>
            <option value="">:: 소속구분 선택 ::</option>
            <option value="">:: 소속구분 선택 ::</option>
          </select>
        </dd>
      </dl>
      <!-- E: 소속구분 -->
      <!-- S: 체급 -->
      <dl class="srch-inpt clearfix">
        <dt>체급</dt>
        <dd>
          <select name="">
            <option value="">:: 체급 선택 ::</option>
            <option value="">:: 체급 선택 ::</option>
            <option value="">:: 체급 선택 ::</option>
          </select>
        </dd>
      </dl>
      <!-- E: 체급 -->
      <!-- S: 기술명 -->
      <dl class="srch-inpt clearfix">
        <dt>기술명</dt>
        <dd>
          <select name="">
            <option value="">전체 종합</option>
            <option value="">전체 종합</option>
            <option value="">전체 종합</option>
          </select>
        </dd>
      </dl>
      <!-- E: 기술명 -->
    </div>
    <!-- E: sel-list -->
    <div class="btn-list">
      <a href="#" class="btn-left btn">닫기</a>
      <a href="#" class="btn-right btn">조회</a>
    </div>
  </div>
  <!-- S: tail -->
  <div class="tail">
    <a href="#"><img src="http://img.sportsdiary.co.kr/sdapp/record/open-tail@3x.png" alt="닫기"></a>
  </div>
  <!-- E: tail -->
  <!-- E: record-input -->
  <!-- S: skill-state -->
  <div class="skill-state state-cont">
    <h2><span>2016년</span> / <span>고등부</span> / <span>여자 -52kg</span> / <br> <span>한소매 업어치기</span></h2>
    <!-- S: match-list -->
    <div class="match-list">
      <table class="rank-tb">
        <thead>
          <tr>
            <th>순위</th>
            <th></th>
            <th>이름(소속)</th>
            <th>한소매<br>업어치기</th>
            <th>총경기수</th>
            <th>득점률</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>1</td>
            <td class="profile-img">
              <span class="img-round"><img src="http://img.sportsdiary.co.kr/sdapp/record/srch-default@3x.png" alt></span>
            </td>
            <td class="belong">
              <p>정해영</p>
              <span>철원고등학교학교학교</span>
            </td>
            <td>100</td>
            <td>10</td>
            <td>100%</td>
          </tr>
          <tr>
            <td>2</td>
            <td class="profile-img">
              <span class="img-round"><img src="http://img.sportsdiary.co.kr/sdapp/record/srch-default@3x.png" alt></span>
            </td>
            <td class="belong">
              <p>정해영</p>
              <span>철원고등학교</span>
            </td>
            <td>100</td>
            <td>10</td>
            <td>100%</td>
          </tr>
          <tr>
            <td>3</td>
            <td class="profile-img">
              <span class="img-round"><img src="http://img.sportsdiary.co.kr/sdapp/record/srch-default@3x.png" alt></span>
            </td>
            <td class="belong">
              <p>정해영</p>
              <span>철원고등학교</span>
            </td>
            <td>100</td>
            <td>10</td>
            <td>100%</td>
          </tr>
          <tr>
            <td>4</td>
            <td class="profile-img">
              <span class="img-round"><img src="http://img.sportsdiary.co.kr/sdapp/record/srch-default@3x.png" alt></span>
            </td>
            <td class="belong">
              <p>정해영</p>
              <span>철원고등학교</span>
            </td>
            <td>100</td>
            <td>10</td>
            <td>100%</td>
          </tr>
          <tr>
            <td>5</td>
            <td class="profile-img">
              <span class="img-round"><img src="http://img.sportsdiary.co.kr/sdapp/record/srch-default@3x.png" alt></span>
            </td>
            <td class="belong">
              <p>정해영</p>
              <span>철원고등학교</span>
            </td>
            <td>100</td>
            <td>10</td>
            <td>100%</td>
          </tr>
          <tr>
            <td>6</td>
            <td class="profile-img">
              <span class="img-round"><img src="http://img.sportsdiary.co.kr/sdapp/record/srch-default@3x.png" alt></span>
            </td>
            <td class="belong">
              <p>정해영</p>
              <span>철원고등학교</span>
            </td>
            <td>100</td>
            <td>10</td>
            <td>100%</td>
          </tr>
          <tr>
            <td>7</td>
            <td class="profile-img">
              <span class="img-round"><img src="http://img.sportsdiary.co.kr/sdapp/record/srch-default@3x.png" alt></span>
            </td>
            <td class="belong">
              <p>정해영</p>
              <span>철원고등학교</span>
            </td>
            <td>100</td>
            <td>10</td>
            <td>100%</td>
          </tr>
          <tr>
            <td>8</td>
            <td class="profile-img">
              <span class="img-round"><img src="http://img.sportsdiary.co.kr/sdapp/record/srch-default@3x.png" alt></span>
            </td>
            <td class="belong">
              <p>정해영</p>
              <span>철원고등학교</span>
            </td>
            <td>100</td>
            <td>10</td>
            <td>100%</td>
          </tr>
        </tbody>
      </table>
    </div>
    <!-- E: match-list -->
  </div>
  <!-- E: skill-state -->
  <!-- S: footer -->
  <div class="footer">
    <!-- S: bottom-menu -->
    <!-- #include file="../include/bottom_menu.asp" -->
    <!-- E: bottom-menu -->
  </div>
  <!-- E: footer -->
  <!-- S: bot-config -->
  <!-- #include file= "../include/bot_config.asp" -->
  <!-- E: bot-config -->
</body>
