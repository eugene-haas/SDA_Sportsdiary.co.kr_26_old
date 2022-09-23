<%
'#############################################
'마장마술 결과저장
'fn_ridging.asp 참조
'#############################################
	Set db = new clsDBHelper

	'request
	If hasown(oJSONoutput, "KGAME") = "ok" Then '체전여부 A 두번복사여부
		r_kgame= oJSONoutput.KGAME
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

'	'독립적으로 지점수, 최고점수, 심판장서명완료 가 되었는지 확인할수 있게 되어야한다. (gbidx 에서 한개라도 누락이라면 안된거임) 다시적용하록 메시지
	SQL = "select top 1 ridingclass , ridingclasshelp,teamgb  from tblTeamGbInfo  where teamgbidx = '"&r_gbidx&"'   "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arrC = rs.GetRows()
		If IsArray(arrC) Then
				gb_class = arrC(0, 0)
				gb_classhelp = arrC(1, 0)
				gb_teamgb = arrC(2,0) ' 단체전 확인값
		End if
	End If
	rs.close


	fld = " a.gametitlename,a.games,a.gamee,a.gamearea     ,"&ptstr&"name    "
	SQL = "select "&fld&" from sd_tennisTitle as a INNER JOIN  tblRGameLevel as b ON a.gametitleidx = b.gametitleidx where a.delyn = 'N' and b.delyn='N' and a.gametitleidx  = " & r_tidx & " and b.gbidx = " & r_gbidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof then
	i_title = rs(0)
	i_sdate = rs(1)
	i_edate = rs(2)
	i_area = rs(3)
	i_judgenm = rs(4)
	End if


'Response.write sql
'Response.end



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
	SQL = "select top 1 judgecnt,judgemaxpt,judgesignYN,judgeshowYN    ,judgeB,judgeE,judgeM,judgeC,judgeH,bestsc,maxChk,minChk  from tblRGameLevel  where gametitleidx = '"&r_tidx&"' and Gbidx = '"&r_gbidx&"'  "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arrC = rs.GetRows()
	End If
	rs.close

	If IsArray(arrC) Then
		For ar = LBound(arrC, 2) To UBound(arrC, 2)
			r_judgecnt = arrC(0, ar)
			r_judgemaxpt = arrC(1, ar) '지점별최고점수
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




			If p_teamgb = "20101" Or p_teamgb = "20201" Or  ( p_teamgb = "20103" And orderType = "MM") Or  ( p_teamgb = "20203" And orderType = "MM")  Then '제한조건 마장마술,복합마술(마장)


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



	'//지점별 감점된  총합구하기 구하기
	Function getAreaTotal(pointvalue, off1, maxpt , vio)
		Dim pointper, sumvalue
		pointper = 0 
		sumvalue = 0

		if CDbl(vio) = 200 then
			sumvalue = CDbl(pointvalue) - cdbl(off1) - (maxpt * (0/100) )
		else
			sumvalue = CDbl(pointvalue) - cdbl(off1) - (maxpt * (vio/100) )
		End if
		getAreaTotal =  sumvalue
	End Function


'Response.write p_sArr(r_ptloc) & " A<br>"
'Response.write p_off1& " B<br>"
'Response.write r_judgemaxpt& " C<br>"
'Response.write p_vio& " D<br>"

	'p_areapt	 = isNullDefault(p_sArr(r_ptloc) , 0)
	If p_sArr(r_ptloc) = "" Then
		p_areapt = 0
	Else
		p_areapt = p_sArr(r_ptloc)	
	End if

	areatotalpoint = FormatNumber(getAreaTotal( p_areapt, p_off1, r_judgemaxpt, p_vio),2)

'Response.write areatotalpoint



