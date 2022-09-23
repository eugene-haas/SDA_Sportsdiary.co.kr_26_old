<%
	SQL = "Select sido,sidonm from tblSidoInfo  "
	Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rss.EOF Then
	arrRS = rss.GetRows()
	End If

	If e_idx <> "" then
		%><input type="hidden" id="e_idx" value="<%=e_idx%>"><%
	Else
		SQL = "select max(team) from tblTeamInfo "
		Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)
		If isNull(rss(0)) = true Then
			e_team = "ATE00001"
		Else
			tno = CDbl(Mid(rss(0), 4)) + 1
			e_team = "ATE"
			For z = 1 To 7 - Len(tno)
				e_team = e_team & "0"
			Next 
			e_team = e_team & tno
		End If
	End If
%>



<div class="form-group">


			<label class="control-label col-sm-1">팀코드</label>
			<div class="col-sm-2">
				<input type="text" id="mk_g0" placeholder="소속코드" value="<%=e_team%>" class="form-control" readonly>
			</div>


			<label class="control-label col-sm-1">팀명칭</label>
			<div class="col-sm-2">
				<input type="text" id="mk_g1" placeholder="소속명" value="<%=e_teamnm%>" class="form-control">
			</div>

			<label class="control-label col-sm-1">리더</label>
			<div class="col-sm-2">
				<input type="hidden" id="mk_g8" value="<%=e_leader_key%>" class="form-control">
				<input type="text" id="mk_g2" placeholder="지도자" value="<%=e_leader_nm%>" class="form-control">
			</div>


			<label class="control-label col-sm-1">연락처</label>
			<div class="col-sm-2">
				<input type="text" id="mk_g3" class="form-control" placeholder="전화번호" value="<%=e_phone%>" onKeyup="this.value=this.value.replace(/[^0-9,^-]/g,'');">
			</div>


</div>

<div class="form-group">

			<label class="control-label col-sm-1">지역</label>
			<div class="col-sm-2">
					<select id="mk_g4" class="form-control" >
					<%
						If IsArray(arrRS) Then 
							For ari = LBound(arrRS, 2) To UBound(arrRS, 2)
								l_sido = arrRS(0, ari)
								l_sidonm = arrRs(1,ari)
								%><option value="<%=l_sido%>" <%If e_sido = l_sido then%>selected<%End if%>><%=l_sidonm%></option><%
							Next
						End if
					%>
					</select>
			</div>

			<label class="control-label col-sm-1">우편번호</label>
			<div class="col-sm-2">
				<div class="input-group">
					<input type="text" name="ZipCode" id="mk_g5" class="form-control" value="<%=e_ZipCode%>" placeholder="우편번호를 입력해주세요." readonly>
					<a href="javascript:Postcode();" class="input-group-addon btn btn-primary" > 주소찾기</a>
				</div>
			</div>


			<label class="control-label col-sm-1">주소</label>
			<div class="col-sm-2">
				<input type="text" name="Address" id="mk_g6" class="form-control"  value="<%=e_Address1%>" placeholder="주소를 입력해주세요."readonly>
			</div>


			<label class="control-label col-sm-1">상세주소</label>
			<div class="col-sm-2">
				<input type="text" name="AddrDtl" id="mk_g7" class="form-control" placeholder="상세주소를 입력해주세요." value="<%=e_Address2%>">
			</div>

</div>
