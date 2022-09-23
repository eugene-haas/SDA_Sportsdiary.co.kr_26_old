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
    Months     = fInject(Request("Months"))   
   
    if Years="" then Years = Year(Date())
    if Months="" then Months = Month(Date())
    if tp ="" then tp="EE1"
    if ORDERBY ="" then ORDERBY="1"

    '해당월의 마지막일 조회 
    Days = right(DateSerial(Years, Months + 1 , 0), 2)
%>

<script type="text/javascript">
    function chk_frm(val) {
        var sf = document.search_frm;

        if (val == "FND") {
            sf.action = "./TMS_MonthByDayViewPage_Count.asp";
        } else {
            sf.action = "./TMS_file_MonthByDayViewPage_Count.asp";
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
            <span id="Depth_GameTitle">일별 페이지 사용 통계</span>
        </div>  
        <form method="post" name="search_frm" id="search_frm" > 
        <div class="sch month-regis-sch">   
					<div class="new-serch">
						<ul>
							<li>
								<span class="l-name">기간</span>
								<span class="r-con">
									<select id="Years" name="Years" style="width:49%;margin-right:2%;">
									 <%
											YEARSQL = "            select left(convert(nvarchar,WORK_DT,112),4) Years "
												YEARSQL = YEARSQL & " From tblSdStaticVisitHis "
												YEARSQL = YEARSQL & " group by left(convert(nvarchar,WORK_DT,112),4)"
												YEARSQL = YEARSQL & " ORDER BY left(convert(nvarchar,WORK_DT,112),4) DESC "

											Set YRs = DBCon5.Execute(YEARSQL)

											If Not(YRs.Eof Or YRs.Bof) Then 
												Do Until YRs.Eof 
														%>
														<option value="<%=YRs("Years")%>" <%If YRs("Years") = Years Then response.write "selected" End If%>><%=YRs("Years")%>년</option>
						<%
												YRs.MoveNext
												Loop 
											End If 
										%>
									</select>
									<select id="Months" name="Months" style="width:49%">
									 <%
										 For i = 1 To 12
														%>
														<option value="<%=i%>" <%If i = cint(Months) Then response.write "selected" End If%>><%=i%>월</option>
						<%
										 Next
										%>
									</select>
								</span>
							</li>
							<li>
								<span class="l-name">구분</span>
								<span class="r-con">
									<select name="tp" id="tp">
									<%
									SQL = "        SELECT STATIC_MEDIA_TP tp"
									SQL = SQL & "      ,CASE "
									SQL = SQL & "          WHEN A.STATIC_MEDIA_TP = 'EE1' THEN 'KATA' "
									'SQL = SQL & "          WHEN A.STATIC_MEDIA_TP = 'SD1' THEN '선수용' "
									'SQL = SQL & "          WHEN A.STATIC_MEDIA_TP = 'TE1' THEN '팀매니저' "
									SQL = SQL & "           ELSE '' "
									SQL = SQL & "           END tpname "
									SQL = SQL & "   FROM tblSdStaticHis A "
									SQL = SQL & "   GROUP BY STATIC_MEDIA_TP "

									SET Rs = DBCon5.Execute(SQL)
									If Not(Rs.Eof Or Rs.Bof) Then 
											Do Until Rs.Eof 
													%>
													<option value="<%=Rs("tp")%>" <%if tp = Rs("tp") then response.write "selected" End IF%>><%=Rs("tpname")%></option>
													<%
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
										<option value="0" <%IF ORDERBY ="0" THEN response.write "selected" End IF%>>페이지명</option>
										<option value="1" <%IF ORDERBY ="1" THEN response.write "selected" End IF%>>누적합계</option>                               
									</select>
								</span>
							</li>
							<a href="javascript:chk_frm('FND');" class="btn" id="btnview" accesskey="s">검색(S)</a>
							<a href="javascript:chk_frm('FILE');" class="btn" id="btnview" accesskey="F">파일저장(F)</a>
						</ul>
					</div>
        </div>
        </form>
                                                          
        <div class="table-list-wrap month-regist">
            <table class="table-list">
             <tr class="table-top">
                <td width="80px">매체유형</td>
                <td width="300px">페이지URL</td>
                <td width="300px">페이지명</td>
                <td width="60px">순위</td> 
                <td width="150px"><%=Years%>. <%=Months%> 누적합계</td>
                <%For i=1 to Days%>
                <td width="50px"><%=i%>일</td>
                <%Next%>                                                              
            </tr>
            <%
                'Response.Write  colStr
                SQL ="EXEC Search_Sd_ViewTouch_PageCount '"&tp&"','"&Years&"','"&Months&"','"&Days&"','"&ORDERBY&"'"
                SET Rs = Dbcon.Execute(SQL)
                If Not(Rs.Eof Or Rs.Bof) Then 
                    Do Until Rs.Eof 
                    %>
                <tr>
                    <td><%=Rs("STATIC_MEDIA_TP_NM")%></td>
                    <td align=left><%=Rs("URL_FILE_NM")%></td>
                    <td align=left><%=Rs("URL_FILE_INFO")%></td>
                    <td align=right><%=FormatNumber(Rs("NUM"),0)%></td>
                    <td align=right><%=FormatNumber(Rs("STR_SUM"),0)%></td>    
                    <%For i=1 to Days%>    
                    <td align=right><%=FormatNumber(Rs("Day"&i),0)%></td>
                    <%Next%>      
               </tr>
                <%
                        Rs.MoveNext
                    Loop 
                End If 
                   Rs.Close
                SET Rs = Nothing 
             %>
        </table>
        </div> 
    </div> 
</section>
    <!-- sticky -->
<script src="./js/js.js"></script>
<!-- E : container -->
<!--#include file="footer.asp"-->