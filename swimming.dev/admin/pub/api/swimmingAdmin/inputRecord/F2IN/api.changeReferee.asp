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




	CDA = "F2" '아티스틱

	Set db = new clsDBHelper

		'기본정보 호출
		booinfo = getBooInfo(lidx, db, ConStr, CDA)

		grouplevelidx = booinfo(0) 
		RoundCnt =  booinfo(1)
		judgeCnt =  booinfo(2)
		lidxs = booinfo(3)

		'예외처리
		'Call judgeExceptionEnd(tidx,judgeCnt,RoundCnt,lidxs,chkpass , db, ConStr, CDA) '체점여부

		'심판카운트조정
		Call resetChangeJudgeCnt(tidx, jidx, targetjidx,targetfldno,  db, ConStr ,CDA)


		'심판 변경	
		Call  setChangeJudge( tidx,lidxs     ,jidx,targetjidx, myfldno, targetfldno               ,db,ConStr,CDA)

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson


	Set rs = Nothing
	db.Dispose
	Set db = Nothing
%>
