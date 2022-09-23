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

	tidxgbidx = r_tidx & r_gbidx


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
	fldnm = "a.gubun,a.playeridx,a.username,a.key3name,a.tryoutsortno,a.tryoutresult,a.teamAna,b.playeridx,b.username,    score_sgf,score_1,score_2,score_3,score_4,score_5,score_6,score_total ,score_per ,a.pubcode,a.off1,a.off2,vio,a.teamgb,a.pubname, a.jinputarr,a.jinputtxtarr,a.jinputsecarr,a.bigo,a.bigo2 "

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

		p_st = isNullDefault(arrRS(16, 0),"0") '지점 총점, 장애물: 소요시간
		p_per = isNullDefault(arrRS(17, 0),"0") '퍼, 장애물: 소요시간2 type B, C

		If p_result = "e" Or p_result = "r" Or p_result = "d" Then
			If CDbl(p_st) >= 200 then
			p_st = UCase(p_result)
			End If
			If CDbl(p_per) >= 200 then			
			p_per = UCase(p_result)
			End if
		End if




		p_pubcode = arrRS(18, 0)
		p_sArr = array("", p_s1,p_s2,p_s3,p_s4,p_s5) 'BEMCH
		p_off1 = arrRS(19, 0)
		p_off2 = arrRS(20, 0)
		p_vio = isNullDefault(arrRS(21, 0),"0")
		p_teamgb = arrRS(22,0) '복합마술 20103
		p_pnm = arrRS(23,0)
		p_judgeinput = isNullDefault(arrRS(24,0),"") '심판입력값 배열
		p_judgeinputtxt = isNullDefault(arrRS(25,0),"") '심판입력값 배열 문자열
		p_judgeinputsec = isNullDefault(arrRS(26,0),"") '심판입력값 배열 벌초
		p_bigo = isNullDefault(arrRS(27,0),"") '비고
		p_bigo2 =isNullDefault(arrRS(28,0),"") '비고2

	    orderType = GetOrderType(gb_classhelp, p_teamgb, gb_class) '타입 

		If p_judgeinput <> "" Then
			p_judgeinputarr = Split(p_judgeinput, ",")
		End If
		If p_judgeinputtxt <> "" Then
			p_judgeinputtxtarr = Split(p_judgeinputtxt, ",")
		End If
		If p_judgeinputsec <> "" Then
			p_judgeinputsecarr = Split(p_judgeinputsec, ",")
		End if		

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
			SQL = "Update SD_tennisMember Set score_1 = 0 where gamememberidx = " & r_idx  '입력중체크
			Call db.execSQLRs(SQL , null, ConStr)		
		End If


		field = " tidxgbidx,tidx,chk1,chk2,chk3,deduction1,deduction2,deduction3,deduction4,d4second,d5second,deduction5, hurdle1,hurdle2,hurdle3,hurdle4,hurdle5,hurdle6,hurdle7,hurdle8,hurdle9,hurdle10,hurdle11,hurdle12,hurdle13,hurdle14,hurdle15,hurdle16,hurdle17,hurdle18,hurdle19,hurdle20, hurdle2pahasegubun,totallength1,mspeed1,time1,limittime1,totallength2,mspeed2,time2,limittime2,installname,designname,useOK "

		'복합마술 이라면 
		If p_teamgb = "20103" then
			SQL = "select  " &field& " from tblHurdleInfo where  tidxgbidx = '" & tidxgbidx  & "' and roundno = " & r_rdno
		Else
			'재경기 기준 배치정보와 관련해서
			If gb_classhelp = CONST_TYPEA2 Or gb_classhelp = CONST_TYPEA1 Or gb_classhelp = CONST_TYPEA_1 Or gb_classhelp = CONST_TYPEB Or gb_classhelp = CONST_TYPEC Then '최적시간 포함 혹 다른곳이 있는지 확인필요
				SQL = "select  " &field& " from tblHurdleInfo where  tidxgbidx = '" & tidxgbidx  & "' and roundno = " & r_rdno
				'If  Cdbl(r_rdno) = 3  And r_kgame = "Y"
			'else
			'	If r_kgame = "Y" And Cdbl(r_rdno) > 3 Then '채전 재경기
			'	SQL = "select  " &field& " from tblHurdleInfo where  tidxgbidx = '" & tidxgbidx  & "' and roundno = " & r_rdno
			'	else
			'	SQL = "select  " &field& " from tblHurdleInfo where  tidxgbidx = '" & tidxgbidx  & "' and roundno = 1 "
			'	End if
			End if
		End if
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

