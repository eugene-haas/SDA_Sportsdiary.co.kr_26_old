<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################

	'request 처리##############
	idx = chkInt(chkReqMethod("req", "GET"), 1)
	'request 처리##############

	Set db = new clsDBHelper

	strTableName = " sd_TennisResult_record  "
	strFieldName = " midx,name,score_postion,gameno,leftscore,rightscore,gameend,servemidx,playsortno,skill1,skill2,skill3 "
	strSort = "  ORDER By gameno asc, playsortno asc"
	strWhere = " resultIDX = " & idx
	SQL = "Select " & strFieldName & " from " & strTableName & " where " & strWhere & strSort
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
%>


<%'View ####################################################################################################%>
<a name="contenttop"></a>

		<div class="top-navi-inner">
			<div class="top-navi-tp">
				<h3 class="top-navi-tit" style="height: 50px;">
					<strong>플레이정보</strong>
				</h3>
			</div>
		</div>


<table class="table-list" id="playerlist">
<%
	Response.write "<thead id=""headtest"">"

	For i = 0 To Rs.Fields.Count - 1
		response.write "<th>"& Rs.Fields(i).name &"</th>"
	Next
	Response.write "</thead>"

	ReDim rsdata(Rs.Fields.Count) '필드값저장
	Dim courtpidx(4)
	

	Do Until rs.eof
		For i = 0 To Rs.Fields.Count - 1
			rsdata(i) = rs(i)
		Next
		
		%>
		<!-- #include virtual = "/pub/html/RookietennisAdmin/GameDebugList2.asp" -->
		<%
	rs.movenext
	Loop
	Response.write "</tbody>"
	Response.write "</table>"


	Set rs = Nothing
%>

