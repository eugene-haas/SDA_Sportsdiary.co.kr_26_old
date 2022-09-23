<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################

  'request 처리##############
	If hasown(oJSONoutput, "IDX") = "ok" then
		idx= oJSONoutput.IDX '종목인덱스
	End If
	If hasown(oJSONoutput, "GB") = "ok" then
		gbidx =  oJSONoutput.GB '종목인덱스
	End If
	If hasown(oJSONoutput, "TGB") = "ok" then
		tidx =  oJSONoutput.TGB 
	End If
	If hasown(oJSONoutput, "LNM") = "ok" then
		lnm= oJSONoutput.LNM
	End if
  'request 처리##############

	Set db = new clsDBHelper

	strSql = "SELECT top 1  kgame,GameTitleName  FROM sd_gameTitle   WHERE gametitleidx = " & tidx
	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)		

	If Not rs.eof Then
		kgame = rs(0)
		gametitle = rs(1)
	End if

	'######################

	attcnt = " (select count(*) from tblGameRequest where gametitleidx = a.gametitleidx  and P1_PlayerIDX = a.P1_PlayerIDX and delyn = 'N' ) as attcnt  "

	strFieldName = " RequestIDX,GameTitleIDX,gbIDX,levelno,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,P1_Midx,P1_PlayerIDX,P1_UserName,P1_UserClass,P1_Team,P1_TeamNm,P1_Team2,P1_TeamNm2,P1_UserPhone,P1_Birthday,P1_SEX,P2_Midx,P2_PlayerIDX,P2_UserName,P2_UserClass,P2_Team,P2_TeamNm,P2_Team2,P2_TeamNm2,P2_UserPhone,P2_Birthday,P2_SEX,PaymentDt,PaymentNm,PaymentType,    P1_ksportsno, P2_ksportsno ," & attcnt & ",sido,sidonm "
	
	strSort = "  ORDER By RequestIDX Desc"
	strWhere = " GameTitleIDX = "&tidx&"  and GbIDX = '"&GbIDX&"' and DelYN = 'N'"
	SQL = "select "&strFieldName&" from tblGameRequest as a where " & strWhere & strSort
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		mcnt = rs.recordcount
		arrR = rs.GetRows()
		l_CDC = arrR(8, 0)
		Set rs = Nothing
	End If


'	SQL = "Select b.cd_mcnt from tblRgameLevel as a "
	SQL = "select cd_mcnt from tblTeamGbInfo where TeamGbIDX = " & gbidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.eof Then
		f_itgubun  = rs(0)
	End if
%>


