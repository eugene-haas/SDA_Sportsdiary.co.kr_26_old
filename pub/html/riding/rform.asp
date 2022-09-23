<%
	If e_idx <> "" then
		%><input type="hidden" id="e_idx" value="<%=e_idx%>"><%
	End if
%>

<div class="form-group">
			<label class="control-label col-sm-1">구분</label>
			<div class="col-sm-2">
				<select id="mk_g0" class="form-control">
				<option value="J" <%If e_userType = "J" then%>selected<%End if%>>심판</option>
				<option value="S" <%If e_userType = "S" then%>selected<%End if%>>스튜어드</option>
				</select>
			</div>


			<label class="control-label col-sm-1">이름</label>
			<div class="col-sm-2">
				<input type="text" id="mk_g1" placeholder="이름" value="<%=e_username%>" class="form-control">
			</div>

			<label class="control-label col-sm-1">전화</label>
			<div class="col-sm-2">
				<input type="text" id="mk_g2" class="form-control" placeholder="전화번호" value="<%=e_userphone%>" onKeyup="this.value=this.value.replace(/[^0-9,^-]/g,'');">
			</div>

			<label class="control-label col-sm-1">생체정심판</label>
			<div class="col-sm-2">
				<input type="text" id="mk_g3" placeholder="생체정심판" value="<%=e_Ajudgelevel%>" class="form-control">
			</div>


</div>

<div class="form-group">

			<label class="control-label col-sm-1">마술등급</label>
			<div class="col-sm-2">
				<input type="text"  id="mk_g4" class="form-control"  value="<%=e_Kef1%>" placeholder="마술등급">
			</div>

			<label class="control-label col-sm-1">장애물등급</label>
			<div class="col-sm-2">
				<input type="text"  id="mk_g5" class="form-control"  value="<%=e_Kef2%>" placeholder="장애물등급">
			</div>

			<label class="control-label col-sm-1">스튜어드</label>
			<div class="col-sm-2">
				<input type="text"  id="mk_g6" class="form-control"  value="<%=e_Kef3%>" placeholder="스튜어드">
			</div>
			<label class="control-label col-sm-1">수의사</label>
			<div class="col-sm-2">
				<input type="text"  id="mk_g7" class="form-control"  value="<%=e_Kef4%>" placeholder="수의사">
			</div>
</div>




<div class="form-group">

			<label class="control-label col-sm-1">장애물레벨</label>
			<div class="col-sm-2">
				<input type="text"  id="mk_g8" class="form-control"  value="<%=e_FEI1%>" placeholder="장애물레벨">
			</div>

			<label class="control-label col-sm-1">마술스타</label>
			<div class="col-sm-2">
				<input type="text"  id="mk_g9" class="form-control"  value="<%=e_FEI2%>" placeholder="마술스타">
			</div>

			<label class="control-label col-sm-1">코스디자인레벨</label>
			<div class="col-sm-2">
				<input type="text"  id="mk_g10" class="form-control"  value="<%=e_FEI3%>" placeholder="코스디자인레벨">
			</div>
			<label class="control-label col-sm-1">마술스튜레벨</label>
			<div class="col-sm-2">
				<input type="text"  id="mk_g11" class="form-control"  value="<%=e_FEI4%>" placeholder="마술스튜어드레벨">
			</div>

</div>


<div class="form-group">

			<label class="control-label col-sm-1">마술스튜레벨</label>
			<div class="col-sm-2">
				<input type="text"  id="mk_g12" class="form-control"  value="<%=e_FEI5%>" placeholder="마술스튜레벨">
			</div>

			<label class="control-label col-sm-1">종마스튜레벨</label>
			<div class="col-sm-2">
				<input type="text"  id="mk_g13" class="form-control"  value="<%=e_FEI6%>" placeholder="종마스튜레벨">
			</div>
			<label class="control-label col-sm-1">지구스튜레벨</label>
			<div class="col-sm-2">
				<input type="text"  id="mk_g14" class="form-control"  value="<%=e_FEI7%>" placeholder="지구스튜레벨">
			</div>
			<label class="control-label col-sm-1">수의사(JDE)</label>
			<div class="col-sm-2">
				<input type="text"  id="mk_g15" class="form-control"  value="<%=e_FEI8%>" placeholder="수의사(JDE)">
			</div>

</div>


<div class="form-group">



			<label class="control-label col-sm-1">PTV</label>
			<div class="col-sm-2">
				<input type="text"  id="mk_g16" class="form-control"  value="<%=e_FEI9%>" placeholder="PTV">
			</div>

</div>