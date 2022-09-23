<%
'#############################################
' 다이빙 심판수정완료
'#############################################
	'request
	tidx = oJSONoutput.Get("TIDX")
	lidx = oJSONoutput.Get("LIDX") 'tblRGameLevel.RGameLevelidx
	jidx = oJSONoutput.Get("JIDX") '심판키 (바꿀대상)
	targetjidx = oJSONoutput.Get("TARGETJIDX") '바꿀심판
	myfldno = oJSONoutput.Get("MYFLDNO") '나의 필드 (변경될)
	targetfldno = oJSONoutput.Get("TARGETFLDNO") '같은 부서에 있다면 변경될 필드 번호
	gameround = oJSONoutput.Get("RND")
	cdc = oJSONoutput.Get("CDC") '




	CDA = "F2" '아티스틱

	Set db = new clsDBHelper

		'기본정보 호출
		booinfo = getBooInfo(lidx, db, ConStr, CDA)

		grouplevelidx = booinfo(0) 
		RoundCnt =  booinfo(1)
		judgeCnt =  booinfo(2)
		grplidxs = booinfo(3)

		'심판카운트조정 (카운트는 솔로만 카운트 하는걸로 되어야한다 확인필요)
		Call resetChangeJudgeCnt(tidx, jidx, targetjidx,targetfldno,  db, ConStr ,CDA)




		If InStr(lidxs,",") > 0 Then '통합
			lidxarr = Split(grplidxs,",") '솔로만 묶을수 있어서 솔로만 있다.

			For i = 0 To ubound(lidxarr)

				'화면에서 통합시 사용못함으로 처리하자.
				artinfo = getArtiGroup(tidx,lidxarr(i), "" ,  db,Constr,CDA)
				If i = 0 then
					lidxs = artinfo(0)
				Else
					lidxs = lidxs & "," & artinfo(0)
				End if
			Next

		Else

			artinfo = getArtiGroup(tidx,lidx,"",  db,Constr,CDA)
			lidxs = artinfo(0)
		End if

		
		'심판 변경	(듀엣과 팀도 같이 변경되어야한다)
		Call  setChangeJudge( tidx,lidxs     ,jidx,targetjidx, myfldno, targetfldno  , cdc, gameround           ,db,ConStr,CDA)

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson


	Set rs = Nothing
	db.Dispose
	Set db = Nothing
%>
