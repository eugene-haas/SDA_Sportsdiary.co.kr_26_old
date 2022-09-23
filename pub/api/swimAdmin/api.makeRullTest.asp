<%
'#############################################
'선택한 쉬트의 내용을 표시해준다.
'#############################################
'request
tidx = oJSONoutput.FSTR 
fstr2 = oJSONoutput.FSTR2
attcnt = oJSONoutput.ATTCNT
seed = oJSONoutput.SEED
jono = oJSONoutput.JONO
boxorder = oJSONoutput.BOXORDER
boxcnt = Fix(ATTCNT / 16) 'seed * 2 '최종 생성되는 박스수

debugmode = false

'충족요건 
	chkcnt = Fix(CDbl(attcnt / seed ))
	If CDbl(chkcnt) mod 8 = 0 Then
	else
		Response.write "저장후 편집하여 주십시오."
		Response.end
		'조건에 충족하지 않음 다시 입력바람
	End if
'충족요건 

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


''4. 시드박스당 BYE수 배분	> 총BYE갯수 = 총드로수 - 본선진출팀수 = 80-(조수x2팀) = 80-(32x2) = 16 														
'	byecnt = CDbl(attcnt - (jono*2))
'	seedbyecnt = Fix(byecnt/boxcnt)
'	seedbyecnt_mod = Fix(byecnt Mod boxcnt)
'
'	ReDim seedboxBYEarr(boxcnt)
'	For i = 1 To boxcnt
'		seedboxBYEarr(i) = seedbyecnt
'		If i <= CDbl(seedbyecnt_mod)  Then
'			seedboxBYEarr(i) = CDbl(seedbyecnt + 1)
'		End if
'	next




'4. 시드박스당 BYE수 배분	> 총BYE갯수 = 총드로수 - 본선진출팀수 = 80-(조수x2팀) = 80-(32x2) = 16 														
	byecnt = CDbl(attcnt - (jono*2))   ' 18
	seedbyecnt = Fix(seed/boxcnt)	
	seedbyecnt_mod = Fix( (byecnt-seed) Mod boxcnt)  '분배하고 남은값
	ReDim seedboxBYEarr(boxcnt)

	
	Function byenanugi(ByVal byecnt)
		Dim sboxcnt
		Dim byearr(2)

		sboxcnt = fix(CDbl(byecnt) / 2)
		byearr(1) = sboxcnt 
		byearr(2) = sboxcnt + fix(CDbl(byecnt) Mod 2)
		byenanugi = byearr		
	End function


	Select Case CDbl(boxcnt)
	Case 2 '그냥 16개 2개로
	Case 4 
		n = 1
		byebye = byenanugi(byecnt)
		For i = 1 To ubound(byebye)
			byebye2 = byenanugi(byebye(i))
			seedboxBYEarr(n) = byebye2(1)
			n = n + 1
			seedboxBYEarr(n) = byebye2(2)
			n = n + 1			
		next
	Case 5
	Case 6
	Case 7
	Case 8
	Case 9
	Case 10
	Case 11
	End select

	
'//////////////////////
'	For i = 1 To boxcnt
'		seedboxBYEarr(i) = CDbl(seedbyecnt) +  Fix( (byecnt-seed) / boxcnt) '시드 + 평균값
'		If i <= CDbl(seedbyecnt_mod)  Then
'			seedboxBYEarr(i) = CDbl(seedboxBYEarr(i)  + 1)
'		End if
'	next
'4. 시드박스당 BYE수 배분



'	For i = 1 To ubound(seedboxBYEarr)
'		Response.write seedboxBYEarr(i) & "<br>"
'	next
'Response.end




'///////////////////////////////////////////
'박스당 1등 바이 출력 
'///////////////////////////////////////////
If debugmode = true then
	For i = 1 To ubound(seedbox1STtarr)
		Response.write seedbox1STtarr(i) & ","
	Next
	Response.write "<br>"

	For i = 1 To ubound(seedboxBYEarr)
		Response.write seedboxBYEarr(i) & ","
	Next
	Response.write "<br>"
	'Response.End
End if
'///////////////////////////////////////////




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
			'box1_bye = sBye
			'box2_bye = CDbl(sBye)+1
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
			'box1_bye = sBye
			'box2_bye = CDbl(sBye)+1
		End if
	End If

	box1st(n) = box1_1st
	boxbye(n) = box1_bye
	n = n + 1
	box1st(n) = box2_1st
	boxbye(n) = box2_bye
	n = n + 1
Next

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

For i = 1 To ubound(boxbye)
Response.write box1st(i) & ","
Next
Response.write "<br>"

For i = 1 To ubound(boxbye)
Response.write boxbye(i) & ","
Next


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
'namergiplus = CDbl(boxcnt) + 1
namergiplus = CDbl(seed)


j = 1
k = 1


'/////////////////////////////////////////////////
For i = 1 To boxcnt*2  '8개씩 10개 담기
	stcnt = box1st(i)
	byecnt = boxbye(i)

	'For m = 1 To 2

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


			dicrull.ADD "R_"&sortno, orderno & "_" & joorndno

			If order1st = True Then
				orderno = "2" '이등자리
				order1st = false
			End if

			sortno = sortno + 1	

		next

	'next

