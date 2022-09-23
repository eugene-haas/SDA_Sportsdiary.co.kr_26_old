<!--#include file="../../dev/dist/config.asp"-->
<!-- S: head -->
<!-- #include file="../../include/head.asp" --> 
  <!-- E: head -->
  <% 
    RoleType = "DAYUVPAGE"	    '일별 페이지뷰 통계
   
    dim tp      : tp        = fInject(Request("tp"))
    dim ORDERBY : ORDERBY   = fInject(Request("ORDERBY"))
    dim Years   : Years     = fInject(Request("Years"))
    dim Months  : Months    = fInject(Request("Months"))

    if Years = "" then Years = Year(Date())
    if Months = "" then Months = Month(Date())
    if tp = "" then tp = "CO1"          
    if ORDERBY = "" then ORDERBY = "1"

    '해당월의 마지막일 조회
    dim Days : Days = right(DateSerial(Years, Months + 1 , 0), 2)
%>
  <!--#include file="../CheckRole.asp"--> 
  <script type="text/javascript">
    function chk_frm(val) {
         var sf = '';
        
         if (val == 'FND') sf = './TMS_MonthByDayViewPage_Count.asp';
         else sf = './TMS_file_MonthByDayViewPage_Count.asp';
        
         $('form[name=search_frm]').attr('action', sf);
         $('form[name=search_frm]').submit();
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
      <div class="navigation"> <i class="fas fa-home"></i> <i class="fas fa-chevron-right"></i> <span>통계관리</span> <i class="fas fa-chevron-right"></i> <span>방문자 통계</span> <i class="fas fa-chevron-right"></i> <span>일별 페이지뷰</span> </div>
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
                  <option value="<%=LRs("Years")%>" <%If LRs("Years") = Years Then response.write "selected" End If%>><%=LRs("Years")%>년</option>
                  <%
                            LRs.MoveNext
                        Loop
                    End If
                         LRs.Close
                    SET LRs = Nothing
                %>
                </select>
                <select id="Months" name="Months">
                  <%
                   FOR i = 1 To 12
                        %>
                  <option value="<%=i%>" <%If i = cint(Months) Then response.write "selected" End If%>><%=i%>월</option>
                  <%
                 NEXT
                %>
                </select>
                <select name="tp" id="tp">
                  <%
                    LSQL = "        SELECT STATIC_MEDIA_TP tp"
                    LSQL = LSQL & "      ,CASE "
                    LSQL = LSQL & "          WHEN A.STATIC_MEDIA_TP = 'CO1' THEN '통합' "
                    LSQL = LSQL & "          WHEN A.STATIC_MEDIA_TP = 'BM1' THEN '배드민턴' "
                    LSQL = LSQL & "          WHEN A.STATIC_MEDIA_TP = 'EE1' THEN '테니스' "
                    LSQL = LSQL & "          WHEN A.STATIC_MEDIA_TP = 'BK1' THEN '자전거' "
                    LSQL = LSQL & "          WHEN A.STATIC_MEDIA_TP = 'SD1' THEN '유도 선수용' "
                    LSQL = LSQL & "          WHEN A.STATIC_MEDIA_TP = 'TE1' THEN '유도 팀매니저용' "
                    LSQL = LSQL & "          ELSE '' "
                    LSQL = LSQL & "          END tpname "
                    LSQL = LSQL & "   FROM tblSdStaticHis A "
                    LSQL = LSQL & "	WHERE A.STATIC_MEDIA_TP <> ''" 
                    LSQL = LSQL & "   GROUP BY A.STATIC_MEDIA_TP "
                    LSQL = LSQL & "   ORDER BY CASE A.STATIC_MEDIA_TP "
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
                <select name="ORDERBY" id="ORDERBY">
                  <option value="0" <%IF ORDERBY ="0" THEN response.write "selected" End IF%> >페이지명</option>
                  <option value="1" <%IF ORDERBY ="1" THEN response.write "selected" End IF%> >누적합계</option>
                </select>
                <a href="javascript:chk_frm('FND');" class="btn btn-primary" id="btnview" accesskey="s">검색(S)</a> <a href="javascript:chk_frm('FILE');" class="btn btn-danger" id="btnview" accesskey="F">엑셀다운로드(F)</a>
              </form>
            </div>
          </div>
					<!-- S: TMS_MonthByDayViewPage_Count -->
					<div class="TMS_MonthByDayViewPage_Count">
						<div class="table-box basic-table-box" >
							<table cellspacing="0" cellpadding="0" class="table">
								<tr class="table-top">
									<th>매체유형</th>
									<th>페이지URL</th>
									<th>페이지명</th>
									<th>순위</th>
									<th><%=Years%>.<%=Months%>누적합계</th>
									<%FOR i=1 to Days%>
									<th><%=i%>일</th>
									<%NEXT%>
								</tr>
								<%
									'Response.Write  colStr
									LSQL =" EXEC Search_Sd_ViewTouch_PageCount '"&tp&"','"&Years&"','"&Months&"','"&Days&"','"&ORDERBY&"' "
									SET LRs = DBCon8.Execute(LSQL)
									IF Not(LRs.Eof Or LRs.Bof) Then
											Do Until LRs.Eof
											%>
								<tr>
									<td><%=LRs("STATIC_MEDIA_TP_NM")%></td>
									<td style="text-align:left;"><%=LRs("URL_FILE_NM")%></td>
									<td style="text-align:left;"><%=LRs("URL_FILE_INFO")%></td>
									<td><%=FormatNumber(LRs("NUM"),0)%></td>
									<td><%=FormatNumber(LRs("STR_SUM"),0)%></td>
									<%FOR i=1 to Days%>
									<td><%=FormatNumber(LRs("Day"&i),0)%></td>
									<%Next%>
								</tr>
								<%
													LRs.MoveNext
											Loop
									End If
										 LRs.Close
									SET LRs = Nothing
							 %>
							</table>
						</div>
					</div>
					<!-- E: TMS_MonthByDayViewPage_Count -->
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