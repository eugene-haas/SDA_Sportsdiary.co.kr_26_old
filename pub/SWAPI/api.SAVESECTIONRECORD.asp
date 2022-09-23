<%
'#############################################
'구간 기록 저장하기
'#############################################
	'개인전
	' {"CMD":540,
	' "LIST":[
	' {"MIDX":"63501A","SECTIONNO":50, "SECTIONRESULT":"001111","GAMERESULT":"003399"},
	' {"MIDX":"63497A","SECTIONNO":50, "SECTIONRESULT":"001111","GAMERESULT":"003399"},
	' {"MIDX":"63493A","SECTIONNO":50, "SECTIONRESULT":"001111","GAMERESULT":"003399"},
	' {"MIDX":"63489A","SECTIONNO":50, "SECTIONRESULT":"001111","GAMERESULT":"003399"},
	' {"MIDX":"63491A","SECTIONNO":50, "SECTIONRESULT":"001111","GAMERESULT":"003399"},
	' {"MIDX":"63495A","SECTIONNO":50, "SECTIONRESULT":"001111","GAMERESULT":"003399"},
	' {"MIDX":"63499A","SECTIONNO":50, "SECTIONRESULT":"001111","GAMERESULT":"003399"},
	' {"MIDX":"63503A","SECTIONNO":50, "SECTIONRESULT":"001111","GAMERESULT":"003399"}
	' ]}

	'단체전
	'{""MIDX"":""64296_17862A"",""SECTIONNO"":50, ""SECTIONRESULT"001111",""GAMERESULT"":""003399""}
	'키, 키_키A or P 오전, 오후,  '출전순서 (단체전인경우 사용 기본 1 ), 현재까지기록 6자리 숫자 문자열, 구간이름, 현구간까지 기록 6자리 숫자 문자열

	'64296_17862A
	'단체키 gameMemberIDX
	'선수키 partnerIDX

	'request
	If hasown(oJSONoutput, "LIST") = "ok" Then
		Set list = oJSONoutput.get("LIST")

		chkval = list.Get(0).MIDX
		sectionno = list.Get(0).SECTIONNO '구간 번호 50M section50 필드 사용

		If InStr(chkval, "_") > 0 Then '-----------------------------단체 (계영)
			ITgubun = "T"
		Else 						   '-----------------------------개인
			ITgubun = "I"
		End if

		ampm = Right(chkval,1) '저장될 위치 tryoutresult or gameresult ( AM, PM ) A, B
		If ampm = "A" Then
			ampmval = "AM"
		else
			ampmval = "PM"
		end if


	Else
		Call oJSONoutput.Set("result", 22 ) '전달값이 없음
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End If

	'###########################################
	'테스트 상태저장되지 않도록
	'###########################################
		If hasown(oJSONoutput, "MODE") = "ok" Then
			 mode = oJSONoutput.MODE
		End If
		
		If mode = "test" Then
			response.write "{""CMD"": ""540"",""result"":0}"
			Response.end
		End if
	'###########################################

	Set db = new clsDBHelper

			'#저장문자열생성####
			Function rcSaveSction(midx, ampmval,sectionno,sectionrt)
				Dim SQL,sectionfld,resultfld
				sectionfld = "section" & sectionno
				resultfld = "r" & sectionno
				SQL = ""
				SQL = SQL & "If EXISTS(select idx from sd_gameMember_sectionRecord where gamememberidx = '"&midx&"' and AMPM = '"&ampmval&"') "

				If sectionno = "50" then 
				SQL = SQL & " Update sd_gameMember_sectionRecord Set  sectionno= '"&sectionno&"',"&sectionfld&" ='"&sectionrt&"',"&resultfld&"='"&sectionrt&"'  where  gamememberidx = '"&midx&"' and AMPM = '"&ampmval&"' "
				SQL = SQL & "Else"
				SQL = SQL & " Insert into sd_gameMember_sectionRecord ( gamememberidx,sectionno, AMPM,"&sectionfld&","&resultfld&" ) values ("&midx&",'"&sectionno&"','"&ampmval&"','"&sectionrt&"','"&sectionrt&"')"
				Else

				SQL = SQL & " Update sd_gameMember_sectionRecord Set  sectionno= '"&sectionno&"',"&resultfld&"='"&sectionrt&"'  where  gamememberidx = '"&midx&"' and AMPM = '"&ampmval&"' "
				SQL = SQL & "Else"
				SQL = SQL & " Insert into sd_gameMember_sectionRecord ( gamememberidx,sectionno, AMPM,"&resultfld&" ) values ("&midx&",'"&sectionno&"','"&ampmval&"','"&sectionrt&"')"
				End if
				rcSaveSction = SQL
			End Function
			'#저장문자열생성####

			Function getRC(endrc, dbrc)
				Dim rc, p_min,p_sec,p_msec,c_min,c_sec,c_msec
				Dim p_total,c_total,d_total
				Dim d_min,d_sec,d_msec

				If Len(endrc) <> 6 Or Len(dbrc) <> 6 Then
					getRC = "000000"
				else

					p_min = Left(dbrc, 2)
					p_sec = mid(dbrc, 3, 2)
					p_msec = right(dbrc, 2)
