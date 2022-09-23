<%
	If kgame = "" Then
		SQL = "select top 1 kgame from sd_TennisTitle where GameTitleIDX = " & tidx
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		kgame = rs("kgame") 'YN 체전여부 
	End if

	attcnt = " ,(select count(*) from tblGameRequest where gametitleIDx = "&tidx&" and gbidx = a.gbidx and pubcode = a.pubcode and delYN = 'N' ) as attcnt " '신청수
	strTableName = "  tblRGameLevel as a inner join tblTeamGbInfo as b  ON a.gbidx = b.teamgbidx "
	strfieldA = " a.RGameLevelidx,a.gameno,a.GameTitleIDX,a.GbIDX,a.pubcode,a.pubName,a.attdateS,a.attdateE,a.GameDay,a.GameTime,a.levelno,a.attmembercnt,a.fee,a.cfg "
	strfieldB = " b.TeamGbIDX,b.useyear,b.PTeamGb,b.PTeamGbNm,b.TeamGb,b.TeamGbNm,b.levelno,b.levelNm,b.ridingclass,b.ridingclasshelp,b.EnterType " & attcnt & ",gamenostr"
	strFieldName = strfieldA &  "," & strfieldB
	strSort = "  ORDER BY gameno asc, a.pubcode , RGameLevelidx Desc"
	strWhere = " a.GameTitleIDX = "&tidx&" and a.DelYN = 'N' "

	SQL = "Select "&strFieldName&" from "&strTableName&" where " & strWhere & strSort
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

'	Call rsdrow(rs)
'	Response.end

	If Not rs.EOF Then
		arrR = rs.GetRows()
	End If




	If IsArray(arrR) Then 
		For ari = LBound(arrR, 2) To UBound(arrR, 2)
			r_a1 = arrR(0, ari) 'idx
			idx = r_a1
			r_a2 = arrR(1, ari) 'gameno
			r_a3 = arrR(2, ari)
			r_a4 = arrR(3, ari)
			r_a5 = arrR(4, ari) '부명
			r_a6 = arrR(5, ari)
			r_a7 = arrR(6, ari) '시작
			r_a8 = arrR(7, ari) '종료
			r_a9 = arrR(8, ari) '게임일
			r_a10 = arrR(9, ari)
			r_a11 = arrR(10, ari)
			r_a12 = arrR(11, ari) 
			r_a13 = arrR(12, ari) 'fee
			r_a14 = arrR(13, ari) 'cfg



			chk1 = Left(r_a14,1)
			chk2 = Mid(r_a14,2,1)
			chk3 = Mid(r_a14,3,1)
			chk4 = Mid(r_a14,4,1)

			'If chk1 = "Y" Then '사용하지말자...빈자리
			'chk1 = "체전"
			'Else
			'chk1 = "비체전"
			'End If

			r_b1 = arrR(14, ari)
			r_b2 = arrR(15, ari)
			r_b3 = arrR(16, ari)
			r_b4 = arrR(17, ari) '개인/단체
			r_b5 = arrR(18, ari) 
			r_b6 = arrR(19, ari) '종목
			r_b7 = arrR(20, ari)
			r_b8 = arrR(21, ari) '마종
			r_b9 = arrR(22, ari) 'class
			r_b10 = arrR(23, ari) 'classhelp
			r_b11 = arrR(24, ari)

			r_attcnt = arrR(25, ari) ' 신청명수

			r_gamenostr = isNullDefault(arrR(26, ari),"") ' 출력용번호


			titlestr = r_b6 & "/" & r_b8 & "/" & r_b9 & "/" & r_b10  


