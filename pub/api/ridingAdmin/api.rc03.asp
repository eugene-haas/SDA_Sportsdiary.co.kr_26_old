<%
'#############################################
'기권 실격저장
'fn_ridging.asp 참조
'#############################################
	Set db = new clsDBHelper

	'request
	If hasown(oJSONoutput, "IDX") = "ok" then
		r_idx= oJSONoutput.IDX
	End If
	If hasown(oJSONoutput, "TIDX") = "ok" then
		r_tidx= oJSONoutput.TIDX
	End If
	If hasown(oJSONoutput, "GBIDX") = "ok" then
		r_gbidx= oJSONoutput.GBIDX
	End If
	If hasown(oJSONoutput, "PUBCODE") = "ok" then
		r_pubcode= oJSONoutput.PUBCODE
	End If


	If hasown(oJSONoutput, "PTLOC") = "ok" then
		r_ptloc= oJSONoutput.PTLOC
	End If


	If hasown(oJSONoutput, "PT1") = "ok" then
		r_pt1= oJSONoutput.PT1
	End If

	If hasown(oJSONoutput, "PT2") = "ok" then
		r_pt2= oJSONoutput.PT2
	End If

	If hasown(oJSONoutput, "PTA") = "ok" then
		r_pta= oJSONoutput.PTA
	End If

	If hasown(oJSONoutput, "PREPT") = "ok" Then '이전 종합관찰값 (빼고 더하자)
		prept = oJSONoutput.PREPT
		If prept = "" Then
			prept = 0			
		End if
	Else
		prept = 0
	End If



'	'독립적으로 지점수, 최고점수, 심판장서명완료 가 되었는지 확인할수 있게 되어야한다. (gbidx 에서 한개라도 누락이라면 안된거임) 다시적용하록 메시지
	SQL = "select judgecnt,judgemaxpt,judgesignYN,judgeshowYN,maxChk,minChk     ,  judgeB,judgeE,judgeM,judgeC,judgeH    from tblRGameLevel  where gametitleidx = '"&r_tidx&"' and Gbidx = '"&r_gbidx&"'  "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arrC = rs.GetRows()
	End If
	rs.close

	If IsArray(arrC) Then
		For ar = LBound(arrC, 2) To UBound(arrC, 2)
			r_judgecnt = arrC(0, ar)
			r_judgemaxpt = arrC(1, ar)
			r_judgesignYN = arrC(2, ar)
			r_judgeshowYN = arrC(3, ar)
			r_judgemaxYN = arrC(4, ar)
			r_judgeminYN = arrC(5, ar)
			r_pYNarr = array(arrC(6, ar),arrC(7, ar),arrC(8, ar),arrC(9, ar),arrC(10, ar)) 'YN


			If CDbl(r_judgecnt) = 0 Or CDbl(r_judgemaxpt) = 0  Then 'Or r_judgesignYN = "N"  이건 끝나고 체크한다고 해서 뺌
				Call oJSONoutput.Set("result", "21" ) '수정시 세부종목 변경 불가
				strjson = JSON.stringify(oJSONoutput)
				Response.Write strjson
				'Response.write "`##`"
				Set rs = Nothing
				db.Dispose
				Set db = Nothing
				Response.End
			Exit for
			End if
		Next
	End if


	'#####################################
	'각지점비율 >> 지점비율 = 지점총점 / 지점별 최고 기록 가능점수

	sgfstr = r_ptloc & ":" & r_pt1 & ":" & r_pt2 & ";" '수정시 누적으로 계속 생성...예시  2:12:34;3:12:34;4:12:34;2:20:26; 루프를 돌면 마지막것이 있음....(varchar 1500 이상 들어가진 않겠지)


	totalquery = " ROUND( (isnull(score_1,0) + isnull(score_2,0) + isnull(score_3,0) + isnull(score_4,0) + isnull(score_5,0) ),3,3 ) "
	perquery =  " ROUND(   ( (isnull(score_1,0) + isnull(score_2,0) + isnull(score_3,0) + isnull(score_4,0) + isnull(score_5,0))/" & CDbl(r_judgemaxpt) * CDbl(r_judgecnt) & ")* 100 ,3,3)"   '총점 /( 지점별최고기록가능점수*심사 지점 수)
	per = " ROUND(   ( "&r_pta&"  /" & r_judgemaxpt & ") * 100   ,3,3)"

	SQL = "Update SD_tennisMember Set per_"&r_ptloc&"= "&per&",score_"&r_ptloc&" = "&r_pta&",s_"&r_ptloc&"_1 = "&r_pt1&",s_"&r_ptloc&"_2 = "&r_pt2&"   where gamememberidx = " & r_idx  '기본내용 저장
	Call db.execSQLRs(SQL , null, ConStr)

