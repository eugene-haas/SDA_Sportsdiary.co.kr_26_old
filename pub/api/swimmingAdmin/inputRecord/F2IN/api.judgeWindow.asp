<%
'#############################################
' 심판배정 모달창
'#############################################
	'request
	tidx = oJSONoutput.Get("TIDX")
	lidx = oJSONoutput.Get("LIDX")
	midx = oJSONoutput.Get("MIDX")
	rno = oJSONoutput.Get("RNO")
	CDA = "F2" '아티스틱

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

	fld = fld & ",username,gbidx,levelno,a.cdb,cdbnm,a.cdc,a.cdcnm,tryoutresult,tryoutorder,tryouttotalorder,itgubun,b.idx,b.gameround,b.judgeendcnt,gamecodeseq,team,teamnm " '1~17
	fld = fld & " ,c.code1,c.code2,c.code3,c.code4,codename ,totalscore  " '16부터 ,c.code5,c.code6,c.code7,c.code8
	fld = fld & " ,b.a_eletotaldeduction,b.a_totaldeduction,b.a_elededuction  "
    'a_eletotaldeduction = 엘리먼트총점에서 감점
		'a_totaldeduction = 아티스틱 총점에서 감점
		'a_elededuction  = 각엘리먼트에서 감점	


	SQL = "select "&fld&"  from sd_gameMember as a inner join sd_gameMember_roundRecord as b on a.gameMemberIDX = b.midx and a.gameMemberIDX = '"&midx&"' " 
	SQL = SQL &  " left join tblGameCode as c On b.gamecodeseq = c.seq and c.CDA = 'F2' order by  gameround asc "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.EOF Then
		arrR = rs.GetRows()
	Else

			Call oJSONoutput.Set("result", 111 ) '서버에서 메시지 생성 전달
			Call oJSONoutput.Set("servermsg", "라운드테이블 " & midx & " 생성안됨" ) '서버에서 메시지 생성 전달
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
													<th width="80">난이도<br>번호</th>
													<th width="80">난이도명</th>
													<th width="60">난이도</th>
													<th width="120">이름</th>
													<%
													For r = 1 To judgeCnt
													%>
													<th><%=r%> 심사</th>
													<%
													Next
													%>
													<%If cdc = "04" Or cdc = "06" Or cdc = "12" Then '테크 %>
													<th>ELE감점</th>
													<%End if%>
													<th width="100">비고</th>
													<th width="100">힙계</th>
												</tr>
											</thead>





											<tbody  class="gametitle">

											<%
											Dim jumsu_arr(16)
											
											If cdc = "04" Or cdc = "06" Or cdc = "12" Then '테크 
												partno = judgeCnt / 3
											End if


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

														j_cdc = arrR(thisno + 6,ari) '상세종목코드

														j_itgubun = arrR(thisno + 11,ari) 
														j_team = arrR(thisno + 16,ari) 
														j_teamnm = arrR(thisno + 17,ari) 

														bigo = ""


														j_code1 = arrR(thisno + 18,ari)
														j_code2 = arrR(thisno + 19,ari)
														j_code3 = arrR(thisno + 20,ari)
														j_code4 = arrR(thisno + 21,ari)
														j_codename = arrR(thisno + 22,ari)
														j_totalscore = arrR(thisno + 23,ari)

														a_eletotaldeduction = arrR(thisno + 24,ari) '엘리먼트총점에서 감점
														a_totaldeduction = arrR(thisno + 25,ari)	'아티스틱 총점에서 감점
														a_elededuction  = arrR(thisno + 26,ari) '각엘리먼트에서 감점	

														'라운드 총점
														j_totalscore = j_totalscore/10000    '소수점 4자리

											
														roundtype = ""
														Select Case j_cdc
														Case "01","02","03" '피겨 :솔로(Solo) 4:1
															Select Case CDbl(j_roundno)
															Case 1,2,3,4
															roundtext = "피겨" & j_roundno
															roundtype = "피겨"
															Case 5
															roundtext = "프리" 
															End Select 

														Case "04","06","12"  '테크니컬 1 : 1
															Select Case CDbl(j_roundno)
															Case 1,2,3,4,5
															roundtext = "E" & j_roundno
															Case 6
															roundtext = "프리"
															End Select 
														Case "05","07","11" '프리 : 1
															roundtext = "프리"
														End Select 
											
											%>

														<%If (j_cdc = "02" Or j_cdc = "03") And CDbl(j_roundno) < 5 Then '피겨단체%>
															<!--그리지 않는다 -->
														<%else%>

														
														<tr>
															<td><%=roundtext%></td>
															<td><%=j_code1%></td>
															<td ><%=j_code2%></td>

															<%Select Case roundtext%>
															<%Case   "피겨1","피겨2","피겨3","피겨4" %>
																<td ><%=j_code4%></td><%'난이도%>
															<%Case   "E1","E2","E3","E4","E5" %>
																<td ><%=j_code4%></td><%'난이도%><!--<br><%=j_code5%><br><%=j_code6%><br><%=j_code7%><br><%=j_code8%>-->
															<%Case   "프리" %>
																<td >-</td><%'난이도%>
															<%End Select%>

															<td ><%If j_itgubun = "T" then%><%=j_teamnm%><%else%><%=j_name%><%End if%></td>
															<% '심판그리는 영역
															refnm = 2
															For j = 1 To judgeCnt 
		
																'소수점찍어서 가져오기
																jumsu = jumsu_arr(j)/10
															%>
															<td rowspan="2" style="padding:1px;">
																<%If roundtype = "피겨" And j > 7 then%>
																	<%If roundtype = "피겨" And j = 8 then%>
																	<a href="javascript:mx.setRoundZeroAvg(<%=tidx%>,<%=lidx%>,<%=midx%>,<%=j_roundno%>)" class="btn btn-default">0점<br>평균</a>
																	<%end if%>
																<%else%>

																<%Select Case roundtext%>
																<%Case   "E2","E3","E4","E5" '엘리먼트 열이라면%>																

																	<%If j > partno * 2 then%>
																	<input class="form-control" type="text" id="jj_<%=j_roundno%>_<%=j%>_<%=midx%>" onkeyup="this.value=this.value.replace(/[^\b0-9]/g,'');mx.setValueCheckE2(this)"  maxlength="4"  value="<%=jumsu%>">
																	<a href="javascript:mx.setRoundValue(<%=tidx%>, <%=lidx%>,<%=midx%>,<%=j_roundno%>,'<%=cdc%>',<%=j%>,$('#jj_<%=j_roundno%>_<%=j%>_<%=midx%>').val())" class="btn btn-success" style="width:100%;"><i class="fa fa-fw fa-edit"></i><%=arrR(refnm,ari)%></a>
																	<%End if%>

																<%Case else%>

																	<input class="form-control" type="text" id="jj_<%=j_roundno%>_<%=j%>_<%=midx%>" onkeyup="this.value=this.value.replace(/[^\b0-9]/g,'');mx.setValueCheckE2(this)"  maxlength="4"  value="<%=jumsu%>">
																	<a href="javascript:mx.setRoundValue(<%=tidx%>, <%=lidx%>,<%=midx%>,<%=j_roundno%>,'<%=cdc%>',<%=j%>,$('#jj_<%=j_roundno%>_<%=j%>_<%=midx%>').val())" class="btn btn-success" style="width:100%;"><i class="fa fa-fw fa-edit"></i><%=arrR(refnm,ari)%></a>

																<%End Select%>


																<%End if%>
															</td>
															<%
																refnm = refnm + 4
															next%>

															<%If (cdc = "04" Or cdc = "06" Or cdc = "12")  Then '테크 일리먼트별 개별 0.5씩 감점%>
																<%If  j_roundno < 6  then%>
																	<%if a_elededuction = "5" then%>
																	<td rowspan="2" style="padding:2px;"><a href="javascript:mx.setEleDeduction(<%=tidx%>,<%=lidx%>,<%=midx%>,<%=j_roundno%>,'danger')" class="btn btn-danger">감점</a></td>
																	<%else%>
																	<td rowspan="2" style="padding:2px;"><a href="javascript:mx.setEleDeduction(<%=tidx%>,<%=lidx%>,<%=midx%>,<%=j_roundno%>,'default')" class="btn btn-default">감점</a></td>																	
																	<%end if%>
																<%else%>
																	<td>&nbsp;</td>
																<%End if%>
															<%End if%>


															<td rowspan="2" style="color:red;vertical-align:middle;text-align:center;"><%=bigo%></td>
															<%Select Case roundtext%>
															<%Case   "E2","E3","E4","E5" %>	
															<td rowspan="2" style="vertical-align:middle;text-align:center;">&nbsp;</td>
															<%Case else%>
															<td rowspan="2" style="vertical-align:middle;text-align:center;"><%=j_totalscore%></td>
															<%End select%>
														</tr>
														<tr>
															<td colspan="5" style="text-align:center;background:#CFCFCF"><b><%=j_codename%></b></td>
														</tr>
														<%End if%>
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
