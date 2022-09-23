<%
'#############################################
'부통합해제
'#############################################

	'request
	tidx = oJSONoutput.Get("TIDX")
	lidx = oJSONoutput.Get("LIDX")
	CDA = "F2" '아티스틱

	Set db = new clsDBHelper 
		

	'기본정보 호출
	booinfo = getBooInfo(lidx, db, ConStr, CDA)

	grouplevelidx = booinfo(0) 
	RoundCnt =  booinfo(1)
	judgeCnt =  booinfo(2)
	grplidxs = booinfo(3)
	grpgbidxs = booinfo(6) 'gbidxs

	'예외처리
	Call judgeExceptionEnd(tidx,judgeCnt,RoundCnt,grplidxs,chkpass , db, ConStr, CDA) '체점여부

	

		If InStr(grplidxs,",") > 0 Then '통합

			lidxarr = Split(grplidxs,",") '솔로만 묶을수 있어서 솔로만 있다.
			gbidxarr = Split(grpgbidxs,",")
			plusnext = 0 '순서번호끝값  부터 시작 (통합시)
			For i = 0 To ubound(lidxarr)


				'다음 순서번호 업데이트 (다음순서는 더한거 다시 원복)
				SQL = "update sd_gameMember Set tryoutsortNo = ABS(tryoutsortNo - " & plusnext & "),tryoutsortno2 =  ABS(tryoutsortNo2 - " & plusnext & "),tryoutsortno3 =  ABS(tryoutsortNo3 - " & plusnext & "),tryoutsortno4 =  ABS(tryoutsortNo4 - " & plusnext & "),tryoutsortno5 =  ABS(tryoutsortNo5 - " & plusnext & ") where delyn = 'N' and  gametitleidx = "&tidx&" and gbidx =  " & gbidxarr(i) 
				Call db.execSQLRs(SQL , null, ConStr)
				SQL = "select max(tryoutsortNo) from sd_gameMember where delyn = 'N' and  gametitleidx = "&tidx&" and gbidx =  " & gbidxarr(i) 
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)		
				plusnext = plusnext + CDbl(rs(0))





				'화면에서 통합시 사용못함으로 처리하자.
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

		SQL = "update tblRGameLevel set Grouplevelidx = null  Where Grouplevelidx in (" & lidxs & ")"
		Call db.execSQLRs(SQL , null, ConStr)


	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing


%>