'@@@@@@@@@@@@@@@@@@@@@@@@@@
			'fieldarr = array("useyear","teamgb","ridingclass","testtype")
			SQL = "Select top 1 a.idx from tblTeamGbInfoDetail as a INNER JOIN tblTeamGbInfo as b ON a.useyear= b.useyear and b.teamgb = b.teamgb and a.ridingclass = b.ridingclass and a.ridingclasshelp = b.ridingclasshelp "
			SQL = SQL & " where a.delYN = 'N' and b.teamgbidx = " & r_gbidx & " and a.teamgb = '"&gb_teamgb&"' " '단체전확인위해 추가  teamgb

			Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)
			If Not rs.eof Then
				'안만들어졌는지 확인해야함...
				e_idx = rs(0)
			End if

			If e_idx <> "" then
				strwhere = " a.delYN = 'N' and ((a.testtype in (1,2) and b.delYN='N') or a.testtype = 3) and a.idx = " & e_idx & "  "
				fieldstr = " a.idxs1,a.testtype,a.orderno as ano ,a.maxval,a.gesoo,a.eidear,a.kidear      ,b.idxs2,b.orderno as bno,b.orderstr,b.ktest,b.etest      ,c.val1,c.val2,c.rmk  "
				SQL = "Select "&fieldstr&" from tblTeamGbInfoDetail_S1 as a Left Join tblTeamGbInfoDetail_S2 as b On a.idxs1 = b.idxs1  "

				SQL = SQL  & "  LEFT JOIN tblJudgeDetail  as c ON a.idxs1 = c.idxs1 and c.gamememberidx = "&r_idx & " and c.areanm = '"&ptstr&"' "

				SQL = SQL  & " where  " & strwhere  & "  order by a.testtype, a.orderno "
'Response.write r_gbidx
				Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)
				If Not rs.EOF Then
					Set fd = Server.CreateObject("Scripting.Dictionary") '필드를 좀더 쉽게 찾자.
					For i = 0 To Rs.Fields.Count - 1
						fd.Add LCase(Rs.Fields(i).name), i
					Next
					arr2 = rs.GetRows()
				End If

'Response.write sql
'Response.END

				SQL = "select val1,val2 from tblJudgeDetail where idx = "&e_idx&" and gamememberidx = "&r_idx'&" and areanm = '"&ptstr&"' "
				Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)
				If Not rs.eof Then
					off1val = rs(0)
					off2val = rs(1)
				End if
			End if
'@@@@@@@@@@@@@@@@@@@@@@@@@@



  db.Dispose
  Set db = Nothing
%>

<%'##########################################################################################%>

<%If e_idx  <> "" then%>

		<%If r_B = "Y" then%><input type="hidden" id="total_1"  value="<%=p_s1%>" ><%End if%>
		<%If r_E = "Y" then%><input type="hidden" id="total_2"  value="<%=p_s2%>" ><%End if%>
		<%If r_M = "Y" then%><input type="hidden" id="total_3"  value="<%=p_s3%>" ><%End if%>
		<%If r_C = "Y" then%><input type="hidden" id="total_4"  value="<%=p_s4%>" ><%End if%>
		<%If r_H = "Y" then%><input type="hidden" id="total_5"  value="<%=p_s5%>" ><%End if%>
		<input type="hidden" id="pertotal"  value="<%=FormatNumber(p_per,3)%>" />


		<div class="modal-content">

			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
				<h4>심사기록입력</h4>
			</div>

			<div class="modal-body">
				<div class="col-sm-8">
					<table cellspacing="0" cellpadding="0" class="table table-bordered table-hover">
						<tbody>
							<tr><th >대회명</th><td><%=i_title%></td></tr>
							<tr><th >기간</th><td><%=i_sdate%>~<%=i_edate%></td></tr>
							<tr><th >장소</th><td><%=i_area%></td></tr>
							<tr><th >심판위원 및 지점</th><td><%=ptstr%> (<%=i_judgenm%>)</td></tr>
						</tbody>
					</table>
				</div>
				<div class="col-sm-4">
					<table cellspacing="0" cellpadding="0" class="table table-bordered table-hover">
						<tbody>
							<tr><th >출전순서</th><td><%=p_sortno%></td></tr>
							<tr><th >소속</th><td><%=p_teamnm%></td></tr>
							<tr><th >선수명</th><td><%=p_unm%></td></tr>
							<tr><th >마명</th><td><%=p_hnm%></td></tr>
						</tbody>
					</table>
				</div>


