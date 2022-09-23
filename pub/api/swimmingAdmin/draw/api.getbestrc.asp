<%
'#############################################
'최고기록 찾기
'#############################################
	
	'request
	If hasown(oJSONoutput, "TIDX") = "ok" Then '대상
		tidx = oJSONoutput.TIDX
	End If
	If hasown(oJSONoutput, "GBIDX") = "ok" Then '대상
		gbidx = oJSONoutput.GBIDX
	End if	

	If hasown(oJSONoutput, "CDC") = "ok" Then '종목코드
		cdc = oJSONoutput.CDC
	End if	

	If hasown(oJSONoutput, "CHKLIDX") = "ok" Then '선택된 것들.
		Set tidxs = oJSONoutput.CHKLIDX

		For i = 0 To oJSONoutput.CHKLIDX.length-1
				If i = 0 Then 
					chk_tidx = tidxs.Get(i)
				Else
					chk_tidx = chk_tidx & "," & tidxs.Get(i)
				End if
		Next
		
		If chk_tidx <> "" Then
			tidxwhere = " and (		gametitleidx in ( "&chk_tidx&" ) or (gametitleidx is null and gamedate > '"&DateAdd("m", -12, Date)& "')		) " '게임타이틀이 없는건 지금부터 일년전까지만
		End if
	End if	

	'gamecode 구하기

	Set db = new clsDBHelper 

		'생성할려는 대회의 정보(기본정보)
			SQL = "Select titlecode,b.levelno,b.pteamgb as CDA,b.cd_boo as CDB,b.teamgb as CDC,b.sexno,b.teamgbnm as CDCNM  from sd_gametitle as a ,tblTeamGbInfo as b  where a.delyn = 'N' and b.delyn = 'N' and gametitleidx = "&tidx&" and teamgbidx = "&gbidx&" "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			titlecode = rs(0)
			levelno = rs(1) '음 전대회에서는 초중고가 다를수도 있으므로 cdc로 구분하자.
			cda = rs(2)
			cdb = rs(3)
			cdc = rs(4)
			sex = rs(5)
			cdcnm = rs(6)
			If tidxwhere = "" Then
				tidxwhere = " and gamedate > '"&DateAdd("m", -12, Date)&"' "
			End if

		'1. 적용할 대상의 선수들 기록 초기회 (재설정인 경우 기존값 삭제)
		' 기록은 6자리로 표기 00:00.00 분 초 밀리초
			SQL = "update sd_gameMember set bestscore = '',bestCDBNM='',bestIDX='',bestdate='',bestarea='',bestTitle='',bestgamecode='',bestorder=0  where gametitleidx = '"&tidx&"' and gbidx = '"&gbidx&"' "
			Call db.execSQLRs(SQL , null, ConStr)


		'2. 대상 기록 찾기 (검색조건 범위에서 최고 기록들 가져오기)
			'랜덤 발생 하자 우선 (임시)
				'Function rndRc(rng)
				'   Randomize
				'   rndRC = Int(Rnd() * rng) + 0 '99뿐까지 
				'End Function 
				'pidx 'besttime = rndRc(9)&rndRc(9) &":"& rndRc(5) & rndRc(9) &"."& rndRc(9)&rndRc(9)		'두개를 구한 배열이 있겠지요 cdbnm 도 넣어주자...(구분출력한다) 그리고 받아온 인덱스도 넣어주고.그렇게 4개 넣자..
			'####################################################

			' tblrecord 필드명 참조 rcIDX,gametitleidx,titleCode,titlename,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,kskey,ksportsno,playerIDX,UserName,Birthday,Sex,nation,sidoCode,sido,gameDate,EnterType,Team,TeamNm,userClass,rctype,gamearea,gameResult,gameOrder,rane,DelYN,gubun,kskey2,kskey3,kskey4,playerIDX2,UserName2,playerIDX3,UserName3,playerIDX4,UserName4,levelno "

		If InStr(CDCNM,"계영") Then

			fld = " team,gameResult,cdbnm,rcIDX,left(gamedate,10),gamearea,titlename,titleCode "
			strWhere = " cda = '"&cda&"' and cdc = '"&cdc&"'  and delyn = 'N' and gameResult > 0 and gameResult < 'a'  " & tidxwhere   

			SQL = "Select "&fld&" from tblrecord where "&strWhere&" and "
			SQL = SQL & " gameresult in ( select min(gameresult) from tblrecord where "&strWhere&" group by team)  " '팀에 가산점을 주자(내생각) 
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		else
			fld = " isnull(playeridx,0),gameResult,cdbnm,rcIDX,left(gamedate,10),gamearea,titlename,titleCode "
			strWhere = " cda = '"&cda&"' and cdc = '"&cdc&"'  and delyn = 'N' and gameResult > 0 and gameResult < 'a'  " & tidxwhere   

			SQL = "Select "&fld&" from tblrecord where "&strWhere&" and "
			SQL = SQL & " gameresult in ( select min(gameresult) from tblrecord where "&strWhere&" group by kskey)  "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		End if

			If Not rs.eof Then
				arrRC = rs.GetRows()		
			End if

			'Call GetRowsDrow(arrRC)
			'Response.end


		'3. 대상 기록 업데이트 , 기록 순위 생성
			SQL = "select gameMemberIDX,playeridx,team from sd_gameMember where delyn = 'N' and gubun in (0,1) and  gametitleidx = '"&tidx&"' and gbidx = '"&gbidx&"' " '0 추가된 선수, 1 기록 저장된 예선 선수
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

