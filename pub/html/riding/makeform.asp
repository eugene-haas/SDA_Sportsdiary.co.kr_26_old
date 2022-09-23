<%
	  '@@@@@@@@@@@@@@
	  'tblPubCode (코드 정의)
	  '년도별 등록된 코드값
	  'tblTeamGbInfo
	  '@@@@@@@@@@@@@@

	  '공통코드 
	  SQL = "Select pubcodeIDX,PubName,pubSubName,PPubCode,PPubName from tblPubCode where SportsGb = '"&sitecode&"' and delYN = 'N'"
	  Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)
	  If Not rs.EOF Then
		arrPub = rs.GetRows()
	  End If

		If e_idx <> "" then
			%><input type="hidden" id="e_idx" value="<%=e_idx%>"><%
		End If
%>

		<div class="form-group" style="background:#eeeeee;">
			<div class="col-sm-2">사용년도</div>
			<div class="col-sm-2">종목명</div>
			<div class="col-sm-2">부별성립 실인원(명)</div>
		</div>


		<div class="form-group">
			<div class="col-sm-2">
				<select id="mk_g0" class="form-control">
				  <%For fny = year(date) To year(date) - 3 Step - 1%>
					<option value="<%=fny%>" <%If CStr(e_rullyear)= CStr(fny) then%>selected<%End if%>><%=fny%></option>
				  <%Next%>
			  </select>
			</div>


			<div class="col-sm-2">
				<select id="mk_g1" class="form-control">
					<option value="">==선택==</option>
					<%
					If IsArray(arrPub) Then
						For ar = LBound(arrPub, 2) To UBound(arrPub, 2)
							pubcodeidx = arrPub(0, ar)
							PubName = arrPub(1, ar)
							PPubCode = arrPub(3, ar)
							If PPubCode = sitecode & "_2"  then
							%><option value="<%=pubcodeidx%>" <%If PubName = e_teamgbnm then%>selected<%End if%>><%=PubName%></option><%
							End if
						Next
					End if
					%>
			  </select>
			</div>

			<div class="col-sm-2">
				<input type="number" id="mk_g2" placeholder="참가실제 명수 입력" value="<%=e_realcnt%>" class="form-control">
			</div>
		</div>

		<div class="btn-group flr" role="group" aria-label="...">
			<a href="#" class="btn btn-primary" id="btnsave" onclick="mx.input_frm();" accesskey="i">등록<span>(I)</span></a>
			<a href="#" class="btn btn-primary" id="btnupdate" onclick="mx.update_frm();" accesskey="e">수정<span>(E)</span></a>
			<a href="#" class="btn btn-danger" id="btndel" onclick="mx.del_frm();" accesskey="r">삭제<span>(R)</span></a>
		</div>








