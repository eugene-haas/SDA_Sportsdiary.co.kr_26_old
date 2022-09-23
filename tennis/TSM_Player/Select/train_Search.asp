<!--#include file="../Library/ajax_config.asp"-->
<%
SportsGb 		=  Request.Cookies("SportsGb")
Sex 		    =  Request.Cookies("Sex")
EnterType 		=  Request.Cookies("EnterType")
PlayerReln      =  decode(Request.Cookies("PlayerReln"),0)

MemberIDX   	=  decode(Request.Cookies("MemberIDX"),0)
PlayerIDX   	=  decode(Request.Cookies("PlayerIDX"),0)
id              = fInject(Request("id"))
TrRerdDate      = fInject(Request("TrRerdDate"))

p_TrRerdIDX	 = fInject(Request("p_TrRerdIDX"))	
p_MentlCd	 = fInject(Request("p_MentlCd"))	

p_AdtFistCd	 = fInject(Request("p_AdtFistCd"))	
p_AdtInTp	 = fInject(Request("p_AdtInTp"))	
p_AdtMidCd  = fInject(Request("p_AdtMidCd"))
p_AdtMidCd1  = fInject(Request("p_AdtMidCd1"))		

p_AdtWell	 = ReplaceTagReText(fInject(Request("p_AdtWell")))	
p_AdtNotWell = ReplaceTagReText(fInject(Request("p_AdtNotWell")))
p_AdtMyDiay = ReplaceTagReText(fInject(Request("p_AdtMyDiay")))	
p_AdtAdvice	 = ReplaceTagReText(fInject(Request("p_AdtAdvice")))	
p_AdtAdviceRe	 = ReplaceTagReText(fInject(Request("p_AdtAdviceRe")))

p_AdtWellCkYn	 = fInject(Request("p_AdtWellCkYn"))	
p_AdtNotWellCkYn	 = fInject(Request("p_AdtNotWellCkYn"))	
p_AdtMyDiayCklYn	 = fInject(Request("p_AdtMyDiayCklYn"))	
p_AdtAdviceCkYn	 = fInject(Request("p_AdtAdviceCkYn"))	
p_AdtAdviceReCkYn	 = fInject(Request("p_AdtAdviceReCkYn"))	

p_TEAMTRAI	 = fInject(Request("p_TEAMTRAI"))	



IF MemberIDX = "" or TrRerdDate="" Then 	
	Response.Write "FALSE"
	Response.End
