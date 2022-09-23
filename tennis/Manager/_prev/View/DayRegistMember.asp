<!--#include virtual="/Manager/Common/common_header.asp"-->
<!--#include virtual="/Manager/Library/config.asp"-->
<!-- bootstrap 부트스트랩 -->
<%

DT_F    = fInject(Request("DT_F"))
DT_T    = fInject(Request("DT_T"))
SportsGB  = fInject(Request("SportsGB")) 

'Response.Write  "DT_F:"&DT_F &"</br>"
'Response.Write  "DT_T:"&DT_T&"</br>"
'Response.Write  "SportsGB:"&SportsGB&"</br>"

if DT_F ="" then 
    DT_F=Dateadd("m",-1,Date())
end if 

if DT_T ="" then 
    DT_T=Date()
end if 

 %>
<link rel="stylesheet" href="../css/lib/bootstrap.min.css">
<script src="../js/library/bootstrap.min.js"></script>

<script type="text/javascript">
    function chk_frm() {
        var sf = document.search_frm;

        sf.submit();
    } 
    function chk_frm_file() {
        var sf = document.search_frm;
        sf.action = "./file_DayRegistMember.asp";
        sf.submit();
    }
     
     
</script>

<section>
    <div id="content">
        <div class="loaction">
            <strong>회원관리</strong>
            <span id="Depth_GameTitle"> 일별가입자수 </span>
        </div>  
        <form method="post" name="search_frm" id="search_frm" action="DayRegistMember.asp"> 
        <div class="sch month-regis-sch">
            <table class="sch-table">
                <caption>검색조건 선택 및 입력</caption>
                <colgroup>
                    <!-- <col width="40px" />
                    <col width="80px" />
                    <col width="80px" />-->
                    <col width="60px" />
                    <col width="120px" />
                    <col width="100px" />
                    <col width="*" />
                </colgroup>              
                <tbody>
                    <tr>
                        <!--<th scope="row"><label for="competition-name-1">기간</label></th>
                        <td><input type="date" name="DT_F" id="DT_F" value=" "/></td>   
                        <td><input type="date" name="DT_T" id="DT_T" value=" "/></td>-->
                        <th scope="row"><label for="competition-name-2">종목</label></th>                                     
                        <td>
                            <select name="SportsGB" id="SportsGB">
                                    <%
                                        SQL = "SELECT PubName , PubCode  FROM Sportsdiary.dbo.tblPubCode WHERE DelYN='N' AND PPubCode='sd000'"

                                        If Request.Cookies("HostCode") <> "" Then 
                                            SQL = SQL&" AND SportsGb = '"&Request.Cookies("SportsGb")&"'"
                                        End If 

                                        Set Rs = Dbcon.Execute(SQL)

                                        If Not(Rs.Eof Or Rs.Bof) Then 
                                            Do Until Rs.Eof 

                                                if SportsGB = Rs("PubCode") then 
                                                    %>
                                                    <option value="<%=Rs("PubCode")%>" selected="selected"><%=Rs("PubName")%></option>
                                                    <%
                                                else
                                                    %>
                                                    <option value="<%=Rs("PubCode")%>"><%=Rs("PubName")%></option>
                                                    <%
                                                end if 
                                            Rs.MoveNext
                                            Loop 
                                        End If 

                                        Rs.Close
                                        Set Rs = Nothing 

                                    %>
                            </select>
                        </td>   
                        
                        <td><a href="javascript:chk_frm();" class="btn" id="btnview" accesskey="s">검색(S)</a></td>
                          <td><a  class="btn" id="btnExport" onclick="chk_frm_file();" accesskey="F">파일저장(F)</a></td>
                    </tr>
                </tbody>
            </table>
        </div>
        </form>

            <%
                SportsType=""
                SEQ =0
                MON_SEQ =0
                YY=""
                MM=""
                num=3
                hidden ="hidden"

                TableSql ="select 0 num,SportsType,convert(nvarchar,convert(date,SrtDate),111) SrtDate,Sex,isnull(PlayerReln,'') PlayerReln, EnterType from tblmember where delyn='N' "
    
                TableSql1 ="select 1 num,SportsType,left(convert(nvarchar,convert(date,SrtDate),111),7) +' 소계' SrtDate,Sex,isnull(PlayerReln,'')PlayerReln,EnterType from tblmember where delyn='N' "
    
                TableSql2 ="select 2 num,SportsType,left(convert(nvarchar,convert(date,SrtDate),111),4) +'년 ' SrtDate,Sex,isnull(PlayerReln,'')PlayerReln,EnterType from tblmember where delyn='N' "

                TableSql3 ="select 3 num,SportsType,'총계' SrtDate,Sex,isnull(PlayerReln,'')PlayerReln,EnterType from tblmember where delyn='N' "
    
                if SportsGB <> "" then 
                    TableSql = TableSql &" and SportsType = '"&SportsGB&"'"
                    TableSql1 = TableSql1 &" and SportsType = '"&SportsGB&"'"
                    TableSql2 = TableSql2 &" and SportsType = '"&SportsGB&"'"
                    TableSql3 = TableSql3 &" and SportsType = '"&SportsGB&"'"
                end if 

                TableSql =TableSql & " union all " & TableSql1  & " union all " & TableSql2 & " union all " & TableSql3
                
                        '선수(R,'')
                        '비등록선수(K)
                        '예비선수(S)
                        '보호자(A,B,Z)
                        '지도자(T)
                        '일반(D)
                SQL = "select num,SportsType,SrtDate, LEFT(SrtDate,4) YY ,RIGHT(LEFT(SrtDate,7),2) MM" & _
                        " ,COUNT(SrtDate) cnt ,sum(case SEX when 'Man' then 1 else 0 end ) SEX_M ,sum(case SEX when 'WoMan' then 1 else 0 end ) SEX_W " & _
                        " ,sum(case EnterType when 'K' then 1 else 0 end ) EnterType_K " & _
                        " ,sum(case EnterType when 'E' then 1 else 0 end ) EnterType_E " & _
                        
                        " ,sum(case EnterType when 'E' then case  when isnull(PlayerReln,'') IN ('R','') then 1 else 0 end else 0 end ) PlayerRelnE_R " & _
                        " ,sum(case EnterType when 'E' then case  when PlayerReln IN ('K','S') then 1 else 0 end else 0 end ) PlayerRelnE_K " & _
                        " ,sum(case EnterType when 'E' then case  when PlayerReln IN ('A','B','Z') then 1 else 0 end else 0 end ) PlayerRelnE_A " & _
                        " ,sum(case EnterType when 'E' then case PlayerReln when 'T' then 1 else 0 end else 0 end ) PlayerRelnE_T " & _
                        " ,sum(case EnterType when 'E' then case PlayerReln when 'D' then 1 else 0 end else 0 end ) PlayerRelnE_D " & _

                        " ,sum(case EnterType when 'A' then 1 else 0 end ) EnterType_A " & _
                        " ,sum(case EnterType when 'A' then case  when isnull(PlayerReln,'') IN ('R','') then 1 else 0 end else 0 end ) PlayerRelnA_R " & _
                        " ,sum(case EnterType when 'A' then case PlayerReln when 'K' then 1 else 0 end else 0 end ) PlayerRelnA_K " & _
                        " ,sum(case EnterType when 'A' then case  when PlayerReln IN ('A','B','Z') then 1 else 0 end else 0 end ) PlayerRelnA_A " & _
                        " ,sum(case EnterType when 'A' then case PlayerReln when 'T' then 1 else 0 end else 0 end ) PlayerRelnA_T " & _
                        " ,sum(case EnterType when 'A' then case PlayerReln when 'D' then 1 else 0 end else 0 end ) PlayerRelnA_D " & _

                        " from (" & TableSql & " ) a " & _
                        " group by num,SportsType,SrtDate order by  SportsType,SrtDate DESC--num desc, "

                'Response.Write SQL
                Set Rs = Dbcon.Execute(SQL)
                If Not(Rs.Eof Or Rs.Bof) Then 
                Do Until Rs.Eof 

                YY              = Rs("YY")
                SrtDate         = Rs("SrtDate")
                cnt             = formatnumber(Rs("cnt"), 0)
                SEX_M           = formatnumber(Rs("SEX_M"), 0)
                SEX_W           = formatnumber(Rs("SEX_W"), 0)

                EnterType_K     = Rs("EnterType_K")

                EnterType_E     = formatnumber(Rs("EnterType_E"), 0)
                PlayerRelnE_R   = formatnumber(Rs("PlayerRelnE_R"), 0)
                PlayerRelnE_K   = formatnumber(Rs("PlayerRelnE_K"), 0)
                PlayerRelnE_A   = formatnumber(Rs("PlayerRelnE_A"), 0)
                PlayerRelnE_T   = formatnumber(Rs("PlayerRelnE_T"), 0)
                PlayerRelnE_D   = formatnumber(Rs("PlayerRelnE_D"), 0)

                EnterType_A     = formatnumber(Rs("EnterType_A"), 0)
                PlayerRelnA_R   = formatnumber(Rs("PlayerRelnA_R"), 0)
                PlayerRelnA_K   = formatnumber(Rs("PlayerRelnA_K"), 0)
                PlayerRelnA_A   = formatnumber(Rs("PlayerRelnA_A"), 0)
                PlayerRelnA_T   = formatnumber(Rs("PlayerRelnA_T"), 0)
                PlayerRelnA_D   = formatnumber(Rs("PlayerRelnA_D"), 0)
                
                 
                 Color_TdSubTotal =""
                IF SportsType  <> Rs("SportsType")  THEN 
                    SportsType      = Rs("SportsType")
                %>
                    <div class="table-list-wrap">
                        <table class="table-list">
                            <tr class="table-top">
                                <td rowspan=2>가입일자</td>
                                <td rowspan=2>총가입자수</td>

                                <td colspan=2>성별</td>

                                <td colspan=6>엘리트</td>
                                <td colspan=5>생활체육</td>
                            </tr>
                            <tr class="table-top">
                                <td>남자</td>
                                <td>여자</td>

                                <td>소계</td>
                                <td>등록선수</td>
                                <td>비등록선수</td>
                                <td>지도자</td>
                                <td>보호자</td>
                                <td>일반</td>

                                <td>소계</td>
                                <td>선수(관원)</td>
                                <td>지도자(관장/사범)</td>
                                <td>보호자</td>
                                <td>일반</td>
                            </tr>
                   <%
                MON_SEQ=0
                SEQ =0
                END IF                     
                            if Rs("num") =1 then 
                             %><tr class="subtotal"><%
                            elseif Rs("num") =2 then 
                             %><tr class="total"><%
                            elseif Rs("num") =3 then 
                             %><tr class="subtotal"><%
                             'Color_TdSubTotal ="style='background-color: #dcede0'" 
                            else
                             %><tr onclick="location.href='/Manager/View/memberinfo.asp?SDate=<%=SrtDate %>&EDate=<%=SrtDate %>';location.target='fPage';"><%
                             Color_TdSubTotal ="style='background-color: #fbefe0'" 
                            end if 
                            %> 
                                <td><%=SrtDate %></td>
                                <td><%=cnt %></td>
                                <td><%=SEX_M %></td>
                                <td><%=SEX_W %></td>

                                <td <%=Color_TdSubTotal %> ><%=EnterType_E %></td>
                                <td><%=PlayerRelnE_R %></td>
                                <td><%=PlayerRelnE_K %></td>
                                <td><%=PlayerRelnE_T %></td>
                                <td><%=PlayerRelnE_A %></td>
                                <td><%=PlayerRelnE_D %></td>

                                <td <%=Color_TdSubTotal %> ><%=EnterType_A %></td>
                                <td><%=PlayerRelnA_R %></td>
                                <td><%=PlayerRelnA_T %></td>
                                <td><%=PlayerRelnA_A %></td>
                                <td><%=PlayerRelnA_D %></td>
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
</section>
    <!-- sticky -->
<script src="../js/js.js"></script>
<!-- E : container -->