<div class="col-sm-12">


<!-- 경로위반정보설정 -->
<%
	If IsArray(arr2) Then
	For ar = LBound(arr2, 2) To UBound(arr2, 2)
		idxs1 =  arr2(fd.Item("idxs1"), ar)
		testtype =  arr2(fd.Item("testtype"), ar)

		If testtype = "3" Then

			pathc = isNullDefault(arr2(fd.Item("maxval"), ar),0)
			pathp = isNullDefault(arr2(fd.Item("gesoo"), ar),0)

			If off2val <> "" Then '경로위반 입력값이 있다면 (경로위반을 체크하는 룰이 있다면)
				If CStr(off2val) = CStr(pathc) Then
					If pathp = "200" Then
						pathperstr = "실권(E)"
					else
						pathperstr = pathp & "%"
					End if
				End if
			End if

			If pathcnt = "" then
				pathcnt =  pathc
				pathper =  pathp
			Else
				pathcnt =  pathcnt & "," & pathc '경로위반 횟수
				pathper =  pathper & "," & pathp '경로위반 %
			End if
		End If



	Next
	%>
	<input type="hidden" id="pathoutcnt" value="<%=pathcnt%>"><%'경로위반 횟수%>
	<input type="hidden" id="pathoutper" value="<%=pathper%>"><%'경로위반 % %>
	<input type="hidden" id="vio" value="<%=p_vio%>"><%'내 경로위반 입력된 점수%>
	<%
	End if
%>





<%
	tabidx = 0

	For tab = 1 To 2%>
	<%If tab = 1 then%>
	<h2 class="cont_tit">운동과목</h2>
	<%else%>
	<h2 class="cont_tit">종합관찰</h2>
	<%End if%>
	<table class="table table-bordered tbl_tspaper">
		<colgroup>
			<col style="width:50px;"/>
			<col style="width:400px;"/>
			<col style="width:60px;"/>
			<col style="width:60px;"/>
			<!-- <col style="width:60px;"/> -->
			<col style="width:60px;"/>
			<col style="width:60px;"/>
			<col style="width:100px;"/>
			<col style="width:22%"/>
			<col style="width:22%"/>
		</colgroup>
		<thead>
			<tr>
				<th scope="col" style="border-right:0px;">순서</th>
				<th scope="col">순서/운동과목</th>
				<th scope="col">최고점</th>
				<th scope="col">채점</th>
				<th scope="col" style="display:none;">수정</th><!-- 안보이게 처리 (삭제요청에 의해서) -->
				<th scope="col">계수</th>
				<th scope="col">계</th>
				<th scope="col">비고<br>(Rmk.)</th>
				<th scope="col" colspan="2">심사착안점<br>(Directive ideas)</th>
			</tr>
		</thead>

		<tbody>


