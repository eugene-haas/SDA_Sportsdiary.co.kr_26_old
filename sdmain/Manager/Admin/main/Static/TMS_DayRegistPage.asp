<!--#include file="../../dev/dist/config.asp"-->
<!-- S: head -->
<!-- #include file="../../include/head.asp" --> 
<!-- E: head -->
<% 
    RoleType = "DAYPV"	    '일별 순방문자 통계
   
    dim sdc, i
    dim LRs, LSQL
    dim SET_DT, SET_DT_class
   
    dim tp      : tp        = fInject(Request("tp"))  
    dim Years   : Years     = fInject(Request("Years"))

    if Years = "" then Years = Year(Date())
    if tp = "" then tp ="CO1"   '통합
                                 
    'Class Info
    '총계 class = total
    '월별 소계 class = subtotal
    '일별 class = days            
%>
  <!--#include file="../CheckRole.asp"-->
  <script type="text/javascript">
    function chk_frm(val) {
		var sf = document.search_frm;

		if (val == "FND") {
		    sf.action = "./TMS_DayRegistPage.asp";
		} else {
		    sf.action = "./TMS_file_DayRegistPage.asp";
		}

        sf.submit();
    }
    
    $(function(){
        $('select').on('change', function() {
           chk_frm('FND');
        });
    });
