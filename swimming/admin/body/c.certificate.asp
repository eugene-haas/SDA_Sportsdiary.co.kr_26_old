<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################

'	If F1 = "" Then
'		checkSdate  = year(date) & "-01-01"
'		checkEdate  = CDbl(year(date))+1 & "-01-01"
'		F1 = year(date)
'	Else
'		checkSdate  = F1 & "-01-01"
'		checkEdate  = CDbl(F1)+1 & "-01-01"		
'	End if
'
'	fld = " gametitleidx,GameTitleName,gubun,kgame,GameArea,hostname,subjectnm,afternm,sponnm,summaryURL,gameSize,ranecnt,titleCode,attmoney,GameS,GameE,atts,atte,GameType,EnterType,attTypeA,attTypeB,attTypeC,attTypeD,teamLimit,attgameCnt, ViewState,ViewStateM,ViewYN,MatchYN,stateNo"	
'	'설정날짜
'	SQL = "select "&fld&" from sd_gameTitle where DelYN = 'N' and ( gameS >=  '"& checkSdate &"' and  gameS < '"& checkEdate &"' )  Order  by gametitleidx desc"
'	Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)
'	
'
'
'	If Not rss.EOF Then
'		grs = rss.GetRows()
'
'		If F2 = "" Then
'			F2 = grs(0, 0)
'		End if 
'	End If


	intPageNum = PN
	intPageSize = 40
	strTableName = " tblSwwimingOrderTable "

	strFieldName = "orderidx,or_num,team,(select top 1 teamnm from tblteaminfo where team = team) as teamnm ,leaderidx,leadername,OorderPayType, oorderstate, ( REPLACE(CONVERT(VARCHAR, CAST(orderprice AS MONEY),1),'.00','')   ) as price, resultmsg, vact_num, vact_bankcode,vactbankname,vact_inputname, order_tid, order_moid,reg_date,refundbnk,refundcc,refundnm,refunddate     ,info1,info2,info3,info4 "

	strSort = "  order by orderidx  desc "
	strSortR = "  order by orderidx "


		strWhere = " Del_YN = 'N' and gubun='2'  "



		Dim intTotalCnt, intTotalPage
		Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
		block_size = 10


	  If Not rs.EOF Then
		arrP = rs.GetRows()
		'Call getrowsdrow(arrp)
	  End If
%>
<%'View ####################################################################################################%>



      <div class="row">

		<div class="col-xs-12">
          <div class="box">
            <!-- <div class="box-header">
              <h3 class="box-title">Hover Data Table</h3>
            </div> -->
            <!-- /.box-header -->

            <div class="box-body">
              <table id="swtable" class="table table-bordered table-hover" >
                <thead class="bg-light-blue-active color-palette">
						<tr>
								<th>KEY</th>
								<th>증명서</th>
								<th>소속</th>
								<th>신청</th>
								<th>결제금액</th>
								<th>상태</th>
								<th>결제방식</th>
								<th>신청기간</th>
<!-- 								<th>신청</th> -->
<!-- 								<th>구분</th> -->
<!-- 								<th>참가자정보</th> -->
						</tr>
					</thead>
					<tbody id="contest"  class="gametitle">
				<%
				If IsArray(arrP) Then 
					For ari = LBound(arrP, 2) To UBound(arrP, 2)

						l_idx = arrP(0, ari)
						l_or_num = arrP(1, ari)
						l_team = arrP(2, ari)
						l_teamnm  = arrP(3, ari)
						l_leaderidx = arrP(4, ari)
						l_leadername = arrP(5, ari)
						l_OorderPayType = arrP(6, ari)
						l_oorderstate = arrP(7, ari)
						l_price = arrP(8, ari)
						l_resultmsg = arrP(9, ari)
						l_vact_num = arrP(10, ari)
						l_vact_bankcode = arrP(11, ari)
						l_vactbankname = arrP(12, ari)
						l_vact_inputname = arrP(13, ari)
						l_order_tid = arrP(14, ari)
						l_order_moid = arrP(15, ari)
						l_reg_date = arrP(16, ari)
						l_refundbnk = arrP(17, ari)
						l_refundcc = arrP(18, ari)
						l_refundnm = arrP(19, ari)
						l_refunddate = arrP(20, ari)
						l_info1 = arrP(21, ari) '용도
						l_info2 = arrP(22, ari) '제출처
						l_info3 = arrP(23, ari) '1, 2 대회참가확인서 , 실적증명서
						If l_info3 = "1" Then
							cnm = "대회참가확인서"
						Else
							cnm = "실적증명서"
						End if
						l_info4 = arrP(24, ari)




						Select Case l_OorderPayType
						Case "Card" : l_typenm = "카드"
						Case "DirectBank" : l_typenm = "계좌이체"
						Case "VBank" : l_typenm = "<a href=""javascript:alert('가상계좌:"&l_vactbankname & " " & l_vact_num &  " " & l_vact_inputname & "'  )"">가상계좌</a>"
						Case "HPP" : l_typenm = "휴대폰결제"
						End Select 

						Select Case l_oorderstate
						Case "00" : l_st = "입금대기"
						Case "01" : l_st = "결제완료"
						Case "88" : l_st = "<a href=""javascript:mx.cancelOK("&l_idx&")"" class=""btn btn-primary"">취소요청</a>"
						Case "89" : l_st = "<span class=""btn-default"" style=""color:#BFBFBF"">취소완료</span>"
						Case "99" : l_st = "결제취소"
						End Select 
						'Case "89" : l_st = "<a href=""javascript:mx.cancelOK("&l_idx&")"" class=""btn btn-danger"">취소완료</a>"

						Select Case l_entertype
						Case "01" : l_entertype =  "전문" 
						Case "02" : l_entertype =  "생활" 
						case "03" : l_entertype =  " 통합" 
						end Select 



						'############################
						%>
						<tr id="titlelist_<%=l_idx%>" style="text-align:center;">
							<td><%=l_idx%></td>
							<td style="text-align:left;"><%=cnm%></td></td>
							<td><%=l_teamnm%></td>
							<td><%=l_leadername%></td>
							<td><%=l_price%></td>
							<td><%=l_st%></td>
							<td><%=l_typenm%></td>



							<td><%=Left(l_reg_date,10)%></td>

<!-- 							 -->
<!-- 							<%If now() < CDate(l_atts)  then%>	 -->
<!-- 							<td >진행전</td> -->
<!-- 							<%ElseIf  CDate(l_atts) <= now() And now()  <= CDate(l_atte)then%> -->
<!-- 							<td class="danger">진행중</td> -->
<!-- 							<%else%> -->
<!-- 							<td class="bg-gray">종료</td> -->
<!-- 							<%End if%> -->
<!-- 							<td><%=l_entertype%></td> -->
<!-- 							<td> -->
<!-- 								  <%If l_oorderstate= "00" Or l_oorderstate = "01" then%> -->
<!-- 								  <a href="javascript:mx.attInfo(<%=l_idx%>)" class="btn btn-primary"><i class="fa fa-thumbs-up"> </i>참가자정보</a> -->
<!-- 								  <%End if%> -->
<!-- 							</td>			 -->


						</tr>
				<%
					 Next
				End if
					%>

					</tbody>
				</table>


            </div>
          </div>
        </div>

	  </div>




		<nav>
			<%
				jsonstr = JSON.stringify(oJSONoutput)
				Call userPagingT2 (intTotalPage, 10, PN, "px.goPN", jsonstr )
			%>
		</nav>




		<!-- s: 콘텐츠 끝 -->