Else 
        
        '권한설정
        
        if PlayerReln="A" or PlayerReln="B"or PlayerReln="Z" then 
            PlayerDis="Y"
            if p_AdtMyDiay<>"" then
                p_AdtMyDiay="비공개 내용입니다."
            end if
            PlayerReadonly="readonly"
            Playerdisabled="disabled"
        end if 


        ''일지정보 start
       if id ="condition" then 
            '심리적상태
            LSQL = "EXEC View_train '"&SportsGb&"' , "&MemberIDX&",'"&TrRerdDate&"','"&p_TrRerdIDX&"','"&id&"'"
            Set LRs = Dbcon.Execute(LSQL)
            IF Not (LRs.Eof Or LRs.Bof) Then 
            %>
            <select id="condition" >
                <option value=0 selected>:: 심리적상태 선택 ::</option>
            <%
            Do Until LRs.Eof 
               
            %> 
               <option value="<%=LRs("MentlCd") %>"  
               <%  
                     if LRs("CHEK") ="Y" then
                        %>selected="selected"<%
                    end if
               %>  
                ><%=LRs("MentlNm") %></option>
            <%
            LRs.MoveNext
            Loop 
            end if
            LRs.Close
            %> </select><%
        End If 

         ''불참정보 start
       if id ="train-check01-select" OR id ="train-check02-select" then 

            LSQL = "EXEC View_train '"&SportsGb&"' , "&MemberIDX&",'"&TrRerdDate&"','"&p_TrRerdIDX&"','"&id&"'"
            'Response.Write  LSQL
            'Response.end

            Set LRs = Dbcon.Execute(LSQL)
            IF Not (LRs.Eof Or LRs.Bof) Then 
            %>
           
           <!-- <select id="<%=id %>" name="<%=id %>" class="train-select  >-->
            <%
            Do Until LRs.Eof 
            %> 
               <option value="<%=LRs("AdtMidCd") %>"  
               <%  
                     if LRs("CHEK") ="Y" then
                        %>selected="selected"<%
                    end if
               %>  
                ><%=LRs("AdtMIdNm") %></option>
            <%
            LRs.MoveNext
            Loop 
            end if
            LRs.Close
            %><!-- </select>--><%
        End If 

        '훈련목표
       if id ="train-goal-list" then 
       i=1
        %> 
        <ul id="train-goal-list"class="train-goal-list">
        <%
            LSQL = "EXEC View_train '"&SportsGb&"' , "&MemberIDX&",'"&TrRerdDate&"','"&p_TrRerdIDX&"','"&id&"'"
            Set LRs = Dbcon.Execute(LSQL)
            IF Not (LRs.Eof Or LRs.Bof) Then 
            Do Until LRs.Eof 
            %> 
                <li><input id="train-goal<%=i %>" type="checkbox" name="train-goal-list" value="<%=LRs("TgtCd") %>"  
                <%  
                    if LRs("CHEK") ="Y" then
                 %>
                        checked="checked" 
                <%
                    end if
               %>  
                /> 
                        <label for="train-goal<%=i %>"><%=LRs("TgtNm")%></label>
                 </li>
            <%
            i=i+1
            LRs.MoveNext
            Loop 
            end if
            LRs.Close
            %> </ul><%
        End If 

        '부상부위
        if id ="injury-chk" then 
            LSQL = "EXEC View_train '"&SportsGb&"' , "&MemberIDX&",'"&TrRerdDate&"','"&p_TrRerdIDX&"','"&id&"'"
            Set LRs = Dbcon.Execute(LSQL)
            retext =  "["
            IF Not (LRs.Eof Or LRs.Bof) Then 
            Do Until LRs.Eof 
            IF Sex ="Man" THEN 
            url="images/stats/injury/"
            ELSE
            url="images/stats/injury/girl"
            END IF

            injury_Img_url      =url
            injury_PubCode		=LRs("PubCode") 
            injury_PubName		=LRs("PubName") 
            injury_CHEK		    =LRs("CHEK") 

            retext = retext&"{""injury_PubCode"":"""&injury_PubCode&""",""injury_PubName"":"""&injury_PubName&""",""injury_CHEK"":"""&injury_CHEK&""",""injury_Img_url"":"""&injury_Img_url&"""},"
            LRs.MoveNext
            Loop 
            end if
            LRs.Close
            retext = Mid(retext, 1, len(retext) - 1)
            retext = retext&"]"
            Response.Write  retext
        End If 
    ''공식훈련
         if id ="official-train-wrap" then 
           %>
             <!-- onclick="officialtrainClick(); return false;"-->
                         <!-- onclick="officialtrainDel(); return false;"-->
           <div id="official-train-wrap">
           <%
                team_class=""
                style_none="style=display:none"
                style="hidden"
                bg_name="새벽훈련"
                MAXSEQ =4
                forseq = 2 
                disabledSTR=""
                disabledSTR_s=""
                'disabledSTR_s="disabled='disabled'"

                LSQL = "EXEC View_train '"&SportsGb&"',"&MemberIDX&",'"&TrRerdDate&"','"&p_TrRerdIDX&"','official-train-wrap-CHEK'"&i

               ' Response.Write LSQL
               ' Response.end

                Set LRs = Dbcon.Execute(LSQL)
                IF Not (LRs.Eof Or LRs.Bof) Then 
                Do Until LRs.Eof 

                'forseq =LRs("CNT")

                    TEAMTRAI =LRs("TEAMTRAI")

                    IF p_TEAMTRAI ="Y" THEN

                     disabledSTR=""
                     team_class="lock"
                     'MAXSEQ=forseq
                    END IF

                    if PlayerDis="Y" then
                        team_class="lock"
                        disabledSTR="disabled='disabled'"
                    end if

                LRs.MoveNext
                Loop 
                end if
                LRs.Close

                For i =1 to MAXSEQ step 1
                    officialtrainwrap = "official-train-wrap"&i
                    classonof="on"

                    if i > forseq then 
                        classonof="off"
                    else
                        classonof="on"
                    end if 

                    %>

                    
                <%'IF i<MAXSEQ  THEN %>
                    <a id="official-train-P<%=i %>" class="btn-navyline <%=team_class %>" <%=disabledSTR %>
                        <% 
                        IF p_TEAMTRAI ="Y" THEN
                               ' Response.Write style_none
                        end if
                        %>
                        >
                        <% 
                        IF i=1 THEN  
                            bg_name="새벽훈련" 
                            Response.Write "새벽훈련" 
                        END IF  
                        IF i=2 THEN  
                            bg_name="오전훈련" 
                            Response.Write "오전훈련" 
                        END IF  
                        IF i=3 THEN  
                            bg_name="오후훈련" 
                            Response.Write "오후훈련" 
                        END IF  
                        IF i=4 THEN  
                            bg_name="야간훈련" 
                            Response.Write "야간훈련" 
                        END IF  
                         %> 
                    입력하기 <span class="txt-or">+</span></a>
                <%'END IF %>
                 <div id="<%=officialtrainwrap %>" class="official-train-wrap"  name="<%=officialtrainwrap %>-<%=classonof %>" >
                    <div class="official-train">
                        <h2> <%=bg_name  %>
                        <% 
                            IF p_TEAMTRAI ="Y" THEN
                                Response.Write " <span class=''>＊지도자 관리훈련＊ </span>" 
                            end if
                        %>
                        </h2>
                         
                         <a href="#" class="del-train-btn" 
                         <% 
                            IF p_TEAMTRAI ="Y" THEN
                                Response.Write style_none
                            end if
                        %> >
                        <span><i class="fa fa-trash-o" aria-hidden="true"></i></span>훈련삭제</a>
                    </div>
                    <div class="bg-navy" <%=style %>>
                    <select id="bg-navy<%=i %>" class="<%=team_class %>"  onchange="bgnavyChange(<%=i %>);" <%=disabledSTR_s %>>
                         <% 
                        IF p_TEAMTRAI <>"Y" THEN
                            %>
                         <option value="0">훈련구분을 선택하세요</option>
                            <%
                        end if
                        LSQL = "EXEC View_train  '"&SportsGb&"' , "&MemberIDX&",'"&TrRerdDate&"','"&p_TrRerdIDX&"','bg-navy',"&i
                        'Response.Write LSQL
                        'Response.end
                        seqbg=0
                        Set LRs = Dbcon.Execute(LSQL)
                        IF Not (LRs.Eof Or LRs.Bof) Then 
                        Do Until LRs.Eof 
                        %>
                        <option value="<%=LRs("PubCode") %>" 
                            <%  seqbg=seqbg+1
                            if seqbg =i then
                            %>selected="selected" <%=disabledSTR %>
                            <% end if %> > <%=LRs("PubName") %>
                            </option>
                        <%
                        LRs.MoveNext
                        Loop 
                        end if
                        LRs.Close
                        %>
                    </select>
                    </div>
                    <ul class="official-train-select">
                    <li>
                        <select id="PceCd<%=i %>"  class="<%=team_class %>" <%=disabledSTR %>>
                        <option value="0" >훈련장소</option>
                            <%
                            LSQL = "EXEC View_train  '"&SportsGb&"' , "&MemberIDX&",'"&TrRerdDate&"','"&p_TrRerdIDX&"','PceCd',"&i
                            
                       ' Response.Write LSQL
                       ' Response.end


                            Set LRs = Dbcon.Execute(LSQL)
                            IF Not (LRs.Eof Or LRs.Bof) Then 
                                Do Until LRs.Eof 
                                %>
                                <option value="<%=LRs("PceCd") %>"
                                        <%  
                                    if LRs("CHEK") ="Y" then
                                    %>
                                    selected="selected"
                                    <%
                                    end if
                                    %>  
                                ><%=LRs("PceNm") %>
                                </option>
                                <%
                                LRs.MoveNext
                                Loop 
                            end if
                            LRs.Close
                            %>
                        </select>
                    </li>
                            <%
                            PTotHour=0
                            Phour= 0
                            Pmin= 0
                            LSQL = "EXEC View_train  '"&SportsGb&"' , "&MemberIDX&",'"&TrRerdDate&"','"&p_TrRerdIDX&"','TrailHour_tot',"&i
                           ' response.Write   LSQL
                           ' response.End

                            Set LRs = Dbcon.Execute(LSQL)
                            IF Not (LRs.Eof Or LRs.Bof) Then 
                          
						    Do Until LRs.Eof 
                                PTotHour=LRs("TraiHour")
                                Phour=LRs("H_TraiHour")
                                Pmin=LRs("M_TraiHour")
                            LRs.MoveNext
                            Loop 
                            end if
                            LRs.Close
                            %>
                       <li class="train-col-3 train-time"> 
                            <p>훈련시간</p>
                            <select id="TrailHour<%=i %>Hour"  class="<%=team_class %>" <%=disabledSTR %>>
                               <%
                               StrTimeNm = "0시간"
                                    for Ph= 0 to 360 step 60
                                        if Ph <> 0 then 
                                            StrTimeNm=(Ph/60)&"시간"
                                        end if
                                        
                                        if Phour=Ph then 
                                            %>  <option value="<%=Ph %>" selected><%=StrTimeNm %></option> <%
                                        else
                                            %>  <option value='<%=Ph %>'><%=StrTimeNm %></option> <%
                                        end if
                                    
                                    next 
                                %>
                            </select>
                            <select id="TrailHour<%=i %>Min" class="<%=team_class %>" <%=disabledSTR %> >
                               <%
                                    StrTimeNm = "0분"
                                    for Ph= 0 to 55 step 5
                                        if Ph <> 0 then 
                                            StrTimeNm=Ph&"분"
                                        end if

                                        if Pmin=Ph then 
                                        %> <option value='<%=Ph %>' selected><%=StrTimeNm %></option> <%
                                        else
                                        %> <option value='<%=Ph %>'><%=StrTimeNm %></option> <%
                                        end if
                                    
                                    next 
                                %>
                            </select>
                    </li>
                    <% TraiFistCd = "TraiFistCd"&i    %>
                    <li class="train-col-2">
                        <select id="<%=TraiFistCd %>" name ="TraiFistCd"  class="<%=team_class %>"  onchange="TraiFistCdChange(<%=i %>,'TraiFistCd','MidCdselect');" <%=disabledSTR %>>
                        <option value="0" >훈련유형</option>
                            <%
                            LSQL = "EXEC View_train  '"&SportsGb&"' , "&MemberIDX&",'"&TrRerdDate&"','"&p_TrRerdIDX&"','TraiFistCd',"&i 
                            Set LRs = Dbcon.Execute(LSQL)
                            IF Not (LRs.Eof Or LRs.Bof) Then 
                            Do Until LRs.Eof 
                                %>
                                <option value="<%=LRs("TraiFistCd") %>" 
                                    <%  
                                    if LRs("CHEK") ="Y" then
                                    %>
                                    selected="selected"
                                    <%
                                    end if
                                    %>  
                                >
                                <%=LRs("TraiFistNm") %></option>
                            <%
                            LRs.MoveNext
                            Loop 
                            end if
                            LRs.Close
                            %>
                        </select>
                        <a class="btn-gray"  
                        <%
                          IF p_TEAMTRAI ="Y" THEN
                            Response.write disabledSTR
                          ELSE
                          %>
                            onclick="officialTrainP(<%=i %>,'TraiFistCd','MidCdselect'); return false;"
                          <%
                            END IF
                         %>
                       >훈련종류선택</a>
                    </li>
                    </ul>
                    <div id="btn-train-list-wrap<%=i %>" class="btn-train-list-wrap" >
                        <% 
                            TraiFistCd_SEQ=1
                            TraiMidCd_SEQ=0
                            midchek =0
                            LSQL = "EXEC View_train  '"&SportsGb&"' , "&MemberIDX&",'"&TrRerdDate&"','"&p_TrRerdIDX&"','TraiMidCd',"&i 

                            
                         '   Response.Write LSQL
                         '   Response.end

                            Set LRs = Dbcon.Execute(LSQL)
                            IF Not (LRs.Eof Or LRs.Bof) Then 
                                Do Until LRs.Eof 

                                    IF  TraiMidCd_SEQ=0  THEN

                                        TraiFistCdMid = TraiFistCd&"Mid"&TraiFistCd_SEQ    
                                        %>
                                    <ul id="<%=TraiFistCdMid %>" class="btn-train-list" <%=style %>>
                                        <%
                                    END IF
                                    %>
                                        <li id="<%=TraiFistCdMid %><%=LRs("TraiFistCd") %><%=i %><%=LRs("TraiMidCd") %>"   
                                            <% IF LRs("CHEK")="Y" THEN  %> 
                                            class="on"
                                            <% midchek=midchek+1
                                            END IF 
                                            %>
                                            >
                                                <a href="#" onclick="TraiFistCdMid('<%=TraiFistCdMid %>','<%=LRs("TraiFistCd") %><%=i %><%=LRs("TraiMidCd") %>',<%=i %>,'TraiFistCd','MidCdselect'); return false;">
                                                    <%=LRs("TraiMIdNm") %></a>
                                        </li>
                                    <%
                                    TraiMidCd_SEQ = TraiMidCd_SEQ+1

                                        IF TraiMidCd_SEQ =LRs("MIDCNT")  THEN
                                        %>
                                            </ul>
                                        <%
                                        TraiMidCd_SEQ = 0
                                        TraiFistCd_SEQ=TraiFistCd_SEQ+1
                                    END IF

                                LRs.MoveNext
                                Loop 
                            end if
                            LRs.Close
                                    
                            %>
                    </div>
                    <div id="MidCdselectOk<%=i %>" class="btn-center pb<%=i %>" <%=style %>>
                        <a href="#" class="btn-or-select" onclick="officialTrainSelectOk(<%=i %>,'TraiFistCd','MidCdselect'); return false;">선택완료</a>
                    </div>
                    <ul id="MidCdselect<%=i %>" class="train-select-list <%=midchek %>" 
                    <%
                        IF midchek <= 0 then 
                            Response.write style
                        end if
                     %>
                     >
                    <% 
                        seqfir =0
                        LSQL = "EXEC View_train  '"&SportsGb&"' , "&MemberIDX&",'"&TrRerdDate&"','"&p_TrRerdIDX&"','TraiMidCd_SELECT',"&i 
                        Set LRs = Dbcon.Execute(LSQL)

                        IF Not (LRs.Eof Or LRs.Bof) Then 
                            Do Until LRs.Eof 
                            seqfir=seqfir+1
                            %>
                            <li id="MidCdselect<%=i %><%=LRs("TraiFistCd") %><%=i %><%=LRs("TraiMidCd")%>" >
                                     <a <%
                                          IF p_TEAMTRAI ="Y" THEN
                                            Response.write disabledSTR
                                            %>
                                            class="<%=team_class %>"
                                            <%
                                          else
                                          %> onclick="btndelx('MidCdselect','<%=LRs("TraiFistCd") %>',<%=i %>,'<%=LRs("TraiMidCd") %>','TraiFistCd'); return false;"
                                        <% end if%>  >  <%
                                      IF p_TEAMTRAI ="Y" THEN
                                      %> <span ></span> <%
                                    else
                                    %> <span class='btn-del-x'> x </span> <%
                                    end if
                                    Response.write LRs("TraiMIdNm") 
                                    %>
                                    </a>
                            </li>
                            <%
                            LRs.MoveNext
                            Loop 

                        end if
                        LRs.Close
                    %>
                    </ul>
                 </div>
                    <%
                next
           %>
           </div>
           <%
        End If 

        
        '개인훈련
         if id ="official-train-person" then 
                style="hidden"
                forseq = 1 
                LSQL = "EXEC View_train_person '"&SportsGb&"' , "&MemberIDX&",'"&TrRerdDate&"','"&p_TrRerdIDX&"','official-person-CHEK'"
                Set LRs = Dbcon.Execute(LSQL)
                IF Not (LRs.Eof Or LRs.Bof) Then 
                Do Until LRs.Eof 
                forseq =LRs("CNT")
                esq =LRs("row")
                LRs.MoveNext
                Loop 
                end if
                LRs.Close

                For i =1 to forseq step 1
                    officialwrap = "person"&i
           %>
              <div id="<%=officialwrap %>" class="official-train-wrap <%=forseq %>">
                  <a href=".individual-train-item" data-toggle="collapse" class="tit-individual-train rotate-caret">
                    <h2 class="clearfix"><span> 개인훈련 내용 입력</span><span class="icon"><span class="caret"></span></span></h2>
                  </a>
                  <!-- S : 처음엔 hide, 버튼 클릭해야 show -->
                  <% if esq>0 then   %>
                  <div class="individual-train-item collapse in" aria-expanded="true">
                  <% else %>
                  <div class="individual-train-item collapse">
                  <% end if %>
                    <div class="bg-or">
                      <select id ="bg-or<%=i %>">
                       <option value="0">훈련구분을 선택하세요</option>
                      <%
                        LSQL = "EXEC View_train_person  '"&SportsGb&"' , "&MemberIDX&",'"&TrRerdDate&"','"&p_TrRerdIDX&"','bg-navy-person',"&i
                        Set LRs = Dbcon.Execute(LSQL)
                        IF Not (LRs.Eof Or LRs.Bof) Then 
                        Do Until LRs.Eof 
                        %>
                        <option value="<%=LRs("PubCode") %>" 
                            <%  
                            if LRs("CHEK") ="Y" then
                            %>
                            selected="selected"
                            <%
                            end if
                            %>  
                        >
                        <%=LRs("PubName") %></option>
                        <%
                        LRs.MoveNext
                        Loop 
                        end if
                        LRs.Close
                       %>
                      </select>
                    </div>
                    <ul class="official-train-select">
                      <li>
                        <select id ="PceCdp<%=i %>">
                         <option value="0" >훈련장소</option>
                            <%
                            LSQL = "EXEC View_train_person  '"&SportsGb&"' , "&MemberIDX&",'"&TrRerdDate&"','"&p_TrRerdIDX&"','PceCd',"&i
                            Set LRs = Dbcon.Execute(LSQL)
                            IF Not (LRs.Eof Or LRs.Bof) Then 

                                Do Until LRs.Eof 
                                %>
                                <option value="<%=LRs("PceCd") %>"
                                        <%  
                                    if LRs("CHEK") ="Y" then
                                    %>
                                    selected="selected"
                                    <%
                                    end if
                                    %>  
                                ><%=LRs("PceNm") %>
                                </option>
                                <%
                                LRs.MoveNext
                                Loop 
                            end if
                            LRs.Close
                            %>
                            </select>
                      </li>
                            <%
                            PTotHour=0
                            Phour= 1
                            Pmin= 10
                            LSQL = "EXEC View_train_person  '"&SportsGb&"' , "&MemberIDX&",'"&TrRerdDate&"','"&p_TrRerdIDX&"','TrailHourPtot',"&i
                            'Response.Write LSQL
                            'Response.end

                            Set LRs = Dbcon.Execute(LSQL)
                            IF Not (LRs.Eof Or LRs.Bof) Then 
                            Do Until LRs.Eof 
                                Phour= LRs("H_TrailHour")
                                Pmin= LRs("M_TrailHour")
                            LRs.MoveNext
                            Loop 
                            end if
                            LRs.Close
                            %>
                          <li class="train-col-3 train-time">
                            <p>훈련시간</p>
                            <select id ="TrailHourP<%=i %>Hour">
                                <%
                                    StrTimeNm = "0시간"
                                    for Ph= 0 to 360 step 60
                                        if Ph <> 0 then 
                                            StrTimeNm=(Ph/60)&"시간"
                                        end if

                                        if Phour =  Ph then 
                                         %> <option value="<%=Ph %>" selected><%=StrTimeNm %></option> <%
                                        else
                                         %> <option value="<%=Ph %>"><%=StrTimeNm %></option> <%
                                        end if 
                                    next 
                                %>
                            </select>
                            <select id ="TrailHourP<%=i %>Min" >
                                    <%
                                    StrTimeNm = "0분"
                                    for Ph= 0 to 55 step 5
                                        if Ph <> 0 then 
                                            StrTimeNm=Ph&"분"
                                        end if

                                         if Pmin =  Ph then 
                                             %> <option value="<%=Ph %>" selected ><%=StrTimeNm %></option> <%
                                         else
                                             %> <option value="<%=Ph %>"><%=StrTimeNm %></option> <%
                                         end if 
                                    next 
                                %>
                            </select>
                      </li>
                        <% TraiFistCdP = "TraiFistCdP"&i    %>
                        <li class="train-col-2">
                            <select id="<%=TraiFistCdP %>" name ="TraiFistCd" onchange="TraiFistCdChange(<%=i %>,'TraiFistCdP','MidCdselectPerson');">
                            <option value="0" >훈련유형</option>
                                <%
                                LSQL = "EXEC View_train_person  '"&SportsGb&"' , "&MemberIDX&",'"&TrRerdDate&"','"&p_TrRerdIDX&"','TraiFistCd',"&i 
                                Set LRs = Dbcon.Execute(LSQL)
                                IF Not (LRs.Eof Or LRs.Bof) Then 
                                Do Until LRs.Eof 
                                    %>
                                    <option value="<%=LRs("TraiFistCd") %>" 
                                        <%  
                                        if LRs("CHEK") ="Y" then
                                        %>
                                        selected="selected"
                                        <%
                                        end if
                                        %>  
                                    >
                                    <%=LRs("TraiFistNm") %></option>
                                <%
                                LRs.MoveNext
                                Loop 
                                end if
                                LRs.Close
                                %>
                            </select>
                        <a href="#" id ="<%=TraiFistCdP %>select" class="btn-gray"  onclick="officialTrainP(<%=i %>,'TraiFistCdP','MidCdselectPerson'); return false;">훈련종류선택</a>
                      </li>
                    </ul>
                    <!-- S : btn-train-list 선택 완료시 hide -->
                    <div id="btn-person-list-wrap<%=i %>" class="btn-train-list-wrap" >
                        <% 
                            TraiFistCd_SEQ=1
                            TraiMidCd_SEQ=0
                            LSQL = "EXEC View_train_person  '"&SportsGb&"' , "&MemberIDX&",'"&TrRerdDate&"','"&p_TrRerdIDX&"','TraiMidCd',"&i 
                            Set LRs = Dbcon.Execute(LSQL)
                            IF Not (LRs.Eof Or LRs.Bof) Then 
                                Do Until LRs.Eof 

                                    IF  TraiMidCd_SEQ=0  THEN

                                        TraiFistCdMidP = TraiFistCdP&"Mid"&TraiFistCd_SEQ    
                                        %>
                                <ul id="<%=TraiFistCdMidP %>" class="btn-train-list" <%=style %>>
                                        <%
                                    END IF
                                    %>
                                        <li id="<%=TraiFistCdMidP %><%=LRs("TraiFistCd") %><%=i %><%=LRs("TraiMidCd") %>"   
                                            <% IF LRs("CHEK")="Y" THEN  %> 
                                            class="on"
                                            <% END IF %>
                                            >
                                                <a href="#" onclick="TraiFistCdMid('<%=TraiFistCdMidP %>','<%=LRs("TraiFistCd") %><%=i %><%=LRs("TraiMidCd") %>',<%=i %>,'TraiFistCdP','MidCdselectPerson'); return false;">
                                                    <%=LRs("TraiMIdNm") %></a>
                                        </li>
                                    <%
                                    TraiMidCd_SEQ = TraiMidCd_SEQ+1

                                        IF TraiMidCd_SEQ =LRs("MIDCNT")  THEN
                                        %>
                                  </ul>
                                        <%
                                        TraiMidCd_SEQ = 0
                                        TraiFistCd_SEQ=TraiFistCd_SEQ+1
                                    END IF

                                LRs.MoveNext
                                Loop 
                            end if
                            LRs.Close
                            %>
                    </div>
                     
                    <div id="MidCdselectPersonOk<%=i %>" class="btn-center pbperson" <%=style %>>
                      <a href="#" class="btn-or-select" onclick="officialTrainSelectOk(<%=i %>,'TraiFistCdP','MidCdselectPerson');return false;">선택완료</a>
                    </div>
                    <!-- E : btn-train-list 선택 완료시 hide -->
                    <!-- S : train-select-list 선택완료시 btn-train-list는 닫히고 이 부분은 남아있음 -->
                    <ul id ="MidCdselectPerson<%=i %>" class="train-select-list">
                    <% 
                        LSQL = "EXEC View_train_person  '"&SportsGb&"' , "&MemberIDX&",'"&TrRerdDate&"','"&p_TrRerdIDX&"','TraiMidCd_SELECT',"&i 
                        Set LRs = Dbcon.Execute(LSQL)
                         seqfir =0
                        IF Not (LRs.Eof Or LRs.Bof) Then 
                            Do Until LRs.Eof 
                             seqfir =seqfir+1
                            %>
                            <li id="MidCdselectPerson<%=i %><%=LRs("TraiFistCd") %><%=i %><%=LRs("TraiMidCd")%>" >
                                <a href='#'  onclick="btndelx('MidCdselectPerson','<%=LRs("TraiFistCd") %>',<%=i %>,'<%=LRs("TraiMidCd") %>','TraiFistCdP'); return false;">
                                    <span class='btn-del-x'> x </span> <%=LRs("TraiMIdNm") %>
                                </a>
                            </li>
                            <%
                            LRs.MoveNext
                            Loop 
                        end if
                        LRs.Close
                    %>
                    </ul>
                    <!-- E : train-select-list 선택완료시 btn-train-list는 닫히고 이 부분은 남아있음 -->
                  </div>
                  <!-- E : 처음엔 hide, 버튼 클릭해야 show -->
             </div>
           <%
           next
        End If 
                '훈련평가
         if id ="tranin-question" or id="tranin-question_sch" then 
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
            LSQL = "EXEC View_train  '"&SportsGb&"' , "&MemberIDX&",'"&TrRerdDate&"','"&p_TrRerdIDX&"','tranin-question'" 
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

                        <%
                            if id ="tranin-question" then
                        
                         %>
                        <td><label for="tranin-question<%=SEQID %>"><%=SEQ %>. <%=LRs("AsmtNm") %> </label></td>
                        <td><input type="radio" id="tranin-question<%=SEQID %>-1" name="tranin-question<%=SEQID %>"  value='<%=LRs("AsmtCd") %>:A'  <%=CHECK_A %> <%=Playerdisabled %>/></td>
                        <td><input type="radio" id="tranin-question<%=SEQID %>-2" name="tranin-question<%=SEQID %>"  value='<%=LRs("AsmtCd") %>:B'  <%=CHECK_B %> <%=Playerdisabled %>/></td>
                        <td><input type="radio" id="tranin-question<%=SEQID %>-3" name="tranin-question<%=SEQID %>"  value='<%=LRs("AsmtCd") %>:C'  <%=CHECK_C %> <%=Playerdisabled %>/></td>
                        <%
                        else
                        %>
                        <td><label for="tranin-question<%=SEQID %>" readonly="readonly" ><%=SEQ %>. <%=LRs("AsmtNm") %>  </label></td>
                        <td><input type="radio" id="Radio1" name="tranin-question<%=SEQID %>"   value='<%=LRs("AsmtCd") %>:A'  <%=CHECK_A %> readonly="readonly" disabled="disabled" /></td>
                        <td><input type="radio" id="Radio2" name="tranin-question<%=SEQID %>"  value='<%=LRs("AsmtCd") %>:B'  <%=CHECK_B %> readonly="readonly" disabled="disabled"/></td>
                        <td><input type="radio" id="Radio3" name="tranin-question<%=SEQID %>"  value='<%=LRs("AsmtCd") %>:C'  <%=CHECK_C %> readonly="readonly" disabled="disabled"/></td>
                        <%
                        end if
                         %>

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
            %> 
                <ul id="memory" class="memory" >
                  <li>
                    <%
                        CLASSNAME ="icon-off-favorite"
                        CHENK_FAVORITE =""
                        IF p_AdtWellCkYn="Y" THEN 
                            CLASSNAME="icon-on-favorite"
                            CHENK_FAVORITE ="checked='checked'"
                        END IF 

                     %>
                    <a href="#" class="sw-char" onclick="memoryChk('memory-txt01',1); return false;">
                    <span class="<%=CLASSNAME %>">★</span>
                    <input type="checkbox" id="memory-txt01"  name ="memory-txt" value="1" <%=CHENK_FAVORITE %>>
                    <label for="memory-txt01">잘된점</label></a>
                    <p><textarea id="AdtWell" <%=PlayerReadonly %>  placeholder="잘된점을 입력하세요"><%= p_AdtWell  %></textarea></p>
                  </li>
                  <li>
                   <%
                        CLASSNAME ="icon-off-favorite"
                        CHENK_FAVORITE =""
                        IF p_AdtNotWellCkYn="Y" THEN 
                            CLASSNAME="icon-on-favorite"
                            CHENK_FAVORITE ="checked='checked'"
                        END IF 

                     %>
                    <a href="#" class="sw-char" onclick="memoryChk('memory-txt02',2); return false;" >
                    <span class="<%=CLASSNAME %>">★</span>
                    <input type="checkbox" id="memory-txt02"  name ="memory-txt" value="2" <%=CHENK_FAVORITE %>>
                    <label for="memory-txt02">보완점</label></a>
                    <p><textarea id="AdtNotWell" <%=PlayerReadonly %> placeholder="보완점을 입력하세요."><%= p_AdtNotWell  %></textarea></p>
                  </li>
                  <li>
                   <%
                        CLASSNAME ="icon-off-favorite"
                        CHENK_FAVORITE =""
                        IF p_AdtMyDiayCklYn="Y" THEN 
                            CLASSNAME="icon-on-favorite"
                            CHENK_FAVORITE ="checked='checked'"
                        END IF 

                     %>
                    <a href="#" class="sw-char"  onclick="memoryChk('memory-txt03',3); return false;">
                    <span class="<%=CLASSNAME %>">★</span>
                    <input type="checkbox" id="memory-txt03"  name ="memory-txt"  value="3"<%=CHENK_FAVORITE %>>
                    <label for="memory-txt03">나의일기</label></a>
                    <p><textarea id="AdtMyDiay" <%=PlayerReadonly %> placeholder="나만의 일기를 작성해 보세요. (비공개)"><%= p_AdtMyDiay  %></textarea></p>
                  </li>
                  <li>
                   <%
                        CLASSNAME ="icon-off-favorite"
                        CHENK_FAVORITE =""
                        IF p_AdtAdviceCkYn="Y" THEN 
                            CLASSNAME="icon-on-favorite"
                            CHENK_FAVORITE ="checked='checked'"
                        END IF 

                     %>
                    <a href="#" class="sw-char"  onclick="memoryChk('memory-txt04',4); return false;">
                    <span class="<%=CLASSNAME %>">★</span>
                    <input type="checkbox" id="memory-txt04"  name ="memory-txt"  value="4"<%=CHENK_FAVORITE %>>
                    <label for="memory-txt04">지도자상담</label></a>
                    <p><textarea id="AdtAdvice" <%=PlayerReadonly %> placeholder="코치님 또는 감독님에게 하고 싶은 말을 입력하세요."><%= p_AdtAdvice  %></textarea></p>
                  </li>
                  <li>
                   <%
                        CLASSNAME ="icon-off-favorite"
                        CHENK_FAVORITE =""
                        IF p_AdtAdviceReCkYn="Y" THEN 
                            CLASSNAME="icon-on-favorite"
                            CHENK_FAVORITE ="checked='checked'"
                        END IF 

                     %>
                    <a href="#" class="sw-char"  onclick="memoryChk('memory-txt05',5); return false;">
                    <span class="<%=CLASSNAME %>">★</span>
                    <input type="checkbox" id="memory-txt05"  name ="memory-txt" value="5" <%=CHENK_FAVORITE %>>
                    <label for="memory-txt05">지도자답변</label></a>
                    <p><textarea id="AdtAdviceRe" readonly="readonly"><%= p_AdtAdviceRe  %></textarea></p>
                  </li>
                </ul>
            <%
        End If 

        
         if id ="memory_sch" then 
            %> 
                  <li>
                    <%
                        CLASSNAME ="icon-off-favorite"
                        CHENK_FAVORITE =""
                        IF p_AdtWellCkYn="Y" THEN 
                            CLASSNAME="icon-on-favorite"
                            CHENK_FAVORITE ="checked='checked'"
                        END IF 

                     %>
                    <a href="#" class="sw-char" onclick="memoryChk('memory-txt01',1); return false;">
                    <span class="<%=CLASSNAME %>">★</span>
                    <input type="checkbox" id="Checkbox1"  name ="memory-txt" value="1" <%=CHENK_FAVORITE %>>
                    <label for="memory-txt01">잘된점</label></a>
                    <p><textarea id="Textarea1" placeholder="잘된점을 입력하세요"readonly="readonly"><%= p_AdtWell  %></textarea></p>
                  </li>
                  <li>
                   <%
                        CLASSNAME ="icon-off-favorite"
                        CHENK_FAVORITE =""
                        IF p_AdtNotWellCkYn="Y" THEN 
                            CLASSNAME="icon-on-favorite"
                            CHENK_FAVORITE ="checked='checked'"
                        END IF 

                     %>
                    <a href="#" class="sw-char" onclick="memoryChk('memory-txt02',2); return false;" >
                    <span class="<%=CLASSNAME %>">★</span>
                    <input type="checkbox" id="Checkbox2"  name ="memory-txt" value="2" <%=CHENK_FAVORITE %>>
                    <label for="memory-txt02">보완점</label></a>
                    <p><textarea id="Textarea2" placeholder="보완점을 입력하세요."readonly="readonly"><%= p_AdtNotWell  %></textarea></p>
                  </li>
                  <li>
                   <%
                        CLASSNAME ="icon-off-favorite"
                        CHENK_FAVORITE =""
                        IF p_AdtMyDiayCklYn="Y" THEN 
                            CLASSNAME="icon-on-favorite"
                            CHENK_FAVORITE ="checked='checked'"
                        END IF 

                     %>
                    <a href="#" class="sw-char"  onclick="memoryChk('memory-txt03',3); return false;">
                    <span class="<%=CLASSNAME %>">★</span>
                    <input type="checkbox" id="Checkbox3"  name ="memory-txt"  value="3"<%=CHENK_FAVORITE %>>
                    <label for="memory-txt03">나의일기</label></a>
                    <p><textarea id="Textarea3" placeholder="나만의 일기를 작성해 보세요. (비공개)"readonly="readonly"><%= p_AdtMyDiay  %></textarea></p>
                  </li>
                  <li>
                   <%
                        CLASSNAME ="icon-off-favorite"
                        CHENK_FAVORITE =""
                        IF p_AdtAdviceCkYn="Y" THEN 
                            CLASSNAME="icon-on-favorite"
                            CHENK_FAVORITE ="checked='checked'"
                        END IF 

                     %>
                    <a href="#" class="sw-char"  onclick="memoryChk('memory-txt04',4); return false;">
                    <span class="<%=CLASSNAME %>">★</span>
                    <input type="checkbox" id="Checkbox4"  name ="memory-txt"  value="4"<%=CHENK_FAVORITE %>>
                    <label for="memory-txt04">지도자상담</label></a>
                    <p><textarea id="Textarea4" placeholder="코치님 또는 감독님에게 하고 싶은 말을 입력하세요."readonly="readonly"><%= p_AdtAdvice  %></textarea></p>
                  </li>
                  <li>
                   <%
                        CLASSNAME ="icon-off-favorite"
                        CHENK_FAVORITE =""
                        IF p_AdtAdviceReCkYn="Y" THEN 
                            CLASSNAME="icon-on-favorite"
                            CHENK_FAVORITE ="checked='checked'"
                        END IF 

                     %>
                    <a href="#" class="sw-char"  onclick="memoryChk('memory-txt05',5); return false;">
                    <span class="<%=CLASSNAME %>">★</span>
                    <input type="checkbox" id="Checkbox5"  name ="memory-txt" value="5" <%=CHENK_FAVORITE %>>
                    <label for="memory-txt05">지도자답변</label></a>
                    <p><textarea id="Textarea5" readonly="readonly"><%= p_AdtAdviceRe  %></textarea></p>
                  </li>
            <%
        End If 



    SET LRs = Nothing
    Dbclose()
End If 
    
%>


