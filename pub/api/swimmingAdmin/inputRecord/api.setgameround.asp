<%
'#############################################
'다이빙, 아티스틱 라운드 저장및 설정 (통합경기는 설정못함)
'#############################################
	
	'request
	tidx = oJSONoutput.Get("TIDX")
	lidx = oJSONoutput.Get("LIDX")

	gbidx = oJSONoutput.Get("GBIDX")
	rndcnt = oJSONoutput.Get("RNDCNT") '받아온 라운드
	
	CDA = "E2" '다이빙

	Set db = new clsDBHelper 

		'기본정보 호출
		booinfo = getBooInfo(lidx, db, ConStr, CDA)

		grouplevelidx = booinfo(0) 
		RoundCnt =  booinfo(1)
		judgeCnt =  booinfo(2)
		lidxs = booinfo(3)

		'예외처리
		Call judgeExceptionEnd(tidx,judgeCnt,RoundCnt,lidxs,chkpass , db, ConStr, CDA) '체점여부
		'심판정보 리셋
		Call resetJudge(tidx, lidxs , db, ConStr ,CDA)




		SQL = "delete from  sd_gameMember_roundRecord where lidx = " & lidx '기존것 삭제 (심사된것 삭제 못하게 했으니 그냥 지우자)
		SQL = SQL &  "update tblRGameLevel set roundcnt = " & rndcnt & " where RGameLevelidx = "  & lidx
		Call db.execSQLRs(SQL , null, ConStr)

		SQL = "select gamememberidx from sd_gameMember where delyn = 'N' and gametitleidx = "&tidx&" and gbidx = "&gbidx&" "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		arrR = rs.GetRows()

		SQL = ""
		If IsArray(arrR) Then 
			For ari = LBound(arrR, 2) To UBound(arrR, 2)
				m_idx = arrR(0, ari)
		
				For i = 1 To rndcnt 
					SQL =  SQL & " insert into  sd_gameMember_roundRecord ( midx,tidx,lidx,gameround ) values ("&m_idx&","&tidx&","&lidx&","& i &") "
				Next
			Next
		End if
		Call db.execSQLRs(SQL , null, ConStr)

		Call oJSONoutput.Set("result", 0 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson

		Set rs = Nothing
		db.Dispose
		Set db = Nothing





%>