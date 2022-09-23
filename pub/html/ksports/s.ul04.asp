		  <li>
            <span class="txt">영상유무</span>
            <select  id="vodYN"  class="sl_search" onchange="mx.SetDate('on-off-vod',this.value)" >
				<option value="">=영상=</option>
				<option value="Y"  <%If vodyn= "Y" then%>selected<%End if%>>Y</option>
				<option value="N"  <%If vodyn= "N" then%>selected<%End if%>>N</option>
            </select>
          </li>

		  <li>
            <dl class="match_grade clearfix">
              <dd>
                <span class="swith_txt">전체</span>
                <div class="toggle-group" onclick="mx.SetVodAll('on-off-vod')">
                    <input type="checkbox" name="on-off-vod" id="on-off-vod" value="Y" <%If vodall = "Y" Or vodall = "" then%>checked<%End if%>>
                    <label for="on-off-vod">
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
			</dl>
          </li>
  		  <li></li>




