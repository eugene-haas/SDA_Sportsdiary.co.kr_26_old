	<tr class="gametitle"  style="cursor:pointer" id="titlelist_<%=idx%>">
		<td  onclick="mx.input_edit(<%=idx%>)"><%=idx%></td>
		<td  onclick="mx.input_edit(<%=idx%>)" style="text-align:left;padding-left:10px;"><font color="red">[<%=titleGrade%>]</font> <%=title%></td>
		<td  onclick="mx.input_edit(<%=idx%>)" style="color:#A43A1D;"><%=sdate%>~<%=edate%></td>
		<td  onclick="mx.input_edit(<%=idx%>)"><%=viewYN%><%=ViewState%> : <%=MatchYN%></td>
		<td ><a href="javascript:mx.golevel(<%=idx%>,'<%=title%>')" class="btn_a">부(경기유형)관리</a></td>
	</tr>