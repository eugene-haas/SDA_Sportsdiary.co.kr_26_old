<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################

  'request 처리##############
	If hasown(oJSONoutput, "TIDX") = "ok" then
		tidx= oJSONoutput.TIDX
	End If
	If hasown(oJSONoutput, "DIDX") = "ok" then
		didx= oJSONoutput.DIDX
	End if

  'request 처리##############


	Set db = new clsDBHelper

	gametitlenm = " (select gametitlename from sd_gametitle where gametitleidx = a.gametitleidx ) as titlenm "
	fld =  " CDANM,CDBNM,CDCNM, " & gametitlenm & " , gametitleidx,gbidx "

	If tidx = "" Then
	'마지막 대회 번호를 가져오자.(경영만)
	SQL = "Select top 1 " & fld & " from tblRGameLevel as a where delyn = 'N' and CDA='D2' order by gametitleidx desc, gbidx asc "
	else
	SQL = "Select top 1 " & fld & " from tblRGameLevel as a where delyn = 'N' and gametitleidx =  '"&tidx&"' and CDA='D2' "
	End If

	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		title = rs(3)
		lnm = rs(3) & " " & rs(0) & " " & rs(1) & " " & rs(2) 
		tidx = rs(4)
		gbidx = rs(5)
	End If



	'설정날짜
	SQL = "select idx,gamedate,am,pm,selectflag from sd_gameStartAMPM where tidx = "& tidx & "  order by gamedate"
	Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rss.EOF Then
		tmarr = rss.GetRows()
		last_gamedate= tmarr(1, UBound(tmarr, 2))
	End If

	If IsArray(tmarr) Then 
		For ari = LBound(tmarr, 2) To UBound(tmarr, 2)
			tm_selectflag = tmarr(4, ari)
			If ari = 0 Then
				start_gamedate = Replace(isNullDefault(tmarr(1, ari), ""),"/","-")
				start_am = isNullDefault(tmarr(2, ari), "")
				start_pm = isNullDefault(tmarr(3, ari), "")
			End If
			
			If tm_selectflag = "Y" Then
				start_gamedate = Replace(isNullDefault(tmarr(1, ari), ""),"/","-")
				start_am = isNullDefault(tmarr(2, ari), "")
				start_pm = isNullDefault(tmarr(3, ari), "")
			End If

		Next 
	End if






  '++++++++++++++++++++++++
  fld = " RGameLevelidx,GbIDX,ITgubun,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,SetBestScoreYN,tryoutgamedate,tryoutgamestarttime,tryoutgameingS,finalgamedate,finalgamestarttime,finalgameingS,gameno,joono,gameno2,joono2,gubunam,gubunpm "
  If start_gamedate = "" Then
	'날짜 생성전
  else

	'오전 오후 두개 가져오자.
	SQL = "select "&fld&" from tblRGameLevel where delyn = 'N' and gametitleidx =  " & tidx  & " and (tryoutgamedate = '"&start_gamedate&"' and tryoutgameingS > 0) order by gameno "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.EOF Then
		arrR = rs.GetRows()
	End If

	SQL = "select "&fld&" from tblRGameLevel where delyn = 'N' and gametitleidx =  " & tidx  & " and (finalgamedate = '"&start_gamedate&"' and finalgameingS > 0)    order by gameno2 "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.EOF Then
		arrR2 = rs.GetRows()
	End If

  End if


  'Response.write sql
  'Call getrowsdrow(arrr2)



%>


