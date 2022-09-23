<!--#include file="../dev/dist/config.asp"-->
<!-- bootstrap 부트스트랩 -->
<%
	Server.ScriptTimeout = 90000 
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

	SaveFilename = replace(left(now(),10),"-","")&Hour(now())&Minute(now()) &".xls"  '확장자도 지정할것..
	
	Response.contenttype="application/vnd.ms-excel" 
	Response.AddHeader "Content-Disposition","attachment;filename=" & SaveFilename
	Response.CacheControl = "public"	'버퍼링하지 않고 바로 다운로드 창
	
 %>
<section>
<div id="content">
  <div class="loaction"> <span id="Depth_GameTitle"><strong><%=Years%>일별 페이지 사용 통계</strong></span> </div>
  <div class="table-list-wrap month-regist">
    <table class="table-list" border="1">
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
                Set Rs = Dbcon5.Execute(SQL)
                If Not(Rs.Eof Or Rs.Bof) Then 
                Do Until Rs.Eof    
                %>
                <% 
                    SET_DT =""
                    SET_DT_class =""

                    IF Rs("COL") ="년별" THEN
                       SET_DT = "총계"
                       SET_DT_class = "Years" 
                    END IF 
                    		
                    IF Rs("COL") ="월별" THEN
                       SET_DT = Rs("MONTHS")&"월 소계"
                       SET_DT_class = "Month" 
                    END IF 
                        
                    IF Rs("COL") ="일별" THEN
                       SET_DT =Rs("MONTHS")&"월 " & Rs("DAYS")&"일"
                       SET_DT_class = "Days" 
                    END IF 
                    
                %>
                <tr class="<%=SET_DT_class %>">
                    <td><%=Rs("STATIC_MEDIA_Nm")%></td>       
                    <td><%=SET_DT %> </td>       
                    <td align=right><%=FormatNumber(Rs("SET_CNT"),0)%></td>    
                    <%
                    for i=0 to 23 
                        sdc="00"
                        if i <10 then
                            sdc = "0"&i
                        else
                            sdc = ""&i
                        end if 
                    %>
                         <td align=right><%=FormatNumber(Rs("SET_"&sdc&"_CNT"),0)%></td>
                    <%
                    next
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
