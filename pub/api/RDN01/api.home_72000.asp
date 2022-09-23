<!-- #include virtual = "/pub/header.RidingHome.asp" -->
<%
Dim intTotalCnt, intTotalPage '총갯수, 총페이지수
'############################################
%><!-- #include virtual = "/pub/setReq.asp" --><%'이걸열어서 디버깅하자.%><%
'#############################################
'승마 공인대회참가신청 구분에 따른 화면 생성   /개인전/ 대리/ 단체전 신청 화면
'#############################################
	'request
	atttype = oJSONoutput.get("ATTTYPE")
	tidx = oJSONoutput.get("TIDX")

	Set db = new clsDBHelper

	select case atttype
	case "1" '선수본인이직접신청_____________________________________________________________________________________

		'선수정보가져오기 선수인지 확인
		' response.write session_nowyear & session_pidx
		' response.end
		if Cstr(session_nowyear) = Cstr(year(date)) and session_pidx <> "" Then '선수라면'
		Else
			Call oJSONoutput.Set("result", 20 ) '등록선수 아님'
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			response.end
		end if

		'참여 신청한 목록을 불러온다 (불러온 목록의 키값을 아래에서 제거 또는 신청상태로 표시)

		'신청목록 아래 left join (개인전만 신청할수 있게 한다.)
		'복합마술은 마장마술만 나오도록 한다.
		strTableName = "  tblRGameLevel as a inner join tblTeamGbInfo as b  ON a.gbidx = b.teamgbidx "
		strfieldA = " a.RGameLevelidx,a.gameno,a.GameTitleIDX,a.GbIDX,a.pubcode,a.pubName,a.attdateS,a.attdateE,a.GameDay,a.GameTime,a.levelno,a.attmembercnt,a.fee,a.cfg "
		strfieldB = " b.TeamGbIDX,b.useyear,b.PTeamGb,b.PTeamGbNm,b.TeamGb,b.TeamGbNm,b.levelno,b.levelNm,b.ridingclass,b.ridingclasshelp,b.EnterType ,gamenostr"
		strFieldName = strfieldA &  "," & strfieldB
		strSort = "  ORDER BY gameno asc, a.pubcode , RGameLevelidx Desc"
		strWhere = " a.GameTitleIDX = "&tidx&" and a.DelYN = 'N' and b.PTeamGb = '201' and ( TeamGb<>'20103' or (TeamGb='20103' and ridingclass like '%마장마술') ) " '개인전만

		SQL = "Select "&strFieldName&" from "&strTableName&" where " & strWhere & strSort
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		'Call rsdrow(rs)
		'Response.end

		If Not rs.EOF Then
			arrR = rs.GetRows()
		End If

		'참가신청내역
		'테스트 삭제쿼리
		'delete from tblGameRequest_r where requestIDX in (SELECT requestidx FROM tblGameRequest where gametitleidx = 60)'
		'delete from tblGameRequest where gametitleidx = 60
		'delete from sd_TennisMember_partner where gamememberidx in (SELECT gamememberidx FROM sd_TennisMember where  GameTitleIDX =60)
		'delete from sd_TennisMember where  GameTitleIDX =60
		fld = "  PTeamGbNm,TeamGbNm,levelNm,ridingclass,ridingclasshelp, p1_username, p2_username,pubcode,engcode,pubname,     p1_birthday,payment,requestIdx,teamgb   "  '생년, 결제정보
		'SQL = "select "&fld&" from tblGameRequest as a inner join tblTeamGbInfo as b on a.gbidx = b.teamgbidx where a.delyn = 'N' and  a.gametitleidx = " & tidx & " and a.p1_playeridx = '" & session_pidx & "'"
		SQL = "select "&fld&" from tblGameRequest as a inner join tblTeamGbInfo as b on a.gbidx = b.teamgbidx where  b.PTeamGb = '201' and a.delyn = 'N' and  a.gametitleidx = " & tidx & " and a.username = '" & session_uid & "'" '신청건이여야하므포


		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If Not rs.EOF Then
			arrA = rs.GetRows()
		End If


	case "2" '개인전 대리신청 한건씩만 신청가능하다.__________________________________________________________________

		'신청목록 아래 left join (개인전만 신청할수 있게 한다.)
		'복합마술은 마장마술만 나오도록 한다.
		strTableName = "  tblRGameLevel as a inner join tblTeamGbInfo as b  ON a.gbidx = b.teamgbidx "
		strfieldA = " a.RGameLevelidx,a.gameno,a.GameTitleIDX,a.GbIDX,a.pubcode,a.pubName,a.attdateS,a.attdateE,a.GameDay,a.GameTime,a.levelno,a.attmembercnt,a.fee,a.cfg "
		strfieldB = " b.TeamGbIDX,b.useyear,b.PTeamGb,b.PTeamGbNm,b.TeamGb,b.TeamGbNm,b.levelno,b.levelNm,b.ridingclass,b.ridingclasshelp,b.EnterType ,gamenostr"
		strFieldName = strfieldA &  "," & strfieldB
		strSort = "  ORDER BY gameno asc, a.pubcode , RGameLevelidx Desc"
		strWhere = " a.GameTitleIDX = "&tidx&" and a.DelYN = 'N' and b.PTeamGb = '201' and ( TeamGb<>'20103' or (TeamGb='20103' and ridingclass like '%마장마술') ) " '개인전만

		SQL = "Select "&strFieldName&" from "&strTableName&" where " & strWhere & strSort
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		'Call rsdrow(rs)
		'Response.end

		If Not rs.EOF Then
			arrR = rs.GetRows()
		End If

		'참가신청내역
		'테스트 삭제쿼리
		'delete from tblGameRequest where gametitleidx = 60 and p1_playeridx = 8981
		'delete from sd_TennisMember_partner where gamememberidx in (SELECT gamememberidx FROM sd_TennisMember where playeridx = 8981 and GameTitleIDX =60)
		'delete from sd_TennisMember where playeridx = 8981 and GameTitleIDX =60
		fld = "  PTeamGbNm,TeamGbNm,levelNm,ridingclass,ridingclasshelp, p1_username, p2_username,pubcode,engcode,pubname,     p1_birthday,payment,requestIdx,teamgb   "  '생년, 결제정보
		SQL = "select "&fld&" from tblGameRequest as a inner join tblTeamGbInfo as b on a.gbidx = b.teamgbidx where b.PTeamGb = '201' and a.delyn = 'N' and  a.gametitleidx = " & tidx & " and a.username = '" & session_uid & "'"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If Not rs.EOF Then
			arrA = rs.GetRows()
		End If


	case "3"

		'리더정보가져오기
		SQL = "Select top 1 nowyear,team,teamnm,sidocode,sido,userphone from tblLeader where owner_id = '"&Session_uid&"' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		if rs.eof Then
			Call oJSONoutput.Set("result", 20 ) '등록선수/리더 아님'
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			response.end
		Else
			leader_nowyear = rs(0)
			leader_team = rs(1)   '팀생성을 안함 못함...이렇게 해야할것 같은데
			leader_teamnm = rs(2)
			leader_sidocode = rs(3)
			leader_sido = rs(4)
			if CDbl(leader_nowyear) < CDbl(year(date)) Then
				Call oJSONoutput.Set("result", 20 ) '등록선수/리더 아님 (현재년도)'
				strjson = JSON.stringify(oJSONoutput)
				Response.Write strjson
				response.end
			end if
		end if

		'참여 신청한 목록을 불러온다 (불러온 목록의 키값을 아래에서 제거 또는 신청상태로 표시)

		'신청목록 아래 left join (개인전만 신청할수 있게 한다.)
		'복합마술은 마장마술만 나오도록 한다.
		strTableName = "  tblRGameLevel as a inner join tblTeamGbInfo as b  ON a.gbidx = b.teamgbidx "
		strfieldA = " a.RGameLevelidx,a.gameno,a.GameTitleIDX,a.GbIDX,a.pubcode,a.pubName,a.attdateS,a.attdateE,a.GameDay,a.GameTime,a.levelno,a.attmembercnt,a.fee,a.cfg "
		strfieldB = " b.TeamGbIDX,b.useyear,b.PTeamGb,b.PTeamGbNm,b.TeamGb,b.TeamGbNm,b.levelno,b.levelNm,b.ridingclass,b.ridingclasshelp,b.EnterType ,gamenostr"
		strFieldName = strfieldA &  "," & strfieldB
		strSort = "  ORDER BY gameno asc, a.pubcode , RGameLevelidx Desc"
		strWhere = " a.GameTitleIDX = "&tidx&" and a.DelYN = 'N' and b.PTeamGb = '202' " '단체전만 (릴레이코스트 별도 루틴 작업)

		SQL = "Select "&strFieldName&" from "&strTableName&" where " & strWhere & strSort
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		'Call rsdrow(rs)
		'Response.end

		If Not rs.EOF Then
			arrR = rs.GetRows()
		End If

		'참가신청내역
		relayquery = ",(select stuff(	  ( select ',' + pnm from sd_groupMember where requestidx = a.requestIDX  group by pnm for XML path('') ) ,1,1,''	 )) as relayplayer"
		fld = "  PTeamGbNm,TeamGbNm,levelNm,ridingclass,ridingclasshelp, p1_username, p2_username,pubcode,engcode,pubname,teamgb " & relayquery & "  ,     a.p1_birthday,a.payment,a.requestIdx,teamgb   " '생년, 결제정보
		SQL = "select "&fld&" from tblGameRequest as a inner join tblTeamGbInfo as b on a.gbidx = b.teamgbidx where a.delyn = 'N' and  a.gametitleidx = " & tidx & " and a.username = '" & session_uid & "' and b.PTeamGb = '202' " '단체만
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If Not rs.EOF Then
			arrA = rs.GetRows()
		End If





	end select

	 db.Dispose
	 Set db = Nothing

