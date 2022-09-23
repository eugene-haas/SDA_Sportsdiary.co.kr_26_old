<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->


    <link rel="stylesheet" href="http://img.sportsdiary.co.kr/lib/tournament/tournament.css" />
    <script type="text/javascript" src="http://img.sportsdiary.co.kr/lib/tournament/tournament.js"></script>

<%
 'Controller ################################################################################################


	Set db = new clsDBHelper

	'등록된 최소년도
	SQL = "Select min(GameYear) from sd_TennisTitle where delYN = 'N' "
	Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)
	If  isNull(rs(0)) = true then
	  minyear = year(date)
	Else
	  minyear = rs(0)
	End if
	
  	'search
	If chkBlank(F2) Then
		strWhere = " DelYN = 'N'  and GameYear = '"&year(date)&"' " 
		findWhere = " DelYN = 'N'  and GameYear = '"&year(date)&"' " 

		nowgameyear = year(date)
	Else
		If InStr(F1, ",") > 0  Then
			F1 = Split(F1, ",")
			F2 = Split(F2, ",")
		End If

		If IsArray(F1) Then
			fieldarr = array("GameYear","gametitleidx","gbidx")
			F2_0 = F2(0)
			F2_1 = F2(1)
			F2_2 = F2(2)

			tidx = F2_1
			find_gbidx = F2_2
			strWhere = " DelYN = 'N' and "&fieldarr(0)&" = '" & F2_0 &"' and "&fieldarr(1)&" = '"& F2_1 &"' "
			findWhere = " DelYN = 'N'  and GameYear = '"&F2_0&"' " 

			nowgameyear = F2_0	
		Else
			strWhere = " DelYN = 'N' and "&F1&" = '"& F2 &"' "

			If LCase(F1) = "gameyear" Then
				nowgameyear = F2
			End if
		End if
	End if

	'년도별 대회명검색
	fieldstr =  "GameTitleIDX,GameTitleName,GameS,GameE,GameYear,GameArea,kgame  "
	SQL = "Select  "&fieldstr&" from sd_TennisTitle where " & findWhere & " order by GameS desc"
	Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rss.EOF Then
		arrPub = rss.GetRows()
		If kgame = "" then
			If IsArray(arrPub)  Then
				kgame = arrPub(6,0) '체전여부 
			End if
		End if

		If tidx = "" Then
			If IsArray(arrPub)  Then
				tidx = arrPub(0, 0)
			End if
		End if
	End If

	'Response.write "#######################"&kgame
	'년도별 대회별 각경기 리스트
	strTableName2 = "  tblRGameLevel as a inner join tblTeamGbInfo as b  ON a.gbidx = b.teamgbidx "
	strfieldA = " a.RGameLevelidx,a.GbIDX " ',a.GameTitleIDX,a.GbIDX,b.useyear,b.levelno
	strfieldB = " cast(a.gameno as varchar) + '경기 ('+ PTeamGbNm +') : ' + b.TeamGbNm + b.levelNm + ' ' + b.ridingclass + ' ' + b.ridingclasshelp ,a.GameDay,a.GameTime,a.gametimeend,b.TeamGbNm"
	strFieldName2 = strfieldA &  "," & strfieldB
	strSort2 = "  ORDER BY gameno asc"
	strWhere2 = " a.GameTitleIDX = "&tidx&" and a.DelYN = 'N' and b.DelYN = 'N' "

	SQL = "Select "&strFieldName2&" from "&strTableName2&" where " & strWhere2 & strSort2
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	'call getrowsdrow(rs)
	'Call rsdrow(rs)
	'Response.end

'	Response.write f_gbidx

	If Not rs.EOF Then
		arrNo = rs.GetRows()
		If find_gbidx = "" Then
			If IsArray(arrNo)  Then
				find_gbidx = arrNo(1, 0)
				'Response.write find_gbidx &"ddd"
			End if
		End if
	End If

	If IsArray(arrNo)  Then
		For ar = LBound(arrNo, 2) To UBound(arrNo, 2)
			f_gbidx = arrNo(1, ar)

			If F2_2 = "" Then
					find_gbidx = arrNo(1, ar)
					select_f_title =  arrNo(2, ar)
					select_f_date = arrNo(3,ar)
					select_f_stime = arrNo(4,ar)
					select_f_etime = arrNo(5,ar)
					Select_f_teamgbnm = arrNo(6,ar)
				Exit for
			else
				If f_gbidx = "" Or CStr(f_gbidx) <> CStr(f_pregbidx) Then
					If CStr(f_gbidx) = CStr(F2_2) Then
						find_gbidx = arrNo(1, ar)
						select_f_title =  arrNo(2, ar)
						select_f_date = arrNo(3,ar)
						select_f_stime = arrNo(4,ar)
						select_f_etime = arrNo(5,ar)
						Select_f_teamgbnm = arrNo(6,ar)
					End If
				End If
			End if
		f_pregbidx = f_gbidx
		Next
	End if
