<%
'#############################################
'선택한 쉬트의 내용을 표시해준다.
'#############################################
'request
tidx = oJSONoutput.FSTR 
fstr2 = oJSONoutput.FSTR2

dcnt = oJSONoutput.ATTCNT				'드로우 96
scnt = oJSONoutput.SEED					'6
jcnt = oJSONoutput.JONO					'조수 32
boxorder = oJSONoutput.BOXORDER		'1,6,3,4,2,5 박스배치순서
boxcnt = Fix(dcnt / 16) 'seed * 2 '최종 생성되는 박스수 6개박스



If hasown(oJSONoutput, "ST1") = "ok" then	 '입금일짜
	st1 = oJSONoutput.ST1
	bye = oJSONoutput.BYE
	
	sudong = true
Else
	sudong = false
End If


If hasown(oJSONoutput, "ST1V") = "ok" then	 '입금일짜
	st1v = oJSONoutput.ST1V
	byev = oJSONoutput.BYEV
	
	saveok = true
Else
	saveok = false
End If

Set db = new clsDBHelper

'저장된 정보확인
jooidx = CStr(tidx) & CStr(Split(fstr2,",")(0))
loadok = false

If saveok = False Then
	SQL = "Select top 1 saveinfo,attcnt,seedcnt,jonocnt,boxorder from sd_TennisKATARullMake where mxjoono =  " & jooidx & " and sortno = 1 "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof Then

		If isnull(rs(0)) = False then
			saveinfo = Split(rs(0),",")
			v1 = rs(1)
			v2 = rs(2)
			v3 = rs(3)
			v4 = rs(4)
			If CStr(v1) = CStr(dcnt) And CStr(v2) = CStr(scnt) And CStr(v3) = CStr(jcnt) And CStr(v4) =  CStr(boxorder) then
				If st1 = "" then
					st1 = Split(saveinfo(0), ":")
					bye = Split(saveinfo(1), ":")
					st1v = Split(saveinfo(2), ":")
					byev = Split(saveinfo(3), ":")

					loadok = True

					ReDim box81STtarr(ubound(st1)+1)
					ReDim box8BYEarr(ubound(bye)+1) 

					For i = 0 To ubound(st1)
							box81STtarr(i+1) = st1(i)
							box8BYEarr(i+1) = bye(i)
					Next
					
					Set dicrull2 =Server.CreateObject("Scripting.Dictionary")
					For i = 0 To ubound(st1v)
						dicrull2.ADD "LOAD_" & CDbl(i+1), st1v(i) &"_"& byev(i)
					Next
				End if
			End If 
		End if
	End if

End if

