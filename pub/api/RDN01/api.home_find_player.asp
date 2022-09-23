<!-- #include virtual = "/pub/header.RidingHome.asp" -->
<%
Dim intTotalCnt, intTotalPage '총갯수, 총페이지수
'############################################
%><!-- #include virtual = "/pub/setReq.asp" --><%'이걸열어서 디버깅하자.%><%
'#############################################
'선수명 검색 모달창
'#############################################
	'request
	If hasown(oJSONoutput, "LEVELIDX") = "ok" then
		levelidx = oJSONoutput.get("LEVELIDX")
		teamcd = oJSONoutput.Get("TEAMCD") '단체인경우 / 개인인경우 ''
	End if

	'단체인경우 선수 명단을 우선 불러온다.
	 Set db = new clsDBHelper
	' 	'단체 처리를 위해서 (릴레이 코스트 라면 참여 그룹명칭을 받고 선수 3명을 선택할 수 있도록 변경 체크는 음 못함 그냥 넣어...)
		if teamcd <> "" Then
			SQL = "Select teamgb from tblRGameLevel as a inner join tblTeamGbInfo as b on a.gbidx = b.teamgbidx and b.delyn = 'N' where a.RGameLevelidx = " & levelidx
		 	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			teamgb = rs(0) '20208


		 	SQL = "Select team,teamnm,ksportsno,playeridx,username from tblPlayer where team = '"&teamcd&"' "
		 	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		 	If Not rs.EOF Then
		 		arrR = rs.GetRows()
		 	End If
		end if

	 db.Dispose
	 Set db = Nothing



if teamgb = "20208" then
%>

	<input type="hidden" id="selectlidx">

	<input type="hidden" id="selectidx">
	<input type="hidden" id="selectnm">

	<input type="hidden" id="selectidx2">
	<input type="hidden" id="selectnm2">
	<input type="hidden" id="selectidx3">
	<input type="hidden" id="selectnm3">

	<div class="l_modal">
	  <section class="m_search-horse">
		<h1 class="m_search-horse__header">릴레이코스트 참가선수 선택</h1>
		<div class="m_search-horse__con">
		  <div class="m_search-horse__con__search-box">
  			<input type="text" id="inputgroupnm" value="<%if IsArray(arrR) then%><%=arrR(1,0)%><%end if%>" placeholder="릴레이팀명을 입력해주세요." onkeyup = "mx.findGroup($('#inputfindplayer').val(),<%=levelidx%>)">
  	  	  </div>


		  <div class="m_search-horse__con__search-box">
			<!-- <input type="text" id="inputfindplayer" value="" placeholder="선수명을 검색해주세요." onkeyup = "mx.findPlayer($('#inputfindplayer').val(),<%=levelidx%>)">
			<%'api.home_51001.asp 말조건 검색%> -->
		  </div>

		  <div>
		  <table class="m_search-horse__con__tbl tbl">
			<thead>
			  <tr>
				<th>선수명</th>
				<th>선수번호</th>
			  </tr>
			</thead>

			<tbody id="findplayerlist" class="t_t2">
				<%
				if IsArray(arrR) then
				For ari = LBound(arrR, 2) To UBound(arrR, 2)
					team = arrR(0,ari)
					Teamnm = arrR(1,ari)
					ksportsno = arrR(2,ari)
					PlayerIDX = arrR(3,ari)
					username = arrR(4,ari)

					response.write "<tr id= ""player_"&ari&""" onclick=""mx.setPlayerInfoRelay(this,'"&playeridx&"','"&ksportsno&"','"&username&"','"&levelidx&"')""><th>"&username&"</th><td>"&ksportsno&"</td></tr>"
				Next
				end if
				%>

				<%'api.home_findPlayerList.asp%>
			</tbody>
		  </table>
	  	</div>


		  <span class="m_search-horse__con__noti s_hide">선수명을 검색하시고 선택한 후 확인 버튼을 눌러주세요.</span>
		</div>
		<div class="m_search-horse__btn-box clear">
		  <button class="m_search-horse__btn" type="button" name="button" onclick="mx.inputPlayerInfoRelay()">확인</button>
		  <button class="m_search-horse__btn t_cancel" type="button" name="button" onclick="$('#modalsearchHorse').hide ()">취소</button>
		</div>
	  </section>
	</div>

<%else '#######################################################################################################%>

<input type="hidden" id="selectidx">
<input type="hidden" id="selectnm">
<input type="hidden" id="selectlidx">
<div class="l_modal">
  <section class="m_search-horse">
	<h1 class="m_search-horse__header"><%if teamcd = "" Then%>팀선수 선택<%else%>선수 검색<%end if%></h1>
	<div class="m_search-horse__con">


	  <div class="m_search-horse__con__search-box">
	<%if teamcd = "" Then%>
		<input type="text" id="inputfindplayer" value="" placeholder="선수명을 검색해주세요." onkeyup = "mx.findPlayer($('#inputfindplayer').val(),<%=levelidx%>)">
		<%'api.home_51001.asp 조건 검색%>
	<%end if%>
	  </div>


	  <div>
	  <table class="m_search-horse__con__tbl tbl">
		<thead>
		  <tr>
			<th>선수명</th>
			<th>선수번호</th>
		  </tr>
		</thead>

		<tbody id="findplayerlist" class="t_t2">
			<%
			if IsArray(arrR) then
			For ari = LBound(arrR, 2) To UBound(arrR, 2)
				team = arrR(0,ari)
				Teamnm = arrR(1,ari)
				ksportsno = arrR(2,ari)
				PlayerIDX = arrR(3,ari)
				username = arrR(4,ari)

				response.write "<tr onclick=""mx.setPlayerInfo(this,'"&playeridx&"','"&ksportsno&"','"&username&"','"&levelidx&"')""><th>"&username&"</th><td>"&ksportsno&"</td></tr>"
			Next
			end if
			%>

			<%'api.home_findPlayerList.asp%>
		</tbody>
	  </table>
	</div>


	  <span class="m_search-horse__con__noti s_hide">선수명을 검색하시고 선택한 후 확인 버튼을 눌러주세요.</span>
	</div>
	<div class="m_search-horse__btn-box clear">
	  <button class="m_search-horse__btn" type="button" name="button" onclick="mx.inputPlayerInfo()">확인</button>
	  <button class="m_search-horse__btn t_cancel" type="button" name="button" onclick="$('#modalsearchHorse').hide ()">취소</button>
	</div>
  </section>
</div>


<%end if%>
