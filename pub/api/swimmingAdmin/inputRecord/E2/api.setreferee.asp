<%
'#############################################
' 심판 부에 배정
'#############################################
	'request
	tidx = oJSONoutput.Get("TIDX")
	lidx = oJSONoutput.Get("LIDX") 'tblRGameLevel.RGameLevelidx
	chkpass = oJSONoutput.Get("CHKPASS")
	
	CDA = "E2" '다이빙

	Set db = new clsDBHelper

		'기본정보 호출
		booinfo = getBooInfo(lidx, db, ConStr, CDA)

		grouplevelidx = booinfo(0) 
		RoundCnt =  booinfo(1)
		judgeCnt =  booinfo(2)
		lidxs = booinfo(3)

		'예외처리
		Call judgeExceptionRnd(tidx,judgeCnt,RoundCnt,lidxs,chkpass , db, ConStr, CDA) '라운드설정여부
		Call judgeExceptionJcnt(tidx,judgeCnt,RoundCnt,lidxs,chkpass , db, ConStr, CDA) '심판수
		Call judgeExceptionEnd(tidx,judgeCnt,RoundCnt,lidxs,chkpass , db, ConStr, CDA) '체점여부
		Call judgeException(tidx,judgeCnt,RoundCnt,lidxs,chkpass , db, ConStr, CDA) '심판배정

		'심판정보 리셋
		Call resetJudge(tidx, lidxs , db, ConStr ,CDA)

		'심판 배정
		Call setJudge(tidx, lidxs , db, ConStr ,CDA)



	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson




	Set rs = Nothing
	db.Dispose
	Set db = Nothing
%>
