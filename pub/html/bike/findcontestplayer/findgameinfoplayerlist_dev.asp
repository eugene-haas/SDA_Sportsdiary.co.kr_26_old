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
                            <div class="toggle toggle-sm">
                              <input type="checkbox" id="paystate_<%=idx%>_switch" name="small-setting" <%If PaymentState= "Y" then%>checked<%End if%>/>
                              <label for="paystate_<%=idx%>_switch" onclick="mx.payCheck(<%=idx%>);">small</label>
                            </div>
                    </div>
                </li>
            </ul>
        </div>

    </td>

    <td class="deposit_date" title="<%=PaymentDate%>">
	<%If PaymentDate = "" Or isnull(PaymentDate) = true then%>
	입금전
	<%else%>
		<span><%=Left(PaymentDate,10)%></span>
	<%End if%>
	</td>
    <td class="att_date" title="<%=Writeday%>"><%=Left(Writeday,10)%></td>

</tr>
