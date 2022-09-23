<!--#include file="../dev/dist/config.asp"-->
<!--#include file="head.asp"-->

<% 
	RoleType = "TMS"	
%>
<!--#include file="CheckRole.asp"-->
<link href="./css/lib/bootstrap.min.css" rel="stylesheet" type="text/css" />
<script src="../front/dist/js/bootstrap.min.js" type="text/javascript"></script>

<% 

tp        = fInject(Request("tp"))  
Years     = fInject(Request("Years"))

if Years="" then 
    YNSQL = "SELECT LEFT(CONVERT(NVARCHAR,GETDATE(),112),4) Years"
    Set YNRs = Dbcon5.Execute(YNSQL)
    
    If Not(YNRs.Eof Or YNRs.Bof) Then 
	    Years =YNRs("Years")
    End If 
End If 

if tp ="" then 
    tp="EE1"
end if 

 %> 

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

<section>
    <div id="content">
        <div class="loaction">
            <strong>순방문자 통계</strong>
            <span id="Depth_GameTitle">일별 순방문자 통계</span>
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
        
        <div class="table-list-wrap">
            <table class="table-list">
            <tbody>
             <tr class="table-top">
                <td width="80px" rowspan=2>매체유형</td>                
                <td width="60px"rowspan=2>일자</td>
                <td width="70px"rowspan=2>Total</td> 
                <td width="70px" colspan=24>시간대</td> 
            </tr>
            <tr class="table-top"> 
                <%
                    for i=0 to 23 
                        sdc="00"
                        if i <10 then
                            sdc = "0"&i
                        else
                            sdc = ""&i
                        end if 
                    %>
                     <td width="50px"><%=sdc %>시</td> 
                    <%
                    next
                %>
            </tr>
                <%
                SQL ="exec Search_Sd_VisitHis_Count '"&tp&"','"&Years&"0101','"&Years&"1231'"
               ' Response.Write SQL
                Set Rs = Dbcon5.Execute(SQL)
                If Not(Rs.Eof Or Rs.Bof) Then 
                Do Until Rs.Eof    
                %>
                <% 
                    SET_DT =""
                    SET_DT_class =""

                    IF Rs("COL") ="년별" THEN
                       SET_DT = "총계"
                       SET_DT_class = "total" 
                    END IF 
                    		
                    IF Rs("COL") ="월별" THEN
                       SET_DT = Rs("MONTHS")&"월 소계"
                       SET_DT_class = "subtotal" 
                    END IF 
                        
                    IF Rs("COL") ="일별" THEN
                       SET_DT = Rs("MONTHS")&"월 "&Rs("DAYS")&"일"
                       SET_DT_class = "Days" 
                    END IF 
                    
                %>
                <tr class="<%=SET_DT_class %>">
                    <td><%=Rs("STATIC_MEDIA_Nm")%></td>       
                    <td><%=SET_DT %> </td>       
                    <td align=right>&nbsp;<%=FormatNumber(Rs("SET_CNT"),0)	 %>&nbsp;</td>    
                    <%
                    for i=0 to 23 
                        sdc="00"
                        if i <10 then
                            sdc = "0"&i
                        else
                            sdc = ""&i
                        end if 
                    %>
                         <td align=right>&nbsp;<%=FormatNumber(Rs("SET_"&sdc&"_CNT"),0)	 %>&nbsp;</td>
                    <%
                    next
                    %>
               </tr>
                <%
                Rs.MoveNext
                Loop 
                End If 
                %>
          </tbody>
        </table>
        </div> 
    </div> 
</section>
    <!-- sticky -->
<script src="./js/js.js"></script>
<!-- E : container -->
<!--#include file="footer.asp"-->