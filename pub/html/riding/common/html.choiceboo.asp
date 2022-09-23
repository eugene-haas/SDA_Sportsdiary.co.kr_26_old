
<select class="m_applicationForm__select" id="levelno" name="levelno">
	<option value="">::부서를 선택하세요::</option>
	<%
	If IsArray(arrA) Then
		For ar = LBound(arrA, 2) To UBound(arrA, 2)
			gamelevel = arrA(3, ar)
			gamelevelnm = arrA(2,ar)
			gamearea = arrA(4,ar)
			gamercnt = arrA(9,ar)
			gameentrycnt = arrA(8,ar)
			gameCh_i = arrA(11,ar)
			if ChekMode = 0 and ridx ="" then
				if gameCh_i ="Y" then
					%><option value="<%=gamelevel%>" <%If levelno = gamelevel then%>selected<%End if%>><%=gamelevelnm%><%if gamearea <>"" then  %>(<%=gamearea%>)<%end if%> <%=gamercnt%>/<%=gameentrycnt%></option><%
				End if
			Else
				%><option value="<%=gamelevel%>" <%If levelno = gamelevel then%>selected<%End if%>><%=gamelevelnm%><%if gamearea <>"" then  %>(<%=gamearea%>)<%end if%> <%=gamercnt%>/<%=gameentrycnt%></option><%
			End if
		Next

	End if
	%>
</select>
