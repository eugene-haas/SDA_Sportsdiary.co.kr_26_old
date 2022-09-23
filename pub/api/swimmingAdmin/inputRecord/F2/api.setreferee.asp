<%
'#############################################
' 심판 부에 배정
'#############################################
	'request
	tidx = oJSONoutput.Get("TIDX")
	lidx = oJSONoutput.Get("LIDX") 'tblRGameLevel.RGameLevelidx
	gbidx = oJSONoutput.Get("GBIDX")
	chkpass = oJSONoutput.Get("CHKPASS")
	CDA = "F2" '아티스틱

	Set db = new clsDBHelper

		'기본정보 호출
		booinfo = getBooInfo(lidx, db, ConStr, CDA)
		grouplevelidx = booinfo(0) 
		RoundCnt =  booinfo(1)
		judgeCnt =  booinfo(2)
		grplidxs = booinfo(3) '쪼개서 다시해야할꺼같은데
		grpgbidxs = booinfo(6) 'gbidxs

		'예외처리
		Call judgeExceptionRnd(tidx,judgeCnt,RoundCnt,lidx,chkpass , db, ConStr, CDA) '라운드설정여부
		Call judgeExceptionJcnt(tidx,judgeCnt,RoundCnt,lidx,chkpass , db, ConStr, CDA) '심판수
		Call judgeExceptionEnd(tidx,judgeCnt,RoundCnt,lidx,chkpass , db, ConStr, CDA) '체점여부
		Call judgeException(tidx,judgeCnt,RoundCnt,lidx,chkpass , db, ConStr, CDA) '심판배정여부


'Response.write InStr(grplidxs,",") & "$$$$$$$$$$$"


		If InStr(grplidxs,",") > 0 Then '통합

			lidxarr = Split(grplidxs,",") '솔로만 묶을수 있어서 솔로만 있다.
			gbidxarr = Split(grpgbidxs,",")

			For i = 0 To ubound(lidxarr)

				'화면에서 통합시 사용못함으로 처리하자.
				artinfo = getArtiGroup(tidx,lidxarr(i), gbidxarr(i) ,  db,Constr,CDA)
				If i = 0 then
				lidxs = artinfo(0)
				'gbidxs = artinfo(1)
				Else
				lidxs = lidxs & "," & artinfo(0)
				End if
			Next

			'심판정보 리셋
			Call resetJudge(tidx, lidxs , db, ConStr ,CDA)
			'심판 배정
			Call setJudge(tidx, lidxs , db, ConStr ,CDA)


		Else


			'화면에서 통합시 사용못함으로 처리하자.
			artinfo = getArtiGroup(tidx,lidx,gbidx,  db,Constr,CDA)
			lidxs = artinfo(0)
			'gbidxs = artinfo(1)
			
			'심판정보 리셋
			Call resetJudge(tidx, lidxs , db, ConStr ,CDA)
			'심판 배정
			Call setJudge(tidx, lidxs , db, ConStr ,CDA)

		End if



'	Call oJSONoutput.Set("gb", grplidxs )
	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson




	Set rs = Nothing
	db.Dispose
	Set db = Nothing
%>
