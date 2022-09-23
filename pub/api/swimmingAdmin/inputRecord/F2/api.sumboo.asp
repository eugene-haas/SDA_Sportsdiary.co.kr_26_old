<%
'#############################################
'다이빙  라운드 저장및 설정
'#############################################

	'request
	Set lidxarr = oJSONoutput.Get("LIDXARR")
	lidxlen = lidxarr.length

	For i = 0 To lidxarr.length-1
	   If i = 0 then
		   grplidxs = lidxarr.Get(i)
	   Else
		   grplidxs = grplidxs &","& lidxarr.Get(i)
	   End if
	Next
	CDA = "F2" '아티스틱

	Set db = new clsDBHelper 

		SQL = "select count(*) from (Select count(*) as c From sd_gameMember_roundRecord Where lidx In ("&grplidxs&") group by lidx ) as A "
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
		gbidxsquery = "(SELECT  STUFF(( select ','+ cast(gbidx as varchar) from tblRGameLevel where RgameLevelidx in ("&grplidxs&") group by gbidx for XML path('') ),1,1, '' ))"
		SQL = "Select isnull(max(Grouplevelidx),'') , min(RGameLevelidx) ,max(gametitleidx),min(roundcnt),min(judgecnt), "&gbidxsquery&" as sno  From tblRGameLevel Where RGameLevelidx in ("&grplidxs&") "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		chkgrp_idx = rs(0)
		group_lidx = rs(1)
		tidx = rs(2)
		RoundCnt =  rs(3)
		judgeCnt =  rs(4)
		grpgbidxs = rs(5)
		

		'예외처리
		If chkgrp_idx = "" Then
				Call oJSONoutput.Set("result", 24 ) '통합항목있음 있으면 안됨.
				strjson = JSON.stringify(oJSONoutput)
				Response.Write strjson
		End if

		'예외처리
		Call judgeExceptionEnd(tidx,judgeCnt,RoundCnt,grplidxs,chkpass , db, ConStr, CDA) '체점여부



		'###########################################
		If InStr(grplidxs,",") > 0 Then '통합

			lidxarr = Split(grplidxs,",") '솔로만 묶을수 있어서 솔로만 있다.
			gbidxarr = Split(grpgbidxs,",")
			plusnext = 0 '순서번호끝값  부터 시작 (통합시)
			For i = 0 To ubound(lidxarr)

				'다음 순서번호 업데이트 
				SQL = "update sd_gameMember Set tryoutsortNo = tryoutsortNo + " & plusnext & ",tryoutsortno2 = tryoutsortNo2 + " & plusnext & ",tryoutsortno3 = tryoutsortNo3 + " & plusnext & ",tryoutsortno4 = tryoutsortNo4 + " & plusnext & ",tryoutsortno5 = tryoutsortNo5 + " & plusnext & " where delyn = 'N' and  gametitleidx = "&tidx&" and gbidx =  " & gbidxarr(i) 
				Call db.execSQLRs(SQL , null, ConStr)
				SQL = "select max(tryoutsortNo) from sd_gameMember where delyn = 'N' and  gametitleidx = "&tidx&" and gbidx =  " & gbidxarr(i) 
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)		
				plusnext = plusnext + CDbl(rs(0))



				'듀엣 팀 정보 가져오기
				artinfo = getArtiGroup(tidx,lidxarr(i), gbidxarr(i) ,  db,Constr,CDA)

				lidxs = artinfo(0)
				gbidxs = artinfo(1)

				'심판정보 리셋
				Call resetJudge(tidx, lidxs , db, ConStr ,CDA)
			Next

		Else
				'심판정보 리셋
				Call resetJudge(tidx, grplidxs , db, ConStr ,CDA)
		End if
		'###########################################





		'통합항목의 라운드는 같아야한다. 나머지는 1번과 동일하게 .
		SQL = "Select judgeCnt,gamecodeidx,tryoutgamedate,tryoutgamestarttime From tblRGameLevel Where RGameLevelidx = "  & group_lidx
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		judgeCnt = rs(0)
		gamecodeidx =  rs(1)
		tryoutgamedate =  rs(2)
		tryoutgamestarttime =  rs(3)
		
		SQL = "update tblRGameLevel set Grouplevelidx = " & group_lidx & ",judgeCnt= '"&judgeCnt&"',gamecodeidx = '"&gamecodeidx&"' ,tryoutgamedate= '"&tryoutgamedate&"',tryoutgamestarttime= '"&tryoutgamestarttime&"'   Where RGameLevelidx in ("&grplidxs&") "
		Call db.execSQLRs(SQL , null, ConStr)


	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing


%>