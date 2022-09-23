<!--#include file="../dev/dist/config.asp"-->
<%
	Server.ScriptTimeout = 90000 

	' Tennis_DBOpen Tennis_DBClose
	tp  = fInject(Request("tp")) 
	Years = fInject(Request("Years"))
	ORDERBY = fInject(Request("ORDERBY")) 

	if tp ="" then tp="EE1"
	if ORDERBY ="" then ORDERBY="0" 
	if Years="" then Years = Year(Date())

	SaveFilename = replace(left(now(),10),"-","")&Hour(now())&Minute(now()) &".xls"  '확장자도 지정할것..

	Response.contenttype="application/vnd.ms-excel" 
	Response.AddHeader "Content-Disposition","attachment;filename=" & SaveFilename
	Response.CacheControl = "public"	'버퍼링하지 않고 바로 다운로드 창 
%>
<section>
    <div id="content">
        <div class="loaction">            
            <span id="Depth_GameTitle"><strong><%=Years%>년 월별 순방문자 통계</strong></span>
        </div> 
        <div class="table-list-wrap day-regist">
            <table class="table-list" border="1">
         
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
                    <td align=right><%=FormatNumber(Rs("CSum17"),0)%></td>
                    <td align=right><%=FormatNumber(Rs("CSum1701"),0)%></td>
                    <td align=right><%=FormatNumber(Rs("CSum1702"),0)%></td>
                    <td align=right><%=FormatNumber(Rs("CSum1703"),0)%></td>
                    <td align=right><%=FormatNumber(Rs("CSum1704"),0)%></td>
                    <td align=right><%=FormatNumber(Rs("CSum1705"),0)%></td>
                    <td align=right><%=FormatNumber(Rs("CSum1706"),0)%></td>
                    <td align=right><%=FormatNumber(Rs("CSum1707"),0)%></td>
                    <td align=right><%=FormatNumber(Rs("CSum1708"),0)%></td>
                    <td align=right><%=FormatNumber(Rs("CSum1709"),0)%></td>
                    <td align=right><%=FormatNumber(Rs("CSum1710"),0)%></td>
                    <td align=right><%=FormatNumber(Rs("CSum1711"),0)%></td>
                    <td align=right><%=FormatNumber(Rs("CSum1712"),0)%></td>
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
