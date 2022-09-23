<%
	Select case  CStr(select_f_teamgb )
	case "20101","20201" '마장마술
	%>
	<div class="row">
		<div class="col-sm-12">

			<label class="control-label" onmouseup="mx.setExceptMax(<%=tidx%>,<%=find_gbidx%>)" ><input type="checkbox" id="mk_g9"  value="Y"  <%If select_f_MAX = "Y" then%>checked<%End if%>>&nbsp;최고점제외</label>
			<label class="control-label" onmouseup="mx.setExceptMin(<%=tidx%>,<%=find_gbidx%>)" >&nbsp;<input type="checkbox" id="mk_g10"  value="Y" <%If select_f_MIN = "Y" then%>checked<%End if%>>&nbsp;최저점제외</label>

			<label class="control-label"  onmouseup="mx.setSign(<%=tidx%>,<%=find_gbidx%>)" ><input type="checkbox" id="mk_g6"  value="Y" <%If select_f_judgesignYN = "Y" then%>checked<%End if%>>&nbsp;심판장 서명 완료</label>
			<%If select_f_teamgb <> "20103" then%>
			<label class="control-label"  onmouseup="mx.setShow(<%=tidx%>,<%=find_gbidx%>)">&nbsp;<input type="checkbox" id="mk_g7"  value="Y"  <%If select_f_judgeshowYN = "Y" then%>checked<%End if%>  >&nbsp;지점별 기록 노출</label>
			<%End if%>

			<label class="control-label" >지점별 최고 기록 가능점수</label><label class="control-label" ><input type="number" id="mk_g5" placeholder="지점별최고 기록 가능점수 입력" value="<%=select_f_judgemaxpt%>" readonly>
			<a href="javascript:mx.setRecordInit(<%=tidx%>,<%=find_gbidx%>)" class="btn btn-primary">적용</a>
			</label>

		</div>
	</div>

	<div class="form-group">
		<hr>
		<table width="100%" border="1"  id="judgePname">
		<tr>
			<td><label class="control-label"><input type="checkbox" id="mk_g0"  value="B" <%If select_f_B = "Y" then%>checked<%End if%>>&nbsp;B</label></td>
			<td><label class="control-label">&nbsp;<input type="checkbox" id="mk_g1"  value="E"  <%If select_f_E = "Y" then%>checked<%End if%>>&nbsp;E</label></td>
			<td><label class="control-label">&nbsp;<input type="checkbox" id="mk_g2"  value="M"  <%If select_f_M = "Y" then%>checked<%End if%>>&nbsp;M</label></td>
			<td><label class="control-label">&nbsp;<input type="checkbox" id="mk_g3"  value="C"  <%If select_f_C = "Y" then%>checked<%End if%>>&nbsp;C</label></td>
			<td><label class="control-label">&nbsp;<input type="checkbox" id="mk_g4"  value="H"  <%If select_f_H = "Y" then%>checked<%End if%>>&nbsp;H</label></td>
			<td><a href="javascript:mx.setJudge('A',1,<%=tidx%>,<%=select_f_ridx%>)">스튜어드</a></td>
		</tr>
		<tr>
			<td><a href="javascript:mx.setJudge('B',1,<%=tidx%>,<%=select_f_ridx%>)">심판</a><br><a href="javascript:mx.setJudge('B',2,<%=tidx%>,<%=select_f_ridx%>)">스크라이버</a></td>
			<td><a href="javascript:mx.setJudge('E',1,<%=tidx%>,<%=select_f_ridx%>)">심판</a><br><a href="javascript:mx.setJudge('E',2,<%=tidx%>,<%=select_f_ridx%>)">스크라이버</a></td>
			<td><a href="javascript:mx.setJudge('M',1,<%=tidx%>,<%=select_f_ridx%>)">심판</a><br><a href="javascript:mx.setJudge('M',2,<%=tidx%>,<%=select_f_ridx%>)">스크라이버</a></td>
			<td><a href="javascript:mx.setJudge('C',1,<%=tidx%>,<%=select_f_ridx%>)">심판</a><br><a href="javascript:mx.setJudge('C',2,<%=tidx%>,<%=select_f_ridx%>)">스크라이버</a></td>
			<td><a href="javascript:mx.setJudge('H',1,<%=tidx%>,<%=select_f_ridx%>)">심판</a><br><a href="javascript:mx.setJudge('H',2,<%=tidx%>,<%=select_f_ridx%>)">스크라이버</a></td>
			<td><a href="javascript:mx.setJudge('A',2,<%=tidx%>,<%=select_f_ridx%>)">Sit-in</a><br><a href="javascript:mx.setJudge('A',3,<%=tidx%>,<%=select_f_ridx%>)">Shadow</a></td>
		</tr>
		</table>
	</div>
	<%
	Case  "20102","20202" '장애물 최적시간
		Select Case select_f_classhelp 
		Case CONST_TYPEA_1
	%>
	<div class="form-group">
		<table width="100%" border="1">
		<tr><!-- select_f_ridx 여러개가 나올수 있다 tidx gbidx 로 전체를 대변해서 구해야한다 .중요  -->
			<td><a href="javascript:mx.setJudge('B',1,<%=tidx%>,<%=select_f_ridx%>)">심판장</a></td>
			<td><a href="javascript:mx.setJudge('E',1,<%=tidx%>,<%=select_f_ridx%>)">벨심판</a></td>
			<td><a href="javascript:mx.setJudge('M',1,<%=tidx%>,<%=select_f_ridx%>)">계시심판</a></td>
			<td><a href="javascript:mx.setJudge('C',1,<%=tidx%>,<%=select_f_ridx%>)">기록심판</a></td>
			<td><a href="javascript:mx.setJudge('A',1,<%=tidx%>,<%=select_f_ridx%>)">스튜어드</a></td>

			<td>
				<a href="javascript:mx.setHurdle(<%=tidx%>,<%=find_gbidx%>,'<%=select_f_classhelp%>',1)" class="btn btn-primary">장애물 기준 및 배치정보</a> 
			</td>
		
		</tr>
		</table>
	</div>
	

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
		case else
			%>
			<div class="form-group">
				<table width="100%" border="1">
				<tr><!-- select_f_ridx 여러개가 나올수 있다 tidx gbidx 로 전체를 대변해서 구해야한다 .중요  -->
					<td><a href="javascript:mx.setJudge('B',1,<%=tidx%>,<%=select_f_ridx%>)">심판장</a></td>
					<td><a href="javascript:mx.setJudge('E',1,<%=tidx%>,<%=select_f_ridx%>)">벨심판</a></td>
					<td><a href="javascript:mx.setJudge('M',1,<%=tidx%>,<%=select_f_ridx%>)">계시심판</a></td>
					<td><a href="javascript:mx.setJudge('C',1,<%=tidx%>,<%=select_f_ridx%>)">기록심판</a></td>
					<td><a href="javascript:mx.setJudge('A',1,<%=tidx%>,<%=select_f_ridx%>)">스튜어드</a></td>

					<td>
						<a href="javascript:mx.setHurdle(<%=tidx%>,<%=find_gbidx%>,'<%=select_f_classhelp%>',1)" class="btn btn-primary">장애물 기준 및 배치정보</a> 
					</td>
				
				</tr>
				</table>
			</div>	
			<%
		End select

	Case "20103","20203" ' 복합마술
		If sel_orderType = "MM" Then
		%>
	<div class="row">
		<div class="col-sm-12">
			<label class="control-label" onmouseup="mx.setExceptMax(<%=tidx%>,<%=find_gbidx%>)" ><input type="checkbox" id="mk_g9"  value="Y"  <%If select_f_MAX = "Y" then%>checked<%End if%>>&nbsp;최고점제외</label>
			<label class="control-label" onmouseup="mx.setExceptMin(<%=tidx%>,<%=find_gbidx%>)" >&nbsp;<input type="checkbox" id="mk_g10"  value="Y" <%If select_f_MIN = "Y" then%>checked<%End if%>>&nbsp;최저점제외</label>
			<label class="control-label"  onmouseup="mx.setSign(<%=tidx%>,<%=find_gbidx%>)" ><input type="checkbox" id="mk_g6"  value="Y" <%If select_f_judgesignYN = "Y" then%>checked<%End if%>>&nbsp;심판장 서명 완료</label>
			<label class="control-label" >지점별 최고 기록 가능점수</label><label class="control-label" ><input type="number" id="mk_g5" placeholder="지점별최고 기록 가능점수 입력" value="<%=select_f_judgemaxpt%>" readonly>
			<a href="javascript:mx.setRecordInit(<%=tidx%>,<%=find_gbidx%>)" class="btn btn-primary">적용</a>
			</label>
		</div>
	</div>

	<div class="form-group">
		<hr>
		<table width="100%" border="1"  id="judgePname">
		<tr>
			<td><label class="control-label"><input type="checkbox" id="mk_g0"  value="B" <%If select_f_B = "Y" then%>checked<%End if%>>&nbsp;B</label></td>
			<td><label class="control-label">&nbsp;<input type="checkbox" id="mk_g1"  value="E"  <%If select_f_E = "Y" then%>checked<%End if%>>&nbsp;E</label></td>
			<td><label class="control-label">&nbsp;<input type="checkbox" id="mk_g2"  value="M"  <%If select_f_M = "Y" then%>checked<%End if%>>&nbsp;M</label></td>
			<td><label class="control-label">&nbsp;<input type="checkbox" id="mk_g3"  value="C"  <%If select_f_C = "Y" then%>checked<%End if%>>&nbsp;C</label></td>
			<td><label class="control-label">&nbsp;<input type="checkbox" id="mk_g4"  value="H"  <%If select_f_H = "Y" then%>checked<%End if%>>&nbsp;H</label></td>
			<td><a href="javascript:mx.setJudge('A',1,<%=tidx%>,<%=f_ridx%>)">스튜어드</a></td>
		</tr>
		<tr>
			<td><a href="javascript:mx.setJudge('B',1,<%=tidx%>,<%=select_f_ridx%>)">심판<%=sss%></a><br><a href="javascript:mx.setJudge('B',2,<%=tidx%>,<%=select_f_ridx%>)">스크라이버</a></td>
			<td><a href="javascript:mx.setJudge('E',1,<%=tidx%>,<%=select_f_ridx%>)">심판</a><br><a href="javascript:mx.setJudge('E',2,<%=tidx%>,<%=select_f_ridx%>)">스크라이버</a></td>
			<td><a href="javascript:mx.setJudge('M',1,<%=tidx%>,<%=select_f_ridx%>)">심판</a><br><a href="javascript:mx.setJudge('M',2,<%=tidx%>,<%=select_f_ridx%>)">스크라이버</a></td>
			<td><a href="javascript:mx.setJudge('C',1,<%=tidx%>,<%=select_f_ridx%>)">심판</a><br><a href="javascript:mx.setJudge('C',2,<%=tidx%>,<%=select_f_ridx%>)">스크라이버</a></td>
			<td><a href="javascript:mx.setJudge('H',1,<%=tidx%>,<%=select_f_ridx%>)">심판</a><br><a href="javascript:mx.setJudge('H',2,<%=tidx%>,<%=select_f_ridx%>)">스크라이버</a></td>
			<td><a href="javascript:mx.setJudge('A',2,<%=tidx%>,<%=select_f_ridx%>)">Sit-in</a><br><a href="javascript:mx.setJudge('A',3,<%=tidx%>,<%=select_f_ridx%>)">Shadow</a></td>
		</tr>
		</table>
	</div>		
		<%
		Else
			'If select_f_classhelp = CONST_TYPEA_1 Then
		%>
			<div class="form-group">
				<table width="100%" border="1">
				<tr><!-- select_f_ridx 여러개가 나올수 있다 tidx gbidx 로 전체를 대변해서 구해야한다 .중요  -->
					<td><a href="javascript:mx.setJudge('B',1,<%=tidx%>,<%=select_f_ridx%>)">심판장</a></td>
					<td><a href="javascript:mx.setJudge('E',1,<%=tidx%>,<%=select_f_ridx%>)">벨심판</a></td>
					<td><a href="javascript:mx.setJudge('M',1,<%=tidx%>,<%=select_f_ridx%>)">계시심판</a></td>
					<td><a href="javascript:mx.setJudge('C',1,<%=tidx%>,<%=select_f_ridx%>)">기록심판</a></td>
					<td><a href="javascript:mx.setJudge('A',1,<%=tidx%>,<%=select_f_ridx%>)">스튜어드</a></td>

					<td>
						<a href="javascript:mx.setHurdle(<%=tidx%>,<%=find_gbidx%>,'<%=select_f_classhelp%>',1)" class="btn btn-primary">장애물 기준 및 배치정보</a> 
					</td>
				
				</tr>
				</table>
			</div>	
		<%
			'End if
		End If
	

	End Select
'####################################################################################################
%>