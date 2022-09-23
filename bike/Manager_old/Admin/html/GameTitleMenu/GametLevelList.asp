<tr>
  <td style="cursor:pointer" onclick='javascript:selGamelevel(<%=strjson%>,<%=rGameLevelidx%>)'>
      <%=rGameLevelidx%>
  </td>
   <td style="cursor:pointer" onclick'"javascript:selGamelevel(<%=strjson%>,<%=rGameLevelidx%>'">
      <%=rTeamGb%>
  </td>
  <td style="cursor:pointer" onclick='javascript:selGamelevel(<%=strjson%>,<%=rGameLevelidx%>)'>
      <%=rGameType%>
  </td>
  <td style="cursor:pointer" onclick='javascript:selGamelevel(<%=strjson%>,<%=rGameLevelidx%>)'>
      <%=rPlayType%>
  </td>
  <td style="cursor:pointer" onclick='javascript:selGamelevel(<%=strjson%>,<%=rGameLevelidx%>)'>
      <%=rGroupGameGb%>
  </td>
  <td style="cursor:pointer" onclick='javascript:selGamelevel(<%=strjson%>,<%=rGameLevelidx%>)'>
  <%IF rSex  = "woman" then%>
  여자
  <%ELSEIF rSex = "man" then%>
  남자
  <%Else%>
  <%END IF%>
  </td>
  <td  style="cursor:pointer" onclick='javascript:selGamelevel(<%=strjson%>,<%=rGameLevelidx%>)'>
  <% IF rViewYN = "Y" Then%>
  노출
  <% ELSE %>
  미노출
  <% END IF %>
  </td>
  <td>
    <a href="javascript:;" onclick='javascript:updateGameLevel(<%=rGameLevelidx%>);' class="btn btn-skyblue">수정</a>
    <a href="javascript:;" onclick='javascript:deleteGameLevel(<%=rGameLevelidx%>);' class="btn btn-delete">삭제</a>
    <a href='javascript:ModalGameLevelDtlManage(<%=rGameLevelidx%>,<%=strjson%>);'class="btn btn-blue">관리</a>
  </td>
</tr>