%>



<%select case atttype
'개인전 본인신청############################################################################################################
case "1"%>
	<li class="apply-online__apply__list">
	  <h3>기본정보</h3>
	  <ul class="clear">
		<li class="apply-online__apply__list__list t_w50">
		  <h4>이름</h4>
		  <%=session_unm%>
		</li>
		<li class="apply-online__apply__list__list t_w50">
		  <h4>선수번호</h4>
		  <%=session_kno%>
		</li>
		<li class="apply-online__apply__list__list t_w50">
		  <h4>소속</h4>
		  <%=session_teamnm%>
		</li>
		<li class="apply-online__apply__list__list t_w50">
		  <!-- <h4>부</h4>일반부 -->
		</li>
	  </ul>
	</li>

	<li class="apply-online__apply__list clear">
	  <h3>참가 정보</h3>
	  <table class="tbl apply-online__apply__list__tbl">
		<caption>참가정보 수정</caption>
		<thead>
		  <tr>
			<th scope="col">참가종목</th>
			<th scope="col">마명 검색</th>
			<th scope="col">참가부 선택</th>
		  </tr>
		</thead>
		<tbody>

		  <tr><!--onclick="mx.setSelectGame(this)-->
			<td>
			  <div class="selc-box t_w650">
				<select id="selectgamelidx" onchange="mx.setBoo(<%=tidx%>, $(this).val(),'201')">
					<%
					if IsArray(arrR) then
					For ari = LBound(arrR, 2) To UBound(arrR, 2)
						RGameLevelidx = arrR(0, ari)
						gameno = arrR(1, ari)
						GameTitleIDX = arrR(2, ari)
						GbIDX = arrR(3, ari)
						pubcode = arrR(4, ari)
						pubName = arrR(5, ari)
						attdateS = arrR(6, ari)
						attdateE = arrR(7, ari)
						GameDay = arrR(8, ari)
						GameTime = arrR(9, ari)
						levelno = arrR(10, ari)
						attmembercnt = arrR(11, ari)
						fee = arrR(12, ari)
						cfg  = arrR(13, ari)

						TeamGbIDX = arrR(14, ari)
						useyear = arrR(15, ari)
						PTeamGb = arrR(16, ari)
						PTeamGbNm = arrR(17, ari)
						TeamGb = arrR(18, ari)
						TeamGbNm = arrR(19, ari)
						levelno = arrR(20, ari)
						levelNm = arrR(21, ari)
						ridingclass = arrR(22, ari)
						ridingclasshelp = arrR(23, ari)
						EnterType  = arrR(24, ari)
						gamenostr = arrR(25, ari)

					if ari = 0 Then
						startgameno = gameno
					end if
					if ari = 0 or gameno <> pre_gameno then
					%>
						<option value="<%=RGameLevelidx%>">경기-<%=PTeamGbNm%> : <%=TeamGbNm%> <%=levelNm%> <%=ridingclass%>&nbsp;<%=ridingclasshelp%></option>
					<%
					end if
					pre_gameno = gameno
					Next
					end if
					%>
				</select>
			  </div>
			</td>
			<td>
			  <div class="apply-online__apply__list__tbl__serch-box clear">
				<input type="hidden" id="hidx" value="">
				<input type="text" id="hnm" value="" placeholder="마명 검색" readonly>
				<a href="javascript:mx.getPopHorse($('#selectgamelidx').val())"><img src="/images/apply-online/apply-online_ico_search.svg" alt="마명 검색"></a>
			  </div>
			</td>

			<td>
			  <div class="selc-box" id="gameboo">
				<select id="attgameboo">
				<%
				 For i = LBound(arrR, 2) To UBound(arrR, 2)
				 	s_pubcode = arrR(4, i)
				 	s_pubName = arrR(5, i)
				 	s_gameno = arrR(1, i)
				 	if Cstr(startgameno) = Cstr(s_gameno) then
				%>
				  <option value="<%=s_pubcode%>"><%=s_pubName%></option>
					<%end if%>
				<%next%>
				</select>
			  </div>
			</td>
		  </tr>



		</tbody>
	  </table>

	  <button type="button" name="button" onclick="mx.attGameRequest('<%=session_pidx%>',1)" class="t_btn-add">참가신청</button>
