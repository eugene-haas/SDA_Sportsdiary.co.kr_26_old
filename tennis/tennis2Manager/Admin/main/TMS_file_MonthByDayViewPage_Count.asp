<!--#include file="../dev/dist/config.asp"-->
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
     
    SaveFilename = replace(left(now(),10),"-","")&Hour(now())&Minute(now()) &".xls"  '확장자도 지정할것..
	
	Response.contenttype="application/vnd.ms-excel" 
	Response.AddHeader "Content-Disposition","attachment;filename=" & SaveFilename
	Response.CacheControl = "public"	'버퍼링하지 않고 바로 다운로드 창 
%>

    
    <div class="loaction">
        <strong>페이지 통계</strong>
        <span id="Depth_GameTitle">일별 페이지 사용 통계</span>
    </div>                                                         
   
    <table class="table-list" border="1">
     <tr class="table-top">
        <td>매체유형</td>
        <td>페이지URL</td>
        <td>페이지명</td>
        <td>순위</td> 
        <td><%=Years%>. <%=Months%> 누적합계</td>
        <%For i=1 to Days%>
        <td><%=i%>일</td>
        <%Next%>                                                              
    </tr>
    <%
        'Response.Write  colStr
        SQL ="EXEC Search_Sd_ViewTouch_PageCount '"&tp&"','"&Years&"','"&Months&"','"&Days&"','"&ORDERBY&"'"   
        SET Rs = DBCon5.Execute(SQL)
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
   