'Response.write sql
'Response.end

	total2 = CDbl(r_pt2) - (prept) '관찰총점
	'SQL = "Update SD_tennisMember Set  score_total = "&totalquery&" , score_per = "&perquery&", score_total2=score_total2 + "&total2&"   where gamememberidx = " & r_idx  '합저장 score_total2 종합관찰점수 총합
	SQL = "Update SD_tennisMember Set  score_total = "&totalquery&" , score_per = "&perquery&"   where gamememberidx = " & r_idx  '합저장 score_total2 종합관찰점수 총합
	Call db.execSQLRs(SQL , null, ConStr)




	'최대값제거 최소값 제거 하기..#############
	'위에 내용은 그냥두고..
	'관찰총점 최대값 최소값 maxval , minval 의 필드명을 찾는다.
	'둘의 값이 다르다면 1개이상 총점이 생성된 경우
	'sgf에서 두개의 값을 찾는다...
	Function arrayMax(ByRef p_arr, ByVal p_def, ByVal returntype, ByVal chkYNarr)
		Dim result : result = p_def
		Dim i
		Dim ivalue

		If isarray(p_arr) Then
		For i = 0 To ubound(p_arr)
			If chkYNarr(i) = "Y" then
				If result = p_def Then
					 result = p_arr(i)
					 ivalue = i
				End If

				If result < p_arr(i) Then
					 result = p_arr(i)
					 ivalue = i
				End If
			End if
		Next
		End If

		If returntype = "k" then
			arrayMax = ivalue + 1
		Else
			arrayMax = result
		End if
	End Function
 
	Function arrayMin(ByRef p_arr, ByVal p_def, ByVal returntype, ByVal chkYNarr)
		Dim result : result = p_def
		Dim i
		Dim ivalue

		If isarray(p_arr) Then
		For i = 0 To ubound(p_arr)
			If chkYNarr(i) = "Y" then
				If result = p_def Then
					 result = p_arr(i)
					 ivalue = i
				End If

				If result > p_arr(i) Then
					 result =  p_arr(i)
					 ivalue = i
				End If
			End if
		Next
		End If

		If returntype = "k" then
			arrayMin = ivalue + 1
		Else
			arrayMin = result
		End if
	End Function

	'3수중 중간값 찾기
	function median(a, b, c)
		If (a > b) Then
			If (b > c)       then 
			median =  b
			elseif (a > c)  then 
			median = c
			else               
			median =  a
			End if
		Else
			if (a > c)   then   
			median =  a
			elseif (b > c)  then 
			median =  c
			else            
			median =  b
			End if
		End if
	End Function

	function sortArray(arrShort)
		Dim i , temp, j 

		for i = UBound(arrShort) - 1 To 0 Step -1
			for j= 0 to i
				if arrShort(j)>arrShort(j+1) then
					temp=arrShort(j+1)
					arrShort(j+1)=arrShort(j)
					arrShort(j)=temp
				end if
			next
		next
		sortArray = arrShort

	end Function



	SQL = "select score_sgf,maxval, minval,score_1,score_2,score_3,score_4,score_5 from sd_TennisMember where gamememberIDX = " & r_idx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	maxarr_v = 0
	minarr_v = 0
	ptchkokcnt = 0
	If Not rs.eof then
		p_sgf = isNullDefault(rs(0),"")
		p_maxv = rs(1)
		p_minv = rs(2)
		sarr = array(isNullDefault(rs(3),0),isNullDefault(rs(4),0),isNullDefault(rs(5),0),isNullDefault(rs(6),0),isNullDefault(rs(7),0))
		rs.close
		Set rs = nothing

		maxarr_i = arrayMax(sarr,0, "k", r_pYNarr) '키
		minarr_i = arrayMin(sarr,0, "k", r_pYNarr)
		maxarr_v = arrayMax(sarr,0,"v", r_pYNarr) '값
		minarr_v = arrayMin(sarr,0 , "v", r_pYNarr)


		'Y갯수에 따라서 중간값 을 넣는다.@@@@@@@@@@@@@
		Select Case CDbl(r_judgecnt)
		Case 1
			'패스 0
			midvalupquery = " ,midval = 0 " '지점이 하나라면 무조건 동점이다.
		Case 2
			'무조건 C지점값 update
			midvalupquery = " ,midval =  score_4 " '동점일경우 짝수인경우는 무조건 C지점의 값으로 비교한다.

		Case 3
			'3개짜리 배열만들어야
			val3arr = array(0,0,0)
			n = 0
			For i = 0 To ubound(r_pYNarr)
				If r_pYNarr(i) = "Y" Then
					val3arr(n) = sarr(i)
					n = n + 1
				End if
			Next
			
			midarr_v = sortArray(val3arr)
			midvalupquery = " ,midval =  " & midarr_v(1)

		Case 4 '이것도 짝수임 그래서...
			'무조건 C지점값 update
			midvalupquery = " ,midval =  score_4 " '동점일경우 짝수인경우는 무조건 C지점의 값으로 비교한다.

		Case 5 '최대 최소값을 뺀 3개값의 중간값으로 비교한다.
			midarr_v = sortArray(sarr)
			midvalupquery = " ,midval =  " & midarr_v(2)
		End Select 
		'Y갯수에 따라서 중간값 을 넣는다.@@@@@@@@@@@@@		


		newsgf = ""
		p_sgfarr = Split(p_sgf,";")


		'Response.write p_sgf & "<br>"


		sgfmode = "insert"
		If p_sgf <> "" Then

			For i = 0 To ubound(p_sgfarr) - 1
				onept = Split(p_sgfarr(i),":")

				If CStr(r_ptloc) =  CStr(onept(0)) Then
					newsgf = newsgf & sgfstr '바꿈
					sgfmode = "edit"
				Else
					newsgf = newsgf &  p_sgfarr(i) & ";"
				End if
			next
		Else
			newsgf = sgfstr
		End If
		
		If sgfmode = "insert" Then
			newsgf = newsgf & sgfstr '바꿈		
		End if

		ptchkokcnt = ubound(p_sgfarr) '지점 평개된갯수

		'Response.write newsgf & "<br>"
		'Response.write minarr_i & "<br>"
		'Response.write maxarr_v & "<br>"
		'Response.write minarr_v & "<br>"

		p_sgfarr = Split(newsgf,";")
		total2 = 0
		maxexcept = 0
		minexcept = 0
		If newsgf <> "" Then
			For i = 0 To ubound(p_sgfarr) - 1
				onept = Split(p_sgfarr(i),":")
				'관찰총점은
				total2 = total2 + CDbl(onept(2))

				If CStr(onept(0)) = CStr(maxarr_i) Then
					maxexcept = onept(2)
				End if
				If CStr(onept(0)) = CStr(minarr_i) Then
					minexcept = onept(2)						
				End if
			next
		End If
		

		If r_judgemaxYN  = "Y" Then
			maxstr = ", maxval = "&maxarr_v&", maxval2 = "&maxexcept
		else
			maxstr = ", maxval = 0, maxval2 = 0 "
		End if
		If r_judgeminYN  = "Y" Then
			minstr = ", minval = "&minarr_v&", minval2 = "&minexcept
		Else
			minstr = ", minval = 0, minval2 = 0 "
		End If
		
		If ptchkokcnt > 3 Then '3개지점이상 평가가 이루어졌다면 최대 최소 제거한다.
		
			If r_judgemaxYN  = "Y" And r_judgeminYN = "N"  Then
				s_total = " , score_total = score_total -  " & maxarr_v
				total2 = CDbl(total2)  - CDbl(maxexcept)
			End if			

			If r_judgemaxYN  = "N" And r_judgeminYN = "Y"  Then
				s_total = " , score_total = score_total -  " & minarr_v
				total2 = CDbl(total2)  - CDbl(minexcept)
			End If

			If r_judgemaxYN  = "Y" And r_judgeminYN = "Y"  Then
				s_total = " , score_total = score_total -  " & CDbl(maxarr_v) + CDbl(minarr_v)
				total2 = CDbl(total2)  - (CDbl(maxexcept) + CDbl(minexcept))
			End If		

		End if
		
		'총점관 관찰총점 빼야지...
		SQL = "Update SD_tennisMember Set score_sgf =  '"&newsgf&"',score_total2= "&total2 &  maxstr & minstr  & s_total  & midvalupquery &  "     where gamememberidx = " & r_idx  
		Call db.execSQLRs(SQL , null, ConStr)

		
		'max min sgf 관찰총점 저장.....
	End if

	'최대값제거 최소값 제거 하기..#############





	'공통사용하기 위해 함수로. req에 일딴 붙여둠
	Call orderUpdate( db, r_tidx, r_gbidx,  r_pubcode, r_rdno, "MM")






  	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson


  db.Dispose
  Set db = Nothing
%>