<!--  	  <button type="button" name="button" onclick="mx.attGameRequest('<%=session_pidx%>',1)" class="t_btn-remove">목록삭제</button> -->
	</li>

	<!-- 선택에 따라서 개인참가신청 내역나옴 -->
	<li class="apply-online__apply__list clear">
	  <!-- <h3>참가 정보</h3> -->
	   <span class="t_noti">※결제 취소는 주최 협회에 문의하시기 바랍니다.</span>
	  <table class="tbl apply-online__apply__list__tbl">
		<caption>참가정보</caption>
		<thead>
		  <tr>
			<th scope="col" style="width:50%;">참가정보</th>
			<th scope="col" style="width:15%;">선수명</th>
			<th scope="col" style="width:15%;">기승마</th>
			<th scope="col" style="width:10%;">상태</th>
			<th scope="col" style="width:10%;"></th>
		  </tr>
		</thead>
		<tbody>

		<%
		if IsArray(arrA) Then
		For i = LBound(arrA, 2) To UBound(arrA, 2)
			PTeamGbNm = arrA(0, i)
			TeamGbNm = arrA(1, i)
			levelNm = arrA(2, i)
			ridingclass = arrA(3, i)
			ridingclasshelp = arrA(4, i)
			p1_username = arrA(5, i)
			p2_username = arrA(6, i)
			att_pubcode = arrA(7,i)
			att_engcode = arrA(8,i)
			att_pubname = arrA(9,i)
			att_birth = arrA(10,i)
			att_payment = arrA(11,i) '결제여부 1결제 0결제전
			'teamgb = arrA(12,i)

			If att_payment = "1" Then
				attstr = ""
			Else
				attstr = "<button type='button'  onclick=""mx.delTempMember("&reqidx&")"" class=""enrollment__list__tbl__btn"">삭제</button>"
			End if		
		%>
		<%If TeamGbNm = "복합마술"  And InStr(ridingclass,"장애물") > 0 then%>
		<%else%>
			<tr>
	  		<td ><%=PTeamGbNm%> <%=TeamGbNm%> <%=levelNm%> <%=ridingclass%> <%=ridingclasshelp%> (<%=att_pubname%>)</td>
	  		<td ><%=p1_username%>(<%=att_birth%>)</td>
	  		<td ><%=p2_username%></td>
			
			<td ><%If att_payment = "1" then%><em class="t_blue">결제완료</em><%else%><button type='button'  onclick="confirm('선택하신 신청항목에 대한 참가비 결제를 하시겠습니까?\n\n전체항목 선택/결제의 경우, 일부 결제취소는 불가합니다.\n일부 결제취소 희망 시, 주최협회에 별도 문의 및 \n취소요청을 부탁 드립니다.')" class="enrollment__list__tbl__btn t_orange">결제하기</button><%End if%></td>
			<td ><%If TeamGbNm = "복합마술"  And InStr(ridingclass,"장애물") > 0 then%><%else%><%=attstr%><%End if%></td> <!-- 복합마술(장매물) 단체전 없다고 들은거 같음. -->
	  	  </tr>
		 <%End if%>
		<%
		Next
		end if
		%>

	  </tbody>
	</table>

	
