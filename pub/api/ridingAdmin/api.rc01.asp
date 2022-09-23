<%
'#############################################
'기권 실격저장
'fn_ridging.asp 참조
'#############################################
	Set db = new clsDBHelper

	'request
	If hasown(oJSONoutput, "KGAME") = "ok" Then '체전여부 A 두번복사여부
		r_kgame= oJSONoutput.KGAME
	End If

	If hasown(oJSONoutput, "RDNO") = "ok" Then '장애물 A 라운드 별 계산에 필요
		r_rdno= oJSONoutput.RDNO
	End If

	If hasown(oJSONoutput, "IDX") = "ok" then
		r_idx= oJSONoutput.IDX
	End If
	If hasown(oJSONoutput, "TIDX") = "ok" then
		r_tidx= oJSONoutput.TIDX
	End If
	If hasown(oJSONoutput, "GBIDX") = "ok" then
		r_gbidx= oJSONoutput.GBIDX
	End If



'	'독립적으로 지점수, 최고점수, 심판장서명완료 가 되었는지 확인할수 있게 되어야한다. (gbidx 에서 한개라도 누락이라면 안된거임) 다시적용하록 메시지
	SQL = "select top 1 ridingclass , ridingclasshelp  from tblTeamGbInfo  where teamgbidx = '"&r_gbidx&"'   "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arrC = rs.GetRows()
		If IsArray(arrC) Then
				gb_class = arrC(0, 0)
				gb_classhelp = arrC(1, 0)
		End if
	End If
	rs.close


	ptarr = array("0","B","E","M","C","H")
	'예선 결과 WRED 기권시작전, 기권 진행중, 실권, 실격 , 외 최종결과 참가신청 동일 필드 적용)
	tblnm = " SD_tennisMember as a LEFT JOIN sd_tennisMember_partner as b ON a.gamememberidx = b.gamememberidx "
	fldnm = "a.gubun,a.playeridx,a.username,a.key3name,a.tryoutsortno,a.tryoutresult,a.teamAna,b.playeridx,b.username,    score_sgf,score_1,score_2,score_3,score_4,score_5,score_6,score_total ,score_per ,a.pubcode,a.off1,a.off2,vio,a.teamgb "

	SQL = "Select top 1 " & fldnm & " from "&tblnm&" where a.gameMemberIDX = " & r_idx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arrRS = rs.GetRows()
	End If
	rs.close

	If IsArray(arrRS) Then
		p_gubun = arrRS(0, 0)
		p_pidx = arrRS(1, 0)
		p_unm = arrRS(2, 0)
		p_boonm = arrRS(3, 0) '마장마술
		p_sortno = arrRS(4, 0) '출전순서
		p_result = arrRS(5, 0) '예선 결과 WRED 기권시작전, 기권 진행중, 실권, 실격 , 외 최종결과 참가신청 동일 필드 적용)
		p_teamnm = arrRS(6, 0) '팀명칭
		p_hidx = arrRS(7, 0) '말인덱스
		p_hnm = arrRS(8, 0) '말이름

		p_sgf = arrRS(9, 0) '과목:종합;과목:종합;
		p_s1 = isNullDefault(arrRS(10, 0),"") '과목 + 종합
		p_s2 = isNullDefault(arrRS(11, 0),"") '과목 + 종합
		p_s3 = isNullDefault(arrRS(12, 0),"") '과목 + 종합
		p_s4 = isNullDefault(arrRS(13, 0),"") '과목 + 종합
		p_s5 = isNullDefault(arrRS(14, 0),"") '과목 + 종합
		p_s6 = isNullDefault(arrRS(15, 0),"") '장애물 B,C 두번째 총합

		p_st = isNullDefault(arrRS(16, 0),"") '지점 총점, 장애물: 소요시간
		p_per = isNullDefault(arrRS(17, 0),"") '퍼, 장애물: 소요시간2 type B, C

		p_pubcode = arrRS(18, 0)
		p_sArr = array("", p_s1,p_s2,p_s3,p_s4,p_s5) 'BEMCH
		p_off1 = arrRS(19, 0)
		p_off2 = arrRS(20, 0)
		p_vio = isNullDefault(arrRS(21, 0),"0")

	
		p_teamgb = arrRS(22,0) '복합마술 20103
	    orderType = GetOrderType(gb_classhelp, p_teamgb, gb_class) '타입 
	End if


