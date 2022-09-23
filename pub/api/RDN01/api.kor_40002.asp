<!-- #include virtual = "/pub/header.RidingAdmin.asp" -->
<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<%
Dim intTotalCnt, intTotalPage '총갯수, 총페이지수
'############################################
	If request("test") = "t" Then
		REQ ="{""CMD"":30002,""SENDPRE"":""rule_"",""IDX"":53}"
	Else
		REQ = request("REQ")
	End if

	If REQ = "" Then
		Response.End
	End if

	Set oJSONoutput = JSON.Parse( join(array(REQ)) )
	CMD = oJSONoutput.Get("CMD")
	SENDPRE = oJSONoutput.Get("SENDPRE")

'#############################################
'수정
'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" then
		reqidx = oJSONoutput.IDX
	End if


	Set db = new clsDBHelper

	SQL = " select playeridx,username,eng_nm,team,teamnm,ksportsno,sex,birthday from  tblplayer  where delYN = 'N'   and playeridx = " & reqidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof Then
		playeridx = rs(0)
		username = rs(1)
		eng_nm = rs(2)
		team = rs(3)
		teamnm = rs(4)
		ksportsno = rs(5)
		sex = rs(6)
		birthday = rs(7)
	End if

	db.Dispose
	Set db = Nothing



%>
						<div class="form-group">
							<label class="col-sm-1 control-label">년도</label>
							<div class="col-sm-2">
								<select id="mk_g0" class="form-control">
								  <%For i = year(date) To 2019 Step -1 %>
								  <option value="<%=i%>" ><%=i%></option>
								  <%next%>
							  </select>
							</div>

							<label class="col-sm-1 control-label">선수명</label>
							<div class="col-sm-2">
								<input type="text" id="mk_g1" class="form-control" placeholder="선수명"  value="<%=username%>">
								<input type="hidden" id="mk_g2" value="<%=playeridx%>">
							</div>

							<label class="col-sm-1 control-label">영문명</label>
							<div class="col-sm-2">
								<input type="text" id="mk_g3" class="form-control" placeholder="영문명"  value="<%=eng_nm%>">
								</select>
							</div>
							<label class="col-sm-1 control-label">소속</label>
							<div class="col-sm-2">
								<input type="hidden" id="mk_g4" value="<%=team%>">
								<input type="text" id="mk_g5" class="form-control" placeholder="소속"  value="<%=teamnm%>">
								</select>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-1 control-label">체육인번호</label>
							<div class="col-sm-2">
								<input type="text" id="mk_g6" class="form-control" placeholder="체육인번호" value="<%=ksportsno%>">
							</div>

							<label class="col-sm-1 control-label">성별</label>
							<div class="col-sm-2">
								<input type="text" id="mk_g7" class="form-control" placeholder="성별"  value="<%=sex%>">
							</div>

							<label class="col-sm-1 control-label">생년월일</label>
							<div class="col-sm-2">
								<input type="text" id="mk_g8" class="form-control" placeholder="생년월일"  value="<%=birthday%>">
								</select>
							</div>
							<label class="col-sm-1 control-label">종목</label>
							<div class="col-sm-2">
								<input type="text" id="mk_g9" class="form-control" placeholder="종목" >
								</select>
							</div>
						</div>


						<div class="btn-group flr" role="group" aria-label="...">
							<a href="#" class="btn btn-primary" id="btnsave" onclick="mx.input_frm('<%=SENDPRE%>');" accesskey="i">등록<span>(I)</span></a>
							<a href="#" class="btn btn-primary" id="btnupdate" onclick="mx.update_frm('<%=SENDPRE%>');" accesskey="e">수정<span>(E)</span></a>
							<a href="#" class="btn btn-danger" id="btndel" onclick="mx.del_frm('<%=SENDPRE%>');" accesskey="r">삭제<span>(R)</span></a>
						</div>

