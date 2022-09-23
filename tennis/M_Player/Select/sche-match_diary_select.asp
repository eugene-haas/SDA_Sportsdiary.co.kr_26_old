<!--#include file="../Library/ajax_config.asp"-->
<%
SportsGb 		=  Request.Cookies("SportsGb")
MemberIDX   	=  decode(Request.Cookies("MemberIDX"),0)
PlayerIDX   	=  decode(Request.Cookies("PlayerIDX"),0)

Tryear          = fInject(Request("Tryear"))
GameTitleIDX    = fInject(Request("GameTitleIDX"))
id              = fInject(Request("id"))

IF  MemberIDX= "" or SportsGb="" Then
	Response.Write "FALSE| id :"&id&" Tryear :"&Tryear&" GameTitleIDX "&GameTitleIDX
	Response.End
Else
        if id ="condition" then
            '심리적상태
            LSQL = "EXEC View_match_diary '"&SportsGb&"' , "&MemberIDX&","&PlayerIDX&",'"&Tryear&"',"&GameTitleIDX&",'"&id&"'"
            Set LRs = Dbcon.Execute(LSQL)
            IF Not (LRs.Eof Or LRs.Bof) Then
            Do Until LRs.Eof
            if LRs("CHEK") ="Y" then
            %>



            <%
            end if

            LRs.MoveNext
            Loop
            end if
            LRs.Close
        End If


        if id ="match-question" then
          %>
             <table id="tranin-question" class="navy-top-table">
                  <thead>
                    <tr>
                      <th rowspan="2">평가 내용</th>
                      <th colspan="3">만족도</th>
                    </tr>
                    <tr>
                      <th>상</th>
                      <th>중</th>
                      <th>하</th>
                    </tr>
                  </thead>
                  <tbody>
            <%
            LSQL = "EXEC View_match_diary '"&SportsGb&"' , "&MemberIDX&","&PlayerIDX&",'"&Tryear&"',"&GameTitleIDX&",'"&id&"'"
            Set LRs = Dbcon.Execute(LSQL)
            IF Not (LRs.Eof Or LRs.Bof) Then
            Do Until LRs.Eof
            %>
                <tr>
                <%
                    SEQID=LRs("AsmtCd")
                    SEQ =LRs("OrderBy")
                    CHECK_question =LRs("AsmtMark")

                    CHECK_0 ="checked='checked'"
                    CHECK_A =""
                    CHECK_B =""
                    CHECK_C =""

                    IF CHECK_question ="A"  THEN
                        CHECK_A=CHECK_0
                    END IF

                    IF CHECK_question ="B"  THEN
                        CHECK_B=CHECK_0
                    END IF

                    IF CHECK_question ="C"  THEN
                        CHECK_C=CHECK_0
                    END IF

                %>
                <td><label for="match-question<%=SEQID %>"><%=SEQ %>. <%=LRs("AsmtNm") %> </label></td>
                <td><input type="radio" id="match-question<%=SEQID %>-1" name="match-question<%=SEQID %>"  value='<%=LRs("AsmtCd") %>:A'  <%=CHECK_A %> /></td>
                <td><input type="radio" id="match-question<%=SEQID %>-2" name="match-question<%=SEQID %>"  value='<%=LRs("AsmtCd") %>:B'  <%=CHECK_B %> /></td>
                <td><input type="radio" id="match-question<%=SEQID %>-3" name="match-question<%=SEQID %>"  value='<%=LRs("AsmtCd") %>:C'  <%=CHECK_C %> /></td>
                </tr>

            <%
            LRs.MoveNext
            Loop

            end if
            LRs.Close
            %>
                    </tbody>
                </table>
            <%
        End If


        '메모리
        if id ="memory" then
            LSQL = "EXEC View_match_diary '"&SportsGb&"',"&MemberIDX&","&PlayerIDX&",'"&Tryear&"',"&GameTitleIDX&",'"&id&"'"
            Set LRs = Dbcon.Execute(LSQL)
            IF Not (LRs.Eof Or LRs.Bof) Then
            Do Until LRs.Eof
            %>
             <ul id="memory" class="memory" >
                  <li>
                    <%
                        CLASSNAME ="icon-off-favorite"
                        CHENK_FAVORITE =""

                        IF LRs("AdtWellCkYn")="Y" THEN
                            CLASSNAME="icon-on-favorite"
                            CHENK_FAVORITE ="checked='checked'"
                        END IF

                     %>
                    <a href="#" class="sw-char" onclick="memoryChk('memory-txt01',1); return false;">
                    <span class="<%=CLASSNAME %>">★</span>
                    <input type="checkbox" id="memory-txt01"  name ="memory-txt" value="1" <%=CHENK_FAVORITE %>>
                    <label for="memory-txt01">잘된점</label></a>
                    <p><textarea id="AdtWell" placeholder="잘된점을 입력하세요"><%= Replace(replace(LRs("AdtWell"), chr(13), "<br />"), Chr(32), "&nbsp;")  %></textarea></p>
                  </li>
                  <li>
                   <%
                        CLASSNAME ="icon-off-favorite"
                        CHENK_FAVORITE =""
                        IF LRs("AdtNotWellCkYn")="Y" THEN
                            CLASSNAME="icon-on-favorite"
                            CHENK_FAVORITE ="checked='checked'"
                        END IF

                     %>
                    <a href="#" class="sw-char" onclick="memoryChk('memory-txt02',2); return false;" >
                    <span class="<%=CLASSNAME %>">★</span>
                    <input type="checkbox" id="memory-txt02"  name ="memory-txt" value="2" <%=CHENK_FAVORITE %>>
                    <label for="memory-txt02">보완점</label></a>
                    <p><textarea id="AdtNotWell" placeholder="보완점을 입력하세요."><%= Replace(replace(LRs("AdtNotWell"), chr(13), "<br />"), Chr(32), "&nbsp;")  %></textarea></p>
                  </li>
                  <li>
                   <%
                        CLASSNAME ="icon-off-favorite"
                        CHENK_FAVORITE =""
                        IF LRs("AdtMyDiayCklYn")="Y" THEN
                            CLASSNAME="icon-on-favorite"
                            CHENK_FAVORITE ="checked='checked'"
                        END IF

                     %>
                    <a href="#" class="sw-char"  onclick="memoryChk('memory-txt03',3); return false;">
                    <span class="<%=CLASSNAME %>">★</span>
                    <input type="checkbox" id="memory-txt03"  name ="memory-txt"  value="3"<%=CHENK_FAVORITE %>>
                    <label for="memory-txt03">나의일기</label></a>
                    <p><textarea id="AdtMyDiay" placeholder="나만의 일기를 작성해 보세요. (비공개)"><%= Replace(replace(LRs("AdtMyDiay"), chr(13), "<br />"), Chr(32), "&nbsp;")  %></textarea></p>
                  </li>
                  <li>
                   <%
                        CLASSNAME ="icon-off-favorite"
                        CHENK_FAVORITE =""
                        IF LRs("AdtAdviceCkYn")="Y" THEN
                            CLASSNAME="icon-on-favorite"
                            CHENK_FAVORITE ="checked='checked'"
                        END IF

                     %>
                    <a href="#" class="sw-char"  onclick="memoryChk('memory-txt04',4); return false;">
                    <span class="<%=CLASSNAME %>">★</span>
                    <input type="checkbox" id="memory-txt04"  name ="memory-txt"  value="4"<%=CHENK_FAVORITE %>>
                    <label for="memory-txt04">지도자상담</label></a>
                    <p><textarea id="AdtAdvice" placeholder="코치님 또는 감독님에게 하고 싶은 말을 입력하세요."><%= Replace(replace(LRs("AdtAdvice"), chr(13), "<br />"), Chr(32), "&nbsp;")  %></textarea></p>
                  </li>
                  <li>
                   <%
                        CLASSNAME ="icon-off-favorite"
                        CHENK_FAVORITE =""
                        IF LRs("AdtAdviceReCkYn")="Y" THEN
                            CLASSNAME="icon-on-favorite"
                            CHENK_FAVORITE ="checked='checked'"
                        END IF

                     %>
                    <a href="#" class="sw-char"  onclick="memoryChk('memory-txt05',5); return false;">
                    <span class="<%=CLASSNAME %>">★</span>
                    <input type="checkbox" id="memory-txt05"  name ="memory-txt" value="5" <%=CHENK_FAVORITE %> >
                    <label for="memory-txt05">지도자답변</label></a>
                    <p><textarea id="AdtAdviceRe" readonly="readonly"><%= Replace(replace(LRs("AdtAdviceRe"), chr(13), "<br />"), Chr(32), "&nbsp;")  %></textarea></p>
                  </li>
                </ul>
            <%
             LRs.MoveNext
            Loop
            end if
            LRs.Close
        End If

        '대회 결과 페이지
        if id ="GameTitle" then
                 %>
          <ul id="GameTitle" class="navyline-top-list">
                 <%
            LSQL = "EXEC View_match_diary_title '"&SportsGb&"',"&MemberIDX&","&PlayerIDX&",'"&Tryear&"',"&GameTitleIDX&",'"&id&"'"
            Set LRs = Dbcon.Execute(LSQL)
            IF Not (LRs.Eof Or LRs.Bof) Then
            Do Until LRs.Eof
                  %>
              <!-- 개인, 단체전에서 좋은 성적을 몇 개 노출. 현재페이지에서만 메달노출, 상세페이지엔 메달x -->
                  <li class="clearfix">
                    <p class="list-info">
                      <span class="cut-off">
                        <%
                        if LRs("roundNm")<= 4 then
                            if  LRs("MedelNm") ="금메달" then
                            %> <img src="http://img.sportsdiary.co.kr/sdapp/record/golden-medal@3x.png" alt="" /> 금메달 <%
                            elseif  LRs("MedelNm") ="은메달" then
                             %> <img src="http://img.sportsdiary.co.kr/sdapp/record/silver-medal@3x.png" alt="" /> 은메달 <%
                            elseif  LRs("MedelNm") ="동메달" then
                             %> <img src="http://img.sportsdiary.co.kr/sdapp/record/bronze-medal@3x.png" alt="" /> 동메달 <%
                            else
                             if  LRs("roundNm") <=2  and LRs("Round")& ""<>"" then
                                    Response.Write "결승전"
                                    ttsround ="결승전 "
                                 else
                                    Response.Write "4강"
                                    ttsround ="4강"
                                 end if
                            end if
                        else
                            Response.Write LRs("roundNm")  & "강"
                        end if
                         %>
                      </span>
                      <span><%=LRs("GroupGameGbNM") %></span>
                      <span><%=LRs("TeamGbNm") %></span>
                      <span><%=LRs("SexNm") %></span>
                      <span><%=LRs("LevelNm") %></span>
                      <input type="hidden" id="<%=GameTitleIDX %>"<%=LRs("GroupGameGb") %>" value="<%=LRs("GroupGameGb") %>"  />
                      <%
                        if LRs("GroupGameGb")="sd040001" then
                       %>
                            <a href="./match-movie.asp" class="show-film">
                      <%
                        else
                       %>
                            <a href="./match-movie-team.asp" class="show-film">
                       <%
                        end if
                       %>
                        <img src="http://img.sportsdiary.co.kr/sdapp/stats/film-icon@3x.png" alt="대회영상보기"></a>
                    </p>
                  </li>
            <%

             LRs.MoveNext
            Loop
            end if
            LRs.Close
            %>
            </ul>
            <%
        end if

        '대회 상세 결과
        if id ="match_final" or id ="match_final_team" then
                        if id ="match_final" then
                            groupclass =""
                        else
                            groupclass ="group"
                        end if
            seq = 0
            LSQL = "EXEC View_match_diary_modal '"&SportsGb&"',"&MemberIDX&","&PlayerIDX&",'"&Tryear&"',"&GameTitleIDX&",'"&id&"'"
            Set LRs = Dbcon.Execute(LSQL)
            IF Not (LRs.Eof Or LRs.Bof) Then
            Do Until LRs.Eof
                        GameS=LRs("GameS")
                        GameE=LRs("GameE")

                        yy1=left(GameS,4)
                        mm1=mid(GameS,6,2)
                        dd1=right(GameS,2)

                        yy2=left(GameE,4)
                        mm2=mid(GameE,6,2)
                        dd2=right(GameE,2)

                  if seq = 0 then
                 %>
                <div id="<%=id %>" class="main stat-record">
                  <div class="stat-film-title">
                    <h3><%=LRs("GameTitleName") %> <span>대회기간: <%=yy1 %>년 <%=mm1 %>월 <%=dd1 %>일 ~ <%=dd2 %>일 (<%=LRs("GameSE") %>일간)</span></h3>
                  </div>
                  <!-- S: 개인전 stat-film -->
                  <section class="stat-film <%=groupclass %>" >
                    <div class="div-title">
                      <h4><span class="cut-off"><%=LRs("GroupGameGbNM") %>&emsp;
                       &nbsp;
                      <%

                        if  LRs("roundNm") <=4  then
                             if  LRs("MedelNm") ="금메달" then
                            %> <img src="http://img.sportsdiary.co.kr/sdapp/record/golden-medal@3x.png" alt="" style="width: 12px; height: AUto" /> 금메달 <%
                            elseif  LRs("MedelNm") ="은메달" then
                             %> <img src="http://img.sportsdiary.co.kr/sdapp/record/silver-medal@3x.png" alt=""style="width: 12px; height: AUto"/> 은메달 <%
                            elseif  LRs("MedelNm") ="동메달" then
                             %> <img src="http://img.sportsdiary.co.kr/sdapp/record/bronze-medal@3x.png" alt=""style="width: 12px; height: AUto" /> 동메달 <%
                            else
                                 if  LRs("roundNm") <=2  and LRs("Round")& ""<>"" then
                                    Response.Write "결승전"
                                    ttsround ="결승전 "
                                 else
                                    Response.Write "4강"
                                    ttsround ="4강"
                                 end if
                            end if
                        else
                            Response.Write LRs("roundNm")  & "강"
                        end if
                      %>&nbsp;
                      </span>
                      </h4>
                    </div>
                    <!-- S: container -->
                    <div class="ana container">
                    <% end if %>
                      <!-- S: stat-list -->
                      <dl class="stat-list">
                        <dt>
                           <a href="#" class="icon-favorite ">★</a>
                          <span>
                          <%
                            if LRs("roundNm") <=2 and LRs("Round")& ""<>"" then
                                %> 결승전 <%
                            elseif LRs("roundNm") =4 then
                                %> 준결승전 <%
                            else
                                if  LRs("roundNm")=0 and LRs("Round")& ""="" then
                                    Response.Write ttsround
                                else
                                    Response.Write LRs("roundNm") & "강"
                                end if

                            end if
                           %>
                          </span>
                           <%

                                if id ="match_final" then
                                    GameNum = LRs("GameNum")
                                else
                                    GameNum = ""
                                end if

                           
                           %>
                          <a href="#" class="show-film"  onclick="mod_Match_Proc('modal_score','<%=LRs("GameTitleIDX") %>','<%=GameNum %>','<%=LRs("MediaLink") %>'); return false;" >
                            <img src="http://img.sportsdiary.co.kr/sdapp/stats/film-icon@3x.png" alt="대회영상보기">
                          </a>
                        </dt>
                        <dd>
                          <ul>
                            <li class="clearfix">
                             <% if id ="match_final" then  %>
                              <p class="me">  <%=LRs("LPlayerNM") %>   &emsp;   <%=LRs("LResultNm")  %>
                              <span class="school"><%=LRs("LTeamNm") %></span>
                              </p>

                              <p class="vs">VS</p>

                              <p class="you">  <%=LRs("RPlayerNM") %>   &emsp; <%=LRs("RResultNm") %>
                              <span class="school"><%=LRs("RTeamNm") %></span>
                              </p>

                              <% else  %>

                              <p class="me">    <%=LRs("LTeamNm") %>&emsp; <%=LRs("LResultNm") %>
                              <span class="school"></span>
                              </p>

                              <p class="vs">VS</p>

                              <p class="you">  <%=LRs("RTeamNm") %>&emsp; <%=LRs("RResultNm") %>
                              <span class="school"></span>
                              </p>
                              <% end if  %>
                            </li>
                          </ul>
                        </dd>
                      </dl>
                      <!-- E: stat-list -->
            <%
             seq = seq+1
             LRs.MoveNext
            Loop
            end if
            LRs.Close
           %>
                    </div>
                    <!-- E: container -->
                  </section>
                  <!-- E: 개인전 stat-film -->
                </div>
           <%
        End If
        if id ="modal_score" then
        %>
                <!-- S: pracice-score -->
                 <div id="modal_score" class="pracice-score" style="width: 100%">
                    <%
                    LSQL = "EXEC View_match_diary_modal_Detail '"&SportsGb&"',"&MemberIDX&","&PlayerIDX&",'"&Tryear&"',"&GameTitleIDX&",'"&id&"'"
                    Set LRs = Dbcon.Execute(LSQL)
                    IF Not (LRs.Eof Or LRs.Bof) Then
                    Do Until LRs.Eof
                    %>
                     <h4><span>
                    <%
                    if LRs("Lchek") ="Y" then
                        Response.Write LRs("LResultNm")
                    ELSE
                        Response.Write LRs("RResultNm")
                    end if
                    %>
                       </span></h4>
                    <!-- S: pop-point-display -->
                    <div class="pop-point-display">
                      <!-- S: display-board -->
                      <div class="display-board clearfix">
                        <!-- S: point-display -->
                        <div class="point-display clearfix">
                          <ul class="point-title flex">
                            <li>선수</li>
                            <li>한판</li>
                            <li>절반</li>
                            <!-- <li>유효</li> -->
                            <li>지도</li>
                            <li>반칙/실격/<br>부전/기권 승</li>
                          </ul>
                          <ul class="player-1-point player-point flex">
                            <li>
                                <a onclick="#">
                                 <%
                                    disp ="disp-none"
                                    if LRs("Lchek") ="Y" then
                                     disp="disp-win"
                                    end if
                                 %>
                                <span class="<%=disp %>"></span>
                                <span class="player-name" id="DP_Edit_LPlayer"><%=LRs("LPlayerNm") %></span>
                                <p class="player-school" id=""><%=LRs("LTeamNm") %></p></a>
                                <p class="vs">vs</p>
                            </li>
                            <li class="tgClass">
                                <a class="" onclick="#" name="a_jumsugb"><span class="score" id="LJumsuGb1"><%=LRs("Left01") %></span></a>
                            </li>
                            <li class="tgClass">
                                <a class="" onclick="#" name="a_jumsugb"><span class="score" id="LJumsuGb2"><%=LRs("Left02") %></span></a>
                            </li>
                            <!-- <li class="tgClass">
                                <a class="" onclick="#" name="a_jumsugb"><span class="score" id="LJumsuGb3">0</span></a>
                            </li> -->
                            <li class="tgClass">
                                <a class="" onclick="#" name="a_jumsugb"><span class="score txt-orange" id="LJumsuGb4"><%=LRs("Left04") %></span></a>
                            </li>
                            <li>
                                <select class="select-win select-box" id="DP_L_GameResult " disabled="disabled">
                                    <option    selected="selected" disabled="disabled">
                                     <%
                                    if LRs("Lchek") ="Y" then
                                        Response.Write LRs("LResultNm")
                                    ELSE
                                      Response.Write "-"
                                    end if
                                     %>
                                    </option>
                                </select>
                            </li>
                            </ul>
                          <ul class="player-2-point player-point flex">
                            <li>
                                <a onclick="#">
                                <%
                                    disp ="disp-none"
                                    if LRs("Rchek") ="Y" then
                                     disp="disp-win"
                                    end if
                                 %>
                                <span class="<%=disp %>"></span>
                                <span class="player-name" id="DP_Edit_RPlayer"><%=LRs("RPlayerNm") %></span>
                                <p class="player-school" id=""><%=LRs("RTeamNm") %></p></a>
                            </li>
                            <li class="tgClass">
                                <a class="" onclick="#" name="a_jumsugb"><span class="score" id="RJumsuGb1"><%=LRs("Right01") %></span></a>
                            </li>
                            <li class="tgClass">
                                <a class="" onclick="#" name="a_jumsugb"><span class="score" id="RJumsuGb2"><%=LRs("Right02") %></span></a>
                            </li>
                            <!-- <li class="tgClass">
                                <a class="" onclick="#" name="a_jumsugb"><span class="score" id="RJumsuGb3">0</span></a>
                            </li> -->
                            <li class="tgClass">
                                <a class="" onclick="#" name="a_jumsugb"><span class="score txt-orange" id="RJumsuGb4"><%=LRs("Right04") %></span></a>
                            </li>
                            <li>
                                <select class="select-win select-box" id="DP_R_GameResult" disabled="disabled">
                                <option value=""    selected="selected" disabled="disabled"><%
                                    if LRs("Lchek") ="Y" then
                                      Response.Write "-"
                                    ELSE
                                      Response.Write LRs("RResultNm")
                                    end if
                                     %></option>
                                </select>
                            </li>
                          </ul>
                          <!-- E: point-display -->
                        </div>
                        <!-- E: point-display -->
                        </div>
                      <!-- E: display-board -->
                    </div>
                    <!-- E: pop-point-display -->
                    <%
                    LRs.MoveNext
                    Loop
                    end if
                    LRs.Close
                    %>
                  </div>
                <!-- E: pracice-score -->
        <%
        End if


        if id ="modal_container" then
        %>
                  <!-- S: 기록보기 record-box -->
                  <div id="modal_container" class="record-box panel" style="display: block;">
                    <h3>득실기록</h3>
                    <ul class="plactice-txt">
                        <%
                        LSQL = "EXEC View_match_diary_modal_Detail '"&SportsGb&"',"&MemberIDX&","&PlayerIDX&",'"&Tryear&"',"&GameTitleIDX&",'"&id&"'"
                        Set LRs = Dbcon.Execute(LSQL)
                        IF Not (LRs.Eof Or LRs.Bof) Then
                        Do Until LRs.Eof
                            %>
                             <li class="<%if LRs("PlayerPosition")  ="LPlayer" then
                                              Response.Write "pratice-txt-white"
                                            else
                                                Response.Write "pratice-txt-blue"
                                           end if
                                         %>" >
                             <%
                                Response.Write "[" &LRs("CheckTime") &"] "&LRs("PlayerName") & " : " & LRs("JumsuGb") &" ( "& LRs("SpecialtyDtl")  &" ) "
                              %>
                             </li>
                            <%

                        LRs.MoveNext
                        Loop
                        end if
                        LRs.Close
                        %>
                    </ul>
                  </div>
                  <!-- E: 기록보기 record-box -->
        <%
        End if

    SET LRs = Nothing
    Dbclose()
End If

%>
