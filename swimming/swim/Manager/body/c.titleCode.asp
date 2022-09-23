<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################

	'request 처리##############
	idx = chkInt(chkReqMethod("idx", "GET"), 1)
	teamidx = chkInt(chkReqMethod("teamidx", "GET"), 1)

	page = chkInt(chkReqMethod("page", "GET"), 1)

	search_word = chkLength(chkStrRpl(chkReqMethod("search_word", ""), ""), 10) 'chkStrReq 막음 chkStrRpl replace
	search_first = chkInt(chkReqMethod("search_first", "POST"), 0)

	page = iif(search_first = "1", 1, page)
	'request 처리##############

	Set db = new clsDBHelper

	intPageNum = page
	intPageSize = 100


'	SQL = "Update sd_TennisRPoint_log  Set ptuse = 'N' where titleCode = " & chk_titleCode & " and teamGb = " & Left(levelno,5) & " and ptuse = 'Y' and titleIDX < " & tidx
	logfield = "(select top 1 ptuse from sd_TennisRPoint_log where titleCode = a.titleCode  order by titleIDX desc, idx desc) as rankok "
	strTableName = " sd_TennisTitleCode "
	strFieldName = " idx,titleCode,titleGrade,hostTitle,delYN ," & logfield
	strWhere = " DelYN = 'N' "
	SQL = "Select " & strFieldName & " from " & strTableName & " as a where " & strWhere & " order by idx desc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	'Response.write sql

%>


<%'View ####################################################################################################%>
<div class="admin_content">
	<a name="contenttop"></a>

	<div class="page_title"><h1>대회관리 > 대회등급관리</h1></div>

	<div class="info_serch">

		<div class="form-horizontal"  id="gameinput_area">
			<!-- #include virtual = "/pub/html/swimAdmin/gamehost/html.codeForm.asp" -->
		</div>

		<div class="btn-group flr">
			<a href="#" id="btnsave" class="btn btn-primary" onclick="mx.input_frm();" accesskey="i">등록(I)</a>
			<a href="#" id="btnupdate" class="btn btn-primary" onclick="mx.update_frm();" accesskey="e">수정(E)</a>
			<a href="#" id="btndel" class="btn btn-danger" onclick="mx.del_frm();" accesskey="r">삭제(R)</a>
		</div>

	</div>

	<hr />

	<div class="table-responsive">
	<%
		Function sorthtml(ByVal sortno)
			sorthtml =  "<button onclick=""mx.sortTD( "&sortno&" )"">▲</button><button onclick=""mx.reverseTD ( "&sortno&" )"">▼</button>"
		End Function

		Response.write "<table cellspacing=""0"" cellpadding=""0"" class=""table table-hover"" id=""playerlist"">"
		<!-- Response.write "<colgroup><col width=""70px""><col width=""90px""><col width=""50px""><col width=""60px""><col width=""60px""><col width=""60px""><col width=""60px""><col width=""60px""><col width=""60px""><col width=""60px""></colgroup>" -->
		Response.write "<thead><tr><th>그룹명</th><th>등급(titleGrade)</th><th>코드(titleCode)</th></tr></thead>"
		Response.write "<tbody id=""contest"">"
		Response.write " <tr class=""gametitle"" ></tr>"

		Do Until rs.eof
			idx = rs("idx")
			titleCode = rs("titleCode")
			titleGrade = rs("titleGrade")
			hostTitle = rs("hostTitle")
			rankok = rs("rankok")

			titleGrade = findGrade(titleGrade)
	'		Select Case titleGrade
	'		Case "2" : titleGrade = "GA"
	'		Case "1" : titleGrade = "SA"
	'		Case "3" : titleGrade = "A"
	'		Case "4" : titleGrade = "B"
	'		Case "5" : titleGrade = "C"
	'		Case "6" : titleGrade = "D" '단체
	'		End Select

			%><!-- #include virtual = "/pub/html/swimAdmin/gamehost/html.codeList.asp" --><%
		rs.movenext
		Loop
		Response.write "</tbody>"
		Response.write "</table>"


		Set rs = Nothing
	%>
	</div>
</div>
