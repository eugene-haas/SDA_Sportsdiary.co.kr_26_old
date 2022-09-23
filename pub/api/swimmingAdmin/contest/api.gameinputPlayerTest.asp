<%
'#############################################
'대회참가자 추가
'#############################################
	'request
	If hasown(oJSONoutput, "LIDX") = "ok" then
		levelidx = oJSONoutput.LIDX
	End if

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

		'생성할 랜덤 명수만큼 player 검색
	    Randomize
	    rndRC = Int(Rnd() * 10) + 5 '99뿐까지 


		'계영 400m, 800m와 혼계영 400m 
		If l_CDC = "16" Or l_CDC = "17" Or l_CDC="15" then
			SQL = "Select top "&rndRC&" teamIDX from tblTeamInfo where delyn = 'N' ORDER BY NEWID()"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			If Not rs.EOF Then
				rndR = rs.GetRows()
			End If
		Else
			SQL = "Select top "&rndRC&" playeridx from tblPlayer where delyn = 'N' and ksportsno <> '' ORDER BY NEWID()"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			If Not rs.EOF Then
				rndR = rs.GetRows()
			End If
		End if



	If IsArray(rndR) Then 
		For a = LBound(rndR, 2) To UBound(rndR, 2)
			pidx= rndR(0, a) 
			
		'계영 400m, 800m와 혼계영 400m 
		If l_CDC = "16" Or l_CDC = "17" Or l_CDC="15" Then

		

			fld = " Team,TeamNM,sidocode,sido,sexno,CDB,groupnm,teamTel,jangname,readername "
			SQL = "select "& fld &" from tblTeamInfo where teamIDX = " & pidx & "  "
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
					l_CDB= arrR(5, ari) '부별코드
					l_groupnm= arrR(6, ari) '부별명칭(초등학교)
					l_teamTel= arrR(7, ari)  '전화
					l_jangname= arrR(8, ari) '장
					l_readername= arrR(9, ari) '리더
				Next
			End If




		'단계 3 최종 저장 (팀 단체 계영 저장인경우)
			infld = " GameTitleIDX,gbIDX,levelno,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,     P1_MIDX,P1_PlayerIDX,P1_UserName,P1_UserClass,P1_Team,P1_TeamNm,P1_Birthday,P1_SEX  , sido,sidonm "
			inval = " '"&l_tidx&"','"&l_gbidx&"','"&l_levelno&"','"&l_CDA&"','"&l_CDANM&"','"&l_CDB&"','"&l_CDBNM&"','"&l_CDC&"','"&l_CDCNM&"',     '0','0','"&l_jangname&"','0','"&l_Team&"','"&l_TeamNm&"','0','"&l_Sex&"'  ,'"&l_sidocode&"','"&l_sidonm&"' "

			SQL = "SET NOCOUNT ON  INSERT INTO tblGameRequest ( "&infld&" ) VALUES ("&inval&")  SELECT @@IDENTITY " 
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			reqidx = rs(0) '참가신청 인덱스

			'sd_gameMember 에도 넣어야지 단체니까 팀만
			infld = " midx,GameTitleIDX,PlayerIDX,userName,gbIDX,levelno,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,Team,TeamNm,userClass,Sex,requestIDX,sidonm "
			inval = " '0','"&l_tidx&"','0','단체','"&l_gbidx&"','"&l_levelno&"','"&l_CDA&"','"&l_CDANM&"','"&l_CDB&"','"&l_CDBNM&"','"&l_CDC&"','"&l_CDCNM&"','"&l_Team&"','"&l_TeamNm&"','0','"&l_Sex&"','"&reqidx&"', '"&l_sidonm&"' "

			SQL = "INSERT INTO sd_gameMember ( "&infld&" ) VALUES ("&inval&")" 
			Call db.execSQLRs(SQL , null, ConStr)



			'테이블 만들어서 팀코드 에 선수들 4명 이상을 랜덤하게 넣자. 최종 4명 선택하겠지 (request테이블 서브에)
			SQL = "insert into tblGameRequest_r (requestIDX,playeridx,username,team,teamnm,userClass)  (Select top 6 '"&reqidx&"',playeridx,username,team,teamnm,userClass from tblPlayer where delyn = 'N' and ksportsno <> '' and team = '"&l_Team&"'  )"
			Call db.execSQLRs(SQL , null, ConStr)
		
		
		
		Else '#######################################################################################################################

		
		
			fld = " ksportsno,startyear,nowyear,MemberIDX,userID,userType,UserName,UserPhone,Birthday,Sex,ProfileIMG,EnterType,Team,TeamNm,userClass,sido "
			SQL = "select "& fld &" from tblPlayer where playeridx = " & pidx & " and  usertype = 'I' " 'I개인 T 팀
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)			

