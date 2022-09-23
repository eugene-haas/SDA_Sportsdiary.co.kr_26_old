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

	tablename = "tblPlayer_korea"
	strFieldName = " regyear,UserName,playeridx,engName,team,teamnm,ksportsno,Sex,birthday,teamgbnm  "

	strSql = "SELECT top 1  " & strFieldName
	strSql = strSql & "  from " & tablename
	strSql = strSql &  " WHERE seq = " & reqidx
	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)		

	If Not rs.eof Then

		e_regyear = rs(0)
		e_UserName = rs(1)
		e_playeridx = rs(2)
		e_engName = rs(3)
		e_team = rs(4)
		e_teamnm = rs(5)
		e_ksportsno = rs(6)
		e_Sex = rs(7)
		e_birthday = rs(8)
		e_teamgbnm = rs(9)
		e_idx				= reqidx
	End if

	db.Dispose
	Set db = Nothing



			If e_idx <> "" then
				%><input type="hidden" id="e_idx" value="<%=e_idx%>"><%
			End If



%>
						<div class="form-group">
							<label class="col-sm-1 control-label">년도</label>
							<div class="col-sm-2">
								<select id="mk_g0" class="form-control">
								  <%For i = year(date) To 2019 Step -1 %>
								  <option value="<%=i%>" <%If CStr(e_regyear) = CStr(i) then%>selected<%End if%>><%=i%></option>
								  <%next%>
							  </select>
							</div>

							<label class="col-sm-1 control-label">선수명</label>
							<div class="col-sm-2">
								<input type="text" id="mk_g1" class="form-control" placeholder="선수명"  value="<%=e_UserName%>">
								<input type="hidden" id="mk_g2" value="<%=e_playeridx%>" >
							</div>

							<label class="col-sm-1 control-label">영문명</label>
							<div class="col-sm-2">
								<input type="text" id="mk_g3" class="form-control" placeholder="영문명"   value="<%=e_engName%>">
								</select>
							</div>
							<label class="col-sm-1 control-label">소속</label>
							<div class="col-sm-2">
								<input type="hidden" id="mk_g4" value="<%=e_team%>">
								<input type="text" id="mk_g5" class="form-control" placeholder="소속"   value="<%=e_teamnm%>">
								</select>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-1 control-label">체육인번호</label>
							<div class="col-sm-2">
								<input type="text" id="mk_g6" class="form-control" placeholder="체육인번호"   value="<%=e_ksportsno%>">
							</div>

							<label class="col-sm-1 control-label">성별</label>
							<div class="col-sm-2">
								<input type="text" id="mk_g7" class="form-control" placeholder="성별"   value="<%=e_Sex%>">
							</div>

							<label class="col-sm-1 control-label">생년월일</label>
							<div class="col-sm-2">
								<input type="text" id="mk_g8" class="form-control" placeholder="생년월일"   value="<%=e_birthday%>">
								</select>
							</div>
							<label class="col-sm-1 control-label">종목</label>
							<div class="col-sm-2">
								<input type="text" id="mk_g9" class="form-control" placeholder="종목"   value="<%=e_teamgbnm%>">
								</select>
							</div>
						</div>


						<div class="btn-group flr" role="group" aria-label="...">
							<a href="#" class="btn btn-primary" id="btnsave" onclick="mx.input_frm('<%=SENDPRE%>');" accesskey="i">등록<span>(I)</span></a>
							<a href="#" class="btn btn-primary" id="btnupdate" onclick="mx.update_frm('<%=SENDPRE%>');" accesskey="e">수정<span>(E)</span></a>
							<a href="#" class="btn btn-danger" id="btndel" onclick="mx.del_frm('<%=SENDPRE%>');" accesskey="r">삭제<span>(R)</span></a>
						</div>