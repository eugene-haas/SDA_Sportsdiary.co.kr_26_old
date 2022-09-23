<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################

  'request 처리##############
	tidx = oJSONoutput.Get("IDX") 
	gametitle =  oJSONoutput.Get("TITLE") '종목인덱스
	f3 = oJSONoutput.Get("F3")
  'request 처리##############

	Set db = new clsDBHelper


	If tidx <> "" Then
		F2 = tidx
	End if

	Select Case f3
	Case "" : findschool = ""
	Case Else
		findschool = " and (Select top 1 cdb as ccode from tblGameRequest_imsi where team = a.team  and tidx = '"&F2&"' and delyn = 'N'   )  = '"&f3&"'  "

'	Case "1" : findschool = " and c.CDB like '%초등학교' "
'	Case "2" : findschool = " and c.teamnm like '%중학교' "
'	Case "3" : findschool = " and (c.teamnm like '%고등학교%'  or  c.teamnm like '%국제학교%') "
'	Case "4" : findschool = " and c.teamnm like '%대학교%' "
'	Case "5" : findschool = " and  not (c.teamnm like '%초등학교'  or c.teamnm like '%중학교'  or c.teamnm like '%고등학교'  or c.teamnm like '%대학교'  )   "
	End Select 

	


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
	intPageSize = 50
'	strTableName = " tblSwwimingOrderTable as a INNER JOIN sd_gameTitle as b ON a.gametitleidx = b.gametitleidx and b.delyn = 'N'  inner join tblteaminfo as c on a.team = c.team and c.delyn = 'N'  "
	strTableName = " tblSwwimingOrderTable as a INNER JOIN sd_gameTitle as b ON a.gametitleidx = b.gametitleidx and b.delyn = 'N'   "

	strFieldName = "a.orderidx,a.or_num,a.team, (select top 1 teamnm from tblteaminfo where team = a.team) as teamnm ,a.leaderidx,a.leadername,a.OorderPayType, a.oorderstate, ( REPLACE(CONVERT(VARCHAR, CAST(a.orderprice AS MONEY),1),'.00','')   ) as price, a.resultmsg, a.vact_num, a.vact_bankcode,a.vactbankname,a.vact_inputname, a.order_tid, a.order_moid,a.reg_date,a.refundbnk,a.refundcc,a.refundnm,a.refunddate  "
	strFieldName  = strFieldName & ", b.gametitleidx,b.gubun,b.gamearea,b.gametitlename,b.titlecode,b.attmoney,b.games,b.gamee,b.atts,b.atte,b.gametype,b.entertype  "
	strFieldName  = strFieldName & ", (Select count(*) from tblGameRequest_imsi as x where x.team = a.team  and x.tidx = '"&F2&"' and x.delyn = 'N'  and leaderidx = a.leaderidx )  as cnt "
	strFieldName  = strFieldName & ", (Select top 1 fileUrl  from sd_schoolConfirm as s where s.team = a.team  and s.gametitleidx = '"&F2&"'  and leaderidx = a.leaderidx )  as fileurl   " '학교장확인서
	strFieldName  = strFieldName & ", okey " '0 비승인 1승인 (학교장확인서를 보고 협회에서 최종승인여부 확인용) 21.2.25 dh요청
	'strFieldName  = strFieldName & ", (Select top 1 cdb from tblGameRequest_imsi as x where team = a.team  and tidx = '"&F2&"' and x.delyn = 'N'  and leaderidx = a.leaderidx )  as cdb "

	strSort = "  order by orderidx  desc "
	strSortR = "  order by orderidx "

	strWhere = " a.Del_YN = 'N' and a.gubun='1' and b.gametitleidx = '"&F2&"'  and oorderstate = '01'   " & findschool


'Response.write strwhere


		Dim intTotalCnt, intTotalPage
		Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
		block_size = 10


	  If Not rs.EOF Then
		arrP = rs.GetRows()
			'페이지 팀코드 구하기
			For ari = LBound(arrP, 2) To UBound(arrP, 2)
				teamcd = arrP(2, ari)
				If ari = 0 then
					teamwhere = "'"&teamcd&"'"
				Else
					teamwhere = teamwhere & "," & "'" & teamcd & "'"
				End if
			Next
			
	  End If




	totalcnt = 0
	If teamwhere <> "" then
	'카운트 전체
	'SQL = "Select count(*) from tblGameRequest_imsi as c  where tidx = '"&F2&"' and delyn = 'N'  and payok= 'Y'   " & findschool

	SQL = " select count(*) from (Select kskey from tblGameRequest_imsi as c  where tidx =  '"&F2&"' and delyn = 'N'   "
	SQL = SQL & " and kskey  in (select case when itgubun = 'T' then b.kskey else a.p1_ksportsno end  from tblgameRequest as a left join tblGameRequest_r as b on a.requestidx = b.requestIDX   where gametitleidx =  '"&F2&"' and a.delyn= 'N' ) "
	SQL = SQL & " group by kskey) as A "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	totalcnt = rs(0)
	
	
	'참가자정보
	fldboo = " ,(SELECT  STUFF(( select ','+ CDCNM from tblGameRequest_imsi_r where seq  = a.seq group by CDCNM for XML path('') ),1,1, '' )) as '참가종목' "
	fld = " a.playeridx as 'key' ,a.username as '이름',a.birthday as '생년',  (case when   a.sex = 1 then '남'  else '여' end) as '성별'               "
	fld = fld & " , ( case when  a.CDBNM = '초등부' and  a.userclass < 5 then '유년부' else a.CDBNM end)   as '참여부'  "
	fld = fld & "	,a.userclass  as '학년' " & fldboo & ", a.team , a.leaderidx "
	SQL = "Select "&fld&" from tblGameRequest_imsi as a  where a.team in ("&teamwhere&")  and a.tidx = '"&F2&"' and delyn = 'N'  order by a.team"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	
	If Not rs.EOF Then
		arrA = rs.GetRows()
	End if
	End if	


