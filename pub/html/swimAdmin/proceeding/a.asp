	<tr class="gametitle"  style="cursor:pointer" id="titlelist_<%=idx%>">
		<td  onclick="mx.input_edit(<%=idx%>)">1</td>
		<td  onclick="mx.input_edit(<%=idx%>)" style="background:green;color:#fff">1-2번 (1번코트)

		</td>
		<td  onclick="mx.input_edit(<%=idx%>)"  style="background:#EEEEEE;">1-3번
			경기종료
			<select  id="tct" >
			<option value="A" >1등</option>
			<option value="A" >2등</option>
			<option value="B" >3등</option>
		</td>
		<td  onclick="mx.input_edit(<%=idx%>)">2-3번
			<select  id="tct" >
			<option value="A" >코트지정</option>
			<option value="A" >1번코트</option>
			<option value="B" >2번코트</option>
			<option value="C">3번코트</option>
			</select><a href="#" class="btn">지정</a>
		</td>
	</tr>




