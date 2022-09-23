<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->
<%

 'Controller ################################################################################################
	sortd = " o.name asc"
	SQL = "SELECT o.name , (SELECT value FROM sys.extended_properties WHERE major_id = o.id and minor_id = 0 )   FROM   sysindexes i INNER JOIN sysobjects o ON i.id = o.id WHERE  i.indid < 2  AND o.xtype = 'U' ORDER BY " & sortd
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arr = rs.GetRows()
	End if




	dbcode = request.Cookies("DBNO")
	If dbcode <> "" Then
		Select Case dbcode
		Case "DB00" : 	dbStr = "공통"
		Case "DB01" : 	dbStr = "멤버"
		Case "DB02" : 	dbStr = "아이템센터"
		Case "DB03" : 	dbStr = "베드민턴"
		Case "DB04" : 	dbStr = "테니스"
		Case "DB05" : 	dbStr = "SD테니스"
		Case "DB06" : 	dbStr = "수영"
		Case "DB07" : 	dbStr = "승마"
		Case "DB08" : 	dbStr = "자전거"
		Case "DB09" : 	dbStr = "유도"
		Case "DB10" : 	dbStr = "json"
		End Select
	End If


	intPageNum = PN
	intPageSize = 20
	strTableName = " tblJSON "
'	strFieldName = " seq,dbcode,inputval,inputq,outputval,outputcnt,title,useurl,makeid,writeday "
	strFieldName = " seq,'"&dbStr&"' as db,title,makeid,writeday  "

	strSort = "  order by seq desc"
	strSortR = "  order by seq "

	strWhere = " dbcode = '"&dbcode&"'  "




	Dim intTotalCnt, intTotalPage
	Set rs = GetBBSSelectRS( B_ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
	block_size = 10

'Response.write B_ConStr
%>

<%'View ####################################################################################################%>


		<!-- s: 콘텐츠 시작 -->
		<div class="admin_content">
			<div class="page_title"><h1>JSON</h1></div>

			<div class="info_serch form-horizontal" id="gameinput_area">
					<!-- #include virtual = "/pub/html/adm/jsonForm.asp" -->
			</div>
			<hr />
			<!-- s: 테이블 리스트 -->
			<div class="table-responsive">
				<!-- <table cellspacing="0" cellpadding="0" class="table table-hover"> -->
					<%
					  Call getRowsDrowTable(rs, "table")
					  rs.close
					%>
				<!-- </table> -->
			</div>
			<!-- e: 테이블 리스트 -->



			<nav>
				<%
					jsonstr = JSON.stringify(oJSONoutput)
					Call userPagingT2 (intTotalPage, 10, PN, "px.goPN", jsonstr )
				%>
			</nav>


		</div>
		<!-- s: 콘텐츠 끝 -->