<%'View ####################################################################################################%>
      <div class="box box-primary">
        <div class="box-header with-border">
          <h3 class="box-title"><%=title%></h3>  <span style="color:green;"> <%=lnm%></span>

          <div class="box-tools pull-right">
            <button type="button" class="btn btn-box-tool" data-widget="collapse"><!-- <i class="fa fa-minus"></i> --></button>
          </div>
        </div>

		<div class="box-body" id="gameinput_area">
			<%If CDbl(ADGRADE) > 500 then%>
			<!-- s: 등록화면 -->
			  <%'If l_CDC = "16" Or l_CDC = "17" Or l_CDC="15" Then%>
			  <%If f_itgubun = "T" then%>
			  <!-- #include virtual = "/pub/html/swimming/gameinfoplayerGroupform.asp" -->
			  <%else%>
			  <!-- #include virtual = "/pub/html/swimming/gameinfoplayerform.asp" -->
			  <%End if%>
			<!-- e: 등록 화면 -->
			<%End if%>
        </div>
        <!-- <div class="box-footer"></div> -->
      </div>



      <div class="row">

		<div class="col-xs-12">
          <div class="box">
            <div class="box-header" style="text-align:right;padding-right:20px;">
              
						<div class="row">
							<div class="col-md-6" style="width:50%;padding-left:20px;padding-right:0px;text-align:left;">
								  <div class="form-group">
									<a href="javascript:px.goSubmit({'IDX':<%=tidx%>,'TITLE':'<%=gametitle%>','KYN':'<%=kgame%>'},'contestlevel.asp?idx=<%=tidx%>')" id="btnsave" class="btn btn-primary"><i class="fa fa-fw fa-list-alt"></i> 세부종목보기</a>

									<%If f_itgubun = "T" then%>
									<a href="javascript:mx.input_fromTest(<%=idx%>)" id="btnsave" class="btn btn-primary"><i class="fa fa-fw fa-list-alt"></i>테스트용팀 생성(랜덤개)</a>
									<%else%>
									<a href="javascript:mx.input_fromTest(<%=idx%>)" id="btnsave" class="btn btn-primary"><i class="fa fa-fw fa-list-alt"></i>테스트용참가자 생성(랜덤개)</a>
									<%End if%>
								  </div>
							</div>
							<div class="col-md-6" style="width:49%;padding-right:20px;padding-right:0px;text-align:right;">
								  <div class="form-group">
										  <%If f_itgubun = "T" then%>
										  <i class="fa fa-fw fa-share-alt"></i> 출전팀 (총 <%=mcnt%>)
										  <%else%>
										  <i class="fa fa-fw fa-share-alt"></i> 출전선수 (총 <%=mcnt%>명)
										  <%End if%>
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
								<%If f_itgubun = "T" then%>
								<th>NO</th>
								<th>종별</th>
								<th>종목</th>
								<th>단체장</th>
								<th>소속명</th>
								<th>시도</th>
								<th>선수목록보기</th>
								<%else%>
								<th>NO</th>
								<th>종별</th>
								<th>종목</th>
								<th>이름</th>
								<th>소속명</th>
								<th>학년</th>
								<th>참가신청횟수</th>
								<th>선수번호</th>
								<%End if%>
								<th>신청취소</th>
						</tr>
					</thead>
					<tbody id="contest"  class="gametitle">

<%
	no = 1
	If IsArray(arrR) Then 
		For ari = LBound(arrR, 2) To UBound(arrR, 2)

				l_idx = arrR(0, ari)
				l_GameTitleIDX = arrR(1, ari)
				l_gbIDX = arrR(2, ari)
				l_levelno = arrR(3, ari)
				l_CDA = arrR(4, ari)
				l_CDANM = arrR(5, ari)
				l_CDB = arrR(6, ari)
				l_CDBNM = arrR(7, ari)
				l_CDC = arrR(8, ari)
				l_CDCNM = arrR(9, ari)
				l_P1_Midx = arrR(10, ari)
				l_P1_PlayerIDX = arrR(11, ari)
				l_P1_UserName = arrR(12, ari)
				l_P1_UserClass = arrR(13, ari)
				l_P1_Team = arrR(14, ari)
				l_P1_TeamNm = arrR(15, ari)
				l_P1_Team2 = arrR(16, ari)
				l_P1_TeamNm2 = arrR(17, ari)
				l_P1_UserPhone = arrR(18, ari)
				l_P1_Birthday = arrR(19, ari)
				l_P1_SEX = arrR(20, ari)
				l_P2_Midx = arrR(21, ari)
				l_P2_PlayerIDX = arrR(22, ari)
				l_P2_UserName = arrR(23, ari)
				l_P2_UserClass = arrR(24, ari)
				l_P2_Team = arrR(25, ari)
				l_P2_TeamNm = arrR(26, ari)
				l_P2_Team2 = arrR(27, ari)
				l_P2_TeamNm2 = arrR(28, ari)
				l_P2_UserPhone = arrR(29, ari)
				l_P2_Birthday = arrR(30, ari)
				l_P2_SEX = arrR(31, ari)
				l_PaymentDt = arrR(32, ari)
				l_PaymentNm = arrR(33, ari)
				l_PaymentType = arrR(34, ari)

				P1_ksportsno = arrR(35, ari)
				P2_ksportsno = arrR(36, ari)
				l_attcnt = arrR(37, ari)

				l_sido = arrR(38,ari)
				l_sidonm = arrR(39, ari)

			%><!-- #include virtual = "/pub/html/swimming/gameInfoPlayerList.asp" --><%
		no = no + 1
		Next
	End if
%>
					</tbody>
				</table>


            </div>
          </div>
        </div>

	  </div>


