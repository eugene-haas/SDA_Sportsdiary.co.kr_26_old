<%
'#############################################
'기권 실격저장
'fn_ridging.asp 참조
'#############################################
	Set db = new clsDBHelper

	'request
	If hasown(oJSONoutput, "IDX") = "ok" then
		r_idx= oJSONoutput.IDX
	End If
	If hasown(oJSONoutput, "TIDX") = "ok" then
		r_tidx= oJSONoutput.TIDX
	End If
	If hasown(oJSONoutput, "GBIDX") = "ok" then
		r_gbidx= oJSONoutput.GBIDX
	End If

	If hasown(oJSONoutput, "PTLOC") = "ok" then
		r_ptloc= oJSONoutput.PTLOC
	End If

'	ptarr = array("0","B","E","M","C","H")
	Select Case CStr(r_ptloc)
	Case "1" : ptstr = "B"
	Case "2" : ptstr = "E"
	Case "3" : ptstr = "M"
	Case "4" : ptstr = "C"
	Case "5" : ptstr = "H"
	End Select 



'아래 폼에서 가져와서 비교하자...
'	SQL = "Select top 1 judgemaxpt from tblRGameLevel where gametitleidx = " & r_tidx & " and delyn = 'N' and gbidx = " & r_gbidx
'	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'	If rs.eof Then
'		judgemaxpt = 0
'	Else
'		judgemaxpt = rs(0)
'	End if


	'예선 결과 WRED 기권시작전, 기권 진행중, 실권, 실격 , 외 최종결과 참가신청 동일 필드 적용)
	tblnm = " SD_tennisMember as a LEFT JOIN sd_tennisMember_partner as b ON a.gamememberidx = b.gamememberidx "
	fldnm = "a.gubun,a.playeridx,a.username,a.key3name,a.tryoutsortno,a.tryoutresult,a.teamAna,b.playeridx,b.username,    score_sgf,score_1,score_2,score_3,score_4,score_5, pubcode "
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

		p_pubcode = arrRS(15, 0)

		p_sArr = array("", p_s1,p_s2,p_s3,p_s4,p_s5)

	
		indata = p_sArr(r_ptloc)

		If indata = "" then 
			indata = 0
		End If
		
		'Response.write p_sgf & "<br>"
		If CDbl(indata) > 0 Then
			p_sgfarr = Split(p_sgf,";")

			If isArray(p_sgfarr) = True Then
				For i = 0 To ubound(p_sgfarr) - 1
					'Response.write p_sgfarr(i) & "<br>"
					onept = Split(p_sgfarr(i),":")
					If CStr(r_ptloc) =  CStr(onept(0)) Then
						nowpt1 = onept(1)
						nowpt2 = onept(2)
					End if
				next
			End if


			indatastr = indata
		Else
			'지점 입력중으로 업데이트 null >> 0 
			SQL = "Update SD_tennisMember Set score_"&r_ptloc&" = 0 where gamememberidx = " & r_idx
			Call db.execSQLRs(SQL , null, ConStr)		
		End If
	End if


  db.Dispose
  Set db = Nothing
%>
				<div class="modal-content">

					<div class="modal-header">
						<%If indatastr = "" then%>
						<button type="button" class="close"  onmousedown="mx.setScState(<%=r_idx%>,<%=r_tidx%>,<%=r_gbidx%>,<%=r_ptloc%>)">×</button>
						<%else%>
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
						<%End if%>

						<h4>기록입력(총점입력)   </h4>
					</div>

					<div class="modal-body">
						<table class="table">
							<tr>
								<th>심판지점</th><td><%=ptstr%></td>
							</tr>
							<tr>
								<th>출전순서</th><td><%=p_sortno%></td>
							</tr>
							<tr>
								<th>소속</th><td><%=p_teamnm%></td>
							</tr>
							<tr>
								<th>선수성명</th><td><%=p_unm%></td>
							</tr>
							<tr>
								<th>말이름</th><td><%=p_hnm%></td>
							</tr>
							<tr>
								<th style="padding-top:12px;">운동과목</th><td> <input type="number" id= "ptnm1" class="form-control" value="<%=nowpt1%>" onchange="mx.ptSum()" onmouseup="mx.ptSum()"/></td>
							</tr>
							<tr>
								<th  style="padding-top:12px;">종합관찰</th><td> <input type="number" id="ptnm2" class="form-control" value="<%=nowpt2%>"  onkeyup="mx.ptSum()"  onmouseup="mx.ptSum()"/></td>
							</tr>
							<tr>
								<th  style="padding-top:12px;">총점</th><td><input type="number" id="pttotal" class="form-control"  value="<%=indatastr%>" readonly/></td>
							</tr>
						</table>

					</div>

					<div class="modal-footer">
						<%If indatastr = "" then%>
						<a href="javascript:mx.inputRecord3(<%=r_idx%>,<%=r_tidx%>,<%=r_gbidx%>,<%=r_ptloc%>,<%=p_pubcode%>,'<%=nowpt2%>')" class="btn btn-primary">결과저장</a>
						<%else%>
						<a href="javascript:if (confirm('입력된 점수가 변경됩니다.\n 저장하시겠습니까?') == true) {mx.inputRecord3(<%=r_idx%>,<%=r_tidx%>,<%=r_gbidx%>,<%=r_ptloc%>,<%=p_pubcode%>,'<%=nowpt2%>')}" class="btn btn-primary">결과수정</a>
						<%End if%>
					</div>

				</div>
