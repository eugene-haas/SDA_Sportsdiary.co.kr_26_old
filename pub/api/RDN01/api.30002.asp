<!-- #include virtual = "/pub/header.RidingAdmin.asp" -->
<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<%
Dim intTotalCnt, intTotalPage '총갯수, 총페이지수
'############################################
	If request("test") = "t" Then
		REQ ="{""CMD"":30002,""IDX"":2}"
	Else
		REQ = request("REQ")
	End if

	If REQ = "" Then
		Response.End
	End if

	Set oJSONoutput = JSON.Parse( join(array(REQ)) )
	CMD = oJSONoutput.Get("CMD")

'#############################################
'수정
'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" then
		reqidx = oJSONoutput.IDX
	End if


	Set db = new clsDBHelper

	tablename = "home_gameTitle"
	strFieldName = " title,gameurl,nationNM,cityNM,sdate,edate,gameyear,gamemonth "

	strSql = "SELECT top 1  " & strFieldName
	strSql = strSql & "  from " & tablename
	strSql = strSql &  " WHERE seq = " & reqidx
	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)		

	If Not rs.eof Then

		e_title			= rs(0)
		e_gameurl		= rs(1)
		e_nationNM		= rs(2)
		e_cityNM		= rs(3)
		e_sdate			= rs(4)
		e_edate			= rs(5)
		e_gameyear	= rs(6)
		e_gamemonth = rs(7)
		e_idx				= reqidx
	End if

	db.Dispose
	Set db = Nothing






			If e_idx <> "" then
				%><input type="hidden" id="e_idx" value="<%=e_idx%>"><%
			End If
%>
						<div class="form-group">
							<label class="col-sm-1 control-label">대회명</label>
							<div class="col-sm-2">
								<input type="text" id="mk_g0" class="form-control" placeholder="대회명" value="<%=e_title%>" >
							</div>

							<label class="col-sm-1 control-label">URL</label>
							<div class="col-sm-2">
								<input type="text" id="mk_g1" class="form-control" placeholder="URL" value="<%=e_gameURL%>" >
								</select>
							</div>
							<label class="col-sm-1 control-label">국가</label>
							<div class="col-sm-2">
								<input type="text" id="mk_g2" class="form-control" placeholder="국가명" value="<%=e_nationNM%>" >
								</select>
							</div>
							<label class="col-sm-1 control-label">도시</label>
							<div class="col-sm-2">
								<input type="text" id="mk_g3" class="form-control" placeholder="도시명" value="<%=e_cityNM%>" >
								</select>
							</div>
						</div>

						<div class="form-group">
							<label class="col-sm-1 control-label">시작일</label>
							<div class="col-sm-2">
								<div class='input-group date'>
									<input type="text" id="mk_g4" value="<%=e_sdate%>" class="form-control"  onkeyup="this.value=this.value.replace(/[^0-9]-/g,'');">
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
						</div>


						<div class="btn-group flr" role="group" aria-label="...">
							<a href="#" class="btn btn-primary" id="btnsave" onclick="mx.input_frm();" accesskey="i">등록<span>(I)</span></a>
							<a href="#" class="btn btn-primary" id="btnupdate" onclick="mx.update_frm();" accesskey="e">수정<span>(E)</span></a>
							<a href="#" class="btn btn-danger" id="btndel" onclick="mx.del_frm();" accesskey="r">삭제<span>(R)</span></a>
						</div>	
	