%>


<%'View ####################################################################################################%>
<div class="admin_content">
  <a name="contenttop"></a>

  <div class="page_title"><h1>대회진행 > 일정관리</h1></div>

  <%If CDbl(ADGRADE) > 500 then%>
	<%If InStr(select_f_title, "릴레이") > 0 then%>
	<%else%>
	<div class="info_serch form-horizontal" id="gameinput_area">
	  <!-- #include virtual = "/pub/html/riding/scform.asp" -->
	</div>
	<%End if%>
	<!-- s: 정보 검색 -->
	<div class="info_serch" id="gameinput_area">
		<!-- #include virtual = "/pub/html/riding/SCFindform.asp" -->
	</div>
	<!-- e: 정보 검색 -->



    <hr />

	<!-- s: 리스트 버튼 -->
	<div class="btn-toolbar" role="toolbar" aria-label="btns">
		<%If InStr(select_f_title, "릴레이") > 0 then%>
		<%else%>
		<a href="javascript:mx.setOrder(<%=tidx%>,<%=nowgameyear%>,<%=find_gbidx%>)" class="btn btn-success">출전순서부여</a>
		<%End if%>
		
		<a href="#" class="btn btn-success" disabled style="width:200px;"><%=select_f_date%> &nbsp;&nbsp;&nbsp;  <%=select_f_stime%>~<%=select_f_etime%></a>
		
		<%If InStr(select_f_title, "릴레이") > 0 then%>
		<a href="javascript:mx.makeGameTable(<%=tidx%>,'<%=find_gbidx%>',1,'make')" class="btn btn-success">리그대진표생성</a>
		<a href="javascript:mx.makeGameTable(<%=tidx%>,'<%=find_gbidx%>',2,'make')" class="btn btn-success">토너먼트대진표생성</a>
		<!-- <a href="javascript:mx.showTourn(<%=tidx%>,<%=nowgameyear%>,<%=find_gbidx%>)" class="btn btn-success">대진표확인</a> -->
		<%End if%>
		
		<div class="btn-group flr">
			<a  id="gdmake" class="btn btn-primary" style="width:500px" disabled>
				<%=select_f_title%>
			</a>
		</div>
	</div>
	<!-- e: 리스트 버튼 -->
 
  <%End if%>

  <%
	'복합마술 타입구분
	'Response.write "#############################################################<br></span>"
	If Select_f_teamgbnm = "복합마술" Then
		If InStr(select_f_title,"마장마술") > 0 Then
			gametype = "BMMM" '게임형태 복합마술 마장마술
		End If
		If InStr(select_f_title,"장애물") > 0 Then
			gametype = "BMJM" '게임형태 복합마술 마장마술
		End if			
	End if
	'Response.write "#############################################################<br></span>"

  %>




  <div class="table-responsive">
  <%
    Response.write "<table cellspacing=""0"" cellpadding=""0"" class=""table table-hover"">"
	If Select_f_teamgbnm = "마장마술" Or gametype = "BMMM"  then
	Response.write "<thead><tr><th>출전순서</th><th>시각</th><th>통합부명</th><th>선수명</th><th>마명</th><th>소속</th><th>참가부명</th><th>기권/실격사유</th><th>사유서제출</th></tr></thead>" '
	Else
		If InStr(select_f_title, "릴레이") > 0 Then
		%><thead><tr><th>No</th><th>팀명</th><th>마명</th><th  colspan='3'>선수명</th><th>기권/실격사유</th><th>사유서제출</th></tr></thead><%
		else
		Response.write "<thead><tr><th>출전순서</th><th>통합부명</th><th>선수명</th><th>마명</th><th>소속</th><th>참가부명</th><th>기권/실격사유</th><th>사유서제출</th></tr></thead>" 
		End if
	End if
    Response.write "<tbody id=""listcontents"">"
    Response.write " <tr class=""gametitle"" ></tr>"

If InStr(select_f_title, "릴레이") > 0 then
	%><%'<!-- #include virtual = "/pub/html/riding/sclist.relay.asp" -->%><%
	%><!-- #include virtual = "/pub/html/riding/sclist.relay.v2.asp" --><%

