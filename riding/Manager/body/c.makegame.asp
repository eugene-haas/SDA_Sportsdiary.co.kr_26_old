<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################

	intPageNum = PN
	intPageSize = 20
	strTableName = " sd_TennisTitle as a "
	'stateNo = 게임상태 0표시전, 3 예선대진표보임 , 4 예선마감상태, 5 본선대진표보임 , 6 본선마감사태 , 7 결과발표보임
	strFieldName = " GameTitleIDX,stateNo,GameTitleName,GameS,GameE,GameYear,GameArea,ViewYN,ViewState,hostname,subjectnm,afternm,titleCode,titleGrade,gameNa,kgame,gameTypeE,gameTypeA,gameTypeL,gameTypeP,gameTypeG   ,vacReturnYN "


	setmember = "(select count(*) from sd_tennisMember where gametitleidx = a.gametitleidx) as setmember "
	setbase = "(select count(*) from tblGameRequest_TEMP where gametitleidx = a.gametitleidx) as setbase "
	attcnt = " (select count(*) from tblGameRequest as x left join tblGameRequest_r  as y ON x.requestidx = y.requestidx  where x.delyn='N' and x.gametitleidx  = a.gametitleidx ) as attcnt "
	strFieldName = " gametitleidx,kgame,GameArea,hostname,subjectnm,afternm,GameTitleName,titleCode,GameS,GameE, ViewState,ViewYN,stateNo, "	 & attcnt & ",exlfile" & ", " & setbase& ", " & setmember

	strSort = "  order by GameS desc"
	strSortR = "  order by GameS"

	strWhere = " DelYN = 'N'   "


	Dim intTotalCnt, intTotalPage
	Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
	block_size = 10


'Call rsdrow(rs)
'Response.end

SENDPRE = "setgame_"
%>
<%'View ####################################################################################################%>



		<!-- s: 콘텐츠 시작 -->
		<div class="admin_content">
			<div class="page_title"><h1>대회운영  (참가자밀어넣기) </h1></div>
			<hr />
			<!-- s: 리스트 버튼 -->
		  <div class="btn-toolbar" role="toolbar" aria-label="btns">
		</div>

			</div>
			<!-- e: 리스트 버튼 -->



			<!-- s: 테이블 리스트 -->
			<div class="table-responsive">
				<table cellspacing="0" cellpadding="0" class="table table-hover">
					<thead>
						<tr>
								<th>NO</th>
								<th>년도</th>
								<th>대회명</th>
								<th>대회기간</th>
								<th>진행상태</th>
								<th>참가(명)</th>
								<th>업로드</th>
								<th>기본설정</th>
								<th>참가에넣기</th>
								<th>리셋</th>
						</tr>
					</thead>
					<tbody id="contest"  class="gametitle">
					<tr id="fc" style="display:none;"><td>first child</td></tr>
					<%
					Do Until rs.eof
						l_idx = rs(0)
						l_GameTitleName = rs("GameTitleName")
						l_GameS = rs("GameS")
						l_GameE = rs("GameE")
						l_GameArea = rs("GameArea")
						l_VliewYN = rs("ViewYN")
						l_MatchYN = rs("stateNo")
						l_ViewState = rs("ViewState")
						l_subjectnm = rs("subjectnm") '주관
						l_afternm = rs("afternm") '후원

						l_titlecode = rs("titlecode")
						l_kgame = rs("kgame")
						l_attcnt = rs("attcnt")
						l_exlfile = isNulldefault(rs("exlfile"),"")
						l_setbase = rs("setbase")
						l_setmember = rs("setmember")
						%>


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
			<%If l_GameE > now() then%>	
			<td >진행전</td>
			<%ElseIf  l_GameS >= now() And l_GameE <= now() then%>
			<td class="danger">진행중</td>
			<%else%>
			<td class="bg-gray">종료</td>
			<%End if%>
			
			<td><%=l_attcnt%></td>

<%If CDbl(l_idx) > 59 then%>

			<td><span>
			<%If l_exlfile = "" then%>
			<a href="javascript:mx.fileuploadPop(3,<%=l_idx%>,'<%=SENDPRE%>')" class="btn btn-primary">업로드</a></span>
			<%else%>
			<a href="javascript:mx.fileuploadPop(3,<%=l_idx%>,'<%=SENDPRE%>')" class="btn bg-gray"><%=LCase(Mid(l_exlfile, InStrRev(l_exlfile, "/") + 1))%></a></span>
			<%End if%>
			</td>
			<td>
			<%If l_setbase > 0 then%>
				  <a  class="btn bg-gray">설정완료</a>
			<%else%>
				  <a href="javascript:mx.insertTemp(<%=l_idx%>,'<%=SENDPRE%>')" class="btn btn-primary">기본설정</a>
			<%End if%>
			</td>			
			<td>
			<%If l_setmember > 0 then%>				 
				  <a  class="btn bg-gray">넣기 완료</a>
			<%else%>
				  <a href="javascript:mx.insertRequest(<%=l_idx%>,'<%=SENDPRE%>')" class="btn btn-primary">참가신청넣기</a>
			<%End if%>
			</td>			
			<td>
				  <%If l_GameE > now() then%>
				  <a href="javascript:mx.resetData(<%=l_idx%>,'<%=SENDPRE%>')" class="btn btn-danger">삭제</a>
				  <%else%>
					<a  class="btn btn-danger" disabled>삭제</a><!-- href="javascript:alert('종료되어 삭제하실수 없습니다.')" -->
				  <%End if%>
			</td>			
<%Else '이전자료 변경되지 않도록 처리%>
			<td>-</td>
			<td>-</td>			
			<td>-</td>		
			<td>-</td>
<%End if%>


		</tr>
<%ci = ci + 1%>



					  <%
					  rs.movenext
					  Loop
					  Set rs = Nothing
					%>

					</tbody>
				</table>
			</div>
			<!-- e: 테이블 리스트 -->

			<nav>
				<%
					jsonstr = JSON.stringify(oJSONoutput)
					Call userPagingT2 (intTotalPage, 10, PN, "px.goPN", jsonstr )
				%>
			</nav>
		</div>
		<!-- s: 콘텐츠 끝 -->
