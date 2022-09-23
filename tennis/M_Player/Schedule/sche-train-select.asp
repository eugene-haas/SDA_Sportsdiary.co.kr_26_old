<!--#include file="../Library/ajax_config.asp"-->
<%
SportsGb 		=  Request.Cookies("SportsGb")
MemberIDX   	=  decode(Request.Cookies("MemberIDX"),0)
PlayerIDX   	=  decode(Request.Cookies("PlayerIDX"),0)
TrRerdDate        =  fInject(Request("TrRerdDate"))

IF  TrRerdDate= "" or SportsGb="" Then 	
	Response.Write "FALSE| checkDay "&checkDay
	Response.End
Else 
%>

<%
    SEQ = 0
    LSQL = "EXEC View_sche_calendar_modal '"&SportsGb&"',"&MemberIDX&","&PlayerIDX&",'"&TrRerdDate&"'"


    Set LRs = Dbcon.Execute(LSQL)
    IF Not (LRs.Eof Or LRs.Bof) Then 
    Do Until LRs.Eof 	

    IF SEQ <=0 and  LRs("title")<>"훈련불참"THEN 
    %>
            <section id="public-train" class="public-train">
             <h3 class="sub-title">공식훈련 내용</h3>
    <%
    END IF

    '훈련정보
    if LRs("title")="훈련참석(일부참석)" or LRs("title")="훈련참석(정상참석)" or LRs("title")="훈련계획" or LRs("title")="훈련불참" then   
    %> 
          <!-- S: modal-body -->
          <%
            cnt = 0
            nott= 0 
            TFPubCode=""
            ddTraiMIdNm =""

            CSQL = "EXEC View_sche_calendar_modal_detail '"&SportsGb&"',"&MemberIDX&","&PlayerIDX&",'"&TrRerdDate&"','공식훈련',''"
           ' Response.Write CSQL
           ' Response.end


            Set CRs = Dbcon.Execute(CSQL)
            IF Not (CRs.Eof Or CRs.Bof) Then 
            Do Until CRs.Eof 

            if TFPubCode <> CRs("TFPubCode") then
                TFPubCode=CRs("TFPubCode")
                cnt = 0 
                ddTraiMIdNm=""
             end if

             if cnt =0 then
                if cnt<>nott then 
                %>
                        </dd>
                    </dl>
                </div>
                <%
                nott=0
                end if 

             %>
            
             <div class="train-list">
              <h4><%=CRs("TFPubNm") %>(<%=CRs("TraiFistNm") %>)</h4>
              <dl class="clearfix">
                <dt>- 훈련장소&nbsp;:&nbsp; </dt>
                <dd><%=CRs("PceNm") %></dd>
             </dl>
             <dl class="clearfix">
                <dt>- 훈련시간&nbsp;:&nbsp; </dt>
                <dd><%=CRs("TOTHour") %></dd>
              </dl>
                <dl class="clearfix">
                  <dt>- 훈련유형&nbsp;:&nbsp; </dt>
                  <dd>
             <%
            end if

                if ddTraiMIdNm <>"" then 
                    ddTraiMIdNm =", &nbsp;" & CRs("TraiMIdNm")
                else
                     ddTraiMIdNm= CRs("TraiMIdNm")
                end if
                Response.Write  ddTraiMIdNm 

            cnt=cnt+1
            nott=nott+1
            CRs.MoveNext
            Loop 
            end if
            CRs.Close
            SET CRs = Nothing
            %>
                       </dd>
                    </dl>
                </div>
            </section>
    <%	
    '개인 훈련 정보
    elseif LRs("title")="개인훈련" then
     %>
           <section class="private-train">
            <h3 class="sub-title">개인훈련 내용</h3>
                <%
                        cnt = 0
                        nott= 0 
                        TFPubCode=""
                        ddTraiMIdNm =""

                        CSQL = "EXEC View_sche_calendar_modal_detail '"&SportsGb&"',"&MemberIDX&","&PlayerIDX&",'"&TrRerdDate&"','"&LRs("title")&"',''"
                        Set CRs = Dbcon.Execute(CSQL)
                        IF Not (CRs.Eof Or CRs.Bof) Then 
                        Do Until CRs.Eof 

                        
                        if TFPubCode <> CRs("TFPubCode") then
                            TFPubCode=CRs("TFPubCode")
                            cnt = 0 
                            ddTraiMIdNm=""
                         end if

                         if cnt =0 then
                            if cnt<>nott then 
                            %>
                                    </dd>
                                </dl>
                            </div>
                            <%
                            nott=0
                            end if
                            
                             %>
                             <div class="train-list">
                              <h4><%=CRs("TFPubNm") %>(<%=CRs("TraiFistNm") %>)</h4>
                              <dl class="clearfix">
                                <dt>- 훈련장소&nbsp;:&nbsp; </dt>
                                <dd><%=CRs("PceNm") %></dd>
                             </dl>
                             <dl class="clearfix">
                                <dt>- 훈련시간&nbsp;:&nbsp; </dt>
                                <dd><%=CRs("TrailHourNm") %></dd>
                              </dl>
                                <dl class="clearfix">
                                  <dt>- 훈련유형&nbsp;:&nbsp; </dt>
                                  <dd>
                             <%
                            end if

                            if ddTraiMIdNm <>"" then 
                                ddTraiMIdNm =", &nbsp;" & CRs("TraiMIdNm")
                            else
                                 ddTraiMIdNm= CRs("TraiMIdNm")
                            end if

                            Response.Write  ddTraiMIdNm 

                        
                        cnt=cnt+1
                        nott=nott+1
                        CRs.MoveNext
                        Loop 
                        end if
                        CRs.Close
                        SET CRs = Nothing
                  %>
                        </dd>
                    </dl>
                </div>
            </section>
    <%	
    end if
    SEQ =SEQ+1
    LRs.MoveNext
    Loop 
    end if
    LRs.Close
    SET LRs = Nothing
    Dbclose()

End If 
%>





