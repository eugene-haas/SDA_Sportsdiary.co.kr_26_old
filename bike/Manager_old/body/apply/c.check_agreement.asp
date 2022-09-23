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
		ElseIf gidx = 3 Then
		SQL = " SELECT levelIDX, detailTitle, subTitle FROM sd_bikeLevel WHERE DelYN = 'N' "
        End If
        set rs = db.ExecSQLReturnRS(SQL, null, ConStr)

        If Not rs.EOF Then
            arrRS = rs.GetRows()
        End If
    End If

'	response.write "gidx=" & gidx & " tidx=" & tidx & " ridx=" & ridx

	strField = " a.attmidx, a.gameIDX, a.playerIDX, a.p_phone, a.p_agree, a.p_nm, b.userName, b.Birthday, c.titleIDX, c.levelno "
	strField = strField & ", (select GameTitleName from sd_bikeTitle where titleIDX = c.titleIDX ) as gameTitle "
	strField = strField & ", (select detailtitle from sd_bikelevel where titleIDX = c.titleIDX AND levelIDX = c.levelno) as levelnoTitle "
	strField1 = strField & ", ( SELECT COUNT(groupno) from sd_bikeRequest WHERE groupno = a.groupno AND groupno <> 0 ) as requestCount, '개인' as td "
	strField2 = strField & ", 1 as requestCount, '단체' as td "

	strTable = " sd_bikeAttmember a "
	strTableSub1 = " INNER JOIN sd_bikePlayer b ON a.playerIDX = b.playerIDX"
	strTableSub2 = " LEFT JOIN sd_bikeGame c ON a.gameIDX = c.gameIDX "
	strWhere1 = " AND a.gameidx IN ( SELECT MAX(gameIDX) AS gameIDX FROM sd_bikeRequest WHERE groupno > 0 GROUP BY groupno ) "
	strWhere2 = " AND groupno = 0 "
	strWhere = " c.gubun <> 2 "

	'검색조건

    '대회선택
    If tidx <> 0 Then
		strWhere = strWhere & " AND c.titleIDX = "&tidx&" "
	End IF

	'부선택
	If ridx <> 0 Then
		strWhere = strWhere & " AND c.levelno = "&ridx&" "
	End IF

	If stype = 1 Then
		strWhere = strWhere & " AND a.p_nm Like '%"&svalue&"%' "
	ElseIf stype = 2 Then
		strWhere = strWhere & " AND b.userName Like '%"&svalue&"%' "
	End IF

	'개인
	SQL1 = " SELECT "&strField1&" FROM "&strTable&strTableSub1&strTableSub2&" WHERE "&strWhere&strWhere1&" "
	'단체
	SQL2 = " SELECT "&strField2&" FROM "&strTable&strTableSub1&strTableSub2&" WHERE "&strWhere&strWhere2&" "

	'개인
	If gidx = 1 Then
		SQL = SQL1
	'단체
	ElseIf gidx = 2 Then
		SQL = SQL2
	'전체
	Else
		SQL = " SELECT * FROM ("&SQL1&" UNION ALL "&SQL2&") RS "
	End If


	Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)
    cnt = rs.recordcount

%>
<%'View ####################################################################################################%>
<!-- S: sub-content -->
<div class="sub-content">

	<!-- s: lms 전송영역 -->
	<span  id="lmsform"></span>
	<!-- e: lms 전송영역 -->

	<!-- s: 정보 검색 -->
    <div class="box-shadow">
    	<div class="search-box-1">
    		<!-- #include virtual = "/pub/html/bike/apply/check_agreement/searchform.asp" -->
    	</div>
    </div>
	<!-- e: 정보 검색 -->

    <div class="all-list-number">
      <span class="l-txt">
        전체<span class="red-font font-bold"><%=cnt%></span>건
      </span>
    </div>

    <!-- S: check_agreement -->
    <div class="check_agreement">
    	<!-- s: 테이블 리스트 -->
    	<div class="table-box basic-table-box">
    		<table cellspacing="0" cellpadding="0">
    			<tr>
    				<th>번호</th>
    				<th>대회명</th>
    				<th>팀/단체</th>
    				<th>부명</th>
    				<th>선수명</th>
    				<th>보호자명</th>
    				<th>보호자번호</th>
    				<th>보호자동의</th>
    				<th>문자발송</th>
    			</tr>
    			<tbody id="contest">
    			<%
    				IF Not(rs.Eof Or rs.Bof) Then
    					i = 0
    					Do Until rs.eof
    						attmidx = rs("attmidx")
    						gameidx = rs("gameIDX")
    						gameTitle = rs("gameTitle")
    						levelno = rs("levelno")
    						levelnoTitle = rs("levelnoTitle")
    						requestCount = rs("requestCount")
    						playeridx = rs("playerIDX")
    						p_nm = rs("p_nm")
    						p_phone = rs("p_phone")
    						p_agree = rs("p_agree")
    						userName = rs("userName")
    						Birthday = rs("Birthday")
    						titleIDX = rs("titleIDX")
    						td = rs("td")

    						myage = GetAge(Birthday)

    						If CDbl(myage) > 10 AND CDbl(myage) < 19 Then
    							myageST = "N"
    						Else
    							myageST = "Y"
    						End if
    				%>
    				<% If myageST = "N" Then
    					i = i + 1
    				%>
    				<!-- #include virtual = "/pub/html/bike/apply/check_agreement/playerlist.asp" -->
    				<% End If %>
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
    <!-- E: check_agreement -->

<%
	Call userPaginglinkBike (intTotalPage, 10, page, "mx.searchPlayer" )
%>
<!-- #include virtual = "/pub/html/bike/modal.asp" -->

</div>
<!-- E: sub-content -->
