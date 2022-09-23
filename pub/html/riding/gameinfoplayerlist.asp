
	<tr class="gametitle" id="titlelist_<%=idx%>" title="메모 : <%=replaceContTag(txtMemo)%>  , 비밀번호 : <%=replaceContTag(p_UserPass)%>">
		<td><span><%=no%></span></td>
		<td><span><%=pay_username%></span></td>
		<td><span><%=CStr(p1phone)%></span></td>
		<td title = "발급 가상계좌: <%=vno%>"><span><%=pay_paymentNm%> <a href="javascript:alert('<%=vno%>')">[가상계좌]</a></span></td>


		<%If rEntryListYN = "대기자" then%>
			<td><span>
				<%=rEntryListYN%>
			</span></td>
		<%else%>

			<%If CDbl(acctotal) = 0 then%>
				<td title = "발급 가상계좌: <%=vno%>">
					<span>
						<label class="switch" title="<%=paytypestr%>" onclick="mx.payCheck(<%=idx%>)">
						<input type="checkbox" id="paystate_<%=idx%>"  value="Y" <%If pay_PaymentType= "Y" then%>checked<%End if%>>
						<span class="slider round"></span></label>
					</span>
				</td>
			<%else%>

				<%If payok = "" Or isNull(payok) = True Or payok = "1" then%>

				<td title = "발급 가상계좌: <%=vno%>">
					<span>
						<label class="switch" title="<%=paytypestr%>" onclick="mx.payCheck(<%=idx%>)">
						<input type="checkbox" id="paystate_<%=idx%>"  value="Y" <%If pay_PaymentType= "Y" then%>checked<%End if%>>
						<span class="slider round"></span></label>
					</span>
				</td>
					<%If pay_PaymentType= "Y" then%>
						<!-- 현장입금 -->
					<%else%>
						<!-- 미입금 -->
					<%End if%>

				<%else%>
					<td title = "발급 가상계좌: <%=vno%>">
						<span>
							<div  title = "가상계좌, 입금액: <%=payok%> : <%=acctotal%>">
								<a href="javascript:mx.AcctInfo(<%=idx%>,<%=titleidx%>,<%=levelno%>)" class="btn_a btn_func btn btn-success" title = "가상계좌, 입금액: <%=payok%> : <%=acctotal%>">입금완료</a>
							</div>
						</span>
					<%End if%>
					</td>
			<%End if%>

		<%End if%>




		<td>
			<span>
				<%=p1nm%>
			</span>
		</td>


		<td><span><%=p2nm%></span></td>

		<td>
			<span>
				<%=pnm%>
			</span>
		</td>

		<td><span><%=rEntryListYN%></span></td>
		<td id="player_<%=idx%>"><span><%=gamemember%></span></td>
	</tr>