Else
	%><!-- #include virtual = "/pub/html/riding/sclist.asp" --><%
End If

    Response.write "</tbody>"
    Response.write "</table><br>"
  %>
  
  <%
  'incluse 내용 받아서..
'  If r_a5 = "복합마술" then
'			Response.write "<span style='color:red;'>#############################################################<br>"
'			Response.write "2. 장애물 출전순서 표를 여기에 그리자.<br>"
'			Response.write "3. 충전순서표 버튼 작업 (복합마술인 경우).<br>"

'			Response.write "*. 일정이 들어간다면 ...(리스트의 연속성을 주어 만들어야한다. 화면을 어떻게 해야 연속되며 안끊어질지 파악해보자. 마장마술과 장애물의 정보를 일정에  포함하기 위해 수정작업 필요) <br>"
'			Response.write "#############################################################<br></span>"
'  End If
  %>
  
  </div>


	  <%'===============%>
	  <%If InStr(select_f_title, "릴레이") > 0 then%>
	  <input type="hidden" onclick="mx.makeGameTable(<%=tidx%>,'<%=find_gbidx%>',3,'drow')" id="drowTN">
	  <div class="row" id="tournament2">
			<%
			If tabletype = "2" Then '리그

					Lfld = " a.gameMemberidx,a.playeridx,a.username,a.tryoutgroupno,a.tryoutsortno,a.gamekey3,a.gametitleidx,a.pubname   ,b.playeridx,b.username "
					SQL = "Select "&Lfld&" from sd_tennisMember as a left join  sd_tennisMember_partner as b on a.gameMemberidx = b.gameMemberidx  where a.gametitleidx =  '"&tidx&"' and a.gamekey3 = '"&find_gbidx&"' and a.delyn = 'N' order by a.tryoutsortno "
					Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
					arrT = rs.GetRows()

					Call drowLeage(arrT, "")





					gfldL = ", (SELECT  STUFF(( select top 10 ','+ pnm from sd_groupMember where gameMemberIDX = a.midxL group by pnm for XML path('') ),1,1, '' ))  as pnmL " '그룹소속선수들
					gfldR = ", (SELECT  STUFF(( select top 10 ','+ pnm from sd_groupMember where gameMemberIDX = a.midxR group by pnm for XML path('') ),1,1, '' ))  as pnmR " '그룹소속선수들

					'라운드 형태로 테이블 그림
					SQL = "Select orderno,idx,teamnmL,teamnmR,hnmL,hnmR,midxL,midxR "&gfldL&gfldR&",sayoocode,errL,errR ,errDocL,errDocR from sd_gameMember_vs as a   where tidx =  '"&tidx&"' and gbidx = '"&find_gbidx&"' and delyn = 'N' order by orderno "

					Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
					If Not rs.eof then
					arrL = rs.GetRows()
					'Call getrowsdrow(arrL)
					End if

			%>
			<table cellspacing="0" cellpadding="0" class="table table-hover">
				<thead><tr><th>R</th><th>팀명</th><th>마명</th><th  colspan='3'>선수명</th><th>기권/실격사유</th><th>사유서제출</th></tr></thead>
					<tbody>
				<%
					If IsArray(arrL) Then 
						For ari = LBound(arrL, 2) To UBound(arrL, 2)
							l_orderno = arrL(0,ari)
							l_idx = arrL(1,ari)
							l_teamnmL = arrL(2,ari)
							l_teamnmR = arrL(3,ari)
							l_hnmL = arrL(4,ari)
							l_hnmR = arrL(5,ari)
							l_errL = isnulldefault(arrL(11,ari),"")
							l_errR = isNulldefault(arrL(12,ari),"")
							l_errDocL = isnulldefault(arrL(13,ari),"")
							l_errdocR = isNulldefault(arrL(14,ari),"")

			l_pnmL = arrL(8, ari) '선수들
			If InStr(l_pnmL ,",") > 0 then
			pnmarrL = Split(l_pnmL,",")
				pnmL0 = pnmarrL(0)
				pnmL1 = pnmarrL(1)
				pnmL2 = pnmarrL(2)
			Else
				pnmL0 = ""
				pnmL1 = ""
				pnmL2 = ""
			End If

			l_pnmR = arrL(9, ari) '선수들
			If InStr(l_pnmR ,",") > 0 then
				pnmarrR = Split(l_pnmR,",")
				pnmR0 = pnmarrR(0)
				pnmR1 = pnmarrR(1)
				pnmR2 = pnmarrR(2)
			else
				pnmR0 = ""
				pnmR1 = ""
				pnmR2 = ""
			End if			

					%>
							  <tr>
								<td style="width:200px;text-align:center;" rowspan="2">
									<input id="order<%=l_idx%>" value="<%=l_orderno%>" style="width:40px;text-align:center;" onkeyup="this.value=this.value.replace(/[^0-9]/g,'');mx.changeOrderNo(<%=l_idx%>,this.value,3)" > R
								</td>

								<td><span><%=l_teamnmL%></span></td>
								<td><span><%=l_hnmL%></span></td>
								<td><span><%=pnmL0%></span></td>
								<td><span><%=pnmL1%></span></td>
								<td><span><%=pnmL2%></span></td>

								<td>
								<span>
										<select id="giveupL_<%=l_idx%>" class="form-control<%If l_errL <> "" then%> btn-danger<%End if%>" onchange= "mx.setGiveUpR(<%=tidx%>,<%=find_gbidx%>,<%=l_idx%>,'L')"><!-- 개별 바로바로 저장 -->
											<option value="">==사유선택==</option>
											<option value="E" <%If l_errL = "e" then%>selected<%End if%>>실권(E)</option>
											<option value="R" <%If l_errL = "r" then%>selected<%End if%>>기권(R) 진행중</option>
											<option value="W" <%If l_errL = "w" then%>selected<%End if%>>기권(W) 시작전</option>
											<option value="D" <%If l_errL = "d" then%>selected<%End if%>>실격(D)</option>
										</select>
								</span>
								</td>

								<td>
								<span>
										<select id="giveupdocL_<%=l_idx%>" class="form-control" onchange= "mx.setGiveUpDocR(<%=tidx%>,<%=find_gbidx%>,<%=l_idx%>,'L')"><!-- 개별 바로바로 저장 -->
											<option value="">==선택==</option>						
											<option value="Y"  <%If l_errDocL = "Y" then%>selected<%End if%>>○</option>
											<option value="N" <%If l_errDocL = "N" then%>selected<%End if%>>X</option>
										</select>
								</span>
								</td>
							  </tr>

							  <tr>
								<td><span><%=l_teamnmR%></span></td>
								<td><span><%=l_hnmR%></span></td>
								<td><span><%=pnmR0%></span></td>
								<td><span><%=pnmR1%></span></td>
								<td><span><%=pnmR2%></span></td>

								<td>
								<span>
										<select id="giveupR_<%=l_idx%>" class="form-control<%If l_errR <> "" then%> btn-danger<%End if%>" onchange= "mx.setGiveUpR(<%=tidx%>,<%=find_gbidx%>,<%=l_idx%>,'R')"><!-- 개별 바로바로 저장 -->
											<option value="">==사유선택==</option>
											<option value="E" <%If l_errR = "e" then%>selected<%End if%>>실권(E)</option>
											<option value="R" <%If l_errR = "r" then%>selected<%End if%>>기권(R) 진행중</option>
											<option value="W" <%If l_errR = "w" then%>selected<%End if%>>기권(W) 시작전</option>
											<option value="D" <%If l_errR = "d" then%>selected<%End if%>>실격(D)</option>
										</select>
								</span>
								</td>

								<td>
								<span>
										<select id="giveupdocR_<%=l_idx%>" class="form-control" onchange= "mx.setGiveUpDocR(<%=tidx%>,<%=find_gbidx%>,<%=l_idx%>,'R')"><!-- 개별 바로바로 저장 -->
											<option value="">==선택==</option>						
											<option value="Y"  <%If l_errDocR = "Y" then%>selected<%End if%>>○</option>
											<option value="N" <%If l_errDocR = "N" then%>selected<%End if%>>X</option>
										</select>
								</span>
								</td>
							  </tr>
					<%

						Next
					End if
			%>
				</tbody>
			</table>
			<%	





			
			ElseIf tabletype = "3" then
			%>
				<script type="text/javascript">
					mx.makeGameTable(<%=tidx%>,'<%=find_gbidx%>',3,'drow');
				</script>
			<%
			End if
			%>

	  </div>
	  <%End if%>
	  <%'===============%>






<!-- #include virtual = "/pub/html/riding/html.modalplayer.asp" -->

</div>

<div id="ModallastRound" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true"></div>
<div id="myModal" class="modal fade" data-backdrop="static" role="dialog" aria-labelledby="myModalLabel"></div>

