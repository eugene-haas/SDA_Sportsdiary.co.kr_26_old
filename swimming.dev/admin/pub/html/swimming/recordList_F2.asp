
	<tr class="gametitle" id="titlelist_<%=l_midx%>"  style="text-align:center;">
		<td>
		<%If chkrowno > 0 then%>
			<%If ADGRADE > 500 then%>
				<span><input  id="player_<%=l_midx%>" value = "<%=l_raneno%>" style="width:40px;text-align:center;" onkeyup="this.value=this.value.replace(/[^0-9]/g,'');mx.changeRane(<%=l_midx%>,this.value,3,'<%=l_gno%>')" ></span>
			<%else%>
				<span><%=l_raneno%></span>
			<%End if%>
		<%End if%>
		</td>

			
			<td><%=l_ksportsno%></td>

			<td><%=l_userName%></td>



			<td><%=u_kskey2%></td>
			<td><%=u_unm%></td>




			<td><%=l_TeamNm%></td>
			<td><%=l_sidonm%></td>
			<td><%=l_totalorderno%></td>

		
			<td><input  class="form-control" type="text" id= "r4_<%=l_midx%>" style="width:90px;" tabindex="<%=CDbl(ari)+1%>" 
			onkeyup="this.value=this.value.replace(/[^0-9]/g,'')" onblur="mx.setPF2(this, <%=l_midx%>, <%=l_lidx%>, <%=l_gno%>,'r1_<%=l_midx%>')"
			value="<%=l_result%>" maxlength="7" <%If l_result = "" then%>disabled<%End if%>  onfocus="px.chkZeroF2(this)"></td><!-- onfocus="px.chkZeroSm(this)"  -->





			<td>
			<select class="form-control" style="width:80px;"  id= "r6_<%=l_midx%>"  onchange= "mx.setOut(this, <%=l_midx%>, <%=l_lidx%>, <%=l_gno%>)">
			<option value="">--</option>

			<%
				If IsArray(arrC) Then 
					For arc = LBound(arrC, 2) To UBound(arrC, 2)
						l_outCD = arrC(0, arc)
						l_outCDNM= arrC(1, arc)
						%><option value="<%=l_outCD%>" <%If l_err = l_outCD then%>selected<%End if%>><%=l_outCDNM%></option><%
					Next
				End if
			%>

			</select>
			</td>


<%
'계영 400m, 800m와 혼계영 400m
'If l_CDC = "16" Or l_CDC = "17" Or l_CDC="15" then
If l_itgubun = "T" Then
%>



			<td><a href="javascript:mx.orderList(<%=l_requestIDX%>)" class="btn btn-default"><%If ADGRADE > 500 then%>오더등록(<%=l_ptncnt%>)<%else%>출전선수<%End if%></a></td>
<%else%>
			<td><a  class="btn btn-default" disabled><%If ADGRADE > 500 then%>오더등록<%else%>출전선수<%End if%></a></td>
<%end if%>

	</tr>
<%
prejoo = chkrowno
%>

