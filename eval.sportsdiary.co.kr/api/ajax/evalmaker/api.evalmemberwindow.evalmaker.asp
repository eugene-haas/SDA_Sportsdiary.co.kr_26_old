<%
'#############################################
' 모달창
'#############################################
	'request
	tableidx = oJSONoutput.Get("TIDX")
	itemidx = oJSONoutput.Get("IIDX")
	regyear = oJSONoutput.Get("RY")

	Set db = new clsDBHelper

		'tblEvalItemType 에 정성이 들어가있는지 체크한다.
		fld = " adminmemberidx,userid,adminname,'평가위원' "
		SQL = " Select evalitemtypeidx from tblEvalItemType  where delkey = 0 and evalitemidx = " & itemidx 
		' response.write SQL
		' response.end
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		
		if rs.eof then
		Call oJSONoutput.Set("result", 111 )
		Call oJSONoutput.Set("servermsg", "정성체크항목을 먼저 작성해주십시오." ) '중복
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.End	
		else
			itemtypeidx = rs(0)
		end if		



		'등록대상 평가위원
		fld = " adminmemberidx,userid,adminname,'평가위원' "
		SQL = " Select "&fld&" from tblAdminMember where delyn = 'N' and SiteCode = '"&SiteCode&"' and Authority = 'C' " 
		SQL = SQL & " and adminmemberidx not in (Select adminmemberidx from tblEvalMember where delkey = 0 and EvalItemIDX = " & itemidx &") "
		

		'response.write SQL
		'response.end
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If Not rs.EOF Then
		arrR = rs.GetRows()
		End If





		'등록된 평가위원
		fld = "EvalMemberIDX,EvalTableIDX,AdminMemberIDX,userid,adminname,evalitemidx,evalitemtypeidx"
		SQL = " Select "&fld&" from tblEvalMember  where delkey = 0 and evalitemtypeidx = " & itemtypeidx
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		
'Response.write sql

		If Not rs.EOF Then
		arrJ = rs.GetRows()
		End If
%>


<div class="modal-dialog modal-xl">
	<div class="modal-content">
		<div class="modal-header game-ctr">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		<h4 class="modal-title" id="myModalLabel"><span>평가자등록</span></h4>
		</div>
		<%'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'%>

		<div class="modal-body">




			<div class="row">
				<div class="col-md-6" style="width:48%;padding-left:20px;padding-right:0px;text-align:left;">
					<div class="form-group">

								<div  style="margin-bottom: 0px;">
										<table  class="table table-bordered table-hover" style="margin:0px;">

											<thead class="bg-light-blue-active color-palette">
													<tr>
														<th width="20%">아이디</th>
														<th width="30%">이름</th>
														<th width="30%">권한</th>
														<th width="20%">등록</th>

													</tr>
												</thead>
										</table>
								</div>

								<div id="jfindarea">
										<div id="Modaltestbody" >
										<div class="box-body" style="overflow-x:hidden;" id="memberarea">

													<table  class="table table-bordered table-hover" >
															<tbody   class="gametitle">
																	<%
																		If IsArray(arrR) Then 
																		lastno = UBound(arrR, 2)
																			For ari = LBound(arrR, 2) To UBound(arrR, 2)
																					j_seq = arrR(0, ari)
																					j_id = arrR(1, ari)
																					j_name = arrR(2, ari)
																					j_Authority = arrR(3, ari)
																			%>
																					<tr id="jftr_<%=j_seq%>">
																						<td width="20%" style="text-align: center;"><%=j_id%></td>
																						<td width="30%" style="text-align: center;"><%=j_name%></td>
																						<td width="30%" style="text-align: center;"><%=j_Authority%></td>
																						<td width="20%" style="text-align:right"><a href="javascript:mx.setMember(<%=j_seq%>,<%=tableidx%>,<%=itemidx%>,<%=itemtypeidx%>,<%=regyear%>);" class="btn btn-danger">등록</a></td>
																					</tr>
																			<%
																			next
																		End if		
																	%>
															</tbody>
													</table>

										</div>
										</div>

								</div>

						</div>
				</div>

				<div class="col-md-6" style="width:48%;padding-left:20px;padding-right:0px;text-align:left;">
						<div  style="margin-bottom: 0px;">

										<table  class="table table-bordered table-hover" style="margin:0px;">
											<thead class="bg-light-blue-active color-palette">
													<tr>
														<th width="20%">아이디</th>
														<th width="30%">이름</th>
														<th width="30%">권한</th>
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
														If IsArray(arrJ) Then 
														lastno = UBound(arrJ, 2)
															For ari = LBound(arrJ, 2) To UBound(arrJ, 2)
																	j_seq = arrJ(0, ari)
																	j_id = arrJ(3, ari)
																	j_name = arrJ(4, ari)
																	j_Authorityteamnm = "평가위원"
																	j_itemidx = arrJ(5,ari)
													%>
																	<tr id="setjftr_<%=j_seq%>">
																		<td width="20%" style="text-align: center;"><%=j_id%></td>
																		<td width="30%" style="text-align: center;"><%=j_name%></td>
																		<td width="30%" style="text-align: center;"><%=j_Authorityteamnm%></td>
																		<td width="20%" style="text-align:right"><a href="javascript:mx.delMember(<%=j_seq%>,<%=j_itemidx%>)" class="btn btn-danger">삭제</a></td>

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
