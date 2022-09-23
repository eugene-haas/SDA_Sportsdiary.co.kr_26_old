<tr class="" id="attlist_<%=attmidx%>" playeridx=<%=playeridx%>>
    <td><%=gameidx%></td>
    <td><%=gameTitle%></td>
    <td><%=td%></td>
    <td><%=levelnoTitle%><% If requestCount > 1 Then %> 외 <%=requestCount -1 %>개<% End If %></td>
    <td><%=userName%></td>
    <td><%=p_nm%></td>
    <td id="p_phone_<%=playeridx%>"><%=p_phone%></td>
    <td <% If p_agree = "N" Then %> style="color:red;font-weight:bold;" <% End IF %> ><%=p_agree%></td>
    <td onclick="mx.sendLMS(<%=attmidx%>,<%=levelno%>,<%=titleIDX%>,<%=playeridx%>);">문자발송</td>
</tr>
<script></script>