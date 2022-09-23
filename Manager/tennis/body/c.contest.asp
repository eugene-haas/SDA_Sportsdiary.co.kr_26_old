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

	'ConStr = Replace(ConStr, "ITEMCENTER", "itemcenter_test")
	Set db = new clsDBHelper

	intPageNum = page
	intPageSize = 2
	strTableName = " sd_TennisTitle "
	strFieldName = " GameTitleIDX,gameTitleName,GameS,GameE,GameYear,cfg,GameRcvDateS,GameRcvDateE "

	strSort = "  order by GameTitleIDX desc"
	strSortR = "  order by GameTitleIDX"

	'search
	If chkBlank(search_word) Then
		strWhere = " GameTitleIDX > 0 "
	Else
		strWhere = " GameTitleIDX = " & tid
		page_params = "&search_word="&search_word
	End if

	Dim intTotalCnt, intTotalPage
	Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )

	block_size = 10
	'list_page = "list_tst.asp"
%>


<%'View ####################################################################################################%>
<script type="text/javascript">
<!--
$(function() {
	$( "#GameS" ).datepicker({ 
			 changeYear:true,
			 changeMonth: true, 
			 dayNamesMin: ['월', '화', '수', '목', '금', '토', '일'], 
			 monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
			 showMonthAfterYear:true,
			 showButtonPanel: true, 
			 currentText: '오늘 날짜', 
			 closeText: '닫기', 
			 dateFormat: "yy-mm-dd"	
	});

	$( "#GameE" ).datepicker({ 
			 changeYear:true,
			 changeMonth: true, 
			 dayNamesMin: ['월', '화', '수', '목', '금', '토', '일'], 
			 monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
			 showMonthAfterYear:true,
			 showButtonPanel: true, 
			 currentText: '오늘 날짜', 
			 closeText: '닫기', 
			 dateFormat: "yy-mm-dd"	
	});


	$( "#GameRcvS" ).datepicker({ 
			 changeYear:true,
			 changeMonth: true, 
			 dayNamesMin: ['월', '화', '수', '목', '금', '토', '일'], 
			 monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
			 showMonthAfterYear:true,
			 showButtonPanel: true, 
			 currentText: '오늘 날짜', 
			 closeText: '닫기', 
			 dateFormat: "yy-mm-dd"	
	});



	$( "#GameRcvE" ).datepicker({ 
			 changeYear:true,
			 changeMonth: true, 
			 dayNamesMin: ['월', '화', '수', '목', '금', '토', '일'], 
			 monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
			 showMonthAfterYear:true,
			 showButtonPanel: true, 
			 currentText: '오늘 날짜', 
			 closeText: '닫기', 
			 dateFormat: "yy-mm-dd"	
	});
});

