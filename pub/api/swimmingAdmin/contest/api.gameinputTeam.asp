<%
'#############################################
'대회참가자 추가
'#############################################
	'request

	'팀명, 시도, 팀코드, levelidx


	If hasown(oJSONoutput, "PARR") = "ok" then
		Set reqArr = oJSONoutput.PARR '23번까지 '13, 14 날짜형태

		teamnm = reqArr.Get(0) 
		sidonm	= reqArr.Get(1)
		team = reqArr.Get(2) 
		levelidx =  reqArr.Get(3)
	End if

'	If team = "" Then '검색후 선택할수 있도록 돌려보냄
'		Call oJSONoutput.Set("result", 2)
'		strjson = JSON.stringify(oJSONoutput)
'		Response.Write strjson
'		Response.End
'	End if

	Set db = new clsDBHelper 



	'단계 1 정보 검색
		fld =  " RGameLevelidx,GameTitleIDX,GbIDX,Sexno,ITgubun,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,levelno " 
		SQL = "select "& fld &" from tblRGameLevel where RGameLevelidx = " & levelidx
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.EOF Then
			arrR = rs.GetRows()
		End If

		If IsArray(arrR) Then 
			For ari = LBound(arrR, 2) To UBound(arrR, 2)
				l_idx = arrR(0, ari) 'idx
				l_tidx = arrR(1, ari)
				l_gbidx= arrR(2, ari)
				l_Sexno= arrR(3, ari)
				Select Case l_Sexno
				Case "1"
					l_sex = "남자"
				Case "2"
					l_sex = "남자"
				Case "3"
					l_sex = "혼성"
				End Select 

				l_ITgubun= arrR(4, ari)
				l_CDA= arrR(5, ari)
				l_CDANM= arrR(6, ari)
				l_CDB= arrR(7, ari)
				l_CDBNM= arrR(8, ari)
				l_CDC= arrR(9, ari)
				l_CDCNM= arrR(10, ari)
				l_levelno= arrR(11, ari)
			Next
		End If

			fld = " Team,TeamNM,sidocode,sido,sexno,CDB,groupnm,teamTel,jangname,readername ,entertype "
			SQL = "select top 1 " & fld & " from tblTeamInfo where team = '" & team & "'  order by teamidx desc"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)			

			If Not rs.EOF Then
				arrR = rs.GetRows()
			End If

			If IsArray(arrR) Then 
				For ari = LBound(arrR, 2) To UBound(arrR, 2)
					l_Team= arrR(0, ari) '팀코드
					l_TeamNM= arrR(1, ari) '명
					l_sidocode= arrR(2, ari) '시도코드
					l_sidonm = arrR(3, ari) '시도
					l_sex= arrR(4, ari) '성멸번호 1,2  
					'l_CDB= arrR(5, ari) '부별코드 (선수껄로 넣으면 안된다......위에껄로 들어가도록 수정 2020 12 24
					l_groupnm= arrR(6, ari) '부별명칭(초등학교)
					l_teamTel= arrR(7, ari)  '전화
					l_jangname= arrR(8, ari) '장
					l_readername= arrR(9, ari) '리더
					l_entertype = arrR(10,ari) 'E A 엘리트 아마추어
				Next
			End If

		'단계 3 최종 저장 (팀 단체 계영 저장인경우)
			infld = " GameTitleIDX,gbIDX,levelno,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,     P1_MIDX,P1_PlayerIDX,P1_UserName,P1_UserClass,P1_Team,P1_TeamNm,P1_Birthday,P1_SEX  , sido,sidonm ,itgubun , entertype  "
			inval = " '"&l_tidx&"','"&l_gbidx&"','"&l_levelno&"','"&l_CDA&"','"&l_CDANM&"','"&l_CDB&"','"&l_CDBNM&"','"&l_CDC&"','"&l_CDCNM&"',     '0','0','단체','0','"&l_Team&"','"&l_TeamNm&"','0','"&l_Sex&"'  ,'"&l_sidocode&"','"&l_sidonm&"', 'T' ,'"&l_entertype&"' "

			SQL = "SET NOCOUNT ON  INSERT INTO tblGameRequest ( "&infld&" ) VALUES ("&inval&")  SELECT @@IDENTITY " 
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			reqidx = rs(0) '참가신청 인덱스


			'sd_gameMember 에도 넣어야지 않을가
			infld = " midx,GameTitleIDX,PlayerIDX,userName,gbIDX,levelno,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,Team,TeamNm,userClass,Sex,requestIDX,sidonm ,itgubun ,gubun "
			inval = " '"&l_MemberIDX&"','"&l_tidx&"','0','단체','"&l_gbidx&"','"&l_levelno&"','"&l_CDA&"','"&l_CDANM&"','"&l_CDB&"','"&l_CDBNM&"','"&l_CDC&"','"&l_CDCNM&"','"&l_Team&"','"&l_TeamNm&"','"&l_userClass&"','"&l_Sex&"','"&reqidx&"', '"&l_sidonm&"' ,'T' ,1 "

			SQL = "INSERT INTO sd_gameMember ( "&infld&" ) VALUES ("&inval&")" 
			Call db.execSQLRs(SQL , null, ConStr)

			'레인배정할때 엑셀에서 등록할때 starttype 을 생성한다 .여기서는 안함 




		Call oJSONoutput.Set("result", 0 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson

  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>