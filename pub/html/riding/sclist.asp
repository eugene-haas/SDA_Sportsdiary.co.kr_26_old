<%
	If kgame = "" Then
		SQL = "select top 1 kgame from sd_TennisTitle where GameTitleIDX = " & tidx
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		kgame = rs("kgame") 'YN 체전여부 
	End if


	sortstr = " a.tryoutsortno,a.tryoutgroupno, a.pubcode, a.orgpubcode asc "
	'sortstr = " a.tryoutsortno,a.tryoutgroupno, a.username, b.username asc "
	tblnm = " SD_tennisMember as a left join sd_tennisMember_partner as b ON a.gamememberidx = b.gamememberidx "
	fldnm = "a.gameMemberIDX,a.gubun,a.playeridx,a.username,a.key3name,a.tryoutgroupno,a.tryoutsortno,a.tryoutresult,a.teamAna,a.pubname,a.orgpubname,b.playeridx,b.username,a.gametime,a.gamekey3,a.requestIDX,tryoutdocYN, gametimeend, noticetitle "
	SQL = "Select "&fldnm&" from "&tblnm&" where a.gametitleidx = " & tidx & " and a.delYN = 'N' and a.gamekey3 = '"&find_gbidx&"' and round=1 order by " & sortstr
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


	'Response.write sql
		
	'Call rsdrow(rs)
	'Response.end

	If Not rs.EOF Then
		arrR = rs.GetRows()
	End If

	'Call getrowsdrow(arrR)



	If IsArray(arrR) Then 
		For ari = LBound(arrR, 2) To UBound(arrR, 2)

			r_a1 = arrR(0, ari) 'idx
			idx = r_a1
			r_a2 = arrR(1, ari) 'gubun   0 순서설정전 1(순서설정완료 : 비체전인경우) 100 '공지사항 이름은 sc playeridx = 0 순서번호는 ? a.tryoutsortno,a.tryoutgroupno 1번위라면 0 100부터 
			r_a3 = arrR(2, ari)' pidx
			r_a4 = arrR(3, ari) 'unm
			r_a5 = arrR(4, ari) '종목
			r_a6 = arrR(5, ari) '경기 그룹번호 (체전이아니면 이것만사용)
			r_a7 = arrR(6, ari) '출전순서

			r_a8 = arrR(7, ari) '최종결과 (기권/실격포함)
			r_a8_1 = arrR(16, ari) '문서제출여부

			r_a9 = arrR(8, ari) '소속
			r_a10 = arrR(9, ari) '통합부명
			r_a11 = arrR(10, ari) '참가부명
			r_b1 = arrR(11, ari) 'pidx 말
			r_b2 = arrR(12, ari) '말명칭
			r_a12 = arrR(13, ari) ' 경기시간

			r_a14 = arrR(14, ari) 'gbidx
			r_a15 = arrR(15, ari) 'requestIDX 참가신청 인덱스

			r_endtime = arrR(17, ari) '공지종료시간
			r_notice = arrR(18, ari) '공지사항


			If r_a12 <> "" And isnull(r_a12) = false then
				r_gametime = Split(Left(setTimeFormat(r_a12),5),":")
				r_hh = r_gametime(0)
				r_mm = r_gametime(1)
			Else
				r_hh = 0
				r_mm = 0
			End if

			If r_endtime <> "" And isnull(r_endtime) = false then
				r_gametimeend = Split(Left(setTimeFormat(r_endtime),5),":")
				r_ehh = r_gametimeend(0)
				r_emm = r_gametimeend(1)
			Else
				r_ehh = 0
				r_emm = 0
			End if
%>

<%If r_a2 = "100" then%>

		  <tr class="gametitle_<%=r_a2%>"  style="cursor:pointer" id="titlelist_<%=idx%>" style="border:1px dot red;">
			<td  onclick="mx.input_edit(<%=idx%>,<%=r_a2%>,<%=r_a7%>)"><a class="btn btn-danger">일정</a></td>
			<td  onclick="mx.input_edit(<%=idx%>,<%=r_a2%>,<%=r_a7%>)"><span style="color:red;"><%=r_hh%>:<%=r_mm%> ~ <%=r_ehh%>:<%=r_emm%></span></td>
			<td colspan="7" onclick="mx.input_edit(<%=idx%>,<%=r_a2%>,<%=r_a7%>)" style="text-align:left;color:green;padding-left:10px;"><span><%=r_notice%></span></td>
		  </tr>