<%'View ####################################################################################################%>
      <div class="box box-primary">
        <div class="box-header with-border">
          <h3 class="box-title"><%=title%></h3>  <span style="color:green;"></span>
        </div>

		<div class="box-body" id="gameinput_area">
			<%If CDbl(ADGRADE) > 500 then%>
			<!-- s: 등록화면 -->
			  <!-- #include virtual = "/pub/html/swimming/gameOrderDetailForm.asp" -->
			<!-- e: 등록 화면 -->
			<%End if%>
        </div>
        <!-- <div class="box-footer"></div> -->
      </div>






      <div class="row">

		<div class="col-xs-12">
          <div class="box">
            <div class="box-header" style="text-align:right;padding-right:20px;">
              
						<div class="row" >
							<div class="col-md-6" style="width:50%;padding-left:20px;padding-right:0px;text-align:left;">
								  <div class="form-group">
									종별 리스트
									<span style="color:blue">* 변경 할 '조개수'를 정확히 입력하시고  '게임번호'를 중복으로 사용하지 마십시오.</span>
								  </div>
							</div>
							<div class="col-md-6" style="width:49%;padding-right:20px;padding-right:0px;text-align:right;">
								  <div class="form-group">
									  
									  
									  <a href="javascript:px.goSubmit({'TIDX':<%=tidx%>,'DIDX':<%=didx%>},'excel03.asp');" class="btn btn-danger"><i class="fa fa-fw fa-file-excel-o"></i>예선엑셀</a>

									  <!-- <a href="javascript:px.exportExcel( '<%=title%>', '<%=Replace(select_gamedate,"/","-")%>' ,'swtable')" class="btn btn-danger"><i class="fa fa-fw fa-file-excel-o"></i>엑셀다운로드</a> -->
									  
									  <a href="javascript:$('#swtable').printThis({importCSS: false,loadCSS: 'http://rhttp://swimming.sportsdiary.co.kr/pub/js/print/print_swim.css',header: '<h1><%=title%></h1>'});" class="btn btn-danger"><i class="fa fa-fw fa-print"></i>인쇄</a>
									 

								  </div>
							</div>
						</div>			  
						  <!-- <h3 class="box-title">Hover Data Table</h3> -->
            </div>
            <!-- /.box-header -->

            <div class="box-body">
              <table id="swtable" class="table table-bordered table-hover" >
                <thead class="bg-light-blue-active color-palette">





						<tr>
								<th>순서</th>
								<th>경기번호- 조개수</th>
								<th>부별</th>
								<th>종별</th>
								<th>구분</th>
						</tr>
					</thead>
					<tbody id="contest"  class="gametitle">
						<tr>
								<th colspan="6" style="text-align:center;background:#eeeeee"><%=start_am%> 오전경기</th>
						</tr>
<%
	weekarr = array("-", "일","월","화","수","목","금","토")
	
	If IsArray(arrR) Then 
	lastno = UBound(arrR, 2)
		For ari = LBound(arrR, 2) To UBound(arrR, 2)

			l_idx = arrR(0, ari)
			l_GbIDX = arrR(1, ari)
			l_ITgubun = arrR(2, ari)
			l_CDA = arrR(3, ari)
			l_CDANM = arrR(4, ari)
			l_CDB = arrR(5, ari)
			l_CDBNM = arrR(6, ari)
			l_CDC = arrR(7, ari)
			l_CDCNM = arrR(8, ari)
			l_SetBestScoreYN = arrR(9, ari)
			l_tryoutgamedate = arrR(10, ari)
			l_tryoutgamestarttime = arrR(11, ari)
			l_tryoutgameingS = arrR(12, ari)
			l_finalgamedate = arrR(13, ari)
			l_finalgamestarttime = arrR(14, ari)
			l_finalgameingS = arrR(15, ari)
			l_gameno = arrR(16, ari)
			l_joono = arrR(17, ari)
			l_week = weekarr(weekday(l_tryoutgamedate))


			l_gubun = arrR(20, ari)
			If l_gubun = "1" Then
			gubunstr = "예선"
			Else
			gubunstr = "결승"
			End if



	%><!-- #include virtual = "/pub/html/swimming/gameOrderList_detail.asp" --><%


		pre_gameno = r_a2
		Next
	End if
%>

						<tr>
								<th colspan="6" style="text-align:center;background:#eeeeee"><%=start_pm%> 오후경기</th>
						</tr>

<%
	If IsArray(arrR2) Then 
	lastno = UBound(arrR2, 2)
		For ari = LBound(arrR2, 2) To UBound(arrR2, 2)

			l_idx = arrR2(0, ari)
			l_GbIDX = arrR2(1, ari)
			l_ITgubun = arrR2(2, ari)
			l_CDA = arrR2(3, ari)
			l_CDANM = arrR2(4, ari)
			l_CDB = arrR2(5, ari)
			l_CDBNM = arrR2(6, ari)
			l_CDC = arrR2(7, ari)
			l_CDCNM = arrR2(8, ari)
			l_SetBestScoreYN = arrR2(9, ari)
			l_tryoutgamedate = arrR2(10, ari)
			l_tryoutgamestarttime = arrR2(11, ari)
			l_tryoutgameingS = arrR2(12, ari)
			l_finalgamedate = arrR2(13, ari)
			l_finalgamestarttime = arrR2(14, ari)
			l_finalgameingS = arrR2(15, ari)
			l_gameno = arrR2(16, ari)
			l_joono = arrR2(17, ari)

			l_gameno2 = arrR2(18, ari)
			l_joono2 = arrR2(19, ari)

			l_week = weekarr(weekday(l_finalgamedate))

			l_gubun = arrR2(21, ari)
			If l_gubun = "1" Then
			gubunstr = "예선"
			Else
			gubunstr = "결승"
			End if

	%><!-- #include virtual = "/pub/html/swimming/gameOrderListPM_detail.asp" --><%


		pre_gameno = r_a2
		Next
	End if
%>



					</tbody>
				</table>


            </div>
          </div>
        </div>

	  </div>


