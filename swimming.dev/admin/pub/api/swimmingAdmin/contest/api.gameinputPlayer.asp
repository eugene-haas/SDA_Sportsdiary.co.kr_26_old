<%
'#############################################
'대회참가자 추가
'#############################################
	'request
	If hasown(oJSONoutput, "PARR") = "ok" then
		Set reqArr = oJSONoutput.PARR '23번까지 '13, 14 날짜형태

		username = reqArr.Get(0) 
		teamnm	= reqArr.Get(1)
		pidx = reqArr.Get(2) 
		levelidx =  reqArr.Get(3)
	End if

	If pidx = "" Then '검색후 선택할수 있도록 돌려보냄
		Call oJSONoutput.Set("result", 2)
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.End
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

			fld = " kskey,startyear,nowyear,MemberIDX,userID,userType,UserName,UserPhone,Birthday,Sex,ProfileIMG,EnterType,Team,TeamNm,userClass,sido "
			SQL = "select "& fld &" from tblPlayer where playeridx = " & pidx & " and  usertype = 'I' " 'I개인 T 팀
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)			

			'Call rsdrow(rs)
			'Response.end

			If Not rs.EOF Then
				arrR = rs.GetRows()
			End If

			If IsArray(arrR) Then 
				For ari = LBound(arrR, 2) To UBound(arrR, 2)
					l_ksportsno= arrR(0, ari) '체육인번호 X ksportsno / kskey O
					l_startyear= arrR(1, ari) '체육인 등록 년도
					l_nowyear= arrR(2, ari) '현재 등록여부
					l_MemberIDX= arrR(3, ari) 
					l_userID= arrR(4, ari)
					l_userType= arrR(5, ari) 'I T 개인 팀
					l_UserName= arrR(6, ari) 
					l_UserPhone= arrR(7, ari)
					l_Birthday= arrR(8, ari)
					l_Sex= arrR(9, ari) 'Man Woman
					l_ProfileIMG= arrR(10, ari)
					l_EnterType= arrR(11, ari)
					l_Team= arrR(12, ari)
					l_TeamNm= arrR(13, ari)
					l_userClass= arrR(14, ari) '학년
					l_sidonm = arrR(15, ari) '시도

				Next
			End If

		'2단계 중복체크 (팀당 2명이내 제한 / 참가가능 종목수 체크)
			SQL = "select teamLimit,attgameCnt from SD_gameTitle where gametitleidx = " & l_tidx & "  " ' YN 참가가능종목수
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)	
			
			teamLimit = rs(0)
			attgameCnt = rs(1)

			'신청종목 등록여부
			SQL = "select GameTitleIDX from tblGameRequest where gametitleidx = '"&l_tidx&"' and levelno = '"&l_levelno&"' and P1_PlayerIDX = '"&pidx&"' and delyn = 'N' "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			If Not rs.eof Then
				Call oJSONoutput.Set("result", 2)
				strjson = JSON.stringify(oJSONoutput)
				Response.Write strjson
				Response.end
			End if

			'팀당 2명이내 신청
			If teamLimit = "Y" then
				SQL = "select count(*) from tblGameRequest where gametitleidx = '"&l_tidx&"' and levelno = '"&l_levelno&"' and P1_Team = '"&l_Team&"' and delyn = 'N' "
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				If CDbl(rs(0)) > 2 Then
					Call oJSONoutput.Set("result", 3)
					strjson = JSON.stringify(oJSONoutput)
					Response.Write strjson
					Response.end
				End If
			End if

			'개인당 참가 신청 종목수 제한
			SQL = "select count(*) from tblGameRequest where gametitleidx = '"&l_tidx&"'  and P1_PlayerIDX = '"&pidx&"' and delyn = 'N' "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			If CDbl(rs(0)) > CDbl(attgameCnt) Then
				Call oJSONoutput.Set("result", 4)
				strjson = JSON.stringify(oJSONoutput)
				Response.Write strjson
				Response.end
			End if			



		'단계 3 최종 저장 (엘리트로 생성된다. 팀이 아마추어인지 찾아야한다.)
			infld = " GameTitleIDX,gbIDX,levelno,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,     P1_MIDX,P1_PlayerIDX,P1_UserName,P1_UserClass,P1_Team,P1_TeamNm,P1_Birthday,P1_SEX  , P1_ksportsno , entertype " 'kskey
			inval = " '"&l_tidx&"','"&l_gbidx&"','"&l_levelno&"','"&l_CDA&"','"&l_CDANM&"','"&l_CDB&"','"&l_CDBNM&"','"&l_CDC&"','"&l_CDCNM&"',     '"&l_MemberIDX&"','"&pidx&"','"&l_UserName&"','"&l_userClass&"','"&l_Team&"','"&l_TeamNm&"','"&l_Birthday&"','"&l_Sex&"'  ,'"&l_ksportsno&"' ,'"&l_EnterType&"' "

			SQL = "SET NOCOUNT ON  INSERT INTO tblGameRequest ( "&infld&" ) VALUES ("&inval&")  SELECT @@IDENTITY " 
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			reqidx = rs(0) '참가신청 인덱스

			'sd_gameMember 에도 넣어야지 않을가
			infld = " midx,GameTitleIDX,PlayerIDX,userName,gbIDX,levelno,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,Team,TeamNm,userClass,Sex,requestIDX,sidonm,ksportsno ,gubun "
			inval = " '"&l_MemberIDX&"','"&l_tidx&"','"&pidx&"','"&l_UserName&"','"&l_gbidx&"','"&l_levelno&"','"&l_CDA&"','"&l_CDANM&"','"&l_CDB&"','"&l_CDBNM&"','"&l_CDC&"','"&l_CDCNM&"','"&l_Team&"','"&l_TeamNm&"','"&l_userClass&"','"&l_Sex&"','"&reqidx&"', '"&l_sidonm&"' , '"&l_ksportsno&"' , 1"

			SQL = "INSERT INTO sd_gameMember ( "&infld&" ) VALUES ("&inval&")" 
			Call db.execSQLRs(SQL , null, ConStr)



		Call oJSONoutput.Set("result", 0 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson

  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>