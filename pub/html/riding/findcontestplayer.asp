<%
'대회 주최/주관
'	SQL = "Select hostname,gubun from tblGameHost where DelYN = 'N' order by gubun asc"
'	Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)
'
'	If Not rss.EOF Then
'	arrRS = rss.GetRows()
'	End If
'
'	'대회그룹/등급
'	SQL = "Select titleCode,titleGrade,hostTitle,idx from sd_TennisTitleCode where  DelYN = 'N' "
'	Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)
'
'	If Not rss.EOF Then
'	arrRSG = rss.GetRows()
'	End If

	If e_idx <> "" then
		%><input type="hidden" id="e_idx" value="<%=e_idx%>"><%
	End If



%>


<div class="form-horizontal">
	<div class="form-group">
		<div class="col-sm-1"><label class="control-label">시도명</label></div>
		<div class="col-sm-2">
			<select id="mk_g7" class="form-control">
				<option value="">==선택==</option>
			</select>
		</div>
		<div class="col-sm-1"><label class="control-label">종목</label></div>
		<div class="col-sm-2">
			<select id="mk_g7" class="form-control">
				<option value="">==선택==</option>
			</select>
		</div>
		<div class="col-sm-1"><label class="control-label">마종</label></div>
		<div class="col-sm-2">
			<select id="mk_g7" class="form-control">
				<option value="">==선택==</option>
			</select>
		</div>
		<div class="col-sm-1"><label class="control-label">세부종목</label></div>
		<div class="col-sm-2">
			<select id="mk_g7" class="form-control">
				<option value="">==선택==</option>
			</select>
		</div>
	</div>
</div>

<!-- 
<table>
<tr>
	<td>시도명</td>
	<td>					<select  id="mk_g7" class="form-control">
						<option value="">==선택==</option>
					</select></td>
</tr>
<tr>
	<td>종목</td>
	<td>					<select  id="mk_g7" class="form-control">
						<option value="">==선택==</option>
					</select></td>
</tr>
<tr>
	<td>마종</td>
	<td>					<select  id="mk_g7" class="form-control">
						<option value="">==선택==</option>
					</select></td>
</tr>
<tr>
	<td>세부종목</td>
	<td>					<select  id="mk_g7" class="form-control">
						<option value="">==선택==</option>
					</select></td>
</tr>
</table>
 -->






<div class="btn-group flr" role="group" aria-label="...">
	<a href="#" class="btn btn-primary" id="btnsave" onclick="mx.input_frm();" accesskey="i">조회</a>
</div>


