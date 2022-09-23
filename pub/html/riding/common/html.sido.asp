
<%
Select Case sdno
Case  1  
	s_sidono = s_sidono1 '번호
	s_gugun = s_gugun1 '스티링
	If addr <> "" Then
		sidoguarr = Split(addr,"_")
		sidono = sidoguarr(0)
		sidonm = sidoguarr(1)
		gugun = sidoguarr(2)
	End if

Case 2
	s_sidono = s_sidono2
	s_gugun = s_gugun2
End Select
%>

<select  id="sidogb<%=sdno%>"   onchange="mx_player.SelectSido(<%=sdno%>)"  <%If s_sidono <> "" then%>disabled<%End if%>>
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
<select  id="googun<%=sdno%>" <%If s_gugun <> "" then%>disabled<%End if%>>
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

