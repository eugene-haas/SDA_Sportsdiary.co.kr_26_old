<%
'#############################################
' 선수관리, 신청정보 관리에 나오는 선수별 랭킹 포인트 기록 및 수정 화면
'#############################################

'request
idx = oJSONoutput.IDX
name = oJSONoutput.NAME

'대회신청정보 수정에서 오면 받는다.
If hasown(oJSONoutput, "LEVELNO") = "ok" then
	levelno = oJSONoutput.LEVELNO
Else
	levelno = ""
End If

If hasown(oJSONoutput, "TIDX") = "ok" then
	tidx = oJSONoutput.TIDX
Else
	tidx = ""
End If

If hasown(oJSONoutput, "TITLE") = "ok" then
	title = oJSONoutput.TITLE
Else
	title = ""
End If

If hasown(oJSONoutput, "PTYPE") = "ok" then
	ptype = oJSONoutput.PTYPE
Else
	ptype = 1
End If


Set db = new clsDBHelper


SQL = "select userName,UserPhone,belongboo,sex,birthday,team,teamnm,team2,team2nm,gameday,dblrnk,openrnkboo,chkLevel,chkTIDX,endRnkDate from tblPlayer where playerIDX = " & idx
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

If rs.eof Then
	Response.write "검색 내용 없음"
	Response.end
Else
	uname = rs("username")
	uphone = rs("userPhone")
	uphoneno = Replace(uphone,"-","")
	ubelongboo = rs("belongboo")
	usex = rs("sex")
	ubirth = rs("birthday")
	uteam1 = rs("team")
	uteam1nm = rs("teamnm")
	uteam2 = rs("team2")
	uteam2nm = rs("team2nm")
	gameday = rs("gameday")
	dblrnk = rs("dblrnk")
	openrnkboo = rs("openrnkboo")
	If isnull(openrnkboo) = True Then
		openrnkboo = ""
	End If
	chklevel = rs("chkLevel")
	chkTIDX = rs("chkTIDX") '0 이면 일시승급
	endRnkDate = rs("endRnkDate") '임의승급자 종료날짜



End If

	If dblrnk = "Y" Then '	'만약 우승자라면
		Select Case  chklevel
		Case "20101"
			myrnkboo = "개나리부"
			boopttitle = "<th>개나리부</th><th>국화부</th>"
			xmax = 2

		Case "20105","20104","20106" ,"20103"
			myrnkboo = "신인부"  '오픈, 신인, 왕중왕, 베테랑부
			boopttitle = "<th>신인부</th><th>오픈부</th><th>베테랑부</th>"
			xmax = 3

		Case Else
			'이런경우는 없다... 혹모르니 에러안나도록
			myrnkboo = chklevel
			boopttitle = "<th>"&chklevel&"</th>"
			xmax = 1

		End Select
	else

		xmax = 1
		Select Case  openrnkboo
		Case "신인부"
			myrnkboo = "신인부"
			boopttitle = "<th>신인부</th>"

		Case "베테랑부"
			myrnkboo = "베테랑부"
			boopttitle = "<th>신인부</th>"

		Case else

			SQL = "select top 1 teamGbName, count(*) from sd_TennisRPoint_log where ptuse= 'Y' and PlayerIDX = "&idx&"  group by teamGbName order by 2 desc"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			Do Until rs.eof

				myattboo = rs(0)
				Select Case myattboo
				Case "개나리부"
					myrnkboo = "개나리부"
					boopttitle = "<th>개나리부</th>"
				Case "국화부"
					myrnkboo = "국화부"
					boopttitle = "<th>국화부</th>"

				Case "베테랑부"
					myrnkboo = "베테랑부"
					boopttitle = "<th>베테랑부</th>"

				Case "신인부" : myrnkboo = "신인부"
				Case "단체전","오픈부","왕중왕부"
					myrnkboo = "오픈부"
					boopttitle = "<th>오픈부</th>"

				Case Else
					 myrnkboo = "랭킹없음"
					boopttitle = "<th>랭킹없음</th>"
					'포인트가 없다면
				End Select

			rs.movenext
			Loop
		End Select

	end if


	'이건 남자부만 발생할수 있다.
	'중복 중 놉은 점수의 것의 인덱스 찾기
	subSQL = "SELECT titlename FROM sd_TennisRPoint_log where ptuse= 'Y' and PlayerIDX = "&idx&" group by titlename HAVING COUNT(titlename) > 1" '중복타이틀 찾기
	SQL = "select titlename from sd_TennisRPoint_log  where ptuse= 'Y' and PlayerIDX = "&idx&" and titlename in ("&subSQL&")  order by titlename, getpoint desc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arrRS = rs.GetRows()
	End If

	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

