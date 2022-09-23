<%
'#############################################
'생성된 룰을 저장한다.
'#############################################
'request
tidx = oJSONoutput.FSTR 
fstr2 = oJSONoutput.FSTR2

attcnt = oJSONoutput.ATTCNT			'드로우 96
seed = oJSONoutput.SEED					'6
jono = oJSONoutput.JONO					'조수 32
boxorder = oJSONoutput.BOXORDER		'1,6,3,4,2,5
boxcnt = Fix(ATTCNT / 16) 'seed * 2 '최종 생성되는 박스수 6개박스

'충족요건 
chkcnt = Fix(CDbl(attcnt / seed ))
If CDbl(chkcnt) mod 8 = 0 Then
else
	Response.write "'조건에 충족하지 않음 다시 입력바람"
	Response.end
End if


Set db = new clsDBHelper

'만들어진 테이블에 조건이 있다면 그냥 불러다 저장하자 ㅡㅡ
SQL = "select  top 1 joono from sd_TennisKATARull where mxjoono = "&jono&" and gang = "&attcnt
Set rs = db.ExecSQLReturnRS(sql , null, ConStr)	

If Not rs.eof Then
	jooidx = CStr(tidx) & CStr(Split(fstr2,",")(0))

	SQL = "delete from sd_TennisKATARullMake where mxjoono = '" & jooidx & "' "
	Call db.execSQLRs(SQL , null, ConStr)		
	
	insertfield = " sortno,orderno,joono,gang,round,mxjoono,seed,attcnt,seedcnt,jonocnt,boxorder "
	selectfield = " sortno,orderno, joono ,gang, round, " & jooidx & ",0, gang, "& seed & ", " & jono & ",0 "
	selectSQL = "Select " & selectfield & "  from sd_TennisKATARull  where mxjoono = " & jono & " and gang = " & attcnt

	SQL = "insert into sd_TennisKATARullMake ("&insertfield&")  " &  selectSQL
	Call db.execSQLRs(SQL , null, ConStr)

	Response.write "저장이 완료 되었습니다."
	Response.end
End if

'강수 라운드수 찾기#############
	if attcnt <=2 then
	drowCnt = 2
	depthCnt = 2
	elseif attcnt >2 and attcnt <=4 then
	drowCnt = 4
	depthCnt = 3
	elseif attcnt >4 and attcnt <=8 then
	drowCnt=8
	depthCnt = 4
	elseif attcnt >8 and  CDbl(attcnt) <=16 then
	drowCnt=16
	depthCnt = 5
	elseif attcnt >16 and  attcnt <=32 then
	drowCnt=32
	depthCnt = 6
	elseif attcnt >32 and  attcnt <=64 then
	drowCnt=64
	depthCnt = 7
	elseif attcnt >64 and  attcnt <=128 then
	drowCnt=128
	depthCnt = 8
	elseif attcnt >128 and  attcnt <=256 then
	drowCnt=256
	depthCnt = 9
	end if 
'강수 라운드수 찾기#############



'1위자리 배정 새로 짠부분####################

boxarr = array(64,32,16) '상위 단위박스부터 검사

For n = 0 To ubound(boxarr)
	If CDbl(attcnt) Mod boxarr(n) = 0 Then
		sboxcnt  = CDbl(attcnt) / boxarr(n)
		Exit for
	End if
next

order1st = Fix(jono / sboxcnt)
namergi = CDbl(jono) - CDbl(order1st * sboxcnt)		'그래도 남은 1등자리수

ReDim seedbox1STtarr_1(sboxcnt) '박스에다 나누어담기
For i = 1 To sboxcnt
	seedbox1STtarr_1(i) = order1st

	If i > CDbl(sboxcnt - namergi)  Then
		seedbox1STtarr_1(i) = CDbl(seedbox1STtarr_1(i) + 1)
	End If
next


If n = 0 Then '64 두번더
	ReDim seedbox1STtarr_2(sboxcnt*2)
	m = 1
	For i = 1 To ubound(seedbox1STtarr_1)
		orgvalue = seedbox1STtarr_1(i)
		orgnamergi = seedbox1STtarr_1(i) Mod 2

		seedbox1STtarr_2(m) = Fix(orgvalue / 2)
		m = m + 1
		seedbox1STtarr_2(m) = Fix(orgvalue / 2) + orgnamergi
		m = m + 1
	next

	ReDim seedbox1STtarr(sboxcnt*2*2)
	m = 1
	For i = 1 To ubound(seedbox1STtarr_2)
		orgvalue = seedbox1STtarr_2(i)
		orgnamergi = seedbox1STtarr_2(i) Mod 2

		seedbox1STtarr(m) = Fix(orgvalue / 2)
		m = m + 1
		seedbox1STtarr(m) = Fix(orgvalue / 2) + orgnamergi
		m = m + 1
	next

