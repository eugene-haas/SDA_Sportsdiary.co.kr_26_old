<%
'#############################################

'상세종목 불러오기

'#############################################
	'request
	lidx = oJSONoutput.Get("LIDX") 'tblRGameLevel.RGameLevelidx
	ampm = "am" 'AM (파이널개념이 없으므로 모두 am으로 처리하면 됨) 예선 , 본선없음 am
	CDA = "F2" '아티스틱
	'starttype = 3

	Set db = new clsDBHelper

	'기본정보 호출
	booinfo = getBooInfo(lidx, db, ConStr, CDA)
	grouplevelidx = booinfo(0) '그룹 묶음 
	RoundCnt =  booinfo(1)'라운드수
	judgeCnt =  booinfo(2)'심사위원수
	lidxs = booinfo(3)
	cdc = booinfo(4)
	tidx = booinfo(5)



	fld = "RgameLevelidx,gametitleidx, gubunam,tryoutgamedate,tryoutgamestarttime,gameno,tryoutgameingS,gbidx,cda,cdc  " 
	gnostr = " gameno "
	tmstr = " tryoutgamestarttime " '오전 오후 구분
	gubunstr = " gubunam "
	dtstr = " tryoutgamedate "
	fldb = "b."& Replace(fld,",",",b.")


	addfld = " ,G1firstRC,G1korSin,G1gameSin,G1firstmemberSin,G2firstRC,G2KorSin,G2gameSin,G2firstmemberSin,a.itgubun "
	addfld = addfld & " ,case when a.itgubun = 'T' then (SELECT  STUFF(( select ','+ username from SD_gameMember_partner where gamememberidx = a.gamememberidx for XML path('') ),1,1, '' )) else '' end"   '파트너 있을때 단체일때 이름가져오기
	addfld = addfld & " ,tryoutsortNo2,tryoutsortNo3,tryoutsortNo4,tryoutsortNo5 " '아티스틱각라운드 소팅정보
	'addfld = addfld & " ,a_totaldeduction,a_eletotaldeduction,a_elededuction " '아티스틱 총점에서 감점, 엘리먼트총점에서 감점, 각엘리먼트에서 감점



	fld = " a.gameMemberIDX,a.gubun,a.gametime,a.gametimeend,a.place,a.PlayerIDX,a.userName,a.gbIDX,a.levelno,a.CDA,a.CDANM,a.CDB,a.CDBNM,a.CDC,a.CDCNM,a.tryoutgroupno,a.tryoutsortNo,a.tryoutstateno,a.tryoutresult,a.roundNo,a.SortNo,a.stateno,a.gameResult,a.Team,a.TeamNm,a.userClass,a.Sex,a.requestIDX     ,a.bestscore,a.bestOrder,a.bestCDBNM,a.bestidx,a.bestdate,a.besttitle,a.bestgamecode,a.bestArea,a.startType,		a.ksportsno,a.kno,a.sidonm   ,CAST(a.tryouttotalorder as int) as tryouttotalorder ,a.tryoutOrder,a.gameOrder "

	fld = fld & "," & fldb & addfld '53번부터 cda, cdc 추가 해서 2개 밀었음..

   'a.tryoutsortno > 0 순서번호가 설정된 값만 가져오자
   tbl = " SD_gameMember as a inner join tblRGameLevel as b	 ON a.gametitleidx = b.gametitleidx and a.gbidx = b.gbidx and a.delYN = 'N'  "
  
	If grouplevelidx = "0" Then '단독운영 / 묶음 운영
		sortstr = " a.tryoutsortno asc "
	else
		sortstr =  " b.gameno, a.tryoutsortno asc "
	End If	
	
	
	SQL = "select "&fld&"  from "&tbl&" where b.delyn = 'N' and a.gubun in (1,3) and a.tryoutsortno > 0 and b.RgameLevelidx in ( " & lidxs & ") order by " & sortstr
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arrR = rs.GetRows()
		l_itgubun= arrR(61,0) '단체
	End If



	'라운드별 감점 , 실격정보 ###############
	arrD = getRndDeduction(lidxs, db, ConStr)
	'Call getrowsdrow(arrD)

	'사유코드 가져오기 ###################
	arrC = getSaYouCode(CDA, db, ConStr)
