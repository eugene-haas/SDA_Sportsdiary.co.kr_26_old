
					<tr style="cursor:pointer;" id="game_<%=gameVideoIDX%>" value=<%=gameVideoIDX%> onclick="mx.input_edit(<%=gameVideoIDX%>)">
						<td style="line-height:normal;"><%=gameVideoIDX%></td>
						<td style="line-height:normal;"><%=rsClassName%></td>
						<td style="line-height:normal;"><%=rsGameSDate%> ~ <%=rsGameEDate%></td>
						<td style="line-height:normal;"><%=rsGameName%></td>
						<td style="line-height:normal;"><%=rsGameAgeDistinct%></td>
						<td style="line-height:normal;"><%=rsGameGroupType%></td>
						<td style="line-height:normal;"><%=rsGameMatchType%></td>
						<td style="line-height:normal;"><%=rsGameOrder%></td>
						<td style="max-width:210px;overflow:hidden;line-height:normal;"><p style="line-height:40px;display:inline-block;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;height:40px;"><%=rsGameMember%></p></td>
						<td style="line-height:normal;"><%=rsGameMemberGender%></td>
						<td style="line-height:normal;"><%=rsDetailType%></td>
						<td style="line-height:normal;" onclick="mx.viewVideo('<%=rsGameVideo%>');"><%=rsGameVideo%></td>
					</tr>