End If

If n = 1 Then '32 1번더
	ReDim seedbox1STtarr(sboxcnt*2)
	m = 1
	For i = 1 To ubound(seedbox1STtarr_1)
		orgvalue = seedbox1STtarr_1(i)
		orgnamergi = seedbox1STtarr_1(i) Mod 2

		seedbox1STtarr(m) = Fix(orgvalue / 2)
		m = m + 1
		seedbox1STtarr(m) = Fix(orgvalue / 2) + orgnamergi
		m = m + 1
	next
End if


If n = 2 Then '16 옴겨담기
	ReDim seedbox1STtarr(sboxcnt)
	For i = 1 To ubound(seedbox1STtarr_1)
		seedbox1STtarr(i) = seedbox1STtarr_1(i)
	next
End if





'1위자리 배정 새로 짠부분####################




'For i = 1 To ubound(seedbox1STtarr)
'	Response.write seedbox1STtarr(i) & "<br>"
'next
'Response.end


'//////////////////////////////////////////////////////////
If backupdata = True Then '백업용 이전작업 내용
	'1) 시드박스별 드로수 = 총드로수 / 총시드수 = 80/5 = 16										
	'2) 시드박스당 기본8드로단위 개수 = 16/8 = 2

	'3. 시드박스당 1위팀수 배분
		order_1st = Fix((jono - seed)/boxcnt)					'16개에 4개
		order_1st_mod = Fix((jono - seed) Mod boxcnt)		'8개당 2개
		namergi = CDbl(seed-boxcnt)								'그래도 남은 1등자리수

		ReDim seedbox1STtarr(boxcnt) '박스에다 나누어담기
		For i = 1 To boxcnt
			If i <= CDbl(seed) then
				seedbox1STtarr(i) = CDbl(order_1st + 1)
			Else
				seedbox1STtarr(i) = order_1st
			End if

			If CDbl(boxcnt) < 6 and CDbl(boxcnt) > 6 Then '박스가 6개보다 작으면 문제가 발생하지 않는다.
				If i > CDbl(boxcnt - order_1st_mod)  Then
					seedbox1STtarr(i) = CDbl(seedbox1STtarr(i) + 1)
				End If
			End if
		next

		'뒤에서 부터 넣어라 4개 박스기준으로    6: 2라면 
		If CDbl(boxcnt) = 6 then

			order_namergi = array(0,6, 4, 5, 3,2,1) '바이넣는자리 순서
			For n = 1 To order_1st_mod
				For i = 1 To ubound(order_namergi)
					If n = i then
						seedbox1STtarr(order_namergi(i)) = CDbl(seedbox1STtarr(order_namergi(i)) + 1)
					End if
				next
			Next

		End if


		If CDbl(namergi) > 0 Then
		namergi_1st = Fix(namergi/boxcnt)
		namergi_1st_mod = Fix(namergi Mod boxcnt)

		For i = 1 To boxcnt
			seedbox1STtarr(i) = CDbl(seedbox1STtarr(i) + namergi_1st)

			If i > CDbl(boxcnt - namergi_1st_mod)  Then
				seedbox1STtarr(i) = CDbl(seedbox1STtarr(i) + 1)
			End if
		Next
		End if
End if
'//////////////////////////////////////////////////////////


'4. 시드박스당 BYE수 배분	> 총BYE갯수 = 총드로수 - 본선진출팀수 = 80-(조수x2팀) = 80-(32x2) = 16 														
	byecnt = CDbl(attcnt - (jono*2))
	seedbyecnt = Fix(byecnt/boxcnt)
	seedbyecnt_mod = Fix(byecnt Mod boxcnt)

	ReDim seedboxBYEarr(boxcnt)
	For i = 1 To boxcnt
		seedboxBYEarr(i) = seedbyecnt
		If i <= CDbl(seedbyecnt_mod)  Then
			seedboxBYEarr(i) = CDbl(seedbyecnt + 1)
		End if
	next