next
'////////////////////////////////////////////////

	Response.write "<br>"
	For Each v In dicrull.Keys 'v = 1 R_1
	Response.write v & " " & dicrull.Item(v) & "<br>"
	Next
	Response.end









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


'8. 각 시드박스 배열 재배치
	'	1) 기본배열순서									
	'	 - 2박스 : 1-2									
	'	 - 4박스 : 1-4-3-2									
	'	 - 8박스 : 1-8-5-4-3-6-7-2									
	'	 - 16박스 : 1-16-9-8-5-12-13-4-3-14-11-6-7-10-15-2									

	If boxorder = "0" then
	'배열 순서를 받는다 16개 한박스
	Select Case boxcnt
	Case 2 : boxorderarr = array(1,2)
	Case 4 : boxorderarr = array(1,4,3,2)
	Case 8  : boxorderarr = array(1,8,5,4,3,6,7,2)
	Case 16 : boxorderarr = array(1,16,9,8,5,12,13,4,3,14,11,6,7,10,15,2)
	Case Else : boxorderarr = array(1,5,2,4,3)
	End Select
	Else
		boxorderarr = Split(boxorder,",")
	End if


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
'8. 각 시드박스 배열 재배치

	For Each v In dicrull2.Keys 'v = 1 R_1
	Response.write dicrull2.Item(v) & "<br>"
	Next
	Response.end


'###################################
'짝수 박스는 뒤집지 말아야한다고..
Dim dvalue(8) '값저장
Dim dkey(8) '키값저장

	i = 1  '한개씩
	n = 1 '8단위로
	a  = 1 '넣을배열 1~8카운트

	For Each v In dicrull2.Keys 'v = 1 R_1

		If  (i Mod 8)  > 0 And (i Mod 8) <  8  then
			If n Mod 2 = 0 Then '일딴 넣은 다음에 뒤집자. 
				dkey(a) = v
				dvalue(a) = dicrull2.Item(v)
				a = a + 1
				'Response.write v & "<br>"
			End if
		Else
			If n Mod 2 = 0 Then
				dkey(a) = v
				dvalue(a) = dicrull2.Item(v)
				
				k = 1
				For x = 8 To 1 Step -1
					dicrull2.Item(dkey(k)) = dvalue(x)
				 k= k + 1
				Next
				'초기화
				a = 1
			End if
			n = n + 1 '각 8때 
'			Response.write n & "<br>"
		End If
		
	i = i + 1
	Next 

'###################################






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
		dicrull2.Item(myKey) = boxinfo(0) & "_" & start1stno  & "_0" 
		start1stno = start1stno + 1
	End If

	If CStr(boxinfo(0)) = "2" And CStr(boxinfo(1)) = "0" Then '2등 순서번호 부여
		dicrull2.Item(myKey) = boxinfo(0) & "_" & (cdbl(start2stno) +0)& "_0" 
		start2stno = start2stno + 1
	End if	
Next






		








'#######################################################
If debugmode = True then
	'들어간 내용 출력
	i = 1
	n = 2
	For Each v In dicrull2.Keys
		If Left(dicrull2.Item(v), 1) = "0" Then
		Response.write "<span style='color:red'>" & dicrull2.Item(v)  &"</span>,"
		Else
		Response.write dicrull2.Item(v)  &","
		End if
		'Response.write v & ":" & dicrull2.Item(v)
		If i>0 And i Mod 16 = 0 Then
	'		Response.write "<br>" & n & ": "
			Response.write "<br>"
			n = n + 1
		End if
	i = i + 1
	Next 
End if
'#######################################################
Set db = new clsDBHelper
'생성 여부 확인하고 찍어준다.
SQL = "select idx from sd_TennisKATARullMake where mxjoono = '" & CStr(tidx) & CStr(Split(fstr2,",")(0)) & "'"
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)		
If rs.eof Then
	Response.write "<div id='rullmsg' style='width:100%;height:30px;color:red;text-align:center;'>대진표 생성 정보가 없습니다. 저장을 눌러 생성해 주십시오.</div>"
else
	Response.write "<div id='rullmsg'  style='width:100%;height:30px;color:red;text-align:center;'>대진표 생성 정보가 있습니다. 저장 버튼을 누르면 다시 생성된 대진표로 저장됩니다.</div>"
End if
%>
<table>
<thead id="headtest">
<th>순번</th>
<th>예선순위</th>
<th>추첨번호</th>
<th>시드</th>
<th style="background-color:orange;width:2px;"></th>
<th>순위</th>
<th>추첨</th>
</thead>
<tbody>
<%
	sql = "select top 1 *  " 
	sql = sql & " from  sd_TennisMember "  
	sql = sql & " where delyn='N' and GameTitleIDX='"&tidx&"'  and  gamekey3 ='"&CStr(Split(fstr2,",")(0))&"' and ISNULL(round,'')='' "  
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)	


	SQL = "select sortno,joono,orderno from sd_TennisKATARull where mxjoono = "&JONO&"  order by sortno asc"
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
	<%if UBound(katarull) <=1 and katarull(0) <> "0" then %>
			<td style="background-color:#454;color:#fff;width:30px;"><%=katarull(1)%></td>
		<%else %>
			<td >
                <%if katarull(1) = 0 then %>
                    <span style="color:blue;width:50px;">BYE</span>
                <%end if %>
            </td>
		<%end if %>
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
Set dicrull = nothing

db.Dispose
Set db = Nothing
%>