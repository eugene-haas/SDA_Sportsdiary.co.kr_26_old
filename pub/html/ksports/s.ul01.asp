		  <li>
            <span class="txt">기간</span>
            <input type="text" id="GameS" value="<%=sdate%>" class="in_txt w_50" style="margin-right:8px;" placeholder="시작일"  onchange="mx.SetDate('on-off-term',this.value)" >
            <input type="text" id="GameE"  value="<%=edate%>"  class="in_txt w_50" placeholder="종료일"  onchange="mx.SetDate('on-off-term',this.value)" >
          </li>

		  <li>
            <dl class="match_grade clearfix">
              <dd>
                <span class="swith_txt">전체</span>
                <div class="toggle-group" onclick="mx.SetDateAll('on-off-term')">
                    <input type="checkbox" name="on-off-term" id="on-off-term" value="Y" <%If dateall = "Y" Or dateall = "" then%>checked<%End if%>>
                    <label for="on-off-term">
                        <span class="aural"></span>
                    </label>
                    <div class="onoffswitch pull-right" aria-hidden="true">
                        <div class="onoffswitch-label">
                            <div class="onoffswitch-inner"></div>
                            <div class="onoffswitch-switch"></div>
                        </div>
                    </div>
                </div>
              </dd>
          </li>
		  <li></li>