'	'독립적으로 지점수, 최고점수, 심판장서명완료 가 되었는지 확인할수 있게 되어야한다. (gbidx 에서 한개라도 누락이라면 안된거임) 다시적용하록 메시지
	SQL = "select top 1 judgecnt,judgemaxpt,judgesignYN,judgeshowYN    ,judgeB,judgeE,judgeM,judgeC,judgeH,bestsc,maxChk,minChk  from tblRGameLevel  where delyn='N' and gametitleidx = '"&r_tidx&"' and Gbidx = '"&r_gbidx&"'  "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arrC = rs.GetRows()
	End If
	rs.close

	If IsArray(arrC) Then
		For ar = LBound(arrC, 2) To UBound(arrC, 2)
			r_judgecnt = arrC(0, ar)
			r_judgemaxpt = arrC(1, ar)
			r_judgesignYN = arrC(2, ar)
			r_judgeshowYN = arrC(3, ar)

			r_B = arrC(4, ar)
			r_E = arrC(5, ar)
			r_M = arrC(6, ar)
			r_C = arrC(7, ar)
			r_H = arrC(8, ar)
			r_BestSC = arrC(9,ar)
			r_maxChk = arrC(10,ar)
			r_minChk = arrC(11,ar)




			If p_teamgb = "20101" Or ( p_teamgb = "20103" And orderType = "MM")  Then '제한조건 마장마술,복합마술(마장)


				If CDbl(r_judgecnt) = 0 Or CDbl(r_judgemaxpt) = 0  Then '심사지점수가 없거나 최대값이 없을때
					Call oJSONoutput.Set("result", "21" ) '수정시 세부종목 변경 불가
					strjson = JSON.stringify(oJSONoutput)
					Response.Write strjson
					Response.write "`##`"
					Set rs = Nothing
					db.Dispose
					Set db = Nothing
					Response.End
				Exit for
				Else
					widthper = fix(100 / r_judgecnt) '박스 넓이 구하기				
				End If

			End if
		Next
	End if



	If  orderType <> "MM" Then '장애물, 복합마술(장애물)
		If  p_s1 = "" Then
			'입력 중 으로 업데이트 null >> 0 
			SQL = "Update SD_tennisMember Set score_1 = 0 where gamememberidx = " & r_idx '입력중체크
			Call db.execSQLRs(SQL , null, ConStr)		
		End If
	End if




  db.Dispose
  Set db = Nothing



