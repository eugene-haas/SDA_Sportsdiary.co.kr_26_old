<%
	If hasown(oJSONoutput, "FORMNO") = "ok" then
		fno = oJSONoutput.FORMNO
	End If

	'수정모드일때
	If hasown(oJSONoutput, "SEQ") = "ok" then
		seq = oJSONoutput.SEQ
	End If

	If hasown(oJSONoutput, "F1") = "ok" then
		F1 = oJSONoutput.F1
	End If
	If hasown(oJSONoutput, "F2") = "ok" then
		F2 = oJSONoutput.F2
	End If



	Set db = new clsDBHelper

		title = "메뉴생성"
		'그룹/종목
		SQL = "Select name from sd_gamePrize where gubun = 1 and delYN = 'N'"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.EOF Then
			arrRS = rs.GetRows()
		End If

	db.Dispose
	Set db = Nothing
%>
<div class="modal-dialog">
	<div class="modal-content">


		<div class='modal-header'>
			<button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
			<h4 id='myModalLabel'>상품등록</h4>
		</div>

		<div class="modal-body" id="Modaltestbody">
			<div id="w_form" class="form-horizontal">
					<div class="form-group">
						<label class="col-sm-2 control-label">상품명</label>
						<div class="col-sm-10">
							<select id="dep01" class="form-control" onchange="mx.SelectDEP(1,'dep01','w_form',mx.CMD_INSERTDEP1)">
						  	<option value="">=상품명=</option>
							  <%
							  If IsArray(arrRS) Then
								  For ar = LBound(arrRS, 2) To UBound(arrRS, 2)
									  grp1nm = arrRS(0, ar)
									  %><option value="<%=grp1nm%>" <%If grp1nm = fldname then%>selected<%End if%>><%=grp1nm%></option><%
								  i = i + 1
								  Next
							  End if
							  %>
							  <option value="insert">[추가생성]</option>
							</select>
						</div>
					</div>

					<div class="form-group">
						<label class="col-sm-2 control-label">성별</label>
						<div class="col-sm-10">
							<select id="dep02" class="form-control" onchange="mx.SelectDEP(2,'dep02','w_form',mx.CMD_INSERTDEP1)">
							  <option value="1">남</option>
							  <option value="2">여</option>
							</select>
						</div>
					</div>

					<div class="form-group">
						<label class="col-sm-2 control-label">상품옵션</label>
						<div class="col-sm-10">
							<select id="dep03" class="form-control" onchange="mx.SelectDEP(3,'dep03','w_form',mx.CMD_INSERTDEP1)">
							  <option value="">=상품옵션=</option>
								  <%
								  If IsArray(arrRS) Then
									  For ar = LBound(arrRS, 2) To UBound(arrRS, 2)
										  grp1nm = arrRS(0, ar)
										  %><option value="<%=grp1nm%>" <%If grp1nm = fldname then%>selected<%End if%>><%=grp1nm%></option><%
									  i = i + 1
									  Next
								  End if
								  %>
								  <option value="insert">[추가생성]</option>
							</select>
						</div>

					</div>
				</div>
		</div>

		<div class="modal-footer">
			<button class="btn btn-default" data-dismiss="modal" aria-hidden="true">닫기</button>
			<!-- <button class="btn" data-dismiss="modal" aria-hidden="true" onclick="location.reload()">닫기</button> -->
			<!-- <button class="btn btn-primary" onclick="mx.writeOK(3,'dep03','w_form',mx.CMD_MAKEGOODSOK)">저장</button> -->
		</div>

	</div>
</div>