'Response.write 	p_min&"__"&p_sec&"__"&p_msec & "<br>"
					c_min = Left(endrc, 2)
					c_sec = mid(endrc, 3, 2)
					c_msec = right(endrc, 2)
'Response.write  c_min&"__"&c_sec&"__"&c_msec & "<br>"


					 c_total = (CDbl(c_min) * 60 * 1000 ) + (CDbl(c_sec) * 1000) + CDbl(c_msec * 10)
					 p_total = (CDbl(p_min) * 60 * 1000 ) + (CDbl(p_sec) * 1000) + CDbl(p_msec * 10) 
					 d_total =  CDbl(c_total) - CDbl(p_total)

'Response.write  p_total&"__"&c_total&"__"&d_total & "<br>"

					 d_min = Fix(Cdbl(d_total) / ( 60 * 1000))
					 d_sec =  Fix((CDbl(d_total) / 1000 ))
					 d_msec =   Fix((CDbl(d_total) Mod 1000) / 10)

'Response.write  d_min&"__"&d_sec&"__"&d_msec &"__"&addZero(d_min) & addZero(d_sec) & addZero(d_msec) & "<br>"

					getRC =  addZero(d_min) & addZero(d_sec) & addZero(d_msec)

				End if
			End Function

			Function rcUpdateQuery(midx, ampmval, sectionno, rc)
				Dim SQL
				SQL = " Update sd_gameMember_sectionRecord Set  section"&sectionno&"='"&rc&"'  where  gamememberidx = '"&midx&"' and AMPM = '"&ampmval&"' "
				rcUpdateQuery = SQL
			End Function





			'1 뒤 진행값을 먼저 넣고
			SQL = ""
			For intloop = 0 To oJSONoutput.LIST.length-1
				midx = list.Get(intloop).MIDX
				gamert = list.Get(intloop).GAMERESULT '현재까지기록 6자리 숫자 문자열 (오류 문자열이 올수도 있다)
				sectionrt = list.Get(intloop).SECTIONRESULT '구간기록 6자리

				Select Case ITgubun
				Case "I"  '개인----------------------------------------------------------
					midx = left(midx, Len(midx)-1)
					'insert update
					SQL = SQL & rcSaveSction(midx, ampmval,sectionno,sectionrt)
				Case "T" '단체------------------------------------------------------------
					marr = Split(midx,"_")
					midx = marr(0) '단체키
					ptnidx = left(marr(1), Len(marr(1))-1) '선수키

					SQL = SQL & rcSaveSction(midx, ampmval,sectionno,sectionrt)
				End Select

				If intloop = 0 Then
					inmidx = midx 
				Else
					inmidx = inmidx & "," & midx 
				End if

			
			Next
			Call db.execSQLRs(SQL , null, ConStr)

			
			If sectionno = "50" then 
				'끝
			Else
				'2 이전필드의 값을 가져온다.
				SQL = "select gamememberidx, r" & CDbl(sectionno) - 50 & " from sd_gameMember_sectionRecord where gamememberidx in ("&inmidx&") and AMPM = '"&ampmval&"' "
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				If Not rs.EOF Then
					arrR = rs.GetRows()
				End If


				SQL = ""
				If IsArray(arrR) Then
					For ari = LBound(arrR, 2) To UBound(arrR, 2)
						midx =  arrR(0,ari)
						dbrc  = arrR(1,ari)

						For intloop = 0 To oJSONoutput.LIST.length-1
							reqmidx = list.Get(intloop).MIDX
							'gamert = list.Get(intloop).GAMERESULT '현재까지기록 6자리 숫자 문자열 (오류 문자열이 올수도 있다) 쓰레기값 보낸다 사용하지 말자.
							endrc = list.Get(intloop).SECTIONRESULT '구간기록 6자리 (현재까지기록)

							Select Case ITgubun
							Case "I"  '개인----------------------------------------------------------
								reqmidx = left(reqmidx, Len(reqmidx)-1)
							Case "T" '단체------------------------------------------------------------
								marr = Split(reqmidx,"_")
								reqmidx = marr(0) '단체키
							End Select

							If CStr(midx) = CStr(reqmidx) Then
								'구간기록을 구한다.

								'Response.write endrc & "__" & dbrc & "<br>"

								rc = getRC(endrc, dbrc)
'								Response.write rc & "<br>"
								'쿼리를 만든다.
								SQL = SQL & rcUpdateQuery(midx, ampmval,sectionno,rc)
							End if
						Next 

					Next
				End If

				Call db.execSQLRs(SQL , null, ConStr)



			End if


	'#########################################################################################################
	response.write "{""CMD"": ""540"",""result"":0}"



	Set rs = Nothing
	db.Dispose
	Set db = Nothing


%>
