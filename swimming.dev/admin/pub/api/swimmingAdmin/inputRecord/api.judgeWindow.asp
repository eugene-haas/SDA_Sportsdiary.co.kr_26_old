<%
'#############################################
' 심판배정 모달창
'#############################################
	'request
	tidx = oJSONoutput.Get("TIDX")
	lidx = oJSONoutput.Get("LIDX")
	midx = oJSONoutput.Get("MIDX")
	rno = oJSONoutput.Get("RNO")
	cda = "E2"

	Set db = new clsDBHelper

	'기본정보 호출
	booinfo = getBooInfo(lidx, db, ConStr, CDA)
	grouplevelidx = booinfo(0) 
	RoundCnt =  booinfo(1)
	judgeCnt =  booinfo(2)
	lidxs = booinfo(3)
	cdc = booinfo(4)
	


	fld = " playeridx"
	For j = 1 To judgeCnt
		fld = fld & "," & " jumsu"&j&",name"&j&",jidx"&j&",jteam"&j&" "
	Next
	
	'여기필드번호는
	thisno = (judgeCnt * 4) 

	fld = fld & ",username,gbidx,levelno,a.cdb,cdbnm,a.cdc,a.cdcnm,tryoutresult,tryoutorder,tryouttotalorder,itgubun,b.idx,b.gameround,b.judgeendcnt,gamecodeseq,r_deduction,r_out "
	fld = fld & " ,c.code1,c.code2,c.code3,c.code4,codename ,totalscore" '16부터


	SQL = "select "&fld&"  from sd_gameMember as a inner join sd_gameMember_roundRecord as b on a.gameMemberIDX = b.midx and a.gameMemberIDX = '"&midx&"' " 
	SQL = SQL &  " left join tblGameCode as c On b.gamecodeseq = c.seq and c.CDA = 'E2' order by  gameround asc "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.EOF Then
		arrR = rs.GetRows()
	Else

			Call oJSONoutput.Set("result", 111 ) '서버에서 메시지 생성 전달
			Call oJSONoutput.Set("servermsg", "선수가 없다" ) '서버에서 메시지 생성 전달
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.End
					
	End If
%>


<div class="modal-dialog modal-xl">
	<div class="modal-content">
		<div class="modal-header game-ctr">
		  <button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="mx.getGameList('game_<%=lidx%>',<%=lidx%>,'am','')">×</button>
		  <h4 class="modal-title" id="myModalLabel"><span><%=arrR(thisno + 5,0)%>&nbsp;<%=arrR(thisno + 7,0)%> </span></h4>
		</div>
		
		<%'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'%>
		<input type="hidden" id="modal_MIDX" value="<%=midx%>">
		<input type="hidden" id="modal_RNO" value="<%=rno%>">


		<div class="modal-body">

				<div class="row">
					<div class="col-md-6" style="width:100%;">

								<div  style="margin-bottom: 0px;">
										<table  class="table table-bordered table-hover" style="margin:0px;">
										<thead class="bg-light-blue-active color-palette">
												<tr>
													<th width="80">R</th>
													<th width="80">다이브<br>번호</th>
													<th width="80">높이</th>
													<th width="50">자세</th>
													<th width="60">난이도</th>
													<th width="100">이름</th>
													<%
													refnm = 2
													For r = 1 To judgeCnt
													%>
													<th><%=r%>. <a href="javascript:mx.changeJudge(<%=tidx%>, <%=lidx%>,<%=r%>,<%=arrR(refnm+1,0)%>)" class="btn btn-default"><%=arrR(refnm,0)%></a></th>
													<%
													refnm = refnm + 4
													Next
													%>
													<th width="100">비고</th>
													<th width="100">힙계</th>
												</tr>
											</thead>





											<tbody  class="gametitle">

											<%
											Dim jumsu_arr(16)


											If IsArray(arrR) Then 
												For ari = LBound(arrR, 2) To UBound(arrR, 2)
														j_pidx = arrR(0,ari)

														'각필드점수
														jumsustartno = 1 '필드에서 점수 시작 위치 번호
														For r = 1 To judgeCnt
															jumsu_arr(r) = arrR(jumsustartno,ari)
														
														jumsustartno = jumsustartno + 4
														Next
														
														j_name = arrR(thisno + 1,ari)
														j_roundno = arrR(thisno + 13,ari)

														j_deduction = arrR(thisno + 16,ari) '라운드별 감점
														j_out = arrR(thisno + 17,ari) '라운드별 실격여부

														bigo = ""
														If j_out = "1" Then
															bigo = "실격"
														Else
															If j_deduction = "2" Then
																bigo = "감점"
															End if
														End if

														j_code1 = arrR(thisno + 18,ari)
														j_code2 = arrR(thisno + 19,ari)
														j_code3 = arrR(thisno + 20,ari)
														j_code4 = arrR(thisno + 21,ari)
														j_codename = arrR(thisno + 22,ari)
														j_totalscore = arrR(thisno + 23,ari)


														'라운드 총점
														'소수점찍어서 가져오기
														'j_totalscore = getE2FirstValue(j_totalscore)
														'j_totalscore = getE2Value(j_totalscore) 
														j_totalscore = j_totalscore/100 

											%>
														<tr>
															<td><%=j_roundno%></td>
															<td><%=j_code1%></td>
															<td ><%=j_code3%></td>
															<td ><%=j_code2%></td>
															<td ><%=j_code4%></td>
															<td ><%=j_name%></td>

															<%For j = 1 To judgeCnt
		
																'소수점찍어서 가져오기
																'jumsu = getE2FirstValue(jumsu_arr(j))
																jumsu = jumsu_arr(j)/10
															%>
															<td rowspan="2"  style="padding:2px;">
																<%If bigo = "실격" then%>
																	<input class="form-control" type="text" id="jj_<%=j_roundno%>_<%=j%>_<%=midx%>"  value="<%=jumsu%>" disabled>
																	<button class="btn btn-default" style="width:100%;background:#D9D9D9;"   disabled>수정</button>
																<%else%>
																	<input class="form-control" type="text" id="jj_<%=j_roundno%>_<%=j%>_<%=midx%>" onkeyup="this.value=this.value.replace(/[^\b0-9]/g,'');mx.setValueCheckE2(this)"  maxlength="4"  value="<%=jumsu%>">
																	<a href="javascript:mx.setRoundValue(<%=tidx%>, <%=lidx%>,<%=midx%>,<%=j_roundno%>,<%=j%>,$('#jj_<%=j_roundno%>_<%=j%>_<%=midx%>').val())" class="btn btn-danger" style="width:100%;">수정</a>
																<%End if%>
															</td>
															<%next%>
															<!--<td rowspan="2" style="padding:2px;"><a href="javascript:mx.setRoundZeroAvg(<%=tidx%>,<%=lidx%>,<%=midx%>,<%=j_roundno%>)" class="btn btn-default">0점<br>평균</a></td>-->


															<td rowspan="2" style="color:red;vertical-align:middle;text-align:center;"><%=bigo%></td>
															<td rowspan="2" style="vertical-align:middle;text-align:center;"><%=j_totalscore%></td>
														</tr>
														<tr>
															<td colspan="6" style="text-align:center;background:#CFCFCF"><b><%=j_codename%></b></td>
														</tr>
											<%
												Next
											End if
											%>


											</tbody>
											</table>
								</div>

					</div>
				</div>



			</div>



		<%'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'%>
	</div>
</div>





<%

	Set rs = Nothing
	db.Dispose
	Set db = Nothing
%>
