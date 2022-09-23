<%
	  '@@@@@@@@@@@@@@
	  'tblPubCode (코드 정의)
	  '년도별 등록된 코드값
	  'tblTeamGbInfo
	  '@@@@@@@@@@@@@@

	  '공통코드
	  SQL = "Select pubcodeIDX,PubName,pubSubName,PPubCode,PPubName from tblPubCode where SportsGb = '"&sitecode&"' and delYN = 'N' and  PPubCode = 'RDN01_2' "
	  Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)
	  If Not rs.EOF Then
		arrPub = rs.GetRows()
	  End If

	  strTableName = " tblTeamGbInfo "
	  strWhere = " DelYN = 'N' "
	  SQL = "Select TeamGb,TeamGbNm,PTeamGbNm from " & strTableName & " where " & strWhere & " group by TeamGb,TeamGbNm , PTeamGbNm "
	  Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)

	  If Not rs.EOF Then
		arrRS = rs.GetRows()
	  End If

	  strWhere = " DelYN = 'N' and TeamGbNm = '마장마술' "
	  SQL = "Select ridingclass from " & strTableName & " where " & strWhere & " group by ridingclass "
	  Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)

	  If Not rs.EOF Then
		arrC = rs.GetRows()
	  End If

'Call getrowsdrow(arrRS)

		If e_idx <> "" then
			%><input type="hidden" id="e_idx" value="<%=e_idx%>"><%
			F2_0 = e_gubun
			F2_1 = e_chkyear

		End If
