					<th scope="row">대회명</th>
					<td>
						<input type="text" id="hosttitle" value="<%=hostTitle%>" width="150px;">
					</td>

					<th scope="row">등급</th>
					<td>
						<select  id="gamegrade" >
						<option value="2"  <%If titleGrade = "2" then%>selected<%End if%>>GA</option>
						<option value="1"  <%If titleGrade = "1" then%>selected<%End if%>>SA</option>
						<option value="3"  <%If titleGrade = "3" then%>selected<%End if%>>A</option>
						<option value="4"  <%If titleGrade = "4" then%>selected<%End if%>>B</option>
						<option value="5"  <%If titleGrade = "5" then%>selected<%End if%>>C</option>
						<option value="6"  <%If titleGrade = "6" then%>selected<%End if%>>D</option>
						<option value="7"  <%If titleGrade = "7" then%>selected<%End if%>>E</option>
						<option value="8"  <%If titleGrade = "8" then%>selected<%End if%>>비랭킹</option>
						</select>
					</td>