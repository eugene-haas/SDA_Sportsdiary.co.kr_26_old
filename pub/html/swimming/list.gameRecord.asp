


<%
If ci = "" Then
ci = 1 
End if
list_no = (intPageSize * (intPageNum-1)) + ci
'############################
%>

		<tr id="titlelist_<%=l_idx%>" style="text-align:center;">
			<td><%=list_no%></td>
			<td><%=Left(l_GameS,4)%></td>
			<td style="text-align:left;"><%=l_GameTitleName%></td></td>
			<td><%=l_GameS%>~<%=l_GameE%></td>

<%
'l_chkdates = CDate(rs(13))
'l_chkdatee = CDate(rs(14))
%>

			<%If l_chkdatee > now() then%>	
			<td >진행전</td>
			<%ElseIf  l_chkdates >= now() And l_chkdatee <= now() then%>
			<td class="danger">진행중</td>
			<%else%>
			<td class="bg-gray">종료</td>
			<%End if%>
			
			<td><%=l_attcnt%></td>
			<td><%=l_gamearea%></td><!-- 전체,모바일,홈페이지 -->
			<td><%=l_entertype%>
			<%
			Select Case l_entertype
			Case "E" : Response.write "전문" 
			Case "A" : Response.write "생활" 
			case "T" : Response.write "전문,생활" 
			end Select 
			%></td><!-- 아마추어 A 엘리트 E 통합 T -->
			<td><span>
			<a href="javascript:px.goSubmit({'TIDX':<%=l_idx%>,'DIDX':'','KYN':'<%=l_kgame%>'},'inputRecord.asp')" class="btn btn-primary">경영</a>
			<%If ADGRADE > 500 then%>
			<a href="javascript:px.goSubmit({'TIDX':<%=l_idx%>,'DIDX':'','KYN':'<%=l_kgame%>'},'inputRecord2.asp')" class="btn btn-primary">다이빙</a>
			<a href="javascript:px.goSubmit({'TIDX':<%=l_idx%>,'DIDX':'','KYN':'<%=l_kgame%>'},'inputRecord3.asp')" class="btn btn-primary">아티스틱</a>
			<a href="javascript:px.goSubmit({'TIDX':<%=l_idx%>,'DIDX':'','KYN':'<%=l_kgame%>'},'inputRecord4.asp')" class="btn btn-primary">수구</a>
			<%End if%>
			</span></td>
			
			<!-- <td>
				  <a href="javascript:px.goSubmit({'TIDX':<%=l_idx%>,'SDA':'<%=F1%>','LNM':'<%=l_GameTitleName%>'},'gameTable.asp')" class="btn btn-primary"><i class="fa fa-fw fa-sitemap"></i> 대진표</a>
			</td>	 -->		
<%If ADGRADE > 500 then%>
			<td>
				  <a href="javascript:px.goSubmit({'TIDX':<%=l_idx%>,'SDA':'<%=F1%>','LNM':'<%=l_GameTitleName%>'},'rcOK.asp')" class="btn btn-primary"><i class="fa fa-thumbs-up"> </i>신기록승인</a>
			</td>			
<%End if%>
		</tr>

<%ci = ci + 1%>