<%
 'Controller ################################################################################################

	'request 처리##############
	page = chkInt(chkReqMethod("page", "GET"), 1)
	search_word = chkLength(chkStrRpl(chkReqMethod("search_word", ""), ""), 10) 'chkStrReq 막음 chkStrRpl replace
	search_first = chkInt(chkReqMethod("search_first", "POST"), 0)

	page = iif(search_first = "1", 1, page)
	'request 처리##############

	'ConStr = Replace(ConStr, "ITEMCENTER", "itemcenter_test")
	Set db = new clsDBHelper

	strTableName = " sd_TennisTitle "
	'stateNo = 게임상태 0표시전, 3 예선대진표보임 , 4 예선마감상태, 5 본선대진표보임 , 6 본선마감사태 , 7 결과발표보임
	strFieldName = " GameTitleIDX,gameTitleName   " ',GameS,GameE,GameYear,cfg,GameRcvDateS,GameRcvDateE,ViewYN,MatchYN,viewState,stateNo
	strSort = "  order by GameTitleIDX desc"
	strWhere = " DelYN = 'N' "'  and stateNo = 0"

	SQL = "Select top 30 " & strFieldName & " from " & strTableName & " where " & strWhere & strsort
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then 
		arrRT = rs.GetRows()
	End if
%>


<%'View ####################################################################################################%>
<a name="contenttop"></a>


		<div class="top-navi-inner">

			<div class="top-navi-tp">
				<h3 class="top-navi-tit" style="height: 50px;">
					<strong>예선편성표 등록</strong>
				</h3>
			</div>

			<div class="top-navi-btm">
				<table class="navi-tp-table">
					<caption>대회정보 기본정보</caption>
					<colgroup>
						<col width="200px">
						<col width="*">
					</colgroup>
					<tbody>
						<tr id="level_form">					
						<!-- #include virtual = "/pub/html/swimAdmin/gamerullform.asp" -->
						</tr>
					</tbody>
				</table>

			</div>

		</div>



<div id="updatelog" ></div><!-- 쉬트뷰 -->




