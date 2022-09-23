
	<tr>
		<th>영상</th><th>종목</th><th>대회일</th><th>대회이름</th><th>학군</th><th>종별</th><th>방식</th><th>경기순</th><th>참가선수</th><th>성별</th><th>세부종별</th>
	</tr>
<%
	If IsArray(arrRS) Then
		For ar = LBound(arrRS, 2) To UBound(arrRS, 2)

		rsGameVideoIDX = arrRS(0, ar)
		'Youtube 영상 id
		rsGameVideo = arrRS(1, ar)
    If Instr(rsGameVideo, "/") > 0 Then
  		rsGameVideoIdarr = Split(rsGameVideo,"/")
  		rsGameVideoId = rsGameVideoIdarr(3)
    Else
      rsGameVideoId = "NoVideo"
    End If

		rsClassName = arrRS(2, ar)
		rsGameSDate = arrRS(3, ar)
		rsGameEDate = arrRS(4, ar)
		rsGameName = arrRS(5, ar)
		rsGameAgeDistinct = arrRS(6, ar)
		rsGameGroupType = arrRS(7, ar)
		rsGameMember = arrRS(8, ar)
		rsGameMemberGender = arrRS(9, ar)
		rsGameMatchType = arrRS(10, ar)
		rsGameOrder = arrRS(11, ar)
		rsDetailType = arrRS(12, ar)

		%><tr id="game_<%=rsGameVideoIDX%>"  onclick="">
        <% If rsGameVideoId = "NoVideo" Then %>
        <td class="video" style="width:154px;"><a href="#">잘못된 영상주소입니다.</a></td>
        <% Else %>
				<td class="video" style="width:154px;"><a href="javascript:mx.viewGameVideo('<%=rsGameName%>','<%=rsGameVideoId%>')"><img src="https://img.youtube.com/vi/<%=rsGameVideoId%>/hqdefault.jpg" style="width:100%;"></a></td>
        <% End If %>
				<td><%=rsClassName%></td>
				<td><%=rsGameSDate%> ~ <%=rsGameEDate%></td>
				<td><%=rsGameName%></td>
				<td><%=rsGameAgeDistinct%></td>
				<td><%=rsGameGroupType%></td>
				<td><%=rsGameMatchType%></td>
				<td><%=rsGameOrder%></td>
				<td><%=rsGameMember%></td>
				<td><%=rsGameMemberGender%></td>
				<td><%=rsDetailType%></td>
			</tr><%
		Next
	End If
%>