'** 각박스별로 BYE수가 1위팀수를 초과하면 2위BYE가 발생한다.															
'** 전체1위팀수보다 전체BYE수가 크지않은한 2위BYE가 발생하면 안된다.		
'** 박스별로 (-)가 생긴경우 (+)가 발생한 차상위 박스로 BYE배분을 이전하여야 한다.

	'BYE 배분 적정성 검사 
		byesplit = False '재분배 여부
		resplit = 0 '재분배해야할 바이값
		If CDbl(jono - byecnt) < 0  Then '바이가 더많음 2위 bye발생
			'이건 그냥 두면되고
		else
			ReDim chkbye(boxcnt)
			For i = 1 To ubound(seedbox1STtarr)
				chkbye(i)  = CDbl(seedbox1STtarr(i) - seedboxBYEarr(i))
				If chkbye(i) < 0 Then
					seedboxBYEarr(i) = seedbox1STtarr(i)
					resplit = CDbl(resplit +Abs(chkbye(i))) '재분배 해야할 바이값
					byesplit = true
				End if
			Next

			If byesplit = True Then 'bye 재분배
				For n = 1 To ubound(chkbye)
					If CDbl(chkbye(n)) > 0 And resplit > 0 Then '1이상인곳
						seedboxBYEarr(n) = CDbl(seedboxBYEarr(n)) + 1
						resplit = resplit - 1
					End If 
				next
			End if
		End if	
	'BYE 배분 적정성 검사 

	n = 1
	ReDim box1st(boxcnt*2)
	ReDim boxbye(boxcnt*2)

	For i = 1 To ubound(seedbox1STtarr) '뒤쪽기준으로 나눔 ,바이는 앞쪽 기준으로 먼저 
		s1ST = Fix(seedbox1STtarr(i) / 2)
		sBye = Fix(seedboxBYEarr(i) / 2)

		If CDbl(seedbox1STtarr(i)) mod 2  = 0 Then		'1등배분 동일 배분 8박스 두개 동일 배분
			If CDbl(seedboxBYEarr(i)) mod 2  = 0 Then	'바이 배분
				box1_1st = s1ST
				box2_1st = s1ST
				box1_bye = sBye
				box2_bye = sBye
			else'앞쪽에 큰수
				box1_1st = s1ST
				box2_1st = s1ST
				box1_bye = CDbl(sBye)+1
				box2_bye = sBye
			End if
		Else '뒤쪽에 큰수
			If CDbl(seedboxBYEarr(i)) mod 2  = 0 Then
				box1_1st = s1ST
				box2_1st = CDbl(s1ST)+1
				box1_bye = sBye
				box2_bye = sBye
			else'앞쪽에 큰수
				box1_1st = s1ST
				box2_1st = CDbl(s1ST)+1
				box1_bye = CDbl(sBye)+1
				box2_bye = sBye
			End if
		End If

		'Response.write n&"<br>"
		'Response.write box1_bye&"<br>"
		box1st(n) = box1_1st
		boxbye(n) = box1_bye
		n = n + 1
		'Response.write n&"<br>"
		'Response.write box2_bye&"<br>"
		box1st(n) = box2_1st
		boxbye(n) = box2_bye
		n = n + 1
	Next


'For i =  1 To ubound(boxbye)
'Response.write  boxbye(i) & "<br>"
'Next
'Response.end



	'BYE 배분 적정성 검사 2처 ###########
		byesplit = False '재분배 여부
		resplit = 0 '재분배해야할 바이값
		If CDbl(jono - byecnt) < 0  Then '바이가 더많음 2위 bye발생
			'이건 그냥 두면되고
		else
			ReDim chkbye(boxcnt*2)
			For i = 1 To ubound(box1st)
				chkbye(i)  = CDbl(box1st(i) - boxbye(i))

				If CDbl(chkbye(i)) < 0 Then
					boxbye(i) = box1st(i)
					resplit = CDbl(resplit +Abs(chkbye(i))) '재분배 해야할 바이값
					byesplit = true
				End if
			Next

			If byesplit = True Then 'bye 재분배
				For n = 1 To ubound(chkbye)
					If CDbl(chkbye(n)) > 0 And resplit > 0 Then '1이상인곳
						boxbye(n) = CDbl(boxbye(n)) + 1
						resplit = resplit - 1
					End If 
				next
			End if
		End if	
	'BYE 배분 적정성 검사 2처 ###########





'For i = 1 To ubound(seedbox1STtarr)
'Response.write seedbox1STtarr(i) & "<br>"
'Next
'Response.write "-----------------------------------------<br>"
'For i = 1 To ubound(seedboxBYEarr)
'Response.write seedboxBYEarr(i) & "<br>"
'next
'Response.write "-----------------------------------------<br>"
'For i = 1 To ubound(seedboxBYEarr)
'Response.write CDbl(seedbox1STtarr(i) - seedboxBYEarr(i)) & "<br>"
'next
'Response.write "-----------------------------------------<br>"
'
'
''1등자리 바이 찍어보기
'For i = 1 To ubound(box1st)
'Response.write i & ". " & box1st(i) & "_" & boxbye(i)  & "<br>"
'Next
'Response.write "-----------------------------------------<br>"
'Response.end





