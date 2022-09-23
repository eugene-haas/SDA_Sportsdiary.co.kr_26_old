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
	strFieldName = " GameTitleIDX,gameTitleName   " ',GameS,GameE,GameYear,cfg,GameRcvDateS,GameRcvDateE,ViewYN,MatchYN,viewState,stateNo
	strSort = "  order by GameTitleIDX desc"
	strWhere = " DelYN = 'N' "'  and stateNo = 0"

	SQL = "Select top 30 " & strFieldName & " from " & strTableName & " where " & strWhere & strsort
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
%>


<%'View ####################################################################################################%>
<a name="contenttop"></a>


		<div class="top-navi-inner">

			<div class="top-navi-tp">
				<h3 class="top-navi-tit" style="height: 50px;">
					<strong>본선대진자율생성</strong>
				</h3>
			</div>

			<div class="top-navi-btm">
						<!-- ** 저장버튼은 막아두었습니다. 나머지 버튼으로 테스트 하시면 됩니다. ** -->
				<table class="navi-tp-table">
					<caption>대회정보 기본정보</caption>
					<colgroup>
						<col width="200px">
						<col width="*">
					</colgroup>
					<tbody>
						<tr id="level_form">		
						<!-- #include virtual = "/pub/html/tennisAdmin/gamerullformfree.asp" -->
						</tr>
					</tbody>
				</table>

			</div>

		</div>

<div id="updatelog" >

</div><!-- 쉬트뷰 -->


<%If loadchk = true Then%>
<script type="text/javascript">
<!--
	$('#btnsave2').click();	
//-->
</script>
<%End if%>




