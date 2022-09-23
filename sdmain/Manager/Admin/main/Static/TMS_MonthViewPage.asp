<!--#include file="../../dev/dist/config.asp"-->
<!-- S: head -->
<!-- #include file="../../include/head.asp" --> 
<!-- E: head -->
<% 
    RoleType = "MONUVPAGE"	    '월별 페이지뷰 통계
   
    dim tp          : tp        = fInject(Request("tp")) 
    dim ORDERBY     : ORDERBY   = fInject(Request("ORDERBY")) 
    dim Years       : Years     = fInject(Request("Years"))

    if Years = "" then Years = Year(Date())
    if tp = "" then tp = "CO1"
    if ORDERBY = "" then ORDERBY = "1"
                                 
    dim LRs, LSQL
    dim colStr
    dim C_YEARS                                 
          
%>
<!--#include file="../CheckRole.asp"--> 
<script type="text/javascript">
    function chk_frm(val) {
        var sf = document.search_frm;

        if (val == "FND") {
            sf.action = "./TMS_MonthViewPage.asp";
        } else {
            sf.action = "./TMS_file_MonthViewPage.asp";
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
  <!-- #include file="../../include/left-gnb-test.asp" --> 
  <!-- E: left-gnb --> 
  
  <!-- S: right-content -->
  <div class="right-content"> 
    <!-- S: navigation -->
    <div class="navigation"> <i class="fas fa-home"></i> <i class="fas fa-chevron-right"></i> <span>통계관리</span> <i class="fas fa-chevron-right"></i> <span>방문자 통계</span> <i class="fas fa-chevron-right"></i> <span>월별 페이지뷰</span> </div>
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
                    LRs.Close
                SET LRs = Nothing
            %>
              </select>
              <select name="tp" id="tp">
                <%
                LSQL = "		 SELECT STATIC_MEDIA_TP tp"
                LSQL = LSQL & "	    ,CASE "
                LSQL = LSQL & "		   WHEN A.STATIC_MEDIA_TP = 'CO1' THEN '통합' "
                LSQL = LSQL & "		   WHEN A.STATIC_MEDIA_TP = 'EE1' THEN '테니스' "
                LSQL = LSQL & "		   WHEN A.STATIC_MEDIA_TP = 'BK1' THEN '자전거' "
                LSQL = LSQL & "		   WHEN A.STATIC_MEDIA_TP = 'SD1' THEN '유도 선수용' "
                LSQL = LSQL & "		   WHEN A.STATIC_MEDIA_TP = 'TE1' THEN '유도 팀매니저용' "
                LSQL = LSQL & "		   ELSE '' "
                LSQL = LSQL & "		   END tpname "
                LSQL = LSQL & "	FROM tblSdStaticHis A "
                LSQL = LSQL & "	WHERE A.STATIC_MEDIA_TP <> ''" 
                LSQL = LSQL & "	GROUP BY A.STATIC_MEDIA_TP"
                LSQL = LSQL & " ORDER BY CASE A.STATIC_MEDIA_TP "
                LSQL = LSQL & "     WHEN 'CO1' THEN 1" 
                LSQL = LSQL & "     WHEN 'EE1' THEN 2" 
                LSQL = LSQL & "     WHEN 'BK1' THEN 3" 
                LSQL = LSQL & "     WHEN 'SD1' THEN 4" 
                LSQL = LSQL & "     WHEN 'TE1' THEN 5"                               
                LSQL = LSQL & "     END ASC"

                SET LRs = DBCon8.Execute(LSQL)
                IF Not(LRs.Eof Or LRs.Bof) Then 
                    Do Until LRs.Eof 
                    %>
                <option value="<%=LRs("tp")%>" <%IF tp = LRs("tp") Then response.write "selected" END IF%>><%=LRs("tpname")%></option>
                <%
                        LRs.MoveNext
                    Loop 
                End IF 
                    LRs.Close
                SET LRs = Nothing 

            %>
              </select>
              <select name="ORDERBY" id="ORDERBY">
                <%
                IF ORDERBY ="1" THEN
                %>
                <option value="0" >페이지명</option>
                <option value="1" selected>누적합계</option>
                <%
                ELSE
                %>
                <option value="0" selected>페이지명</option>
                <option value="1" >누적합계</option>
                <%
                END IF 
             %>
              </select>
              <a href="javascript:chk_frm('FND');" class="btn btn-primary" id="btnview" accesskey="s">검색(S)</a><a href="javascript:chk_frm('FILE');" class="btn btn-danger" id="A1" accesskey="F">엑셀다운로드(F)</a>
            </form>
          </div>
        </div>
        <div class="table-box basic-table-box">
          <table cellspacing="0" cellpadding="0" class="table">
            <tr class="table-top">
              <th>매체유형</th>
              <th>페이지URL</th>
              <th>페이지명</th>
              <th>순위</th>
              <%
                colStr =""
                C_YEARS = ""
                                                                                                                                          
                LSQL ="exec Search_Sd_ViewTouch_Count '"&tp&"','"&Years&"0101','"&Years&"1231','"&ORDERBY&"','NAME'"                
                SET LRs = DBCon8.Execute(LSQL)
                IF Not(LRs.Eof Or LRs.Bof) Then 
                    Do Until LRs.Eof 

                        IF C_YEARS <> LRs("C_YEARS") Then
                            colStr = colStr  &"CNT"& LRs("C_YEARS") & "|"
                            %>
              <th><%=LRs("C_YEARS") %>년 누적합계</th>
              <%
                            C_YEARS = LRs("C_YEARS")
                        END IF
                        %>
              <th><%=LRs("C_MONTHS") %>월</th>
              <%
                      
                        colStr = colStr  &"CNT"& LRs("C_YEARS")& LRs("C_MONTHS") & "|"

                        LRs.MoveNext
                    Loop 
                End If 
                    LRs.Close
                SET LRs = Nothing
                %>
            </tr>
            <%
            'Response.Write  colStr
            LSQL ="exec Search_Sd_ViewTouch_Count '"&tp&"','"&Years&"0101','"&Years&"1231','"&ORDERBY&"','DATA'"
            SET LRs = DBCon8.Execute(LSQL)
            IF Not(LRs.Eof Or LRs.Bof) Then 
                Do Until LRs.Eof 
                %>
            <tr>
              <td><%=LRs("C_STATIC_MEDIA_TP_Nm")%></td>
              <td style="text-align:left;"><%=LRs("URL_FILE_NM")%></td>
              <td style="text-align:left;"><%=LRs("URL_FILE_INFO")%></td>
              <td><%=FormatNumber(LRs("num"),0)%></td>
              <%
                  IF colStr <> "" Then
                      colstrC = split(colStr,"|") 
                      
                      FOR i = 0 to UBound(colstrC)
                          IF colstrC(i) <> "" Then 
                          %>
              <td align=right><%=FormatNumber(LRs(colstrC(i)),0)%></td>
              <%
                          END IF
                      NEXT
                  END IF
                %>
            </tr>
            <%
                    LRs.MoveNext
                Loop 
            End If  
            %>
          </table>
        </div>
      </div>
      <!-- E: sub-content --> 
    </div>
    <!-- E: pd-15 --> 
    
  </div>
  <!-- S: right-content --> 
  
</div>
<%
    DBClose8()   
%>