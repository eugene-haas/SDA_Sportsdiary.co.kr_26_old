
	<tr class="gametitle" id="titlelist_<%=idx%>"  style="text-align:center;">

<%If f_CDA = "D2" then%>


	<%If l_raneno = "0" then%>
		<td>&nbsp;</td>
	<%else%>
		<%If chkrowno > 0 then%>
		<%If ari =  0 or prejoo <> chkrowno Then%>
			<td  rowspan="<%=raneCnt%>" style="vertical-align:middle;"><span><%=chkrowno%>조</span></td>
		<%End if%>
		<%else%>
		<td>&nbsp;</td>
		<%End if%>
	<%End if%>

<!-- 		<td> -->
			<%If l_raneno <> "0" then%>
				<%If chkrowno > 0 then%>
<!-- 				<button onclick="mx.changeRane(<%=l_idx%>,0,1)" class="btn btn-default btn-xs">▲</button> -->
<!-- 				<button onclick="mx.changeRane(<%=l_idx%>,0,2)" class="btn btn-default btn-xs">▼</button> -->
				<%else%>
				레인배정전
				<%'=l_bestOrder%>
				<%End if%>
			<%End if%>
<!-- 		</td> -->
		<!-- <td><%=l_bestOrder%></td> -->
		<td><%=l_Sex%></td>
		
		
<%
'			If l_tryoutgroupno > 0 Then
'				chkrowno = l_tryoutgroupno
'				l_raneno = l_tryoutsortNo
'			Else
'				chkrowno = l_roundNo
'				l_raneno = l_SortNo
'			End if
%>
		
		
		<td>
		<%If chkrowno > 0 then%>
		
		<span>
		<input  id="jooc_<%=l_idx%>" value = "<%=chkrowno%>" style="width:40px;text-align:center;" onkeyup="this.value=this.value.replace(/[^0-9]/g,'');">
		<input  id="ranec_<%=l_idx%>" value = "<%=l_raneno%>" style="width:40px;text-align:center;" onkeyup="this.value=this.value.replace(/[^0-9]/g,'');">
		<a href="javascript:mx.changeRaneJoo(<%=l_idx%>,$('#jooc_<%=l_idx%>').val(),$('#ranec_<%=l_idx%>').val(),1);" class="btn  btn-default" >변경</a>
		</span>
		
		<%End if%>		
		</td>



		<td><%=l_bestCDBNM%></span></td>

		<td><span><%=l_CDCNM%></span></td>
		<td><span><%=l_username%></span></td>
		<td><span><%=l_teamnm%></span></td>
		<td><span><%=l_bestscore%></span></td>
		<td><span><%=l_bestDate%></span></td>
		<td><span><%=l_bestArea%></span></td>
		<td><%=l_bestTitle%></td>
		<td><span><%=l_bestGamecode%></span></td>
		<td>
		<%If chkrowno > 0 then%>
		<span><input  id="player_<%=l_idx%>" value = "<%=l_raneno%>" style="width:40px;text-align:center;" onkeyup="this.value=this.value.replace(/[^0-9]/g,'');mx.changeRane(<%=l_idx%>,this.value,3)" ></span>
		<%End if%>
		</td>

<%else%>	

	<%If l_raneno = "0" then%>
		<td>&nbsp;</td>

	<%else%>
		<td><span><%=l_raneno%></span></td>
	<%End if%>

		<td>
			<%If l_raneno <> "0" then%>
				<%If chkrowno > 0 then%>
				<button onclick="mx.changeRane(<%=l_idx%>,0,1)" class="btn btn-default btn-xs">▲</button>
				<button onclick="mx.changeRane(<%=l_idx%>,0,2)" class="btn btn-default btn-xs">▼</button>
				<%else%>
				레인배정전
				<%'=l_bestOrder%>
				<%End if%>
			<%End if%>
		</td>

		<td><%=strSex(l_Sex)%></td>
		<td><span><%=l_CDCNM%></span></td>
		<td><span><%=l_username%></span></td>
		<td><span><%=l_teamnm%></span></td>
<%End if%>
	
	</tr>
<%
prejoo = chkrowno
%>

