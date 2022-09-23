<!-- #include virtual = "/pub/header.RidingAdmin.asp" -->
<%
Dim intTotalCnt, intTotalPage '총갯수, 총페이지수
'############################################
%><!-- #include virtual = "/pub/setReq.asp" --><%'이걸열어서 디버깅하자.%><%
'#############################################
'수정
'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" then
		reqidx = oJSONoutput.IDX
	End if


	Set db = new clsDBHelper

	tablename = "tblTotalBoard"
	strFieldName = " title,url,target  "

	strSql = "SELECT top 1  " & strFieldName
	strSql = strSql & "  from " & tablename
	strSql = strSql &  " WHERE seq = " & reqidx
	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)		

	If Not rs.eof Then

		e_title = rs(0)
		e_url = rs(1)
		e_target = rs(2)
		e_idx				= reqidx
	End if

	db.Dispose
	Set db = Nothing



			If e_idx <> "" then
				%><input type="hidden" id="e_idx" value="<%=e_idx%>"><%
			End If



%>
						<div class="form-group">
							<label class="col-sm-1 control-label">제목</label>
							<div class="col-sm-8">
								<input type="text" id="mk_g0" class="form-control" placeholder="제목" value="<%=e_title%>" >
							</div>
						</div>

						<div class="form-group">
							<label class="col-sm-1 control-label">URL</label>
							<div class="col-sm-2">
								<input type="text" id="mk_g1" class="form-control" placeholder="URL" value="<%=e_URL%>" >
							</div>
							<label class="col-sm-1 control-label">Target</label>
							<div class="col-sm-2">
								<select id="mk_g2" class="form-control">
									<option value="_blank" <%If e_target= "_blank" then%>selected<%End if%>>_blank</a>
									<option value="_self" <%If e_target= "_self" then%>selected<%End if%>>_self</a>
								</select>
							</div>
						</div>




						<div class="btn-group flr" role="group" aria-label="...">
							<a href="#" class="btn btn-primary" id="btnsave" onclick="mx.input_frm('<%=SENDPRE%>');" accesskey="i">등록<span>(I)</span></a>
							<a href="#" class="btn btn-primary" id="btnupdate" onclick="mx.update_frm('<%=SENDPRE%>');" accesskey="e">수정<span>(E)</span></a>
							<a href="#" class="btn btn-danger" id="btndel" onclick="mx.del_frm('<%=SENDPRE%>');" accesskey="r">삭제<span>(R)</span></a>
						</div>