If  orderType = "MM" Then '마장마술, 복합마술(마장마술)
%>

				<div class="modal-content">

					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
						<h4>결과입력</h4>
					</div>

					<div class="modal-body">
						<div class="form-horizontal">
							<div class="form-group">
								<p class="col-sm-12">총점입력   최고점제외(<%=r_maxChk%>) 최저점제외(<%=r_minChk%>)</p>
								<div class="col-sm-12">

									<%If r_B = "Y" then%>
										<div style="float:left;width:<%=widthper%>%;">B지점<input type="number" id="total_1" class="form-control"  style="text-align:right;" value="<%=p_s1%>"  onkeyup="mx.setViolation('<%=Left(LCase(gb_class),1)%>',<%=r_judgemaxpt%>,<%=r_judgecnt%>,'<%=r_maxChk%>','<%=r_minChk%>','<%=p_teamgb%>')"  onmouseup="mx.setViolation('<%=Left(LCase(gb_class),1)%>',<%=r_judgemaxpt%>,<%=r_judgecnt%>,'<%=r_maxChk%>','<%=r_minChk%>','<%=p_teamgb%>')"/></div>
									<%End if%>

									<%If r_E = "Y" then%>
										<div style="float:left;width:<%=widthper%>%;">E점<input type="number" id="total_2" class="form-control"  style="text-align:right;" value="<%=p_s2%>" onkeyup="mx.setViolation('<%=Left(LCase(gb_class),1)%>',<%=r_judgemaxpt%>,<%=r_judgecnt%>,'<%=r_maxChk%>','<%=r_minChk%>','<%=p_teamgb%>')"  onmouseup="mx.setViolation('<%=Left(LCase(gb_class),1)%>',<%=r_judgemaxpt%>,<%=r_judgecnt%>,'<%=r_maxChk%>','<%=r_minChk%>','<%=p_teamgb%>')"/></div>
									<%End if%>

									<%If r_M = "Y" then%>
										<div style="float:left;width:<%=widthper%>%;">M지점<input type="number" id="total_3" class="form-control" style="text-align:right;" value="<%=p_s3%>" onkeyup="mx.setViolation('<%=Left(LCase(gb_class),1)%>',<%=r_judgemaxpt%>,<%=r_judgecnt%>,'<%=r_maxChk%>','<%=r_minChk%>','<%=p_teamgb%>')"  onmouseup="mx.setViolation('<%=Left(LCase(gb_class),1)%>',<%=r_judgemaxpt%>,<%=r_judgecnt%>,'<%=r_maxChk%>','<%=r_minChk%>','<%=p_teamgb%>')"/></div>
									<%End if%>

									<%If r_C = "Y" then%>
										<div style="float:left;width:<%=widthper%>%;">C지점<input type="number" id="total_4" class="form-control" style="text-align:right;" value="<%=p_s4%>" onkeyup="mx.setViolation('<%=Left(LCase(gb_class),1)%>',<%=r_judgemaxpt%>,<%=r_judgecnt%>,'<%=r_maxChk%>','<%=r_minChk%>','<%=p_teamgb%>')"  onmouseup="mx.setViolation('<%=Left(LCase(gb_class),1)%>',<%=r_judgemaxpt%>,<%=r_judgecnt%>,'<%=r_maxChk%>','<%=r_minChk%>','<%=p_teamgb%>')"/></div>
									<%End if%>

									<%If r_H = "Y" then%>
										<div style="float:left;width:<%=widthper%>%;">H지점<input type="number" id="total_5" class="form-control" style="text-align:right;" value="<%=p_s5%>" onkeyup="mx.setViolation('<%=Left(LCase(gb_class),1)%>',<%=r_judgemaxpt%>,<%=r_judgecnt%>,'<%=r_maxChk%>','<%=r_minChk%>','<%=p_teamgb%>')"  onmouseup="mx.setViolation('<%=Left(LCase(gb_class),1)%>',<%=r_judgemaxpt%>,<%=r_judgecnt%>,'<%=r_maxChk%>','<%=r_minChk%>','<%=p_teamgb%>')"/></div>
									<%End if%>

								</div>
							</div>
							<hr />
							<div class="row">
								<div class="col-sm-12">

						<table class="table">
							<tr>
								<th style="padding-top:12px;">감점사항</th><td> <input type="number" id= "off1" class="form-control" value="<%=p_off1%>" onkeyup="mx.setViolation('<%=Left(LCase(gb_class),1)%>',<%=r_judgemaxpt%>,<%=r_judgecnt%>,'<%=r_maxChk%>','<%=r_minChk%>','<%=p_teamgb%>')"  onmouseup="mx.setViolation('<%=Left(LCase(gb_class),1)%>',<%=r_judgemaxpt%>,<%=r_judgecnt%>,'<%=r_maxChk%>','<%=r_minChk%>','<%=p_teamgb%>')"/></td>
								<td>점</td><td></td>
							</tr>
							<tr>
								<th  style="padding-top:12px;">경로위반</th><td> <input type="number" id="off2" class="form-control" value="<%=p_off2%>"  onkeyup="mx.setViolation('<%=Left(LCase(gb_class),1)%>',<%=r_judgemaxpt%>,<%=r_judgecnt%>,'<%=r_maxChk%>','<%=r_minChk%>','<%=p_teamgb%>')"  onmouseup="mx.setViolation('<%=Left(LCase(gb_class),1)%>',<%=r_judgemaxpt%>,<%=r_judgecnt%>,'<%=r_maxChk%>','<%=r_minChk%>','<%=p_teamgb%>')"/></td>
								<td>회</td><td>
								<span id="vio_rt">
									<%
									Select Case p_vio
									Case "","0" : 
									Case "200" : Response.write "실권(E)"
									Case else : Response.write "-" & p_vio & "%"
									End Select 
									%>								
								</span></td>
							</tr>
							<tr>
								<th  style="padding-top:12px;">총 비율</th><td><input type="number" id="pertotal" class="form-control"  value="<%=FormatNumber(p_per,3)%>" readonly/></td>
								<td>%</td><td></td>
							</tr>
						</table>





								</div>
							</div>
						</div>
					</div>


					<div class="modal-footer">
						<a  href="javascript:mx.inputRecordMM(<%=r_idx%>,<%=r_tidx%>,<%=r_gbidx%>,<%=p_pubcode%>, '<%=Left(LCase(gb_class),1)%>',<%=r_judgemaxpt%>,<%=r_judgecnt%>,'<%=r_maxChk%>','<%=r_minChk%>','<%=p_teamgb%>')" class="btn btn-primary">확인</a>
					</div>

				</div>
