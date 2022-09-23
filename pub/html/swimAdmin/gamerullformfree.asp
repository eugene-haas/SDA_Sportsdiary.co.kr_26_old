				<th scope="row"><label for="competition-name"></label></th>
				<td>
					<select  id="TitleCode" style="width:180px;" onchange="mx_gameRull.find1()">
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

				
				
					<%If tidx <> "" then%>
						<select id="booColde"  style="width:180px;" onchange="$('#btnsave').show();$('#btnmake').show();mx_gameRull.find2();">
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
						&nbsp;&nbsp;
						조수 : <input type="number" id="jono" style="width:60px;height:30px;margin-top:10px;" value="30" onChange="mx_gameRull.jonoChange();" onfocus="this.select();" >
						드로우 : <input type="number" id="attteamcnt" style="width:60px;height:30px;margin-top:10px;" value="64" onfocus="this.select();" >
						시드 : <input type="number" id="seedcnt" style="width:60px;height:30px;margin-top:10px;" value="8" onfocus="this.select();" >

					
					<a href="javascript:mx_gameRull.setGame();" id="btnsave" class="btn" accesskey="i"  >본선대진</a>
					<input type="button" onclick="mx_gameRull.setGame()"  id="btnsave2" style="display:none;" value="본선대진">

					<!-- &nbsp;<a href="javascript:mx_gameRull.saveGame();" id="btnmake" class="btn" accesskey="i" style="display:none;">저장</a>
					&nbsp;<a href="javascript:mx_gameRull.DelGame();" id="btndelGame" class="btn" accesskey="i" style="display:none;">삭제</a>
					&nbsp;&nbsp;<a href="javascript:mx_gameRull.DelGame();" id="btnSearch" class="btn" accesskey="i" onchange="$('#btnsave').show();$('#btnmake').show();mx_gameRull.find2();">조회</a> -->				
					<%End if%>
				</td>


