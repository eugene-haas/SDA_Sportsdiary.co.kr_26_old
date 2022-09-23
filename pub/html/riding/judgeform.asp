	<%
	Select case  CStr(select_f_teamgb )
	case "20101"
	%>
	<div class="info_serch form-horizontal" id="gameinput_area">
		<div class="form-group">


			<div class="col-sm-3">
				<label class="col-sm-12 control-label text-left" style="text-align:left;">심사지점</label>
				<!-- <div class="col-sm-2" style="width:200px;"> -->
				<div class="col-sm-12">

					<div class="input-group" id="judgePname">
							<label class="control-label"><input type="checkbox" id="mk_g0"  value="B" <%If select_f_B = "Y" then%>checked<%End if%>>&nbsp;B</label>
							<label class="control-label">&nbsp;<input type="checkbox" id="mk_g1"  value="E"  <%If select_f_E = "Y" then%>checked<%End if%>>&nbsp;E</label>
							<label class="control-label">&nbsp;<input type="checkbox" id="mk_g2"  value="M"  <%If select_f_M = "Y" then%>checked<%End if%>>&nbsp;M</label>
							<label class="control-label">&nbsp;<input type="checkbox" id="mk_g3"  value="C"  <%If select_f_C = "Y" then%>checked<%End if%>>&nbsp;C</label>
							<label class="control-label">&nbsp;<input type="checkbox" id="mk_g4"  value="H"  <%If select_f_H = "Y" then%>checked<%End if%>>&nbsp;H</label>
					</div>

				</div>
			</div>

				<%If Select_f_teamgbnm = "장애물" And select_f_classhelp = CONST_TYPEA_1 then%>
				<label class="control-label col-sm-1" style="width:120px;">최적시간(초)</label>
				<div class="col-sm-2" style="width:140px;">
					<input type="number" id="mk_g8" placeholder="최적시간 입력" value="<%=select_f_bestsc%>" class="form-control">
				</div>
				<%End if%>

			<div class="col-sm-3">
				<label class="control-label col-sm-12" style="text-align:left;">지점별 최고 기록 가능점수</label>

				<div class="col-sm-10">

					<div class="input-group">
						<input type="number" id="mk_g5" placeholder="지점별최고 기록 가능점수 입력" value="<%=select_f_judgemaxpt%>" class="form-control">
						<span class="input-group-btn">
							<a href="javascript:mx.setRecordInit(<%=tidx%>,<%=find_gbidx%>)" class="btn btn-primary">적용</a>
						</span>
					</div>

				</div>
			</div>


			<div class="col-sm-3">
				<div class="input-group" id="judgePname">
					<label class="control-label" onmouseup="mx.setExceptMax(<%=tidx%>,<%=find_gbidx%>)" ><input type="checkbox" id="mk_g9"  value="Y"  <%If select_f_MAX = "Y" then%>checked<%End if%>>&nbsp;최고점제외</label>
					<label class="control-label" onmouseup="mx.setExceptMin(<%=tidx%>,<%=find_gbidx%>)" >&nbsp;<input type="checkbox" id="mk_g10"  value="Y" <%If select_f_MIN = "Y" then%>checked<%End if%>>&nbsp;최저점제외</label>
				</div>
				<div class="input-group">
					<label class="control-label"  onmouseup="mx.setSign(<%=tidx%>,<%=find_gbidx%>)" ><input type="checkbox" id="mk_g6"  value="Y" <%If select_f_judgesignYN = "Y" then%>checked<%End if%>>&nbsp;심판장 서명 완료</label>
					<%If select_f_teamgb <> "20103" then%>
					<label class="control-label"  onmouseup="mx.setShow(<%=tidx%>,<%=find_gbidx%>)">&nbsp;<input type="checkbox" id="mk_g7"  value="Y"  <%If select_f_judgeshowYN = "Y" then%>checked<%End if%>  >&nbsp;지점별 기록 노출</label>
					<%End if%>

				</div>
			</div>


		</div>
	</div>

	<%
	Case  "20102"
		If select_f_classhelp = CONST_TYPEA_1 Then
	%>
	<div class="info_serch form-horizontal" id="gameinput_area">
		<div class="form-group">

			<label class="control-label col-sm-1" style="width:120px;">최적시간(초)</label>
			<div class="col-sm-2" style="width:140px;">
				<input type="number" id="mk_g8" placeholder="최적시간 입력" value="<%=select_f_bestsc%>" class="form-control">
			</div>

			<div class="col-sm-2">
				<a href="javascript:mx.setRecordInit2(<%=tidx%>,<%=find_gbidx%>)" class="btn btn-primary">적용</a>
			</div>

		</div>
	</div>
	<%
		End If

	Case "20103" ' 복합마술
		If sel_orderType = "MM" Then
		%>
			<div class="info_serch form-horizontal" id="gameinput_area">
				<div class="form-group">


					<div class="col-sm-3">
						<label class="col-sm-12 control-label text-left" style="text-align:left;">심사지점</label>
						<div class="col-sm-12">
							<div class="input-group" id="judgePname">
									<label class="control-label"><input type="checkbox" id="mk_g0"  value="B" <%If select_f_B = "Y" then%>checked<%End if%>>&nbsp;B</label>
									<label class="control-label">&nbsp;<input type="checkbox" id="mk_g1"  value="E"  <%If select_f_E = "Y" then%>checked<%End if%>>&nbsp;E</label>
									<label class="control-label">&nbsp;<input type="checkbox" id="mk_g2"  value="M"  <%If select_f_M = "Y" then%>checked<%End if%>>&nbsp;M</label>
									<label class="control-label">&nbsp;<input type="checkbox" id="mk_g3"  value="C"  <%If select_f_C = "Y" then%>checked<%End if%>>&nbsp;C</label>
									<label class="control-label">&nbsp;<input type="checkbox" id="mk_g4"  value="H"  <%If select_f_H = "Y" then%>checked<%End if%>>&nbsp;H</label>
							</div>
						</div>
					</div>

						<%If Select_f_teamgbnm = "장애물" And select_f_classhelp = CONST_TYPEA_1 then%>
						<label class="control-label col-sm-1" style="width:120px;">최적시간(초)</label>
						<div class="col-sm-2" style="width:140px;">
							<input type="number" id="mk_g8" placeholder="최적시간 입력" value="<%=select_f_bestsc%>" class="form-control">
						</div>
						<%End if%>

					<div class="col-sm-3">
						<label class="control-label col-sm-12" style="text-align:left;">지점별 최고 기록 가능점수</label>

						<div class="col-sm-10">

							<div class="input-group">
								<input type="number" id="mk_g5" placeholder="지점별최고 기록 가능점수 입력" value="<%=select_f_judgemaxpt%>" class="form-control">
								<span class="input-group-btn">
									<a href="javascript:mx.setRecordInit(<%=tidx%>,<%=find_gbidx%>)" class="btn btn-primary">적용</a>
								</span>
							</div>

						</div>
					</div>


					<div class="col-sm-3">
						<div class="input-group" id="judgePname">
							<label class="control-label" onmouseup="mx.setExceptMax(<%=tidx%>,<%=find_gbidx%>)" ><input type="checkbox" id="mk_g9"  value="Y"  <%If select_f_MAX = "Y" then%>checked<%End if%>>&nbsp;최고점제외</label>
							<label class="control-label" onmouseup="mx.setExceptMin(<%=tidx%>,<%=find_gbidx%>)" >&nbsp;<input type="checkbox" id="mk_g10"  value="Y" <%If select_f_MIN = "Y" then%>checked<%End if%>>&nbsp;최저점제외</label>
						</div>
						<div class="input-group">
							<label class="control-label"  onmouseup="mx.setSign(<%=tidx%>,<%=find_gbidx%>)" ><input type="checkbox" id="mk_g6"  value="Y" <%If select_f_judgesignYN = "Y" then%>checked<%End if%>>&nbsp;심판장 서명 완료</label>
		
							<%If select_f_teamgb <> "20103" then%>							
							<label class="control-label"  onmouseup="mx.setShow(<%=tidx%>,<%=find_gbidx%>)">&nbsp;<input type="checkbox" id="mk_g7"  value="Y"  <%If select_f_judgeshowYN = "Y" then%>checked<%End if%>  >&nbsp;지점별 기록 노출</label>
							<%End if%>

						</div>
					</div>


				</div>
			</div>		
		<%
		Else
			If select_f_classhelp = CONST_TYPEA_1 Then
				%>
				<div class="info_serch form-horizontal" id="gameinput_area">
					<div class="form-group">

						<label class="control-label col-sm-1" style="width:120px;">최적시간(초)</label>
						<div class="col-sm-2" style="width:140px;">
							<input type="number" id="mk_g8" placeholder="최적시간 입력" value="<%=select_f_bestsc%>" class="form-control">
						</div>

						<div class="col-sm-2">
							<a href="javascript:mx.setRecordInit2(<%=tidx%>,<%=find_gbidx%>)" class="btn btn-primary">적용</a>
						</div>

					</div>
				</div>
				<%
			End if
		End if
	End Select
	%>
