<%
'#############################################
' 심판수정 모달창
'#############################################
	'request
	tidx = oJSONoutput.Get("TIDX")
	lidx = oJSONoutput.Get("LIDX")
	midx = oJSONoutput.Get("MIDX")
	CDA = "E2" '다이빙


	Set db = new clsDBHelper


		'기본정보 호출
		booinfo = getBooInfo(lidx, db, ConStr, CDA)

		grouplevelidx = booinfo(0) 
		RoundCnt =  booinfo(1)
		judgeCnt =  booinfo(2)
		lidxs = booinfo(3)
		cdc = booinfo(4)

		'예외처리
		Call judgeExceptionEnd(tidx,judgeCnt,RoundCnt,lidxs,chkpass , db, ConStr, CDA) '체점여부


		'라운드 + 설정된 난이율정보
		fld = "a.idx,a.gameround, isnull(a.gamecodeseq,0),   b.CDA,b.cdc,b.code1,b.code2,b.code3,b.code4,b.codename,b.title as cdcnm"
		SQL = "select "&fld&" from sd_gameMember_roundRecord as a left join tblGameCode as b on a.gamecodeseq = b.seq where    midx =  " & midx
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.EOF Then
			arrR = rs.GetRows()
		End If

		'난의율 코드 정보
		strSql = "SELECT SEQ,CDA,CDC,title,CODE1,CODE2,CODE3,CODE4,codename   FROM tblGameCode  WHERE delyn = 'N' and CDA = 'E2'  and CDC = '"&cdc&"'"
		Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)		
		If Not rs.EOF Then
			arrC = rs.GetRows()
		End If
%>


<div class="modal-dialog">
	<div class="modal-content">
		<div class="modal-header game-ctr">
		  <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="mx.getGameList('game_<%=lidx%>',<%=lidx%>,'am','')">×</button>
		  <h4 class="modal-title" id="myModalLabel"><span>난이율등록</span></h4>
		</div>
		<%'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'%>

		<div class="modal-body">




			<div class="row">
				<div class="col-md-6" style="width:95%;padding-left:20px;padding-right:0px;text-align:left;">
					  <div  style="margin-bottom: 0px;">

									  <table  class="table table-bordered table-hover" style="margin:0px;">

											<thead class="color-palette">
													<tr>
														<td width="60px;">
															<select id="cd_rndno"  style="width:100%;height:34px;">
																<%
																If IsArray(arrR) Then 
																For ari = LBound(arrR, 2) To UBound(arrR, 2)
																%><option value="<%=ari+1%>"><%=ari+1%></option><%
																next
																end if																
																%>
															</select>
														</td>
														<td>
															<input type="text" class="form-control" onkeyup="mx.searchGameCode(<%=midx%>,'<%=CDC%>',$('#cd_rndno').val(), $(this).val())">

															<div id="searchcodelist" style="width:100%;height:200px;overflow:auto;display:none;">
														
															</div>
														</td>
													</tr>
												</thead>
											
											<tbody  class="gametitle">
													<%
														If IsArray(arrR) Then 
														lastno = UBound(arrR, 2)
															For ari = LBound(arrR, 2) To UBound(arrR, 2)
																	j_idx = arrR(0,ari)
																	j_round = arrR(1, ari)
																	j_gamecodeseq = arrR(2, ari)
																	%>
																	<tr <%If j_gamecodeseq <> "0" then%>style="background:#A6B3C1"<%End if%>>
																		<td  style="text-align: center;"><%=j_round%></td>
																		<td  style="text-align:left;padding-left:5px;">


																					<%
																						If IsArray(arrC) Then 
																							For c = LBound(arrC, 2) To UBound(arrC, 2)
																								r_idx = arrC(0, c)
																								r_cda = arrC(1, c)
																								r_cdc = arrC(2, c)
																								r_title = arrC(3, c)
																								r_code1 = arrC(4, c) '다이브번호
																								r_code2 = arrC(5, c) '다이브높이
																								r_code3 = arrC(6, c) '자세
																								r_code4 = arrC(7, c) '난이율
																								r_codename = arrC(8,c)
																								%>
																								<%If Cstr(j_gamecodeseq) = Cstr(r_idx) then%>
																								<%'=r_title%>[ 번호:<%=r_code1%> ]&nbsp;자세:<%=r_code3%>&nbsp;높이 &nbsp;<%=r_code2%>(<%=r_codename%>)&nbsp;난이율:<%=r_code4%>
																								<%end if%>
																								<%
																							Next
																						End If
																					%>


																		</td>
															

																	</tr>
																	<%
																	'End If
																	
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