//-->
</script>
<a name="contenttop"></a>





		<form name="frm" method="post">
		<div class="top-navi-inner">

			<div class="top-navi-tp">
				<h3 class="top-navi-tit" style="height: 50px;">
					<strong>대회정보</strong>
				</h3>
			</div>

			<div class="top-navi-btm">
				<div class="navi-tp-table-wrap"  id="gameinput_area">
					<table class="navi-tp-table">
						<caption>대회정보 기본정보</caption>
						<colgroup>
							<col width="110px">
							<col width="*">
							<col width="110px">
							<col width="*">
							<col width="110px">
							<col width="*">
						</colgroup>
						<tbody>
							<tr>
								<th scope="row"><label for="competition-name">대회명</label></th>
								<td><input type="text" name="GameTitleName" id="GameTitleName" placeholder="대회명을 입력해주세요."></td>

								<th scope="row">대회주최</th>
								<td>
									<span id="sel_HostCode">
									<select  id="HostCode">
									<option value="">==선택==</option>
									<option value="sd053007">위드라인</option>
									</select></span>
								</td>
								<th scope="row"><label for="competition-place">장소</label><!-- 년도 --></th>
								<td>
									<div class="ymd-list">
										<input type="text"  id="GameArea"  placeholder="경기장소를 입력해주세요.">
										<!-- <span id="sel_Year"><select name="GameYear" id="GameYear"><option value="">년도</option>
											<%For i = 1 To 3%>
											<option value="<%=year(date)+i%>"><%=year(date)+i%></option>
											<%next%>
											<option value="<%=year(date)%>" selected><%=year(date)%></option>
											<%For i = 1 To 5%>
											<option value="<%=year(date)-i%>"><%=year(date)-i%></option>
											<%next%>												
										</select></span> -->

								</td>
							</tr>
							<tr>
								<th scope="row">시작일</th>
								<td>
									<div class="ymd-list">
										<span id="sel_GameSYear"><input type="text" id="GameS"></span>
									</div>
								</td>
								<th scope="row">종료일</th>
								<td>
									<div class="ymd-list">
										<span id="sel_GameEYear"><input type="text" id="GameE"></span>
								</div></td>
								<th scope="row">대회구분<!-- <label for="competition-place">장소</label> --></th>
								<td>
									<select id="entertype" style="width:40%;">
										<option value="E" selected>엘리트</option>
										<option value="A">아마추어</option>
									</select>											
									<!-- <input type="text"  id="GameArea"  placeholder="경기장소를 입력해주세요."> -->
								</td>
							</tr>
							<tr>
								<th scope="row">접수시작일</th>
								<td>
									<div class="ymd-list">
										<span id="sel_GameRcvSMonth"><input type="text" id="GameRcvS"></span>
									</div>
								</td>
								<th scope="row">접수종료일</th>
								<td>
									<div class="ymd-list">
										<span id="sel_GameRcvEYear"><input type="text" id="GameRcvE"></span>
								</div></td>
								<th scope="row">타이/듀스</th>
								<td>
									<select id="tie" style="width:40%;">
										<option value="6" selected>6점</option>
										<option value="5">5점</option>
									</select>
									<select id="deuce"  style="width:40%;">
										<option value="0" selected>듀스</option>
										<option value="1">노에드</option>
										<option value="2">원듀스노에드</option>
									</select>
								</td>
							</tr>

							<tr>
								<th scope="row">노출여부</th>
								<td>
									<select id="ViewYN">
										<option value="Y">노출</option>
										<option value="N" selected>미노출</option>
									</select>
								</td>
								<th scope="row">대진표노출</th>
								<td>
									<select  id="MatchYN">
										<option value="Y">노출</option>
										<option value="N"  selected>미노출</option>
									</select>
								</td>
								<th scope="row">대회달력노출</th>
								<td>
									<select  id="ViewState">
										<option value="1">노출</option>
										<option value="2"  selected>미노출</option>
									</select>
								</td>											
							</tr>

						</tbody>
					</table>
				</div>

				<div class="btn-right-list">
					<a href="#" id="btnsave" class="btn" onclick="mx.input_frm();" accesskey="i">등록(I)</a>
					<a href="#" id="btnupdate" class="btn" onclick="mx.update_frm();" accesskey="e">수정(E)</a>
					<a href="#" id="btndel" class="btn btn-delete" onclick="mx.del_frm();" accesskey="r">삭제(R)</a>
				</div>
			</div>

		</div>
		</form>



<%

	Response.write "<table class=""type09"" id=""contest"">"
	Response.write "<thead><th>번호</th><th>대회명</th><th>접수</th><th>기간</th><th>추첨</th></thead>"

	Do Until rs.eof
		idx = rs("GameTitleIDX")
		title = rs("gameTitleName")
		sdate = rs("GameS")
		edate = rs("GameE")
		gamecfg = rs("cfg")
		rcvs = rs("GameRcvDateS")
		rcve = rs("GameRcvDateE")
		%>
			<!-- #include virtual = "/pub/html/tennisAdmin/gameinfolist.asp" -->
	<%
	rs.movenext
	Loop
	Response.write "</table>"


	Set rs = Nothing
%>
<br><br>

<!-- <div>
<%'Call userPaging(intTotalPage, block_size, page, page_params, list_page)%>
</div> -->


<!-- S: more-box -->
<div class="more-box">
  <%If nextrowidx <> "_end" then%>
  <a href="javascript:mx.contestMore()" class="btn btn-more" id="_more">
	<span>더 보기</span>
	<span class="ic-deco"><i class="fa fa-plus"></i></span>
  </a>
  <%End if%>
</div>
<!-- E: more-box -->

