<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################

	'request 처리##############
	page = chkInt(chkReqMethod("page", "GET"), 1)
	search_word = chkLength(chkStrRpl(chkReqMethod("search_word", ""), ""), 10) 'chkStrReq 막음 chkStrRpl replace
	search_first = chkInt(chkReqMethod("search_first", "POST"), 0)

	page = iif(search_first = "1", 1, page)
	'request 처리##############

	ConStr = Replace(ConStr, "ITEMCENTER", "itemcenter_test")
	Set db = new clsDBHelper

	intPageNum = page
	intPageSize = 10
	strTableName = " __wboardS "
	strFieldName = " seq,tid,title,contents,id,ip,readnum,writeday,num,ref,re_step,re_level,tailcnt,filename,pubopen,topshow "

	strSort = "  order by topshow desc,ref desc, re_step"
	strSortR = "  order by topshow,ref, re_step desc"

	'search
	If chkBlank(search_word) Then
		strWhere = " tid = 0 "
	Else
		strWhere = " tid = " & tid
		page_params = "&search_word="&search_word
	End if

	Dim intTotalCnt, intTotalPage
	Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )

	block_size = 10
	'list_page = "list_tst.asp"
%>


<%'View ####################################################################################################%>
<%

	Response.write "<table class=""type09"">"
	Response.write "<thead><th>num</th><th>title</th></thead>"

	Do Until rs.eof
		seq = rs("seq")
		num = rs("num")
		title = rs("title")
		%>
			<tr>
				<td ><%=num%></td>
				<td ><a href="javascript:mx.SendPacket(this, {'CMD':mx.CMD_BOARDVIEW, 'SEQ':<%=seq%>,'PG':'<%=pagec%>','TID':'<%=tid%>','FT':'<%=finttype%>','SSTR':'<%=searchstr%>'})"><%=title%></a></td>
			</tr>
	<%
	rs.movenext
	Loop

	Call userPaging(intTotalPage, block_size, page, page_params, list_page)


	Response.write "</table>"		

	Set rs = Nothing
	db.Dispose
	Set db = Nothing
%>


		  <div class='set blue'>
			<a href="javascript:mx.SendPacket(this, {'CMD':mx.CMD_BOARDWRITE})" class='btn pri ico'  style="content:'\f040'">글쓰기</a>
		  </div>