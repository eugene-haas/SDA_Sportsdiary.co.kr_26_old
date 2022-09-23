<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<!-- #include virtual="/pub/class/json2.asp" -->
<script language="Javascript" runat="server">
function hasown(obj,  prop){
	if (obj.hasOwnProperty(prop) == true){
		return "ok";
	}
	else{
		return "notok";
	}
}
</script>
<%
 'Controller ################################################################################################
	REQ = chkReqMethod("p", "POST")
	If REQ <> "" then
	    Set oJSONoutput = JSON.Parse(REQ)
		selecttype = "search"
		page = chkInt(oJSONoutput.pg,1)
		stype = chkInt(oJSONoutput.st,1)
		ptype = chkInt(oJSONoutput.pt,1) '입금상태

        If hasown(oJSONoutput, "sv") = "ok" Then
			svalue = chkLength(chkStrRpl(oJSONoutput.sv, ""), 20)
		End if

        If hasown(oJSONoutput, "tidx") = "ok" then
			tidx = oJSONoutput.tidx
		Else
			tidx = 0
		End If

        If hasown(oJSONoutput, "gidx") = "ok" then
			gidx = oJSONoutput.gidx
		Else
			gidx = 1
		End if

		If hasown(oJSONoutput, "ridx") = "ok" then
			ridx = oJSONoutput.ridx
		Else
			ridx = 0
		End if

	Else
		'findmode 전체검색
		page = chkInt(chkReqMethod("page", "GET"), 1)
		selecttype = "default"
        gidx = 1
        ptype = 1
	End if
	'request 처리##############

	Set db = new clsDBHelper

	'검색영역 - 대회목록
	SQL = " SELECT titleIDX,GameTitleName FROM sd_bikeTitle "
	set rs = db.ExecSQLReturnRS(SQL, null, ConStr)

	If Not rs.EOF Then
		arrRT = rs.GetRows()
	End If

    '검색영역 - 대회목록 - 부서선택
    If tidx <> 0 Then
        IF gidx = 1 Then
        SQL = " SELECT levelIDX, detailTitle, subTitle FROM sd_bikeLevel WHERE DelYN = 'N' AND subtitle = '개인경기' "
        ElseIf gidx = 2 Then
        SQL = " SELECT levelIDX, detailTitle, subTitle FROM sd_bikeLevel WHERE DelYN = 'N' AND subtitle = '단체경기' "
        End If
        set rs = db.ExecSQLReturnRS(SQL, null, ConStr)

        If Not rs.EOF Then
            arrRS = rs.GetRows()
        End If
    End If






    '신청자 정보 셀렉트 필드와 테이블은 공통
    strTable = " sd_bikeRequest a"
	  strTableSub = " INNER JOIN sd_bikeGame c ON a.gameIDX = c.gameIDX "
    strField = " a.RequestIDX, a.titleIDX, a.levelno, a.gameIDX, a.subType, a.PlayerIDX, a.UserName, a.PaymentState, a.PaymentName, a.Paymentdate, a.attmoney, a.groupno, a.Writeday "
    strField = strField & ", a.refundno, a.refundbnk, a.refundattdate, a.refundstate, a.refundupdate "
    strFieldSub1 = ", ( SELECT GameTitleName FROM sd_bikeTitle WHERE titleIDX = a.titleIDX ) as gameTitle"
    strFieldSub2 = ", ( SELECT detailtitle FROM sd_bikelevel WHERE titleIDX = a.titleIDX AND levelIDX = a.levelno ) as levelnoTitle "
	  strFieldSub3 = ", ( SELECT COUNT(groupno) FROM sd_bikeRequest WHERE groupno = a.groupno AND groupno <> 0 ) as requestCount  "
	  strFieldSub4 = ", ( SELECT CASE Sex WHEN 'Man' THEN '남' WHEN 'WoMan' THEN '여' ELSE Sex END  FROM sd_bikePlayer WHERE PlayerIDX = a.playerIDX ) as sex"
    strWhere = " a.DelYN = 'N' AND c.gubun in ( 0, 1 ) "


    '입금상태
    Select Case CDbl(ptype)
    Case 2
        strWhere = strWhere &  " AND PaymentState = 'N' "
    Case 3
        strWhere = strWhere &  " AND PaymentState = 'Y' "
    End Select

    '입금자명/선수명 검색
    If svalue <> "" Then
        Select Case CDbl(stype)
        Case 1 '입금자
            strWhere = strWhere &  " AND PaymentName like '%"&svalue&"%' "
        Case 2 '선수
            strWhere = strWhere &  " AND UserName like '%"&svalue&"%' "
        End Select
    End If

	'대회선택
	If tidx <> 0 Then
		strWhere = strWhere & " AND a.titleIDX = "&tidx&" "
	End If
	'부서선택
	If ridx > 0 Then
		strWhere = strWhere & " AND a.levelno = "&ridx&" "
	End If

    '개인/단체 구분
    If gidx = 2 Then
        strWhere = strWhere & " AND groupno = 0 "
        SQL = "SELECT "&strField&strFieldSub1&strFieldSub2&strFieldSub3&strFieldSub4&" FROM "&strTable&strTableSub&" WHERE "&strWhere&" "
    ElseIf gidx = 1 Then
        strWhere = strWhere & " AND a.groupno <> 0 "
        strJoin = " (SELECT MAX(requestIDX) requestIDX, groupno FROM sd_bikeRequest WHERE groupno <> 0  GROUP BY  groupno) b ON a.requestIDX = b.requestIDX "
        SQL = "SELECT  "&strField&strFieldSub1&strFieldSub2&strFieldSub3&strFieldSub4&" FROM "&strTable&strTableSub&" INNER JOIN "&strJoin&" WHERE "&strWhere
    End If

	'response.write SQL
	'response.end
	set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	set rsCount = db.ExecSQLReturnRS(SQL , null, ConStr)
	If not rsCount.eof then
		rsArray = rsCount.GetRows()
		totalCount = UBound(rsArray, 2) + 1
	End If



