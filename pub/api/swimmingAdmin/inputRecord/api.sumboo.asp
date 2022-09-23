<%
'#############################################
'다이빙  라운드 저장및 설정
'#############################################

	'request
	Set lidxarr = oJSONoutput.Get("LIDXARR")
	lidxlen = lidxarr.length

	For i = 0 To lidxarr.length-1
	   If i = 0 then
		   lidxs = lidxarr.Get(i)
	   Else
		   lidxs = lidxs &","& lidxarr.Get(i)
	   End if
	Next
	CDA = "E2" '다이빙

	Set db = new clsDBHelper 

		SQL = "select count(*) from (Select count(*) as c From sd_gameMember_roundRecord Where lidx In ("&lidxs&") group by lidx ) as A "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		chkcnt = rs(0)
		If lidxlen <> chkcnt Then
				Call oJSONoutput.Set("result", 111 ) '서버에서 메시지 생성 전달
				Call oJSONoutput.Set("servermsg", "부서중에 등록된 선수가 없는 부서가 있습니다." ) '서버에서 메시지 생성 전달
				strjson = JSON.stringify(oJSONoutput)
				Response.Write strjson
				Response.end
		End if



		'기본정보
		SQL = "Select isnull(max(Grouplevelidx),'') , min(RGameLevelidx) ,max(gametitleidx),min(roundcnt),min(judgecnt)  From tblRGameLevel Where RGameLevelidx in ("&lidxs&") "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		chkgrp_idx = rs(0)
		group_lidx = rs(1)
		tidx = rs(2)
		RoundCnt =  rs(3)
		judgeCnt =  rs(4)

		'예외처리
		If chkgrp_idx = "" Then
				Call oJSONoutput.Set("result", 24 ) '통합항목있음 있으면 안됨.
				strjson = JSON.stringify(oJSONoutput)
				Response.Write strjson
		End if

		'예외처리
		Call judgeExceptionEnd(tidx,judgeCnt,RoundCnt,lidxs,chkpass , db, ConStr, CDA) '체점여부

		'심판정보 리셋
		Call resetJudge(tidx, lidxs , db, ConStr ,CDA)

		'통합항목의 라운드는 같아야한다. 나머지는 1번과 동일하게 .
		SQL = "Select judgeCnt,gamecodeidx,tryoutgamedate,tryoutgamestarttime From tblRGameLevel Where RGameLevelidx = "  & group_lidx
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		judgeCnt = rs(0)
		gamecodeidx =  rs(1)
		tryoutgamedate =  rs(2)
		tryoutgamestarttime =  rs(3)
		
		SQL = "update tblRGameLevel set Grouplevelidx = " & group_lidx & ",judgeCnt= '"&judgeCnt&"',gamecodeidx = '"&gamecodeidx&"' ,tryoutgamedate= '"&tryoutgamedate&"',tryoutgamestarttime= '"&tryoutgamestarttime&"'   Where RGameLevelidx in ("&lidxs&") "
		Call db.execSQLRs(SQL , null, ConStr)


	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing


%>