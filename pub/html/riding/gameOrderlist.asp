<%
  '##########################
  'ajax 호출수 고려사항
  'nowgameyear   'tidx필요 (검색된 내용)
  '##########################


	If kgame = "" Then
		SQL = "select top 1 kgame from sd_TennisTitle where GameTitleIDX = " & tidx
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		kgame = rs("kgame") 'YN 체전여부 
	End if

	attcnt = " ,(select count(*) from tblGameRequest where gametitleIDx = "&tidx&" and gbidx = a.gbidx and pubcode = a.pubcode and delYN = 'N' ) as attcnt " '신청명수
	readlattcnt = " ,(select count(DISTINCT p1_playerIDX) from tblGameRequest where gametitleIDx = "&tidx&" and gbidx = a.gbidx and pubcode = a.pubcode and delYN = 'N') as realattcnt " '실인원 중복제거

	strTableName = "  tblRGameLevel as a inner join tblTeamGbInfo as b  ON a.gbidx = b.teamgbidx "
	strfieldA = " a.RGameLevelidx,a.gameno,a.GameTitleIDX,a.GbIDX,a.pubcode,a.pubName,a.attdateS,a.attdateE,a.GameDay,a.GameTime,a.levelno,a.attmembercnt,a.fee,a.cfg "
	strfieldB = " b.TeamGbIDX,b.useyear,b.PTeamGb,b.PTeamGbNm,b.TeamGb,b.TeamGbNm,b.levelno,b.levelNm,b.ridingclass,b.ridingclasshelp,b.EnterType " & attcnt & readlattcnt & " ,okYN, a.GameTimeend "
	strfieldC = " c.sdatetime,c.edatetime,c.noticetitle,isnull(c.sortno,10000) as sno ,isNull(c.idx,0) "
	strFieldName = strfieldA &  "," & strfieldB &  "," & strfieldC
	'strFieldName = " a.gameno,c.noticetitle, isnull(c.sortno,10000) "

	strSort = "  ORDER BY a.gameno asc, sno"
	strWhere = " a.GameTitleIDX = "&tidx&" and a.DelYN = 'N' "

	leftjoinstr = " left join tblGameNotice as c On a.RgameLevelIDX = c.RgameLevelIDX "

	SQL = "Select "&strFieldName&" from "&strTableName &  leftjoinstr &  " where " & strWhere & strSort
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arrR = rs.GetRows()
	End If
	rs.close

'	strfieldC = " idx,RGameLevelidx,sdatetime,edatetime,noticetitle,sortno "
'	SQL = "Select " & strfieldC & " from tblGameNotice where tidx = " & tidx & " and (sortno < 10000 or sortno > 10000) order by sortno"
'	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'
'	If Not rs.EOF Then
'		arrSort = rs.GetRows()
'	End If
	'rs.close

	'#test################################
	'Response.write sql
	'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	'Call rsDrow(rs)
	'Response.end
	'#test################################
	

'	'부별성립여부
	SQL = "select TeamGb,realcnt,TeamGbNm from tblRealPersonNo where useyear ='"&nowgameyear&"' " 
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arrB = rs.GetRows()
	End If
	rs.close

'	'확정여부
	SQL = "select DISTINCT gbidx from tblRGameLevel where gametitleidx = " & tidx & " and okYN = 'N'  and delYN = 'N'"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	'Response.write sql
	'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arrOK = rs.GetRows()
	End If
	rs.close


	If IsArray(arrR) Then 
		For ari = LBound(arrR, 2) To UBound(arrR, 2)
			r_a1 = arrR(0, ari) 'idx
			idx = r_a1
			r_a2 = arrR(1, ari) 'gameno
			r_a3 = arrR(2, ari) 'tidx
			r_a4 = arrR(3, ari) 'gbidx
			r_a5 = arrR(4, ari) 'pubcode
			r_a6 = arrR(5, ari) 'pubname
			r_a7 = arrR(6, ari) '시작
			r_a8 = arrR(7, ari) '종료
			r_a9 = arrR(8, ari) '게임일
			r_a10 = arrR(9, ari) 'gametime (시작시간)
			r_a11 = arrR(10, ari)
			r_a12 = arrR(11, ari) 
			r_a13 = arrR(12, ari) 'fee
			r_a14 = arrR(13, ari) 'cfg

			chk1 = Left(r_a14,1)
			chk2 = Mid(r_a14,2,1)
			chk3 = Mid(r_a14,3,1)
			chk4 = Mid(r_a14,4,1)

			r_b1 = arrR(14, ari)
			r_b2 = arrR(15, ari)
			r_b3 = arrR(16, ari)
			r_b4 = arrR(17, ari) '개인/단체
			r_b5 = arrR(18, ari)  'teamgb?.............
			r_b6 = arrR(19, ari) '종목
			r_b7 = arrR(20, ari)
			r_b8 = arrR(21, ari) '마종
			r_b9 = arrR(22, ari) 'class
			r_b10 = arrR(23, ari) 'classhelp
			r_b11 = arrR(24, ari)

			r_attcnt = arrR(25, ari) ' 신청명수
			r_readlattcnt = arrR(26, ari) '실인원

			r_a15 = arrR(27, ari) 'okYN 성립완료 확정
			r_a16 = arrR(28, ari) '경기종료시간

'			r_sortno = arrR(29, ari)  '기본값
			r_c1 = arrR(29, ari)  'stime
			r_c2 = arrR(30, ari) 'etime
			r_c3 = arrR(31, ari) 'title
			r_c4 = arrR(32, ari) 'sortno
			r_c5 = arrR(33, ari) 'idx


			titlestr = r_b6 & "/" & r_b8 & "/" & r_b9 & "/" & r_b10  

			If CStr(r_a2) <> CStr(pre_gameno) Then
				trborder = "style=""border-top:2px solid red;"" "
			Else
				trborder = ""
			End If
			
			'If CStr(r_a9) <> CStr(pre_gameday) Then
			'	day_trborder = "style=""border-top:2px solid green;"" "
			'Else
			'	day_trborder = ""
			'End If
