<%
	If kgame = "" Then
		SQL = "select top 1 kgame from sd_TennisTitle where GameTitleIDX = " & tidx
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		kgame = rs("kgame") 'YN 체전여부 
	End if




	'경기순서 생성 ====================================
		'줄행으로 바꾸기

		fldnm = "a.gameMemberIDX,a.gubun,a.playeridx,a.username,a.key3name,a.tryoutgroupno,a.tryoutsortno,a.tryoutresult,a.teamAna,a.pubname,a.orgpubname,b.playeridx,b.username,a.gametime,a.gamekey3,a.requestIDX,tryoutdocYN, gametimeend, noticetitle "
		tblnm = " SD_tennisMember as a left join sd_tennisMember_partner as b ON a.gamememberidx = b.gamememberidx "

		pnmfld = ", (SELECT  STUFF(( select top 10 ','+ pnm from sd_groupMember where gameMemberIDX = a.gameMemberIDX group by pnm for XML path('') ),1,1, '' ))  as pnm " '그룹소속선수들

		SQL = "Select "&fldnm&pnmfld&" from "&tblnm&" where a.gametitleidx = " & tidx & " and a.delYN = 'N' and a.gamekey3 = '"&find_gbidx&"'  order by tryoutsortno "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.eof Then
			arrR = rs.GetRows()
			attcnt = UBound(arrR, 2) + 1
			tabletype = arrR(1,0) '2리그 , 3 토너먼트
			gno = arrR(5,0) '기본값 100이다...
			sno = arrR(6,0)

			tableno = attcnt


			If gno = "100" Then '필드 기본값이 100임 (소팅번호생성)
				Selecttbl = "( SELECT gubun,tryoutgroupno,tryoutsortNo,RANK() OVER (Order By gameMemberidx asc) AS RowNum FROM SD_tennisMember where gametitleidx =  '"&tidx&"' and gamekey3 = '"&find_gbidx&"' and delyn = 'N'  ) AS A "
				SQL = "UPDATE A  SET A.tryoutgroupno = '1', A.tryoutsortNo = A.RowNum FROM " & Selecttbl '참고 *  대진표 한번으로 끝
				Call db.execSQLRs(SQL , null, ConStr)

				
				'왼쪽메뉴 다시그려야하니까
				SQL = "Select "&fldnm&pnmfld&" from "&tblnm&" where a.gametitleidx = " & tidx & " and a.delYN = 'N' and a.gamekey3 = '"&find_gbidx&"'  order by tryoutsortno "
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				arrR = rs.GetRows() 
			End If



			


		End if
	'경기순서 생성 및====================================

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

			r_pnm = arrR(19, ari) '선수들
			If InStr(r_pnm ,",") > 0 then
			pnmarr = Split(r_pnm,",")
				pnm0 = pnmarr(0)
				pnm1 = pnmarr(1)
				pnm2 = pnmarr(2)
			End if


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
		  <input type="hidden" id="tableno" value="<%=tableno%>">


		  <tr class="gametitle_<%=r_a2%>"  style="cursor:pointer" id="titlelist_<%=idx%>">
			<td style="width:200px;text-align:center;">
				<input id="player_<%=r_a1%>" value="<%=r_a7%>" style="width:40px;text-align:center;" onkeyup="this.value=this.value.replace(/[^0-9]/g,'');mx.changeNo(<%=r_a1%>,this.value,3)">
			</td>



			<td  onclick="mx.input_edit(<%=idx%>,<%=r_a2%>,<%=r_a7%>)"><span><%=r_a4%></span></td>
		<%If r_a4 = "부전" then%>
			<td colspan="6"></td>
		<%else%>
			<td  onclick="mx.input_edit(<%=idx%>,<%=r_a2%>,<%=r_a7%>)"><span><%=r_b2%></span></td>
			<td  onclick="mx.input_edit(<%=idx%>,<%=r_a2%>,<%=r_a7%>)"><span><%=pnm0%></span></td>
			<td  onclick="mx.input_edit(<%=idx%>,<%=r_a2%>,<%=r_a7%>)"><span><%=pnm1%></span></td>
			<td  onclick="mx.input_edit(<%=idx%>,<%=r_a2%>,<%=r_a7%>)"><span><%=pnm2%></span></td>

			<td>
			<span>
					<select id="giveup_<%=idx%>" class="form-control<%If r_a8 <> "0" then%> btn-danger<%End if%>" onchange= "mx.setGiveUp(<%=tidx%>,<%=r_a14%>,<%=idx%>,<%=r_a15%>)"><!-- 개별 바로바로 저장 -->
						<option value="">==사유선택==</option>
						<option value="E" <%If r_a8 = "e" then%>selected<%End if%>>실권(E)</option>
						<option value="R" <%If r_a8 = "r" then%>selected<%End if%>>기권(R) 진행중</option>
						<option value="W" <%If r_a8 = "w" then%>selected<%End if%>>기권(W) 시작전</option>
						<option value="D" <%If r_a8 = "d" then%>selected<%End if%>>실격(D)</option>
					</select>
			</span>
			</td>

			<td>
			<span>
					<select id="giveupdoc_<%=idx%>" class="form-control" onchange= "mx.setGiveUpDoc(<%=tidx%>,<%=r_a14%>,<%=idx%>,<%=r_a15%>)"><!-- 개별 바로바로 저장 -->
						<option value="">==선택==</option>						
						<option value="Y"  <%If r_a8_1 = "Y" then%>selected<%End if%>>○</option>
						<option value="N" <%If r_a8_1 = "N" then%>selected<%End if%>>X</option>
					</select>
			</span>
			</td>
		  </tr>
	<%End if%>

<%
		Next
	End if
%>