'Response.write orderType
'Response.write sql
'Response.end
		Dim hurdleArr(20)
		If rs.EOF Then
			'장애물 기준 및 배치정보를 설정해주세요.
		Else
			For i = 1 To 20
				hurdleArr(i) = isNullDefault(rs("hurdle" & i),"")
			next
			jm01 = rs("chk1")	
			jm02 = rs("chk2")	
			jm08 = rs("chk3")	

			jm03 = rs("deduction1")	
			jm04 = rs("deduction2")	
			jm05 = rs("deduction3")	
			
			jm06 = rs("deduction4")	
			jm07 = rs("d4second")	

			jm09 = rs("d5second")	
			jm10 = rs("deduction5")	

			hurdle2pahasegubun = isNullDefault(rs("hurdle2pahasegubun"),"0") '구분값 1라운드 2라운드

			totallength1= rs("totallength1")
			mspeed1 = rs("mspeed1")
			time1 = rs("time1")
			limittime1 = rs("limittime1")

			totallength2= rs("totallength2")
			mspeed2 = rs("mspeed2")
			time2 = rs("time2")
			limittime2 = rs("limittime2")

			installname = rs("installname")
			designname = rs("designname")
			useOK = rs("useOK")  '실지 사용여부 설정 확인버튼 누를때 업데이트
		End If

	End if
	
	makevalue = "{""d1"":"""&jm03&""",""d2"":"""&jm04&""",""d3"":"""&jm05&""",""d4"":"""&jm06&""",""d5"":"""&jm10&"""   ,""sec4"":"""&jm07&""",""sec5"":"""&jm09&""" ,""chk1"":"""&jm01&""",""chk2"":"""&jm02&""",""chk3"":"""&jm08&"""   ,""ln1"":"""&totallength1&""",""m1"":"""&mspeed1&""",""t1"":"""&time1&""",""lm1"":"""&limittime1&""" ,""ln2"":"""&totallength2&""",""m2"":"""&mspeed2&""",""t2"":"""&time2&""",""lm2"":"""&limittime2&"""}"



	
	game1devalue = 0
	Select Case gb_classhelp
	Case CONST_TYPEA1 , CONST_TYPEA2 , CONST_TYPEA_1 'type A
		If CDbl(r_rdno) = 2 Then '1라운드에 실권 이라면 -40점 되어야하므로 실권이라면 -40을 출력해서 보여준다 (장애감점에)
			SQL = "Select tryoutresult,playeridx from sd_tennisMember where gametitleidx = "& r_tidx &" and gamekey3 = '"&r_gbidx&"' and  playeridx = " & p_pidx
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			game1result = rs(0)
			If game1result = "e" Then
				game1de = "(+20)"
				game1devalue = 20
			End if
		End if
	End Select 


  db.Dispose
  Set db = Nothing


'Select Case p_boonm
'Case "마장마술"
If  orderType = "MM" Then '마장마술, 복합마술(마장마술)
%>

				<div class="modal-content">

					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
						<h4>결과입력(심판지점 선택)</h4>
					</div>

					<div class="modal-body">
						<div class="form-horizontal">
							<div class="form-group">
								<p class="col-sm-12" style="color:#000;font-size:15px;">참가번호:<%=p_sortno%> 선수명:<%=p_unm%> 마명:<%=p_hnm%></p>

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
										<input type="radio" name="point" id="point_1" value="1"/><label for="point_1" class="control-label mgl8 mgr20 text-primary" style="font-size:20px;"> B 지점</label>
										<%Case "0" '입력진행중%>
										<input type="radio" name="point" id="point_1" value="1"/><label for="point_1" class="control-label mgl8 mgr20 text-danger" style="font-size:20px;"> B 지점</label>
										<%Case Else '입력완료%>
										<input type="radio" name="point" id="point_1" value="1" /><label for="point_1" class="control-label mgl8 mgr20 text-success" style="font-size:20px;"> B 지점<br><%=p_s1%></label>
										
										<%End Select %>
										<%End if%>

										<%If r_E = "Y" then%>
										<%Select Case CStr(p_sArr(2))%>
										<%Case "" '입력전%>
										<input type="radio" name="point" id="point_2" value="2"/><label for="point_2" class="control-label mgl8 mgr20 text-primary" style="font-size:20px;"> E 지점</label>
										<%Case "0" '입력진행중%>
										<input type="radio" name="point" id="point_2" value="2"/><label for="point_2" class="control-label mgl8 mgr20 text-danger" style="font-size:20px;"> E 지점</label>
										<%Case Else '입력완료%>
										<input type="radio" name="point" id="point_2" value="2" /><label for="point_2" class="control-label mgl8 mgr20 text-success" style="font-size:20px;"> E 지점<br><%=p_s2%></label>
										<%End Select %>
										<%End if%>

										<%If r_M = "Y" then%>
										<%Select Case CStr(p_sArr(3))%>
										<%Case "" '입력전%>
										<input type="radio" name="point" id="point_3" value="3"/><label for="point_3" class="control-label mgl8 mgr20 text-primary" style="font-size:20px;"> M 지점</label>
										<%Case "0" '입력진행중%>
										<input type="radio" name="point" id="point_3" value="3"/><label for="point_3" class="control-label mgl8 mgr20 text-danger" style="font-size:20px;"> M 지점</label>
										<%Case Else '입력완료%>
										<input type="radio" name="point" id="point_3" value="3" /><label for="point_3" class="control-label mgl8 mgr20 text-success" style="font-size:20px;"> M 지점<br><%=p_s3%></label>
										<%End Select %>
										<%End if%>

										<%If r_C = "Y" then%>
										<%Select Case CStr(p_sArr(4))%>
										<%Case "" '입력전%>
										<input type="radio" name="point" id="point_4" value="4"/><label for="point_4" class="control-label mgl8 mgr20 text-primary" style="font-size:20px;"> C 지점</label>
										<%Case "0" '입력진행중%>
										<input type="radio" name="point" id="point_4" value="4"/><label for="point_4" class="control-label mgl8 mgr20 text-danger" style="font-size:20px;"> C 지점</label>
										<%Case Else '입력완료%>
										<input type="radio" name="point" id="point_4" value="4" /><label for="point_4" class="control-label mgl8 mgr20 text-success" style="font-size:20px;"> C 지점<br><%=p_s4%></label>
										<%End Select %>
										<%End if%>

										<%If r_H = "Y" then%>
										<%Select Case CStr(p_sArr(5))%>
										<%Case "" '입력전%>
										<input type="radio" name="point" id="point_5" value="5"/><label for="point_5" class="control-label mgl8 mgr20 text-primary" style="font-size:20px;"> H 지점</label>
										<%Case "0" '입력진행중%>
										<input type="radio" name="point" id="point_5" value="5"/><label for="point_5" class="control-label mgl8 mgr20 text-danger" style="font-size:20px;"> H 지점</label>
										<%Case Else '입력완료%>
										<input type="radio" name="point" id="point_5" value="5" /><label for="point_5" class="control-label mgl8 mgr20 text-success" style="font-size:20px;"> H 지점<br><%=p_s5%></label>
										<%End Select %>
										<%End if%>

										<br><br><span>감점:<%=p_off1%> 경로위반:<%=p_off2%></a>


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

<%End If%>




<%'Case "장애물####################################################################################################"%>
<%If  orderType <> "MM" Then '장애물, 복합마술(장애물)%>
	<input type="hidden" id="makevalue" value='<%=makevalue%>'><%'생성된 장애물의 기준값들 json%>
	<input type="hidden" id="judgeinput" value='<%=p_judgeinput%>'><%'심판들이 입력한 값들 json 배열%>
	<input type="hidden" id="judgeinputtxt" value='<%=p_judgeinputtxt%>'>
	<input type="hidden" id="judgeinputsec" value='<%=p_judgeinputsec%>'>
	<input type="hidden" id="hurdlegubun" value='<%=hurdle2pahasegubun%>'>

	<input type="hidden" id="game1devalue" value='<%=game1devalue%>'><!-- 2.1, 2.2 체전인 경우 1라운드 실권 - 20 -->


				<%Select Case gb_classhelp%>
				<%Case CONST_TYPEA1 , CONST_TYPEA2 , CONST_TYPEA_1 'type A%>

					<div class="modal-content">
						<div class="modal-header">
							<%If p_s1 = "" then%>
							<button type="button" class="close"  onmousedown="mx.setScState(<%=r_idx%>,<%=r_tidx%>,<%=r_gbidx%>,1)">×</button>
							<%else%>
							<button type="button" class="close" data-dismiss="modal" aria-hidden="true" onmousedown="mx.ssremove()">×</button>
							<%End if%>
							<h4>기록입력 (장애물 <%=gb_classhelp%>)</h4>
						</div>
						<div class="modal-body">
							<div style="float:left;width:50%;padding-right:10px;">
							<table class="table">
								<thead>
									<tr>
										<th>부명</th><th>번호</th><th>선수명</th><th>마명</th><th>소속</th>
									</tr>
								</thead>
								<tbdoy>
									<tr>
										<td style="height:50px;"><%=p_pnm%></td>
										<td><%=p_sortno%></td>
										<td><%=p_unm%></td>
										<td><%=p_hnm%></td>
										<td><%=p_teamnm%></td>
									</tr>
								</tbdoy>
							</table>
							</div>

							<div style="float:left;width:50%;">
							<table class="table">
								<thead>
									<tr>
										<%'만약 2라운드 이고 1라운드에 실권 이라면 -40점 되어야하므로 실권이라면 -40을 출력해서 보여준다 (장애감점에)%>
										<%If CDbl(r_rdno) = 2 then%>
										<th>소요시간</th><th>시간감점</th><th>장애감점<%=game1de%></th><th>감점합계</th>
										<%else%>
										<th>소요시간</th><th>시간감점</th><th>장애감점</th><th>감점합계</th>
										<%End if%>
									</tr>
								</thead>
								<tbdoy>
									<tr>
										<td><input type="number" id="j_gametime"  value="<%=p_s1%>" placeholder="00.000" class="form-control" onfocus="px.chkZero(this)" onkeyup="mx.setDotAuto('j_gametime');" onblur="px.setZero(this);mx.setTimeDeduction('j_gametime',this)" /></td>
										<td><input type="number" id="j_pt1" value="<%=p_s2%>"  placeholder="0" class="form-control"  readonly/></td>
										<!-- onkeyup="mx.jptSum()"   onmouseup="mx.jptSum()" -->
										<td><input type="number" id="j_pt2" value="<%=p_s3%>"  placeholder="0" class="form-control"  readonly/></td>
										<td><input type="text" id="j_pttotal" class="form-control" value = "<%If isnumeric(p_result) = True then%><%=p_st%><%else%><%=UCase(p_result)%><%End if%>" readonly/></td>
									</tr>
								</tbdoy>
							</table>
							</div>



					<table cellspacing="0" cellpadding="0" class="table table-bordered table-hover" width="100%">
						<thead>
							<tr>
								<%For i = 11 To 30%>
								<%
								If Trim(hurdleArr(i-10)) = "" Then
									Exit for
								End if
								%>
								<th style="cursor:pointer;<%If i = 11 then%>background:orange;<%End if%>" id="t_<%=i%>" onclick="$(this).parent().children().css('backgroundColor','#333333');$(this).css('backgroundColor','orange');mx.chkRnd='<%=i%>'">
								<%=hurdlearr(i-10)%>
								</th>
								<%next%>
								<th>비고</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<%For i = 11 To 30%>
								<%
								If Trim(hurdleArr(i-10)) = "" Then
									Exit for
								End If
								
								If isArray(p_judgeinputtxtarr)  Then
									If CDbl(ubound(p_judgeinputtxtarr)) >=  (i-11) then
									jvalue = p_judgeinputtxtarr(i-11)
									End if
								End if
								%>
								<td onclick="$('#t_<%=i%>').parent().children().css('backgroundColor','#333333');$('#t_<%=i%>').css('backgroundColor','orange');mx.chkRnd='<%=i%>'"><input type="text" class="form-control"  id='jm<%=i%>'  value= "<%=jvalue%>" readonly/></td>
								<%
								jvalue = ""
								next%>
								<td><input type="text" class="form-control"  id='jmbigo' value="<%=p_bigo%>" /></td>
							</tr>
						</tbody>
					</table>




				<div class="col-md-12">
					<div class="row">


							<div class="col-md-1 text-center">
								<h5 class="row">입력값취소</h5>
								<div class="row">
									<button type="button" class="btn btn-danger" onclick="mx.setDeduction('')">취소</button>
								</div>
							</div>

							<div class="col-md-2 text-center">
								<h5 class="row">장애물 낙하</h5>
								<div class="row">
									<button type="button" class="btn btn-default"  onclick="mx.setDeduction('K')">K</button>
									<button type="button" class="btn btn-default"  onclick="mx.setDeduction('K.K')">K.K</button>
								</div>
							</div>
							<div class="col-md-2 text-center">
								<h5 class="row">1회 거부</h5>
								<div class="row">
									<button type="button" class="btn btn-default"  onclick="mx.setDeduction('1R')">1R</button>
									<button type="button" class="btn btn-default"  onclick="mx.setDeduction('1R.K')">1R.K</button>
								</div>
							</div>
							<div class="col-md-1 text-center">
								<h5 class="row">2회 거부</h5>
								<div class="row">
									<button type="button" class="btn btn-default"  onclick="mx.setDeduction('2R')">2R</button>
								</div>
							</div>
							<div class="col-md-2 text-center">
								<h5 class="row">거부,전도</h5>
								<div class="row">
									<button type="button" class="btn btn-default"  onclick="mx.setDeduction('RF')">RF</button>
									<button type="button" class="btn btn-default"  onclick="mx.setDeduction('RF.K')">RF.K</button>
								</div>
							</div>
							<div class="col-md-1  text-center">
								<h5 class="row">낙마</h5>
								<div class="row">
									<button type="button" class="btn btn-default"  onclick="mx.setDeduction('F')">F</button>
								</div>
							</div>
							<div class="col-md-3 text-center">
								<div class="col-md-2 text-center">
									<h5 class="row">실권</h5>
									<div class="row">
										<button type="button" class="btn btn-default"  onclick="mx.setDeduction('E')">E</button>
									</div>
								</div>
								<div class="col-md-3 text-center">
									<h5 class="row">기권(R)</h5>
									<div class="row">
										<button type="button" class="btn btn-default"  onclick="mx.setDeduction('R')">R</button>
									</div>
								</div>
								<div class="col-md-2 text-center">
									<h5 class="row">실격</h5>
									<div class="row">
										<button type="button" class="btn btn-default"  onclick="mx.setDeduction('D')">D</button>
									</div>
								</div>
							</div>



						</div>
					</div>


						</div>
						<div class="modal-footer">
							
							<%If gb_classhelp = CONST_TYPEA_1 Then '최적시간..................................................................................%>

								<%If CStr(p_st) = "0" then%>
								<a href="javascript:mx.inputRecordJokA_1(<%=r_idx%>,<%=r_tidx%>,<%=r_gbidx%>,<%=p_pubcode%>,<%=r_rdno%>,'<%=r_kgame%>',<%=r_BestSC%>)" class="btn btn-primary">점수기록</a>
								<%else%>
								<a href="javascript:mx.inputRecordJokA_1(<%=r_idx%>,<%=r_tidx%>,<%=r_gbidx%>,<%=p_pubcode%>,<%=r_rdno%>,'<%=r_kgame%>',<%=r_BestSC%>)" class="btn btn-primary">입력수정</a>
								<!-- <a href="javascript:if (confirm('입력된 점수가 변경됩니다.\n 저장하시겠습니까?') == true) {mx.inputRecordJokA_1(<%=r_idx%>,<%=r_tidx%>,<%=r_gbidx%>,<%=p_pubcode%>,<%=r_rdno%>,'<%=r_kgame%>',<%=r_BestSC%>)}" class="btn btn-primary">입력수정</a> -->
								<%End if%>


							<%else%>
								<%If CStr(p_st) = "0" then%>
								<a href="javascript:mx.inputRecordJok(<%=r_idx%>,<%=r_tidx%>,<%=r_gbidx%>,<%=p_pubcode%>,<%=r_rdno%>,'<%=r_kgame%>','w')" class="btn btn-primary">점수기록</a>
								<%else%>
								<a href="javascript:mx.inputRecordJok(<%=r_idx%>,<%=r_tidx%>,<%=r_gbidx%>,<%=p_pubcode%>,<%=r_rdno%>,'<%=r_kgame%>','e')" class="btn btn-primary">입력수정</a>
								<!-- <a href="javascript:if (confirm('입력된 점수가 변경됩니다.\n 저장하시겠습니까?') == true) {mx.inputRecordJok(<%=r_idx%>,<%=r_tidx%>,<%=r_gbidx%>,<%=p_pubcode%>,<%=r_rdno%>,'<%=r_kgame%>')}" class="btn btn-primary">입력수정</a> -->
								<%End if%>
							<%End if%>


						</div>
					</div>

				<%Case CONST_TYPEB 'type B ########################################################################%>

					<div class="modal-content">
						<div class="modal-header">
							<button type="button" class="close" data-dismiss="modal" aria-hidden="true" onmousedown="mx.ssremove()">×</button>
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
											<td><input type="number" id="j_gametime"  placeholder="0.000"  class="form-control" value="<%=p_s1%>"  onfocus="px.chkZero(this)"   onkeyup="mx.setDotAuto('j_gametime');" onblur="px.setZero(this);mx.setTimeDeduction('j_gametime',this)"/></td>
											<td><input type="number" id="j_pt1" placeholder="0" class="form-control" value="<%=p_s2%>"  readonly/></td>
											<td><input type="number" id="j_pt2" placeholder="0" class="form-control" value="<%=p_s3%>"  readonly/></td><!-- score_total, score_total2 >=200  함수로 변경 getSayooSortno(sayou) -->
											<td><input type="text" id="j_pttotal" class="form-control" value = "<%If isnumeric(p_result) = True then%><%=p_st%><%else%><%=UCase(p_result)%><%End if%>" readonly/></td>


										<!-- 2단계 -->
											<td><input type="number" id="j2_gametime"  placeholder="0.000" class="form-control" value="<%=p_s4%>" onfocus="px.chkZero(this)"   onkeyup="mx.setDotAuto('j2_gametime');" onblur="px.setZero(this);mx.setTimeDeduction('j2_gametime',this)"/></td>
											<td><input type="number" id="j2_pt1" placeholder="0" class="form-control" value="<%=p_s5%>"  readonly/></td>
											<!-- onkeyup="mx.jptSum2()" -->
											<td><input type="number" id="j2_pt2" placeholder="0" class="form-control" value="<%=p_s6%>"  readonly/></td><!-- score_total, score_total2 >=200  함수로 변경 getSayooSortno(sayou) -->
											<td><input type="text" id="j2_pttotal" class="form-control" value = "<%If isnumeric(p_result) = True then%><%=p_per%><%else%><%=UCase(p_result)%><%End if%>" readonly/></td>
									</tr>
								</tbdoy>
							</table>


							<table cellspacing="0" cellpadding="0" class="table table-bordered table-hover" width="100%">
								<thead>
									<tr>
										<%For i = 11 To 30%>
										<%
										If Trim(hurdleArr(i-10)) = "" Then
											Exit for
										End if
										%>
										<%If (i - 10) = CDbl(hurdle2pahasegubun) then%>
										<th>비고</th>										
										<%End if%>


										<th style="cursor:pointer;<%If i = 11 then%>background:orange;<%End if%><%If (i - 10) = CDbl(hurdle2pahasegubun) then%>border-top:5px solid #D9534F;<%End if%>" id="t_<%=i%>" onclick="$(this).parent().children().css('backgroundColor','#333333');$(this).css('backgroundColor','orange');mx.chkRnd='<%=i%>';">
										<%=hurdlearr(i-10)%>
										</th>
										<%next%>
										<th>비고</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<%For i = 11 To 30%>
										<%
										If Trim(hurdleArr(i-10)) = "" Then
											Exit for
										End If

										If isArray(p_judgeinputtxtarr)  Then
											If CDbl(ubound(p_judgeinputtxtarr)) >=  (i-11) then
											jvalue = p_judgeinputtxtarr(i-11)
											End if
										End if
										%>

										<%If (i - 10) = CDbl(hurdle2pahasegubun) then%>
										<td><input type="text" class="form-control"  id='jmbigo'  value="<%=p_bigo%>"/></td>
										<%End if%>


										<td onclick="$('#t_<%=i%>').parent().children().css('backgroundColor','#333333');$('#t_<%=i%>').css('backgroundColor','orange');mx.chkRnd='<%=i%>'"><input type="text" class="form-control"  id='jm<%=i%>'  value= "<%=jvalue%>" readonly/></td>
										<%
										jvalue = ""
										next%>
										<td><input type="text" class="form-control"  id='jmbigo2'  value="<%=p_bigo2%>"/></td>
									</tr>
								</tbody>
							</table>


								<div class="col-md-12">
									<div class="row">

											<div class="col-md-1 text-center">
												<h5 class="row">입력값취소</h5>
												<div class="row">
													<button type="button" class="btn btn-danger" onclick="mx.setDeduction('')">취소</button>
												</div>
											</div>
											<div class="col-md-2 text-center">
												<h5 class="row">장애물 낙하</h5>
												<div class="row">
													<button type="button" class="btn btn-default"  onclick="mx.setDeduction('K')">K</button>
													<button type="button" class="btn btn-default"  onclick="mx.setDeduction('K.K')">K.K</button>
												</div>
											</div>
											<div class="col-md-2 text-center">
												<h5 class="row">1회 거부</h5>
												<div class="row">
													<button type="button" class="btn btn-default"  onclick="mx.setDeduction('1R')">1R</button>
													<button type="button" class="btn btn-default"  onclick="mx.setDeduction('1R.K')">1R.K</button>
												</div>
											</div>
											<div class="col-md-1 text-center">
												<h5 class="row">2회 거부</h5>
												<div class="row">
													<button type="button" class="btn btn-default"  onclick="mx.setDeduction('2R')">2R</button>
												</div>
											</div>
											<div class="col-md-2 text-center">
												<h5 class="row">거부,전도</h5>
												<div class="row">
													<button type="button" class="btn btn-default"  onclick="mx.setDeduction('RF')">RF</button>
													<button type="button" class="btn btn-default"  onclick="mx.setDeduction('RF.K')">RF.K</button>
												</div>
											</div>
											<div class="col-md-1  text-center">
												<h5 class="row">낙마</h5>
												<div class="row">
													<button type="button" class="btn btn-default"  onclick="mx.setDeduction('F')">F</button>
												</div>
											</div>

											<div class="col-md-3 text-center">
												<div class="col-md-2 text-center">
													<h5 class="row">실권</h5>
													<div class="row">
														<button type="button" class="btn btn-default"  onclick="mx.setDeduction('E')">E</button>
													</div>
												</div>
												<div class="col-md-3 text-center">
													<h5 class="row">기권(R)</h5>
													<div class="row">
														<button type="button" class="btn btn-default"  onclick="mx.setDeduction('R')">R</button>
													</div>
												</div>
												<div class="col-md-2 text-center">
													<h5 class="row">실격</h5>
													<div class="row">
														<button type="button" class="btn btn-default"  onclick="mx.setDeduction('D')">D</button>
													</div>
												</div>
											</div>

										</div>
									</div>

						
						
						</div>








						<div class="modal-footer">
							<%If CStr(p_st) = "0" then%>
							<a href="javascript:mx.inputRecordJok2(<%=r_idx%>,<%=r_tidx%>,<%=r_gbidx%>,<%=p_pubcode%>)" class="btn btn-primary">입력</a>
							<%else%>
							<a href="javascript:mx.inputRecordJok2(<%=r_idx%>,<%=r_tidx%>,<%=r_gbidx%>,<%=p_pubcode%>)" class="btn btn-primary">입력수정</a>
							<!-- <a href="javascript:if (confirm('입력된 점수가 변경됩니다.\n 저장하시겠습니까?') == true) {mx.inputRecordJok2(<%=r_idx%>,<%=r_tidx%>,<%=r_gbidx%>,<%=p_pubcode%>)}" class="btn btn-primary">입력수정</a> -->
							<%End if%>
						</div>
					</div>

				<%Case CONST_TYPEC 'type C ########################################################################%>
					
					<%
						If p_result = "e" Or p_result = "r" Or p_result = "d" Then
							p_st = UCase(p_result)
						End if					
					%>
					
					<div class="modal-content">
						<div class="modal-header">
							<button type="button" class="close" data-dismiss="modal" aria-hidden="true" onmousedown="mx.ssremove()">×</button>
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
										<!-- <td><input type="number" id="j_pt1" placeholder="0" value="<%=p_s1%>" class="form-control" onkeyup="mx.setTimeDeduction('j_pt1')"/></td> -->
										<td><input type="number" id="j_pt1" placeholder="0" value="<%=p_s1%>" class="form-control" onkeyup="mx.setDotAuto('j_pt1');" onblur="mx.setTimeDeduction('j_pt1',this)"/></td>
										<td><input type="number" id="j_pt2" placeholder="0" value="<%=p_s2%>" class="form-control"  readonly/></td>
										<!-- onkeyup="mx.jptSum()" onmouseup="mx.jptSum()" -->
										<td><input type="text" id="j_pttotal" class="form-control" value = "<%=p_st%>" readonly/></td>
									</tr>
								</tbdoy>
							</table>

							<table cellspacing="0" cellpadding="0" class="table table-bordered table-hover" width="100%">
								<thead>
									<tr>
										<%For i = 11 To 30%>
										<%
										If Trim(hurdleArr(i-10)) = "" Then
											Exit for
										End if
										%>
										<th style="cursor:pointer;<%If i = 11 then%>background:orange;<%End if%>" id="t_<%=i%>" onclick="$(this).parent().children().css('backgroundColor','#333333');$(this).css('backgroundColor','orange');mx.chkRnd='<%=i%>';">
										<%=hurdlearr(i-10)%>
										</th>
										<%next%>
										<th>비고</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<%For i = 11 To 30%>
										<%
										If Trim(hurdleArr(i-10)) = "" Then
											Exit for
										End If
										
										If isArray(p_judgeinputtxtarr)  Then
											If CDbl(ubound(p_judgeinputtxtarr)) >=  (i-11) then
											jvalue = p_judgeinputtxtarr(i-11)
											End if
										End if
										%>
										<td onclick="$('#t_<%=i%>').parent().children().css('backgroundColor','#333333');$('#t_<%=i%>').css('backgroundColor','orange');mx.chkRnd='<%=i%>'"><input type="text" class="form-control"  id='jm<%=i%>'  value= "<%=jvalue%>" readonly/></td>
										<%
										jvalue = ""
										next%>
										<td><input type="text" class="form-control"  id='jmbigo'  value="<%=p_bigo%>"/></td>
									</tr>
								</tbody>
							</table>



								<div class="col-md-12">
									<div class="row">

											<div class="col-md-1 text-center">
												<h5 class="row">입력값취소</h5>
												<div class="row">
													<button type="button" class="btn btn-danger" onclick="mx.setDeduction('')">취소</button>
												</div>
											</div>
											<div class="col-md-2 text-center">
												<h5 class="row">장애물 낙하</h5>
												<div class="row">
													<button type="button" class="btn btn-default"  onclick="mx.setDeduction('K')">K</button>
													<button type="button" class="btn btn-default"  onclick="mx.setDeduction('K.K')">K.K</button>
												</div>
											</div>
											<div class="col-md-2 text-center">
												<h5 class="row">1회 거부</h5>
												<div class="row">
													<button type="button" class="btn btn-default"  onclick="mx.setDeduction('1R')">1R</button>
													<button type="button" class="btn btn-default"  onclick="mx.setDeduction('1R.K')">1R.K</button>
												</div>
											</div>
											<div class="col-md-1 text-center">
												<h5 class="row">2회 거부</h5>
												<div class="row">
													<button type="button" class="btn btn-default"  onclick="mx.setDeduction('2R')">2R</button>
												</div>
											</div>
											<div class="col-md-2 text-center">
												<h5 class="row">거부,전도</h5>
												<div class="row">
													<button type="button" class="btn btn-default"  onclick="mx.setDeduction('RF')">RF</button>
													<button type="button" class="btn btn-default"  onclick="mx.setDeduction('RF.K')">RF.K</button>
												</div>
											</div>
											<div class="col-md-1  text-center">
												<h5 class="row">낙마</h5>
												<div class="row">
													<button type="button" class="btn btn-default"  onclick="mx.setDeduction('F')">F</button>
												</div>
											</div>

											<div class="col-md-3 text-center">
												<div class="col-md-2 text-center">
													<h5 class="row">실권</h5>
													<div class="row">
														<button type="button" class="btn btn-default"  onclick="mx.setDeduction('E')">E</button>
													</div>
												</div>
												<div class="col-md-3 text-center">
													<h5 class="row">기권(R)</h5>
													<div class="row">
														<button type="button" class="btn btn-default"  onclick="mx.setDeduction('R')">R</button>
													</div>
												</div>
												<div class="col-md-2 text-center">
													<h5 class="row">실격</h5>
													<div class="row">
														<button type="button" class="btn btn-default"  onclick="mx.setDeduction('D')">D</button>
													</div>
												</div>
											</div>

										</div>
									</div>


						</div>



						<div class="modal-footer">
							<%If CStr(p_st) = "0" then%>
							<a href="javascript:mx.inputRecordJok3(<%=r_idx%>,<%=r_tidx%>,<%=r_gbidx%>,<%=p_pubcode%>)" class="btn btn-primary">입력</a>
							<%else%>
							<a href="javascript:mx.inputRecordJok3(<%=r_idx%>,<%=r_tidx%>,<%=r_gbidx%>,<%=p_pubcode%>)" class="btn btn-primary">입력수정</a>
							<!-- <a href="javascript:if (confirm('입력된 점수가 변경됩니다.\n 저장하시겠습니까?') == true) {mx.inputRecordJok3(<%=r_idx%>,<%=r_tidx%>,<%=r_gbidx%>,<%=p_pubcode%>)}" class="btn btn-primary">입력수정</a> -->
							<%End if%>
						</div>
					</div>
				<%End Select%>

<%End if%>
<%'End select %>