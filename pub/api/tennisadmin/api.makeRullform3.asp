<%
'#############################################
'본선대진룰을 생성해 준다.
'#############################################

'++++++++
	'dcnt  =96
	'scnt = 6
	'jcnt = 32

	'dcnt = 80
	'scnt = 5
	'jcnt = 32

	'dcnt = 40
	'scnt = 5
	'jcnt = 19
'++++++++

'받는값
tidx = oJSONoutput.FSTR 
fstr2 = oJSONoutput.FSTR2


jcnt = oJSONoutput.JONO					'조수
scnt = oJSONoutput.SEED					'시드수

If hasown(oJSONoutput, "TSGF") = "ok" then	 'sgf  순서번호:랜덤번호;
	tsgf = oJSONoutput.TSGF
	saveok = True '화면에서 받아온값
Else
	tsgf = ""
	saveok = false
End If


'If hasown(oJSONoutput, "ABCSGF") = "ok" then	 'abcsgf  경기진행 조구분 알파벳;
'	abcsgf = oJSONoutput.ABCSGF
'End If


Set db = new clsDBHelper
'#############################################
'기본값 생성
'#############################################
'jcnt = 29 '조수
'scnt = 4  '시드수
Function chkdrow(ByVal tmcnt, ByVal rdcnt)
	Dim dcnt
	If rdcnt >= tmcnt Then
		dcnt = rdcnt
	Else
		rdcnt = rdcnt * 2
		If rdcnt >= tmcnt Then
			dcnt = rdcnt
		Else
			rdcnt = rdcnt * 2
			If rdcnt >= tmcnt Then
				dcnt = rdcnt
			Else
				rdcnt = rdcnt * 2
				If rdcnt >= tmcnt Then
					dcnt = rdcnt
				Else
					rdcnt = rdcnt * 2
					If rdcnt >= tmcnt Then
						dcnt = rdcnt
					Else
						Response.write rdcnt &  "는 지원하지 않아요..."
						Response.end
					End if
				End if
			End if
		End if
	End If
	chkdrow = dcnt
End Function 

'계산될값 -   드로수의 설정 : (시드수 X 8), (시드수 X 16), (시드수 X 32), (시드수 X 64)..순으로													
tmcnt = CDbl(jcnt) *2 '본선진출팀수
rdcnt = CDbl(scnt) * 8 '8박스 기준 강수 (드로수)

dcnt = chkdrow(tmcnt, rdcnt)
byecnt = dcnt - tmcnt


'저장된 정보확인
jooidx = CStr(tidx) & CStr(Split(fstr2,",")(0))
loadok = false
'#############################################


'Response.write jooidx 
'Response.end
'불러오기
If saveok = False Then
	SQL = "Select top 1 saveinfo,attcnt,seedcnt,jonocnt from sd_TennisKATARullMake where mxjoono =  '" & jooidx & "' and sortno = 1 "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

'Call rsdrow(rs)
'Response.end

	If Not rs.eof Then
		If isnull(rs(0)) = False then
			If InStr(rs(0),";") > 0 then
				saveinfo = Split(rs(0),";")
				v1 = rs(1)
				v2 = rs(2)
				v3 = rs(3)

				If CStr(v1) = CStr(dcnt) And CStr(v2) = CStr(scnt) And CStr(v3) = CStr(jcnt)  then
					loadok = true
					Set dicrull2 =Server.CreateObject("Scripting.Dictionary")
					For i = 0 To ubound(saveinfo) -1	
						sort_no = i + 1
						sellinfo = Split(saveinfo(i), ":")
						If CDbl(ubound(sellinfo)) = 2 then
						dicrull2.ADD "K_" & sort_no , sellinfo(0) & "_" & sellinfo(1) & "_" & sellinfo(2)
						Else
						dicrull2.ADD "K_" & sort_no , sellinfo(0) & "_" & sellinfo(1)
						End if
					Next
				End If 

			End if
		End if
	End if

End if