%>

				<%'=request("p")%>
				<div class="form-horizontal">
				<input type="hidden" id="F1_0" value="<%=F2_0%>"><%' F1,F2,F3 검색조건, 검색어, checkbox 인경우 사용 %>
				<a href="javascript:px.goSubmit( {'F1':[0,1] , 'F2':[1, $('#F1_1').val()],'F3':[]} , 'limited.asp'  )" class="btn btn-<%If F2_0 = "1" then%>primary<%else%>default<%End if%>" style="width:100px;" id="tab01">선수</a>
				<a href="javascript:px.goSubmit( {'F1':[0,1] , 'F2':[2, $('#F1_1').val()],'F3':[]} , 'limited.asp' )" class="btn btn-<%If F2_0 = "2" then%>primary<%else%>default<%End if%>" style="width:100px;" id="tab02">말</a>


				<table cellspacing="0" cellpadding="0" class="table table-hover">
					<thead>
						<tr>
							<th colspan="4">조건</th>
							<th colspan="8" class="borl">참가제한사항</th>
						</tr>
						<tr>
							<th>등록년도</th>
							<th>종목</th>
							<th>마종</th>
							<th>Class</th>
							<th>해당범위</th>
							<th>무감점횟수</th>
							<th>조건선택</th>
							<th>입상실적(횟수)</th>
							<th>참가가능여부</th>
							<th>종목</th>
							<th>Class</th>
						</tr>
					</thead>

					<tbody id="contest"  class="gametitle">
						<tr>
							<td>
								<select id="F1_1" class="form-control" onchange="px.goSubmit( {'F1':[0,1] , 'F2':[$('#F1_0').val(),$('#F1_1').val()],'F3':[]} , 'limited.asp')">
								  <%For fny = year(date) To year(date) - 3 Step - 1%>
									<option value="<%=fny%>" <%If CStr(F2_1)= CStr(fny) then%>selected<%End if%>><%=fny%></option>
								  <%Next%>
							  </select>
							</td>

							<td>
								<select id="mk_g1" class="form-control">
									<option value="">==선택==</option>
									<%
									If IsArray(arrPub) Then
										For ar = LBound(arrPub, 2) To UBound(arrPub, 2)
											pubcodeidx = arrPub(0, ar)
											PubName = arrPub(1, ar)
											PPubCode = arrPub(3, ar)
											If PPubCode = sitecode & "_2"  then
											%><option value="<%=PubName%>" <%If PubName = e_teamgbnm then%>selected<%End if%>><%=PubName%></option><%
											End if
										Next
									End if
									%>
							  </select>
							</td>
							<!-- 마종 -->
							<td style="text-align:left">
								<input type="checkbox" id="checkall" onclick="mx.setCheckToggle()"> 전체<br>
								<input type="checkbox" name="chk" value="M" <%If e_H1 = "M" then%>checked<%End if%>> 국산마+외산마<br>
								<input type="checkbox" name="chk" value="K" <%If e_H2 = "K" then%>checked<%End if%>> 국산마<br>
								<input type="checkbox" name="chk" value="F" <%If e_H3 = "F" then%>checked<%End if%>> 외산마<br>
							</td>
							<td>
								<select id="mk_g2" class="form-control">
									<option value="-1">==선택==</option>
									<%
									For i = 0 To  ubound(classarr)
									%><option value="<%=i%>" <%If CStr(e_chkClass) = CStr(i) then%>selected<%End if%>><%=Classarr(i)%></option><%
									Next
									%>
							  </select>
							</td>
							<td>
							<select id="mk_g3" class="form-control">
									<option value="">==선택==</option>
									<option value="UP" <%If e_updown = "UP" then%>selected<%End if%>> 이상</option>
									<option value="DOWN" <%If e_updown = "DOWN" then%>selected<%End if%>> 이하</option>
							</select>
							</td>
							<td>
								<select id="mk_g4" class="form-control">
									<option value="">==선택==</option>
									<%For i = 1 To 10 %>
									<option value="<%=i%>"  <%If CStr(e_zeropointcnt) = CStr(i) then%>selected<%End if%> > <%=i%>회 이상</option>
									<%next%>
								</select>
							</td>
							<td>
							<select id="mk_g5" class="form-control">
									<option value="">==선택==</option>
									<option value="or" <%If e_chkandor = "or" then%>selected<%End if%>> 또는</option>
									<option value="and" <%If e_chkandor = "and" then%>selected<%End if%>> 그리고</option>
							</select>
							</td>
							<td>
							<select id="mk_g6" class="form-control">
								<option value="">==선택==</option>
								<%For i = 1 To 10 %>
								<option value="<%=i%>"  <%If CStr(e_prizecnt) = CStr(i) then%>selected<%End if%>> <%=i%>회 이상</option>
								<%next%>
							</select>
							</td>
							<td>
							<select id="mk_g7" class="form-control">
									<option value="">==선택==</option>
									<option value="Y" <%If e_attokYN = "Y" then%>selected<%End if%>> 참가가능</option>
									<option value="N" <%If e_attokYN = "N" then%>selected<%End if%>> 참가불가</option>
							</select>
							</td>
							<td>
							<select id="mk_g8" class="form-control">
									<option value="">==선택==</option>
									<%
									If IsArray(arrPub) Then
										For ar = LBound(arrPub, 2) To UBound(arrPub, 2)
											pubcodeidx = arrPub(0, ar)
											PubName = arrPub(1, ar)
											PPubCode = arrPub(3, ar)
											If PPubCode = sitecode & "_2"  then
											%><option value="<%=PubName%>" <%If PubName = e_limitTeamgbnm then%>selected<%End if%>><%=PubName%></option><%
											End if
										Next
									End if
									%>
							</select>
							</td>
							<td>
							<select id="mk_g9" class="form-control">
									<option value="-1">==선택==</option>
									<%
									For i = 0 To  ubound(classarr)
											%><option value="<%=i%>" <%If CStr(e_limitchkClass) = CStr(i) then%>selected<%End if%>><%=Classarr(i)%></option><%
									Next
									%>
							</select>
							</td>
						</tr>
					</tbody>
				</table>


		<span>* 종목 및 클래스는 등록된 전체 내역이 출력됩니다.</span>
		<div class="btn-group flr" role="group" aria-label="...">
			<a href="#" class="btn btn-primary" id="btnsave" onclick="mx.input_frm();" accesskey="i">등록<span>(I)</span></a>
			<a href="#" class="btn btn-primary" id="btnupdate" onclick="mx.update_frm();" accesskey="e">수정<span>(E)</span></a>
			<a href="#" class="btn btn-danger" id="btndel" onclick="mx.del_frm();" accesskey="r">삭제<span>(R)</span></a>
		</div>





<!--     아래는 그냥 참조만... -->






					<%If aaa = "안보임" then%>
					<div class="form-group">
						<label class="col-sm-1 control-label">사용년도</label>
						<div class="col-sm-2">

							<select id="fnd_y" class="form-control">

							  <%For fny = year(date) To minyear Step - 1%>
								<option value="<%=fny%>" <%If CStr(F2)= CStr(fny) then%>selected<%End if%>><%=fny%></option>
							  <%Next%>

						  </select>
						</div>

						<a href="javascript:px.goSubmit( {'F1':'useyear','F2':$('#fnd_y').val()} , '<%=pagename%>');" class="btn btn-primary">검색</a>
					</div>
					<%End if%>

				</div>
