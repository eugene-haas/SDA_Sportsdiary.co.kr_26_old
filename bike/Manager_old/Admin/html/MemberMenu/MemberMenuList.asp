
	<tr>	
    <td style="cursor:pointer"><%=rMemberIDX%></td>	
    <td style="cursor:pointer"><%=rPlayerGb%></td>	
    <td style="cursor:pointer"><%=rUserName%></td>	
    <td style="cursor:pointer"><%=rBirthday%></td>	
    <td style="cursor:pointer">
    <%
      IF rSex ="Man" Then 
      Response.Write "남자" 
      ELSE 
      Response.Write "여자" 
      END IF
    %>
    </td>	
    <td style="cursor:pointer">
       <%
      IF rEnterType ="E" Then 
      Response.Write "엘리트" 
      ELSE 
      Response.Write "생활체육" 
      END IF
    %>
    </td>	
    <td style="cursor:pointer"></td>	
    <td style="cursor:pointer"></td>	
    <td style="cursor:pointer"></td>	
    <td style="cursor:pointer"><%=rUserPhone%></td>	
    <td style="cursor:pointer"></td>	
    <td style="cursor:pointer"></td>	
    <td style="cursor:pointer"></td>	
    <td style="cursor:pointer"></td>	
    <td style="cursor:pointer"><%=rWriteDate%></td>	
  </tr>