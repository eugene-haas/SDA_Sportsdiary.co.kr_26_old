<!--#include file="../../dev/dist/config.asp"-->
<%
	dim tp      : tp        = fInject(Request("tp"))  
    dim Years   : Years     = fInject(Request("Years"))

    dim sdc, i
    dim LSQL, LRs
    dim SET_DT, SET_DT_class
   
    if Years = "" then Years = Year(Date())
    if tp = "" then tp ="CO1"   '통합
                                 

	dim SaveFilename : SaveFilename = replace(left(now(),10),"-","")&Hour(now())&Minute(now()) &".xls"  '확장자도 지정할것..
	
	Response.contenttype="application/vnd.ms-excel" 
	Response.AddHeader "Content-Disposition","attachment;filename=" & SaveFilename
	Response.CacheControl = "public"	'버퍼링하지 않고 바로 다운로드 창
	
 %>

<div id="content">
  <div class="loaction"> <span id="Depth_GameTitle"><strong><%=Years%>일별 페이지 사용 통계</strong></span> </div>
  <div class="table-box basic-table-box">
    <table border="1">
       <tr class="table-top">
                <td rowspan=2>매체유형</td>                
                <td rowspan=2>일자</td>
                <td rowspan=2>Total</td> 
                <td colspan=24>시간대</td> 
            </tr>
            <tr class="table-top"> 
                <%
                    for i=0 to 23 
                        sdc = "00"
                        if i < 10 then
                            sdc = "0"&i
                        else
                            sdc = ""&i
                        end if 
                    %>
                     <td><%=sdc%>시</td> 
                    <%
                    next
                %>
            </tr>
            <%
                LSQL = " EXEC Search_Sd_VisitHis_Count '"&tp&"','"&Years&"0101','"&Years&"1231' "
                SET LRs = DBCon8.Execute(LSQL)
                If Not(LRs.Eof Or LRs.Bof) Then 
                    Do Until LRs.Eof    
                 
                        SET_DT =""
                        SET_DT_class =""

                        IF LRs("COL") ="년별" THEN
                           SET_DT = "총계"
                           SET_DT_class = "Years" 
                        END IF 

                        IF LRs("COL") ="월별" THEN
                           SET_DT = LRs("MONTHS")&"월 소계"
                           SET_DT_class = "Month" 
                        END IF 

                        IF LRs("COL") ="일별" THEN
                           SET_DT =LRs("MONTHS")&"월 " & LRs("DAYS")&"일"
                           SET_DT_class = "Days" 
                        END IF 
                    
                %>
                <tr class="<%=SET_DT_class %>">
                    <td><%=LRs("STATIC_MEDIA_Nm")%></td>       
                    <td><%=SET_DT %> </td>       
                    <td><%=FormatNumber(LRs("SET_CNT"),0)%></td>    
                    <%
                    FOR i = 0 to 23 
                        sdc = "00"
                        
                        IF i < 10 then
                            sdc = "0"&i
                        ELSE
                            sdc = ""&i
                        END IF
                    %>
                         <td><%=FormatNumber(LRs("SET_"&sdc&"_CNT"),0)%></td>
                    <%
                    NEXT
                    %>
               </tr>
            <%
                LRs.MoveNext
            Loop 
        End IF
            LRs.Close
        SET LRs = Nothing               
        %>
    </table>
  </div>
</div>
<%
    DBClose8()
%>                 
