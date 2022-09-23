<!--#include file="../../dev/dist/config.asp"-->
<%
	dim tp         : tp        = fInject(Request("tp")) 
	dim ORDERBY    : ORDERBY   = fInject(Request("ORDERBY")) 
	dim Years      : Years     = fInject(Request("Years")) 
   
   	if Years = "" then Years = Year(Date())
	if tp = "" Then tp = "CO1"
	if ORDERBY = "" Then ORDERBY = "0"
   	
	dim SaveFilename : SaveFilename = replace(left(now(),10),"-","")&Hour(now())&Minute(now()) &".xls"  '확장자도 지정할것..
    
    dim LSQL, LRs
	
	Response.contenttype="application/vnd.ms-excel" 
	Response.AddHeader "Content-Disposition","attachment;filename=" & SaveFilename
	Response.CacheControl = "public"	'버퍼링하지 않고 바로 다운로드 창
	
 %>

<div id="content">
  <div class="loaction"> <span id="Depth_GameTitle"><strong><%=Years%>월별 페이지뷰 통계</strong></span> </div>
   <div class="table-box basic-table-box">
      <table class="table-list" border="1">
      <tr class="table-top">
        <td>매체유형</td>
        <td>페이지URL</td>
        <td>페이지명</td>
        <td>순위</td>
        <td>누적합계</td>
        <td>1월</td>
        <td>2월</td>
        <td>3월</td>
        <td>4월</td>
        <td>5월</td>
        <td>6월</td>
        <td>7월</td>
        <td>8월</td>
        <td>9월</td>
        <td>10월</td>
        <td>11월</td>
        <td>12월</td>
      </tr>
      <%
        LSQL = " SELECT * "
        LSQL = LSQL & " FROM( "
        LSQL = LSQL & "     SELECT ROW_NUMBER() OVER( ORDER BY sum(case when a.일자 like '"&Years&"%' then a.합계 else 0 end ) DESC) AS NUM"
        LSQL = LSQL & "         ,a.매체유형"
        LSQL = LSQL & "         ,a.파일명"
        LSQL = LSQL & "         ,a.파일정보 " 
        LSQL = LSQL & "         ,SUM(CASE WHEN a.일자 like '"&Years&"%' THEN a.합계 ELSE 0 END) CSum "
        LSQL = LSQL & "         ,SUM(CASE a.일자 WHEN '"&Years&"-01' THEN a.합계 ELSE 0 END) CSum01 " 
        LSQL = LSQL & "         ,SUM(CASE a.일자 WHEN '"&Years&"-02' THEN a.합계 ELSE 0 END) CSum02 " 
        LSQL = LSQL & "         ,SUM(CASE a.일자 WHEN '"&Years&"-03' THEN a.합계 ELSE 0 END) CSum03 " 
        LSQL = LSQL & "         ,SUM(CASE a.일자 WHEN '"&Years&"-04' THEN a.합계 ELSE 0 END) CSum04 " 
        LSQL = LSQL & "         ,SUM(CASE a.일자 WHEN '"&Years&"-05' THEN a.합계 ELSE 0 END) CSum05 " 
        LSQL = LSQL & "         ,SUM(CASE a.일자 WHEN '"&Years&"-06' THEN a.합계 ELSE 0 END) CSum06 " 
        LSQL = LSQL & "         ,SUM(CASE a.일자 WHEN '"&Years&"-07' THEN a.합계 ELSE 0 END) CSum07 " 
        LSQL = LSQL & "         ,SUM(CASE a.일자 WHEN '"&Years&"-08' THEN a.합계 ELSE 0 END) CSum08 " 
        LSQL = LSQL & "         ,SUM(CASE a.일자 WHEN '"&Years&"-09' THEN a.합계 ELSE 0 END) CSum09 " 
        LSQL = LSQL & "         ,SUM(CASE a.일자 WHEN '"&Years&"-10' THEN a.합계 ELSE 0 END) CSum10 " 
        LSQL = LSQL & "         ,SUM(CASE a.일자 WHEN '"&Years&"-11' THEN a.합계 ELSE 0 END) CSum11 " 
        LSQL = LSQL & "         ,SUM(CASE a.일자 WHEN '"&Years&"-12' THEN a.합계 ELSE 0 END) CSum12 " 
        LSQL = LSQL & "     FROM (" 
        LSQL = LSQL & "	        SELECT "
        LSQL = LSQL & "             CASE " 
        LSQL = LSQL & "		            WHEN A.STATIC_MEDIA_TP = 'CO1' THEN '통합' " 
        LSQL = LSQL & "		            WHEN A.STATIC_MEDIA_TP = 'EE1' THEN '테니스' " 
        LSQL = LSQL & "		            WHEN A.STATIC_MEDIA_TP = 'BK1' THEN '자전거' " 
        LSQL = LSQL & "		            WHEN A.STATIC_MEDIA_TP = 'SD1' THEN '유도 선수용' " 
        LSQL = LSQL & "		            WHEN A.STATIC_MEDIA_TP = 'TE1' THEN '유도 팀매니저용' " 
        LSQL = LSQL & "		            ELSE '' " 
        LSQL = LSQL & "		            END 매체유형 " 
        LSQL = LSQL & " 		    ,B.URL_FILE_NM 파일명"
        LSQL = LSQL & "             ,B.URL_FILE_INFO 파일정보"
        LSQL = LSQL & "             ,SUBSTRING(A.SET_DT, 1, 4) + '-' + SUBSTRING(A.SET_DT, 5, 2) 일자"
        LSQL = LSQL & "             ,SUM(A.SET_CNT) 합계 " 
        LSQL = LSQL & " 	   FROM tblSdStaticHis A "  
        LSQL = LSQL & " 	       LEFT OUTER JOIN ("
        LSQL = LSQL & "                     SELECT STATIC_MEDIA_TP"
        LSQL = LSQL & "                         ,URL_FILE_NM"
        LSQL = LSQL & "                         ,URL_FILE_INFO "
        LSQL = LSQL & " 					FROM tblSdStaticInfo " 
        LSQL = LSQL & " 					WHERE DEL_YN = 'N'"
        LSQL = LSQL & "                     ) B ON A.STATIC_MEDIA_TP = B.STATIC_MEDIA_TP AND A.URL_FILE_NM = B.URL_FILE_NM " 
        LSQL = LSQL & " 	   WHERE A.DEL_YN = 'N'"
        LSQL = LSQL & "            AND B.URL_FILE_NM IS NOT NULL "
        LSQL = LSQL & " 	       AND A.URL_FILE_NM NOT Like '%Login%'"
        LSQL = LSQL & " 	       AND A.URL_FILE_NM NOT Like '%login%'" 
        LSQL = LSQL & " 	       AND A.URL_FILE_NM NOT Like '%join%'" 	
        LSQL = LSQL & " 	       AND A.URL_FILE_NM NOT Like '%id%'" 		
        LSQL = LSQL & " 	       AND A.URL_FILE_NM NOT Like '%test%'" 	
        LSQL = LSQL & " 	       AND A.STATIC_MEDIA_TP = '"&tp&"' " 
        LSQL = LSQL & " 	   GROUP BY B.URL_FILE_NM, B.URL_FILE_INFO, A.STATIC_MEDIA_TP, SUBSTRING(A.SET_DT, 1, 4) + '-' + SUBSTRING(A.SET_DT, 5, 2)"
        LSQL = LSQL & "        )a "
        LSQL = LSQL & "     GROUP BY a.매체유형,a.파일명,a.파일정보"
        LSQL = LSQL & "     ) A " 

        IF ORDERBY ="1" THEN
            LSQL = LSQL & " ORDER BY NUM "
        ELSE
            LSQL = LSQL & " ORDER BY 파일정보 "
        END IF 

       ' Response.Write SQL
        SET LRs = DBCon8.Execute(LSQL)
        IF Not(LRs.Eof Or LRs.Bof) Then 
            Do Until LRs.Eof 
                COLORS ="style='background-color: #FFFFFF'"
                COLORS=""
        %>
      <tr>
        <td><%=LRs("매체유형")%></td>
        <td><%=LRs("파일명")%></td>
        <td><%=LRs("파일정보")%></td>
        <td style="mso-number-format:\@" <%=COLOLRS%>><%=LRs("NUM")%></td>
        <td style="mso-number-format:\@"><%=FormatNumber(LRs("CSum"), 0)%></td>
        <td style="mso-number-format:\@"><%=FormatNumber(LRs("CSum01"), 0)%></td>
        <td style="mso-number-format:\@"><%=FormatNumber(LRs("CSum02"), 0)%></td>
        <td style="mso-number-format:\@"><%=FormatNumber(LRs("CSum03"), 0)%></td>
        <td style="mso-number-format:\@"><%=FormatNumber(LRs("CSum04"), 0)%></td>
        <td style="mso-number-format:\@"><%=FormatNumber(LRs("CSum05"), 0)%></td>
        <td style="mso-number-format:\@"><%=FormatNumber(LRs("CSum06"), 0)%></td>
        <td style="mso-number-format:\@"><%=FormatNumber(LRs("CSum07"), 0)%></td>
        <td style="mso-number-format:\@"><%=FormatNumber(LRs("CSum08"), 0)%></td>
        <td style="mso-number-format:\@"><%=FormatNumber(LRs("CSum09"), 0)%></td>
        <td style="mso-number-format:\@"><%=FormatNumber(LRs("CSum10"), 0)%></td>
        <td style="mso-number-format:\@"><%=FormatNumber(LRs("CSum11"), 0)%></td>
        <td style="mso-number-format:\@"><%=FormatNumber(LRs("CSum12"), 0)%></td>
      </tr>
      <%
                LRs.MoveNext
            Loop 
        End If 
            LRs.Close
        SET LRs = Nothing
    %>
    </table>                                   
    </div>
</div>
<%
    DBClose8()
%> 
