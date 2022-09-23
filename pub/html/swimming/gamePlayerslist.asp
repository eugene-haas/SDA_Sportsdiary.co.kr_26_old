
	<tr class="gametitle" id="titlelist_<%=l_idx%>"  style="text-align:center;" onclick="mx.input_edit(<%=l_idx%>)">
<td>
		<input type="checkbox" value="<%=l_idx%>" <%if l_chkmsg = "Y" then%>checked<%end if%>>
</td>
			<td><%=no%></td>
			<td><%=l_kskey%><%'=l_ksportsno%></td>
			<td><%=l_startyear%><%'=l_ksportsnoS%></td>
			<td><%=l_nowyear%><%'=l_ksportsnoS%></td>
			<td><a href="javascript:alert('<%=l_kskey%>\n<%=l_UserName%>\n<%=l_email%>\n<%=l_TeamNm%>')"><%=l_UserName%></a></td>
			<td><%=l_userNameCn%></td>
			<td><%=l_userNameEn%></td>
			<td><%=Left(l_Birthday,6)%>(<%If l_Sex = "1" then%>남<%else%>여<%End if%>)</td>
			<td><%=l_Team%></td>
			<td><%=l_TeamNm%></td>
			<td><%=l_CDBNM%>(<%=l_CDB%>)</td>
			<td><%=l_userClass%></td>
			<td><%=l_nation%></td>
			<td><%=l_sido%></td>
<!-- 			<td><%=l_CDANM%><%If l_CDA <> "" then%>(<%=l_CDA%>)<%End if%></td> -->
	</tr>
