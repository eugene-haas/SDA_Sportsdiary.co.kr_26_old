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


						If CStr(f_tidx) = CStr(F2_1) Then
							kgame = arrPub(6, ar)
						End if

						%><option value="<%=f_tidx%>" <%If CStr(f_tidx) = CStr(F2_1) then%>selected<%End if%>><%=f_tnm%></option><%
					Next
				End if
				%>

			</select>
			<!-- <input type="text" id="F1_6" class="form-control"  onkeydown="if(event.keyCode == 13){px.goSubmit( {'F1':[0,1,2,3,4,5,6],'F2':['','','','','','',''],'F3':[3,4,5]} , '<%=pagename%>');}" value="<%=F1_6%>"> -->
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
						If ar = 0 Or CStr(f_gbidx) <> CStr(f_pregbidx) Then
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


<% '릴레이경기 심사기록 페이지로 다시 이동 (별도 페이지로 작업)
	If InStr(select_f_title,"릴레이") > 0 Then
		%>
		<script>px.goSubmit( {'F1':[0,1,2],'F2':['','',''],'F3':[]} , 'judgerelay.asp');</script>
		<%
		
		Response.end
	End if


	If InStr(select_f_title,"지구력") > 0 Then
		%>
		<script>px.goSubmit( {'F1':[0,1,2],'F2':['','',''],'F3':[]} , 'judgegigoo.asp');</script>
		<%
		
		Response.end
	End if

%>


<%
'체전여부를 쿠키로 생성해서 사용할것임 ㅡㅡ---------------------------------------------
	Set objRD = JSON.Parse("{}")
  	Call objRD.Set("kgame", kgame )
	strjson = JSON.stringify(objRD)

	Response.Cookies("RDOBJ") = strjson
	Response.Cookies("RDOBJ").domain = Request.ServerVariables("HTTP_HOST")

	'cookies_pub.asp 에서 request
'체전여부를 쿠키로 생성해서 사용할것임 ㅡㅡ---------------------------------------------
%>
<%'=kgame%>