'			Call rsdrow(rs)
'			Response.end

			If Not rs.EOF Then
				arrR = rs.GetRows()
			End If

			If IsArray(arrR) Then 
				For ari = LBound(arrR, 2) To UBound(arrR, 2)
					l_ksportsno= arrR(0, ari) '체육인번호
					l_startyear= arrR(1, ari) '체육인 등록 년도
					l_nowyear= arrR(2, ari) '현재 등록여부
					l_MemberIDX= arrR(3, ari) 
					l_userID= arrR(4, ari)
					l_userType= arrR(5, ari) 'I T 개인 팀
					l_UserName= arrR(6, ari) 
					l_UserPhone= arrR(7, ari)
					l_Birthday= arrR(8, ari)
					l_Sex= arrR(9, ari) '1 2
					l_ProfileIMG= arrR(10, ari)
					l_EnterType= arrR(11, ari)
					l_Team= arrR(12, ari)
					l_TeamNm= arrR(13, ari)
					l_userClass= arrR(14, ari) '학년
					l_sidonm = arrR(15, ari) '시도
				Next
			End If




		'단계 3 최종 저장
			infld = " GameTitleIDX,gbIDX,levelno,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,     P1_MIDX,P1_PlayerIDX,P1_UserName,P1_UserClass,P1_Team,P1_TeamNm,P1_Birthday,P1_SEX  , P1_ksportsno "
			inval = " '"&l_tidx&"','"&l_gbidx&"','"&l_levelno&"','"&l_CDA&"','"&l_CDANM&"','"&l_CDB&"','"&l_CDBNM&"','"&l_CDC&"','"&l_CDCNM&"',     '"&l_MemberIDX&"','"&pidx&"','"&l_UserName&"','"&l_userClass&"','"&l_Team&"','"&l_TeamNm&"','"&l_Birthday&"','"&l_Sex&"'  ,'"&l_ksportsno&"' "

			SQL = "SET NOCOUNT ON  INSERT INTO tblGameRequest ( "&infld&" ) VALUES ("&inval&")  SELECT @@IDENTITY " 
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			reqidx = rs(0) '참가신청 인덱스

			'sd_gameMember 에도 넣어야지 않을가
			infld = " midx,GameTitleIDX,PlayerIDX,userName,gbIDX,levelno,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,Team,TeamNm,userClass,Sex,requestIDX,sidonm "
			inval = " '"&l_MemberIDX&"','"&l_tidx&"','"&pidx&"','"&l_UserName&"','"&l_gbidx&"','"&l_levelno&"','"&l_CDA&"','"&l_CDANM&"','"&l_CDB&"','"&l_CDBNM&"','"&l_CDC&"','"&l_CDCNM&"','"&l_Team&"','"&l_TeamNm&"','"&l_userClass&"','"&l_Sex&"','"&reqidx&"', '"&l_sidonm&"' "

			SQL = "INSERT INTO sd_gameMember ( "&infld&" ) VALUES ("&inval&")" 
			Call db.execSQLRs(SQL , null, ConStr)
		
		
		
		
		
		
		End If
		


		Next
	End if



		Call oJSONoutput.Set("result", 0 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson

  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>