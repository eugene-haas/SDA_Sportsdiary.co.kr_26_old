<!--#include file="../dev/dist/config.asp"-->
<!--#include file="head.asp"-->

<% 
	RoleType = "TMS2"	
%>
<!--#include file="CheckRole.asp"-->

<link href="./css/lib/bootstrap.min.css" rel="stylesheet" type="text/css" />
<script src="../front/dist/js/bootstrap.min.js" type="text/javascript"></script>
<%
tp        = fInject(Request("tp")) 
ORDERBY   = fInject(Request("ORDERBY")) 
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

if ORDERBY ="" then 
    ORDERBY="1"
end if 

%>

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

<section>
    <div id="content">
        <div class="loaction">
            <strong>페이지 통계</strong>
            <span id="Depth_GameTitle">월별 페이지 사용 통계</span>
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
														<option value="<%=YRs("Years")%>" <%If YRs("Years") = Years Then response.write "selected" End If%>><%=YRs("Years")%></option>
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
											SQL = "SELECT STATIC_MEDIA_TP tp,CASE  WHEN A.STATIC_MEDIA_TP = 'EE1' THEN 'KATA' WHEN A.STATIC_MEDIA_TP = 'SD1' THEN '선수용' WHEN A.STATIC_MEDIA_TP = 'TE1' THEN '팀매니저' ELSE '' END tpname FROM tblSdStaticHis A group by STATIC_MEDIA_TP"
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
							<li>
								<span class="l-name">정렬기준</span>
								<span class="r-con">
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
								</span>
							</li>
							<a href="javascript:chk_frm('FND');" class="btn" id="btnview" accesskey="s">검색(S)</a>
												<a href="javascript:chk_frm('FILE');" class="btn" id="btnview" accesskey="F">파일저장(F)</a>
						</ul>
					</div>


        </div>
        </form>
        <%
            SQL ="exec Search_Sd_ViewTouch_Count '"&tp&"','"&Years&"0101','"&Years&"1231','"&ORDERBY&"','NAME'"
            C_YEARS=""
         %>
        <div class="table-list-wrap month-regist">
            <table class="table-list">
             <tr class="table-top">
                <td width="80px">매체유형</td>
                <td width="170px">페이지URL</td>
                <td width="450px">페이지명</td>
                <td width="60px">순위</td> 
                <%
                    colStr =""
                    Set Rs = Dbcon5.Execute(SQL)
                    If Not(Rs.Eof Or Rs.Bof) Then 
                    Do Until Rs.Eof 

                    if C_YEARS <> Rs("C_YEARS") then
                        colStr = colStr  &"CNT"& Rs("C_YEARS") & "|"
                %>
                    <td width="90px"><%=Rs("C_YEARS") %>년 <br />누적합계</td>
                <%
                    C_YEARS = Rs("C_YEARS")
                    end if 
                %>
                    <td width="90px"><%=Rs("C_MONTHS") %> 월</td>
                <%
                      colStr = colStr  &"CNT"& Rs("C_YEARS")& Rs("C_MONTHS") & "|"

                    Rs.MoveNext
                    Loop 
                    End If 
                 %>
            </tr>
            <%
                'Response.Write  colStr
                SQL ="exec Search_Sd_ViewTouch_Count '"&tp&"','"&Years&"0101','"&Years&"1231','"&ORDERBY&"','DATA'"
                Set Rs = Dbcon5.Execute(SQL)
                If Not(Rs.Eof Or Rs.Bof) Then 
                Do Until Rs.Eof 
                %>
                <tr>
                    <td><%=Rs("C_STATIC_MEDIA_TP_Nm")	 %></td>
                    <td align=left>&nbsp;<%=Rs("URL_FILE_NM")	 %>&nbsp;</td>
                    <td align=left>&nbsp;<%=Rs("URL_FILE_INFO")	 %>&nbsp;</td>
                    <td align=right>&nbsp;<%=FormatNumber(Rs("num"),0)	 %>&nbsp;</td>

                    <%
                       
                        if colStr <> "" then
                            colstrC = split(colStr,"|") 
                            for i=0 to UBound(colstrC)
                                if colstrC(i) <> "" then 
                                %>
                                 <td align=right>&nbsp;<%=FormatNumber(Rs(colstrC(i)),0)	 %>&nbsp;</td>
                                <%
                                end if 
                            next
                        end if    
                    %>
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
<!-- E : container -->
<!--#include file="footer.asp"-->