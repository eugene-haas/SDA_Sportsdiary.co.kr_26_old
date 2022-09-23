<!--#include file="../../dev/dist/config.asp"-->
<!-- S: head -->
<!-- #include file="../../include/head.asp" --> 
  <!-- E: head -->
  <% 
    RoleType = "01MEMALL"	    '일별 통합회원 가입자 통계   
                             
    dim DT_F        : DT_F      = fInject(Request("DT_F"))
    dim DT_T        : DT_T      = fInject(Request("DT_T"))
    dim SportsGB    : SportsGB  = fInject(Request("SportsGB"))                              
    dim Years       : Years     = fInject(Request("Years"))

    IF Years = "" Then Years = Year(Date())      
    IF DT_F = "" Then DT_F = DateAdd("m",-1,Date())
    IF DT_T = "" Then DT_T = Date()
%>
  <!--#include file="../CheckRole.asp"--> 
  <script type="text/javascript">
    $(function(){
        $('select').on('change', function() {
            $('form[name=search_frm]').attr('action','./mem_DayRegistMember_all.asp');
            $('form[name=search_frm]').submit();
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
      <div class="navigation"> <i class="fas fa-home"></i> <i class="fas fa-chevron-right"></i> <span>통계관리</span> <i class="fas fa-chevron-right"></i> <span>가입자 회원 통계</span> <i class="fas fa-chevron-right"></i> <span>통합회원 일별 가입자</span> </div>
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
                    LSQL = "        SELECT YEAR(WriteDate) Years "
                    LSQL = LSQL & " FROM [SD_Member].[dbo].[tblMember] "
                    LSQL = LSQL & " GROUP BY YEAR(WriteDate) "
                    LSQL = LSQL & " ORDER BY YEAR(WriteDate) DESC "
                    
                    SET LRs = DBCon8.Execute(LSQL)
                    IF Not(LRs.Eof Or LRs.Bof) Then 
                        Do Until LRs.Eof 
                        %>
                  <option value="<%=LRs("Years")%>" <%If LRs("Years") = CInt(Years) Then response.write "selected" End If%>><%=LRs("Years")%></option>
                  <%
                            LRs.MoveNext
                        Loop 
                    End IF 
                        LRs.Close
                    SET LRs = Nothing                                 
                %>
                </select>
              </form>
            </div>
          </div>
          <div class="mem_DayRegistMember_all">
            <div class="table-box basic-table-box">
              <table cellspacing="0" cellpadding="0" class="table">
                <tr class="table-top">
                  <th>가입일자</th>
                  <th>총가입자수</th>
                  <th>남자</th>
                  <th>여자</th>
                </tr>
                <%
            SportsType = ""
            SEQ = 0
            MON_SEQ = 0
            YY = ""
            MM = ""
            num = 3
            hidden = "hidden"       

            TableSql = "			SELECT 0 num"
            TableSql = TableSql & "		,'통합' SportsType"
            TableSql = TableSql & "		,CONVERT(CHAR,CONVERT(DATE,CONVERT(CHAR, WriteDate, 111)),111) SrtDATE"
            TableSql = TableSql & "		,Sex"		
            TableSql = TableSql & "	FROM [SD_Member].[dbo].[tblmember]"
            TableSql = TableSql & "	WHERE delYN='N' AND YEAR(WriteDate) = '"&Years&"'"

            TableSql1 = "				SELECT 1 num"
            TableSql1 = TableSql1 & "		,'통합' SportsType"
            TableSql1 = TableSql1 & "		,left(CONVERT(CHAR,CONVERT(DATE,CONVERT(CHAR, WriteDate, 111)),111),7) +' 소계' SrtDATE"
            TableSql1 = TableSql1 & "		,Sex"	
            TableSql1 = TableSql1 & "	FROM [SD_Member].[dbo].[tblmember]" 		
            TableSql1 = TableSql1 & "	WHERE delYN='N' AND YEAR(WriteDate) = '"&Years&"'"

            TableSql2 = "				SELECT 2 num"	
            TableSql2 = TableSql2 & "		,'통합' SportsType"
            TableSql2 = TableSql2 & "		,left(CONVERT(CHAR,CONVERT(DATE,CONVERT(CHAR, WriteDate, 111)),111),4) +'년 ' SrtDATE"
            TableSql2 = TableSql2 & "		,Sex"	
            TableSql2 = TableSql2 & "	FROM [SD_Member].[dbo].[tblmember]"
            TableSql2 = TableSql2 & "	WHERE delYN='N' AND YEAR(WriteDate) = '"&Years&"'"

            TableSql3 = "				SELECT 3 num"
            TableSql3 = TableSql3 & "		,'통합' SportsType"
            TableSql3 = TableSql3 & "		,'총계' SrtDATE"
            TableSql3 = TableSql3 & "		,Sex"	
            TableSql3 = TableSql3 & "	FROM [SD_Member].[dbo].[tblmember]"
            TableSql3 = TableSql3 & "	WHERE delYN='N' AND YEAR(WriteDate) = '"&Years&"'"


            TableSql =TableSql & " union all " & TableSql1  & " union all " & TableSql2 & " union all " & TableSql3

            SQL = "			SELECT num"	
            SQL = SQL & "		,'통합' SportsType"
            SQL = SQL & "		,SrtDATE"
            SQL = SQL & "		,LEFT(SrtDATE,4) YY" 
            SQL = SQL & "		,RIGHT(LEFT(SrtDATE,7),2) MM"
            SQL = SQL & "		,COUNT(SrtDATE) cnt" 
            SQL = SQL & "		,SUM(CASE SEX WHEN 'Man' THEN 1 ELSE 0 END) SEX_M" 
            SQL = SQL & "		,SUM(CASE SEX WHEN 'WoMan' THEN 1 ELSE 0 END) SEX_W"
            SQL = SQL & "	FROM (" & TableSql & " ) a "
            SQL = SQL & "	GROUP BY num, SportsType, SrtDATE"
            SQL = SQL & "	ORDER BY SportsType, SrtDATE DESC"

            'Response.Write SQL

            SET Rs = DBCon8.Execute(SQL)
            If Not(Rs.Eof Or Rs.Bof) Then 
                Do Until Rs.Eof 
                    YY              = Rs("YY")
                    SrtDate         = Rs("SrtDate")
                    cnt             = formatnumber(Rs("cnt"), 0)
                    SEX_M           = formatnumber(Rs("SEX_M"), 0)
                    SEX_W           = formatnumber(Rs("SEX_W"), 0)

                    Color_TdSubTotal = ""

                    IF SportsType  <> Rs("SportsType")  THEN 
                        SportsType = Rs("SportsType")
                        MON_SEQ = 0
                        SEQ = 0

                    END IF    

                    SELECT CASE Rs("num")
                        CASE 1 : response.write "<tr class=""subtotal"">"
                        CASE 2 : response.write "<tr class=""subtotal"">"
                        CASE 3 : response.write "<tr class=""total"">"   
                        CASE ELSE 
                            response.write "<tr style=""cursor: pointer;"" onClick=""location.href='../member_info.asp?SDate="&SrtDate&"';"">"   
                            Color_TdSubTotal ="style='background-color: #fbefe0'" 
                    END SELECT    
                %>
                
                  <td><%=SrtDate%></td>
                  <td><%=cnt%></td>
                  <td><%=SEX_M%></td>
                  <td><%=SEX_W%></td>
                </tr>
                <%
                    Color_TdSubTotal = ""
                    MON_SEQ = MON_SEQ + 1
                    SEQ = SEQ + 1
                    num = Rs("num")

                    Rs.MoveNext
                Loop 
            End If 
            %>
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
