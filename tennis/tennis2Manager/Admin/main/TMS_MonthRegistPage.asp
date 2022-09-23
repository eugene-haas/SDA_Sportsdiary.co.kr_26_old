<!--#include file="../dev/dist/config.asp"-->
<!--#include file="head.asp"-->

<% 
	RoleType = "TMS1"	
%>
<!--#include file="CheckRole.asp"-->
<link href="./css/lib/bootstrap.min.css" rel="stylesheet" type="text/css" />
<script src="../front/dist/js/bootstrap.min.js" type="text/javascript"></script>
<%

' Tennis_DBOpen Tennis_DBClose
tp  = fInject(Request("tp")) 
Years = fInject(Request("Years"))
ORDERBY = fInject(Request("ORDERBY")) 

if tp ="" then tp="EE1"
if ORDERBY ="" then ORDERBY="0" 
if Years="" then Years = Year(Date())
 
%>
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

<section>
    <div id="content">
        <div class="loaction">
            <strong>순방문자 통계</strong>
            <span id="Depth_GameTitle">월별 순방문자 통계</span>
        </div>  
        <form method="post" name="search_frm" id="search_frm" > 
        <div class="sch month-regis-sch">
						<div class="new-serch">
						<ul>
							<li>
								<span class="l-name">기간</span>
								<span class="r-con">
									<select id="Years" name="Years">
										<%
											YEARSQL = " select left(convert(nvarchar,WORK_DT,112),4) Years "
												YEARSQL =YEARSQL+ " From tblSdStaticVisitHis "
												YEARSQL =YEARSQL+ " group by left(convert(nvarchar,WORK_DT,112),4)"
												YEARSQL =YEARSQL+ " ORDER BY left(convert(nvarchar,WORK_DT,112),4) DESC "

											Set YRs = Dbcon5.Execute(YEARSQL)

											If Not(YRs.Eof Or YRs.Bof) Then 
												Do Until YRs.Eof 
														%>
														<option value="<%=YRs("Years")%>" <%If YRs("Years") = Years Then %>selected<% Years= YRs("Years")  
														End If
														%>
														>
														<%=YRs("Years")%></option>
														<%
											YRs.MoveNext
												Loop 
											End If 
										%>
									</select>
								</span>
							</li>
							<li>
								<span class="l-name">구분</span>
								<span class="r-con">
									<select name="tp" id="tp">
										<%
												SQL = "SELECT STATIC_MEDIA_TP tp,CASE WHEN A.STATIC_MEDIA_TP = 'EE1' THEN 'KATA' WHEN A.STATIC_MEDIA_TP = 'SD1' THEN '선수용' WHEN A.STATIC_MEDIA_TP = 'TE1' THEN '팀매니저' ELSE '' END tpname FROM tblSdStaticVisitHis A group by STATIC_MEDIA_TP"
												Set Rs = Dbcon5.Execute(SQL)

												If Not(Rs.Eof Or Rs.Bof) Then 
														Do Until Rs.Eof 

																if tp = Rs("tp") then 
																		%>
																		<option value="<%=Rs("tp")%>" selected="selected"><%=Rs("tpname")%></option>
																		<%
																else
																		%>
																		<option value="<%=Rs("tp")%>"><%=Rs("tpname")%></option>
																		<%
																end if 
														Rs.MoveNext
														Loop 
												End If 

												Rs.Close
												Set Rs = Nothing 

										%>
									</select>
								</span>
							</li>
							<a href="javascript:chk_frm('FND');" class="btn" id="btnview" accesskey="s">검색(S)</a>
							<a href="javascript:chk_frm('FILE');" class="btn" id="A1" accesskey="F">파일저장(F)</a>
							
						</ul>
					</div>

           
        </div>
        </form>
        
        <div class="table-list-wrap day-regist">
            <table class="table-list">
         
             <tr class="table-top">
                <td width="80px">매체유형</td>                
                <td width="90px">누적합계</td>
                <td width="80px">1월</td>
                <td width="80px">2월</td>
                <td width="80px">3월</td>
                <td width="80px">4월</td>
                <td width="80px">5월</td>
                <td width="80px">6월</td>
                <td width="80px">7월</td>
                <td width="80px">8월</td>
                <td width="80px">9월</td>
                <td width="80px">10월</td>
                <td width="80px">11월</td>
                <td width="80px">12월</td>
            </tr>
            <%
                SQL = "SELECT * FROM (select a.매체유형" & _ 
                    " ,sum(case  when a.일자 like '"&Years&"%' then a.합계 else 0 end ) CSum17 " & _ 
                    " ,sum(case a.일자 when '"&Years&"-01' then a.합계  else 0 end ) CSum1701 " & _ 
                    " ,sum(case a.일자 when '"&Years&"-02' then a.합계  else 0 end ) CSum1702 " & _ 
                    " ,sum(case a.일자 when '"&Years&"-03' then a.합계  else 0 end ) CSum1703 " & _ 
                    " ,sum(case a.일자 when '"&Years&"-04' then a.합계  else 0 end ) CSum1704 " & _ 
                    " ,sum(case a.일자 when '"&Years&"-05' then a.합계  else 0 end ) CSum1705 " & _ 
                    " ,sum(case a.일자 when '"&Years&"-06' then a.합계  else 0 end ) CSum1706 " & _ 
                    " ,sum(case a.일자 when '"&Years&"-07' then a.합계  else 0 end ) CSum1707 " & _ 
                    " ,sum(case a.일자 when '"&Years&"-08' then a.합계  else 0 end ) CSum1708 " & _ 
                    " ,sum(case a.일자 when '"&Years&"-09' then a.합계  else 0 end ) CSum1709 " & _ 
                    " ,sum(case a.일자 when '"&Years&"-10' then a.합계  else 0 end ) CSum1710 " & _ 
                    " ,sum(case a.일자 when '"&Years&"-11' then a.합계  else 0 end ) CSum1711 " & _ 
                    " ,sum(case a.일자 when '"&Years&"-12' then a.합계  else 0 end ) CSum1712 " & _ 
                    " from (SELECT CASE WHEN A.STATIC_MEDIA_TP = 'EE1' THEN 'KATA' WHEN A.STATIC_MEDIA_TP = 'SD1' THEN '선수용' WHEN A.STATIC_MEDIA_TP = 'TE1' THEN '팀매니저' ELSE '' END 매체유형 " & _ 
                    " 		  ,SUBSTRING(A.SET_DT,1,4) + '-' + SUBSTRING(A.SET_DT,5,2)  일자,SUM(A.SET_CNT) 합계 " & _ 
                    " 	FROM tblSdStaticVisitHis A " & _
                    " 	WHERE A.DEL_YN = 'N'" & _                    
                    " 	 and A.STATIC_MEDIA_TP='"&tp&"'" & _ 
                    " 	GROUP BY A.STATIC_MEDIA_TP,SUBSTRING(A.SET_DT,1,4) + '-' + SUBSTRING(A.SET_DT,5,2))a " & _ 
                    " group by a.매체유형 ) A " 

                Set Rs = Dbcon5.Execute(SQL)
                
                If Not(Rs.Eof Or Rs.Bof) Then 
                Do Until Rs.Eof                 
                %>
                <tr>
                    <td><%=Rs("매체유형")%></td>                    
                    <td align=right>&nbsp;<%=FormatNumber(Rs("CSum17"),0)	 %>&nbsp;</td>
                    <td align=right>&nbsp;<%=FormatNumber(Rs("CSum1701"),0)	 %>&nbsp;</td>
                    <td align=right>&nbsp;<%=FormatNumber(Rs("CSum1702"),0)	 %>&nbsp;</td>
                    <td align=right>&nbsp;<%=FormatNumber(Rs("CSum1703"),0)	 %>&nbsp;</td>
                    <td align=right>&nbsp;<%=FormatNumber(Rs("CSum1704"),0)	 %>&nbsp;</td>
                    <td align=right>&nbsp;<%=FormatNumber(Rs("CSum1705"),0)	 %>&nbsp;</td>
                    <td align=right>&nbsp;<%=FormatNumber(Rs("CSum1706"),0)	 %>&nbsp;</td>
                    <td align=right>&nbsp;<%=FormatNumber(Rs("CSum1707"),0)	 %>&nbsp;</td>
                    <td align=right>&nbsp;<%=FormatNumber(Rs("CSum1708"),0)	 %>&nbsp;</td>
                    <td align=right>&nbsp;<%=FormatNumber(Rs("CSum1709"),0)	 %>&nbsp;</td>
                    <td align=right>&nbsp;<%=FormatNumber(Rs("CSum1710"),0)	 %>&nbsp;</td>
                    <td align=right>&nbsp;<%=FormatNumber(Rs("CSum1711"),0)	 %>&nbsp;</td>
                    <td align=right>&nbsp;<%=FormatNumber(Rs("CSum1712"),0) %>&nbsp;</td>
               </tr>
                <%
                Rs.MoveNext
                Loop 
                End If 
 
 %>
        </table>
        </div> 
    </div> 
</section>
    <!-- sticky -->
<script src="./js/js.js"></script>

<script type="text/javascript">
  //  chk_frm("FND");
</script>
<!-- E : container -->
<!--#include file="footer.asp"-->