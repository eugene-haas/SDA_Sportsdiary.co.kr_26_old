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
	SQL = "select top 1 tryoutsortNo, from Sd_tennisMember where gameMemberIDX = " & r_idx

	'예선 결과 WRED 기권시작전, 기권 진행중, 실권, 실격 , 외 최종결과 참가신청 동일 필드 적용)
	tblnm = " SD_tennisMember as a LEFT JOIN sd_tennisMember_partner as b ON a.gamememberidx = b.gamememberidx "
	fldnm = "a.gubun,a.playeridx,a.username,a.key3name,a.tryoutsortno,a.tryoutresult,a.teamAna,b.playeridx,b.username,    score_sgf,score_1,score_2,score_3,score_4,score_5,score_6,score_total ,score_per ,a.pubcode"

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
	End if



'	'독립적으로 지점수, 최고점수, 심판장서명완료 가 되었는지 확인할수 있게 되어야한다. (gbidx 에서 한개라도 누락이라면 안된거임) 다시적용하록 메시지
	SQL = "select top 1 judgecnt,judgemaxpt,judgesignYN,judgeshowYN    ,judgeB,judgeE,judgeM,judgeC,judgeH,bestsc       from tblRGameLevel  where gametitleidx = '"&r_tidx&"' and Gbidx = '"&r_gbidx&"'  "
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


			If p_boonm = "마장마술" Then '제한조건
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
				End If
			End if
		Next
	End if



	Select Case p_boonm
	Case "장애물"
		If  p_s1 = "" Then
			'입력 중 으로 업데이트 null >> 0 
			SQL = "Update SD_tennisMember Set score_1 = 0 where gamememberidx = " & r_idx '입력중체크
			Call db.execSQLRs(SQL , null, ConStr)		
		End If
	End Select 



  db.Dispose
  Set db = Nothing


Select Case p_boonm
Case "마장마술"
%>

				<div class="modal-content">

					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
						<h4>결과입력(심판지점 선택)</h4>
					</div>

					<div class="modal-body">
						<div class="form-horizontal">
							<div class="form-group">
								<p class="col-sm-12">심판 지점을 선택해주세요</p>
								<div class="col-sm-12">
									
									<%
									'###################
									'입력된 값이있는 경우 지점변경이 되면 안된다.
									'###################									
									%>

										<%If r_B = "Y" then%>
										<%Select Case CStr(p_sArr(1))%>
										<%Case "" '입력전%>
										<input type="radio" name="point" id="point_1" value="1"/><label for="point_1" class="control-label mgl8 mgr20 text-primary"> B 지점</label>
										<%Case "0" '입력진행중%>
										<input type="radio" name="point" id="point_1" value="1"/><label for="point_1" class="control-label mgl8 mgr20 text-danger"> B 지점</label>
										<%Case Else '입력완료%>
										<input type="radio" name="point" id="point_1" value="1" /><label for="point_1" class="control-label mgl8 mgr20 text-success"> B 지점</label>
										<%End Select %>
										<%End if%>

										<%If r_E = "Y" then%>
										<%Select Case CStr(p_sArr(2))%>
										<%Case "" '입력전%>
										<input type="radio" name="point" id="point_2" value="2"/><label for="point_2" class="control-label mgl8 mgr20 text-primary"> E 지점</label>
										<%Case "0" '입력진행중%>
										<input type="radio" name="point" id="point_2" value="2"/><label for="point_2" class="control-label mgl8 mgr20 text-danger"> E 지점</label>
										<%Case Else '입력완료%>
										<input type="radio" name="point" id="point_2" value="2" /><label for="point_2" class="control-label mgl8 mgr20 text-success"> E 지점</label>
										<%End Select %>
										<%End if%>

										<%If r_M = "Y" then%>
										<%Select Case CStr(p_sArr(3))%>
										<%Case "" '입력전%>
										<input type="radio" name="point" id="point_3" value="3"/><label for="point_3" class="control-label mgl8 mgr20 text-primary"> M 지점</label>
										<%Case "0" '입력진행중%>
										<input type="radio" name="point" id="point_3" value="3"/><label for="point_3" class="control-label mgl8 mgr20 text-danger"> M 지점</label>
										<%Case Else '입력완료%>
										<input type="radio" name="point" id="point_3" value="3" /><label for="point_3" class="control-label mgl8 mgr20 text-success"> M 지점</label>
										<%End Select %>
										<%End if%>

										<%If r_C = "Y" then%>
										<%Select Case CStr(p_sArr(4))%>
										<%Case "" '입력전%>
										<input type="radio" name="point" id="point_4" value="4"/><label for="point_4" class="control-label mgl8 mgr20 text-primary"> C 지점</label>
										<%Case "0" '입력진행중%>
										<input type="radio" name="point" id="point_4" value="4"/><label for="point_4" class="control-label mgl8 mgr20 text-danger"> C 지점</label>
										<%Case Else '입력완료%>
										<input type="radio" name="point" id="point_4" value="4" /><label for="point_4" class="control-label mgl8 mgr20 text-success"> C 지점</label>
										<%End Select %>
										<%End if%>

										<%If r_H = "Y" then%>
										<%Select Case CStr(p_sArr(5))%>
										<%Case "" '입력전%>
										<input type="radio" name="point" id="point_5" value="5"/><label for="point_5" class="control-label mgl8 mgr20 text-primary"> H 지점</label>
										<%Case "0" '입력진행중%>
										<input type="radio" name="point" id="point_5" value="5"/><label for="point_5" class="control-label mgl8 mgr20 text-danger"> H 지점</label>
										<%Case Else '입력완료%>
										<input type="radio" name="point" id="point_5" value="5" /><label for="point_5" class="control-label mgl8 mgr20 text-success"> H 지점</label>
										<%End Select %>
										<%End if%>



									<%'next%>

								</div>
							</div>
							<hr />
							<div class="row">
								<div class="col-sm-12">
									<span>지점별 입력 상태값 - 텍스트 색 구분</span><br />
									<b class="text-primary">입력전</b> &nbsp;&nbsp; <b class="text-danger">입력진행중</b> &nbsp;&nbsp; <b class="text-success">입력완료</b>
								</div>
							</div>
						</div>
					</div>

					<div class="modal-footer">
						<a  href="javascript:mx.inputRecord2(<%=r_idx%>,<%=r_tidx%>,<%=r_gbidx%>)" class="btn btn-primary">확인</a>
					</div>

				</div>

<%Case "장애물"%>
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


<%End select %>