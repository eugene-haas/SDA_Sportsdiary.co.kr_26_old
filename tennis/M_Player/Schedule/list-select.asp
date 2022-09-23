<!--#include file="../Library/ajax_config.asp"-->
<%
SportsGb 		=  Request.Cookies("SportsGb")
MemberIDX   	=  decode(Request.Cookies("MemberIDX"),0)
PlayerIDX   	=  decode(Request.Cookies("PlayerIDX"),0)
checkDay        =  fInject(Request("checkDay"))
PlayerReln      =  decode(Request.Cookies("PlayerReln"),0)


IF  checkDay= "" or SportsGb="" Then 	
	Response.Write "FALSE| checkDay "&checkDay
	Response.End
Else 

    SEQ = 1
    LSQL = "EXEC View_sche_calendar_list '"&SportsGb&"','"&MemberIDX&"','"&PlayerIDX&"','"&checkDay&"'"
   ' Response.Write LSQL
    'Response.end

    Set LRs = Dbcon.Execute(LSQL)
    IF Not (LRs.Eof Or LRs.Bof) Then 
    Do Until LRs.Eof 	

    titleid=LRs("titleid")
    titleDay =LRs("titleDay")
    holdheaderid ="holdheader"&titleid
    IF SEQ =1 THEN 
    %>
      <div class="accord panel">
        <a href=".hold<%=titleid %>" data-toggle="collapse" data-parent=".custom-accord" tabindex='0'>
         <div id ="<%=holdheaderid %>" class="schedule-header sche-title"   >
              <h2><span><%=titleid %></span>일</h2>
              <span class="icon"><span class="caret"></span></span>
          </div>
        </a>
         <div class="hold<%=titleid %> collapse">
            <div class="hold">
    <%
    END IF
 
 
    '훈련정보
    if LRs("title")="훈련참석(일부참석)" or LRs("title")="훈련참석(정상참석)" or LRs("title")="훈련계획" or LRs("title")="훈련불참"or LRs("title")="훈련종료" then   
    %> 
            <%if LRs("title") = "훈련참석(정상참석)" then%>
                 <h5 class="tit-blue-radius">훈련</h5>
                 <h6 class="tit-graybox">
                  <i class="fa fa-check-circle" aria-hidden="true"></i>
                  <strong>훈련참석(정상참석)</strong>
            <%elseif LRs("title") = "훈련참석(일부참석)" then %>
                <h5 class="tit-blue-radius">훈련</h5>
                <h6 class="tit-graybox">
                  <i class="fa fa-check-circle" aria-hidden="true"></i>
                  <strong>훈련참석(일부참석)</strong>
            <%elseif LRs("title") = "훈련계획" then %>
                <h5 class="tit-blue-radius">훈련</h5>
                <h6 class="tit-graybox">
            <%elseif LRs("title") = "훈련종료" then %>
                <h5 class="tit-blue-radius">훈련</h5>
                <h6 class="tit-graybox">
            <%elseif LRs("title") = "훈련불참" then %>
              <h5 class="tit-line-through">훈련</h5>
                <h6 class="tit-graybox">
                  <i class="fa fa-times-circle" aria-hidden="true"></i>
                  <strong>훈련불참</strong>
            <%end if 

                TFPubNm_1 =""
                SQL = "EXEC View_sche_calendar_modal_detail '"&SportsGb&"','"&MemberIDX&"','"&PlayerIDX&"','"&LRs("titleDay")&"','공식훈련',''"

                Set Rs = Dbcon.Execute(SQL)
                IF Not (Rs.Eof Or Rs.Bof) Then 
                Do Until Rs.Eof 	

                if TFPubNm_1 <> Rs("TFPubNm") then
                    TFPubNm_1 = Rs("TFPubNm")
                     if Rs("AdtInTp_1") = "A" then 
                      AdtInTp_nm = "참석"
                     end if 

                    if Rs("AdtInTp_1") = "B" then 
                        AdtInTp_nm = "일부참석"
                    else 
                        AdtInTp_nm = "불참"
                    end if 

                    if Rs("AdtInTp_1") <> "A" then
                    %>
                    <span><%=Rs("TFPubNm")%> : <%=AdtInTp_nm %>/<%=Rs("AdtMIdNm_1")%>
                    <%
                        if Rs("AdtMidCd_1") = 1 or Rs("AdtMidCd_1") = 2 then 
                            Response.Write " ( 부위 : "
                            if Rs("CHEK") ="Y" then 
                                 RSQL = "select  JRPubCode ,JRPubNm  from tblSvcTrTramPlayerJury "
                                 RSQL =RSQL&" where TrRerdTeamIDX='"&Rs("TrRerdTeamIDX")&"' "
                                 RSQL =RSQL&" and SportsGb='"&SportsGb&"'and DelYN='N'"
                                 RSQL =RSQL&" and TFPubCode='"&Rs("TFPubCode")&"'"
                                 RSQL =RSQL&" and PlayerIDX='"&PlayerIDX&"'" 
                                 RSQL =RSQL&" group by  JRPubCode ,JRPubNm " 
                            else
                                 RSQL = " select a.TrRerdIDX,a.JRPubCode,b.PubName JRPubNm " 
                                 RSQL =RSQL&" from tblSvcTrRerdJury a" 
                                 RSQL =RSQL&" inner join tblPubCode b "
                                 RSQL =RSQL&" on a.JRPubCode = b.PubCode" 
                                 RSQL =RSQL&"   and a.TrRerdIDX='"&Rs("TrRerdIDX")&"'"
                                 RSQL =RSQL&" and a.DelYN ='N' and b.DelYN='N'"
                                 RSQL =RSQL&" group by   a.TrRerdIDX,a.JRPubCode,b.PubName"
                                 RSQL =RSQL&" order by  a.TrRerdIDX,a.JRPubCode" 
                            end if

                            'response.Write RSQL
                            Set uRs = Dbcon.Execute(RSQL)
                            IF Not (uRs.Eof Or uRs.Bof) Then 
                            Do Until uRs.Eof 	
                            Response.Write uRs("JRPubNm")	
                            uRs.MoveNext
                            Loop 
                            end if
                            uRs.Close
                            SET uRs = Nothing

                            Response.Write " ) "
                       end if
                     %>
                    </span>
                   <%
                   else
                        if Rs("TOTHour")<>"0시간"then
                        %>
                        <span  style="color: #0066FF"><%=Rs("TFPubNm")%> : 정상참석 </span> 
                        <%
                        else
                        %>
                        
                        <%
                        end if
                    end if
                end if
                Rs.MoveNext
                Loop 
                end if
                Rs.Close
                SET Rs = Nothing
             %>
           </h6>
          <!-- S: modal-body -->
          <%
            cnt = 0
            nott= 0 
            TFPubCode=""
            Csql_TrRerdIDX="0"
            teamchek="N"
            CSQL = "EXEC View_sche_calendar_modal_detail '"&SportsGb&"','"&MemberIDX&"','"&PlayerIDX&"','"&titleDay&"','공식훈련',''"
            Set CRs = Dbcon.Execute(CSQL)
            'Response.Write CSQL
            IF Not (CRs.Eof Or CRs.Bof) Then 
            Do Until CRs.Eof 

            if TFPubCode <> CRs("TFPubCode") then
                TFPubCode=CRs("TFPubCode")
                cnt = 0 
             end if

             teamchek = CRs("CHEK")

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
                if CRs("AdtInTp_1")="C" then 
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
                        <p>
                            <% if teamchek="Y" then
                                    if CRs("TOTHour") ="0시간" then 
                                     %>
                                        <span><%=CRs("TFP_Ftime") %> ~ <%= CRs("TFP_Ttime") %></span>
                                        <%
                                    else
                                     %>
                                        <span><%=CRs("TOTHour") %> </span>
                                        <%
                                    end if
                                        
                                else
                                 %>
                                    <span><%=CRs("TOTHour") %> </span>
                                    <%
                             end if
                            %>
                        </p>
                        </li>
             <%
            end if

                        %>
                            <li style="text-align: center">
                                <p style="text-align: center"><%=CRs("TraiMIdNm") %></p>
                                <p> 
                                <%
                                 if teamchek="Y" then
                                 
                                     if CRs("TrailHourNm")="0시간" then 
                                     
                                            IF CRs("TraiCount") <>"0" Then 
                                            %>
                                            <span><%=CRs("TraiCount") %> 개/분</span>
                                            <%
                                            end if
                                         %>
                                         <%
                                            IF CRs("TraiSet") <>"0" Then 
                                                IF CRs("TraiCount") <>"0" Then 
                                                %>
                                                <span>X</span>
                                                <%
                                                end if
                                                %>
                                            <span><%=CRs("TraiSet") %> SET</span> 
                                            <%
                                            end if

                                     else 
                                            %>
                                            <span><%=CRs("TrailHourNm") %></span>
                                            <%

                                     end if
                                 
                                 

                                    end if
                                 %>
                                
                                
                                </p>
                            </li>
                        <% 
            teamchek = CRs("CHEK") 
             Csql_TrRerdIDX=  CRs("TrRerdIDX")
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
            <%
            titleDaystr =left(titleDay,4)&"-"&mid(titleDay,5,2)&"-"&right(titleDay,2)
             %>
              <%
              if PlayerReln ="" or PlayerReln="R" or PlayerReln="K" then
                if Csql_TrRerdIDX = "0" then
                 %> <a href="../Train/train.asp?TrRerdDate=<%=titleDaystr %>" class="btn-modal-train"><span class="ic-modal-train"></span>훈련일지 작성하러 가기</a>
                 <%
                    else
                  %>
                  <a href="sche-train.asp?TrRerdDate=<%=titleDaystr %>" class="btn-modal-train"><span class="ic-modal-train"></span>훈련일지 상세보기</a>
                 <%
                    end if
                end if
              %>

            
    <%	
    '개인 훈련 정보
    elseif LRs("title")="개인훈련" then
     %>
            <h5 class="tit-orange-radius">개인</h5>
            <dl class="modal-train-list">
                <%
                        cnt = 0 
                        CSQL = "EXEC View_sche_calendar_modal_detail '"&SportsGb&"','"&MemberIDX&"','"&PlayerIDX&"','"&titleDay&"','"&LRs("title")&"',''"
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
                        CSQL = "EXEC View_match_diary_title '"&SportsGb&"','"&MemberIDX&"','"&PlayerIDX&"','',"&LRs("id") &",''"
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
                                CSQL = "EXEC View_institute_search '"&SportsGb&"','"&PlayerIDX&"','"&MemberIDX&"',"&LRs("id") 
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

                            if PlayerReln ="" or PlayerReln="R" or PlayerReln="K" then
                            %>
          
                            <a href="sche-match.asp?GameTitleIDX='<%=LRs("id") %>'" class="btn-modal-match"><span class="ic-modal-match"></span>대회일지 상세보기</a>
                       <%	 end if
                       end if
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
            CSQL = "EXEC View_sche_calendar_modal_detail '"&SportsGb&"','"&MemberIDX&"','"&PlayerIDX&"','"&titleDay&"','"&LRs("title")&"',''"

            'Response.Write  CSQL

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
        <%
        if PlayerReln ="" or PlayerReln="R" or PlayerReln="K" then
         %>
        <a href="../Strength/index.asp?TrRerdDate=<%=titleDay %>"   class="btn-modal-strength">
            <span class="ic-modal-strength"></span>체력측정 상세보기
        </a>
    <%	
        end if
    end if
    
    IF SEQ=LRs("cnt")  THEN 
    %>
            </div>
        </div>
      </div>
    <%
    SEQ =1
    else
    SEQ =SEQ+1
    END IF

    LRs.MoveNext
    Loop 
    else
    Response.Write " <span>일정이 없습니다. </span>"
    end if
    LRs.Close
    SET LRs = Nothing
    Dbclose()
%>


<%
End If 
%>





