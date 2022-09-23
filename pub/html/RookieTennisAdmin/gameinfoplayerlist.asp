	<tr class="gametitle"  style="cursor:pointer" id="titlelist_<%=idx%>" title="메모 : <%=replaceContTag(txtMemo)%>  , 비밀번호 : <%=replaceContTag(p_UserPass)%>">
		<td  onclick="mx.input_edit(<%=idx%>)"><%=no%></td>
		<!-- <td  onclick="mx.input_edit(<%=idx%>)"><%=title%></td>
		<td  onclick="mx.input_edit(<%=idx%>)"><%=boo%></td>
		<td  onclick="mx.input_edit(<%=idx%>)"><%=teamgbnm%></td>
		<td><a href="#" class="btn" onclick="mx.requestManInfo(<%=idx%>)" accesskey="i">보기</a>&nbsp;&nbsp;</td> -->

		<td  onclick="mx.input_edit(<%=idx%>)"><%=pay_username%></td>
		<td  onclick="mx.input_edit(<%=idx%>)"><%=pay_userphone%></td>
		<td  onclick="mx.input_edit(<%=idx%>)"  title = "발급 가상계좌: <%=vno%>"><%=pay_paymentNm%></td>





		<%If rEntryListYN = "대기자" then%>
			<td style="border-right: 5px solid red;">
				<%=rEntryListYN%>
			</td>
		<%else%>

			<%If CDbl(acctotal) = 0 then%>
				<td style="border-right: 5px solid red;" title = "발급 가상계좌: <%=vno%>">
						<label class="switch" style="margin-bottom:-8px;" title="<%=paytypestr%>" onclick="mx.payCheck(<%=idx%>)">
						<input type="checkbox" id="paystate_<%=idx%>"  value="Y" <%If pay_PaymentType= "Y" then%>checked<%End if%>>
						<span class="slider round"></span>
						</label>
				</td>
			<%else%>

				<%If payok = "" Or isNull(payok) = True Or payok = "1" then%>

				<td style="border-right: 5px solid red;" title = "발급 가상계좌: <%=vno%>">
						<label class="switch" style="margin-bottom:-8px;" title="<%=paytypestr%>" onclick="mx.payCheck(<%=idx%>)">
						<input type="checkbox" id="paystate_<%=idx%>"  value="Y" <%If pay_PaymentType= "Y" then%>checked<%End if%>>
						<span class="slider round"></span>
						</label>
				</td>
					<%If pay_PaymentType= "Y" then%>
						<!-- 현장입금 -->
					<%else%>
						<!-- 미입금 -->
					<%End if%>

				<%else%>
					<td style="border-right: 5px solid red;" title = "발급 가상계좌: <%=vno%>">
						<div  title = "가상계좌, 입금액: <%=payok%> : <%=acctotal%>">
							<a href="javascript:mx.AcctInfo(<%=idx%>,<%=titleidx%>,<%=levelno%>)" class="btn_a btn_func" style="height:100%;width:95%;font-size:15px;background:orange;"
							 title = "가상계좌, 입금액: <%=payok%> : <%=acctotal%>">입금완료</a>
						</div>
					<%End if%>
					</td>
			<%End if%>


		<%End if%>




		<td>
		<a href="javascript:mx.RankingPoint(<%=pidx1%>,'<%=p1nm%>', <%=idx%>, <%=levelno%>, 1)" class="btn_a btn_func" style="height:100%;width:95%;font-size:15px;"><%=p1nm%> [<%=P1_id%>]</a>
		</td>

		<!-- <td  onclick="mx.input_edit(<%=idx%>)"><%=p1rpoint%></td> -->
		<td  onclick="mx.input_edit(<%=idx%>)" style="text-align:left;padding-left:5px;"><%=p1t1 & "," & p1t2%></td>

		<td>
		<a href="javascript:mx.RankingPoint(<%=pidx2%>,'<%=p2nm%>',<%=idx%>, <%=levelno%>, 2)" class="btn_a btn_func"  style="height:100%;width:95%;font-size:15px;"><%=p2nm%> [<%=P2_id%>]</a>
		</td>
		<!-- <td  onclick="mx.input_edit(<%=idx%>)"><%=p2rpoint%></td> -->
		<td  onclick="mx.input_edit(<%=idx%>)" style="text-align:left;padding-left:5px;"><%=p2t1 & "," & p2t2%></td>
		<td  onclick="mx.input_edit(<%=idx%>)"><%=rEntryListYN%></td>
		<td id="player_<%=idx%>"><%=gamemember%></td>
	</tr>
