<%
	If hasown(oJSONoutput, "IDX") = "ok" Then  'gameMemberIDX
		midx = chkStrRpl(oJSONoutput.get("IDX"),"")
	End If

	ampm = chkStrRpl(oJSONoutput.get("AMPM"),"")
	rc = chkStrRpl(oJSONoutput.get("RC"),"")
	gameorder = chkStrRpl(oJSONoutput.get("ORDER"),"")
	rane = chkStrRpl(oJSONoutput.get("RANE"),"")



	Set db = new clsDBHelper


	SQL = "Select a.cda,a.cdb,a.cdc,a.cdbnm,a.cdcnm,b.RoundCnt,b.judgeCnt,tryoutresult,rgamelevelidx from sd_gameMember as a inner join tblRGameLevel as b "
	SQL = SQL & " ON a.gametitleidx = b.gametitleidx and a.gbidx = b.gbidx where a.gameMemberIDX = " & midx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	if not rs.eof then
		CDA = rs(0)
		CDB = rs(1)
		CDC = rs(2)				
		CDBNM = rs(3)
		CDCNM = rs(4)
		roundCnt = rs(5) '라운드수
		judgeCnt = rs(6) '심판수
		tryoutresult = rs(7)
		lidx = rs(8)
		If isNumeric(tryoutresult) = True Then
				select case CDA
				case "E2" 
				tryoutresult = FormatNumber(tryoutresult / 100 ,2)
				case "F2"
				tryoutresult = FormatNumber(tryoutresult / 10000 ,4)
				end select
		Else
			SQL = "select code,codeNm from tblCode  where gubun = 2 and CDA = '"&cda&"' and code = '"&tryoutresult&"' and delyn = 'N'  order by sortno asc"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			If Not rs.EOF Then
					tryoutresult = rs(1)
			end if
		End if		
	end if

Dim jumsu_arr(16)
	select case CDA
	case "D2"
		sectionwhere = " a.delyn = 'N' and a.gameMemberIDX = '"&midx&"' "
		SQL = "select b.*,a.username from sd_gameMember as a left join sd_gameMember_sectionRecord as b on a.gameMemberIDX = b.gameMemberidx and b.AMPM = '"&Ucase(ampm)&"' where " & sectionwhere
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.EOF Then
			userName = rs("username")
			if isNull(rs(0)) = false Then
				arrSec = rs.GetRows()
			else
				'구간기록 정보가 없습니다.
			end if
		else
			'구간기록 정보가 없습니다.
		End if
		title = "구간기록"
	case "E2"
		title = "라운드기록"
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
				Call oJSONoutput.Set("result", 1 )
				strjson = JSON.stringify(oJSONoutput)
				Response.Write strjson
				Response.End
			End If


	case "F2"
		title = "라운드기록"	
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
				Call oJSONoutput.Set("result", 1 )
				strjson = JSON.stringify(oJSONoutput)
				Response.Write strjson
				Response.End
			End If

	end select
