<%
'#############################################
' 전체심판 부에 배정
'#############################################
	'request
	tidx = oJSONoutput.Get("TIDX")
	CDA = "E2" '다이빙

	Set db = new clsDBHelper




	'수구빼고 31
	SQL = "select RGameLevelidx from tblRGameLevel  as a where  delyn = 'N' and gametitleidx =  " & tidx  & "  and CDA='E2'  and CDC <> '31' "
  SQL = SQL & " and (  grouplevelidx is null or grouplevelidx = RGameLevelidx )   order by cast(gameno as int) "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


do until rs.eof 

    lidx = rs(0) 
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
    
rs.movenext
loop






	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson




	Set rs = Nothing
	db.Dispose
	Set db = Nothing
%>