<%
totalm = 0
totalg = 0
testA = 0
testB = 0
testlinesum = 0
testv = 0


	If IsArray(arr2) Then
	For ar = LBound(arr2, 2) To UBound(arr2, 2)

		'a.idxs1,a.testtype,a.orderno as ano ,a.maxval,a.gesoo,a.eidear,a.kidear      ,b.idxs2,b.orderno as bno,b.orderstr,b.ktest,b.etest
		idxs1 =  arr2(fd.Item("idxs1"), ar)
		testtype =  arr2(fd.Item("testtype"), ar)
		nos1 =   arr2(fd.Item("ano"), ar)
		nos2 =   arr2(fd.Item("bno"), ar)
		eidear =   arr2(fd.Item("eidear"), ar)
		kidear =   arr2(fd.Item("kidear"), ar)
		maxval =  isNullDefault(arr2(fd.Item("maxval"), ar),0)
		gesoo =  isNullDefault(arr2(fd.Item("gesoo"), ar),0)
		val1 = isNullDefault(arr2(fd.Item("val1"), ar),0)
		val2 = isNullDefault(arr2(fd.Item("val2"), ar),0)
		rmk = isNullDefault(arr2(fd.Item("rmk"), ar),"")

		If tab = testtype Then '체점형태
		If nos1 <> prenos1 Then 's1번호 와 이전번호비교


				If maxval <> "" then
				totalm = totalm + (maxval*gesoo)
				End If
				If gesoo <> "" then
				totalg = totalg + gesoo
				End If

				'채점 및 수정 점수 구하기
				If val1 > 0 Then
					testlinesum = CDbl(val1 * gesoo)
					testA = testA + testlinesum
				End If
				If val2 > 0 Then
					testlinesum = CDbl(val2 * gesoo)
					testB = testB + testlinesum
				Else
					testlinesum = CDbl(val1 * gesoo)
					testB = testB + testlinesum
				End if
				testv =testv + CDbl(testlinesum)
		%>
			<tr name="trOrder">

				<td scope="col"><%=nos1%></td>
				<td style="padding:0px;">
					<table class="tbl_tspaper" cellspacing="0" cellpadding="0">
						<%
						For ar2 = LBound(arr2, 2) To UBound(arr2, 2)
							idxs1_s =  arr2(fd.Item("idxs1"), ar2)
							idxs2_s =  arr2(fd.Item("idxs2"), ar2)
							testtype_s =  arr2(fd.Item("testtype"), ar2)
							nos1_s =   arr2(fd.Item("ano"), ar2)
							nos2_s =   arr2(fd.Item("bno"), ar2)
							ktest =   arr2(fd.Item("ktest"), ar2)
							etest =   arr2(fd.Item("etest"), ar2)
							orderstr =   arr2(fd.Item("orderstr"), ar2)

							If CStr(idxs1) = CStr(idxs1_s) then





						%>
						<tr style="height:60px;" name="trStaff<%=idxs1%>">
							<td scope="row" style="width:60px;word-break:break-all;"><%=orderstr%></td>
							<td scope="row" style="width:200px;word-break:break-all;"><%=htmlDecode(ktest)%></td>
							<td scope="row" style="width:200px;word-break:break-all;"><%=htmlDecode(etest)%></td>
						</tr>
						<%
							End if
						Next
						%>
					</table>
				</td>
				<%tabidx = tabidx+1%>
				<td scope="row"><input type="text" name="maxval<%=tab%>" value="<%=maxval%>" class="itxtbox"  readonly onfocus="blur()"></td>
				<td scope="row"><input type="text" name="val<%=tab%>_1" value="<%=val1%>" class="itxtbox"  onkeyup="this.value=mx.setValuation(event,this,<%=tab%>,'<%=ptstr%>',<%=r_tidx%>,<%=r_gbidx%>,<%=e_idx%>,<%=idxs1%>,<%=r_idx%>,1)" maxlength="6" style="background:#CBCDE0;" tabindex="<%=tabidx%>" onfocus="px.chkZero(this)" onblur="px.setZero(this);"></td>

				<td scope="row" style="display:none;"><input type="text" name="val<%=tab%>_2" value="0<%'=val2%>" class="itxtbox" onkeyup="this.value=mx.setValuation(event,this,<%=tab%>,'<%=ptstr%>',<%=r_tidx%>,<%=r_gbidx%>,<%=e_idx%>,<%=idxs1%>,<%=r_idx%>,2)" maxlength="6" style="background:#CBCDE0;" readonly></td>

				<td scope="row" ><input type="text" name="vdog<%=tab%>" value="<%=gesoo%>" class="itxtbox"  readonly onfocus="blur()"></td>
				<td scope="row"><input type="text" name="linesum<%=tab%>" value="<%=testlinesum%>" class="itxtbox"  readonly onfocus="blur()"></td>


				<td scope="row"><input type="text" name="rmk" value="<%=rmk%>" class="itxtbox"  maxlength="20" style="background:#CBCDE0;" onkeyup="this.value=mx.setValuation(event,this,<%=tab%>,'<%=ptstr%>',<%=r_tidx%>,<%=r_gbidx%>,<%=e_idx%>,<%=idxs1%>,<%=r_idx%>,3)" ></td>

				<td scope="row"><div style="word-break:break-all;"><%=textareaDecode(eidear)%></div></td>
				<td scope="row"><div style="word-break:break-all;"><%=textareaDecode(kidear)%></div></td>
			</tr>
		<%

		End If
		End if
		prenos1 = nos1

	Next
	End if
