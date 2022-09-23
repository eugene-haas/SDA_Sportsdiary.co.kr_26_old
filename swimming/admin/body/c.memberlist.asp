<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################

  'request 처리##############
	If hasown(oJSONoutput, "IDX") = "ok" then
		idx= oJSONoutput.IDX '종목인덱스
	Else
		'Response.redirect "./contest.asp"
		'Response.End	
	End If
	If hasown(oJSONoutput, "TITLE") = "ok" then
		title= oJSONoutput.TITLE
	End if

  'request 처리##############


	Set db = new clsDBHelper

'	attcnt = " ,(select count(*) from tblGameRequest where gametitleIDx = "&tidx&" and gbidx = a.gbidx  and delYN = 'N' ) as attcnt " '신청수
'	fld =  " RGameLevelidx,GameTitleIDX,GbIDX,Sexno,ITgubun,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,levelno " & attcnt
'	strSort = "  ORDER BY writedate Desc"
'	strWhere = " a.GameTitleIDX = "&tidx&" and a.DelYN = 'N' "
'
'	SQL = "Select " & fld & " from tblRGameLevel as a where " & strWhere & strSort
'	Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)
'
'	If Not rss.EOF Then
'		fr = rss.GetRows()
'	End If


  '++++++++++++++++++++++++
  SQL = "select top 1 idx,gametitleidx,team,teamNm,fileUrl from sd_schoolConfirm " 
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

  If Not rs.EOF Then
		arrR = rs.GetRows()
  End If
%>


<%'View ####################################################################################################%>
      <div class="box box-primary"> <!-- collapsed-box -->
        <div class="box-header with-border">
          <h3 class="box-title">회원정보관리</h3>

          <div class="box-tools pull-right">
            <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i></button><!-- fa fa-plus -->
          </div>
        </div>

		<div class="box-body" id="gameinput_area">
			<%If CDbl(ADGRADE) > 500 then%>
			<!-- s: 등록화면 -->
			  <!-- #include virtual = "/pub/html/swimming/memberlistForm.asp" -->
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
							<div class="col-md-6" style="width:40%;padding-left:20px;padding-right:0px;text-align:left;">
								  <div class="form-group">

									<div class="input-group date">
										<input type="text" id="mk_g2" placeholder="이름/소속" value="<%=e_GameArea%>" class="form-control">
										<div class="input-group-addon" onmousedown="alert('검색하자')">
										  <i class="fa fa-fw fa-search"></i>
										</div>
									</div>									
									

								  </div>
							</div>
							<div class="col-md-6" style="width:59%;padding-right:20px;padding-right:0px;text-align:right;">
								  <div class="form-group">
									  <!-- <a href="" class="btn btn-danger"><i class="fa fa-fw fa-file-excel-o"></i>엑셀</a>
									  <a href="#" class="btn btn-danger"><i class="fa fa-fw fa-print"></i>인쇄</a> -->
										<a href="#" class="btn btn-danger" id="btndel" onclick="mx.del_frm();" accesskey="r">삭제<span>(R)</span></a>
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
								<th>C</th>
								<th>NO</th>
								<th>이름</th>
								<th>구분</th>
								<th>상태</th>
								<th>연락처</th>
								<th>휴대폰</th>
								<th>시도</th>
								<th>성별</th>
								<th>소속팀</th>
								<th>ID제한(form_IP)</th>
								<th>ID제한(to_IP)</th>
								<th>수정</th>
						</tr>
					</thead>
					<tbody id="contest"  class="gametitle">


<%


	If IsArray(arrR) Then 
		For ari = LBound(arrR, 2) To UBound(arrR, 2)
			l_idx = arrR(0, ari)
			l_gametitleidx = arrR(1, ari)
			l_team = arrR(2, ari)
			l_teamNm = arrR(3, ari)
			l_fileUrl = arrR(4, ari)

	%><!-- #include virtual = "/pub/html/swimming/list.member.asp" --><%


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