%>


  <tr class="gametitle_<%=r_a2%>"   id="titlelist_<%=idx%>" 
		  
		  <%If CStr(r_a2) <> CStr(pre_gameno) then%>
				style="cursor:pointer"
		  <%else%>
				style="display:none;cursor:pointer" 
		  <%End if%>
  
  >

	<td><span>
	<%If CStr(r_a2) <> CStr(pre_gameno) then%>
	[<%=r_b4%>]&nbsp;<input type="number"  value="<%=r_a2%>"  id="gameno_<%=idx%>" style="text-align:center;width:60px;"  onchange="mx.setGameNo(<%=idx%>,this.value);">
	<%End if%>
	</span></td>

	<td><span>
	<%If CStr(r_a2) <> CStr(pre_gameno) then%>
	<input type="number" maxlength="5"  value="<%=r_gamenostr%>"  id="gamenostr_<%=idx%>"  style="text-align:center;width:60px;"  onchange="mx.setGameNoStr(<%=idx%>,this.value);">
	<%End if%>
	</span></td>


<!-- 
    <td >
			<span>
				<%If CStr(r_a2) <> CStr(pre_gameno) then%>
				<label class="switch" title="신청 (사용자 참가신청) 준비 중">
				<input type="checkbox" id="attins_<%=idx%>"  value="Y" <%If chk2= "Y" then%>checked<%End if%> >
				<span class="slider round"></span>
				</label>
				<label class="switch" title="수정 (사용자 참가신청) 준비 중">
				<input type="checkbox" id="attedit_<%=idx%>"  value="Y" <%If chk3= "Y" then%>checked<%End if%>>
				<span class="slider round"></span>
				</label>
				<label class="switch" title="삭제 (사용자 참가신청)  준비 중" >
				<input type="checkbox" id="attdel_<%=idx%>"  value="Y" <%If chk4= "Y" then%>checked<%End if%>>
				<span class="slider round"></span>
				</label>
				<%End if%>
			</span>
    </td>
 -->

	<td  onclick="mx.input_edit(<%=idx%>,<%=r_a2%>)"><span>	<%If CStr(r_a2) <> CStr(pre_gameno) then%><%=titlestr%><%End if%></span></td>

	<td  onclick="mx.input_edit(<%=idx%>,<%=r_a2%>)"><span>	<%If CStr(r_a2) <> CStr(pre_gameno) then%><%=r_a9%><%End if%></span></td>


    <td  onclick="mx.input_edit(<%=idx%>,<%=r_a2%>)">	<%If CStr(r_a2) <> CStr(pre_gameno) then%><span><%=r_a7%><br><span><%=r_a8%></span><%End if%></td>

	<td  onclick="mx.input_edit(<%=idx%>,<%=r_a2%>)"><span><%=r_a6%> (<%=r_attcnt%>)</span></td>

	<td style="text-align:left;padding-left:10px;">
	<%If kgame = "Y" Then '전국체전%>
		1라운드 , 2라운드, 결승
	<%else%>
		결승
	<%End if%>
	</td>
    <td  onclick="mx.input_edit(<%=idx%>,<%=r_a2%>)"><span><%=r_a13%></span></td>

		<td>
		  <a href="javascript:mx.goplayer(<%=idx%>,'<%=levelgb%>','<%=teamgbnm%>','<%=LevelNm%>')" class="btn btn-default">신청목록</a>&nbsp;&nbsp;
		 
		  
		  
		  <%If CStr(r_a2) <> CStr(pre_gameno) then%>
		 
		  <span class="glyphicon glyphicon-plus plusIcon" onclick="mx.showtrgroup('gametitle_<%=r_a2%>', 'titlelist_<%=idx%>',this)"></span>
		  <span class="glyphicon glyphicon-minus plusIcon" style="display:none"  onclick="mx.hidetrgroup('gametitle_<%=r_a2%>', 'titlelist_<%=idx%>',this)"></span>		  
		  
		  <!-- &nbsp;&nbsp;<a href="javascript:alert('접기버튼임')" class="btn btn-default" >접기▼</a> -->
		  <%End if%>
		</td>

  </tr>
<%
		pre_gameno = r_a2
		Next
	End if
%>

