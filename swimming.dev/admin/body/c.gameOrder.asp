<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################

  'request 처리##############
	If hasown(oJSONoutput, "IDX") = "ok" then
		tidx= oJSONoutput.IDX
	End If
	If hasown(oJSONoutput, "TITLE") = "ok" then
		title= oJSONoutput.TITLE
	End if

  'request 처리##############


	Set db = new clsDBHelper


	
	gameS = " (select gameS from sd_gametitle where gametitleidx = a.gametitleidx ) as games "
	gametitlenm = " (select gametitlename from sd_gametitle where gametitleidx = a.gametitleidx ) as titlenm "
	fld =  " CDANM,CDBNM,CDCNM, " & gametitlenm & " , gametitleidx,gbidx, " & games

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
		games = Replace(Left(rs(6),10),"-","/")
	End If

	'종목
	fld =  " CDC,CDCNM,count(*) "
	strWhere = " GameTitleIDX = "&tidx&" and DelYN = 'N'  and CDA='D2'  and  cdc not in ('31','32','33','34','35','41','42')    group by CDC, CDCNM " '경영만
	SQL = "Select " & fld & " from tblRGameLevel where " & strWhere 
	Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rss.EOF Then
		cr = rss.GetRows() '부별
	End If



	'부서
	attcnt = " ,(select count(*) from tblGameRequest where gametitleIDx = "&tidx&" and gbidx = a.gbidx  and delYN = 'N' ) as attcnt " '신청수
	fld =  " RGameLevelidx,GameTitleIDX,GbIDX,Sexno,ITgubun,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,levelno " & attcnt & ",gubunam,gubunpm"
	strSort = "  ORDER BY cdc ,cdb"
	strWhere = " a.GameTitleIDX = "&tidx&" and a.DelYN = 'N'  and CDA='D2' and  a.cdc not in ('31','32','33','34','35','41','42')   " '경영만

	SQL = "Select " & fld & " from tblRGameLevel as a where " & strWhere & strSort
	Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rss.EOF Then
		fr = rss.GetRows() '개별
	End If


	'설정날짜
	SQL = "select idx,gamedate,am,pm,selectflag from sd_gameStartAMPM where tidx = "& tidx & " order by gamedate"
	Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rss.EOF Then
		tmarr = rss.GetRows()
		last_gamedate= tmarr(1, UBound(tmarr, 2))
	End If

	If IsArray(tmarr) Then 
		For ari = LBound(tmarr, 2) To UBound(tmarr, 2)
			tm_selectflag = tmarr(4, ari)
			
			If ari = 0 Then
				start_gamedate = isNullDefault(tmarr(1, ari), "")
				start_am = isNullDefault(tmarr(2, ari), "")
				start_pm = isNullDefault(tmarr(3, ari), "")
			End If
			
			If tm_selectflag = "Y" Then
				start_gamedate = isNullDefault(tmarr(1, ari), "")
				start_am = isNullDefault(tmarr(2, ari), "")
				start_pm = isNullDefault(tmarr(3, ari), "")
			End If

		Next 
	End if






  '++++++++++++++++++++++++
  If start_gamedate = "" Then
	'날짜 생성전
  else

	'오전
	fld = " min(RGameLevelidx),CDC,CDCNM,min(tryoutgamedate) ,min(tryoutgamestarttime) ,min(gameno) as gameno,gubunam "
	SQL = "select "&fld&" from tblRGameLevel where delyn = 'N' and gametitleidx =  " & tidx  & " and CDA = 'D2' and tryoutgamedate = '"&start_gamedate&"' and tryoutgameingS > 0 "
	SQL = SQL & " group by cdc,cdcnm,gubunam order by gameno "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr) 
	If Not rs.EOF Then
		arrR = rs.GetRows()
	End If

    fld = " RGameLevelidx,GbIDX,ITgubun,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,SetBestScoreYN,tryoutgamedate,tryoutgamestarttime,tryoutgameingS,finalgamedate,finalgamestarttime,finalgameingS,gameno,joono,gameno2,joono2 "
	fld = " min(RGameLevelidx),CDC,CDCNM,min(finalgamedate) ,min(finalgamestarttime),min(gameno2) as gameno2,gubunpm "

	SQL = "select "&fld&" from tblRGameLevel where delyn = 'N' and gametitleidx =  " & tidx  & " and CDA = 'D2' and finalgamedate = '"&start_gamedate&"' and finalgameingS > 0 "
	SQL = SQL & " group by cdc,cdcnm,gubunpm order by gameno2 "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.EOF Then
		arrR2 = rs.GetRows()
	End If

  End if

  'Call getrowsdrow(arrr2)


