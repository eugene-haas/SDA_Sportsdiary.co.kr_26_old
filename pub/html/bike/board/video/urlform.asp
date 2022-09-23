<% If Mode = "edit" Then %>
  <!-- url이 0개 일때는 안나오도록. -->
  <% If cIDX <> "" Then%>
  <tr id="video_<%=cIDX%>">
      <th>URL</th>
      <td>
          <input type="text" idx="<%=cIDX%>" video placeholder="ex) https://www.youtube.com/watch?v=AbCd1234EfG" value="https://www.youtube.com/watch?v=<%=url%>" class="in-style-1" disabled>
          <a href="#" class="blue-btn view-btn" onclick="mx.previewVideo($(this));">영상미리보기</a>
          <a href="#" class="icon-btn">
            <i class="fas fa-minus-circle" onclick="mx.delVideo(<%=cIDX%>, <%=seq%>);"></i>
          </a>
      </td>
  </tr>
  <% End If %>
<% Else %>
  <tr>
      <th>URL</th>
      <td>
          <input type="text" video placeholder="URL 주소를 입력 해주세요." class="in-style-1">
          <a href="#" class="blue-btn view-btn" onclick="mx.previewVideo($(this));">영상미리보기</a>
          <a href="#" class="icon-btn">
              <% If add = "Y" Then %>
                  <i class="fas fa-minus-circle" onclick="mx.removeUrl($(this));"></i>
              <% Else %>
                  <i class="fas fa-plus-circle" onclick="mx.addUrl();"></i>
              <% End If %>
          </a>
      </td>
  </tr>
<% End If %>
