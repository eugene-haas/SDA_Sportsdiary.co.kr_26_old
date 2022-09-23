				<ul>
					<li>
						<select  id="TitleCode" onchange="mx_gameRull.find1()" class="sl_search">
						<option value="">==대회선택==</option>
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
					</li>
					<li>
						<%If tidx <> "" then%>
						<select id="booColde"  class="sl_search" onchange="$('#btnsave').show();$('#btnmake').show();mx_gameRull.find2();">
						<option value="">==부서선택==</option>
							<%			
							If IsArray(arrRS) Then
								For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 

									RGameLevelIdx = arrRS(0, ar) 
									PTeamGbNm = arrRS(1, ar)
									LevelNm = arrRS(2, ar)
								%>
									<option value="<%=RGameLevelIdx&","&PTeamGbNm%>" <%If CDbl(ridx) = CDbl(RGameLevelIdx) then%>selected<%End if%>><%=PTeamGbNm &"("&LevelNm&")"%></option>
								<%
								i = i + 1
								Next
							End if					
							%>
						</select>
						<%End If%>
					</li>
					<li>
						<%If tidx <> "" then%>
						<span class="txt_50">조수:</span>
						<input type="number" id="jono" class="in_txt w_50" value="<%=p_jonocnt%>" onChange="mx_gameRull.jonoChange();" onfocus="this.select();" >
						<%End if%>
					</li>
					<li>
						<%If tidx <> "" then%>
						<span class="txt_50">시드:</span>
						<input type="number" id="seedcnt" class="in_txt w_50" value="<%=p_seedcnt%>" onfocus="this.select();"   onkeydown="if(event.keyCode == 13){ mx_gameRull.setGame();}">
						<%End if%>
					</li>

					<li>
						<%If tidx <> "" then%>
							<a href="javascript:mx_gameRull.setGame();" id="btnsave" class="search_btn">본선대진</a>
							<input type="button" onclick="mx_gameRull.setGame()"  id="btnsave2" style="display:none;" value="본선대진">
						<%End if%>
					</li>
				</ul>