'저장#############
	If saveok = True Then '저장버튼을 눌러 화면에서 받아온 값이있다면


		'본선에 3라운드 선수가 있다면 bye 진출 선수가 있을수 있으므로
		'SQL = "Select top 1 gameMemberIDX from sd_TennisMember where GameTitleIDX =  "&tidx&"  and gamekey3 = " & Split(fstr2,",")(0) & " and round = 3 "
		'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		'If Not rs.eof Then
		'	Call oJSONoutput.Set("result", "12346" ) '진행경기가 있어 수정불가
		'	strjson = JSON.stringify(oJSONoutput)
		'	Response.Write strjson
			'db.Dispose
			'Set db = Nothing
			'Response.End
		'End if
		
		'결과가 생성 되었다면 수정 불가.
		'SQL = "Select top 1 idx from sd_TennisRPoint_log where titleIDX =  "&tidx&"  and teamGb = " & Left(Split(fstr2,",")(0),5)
		'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		'If Not rs.eof then
		'	Call oJSONoutput.Set("result", "12346" ) '진행경기가 있어 수정불가
		'	strjson = JSON.stringify(oJSONoutput)
		'	Response.Write strjson

		'db.Dispose
		'Set db = Nothing
		'Response.End
		'End if

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

		saveinfo = Split(tsgf,";")

		'생성된거 삭제#####
			SQL = "delete from sd_TennisKATARullMake where mxjoono = '" & jooidx & "' "
			Call db.execSQLRs(SQL , null, ConStr)	
		'생성된거 삭제#####

		For i = 0 To ubound(saveinfo) -1
			sort_no = i + 1
			sellinfo = Split(saveinfo(i), ":")

			If CDbl(ubound(sellinfo)) = 2 then
				abcinfo = sellinfo(2)
			Else
				abcinfo = ""
			End if

			If i = 0 Then
				insertvalue = " (" & sort_no &"," & sellinfo(0) &"," & sellinfo(1) &","& drowCnt &","& depthCnt &",'"& jooidx &"','0','"& dcnt &"','"& scnt &"','"& jcnt &"','0', '"&tsgf&"' ,'"&abcinfo&"')"
			else
				insertvalue = insertvalue & ", (" & sort_no &"," & sellinfo(0) &"," & sellinfo(1) &","& drowCnt &","& depthCnt &",'"& jooidx &"','0','"& dcnt &"','"& scnt &"','"& jcnt &"','0' , '' ,'"&abcinfo&"'  )"
			End if  
		next

		SQL = "INSERT INTO sd_TennisKATARullMake (sortno,orderno,joono,gang,round,mxjoono,seed,attcnt,seedcnt,jonocnt,boxorder, saveinfo, ABC) VALUES " & insertvalue
		Call db.execSQLRs(SQL , null, ConStr)	

		Call oJSONoutput.Set("result", "12345" ) '저장이 완료되었슴
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson

		db.Dispose
		Set db = Nothing
	Response.End
	End if
'저장#############


