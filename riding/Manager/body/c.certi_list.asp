<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################

	intPageNum = PN
	intPageSize = 10


	strTableName = " tblOrderTable as a "
	strFieldName = " OrderIDX,OR_type,orderid,targetidx,targetnm,targetmsg1,targetmsg2,printcnt,reg_date,OrderPrice,OR_NUM,GameTitleIDX,Team,LeaderIDX,LeaderName,OorderPayType,OorderState,resultMsg,VACT_Num,VACT_BankCode,vactBankName,VACT_InputName,Order_tid,Order_MOID,reg_update,refundBnk,refundCC,refundNM,refunddate,refundYN,refundenddate "

	strSort = "  order by OrderIDX desc"
	strSortR = "  order by OrderIDX"

	'search
	If chkBlank(F2) Then
		strWhere = " a.DelYN = 'N'  "	
	Else
		strWhere = " a.DelYN = 'N' and orderid like '%"&F2&"%' "	
	End if
	'OR_type in ('H','E1','E2') 




	Dim intTotalCnt, intTotalPage
	Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
	block_size = 10

	If Not rs.EOF Then
		arrR = rs.GetRows()
	End If

'Call getrowsdrow(arrr)

'REQ파일에서 파일 구분자로 사용
SENDPRE = "history_"
%>
<%'View ####################################################################################################%>
		<!-- s: 콘텐츠 시작 -->
		<div class="admin_content" >
			<div class="page_title"><h1>증명서발급내역</h1></div>
			<div class="info_serch form-horizontal" id="gameinput_area"><!-- s: 폼 -->
			</div>


			<div class="info_serch">
				<!-- s -->
					<div class="form-horizontal">

						<div class="form-group">
							<label class="col-sm-1 control-label">제목</label>
							<div class="col-sm-2">
								<input type="hidden" id="F1" value="title">
								<input type="text" id="F2" class="form-control"  onkeydown="if(event.keyCode == 13){px.goSubmit( {'F1':#('#F1').val(),'F2':#('#F2').val()} , '<%=pagename%>');}" value="<%=F1_2%>">
							</div>

							<a href="javascript:px.goSubmit( {'F1':#('#F1').val(),'F2':#('#F2').val()} , '<%=pagename%>');" class="btn btn-primary">검색</a>
						</div>
					</div>

				<!-- e -->
			</div>

			<hr />
		  <div class="btn-toolbar" role="toolbar" aria-label="btns"></div>



			<!-- s: 테이블 리스트 -->
			<div class="table-responsive">
				<table cellspacing="0" cellpadding="0" class="table table-hover">
					<thead>
						<tr>
								<th>No.</th>
								<th>신청아이디</th>
								<th>발급종류</th>
								<th>대상</th>
								<th>용도</th>
								<th>제출처</th>
								<th>금액</th>
								<th>결제여부</th>
								<th>발급확인</th>
						</tr>
					</thead>
					<tbody id="contest"  class="gametitle">
			<%
			If IsArray(arrR) Then 
				For ari = LBound(arrR, 2) To UBound(arrR, 2)

				l_seq = arrR(0,ari)
				l_type = arrR(1, ari) 'H 말
				Select Case l_type 
				Case "H" 
				kindtitle = "말 경기 실적증명서"
				printstr = "출력"
				Case "E1" 
				kindtitle = "(영문)선수경기실적증명서"
				printstr = "메일발송"
				Case "E2" 
				kindtitle = "(영문)선수등록확인서"
				printstr = "메일발송"
				End Select 

				l_orderid = arrR(2, ari)
				l_targetidx = arrR(3, ari)
				l_targetnm = arrR(4, ari)
				l_targetmsg1 = arrR(5, ari)
				l_targetmsg2 = arrR(6, ari)
				l_printcnt = arrR(7, ari)

				l_rdate = isnulldefault(arrR(8, ari),Date())
				l_reg_date = Replace(Left(l_rdate,10),"-",".")
				l_OrderPrice = isnulldefault(arrR(9,ari),"0")

				%>

				<%
				If ci = "" Then
				ci = 1 
				End if
				list_no = (intPageSize * (intPageNum-1)) + ci
				'############################
				%>
				<tr id="titlelist_<%=l_seq%>">
					<td ><span><%=l_seq%></span></td>
					<td ><span><%=l_orderid%></span></td>
					<td ><span><%=kindtitle%></span></td>
					<td ><%=l_targetnm%></td>
					<td ><%=l_targetmsg1%></td>
					<td ><%=l_targetmsg2%></td>
					
					<td>
					<%=l_OrderPrice%>
					</td>

					<td>
						-
					</td>

					<td>
						<label class="switch" title="발급확인" >
						<input type="checkbox" id="tbl_<%=l_seq%>"  value="<%=l_printcnt%>" <%If l_printcnt >  0 then%>checked<%End if%> onclick="mx.setBtnState('tbl_<%=l_seq%>',<%=l_seq%>,3,'<%=SENDPRE%>')">
						<span class="slider round"></span>
						</label>			
					</td>
				</tr>

				<%
				'############################
				ci = ci + 1
				Next
				End if
				%>


					</tbody>
				</table>
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