%>
<%'View ####################################################################################################%>
	<!-- S: 정보 검색 -->
    <div class="box-shadow">
    	<div class="search-box-1">
    		<!-- #include virtual = "/pub/html/bike/apply/apply_info/searchform.asp" -->
    	</div>
    </div>
	<!-- E: 정보 검색 -->

    <!-- S: apply_info -->
    <div class="apply_info">

    	<!-- S: 전체 페이지 -->
        <div class="all-list-number">
        	<div class="l-txt">
                전체<span class="red-font font-bold"><%=totalCount%></span>건
        	</div>
        </div>
    	<!-- E: 전체 페이지 -->

    	<!-- S: 테이블 리스트 -->
    	<div class="table-box basic-table-box">
    		<table cellspacing="0" cellpadding="0">
    			<tr>
    				<th>번호</th>
    				<th>대회명</th>
    				<th>부명</th>
                    <th>개인/단체</th>
    				<th>선수명</th>
    				<th>입금자명</th>
    				<th>입금금액</th>
    				<th>입금상태</th>
    				<th>입금상태확인</th>
    				<th>신청날짜</th>
    				<!--
    				<th>환불신청정보</th>
    				<th>환불날짜</th>
    				-->
    			</tr>
    			<tbody id="contest">
    				<%
    				IF Not(rs.Eof Or rs.Bof) Then
    					Do Until rs.eof
    						idx = rs("RequestIDX")
    						levelTitle = rs("levelnotitle")
                            subtype = rs("subType")
    						gameTitle = rs("gameTitle")
    						UserName = rs("UserName")
    						sex = rs("sex")
    						requestCount = rs("requestCount")
    						groupno = rs("groupno")
    						Writeday = rs("Writeday")
    						PaymentName = rs("PaymentName")
    						PaymentState = rs("PaymentState")
    						Paymentdate = rs("Paymentdate")
    						attmoney = rs("attmoney")
    						refundno = rs("refundno")
    						refundbnk = rs("refundbnk")
    						refundattdate = rs("refundattdate")
    						refundstate = rs("refundstate")
    						refundupdate = rs("refundupdate")

    				%>
    				<!-- #include virtual = "/pub/html/bike/apply/apply_info/playerlist.asp" -->
    				<%
    					rs.movenext
    					Loop
    				End if
    				set rs = nothing
    				%>
    			</tbody>
    		</table>
    	</div>
    </div>
    <!-- E: apply_info -->




<%
	Call userPaginglinkBike (intTotalPage, 10, page, "mx.searchPlayer" )
%>
<!-- #include virtual = "/pub/html/bike/modal.asp" -->