</script>
  <div class="content"> 
    <!-- S: left-gnb --> 
    <!-- #include file="../../include/left-gnb.asp" --> 
    <!-- E: left-gnb --> 
    
    <!-- S: right-content -->
    <div class="right-content"> 
      <!-- S: navigation -->
      <div class="navigation"> <i class="fas fa-home"></i> <i class="fas fa-chevron-right"></i> <span>통계관리</span> <i class="fas fa-chevron-right"></i> <span>방문자 통계</span> <i class="fas fa-chevron-right"></i> <span>일별 순방문자</span> </div>
      <!-- E: navigation --> 
      <!-- S: pd-15 -->
      <div class="pd-30 right-bg"> 
        <!-- S: sub-content -->
        <div class="sub-content">
          
            <div class="box-shadow">
              <div class="search-box-1">
                  <form method="post" name="search_frm" id="search_frm" >
                <select id="Years" name="Years">
                  <%
                    LSQL = "        SELECT LEFT(CONVERT(NVARCHAR, WORK_DT, 112), 4) Years "
                    LSQL = LSQL & " FROM tblSdStaticVisitHis "
                    LSQL = LSQL & " GROUP BY LEFT(CONVERT(NVARCHAR, WORK_DT, 112), 4)"
                    LSQL = LSQL & " ORDER BY LEFT(CONVERT(NVARCHAR, WORK_DT, 112), 4) DESC "
                    
                    SET LRs = DBCon8.Execute(LSQL)
                    IF Not(LRs.Eof Or LRs.Bof) Then 
                        Do Until LRs.Eof 
                        %>
                  <option value="<%=LRs("Years")%>" <%If LRs("Years") = Years Then response.write "selected" End If%>><%=LRs("Years")%></option>
                  <%
                            LRs.MoveNext
                        Loop 
                    End IF 
                %>
                </select>
                <select name="tp" id="tp">
                  <%
                    LSQL = "        SELECT STATIC_MEDIA_TP tp"
                    LSQL = LSQL & "		,CASE "
                    LSQL = LSQL & "			WHEN A.STATIC_MEDIA_TP = 'CO1' THEN '통합'"
                    LSQL = LSQL & "			WHEN A.STATIC_MEDIA_TP = 'BM1' THEN '배드민턴'"
                    LSQL = LSQL & "			WHEN A.STATIC_MEDIA_TP = 'EE1' THEN '테니스'"
                    LSQL = LSQL & "			WHEN A.STATIC_MEDIA_TP = 'BK1' THEN '자전거'"
                    LSQL = LSQL & "			WHEN A.STATIC_MEDIA_TP = 'SD1' THEN '유도 선수용'"
                    LSQL = LSQL & "			WHEN A.STATIC_MEDIA_TP = 'TE1' THEN '유도 팀매니저용'"
                    LSQL = LSQL & "			ELSE '' "
                    LSQL = LSQL & "			END tpname "
                    LSQL = LSQL & "	FROM tblSdStaticVisitHis A "
                    LSQL = LSQL & "	WHERE A.STATIC_MEDIA_TP <> ''" 
                    LSQL = LSQL & "	GROUP BY A.STATIC_MEDIA_TP "
                    LSQL = LSQL & " ORDER BY CASE A.STATIC_MEDIA_TP "
                    LSQL = LSQL & "       WHEN 'CO1' THEN 1" 
                    LSQL = LSQL & "       WHEN 'EE1' THEN 2" 
                    LSQL = LSQL & "       WHEN 'BK1' THEN 3" 
                    LSQL = LSQL & "       WHEN 'SD1' THEN 4" 
                    LSQL = LSQL & "       WHEN 'TE1' THEN 5"                               
                    LSQL = LSQL & "       END ASC"

                    SET LRs = DBCon8.Execute(LSQL)
                    IF Not(LRs.Eof Or LRs.Bof) Then 
                        Do Until LRs.Eof                                                 
                            %>
                  <option value="<%=LRs("tp")%>" <%if tp = LRs("tp") then response.write "selected" End IF%>><%=LRs("tpname")%></option>
                  <%                                                 
                            LRs.MoveNext
                        Loop 
                    End IF 

                        LRs.Close
                    SET LRs = Nothing 

                %>
                </select>
                <a href="javascript:chk_frm('FND');" class="btn btn-primary" id="btnview" accesskey="s">검색(S)</a>
								<a href="javascript:chk_frm('FILE');" class="btn btn-danger" id="A1" accesskey="F">엑셀다운로드(F)</a>
          </form>      
              </div>
            </div>
          <div class="TMS_DayRegistPage">
						<div class="table-box basic-table-box">
							<table cellspacing="0" cellpadding="0" class="table">
								<tbody>
									<tr>
										<th rowspan=2>매체유형</th>
										<th rowspan=2>일자</th>
										<th rowspan=2>Total</th>
										<th colspan=24>시간대</th>
									</tr>
									<tr>
										<%
							FOR i = 0 to 23 
									sdc = "00"
									if i < 10 then
											sdc = "0"&i
									else
											sdc = ""&i
									end if 
							%>
										<th><%=sdc%>시</th>
										<%
							NEXT
							%>
									</tr>
									<%
									LSQL = " EXEC Search_Sd_VisitHis_Count '"&tp&"','"&Years&"0101','"&Years&"1231' "
									'Response.Write LSQL
									
									SET LRs = DBCon8.Execute(LSQL)
									IF Not(LRs.Eof Or LRs.Bof) Then 
											Do Until LRs.Eof    
											
													SET_DT = ""
													SET_DT_class = ""

													IF LRs("COL") ="년별" THEN
														 SET_DT = "총계"
														 SET_DT_class = "total" 
													END IF 

													IF LRs("COL") ="월별" THEN
														 SET_DT = LRs("MONTHS")&"월 소계"
														 SET_DT_class = "subtotal" 
													END IF 

													IF LRs("COL") ="일별" THEN
														 SET_DT = LRs("MONTHS")&"월 "&LRs("DAYS")&"일"
														 SET_DT_class = "days" 
													END IF 

											%>
											<tr class="<%=SET_DT_class%>">
												<td><%=LRs("STATIC_MEDIA_Nm")%></td>
												<td><%=SET_DT%></td>
												<td><%=FormatNumber(LRs("SET_CNT"), 0)%></td>
												<%
													FOR i = 0 to 23 
															sdc = "00"
															if i < 10 then
																	sdc = "0"&i
															else
																	sdc = ""&i
															end if 
													%>
												<td><%=FormatNumber(LRs("SET_"&sdc&"_CNT"), 0)%></td>
												<%
													NEXT
													%>
											</tr>
											<%
													LRs.MoveNext
											Loop 
									End IF 
									%>
								</tbody>
							</table>
						</div>
					</div>
        </div>
        <!-- E: sub-content --> 
      </div>
      <!-- E: pd-15 --> 
    </div>
    <!-- E: right-content --> 
    
  </div>
  <!-- S: footer --> 
  <!-- #include file="../../include/footer.asp" -->
<!-- E: footer -->
<%
    DBClose8()
%>                 