<!-- #include virtual = "/game_manager/include/asp_setting/ajaxHeader.asp" -->
<!-- #include virtual = "/game_manager/ajax/setReq.asp" -->
<!-- #include virtual = "/pub/fn/fn.swjudge.asp" -->
<%
'#############################################
'라운드 입력폼
'#############################################
	tidx = isNulldefault(oJSONoutput.Get("TIDX"),"")
	CDA = "E2"
	
	Set db = new clsDBHelper


	'tryoutresult 실격인경우는 패스 ~~~~~~~~~~~
	'진행중인 대회 리스트 가져오기 (대회날짜도 확인되어야함.)
		tbl = " sd_gamemember as a inner join sd_gameMember_roundRecord as b On a.cda = '"&CDA&"' and a.gametitleidx = "&tidx&" and a.gamememberidx = b.midx "
		SQL = "Select top 1 b.lidx,b.midx,b.idx from "&tbl&" where b.tidx = " & tidx & " and b.rounding = 'Y' and a.tryoutresult < 'a' "
		SQL = SQL & " and b.lidx in (select RGameLevelidx from tblRgameLevel where gametitleidx = "&tidx&" and DelYN='N' and cda = '"&CDA&"' and (tryoutgamedate = '"&date&"' or finalgamedate = '"&date&"') ) "
		SQL = SQL & " order by gameround desc, idx desc"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		
		'  Call oJSONoutput.Set("sql", sql ) '정상
		'  Call oJSONoutput.Set("result", "0" ) '정상
		'  strjson = JSON.stringify(oJSONoutput)
		'  Response.Write strjson
		'  response.end
		
		if rs.eof then
			Call oJSONoutput.Set("list", array() ) '정상
			Call oJSONoutput.Set("result", "0" ) '정상
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			response.end
		else
			ridx = rs("idx")
		end if
		





	'기본정보 호출
		SQL = "Select judgeCnt,roundCnt,gameround from sd_gameMember_roundRecord as a inner join tblRGameLevel as b on a.lidx = b.RGameLevelidx where idx = " & ridx
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		judgecnt = rs(0)
		roundcnt = rs(1) '라운드수
		gameround = rs(2) '현재 진행중인 라운드번호


	'다이빙
		fld = ""
		fld = fld & " cast(b.gameround as varchar) + 'R' as roundno "
		fld = fld & " ,a.tryoutsortNo as orderno "
		fld = fld & " ,case when a.itgubun = 'I' then '개인' else '단체' end as itgubun "
		fld = fld & " ,case when a.itgubun = 'T' then (SELECT  STUFF(( select ','+ username from SD_gameMember_partner where gamememberidx = a.gamememberidx for XML path('') ),1,1, '' )) else a.username end as names"  '파트너 있을때 단체일때 이름가져오기
		fld = fld & " ,a.CDBNM "
		fld = fld & " ,a.CDCNM "
		fld = fld & " ,(case when left(CDCNM,5) = '플렛포옴다' then '1' "
		fld = fld & "  when left(CDCNM,5) = '스프링보오' then '2' "
		fld = fld & "  when left(CDCNM,5) = '스프링다이' then '3' "
		fld = fld & "  when left(CDCNM,5) = '싱크로다이' then '4' "

		fld = fld & "  when left(CDCNM,2) = '솔로' then '5' " '피겨
		fld = fld & "  when left(CDCNM,2) = '듀엣' then '5' "
		fld = fld & "  when left(CDCNM,1) = '팀' then '5' "
		fld = fld & "  when left(CDCNM,2) = '테크' then '6' "
		fld = fld & "  when left(CDCNM,2) = '프리' then '7' else '' end) as CDCICON "
		fld = fld & " ,case when a.tryoutresult >= 'a' then 'Y' else 'N' end as isdisabled " '실격 다음맴버
		fld = fld & " ,b.rounding as roundstate " '라운드 진행상태

		fld = fld & " ,b.totalscore as roundscore " '라운드총점 (모든심판입력)
		fld = fld & " ,a.TeamNm as team "
		fld = fld & " ,a.sidonm  "
		fld = fld & " ,c.codename as div_divname  " '다이브명
		fld = fld & " ,c.code1 as div_divno  " '다이브번호
		fld = fld & " ,c.code3 as div_posture  " '자세
		fld = fld & " ,c.code2 as div_height " '높이
		fld = fld & " ,c.code4 as div_divdifficulty " '난이율
		fld = fld & " , '"&judgecnt&"' as judgecnt " '심판수

		'심판수만큼
		for i = 1 to judgecnt
		fld = fld & " ,b.jumsu"&i&" "
		Next

		'a.tryoutsortno > 0 순서번호가 설정된 값만 가져오자
		tbl = " SD_gameMember as a inner join sd_gameMember_roundRecord as b on a.gamememberidx = b.midx  inner join tblgamecode as c on c.seq = b.gamecodeseq "
		SQL = "select "&fld&"  from "&tbl&" where a.delyn = 'N' and a.gubun in (1,3) and a.tryoutsortno > 0 and b.idx = " & ridx
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)



	If Not rs.EOF Then
		'배열로 화면 확인
		'arrR = rs.GetRows()
		'Call oJSONoutput.Set("list", arrR ) '배열

		rsobj =  jsonTors_arr(rs)
		objstr = "{""list"": "&rsobj&",""result"":""0""}"
		Response.write objstr
	Else
		Call oJSONoutput.Set("list", array() ) '정상
		Call oJSONoutput.Set("result", "0" ) '정상
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
	End If

	db.Dispose
	Set db = Nothing
%>

