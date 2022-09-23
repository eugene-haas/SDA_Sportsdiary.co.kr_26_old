<%
'대회 주최/주관
	SQL = "Select hostname,gubun from tblGameHost where DelYN = 'N' order by gubun asc"
	Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rss.EOF Then
	arrRS = rss.GetRows()
	End If

	'대회그룹/등급
	SQL = "Select titleCode,titleGrade,hostTitle,idx from sd_TennisTitleCode where  DelYN = 'N' "
	Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rss.EOF Then
	arrRSG = rss.GetRows()
	End If

	If e_idx <> "" then
		%><input type="hidden" id="e_idx" value="<%=e_idx%>"><%
	End If
%>

		<div class="form-group">
			<label class="col-sm-1 control-label">국제/체전</label>
			<div class="col-sm-2">
				<div class="input-group">
					<select id="mk_g0" class="form-control form-control-half">
						<option value="K" <%If e_gameNa = "" Or e_gameNa = "K" then%>selected<%End if%>>국내&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</option>
						<option value="F" <%If e_gameNa = "F" then%>selected<%End if%>>국제</option>
					</select>
					<select id="mk_g1" class="form-control form-control-half" >
						<option value="N" <%If e_kgame = "" Or e_kgame = "N" then%>selected<%End if%>>N</option>
						<option value="Y" <%If e_kgame = "Y" then%>selected<%End if%>>Y</option>
					</select>
				</div>

			</div>

			<label class="col-sm-1 control-label">장소</label>
			<div class="col-sm-2">
				<input type="text" id="mk_g2" placeholder="경기장소를 입력해주세요." value="<%=e_GameArea%>" class="form-control">
			</div>

			<label class="col-sm-1 control-label">주최/주관</label>
			<div class="col-sm-2">
				<div class="input-group">
					<select id="mk_g3" class="form-control form-control-half">
						<option value="">==선택==</option>
						<%
						If IsArray(arrRS) Then
							For ar = LBound(arrRS, 2) To UBound(arrRS, 2)
								h_hostname = arrRS(0, ar)
								h_gubun = arrRS(1, ar)

								If h_gubun = "1" then
									%><option value="<%=h_hostname%>" <%If h_hostname = e_hostname then%>selected<%End if%>><%=h_hostname%></option><%
								End if
							Next
						End if
						%>
					</select>
					<select id="mk_g4" class="form-control form-control-half">
						<option value="">==선택==</option>
						<%
						If IsArray(arrRS) Then
							For ar = LBound(arrRS, 2) To UBound(arrRS, 2)
								h_subjectnm = arrRS(0, ar)
								h_gubun = arrRS(1, ar)

								If h_gubun = "2" then
									%><option value="<%=h_subjectnm%>" <%If h_subjectnm = e_subjectnm then%>selected<%End if%>><%=h_subjectnm%></option><%
								End if
							Next
						End if
						%>
					</select>
				</div>

			</div>
			<label class="col-sm-1 control-label">후원</label>
			<div class="col-sm-2">
				<input type="text" id="mk_g5" placeholder="후원사 입력" value="<%=Replace(e_afternm,"`",",")%>" class="form-control">
			</div>
		</div>

		<div class="form-group">

			<label class="col-sm-1 control-label">대회명</label>
			<div class="col-sm-2">
				<input type="text" name="mk_g6" id="mk_g6" class="form-control" placeholder="대회명을 입력해주세요." value="<%=e_GameTitleName%>" >
			</div>

			<label class="col-sm-1 control-label">그룹/등급</label>
			<div class="col-sm-2">
				<select  id="mk_g7" class="form-control">
					<option value="">==선택==</option>
						<%
						If IsArray(arrRSG) Then
							For ar = LBound(arrRSG, 2) To UBound(arrRSG, 2)
								g_titleCode = arrRSG(0, ar)
								g_titleGrade = arrRSG(1, ar)
								g_hostTitle = arrRSG(2, ar)
'								Select Case g_titleGrade
'								Case "1" : t_titleGrade = "SA"
'								Case "2" : t_titleGrade = "GA"
'								Case "3" : t_titleGrade = "A"
'								Case "4" : t_titleGrade = "B"
'								Case "5" : t_titleGrade = "C"
'								Case "6" : t_titleGrade = "단체전"
'								Case "7" : t_titleGrade = "E"
'								Case "8" : t_titleGrade = "비노출"
'								End Select
								%><option value="<%=g_titleCode%>_<%=g_titleGrade%>"  <%If g_titleCode = e_titleCode then%>selected<%End if%>><%=g_hostTitle%></option><%
							Next
						End if
						%>
				</select>
			</div>
		</div>

		<div class="form-group">
			<label class="col-sm-1 control-label">대회구분</label>
			<div class="col-sm-3">
				<div class="input-group">
						<label class="control-label"><input type="checkbox" id="mk_g8"  value="Y" <%If e_gameTypeE = "Y" then%>checked<%End if%>>&nbsp;전문</label>
						<label class="control-label">&nbsp;<input type="checkbox" id="mk_g9"  value="Y"  <%If e_gameTypeA = "Y" then%>checked<%End if%>>&nbsp;생활</label>
						<label class="control-label">&nbsp;<input type="checkbox" id="mk_g10"  value="Y"  <%If e_gameTypeL = "Y" then%>checked<%End if%>>&nbsp;유소년</label>
				</div>
			</div>

			<label class="col-sm-1 control-label">개인/단체</label>
			<div class="col-sm-3">
				<div class="input-group">
					<label class="control-label"><input type="checkbox" id="mk_g11"  value="Y"  <%If e_gameTypeP = "Y" then%>checked<%End if%>>&nbsp;개인</label>
					<label class="control-label">&nbsp;<input type="checkbox" id="mk_g12"  value="Y"  <%If e_gameTypeG = "Y" then%>checked<%End if%>>&nbsp;단체</label>
				</div>
			</div>
		</div>

		<div class="form-group">
			<label class="col-sm-1 control-label">시작일</label>
			<div class="col-sm-2">
				<div class='input-group date'>
					<input type="text" id="mk_g13" value="<%=e_GameS%>" class="form-control">
					<span class="input-group-addon">
						<span class="glyphicon glyphicon-calendar"></span>
					</span>
				</div>
			</div>
			<label class="col-sm-1 control-label">종료일</label>
			<div class="col-sm-2">
				<div class='input-group date'>
					<input type="text" id="mk_g14"  value="<%=e_GameE%>"  class="form-control">
					<span class="input-group-addon">
						<span class="glyphicon glyphicon-calendar"></span>
					</span>
				</div>				
			</div>
		</div>




		<div class="btn-group flr" role="group" aria-label="...">
			<a href="#" class="btn btn-primary" id="btnsave" onclick="mx.input_frm();" accesskey="i">등록<span>(I)</span></a>
			<a href="#" class="btn btn-primary" id="btnupdate" onclick="mx.update_frm();" accesskey="e">수정<span>(E)</span></a>
			<a href="#" class="btn btn-danger" id="btndel" onclick="mx.del_frm();" accesskey="r">삭제<span>(R)</span></a>
		</div>
