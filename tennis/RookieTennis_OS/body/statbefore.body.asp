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
              <a href="stat-winning-rate.asp" class="medal-btn medal"><span class="tab-img"><img src="images/tournerment/stat/icon-medal-off.png" alt></span><span>순위</span></a>
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
              <a href="stat-winner-state.asp" class="result-search-list winner-state">입상현황</a>
            </li>
            <li>
              <a href="stat-grade-state-before.asp" class="result-search-list grade-state on">입상자(단체)조회</a>
            </li>
          </ul>
          <!-- E: stat-result-menu -->
        </div>
        <!-- E: grade-tab -->

        <!-- S: select-group -->
				<div class="select-group-wrap">
					<div class="stat-select-group grade-chk select-group">
						<!-- S: select-list -->
						<ul class="select-list clearfix">
							<li>
								<select id="SYear">
								</select>
							</li>
							<li>
								<select id="SearchType">
									<option value="A">선수명</option>
									<option value="B">소속명</option>
								</select>
							</li>
							<li><input type="text" id="SearchValue" class="sch-grade" /></li>
							<li>
								<!-- S: btn-box -->
								<div class="btn-box">
									<a onclick="score.gradeSearch(1);" role="submit" class="btn btn-state">조회</a>
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





