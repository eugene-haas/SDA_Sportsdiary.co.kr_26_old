	<tr id="titlelist_<%=idx%>" >
		<td class="number"><span><%=idx%></span></td>
		<td class="competition_name" title="<%=title%>"><span><%=Left(title,15)%>..</span></td>
		<td class="department_name">
					<select id="LevelGb_<%=idx%>" class="td_select">
							<%
							If IsArray(arrRS) Then
								For ar = LBound(arrRS, 2) To UBound(arrRS, 2)
									LevelNm = arrRS(0, ar)
									Level_no = arrRS(1, ar)
								%>
										<option value="<%=Level_no%>" <%If CStr(Level_no) = levelno then%>selected<%End if%>><%=LevelNm%></option>
								<%
								i = i + 1
								Next
							End if
							%>
					</select>

			<a href="javascript:mx.changeBoo(<%=idx%>,<%=levelno%>)" class="change_btn">변 경</a>
		</td>
		<td class="depositor_name" title = "비밀번호: <%=p_UserPass%>, 발급 가상계좌: <%=vno%>" onclick="alert('<%=vno%>')"><span><%=pay_username%></span></td>
		<td class="tel"><span><%=pay_userphone%></span></td>
		<td class="deposit_condition">

			<div class="switch_box">
				<ul>
					<li>
						<%If rEntryListYN = "대기자" then%>
							<div class="switch switch-red">
							<span class="waiting"><%=rEntryListYN%></span>
							</div>
						<%else%>
							<%If CDbl(acctotal) = 0 then%>
							<div class="switch switch-red">
									<input type="radio" class="switch-input" name="paystate<%=idx%>" id="paystate_<%=idx%>_on" value="Y" <%If pay_PaymentType= "Y" then%>checked<%End if%>>
									<label for="paystate_<%=idx%>_on" class="switch-label switch-label-off"  title="<%=paytypestr%>" onclick="mx.payCheck(<%=idx%>,'ON')">on</label>
									<input type="radio" class="switch-input" name="paystate<%=idx%>" id="paystate_<%=idx%>_off" value="N" <%If pay_PaymentType= "N" then%>checked<%End if%>>
									<label for="paystate_<%=idx%>_off" class="switch-label switch-label-on"  title="<%=paytypestr%>" onclick="mx.payCheck(<%=idx%>,'OFF')">off</label>
									<span class="switch-selection"></span>
							</div>
							<%else%>

								<%If payok = "" Or isNull(payok) = True Or payok = "1" then%>

									<div class="switch switch-red">
											<input type="radio" class="switch-input" name="paystate<%=idx%>" id="paystate_<%=idx%>_on" value="Y" <%If pay_PaymentType= "Y" then%>checked<%End if%>>
											<label for="paystate_<%=idx%>_on" class="switch-label switch-label-off"  title="<%=paytypestr%>" onclick="mx.payCheck(<%=idx%>,'ON')">on</label>
											<input type="radio" class="switch-input" name="paystate<%=idx%>" id="paystate_<%=idx%>_off" value="N" <%If pay_PaymentType= "N" then%>checked<%End if%>>
											<label for="paystate_<%=idx%>_off" class="switch-label switch-label-on"  title="<%=paytypestr%>" onclick="mx.payCheck(<%=idx%>,'OFF')">off</label>
											<span class="switch-selection"></span>
									</div>

									<%If pay_PaymentType= "Y" then%>
										<!-- 현장입금 -->
									<%else%>
										<!-- 미입금 -->
									<%End if%>

								<%else%>
									<div  title = "가상계좌, 입금액: <%=payok%> : <%=acctotal%>">
										<a href="javascript:mx.AcctInfo(<%=idx%>,<%=tidx%>,<%=levelno%>)" class="name_btn"style="background:orange;">입금완료</a>
									</div>
								<%End if%>
							<%End if%>
						<%End if%>
					</li>
				</ul>
			</div>

		</td>
		<td class="player_a">
			<%If p1nm <> "" then%><a href="javascript:mx.RankingPoint(<%=pidx1%>,'<%=p1nm%>',<%=tidx%>,<%=levelno%>,'<%=title%>', 1)" class="name_btn"><%=p1nm%></a><%End if%>
		</td>
		<td class="player_b">
			<%If p2nm <> "" then%><a href="javascript:mx.RankingPoint(<%=pidx2%>,'<%=p2nm%>',<%=tidx%>,<%=levelno%>,'<%=title%>', 2)" class="name_btn"><%=p2nm%></a><%End if%>
		</td>
		<td class="player_change">
			<a href="javascript:mx.updateMember(<%=idx%>,<%=tidx%>,<%=levelno%>)" class="name_btn">선수교체</a>
		</td>
		<td class="attend_division">

		<%If rEntryListYN = "대기자" then%>
		<span class="waiting"><%=rEntryListYN%></span>
		<%else%>
		<span class="participant"><%=rEntryListYN%></span>
		<%End if%>

		</td>
		<td id="player_<%=idx%>"><%=gamemember%></td>

		<%If rEntryListYN = "대기자" then%>
			<td>대기자</td>
		<%else%>

			<%If vno <> "" then%>
				<td><a href="javascript:mx.sendAcctMsg(<%=idx%>,<%=tidx%>,<%=levelno%>)" class="name_btn">문자발송</a></td>
			<%else%>
				<td>&nbsp;</td>
			<%End if%>

		<%End if%>
	</tr>
