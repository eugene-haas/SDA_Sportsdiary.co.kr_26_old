<%
	If e_idx <> "" then
		%><input type="hidden" id="e_idx" value="<%=e_idx%>"><%
	End if
%>

<div class="form-group">
			<label class="control-label col-sm-1">여권번호</label>
			<div class="col-sm-2">
				<input type="text" id="mk_g0" placeholder="여권번호" value="<%=e_hpassport%>" class="form-control">
			</div>
			<label class="control-label col-sm-1">발급기관</label>
			<div class="col-sm-2">
				<input type="text" id="mk_g5" placeholder="발급기관" value="<%=e_hpassportagency%>" class="form-control">
			</div>

			<label class="control-label col-sm-1">말명</label>
			<div class="col-sm-2">
				<input type="text" id="mk_g1" placeholder="말명" value="<%=e_username%>" class="form-control">
			</div>

			<label class="control-label col-sm-1">영문명</label>
			<div class="col-sm-2">
				<input type="text" id="mk_g7" placeholder="영문이름" value="<%=e_eng_nm%>" class="form-control">
			</div>

</div>

<div class="form-group">

			<label class="control-label col-sm-1">칩번호</label>
			<div class="col-sm-2">
				<input type="text" id="mk_g2" placeholder="칩번호" value="<%=e_hchipno%>" class="form-control">
			</div>

			<label class="control-label col-sm-1">국가</label>
			<div class="col-sm-2">
				<input type="text"  id="mk_g6" class="form-control"  value="<%=e_hnation%>" placeholder="국가">
			</div>


			<label class="control-label col-sm-1">산지</label>
			<div class="col-sm-2">
				<input type="text"  id="mk_g3" class="form-control"  value="<%=e_hfield%>" placeholder="산지">
			</div>

			<label class="control-label col-sm-1">모색</label>
			<div class="col-sm-2">
				<input type="text"  id="mk_g4" class="form-control"  value="<%=e_hhairclr%>" placeholder="모색">
			</div>
</div>


<div class="form-group">

			<label class="control-label col-sm-1">성별</label>
			<div class="col-sm-2">
			<select id="mk_g8" class="form-control">
					<option value="1" <%If e_sex = "1" then%>selected<%End if%>>숫컷</option>
					<option value="2" <%If e_sex = "2" then%>selected<%End if%>>암컷</option>
					<option value="3" <%If e_sex = "3" then%>selected<%End if%>>거세마</option>
		  </select>
			</div>

			<label class="control-label col-sm-1">출생년도</label>
			<div class="col-sm-2">
				<input type="text"  id="mk_g9" class="form-control"  value="<%=e_birthday%>" placeholder="8자리" onKeyup="this.value=this.value.replace(/[^0-9,^-]/g,'');" maxlength="8">
			</div>


			<label class="control-label col-sm-1">연도별등록</label>
			<div class="col-sm-2">
				<select id="mk_g10" class="form-control">
					<%For y = year(date) To year(date) -2 Step - 1%>
					<option value="<%=y%>" <%If CStr(isNulldefault(e_nowyear,"")) = CStr(y) then%>selected<%end if%>><%=y%></option>
					<%next%>
			    </select>
			</div>

			<label class="control-label col-sm-1">종목</label>
			<%
			
			If e_hCDASTR <> "" Then
				e_cd = Split(e_hCDASTR,",")
			
					For i = 0 To ubound(e_cd)
						If e_cd(i) = "마장마술" Then
							chk1str = "checked"
						End If
						If e_cd(i) = "장애물" Then
							chk2str = "checked"
						End If
						If e_cd(i) = "종합마술" Then
							chk3str = "checked"
						End If
						If e_cd(i) = "지구력" Then
							chk4str = "checked"
						End If
						If e_cd(i) = "기타" Then
							chk5str = "checked"
						End If
					next
			End If
			%>
			<div class="col-sm-2"><%'=e_hCDASTR%>
				<label class="control-label"><input type="checkbox"  id="mk_g11"  <%=chk1str%> value="마장마술">마장마술</label>
				<label class="control-label"><input type="checkbox"  id="mk_g12"   <%=chk2str%> value="장애물">장애물</label>
				<label class="control-label"><input type="checkbox"  id="mk_g13" <%=chk3str%>   value="종합마술">종합마술</label>
				<label class="control-label"><input type="checkbox"  id="mk_g14"  <%=chk4str%>  value="지구력">지구력</label>
				<label class="control-label"><input type="checkbox"  id="mk_g15"  <%=chk5str%>  value="기타">기타</label>
			</div>
</div>


<div class="form-group">
		<label class="control-label col-sm-1">소유자</label>
		<div class="col-sm-2">
			<input type="text"  id="mk_g16" class="form-control"  value="<%=e_howner%>" placeholder="소유자">
		</div>

		<label class="control-label col-sm-1">생년월일</label>
		<div class="col-sm-2">
			<input type="text"  id="mk_g17" class="form-control"  value="<%=e_hownerbirthday%>" placeholder="8자리 숫자만" onKeyup="this.value=this.value.replace(/[^0-9,^-]/g,'');" maxlength="8">
		</div>

		<label class="control-label col-sm-1">연락처</label>
		<div class="col-sm-2">
			<input type="text"  id="mk_g18" class="form-control"  value="<%=e_userphone%>" placeholder="연락처 숫자만" onKeyup="this.value=this.value.replace(/[^0-9,^-]/g,'');" maxlength="11">
		</div>

		<label class="control-label col-sm-1">이메일</label>
		<div class="col-sm-2">
			<input type="text"  id="mk_g19" class="form-control"  value="<%=e_email%>" placeholder="8자리" >
		</div>
</div>

<div class="form-group">
		<label class="control-label col-sm-1">우편번호</label>
		<div class="col-sm-2">
			<div class="input-group">
				<input type="text" name="ZipCode" id="mk_g20" class="form-control" value="<%=e_ZipCode%>" placeholder="우편번호를 입력해주세요." readonly>
				<a href="javascript:Postcode();" class="input-group-addon btn btn-primary" > 주소찾기</a>
			</div>
		</div>

		<label class="control-label col-sm-1">주소</label>
		<div class="col-sm-2">
			<input type="text" name="Address" id="mk_g21" class="form-control"  value="<%=e_Address1%>" placeholder="주소를 입력해주세요."readonly>
		</div>

		<label class="control-label col-sm-1">상세주소</label>
		<div class="col-sm-2">
			<input type="text" name="AddrDtl" id="mk_g22" class="form-control" placeholder="상세주소를 입력해주세요." value="<%=e_Address2%>">
		</div>
</div>