<!-- 	<button type="button" name="button"  class="btn-apply" onclick="confirm('선택하신 신청항목에 대한 참가비 결제를 하시겠습니까?\n\n전체항목 선택/결제의 경우, 일부 결제취소는 불가합니다.\n일부 결제취소 희망 시, 주최협회에 별도 문의 및 \n취소요청을 부탁 드립니다.')">결제하기</button> -->
	</li>



<%
'개인전 대리신청############################################################################################################
case "2"%>


	<li class="apply-online__apply__list clear">
	  <h3>참가 정보</h3>
	  <table class="tbl apply-online__apply__list__tbl">
		<caption>참가정보 수정</caption>
		<thead>
		  <tr>
			<th scope="col">참가종목</th>
			<th scope="col">선수 검색</th>
			<th scope="col">마명 검색</th>
			<th scope="col">참가부 선택</th>
		  </tr>
		</thead>
		<tbody>

		  <tr><!--onclick="mx.setSelectGame(this)-->
			<td style="padding-right:5px;">
			  <div class="selc-box" style="width:400px;">
				<select id="selectgamelidx" onchange="mx.setBoo(<%=tidx%>, $(this).val(),'201')">
					<%
					if IsArray(arrR) then
					For ari = LBound(arrR, 2) To UBound(arrR, 2)
						RGameLevelidx = arrR(0, ari)
						gameno = arrR(1, ari)
						GameTitleIDX = arrR(2, ari)
						GbIDX = arrR(3, ari)
						pubcode = arrR(4, ari)
						pubName = arrR(5, ari)
						attdateS = arrR(6, ari)
						attdateE = arrR(7, ari)
						GameDay = arrR(8, ari)
						GameTime = arrR(9, ari)
						levelno = arrR(10, ari)
						attmembercnt = arrR(11, ari)
						fee = arrR(12, ari)
						cfg  = arrR(13, ari)

						TeamGbIDX = arrR(14, ari)
						useyear = arrR(15, ari)
						PTeamGb = arrR(16, ari)
						PTeamGbNm = arrR(17, ari)
						TeamGb = arrR(18, ari)
						TeamGbNm = arrR(19, ari)
						levelno = arrR(20, ari)
						levelNm = arrR(21, ari)
						ridingclass = arrR(22, ari)
						ridingclasshelp = arrR(23, ari)
						EnterType  = arrR(24, ari)
						gamenostr = arrR(25, ari)

					if ari = 0 Then
						startgameno = gameno
					end if
					if ari = 0 or gameno <> pre_gameno then
					%>
						<option value="<%=RGameLevelidx%>">경기-<%=PTeamGbNm%> : <%=TeamGbNm%> <%=levelNm%> <%=ridingclass%>&nbsp;<%=ridingclasshelp%></option>
					<%
					end if
					pre_gameno = gameno
					Next
					end if
					%>
				</select>
			  </div>
			</td>
			<td>
			  <div class="apply-online__apply__list__tbl__serch-box clear">
				<input type="hidden" id="attpidx" value="">
				<input type="text" id="pnm" value="" placeholder="선수 검색" readonly>
				<a href="javascript:mx.getPopPlayer($('#selectgamelidx').val())"><img src="/images/apply-online/apply-online_ico_search.svg" alt="마명 검색"></a>
			  </div>
			</td>

			<td>
			  <div class="apply-online__apply__list__tbl__serch-box clear">
				<input type="hidden" id="hidx" value="">
				<input type="text" id="hnm" value="" placeholder="마명 검색" readonly>
				<a href="javascript:if($('#pnm').val() == ''){alert('선수명을 먼저 검색해 주십시오.');}else{mx.getPopHorse($('#selectgamelidx').val() , $('#attpidx').val() )}"><img src="/images/apply-online/apply-online_ico_search.svg" alt="마명 검색"></a>
			  </div>
			</td>

			<td>
			  <div class="selc-box" id="gameboo">
				<select id="attgameboo">
				<%
				 if IsArray(arrR) Then
				 For i = LBound(arrR, 2) To UBound(arrR, 2)
					s_pubcode = arrR(4, i)
					s_pubName = arrR(5, i)
					s_gameno = arrR(1, i)
					if Cstr(startgameno) = Cstr(s_gameno) then
				%>
				  <option value="<%=s_pubcode%>"><%=s_pubName%></option>
					<%end if%>
				<%
				next
				end if
				%>
				</select>
			  </div>
			</td>
		  </tr>

		</tbody>
	  </table>

	  <button type="button" name="button" onclick="mx.attGameRequest($('#attpidx').val(),2)" class="t_btn-add">참가신청</button>
	</li>

	<!-- 대리신청한 참가신청 내역 #######################################################################-->
	<li class="apply-online__apply__list clear">
	  <!-- <h3>참가 정보</h3> -->
	   <span class="t_noti">※결제 취소는 주최 협회에 문의하시기 바랍니다.</span>
	  <table class="tbl apply-online__apply__list__tbl">
		<caption>참가정보</caption>
		<thead>
		  <tr>
			<th scope="col" style="width:50%;">참가정보</th>
			<th scope="col" style="width:15%;">선수명</th>
			<th scope="col" style="width:15%;">기승마</th>
			<th scope="col" style="width:10%;">상태</th>
			<th scope="col" style="width:10%;"></th>
		  </tr>
		</thead>
		<tbody>

		<%
		if IsArray(arrA) Then
		For i = LBound(arrA, 2) To UBound(arrA, 2)
			PTeamGbNm = arrA(0, i)
			TeamGbNm = arrA(1, i)
			levelNm = arrA(2, i)
			ridingclass = arrA(3, i)
			ridingclasshelp = arrA(4, i)
			p1_username = arrA(5, i)
			p2_username = arrA(6, i)
			att_pubcode = arrA(7,i)
			att_engcode = arrA(8,i)
			att_pubname = arrA(9,i)

			att_birth = arrA(10,i)
			att_payment = arrA(11,i) '결제여부 1결제 0결제전
			reqidx = arrA(12,i) '키

			If att_payment = "1" Then
				attstr = ""
			Else
				attstr = "<button type='button'  onclick=""mx.delTempMember("&reqidx&")"" class=""enrollment__list__tbl__btn"">삭제</button>"
			End if					
		%>
		<%If TeamGbNm = "복합마술"  And InStr(ridingclass,"장애물") > 0 then%>
		<%else%>
		 <tr>
			<td ><%=PTeamGbNm%> <%=TeamGbNm%> <%=levelNm%> <%=ridingclass%> <%=ridingclasshelp%> (<%=att_pubname%>)</td>
			<td ><%=p1_username%>(<%=att_birth%>)</td>
			<td ><%=p2_username%></td>

			<td ><%If att_payment = "1" then%><em class="t_blue">결제완료</em><%else%><button type='button'  onclick="confirm('선택하신 신청항목에 대한 참가비 결제를 하시겠습니까?\n\n전체항목 선택/결제의 경우, 일부 결제취소는 불가합니다.\n일부 결제취소 희망 시, 주최협회에 별도 문의 및 \n취소요청을 부탁 드립니다.')" class="enrollment__list__tbl__btn t_orange">결제하기</button><%End if%></td>
			<td ><%If TeamGbNm = "복합마술"  And InStr(ridingclass,"장애물") > 0 then%><%else%><%=attstr%><%End if%></td> <!-- 복합마술(장매물) 단체전 없다고 들은거 같음. -->			
		  </tr>
		<%End if%>
		<%
		Next
		end if
		%>

	  </tbody>
	</table>

