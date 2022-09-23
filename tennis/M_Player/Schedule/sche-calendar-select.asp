<!--#include file="../Library/ajax_config.asp"-->
<%
SportsGb 		=  Request.Cookies("SportsGb")
MemberIDX   	=  decode(Request.Cookies("MemberIDX"),0)
PlayerIDX   	=  decode(Request.Cookies("PlayerIDX"),0)
checkDay        =  fInject(Request("checkDay"))
idx              =  fInject(Request("idx"))
Crs_color        =  fInject(Request("Crs_color"))
PlayerReln      =  decode(Request.Cookies("PlayerReln"),0)


IF  checkDay= "" or SportsGb="" Then 	
	Response.Write "FALSE| checkDay "&checkDay
	Response.End
Else 
%>

<%
    SEQ = 0
    LSQL = "EXEC View_sche_calendar_modal '"&SportsGb&"','"&MemberIDX&"','"&PlayerIDX&"','"&checkDay&"'"
   ' Response.Write  LSQL
   ' Response.End
    Set LRs = Dbcon.Execute(LSQL)
    IF Not (LRs.Eof Or LRs.Bof) Then 
    Do Until LRs.Eof 	

    IF SEQ <=0 THEN 
    %>
    <div class="modal-content">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title"><%=FormatDateTime(checkDay, 1)    %></h4>
    </div>
     <div class="modal-schedule">
      <div class="modal-body">
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
                SQL = "EXEC View_sche_calendar_modal_detail '"&SportsGb&"','"&MemberIDX&"','"&PlayerIDX&"','"&checkDay&"','공식훈련',''"
               
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
                     <span> <%=Rs("TFPubNm")%> : <%=AdtInTp_nm %>/<%=Rs("AdtMIdNm_1")%>
                     <%
                        if Rs("AdtMidCd_1") = 1 or Rs("AdtMidCd_1") = 2 then 
                            Response.Write "<strong> ( 부위 : "
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

                            Response.Write " ) </strong>"	
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
            CSQL = "EXEC View_sche_calendar_modal_detail '"&SportsGb&"','"&MemberIDX&"','"&PlayerIDX&"','"&checkDay&"','공식훈련',''"

           ' Response.Write CSQL
            Set CRs = Dbcon.Execute(CSQL)
            IF Not (CRs.Eof Or CRs.Bof) Then 
            Do Until CRs.Eof 

             teamchek = CRs("CHEK")

            if TFPubCode <> CRs("TFPubCode") then
                if nott>0 then 
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

                TFPubCode=CRs("TFPubCode")
                cnt = 0 

                 %> 
                 <dl class="modal-train-list <%=dl_class %>">
                    <dt><%=CRs("TFPubNm") %></dt>
                    <dd>
                        <ul> 
                            <li><%=CRs("PceNm") %></li>
                            <li class="<%=CRs("TraiFistNm_sub") %>">
                            <p><%=CRs("TraiFistNm") %></p>
                            <p>
                                <% 
                                  if teamchek="Y" then
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
                if PlayerReln ="" or PlayerReln="R" or PlayerReln="K" then
                    if Csql_TrRerdIDX = "0" then
                 %>
                 <a href="../Train/train.asp?TrRerdDate=<%=checkDay %>" class="btn-modal-train"><span class="ic-modal-train"></span>훈련일지 작성하러 가기</a>
                 <%
                    else
                  %>
                   <a href="sche-train.asp?TrRerdDate=<%=checkDay %>" class="btn-modal-train"><span class="ic-modal-train"></span>훈련일지 상세보기</a>
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
                        CSQL = "EXEC View_sche_calendar_modal_detail '"&SportsGb&"','"&MemberIDX&"','"&PlayerIDX&"','"&checkDay&"','"&LRs("title")&"',''"
                        
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
     Crs_color="#42c7db"
    %> 
            <h5 class="tit-marine-radius" style="background-color:<%=Crs_color %>">대회</h5>
            <div class="tourney-info game-sche">
                <%
                        '
                        cnt = 0 
                        CSQL = "EXEC View_match_diary_title '"&SportsGb&"','"&MemberIDX&"','"&PlayerIDX&"','','"&LRs("id")&"',''"
           
                        Set CRs = Dbcon.Execute(CSQL)
                        IF Not (CRs.Eof Or CRs.Bof) Then 
                        Do Until CRs.Eof 

                         Crs_color=CRs("color")
                        if cnt = 0 then 
                        %>
                         <h6 style="background-color:<%=Crs_color %>"><%=CRs("GameTitleName") %></h6>
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
                        'Crs_color=CRs("color")
                        cnt=cnt+1
                        CRs.MoveNext
                        Loop 
                        end if
                        CRs.Close
                        SET CRs = Nothing

                         if cnt = 0 then 
                                CSQL = "EXEC View_institute_search '"&SportsGb&"','"&MemberIDX&"','"&PlayerIDX&"',"&LRs("id") 
                                Set CRs = Dbcon.Execute(CSQL)
                                IF Not (CRs.Eof Or CRs.Bof) Then 
                                Do Until CRs.Eof 
                                'Crs_color=CRs("color")
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
          
                    
               <%	 end if

                if PlayerReln ="" or PlayerReln="R" or PlayerReln="K" then
                %>

                 </div><a href="sche-match.asp?GameTitleIDX=<%=idx %>" class="btn-modal-match" style="background-color:<%=Crs_color %>"><span class="ic-modal-match"></span>대회일지 상세보기</a>
                <%

                end if
    '체력훈련
     elseif LRs("title")="체력측정" then
    %> 
        <h5 class="tit-green-radius">체력</h5>
        <dl class="modal-strength-list">
        <%
            StimFistNm=""
            FistS =0  
            CSQL = "EXEC View_sche_calendar_modal_detail '"&SportsGb&"','"&MemberIDX&"','"&PlayerIDX&"','"&checkDay&"','"&LRs("title")&"',''"
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
        <a href="../Strength/index.asp?TrRerdDate=<%=checkDay %>" class="btn-modal-strength">
            <span class="ic-modal-strength"></span>체력측정 상세보기
        </a>
    <%	
        end if
    end if
    SEQ =SEQ+1
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





