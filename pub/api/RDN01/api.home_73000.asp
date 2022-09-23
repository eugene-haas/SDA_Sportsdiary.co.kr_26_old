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
	case "1","A" '선수본인이직접신청_____________________________________________________________________________________

		'선수정보가져오기 선수인지 확인
		' response.write session_nowyear & session_pidx
		' response.end
'		if Cstr(session_nowyear) = Cstr(year(date)) and session_pidx <> "" Then '선수라면'
'		Else
'			Call oJSONoutput.Set("result", 20 ) '등록선수 아님'
'			strjson = JSON.stringify(oJSONoutput)
'			Response.Write strjson
'			response.end
'		end if

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
		fld = "  PTeamGbNm,TeamGbNm,levelNm,ridingclass,ridingclasshelp, p1_username, p2_username,pubcode,engcode,pubname "
		'SQL = "select "&fld&" from tblGameRequest as a inner join tblTeamGbInfo as b on a.gbidx = b.teamgbidx where a.delyn = 'N' and  a.gametitleidx = " & tidx & " and a.p1_playeridx = '" & session_pidx & "'"
		SQL = "select "&fld&" from tblGameRequest as a inner join tblTeamGbInfo as b on a.gbidx = b.teamgbidx where a.delyn = 'N' and  a.gametitleidx = " & tidx & " and a.username = '" & session_uid & "'" '신청건이여야하므포
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If Not rs.EOF Then
			arrA = rs.GetRows()
		End If


	case "2","B" '개인전 대리신청 한건씩만 신청가능하다.__________________________________________________________________

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
		fld = "  PTeamGbNm,TeamGbNm,levelNm,ridingclass,ridingclasshelp, p1_username, p2_username,pubcode,engcode,pubname "
		SQL = "select "&fld&" from tblGameRequest as a inner join tblTeamGbInfo as b on a.gbidx = b.teamgbidx where a.delyn = 'N' and  a.gametitleidx = " & tidx & " and a.username = '" & session_uid & "'"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If Not rs.EOF Then
			arrA = rs.GetRows()
		End If


	case "3","C"

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
			leader_team = rs(1)
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
		strfieldB = " b.TeamGbIDX,b.useyear,b.PTeamGb,b.PTeamGbNm,b.TeamGb,b.TeamGbNm,b.levelno,b.levelNm,b.ridingclass,b.ridingclasshelp,b.EnterType ,gamenostr    "
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
		fld = "  PTeamGbNm,TeamGbNm,levelNm,ridingclass,ridingclasshelp, p1_username, p2_username,pubcode,engcode,pubname,teamgb " & relayquery
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
case "1","A"%>
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
		%>
				  <tr>
                    <th><%=i+1%></th>
                    <td>
                      <%=levelNm%> <%=ridingclass%> <%=ridingclasshelp%>
                    </td>
                    <td><%=p1_username%></td>
                    <td><%=att_pubname%></td>
                    <td><%=TeamGbNm%></td>
                  </tr>
		<%
		Next
		end if
		%>
<%
'개인전 대리신청############################################################################################################
case "2","B"%>
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
		%>
				  <tr>
                    <th><%=i+1%></th>
                    <td>
                      <%=levelNm%> <%=ridingclass%> <%=ridingclasshelp%>
                    </td>
                    <td><%=p1_username%></td>
                    <td><%=att_pubname%></td>
                    <td><%=TeamGbNm%></td>
                  </tr>
		<%
		Next
		end if
		%>
<%
'단체전 참가신청'###########################################################################################################
case "3","C"%>
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
		%>
				  <tr>
                    <th><%=i+1%></th>
                    <td>
                      <%=levelNm%> <%=ridingclass%> <%=ridingclasshelp%>
                    </td>
                    <td><%if att_teamgb = "20208" then%><%=att_relayplayer%><%else%><%=p1_username%><%end if%></td>
                    <td><%=att_pubname%></td>
                    <td><%=TeamGbNm%></td>
                  </tr>
		<%
		Next
		end if
		%>
<%end select%>
