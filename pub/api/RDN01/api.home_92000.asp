<!-- #include virtual = "/pub/header.RidingHome.asp" -->
<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<%
Dim intTotalCnt, intTotalPage '총갯수, 총페이지수
'############################################
%><!-- #include virtual = "/pub/setReq.asp" --><%'이걸열어서 디버깅하자.%><%
'#############################################
'결제전 참가자 정보 삭제
'#############################################

	'request
	ridx = oJSONoutput.get("RIDX")

	Set db = new clsDBHelper 

	If login = False Then
		Call oJSONoutput.Set("result", 9 ) '로그인안됨
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End if


	'같은팀으로 묶일수 있도록 해야한다. 
	' 1. tblPlayer 에 group 만들기 또는 찾기
	' 2. tblGameRequest 그룹저장한 플레이어를 저장
	' 3. tblGameRequest_r 선수들 각각 정보를 넣고 여기 개별 결제 확인 할수 있도록 넣고 (payment 이걸로 체크)
	' 4. sd_TennisMember group 설정된 값넣기
	' 5. 말은 sd_TennisMember_partner 여기다 넣고
	' 6. sd_groupMember 에 선수 정보 넣고 

	
sub delTempMember(ridx,gbidx,teamgb)
    dim sql

	if teamgb = "20208" Then '릴레이코스경기   3인 1마로 말중복만 검색하자.
		'릴레이생성팀 삭제 
			sql = ""
			sql = sql & "update tblplayer set DelYN = 'Y' where playeridx = (select p1_playeridx from tblGameRequest where requestidx = "&ridx&") and usertype = 'G' "
			sql = sql & "update tblGameRequest set DelYN = 'Y' where requestidx = "&ridx&" "
			sql = sql & "update tblGameRequest_r set DelYN = 'Y' where requestidx = "&ridx&" " 
			sql = sql & "update sd_TennisMember set DelYN = 'Y' where requestidx =  "&ridx&" "
			sql = sql & "delete From  sd_TennisMember_partner   where gamememberidx = (select top 1 gamememberidx from sd_TennisMember where requestidx = "&ridx&") "
			sql = sql & "delete From sd_groupMember Where  gamememberidx = (select top 1 gamememberidx from sd_TennisMember where requestidx = "&ridx&") "
			Call db.execSQLRs(SQL , null, ConStr)

	Else
			sql = ""
			sql = sql & " update tblGameRequest set DelYN = 'Y' where requestidx = "&ridx&" "
			sql = sql & " update sd_TennisMember set DelYN = 'Y' where requestidx =  "&ridx&" "
			sql = sql & " delete From  sd_TennisMember_partner   where gamememberidx = (select top 1 gamememberidx from sd_TennisMember where requestidx = "&ridx&") "
			Call db.execSQLRs(SQL , null, ConStr)
    end If
end sub


	SQL = "select teamgb,teamgbidx,teamgbnm,levelno,pubcode,gametitleidx,p1_playeridx from tblGameRequest as a inner join tblTeamGbInfo as b on  a.gbidx = b.teamgbidx and b.DelYN = 'N' where a.requestidx = "&ridx&" "
	'SQL = "select teamgb,teamgbidx,teamgbnm,levelno,pubcode from tblTeamGbInfo where teamgbidx = (select gbidx from tblGameRequest where requestidx = "&ridx&")"
    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.eof Then
		teamgb = rs(0)
		gbidx = rs(1)
		pubcode = rs(4)

		tidx = rs(5)
		pidx = rs(6)
	End if


	call delTempMember(ridx,gbidx,teamgb)
	'복합마술은 마장마술만 불러오므로 장애물도 불러서 넣어주어야한다.




	if teamgb = "20103" then '복합마술이라면
		'받아온  gbidx는 마장마술 입니다. 장애물 gbidx를 찾아서 동일하게 인서트 하여야 합니다.
		SQL = "select top 1 requestidx from tblGameRequest as a inner join tblTeamGbInfo as b on  a.gbidx = b.teamgbidx and b.DelYN = 'N' where a.gametitleidx = "&tidx&" and teamgb = '20103' and p1_playeridx = "&pidx&" and requestidx <> "&ridx&" "

'Response.write sql
'Response.end

		Set rs = db.ExecSQLReturnRS(SQL,null, ConStr)

		If Not rs.eof then
		ridx = rs(0)
		call delTempMember(ridx,gbidx,teamgb)
		End if
	end if



	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson


  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>