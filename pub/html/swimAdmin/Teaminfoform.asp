<%If TeamIDX <> "" then%>
	<input type="hidden" id="TeamIDX" value="<%=TeamIDX%>">
<%End if%>



		<!-- <div class="alert alert-info col-sm-offset-1 col-sm-10">팀정보 기본정보</div> -->

<div class="form-group">


			<label class="control-label col-sm-1">팀코드</label>
			<div class="col-sm-2">
				<input type="text" name="Team" id="Team" class="form-control" value="<%=Team%>" readonly>
			</div>



			<label class="control-label col-sm-1">팀명칭</label>
			<div class="col-sm-2">
				<input type="text" name="TeamNm" id="TeamNm" class="form-control" placeholder="팀명칭을 입력해주세요." value="<%=TeamNm%>">
			</div>

			<label class="control-label col-sm-1">비밀번호</label>
			<div class="col-sm-2">
				<input type="text" id="TeamLoginPwd" name="TeamLoginPwd"  class="form-control" value="<%=TeamLoginPwd%>" readonly/>
			</div>


			<label class="control-label col-sm-1">연락처</label>
			<div class="col-sm-2">
				<input type="text" id="TeamTel" name="TeamTel"  class="form-control" value="<%=TeamTel%>"/>
			</div>


</div>

<div class="form-group">
			<label class="control-label col-sm-1">지역</label>
			<div class="col-sm-2">
				<select  name="sido" id="sido" class="form-control" disabled>
					<option value="01" <% if sido="01" then %> selected<% end if%> >서울</option>
					<option value="02" <% if sido="02" then %> selected<% end if%> >부산</option>
					<option value="03" <% if sido="03" then %> selected<% end if%> >대구</option>
					<option value="04" <% if sido="04" then %> selected<% end if%> >인천</option>
					<option value="05" <% if sido="05" then %> selected<% end if%> >광주</option>
					<option value="06" <% if sido="06" then %> selected<% end if%> >대전</option>
					<option value="07" <% if sido="07" then %> selected<% end if%> >울산</option>
					<option value="08" <% if sido="08" then %> selected<% end if%> >경기</option>
					<option value="09" <% if sido="09" then %> selected<% end if%> >강원</option>
					<option value="10" <% if sido="10" then %> selected<% end if%> >충북</option>
					<option value="11" <% if sido="11" then %> selected<% end if%> >충남</option>
					<option value="12" <% if sido="12" then %> selected<% end if%> >전북</option>
					<option value="13" <% if sido="13" then %> selected<% end if%> >전남</option>
					<option value="14" <% if sido="14" then %> selected<% end if%> >경북</option>
					<option value="15" <% if sido="15" then %> selected<% end if%> >경남</option>
					<option value="16" <% if sido="16" then %> selected<% end if%> >제주</option>
					<option value="50" <% if sido="50" then %> selected<% end if%> >세종</option>
				</select>
			</div>

			<label class="control-label col-sm-1">우편번호</label>
			<div class="col-sm-2">
				<div class="input-group">
					<input type="text" name="ZipCode" id="ZipCode" class="form-control" value="<%=ZipCode%>" placeholder="우편번호를 입력해주세요." readonly>
					<a href="javascript:Postcode();" class="input-group-addon btn btn-primary" > 주소찾기</a>
				</div>
			</div>


			<label class="control-label col-sm-1">주소</label>
			<div class="col-sm-2">
				<input type="text" name="Address" id="Address" class="form-control"  value="<%=Address%>" placeholder="주소를 입력해주세요."readonly>
			</div>


			<label class="control-label col-sm-1">상세주소</label>
			<div class="col-sm-2">
				<input type="text" name="AddrDtl" id="AddrDtl" class="form-control" placeholder="상세주소를 입력해주세요." value="<%=AddrDtl%>">
			</div>

	</div>
