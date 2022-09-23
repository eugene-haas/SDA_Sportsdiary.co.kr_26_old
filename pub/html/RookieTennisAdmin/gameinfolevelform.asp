		
		<input type="hidden" id="idx" value="<%=updateidx%>" />
		<input type="hidden" id="TitleIDX" value="<%=idx%>" />

		<table class="navi-tp-table">
			<caption>대회정보관리 기본정보</caption>
			<colgroup>
				<col width="90px">
				<col width="400px">
				<col width="100px">
				<col width="270px">
				<col width="94px">
				<col width="*">
			</colgroup>
			<tbody>
				<tr>
					<th scope="row"><label for="competition-name">대회명</label></th>
					<td id="sel_GameTitle" colspan="3"><strong><%=title%></strong></td>
				</tr>

				<tr id="level_form">
					<!-- #include virtual = "/pub/html/RookietennisAdmin/gameinfoLevelFormLine1.asp" -->
				</tr>

				<tr>
					<th scope="row">경기일자</th>
					<td>
						<input type="hidden"  id="VersusGb"  value="sd043003">
						<input type="text" id="GameDate" style="width:150px;" value="<%=gamedate%>">&nbsp;<input type="text"  id="GameTime"  placeholder="경기시간" class='timepicker' style="width:150px;" value="<%=gametime%>">
					</td>


					<th scope="row">예선조수</th>
					<td id="sel_VersusGb">

					<input type="number" id="joocnt" style="width:75px;height:30px;margin-bottom:0px;text-align:right;" value="<%=joocnt%>">
					<!-- <select name="VersusGb" id="VersusGb" disabled>
					<option value="">==선택==</option>
					<option value="sd043003"  <%'If gametype = "sd043003" then%>selected<%'End if%>>리그&gt;토너먼트</option>
					<%'sd043002"  토너먼트%>
					</select> -->
					</td>

					<th scope="row">잔여팀수/최종</th>
					<td>
					<select id="LastRnd" style="width:50px;" title="본선 진행할 표시 라운드 입니다.">
						<option value="2" <%If endround = "2" then%>selected<%End if%>>1</option>
						<option value="4" <%If endround = "4" then%>selected<%End if%>>2</option>
						<option value="8" <%If endround = "8" then%>selected<%End if%>>4</option>
						<option value="16" <%If endround = "16" then%>selected<%End if%>>8</option>
						<option value="32" <%If endround = "32" then%>selected<%End if%>>16</option>
					</select>

					<select id="LastRchk" style="width:70px;" title="최종라운드에서 랭킹강수를 구하기 위해서 필요한 정보입니다.">
						<option value="0" <%If LastRchk = "0" then%>selected<%End if%>>1</option>
						<option value="2" <%If LastRchk = "2" then%>selected<%End if%>>2강</option>
						<option value="3" <%If LastRchk = "3" then%>selected<%End if%>>4강</option>
						<option value="4" <%If LastRchk = "4" then%>selected<%End if%>>8강</option>
					</select>
					</td>


				<!-- 
				</tr>
                 <tr>
                    <th scope="row">사은품</th>
                    <td colspan="6">
						<select  id="bigo" >
						  <option value="">=상품명=</option>
							  <%
							  If IsArray(arrG) Then
								  For ar = LBound(arrG, 2) To UBound(arrG, 2)
									  gpnm = arrG(0, ar)
									  %><option value="<%=gpnm%>" <%If gpnm = gameprize then%>selected<%End if%>><%=gpnm%></option><%
								  i = i + 1
								  Next
							  End if
							  %>
						</select>						  
                    </td>
                </tr> -->

			</tbody>
		</table>