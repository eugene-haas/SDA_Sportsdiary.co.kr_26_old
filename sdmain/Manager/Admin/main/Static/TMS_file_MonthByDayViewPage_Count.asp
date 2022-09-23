<!--#include file="../../dev/dist/config.asp"-->
<%
    dim tp          : tp        = fInject(Request("tp")) 
    dim ORDERBY     : ORDERBY   = fInject(Request("ORDERBY")) 
    dim Years       : Years     = fInject(Request("Years"))
    dim Months      : Months    = fInject(Request("Months"))   
   
    if Years = "" then Years = Year(Date())
    if Months = "" then Months = Month(Date())
    if tp = "" then tp = "CO1"
    if ORDERBY = "" then ORDERBY = "1"
   
    dim i
    dim LSQL, LRs
   
    '해당월의 마지막일 조회 
    dim Days : Days = right(DateSerial(Years, Months + 1 , 0), 2)
     
    dim SaveFilename : SaveFilename = replace(left(now(),10),"-","")&Hour(now())&Minute(now()) &".xls"  '확장자도 지정할것..
	
	Response.contenttype="application/vnd.ms-excel" 
	Response.AddHeader "Content-Disposition","attachment;filename=" & SaveFilename
	Response.CacheControl = "public"	'버퍼링하지 않고 바로 다운로드 창 
%>
    <div class="loaction">
        <span id="Depth_GameTitle">일별 페이지 사용 통계</span>
    </div>                                                         
   
    <table border="1">
     <tr class="table-top">
        <td>매체유형</td>
        <td>페이지URL</td>
        <td>페이지명</td>
        <td>순위</td> 
        <td><%=Years%>년 <%=Months%>월 누적합계</td>
        <%FOR i=1 to Days%>
        <td><%=i%>일</td>
        <%NEXT%>                                                              
    </tr>
    <%
        'Response.Write  colStr
        LSQL ="EXEC Search_Sd_ViewTouch_PageCount '"&tp&"','"&Years&"','"&Months&"','"&Days&"','"&ORDERBY&"'"   
        SET LRs = DBCon8.Execute(LSQL)
        IF Not(LRs.Eof Or LRs.Bof) Then 
            Do Until LRs.Eof 
            %>
        <tr>
            <td><%=LRs("STATIC_MEDIA_TP_NM")%></td>
            <td><%=LRs("URL_FILE_NM")%></td>
            <td><%=LRs("URL_FILE_INFO")%></td>
            <td><%=FormatNumber(LRs("NUM"),0)%></td>
            <td><%=FormatNumber(LRs("STR_SUM"),0)%></td>    
            <%FOR i = 1 to Days%>    
            <td><%=FormatNumber(LRs("Day"&i),0)%></td>
            <%NEXT%>      
       </tr>
        <%
                LRs.MoveNext
            Loop 
        End IF 
           LRs.Close
        SET LRs = Nothing 
     %>
</table>
<%
    DBClose8()
%>                    

