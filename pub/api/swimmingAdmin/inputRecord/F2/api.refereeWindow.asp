<%
'#############################################
' 심판배정 모달창
'#############################################
	'request
	tidx = oJSONoutput.Get("TIDX")
	cda = oJSONoutput.Get("CDA")
	CDA = "F2" '아티스틱


	Set db = new clsDBHelper

	  fld = " seq,name,team,teamnm "
	  SQL = " Select "&fld&" from sd_gameTitle_judge  where tidx = "&tidx&" and cda = '"&cda&"'  "
	  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	  If Not rs.EOF Then
			arrR = rs.GetRows()
	  End If


%>


<div class="modal-dialog modal-xl">
	<div class="modal-content">
		<div class="modal-header game-ctr">
		  <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		  <h4 class="modal-title" id="myModalLabel"><span>대회 진행 심판 배정</span></h4>
		</div>
		<%'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'%>

		<div class="modal-body">




			<div class="row">
				<div class="col-md-6" style="width:48%;padding-left:20px;padding-right:0px;text-align:left;">
					  <div class="form-group">

						<div class="input-group date">
							<div class="input-group-addon">
							  <i class="fa fa-fw fa-search"></i>
							</div>
							 <input type="text" id="jfind" placeholder="심판명검색" value="" class="form-control" onkeyup="mx.findJudge('<%=cda%>',<%=tidx%>,$(this).val());">
						</div>

						<div id="jfindarea">
							
						</div>

					  </div>
				</div>


				<div class="col-md-6" style="width:48%;padding-left:20px;padding-right:0px;text-align:left;">
					  <div  style="margin-bottom: 0px;">

									  <table  class="table table-bordered table-hover" style="margin:0px;">

											<thead class="bg-light-blue-active color-palette">
													<tr>
														<th width="20%">번호</th>
														<th width="30%">심판명</th>
														<th width="30%">소속</th>
														<th width="20%">삭제</th>

													</tr>
												</thead>
										</table>

						</div>

			
							<div id="Modaltestbody" >
							<div class="box-body" style="overflow-x:hidden;" id="jsetarea">

									  <table  class="table table-bordered table-hover" >
												
											<tbody  class="gametitle">
													<%
														If IsArray(arrR) Then 
														lastno = UBound(arrR, 2)
															For ari = LBound(arrR, 2) To UBound(arrR, 2)
																	j_seq = arrR(0, ari)
																	j_name = arrR(1, ari)
																	j_team = arrR(2, ari)
																	j_teamnm = arrR(3, ari)
													%>
																	<tr id="setjftr_<%=j_seq%>">
																		<td width="20%" style="text-align: center;"><%=j_seq%></td>
																		<td width="30%" style="text-align: center;"><%=j_name%></td>
																		<td width="30%" style="text-align: center;"><%=j_teamnm%></td>
																		<td width="20%" style="text-align:right"><a href="javascript:mx.delJudge('<%=cda%>',<%=tidx%>,<%=j_seq%>)" class="btn btn-danger">삭제</a></td>

																	</tr>
													<%
															next
														End if		
													%>

											</tbody>

							</div>
							</div>




					  </div>
				</div>



			</div>











</div>
</div>
</div>





<%

	Set rs = Nothing
	db.Dispose
	Set db = Nothing
%>
