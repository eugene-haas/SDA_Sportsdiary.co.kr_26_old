<!--#include file="../Library/ajax_config.asp"-->
<%
SportsGb 		=  Request.Cookies("SportsGb")
Sex 		    =  Request.Cookies("Sex")
MemberIDX   	=  decode(Request.Cookies("MemberIDX"),0)
PlayerIDX   	=  decode(Request.Cookies("PlayerIDX"),0)

id        = fInject(Request("id"))
TrRerdDate      = fInject(Request("TrRerdDate"))	

IF MemberIDX = "" Then 	
	Response.Write "FALSE"
	Response.End
Else 
    ''일지정보 start

    ''목표정보

    ''훈련정보

    ''훈련평가

    ''부상부위

    
    ''일지정보 end






        '''''''기본''''''
        '심리적상태
       if id ="condition" then 
            LSQL = "EXEC View_train '"&SportsGb&"','"&PlayerIDX&"','"&MemberIDX&"','"&id&"','"&TrRerdDate&"'"
            Set LRs = Dbcon.Execute(LSQL)
            IF Not (LRs.Eof Or LRs.Bof) Then 
            Do Until LRs.Eof 
            %> 
              <select id="condition">
                <option value=0>:: 심리적상태 선택 ::</option>
                <option value=1>매우좋음</option>
                <option value=2>좋음</option>
                <option value=3>보통</option>
                <option value=4>나쁨</option>
                <option value=5>매우나쁨</option>
              </select>
            <%
            LRs.MoveNext
            Loop 
            end if
            LRs.Close
        End If 

        '훈련 참석 여부

        '정상? 일부 여부 

        '일부 > 사유

        '불참사유 

        '부상일때 부상부위 

        '훈련목표
       if id ="train-goal-list" then 
            LSQL = "EXEC View_train '"&SportsGb&"','"&PlayerIDX&"','"&MemberIDX&"','"&id&"','"&TrRerdDate&"'"
            Set LRs = Dbcon.Execute(LSQL)
            IF Not (LRs.Eof Or LRs.Bof) Then 
            Do Until LRs.Eof 
            %> 
                <ul id="train-goal-list"class="train-goal-list">
                  <li><input type="checkbox" id="train-goal01"name="train-goal-list" value="1" /> <label for="train-goal01">체력향상 훈련</label></li>
                  <li><input type="checkbox" id="train-goal02"name="train-goal-list" value="2" /> <label for="train-goal02">기술향상 훈련</label></li>
                  <li><input type="checkbox" id="train-goal03"name="train-goal-list" value="3" /> <label for="train-goal03">대회전략 준비 (실전에 필요한 전술훈련 중심)</label></li>
                  <li><input type="checkbox" id="train-goal04"name="train-goal-list" value="4" /> <label for="train-goal04">컨디션 조절을 위한 훈련</label></li>
                  <li><input type="checkbox" id="train-goal05"name="train-goal-list" value="5" /> <label for="train-goal05">부상에 의한 재활훈련</label></li>
                </ul>
            <%
            LRs.MoveNext
            Loop 
            end if
            LRs.Close
        End If 


        '공식훈련 //기본 두개

         if id ="official-train-wrap" then 
           %>
           <div id="official-train-wrap">
           <%
           style="style=visibility: hidden"

           forseq = 2 
            
                For i =1 to 5 step 1
                    officialtrainwrap = "official-train-wrap"&i
                    %>
                     <div id="<%=officialtrainwrap %>" class="official-train-wrap" 
                     <% 
                     if i > forseq then 
                       Response.Write style
                      end if 
                     %> >
                        <div class="official-train">
                            <h2>공식훈련 내용</h2>
                            <a href="http://sportsdiary.co.kr/M_Player/Mypage/training.asp" class="icon-fa-cog" target="_blank">
                            <img src="../images/sub/icon-fa-cog.png" alt="훈련종류 항목관리" /></a>
                            <a href="#" id="official-train-P<%=i %>" class="btn-navyline" onclick="officialtrainClick('official-train-P<%=i %>'); return false;">훈련구분 추가 <span class="txt-or">+</span></a>
                        </div>
                          <div class="bg-navy">
                            <select id="bg-navy<%=i %>"  onchange="bgnavyChange(<%=i %>);">
                             <option value="0">훈련구분을 선택하세요</option>
                                <%
                                LSQL = "select PubCode,PubName from tblPubCode where SportsGb='"&SportsGb&"' AND  PPubCode ='sd017' AND DelYN ='N'"
                                Set LRs = Dbcon.Execute(LSQL)
                                IF Not (LRs.Eof Or LRs.Bof) Then 
                                Do Until LRs.Eof 
                                %><option value="<%=LRs("PubCode") %>"><%=LRs("PubName") %></option><%
                                LRs.MoveNext
                                Loop 
                                end if
                                LRs.Close
                                %>
                            </select>
                          </div>
                             <ul class="official-train-select">
                                <li>
                                  <select id="PceCd<%=i %>" >
                                   <option value="0" >훈련장소</option>
                                        <%
                                        LSQL = "select PceCd,PceNm from tblSvcPceInfo where  DelYN ='N' and MemberIDX='"&MemberIDX&"'  order by OrderBy"

                                        Set LRs = Dbcon.Execute(LSQL)
                                        IF Not (LRs.Eof Or LRs.Bof) Then 

                                            Do Until LRs.Eof 
                                            %><option value="<%=LRs("PceCd") %>"><%=LRs("PceNm") %></option><%
                                            LRs.MoveNext
                                            Loop 
                                           
                                        else 
                                            LRs.Close
                                            LSQL = "select PceCd,PceNm from tblSvcPceInfo where  DelYN ='N' and MemberIDX=0  order by OrderBy"
                                            Set LRs = Dbcon.Execute(LSQL)
                                            IF Not (LRs.Eof Or LRs.Bof) Then 
                                                Do Until LRs.Eof 
                                                %><option value="<%=LRs("PceCd") %>"><%=LRs("PceNm") %></option><%
                                                LRs.MoveNext
                                                Loop 
                                            end if
                                       end if
                                       LRs.Close
                                       %>
                                  </select>
                                </li>
                                <li>
                                  <select id="TrailHour<%=i %>">
                                     <option value="0.0">시간</option>
                                        <%
                                        LSQL = "select PubCode,PubName from tblPubCode where SportsGb='"&SportsGb&"' AND PPubCode ='sd032' AND DelYN ='N'"
                                        Set LRs = Dbcon.Execute(LSQL)
                                        IF Not (LRs.Eof Or LRs.Bof) Then 
                                        Do Until LRs.Eof 
                                        %><option value="<%=LRs("PubCode") %>"><%=LRs("PubName") %></option><%
                                        LRs.MoveNext
                                        Loop 
                                        end if
                                        LRs.Close
                                       %>
                                  </select>
                                </li>
                                <% TraiFistCd = "TraiFistCd"&i    %>
                                <li>
                                  <select id="<%=TraiFistCd %>">
                                   <option value="0" >훈련유형</option>
                                    <%
                                    LSQL = "select TraiFistCd,TraiFistNm,OrderBy from tblSvcTrailFistInfo where SportsGb ='"&SportsGb&"' order by OrderBy"
                                    Set LRs = Dbcon.Execute(LSQL)
                                    IF Not (LRs.Eof Or LRs.Bof) Then 
                                    Do Until LRs.Eof 
                                    %><option value="<%=LRs("TraiFistCd") %>"><%=LRs("TraiFistNm") %></option><%
                                    LRs.MoveNext
                                    Loop 
                                    end if
                                    LRs.Close
                                    %>
                                  </select>
                                </li>
                                <li>
                                  <a href="#" class="btn-gray"  onclick="officialTrainP(<%=i %>); return false;">훈련종류선택</a>
                                </li>
                              </ul>
                               <% TraiFistCdMid = TraiFistCd&"Mid1"    %>
                                <div id="btn-train-list-wrap<%=i %>" class="btn-train-list-wrap" >
                                    <ul id="<%=TraiFistCdMid %>" class="btn-train-list" <%=style %>>
                                    <%
                                    LSQL = " select TraiFistCd,TraiMidCd,TraiMIdNm,OrderBy from tblSvcTrailMidInfo where SportsGb ='"&SportsGb&"' and TraiFistCd='TA' and delyn='N' order by OrderBy "
                                    Set LRs = Dbcon.Execute(LSQL)
                                    IF Not (LRs.Eof Or LRs.Bof) Then 
                                        Do Until LRs.Eof 
                                   %>
                                        <li id="<%=LRs("TraiFistCd") %><%=i %><%=LRs("TraiMidCd") %>">
                                            <a href="#" onclick="TraiFistCdMid('<%=LRs("TraiFistCd") %><%=i %><%=LRs("TraiMidCd") %>'); return false;">
                                            <%=LRs("TraiMIdNm") %></a>
                                            </li>
                                    <%
                                        LRs.MoveNext
                                        Loop 
                                    end if
                                    LRs.Close
                                    %>
                                    </ul>
                                <% TraiFistCdMid = TraiFistCd&"Mid2"    %>
                                    <ul id="<%=TraiFistCdMid %>" class="btn-train-list" <%=style %>>
                                        <%
                                            LSQL = " select TraiFistCd,TraiMidCd,TraiMIdNm,OrderBy from tblSvcTrailMidInfo where SportsGb ='"&SportsGb&"' and TraiFistCd='TB' and delyn='N' order by OrderBy "
                                            Set LRs = Dbcon.Execute(LSQL)
                                            IF Not (LRs.Eof Or LRs.Bof) Then 
                                                Do Until LRs.Eof 
                                           %>
                                                <li id="<%=LRs("TraiFistCd") %><%=i %><%=LRs("TraiMidCd") %>">
                                                    <a href="#" onclick="TraiFistCdMid('<%=LRs("TraiFistCd") %><%=i %><%=LRs("TraiMidCd") %>'); return false;">
                                                    <%=LRs("TraiMIdNm") %></a>
                                                    </li>
                                            <%
                                                LRs.MoveNext
                                                Loop 
                                            end if
                                            LRs.Close
                                            %>
                                    </ul>
                               </div>
                               <div id="MidCdselectOk<%=i %>" class="btn-center pb<%=i %>" <%=style %>>
                                    <a href="#" class="btn-or-select" onclick="officialTrainSelectOk(<%=i %>); return false;">선택완료</a>
                              </div>
                              <ul id="MidCdselect<%=i %>" class="train-select-list" >
                                      <!--tags = tags + "<li id='MidCdselect" + SEQ + tagid + "'><a href='#'><span class='btn-del-x'>x</span>" + $("#" + tagid).text() + "</a></li>";-->
                              </ul>
                     </div>
                     
                    <script type="text/javascript">
                         
                         
                    </script>

                    <%
                next

           %>
           </div>
           <%
        End If 


        '개인훈련
         if id ="official-train-person" then 
            %> 
              <div id="official-train-person" class="official-train-wrap">
                  <div class="tit-individual-train">
                    <h2><span> 개인훈련 내용 입력</span> 
                    <a href="#" class="more-a">▼</a> <!--//<a href="#" class="close-a">▲</a>--></h2>
                  </div>
                  <!-- S : 처음엔 hide, 버튼 클릭해야 show -->
                  <div>
                    <div class="bg-or">
                      <select id ="bg-or-sd017">
                       <option value="0">훈련구분을 선택하세요</option>
                      <%
                        LSQL = "select PubCode,PubName from tblPubCode where SportsGb='"&SportsGb&"' AND PPubCode ='sd017' AND DelYN ='N'"
                        Set LRs = Dbcon.Execute(LSQL)
                        IF Not (LRs.Eof Or LRs.Bof) Then 
                        Do Until LRs.Eof 
                        %><option value="<%=LRs("PubCode") %>"><%=LRs("PubName") %></option><%
                        LRs.MoveNext
                        Loop 
                        end if
                        LRs.Close
                       %>
                      </select>
                    </div>
                    <ul class="official-train-select">
                      <li>
                        <select id ="bg-or-sd027">
                         <option value="0" >훈련장소</option>
                        <%
                        LSQL = "select PubCode,PubName from tblPubCode where SportsGb='"&SportsGb&"' AND PPubCode ='sd027' AND DelYN ='N'"
                        Set LRs = Dbcon.Execute(LSQL)
                        IF Not (LRs.Eof Or LRs.Bof) Then 
                        Do Until LRs.Eof 
                        %><option value="<%=LRs("PubCode") %>"><%=LRs("PubName") %></option><%
                        LRs.MoveNext
                        Loop 
                        end if
                        LRs.Close
                       %>
                        </select>
                      </li>
                      <li>
                      <select id ="bg-or-sd032">
                      <%
                        LSQL = "select PubCode,PubName from tblPubCode where SportsGb='"&SportsGb&"' AND PPubCode ='sd032' AND DelYN ='N'"
                        Set LRs = Dbcon.Execute(LSQL)
                        IF Not (LRs.Eof Or LRs.Bof) Then 
                        Do Until LRs.Eof 
                        %><option value="<%=LRs("PubCode") %>"><%=LRs("PubName") %></option><%
                        LRs.MoveNext
                        Loop 
                        end if
                        LRs.Close
                       %> 
                        </select>
                      </li>
                      <li>
                        <select id ="bg-or-select1" onchange=" PersonTrainP();return false;">
                          <option value="0">훈련유형</option>
                          <option value="1">체력훈련</option>
                          <option value="2">도복훈련</option>
                        </select>
                      </li>
                      <li>
                        <a href="#" id ="bg-or-select_user" class="btn-gray"  onclick="PersonTrainP();return false;">훈련종류선택</a>
                      </li>
                    </ul>
                    <!-- S : btn-train-list 선택 완료시 hide -->
                    <div class="btn-train-list-wrap" >
                      <!-- 01 훈련유형 > 체력훈련 -->
                      <ul class="btn-train-list" >
  
                      </ul>
                      <!--// 01 훈련유형 > 체력훈련 -->

                      <!-- 02 훈련유형 > 도복훈련 -->
                      <ul class="btn-train-list" >
                        <li><a href="#">준비운동</a></li>
                        <li><a href="#">스트레칭</a></li>
                        <li><a href="#">정리운동</a></li>

                        <li><a href="#">굳히기 익히기</a></li>
                        <li><a href="#">끌면서 익히기</a></li>
                        <li><a href="#">초익히기(스피드)</a></li>

                        <li><a href="#">주특기 기술</a></li>
                        <li><a href="#">안다리 후리기</a></li>
                        <li><a href="#">밭다리 후리기</a></li>

                        <li><a href="#">업어치기</a></li>
                        <li><a href="#">허벅다리</a></li>
                        <li><a href="#">허리후리기</a></li>

                        <li><a href="#">잡기싸움</a></li>
                        <li><a href="#">굳히기 자유연습</a></li>
                        <li><a href="#">메치기 자유연습</a></li>

                        <li><a href="#">메치기</a></li>
                        <li><a href="#">소와다리</a></li>
                        <li><a href="#">기술연구</a></li>

                        <li><a href="#">기타</a></li>
                        <li><a href="#">&nbsp;</a></li>
                        <li><a href="#">&nbsp;</a></li>
                      </ul>
                      <!--// 02 훈련유형 > 도복훈련 -->
                    </div>
                    <div class="btn-center pbperson">
                      <a href="#" class="btn-or-select" onclick="PersonTrainSelect();return false;">선택완료</a>
                    </div>
                    <!-- E : btn-train-list 선택 완료시 hide -->
                    <!-- S : train-select-list 선택완료시 btn-train-list는 닫히고 이 부분은 남아있음 -->
                    <ul id ="train-select-list1" class="train-select-list">
                    
                    </ul>
                    <!-- E : train-select-list 선택완료시 btn-train-list는 닫히고 이 부분은 남아있음 -->
                  </div>
                  <!-- E : 처음엔 hide, 버튼 클릭해야 show -->
                </div>
            <%
        End If 


        '훈련평가
         if id ="tranin-question" then 
            LSQL = " SELECT AsmtCd,AsmtNm,OrderBy FROM tblSvcAsmtInfo WHERE SportsGb='"&SportsGb&"' AND DelYN='N' ORDER BY OrderBy "
            Set LRs = Dbcon.Execute(LSQL)
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
                    <tbody>
            <%
            IF Not (LRs.Eof Or LRs.Bof) Then 
            Do Until LRs.Eof 
            %> 
                      <tr>
                        <%  
                            SEQID=""
                            SEQ =LRs("OrderBy")   

                            IF SEQ<10 THEN 
                                SEQID = "0"&SEQ
                            END IF
                        %>
                        <td><label for="tranin-question<%=SEQID %>"><%=SEQ %>. <%=LRs("AsmtNm") %> </label></td>
                        <td><input type="radio" id="tranin-question<%=SEQID %>-1" name="tranin-question<%=SEQID %>"  value='<%=LRs("AsmtCd") %>:A' /></td>
                        <td><input type="radio" id="tranin-question<%=SEQID %>-2" name="tranin-question<%=SEQID %>"  value='<%=LRs("AsmtCd") %>:B' /></td>
                        <td><input type="radio" id="tranin-question<%=SEQID %>-3" name="tranin-question<%=SEQID %>"  value='<%=LRs("AsmtCd") %>:C' /></td>
                      </tr>
            <%
            LRs.MoveNext
            Loop 
            %>
                    </tbody>
                  </thead>
                </table>
            <%

            end if
            LRs.Close
        End If 


        '메모리
         if id ="memory" then 
            %> 
                <ul id="memory" class="memory" >
                  <li>
                    <a href="#" class="sw-char" onclick="memoryChk('memory-txt01',1); return false;">
                    <span class="icon-off-favorite">★</span>
                    <input type="checkbox" id="memory-txt01"  name ="memory-txt" value="1">
                    <label for="memory-txt01">잘된점</label></a>
                    <p><textarea id="AdtWell" placeholder="잘된점을 입력하세요"></textarea></p>
                  </li>
                  <li>
                    <a href="#" class="sw-char" onclick="memoryChk('memory-txt02',2); return false;" >
                    <span class="icon-off-favorite">★</span>
                    <input type="checkbox" id="memory-txt02"  name ="memory-txt" value="2" >
                    <label for="memory-txt02">보완점</label></a>
                    <p><textarea id="AdtNotWell" placeholder="보완점을 입력하세요."></textarea></p>
                  </li>
                  <li>
                    <a href="#" class="sw-char"  onclick="memoryChk('memory-txt03',3); return false;">
                    <span class="icon-off-favorite">★</span>
                    <input type="checkbox" id="memory-txt03"  name ="memory-txt"  value="3">
                    <label for="memory-txt03">나의일기</label></a>
                    <p><textarea id="AdtMyDiay" placeholder="나만의 일기를 작성해 보세요. (비공개)"></textarea></p>
                  </li>
                  <li>
                    <a href="#" class="sw-char"  onclick="memoryChk('memory-txt04',4); return false;">
                    <span class="icon-off-favorite">★</span>
                    <input type="checkbox" id="memory-txt04"  name ="memory-txt"  value="4">
                    <label for="memory-txt04">지도자상담</label></a>
                    <p><textarea id="AdtAdvice" placeholder="코치님 또는 감독님에게 하고 싶은 말을 입력하세요."></textarea></p>
                  </li>
                  <li>
                    <a href="#" class="sw-char"  onclick="memoryChk('memory-txt05',5); return false;">
                    <span class="icon-off-favorite">★</span>
                    <input type="checkbox" id="memory-txt05"  name ="memory-txt" value="5" >
                    <label for="memory-txt05">지도자답변</label></a>
                    <p><textarea id="AdtAdviceRe"></textarea></p>
                  </li>
                </ul>
            <%
        End If 
    SET LRs = Nothing
    Dbclose()
End If 
    
%>