'저장#############
If saveok = True Then

		'본선에 3라운드 선수가 있다면 bye 진출 선수가 있을수 있으므로
		SQL = "Select top 1 gameMemberIDX from sd_TennisMember where GameTitleIDX =  "&tidx&"  and gamekey3 = " & Split(fstr2,",")(0) & " and round = 3 "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.eof Then
			Call oJSONoutput.Set("result", "12346" ) '진행경기가 있어 수정불가
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
		End if
		
		'결과가 생성 되었다면 수정 불가.
		SQL = "Select top 1 idx from sd_TennisRPoint_log where titleIDX =  "&tidx&"  and teamGb = " & Left(Split(fstr2,",")(0),5)
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.eof then
			Call oJSONoutput.Set("result", "12346" ) '진행경기가 있어 수정불가
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson

		db.Dispose
		Set db = Nothing
		Response.End
		End if


	'강수 라운드수 찾기#############
		if dcnt <=2 then
		drowCnt = 2
		depthCnt = 2
		elseif dcnt >2 and dcnt <=4 then
		drowCnt = 4
		depthCnt = 3
		elseif dcnt >4 and dcnt <=8 then
		drowCnt=8
		depthCnt = 4
		elseif dcnt >8 and  CDbl(dcnt) <=16 then
		drowCnt=16
		depthCnt = 5
		elseif dcnt >16 and  dcnt <=32 then
		drowCnt=32
		depthCnt = 6
		elseif dcnt >32 and  dcnt <=64 then
		drowCnt=64
		depthCnt = 7
		elseif dcnt >64 and  dcnt <=128 then
		drowCnt=128
		depthCnt = 8
		elseif dcnt >128 and  dcnt <=256 then
		drowCnt=256
		depthCnt = 9
		end if 
	'강수 라운드수 찾기#############

	saveinfo = st1 & "," & bye & "," & st1v & "," & byev 

	st1varr = Split(st1v,":")
	byevarr = Split(byev,":")


	'생성된거 삭제#####
		SQL = "delete from sd_TennisKATARullMake where mxjoono = '" & jooidx & "' "
		Call db.execSQLRs(SQL , null, ConStr)	
	'생성된거 삭제

	For i = 1 To CDbl(dcnt)
		arrno = i -1
		If i = 1 Then
			insertvalue = " (" & i &"," & st1varr(arrno) &"," & byevarr(arrno) &","& drowCnt &","& depthCnt &",'"& jooidx &"','0','"& dcnt &"','"& scnt &"','"& jcnt &"','"& boxorder &"', '"&saveinfo&"' )"
		else
			insertvalue = insertvalue & ", (" & i &"," & st1varr(arrno) &"," & byevarr(arrno) &","& drowCnt &","& depthCnt &",'"& jooidx &"','0','"& dcnt &"','"& scnt &"','"& jcnt &"','"& boxorder &"' , '' )"
		End if  
	next

	SQL = "INSERT INTO sd_TennisKATARullMake (sortno,orderno,joono,gang,round,mxjoono,seed,attcnt,seedcnt,jonocnt,boxorder, saveinfo) VALUES " & insertvalue
	Call db.execSQLRs(SQL , null, ConStr)	


	Call oJSONoutput.Set("result", "12345" ) '저장이 완료되었슴
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	db.Dispose
	Set db = Nothing
Response.End
End if
'저장#############



'##test
	'dcnt = 64
	'scnt = 8
	'jcnt = 23

	'dcnt  =96
	'scnt = 6
	'jcnt = 32

	'dcnt = 80
	'scnt = 5
	'jcnt = 32
'##test


'충족요건  8배수
	chkcnt = Fix(CDbl(dcnt / scnt ))
	If CDbl(chkcnt) mod 8 = 0 Then
	else
		'Response.write "조건에 충족하지 않음 다시 입력바람" '"저장후 편집하여 주십시오."
		'Response.end
	End if
'충족요건 




' 각 시드박스 배열 재배치 기본배열순서 (방식 바꿈 나눌때부터 돌려져 있다고 가정하고 하자)
If boxorder = "0" then
'배열 순서를 받는다 16개 한박스
Select Case boxcnt
Case 2 : boxorderarr = array(1,2)
Case 4 : boxorderarr = array(1,4,3,2)													'3,4,2,1 (홀수일때 1등남는자리 받는순서 ) 나누기 2 해서 왼쪽이 크다면....
Case 8  : boxorderarr = array(1,8,5,4,3,6,7,2)										'6,5,7,8,3,4,2,1)
Case 16 : boxorderarr = array(1,16,9,8 ,5,12,13,4   ,3,14,11,6 ,7,10,15,2)	'11,12,10,16,14,13,15,16,,6,5,7,8,3,4,2,1)
Case Else : boxorderarr = array(1,5,2,4,3)
End Select
Else
	boxorderarr = Split(boxorder,",")
End if	
' 각 시드박스 배열 재배치 기본배열순서

bcnt = CDbl(dcnt - (jcnt*2))   '총BYE갯수 = 총드로수 - 본선진출팀수 = 80-(조수x2팀) = 80-(32x2) = 16 

