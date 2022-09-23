<!--#include file="../../dev/dist/config.asp"-->
<%
	dim tp      : tp        = fInject(Request("tp"))  
    dim Years   : Years     = fInject(Request("Years"))
	dim ORDERBY : ORDERBY   = fInject(Request("ORDERBY")) 
	
   	if Years = "" then Years = Year(Date())
	if tp = "" then tp = "CO1"     '통합
	if ORDERBY = "" then ORDERBY = "0" 
	

    dim SaveFilename : SaveFilename = replace(left(now(),10) ,"-" ,"")&Hour(now())&Minute(now()) &".xls"  '확장자도 지정할것..

'	Response.contenttype="application/vnd.ms-excel" 
'	Response.AddHeader "Content-Disposition","attachment;filename=" & SaveFilename
'	Response.CacheControl = "public"	'버퍼링하지 않고 바로 다운로드 창 
%>

    <div id="content">
        <div class="loaction">            
            <span id="Depth_GameTitle"><strong><%=Years%>년 월별 순방문자 통계</strong></span>
        </div> 
        <div class="table-box basic-table-box">
    <table border="1">
       <tr class="table-top">
                <td>매체유형</td>                
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
                LSQL = "        SELECT * "
                LSQL = LSQL & " FROM (" 
                LSQL = LSQL & "     SELECT a.TypeMedia" 
                LSQL = LSQL & "         ,SUM(CASE WHEN a.LogDate like '"&Years&"%' THEN a.LogCntTotal ELSE 0 END) CSum " 
                LSQL = LSQL & "         ,SUM(CASE a.LogDate WHEN '"&Years&"-01' THEN a.LogCntTotal ELSE 0 END) CSum01 " 
                LSQL = LSQL & "         ,SUM(CASE a.LogDate WHEN '"&Years&"-02' THEN a.LogCntTotal ELSE 0 END) CSum02 " 
                LSQL = LSQL & "         ,SUM(CASE a.LogDate WHEN '"&Years&"-03' THEN a.LogCntTotal ELSE 0 END) CSum03 " 
                LSQL = LSQL & "         ,SUM(CASE a.LogDate WHEN '"&Years&"-04' THEN a.LogCntTotal ELSE 0 END) CSum04 " 
                LSQL = LSQL & "         ,SUM(CASE a.LogDate WHEN '"&Years&"-05' THEN a.LogCntTotal ELSE 0 END) CSum05 " 
                LSQL = LSQL & "         ,SUM(CASE a.LogDate WHEN '"&Years&"-06' THEN a.LogCntTotal ELSE 0 END) CSum06 " 
                LSQL = LSQL & "         ,SUM(CASE a.LogDate WHEN '"&Years&"-07' THEN a.LogCntTotal ELSE 0 END) CSum07 " 
                LSQL = LSQL & "         ,SUM(CASE a.LogDate WHEN '"&Years&"-08' THEN a.LogCntTotal ELSE 0 END) CSum08 " 
                LSQL = LSQL & "         ,SUM(CASE a.LogDate WHEN '"&Years&"-09' THEN a.LogCntTotal ELSE 0 END) CSum09 " 
                LSQL = LSQL & "         ,SUM(CASE a.LogDate WHEN '"&Years&"-10' THEN a.LogCntTotal ELSE 0 END) CSum10 " 
                LSQL = LSQL & "         ,SUM(CASE a.LogDate WHEN '"&Years&"-11' THEN a.LogCntTotal ELSE 0 END) CSum11 " 
                LSQL = LSQL & "         ,SUM(CASE a.LogDate WHEN '"&Years&"-12' THEN a.LogCntTotal ELSE 0 END) CSum12 " 
                LSQL = LSQL & "     FROM ("  
			   	LSQL = LSQL & "          SELECT CASE "  
			   	LSQL = LSQL & "			       WHEN A.STATIC_MEDIA_TP = 'CO1' THEN '통합' " 
			   	LSQL = LSQL & "			       WHEN A.STATIC_MEDIA_TP = 'EE1' THEN '테니스' " 
			   	LSQL = LSQL & "			       WHEN A.STATIC_MEDIA_TP = 'BK1' THEN '자전거' " 
			   	LSQL = LSQL & "			       WHEN A.STATIC_MEDIA_TP = 'SD1' THEN '유도 선수용' " 
			   	LSQL = LSQL & "			       WHEN A.STATIC_MEDIA_TP = 'TE1' THEN '유도 팀매니저용' " 
			   	LSQL = LSQL & "			       ELSE '' " 
			   	LSQL = LSQL & "			       END TypeMedia " 
                LSQL = LSQL & "		        ,SUBSTRING(A.SET_DT, 1, 4) + '-' + SUBSTRING(A.SET_DT, 5, 2) LogDate "
                LSQL = LSQL & "             ,SUM(A.SET_CNT) LogCntTotal "
                LSQL = LSQL & " 	     FROM tblSdStaticVisitHis A "
                LSQL = LSQL & "     	 WHERE A.DEL_YN = 'N'"                 
                LSQL = LSQL & " 	         AND A.STATIC_MEDIA_TP = '"&tp&"'"
                LSQL = LSQL & " 	     GROUP BY A.STATIC_MEDIA_TP, SUBSTRING(A.SET_DT, 1, 4) + '-' + SUBSTRING(A.SET_DT, 5, 2) "
                LSQL = LSQL & "         ) a "
                LSQL = LSQL & "     GROUP BY a.TypeMedia "
                LSQL = LSQL & "     ) A "

                SET LRs = DBCon8.Execute(LSQL)                
                IF Not(LRs.Eof Or LRs.Bof) Then 
                    Do Until LRs.Eof                 
                    %>
                    <tr>
                        <td><%=LRs("TypeMedia")%></td>                    
                        <td><%=FormatNumber(LRs("CSum"), 0)%></td>
                        <td><%=FormatNumber(LRs("CSum01"), 0)%></td>
                        <td><%=FormatNumber(LRs("CSum02"), 0)%></td>
                        <td><%=FormatNumber(LRs("CSum03"), 0)%></td>
                        <td><%=FormatNumber(LRs("CSum04"), 0)%></td>
                        <td><%=FormatNumber(LRs("CSum05"), 0)%></td>
                        <td><%=FormatNumber(LRs("CSum06"), 0)%></td>
                        <td><%=FormatNumber(LRs("CSum07"), 0)%></td>
                        <td><%=FormatNumber(LRs("CSum08"), 0)%></td>
                        <td><%=FormatNumber(LRs("CSum09"), 0)%></td>
                        <td><%=FormatNumber(LRs("CSum10"), 0)%></td>
                        <td><%=FormatNumber(LRs("CSum11"), 0)%></td>
                        <td><%=FormatNumber(LRs("CSum12"), 0)%></td>
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
