<%
'#############################################
'다이빙, 아티스틱 라운드 저장및 설정 (통합경기는 설정못함)
'#############################################
	
	'request
	tidx = oJSONoutput.Get("TIDX")
	lidx = oJSONoutput.Get("LIDX")

	gbidx = oJSONoutput.Get("GBIDX")
	rndcnt = oJSONoutput.Get("RNDCNT") '받아온 라운드
	
	CDA = "F2" '아티스틱

	Set db = new clsDBHelper 

		'기본정보 호출
		booinfo = getBooInfo(lidx, db, ConStr, CDA)

		grouplevelidx = booinfo(0) 
		RoundCnt =  booinfo(1)
		judgeCnt =  booinfo(2)
		grplidxs = booinfo(3)

		'예외처리
		Call judgeExceptionEnd(tidx,judgeCnt,RoundCnt,grplidxs,chkpass , db, ConStr, CDA) '체점여부
		'심판정보 리셋
		Call resetJudge(tidx, grplidxs , db, ConStr ,CDA)




		artinfo = getArtiGroup(tidx,lidx,gbidx,  db,Constr,CDA)
		lidxs = artinfo(0)
		gbidxs = artinfo(1)
		lidxsarr = Split(lidxs,",")
		gbidxsarr = Split(gbidxs,",")


		SQL = "delete from  sd_gameMember_roundRecord where lidx in ( " & lidxs & ") " '기존것 삭제 (심사된것 삭제 못하게 했으니 그냥 지우자)
		SQL = SQL &  "update tblRGameLevel set roundcnt = " & rndcnt & " where RGameLevelidx  in ( " & lidxs & ")  "
		Call db.execSQLRs(SQL , null, ConStr)





		
		For i = 0 To ubound(gbidxsarr)

			'라운드가 설정되었다면 각라운드 순서 번호 복사################
			If CDbl(rndcnt) > 1 then
				For rd = 2 To rndcnt '머그냥 다 복사해도 될듯...정확히 맞추어두어야할까 (테크가 6라운드까지임 최대크기)
					If rd = 2 then
						updatestr = " tryoutsortNo2= case when tryoutsortNo2 = 0 then tryoutsortNo else tryoutsortNo2 end "
					Else
						If rd > CDbl(rndcnt) then
							updatestr = updatestr & " ,tryoutsortNo"&rd&"= 0 "
						Else
							updatestr = updatestr & " ,tryoutsortNo"&rd&"= case when tryoutsortNo"&rd&" = 0 then tryoutsortNo else tryoutsortNo"&rd&" end "
						End if
					End if
				Next
			Else
				updatestr = " tryoutsortNo2= 0,tryoutsortNo3= 0,tryoutsortNo4= 0,tryoutsortNo5= 0,,tryoutsortNo6= 0 "
			End If

			SQL = "update  sd_gameMember set "&updatestr&"  where delyn = 'N' and  gametitleidx = "&tidx&" and gbidx =  " & gbidxsarr(i)
			Call db.execSQLRs(SQL , null, ConStr)			



			
			SQL = "select gamememberidx,cda,cdb,cdc, (select isNull(count(*),1) from sd_gameMember_partner where gamememberidx = a.gamememberidx  ) from sd_gameMember as a where delyn = 'N' and gametitleidx = "&tidx&" and gbidx =  " & gbidxsarr(i)
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			arrR = rs.GetRows()

			SQL = ""
			If IsArray(arrR) Then 
				For ari = LBound(arrR, 2) To UBound(arrR, 2)
					m_idx = arrR(0, ari)
					m_cda = arrR(1,ari)
					m_cdb = arrR(2,ari)
					m_cdc = arrR(3,ari)
					m_cnt = arrR(4,ari)
			
					For m = 1 To rndcnt 
						SQL =  SQL & " insert into  sd_gameMember_roundRecord ( midx,tidx,lidx,gameround ,cda,cdb,cdc,membercnt) values ("&m_idx&","&tidx&","&lidxsarr(i)&","& m &", '"&m_cda&"', '"&m_cdb&"', '"&m_cdc&"', "&m_cnt&") "
					Next
				Next
			End if
			Call db.execSQLRs(SQL , null, ConStr)

		next



		Call oJSONoutput.Set("result", 0 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson

		Set rs = Nothing
		db.Dispose
		Set db = Nothing





%>