<tr>
   <!-- 번호-->
 <td onclick="SelGameTitle('<%=crypt_RGameTitleIDX%>')" style="cursor:pointer">
      <%=RGameTitleIDX%>
  </td>
  <!-- 날짜 -->
 <td onclick="SelGameTitle('<%=crypt_RGameTitleIDX%>')" style="cursor:pointer">
   <%if RGameS = "" and RGameE = ""  Then %>
    <%Response.Write  "-"%>
   <%else%>
    <%=RGameS%> ~ <br><%=RGameE%>
   <%end if%>
  </td>
  <!-- 대회구분 -->
 <td onclick="SelGameTitle('<%=crypt_RGameTitleIDX%>')" style="cursor:pointer">
      <%=RGameGbNm%> 
  </td>
  <!-- 대회 이름-->
 <td onclick="SelGameTitle('<%=crypt_RGameTitleIDX%>')" style="cursor:pointer">
      <%=RGameTitleName%>
  </td>

  
  <!-- 단체전-->
 <td onclick="SelGameTitle('<%=crypt_RGameTitleIDX%>')" style="cursor:pointer">
      <%=REnterType%>
  </td>

     <!-- 주관 -->
  <td onclick="SelGameTitle('<%=crypt_RGameTitleIDX%>')" style="cursor:pointer">
    <%
        if(cdbl(Len(rGameTitleHost)) > 10) Then
          response.write LEFT(rGameTitleHost, 10) & "..."
        else
          response.write rGameTitleHost
        end if
    %>
  </td>
  <!-- 지역-->
   <td onclick="SelGameTitle('<%=crypt_RGameTitleIDX%>')" style="cursor:pointer">
    <%=RSidoNm%>
  </td>

  <!-- 장소-->
 <td onclick="SelGameTitle('<%=crypt_RGameTitleIDX%>')" style="cursor:pointer">
    <%=RGamePlace%>
  </td>

  <!-- 단체전-->
   <td onclick="SelGameTitle('<%=crypt_RGameTitleIDX%>')" style="cursor:pointer">
   <%=RViewYN%>
  </td>
  <td>
    <a href="javascript:href_level('<%=crypt_RGameTitleIDX%>');" class="btn-list type2"> 종별관리 <%=RLevelCount%></a>
  </td>
  <!-- 종목 리스트-->
 <td onclick="SelGameTitle('<%=crypt_RGameTitleIDX%>')" style="cursor:pointer">
    <%=RlevelGrooupNm%>
  </td>

</tr>