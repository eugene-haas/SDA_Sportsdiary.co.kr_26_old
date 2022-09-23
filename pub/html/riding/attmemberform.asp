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
		<label class="col-sm-1 control-label">대회년도</label>
		<div class="col-sm-2">
			<div class="input-group">
				<select id="F1_0" class="form-control">
				  <%For fny = year(date) To minyear Step - 1%>
					<option value="<%=fny%>" <%If CStr(F2_0)= CStr(fny) then%>selected<%End if%>><%=fny%></option>
				  <%Next%>
			  </select>

			</div>
		</div>

		<div class="col-sm-2"></div>

		<label class="col-sm-1 control-label">모집상태</label>
		<div class="col-sm-2">
			<select  id="F1_1" class="form-control">
				<option value="3" <%If CStr(F2_1)= "3" Or  F2_1 = "" then%>selected<%End if%>>전체</option>
				<option value="2" <%If CStr(F2_1)= "2" then%>selected<%End if%>>마감</option>
				<option value="1" <%If CStr(F2_1)= "1" then%>selected<%End if%>>진행중</option>
			</select>
		</div>
	</div>


	<div class="form-group">
		<label class="col-sm-1 control-label">신청기간</label>
		<div class="col-sm-4">
			<div class="col-sm-1 input-group date" style="float:left;" id='GameDateWrap1'>
				<input type="text" id="F1_2" value="<%If CStr(F2_2)= "" then%><%=Left(date,7) & "-01"%><%else%><%=F2_2%><%End if%>" class="form-control" style="width:100px;">
				<span class="input-group-addon">
					<span class="glyphicon glyphicon-calendar"></span>
				</span>
			</div>

			<label class="col-sm-1 control-label">~</label>
			<div class="col-sm-1 input-group date" id='GameDateWrap2'>
				<input type="text" id="F1_3" value="<%If CStr(F2_2)= "" then%><%=date%><%else%><%=F2_3%><%End if%>" class="form-control" style="width:100px;">
				<span class="input-group-addon">
					<span class="glyphicon glyphicon-calendar"></span>
				</span>
			</div>				
		</div>


		<label class="col-sm-1 control-label">대회구분</label>
		<div class="col-sm-3">
			<div class="input-group">
					<label class="control-label">&nbsp;<input type="checkbox" id="checkall"  value="Y"  onclick="mx.setCheckToggle()">&nbsp;전체</label>
					<label class="control-label"><input type="checkbox" name="chk"  value="E" <%If F2_E = "E" then%>checked<%End if%>>&nbsp;전문</label>
					<label class="control-label">&nbsp;<input type="checkbox" name="chk"  value="A"  <%If F2_A = "A" then%>checked<%End if%>>&nbsp;생활</label>
					<label class="control-label">&nbsp;<input type="checkbox" name="chk"  value="L"  <%If F2_L = "L" then%>checked<%End if%>>&nbsp;유소년</label>
			</div>
		</div>
	</div>




	<div class="form-group">
		<label class="col-sm-1 control-label">대회명</label>
		<div class="col-sm-10">
			<input type="text"  id="F1_5" class="form-control" placeholder="대회명을 입력해주세요." value="<%=F2_5%>" >
		</div>
	</div>




	<div class="btn-group flr" role="group" aria-label="...">
		<a href="#" class="btn btn-primary" id="btnsave" onclick="mx.search();" accesskey="i">조회</a>
	</div>
</div>