If loadok = False then

	'#######################################################################################
		debugp = false
		If debugp = True then
			Response.write dcnt & " " & byecnt & "<br>"
			Response.end
		End if
	'#######################################################################################

	Function baeboon1st(ByVal scnt, ByVal jcnt )
		Dim set1stcnt, re1st, i
		Dim boxarr() 
		ReDim boxarr(scnt)

		set1stcnt = 0 '추가배분까지한 1등자리

		For i = 1 To scnt '기본값 넣어두고
			boxarr(i) = 0
		Next

		For i = 1 To scnt
			boxarr(i) = Fix( jcnt  / scnt) '균등배분 (이미 시드수로 배열생성했음으로)
			set1stcnt = set1stcnt + boxarr(i) '배분총수
		next

		re1st = jcnt - set1stcnt '추가배분
		If CDbl(re1st) > 0 Then '추가배분 여부
			For i = scnt To 1 Step -1
				If CDbl(re1st) > 0 then
					boxarr(i) = CDbl(boxarr(i)) + 1
					re1st = re1st - 1
				End if
			next
		End If

		baeboon1st = boxarr
	End Function 

	Function baeboonbye(ByVal scnt, ByVal byecnt )
		Dim set1stcnt, re1st, i
		Dim boxarr()
		ReDim boxarr(scnt)

		For i = 1 To scnt '기본값 넣어두고
			boxarr(i) = 0
		Next

		rebyecnt = byecnt '분배할 바이수

		For i = 1 To scnt
			If CDbl(rebyecnt) > 0 then
				boxarr(i) = Fix(byecnt / scnt)	
				rebyecnt = rebyecnt - boxarr(i)
			End If
		next

		If CDbl(rebyecnt) > 0 Then '남은바이 배분
			For i = 1 To scnt
				If CDbl(rebyecnt) > 0 Then
					boxarr(i) = CDbl(boxarr(i))  + 1
					rebyecnt = rebyecnt - 1
				End if
			next
		End If
		baeboonbye = boxarr
	End Function 


	box1starr = baeboon1st(scnt, jcnt )
	byeboxarr = baeboonbye(scnt,  byecnt )

	'#######################################################################################
		debugp = false
		If debugp = True then
			For i = 1 To ubound(box1starr)
				Response.write box1starr(i) & "<br>"
			Next
			Response.write "++++++++++"& "<br>"
			For i = 1 To ubound(byeboxarr)
				Response.write byeboxarr(i) & "<br>"
			Next
			Response.end	
		End if
	'#######################################################################################

	seedbase = Fix(dcnt / scnt / 8) '시드당 기본단위수 시드를 8박스로 분배

	Dim box1st()
	ReDim box1st(scnt)
	Dim boxbye()
	ReDim boxbye(scnt)

	totalsetbyevalue = 0
	totalrebyevalue = 0

	For i = 1 To ubound(box1starr)
		box1st(i) = baeboon1st(seedbase, box1starr(i) )
		boxbye(i) = baeboonbye(seedbase,  byeboxarr(i) )

		'BYE 배분 적정성 검사 
		byesplit = False '재분배 여부
		resplit = 0 '재분배해야할 바이값

		setbyevalue = 0
		rebyevalue  =0

		For n = 1 To ubound(boxbye(i))
			chkbye = CDbl(box1st(i)(n) - boxbye(i)(n))
			If chkbye < 0 Then
				rebyevalue = CDbl(rebyevalue +Abs(chkbye)) '재분배 해야할 바이값
			ElseIf chkbye > 0 then
				setbyevalue = CDbl(setbyevalue +Abs(chkbye)) '재분배 가능한 값
			End If
		Next

		chkvalue = setbyevalue - rebyevalue

		totalsetbyevalue = CDbl(totalsetbyevalue + setbyevalue)
		totalrebyevalue = CDbl(totalrebyevalue + rebyevalue)
	Next

	'Response.write totalsetbyevalue & "- 재분배할수 있는갯수<br>"
	'Response.write totalrebyevalue & " - 재분배해야할 갯수<br>"

	'chkvalue = totalsetbyevalue - totalrebyevalue '가능한 숫자...

	chkvalue = totalrebyevalue - totalsetbyevalue  '해야할갯수 - 가능한곳갯수

	If totalrebyevalue > totalsetbyevalue Then '해야할갯수 > 가능한곳이
		totalrebyevalue = totalsetbyevalue
		total1stupvalue = totalrebyevalue '1등자리 변경할수	
		'역방향으로 

		If CDbl(totalrebyevalue) > 0 then
		'bye적정성 검사 차 분배
		For i = ubound(box1starr) To 1 Step -1

			'BYE 배분 적정성 검사 
			byesplit = False '재분배 여부
			resplit = 0 '재분배해야할 바이값

			setbyevalue = 0
			rebyevalue  =0

			For n = ubound(boxbye(i)) To 1 Step -1
				chkbye = CDbl(box1st(i)(n) - boxbye(i)(n))
				If chkbye < 0  And CDbl(total1stupvalue) > 0 Then
					boxbye(i)(n) = box1st(i)(n)
					total1stupvalue = total1stupvalue - 1
				End If
			Next
			
			 'bye 재분배
			For n = 1 To ubound(boxbye(i))
				chkbye = CDbl(box1st(i)(n) - boxbye(i)(n))
				If chkbye > 0 And CDbl(totalrebyevalue) > 0 Then '1이상인곳
					boxbye(i)(n) = CDbl(boxbye(i)(n)) + 1
					totalrebyevalue = totalrebyevalue - 1
				End If 
			next
		Next
		End if

	
	
	else
		total1stupvalue = totalrebyevalue '1등자리 변경할수

		If CDbl(totalrebyevalue) > 0 then
		'bye적정성 검사 차 분배
		For i = 1 To ubound(box1starr)

			'BYE 배분 적정성 검사 
			byesplit = False '재분배 여부
			resplit = 0 '재분배해야할 바이값

			setbyevalue = 0
			rebyevalue  =0


			For n = 1 To ubound(boxbye(i))
				chkbye = CDbl(box1st(i)(n) - boxbye(i)(n))
				If chkbye < 0  And CDbl(total1stupvalue) > 0 Then
					boxbye(i)(n) = box1st(i)(n)
					total1stupvalue = total1stupvalue - 1
				End If
			Next
			
			 'bye 재분배
			For n = 1 To ubound(boxbye(i))
				chkbye = CDbl(box1st(i)(n) - boxbye(i)(n))
				If chkbye > 0 And CDbl(totalrebyevalue) > 0 Then '1이상인곳
					boxbye(i)(n) = CDbl(boxbye(i)(n)) + 1
					totalrebyevalue = totalrebyevalue - 1
				End If 
			next
		Next
		End if
	End If
	





	'#######################################################################################
		debugp = false
		If debugp = True then
			For i = 1 To scnt
				For n = 1 To ubound(box1st(i))
					Response.write box1st(i)(n) & "<br>"
				next
			Next
			Response.write "++++++++++"& "<br>"
			For i = 1 To scnt
				For n = 1 To ubound(boxbye(i))
					Response.write boxbye(i)(n) & "<br>"
				next
			Next
			Response.end	
		End if
	'#######################################################################################


	'1위배치우선순위 : 1-8-5-4-6-3-7-2						
	POS1STARR = array(1,8,5,4,3,6,7,2)
	'BYE배치 우선순위 : 1위갯수와 같아질때 까지는 2-7-6-3 순으로 배분하고 1위를 초과하는 순번에서는 2-7-3-6순으로 기준을 변경하여 배분
	POSBYEARR = array(2,7,6,3)
	POSBYEARR2 = array(2,7,3,6)

	'1등 자리 red '2등 자리 black'bye 자리 blue '빈자리 blank
	orderno = 100	'빈자리 ,1 1등자리 , 2 2등자리 0 bye자리
	Set dicrull =Server.CreateObject("Scripting.Dictionary")


	'/////////////////////////////////////////////////
	'시드 박스에 8개씩 담기
	For i = 1 To scnt
		For n = 1 To ubound(box1st(i))
			'8드로우
			stcnt = box1st(i)(n)
			bcnt = boxbye(i)(n)

			If bcnt > 4 Then
				Call oJSONoutput.Set("result", "1212" ) '바이갯수 초과 (시드수를 줄여 주십시오.)
				strjson = JSON.stringify(oJSONoutput)
				Response.Write strjson
				Response.end
			End if		

			'일딴 8개 생성하고
			For d = 1 To 8
				dicrull.ADD "K_" & i & "_" & n & "_" & d,   "2" ' 2등자리라 해두고 이등자리_순서번호
			Next

			For d = 1 To 8

				For pos = 1 To stcnt 'stcnt 갯수만큼 채움
					If POS1STARR(pos-1) = d  Then
						dicrull.item("K_" & i & "_" & n & "_" & d) = "1"
					Exit for		
					End if
				Next

				If bcnt < 5 Then			
				For pos = 1 To bcnt '바이자리 (1등갯수에 따라서)
					If CDbl(bcnt) >  CDbl(stcnt)  then
						If POSBYEARR2(pos-1) = d  Then
							dicrull.item("K_" & i & "_" & n & "_" & d) = "0"
						Exit for			
						End If
					Else
						If POSBYEARR(pos-1) = d  Then
							dicrull.item("K_" & i & "_" & n & "_" & d) = "0"
						Exit for			
						End If
					End if
				Next
				End if

			Next

		next
	Next


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

	' 각 시드박스 배열 재배치 기본배열순서 (방식 바꿈 나눌때부터 돌려져 있다고 가정하고 하자)
	Select Case CDbl(scnt)
	Case 1 : sboxorder = array(1)
	Case 2 : sboxorder = array(1,2)
	Case 3 : sboxorder = array(1,3,2)
	Case 4 : sboxorder = array(1,4,2,3)
	Case 5 : sboxorder = array(1,5,2,4,3)
	Case 6 : sboxorder = array(1,6,3,4,2,5)
	Case 7 : sboxorder = array(1,7,3,5,2,6,4)
	Case 8 : sboxorder = array(1,8,4,5,2,7,3,6)
	End Select

	Select Case CDbl(seedbase)
	Case 1 : seedbox8 = array(1)
	Case 2 : seedbox8 = array(1,2)
	Case 4 : seedbox8 = array(1,3,2,4)
	Case 8 : seedbox8 = array(1,5,4,8,2,6,3,7)
	End Select

	'재배치
	sortno = 1
	rnd1 = CDbl(scnt) + 1 '시드번호다음 1등자리번호
	rnd2 = 1 '2등자리번호

	Set dicrull2 =Server.CreateObject("Scripting.Dictionary")
	For i = 0 To ubound(sboxorder)

		For n = 0 To ubound(seedbox8)

			For Each v In dicrull.Keys
				If InStr(v, "K_" & sboxorder(i) & "_" & seedbox8(n) ) > 0 Then
					If right(v, 3 ) =  "1_1" Then '시드자리라면
						dicrull2.ADD "K_" & sortno , dicrull.Item(v) & "_" & sboxorder(i)  & "_"  ' 원 시드번호
					Else
						Select Case CDbl(dicrull.Item(v))
						Case 1 
							no = rnd1
							rnd1 = rnd1 + 1
						Case 2
							no = rnd2
							rnd2 = rnd2 + 1
						Case 0
							no = 0
						End Select 
						dicrull2.ADD "K_" & sortno , dicrull.Item(v) & "_" & no & "_"  '우선 시드에다 번호먼저 줘야되는데
					End if
					sortno = sortno + 1
				End if
			Next

		next

	Next



	debugp = false
	'#######################################################################################
		If debugp = True then
			Response.write "#######################<br>"
			n = 1
			m = 1
			Response.write "<table border=1 style='border-collapse: collapse;width:600px;'><tr><td style='background:orange'>"&m&"</td>"
			dic2cnt = dicrull2.Count
			For Each v In dicrull2.Keys 'v = 1 R_1
				Select Case CDbl(Split(dicrull2.Item(v),"_")(0))
				Case 1 : clr = "color:red"
				Case 2 : clr = "color:block"
				Case 0 : clr = "color:blue"
				End Select 
				Response.write  "<td><table border='1' style='border-collapse: collapse;width:100%;'><tr><td style='background:#efef'>" &  Split(v,"_")(1) & "</td></tr>   <tr><td style="""&clr&""">" & Split(dicrull2.Item(v),"_")(1) & "</td></tr></table></td>"
				If n Mod 16 = 0 Then
					If n < dic2cnt  then
					m = m + 1
					Response.write  "</tr><tr><td style='background:orange'>"&m&"</td>"
					Else
					Response.write  "</tr><tr>"
					End if
				End If
				n = n + 1
			Next
			Response.write "</tr></table>"
			Response.end
		End if
	'#######################################################################################

End if





Call oJSONoutput.Set("ATTCNT", dcnt )
Call oJSONoutput.Set("totalbye", bcnt )
strjson = JSON.stringify(oJSONoutput) 
%>

	
	<%
	'----------------------------------------------------------------------------------------------
	n = 1
	m = 0
	x = 1
	%>
			<!-- s: 테이블 리스트 -->





			<!-- s: 리스트 버튼 -->
		<%If CDbl(ADGRADE) > 500 then%>
		<div class="list_btn">
			<span style="padding"><!-- 저장은 막아두었습니다.&nbsp;&nbsp;&nbsp; --></span>
			<a href='javascript:mx_gameRull.reset1STvalue(<%=strjson%>);' class="blue_btn">자리번호지우기</a>
			<a href='javascript:mx_gameRull.resetBYEvalue(<%=strjson%>);' class="blue_btn">랜덤번호지우기</a>
			
			<a href='javascript:if (confirm("<%If loadok = False then%>저장<%else%>수정<%End if%>하시겠습니까?")) {mx_gameRull.saveRull(<%=strjson%>);}' class="pink_btn" id="btnsave"><%If loadok = False then%>저장<%else%>수정<%End if%></a>
		</div>
		<%End if%>
		<!-- e: 리스트 버튼 -->	
	
		<div class="h_20"></div>
	
	

		<table cellspacing="0" cellpadding="0">
			<tr class="no_bg">
			<%
			For i = 1 To 16
				Response.write  "<td>" & i & "</td>"
			next
			Response.write "</tr><tr>"	

			For Each v In dicrull2.Keys

				kv = Split(dicrull2.Item(v),"_")

				If CDbl(ubound(kv)) = 2 Then
					kvabc = kv(2)
				Else
					kvabc = ""
				End if
						
				Select Case CDbl(kv(0))
				Case 1 : o_color = "red"
				Case 2 : o_color = "black"
				Case 0  : o_color = "blue"
				End select
				ik = "<input type='number' id='ik_"&x&"' value='"&kv(0)&"'  class='"&o_color&"_font'><br>"
				iv = "<input type='number' id='iv_"&x&"' value='"&kv(1)&"'  class='"&o_color&"_font'><br>"
				jooabc = "<input type='text' id='abc_"&x&"' value='"&kvabc&"'  class='black_font' style='background:#CCD3E1;'  maxlength='1' onkeyup='mx_gameRull.jooABC("""&x&""",this.value)'>"
				x = x + 1

				Response.write  "<td>" & ik & iv & jooabc & "</td>"

				If n Mod 16 = 0 And n < dicrull2.Count - 1  Then
					m = m + 1
					Response.write  "</tr>"
					Response.write  "<tr  class='no_bg'>"
					For i = i To i + 15
						Response.write  "<td>" & i & "</td>"
					next			
					Response.write  "</tr>"
					Response.write"<tr>"
				End If

				n = n + 1
			Next
			%>
			</tr>
		</table>







<%
Set dicrull2 = nothing
db.Dispose
Set db = Nothing
%>