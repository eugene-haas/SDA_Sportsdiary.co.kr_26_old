<!--#include file="../../dev/dist/config.asp"-->
<!-- S: head -->
<!-- #include file="../../include/head.asp" --> 
  <!-- E: head -->
  <% 
    RoleType = "MONPV"	    '월별 순방문자 통계
   
    dim sdc, i
    dim LRs, LSQL
    dim SET_DT, SET_DT_class
   
    dim tp      : tp        = fInject(Request("tp"))  
    dim Years   : Years     = fInject(Request("Years"))
    dim ORDERBY : ORDERBY   = fInject(Request("ORDERBY")) 
                             
    if Years = "" then Years = Year(Date())
    if tp = "" then tp ="CO1"   '통합
    if ORDERBY = "" then ORDERBY = "0" 
                                 
    'Class Info
    '총계 class = total
    '월별 소계 class = subtotal
    '일별 class = days            
%>
  <!--#include file="../CheckRole.asp"--> 
  <script type="text/javascript">
    function chk_frm(val) {
		var sf = document.search_frm;
		
		if(val=="FND") {
		    sf.action = "./TMS_MonthRegistPage.asp";
 		} else {
		    sf.action = "./TMS_file_MonthRegistPage.asp";
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
      <div class="navigation"> <i class="fas fa-home"></i> <i class="fas fa-chevron-right"></i> <span>통계관리</span> <i class="fas fa-chevron-right"></i> <span>방문자 통계</span> <i class="fas fa-chevron-right"></i> <span>월별 순방문자</span> </div>
      <!-- E: navigation --> 
      <!-- S: pd-15 -->
      <div class="pd-30"> 
        <!-- S: sub-content -->
        <div class="sub-content">
          <div class="box-shadow">
            <div class="search-box-1">
              <form method="post" name="search_frm" id="search_frm" >
                <select id="Years" name="Years">
                  <%
                    LSQL = "        SELECT LEFT(CONVERT(NVARCHAR, WORK_DT, 112), 4) Years "
                    LSQL = LSQL & " FROM tblSdStaticVisitHis "
                    LSQL = LSQL & " GROUP BY LEFT(CONVERT(NVARCHAR, WORK_DT, 112), 4) "
                    LSQL = LSQL & " ORDER BY LEFT(CONVERT(NVARCHAR, WORK_DT, 112), 4) DESC "

                    SET YRs = DBCon8.Execute(LSQL)
                    If Not(YRs.Eof Or YRs.Bof) Then 
                        Do Until YRs.Eof 
                            %>
                  <option value="<%=YRs("Years")%>" <%If YRs("Years") = Years Then response.write "selected" End If%>><%=YRs("Years")%></option>
                  <%
                            YRs.MoveNext
                        Loop 
                    End If 
                    %>
                </select>
                <select name="tp" id="tp">
                  <%
                    LSQL = "			SELECT STATIC_MEDIA_TP tp"
                    LSQL = LSQL & "		,CASE "
                    LSQL = LSQL & "			WHEN A.STATIC_MEDIA_TP = 'CO1' THEN '통합' "
                    LSQL = LSQL & "			WHEN A.STATIC_MEDIA_TP = 'EE1' THEN '테니스' "
                    LSQL = LSQL & "			WHEN A.STATIC_MEDIA_TP = 'BK1' THEN '자전거' "
                    LSQL = LSQL & "			WHEN A.STATIC_MEDIA_TP = 'SD1' THEN '유도 선수용' "
                    LSQL = LSQL & "			WHEN A.STATIC_MEDIA_TP = 'TE1' THEN '유도 팀매니저용' "
                    LSQL = LSQL & "			ELSE '' "
                    LSQL = LSQL & "			END tpname "
                    LSQL = LSQL & "	FROM tblSdStaticVisitHis A "
                    LSQL = LSQL & "	WHERE A.STATIC_MEDIA_TP <> ''" 
                    LSQL = LSQL & "	GROUP BY A.STATIC_MEDIA_TP "							   
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
                  <option value="<%=LRs("tp")%>" <% if tp = LRs("tp") then response.write "selected" End IF%>><%=LRs("tpname")%></option>
                  <%
                            LRs.MoveNext
                        Loop 
                    End IF
                        LRs.Close
                    SET LRs = Nothing 
                %>
                </select>
                <a href="javascript:chk_frm('FND');" class="btn btn-primary" id="btnview" accesskey="s">검색(S)</a><a href="javascript:chk_frm('FILE');" class="btn btn-danger" id="A1" accesskey="F">엑셀다운로드(F)</a>
              </form>
            </div>
          </div>
          <div class="table-box basic-table-box">
            <table cellspacing="0" cellpadding="0" class="table">
              <tr>
                <th>매체유형</th>
                <th>누적합계</th>
                <th>1월</th>
                <th>2월</th>
                <th>3월</th>
                <th>4월</th>
                <th>5월</th>
                <th>6월</th>
                <th>7월</th>
                <th>8월</th>
                <th>9월</th>
                <th>10월</th>
                <th>11월</th>
                <th>12월</th>
              </tr>
              <%
                LSQL = "        SELECT * "
                LSQL = LSQL & " FROM ("
                LSQL = LSQL & "     SELECT a.TypeMedia "  
                LSQL = LSQL & "         ,sum(case  when a.LogDate like '"&Years&"%' then a.LogCntTotal else 0 end ) CSum "  
                LSQL = LSQL & "         ,sum(case a.LogDate when '"&Years&"-01' then a.LogCntTotal  else 0 end ) CSum01 "  
                LSQL = LSQL & "         ,sum(case a.LogDate when '"&Years&"-02' then a.LogCntTotal  else 0 end ) CSum02 "  
                LSQL = LSQL & "         ,sum(case a.LogDate when '"&Years&"-03' then a.LogCntTotal  else 0 end ) CSum03 "  
                LSQL = LSQL & "         ,sum(case a.LogDate when '"&Years&"-04' then a.LogCntTotal  else 0 end ) CSum04 "  
                LSQL = LSQL & "         ,sum(case a.LogDate when '"&Years&"-05' then a.LogCntTotal  else 0 end ) CSum05 "  
                LSQL = LSQL & "         ,sum(case a.LogDate when '"&Years&"-06' then a.LogCntTotal  else 0 end ) CSum06 "  
                LSQL = LSQL & "         ,sum(case a.LogDate when '"&Years&"-07' then a.LogCntTotal  else 0 end ) CSum07 "  
                LSQL = LSQL & "         ,sum(case a.LogDate when '"&Years&"-08' then a.LogCntTotal  else 0 end ) CSum08 "  
                LSQL = LSQL & "         ,sum(case a.LogDate when '"&Years&"-09' then a.LogCntTotal  else 0 end ) CSum09 "  
                LSQL = LSQL & "         ,sum(case a.LogDate when '"&Years&"-10' then a.LogCntTotal  else 0 end ) CSum10 "  
                LSQL = LSQL & "         ,sum(case a.LogDate when '"&Years&"-11' then a.LogCntTotal  else 0 end ) CSum11 "  
                LSQL = LSQL & "         ,sum(case a.LogDate when '"&Years&"-12' then a.LogCntTotal  else 0 end ) CSum12 "  
                LSQL = LSQL & "     FROM (" 
                LSQL = LSQL & "	        SELECT CASE "
                LSQL = LSQL & "			      WHEN A.STATIC_MEDIA_TP = 'CO1' THEN '통합' "
                LSQL = LSQL & "			      WHEN A.STATIC_MEDIA_TP = 'EE1' THEN '테니스' "
                LSQL = LSQL & "			      WHEN A.STATIC_MEDIA_TP = 'BK1' THEN '자전거' "
                LSQL = LSQL & "			      WHEN A.STATIC_MEDIA_TP = 'SD1' THEN '유도 선수용' "
                LSQL = LSQL & "			      WHEN A.STATIC_MEDIA_TP = 'TE1' THEN '유도 팀매니저용' "
                LSQL = LSQL & "			      ELSE ''  "
                LSQL = LSQL & "		           END TypeMedia "
                LSQL = LSQL & " 	       ,SUBSTRING(A.SET_DT,1,4) + '-' + SUBSTRING(A.SET_DT,5,2)  LogDate,SUM(A.SET_CNT) LogCntTotal "
                LSQL = LSQL & " 	   FROM tblSdStaticVisitHis A "
                LSQL = LSQL & " 	   WHERE A.DEL_YN = 'N'"                    
                LSQL = LSQL & " 	       AND A.STATIC_MEDIA_TP='"&tp&"'"
                LSQL = LSQL & " 	   GROUP BY A.STATIC_MEDIA_TP,SUBSTRING(A.SET_DT,1,4) + '-' + SUBSTRING(A.SET_DT,5,2)"
                LSQL = LSQL & "        ) a "
                LSQL = LSQL & "     GROUP BY a.TypeMedia "
                LSQL = LSQL & " ) A " 

                SET LRs = DBCon8.Execute(LSQL)
                IF Not(LRs.Eof Or LRs.Bof) Then 
                    Do Until LRs.Eof                 
                %>
                  <tr>
                    <td><%=LRs("TypeMedia")%></td>
                    <td><%=FormatNumber(LRs("CSum"), 0)%></td>
                    <td><%=FormatNumber(LRs("CSum01"), 0)%></td>
                    <td><%=FormatNumber(LRs("CSum02"), 0)%></td>
                    <td><%=FormatNumber(LRs("CSum03"), 0)%></td>
                    <td><%=FormatNumber(LRs("CSum04"), 0)%></td>
                    <td><%=FormatNumber(LRs("CSum05"), 0)%></td>
                    <td><%=FormatNumber(LRs("CSum06"), 0)%></td>
                    <td><%=FormatNumber(LRs("CSum07"), 0)%></td>
                    <td><%=FormatNumber(LRs("CSum08"), 0)%></td>
                    <td><%=FormatNumber(LRs("CSum09"), 0)%></td>
                    <td><%=FormatNumber(LRs("CSum10"), 0)%></td>
                    <td><%=FormatNumber(LRs("CSum11"), 0)%></td>
                    <td><%=FormatNumber(LRs("CSum12"), 0)%></td>
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