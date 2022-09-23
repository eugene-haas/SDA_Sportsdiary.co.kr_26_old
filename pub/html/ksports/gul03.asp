		<li>
      <span class="txt">대회일자</span>
      <input type="text" id="gameSDate" value="<%=rsGameSDate%>" class="in_txt w_50" style="margin-right:8px;" placeholder="대회시작일자" readonly; >
			<input type="text" id="gameEDate" value="<%=rsGameEDate%>" class="in_txt w_50" style="margin-right:8px;" placeholder="대회끝일자"  >
    </li>
		<li>
			<span class="txt">학군</span>
			<select id="gameAgeDistinct">
				<option value="">=학군선택=</option>
				<%
				If IsArray(arrAge) Then
					For ar = LBound(arrAge, 2) To UBound(arrAge, 2)
						CodeValue  = arrAge(0, ar)
						CodeText = arrAge(1, ar)
						%><option value="<%=CodeValue%>" <% If rsGameAgeDistinct = CodeValue Then %> selected <% End If%> ><%=CodeText%></option><%
					Next
				End If
				%>
			</select>
		</li>
		<li>
			<span class="txt">종별</span>
			<select id="gameGroupType">
				<option value="">=종별선택=</option>
				<%
				If IsArray(arrGroup) Then
					For ar = LBound(arrGroup, 2) To UBound(arrGroup, 2)
						CodeValue  = arrGroup(0, ar)
						CodeText = arrGroup(1, ar)
						%><option value="<%=CodeValue%>" <% If rsGameGroupType = CodeValue Then %> selected <% End If%> ><%=CodeText%></option><%
					Next
				End If
				%>
			</select>
		</li>
		<li>
			<span class="txt">세부종별</span>
			<select id="gameDetailType" onchange="mx.insertDetailType();">
				<option value="">=세부종별선택=</option>
				<%
				If IsArray(arrDT) Then
					For ar = LBound(arrDT, 2) To UBound(arrDT, 2)
						idx  = arrDT(0, ar)
						detailType = arrDT(1, ar)
						%><option value="<%=idx%>"  id="detailType_<%=idx%>" <% If rsDetailType = idx Then %> selected <% End If%> ><%=detailType%></option><%
					Next
				End If
				%>
				<option value="insert" >[추가생성]</option>
			</select>
		</li>
		<li>
			<span class="txt">방식</span>
			<select id="gameMatchType">
				<option value="">=방식선택=</option>
				<%
				If IsArray(arrMatch) Then
					For ar = LBound(arrMatch, 2) To UBound(arrMatch, 2)
						CodeValue  = arrMatch(0, ar)
						CodeText = arrMatch(1, ar)
						%><option value="<%=CodeValue%>" <% If rsGameMatchType = CodeValue Then %> selected <% End If%> ><%=CodeText%></option><%
					Next
				End If
				%>
			</select>
		</li>
		<li>
			<span class="txt">성별</span>
			<select id="gameMemberGender">
				<option value="">=성별선택=</option>
				<%
				If IsArray(arrGender) Then
					For ar = LBound(arrGender, 2) To UBound(arrGender, 2)
						CodeValue  = arrGender(0, ar)
						CodeText = arrGender(1, ar)
						%><option value="<%=CodeValue%>" <% If rsGameMemberGender = CodeValue Then %> selected <% End If%> ><%=CodeText%></option><%
					Next
				End If
				%>
			</select>
		</li>
    <li>
      <span class="txt">영상파일명</span>
			<input type="text" id="gameFileName"  maxlength="150" value="<%=rsGameFileName%>" style="width:240px;"></input>
    </li>
		<li style="width:331px;">
			<span class="txt">영상링크</span>
			<input type="text" id="gameVideo"  maxlength="150" value="<%=rsGameVideo%>" style="width:240px;"></input>
		</li>
		<li>
			<span class="txt">경기순</span>
			<input type="text" id="gameOrder"  maxlength="10" value="<%=rsGameOrder%>"></input>
		</li>
		<li>
			<span class="txt">참가선수(팀)</span>
			<input type="text" id="gameMember" placeholder="참가선수1,참가선수2,참가선수3 ..." maxlength="500" value="<%=rsGameMember%>"></input>
		</li>