<%End If%>








<%If  orderType <> "MM" Then '장애물, 복합마술(장애물)%>
				<%Select Case gb_classhelp%>
				<%Case CONST_TYPEA1 , CONST_TYPEA2 , CONST_TYPEA_1 'type A%>

					<div class="modal-content">
						<div class="modal-header">
							<%If p_s1 = "" then%>
							<button type="button" class="close"  onmousedown="mx.setScState(<%=r_idx%>,<%=r_tidx%>,<%=r_gbidx%>,1)">×</button>
							<%else%>
							<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
							<%End if%>
							<h4>기록입력 (장애물 <%=gb_classhelp%>)</h4>
						</div>
						<div class="modal-body">
							<table class="table">
								<thead>
									<tr>
										<th>소요시간</th><th>시간감점</th><th>장애감점</th><th>감점합계</th>
									</tr>
								</thead>
								<tbdoy>
									<tr>
										<td><input type="number" id="j_gametime"  value="<%=p_s1%>" placeholder="00.000" class="form-control" onkeyup="mx.setDotAuto('j_gametime')" /></td>
										<td><input type="number" id="j_pt1" value="<%=p_s2%>"  placeholder="0" class="form-control" onkeyup="mx.jptSum()"   onmouseup="mx.jptSum()"/></td>
										<td><input type="number" id="j_pt2" value="<%=p_s3%>"  placeholder="0" class="form-control" onkeyup="mx.jptSum()"  onmouseup="mx.jptSum()"/></td>
										<td><input type="number" id="j_pttotal" class="form-control" value = "<%=p_st%>" readonly/></td>
									</tr>
								</tbdoy>
							</table>
						</div>
						<div class="modal-footer">
							
							<%If gb_classhelp = CONST_TYPEA_1 Then '최적시간.........%>

								<%If CStr(p_st) = "0" then%>
								<a href="javascript:mx.inputRecordJokA_1(<%=r_idx%>,<%=r_tidx%>,<%=r_gbidx%>,<%=p_pubcode%>,<%=r_rdno%>,'<%=r_kgame%>',<%=r_BestSC%>)" class="btn btn-primary">점수기록</a>
								<%else%>
								<a href="javascript:if (confirm('입력된 점수가 변경됩니다.\n 저장하시겠습니까?') == true) {mx.inputRecordJokA_1(<%=r_idx%>,<%=r_tidx%>,<%=r_gbidx%>,<%=p_pubcode%>,<%=r_rdno%>,'<%=r_kgame%>',<%=r_BestSC%>)}" class="btn btn-primary">입력수정</a>
								<%End if%>


							<%else%>
								<%If CStr(p_st) = "0" then%>
								<a href="javascript:mx.inputRecordJok(<%=r_idx%>,<%=r_tidx%>,<%=r_gbidx%>,<%=p_pubcode%>,<%=r_rdno%>,'<%=r_kgame%>')" class="btn btn-primary">점수기록</a>
								<%else%>
								<a href="javascript:if (confirm('입력된 점수가 변경됩니다.\n 저장하시겠습니까?') == true) {mx.inputRecordJok(<%=r_idx%>,<%=r_tidx%>,<%=r_gbidx%>,<%=p_pubcode%>,<%=r_rdno%>,'<%=r_kgame%>')}" class="btn btn-primary">입력수정</a>
								<%End if%>
							<%End if%>


						</div>
					</div>

				<%Case CONST_TYPEB 'type B%>
					<div class="modal-content" style="width:800px;">
						<div class="modal-header">
							<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
							<h4>기록입력(장애물 - 2phase)</h4>
						</div>
						<div class="modal-body">
							<table class="table">
								<thead>
									<tr><th colspan="4">1단계</th><th colspan="4">2단계</th></tr>
									<tr><th>소요시간</th><th>시간감점</th><th>장애감점</th><th>감점합계</th><th>소요시간</th><th>시간감점</th><th>장애감점</th><th>감점합계</th></tr>
								</thead>
								<tbdoy>
									<tr>
										<!-- 1단계 -->
										<tr>
											<td><input type="number" id="j_gametime"  placeholder="0.000"  class="form-control" value="<%=p_s1%>"  onkeyup="mx.setDotAuto('j_gametime')"/></td>
											<td><input type="number" id="j_pt1" placeholder="0" class="form-control" value="<%=p_s2%>" onkeyup="mx.jptSum()" onmouseup="mx.jptSum()"/></td>
											<td><input type="number" id="j_pt2" placeholder="0" class="form-control" value="<%=p_s3%>" onkeyup="mx.jptSum()" onmouseup="mx.jptSum()"/></td>
											<td><input type="number" id="j_pttotal" class="form-control" value = "<%=p_st%>" readonly/></td>


										<!-- 2단계 -->
											<td><input type="number" id="j2_gametime"  placeholder="0.000" class="form-control" value="<%=p_s4%>"   onkeyup="mx.setDotAuto('j2_gametime')"/></td>
											<td><input type="number" id="j2_pt1" placeholder="0" class="form-control" value="<%=p_s5%>" onkeyup="mx.jptSum2()"/></td>
											<td><input type="number" id="j2_pt2" placeholder="0" class="form-control" value="<%=p_s6%>"  onkeyup="mx.jptSum2()"/></td>
											<td><input type="number" id="j2_pttotal" class="form-control" value = "<%=p_per%>" readonly/></td>
									</tr>
								</tbdoy>
							</table>
						</div>
						<div class="modal-footer">
							<%If CStr(p_st) = "0" then%>
							<a href="javascript:mx.inputRecordJok2(<%=r_idx%>,<%=r_tidx%>,<%=r_gbidx%>,<%=p_pubcode%>)" class="btn btn-primary">입력</a>
							<%else%>
							<a href="javascript:if (confirm('입력된 점수가 변경됩니다.\n 저장하시겠습니까?') == true) {mx.inputRecordJok2(<%=r_idx%>,<%=r_tidx%>,<%=r_gbidx%>,<%=p_pubcode%>)}" class="btn btn-primary">입력수정</a>
							<%End if%>
						</div>
					</div>
				<%Case CONST_TYPEC 'type C%>
					<div class="modal-content">
						<div class="modal-header">
							<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
							<h4>기록입력(장애물 - Table C)</h4>
						</div>
						<div class="modal-body">
							<table class="table">
								<thead>
									<tr>
										<th>소요시간</th><th>벌초</th><th>총소요시간</th>
									</tr>
								</thead>
								<tbdoy>
									<tr>
										<td><input type="number" id="j_pt1" placeholder="0" value="<%=p_s1%>" class="form-control" onkeyup="mx.jptSum()" onmouseup="mx.jptSum()"/></td>
										<td><input type="number" id="j_pt2" placeholder="0" value="<%=p_s2%>" class="form-control" onkeyup="mx.jptSum()" onmouseup="mx.jptSum()"/></td>
										<td><input type="number" id="j_pttotal" class="form-control" value = "<%=p_st%>" readonly/></td>
									</tr>
								</tbdoy>
							</table>
						</div>
						<div class="modal-footer">
							<%If CStr(p_st) = "0" then%>
							<a href="javascript:mx.inputRecordJok3(<%=r_idx%>,<%=r_tidx%>,<%=r_gbidx%>,<%=p_pubcode%>)" class="btn btn-primary">입력</a>
							<%else%>
							<a href="javascript:if (confirm('입력된 점수가 변경됩니다.\n 저장하시겠습니까?') == true) {mx.inputRecordJok3(<%=r_idx%>,<%=r_tidx%>,<%=r_gbidx%>,<%=p_pubcode%>)}" class="btn btn-primary">입력수정</a>
							<%End if%>
						</div>
					</div>
				<%End Select%>

<%End if%>