'Call rsdrow(rs)


	strfield = "titleName as '대회명' ,teamGbName as '출전부서',rankno as '순위',getpoint as '포인트',ptuse as '반영', gamedate as '게임일자'  "
	SQL = "select "&strfield&"  from sd_TennisRPoint_log  where ptuse= 'Y' and PlayerIDX = "&idx&" order by getpoint desc, gamedate desc  "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

'#############################################

	arrb =  listBoo()


%>

<div class="modal-dialog">
	<div class="modal-content">


  <div class='modal-header game-ctr'>
    <button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
    <h3 id='myModalLabel'><%=name%>

		<%If gameday <> "" And dblrnk = "Y" then%>
			<%If chkTIDX = "0" then%>
				<span style="font-size:14px;color:orange;">일시승급 <%=gameday%> ~ <%=Left(endRnkDate,10)%></span>
			<%else%>
				<span style="font-size:14px;color:orange;">&nbsp;승급 : <%=gameday%> </span>
			<%End if%>
		<%End if%>
		&nbsp; 랭킹부 : <%=myrnkboo%>

		<%If title <> "" then%>[<%=title%>]<%End if%></h3>
  </div>

	<div class='modal-body'>
		<div class="scroll_box table-box" style="">
		<%
				orderA = 1
				orderB = 1
				orderC = 1
				totalA = 0
				totalB = 0
				totalC = 0
				rscnt = Rs.Fields.Count
			    overrapcnt = 0
				response.write "<table class='table-list' border='1'>"
				Response.write "<thead id=""headtest"">"
				For i = 0 To rscnt - 1
					response.write "<th>"& Rs.Fields(i).name &"</th>"
				Next
				Response.write boopttitle & "</thead>"

				ReDim rsdata(rscnt) '필드값저장

				Do Until rs.eof

					For i = 0 To rscnt - 1
						rsdata(i) = rs(i)
					Next
					%>
						<tr class="gametitle">
							<%
								overcolor = ""
								okpt = True

								For i = 0 To rscnt - 1

									If i = 0 then
									If IsArray(arrRS) Then
									  For ar = LBound(arrRS, 2) To UBound(arrRS, 2)
										  overrap = arrRS(0, ar) '중복타이틀

										  If rsdata(i) = overrap Then

												If overrapcnt = 0  then
													okpt = true
													overcolor = "style = 'background:green;color:yellow;' "

													If  pre = "" Or overrap = pre Then
														overrapcnt = 1
													Else
														overrapcnt = 0
													End If
													pre = overrap
													Exit For
												Else
													okpt = false
													overcolor = "style = 'background:orange;color:yellow;' "
													If  pre = "" Or overrap = pre Then
														overrapcnt = 1
													Else
														overrapcnt = 0
													End If

													pre = overrap

												End If

										  End If

									  Next



									End If
									End if


									If dblrnk = "Y" then
										If i = 5 And Left(rsdata(i),10) = Left(gameday,10)    Then
											Response.write "<td style='color:red'>" & rsdata(i)    & "</td>"
										else
											If i = 0 Or i = 3 then
											Response.write "<td "&overcolor&">" & rsdata(i)   & "</td>"

											ElseIf i = 2 Then '점수

												'일시승급자 순위 칼라 대회
												If chkTIDX = "0" And CDbl(rsdata(i)) < 5 And CDate(Left(rsdata(5),10)) <= CDate(Left(gameday,10))  Then
													Response.write "<td style='background:yellow;'>" & rsdata(i)   & "</td>"
												Else
													Response.write "<td>" & Replace(rsdata(i),"512","<span style='color:blue'>참가</span>")   & "</td>"
												End if

											Else
												Response.write "<td>" & rsdata(i)   & "</td>"
											End if
										End If
									Else
											If i = 0 Or i = 3 then
											Response.write "<td "&overcolor&">" & rsdata(i)   & "</td>"
											Else
											Response.write "<td>" & rsdata(i)   & "</td>"
											End if
									End if

									If i = 1 Then '출전부
										xboonm = rsdata(i)
									End If

									If i = 2 Then '순위
										xorder = rsdata(i)
									End If

									If i = 3 Then '포인트
										xpoint = rsdata(i)
									End If
									If i = 5 Then '게임데이트
										xdate = rsdata(i)
									End If

									If i = 5 Then '게임일자 다음에 그리기

										For x = 1 To xmax

											If dblrnk = "Y" then
												Select Case  myrnkboo
												Case "개나리부"
													Select Case x '여자는 중복참여불가
													Case 1
														If orderA <= 15 then
														Response.write "<td>" &  xpoint & " | " & orderA & "</td>"
														totalA = totalA + xpoint
														orderA = orderA + 1
														Else
														Response.write "<td>" &  xpoint  & "</td>"
														End if
													Case 2
														If xboonm = "국화부" then
															If  CDate(Left(xdate,10)) > CDate(Left(gameday,10)) Then
																If orderB <= 15 then
																	Response.write "<td>" &  xpoint & " | " & orderB & "</td>"
																	totalB = totalB + xpoint
																	orderB = orderB + 1
																Else
																	Response.write "<td>" &  xpoint & "</td>"
																End if
															Else
																Response.write "<td>&nbsp;</td>"
															End If
														Else
															Response.write "<td>&nbsp;</td>"
														End if
													End Select
												Case "신인부"
													Select Case x
													Case 1
														If orderA <= 15 Then
															If okpt = True then
																Response.write "<td>" &  xpoint & " | " & orderA & "</td>"
																totalA = totalA + xpoint
																orderA = orderA + 1
															Else
																Response.write "<td>" &  xpoint & "</td>"
															End if
														Else
															Response.write "<td>" &  xpoint  & "</td>"
														End if
													Case 2
														If xboonm = "오픈부" Or xboonm = "왕중왕부" then
															If  CDate(Left(xdate,10)) > CDate(Left(gameday,10)) Then
																If orderB <= 15 then
																	Response.write "<td>" &  xpoint & " | " & orderB & "</td>"
																	totalB = totalB + xpoint
																	orderB = orderB + 1
																Else
																	Response.write "<td>" &  xpoint & "</td>"
																End if
															Else
																Response.write "<td>&nbsp;</td>"
															End If
														Else
															Response.write "<td>&nbsp;</td>"
														End if
													Case 3
															Response.write "<td>&nbsp;</td>"
													End Select

												Case Else
													'베테랑
													If orderA <= 15 then
													Response.write "<td>" &  xpoint & " | " & orderA & "</td>"
													totalA = totalA + xpoint
													orderA = orderA + 1
													Else
													Response.write "<td>" &  xpoint  & "</td>"
													End if
												End Select
											Else
												If orderA <= 15 then
													If okpt = True Then '중복참여처리
														Response.write "<td>" &  xpoint & " | " & orderA & "</td>"
														totalA = totalA + xpoint
														orderA = orderA + 1
													Else
														Response.write "<td>" &  xpoint  & "</td>"
													End if
												Else
													Response.write "<td>" &  xpoint  & "</td>"
												End if
											End if
										Next

									End if

								Next
							%>
						</tr>
					<%
				rs.movenext
				Loop

				If Not rs.eof then
				rs.movefirst
				End if


				Response.write "<tr>"
				For i = 1 To rscnt
					If i = 1 Then
					Response.write "<td>랭킹포인트(상위15)</td>"
					else
					Response.write "<td>&nbsp;</td>"
					End if
				Next
				For x = 1 To xmax
					Select Case x
					Case 1: 	Response.write "<td>"&totalA&"</td>"
					Case 2: 	Response.write "<td>"&totalB&"</td>"
					Case 3: 	Response.write "<td>"&totalC&"</td>"
					End select
				Next

				Response.write "</tr>"


				Response.write "</tbody>"
				Response.write "</table>"
		%>




			<%
			'Call rsDrow(rs)
			%>




		<%
					'플레이어	Case 20103 '베테랑부
					'선수의 반영 부서가 베테랑 부라면 오픈부값을 추가한다.
		'			SQL = "select openrnkboo from tblplayer where playerIDX = " & idx & " and openrnkboo in ( '베테랑부', '신인부') "
		'			Set rsr = db.ExecSQLReturnRS(SQL , null, ConStr)
		'			If Not rsr.eof Then
		'				boo_nm = rsr(0)
		'				If boo_nm = "베테랑부" then
		'				SQL = "select max(teamGbName) as '출전부서',  sum(getpoint) as '상위 15개(오픈부포함) 포인트'  from sd_TennisRPoint_log as a where idx in ( Select top 15 idx from sd_TennisRPoint_log where  ptuse= 'Y' and PlayerIDX = "&idx&" and teamGbName in ('베테랑부', '오픈부') order by getpoint desc ) "
		'				Else
		'				SQL = "select max(teamGbName) as '출전부서',  sum(getpoint) as '상위 15개(오픈부포함) 포인트'  from sd_TennisRPoint_log as a where idx in ( Select top 15 idx from sd_TennisRPoint_log where  ptuse= 'Y' and PlayerIDX = "&idx&" and teamGbName in ('신인부', '오픈부','왕중왕부') order by getpoint desc ) "
		'				End if
		'				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		'				If isNull(rs(1)) = false then
		'				Call rsDrow(rs)
		'				End if
		'			End if
		'
		'
		'		If IsArray(arrb) Then
		'			For arp = LBound(arrb, 2) To UBound(arrb, 2)
		'				boocode = arrb(0, arp)
		'				booname = arrb(1,arp)
		'
		'				SQL = "select max(teamGbName) as '출전부서',  sum(getpoint) as '상위 15개 포인트'  from sd_TennisRPoint_log as a where idx in ( Select top 15 idx from sd_TennisRPoint_log where  ptuse= 'Y' and PlayerIDX = "&idx&" and teamGb = "&boocode&" order by getpoint desc ) "
		'				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		'				If isNull(rs(1)) = false then
		'				Call rsDrow(rs)
		'				End if
		'			Next
		'		End if


		db.Dispose
		Set db = Nothing
		%>

		</div>

		<hr />

		<div id="rankplayerinfo">
			<h4>선수정보변경</h4>
			<div class="alert alert-info"><%=uname%></div>

			<div id="sel_VersusGb" >
				<input type="hidden" id="u_idx" value="<%=idx%>">
				<input type="hidden" id="u_name" value="<%=uname%>">

				<div class="form-group">
					<select  id="u_boo" class="form-control">
						<option value="개나리부"  <%If ubelongBoo = "개나리부" then%>selected<%End if%>>개나리부</option>
						<option value="국화부"  <%If ubelongBoo = "국화부" then%>selected<%End if%>>국화부</option>
						<option value="신인부"  <%If ubelongBoo = "신인부" then%>selected<%End if%>>신인부</option>
						<option value="오픈부"  <%If ubelongBoo = "오픈부" then%>selected<%End if%>>오픈부</option>
						<option value="베테랑부"  <%If ubelongBoo = "베테랑부" then%>selected<%End if%>>베테랑부</option>
					</select>
				</div>

				<div class="form-group">
					<select name="u_sex" id="u_sex" class="form-control">
						<option value="Man"  <%If usex = "Man" then%>selected<%End if%>>남</option>
						<option value="WoMan"  <%If usex = "WoMan" then%>selected<%End if%>>여</option>
					</select>
				</div>

				<div class="form-group">
					<input type="text"  id="u_birth"  maxlength="8" placeholder="ex)19880725" class="form-control" value="<%=ubirth%>" >
				</div>
				<div class="form-group">
					<input type="text" id="u_phone" value="<%=uphone%>" class="form-control" placeholder="ex)01000000000" >
				</div>

				<div class="form-group">
					<label>1팀</label><input type="text" id="u_team1nm" class="form-control" value ="<%=uteam1nm%>">
				</div>
				<div class="form-group">
					<label>2</label>팀<input type="text" id="u_team2nm" class="form-control" value ="<%=uteam2nm%>">
				</div>


				<div class="btn-group">

				</div>


			</div>
		</div>

	</div>

	<div class="modal-footer">
		<button type="button" data-dismiss='modal' aria-hidden='true' class="btn">닫기</button>
		<% If tidx <> "" AND levelno <> "" Then %>
			<% If tidx <> 0 AND levelno <> 0 Then %>
			<a href="javascript:mx.playeredit(<%=idx%>,<%=tidx%>,<%=levelno%>, <%=ptype%>)" class="btn btn-primary">선수 정보 수정<span>[참가신청, 선수정보, 대진정보]</span></a>

			<% Else %>
			<a href="javascript:mx.playeredit(<%=idx%>,0,0)" class="btn btn-primary">선수 정보 수정<span>[선수정보]</span></a>

			<% End If %>
		<% Else %>
			<a href="javascript:mx.playeredit(<%=idx%>,0,0)" class="btn btn-primary">선수 정보 수정 <span>[선수정보]</span></a>
		<% End If %>
	</div>

	</div>
</div>