'If CDbl(boxcnt) = 2 Or CDbl(boxcnt) = 4 Or CDbl(boxcnt) = 8 Or CDbl(boxcnt) = 16  Then
'Else
'	'2n승이 아닌경우 나머지 2개
'	'If boxcnt Mod 4 = 2 Then
'	If CDbl(boxcnt) = 6 Then
'		boxdata = array(box1st(11),boxbye(11),box1st(7),boxbye(7))
'		box1st(11)  = boxdata(2)
'		boxbye(11) =  boxdata(3)
'		box1st(7) =  boxdata(0)
'		boxbye(7) =  boxdata(1)
'	End if
'End if



'1등자리 바이 찍어보기
'For i = 1 To ubound(box1st)
'Response.write i & ". " & box1st(i) & "_" & boxbye(i)  & "<br>"
'Next



'여기까지 1등과 바이배분 
'#################################################################################################


'1위배치우선순위 : 1-8-5-4-6-3-7-2						
POS1STARR = array(1,8,5,4,6,3,7,2)
'BYE배치 우선순위 : 2-7-6-3					
POSBYEARR = array(2,7,6,3)

'1등 자리 red
'2등 자리 black
'bye 자리 blue
'빈자리 blank
orderno = 100 '빈자리 ,1 1등자리 , 2 2등자리 0 bye자리

Set dicrull =Server.CreateObject("Scripting.Dictionary")
'시드 박스에 8개씩 담기
sortno = 1
namergiplus = CDbl(seed)

j = 1
k = 1

For i = 1 To boxcnt*2  '8개씩 10개 담기
	stcnt = box1st(i)
	byecnt = boxbye(i)

	For n = 1 To 8

		For pos = 1 To stcnt '3개자리만 채웜
			If POS1STARR(pos-1) = n  Then
				orderno = 1 '1st표시
				order1st = true
			Exit for			
			End if
		Next
		
		For pos = 1 To byecnt '바이자리
			If POSBYEARR(pos-1) = n  Then
				orderno = 0 'bye표시
				order1st = true
			Exit for			
			End if
		Next

		'시드 자리 넣기 32에 4개라면  앞에서 체우고 역순으로 채우고 *****
		If n = 1 And i Mod 2 = 1  Then '홀수열 채우고 그래도 남는다면 짝수열 꺼꾸로 채우기를 해야한다.
			If j Mod 2 = 1 then
				joorndno = Fix(i/2) + 1
			Else
				joorndno = namergiplus
				namergiplus = CDbl(namergiplus) - 1
			End If
			j = j + 1
		Else
			joorndno = 0 '빈자리
		End If

		If n = 1 And i Mod 2 = 0  Then '8번째리 시드남은갯수 
			If k Mod 2 = 0 Then
				joorndno = k
			else
				joorndno = namergiplus
				namergiplus = CDbl(namergiplus) - 1
			End If
			k = k + 1
		End If


		dicrull.ADD "R_"&sortno, orderno & "_" & joorndno

		If order1st = True Then
			orderno = "2" '이등자리
			order1st = false
		End if

	sortno = sortno + 1	
	next
next


'For Each v In dicrull.Keys 
'	Response.write dicrull.Item(v) & "<br>"
'next
'Response.end


'8. 각 시드박스 배열
'	1) 기본배열순서									
'	 - 2박스 : 1-2									
'	 - 4박스 : 1-4-3-2									
'	 - 8박스 : 1-8-5-4-3-6-7-2									
'	 - 16박스 : 1-16-9-8-5-12-13-4-3-14-11-6-7-10-15-2									

If boxorder = "0" then
	'배열 순서를 받는다 16개 한박스
	Select Case boxcnt
	Case 1 : boxorderarr = array(1)
	Case 2 : boxorderarr = array(1,2)
	Case 4 : boxorderarr = array(1,4,3,2)
	Case 8  : boxorderarr = array(1,8,5,4,3,6,7,2)
	Case 16 : boxorderarr = array(1,16,9,8,5,12,13,4,3,14,11,6,7,10,15,2)
	Case Else : boxorderarr = array(1,5,2,4,3)
	End Select
Else
	boxorderarr = Split(boxorder,",")
	boxorder = CDbl( ubound(boxorderarr)) +1
End if


'내용찍어보기#########################
'For Each v In dicrull.Keys 
'	Response.write dicrull.Item(v) & "<br>"
'next
'내용찍어보기#########################




