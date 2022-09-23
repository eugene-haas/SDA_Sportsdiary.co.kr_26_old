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
	strFieldName = " TITLE,sdate,edate,place,attsdate,attedate,  syear,smonth,hostname,subjectnm  "

	strSql = "SELECT top 1  " & strFieldName
	strSql = strSql & "  from " & tablename
	strSql = strSql &  " WHERE seq = " & reqidx
	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)		

	If Not rs.eof Then

		e_title = rs(0)
		e_sdate = rs("sdate")
		e_edate = rs("edate")
		e_attsdate = rs("attsdate")
		e_attedate = rs("attedate")
		e_place = rs("place")
		e_hostname = rs("hostname")
		e_subjectnm = rs("subjectnm")

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
							<div class="col-sm-2">
								<input type="text" id="mk_g0" class="form-control" placeholder="제목" value="<%=e_title%>" >
							</div>

							<label class="col-sm-1 control-label">장소</label>
							<div class="col-sm-2">
								<input type="text" id="mk_g1" class="form-control" placeholder="장소" value="<%=e_place%>" >
							</div>
							<label class="col-sm-1 control-label">주최/주관</label>
							<div class="col-sm-2">
								<input type="text" id="mk_g2" class="form-control" placeholder="주최" value="<%=e_hostname%>" >
							</div>
							<label class="col-sm-1 control-label">후원</label>
							<div class="col-sm-2">
								<input type="text" id="mk_g3" class="form-control" placeholder="후원" value="<%=e_subjectnm%>" >
							</div>
						</div>

						<div class="form-group">
							<label class="col-sm-1 control-label">시작일</label>
							<div class="col-sm-2">
								<div class='input-group date'>
									<input type="text" id="mk_g4" value="<%=e_sdate%>" class="form-control" onkeyup="this.value=this.value.replace(/[^0-9]-/g,'');">
									<span class="input-group-addon">
										<span class="glyphicon glyphicon-calendar"></span>
									</span>
								</div>
							</div>
							<label class="col-sm-1 control-label">종료일</label>
							<div class="col-sm-2">
								<div class='input-group date'>
									<input type="text" id="mk_g5"  value="<%=e_edate%>"  class="form-control"  onkeyup="this.value=this.value.replace(/[^0-9]-/g,'');">
									<span class="input-group-addon">
										<span class="glyphicon glyphicon-calendar"></span>
									</span>
								</div>				
							</div>
							<label class="col-sm-1 control-label">참가시작</label>
							<div class="col-sm-2">
								<div class='input-group date'>
									<input type="text" id="mk_g6"  value="<%=e_attsdate%>"  class="form-control"  onkeyup="this.value=this.value.replace(/[^0-9]-/g,'');">
									<span class="input-group-addon">
										<span class="glyphicon glyphicon-calendar"></span>
									</span>
								</div>				
							</div>
							<label class="col-sm-1 control-label">참가종료</label>
							<div class="col-sm-2">
								<div class='input-group date'>
									<input type="text" id="mk_g7"  value="<%=e_attedate%>"  class="form-control"  onkeyup="this.value=this.value.replace(/[^0-9]-/g,'');">
									<span class="input-group-addon">
										<span class="glyphicon glyphicon-calendar"></span>
									</span>
								</div>				
							</div>
						</div>




						<div class="btn-group flr" role="group" aria-label="...">
							<a href="#" class="btn btn-primary" id="btnsave" onclick="mx.input_frm('<%=SENDPRE%>');" accesskey="i">등록<span>(I)</span></a>
							<a href="#" class="btn btn-primary" id="btnupdate" onclick="mx.update_frm('<%=SENDPRE%>');" accesskey="e">수정<span>(E)</span></a>
							<a href="#" class="btn btn-danger" id="btndel" onclick="mx.del_frm('<%=SENDPRE%>');" accesskey="r">삭제<span>(R)</span></a>
						</div>