%>


		</tbody>

		<tfoot>
			<tr class="active">
				<td scope="row" colspan="2">계</td>
				<td scope="row"><%=totalm%></td>
				<td scope="row"><%'=testA%></td><!-- 채점 총점 -->
				<td scope="row" style="display:none;"><%'=testB%></td><!-- 수정 총점 -->
				<td scope="row"><%=totalg%></td>
				<td scope="row"><input type="text" id="testtotal<%=tab%>" value="<%=testv%>" class="itxtbox"  readonly onfocus="blur()"></td>
				<td scope="row"></td>
				<td scope="row"></td>
				<td scope="row"></td>
			</tr>
		</tfoot>
	</table>

<%next%>

</div>


<%'If ptstr = "C" then%>
	<div class="col-sm-12">
		<h2 class="cont_tit">감점사항</h2>
		<table cellspacing="0" cellpadding="0" class="table table-bordered table-hover" width="100%">
			<thead>
				<tr>
					<th scope="">감점사항</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>감점 <input type="text" id="off1" value="<%=off1val%>" maxlength="3"  onkeyup="this.value=mx.setValuation(event,this,<%=tab%>,'<%=ptstr%>',<%=r_tidx%>,<%=r_gbidx%>,<%=e_idx%>,<%=idxs1%>,<%=r_idx%>,4)"   <%If ptstr <> "C" then%>readonly onfocus="blur()"<%else%>
					tabindex="<%=tabidx%>" <%tabidx = tabidx+1%>
					<%End if%> /> 점</td>
				</tr>
			</tbody>
		</table>
	</div>

	<div class="col-sm-12">
		<h2 class="cont_tit">경로위반</h2>
		<table cellspacing="0" cellpadding="0" class="table table-bordered table-hover" width="100%">
			<thead>
				<tr>
					<th colspan="2">감점사항</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td class="col-sm-6"><input type="text" id="off2"  value="<%=off2val%>"  maxlength="2"  onkeyup="this.value=mx.setValuation(event,this,<%=tab%>,'<%=ptstr%>',<%=r_tidx%>,<%=r_gbidx%>,<%=e_idx%>,<%=idxs1%>,<%=r_idx%>,5)" <%If ptstr <> "C" then%>readonly onfocus="blur()"<%else%>
					tabindex="<%=tabidx%>" <%tabidx = tabidx+1%>
					<%End if%> /> 회</td>
					<td class="col-sm-6"><span id="vio_rt"><%=pathperstr%></span></td>
				</tr>
			</tbody>
		</table>
	</div>
<%'else%>
	<!-- <input type = "hidden"  id="off1" value="<%=off1val%>" />
	<input type = "hidden"  id="off2"  value="<%=off2val%>" /> -->
<%'End if%>



		<div class="modal-footer">
			총점 : <span id="areatotal"><%=areatotalpoint%></span>&nbsp;&nbsp;&nbsp;
			<a  href="javascript:mx.inputRecordMM(<%=r_idx%>,<%=r_tidx%>,<%=r_gbidx%>,<%=p_pubcode%>, '<%=Left(LCase(gb_class),1)%>',<%=r_judgemaxpt%>,<%=r_judgecnt%>,'<%=r_maxChk%>','<%=r_minChk%>','<%=p_teamgb%>','<%=ptstr%>')" class="btn btn-primary">확인</a>
		</div>

</div>

<%End if%>


<%'##########################################################################################%>




























<%If e_idx  = "" then%>
<!-- 심사기준 관리를 먼저 작성해 주십시오. -->
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

<%End if%>