<!--  		<button type="button" name="button"  class="btn-apply" onclick="confirm('선택하신 신청항목에 대한 참가비 결제를 하시겠습니까?\n\n전체항목 선택/결제의 경우, 일부 결제취소는 불가합니다.\n일부 결제취소 희망 시, 주최협회에 별도 문의 및 \n취소요청을 부탁 드립니다.')">결제하기</button> -->

	</li>




<%
'단체전 참가신청'###########################################################################################################
case "3"%>
	<li class="apply-online__apply__list t_solo-sub">
	  <h3>기본정보</h3>
	  <ul class="clear">
		<li class="apply-online__apply__list__list t_w50">
		  <h4>지도자</h4>
		  <%=Session_unm%>
		</li>
		<li class="apply-online__apply__list__list t_w50">
		  <h4>소속</h4>
		  <%=leader_teamnm%>
		</li>
	  </ul>
	</li>

	<li class="apply-online__apply__list clear t_solo-sub t_group">
	  <h3>참가 정보</h3>
	  <!-- <div class="apply-online__apply__list__group clear">
		<span>1</span>
		<span>단체명 선택</span>
		<div class="selc-box">
		  <select class="" name="">
			<option value="">서울영등포구연합단체</option>
		  </select>
		</div>
		<button type="button" name="button">단체추가</button>
	  </div> -->

	  <table class="tbl apply-online__apply__list__tbl">
		<caption>참가정보 수정</caption>
		<thead>
		  <tr>
			<th scope="col">참가종목</th>
			<th scope="col">선수 검색</th>
			<th scope="col">마명 검색</th>
			<th scope="col">참가부 선택</th>
		  </tr>
		</thead>
		<tbody>

		  <tr >
			<td style="padding-right:5px;">
			  <div class="selc-box" style="width:550px;">
				<select id="selectgamelidx" onchange="mx.setBoo(<%=tidx%>, $(this).val(),'202')">
					<%
					if IsArray(arrR) then
					For ari = LBound(arrR, 2) To UBound(arrR, 2)
						RGameLevelidx = arrR(0, ari)
						gameno = arrR(1, ari)
						GameTitleIDX = arrR(2, ari)
						GbIDX = arrR(3, ari)
						pubcode = arrR(4, ari)
						pubName = arrR(5, ari)
						attdateS = arrR(6, ari)
						attdateE = arrR(7, ari)
						GameDay = arrR(8, ari)
						GameTime = arrR(9, ari)
						levelno = arrR(10, ari)
						attmembercnt = arrR(11, ari)
						fee = arrR(12, ari)
						cfg  = arrR(13, ari)

						TeamGbIDX = arrR(14, ari)
						useyear = arrR(15, ari)
						PTeamGb = arrR(16, ari)
						PTeamGbNm = arrR(17, ari)
						TeamGb = arrR(18, ari)
						TeamGbNm = arrR(19, ari)
						levelno = arrR(20, ari)
						levelNm = arrR(21, ari)
						ridingclass = arrR(22, ari)
						ridingclasshelp = arrR(23, ari)
						EnterType  = arrR(24, ari)
						gamenostr = arrR(25, ari)

					if ari = 0 Then
						startgameno = gameno
					end if
					if ari = 0 or gameno <> pre_gameno then
					%>
						<option value="<%=RGameLevelidx%>">경기-<%=PTeamGbNm%> : <%=TeamGbNm%> <%=levelNm%> <%=ridingclass%>&nbsp;<%=ridingclasshelp%></option>
					<%
					end if
					pre_gameno = gameno
					Next
					end if
					%>
				</select>
			  </div>
			</td>
			<td>
			  <div class="apply-online__apply__list__tbl__serch-box clear">
				<input type="hidden" id="attpidx" value="">
				<input type="text" id="pnm" value="" placeholder="선수 검색" readonly>
				<a href="javascript:mx.getPopPlayer($('#selectgamelidx').val(), '<%=leader_team%>')"><img src="/images/apply-online/apply-online_ico_search.svg" alt="마명 검색"></a>
			  </div>
			</td>

			<td>
			  <div class="apply-online__apply__list__tbl__serch-box clear">
				<input type="hidden" id="hidx" value="">
				<input type="text" id="hnm" value="" placeholder="마명 검색" readonly>
				<a href="javascript:if($('#pnm').val() == ''){alert('선수명을 먼저 검색해 주십시오.');}else{mx.getPopHorse($('#selectgamelidx').val() , $('#attpidx').val() )}"><img src="/images/apply-online/apply-online_ico_search.svg" alt="마명 검색"></a>
			  </div>
			</td>

			<td>
			  <div class="selc-box" id="gameboo">
				<input type="hidden" id="relayteamnm"><%'참가팀명'%>
				<select id="attgameboo">
				<%
				 if IsArray(arrR) Then
				 For i = LBound(arrR, 2) To UBound(arrR, 2)
					s_pubcode = arrR(4, i)
					s_pubName = arrR(5, i)
					s_gameno = arrR(1, i)
					if Cstr(startgameno) = Cstr(s_gameno) then
				%>
				  <option value="<%=s_pubcode%>"><%=s_pubName%></option>
					<%end if%>
				<%
				next
				end if
				%>
				</select>
			  </div>
			</td>
		  </tr>

		</tbody>
	  </table>

	  <button type="button" name="button" onclick="mx.attGameRequest($('#attpidx').val(),2)" class="t_btn-add">참가신청</button>
	</li>


	<!-- 참가신청 내역 #######################################################################-->
	<li class="apply-online__apply__list clear">
	  <!-- <h3>참가 정보</h3> -->
	   <span class="t_noti">※결제 취소는 주최 협회에 문의하시기 바랍니다.</span>
	  <table class="tbl apply-online__apply__list__tbl">
		<caption>참가정보</caption>
		<thead>
		  <tr>
			<th scope="col" style="width:50%;">참가정보</th>
			<th scope="col" style="width:15%;">선수명</th>
			<th scope="col" style="width:15%;">기승마</th>
			<th scope="col" style="width:10%;">상태</th>
			<th scope="col" style="width:10%;"></th>
		  </tr>
		</thead>
		<tbody>

		<%
		if IsArray(arrA) Then
		For i = LBound(arrA, 2) To UBound(arrA, 2)
			PTeamGbNm = arrA(0, i)
			TeamGbNm = arrA(1, i)
			levelNm = arrA(2, i)
			ridingclass = arrA(3, i)
			ridingclasshelp = arrA(4, i)
			p1_username = arrA(5, i)
			p2_username = arrA(6, i)
			att_pubcode = arrA(7,i)
			att_engcode = arrA(8,i)
			att_pubname = arrA(9,i)
			att_teamgb = arrA(10,i)
			att_relayplayer = arrA(11,i)

			att_birth = arrA(12,i)
			att_payment = arrA(13,i) '결제여부 1결제 0결제전

			If att_payment = "1" Then
				attstr = ""
			Else
				attstr = "<button type='button'  onclick=""mx.delTempMember("&reqidx&")"" class=""enrollment__list__tbl__btn"">삭제</button>"
			End if		

		%>
			<tr>
			<td ><%=PTeamGbNm%> <%=TeamGbNm%> <%=levelNm%> <%=ridingclass%> <%=ridingclasshelp%> (<%=att_pubname%>)</td>
			<td ><%if att_teamgb = "20208" then%><%=att_relayplayer%><%else%><%=p1_username%><%end if%></td>
			<td ><%=p2_username%></td>

			<td ><%If att_payment = "1" then%><em class="t_blue">결제완료</em><%else%><button type='button'  onclick="confirm('선택하신 신청항목에 대한 참가비 결제를 하시겠습니까?\n\n전체항목 선택/결제의 경우, 일부 결제취소는 불가합니다.\n일부 결제취소 희망 시, 주최협회에 별도 문의 및 \n취소요청을 부탁 드립니다.')" class="enrollment__list__tbl__btn t_orange">결제하기</button><%End if%></td>
			<td ><%=attstr%></td>
		  </tr>
		<%
		Next
		end if
		%>

	  </tbody>
	</table>

<!--  		<button type="button" name="button"  class="btn-apply" onclick="confirm('선택하신 신청항목에 대한 참가비 결제를 하시겠습니까?\n\n전체항목 선택/결제의 경우, 일부 결제취소는 불가합니다.\n일부 결제취소 희망 시, 주최협회에 별도 문의 및 \n취소요청을 부탁 드립니다.')">결제하기</button>	  -->

	</li>

<%end select%>
