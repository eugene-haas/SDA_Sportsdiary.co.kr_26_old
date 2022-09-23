<%
 'Controller ################################################################################################

	'request 처리##############
	tidx = chkInt(chkReqMethod("tidx", "GET"), 1)
	ridx =  chkInt(chkReqMethod("ridx", "GET"), 1)
	'request 처리##############

	'ConStr = Replace(ConStr, "ITEMCENTER", "itemcenter_test")
	Set db = new clsDBHelper

	strTableName = " sd_TennisTitle "
	'stateNo = 게임상태 0표시전, 3 예선대진표보임 , 4 예선마감상태, 5 본선대진표보임 , 6 본선마감사태 , 7 결과발표보임
	strFieldName = " GameTitleIDX,gameTitleName   " 
	strSort = "  order by GameTitleIDX desc"
	strWhere = " DelYN = 'N' and (gameE >= '" &  Date - 90 & "' or GameTitleIDX = 28 or GameTitleIDX = 25) "

	SQL = "Select " & strFieldName & " from " & strTableName & " where " & strWhere & strsort
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then 
		arrRT = rs.GetRows()
	End if


	If tidx <> "" then
		strTableName = "  tblRGameLevel as a left join tblLevelInfo as b  ON a.level = b.level and b.DelYN ='N' "
		strFieldName = " a.Level,a.TeamGbNm,b.LevelNm "

		strSort = "  ORDER BY RGameLevelidx Desc"
		strWhere = " a.GameTitleIDX = "&tidx&" and a.DelYN = 'N' "

		SQL = "Select " & strFieldName & " from " & strTableName & " where " & strWhere & strsort
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.EOF Then 
			arrRS = rs.GetRows()
		End If
	End if

	If tidx <> "" And  ridx <> "" Then
		jooidx = CStr(tidx) & CStr(ridx)

		SQL = "select top 1 * from sd_TennisKATARullMake where mxjoono = '" & jooidx & "' and sortno = 1"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)		
		
		Do Until rs.eof
		loadchk = true
		p_attcnt		= rs("attcnt")
		p_seedcnt		= rs("seedcnt")
		p_jonocnt		= rs("jonocnt")
		p_boxorder		= rs("boxorder")
		p_saveinfo		=rs("saveinfo")
		rs.movenext
		Loop
	
	End if

	If p_jonocnt = "" Then
		loadchk = false
		p_jonocnt = 0
	End If
	If p_seedcnt = "" Then
		loadchk = false
		p_seedcnt = 1
	End if
%>


<%'View ####################################################################################################%>


		<!-- s: 콘텐츠 시작 -->
		<div class="admin_content">
			<!-- s: 페이지 타이틀 -->
			<div class="page_title">
				<h1>본선대진자율생성</h1>
			</div>
			<!-- e: 페이지 타이틀 -->

			<!-- s: 정보 검색 -->
			<div class="search_top" id="level_form">
				<!-- #include virtual = "/pub/html/swimAdmin/gamerullform3.asp" -->
			</div>
			<!-- e: 정보 검색 -->


			<!-- s: 테이블 리스트 -->
			<div class="table_list gamerull3" id="updatelog"></div>
			<!-- e: 테이블 리스트 -->


		</div>
		<!-- s: 콘텐츠 끝 -->

		<a name="contenttop"></a>






<%If loadchk = true Then%>
<script type="text/javascript">
<!--
	$('#btnsave2').click();	
//-->
</script>
<%End if%>