If loadok = False then
'**************************************************************
	boxdorwcnt = Fix(dcnt / scnt)	'박스별드로수
	boxcnt = Fix(dcnt / 16) '16drow box 갯수
		
		'#########################
		'function
		'#########################
			Function finddivno(ByVal dcnt)
				Dim i
				For i = 0 To 10
					If dcnt Mod 2 = 0 And dcnt > 2  then
						dcnt = dcnt / 2 
					Else
						finddivno = dcnt
					End if
				Next 
			End Function

			Function boxdiv(ByVal divno, ByVal jcnt)
				Dim box1starr,namergi, i
				Redim box1starr(divno) '첫번째 조나누기

				namergi =  jcnt Mod divno
				For i = 1 To ubound(box1starr)
					box1starr(i) = Fix(jcnt / divno)	
				Next

				For i = ubound(box1starr) To 1 Step -1
					If CDbl(namergi) > 0 Then
						box1starr(i) = box1starr(i) + 1
						namergi = namergi - 1
					End if
				Next
				boxdiv = box1starr
			End Function
			
			Function byeboxdiv(ByVal divno, ByVal jcnt)
				Dim namergi, i, l_byeboxarr
				Redim l_byeboxarr(divno) '첫번째 조나누기

				namergi =  jcnt Mod divno
				For i = 1 To ubound(l_byeboxarr)
					l_byeboxarr(i) = Fix(jcnt / divno)
					If CDbl(namergi) > 0 Then
						l_byeboxarr(i) = l_byeboxarr(i) + 1
						namergi = namergi - 1
					End if
				Next
				byeboxdiv = l_byeboxarr
			End Function

			Function nseung(ByVal dcnt) 	'분분 드로우 8드로우 까지 구하기
				Dim i
				For i = 1 To 10 
					If CDbl(dcnt) Mod 2 > 0 or  dcnt <  16  Then '8드로우 때까지만
						nseung = i
						Exit for
					Else
						dcnt = Fix(dcnt/2)

					End if
				next
			End function

			Function box2div(boxarr)
				Dim box1c, barr, n,c
				ReDim box1c(ubound(boxarr) * 2)
				c = 1
				For n = 1 To ubound(boxarr) 
					barr = boxdiv(2,boxarr(n))
					box1c(c) = barr(1)
					c= c + 1
					box1c(c) = barr(2)
					c= c + 1
				Next
				box2div = box1c
			End Function

			Function byebox2div(boxarr)
				Dim byec, barr, n,c
				ReDim byec(ubound(boxarr) * 2)
				c = 1
				For n = 1 To ubound(boxarr) 
					barr = byeboxdiv(2,boxarr(n))
					byec(c) = barr(1)
					c= c + 1
					byec(c) = barr(2)
					c= c + 1
				Next
				byebox2div = byec
			End function
		'#########################

	divno  = finddivno(dcnt)		  '처음 나누기 시갈할 갯수





	'시드박스당 1위팀수/바이수 배분###########
		order_1st = Fix(jcnt/boxcnt)
		order_1st_mod = Fix(jcnt Mod boxcnt)

		seedbyecnt = Fix(bcnt/boxcnt)
		seedbyecnt_mod = Fix(bcnt Mod boxcnt)

		ReDim box1stcnt(boxcnt)
		ReDim byecnt(boxcnt)
		ReDim copybox1stcnt(boxcnt)
		ReDim copybyecnt(boxcnt)

		For i = 1 To boxcnt
			box1stcnt(i) = order_1st
			byecnt(i) = seedbyecnt
			copybox1stcnt(i) = order_1st
			copybyecnt(i) = seedbyecnt
			If seedbyecnt_mod > 0 Then
				byecnt(i) = byecnt(i) + 1
				copybyecnt(i) = copybyecnt(i) + 1
				seedbyecnt_mod = seedbyecnt_mod - 1
			End if
		Next

		'bcnt 박스갯수가 짝수라면 16개드로박스갯수
		Select Case CDbl(boxcnt)
		Case 4
			'짝수 뒤에서 부터 배분
			st14arr = array(3,4,2,1) '4 ,2 3, 1 순으로 분배
			For i = 1 To boxcnt
				If order_1st_mod > 0 then
					box1stcnt(st14arr(i-1)) = box1stcnt(st14arr(i-1)) + 1
					copybox1stcnt(st14arr(i-1)) = copybox1stcnt(st14arr(i-1)) + 1
					order_1st_mod = order_1st_mod -1
				End If
			Next

		Case 8
			st14arr = array(6,5,7,8,3,4,2,1)
			For i = 1 To boxcnt
				If order_1st_mod > 0 then
					box1stcnt(st14arr(i-1)) = box1stcnt(st14arr(i-1)) + 1
					copybox1stcnt(st14arr(i-1)) = copybox1stcnt(st14arr(i-1)) + 1
					order_1st_mod = order_1st_mod -1
				End If
			Next
		Case Else
			For i = boxcnt To 1 Step -1
				If order_1st_mod > 0 then
					'짝수박스 뒤에서 부터 배분
					box1stcnt(i) = box1stcnt(i) + 1
					copybox1stcnt(i) = copybox1stcnt(i) + 1
					order_1st_mod = order_1st_mod -1
				End If
			Next		
		End select

		'		For i = boxcnt To 1 Step -1
		'			If order_1st_mod > 0 then
		'				box1stcnt(i) = box1stcnt(i) + 1
		'				copybox1stcnt(i) = copybox1stcnt(i) + 1
		'				order_1st_mod = order_1st_mod -1
		'			End If
		'		Next	
	'시드박스당 1위팀수/바이수 배분###########


	debugp = false
	'#######################################################################################
	If debugp = True then
		For i = 1 To ubound(box1stcnt)
		Response.write box1stcnt(i) & ","
		'Response.write byecnt(i) & ","
		Next
		Response.write  "<br>"
		For i = 1 To ubound(byecnt)
		'Response.write box1stcnt(i) & ","
		Response.write byecnt(i) & ","
		Next
		Response.write  "<br>"
		Response.write "###########<br>"
	'	Response.end
	End If
	'#######################################################################################

		'** 각박스별로 BYE수가 1위팀수를 초과하면 2위BYE가 발생한다.															
		'** 전체1위팀수보다 전체BYE수가 크지않은한 2위BYE가 발생하면 안된다.		
		'** 박스별로 (-)가 생긴경우 (+)가 발생한 차상위 박스로 BYE배분을 이전하여야 한다.
		'BYE 배분 적정성 검사  16드로에서 검사?
			byesplit = False '재분배 여부
			resplit = 0 '재분배해야할 바이값
			If CDbl(jcnt - bcnt) < 0  Then '바이가 더많음 2위 bye발생
				'이건 그냥 두면되고
			else
				ReDim chkbye(ubound(byecnt))

				For i = 1 To ubound(box1stcnt)
					chkbye(i)  = CDbl(box1stcnt(i) - byecnt(i))
					If chkbye(i) < 0 Then
						byecnt(i) = box1stcnt(i)
						resplit = CDbl(resplit +Abs(chkbye(i))) '재분배 해야할 바이값
						byesplit = true
					End if
				Next

				If byesplit = True Then 'bye 재분배
					For n = 1 To ubound(chkbye)
						If CDbl(chkbye(n)) > 0 And resplit > 0 Then '1이상인곳
							byecnt(n) = CDbl(byecnt(n)) + 1
							resplit = resplit - 1
						End If 
					next
				End if
			End if	
		'BYE 배분 적정성 검사 


		'박스 순서로 정렬 ☆☆☆☆☆ [중요 : 순서대로 적정성 검사후에 박스 순서를 맞추어 준다. 8드로우 에서는 짝수에 분배하도록 한다. 시드배분을 잘하자..]
		For n = 0 To ubound(boxorderarr)
			box1stcnt(n+1) = copybox1stcnt(boxorderarr(n))
			byecnt(n+1) = copybyecnt(boxorderarr(n))
		Next	

	debugp = false
	'#######################################################################################
	If debugp = True then
		For i = 1 To ubound(box1stcnt)
		Response.write box1stcnt(i) & ","
		'Response.write byecnt(i) & ","
		Next
		Response.write  "<br>"
		For i = 1 To ubound(byecnt)
		'Response.write box1stcnt(i) & ","
		Response.write byecnt(i) & ","
		Next
		Response.write  "<br>"
		Response.write "###########<br>"
	'	Response.end
	End If
	'#######################################################################################

		'8드로 박스 까지 분배
		If dcnt/8 = ubound(box1stcnt) Then
			ReDim box81STtarr(ubound(box1stcnt))
			ReDim box8BYEarr(ubound(byecnt))

			For i = 1 To ubound(box1stcnt)
				box81STtarr(i) = box1stcnt(i)
				box8BYEarr(i) = byecnt(i)
			next
		Else
			box81STtarr = box2div(box1stcnt)
			box8BYEarr = byebox2div(byecnt)
		End if

		If 	sudong = True Then '수동으로 갯수설정했을경우
			st1arr = Split(st1,":")
			byearr = Split(bye,":")
			
			For i = 1 To ubound(box1stcnt)
				box81STtarr(i) = st1arr(i-1)
				box8BYEarr(i) = byearr(i-1)				
			next
		End if


	debugp = false
	'#######################################################################################
	If debugp = True then
		For i = 1 To ubound(box1stcnt)
		Response.write box1stcnt(i) & ","
		'Response.write byecnt(i) & ","
		Next
		Response.write  "<br>"
		For i = 1 To ubound(byecnt)
		'Response.write box1stcnt(i) & ","
		Response.write byecnt(i) & ","
		Next
		Response.write  "<br>"
		Response.write "###########<br>"
		'Response.end
	End If
	'#######################################################################################


		'BYE 배분 적정성 검사 2처 8드로에서 검사
			byesplit = False '재분배 여부
			resplit = 0 '재분배해야할 바이값
			If CDbl(jcnt - bcnt) < 0  Then '바이가 더많음 2위 bye발생
				'이건 그냥 두면되고
			else
				ReDim chkbye(ubound(box8BYEarr))
				For i = 1 To ubound(box81STtarr)
					chkbye(i)  = CDbl(box81STtarr(i) - box8BYEarr(i))
					If chkbye(i) < 0 Then
						box8BYEarr(i) = box81STtarr(i)
						resplit = CDbl(resplit +Abs(chkbye(i))) '재분배 해야할 바이값
						byesplit = true
					End if
				Next

				If byesplit = True Then 'bye 재분배
					For n = 1 To ubound(chkbye)
						If n Mod 2 = 1 Then '짝수만 
						If CDbl(chkbye(n)) > 0 And resplit > 0 Then '1이상인곳
							box8BYEarr(n) = CDbl(box8BYEarr(n)) + 1
							resplit = resplit - 1
						End If 
						End if
					next
				End if
			End if	
		'BYE 배분 적정성 검사 2처 ###########

	debugp = false
	'#######################################################################################
	If debugp = True then
		For i = 1 To ubound(box81STtarr)
		Response.write i & ". " &  box81STtarr(i) & "<br>"
		Next
		Response.write "###################<br>"
		For i = 1 To ubound(box8BYEarr)
		Response.write i & ". " & box8BYEarr(i) & "<br>"
		next
		Response.End
	End if
	'#######################################################################################

	'1위배치우선순위 : 1-8-5-4-6-3-7-2						
	POS1STARR = array(1,8,5,4,3,6,7,2)
	'BYE배치 우선순위 : 2-7-6-3					
	POSBYEARR = array(2,7,6,3)
	POSBYEARR2 = array(2,7,3,6)

	'1등 자리 red '2등 자리 black'bye 자리 blue'빈자리 blank
	orderno = 100	'빈자리 ,1 1등자리 , 2 2등자리 0 bye자리
	Set dicrull =Server.CreateObject("Scripting.Dictionary")

	'/////////////////////////////////////////////////
	'시드 박스에 8개씩 담기
	sortno = 1
	putseed = scnt
	rnd1 = 1
	rnd2 = 1
	seednamergi = Fix(scnt - ubound(box81STtarr)/2)
	'brnd = Fix(ubound(box81STtarr)/2 + 1)
	brnd = Fix(boxcnt/2)


	For i = 1 To ubound(box81STtarr)  '8개씩 
		stcnt = box81STtarr(i)
		box8byecnt = box8BYEarr(i)

		For n = 1 To 8
			For pos = 1 To stcnt 'stcnt 갯수만큼 채움
				If POS1STARR(pos-1) = n  Then
					orderno = 1 '1st표시
					order1st = true
				Exit for			
				End if
			Next
			
			For pos = 1 To box8byecnt '바이자리 (1등갯수에 따라서)
				
				If CDbl(box8byecnt) >  CDbl(stcnt)  then
					If POSBYEARR2(pos-1) = n  Then
						orderno = 0 'bye표시
						order1st = true
					Exit for			
					End If
				Else
					If POSBYEARR(pos-1) = n  Then
						orderno = 0 'bye표시
						order1st = true
					Exit for			
					End If
				End if

				
			Next

			'시드주기배정 '홀수 번호 주고 남으면 짝수 주고. (박스순서로 배분하자.)
			If n = 1 And i Mod 2 = 1 Then '홀수 박스먼저 배분
				If CDbl(putseed) > 0 And CDbl(boxorderarr(rnd1-1)) <=CDbl(scnt)  Then
					seedrnd = boxorderarr(rnd1-1) 'rnd1
					putseed = putseed - 1
				End If
				rnd1 = rnd1 + 1

			ElseIf n = 1 And i Mod 2 = 0 then
				If CDbl(seednamergi) >= 0 then
					'seed  제일큰수부터 분배 (좌우까지만 있다고 치자) 더는 하지말자.
					If (boxcnt *2 + 1) - boxorderarr(rnd2-1) <= CDbl(scnt) Then
					seedrnd = (boxcnt *2 + 1) - boxorderarr(rnd2-1)
					else
					seedrnd = 0
					End if
					seednamergi = seednamergi - 1
					rnd2 = rnd2 + 1
				End if
			else
				seedrnd = 0 '빈자리	
			End If
			
			If i Mod 2 = 0 Then
				posstr = "R_"	
			Else
				posstr = "L_"
			End if

			dicrull.ADD posstr & sortno, orderno &"_"& seedrnd

			If order1st = True Then
				orderno = "2" '이등자리
				order1st = false
			End if
			sortno = sortno + 1	
		Next
	next

	debugp = false
	'#######################################################################################
	If debugp = True then
		Response.write "#######################<br>"
		n = 1
		m = 1
		Response.write "<table border=1><tr><td style='background:orange'>"&m&"</td>"
		For Each v In dicrull.Keys 'v = 1 R_1
			Response.write  "<td style='background:#efef'>" &   v & "</td><td>" & dicrull.Item(v) & "</td>"
			If n Mod 8 = 0 Then
				m = m + 1
				Response.write  "</tr><tr><td style='background:orange'>"&m&"</td>"
			End If
			n = n + 1
		Next
		Response.write "</tr></table>"
		Response.end
	End if
	'#######################################################################################


	If bkst = "짝수 역소트 필요없어졌어용" then
		sub backsort(ByVal dkey, ByVal dvalue)
			Dim v, k 
			k = 1
			For v = 8 To 1 Step -1
				dicrull.Item(dkey(k)) = dvalue(v)
			 k= k + 1
			Next	 
		End sub

		'짝수 (R)박스 역순으로 소팅하기
		Dim dkey(8) '키값저장
		Dim dvalue(8) '값저장

		a  = 1 '넣을배열 1~8카운트
		For Each v In dicrull.Keys 

			If  Left(v,1) = "R" And a <=  8 then
				If a = 1 Then
					Call backsort(dkey,dvalue)	'역순으로 집어넣기
				End If

				dkey(a) = v
				dvalue(a) = dicrull.Item(v)
				
				If a = 8 Then
					a = 1
				Else
					a = a + 1			
				End if
			End If

		Next 
		If a = 1 Then
			Call backsort(dkey,dvalue)	'역순으로 집어넣기
		End If
	End if

	debugp = false
	'#######################################################################################
	If debugp = True then
		Response.write "#######################<br>"
		n = 1
		m = 1
		Response.write "<table border=1><tr><td style='background:orange'>"&m&"</td>"
		For Each v In dicrull.Keys 'v = 1 R_1
			Response.write  "<td style='background:#efef'>" &   v & "</td><td>" & dicrull.Item(v) & "</td>"
			If n Mod 8 = 0 Then
				m = m + 1
				Response.write  "</tr><tr><td style='background:orange'>"&m&"</td>"
			End If
			n = n + 1
		Next
		Response.write "</tr></table>"
		Response.end
	End if
	'#######################################################################################


		'고대로 왼쪽 오른쪽만 변경해서 넣자.
		Set dicrull2 =Server.CreateObject("Scripting.Dictionary")
		'박스 순서로 doc을 재배치 한다.
		no = 1
		keystr = "L_"

		For n = 0 To ubound(boxorderarr)
			startno = (boxorderarr(n) * 16) - 16
			For i = 1 To 16
				If i > 8 then
					dicrull2.ADD keystr & no , dicrull("R_"& no)
				Else
					dicrull2.ADD keystr & no , dicrull("L_"& no)
				End if
			no = no + 1
			Next
			If 	keystr = "L_" Then
				keystr = "R_"
			Else
				keystr = "L_"
			End if
		Next	


	debugp = false
	'#######################################################################################
	If debugp = True then
		Response.write "#######################<br>"
		n = 1
		m = 1
		Response.write "<table border=1><tr><td style='background:orange'>"&m&"</td>"
		For Each v In dicrull2.Keys 'v = 1 R_1
			Response.write  "<td style='background:#efef'>" &   v & "</td><td>" & dicrull2.Item(v) & "</td>"
			If n Mod 16 = 0 Then
				m = m + 1
				Response.write  "</tr><tr><td style='background:orange'>"&m&"</td>"
			End If
			n = n + 1
		Next
		Response.write "</tr></table>"
		Response.end
	End if
	'#######################################################################################
		
	If abc = "뒤집는거 하지말자" then
		'짝수열을 다시한번 역순으로 뒤집자.
		sub backsort2(ByVal dkey2, ByVal dvalue2)
			Dim v, k 
			k = 1
			For v = 16 To 1 Step -1
				dicrull2.Item(dkey2(k)) = dvalue2(v)
			 k= k + 1
			Next	 
		End sub

		'짝수 (R)박수 역순으로 소팅하기
		Dim dkey2(16) '키값저장
		Dim dvalue2(16) '값저장

		a  = 1 '넣을배열 1~8카운트
		For Each v In dicrull2.Keys 

			If  Left(v,1) = "R"  And a <=  16 then
				If a = 1 Then
					Call backsort2(dkey2,dvalue2)	'역순으로 집어넣기
				End If

				dkey2(a) = v
				dvalue2(a) = dicrull2.Item(v)
				
				If a = 16 Then
					a = 1
				Else
					a = a + 1			
				End if
			End If
		Next 

		If a = 1 Then
			Call backsort2(dkey2,dvalue2)	'역순으로 집어넣기
		End If

		For Each v In dicrull2.Keys 'v = 1 R_1
			If v = "" then
			dicrull2.Remove(v)
			End if
		next
	End if


	'10. 시드를 제외한 1위에 일련번호 부여 (6~32)
	'11. 2위일련번호 부여 (1~32)
	'bye joorndno = 짝꿍의 joorndno 와 맞춘다. (bye sortno 가 홀수 이면 +1의 것이랑, 짝수이면 -1의 것이랑)
	start1stno = CDbl(scnt + 1)
	start2stno = 1
	allKeys = dicrull2.Keys   
	allItems = dicrull2.Items 

	For i = 0 To dicrull2.Count - 1
		myKey = allKeys(i)
		myItem = allItems(i)
		boxinfo = Split(myItem,"_")

		If CStr(boxinfo(0)) = "1" And CStr(boxinfo(1)) = "0" Then '1등 순서번호 부여
			'If 	sudong = True Then '수동으로 갯수설정했을경우
			'	dicrull2.Item(myKey) = boxinfo(0) & "_" &""
			'else
				dicrull2.Item(myKey) = boxinfo(0) & "_" & start1stno
			'End if
			start1stno = start1stno + 1
		End If

		If CStr(boxinfo(0)) = "2" And CStr(boxinfo(1)) = "0" Then '2등 순서번호 부여
			'If 	sudong = True Then '수동으로 갯수설정했을경우
			'	dicrull2.Item(myKey) = boxinfo(0) & "_" &""
			'else
				dicrull2.Item(myKey) = boxinfo(0) & "_" & (cdbl(start2stno) +0)
			'End if
			start2stno = start2stno + 1
		End if	
	Next

	debugp = false
	'#######################################################################################
	If debugp = True then
		Response.write "#######################<br>"
		n = 1
		m = 1
		Response.write "<table border=1><tr><td style='background:orange'>"&m&"</td>"
		For Each v In dicrull2.Keys 'v = 1 R_1
			Response.write  "<td style='background:#efef'>" &   v & "</td><td>" & dicrull2.Item(v) & "</td>"
			If n Mod 16 = 0 Then
				m = m + 1
				Response.write  "</tr><tr><td style='background:orange'>"&m&"</td>"
			End If
			n = n + 1
		Next
		Response.write "</tr></table>"
	End if
	'#######################################################################################

