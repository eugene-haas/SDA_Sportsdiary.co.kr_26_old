<%
'#############################################
'기록 저장하기
'#############################################

	'request
	If hasown(oJSONoutput, "LIST") = "ok" Then
		Set list = oJSONoutput.LIST

		chkval = list.Get(0).MIDX
		If InStr(chkval, "_") > 0 Then
			'Response.write "단체 (계영)"
			ITgubun = "T"
			chkmarr = Split(chkval,"_")
			chkmidx = chkmarr(0)
		Else
			'개인
			'Response.write "개인"
			ITgubun = "I"
			chkmidx = left(chkval, Len(chkval)-1)
		End if


		Set db = new clsDBHelper
		SQL = "select top 1 starttype,sex from sd_gameMember where delyn = 'N' and gameMemberIDX =  '"&chkmidx&"' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If Not rs.eof Then
			starttype = rs(0)
			sexno = rs(1) '한국신기록 구분해야함 남여
		Else
			starttype = 1
			sexno = 1
		End If

		savefld = Right(chkval,1) '저장될 위치 tryoutresult or gameresult
		If starttype = "3" Then
			savefld = "A"
		End if



		If savefld = "A" Then
			sfld = " tryoutResult "
			
			gnofld = "tryoutgroupno"
			orderfld = "tryoutOrder"
			sfldptn = " gameresultA " 'A AM값 계영 순서대로 넣을값

			firstfld = "G1FirstRC"  '(예선/본선) as a 첫주자기록 (단체)
			ksinfld = "G1korSin"	'한국신기록필드명
			gamesinfld = "G1gameSin" '대회신기록 필드명
			firstsinfld = "G1firstmemberSin" '첫주자신기록
			preksinfld = "G1korSinPre"
			pregamesinfld = "G1gameSinPre"

			kortiefld = "G1kortie" '한국타이
			gametiefld = "G1gametie"

		Else
			'starttype = 3 이라면 tryoutResult
			sfld = " gameResult "

			gnofld = "roundno"
			orderfld = "gameOrder"
			sfldptn = " gameresultB " 'B PM값 계영 순서대로 넣을값

			firstfld = "G2FirstRC"
			ksinfld = "G2KorSin"
			gamesinfld = "G2gameSin"
			firstsinfld = "G2firstmemberSin"
			preksinfld = "G2korSinPre"
			pregamesinfld = "G2gameSinPre"

			kortiefld = "G2kortie" '한국타이
			gametiefld = "G2gametie"
		End if
	End If

	If hasown(oJSONoutput, "MODE") = "ok" Then
		 mode = oJSONoutput.MODE
	End if









			'###################
			Function rcSum(val1, val2)
				Dim m1,m2,s1,s2,mi1,mi2, mm,ss,mic
				m1 = Left(val1,2)
				m2 = Left(val2,2)
				s1 = Mid(val1,3,2)
				s2 = Mid(val2,3,2)
				mi1 = Right(val1,2)
				mi2 = Right(val2,2)

				mm = addZero(CDbl(m1) + CDbl(m2))
				ss = addZero(CDbl(s1) + CDbl(s2))
				mic = addZero(CDbl(mi1) + CDbl(mi2))

				rcSum = mm & ss & mic
			End Function
			'###################


			'한국기록, 대회기록 비교S
				Function checkSin(cdc,titlecode,levelno,itgubun,sexno)
					Dim SQL,rs,korsin,strWhere,gamesin,FirstSin
					Dim codepre 
					codepre = LCase(Left(titlecode,2)) '대회 코드
					'한국신기록

					'외국인번호
					If sexno = "5" Or sexno = "7" Then
						sexno = 1
					End If
					If sexno = "6" Or sexno = "8" Then
						sexno = 2
					End If
					
					strWhere = " delyn = 'N' and rctype = 'R07' and CDA = 'D2' and CDC = '"&CDC&"' and gameResult > 0 and sex = '"&sexno&"' and gameResult < 'a' "
					SQL = "Select min(gameResult) from tblrecord where " & strWhere
					Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
					korsin = rs(0) 'null 또는 값


					If codepre = "nr" Then '대회신기록 체크 페스 
						'패스
						gamesin = "0"
					else
						'대회신기록
						strWhere = " titlecode = '"&titlecode&"' and  levelno = '"&levelno&"'  and delyn = 'N'   and gameResult > 0 and sex = '"&sexno&"'   and gameResult < 'a' "
						SQL = "select min(gameresult) from tblrecord where "&strWhere
						Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
						gamesin = rs(0) 'null 또는 값
					End If
					

					If itgubun = "T" then
						'첫주자기록 조회 (단체 - 계영)
						strWhere = " titlecode = '"&titlecode&"' and  levelno = '"&levelno&"'  and delyn = 'N'  and sex = '"&sexno&"'   and firstRC > 0  "
						SQL = "select min(firstRC) from tblrecord where "&strWhere
						Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
						FirstSin = rs(0)
					End if

					checkSin = array(korsin,gamesin,FirstSin)
				End Function
			'한국기록, 대회기록 비교E







			SQL = ""
			For intloop = 0 To oJSONoutput.LIST.length-1
				midx = list.Get(intloop).MIDX
				joo = list.Get(intloop).JOO '조
				rane = list.Get(intloop).RANE '레인
				odrno = list.Get(intloop).ODRNO  '출전순서 (단체전인경우 사용 기본 1 )
				gamert = list.Get(intloop).GAMERESULT '기록 6자리 숫자 문자열 (오류 문자열이 올수도 있다)

				'값초기화
				newkorsin = ""
				KorSinPre = ""
				kortie = ""

				newgamesin =  ""
				GameSinPre = ""
				gametie = ""
				'값초기화

				Select Case ITgubun

				'Case "I"  '개인--------------
				'	midx = left(midx, Len(midx)-1)
				Case "I",  "T" '개인--------------

					if ITgubun  = "I" Then
						midx = left(midx, Len(midx)-1)
					else
						marr = Split(midx,"_")
						midx = marr(0)
					end if


					If intloop = 0 then
						SQLINFO = "select top 1 a.gametitleidx, a.gbidx,a.cdc,b.titlecode,a.levelno from sd_gameMember as a inner join sd_gametitle as b on a.gametitleidx = b.gametitleidx and a.delyn='N' and b.delyn='N' where a.gameMemberIDX =  '"&midx&"' "
						Set rs = db.ExecSQLReturnRS(SQLINFO , null, ConStr)
						tidx = rs(0)
						gbidx = rs(1)
						cdc = rs(2)
						titlecode = rs(3)
						levelno = rs(4)

						chkvalarr = checkSin(cdc,titlecode,levelno,"I",sexno)
						korsin = isNulldefault(chkvalarr(0), "0")
						gamesin = isNulldefault(chkvalarr(1), "0")
					End if


					KorSinPre = ""
					GameSinPre = ""

					If korsin  = "0" then
						newkorsin =  gamert
					Else
						If isNumeric(gamert) = True Then
							If CDbl(gamert) > 0 And CDbl(gamert) < CDbl(korsin) Then
								newkorsin = gamert
								KorSinPre = korsin
								kortie = ""
							ElseIf CDbl(gamert) > 0 And  CDbl(gamert) = CDbl(korsin) Then
								newkorsin = ""
								kortie = korsin		'타이기록
							Else
								newkorsin = ""
								kortie = ""
							End if
						Else
							'오류코드
							newkorsin = ""
						End if
					End If


					If gamesin  = "0" then
						newgamesin =  gamert


					Else
						If isNumeric(gamert) = True Then
							If CDbl(gamert) > 0 And  CDbl(gamert) < CDbl(gamesin) Then
								newgamesin =  gamert
								GameSinPre = gamesin
								gametie = ""
							ElseIf CDbl(gamert) > 0 And  CDbl(gamert) = CDbl(gamesin) Then
								newgamesin = ""
								gametie = gamesin
							else
								newgamesin = ""
								gametie = ""
							End if
						Else
							'오류코드
							newgamesin = ""
						End if
					End if

					'G1firstRC				'(예선/본선) as a 첫주자기록 (단체)
					'G2firstRC				'(본선) as b 첫주자기록 (단체)

					'G1korSin				'a 한국신기록
					'G1gameSin				'a 대회신기록
					'G1firstmemberSin		'a 첫주자신기록(단체)

					'G2KorSin				'b 한국신기록
					'G2gameSin				'b 대회신기록
					'G2firstmemberSin		'b 첫주자신기록 (단체)

					'타이수정
					sinupdate = " ,"&preksinfld&" = '"&KorSinPre&"',"&ksinfld&" = '"&newKorSin&"' ,"&pregamesinfld&" = '"&GameSinPre&"' ,"&gamesinfld&" = '"&newGameSin&"'    ,"&kortiefld&" = '"&kortie&"' ,"&gametiefld&" = '"&gametie&"' "
					SQL = SQL & " UPDATE sd_gameMember  SET "&sfld&" = '"&gamert&"' "&sinupdate&" where gameMemberIDX =  '"&midx&"' " & "<br>"



				End Select

			Next
		
			'Call db.execSQLRs(SQL , null, ConStr)


	'Response.write sql & "<br><br>"
	'#########################################################################################################



	'(경기번호) 부별 순위 산정
		SQL = ""
		If savefld = "A"  Then
			wherestr = " and gametitleidx =  '"&tidx&"' and gbidx = '"&gbidx&"'  and "&sfld&" > 0  and tryoutresult < 'a'  " '업데이트 대상
			Selecttbl = "( SELECT tryouttotalorder, RANK() OVER (Order By tryoutresult asc) AS RowNum FROM SD_gameMember where DelYN = 'N' "&wherestr&" ) AS A "
			SQL = "UPDATE A  SET A.tryouttotalorder = A.RowNum FROM " & selecttbl
		End if

		'조순위 산정 (보내온 조 업데이트  gnofld)
			wherestr = " and gametitleidx =  '"&tidx&"' and gbidx = '"&gbidx&"' and "&gnofld&" = "& joo &" and "&sfld&" > 0 and "&sfld&" < 'a'  " '업데이트 대상
			Selecttbl = "( SELECT "&orderfld&",RANK() OVER (Order By "&sfld&" asc) AS RowNum FROM SD_gameMember where DelYN = 'N' "&wherestr&" ) AS A "
			SQL = SQL & " UPDATE A  SET A."&orderfld&" = A.RowNum FROM " & selecttbl
'		Call db.execSQLRs(SQL , null, ConStr)


	response.write "{""CMD"": ""530"",""result"":0}"


	Set rs = Nothing
	db.Dispose
	Set db = Nothing


%>
