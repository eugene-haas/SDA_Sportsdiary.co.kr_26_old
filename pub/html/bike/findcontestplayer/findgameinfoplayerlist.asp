	<tr id="paystate_<%=idx%>" >
		<td class="number"><span><%=idx%></span></td>
		<td class="competition_name"><span><%=gameTitle%></span></td>
		<td class="department_name" onclick="mx.viewLevelInfo(<%=groupno%>, <%=idx%>)"><%=levelTitle%><% If requestCount > 1 Then %> 외 <%=requestCount -1 %>개<% End If %></td>
        <td class="department_type"><%=subtype%></td>
		<td class="user_name"><%=UserName%>(<%=sex%>)</td>
		<td class="depositor_name" ><span><%=PaymentName%></span></td>
		<td class="attmoney" ><span><%=attmoney%></span></td>
		<td class="deposit_condition">
			<div class="switch_box">
				<ul>
					<li>
						<div class="switch switch-red">
								<input type="radio" class="switch-input" name="paystate<%=idx%>" id="paystate_<%=idx%>_on" value="Y" <%If PaymentState= "Y" then%>checked<%End if%>>
								<label for="paystate_<%=idx%>_on" class="switch-label switch-label-off" onclick="mx.payCheck(<%=idx%>,'ON')">on</label>
								<input type="radio" class="switch-input" name="paystate<%=idx%>" id="paystate_<%=idx%>_off" value="N" <%If PaymentState= "N" then%>checked<%End if%>>
								<label for="paystate_<%=idx%>_off" class="switch-label switch-label-on" onclick="mx.payCheck(<%=idx%>,'OFF')">off</label>
								<span class="switch-selection"></span>
						</div>
					</li>
				</ul>
			</div>

		</td>
		
		<td class="deposit_date" style="min-width:220px;"><%=PaymentDate%></td>
		<td class="att_date" style="max-width:200px;"><%=Writeday%></td>
		<!--
		<td class="refund_info">
		<% If refundno <> "" Then %>
		<a class="btn" onclick="mx.viewRefundInfo(<%=idx%>);" >정보확인</a>
		<% Else %>
		<a class="btn" onclick="" disabled>정보확인</a>
		<% End If %>
		</td>
		<td class="refund_date"></td>
		-->
		
	</tr>