<%else%>

		  <tr class="gametitle_<%=r_a2%>"  style="cursor:pointer" id="titlelist_<%=idx%>">
			<td style="width:200px;text-align:center;">
			<div class="input-group">

			<%If CDbl(r_a2) = 0 then%>
				<%=r_a7%>
			<%Else '출전순서부여후 순서 변경 할수 있도록 변경%>
				
				<%If InStr(r_a5,"릴레이") > 0 then%>
					<%=r_a7%>
				<%else%>
					<input type="number" id="order_<%=idx%>" value="<%=r_a7%>" class="form-control"  style="width:100px;">
					<a href="javascript:mx.setOrderNo( <%=idx%>,<%=tidx%>,<%=find_gbidx%>,$('#order_<%=idx%>').val() );" class="btn btn-primary" >변경</a>
					<!-- 출전순서변경 시간도 -->
				<%End if%>

			<%End if%>
			</div>
			</td>


			<%If r_a5 = "마장마술" Or gametype = "BMMM" Then '복합마술 마장마술%>
			<td >
					<div class="input-group">
					<select id="hg_<%=idx%>" class="form-control form-control-half" onchange= "mx.setTime(<%=tidx%>,<%=r_a14%>,'g',<%=idx%>)"><!-- 개별 바로바로 저장 -->
						<%For i = 0 To 23%>
							<option value="<%=i%>" <%If i = CDbl(r_hh) then%>selected<%End if%>><%=i%></option>
						<%next%>
					</select>
					<select id="mg_<%=idx%>" class="form-control form-control-half" onchange= "mx.setTime(<%=tidx%>,<%=r_a14%>,'g',<%=idx%>)"><!-- 개별 바로바로 저장 -->
						<%For i = 0 To 59%>
							<option value="<%=i%>" <%If i = CDbl(r_mm) then%>selected<%End if%>><%=i%></option>
						<%next%>
					</select>
					</div>			
			</td>
			<%End if%>


			<td onclick="mx.input_edit(<%=idx%>,<%=r_a2%>,<%=r_a7%>)"><span><%=r_a10%><!-- 초,중등부 --></span></td>

			<td  onclick="mx.input_edit(<%=idx%>,<%=r_a2%>,<%=r_a7%>)"><span><%=r_a4%></span></td>
			<td  onclick="mx.input_edit(<%=idx%>,<%=r_a2%>,<%=r_a7%>)"><span><%=r_b2%><!-- 분더바엔지 --></span></td>

			<td onclick="mx.input_edit(<%=idx%>,<%=r_a2%>,<%=r_a7%>)"><%=r_a9%><!-- 원곡중학교 --></span></td>
			<td onclick="mx.input_edit(<%=idx%>,<%=r_a2%>,<%=r_a7%>)"><%If r_a11 = "" then%><%=r_a10%><%else%><%=r_a11%><%End if%><!-- 중등부 --></span></td>



			<td  ><span>
					<%'tryoutresult tryoutdocYN (N)%>
					<select id="giveup_<%=idx%>" class="form-control<%If r_a8 <> "0" then%> btn-danger<%End if%>" onchange= "mx.setGiveUp(<%=tidx%>,<%=r_a14%>,<%=idx%>,<%=r_a15%>)"><!-- 개별 바로바로 저장 -->
						<option value="">==사유선택==</option>
						<option value="E" <%If r_a8 = "e" then%>selected<%End if%>>실권(E)</option>
						<option value="R" <%If r_a8 = "r" then%>selected<%End if%>>기권(R) 진행중</option>
						<option value="W" <%If r_a8 = "w" then%>selected<%End if%>>기권(W) 시작전</option>
						<option value="D" <%If r_a8 = "d" then%>selected<%End if%>>실격(D)</option>
					</select>
			</span></td>

			<td  ><span>
					<select id="giveupdoc_<%=idx%>" class="form-control" onchange= "mx.setGiveUpDoc(<%=tidx%>,<%=r_a14%>,<%=idx%>,<%=r_a15%>)"><!-- 개별 바로바로 저장 -->
						<option value="">==선택==</option>						
						<option value="Y"  <%If r_a8_1 = "Y" then%>selected<%End if%>>○</option>
						<option value="N" <%If r_a8_1 = "N" then%>selected<%End if%>>X</option>
					</select>
			</span></td>
		  </tr>
<%End if%>

<%
		pre_gameno = r_a2
		pre_gameday = r_a9
		Next
	End if
%>




