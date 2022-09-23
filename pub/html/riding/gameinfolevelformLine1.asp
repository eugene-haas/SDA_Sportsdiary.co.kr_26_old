<%
'#######################
'api.find1.asp, api.gameinputedit.asp
'#######################
	If P_1 = "" Then
		P_1 = year(date)	
	End if
	findWhere = " and useYear = '"&P_1&"' "



	If P_2 <> "" Then
		findWhere = findWhere & " and PTeamGb = '"&P_2&"' "
	End if


	fieldstr =  "TeamGbIDX,useyear,PTeamGb,PTeamGbNm,TeamGb,TeamGbNm,levelno,levelNm,ridingclass,ridingclasshelp,Orderby,WriteDate,DelYN "
	SQL = "Select  "&fieldstr&" from tblTeamGbInfo where DelYN = 'N' " & findWhere & " order by teamgb asc,levelno asc"
	Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rss.EOF Then
		arrPub = rss.GetRows()
	End If
'#######################


'Response.write sql
'Call getrowsdrow(arrpub)
'Response.end
%>

	<div id="sel_GroupGameGb" class="form-group">

			<label class="control-label col-sm-1">세부종목</label>

			<div class="col-sm-2">

				<div class="input-group">
				<select id="mk_g0" class="form-control form-control-half" onchange="mx.SelectLevelGb(0)">
				  <%For fny = year(date) + 1 To year(date) - 2 Step - 1%>
					<option value="<%=fny%>" <%If (P_1 = "" And fny = year(date)) Or (P_1 <> "" And CStr(P_1)= CStr(fny)) then%>selected<%End if%>><%=fny%></option>
				  <%Next%>
				</select>

				<select id="mk_g1" class="form-control form-control-half" onchange="mx.SelectLevelGb(1)">
					<option value="">==선택==</option>
					<option value="201" <%If  P_2 = "201" then%>selected<%End if%>>개인</option>
					<option value="202" <%If  P_2 = "202" then%>selected<%End if%>>단체</option>
				</select>
				</div>

			</div>

			<div class="col-sm-2">
				<div class="input-group">
				<select id="mk_g2" class="form-control form-control-half" onchange="mx.SelectLevelGb(2)">
					<option value="">==선택==</option>
					<%
					If IsArray(arrPub) And P_2 <> "" Then  '앞에선택값이 있다면 그림 (종목)
						For ar = LBound(arrPub, 2) To UBound(arrPub, 2)
							f_teamgb = arrPub(4, ar)
							f_teamgbnm = arrPub(5, ar)
							If f_teamgb <> pre_teamgb  then
								%><option value="<%=f_teamgb%>" <%If f_teamgb = P_3 then%>selected<%End if%>><%=f_teamgbnm%></option><%
								pre_teamgb = f_teamgb
							End If
						Next
					End if
					%>
			  </select>
				<select id="mk_g3" class="form-control form-control-half" onchange="mx.SelectLevelGb(3)">
					<option value="">==선택==</option>
					<%
					If IsArray(arrPub) And P_3 <> "" Then '앞에선택값이 있다면 그림 (말종류)
						For ar = LBound(arrPub, 2) To UBound(arrPub, 2)
							f_teamgb = arrPub(4, ar)
							f_teamgbnm = arrPub(5, ar)
							f_levelno = arrPub(6, ar)
							f_levelNm = arrPub(7, ar)
							If f_teamgb = P_3 And  f_levelno <> pre_levelno then
								%><option value="<%=f_levelno%>" <%If CStr(f_levelno) = CStr(P_4) then%>selected<%End if%>><%=f_levelNm%></option><%
								pre_levelno = f_levelno
							End If
						Next
					End if
					%>
			  </select>

			  </div>
			</div>




			<div class="col-sm-2">
				<div class="input-group">
				<select id="mk_g4" class="form-control form-control-half"  onchange="mx.SelectLevelGb(4)">
					<option value="">==선택==</option>
					<%
					If IsArray(arrPub) then
						arsortdata = arraySort (arrPub, 8, "Text", "desc" ) 
					End if
					'Response.write sql
					'Call getrowsdrow(arsortdata)

					If IsArray(arrPub) And P_4 <> "" Then '앞에선택값이 있다면 그림 (클레스)
						For ar = LBound(arrPub, 2) To UBound(arrPub, 2)
							f_teamgb = arrPub(4, ar)
							f_teamgbnm = arrPub(5, ar)
							f_levelno = arrPub(6, ar)
							f_levelNm = arrPub(7, ar)
							f_class = arrPub(8, ar)

							If f_teamgb = P_3 And f_levelno = P_4 And  f_class <> pre_class then
								%><option value="<%=f_class%>" <%If f_class = P_5 then%>selected<%End if%>><%=f_class%></option><%
								pre_class = f_class
							End If
						Next
					End if
					%>
			  </select>





				<select id="mk_g5" class="form-control form-control-half"  onchange="mx.SelectLevelGb(5)">
					<option value="">==선택==</option>
					<%
					If IsArray(arrPub) And P_5 <> "" Then '앞에선택값이 있다면 그림 (클레스안내)
						For ar = LBound(arrPub, 2) To UBound(arrPub, 2)
							f_teamgb = arrPub(4, ar)
							f_teamgbnm = arrPub(5, ar)
							f_levelno = arrPub(6, ar)
							f_levelNm = arrPub(7, ar)
							f_class = arrPub(8, ar)
							f_classhelp = arrPub(9, ar)

							If f_teamgb = P_3 And f_levelno = P_4 And f_class = P_5 And  f_classhelp <> pre_classhelp then
								%><option value="<%=f_classhelp%>" <%If f_classhelp = P_6 then%>selected<%End if%>><%=f_classhelp%></option><%
								pre_classhelp = f_classhelp
							End If
						Next
					End if
					%>
			  </select>

			  </div>
			</div>

			

	</div>


			
			
			
			
			
	
