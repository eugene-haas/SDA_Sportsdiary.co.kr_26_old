    <!-- S: input-select -->
      <div class="stat-select row">
        <!-- S: tab-menu -->
        <div class="stat-type">
          <!-- S: tab-list -->
          <ul class="stat-list clearfix">
            <li>
              <a href="stat-winner-state.asp" class="grade-btn on"><span class="tab-img"><img src="images/tournerment/stat/icon-grade-on.png" alt></span><span>성적조회</span></a>
            </li>
            <li>
              <a href="stat-medal.asp" class="medal-btn medal"><span class="tab-img"><img src="images/tournerment/stat/icon-medal-off.png" alt></span><span>순위</span></a>
            </li>
          </ul>
          <!-- E: tab-list -->
        </div>
        <!-- E: tab-menu -->


        <!-- S: stat-result-menu -->
        <div class="grade-tab stat-result-menu">
          <!-- S: grade-tab -->
          <ul class="grade-list clearfix">
          <!--//
            <li>
              <a href="stat-winning-rate.html" class="result-search-list winning-rate">경기승률</a>
            </li>
          -->
            <li>
              <a href="stat-tourney-result.asp" class="result-search-list winner-state on">대진표로 보기</a>
            </li>
            <li>
              <a href="stat-result-list.asp" class="result-search-list grade-state">리스트로 보기</a>
            </li>
          </ul>
          <!-- E: stat-result-menu -->
        </div>
        <!-- E: grade-tab -->





	  <!-- S: winner-state -->
		<div class="winner-state solo-state" id="div-statresult"></div>
      <!-- E: winner-state -->


    <!-- S: Winner  result Modal -->	
	<div class="round-res fade modal" id="round-res" tabindex="-1" role="dialog" aria-labelledby="modal-title" aria-hidden="true">	</div>
    <!-- E: Winner-1 result Modal -->





<%If x = 1 then%>
      <!-- S: ranking, medal -->
      <div class="medal ranking">
        <!-- S: ranking -->
        <table class="table table-bordered table-striped ranking-table">
          <!-- <caption id="DP_NowYear"> -->
          <caption>
            <span>개인전</span>
            <span>복식</span>
            <span>신인부</span>
          </caption>
          <thead>
            <tr>
              <th>순위</th>
              <th>이름</th>
              <th>소속명</th>
              <th><span class="gold-medal"><img src="images/tournerment/stat/gold-medal.png" alt width="23" height="30"></span>금</th>
              <th><span class="silver-medal"><img src="images/tournerment/stat/silver-medal.png" alt width="23" height="30"></span>은</th>
              <th><span class="bronze-medal"><img src="images/tournerment/stat/bronze-medal.png" alt width="23" height="30"></span>동</th>
              <th>대회수</th>
              <!--<th>순위변동</th>-->
            </tr>
          </thead>
          <tbody id="list_body">
            <tr>
            <td colspan='8'>조회 조건을 선택 후, 조회버튼을 눌러주세요.</td>
            </tr>
          
            <tr>
              <td>1</td>
              <td>최보라</td>
              <td>서울체육고등학교</td>
              <td>5</td>
              <td>3</td>
              <td>1</td>
              <td>10</td>
             
            </tr>
            <tr>
              <td>2</td>
              <td>최보라</td>
              <td>서울체육고등학교</td>
              <td>5</td>
              <td>3</td>
              <td>1</td>
              <td>10</td>
              
            </tr>
           
          </tbody>
        </table>
        <!-- E: ranking-table -->
      </div>
      <!-- E: medal, ranking-->
<%End if%>