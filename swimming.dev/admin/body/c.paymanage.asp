<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################
'with cte_gameLv As (
'	Select * From (
'		select ROW_NUMBER() Over(Partition By GameTitleIdx Order By RGameLevelIdx) As Idx, 
'		* from tblRgameLevel where DelYN = 'N' And CDA = 'D2' ) As AA Where Idx = 1
')
'
'--select * From cte_gameLv Where Idx = 1
'
'select Lv.CDA, Lv.CDANM, * from sd_gametitle As T
'	Inner Join cte_gameLv As Lv On T.GameTitleIDX = Lv.GameTitleIdx 
'where T.delyn = 'N' 


	If F1 = "" Then
		checkSdate  = year(date) & "-01-01"
		checkEdate  = CDbl(year(date))+1 & "-01-01"
		F1 = year(date)
	Else
		checkSdate  = F1 & "-01-01"
		checkEdate  = CDbl(F1)+1 & "-01-01"		
	End if

	fld = " gametitleidx,GameTitleName,gubun,kgame,GameArea,hostname,subjectnm,afternm,sponnm,summaryURL,gameSize,ranecnt,titleCode,attmoney,GameS,GameE,atts,atte,GameType,EnterType,attTypeA,attTypeB,attTypeC,attTypeD,teamLimit,attgameCnt, ViewState,ViewStateM,ViewYN,MatchYN,stateNo"	
	'설정날짜
	SQL = "select "&fld&" from sd_gameTitle where DelYN = 'N' and ( gameS >=  '"& checkSdate &"' and  gameS < '"& checkEdate &"' )  Order  by gametitleidx desc"
	Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)
	


	If Not rss.EOF Then
		grs = rss.GetRows()

		If F2 = "" Then
			F2 = grs(0, 0)
		End if 
	End If


	intPageNum = PN
	intPageSize = 40
	strTableName = " tblSwwimingOrderTable as a INNER JOIN sd_gameTitle as b ON a.gametitleidx = b.gametitleidx and b.delyn = 'N' "

	strFieldName = "a.orderidx,a.or_num,a.team,(select top 1 teamnm from tblteaminfo where team = a.team) as teamnm ,a.leaderidx,a.leadername,a.OorderPayType, a.oorderstate, ( REPLACE(CONVERT(VARCHAR, CAST(a.orderprice AS MONEY),1),'.00','')   ) as price, a.resultmsg, a.vact_num, a.vact_bankcode,a.vactbankname,a.vact_inputname, a.order_tid, a.order_moid,a.reg_date,a.refundbnk,a.refundcc,a.refundnm,a.refunddate  "
	strFieldName  = strFieldName & ", b.gametitleidx,b.gubun,b.gamearea,b.gametitlename,b.titlecode,b.attmoney,b.games,b.gamee,b.atts,b.atte,b.gametype,b.entertype  "

	strSort = "  order by orderidx  desc "
	strSortR = "  order by orderidx "

	'search
'	If chkBlank(F2) Then
'		strWhere = " DelYN = 'N' and ( gameS >=  '"& year(date) & "-01-01" &"' and  gameS < '"& CDbl(year(date))+1 & "-01-01" &"' )  and GameTitleIDX = (select top 1 GameTitleIDX from tblRgameLevel where GameTitleIDX = a.GameTitleIDX and DelYN='N' and cda = 'D2')  "
'		F1 = "D2"
'	Else
'		If IsArray(F1) = false Then
			strWhere = " a.Del_YN = 'N' and a.gubun='1' and b.gametitleidx = '"&F2&"' "
'		End if
'	End if


		Dim intTotalCnt, intTotalPage
		Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
		block_size = 10


	  If Not rs.EOF Then
		arrP = rs.GetRows()
		'Call getrowsdrow(arrp)
	  End If
%>
<%'View ####################################################################################################%>

	  <%'If ADGRADE > 500 then%>
	  <div class="box-body" id="gameinput_area">
			  <!-- #include virtual = "/pub/html/swimming/paymentform.asp" -->
      </div>
	  <%'End if%>





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
								<th>대회명</th>
								<th>소속</th>
								<th>지도자</th>
								<th>결제금액</th>
								<th>상태</th>
								<th>결제방식</th>
								<th>신청기간</th>
								<th>신청</th>
								<th>구분</th>
								<th>참가자정보</th>
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
						l_gametitleidx = arrP(21, ari)
						l_gubun = arrP(22, ari)
						l_gamearea = arrP(23, ari)
						l_gametitlename = arrP(24, ari)
						l_titlecode = arrP(25, ari)
						l_attmoney = arrP(26, ari)
						l_games = arrP(27, ari)
						l_gamee = arrP(28, ari)
						l_atts = arrP(29, ari)
						l_atte = arrP(30, ari)
						l_gametype = arrP(31, ari)
						l_entertype  = arrP(32, ari)


						Select Case l_OorderPayType
						Case "Card" : l_typenm = "카드"
						Case "DirectBank" : l_typenm = "계좌이체"
						Case "VBank" 
						If l_oorderstate = "88"   or l_oorderstate = "89"  then
							l_typenm = "<a href=""javascript:alert('환불요청 은행,계좌번호, 신청자 \n\n "&l_refundbnk & ", " & l_refundcc &  ", " & l_refundnm & "'  )"">환불계좌정보</a>"
						Else
							l_typenm = "<a href=""javascript:alert('가상계좌:"&l_vactbankname & " " & l_vact_num &  " " & l_vact_inputname & "'  )"">가상계좌</a>"
						End if


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
							<td style="text-align:left;"><%=l_GameTitleName%></td></td>
							<td><%=l_teamnm%></td>
							<td><%=l_leadername%></td>
							<td><%=l_price%></td>
							<td><%=l_st%></td>
							<td><%=l_typenm%></td>



							<td><%=l_atts%>~<%=l_atte%></td>
							<%If now() < CDate(l_atts)  then%>	
							<td >진행전</td>
							<%ElseIf  CDate(l_atts) <= now() And now()  <= CDate(l_atte)then%>
							<td class="danger">진행중</td>
							<%else%>
							<td class="bg-gray">종료</td>
							<%End if%>
					

							<td><%=l_entertype%></td>
						
							<td>
								  <%If l_oorderstate= "00" Or l_oorderstate = "01" then%>
								  <a href="javascript:mx.attInfo(<%=l_idx%>)" class="btn btn-primary"><i class="fa fa-thumbs-up"> </i>참가자정보</a>
								  <%End if%>
							</td>			
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


