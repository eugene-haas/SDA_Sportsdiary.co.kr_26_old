          <li>
            <span class="txt">종별</span>
            <dl class="match_grade clearfix">
              <dd>
                <span class="swith_txt">초등부</span>
                <div class="toggle-group" >
                    <input type="checkbox" name="on-off-sc1" id="on-off-sc1" value="Y" <%If VOD1 = "Y" then%>checked<%End if%>>
                    <label for="on-off-sc1">
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
              <dd>
                <span class="swith_txt">중등부</span>
                <!-- S: toggle-group -->
                <div class="toggle-group" onclick="mx.vodbtn('2', 'm_btn')">
                    <input type="checkbox" name="on-off-sc2" id="on-off-sc2"  value="Y" <%If VOD2 = "Y" then%>checked<%End if%>>
                    <label for="on-off-sc2">
                        <span class="aural"></span>
                    </label>
                    <!-- S: onoffswitch -->
                    <div class="onoffswitch pull-right" aria-hidden="true">
                        <div class="onoffswitch-label">
                            <div class="onoffswitch-inner"></div>
                            <div class="onoffswitch-switch"></div>
                        </div>
                    </div>
                    <!-- E: onoffswitch -->
                </div>
                <!-- E: toggle-group -->

                <a href="javascript:mx.setBooDate('boodate','m')" class="btn btn-ctr" id="m_btn" data-target=".add-date" <%If VOD2 = "N" Or VOD2="" then%>style="display:none;"<%End if%>>날짜추가</a>
              </dd>
              <dd>
                <span class="swith_txt">고등부</span>
                <!-- S: toggle-group -->
                <div class="toggle-group"  onclick="mx.vodbtn('3', 'h_btn')">
                    <input type="checkbox" name="on-off-sc3" id="on-off-sc3"  value="Y" <%If VOD3 = "Y" then%>checked<%End if%>>
                    <label for="on-off-sc3">
                        <span class="aural"></span>
                    </label>
                    <!-- S: onoffswitch -->
                    <div class="onoffswitch pull-right" aria-hidden="true">
                        <div class="onoffswitch-label">
                            <div class="onoffswitch-inner"></div>
                            <div class="onoffswitch-switch"></div>
                        </div>
                    </div>
                    <!-- E: onoffswitch -->
                </div>
                <!-- E: toggle-group -->
                <a href="javascript:mx.setBooDate('boodate','h')" class="btn btn-ctr"  id="h_btn"  data-target=".add-date"  <%If VOD3 = "N" Or VOD2="" then%>style="display:none;"<%End if%>>날짜추가</a>
              </dd>
              <dd>
                <span class="swith_txt">대학부</span>
                <div class="toggle-group">
                    <input type="checkbox" name="on-off-sc4" id="on-off-sc4"  value="Y" <%If VOD4 = "Y" then%>checked<%End if%>>
                    <label for="on-off-sc4">
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
              <dd>
                <span class="swith_txt">일반부</span>
                <div class="toggle-group">
                    <input type="checkbox" name="on-off-sc5" id="on-off-sc5"  value="Y" <%If VOD5 = "Y" then%>checked<%End if%>>
                    <label for="on-off-sc5">
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

              <dd>
                <span class="swith_txt">구분없음</span>
                <div class="toggle-group">
                    <input type="checkbox" name="on-off-sc6" id="on-off-sc6"  value="Y" <%If VOD6 = "Y" then%>checked<%End if%>>
                    <label for="on-off-sc6">
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