Set dicrull2 =Server.CreateObject("Scripting.Dictionary")
'박스 순서로 doc을 재배치 한다.
no = 1
For n = 0 To ubound(boxorderarr)
	startno = boxorderarr(n) * 16 - 15
	For i = 0 To 15
		dicrull2.ADD "R_"&no , dicrull("R_"& CDbl(startno + i ))
	no = no + 1
	Next
next





'###################################
Dim dvalue_s(8) '값저장
Dim dkey_s(8) '키값저장

	i = 1
	n = 1
	a  = 1

	For Each v In dicrull2.Keys 'v = 1 R_1
		If  (i Mod 8)  > 0 And (i Mod 8) <  8  then
			If n Mod 2 = 0 Then '일딴 넣은 다음에 뒤집자. 
				dkey_s(a) = v
				dvalue_s(a) = dicrull2.Item(v)
				a = a + 1
				'Response.write v & "<br>"
			End if
		Else
			If n Mod 2 = 0 Then
				dkey_s(a) = v
				dvalue_s(a) = dicrull2.Item(v)
				'역순저장
				k = 1
				For x = 8 To 1 Step -1
					dicrull2.Item(dkey_s(k)) = dvalue_s(x)
				 k= k + 1
				next

				'초기화
				a = 1
				'Response.write v & "----------------<br>"
			End if
			n = n + 1 '각 8때 
		End if
	i = i + 1
	Next 
'###################################






'For Each v In dicrull2.Keys 
'	Response.write dicrull2.Item(v) & "<br>"
'Next
'	Response.write dicrull2.Item(v) & "<br>"
'Response.End




'Response.end
'10. 시드를 제외한 1위에 일련번호 부여 (6~32)
'11. 2위일련번호 부여 (1~32)
'bye joorndno = 짝꿍의 joorndno 와 맞춘다. (bye sortno 가 홀수 이면 +1의 것이랑, 짝수이면 -1의 것이랑)
start1stno = CDbl(seed + 1)
start2stno = 1
allKeys = dicrull2.Keys   
allItems = dicrull2.Items 

For i = 0 To dicrull2.Count - 1
	myKey = allKeys(i)
	myItem = allItems(i)
	boxinfo = Split(myItem,"_")

	If CStr(boxinfo(0)) = "1" And CStr(boxinfo(1)) = "0" Then '1등 순서번호 부여
		dicrull2.Item(myKey) = boxinfo(0) & "_" & start1stno & "_0" 
		start1stno = start1stno + 1
	End If

	If CStr(boxinfo(0)) = "2" And CStr(boxinfo(1)) = "0" Then '2등 순서번호 부여
		dicrull2.Item(myKey) = boxinfo(0) & "_" & (cdbl(start2stno) +0) & "_0" 
		start2stno = start2stno + 1
	End if	
Next














'################################################################################



jooidx = CStr(tidx) & CStr(Split(fstr2,",")(0))

'생성된거 삭제#####
	SQL = "delete from sd_TennisKATARullMake where mxjoono = '" & jooidx & "' "
	Call db.execSQLRs(SQL , null, ConStr)	
'생성된거 삭제



'생성##########
i = 1
For Each v In dicrull2.Keys
	katarull = Split(dicrull2.Item(v),"_")
	If i = 1 Then
		insertvalue = " (" & i &"," & katarull(0) &"," & katarull(1) &","& drowCnt &","& depthCnt &",'"& jooidx &"' "
	else
		insertvalue = insertvalue & ", (" & i &"," & katarull(0) &"," & katarull(1) &","& drowCnt &","& depthCnt &",'"& jooidx &"' "
	End if  

	if UBound(katarull) <=1 and katarull(0) <> "0" then
		insertvalue = insertvalue &",'"&katarull(1)&"' "
	else
		insertvalue = insertvalue &",'' "
	end if 

	insertvalue = insertvalue &",'"&attcnt&"' "
	insertvalue = insertvalue &",'"&seed&"' "
	insertvalue = insertvalue &",'"&jono&"' "
	insertvalue = insertvalue &",'"&boxorder&"' "
	insertvalue = insertvalue &") "

i = i + 1
next

SQL = "INSERT INTO sd_TennisKATARullMake (sortno,orderno,joono,gang,round,mxjoono,seed,attcnt,seedcnt,jonocnt,boxorder) VALUES " & insertvalue
Call db.execSQLRs(SQL , null, ConStr)	
Response.write "저장이 완료 되었습니다."

Set dicrull2 = nothing
db.Dispose
Set db = Nothing
%>
 