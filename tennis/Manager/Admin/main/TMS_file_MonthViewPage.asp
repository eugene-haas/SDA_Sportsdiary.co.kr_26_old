<!--#include file="../dev/dist/config.asp"-->

<!-- bootstrap 부트스트랩 -->
<%
	Server.ScriptTimeout = 90000 
	
	tp  = fInject(Request("tp")) 
	ORDERBY = fInject(Request("ORDERBY")) 
	Years = fInject(Request("Years")) 
      
	if tp = "" Then tp="EE1"
	if ORDERBY = "" Then ORDERBY="0"
   	if Years = "" Then Years = Year(Date()) 

	SaveFilename = replace(left(now(),10),"-","")&Hour(now())&Minute(now()) &".xls"  '확장자도 지정할것..
	
	Response.contenttype="application/vnd.ms-excel" 
	Response.AddHeader "Content-Disposition","attachment;filename=" & SaveFilename
	Response.CacheControl = "public"	'버퍼링하지 않고 바로 다운로드 창
	
 %>
<section>
<div id="content">
  <div class="loaction"> <span id="Depth_GameTitle"><strong><%=Years%>월별 페이지 사용 통계</strong></span> </div>
  <div class="table-list-wrap month-regist">
    <table class="table-list" border="1">
      <tr class="table-top">
        <td width="80px">매체유형</td>
        <td width="170px">페이지URL</td>
        <td width="450px">페이지명</td>
        <td width="80px">순위</td>
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
               SQL = "SELECT*FROM(  select ROW_NUMBER() OVER( ORDER BY sum(case when a.일자 like '"&Years&"%' then a.합계 else 0 end ) DESC) AS NUM ,a.매체유형,a.파일명,a.파일정보 " & _ 
                    " ,sum(case  when a.일자 like '"&Years&"%' then a.합계 else 0 end ) CSum " & _ 
                    " ,sum(case a.일자 when '"&Years&"-01' then a.합계  else 0 end ) CSum01 " & _ 
                    " ,sum(case a.일자 when '"&Years&"-02' then a.합계  else 0 end ) CSum02 " & _ 
                    " ,sum(case a.일자 when '"&Years&"-03' then a.합계  else 0 end ) CSum03 " & _ 
                    " ,sum(case a.일자 when '"&Years&"-04' then a.합계  else 0 end ) CSum04 " & _ 
                    " ,sum(case a.일자 when '"&Years&"-05' then a.합계  else 0 end ) CSum05 " & _ 
                    " ,sum(case a.일자 when '"&Years&"-06' then a.합계  else 0 end ) CSum06 " & _ 
                    " ,sum(case a.일자 when '"&Years&"-07' then a.합계  else 0 end ) CSum07 " & _ 
                    " ,sum(case a.일자 when '"&Years&"-08' then a.합계  else 0 end ) CSum08 " & _ 
                    " ,sum(case a.일자 when '"&Years&"-09' then a.합계  else 0 end ) CSum09 " & _ 
                    " ,sum(case a.일자 when '"&Years&"-10' then a.합계  else 0 end ) CSum10 " & _ 
                    " ,sum(case a.일자 when '"&Years&"-11' then a.합계  else 0 end ) CSum11 " & _ 
                    " ,sum(case a.일자 when '"&Years&"-12' then a.합계  else 0 end ) CSum12 " & _ 
                    " from (SELECT CASE WHEN A.STATIC_MEDIA_TP = 'SD1' THEN '선수용' WHEN A.STATIC_MEDIA_TP = 'TE1' THEN '팀매니저' ELSE '' END 매체유형 " & _ 
                    " 		  ,B.URL_FILE_NM 파일명,B.URL_FILE_INFO 파일정보,SUBSTRING(A.SET_DT,1,4) + '-' + SUBSTRING(A.SET_DT,5,2)  일자,SUM(A.SET_CNT) 합계 " & _ 
                    " 	FROM tblSdStaticHis A " & _ 
                    " 	LEFT OUTER JOIN (SELECT STATIC_MEDIA_TP,URL_FILE_NM,URL_FILE_INFO " & _ 
                    " 					 FROM tblSdStaticInfo " & _ 
                    " 					 WHERE DEL_YN = 'N') B ON A.STATIC_MEDIA_TP = B.STATIC_MEDIA_TP AND A.URL_FILE_NM = B.URL_FILE_NM   " & _ 
                    " 	WHERE A.DEL_YN = 'N'   AND B.URL_FILE_NM IS NOT NULL " & _                    
                    " 	 AND A.URL_FILE_NM not like '%Login%'   " & _ 
		 			" 	 AND A.URL_FILE_NM not like '%login%'   " & _ 
		 			" 	 AND A.URL_FILE_NM not like '%join%'   " & _ 	
		 			" 	 AND A.URL_FILE_NM not like '%id%'   " & _ 		
		 			" 	 AND A.URL_FILE_NM not like '%test%'   " & _ 	
                    " 	 and A.STATIC_MEDIA_TP='"&tp&"' " & _ 
                    " 	GROUP BY B.URL_FILE_NM,B.URL_FILE_INFO,A.STATIC_MEDIA_TP,SUBSTRING(A.SET_DT,1,4) + '-' + SUBSTRING(A.SET_DT,5,2))a " & _ 
                    " group by a.매체유형,a.파일명,a.파일정보  ) A " 
                 

                IF ORDERBY ="1" THEN
                    SQL = SQL&" order by NUM "
                ELSE
                    SQL = SQL&" order by 파일정보 "
                END IF 

               ' Response.Write SQL
                Set Rs = Dbcon5.Execute(SQL)
                If Not(Rs.Eof Or Rs.Bof) Then 
                Do Until Rs.Eof 
                COLORS ="style='background-color: #FFFFFF'"
                COLORS=""
                %>
      <tr>
        <td><%=Rs("매체유형")	 %></td>
        <td align=left>&nbsp;<%=Rs("파일명")%>&nbsp;</td>
        <td align=left>&nbsp;<%=Rs("파일정보")%>&nbsp;</td>
        <td style="mso-number-format:\@" align=right <%=COLORS %>><%=Rs("NUM")%></td>
        <td style="mso-number-format:\@" align=right><%=FormatNumber(Rs("CSum"),0)%></td>
        <td style="mso-number-format:\@" align=right><%=FormatNumber(Rs("CSum01"),0)%></td>
        <td style="mso-number-format:\@" align=right><%=FormatNumber(Rs("CSum02"),0)%></td>
        <td style="mso-number-format:\@" align=right><%=FormatNumber(Rs("CSum03"),0)%></td>
        <td style="mso-number-format:\@" align=right><%=FormatNumber(Rs("CSum04"),0)%></td>
        <td style="mso-number-format:\@" align=right><%=FormatNumber(Rs("CSum05"),0)%></td>
        <td style="mso-number-format:\@" align=right><%=FormatNumber(Rs("CSum06"),0)%></td>
        <td style="mso-number-format:\@" align=right><%=FormatNumber(Rs("CSum07"),0)%></td>
        <td style="mso-number-format:\@" align=right><%=FormatNumber(Rs("CSum08"),0)%></td>
        <td style="mso-number-format:\@" align=right><%=FormatNumber(Rs("CSum09"),0)%></td>
        <td style="mso-number-format:\@" align=right><%=FormatNumber(Rs("CSum10"),0)%></td>
        <td style="mso-number-format:\@" align=right><%=FormatNumber(Rs("CSum11"),0)%></td>
        <td style="mso-number-format:\@" align=right><%=FormatNumber(Rs("CSum12"),0) %></td>
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