'Response.write sql
'Response.end

			If Not rs.EOF Then
				arrR = rs.GetRows()
			Else
				'선수가 없다고
				Call oJSONoutput.Set("result", 1)
				strjson = JSON.stringify(oJSONoutput)
				Response.Write strjson
				Response.end
			End If



			'Call GetRowsDrow(arrR)
			'Response.write UBound(arrR,2)
'			Response.write sql
'			Response.end

			'갯수가 8개가 안되면 구분값이 본선으로 가야한다.고

			SQL = ""
			If IsArray(arrR) Then 
				For ari = LBound(arrR, 2) To UBound(arrR, 2)
					l_midx = arrR(0, ari)
					
					
					If InStr(CDCNM,"계영") Then
						l_team = arrR(1, ari)

						If IsArray(arrRC) Then 
						For x = LBound(arrRC, 2) To UBound(arrRC, 2)
							'Response.write l_team & " " & arrRC(0, x)& "<br>"
							If Cstr(l_team) = Cstr(arrRC(0, x)) then
								SQL = SQL &  " update SD_gameMember set gubun =1 , bestscore = '"& arrRC(1,x) &"',bestCDBNM='"&arrRC(2,x)&"',bestIDX='"&arrRC(3,x)&"',bestdate='"&arrRC(4,x)&"',bestarea='"&arrRC(5,x)&"',bestTitle='"&arrRC(6,x)&"',bestgamecode='"&arrRC(7,x)&"'    where gamememberidx = '"&l_midx&"' "
							exit for
							End if
						Next
						End if					
					
					
					else
						l_pidx = arrR(1, ari)

						If IsArray(arrRC) Then 
						For x = LBound(arrRC, 2) To UBound(arrRC, 2)
							'Response.write l_pidx & " " & arrRC(0, x)& "<br>"
							If CDbl(l_pidx) = CDbl(arrRC(0, x)) then
								SQL = SQL &  " update SD_gameMember set gubun =1 , bestscore = '"& arrRC(1,x) &"',bestCDBNM='"&arrRC(2,x)&"',bestIDX='"&arrRC(3,x)&"',bestdate='"&arrRC(4,x)&"',bestarea='"&arrRC(5,x)&"',bestTitle='"&arrRC(6,x)&"',bestgamecode='"&arrRC(7,x)&"'    where gamememberidx = '"&l_midx&"' "
							exit for
							End if
						Next
						End if					
					
					
					End if

	

				
				Next
			End if

			'Response.write sql & "--"
			'Response.end
			If SQL <> "" then			
				Call db.execSQLRs(SQL , null, ConStr)
			End if

			SQL = "Update SD_gameMember Set gubun = 1 where gametitleidx = " & tidx & " and gbidx = " & gbidx
			Call db.execSQLRs(SQL , null, ConStr)


			SQL = "UPDATE A  SET A.bestOrder = A.RowNum FROM ( Select bestOrder , RANK() OVER (Order By bestscore asc) AS RowNum from SD_gameMember where delyn='N' and gubun in (0,1) and gametitleidx = '"&tidx&"' and gbidx = '"&gbidx&"'  and bestscore != '' ) AS A "
			Call db.execSQLRs(SQL , null, ConStr)

			SQL = " UPDATE SD_gameMember Set bestOrder = 99 where  delyn='N' and gubun in (0,1) and gametitleidx = '"&tidx&"' and gbidx = '"&gbidx&"'  and bestscore = '' " 
			Call db.execSQLRs(SQL , null, ConStr)

			'SQL = "select * from SD_gameMember where gametitleidx = '"&tidx&"' and gbidx = '"&gbidx&"'  "	
			'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			'Call rsdrow(rs)
		

			Call oJSONoutput.Set("result", 0 )
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson

  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>