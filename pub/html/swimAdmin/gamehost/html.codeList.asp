	<tr class="gametitle"  style="cursor:pointer" id="titlelist_<%=idx%>">
		<td onclick="mx.input_edit(<%=idx%>)"><span><a onmouseover="mx.input_edit(<%=idx%>)" class="btn btn-success"><%=hosttitle%></a></span></td>
		<td onclick="mx.input_edit(<%=idx%>)"><span><%=titlegrade%></span></td>
		<td onclick="mx.input_edit(<%=idx%>)"><span><%=titleCode%></span></td>


		<!-- <td>
		<select id="gameyear_<%=idx%>">
		<%For y = year(date) To year(date) -4 Step - 1%>
		<option value="<%=y%>"><%=y%>년도</option>
		<%next%>
		</select>
		<a href="javascript:alert($('#gameyear_<%=idx%>').val())" class="btn">랭킹반영</a>
		</td> -->


<%If rankok = "Y" Or isnull(rankok) = true then%>
		<!-- <td><a href="javascript:mx.rnkOK(<%=titlecode%>,'N')" class="btn">랭킹반영중</a></td> -->
<%else%>
		<!-- <td><a href="javascript:mx.rnkOK(<%=titlecode%>,'Y')" class="btn" style="background:green;">랭킹반영중지됨</a></td> -->
<%End if%>
	</tr>