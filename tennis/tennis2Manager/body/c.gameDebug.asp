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

	strTableName = " sd_TennisResult as a Left Join sd_TennisMember b on a.gameMemberIDX1 = b.gameMemberIDX and b.DelYN = 'N' "
	strTableName = strTableName & " Left Join sd_TennisMember c on a.gameMemberIDX2 = c.gameMemberIDX and c.DelYN = 'N' "
	strTableName = strTableName & " LEFT JOIN sd_TennisTitle  e on a.GameTitleIDX = e.GameTitleIDX and e.DelYN = 'N' "
	strFieldName = " resultIDX " 
	strFieldName = strFieldName & " , B.UserName + ',' +  Cast(B.PlayerIDX as nvarchar(max)) as LPlayer, + C.userName + ',' + Cast(c.PlayerIDX as nvarchar(max)) as RPlayer, b.Round, e.GameTitleName as 대회명" 
	strFieldName = strFieldName & " , gameMemberIDX1 as MemberIDX1,gameMemberIDX2 as MemberIDX2,a.stateno,a.gubun,a.courtno,m1set1,m2set1,winIDX,winResult,recorderName,startserve,secondserve,court1playerIDX,court2playerIDX,court3playerIDX,court4playerIDX,leftetc,rightetc,preresult,a.gametitleidx,gamekeyname,level,a.tryoutgroupno,startrecive,secondrecive "
	strSort = "  ORDER By b.GameTitleIDX,b.Round ,b.SortNo asc "

	'search
	If chkBlank(search_word) Then
		strWhere = "  a.DelYN = 'N'and (a.gameMemberIDX1 in (SELECT gameMemberIDX from sd_tennisMember) or a.gameMemberIDX2 in (SELECT gameMemberIDX from sd_tennisMember)) and b.Round >= 1 "
	Else
		'strWhere = " DelYN = 'N' and GameTitleIDX = " & idx
		'page_params = "&search_word="&search_word
	End if


	Dim intTotalCnt, intTotalPage
	SQL = "Select " & strFieldName & " from " & strTableName & " where " & strWhere & strSort
	'response.Write "SQL : " & SQL & "<br>"
	'response.end
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
%>


<%'View ####################################################################################################%>
<a name="contenttop"></a>
		<form name="frm" method="post">
		<div class="top-navi-inner">
			<div class="top-navi-tp">
				<h3 class="top-navi-tit" style="height: 50px;">
					<strong>대회관리 > 선수 관리 (tblPlayer)</strong>
				</h3>
			</div>

			<div class="top-navi-btm">

		
				<div class="sch">				
				<%'<!-- #include virtual = "/pub/html/tennisAdmin/GameSearchForm.asp" -->%>
				</div>

				<div class="navi-tp-table-wrap"  id="gameinput_area">
					<%'<!-- #include virtual = "/pub/html/tennisAdmin/gameForm.asp" -->%>
				</div>

			</div>

		</div>
		</form>


		<div class="btn-left-list">
				<a href="javascript:mx.contestMore(<%=titleidx%>)" class="btn-more-result">
					전체 (<strong id="totcnt"><%=intTotalCnt%></strong>)건 / <strong class="current">현재페이지(<span id="nowcnt">1</span>)</strong>
				</a>
		</div>


<table class="table-list" id="playerlist">
<%
	Response.write "<thead id=""headtest"">"
	'Response.write "Rs.Fields.Count" & Rs.Fields.Count
	For i = 0 To Rs.Fields.Count - 1
	
				
		If Rs.Fields(i).name = "court1playerIDX" Then
			i = i + 4
			%><th>코트</th><th>상세</th><%
		End if
		'Response.write "i : "  & i & "<br/>"
			If Rs.Fields(i).name = "Round" Then
			response.write "<th>"& Rs.Fields(i).name &"</th>"
		%>
				<th>게임순서</th>
		<%	
		ELSE
		response.write "<th>"& Rs.Fields(i).name &"</th>"
		END IF
	Next
	
'	For each fld in rs.fields
'		response.write "<th>"& fld.Name &"</th>"
'	Next
	Response.write "</thead>"

	ReDim rsdata(Rs.Fields.Count) '필드값저장
	Dim courtpidx(4)

	Do Until rs.eof
	j = j + 1
		For i = 0 To Rs.Fields.Count - 1
			
			rsdata(i) = rs(i)
		Next
		%>
		<!-- #include virtual = "/pub/html/tennisAdmin/GameDebugList.asp" -->
		<%
	rs.movenext
	Loop
	Response.write "</tbody>"
	Response.write "</table>"


	Set rs = Nothing
%>

