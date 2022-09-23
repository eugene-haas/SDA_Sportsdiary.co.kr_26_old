<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################

  'request 처리##############
	If hasown(oJSONoutput, "IDX") = "ok" then
		tidx= oJSONoutput.IDX
	Else
		Response.redirect "./contest.asp"
		Response.End
	End If
	If hasown(oJSONoutput, "TITLE") = "ok" then
		title= oJSONoutput.TITLE
	End if

  'request 처리##############
  Set db = new clsDBHelper



  '결제와 연동해서 보여주자.
  SQL = "select  a.idx,a.gametitleidx,a.team,a.teamNm,a.fileUrl from sd_schoolConfirm  as a inner join tblSwwimingOrderTable as b on a.team = b.team and a.gametitleidx = b.gametitleidx and b.oOrderState = '01'  and b.del_yn = 'N'  and a.leaderidx = b.leaderidx    where a.GameTitleIDX = " & tidx '결제된 것만 보여주면된다.
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

  If Not rs.EOF Then
		arrR = rs.GetRows()
  End If
%>


<%'View ####################################################################################################%>
      <div class="box box-primary collapsed-box">
        <div class="box-header with-border">
          <h3 class="box-title"><%=title%></h3>
        </div>


      </div>





      <div class="row">

		<div class="col-xs-12">
          <div class="box">



            <div class="box-header" style="text-align:right;padding-right:20px;">

						<div class="row">
							<div class="col-md-6" style="width:50%;padding-left:20px;padding-right:0px;text-align:left;">
								  <div class="form-group">
									<a href="./contest.asp" id="btnsave" class="btn btn-primary"><i class="fa fa-fw fa-list-alt"></i> 대회목록보기</a>
								  </div>
							</div>
							<div class="col-md-6" style="width:49%;padding-right:20px;padding-right:0px;text-align:right;">
								  <div class="form-group">
										  <!-- <a href="#" class="btn btn-danger"><i class="fa fa-fw fa-cloud-download"></i>전체 다운로드</a> -->
								  </div>
							</div>
						</div>
						  <!-- <h3 class="box-title">Hover Data Table</h3> -->
            </div>


            <div class="box-body">
              <table id="swtable" class="table table-bordered table-hover" >
                <thead class="bg-light-blue-active color-palette">

						<tr>
								<th>NO</th>
								<th>학교명</th>
								<th>확인서보기</th>
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

	%><!-- #include virtual = "/pub/html/swimming/gameschoolchecklist.asp" --><%


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
