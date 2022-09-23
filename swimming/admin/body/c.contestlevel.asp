<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################

  'request 처리##############
  If request("idx") = "" Then
    Response.redirect "./contest.asp"
    Response.End
  End if

	If hasown(oJSONoutput, "IDX") = "ok" then
		tidx = oJSONoutput.IDX
	Else
		tidx = chkInt(chkReqMethod("idx", "GET"), 1)	
	End if
	If hasown(oJSONoutput, "TITLE") = "ok" then
		title = oJSONoutput.TITLE
	End If
	If hasown(oJSONoutput, "KYN") = "ok" then
		kyn = oJSONoutput.KYN '유년부의 부서가 달라져서 넣었으나 대한 채육회 정보와 틀려서 사용하지 않음 form 양식에 주석확인
	End if	


  titleidx = tidx
  'request 처리##############
  Set db = new clsDBHelper

'페이지 입력폼 상태 확인
pageYN = getPageState( "MN0102", "대회정보관리상세" ,Cookies_aIDX , db)
%>
<%'View ####################################################################################################%>
      <div class="box box-primary <%If pageYN="N" then%>collapsed-box<%End if%>">
        <div class="box-header with-border">
          <h3 class="box-title"><%=title%></h3>

          <div class="box-tools pull-right">
            <button type="button" class="btn btn-box-tool" data-widget="collapse" onclick="px.hiddenSave({'YN':'<%=pageYN%>','PC':'MN0102'},'/setPageState.asp')"><i class="fa fa-<%If pageYN="N" then%>plus<%else%>minus<%End if%>"></i></button>
          </div>
        </div>

		<div class="box-body" id="gameinput_area">
			<%If CDbl(ADGRADE) > 500 then%>
			<!-- s: 등록화면 -->
			  <!-- #include virtual = "/pub/html/swimming/gameinfolevelform.asp" -->
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

								  </div>
							</div>
							<div class="col-md-6" style="width:49%;padding-right:20px;padding-right:0px;text-align:right;">
								  <div class="form-group">
										<a href="./contest.asp" id="btnsave" class="btn btn-primary"><i class="fa fa-fw fa-list-alt"></i> 대회목록보기</a>
										  <!-- <a href="javascript:px.exportExcel( '<%=title%>', '종별-<%=Date()%>' ,'swtable')" class="btn btn-danger"><i class="fa fa-fw fa-file-excel-o"></i>엑셀다운로드</a> -->
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
								<th>NO</th>
								<th>개인/단체</th>
								<th>부서(성별)</th>
								<th>종목</th>
								<th>출전선수관리</th>
								<th>대진추첨</th>
								<th>대진표</th>
								<th>삭제</th>
						</tr>
					</thead>
					<tbody id="contest"  class="gametitle">

<%

	chktable = " ,(select max(gubun) from sd_gameMember where gametitleIDx = "&tidx&" and gbidx = a.gbidx  and delYN = 'N'   and tryoutsortno > 0 ) as gubun " '대신표

	attcnt = " ,(select count(*) from tblGameRequest where gametitleIDx = "&tidx&" and gbidx = a.gbidx  and delYN = 'N' ) as attcnt " '신청수
	fld =  " RGameLevelidx,GameTitleIDX,GbIDX,Sexno,ITgubun,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,levelno " & attcnt & chktable
	strSort = "  ORDER BY CDA, itgubun,cdc,Sexno , cdb desc"
	strWhere = " a.GameTitleIDX = "&tidx&" and a.DelYN = 'N' "

	SQL = "Select " & fld & " from tblRGameLevel as a where " & strWhere & strSort
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

'Response.write sql

'	Call rsdrow(rs)
'	Response.end

	If Not rs.EOF Then
		arrR = rs.GetRows()
	End If




	If IsArray(arrR) Then 
		For ari = LBound(arrR, 2) To UBound(arrR, 2)
			l_idx = arrR(0, ari) 'idx
			l_tidx = arrR(1, ari)
			l_gbidx= arrR(2, ari)
			l_Sexno= arrR(3, ari)
			Select Case l_Sexno
			Case "1"
				l_sex = "남자"
			Case "2"
				l_sex = "남자"
			Case "3"
				l_sex = "혼성"
			End Select 

			l_ITgubun= arrR(4, ari)
			l_CDA= arrR(5, ari)
			l_CDANM= arrR(6, ari)
			l_CDB= arrR(7, ari)
			l_CDBNM= arrR(8, ari)
			l_CDC= arrR(9, ari)
			l_CDCNM= arrR(10, ari)
			l_levelno= arrR(11, ari)

			l_attcnt= arrR(12, ari)
			l_gubun = arrR(13, ari)



			%><!-- #include virtual = "/pub/html/swimming/gameinfolevellist.asp" --><%
		Next
	End if
%>


					</tbody>
				</table>


            </div>
          </div>
        </div>

	  </div>

