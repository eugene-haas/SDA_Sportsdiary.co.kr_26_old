
                <form method="post"  name="sform" action="check_agreement.asp">
                <input type="hidden" name="p">

                <ul>
                    <li>
                        <select id="gidx"  class="" onchange="mx.searchPlayer(<%=page%>);">
                            <option value="3" <%If CDbl(gidx) = 3 then%>selected<%End if%>>전체</option>
                            <option value="1" <%If CDbl(gidx) = 1 then%>selected<%End if%>>개인</option>
                            <option value="2" <%If CDbl(gidx) = 2 then%>selected<%End if%>>단체</option>
                        </select>
                    </li>
                    <li>
                        <select id="fnd_Type" class="" onchange="mx.searchPlayer(<%=page%>);">
                        <option value="2" <%If stype= "2" then%>selected<%End if%>>선수명</option>
                        <option value="1" <%If stype= "1" then%>selected<%End if%>>보호자명</option>
                        <option value="3" <%If stype= "3" then%>selected<%End if%>>대회명</option>
                        </select>
                    </li>
                    <li>
                        <%If CStr(stype)="3" then%>
                        <select  id="tidx" onchange="mx.searchPlayer(<%=page%>);" class="">
                        <option value="">==대회선택==</option>
                            <%
                            If IsArray(arrRT) Then
                                For ar = LBound(arrRT, 2) To UBound(arrRT, 2)
                                    t_tidx = arrRT(0, ar)
                                    t_tname = arrRT(1, ar)
                                    %><option value="<%=t_tidx%>"  <%If CDbl(t_tidx) = CDbl(tidx) then%>selected<%End if%>><%=t_tname%></option><%
                                Next
                            End if
                            %>
                        </select>
                        <%End if%>


                        <%If CStr(stype)="3" And tidx > 0 then%>
                        <li>
                            <select id="ridx"  class="" onchange="mx.searchPlayer(<%=page%>);">
                            <option value="">==부서선택==</option>
                                <%
                                If IsArray(arrRS) Then
                                    For ar = LBound(arrRS, 2) To UBound(arrRS, 2)

                                        levelno = arrRS(0, ar)
                                        PTeamGbNm = arrRS(1, ar)
                                        LevelNm = arrRS(2, ar)
                                    %>
                                        <option value="<%=levelno%>" <%If CDbl(ridx) = CDbl(levelno) then%>selected<%End if%>><%=PTeamGbNm &"("&LevelNm&")"%></option>
                                    <%
                                    i = i + 1
                                    Next
                                End if
                                %>
                            </select>
                        </li>
                        <%End If%>

                        <%If stype = "" Or stype="1" Or stype = "2" then%>
                        <input type="text" id="fnd_Str" class="in_txt"  onkeydown="if(event.keyCode == 13){mx.searchPlayer(<%=page%>);}" value="<%=svalue%>">
                        <a href="javascript:mx.searchPlayer(<%=page%>);" class="navy-btn search-btn">검색</a>
                        <%End if%>

                    </li>





                </ul>


                </form>
