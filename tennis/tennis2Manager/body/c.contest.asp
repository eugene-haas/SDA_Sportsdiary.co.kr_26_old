<%
 'Controller ################################################################################################

  'request 처리##############
  page = chkInt(chkReqMethod("page", "GET"), 1)
  search_word = chkLength(chkStrRpl(chkReqMethod("search_word", ""), ""), 10) 'chkStrReq 막음 chkStrRpl replace
  search_first = chkInt(chkReqMethod("search_first", "POST"), 0)

  page = iif(search_first = "1", 1, page)
  'request 처리##############


	strTableName = " sd_TennisTitle "
	'stateNo = 게임상태 0표시전, 3 예선대진표보임 , 4 예선마감상태, 5 본선대진표보임 , 6 본선마감사태 , 7 결과발표보임
	strFieldName = " GameTitleIDX,gameTitleName,GameS,GameE,GameYear,cfg,GameRcvDateS,GameRcvDateE,ViewYN,MatchYN,viewState,stateNo,titlecode,titlegrade,vacReturnYN , tnshowhide" '본선대진보임안보임

	strSort = "  order by GameS desc"
	strSortR = "  order by GameS"

	'대회의 날짜가 오늘거만 가져오자. 
	strWhere = " DelYN = 'N' "

	SQL = "select top 2 " & strFieldName & " from " & strTableName & " where " & strWhere & " and GameE >= getdate() -30 " & strSort
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
%>
<%'View ####################################################################################################%>



		<!-- s: 콘텐츠 시작 -->
		<div class="admin_content">
			<div class="page_title">대회정보관리  <span><a href="<%=logouturl%>">로그아웃</a></span></div>

			<!-- s: 테이블 리스트 -->
				<div class="table_list contest">
					<table cellspacing="0" cellpadding="0">
						<tr>
							<th>대회명</th></thead>
						</tr>
						<tbody id="contest">
						<%
						Do Until rs.eof
							idx = rs("GameTitleIDX")
							title = rs("gameTitleName")
							sdate = rs("GameS")
							edate = rs("GameE")
							gamecfg = rs("cfg")
							rcvs = rs("GameRcvDateS")
							rcve = rs("GameRcvDateE")
							tnshow = rs("tnshowhide") '본선 대진표 보임 안보임

							ViewYN = rs("ViewYN")
							MatchYN = rs("stateNo")
							viewState = rs("viewState")
							vacReturnYN = rs("vacReturnYN")

							titleCode = rs("titleCode")
							titleGrade = findGrade(rs("titleGrade"))
							%>
							<tr id="titlelist_<%=idx%>" onmousedown="mx.golevel(<%=idx%>,'<%=title%>')">
								<td class="name" onclick="mx.input_edit(<%=idx%>)"><span class="red_font"><%=titleGrade%></span> <span><%=title%></span></td>
							</tr>
						  <%
						  rs.movenext
						  Loop
						  Set rs = Nothing
						%>


<!-- 테스트용  -->
<%'If USER_IP = "118.33.86.240" then%>
<%'If CDbl(ADGRADE) <= 500 then%>
	<tr class="gametitle"  style="cursor:pointer" id="titlelist_25" onmousedown="mx.golevel(25,'<%=title%>')"  style="background:#BAD6FA;">
		<td   style="text-align:left;padding-left:10px;"><span class="red_font">E</span> 가이드 작성용 테스트 대회</td>
	</tr>
<%'End if%>
<%'End if%>
<!-- 테스트용  -->




						</tbody>
					</table>
				</div>
			<!-- e: 테이블 리스트 -->


		</div>
		<!-- s: 콘텐츠 끝 -->