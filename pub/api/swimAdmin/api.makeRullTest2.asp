<%
'#############################################
'선택한 쉬트의 내용을 표시해준다.
'#############################################
'request
tidx = oJSONoutput.FSTR 
fstr2 = oJSONoutput.FSTR2

'dcnt = oJSONoutput.ATTCNT				'드로우 96
'scnt = oJSONoutput.SEED					'6
'jcnt = oJSONoutput.JONO					'조수 32
'boxorder = oJSONoutput.BOXORDER		'1,6,3,4,2,5 박스배치순서
'boxcnt = Fix(dcnt / 16) 'seed * 2 '최종 생성되는 박스수 6개박스


dcnt = 64
scnt = 8
jcnt = 22

'dcnt  =96
'scnt = 6
'jcnt = 32

'dcnt = 80
'scnt = 5
'jcnt = 32

dcnt = 40
scnt = 5
jcnt = 19


'충족요건  8배수
	chkcnt = Fix(CDbl(dcnt / scnt ))
	If CDbl(chkcnt) mod 8 = 0 Then
	else
		'Response.write "조건에 충족하지 않음 다시 입력바람" '"저장후 편집하여 주십시오."
		'Response.end
	End if
'충족요건 

boxorder = "0"

'boxorder = "1,6,3,4,2,5"

boxdorwcnt = Fix(dcnt / scnt)	'박스별드로수
boxcnt = Fix(dcnt / 16) '16drow box 갯수


chkdiv = 16
If CDbl(dcnt) mod 16 > 0 then
boxcnt = Fix(dcnt / 8) '16drow box 갯수
chkdiv = 8
End if


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
bcnt = CDbl(dcnt - (jcnt*2))   '총BYE갯수 = 총드로수 - 본선진출팀수 = 80-(조수x2팀) = 80-(32x2) = 16 




	' 각 시드박스 배열 재배치 기본배열순서 (방식 바꿈 나눌때부터 돌려져 있다고 가정하고 하자)

'Response.write boxcnt & "--------<br>"
'Response.end

Select Case CDbl(chkdiv)
Case 16

	If boxorder = "0" then
	'배열 순서를 받는다 16개 한박스
	Select Case CDbl(boxcnt)
	Case 2 : boxorderarr = array(1,2)
	Case 4 : boxorderarr = array(1,4,3,2)													'3,4,2,1 (홀수일때 1등남는자리 받는순서 ) 나누기 2 해서 왼쪽이 크다면....
	Case 8  : boxorderarr = array(1,8,5,4,3,6,7,2)										'6,5,7,8,3,4,2,1)
	Case 16 : boxorderarr = array(1,16,9,8 ,5,12,13,4   ,3,14,11,6 ,7,10,15,2)	'11,12,10,16,14,13,15,16,,6,5,7,8,3,4,2,1)
	Case Else : boxorderarr = array(1,5,2,4,3)
	End Select
	Else
		boxorderarr = Split(boxorder,",")
	End if	

Case 8

	Select Case CDbl(boxcnt)
	Case 5 : boxorderarr = array(1,2,3)
	End Select

End select
	' 각 시드박스 배열 재배치 기본배열순서


'시드박스당 1위팀수/바이수 배분###########
	'일딴 반분

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
	'4개라면 두개씩더해본다.
	'8개라면 4개씩 더해본다.

	Select Case CDbl(boxcnt)
	Case 4 '4 ,2 3, 1 순으로 분배
		'If order_1st * 2 > order_1st * 2 + order1_st_mod
		'짝수 뒤에서 부터 배분

		st14arr = array(4,2,3,1)
		For i = 1 To boxcnt
			If order_1st_mod > 0 then
				box1stcnt(st14arr(i-1)) = box1stcnt(st14arr(i-1)) + 1
				copybox1stcnt(st14arr(i-1)) = copybox1stcnt(st14arr(i-1)) + 1
				order_1st_mod = order_1st_mod -1
			End If
		Next

	Case 8
	st14arr = array(8,4,6,2,7,3,5,1)

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

