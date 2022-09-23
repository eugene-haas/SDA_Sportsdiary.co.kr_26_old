


				<th scope="row"><label for="competition-name">예선데이터밀어넣을곳</label></th>
				<td>
					<select  id="TitleCode" style="width:180px;" onchange="mx.find1()">
					<option value="">==선택==</option>
						<%
						If IsArray(arrRT) Then
							For ar = LBound(arrRT, 2) To UBound(arrRT, 2) 
								t_tidx = arrRT(0, ar)
								t_tname = arrRT(1, ar)
								%><option value="<%=t_tidx%>"  <%If CDbl(t_tidx) = CDbl(tidx) then%>selected<%End if%>><%=t_tname%></option><%
							Next
						End if
						%>
					</select>				

				
				
					<%If tidx <> "" then%>
						<select id="booColde"  style="width:180px;" onchange="$('#btnsave').show();$('#btndel').show()">
						<option value="">==선택==</option>
							<%			
							If IsArray(arrRS) Then
								For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 

									RGameLevelIdx = arrRS(0, ar) 
									PTeamGbNm = arrRS(1, ar)
									LevelNm = arrRS(2, ar)

								
								%>
										<option value="<%=RGameLevelIdx&","&PTeamGbNm%>"><%=PTeamGbNm &"("&LevelNm&")"%></option>
								<%
								i = i + 1
								Next
							End if					
							%>
						</select>
					<%End if%>

					<a href="javascript:mx.setGame();" id="btnsave" class="btn" accesskey="i" style="display:none;">예선대진표등록</a>
					<a href="javascript:mx.delGame();" id="btndel" class="btn" accesskey="i" style="display:none;">등록삭제</a>

				</td>


