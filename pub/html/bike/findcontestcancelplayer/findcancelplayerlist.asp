	<tr id="paystate_<%=idx%>" >
		<td class="number"><span><%=idx%></span></td>
		<td class="competition_name"><span><%=gameTitle%></span></td>
		<td class="department_name" onclick="mx.viewLevelInfo(<%=groupno%>, <%=idx%>)"><%=levelTitle%><% If requestCount > 1 Then %> 외 <%=requestCount -1 %>개<% End If %></td>
        <td class="department_type"><%=subtype%></td>
		<td class="user_name"><%=UserName%></td>
		<td class="depositor_name" ><span><%=PaymentName%></span></td>
		<td class="attmoney" ><span><%=attmoney%></span></td>
		<td class="deposit_condition">
			<div class="switch_box">
				<ul>
					<li>
						<div>
						    <p <% If payText = "입금" Then %>style="color:red;"<%End If%>><%=payText%><p>
						</div>
					</li>
				</ul>
			</div>

		</td>
		<td class="refund_info">
		<% If refundno <> "" Then %>
		<a class="btn" onclick="mx.viewRefundInfo(<%=idx%>);" >정보확인</a>
		<% Else %>
		<a class="btn" onclick="" disabled>정보확인</a>
		<% End If %>
		</td>
		<td class="refund_date"></td>
		
	</tr>