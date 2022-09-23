      <!-- S: input-select -->
      <div class="stat-select row">
        <!-- S: tab-menu -->
        <div class="stat-type">
          <!-- S: tab-list -->
          <ul class="stat-list clearfix">
            <li>
              <a href="stat-winner-state.asp" class="grade-btn"><span class="tab-img"><img src="images/tournerment/stat/icon-grade-off.png" alt></span><span>성적조회</span></a>
            </li>
            <!--//
            <li>
              <a href="stat-point-divide.asp" class="point-btn"><span class="tab-img"><img src="images/tournerment/stat/icon-point-off.png" alt width="50" height="47"></span><span>득실점률</span></a>
            </li>
            -->
            <li>
              <a href="stat-medal.asp" class="medal-btn medal on"><span class="tab-img"><img src="images/tournerment/stat/icon-medal-on.png" alt></span><span>순위</span></a>
            </li>
          </ul>
          <!-- E: tab-list -->
        </div>
        <!-- E: tab-menu -->

        <!-- S: stat-result-menu -->
        <div class="grade-tab stat-result-menu">
          <!-- S: grade-tab -->
          <ul class="grade-list clearfix">
            <li>
              <a href="stat-winning-rate.asp" class="result-search-list winning-rate">경기승률</a>
            </li>
            <li>
              <a href="stat-medal.asp" class="result-search-list winner-state">메달순위</a>
            </li>
            <li>
              <a href="stat-medal-total.asp" class="result-search-list grade-state on">메달합계</a>
            </li>
          </ul>
          <!-- E: stat-result-menu -->
        </div>
        <!-- E: grade-tab -->



        <!-- S: select-group -->
        <div class="select-group-wrap stat-select-group">
          <div class="stat-select-group select-group clearfix">
            <!-- S: select-list -->
            <ul class="select-list">
              <li>
                <select id="SYear">
                </select>
              </li>
              <li>
                <select id="GroupGameGb" onchange="score.changeGroup();">
                  <option value="<%=CONST_CODE_PERSON%>" selected>개인전</option>
                  <option value="<%=CONST_CODE_GROUP%>">단체전</option>
				</select>
              </li>
              <li><!-- 0 전체를 가져올것 -->
                <select id="TeamGb"  onchange="score.setSearch();">
                  <option value="<%=CONST_CODE_PERSON_SINGLE%>">단식</option>
                  <option value="<%=CONST_CODE_PERSON_DOUBLE%>">복식</option>
                </select>
              </li>
              <li>
                <select id="SexLevel">
                  <option value="0">전체</option>
                </select>
              </li>
              <li>
                <!-- S: btn-box -->
                <div class="btn-box">
                  <a onclick="javascript:score.gradeSearch(1)" role="submit" class="btn btn-state">조회</a>
                </div>
                <!-- E: btn-box -->
              </li>
            </ul>
            <!-- E: select-list -->
        </div>
        <!-- E: select-group -->
      </div>
      <!-- E: input-select -->


	  <!-- S: winner-state -->
		<div class="winner-state solo-state" id="div-gradelist"></div>
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
              <th>총메달</th>
              <th>대회수</th>
              <!--<th>순위변동</th>-->
            </tr>
          </thead>
          <tbody id="list_body">
            
            <tr>
              <td>1</td>
              <td>최보라</td>
              <td>서울체육고등학교</td>
              <td>5</td>
              <td>3</td>
              <td>1</td>
              <td>9</td>
              <td>10</td>
              
            </tr>
            <tr>
              <td>2</td>
              <td>최보라</td>
              <td>서울체육고등학교</td>
              <td>5</td>
              <td>3</td>
              <td>1</td>
              <td>9</td>
              <td>10</td>
             
            </tr>
            
          </tbody>
        </table>
        <!-- E: ranking-table -->
      </div>
      <!-- E: medal, ranking-->
<%End if%>