'페이지 입력폼 상태 확인
pageYN = getPageState( "MN0107", "경기순서" ,Cookies_aIDX , db)
%>


<%'View ####################################################################################################%>
      <div class="box box-primary <%If pageYN="N" then%>collapsed-box<%End if%>">
        <div class="box-header with-border">
          <h3 class="box-title"><%=title%></h3>  <span style="color:green;"> <!-- 수영(경영) 남자초등부 자유형 100M] --></span>

          <div class="box-tools pull-right">
            <button type="button" class="btn btn-box-tool" data-widget="collapse"   onclick="px.hiddenSave({'YN':'<%=pageYN%>','PC':'MN0107'},'/setPageState.asp')"><i class="fa fa-<%If pageYN="N" then%>plus<%else%>minus<%End if%>"></i></button>
          </div>
        </div>

		<div class="box-body" id="gameinput_area">
			<%If CDbl(ADGRADE) > 500 then%>
			<!-- s: 등록화면 -->
			  <!-- #include virtual = "/pub/html/swimming/gameOrderForm.asp" -->
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
								  </div>
							</div>
							<div class="col-md-6" style="width:49%;padding-right:20px;padding-right:0px;text-align:right;">
								  <div class="form-group">
									  <!-- <a href="#" class="btn btn-danger"><i class="fa fa-fw fa-print"></i>인쇄</a> -->

									  <a href="javascript:px.goSubmit({'TIDX':<%=tidx%>,'DIDX':$('#mk_g0').val()},'gameorderDetail.asp')" class="btn btn-primary"><i class="fa fa-fw fa-toggle-right"></i>조회</a>
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
								<th>No</th>
								<th>구분</th>
								<th>종별</th>
								<th>날짜</th>
								<th>시간</th>
								<th>순서에서제거</th><!-- 종모을 통합해서 보여줌으로 모두 삭제된후 뒤에 날짜를 더해서 땡겨주어야한다. -->
						</tr>
					</thead>
					<tbody id="contest"  class="gametitle">
						<tr>
								<th colspan="6" style="text-align:center;background:#eeeeee"><%=start_am%> 오전경기</th>
						</tr>
<%
	weekarr = array("-", "일","월","화","수","목","금","토")

	If IsArray(arrR) Then  '오전
		For ari = LBound(arrR, 2) To UBound(arrR, 2)
			
			l_idx = arrR(0, ari)
			l_CDC = arrR(1, ari)
			l_CDCNM = arrR(2, ari)
			l_tryoutgamedate = arrR(3, ari)
			l_tryoutgamestarttime = arrR(4, ari)
			l_gubun = arrR(6, ari)
			If l_gubun = "1" Then
			gubunstr = "예선"
			Else
			gubunstr = "결승"
			End if
			l_week = weekarr(weekday(l_tryoutgamedate))


	%><!-- #include virtual = "/pub/html/swimming/gameOrderList.asp" --><%


		pre_gameno = r_a2
		Next
	End if
%>

						<tr>
								<th colspan="6" style="text-align:center;background:#eeeeee"><%=start_pm%> 오후경기</th>
						</tr>

<%
	If IsArray(arrR2) Then 
		For ari = LBound(arrR2, 2) To UBound(arrR2, 2)

			l_idx = arrR2(0, ari)
			l_CDC = arrR2(1, ari)
			l_CDCNM = arrR2(2, ari)
			l_finalgamedate = arrR2(3, ari)
			l_finalgamestarttime = arrR2(4, ari)
			l_gubun = arrR2(6, ari)
			If l_gubun = "1" Then
			gubunstr = "예선"
			Else
			gubunstr = "결승"
			End if

	%><!-- #include virtual = "/pub/html/swimming/gameOrderListPM.asp" --><%


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