'**************************************************************
End if


Call oJSONoutput.Set("boxcnt", boxcnt*2 )
Call oJSONoutput.Set("totalbye", bcnt )
strjson = JSON.stringify(oJSONoutput) 
	%>
	<div class="top_table">
		<table cellspacing="0" cellpadding="0">
			<tr>
				<th width="100">박스번호</th>
	<%
				For i = 0 To ubound(boxorderarr)
					Response.write "<th colspan='2'>"&boxorderarr(i)&"번</th>"
				next
				Response.write "<th>변경</th>"
				Response.write "</tr><tr><td><span>1위자리</span></td>"	

	
				For i= 1 To ubound(box81STtarr)
					Response.write "<td><input type='number' id='st1_"&i&"' value='"&box81STtarr(i)&"'></td>"
				next
				Response.write "<td rowspan='2'><input type='button' value='변 경' class='btn' onclick='javascript:mx_gameRull.reset1ST("&strjson&");'></td></tr><tr><td><span>BYE자리</span></td>"
	
				For i= 1 To ubound(box8BYEarr)
					Response.write "<td><input type='number' id='bye_"&i&"' value='"&box8BYEarr(i)&"'></td>"
				Next
	%>
			</tr>
		</table>
	</div>	
	<%
	'----------------------------------------------------------------------------------------------
	n = 1
	m = 0
	x = 1
	%>
	<div class="bt_table">
		<table cellspacing="0" cellpadding="0">
			<tr>
			<th width="50" class="l_bg">NO</th>
			<%
			For i = 1 To 16
				Response.write  "<th>" & i & "</th>"
			next

			Response.write "</tr><tr><td class='l_bg'>"&boxorderarr(m)&"</td>"	

			For Each v In dicrull2.Keys
				kv = Split(dicrull2.Item(v),"_")
				Select Case CDbl(kv(0))
				Case 1 : o_color = "color:red;font-weight:bold;"
				Case 2 : o_color = "color:black;"
				Case 0  : o_color = "color:blue;font-weight:bold;"
				End select
				ik = "<input type='number' id='ik_"&x&"' value='"&kv(0)&"' style='"&o_color&"'><br>"
				iv = "<input type='number' id='iv_"&x&"' value='"&kv(1)&"' style='"&o_color&"'>"
				x = x + 1

				Response.write  "<td>" & ik & iv & "</td>"

				If n Mod 16 = 0 And n < dicrull2.Count - 1  Then
					m = m + 1
					Response.write  "</tr>"

					Response.write  "<tr><th class='l_bg'>No</th>"
					For i = i To i + 15
						Response.write  "<th>" & i & "</th>"
					next			
					Response.write  "</tr>"
					Response.write"<tr><td class='l_bg'>"&boxorderarr(m)&"</td>"
				End If

				n = n + 1
			Next
			%>
			</tr>
		</table>
	</div>
	
	<%

%>
	<div class="top_table">
	<!-- <input type='button' value='빈자리 순서대로 채우기' class='btn'> -->
			<input type='button' value='자리번호지우기' class='btn' onclick='javascript:mx_gameRull.reset1STvalue(<%=strjson%>);'>
			<input type='button' value='랜덤번호지우기' class='btn' onclick='javascript:mx_gameRull.resetBYEvalue(<%=strjson%>);'>

			
			<%If loadok = false Then%>		
			<input type='button' value='저장' class='btn'  onclick='javascript:mx_gameRull.saveRull(<%=strjson%>);'>
			<%else%>
			<input type='button' value='수정' class='btn'  onclick='javascript:mx_gameRull.saveRull(<%=strjson%>);'><%'=strjson%>
			<%End if%>
	</div>
	<br><br><br><br><br><br><br>
<%
db.Dispose
Set db = Nothing
%>