%>
		<div class="m_searchPopup__control" style="text-align:center;">
			<span style="color:#000;font-size:16px;font-weight:bold;"><br><%=title%></span>
    </div>

    <div class="m_searchPopup__panelWrap [ _sliderWrap ] s_filtering">
      <div class="box" style="width:100%;">
				
				<%
				select case CDA
				case "D2"				
				%>
					
					<%'#######################################################%>
					<div class="box-header" style="padding:10px;">
						<table>
							<thead class="bg-light-blue-active color-palette" style="background:#3F505C;color:#ffffff;">
								<tr>
									<th>순위</th>
									<th>레인</th>
									<th>선수명</th>
									<th>기록</th>
								</tr>
							</thead>
							<tbody>
								<tr style="height:35px;">
									<td><%=gameorder%></td>
									<td><%=rane%></td>
									<td><%=userName%></td>
									<td><%call SetRC(rc)%></td>
								</tr>
							</tbody>
						</table>
					</div>

					<div class="box-body" style="margin-top:10px;padding:10px;overflow-y: auto;height:56vh;"   >
					<table>
						<thead class="bg-light-blue-active color-palette" style="background:#3F505C;color:#ffffff;">
								<tr>
									<th>구간</th>
									<th>구간기록</th>
									<th>기록</th>
								</tr>
						</thead>
						<tbody>
								<%
								If IsArray(arrSec) Then
									For si = LBound(arrSec, 2) To UBound(arrSec, 2)

										s_gameMemberidx = arrSec(1, si)
										s_ampm = arrSec(2, si)

										'if Cstr(midx) = Cstr(s_gameMemberidx) and Lcase(s_ampm) = Lcase(ampm) Then
										s_sectionno = arrSec(3,si) '마지막 저장된 필드번호

										'필드 루프 생성
											s_sectionfldno = s_sectionno/50
											for f = 1 to s_sectionfldno
												s_sectionfld = f * 50
												s_sectionrc = arrSec(3 + f ,si)
												s_gamerc = arrSec(33 + f, si)
												%>
													<tr style="height:35px;">
														<td><%=s_sectionfld%>m</td>
														<td><%call SetRC(s_sectionrc)%></td>
														<td><%call SetRC(s_gamerc)%></td>
													</tr>
												<%
											next

										'end if

									Next
								End if
								%>
						</tbody>
					</table>
					</div>
					<%'#######################################################%>

				<%case "E2"%>

					<%'#######################################################%>
					<div style="color:#000;font-size:16px;font-weight:bold;text-align:center;margin-top:3px;"><%=CDBNM%> | <%=CDCNM%></div>
					<div class="box-header" style="padding:10px;margin-bottom:10px;">
						<table>
							<thead class="bg-light-blue-active color-palette" style="background:#3F505C;color:#ffffff;">
								<tr>
									<%
									If IsArray(arrR) Then 
											p_itgubun = arrR(thisno + 11,0) 
											p_teamnm = arrR(thisno + 17,0)
											p_name = arrR(thisno + 1,0)														
									end if
									%>
									
									<th><%If p_itgubun = "T" then%><%=p_teamnm%><%else%><%=p_name%> (<%=p_teamnm%>)<%End if%></th>
									<th width="80px;"><%=tryoutresult%></th>
								</tr>
							</thead>
						</table>
					</div>

					<div class="box-body" style="margin-top:10px;padding:10px;overflow-y: auto;height:56vh;"   >
					<table>
						<thead class="bg-light-blue-active color-palette" style="background:#3F505C;color:#ffffff;">
						<tbody>
											<%
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
														if isnumeric(j_totalscore) = true then
															j_totalscore = FormatNumber(j_totalscore/100 ,2)   '소수점 2자리
														else
															j_totalscore = ""
														end if											
											%>
														<tr>
															<td style="border:none;">
																		<table style="margin-top:10px;">
																			<thead class="bg-light-blue-active color-palette" style="background:#3F505C;color:#ffffff;">
																				<tr>
																						<th>R</th>
																						<th>다이브<br>번호</th>
																						<th>높이</th>
																						<th>자세</th>
																						<th>난이도</th>																						
																						<th>합계</th>
																				</tr>
																			</thead>
																			<tbody>
																				<tr style="height:35px;">
																					<td><%=j_roundno%></td>
																					<td><%=j_code1%></td>
																					<td><%=j_code3%></td>
																					<td ><%=j_code2%></td>
																					<td ><%=j_code4%></td>
																					<td style="vertical-align:middle;text-align:center;"><%=j_totalscore%></td>
																				</tr>
																				<tr>
																					<td colspan="6" style="text-align:center;background:#CFCFCF"><b><%=j_codename%></b></td>
																				</tr>								
																			</tbody>
																		</table>
															</td>
														</tr>
														<tr>
															<td style="border:none;">
																		<table>
																			<tr>
																				<% '심판그리는 영역
																				For j = 1 To judgeCnt 
																					'소수점찍어서 가져오기
																					jumsu = isnulldefault(jumsu_arr(j)/10,"")
																					%>
																						<td style="padding:1px;">
																								<%if jumsu = "" then%>&nbsp;<%else%><%=jumsu%><%end if%>
																						</td>
																					<%
																				next
																				%>
																			</tr>
																		</table>
															</td>
														</tr>
											<%
												Next
											End if
											%>
						</tbody>
					</table>
					</div>
					<%'#######################################################%>




				<%case "F2" '테크니컬 듀엣 , 팀 자동계산되는 피겨영역을 따로 그려주어야할까 (패스하고) - 일딴여기까지만..%>
					<%'#######################################################%>
					<div style="color:#000;font-size:16px;font-weight:bold;text-align:center;margin-top:3px;"><%=CDBNM%> | <%=CDCNM%></div>
					<div class="box-header" style="padding:10px;margin-bottom:10px;">
						<table>
							<thead class="bg-light-blue-active color-palette" style="background:#3F505C;color:#ffffff;">
								<tr>
									<%
									If IsArray(arrR) Then 
											p_itgubun = arrR(thisno + 11,0) 
											p_teamnm = arrR(thisno + 17,0)
											p_name = arrR(thisno + 1,0)														
									end if
									%>
									
									<th><%If p_itgubun = "T" then%><%=p_teamnm%><%else%><%=p_name%> (<%=p_teamnm%>)<%End if%></th>
									<th width="80px;"><%=tryoutresult%></th>
								</tr>
							</thead>
						</table>
					</div>

					<div class="box-body" style="margin-top:10px;padding:10px;overflow-y: auto;height:56vh;"   >
					<table>
						<tbody>
											<%
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
														if isnumeric(j_totalscore) = true then
															j_totalscore = FormatNumber(j_totalscore/10000 ,4)   '소수점 4자리
														else
															j_totalscore = ""
														end if

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
															<td style="border:none;">
																		<table style="margin-top:10px;">
																			<thead class="bg-light-blue-active color-palette" style="background:#3F505C;color:#ffffff;">
																				<tr>
																						<th>R</th>
																						<th>난이도<br>번호</th>
																						<th>난이도명</th>
																						<th>난이도</th>
																						<th>합계</th>
																				</tr>
																			</thead>
																			<tbody>
																				<tr style="height:35px;">
																					<td><%=roundtext%></td>
																					<td><%=j_code1%></td>
																					<td><%=j_code2%></td>
																					
																					<%Select Case roundtext%>
																					<%Case   "피겨1","피겨2","피겨3","피겨4" %>
																						<td ><%=j_code4%></td><%'난이도%>
																					<%Case   "E1","E2","E3","E4","E5" %>
																						<td ><%=j_code4%></td><%'난이도%>
																					<%Case   "프리" %>
																						<td >-</td><%'난이도%>
																					<%End Select%>
																				
																					<%Select Case roundtext%>
																					<%Case   "E2","E3","E4","E5" %>	
																					<td style="vertical-align:middle;text-align:center;">&nbsp;</td>
																					<%Case else%>
																					<td style="vertical-align:middle;text-align:center;"><%=j_totalscore%></td>
																					<%End select%>
																				</tr>
																				<tr>
																					<td colspan="5" style="text-align:center;background:#CFCFCF"><b><%=j_codename%></b></td>
																				</tr>								
																			</tbody>
																		</table>
															</td>
														</tr>
														
														<tr>
															<td style="border:none;">

																		<table>
																			<tr>

																				<% '심판그리는 영역
																				For j = 1 To judgeCnt 

																					'소수점찍어서 가져오기
																					jumsu = isnulldefault(jumsu_arr(j)/10,"")
																					%>
																					
																					<%If roundtype = "피겨" And j > 7 then%>								
																					
																					<%else%>
																						<td style="padding:1px;">
																							<%Select Case roundtext%>
																							<%Case   "E2","E3","E4","E5" '엘리먼트 열이라면%>																

																								<%If j > partno * 2 then%>
																								<%if jumsu = "" then%>&nbsp;<%else%><%=jumsu%><%end if%>
																								<%End if%>
																							<%Case else%>
																								<%if jumsu = "" then%>&nbsp;<%else%><%=jumsu%><%end if%>
																							<%End Select%>
																						</td>
																					<%End if%>
																					<%
																				next
																				%>

																			</tr>
																		</table>
															</td>
														</tr>


														<%End if%>
											<%
												Next
											End if
											%>
						</tbody>
					</table>
					</div>
					<%'#######################################################%>
				<%end select%>								
			</div>    
		</div>



<%


	Call db.Dispose()
	Set rs = Nothing
	Set db = Nothing
%>