'Call getrowsdrow(arrP)
%>



<%'View ####################################################################################################%>

	  <div class="box-body" id="gameinput_area">
			  <!-- #include virtual = "/pub/html/swimming/attinfoform.asp" -->
      </div>


      <div class="row">

		<div class="col-xs-12">
          <div class="box">
           <div class="box-header">
					
<div class="row">
            <div class="col-md-6">
		            <h3 class="box-title" style="margin-right:100px;"><i class="fa fa-fw fa-share-alt"></i> 전체참여인원 (<%=totalcnt%>)</h3>  
			</div>
			<div class="col-md-6">
			</div>
            <div class="col-md-6">
			</div>
            <div class="col-md-6" style="text-align:right;padding-right:20px;">
					<a href="/excelattmember.asp?f2=<%=f2%>&f3=<%=f3%>" class="btn btn-danger" target="_blank">엑셀출력</a>
			</div>
</div>


            </div>
            <!-- /.box-header -->

            <div class="box-body">

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
						l_attcnt = arrP(33,ari)
						l_fileurl = isnulldefault(arrP(34,ari),"")
						l_onoff = isnulldefault(arrP(35,ari),0)
						'l_cdb =  arrP(36,ari)


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

						  <div class="box box-primary collapsed-box" style="margin-bottom:1px;">
							<div class="box-header with-border" >
							  <h3 class="box-title">
									<%=l_teamnm%>  <span style="font-size:13px;">, 지도자 (<%=l_leadername%>),  참가명수 (<%=l_attcnt%>명)</span>   

									<%If l_fileUrl <> "" then%>
									<a href="http://upload.sportsdiary.co.kr/sportsdiary<%=l_fileUrl%>" class="btn btn-default" target="_blank">학교장확인서</a>
									<%End if%>

									<button style="margin-right:-10px;margin-left:20px;" id="<%=l_idx%>_1" type="button" class="btn btn-<%If l_onoff = "1" then%>primary<%else%>default<%End if%>" onclick="mx.SetOK('<%=l_idx%>' ,1)">ON</button>


									<button type="button" id="<%=l_idx%>_2" class="btn btn-<%If l_onoff = "1" then%>default<%else%>primary<%End if%>" onclick="mx.SetOK('<%=l_idx%>' ,2)">OFF</button> <%'=l_cdb%>

							  </h3>
							  <div class="box-tools pull-right">
								<button type="button" class="btn btn-box-tool" data-widget="collapse" >
								<i class="fa fa-plus"></i>
								</button>
							  </div>
							</div>

							<div class="box-body" id="game_<%=l_idx%>" style="tabindex:<%=CDbl(ari) + 1%>">
									<table class="table" id="tblrsdrow">
									<thead id="headtest"><tr><th>key</th><th>이름</th><th>생년</th><th>성별</th><th>참여부</th><th>학년</th><th>참가종목</th></tr></thead>
									<tbody>
									<%
									i = 0 
									If IsArray(arrA) Then 
									For x = LBound(arrA, 2) To UBound(arrA, 2)
										m_pidx =  arrA(0, x)
										m_nm =  arrA(1, x)
										m_birth =  arrA(2, x)
										m_sex =  arrA(3, x)
										m_cdbnm =  arrA(4, x)
										m_classno =  arrA(5, x)
										m_attboo =  arrA(6, x)
										m_team =  arrA(7, x)
										m_leaderidx = arrA(8,x)

										If l_team = m_team And CStr(l_leaderidx) = CStr(m_leaderidx) then
										i = i + 1
										%>
										<tr class="gametitle">
										<td><%=m_pidx%></td><td><%=m_nm%></td><td><%=m_birth%></td><td><%=m_sex%></td><td><%=m_cdbnm%></td><td><%=m_classno%></td><td width="50%"><%=m_attboo%></td>
										</tr>
										<%
										End if
									Next
									End If
									
									If i = 0 Then
										classno = " (select top 1 userclass  from tblplayer where playeridx = a.p1_playeridx )  as classno "
										SQL = "select a.p1_ksportsno,a.p1_username,a.p1_birthday,a.p1_sex,a.cdbnm,a.cdcnm,b.username,"&classno&" from tblGameRequest as a left join tblGameRequest_r as b on a.requestidx = b.requestidx and a.delyn='N' where  a.gametitleidx= '"&tidx&"' and a.paymentidx = '"&l_leaderidx&"'"

'Response.write sql
										Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
										Do Until rs.eof
										%>
										<tr class="gametitle">
										<td><%=rs(0)%></td><td><%=rs(1)%><%If rs(6) <> "" then%>[<%=rs(6)%>]<%End if%></td><td><%=rs(2)%></td><td><%=rs(3)%></td><td><%=rs(4)%></td><td><%=rs(7)%></td><td width="50%"><%=rs(5)%></td>
										</tr>
										<%
										rs.movenext
										loop
									End If
									

									%>

									</tbody></table>
							</div>
						  </div>						

				<%
					 Next
				End if
					%>




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










































