<!--#include file="../Library/ajax_config.asp"-->
<%
SportsGb 		=  Request.Cookies("SportsGb")
MemberIDX   	=  decode(Request.Cookies("MemberIDX"),0)
PlayerIDX   	=  decode(Request.Cookies("PlayerIDX"),0)
checkDay        =  fInject(Request("checkDay"))


IF  checkDay= "" or SportsGb="" Then 	
	Response.Write "FALSE| checkDay "&checkDay
	Response.End
Else 

    SEQ = 1
    LSQL = "EXEC View_sche_calendar_list '"&SportsGb&"',"&MemberIDX&","&PlayerIDX&",'"&checkDay&"'"
    Set LRs = Dbcon.Execute(LSQL)
    IF Not (LRs.Eof Or LRs.Bof) Then 
    Do Until LRs.Eof 	

    'var accordId = "accord" + now.getDate();
    'var holdId = "hold" + now.getDate();
    'var holdheader = "holdheader" + now.getDate();
    'var holdcontents = "holdcontents" + now.getDate();
    'var holdcontents_sub = "holdcontents_sub" + now.getDate();
    
 
    titleid=LRs("titleid")
    titleDay =LRs("titleDay")

    IF SEQ =1 THEN 
    %>
      <div class="accord">
        <a href=".hold<%=titleid %>" data-toggle="collapse" data-parent=".custom-accord">
           <div id ="holdheader<%=titleid %>" class="schedule-header sche-title">
              <h2><span><%=titleid %></span>일</h2>
            </div>
          </a>
     <div class="hold<%=titleid %> collapse">
    <%
    END IF

    '훈련정보
    if LRs("title")="훈련참석(일부참석)" or LRs("title")="훈련참석(정상참석)" or LRs("title")="훈련계획" or LRs("title")="훈련불참" then   
    %> 
            <%if LRs("title") = "훈련참석(정상참석)" then%>
                 <h5 class="tit-blue-radius">훈련</h5>
                 <h6 class="tit-graybox">
                  <i class="fa fa-check-circle" aria-hidden="true"></i>
                  <strong>훈련참석(정상참석)</strong>
                </h6>
            <%elseif LRs("title") = "훈련참석(일부참석)" then %>
                <h5 class="tit-blue-radius">훈련</h5>
                <h6 class="tit-graybox">
                  <i class="fa fa-check-circle" aria-hidden="true"></i>
                  <strong>훈련참석(일부참석)</strong>
                   <%if LRs("subtitle") <> "" then%>
                    <span>사유 : <%=LRs("subtitle")%></span>
                 <%end if %>
                </h6>
            <%elseif LRs("title") = "훈련계획" then %>
                <h5 class="tit-blue-radius">훈련</h5>
            <%elseif LRs("title") = "훈련불참" then %>
              <h5 class="tit-line-through">훈련</h5>
                <h6 class="tit-graybox">
                  <i class="fa fa-times-circle" aria-hidden="true"></i>
                  <strong>훈련불참</strong>
                   <%if LRs("subtitle") <> "" then%>
                        <span>  사유 : <%=LRs("subtitle")%>
                             <%if LRs("bigo") <> "" then%>
                                 ( <%=LRs("bigo")%> )
                            <%end if %>
                        </span>
                 <%end if %>
                </h6>
            <%end if %>
          <!-- S: modal-body -->
          <%
            cnt = 0
            nott= 0 
            TFPubCode=""
            CSQL = "EXEC View_sche_calendar_modal_detail '"&SportsGb&"',"&MemberIDX&","&PlayerIDX&",'"&titleDay&"','공식훈련',''"
            Set CRs = Dbcon.Execute(CSQL)
            IF Not (CRs.Eof Or CRs.Bof) Then 
            Do Until CRs.Eof 

            if TFPubCode <> CRs("TFPubCode") then
                TFPubCode=CRs("TFPubCode")
                cnt = 0 
             end if

             if cnt =0 then
                if cnt<>nott then 
                %>
                    </ul>
                    </dd>
                </dl>
                <%
                nott=0
                end if 
                
                dl_class=""
                if CRs("AdtInTp")="C" then 
                    dl_class =" disabled"
                end if

             %>
             <dl class="modal-train-list <%=dl_class %>">
                <dt><%=CRs("TFPubNm") %></dt>
              <dd>
                    <ul>
                        <li><%=CRs("PceNm") %></li>
                        <li class="<%=CRs("TraiFistNm_sub") %>">
                        <p><%=CRs("TraiFistNm") %></p>
                        <p><%=CRs("TrailHourNm") %></p>
                        </li>
             <%
            end if
                        %>
                            <li style="text-align: center">
                                <p style="text-align: center"><%=CRs("TraiMIdNm") %></p>
                                <p></p>
                            </li>
                        <% 

            cnt=cnt+1
            nott=nott+1
            CRs.MoveNext
            Loop 
            end if
            CRs.Close
            SET CRs = Nothing
            %>
                    </ul>
                </dd>
            </dl>
            <a href="../Train/train.asp" class="btn-modal-train"><span class="ic-modal-train"></span>훈련일지 상세보기</a>
       
    <%	
    '개인 훈련 정보
    elseif LRs("title")="개인훈련" then
     %>
            <h5 class="tit-orange-radius">개인</h5>
            <dl class="modal-train-list">
                <%
                        cnt = 0 
                        CSQL = "EXEC View_sche_calendar_modal_detail '"&SportsGb&"',"&MemberIDX&","&PlayerIDX&",'"&titleDay&"','"&LRs("title")&"',''"
                        Set CRs = Dbcon.Execute(CSQL)
                        IF Not (CRs.Eof Or CRs.Bof) Then 
                        Do Until CRs.Eof 

                        if cnt=0 then 
                        %>
                      <dt><%=CRs("TFPubNm") %></dt>
                      <dd>
                        <ul>
                         <li><%=CRs("PceNm") %></li>
                         <li class="<%=CRs("TraiFistNm_sub") %>">
                            <p><%=CRs("TraiFistNm") %></p>
                            <p><%=CRs("TrailHourNm") %></p>
                          </li>
                        <%
                        end if
                 %> 
                         <li style="text-align: center">
                            <p style="text-align: center"><%=CRs("TraiMIdNm") %></p>
                            <p></p>
                          </li>
                 <%
                        cnt=cnt+1
                        CRs.MoveNext
                        Loop 
                        end if
                        CRs.Close
                        SET CRs = Nothing
                  %>
                </ul>
              </dd>
            </dl>
    <%	
    '대회
     elseif LRs("className")="match" then
    %> 
            <h5 class="tit-marine-radius">대회</h5>
            <div class="tourney-info">
                <%
                        cnt = 0 
                        CSQL = "EXEC View_match_diary_title '"&SportsGb&"',"&MemberIDX&","&PlayerIDX&",'"&titleDay&"',"&LRs("id") &",''"
                        Set CRs = Dbcon.Execute(CSQL)
                        IF Not (CRs.Eof Or CRs.Bof) Then 
                        Do Until CRs.Eof 
                        if cnt = 0 then 
                        %>
                         <h6><%=CRs("GameTitleName") %></h6>
                        <%
                        end if
                        %>
                        <p>
                                <%
                                MedelNm =""
                                MedelNmclass=""
                                if CRs("roundNm")<= 4 then 
                                    if  CRs("MedelNm") ="금메달" then 
                                        MedelNmclass ="medal gold"
                                        MedelNm="금메달"
                                    elseif  CRs("MedelNm") ="은메달" then 
                                        MedelNmclass ="medal silver"
                                        MedelNm="은메달"
                                    elseif  CRs("MedelNm") ="동메달" then 
                                        MedelNmclass ="medal bronze"
                                        MedelNm="동메달"
                                    else
                                        if  CRs("roundNm") <=2  and CRs("Round")& ""<>"" then
                                            MedelNmclass ="medal"
                                            MedelNm="결승전"
                                        else
                                            MedelNmclass ="medal"
                                            MedelNm="4강"
                                        end if 
                                    end if
                                else
                                   MedelNmclass ="medal"
                                   MedelNm=CRs("roundNm")  & "강"
                                end if 
                                %>
                            <span class="<%=MedelNmclass %>"><%=MedelNm %></span>
                            <span><%=CRs("GroupGameGbNM") %></span>
                            <span><%=CRs("TeamGbNm") %></span>
                            <span><%=CRs("SexNm") %> &nbsp;<%=CRs("LevelNm") %></span>
                        </p>
                 <%
                        cnt=cnt+1
                        CRs.MoveNext
                        Loop 
                        end if
                        CRs.Close
                        SET CRs = Nothing

                         if cnt = 0 then 
                                CSQL = "EXEC View_institute_search '"&SportsGb&"',"&PlayerIDX&","&MemberIDX&","&LRs("id") 
                                Set CRs = Dbcon.Execute(CSQL)
                                IF Not (CRs.Eof Or CRs.Bof) Then 
                                Do Until CRs.Eof 
                                %> 
                                <div class="sche-title">
                                  <h2><%=CRs("GameTitleName") %></h2>

                                 </div>
                                    <dl class="schedule-item">
                                        <dt class="place"><span class="icon"></span>장소</dt>
                                        <dd><p class="match-term"><%=CRs("GameArea") %> </p></dd>
                                    </dl>
                                        <dl class="schedule-item">
                                            <dt class="term"><span class="icon"></span>기간</dt>
                                            <dd> 
                                                <p class="match-term">
                                                <%=CRs("GameSyy") %>년 <%=CRs("GameSmm") %>월 <%=CRs("GameSdd") %>일 (<%=CRs("GameSName") %>)
                                                ~
                                                <% if  CRs("GameSyy") <> CRs("GameEyy") then  %>
                                                <%=CRs("GameEyy") %>년
                                                <% end if %>
                                                    <% if  CRs("GameSmm") <> CRs("GameEmm") then  %>
                                                    <%=CRs("GameEmm") %>월
                                                <% end if %>
                                                <%=CRs("GameESdd") %>일 (<%=CRs("GameEName") %>)
                                                </p>
                                             </dd>
                                        </dl>
                               <%
                                CRs.MoveNext
                                Loop 
                                end if
                                CRs.Close
                                SET CRs = Nothing
                         ELSE
                    %>
          
                    <a href="sche-match.asp" class="btn-modal-match"><span class="ic-modal-match"></span>대회일지 상세보기</a>
               <%	 end if
            %>
             </div>
            <%
    '체력훈련
     elseif LRs("title")="체력측정" then
    %> 
        <h5 class="tit-green-radius">체력</h5>
        <dl class="modal-strength-list">
        <%
            StimFistNm=""
            FistS =0  
            CSQL = "EXEC View_sche_calendar_modal_detail '"&SportsGb&"',"&MemberIDX&","&PlayerIDX&",'"&titleDay&"','"&LRs("title")&"',''"
            Set CRs = Dbcon.Execute(CSQL)
            IF Not (CRs.Eof Or CRs.Bof) Then 
            Do Until CRs.Eof 
            	
            if StimFistNm <> CRs("StimFistNm") then
                    FistS =0  
            end if
            StimFistNm	    =CRs("StimFistNm")

            if FistS= 0 then 
            %>
                <dt><%=StimFistNm %></dt>
            <%
            end if
            %>
             <dd>
                ○&nbsp;<%=CRs("StimMidNm") %>  &nbsp; : &nbsp;<%=CRs("StimData") %>  <%=CRs("StimMidUnit") %>&emsp;
             </dd>
            <%
            FistS=FistS+1
            CRs.MoveNext
            Loop 
            end if
            CRs.Close
            SET CRs = Nothing
         %>
        </dl>
        <a href="../Strength/index.asp" target="blank" class="btn-modal-strength">
            <span class="ic-modal-strength"></span>체력측정 상세보기
        </a>
    <%	
    end if

    
    IF SEQ=LRs("cnt")  THEN 
    %>
        </div>
      </div>
    <%
    SEQ =1
    else
    SEQ =SEQ+1
    END IF

    LRs.MoveNext
    Loop 
    end if
    LRs.Close
    SET LRs = Nothing
    Dbclose()
%>
            </div>
            <!-- E: modal-body -->
        </div>
    <div class="modal-footer">
    <button type="button" class="btn btn-gray" data-dismiss="modal">닫기</button>
    </div>
</div>
<%
End If 
%>