'	For i = boxcnt To 1 Step -1
'		If order_1st_mod > 0 then
'			'짝수박스 뒤에서 부터 배분
'			box1stcnt(i) = box1stcnt(i) + 1
'			copybox1stcnt(i) = copybox1stcnt(i) + 1
'
'			order_1st_mod = order_1st_mod -1
'		End If
'	Next	
'시드박스당 1위팀수/바이수 배분###########


debugp = true
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
'	For n = 0 To ubound(boxorderarr)
'		box1stcnt(n+1) = copybox1stcnt(boxorderarr(n))
'		byecnt(n+1) = copybyecnt(boxorderarr(n))
'	Next	

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
POS1STARR = array(1,8,5,4,6,3,7,2)
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


'Response.write boxcnt@@@@@@@@@@@@@@@@
'For i = 0 To  ubound(boxorderarr)
'	Response.write boxorderarr(i) & ","
'next
'Response.write "<br>"


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
			If CDbl(box8byecnt) > CDbl(stcnt)  then
				If POSBYEARR(pos-1) = n  Then
					orderno = 0 'bye표시
					order1st = true
				Exit for			
				End If
			Else
				If POSBYEARR2(pos-1) = n  Then
					orderno = 0 'bye표시
					order1st = true
				Exit for			
				End If
			End if

		Next

		'시드주기배정 '홀수 번호 주고 남으면 짝수 주고. (박스순서로 배분하자.)
		If n = 1 And i Mod 2 = 1 Then '홀수 박스먼저 배분 홀수 박스 이하갯수처리는?
			If CDbl(putseed) > 0 And CDbl(boxorderarr(rnd1-1)) <=CDbl(scnt) Then
				seedrnd = boxorderarr(rnd1-1) 'rnd1
				putseed = putseed - 1
			End If
			rnd1 = rnd1 + 1

		ElseIf n = 1 And i Mod 2 = 0 then
			If CDbl(seednamergi) >= 0 then
				'seed  제일큰수부터 분배 (좌우까지만 있다고 치자) 더는 하지말자.

Response.write boxorderarr(rnd2-1) & "--"
Response.end
				
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

debugp = true
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
	'Response.end
End if
'#######################################################################################




	'고대로 왼쪽 오른쪽만 변경해서 넣자.
	Set dicrull2 =Server.CreateObject("Scripting.Dictionary")
	'박스 순서로 doc을 재배치 한다.
	no = 1
	keystr = "L_"

	For n = 0 To ubound(boxorderarr)
	If no <= dcnt then
		For i = 1 To 16
			If i > 8 then
				If dicrull("R_"& no) <> "" then
				dicrull2.ADD keystr & no , dicrull("R_"& no)
				End if
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
	End if
	Next	

debugp = true
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
	'Response.end
End if
'#######################################################################################
	

If aaa = "뒤집지마" then
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
	Next
End if

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
		'dicrull2.Item(myKey) = boxinfo(0) & "_" &"########"
		dicrull2.Item(myKey) = boxinfo(0) & "_" & start1stno
		start1stno = start1stno + 1
	End If

	If CStr(boxinfo(0)) = "2" And CStr(boxinfo(1)) = "0" Then '2등 순서번호 부여
		'dicrull2.Item(myKey) = boxinfo(0) & "_" &"########"
		dicrull2.Item(myKey) = boxinfo(0) & "_" & (cdbl(start2stno) +0)
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
























Set db = new clsDBHelper
'생성 여부 확인하고 찍어준다.
'SQL = "select idx from sd_TennisKATARullMake where mxjoono = '" & CStr(tidx) & CStr(Split(fstr2,",")(0)) & "'"
'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)		
'If rs.eof Then
'	Response.write "<div id='rullmsg' style='width:100%;height:30px;color:red;text-align:center;'>대진표 생성 정보가 없습니다. 저장을 눌러 생성해 주십시오.</div>"
'else
'	Response.write "<div id='rullmsg'  style='width:100%;height:30px;color:red;text-align:center;'>대진표 생성 정보가 있습니다. 저장 버튼을 누르면 다시 생성된 대진표로 저장됩니다.</div>"
'End If

