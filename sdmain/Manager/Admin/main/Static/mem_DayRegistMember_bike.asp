<!--#include file="../../dev/dist/config.asp"-->
<!-- S: head -->
<!-- #include file="../../include/head.asp" --> 
  <!-- E: head -->
  <% 
    RoleType = "04MEMBIKE"	    '자전거 일별 계정가입자 수      
    
    dim DT_F        : DT_F      = fInject(Request("DT_F"))
    dim DT_T        : DT_T      = fInject(Request("DT_T"))
    dim SportsGB    : SportsGB  = fInject(Request("SportsGB"))                              
    dim Years       : Years     = fInject(Request("Years"))

    IF Years = "" Then Years = Year(Date())
    IF DT_F = "" Then DT_F = Dateadd("m", -1, Date())
    IF DT_T = "" Then DT_T = Date()
    
%>
  <!--#include file="../CheckRole.asp"-->
<script type="text/javascript">
    $(function(){
        $('select').on('change', function() {
            $('form[name=search_frm]').attr('action','./mem_DayRegistMember_bike.asp');
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
      <div class="navigation"> <i class="fas fa-home"></i> <i class="fas fa-chevron-right"></i> <span>통계관리</span> <i class="fas fa-chevron-right"></i> <span>가입자 회원 통계</span> <i class="fas fa-chevron-right"></i> <span>자전거</span> </div>
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
                    LSQL = "        SELECT LEFT(SrtDate, 4) Years "
                    LSQL = LSQL & " FROM [SD_Bike].[dbo].[tblMember] "
                    LSQL = LSQL & " GROUP BY LEFT(SrtDate, 4)"
                    LSQL = LSQL & " ORDER BY LEFT(SrtDate, 4) DESC "
                    
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
              </form>
            </div>
          </div>                                         
          <div class="mem_DayRegistMember_Tennis">
            <div class="table-box basic-table-box">
            <table cellspacing="0" cellpadding="0" class="table">
                <tr class="table-top">
                  <th rowspan=2>가입일자</th>
                  <th rowspan=2>총가입자수</th>
                  <th colspan=2>성별</th>
                  <!--<th colspan=6>엘리트</th>-->
                  <th colspan=5>생활체육</th>
                </tr>
                <tr class="table-top">
                  <th>남자</th>
                  <th>여자</th>
                    <!--
                  <th>소계</th> 			
                  <th>등록선수</th>
                  <th>비등록선수</th>
                  <th>지도자</th>
                  <th>보호자</th>
                  <th>일반</th>
                    -->	
                  <th>소계</th>
                  <th>선수</th>
                  <!--<th>지도자</th>-->
                  <th>보호자</th>
                  <!--<th>일반</th>-->
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
            TableSql = TableSql & "		,SportsType"
            TableSql = TableSql & "		,CONVERT(CHAR,CONVERT(DATE,SrtDATE),111) SrtDATE"
            TableSql = TableSql & "		,B.Sex"
            TableSql = TableSql & "		,ISNULL(PlayerReln,'') PlayerReln"
            TableSql = TableSql & "		,EnterType "
            TableSql = TableSql & "	FROM [SD_Bike].[dbo].[tblmember] A"
            TableSql = TableSql & "		inner join [SD_Member].[dbo].[tblmember] B on A.SD_UserID = B.UserID AND B.delYN = 'N'"
            TableSql = TableSql & "	WHERE A.delYN='N' AND A.SportsType = 'bike' AND left(A.SrtDate, 4) = '"&Years&"'"

            TableSql1 = "				SELECT 1 num"
            TableSql1 = TableSql1 & "		,SportsType"
            TableSql1 = TableSql1 & "		,left(CONVERT(CHAR,CONVERT(DATE,SrtDATE),111),7) +' 소계' SrtDATE"
            TableSql1 = TableSql1 & "		,B.Sex"
            TableSql1 = TableSql1 & "		,ISNULL(PlayerReln,'')PlayerReln"
            TableSql1 = TableSql1 & "		,EnterType "
            TableSql1 = TableSql1 & "	FROM [SD_Bike].[dbo].[tblmember] A"
            TableSql1 = TableSql1 & "		inner join [SD_Member].[dbo].[tblmember] B on A.SD_UserID = B.UserID AND B.delYN = 'N'"
            TableSql1 = TableSql1 & "	WHERE A.delYN='N' AND A.SportsType = 'bike' AND left(A.SrtDate, 4) = '"&Years&"'"

            TableSql2 = "				SELECT 2 num"
            TableSql2 = TableSql2 & "		,SportsType"
            TableSql2 = TableSql2 & "		,left(CONVERT(CHAR,CONVERT(DATE,SrtDATE),111),4) +'년 ' SrtDATE"
            TableSql2 = TableSql2 & "		,B.Sex"
            TableSql2 = TableSql2 & "		,ISNULL(PlayerReln,'')PlayerReln"
            TableSql2 = TableSql2 & "		,EnterType "
            TableSql2 = TableSql2 & "	FROM [SD_Bike].[dbo].[tblmember] A"
            TableSql2 = TableSql2 & "		inner join [SD_Member].[dbo].[tblmember] B on A.SD_UserID = B.UserID AND B.delYN = 'N'"
            TableSql2 = TableSql2 & "	WHERE A.delYN='N' AND A.SportsType = 'bike' AND left(A.SrtDate, 4) = '"&Years&"'"

            TableSql3 = "				SELECT 3 num"
            TableSql3 = TableSql3 & "		,SportsType"
            TableSql3 = TableSql3 & "		,'총계' SrtDATE"
            TableSql3 = TableSql3 & "		,B.Sex"
            TableSql3 = TableSql3 & "		,ISNULL(PlayerReln,'')PlayerReln"
            TableSql3 = TableSql3 & "		,EnterType "
            TableSql3 = TableSql3 & "	FROM [SD_Bike].[dbo].[tblmember] A"
            TableSql3 = TableSql3 & "		inner join [SD_Member].[dbo].[tblmember] B on A.SD_UserID = B.UserID AND B.delYN = 'N'"
            TableSql3 = TableSql3 & "	WHERE A.delYN='N' AND A.SportsType = 'bike' AND left(A.SrtDate, 4) = '"&Years&"'"


            TableSql =TableSql & " union all " & TableSql1  & " union all " & TableSql2 & " union all " & TableSql3

            SQL = "			SELECT num"
            SQL = SQL & "		,SportsType"
            SQL = SQL & "		,SrtDATE"
            SQL = SQL & "		,LEFT(SrtDATE,4) YY" 
            SQL = SQL & "		,RIGHT(LEFT(SrtDATE,7),2) MM"
            SQL = SQL & "		,COUNT(SrtDATE) cnt "
            SQL = SQL & "		,SUM(CASE SEX WHEN 'Man' THEN 1 ELSE 0 END) SEX_M "
            SQL = SQL & "		,SUM(CASE SEX WHEN 'WoMan' THEN 1 ELSE 0 END) SEX_W "
        '	SQL = SQL & "		,SUM(CASE EnterType WHEN 'K' THEN 1 ELSE 0 END) EnterType_K" 	
        '	SQL = SQL & "		,SUM(CASE EnterType WHEN 'E' THEN 1 ELSE 0 END) EnterType_E" 
        '	SQL = SQL & "		,SUM(CASE EnterType WHEN 'E' THEN CASE WHEN ISNULL(PlayerReln,'') IN ('R','') THEN 1 ELSE 0 END ELSE 0 END) PlayerRelnE_R" 
        '	SQL = SQL & "		,SUM(CASE EnterType WHEN 'E' THEN CASE WHEN PlayerReln IN ('K','S') THEN 1 ELSE 0 END ELSE 0 END) PlayerRelnE_K "
        '	SQL = SQL & "		,SUM(CASE EnterType WHEN 'E' THEN CASE WHEN PlayerReln IN ('A','B','Z') THEN 1 ELSE 0 END ELSE 0 END) PlayerRelnE_A "
        '	SQL = SQL & "		,SUM(CASE EnterType WHEN 'E' THEN CASE PlayerReln WHEN 'T' THEN 1 ELSE 0 END ELSE 0 END) PlayerRelnE_T" 
        '	SQL = SQL & "		,SUM(CASE EnterType WHEN 'E' THEN CASE PlayerReln WHEN 'D' THEN 1 ELSE 0 END ELSE 0 END) PlayerRelnE_D" 	
            SQL = SQL & "		,SUM(CASE EnterType WHEN 'A' THEN 1 ELSE 0 END) EnterType_A "
            SQL = SQL & "		,SUM(CASE EnterType WHEN 'A' THEN CASE WHEN ISNULL(PlayerReln,'') IN ('R','') THEN 1 ELSE 0 END ELSE 0 END) PlayerRelnA_R "
        '	SQL = SQL & "		,SUM(CASE EnterType WHEN 'A' THEN CASE PlayerReln WHEN 'K' THEN 1 ELSE 0 END ELSE 0 END) PlayerRelnA_K "
            SQL = SQL & "		,SUM(CASE EnterType WHEN 'A' THEN CASE WHEN PlayerReln IN ('A','B','Z') THEN 1 ELSE 0 END ELSE 0 END) PlayerRelnA_A "
        '	SQL = SQL & "		,SUM(CASE EnterType WHEN 'A' THEN CASE PlayerReln WHEN 'T' THEN 1 ELSE 0 END ELSE 0 END) PlayerRelnA_T "
        '	SQL = SQL & "		,SUM(CASE EnterType WHEN 'A' THEN CASE PlayerReln WHEN 'D' THEN 1 ELSE 0 END ELSE 0 END) PlayerRelnA_D "
            SQL = SQL & "	FROM (" & TableSql & " ) a "
            SQL = SQL & "	GROUP BY num, SportsType ,SrtDATE"
            SQL = SQL & "	ORDER BY SportsType, SrtDATE DESC"

            'Response.Write SQL

            SET Rs = Dbcon8.Execute(SQL)
            If Not(Rs.Eof Or Rs.Bof) Then 
                Do Until Rs.Eof 
                    YY              = Rs("YY")
                    SrtDate         = Rs("SrtDate")
                    cnt             = formatnumber(Rs("cnt"), 0)
                    SEX_M           = formatnumber(Rs("SEX_M"), 0)
                    SEX_W           = formatnumber(Rs("SEX_W"), 0)

        '			EnterType_K     = Rs("EnterType_K")
        '			EnterType_E     = formatnumber(Rs("EnterType_E"), 0)
        '			PlayerRelnE_R   = formatnumber(Rs("PlayerRelnE_R"), 0)
        '			PlayerRelnE_K   = formatnumber(Rs("PlayerRelnE_K"), 0)
        '			PlayerRelnE_A   = formatnumber(Rs("PlayerRelnE_A"), 0)
        '			PlayerRelnE_T   = formatnumber(Rs("PlayerRelnE_T"), 0)
        '			PlayerRelnE_D   = formatnumber(Rs("PlayerRelnE_D"), 0)

                    EnterType_A     = formatnumber(Rs("EnterType_A"), 0)
                    PlayerRelnA_R   = formatnumber(Rs("PlayerRelnA_R"), 0)
        '			PlayerRelnA_K   = formatnumber(Rs("PlayerRelnA_K"), 0)
                    PlayerRelnA_A   = formatnumber(Rs("PlayerRelnA_A"), 0)
        '			PlayerRelnA_T   = formatnumber(Rs("PlayerRelnA_T"), 0)
        '			PlayerRelnA_D   = formatnumber(Rs("PlayerRelnA_D"), 0)


                    Color_TdSubTotal = ""

                    IF SportsType  <> Rs("SportsType")  THEN 
                        SportsType      = Rs("SportsType")
                  
                        MON_SEQ=0
                        SEQ =0

                    END IF                     
                if Rs("num") = 1 then 
                %>
                <tr class="subtotal">
                <%
                elseif Rs("num") = 2 then 
                 %>
                <tr class="subtotal">
                <%
                elseif Rs("num") =3 then 
                %>
                <tr class="total">
                <%
                else
                %>
                <tr>
                <%
                Color_TdSubTotal ="style='background-color: #fbefe0'" 
                end if 
                %>
                  <td><%=SrtDate%></td>
                  <td><%=cnt%></td>
                  <td><%=SEX_M%></td>
                  <td><%=SEX_W%></td>
                <!--
                  <td <%=Color_TdSubTotal %>><%=EnterType_E%></td>
                  <td><%=PlayerRelnE_R%></td>
                  <td><%=PlayerRelnE_K%></td>
                  <td><%=PlayerRelnE_T%></td>
                  <td><%=PlayerRelnE_A%></td>
                  <td><%=PlayerRelnE_D%></td>
                -->
                  <td <%=Color_TdSubTotal%>><%=EnterType_A%></td>
                  <td><%=PlayerRelnA_R%></td>
                  <!--<td><%=PlayerRelnA_T%></td>-->
                  <td><%=PlayerRelnA_A%></td>
                  <!--<td><%=PlayerRelnA_D%></td>-->
                </tr>
                <%
                    Color_TdSubTotal =""
                    MON_SEQ=MON_SEQ+1
                    SEQ = SEQ+1
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
