<div class="form-horizontal">

	<div class="form-group">
		<label class="col-sm-1 control-label">대회년/월</label>
		<div class="col-sm-2">
			<select id="F1_0" class="form-control" onchange="px.goSubmit( {'F1':[0,1,2],'F2':['',null,null],'F3':[]} , '<%=pagename%>')">
			  <%For fny = year(date) To minyear Step - 1%>
				<option value="<%=fny%>" <%If CStr(F2_0)= CStr(fny) then%>selected<%End if%>><%=fny%></option>
			  <%Next%>
		  </select>
		</div>

		<label class="col-sm-1 control-label">대회명</label>
		<div class="col-sm-2">
			<select id="F1_1" class="form-control" onchange="px.goSubmit( {'F1':[0,1,2],'F2':['','',null],'F3':[]} , '<%=pagename%>')">
				<%
				If IsArray(arrPub)  Then
					For ar = LBound(arrPub, 2) To UBound(arrPub, 2)
						f_tidx = arrPub(0, ar)
						f_tnm = arrPub(1, ar)
						%><option value="<%=f_tidx%>" <%If CStr(f_tidx) = CStr(F2_1) then%>selected<%End if%>><%=f_tnm%></option><%
					Next
				End if
				%>

			</select>
		</div>


		<label class="col-sm-1 control-label" style="width:70px;">상세</label>
		<div class="col-sm-2" style="width:320px;">
			<select id="F1_2" class="form-control" style="width:300px;">
				<%
				If IsArray(arrNo)  Then
					For ar = LBound(arrNo, 2) To UBound(arrNo, 2)
						f_ridx = arrNo(0, ar)
						f_gbidx = arrNo(1, ar)
						f_title = arrNo(2, ar)
						If f_gbidx = "" Or CStr(f_gbidx) <> CStr(f_pregbidx) then
						%><option value="<%=f_gbidx%>" <%If CStr(f_gbidx) = CStr(F2_2) then%>selected<%End if%>><%=f_title%></option><%
						End If
					f_pregbidx = f_gbidx
					Next
				End if
				%>
			</select>
		</div>

		<a href="javascript:px.goSubmit( {'F1':[0,1,2],'F2':['','',''],'F3':[]} , '<%=pagename%>');" class="btn btn-primary">검색</a>
	</div>
</div>