%>


            <div class="box-body">

<%If IsArray(arrR) = false Then%>
<%'=SQLPrint%><br>
대진표가 작성되지 않았습니다. 
<!-- 예선이 종료되지 않았습니다. > 대회관리>부서선택>대진표설정 진행(레인배정) > 경기순서생성확인 -->
<%else%>
			  <table id="swtable_<%=lidx%>" class="table table-bordered table-hover" >
          <thead class="bg-light-blue-active color-palette">
						<tr>
								<th>순서</th>
								<th>부</th>
								<th style="width:80px;">R</th>
								<th style="width:80px;">이름</th>
								<th>이름2</th>
								<th>소속</th>
								<th>시도</th>
								<th>최종순위</th>
								<th>최종기록</th>
								<%If cdc = "04" Or cdc = "06" Or cdc = "12" then%>
								<th>테크총 / ELE총</th>
								<th>총감점</th>
								<%End if%>

								<%'If l_itgubun = "I" then%>
								<th>심사기록</th>
								<%'End if%>
								<th>사유(전체)</th>
						</tr>
					</thead>

					<%
					If cdc="02" Or cdc = "03" Then
						startr = 5
					Else
						startr = 1
					End If 

					loopcnt = RoundCnt 
						
					For r = startr To loopcnt%>	

					<tbody id="contest"  class="gametitle">
						<%

							Select Case r '라운드별로 소팅
							Case 1
							arrR = arraySort (arrR, 16, "Number", "asc" ) 
							Case 2
							arrR = arraySort (arrR, 63, "Number", "asc" ) 
							Case 3
							arrR = arraySort (arrR, 64, "Number", "asc" ) 
							Case 4
							arrR = arraySort (arrR, 65, "Number", "asc" ) 
							Case 5
							arrR = arraySort (arrR, 66, "Number", "asc" ) 
							End select

							For ari = LBound(arrR, 2) To UBound(arrR, 2)
								l_midx = arrR(0, ari) 'midx
								l_PlayerIDX= arrR(5, ari)
								l_userName= arrR(6, ari)
								l_gbIDX= arrR(7, ari)
								l_levelno= arrR(8, ari)
								l_CDA= arrR(9, ari)
								l_CDANM= arrR(10, ari)
								l_CDB= arrR(11, ari)
								l_CDBNM= arrR(12, ari)
								l_CDC= arrR(13, ari)
								l_CDCNM= arrR(14, ari)
								l_tryoutgroupno= arrR(15, ari)
								l_tryoutsortNo= arrR(16, ari)
								l_tryoutstateno= arrR(17, ari)
								l_tryoutresult= arrR(18, ari)
								l_roundNo= arrR(19, ari)
								l_SortNo= arrR(20, ari)
								l_stateno= arrR(21, ari)
								l_gameResult= arrR(22, ari)
								l_Team= arrR(23, ari)
								l_TeamNm= shortNm(arrR(24, ari))
								l_userClass= arrR(25, ari)
								l_Sex= arrR(26, ari)
								l_requestIDX= arrR(27, ari)
								l_startType = arrR(36, ari) '1 예선부터 시작 3 결승부터 시작

								'####################
								l_ksportsno = arrR(37,ari)
								l_kno = arrR(38,ari)
								l_sidonm = arrR(39,ari)
								l_tryouttotalorder	 = arrR(40, ari) '총순위  (부에 총 조에 대한 순위) 예선 결승 시작인 경우 들어간다.
								l_tryoutorder	 = arrR(41, ari) '조순위
								l_gameOrder	 = arrR(42, ari) '결과 최종순위

								l_lidx = arrR(43,ari) '부 인덱스 통합부가 있으므로 이걸로**

								l_ampm = arrR(45,ari)
								l_gamedate = arrR(46,ari)
								l_gno  = arrR(48,ari)
								l_itgubun= arrR(61,ari) '단체


								If l_itgubun = "T" then
									l_teammemberstr = arrR(62, ari)
									if InStr(l_teammemberstr,",") > 0 then
										membernm = Split(l_teammemberstr, ",")
										l_userName = membernm(0)

										If InStr(l_cdcnm, "팀") > 0 then
										l_userName2 = "외 " & ubound(membernm) & "명"
										Else
										l_userName2 = membernm(1)
										End if
									else
										l_userName = "없음"
										l_userName2 = "없음"
									end if
								End if


								chkrowno = l_tryoutgroupno
								l_raneno = l_tryoutsortNo

								l_tryoutsortNo2 = arrR(63, ari)
								l_tryoutsortNo3 = arrR(64, ari)
								l_tryoutsortNo4 = arrR(65, ari)
								l_tryoutsortNo5 = arrR(66, ari)

								'a_totaldeduction = arrR(67, ari) '아티스틱 총점에서 감점
								'a_eletotaldeduction = arrR(68, ari) '엘리먼트총점에서 감점
								'a_elededuction  = arrR(69, ari)'각엘리먼트에서 감점

								chkrowno = l_tryoutgroupno

								Select Case r
								Case 1 :	l_raneno = l_tryoutsortNo
								Case 2 :	l_raneno = l_tryoutsortNo2
								Case 3 :	l_raneno = l_tryoutsortNo3
								Case 4 :	l_raneno = l_tryoutsortNo4
								Case 5 :	l_raneno = l_tryoutsortNo5
								Case Else 
								l_raneno = l_tryoutsortNo
								End Select 



								l_result = l_tryoutresult
								l_err = ""
								
								If isNumeric(l_result) = True Then
										l_result = FormatNumber(l_tryoutresult / 10000 ,4)
								Else
										l_err = l_result
										l_result = ""
								End if


								Select Case l_CDC
								Case "01","02","03" '피겨 :솔로(Solo) 4:1
									Select Case r
									Case 1,2,3,4
									roundtext = "피겨" & r
									Case 5
									roundtext = "프리" 
									End Select 

								Case "04","06","12"  '테크니컬 1 : 1
									Select Case r
									Case 1
									roundtext = "테크니컬"
									Case 2
									roundtext = "프리"
									End Select 
								Case "05","07","11" '프리 : 1
									roundtext = "프리"
								End Select 


									'#####################################%>
											<%
											If (l_CDC  =  "04"  Or l_CDC  =  "06"  Or l_CDC  =  "12") And  (r = 2 Or r = 3 Or r = 4 Or r = 5) then
												'감춤 하나처럼 보이게
											else
											%>
												<tr class="gametitle" id="titlelist_<%=r%>_<%=l_midx%>"  style="text-align:center;">
													<td>
															<span><%=l_raneno%></span>
													</td>
														<td><%=Replace(Replace(l_CDBNM,"남자","남<br>"),"여자","여<br>")%></td>
														<td><b><%=roundtext%></b></td>
														<td><%=l_userName%></td>
														<td><%=l_userName2%></td>
														<td><%=l_TeamNm%></td>
														<td><%=l_sidoNm%></td>
														<td><%=l_tryouttotalorder%></td><%'최종순위%>

														<td><input class="form-control" type="text" id="r_<%=r%>_<%=l_raneno%>_<%=l_midx%>" style="width:100%;" value="<%=l_result%>"  readonly></td>


														<%If cdc = "04" Or cdc = "06" Or cdc = "12" then%>
														
														<%
															If IsArray(arrD) Then 
																tkdeduction_btnclass = "default"
																deduction_btnclass = "default"
																out_btnclass = "default"
																totalselectvalue = 0

																For ard = LBound(arrD, 2) To UBound(arrD, 2)
																	rndrull_midx = arrD(0, ard)
																	rndrull_totaldeduction= arrD(1, ard) '총점에서 감점
																	rndrull_eletotaldeduction= arrD(2, ard) '엘리먼트총점에서감점
																	rndrull_elededuction= arrD(3, ard) '각엘리먼트에서 감점 0.5
																	rndrull_gameround = arrD(4, ard) 
																	rndrull_tktotaldeduction= arrD(5, ard) '테크1에서 감점 0.5

																	If  CStr(rndrull_midx) = CStr(l_midx) And  CStr(r) =  CStr(rndrull_gameround)  Then
																		If CStr(rndrull_eletotaldeduction) = "25" Then '감점
																			deduction_btnclass = "danger"
																		End If
																		If CStr(rndrull_tktotaldeduction) = "5" Then '감점
																			tkdeduction_btnclass = "danger"
																		End If																		

																		totalselectvalue = rndrull_totaldeduction
																	End if
																Next
															End if
														%>
														
														<td>
														<%If r = 1 then%>
														<a href="javascript:mx.setTkTotalDeduction(<%=tidx%>,<%=lidx%>,<%=l_midx%>,<%=r%>,'<%=tkdeduction_btnclass%>')" class="btn btn-<%=tkdeduction_btnclass%>">감점 0.5</a>
														<a href="javascript:mx.setEleTotalDeduction(<%=tidx%>,<%=lidx%>,<%=l_midx%>,<%=r%>,'<%=deduction_btnclass%>')" class="btn btn-<%=deduction_btnclass%>">감점 2.5<%'=rndrull_eletotaldeduction%></a>
														<%else%>
														-
														<%End if%>
														</td>
														<td>
																<select class="form-control" style="width:100%;" id="ddd_<%=r%>_<%=l_raneno%>_<%=l_midx%>"  
																onchange="mx.setTotalDeduction(<%=tidx%>,<%=lidx%>,<%=l_midx%>,<%=r%>,$(this).val())">
																<%For i = 0 To 6 Step 0.5%>
																<option value="<%=i*10%>" <%if Cdbl(totalselectvalue) = i*10 then%>selected<%end if%> ><%=i%></option>
																<%next%>
																</select>
														</td>
														<%End if%>									

														
														<%If l_err = "" then%>
														<td><a href="javascript:mx.judgeWindow(<%=tidx%>,<%=l_lidx%>,<%=l_midx%>,<%=r%>)" class="btn btn-default">보기</a></td>
														<%else%>
														<td><button class="btn btn-default" disabled style="background:#D9D9D9;">보기</button></td>								
														<%End if%>

														<td>
																	<select class="form-control" style="width:100%;" id="x_<%=r%>_<%=l_raneno%>_<%=l_midx%>"  onchange="mx.setTotalOut(<%=tidx%>,<%=lidx%>,<%=l_midx%>,<%=r%>,$(this).val())">
																	<option value="">--</option>
																	<%
																		If IsArray(arrC) Then 
																			For arc = LBound(arrC, 2) To UBound(arrC, 2)
																				l_outCD = arrC(0, arc)
																				l_outCDNM= arrC(1, arc)
																				%><option value="<%=l_outCD%>" <%If l_err = l_outCD then%>selected<%End if%>><%=l_outCDNM%></option><%
																			Next
																		End if
																	%>
																	</select>
														</td>
												</tr>
											<%
											End if
											%>						
											<%
											prejoo = chkrowno
											%>
									<%'####################################

							Next
						%>

					</tbody>
					<%next%>

				</table>
<%End if%>

            </div>
<%

	Set rs = Nothing
	db.Dispose
	Set db = Nothing
%>