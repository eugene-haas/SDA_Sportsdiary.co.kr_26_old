
<%
Select Case sdno
Case  1  
	s_sidono = s_sidono1 '번호
	s_gugun = s_gugun1 '스티링
	If Cookies_sidogu <> "" Then
		sidoguarr = Split(Cookies_sidogu,"_")
		sidono = sidoguarr(0)
		sidonm = sidoguarr(1)
		gugun = sidoguarr(2)
	End if

Case 2
	s_sidono = s_sidono2
	s_gugun = s_gugun2
End Select
%>

<%If sdno = 1 And Cookies_sidogu <> "" Then%>
	<select  id="sidogb<%=sdno%>"   disabled>
		<option value="<%=sidono%>" selected><%=sidonm%></option>
	</select>
	<select  id="googun<%=sdno%>" disabled>
		<option value="<%=gugun%>" selected><%=gugun%></option>
	</select>

	<!-- SQL = "Select GuGunNm from tblGugunInfo where delYN = 'N' and Sido = (select top 1 sido from tblSidoInfo where Sido = '"&Split(P2_sidogu,"_")(0)&"' )" -->


<%elseIf sdno = 2 And P2_sidogu <> "" Then '수정시%>
	<select  id="sidogb<%=sdno%>"   onchange="mx_player.SelectSido(<%=sdno%>)" disabled>
		<option value="">=시,도=</option>
			<%
			If IsArray(arrSD) Then
				For ar = LBound(arrSD, 2) To UBound(arrSD, 2) 
					sidono = arrSD(0, ar) 
					sidonm = arrSD(1,ar)
				%>
					<option value="<%=sidono%>" <%If CStr(sidono) = Split(P2_sidogu,"_")(0) then%>selected<%End if%>><%=sidonm%></option>
				<%
				i = i + 1
				Next
			End if					
			%>
	</select>
	<select  id="googun<%=sdno%>" disabled>
		<option value="">=시,군,구=</option>
		<%			
		If IsArray(arrGG) Then
			For ar = LBound(arrGG, 2) To UBound(arrGG, 2) 
				gugun = arrGG(0, ar)
				%>
				<option value="<%=gugun%>" <%If CStr(gugun) = Split(P2_sidogu,"_")(2) then%>selected<%End if%>><%=gugun%></option>
				<%
			Next
		End if
		%>
	</select>

<%else%>

	<select  id="sidogb<%=sdno%>"   onchange="mx_player.SelectSido(<%=sdno%>)">
		<option value="">=시,도=</option>
			<%
			If IsArray(arrSD) Then
				For ar = LBound(arrSD, 2) To UBound(arrSD, 2) 
					sidono = arrSD(0, ar) 
					sidonm = arrSD(1,ar)
				%>
					<option value="<%=sidono%>" <%If CStr(sidono) = s_sidono then%>selected<%End if%>><%=sidonm%></option>
				<%
				i = i + 1
				Next
			End if					
			%>
	</select>
	<select  id="googun<%=sdno%>">
		<option value="">=시,군,구=</option>
		<%			
		If IsArray(arrGG) Then
			For ar = LBound(arrGG, 2) To UBound(arrGG, 2) 
				gugun = arrGG(0, ar)
				%>
				<option value="<%=gugun%>" <%If CStr(gugun) = s_gugun then%>selected<%End if%>><%=gugun%></option>
				<%
			Next
		End if
		%>
	</select>

<%End if%>