%>



<%If CDbl(r_c4) <> 10000 Then '공지인경우 표시%>

			  <tr class="gametitle_<%=r_a2%>"  style="color:green;" id="titlelist_<%=r_c4%>_<%=idx%>">
				<td  colspan = "1"><a class="btn btn-danger">공지</a></td>
				<td   colspan = "2">
				<span><%=setTimeFormat(r_c1)%></span> ~ <span><%=setTimeFormat(r_c2)%></span></td>

				<td  colspan="4"><span><%=r_c3%></span></td>
				<td ><span>
				  <a href="javascript:mx.input_edit(<%=idx%>,<%=r_a2%>,'<%=r_c4%>',<%=r_c5%>)" class="btn btn-default">선택</a><%' idx, gameno, sortno, noidx %>
				</span></td>
			  </tr>	


<%else%>


	<%If CStr(r_a2) <> CStr(pre_gameno)  Then
		If	Left(r_b5,3) = "202" Then
			typestr = "단체"
		Else
			typestr = "개인"
		End if
	
	
	%>

		  <tr class="gametitle_<%=r_a2%>"  id="titlelist_<%=r_c4%>_<%=idx%>" ><!-- style="cursor:pointer" -->
			<td <%=day_trborder%>><span><%=r_a9%></span></td>
			<td <%=trborder%>><span><%=r_a2%></span></td>
			<td <%=trborder%> >[<%=typestr%>]<span>	<%=titlestr%></span></td>

			<td <%=trborder%>>

					<div class="input-group">
					<select id="hs_<%=idx%>" class="form-control form-control-half" onchange= "mx.setTime(<%=tidx%>,<%=nowgameyear%>,'s',<%=idx%>)"><!-- 개별 바로바로 저장 -->
						<%
						s_gametime = Split(r_a10,":")
						For i = 0 To 23%>
							<option value="<%=i%>" <%If i = CDbl(s_gametime(0)) then%>selected<%End if%>><%=i%></option>
						<%next%>
					</select>
					<select id="ms_<%=idx%>" class="form-control form-control-half" onchange= "mx.setTime(<%=tidx%>,<%=nowgameyear%>,'s',<%=idx%>)"><!-- 개별 바로바로 저장 -->
						<%For i = 0 To 59%>
							<option value="<%=i%>" <%If i = CDbl(s_gametime(1)) then%>selected<%End if%>><%=i%></option>
						<%next%>
					</select>
					</div>
			
			</span></td>
			<td <%=trborder%> ><span>
					<div class="input-group">
					<select id="he_<%=idx%>" class="form-control form-control-half" onchange= "mx.setTime(<%=tidx%>,<%=nowgameyear%>,'e',<%=idx%>)"><!-- 개별 바로바로 저장 -->
						<%
						e_gametime = Split(r_a16,":")
						For i = 0 To 23%>
							<option value="<%=i%>" <%If i = CDbl(e_gametime(0)) then%>selected<%End if%>><%=i%></option>
						<%next%>
					</select>
					<select id="me_<%=idx%>" class="form-control form-control-half" onchange= "mx.setTime(<%=tidx%>,<%=nowgameyear%>,'e',<%=idx%>)"><!-- 개별 바로바로 저장 -->
						<%For i = 0 To 59%>
							<option value="<%=i%>" <%If i = CDbl(e_gametime(1)) then%>selected<%End if%>><%=i%></option>
						<%next%>
					</select>
					</div>
			</span></td>

			<td <%=trborder%>><span>
			  
			  <%
				chkst = false
				If IsArray(arrOK) Then 
					For arb = LBound(arrOK, 2) To UBound(arrOK, 2)
						chk_gb = arrOK(0, arb) '성립미성립 체크 (마장마술...) '존재하면 조정안됨...
						If CStr(r_a4) = CStr(chk_gb)  Then
							Response.write "<span style='color:red'>미정</span>" '& r_a4
							chkst = True
						End If
					Next
					If chkst = False then
						Response.write "조정완료" '& r_a4
					End if
				Else
					Response.write "조정완료"
				end if	
			  %>
			</span></td>


			<td <%=trborder%>><span>
			  <%If chkst = True then%>
			  <a href="javascript:alert('부별조정에서 완료 후 \n\n모든 조정확정 버튼을(Y)로 눌러주세요.')" class="btn btn-default"><span style="color:red">부별출전순서표</span></a><!-- 성립된것만 -->
			  <%else%>
			  <a href="javascript:px.goSubmit( {'F1':[0,1,2],'F2':['<%=nowgameyear%>','<%=tidx%>','<%=r_a4%>'],'F3':[]} , '/sc.asp');" class="btn btn-default">부별출전순서표</a><!-- 성립된것만 -->
			  <%End if%>
			</span></td>

			<td <%=trborder%>><span>
			  <a href="javascript:mx.input_edit(<%=idx%>,<%=r_a2%>,'<%=r_c4%>',<%=r_c5%>)" class="btn btn-default">선택</a><%' idx, gameno, sortno, noidx %><!-- 성립된것만 -->
			</span></td>

		  </tr>
	<%End if%>

<%End if%>








<%
		If CDbl(r_c4) = 10000 Then '공지인경우 표시
		pre_gameno = r_a2
		pre_gameday = r_a9
		End If
		
		Next
	End if
%>

