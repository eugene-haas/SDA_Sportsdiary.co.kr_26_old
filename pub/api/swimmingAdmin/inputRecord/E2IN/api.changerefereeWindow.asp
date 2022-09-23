<%
'#############################################
' 심판수정 모달창
'#############################################
	'request
	tidx = oJSONoutput.Get("TIDX")
	lidx = oJSONoutput.Get("LIDX")
	myfldno = oJSONoutput.Get("MYFLDNO")
	jidx = oJSONoutput.Get("JIDX")
	CDA = "E2" '다이빙

	Set db = new clsDBHelper


		'기본정보 호출
		booinfo = getBooInfo(lidx, db, ConStr, CDA)

		grouplevelidx = booinfo(0) 
		RoundCnt =  booinfo(1)
		judgeCnt =  booinfo(2)
		lidxs = booinfo(3)

		'예외처리
		'Call judgeExceptionEnd(tidx,judgeCnt,RoundCnt,lidxs,chkpass , db, ConStr, CDA) '체점여부


		'현재 포함된 심판들 인덱스들
		'select jidx1 from sd_gameMember_roundRecord where tidx = 137 and lidx = 11365
		jidxarr = Split(getBooJudge( tidx, lidxs , judgecnt, db,  ConStr),",")
		


	  fld = " seq,name,team,teamnm,setcnt,jseq "
	  SQL = " Select "&fld&" from sd_gameTitle_judge  where tidx = "&tidx&" and cda = '"&CDA&"'   "
	  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	  If Not rs.EOF Then
			arrR = rs.GetRows()
	  End If


%>


<div class="modal-dialog">
	<div class="modal-content">
		<div class="modal-header game-ctr">
		  <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		  <h4 class="modal-title" id="myModalLabel"><span>심판변경</span></h4>
		</div>
		<%'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'%>

		<div class="modal-body">




			<div class="row">
				<div class="col-md-6" style="width:95%;padding-left:20px;padding-right:0px;text-align:left;">
					  <div  style="margin-bottom: 0px;">

									  <table  class="table table-bordered table-hover" style="margin:0px;">

											<thead class="bg-light-blue-active color-palette">
													<tr>
														<th width="20%">번호</th>
														<th width="30%">심판명(배치수)</th>
														<th width="30%">소속</th>
														<th width="20%">변경</th>

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
																	j_setcnt = arrR(4,ari)
																	j_jseq = arrR(5,ari)
																	
																	targetfldno = ""
																	trbg = "" '동일 부변경 조건으로 사용 색상도
																	For j = 0 To ubound(jidxarr)
																		If CStr(j_jseq) = CStr(jidxarr(j)) Then
																			trbg = "#A6B3C1"
																			targetfldno = CDbl(j) + 1
																		End if
																	next

																	If CStr(j_jseq) <> CStr(jidx) then
																	%>
																	<tr id="setjftr_<%=j_seq%>" style="background:<%=trbg%>">
																		<td width="20%" style="text-align: center;">
																		<%=j_seq%></td>
																		<td width="30%" style="text-align: center;"><%=j_name%> [<%=j_setcnt%>]</td>
																		<td width="30%" style="text-align: center;"><%=j_teamnm%></td>
																		<td width="20%" style="text-align:right"><a href="javascript:mx.changeJudgeOK(<%=tidx%>,<%=lidx%>,<%=jidx%>,<%=j_jseq%>  ,<%=myfldno%> ,'<%=targetfldno%>')" class="btn btn-danger">변경</a></td>
																	</tr>
																	<%
																	End If
																	
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