%>
<table>
<!-- <thead id="headtest">
<th>순번</th>
<th>예선순위</th>
<th>추첨번호</th>
<th>시드순위</th>
<th style="background-color:orange;width:2px;"></th>
<th>순위</th>
<th>추첨</th>
</thead> -->
<tbody>
<%
'	sql = "select top 1 *  " 
'	sql = sql & " from  sd_TennisMember "  
'	sql = sql & " where delyn='N' and GameTitleIDX='"&tidx&"'  and  gamekey3 ='"&CStr(Split(fstr2,",")(0))&"' and ISNULL(round,'')='' "  
'	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)	


	SQL = "select sortno,joono,orderno from sd_TennisKATARull where mxjoono = "&jcnt&"  order by sortno asc"
	Set srs = db.ExecSQLReturnRS(sql , null, ConStr)	
	If Not srs.EOF Then 
		arrRS = srs.GetRows()
	End if


'0 순위번호 1 조번호
i = 1
For Each v In dicrull2.Keys
katarull = Split(dicrull2.Item(v),"_")

Select Case CStr(katarull(0))
Case 0 
pstr = "<font color=blue>B</font>"
pvalue = "B"
Case 1 
pstr = "<font color=red>"&katarull(1)&"</font>"
pvalue = katarull(1)
Case 2 
pstr = "<font color=black>"&katarull(1)&"</font>"
pvalue = katarull(1)
End Select 

%>
<tr class="gametitle"  
	<%if UBound(katarull) <=1 and katarull(0) <> "0" then %> 
	 style="background-color:#fda;"
	<%elseif UBound(katarull) <=1 and katarull(0) = "0" then %> 
 style="background-color:#C3C3C3;"
	<%elseif UBound(katarull) =2 and katarull(0) = "1" then %> 
 style="background-color:#cfdfff;"
	<%end if %>>

		<td><%=i%></td>
		
		<%if CStr(katarull(0)) = 1 then %>
			<td style="color:red;width:50px;font-weight:bold;"><%=katarull(0)%></td>
		<%elseif  CStr(katarull(0)) = 0 then  %>
			<td style="color:blue;width:50px;font-weight:bold;">B</td>
		<%else %>
			<td style="width:50px;"><%=katarull(0)%></td>
		<%end if %>
		
		<td id="c_<%=katarull(0)%>_<%=katarull(1)%>" ><%=pstr%> </td>

		
		
		
		<!-- <%if UBound(katarull) <=1 and katarull(0) <> "0" then %>
			<td style="background-color:#454;color:#fff;width:30px;"><%=katarull(1)%></td>
		<%else %>
			<td >
                <%if katarull(1) = 0 then %>
                    <span style="color:blue;width:50px;">BYE</span>
                <%end if %>
            </td>
		<%end if %> -->
		

		<!-- <%if CStr(katarull(0)) = 1 then %>
			<td style="color:red;width:50px;font-weight:bold;"><%=katarull(0)%></td>
		<%elseif  CStr(katarull(0)) = 0 then  %>
			<td style="color:blue;width:50px;font-weight:bold;">B</td>
		<%else %>
			<td style="width:50px;"><%=katarull(0)%></td>
		<%end if %> -->



		<td style="background-color:red;width:3px;"></td>
		
				<%
					If IsArray(arrRS) Then
						For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 
							dbsortno			= arrRS(0, ar)
							dbchoo			= arrRS(1, ar) 
							dborderno		= arrRS(2, ar) 
							If dborderno = "0" Then
								dbchoo = 0
							End if

							if  CDbl(dbsortno) = i  then 
								Response.write "<td>"& dborderno & "</td><td>" & dbchoo & "</td>"
								'Response.write "<td>"& dborderno & "</td>"
							end if

						Next
					end if
 
				%>

	</tr>
<%


if i mod 2 <> 1 then 
	%>
		<tr style="height:1px;"> 
			<td colspan="9" style="font-size:1px;background-color:black;height:1px;padding:1px;"></td>
		</tr>
	<%
end if

i = i + 1
next
%>
</tbody>
</table>
</br>
</br>
<%
Set dicrull2 = nothing

db.Dispose
Set db = Nothing
%>