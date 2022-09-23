<%
'#############################################
'마장마술 결과저장 
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

	'=========================
		If hasown(oJSONoutput, "B") = "ok" then
			r_B= oJSONoutput.B
		Else
			r_B = 0
		End If
		If hasown(oJSONoutput, "E") = "ok" then
			r_E= oJSONoutput.E
		Else
			r_E = 0
		End If
		If hasown(oJSONoutput, "M") = "ok" then
			r_M= oJSONoutput.M
		Else
			r_M = 0
		End If
		If hasown(oJSONoutput, "C") = "ok" then
			r_C= oJSONoutput.C
		Else
			r_C = 0
		End If
		If hasown(oJSONoutput, "H") = "ok" then
			r_H= oJSONoutput.H
		Else
			r_H = 0
		End If
	'=========================

	If hasown(oJSONoutput, "OFF1") = "ok" Then '감점
		r_off1= isnulldefault(oJSONoutput.OFF1,"0")
		If r_off1 = "" Then
			r_off1 = 0
		End if
	Else
		r_off1 = 0
	End If

	If hasown(oJSONoutput, "OFF2") = "ok" Then '경로위반
		r_off2= isnulldefault(oJSONoutput.OFF2,"0")
		If r_off2 = "" Then
			r_off2 = 0
		End if
	Else
		r_off2 = 0
	End If

	If hasown(oJSONoutput, "PERTOTAL") = "ok" Then '총비율
		r_pertotal= oJSONoutput.PERTOTAL
	End If

	If hasown(oJSONoutput, "MMTOTAL") = "ok" Then '지점총점 (계산된)
		r_mmtotal= oJSONoutput.MMTOTAL
	End If
	If hasown(oJSONoutput, "MMMAX") = "ok" Then 
		r_mmmax= oJSONoutput.MMMAX
	End If
	If hasown(oJSONoutput, "MMMIN") = "ok" Then 
		r_mmmin= oJSONoutput.MMMIN
	End If
	If hasown(oJSONoutput, "VIO") = "ok" Then  '경로위반에 따른 문자열 200 실권
		r_vio= oJSONoutput.VIO
	Else
		r_vio = 0
	End If


	If hasown(oJSONoutput, "PTPERARR") = "ok" Then  '지점별 비율계산값 배열
		Set r_ptarr= oJSONoutput.PTPERARR '여기배열값이 객체라면 Set this = r_ptarr.Get(0) 크기는 r_ptarr.length
	End If



'		obj.MAXPT = maxpt; //지점별 최고점수
'		obj.PTCNT = ptcnt; //지점수
'		obj.MAXCHK = maxchk;
'		obj.MINCHK = minchk; //최소값 제거할지 여부 YN
'		obj.TEAMGB = teamgb; //복합마술등 코드
'		obj.LOCSTR = locstr; //선택지점 문자열
'		obj.TESTA = $('#testtotal1').val(); //운동과목
'		obj.TESTB = $('#testtotal2').val(); //종합관찰
'#################################
	If hasown(oJSONoutput, "MAXPT") = "ok" Then  
		maxpt= oJSONoutput.MAXPT
	End If
	If hasown(oJSONoutput, "PTCNT") = "ok" Then  
		ptcnt= oJSONoutput.PTCNT
	End If
	If hasown(oJSONoutput, "MAXCHK") = "ok" Then  
		maxchk= oJSONoutput.MAXCHK
	End If
	If hasown(oJSONoutput, "MINCHK") = "ok" Then  
		minchk= oJSONoutput.MINCHK
	End If
	If hasown(oJSONoutput, "TEAMGB") = "ok" Then  
		teamgb= oJSONoutput.TEAMGB
	End If
	If hasown(oJSONoutput, "LOCSTR") = "ok" Then  '심사위치 문자열 
		locstr= oJSONoutput.LOCSTR
	End If
	If hasown(oJSONoutput, "TESTA") = "ok" Then  
		testa= oJSONoutput.TESTA
	End If
	If hasown(oJSONoutput, "TESTB") = "ok" Then  
		testb= oJSONoutput.TESTB
	End If
'#################################


'	'독립적으로 지점수, 최고점수, 심판장서명완료 가 되었는지 확인할수 있게 되어야한다. (gbidx 에서 한개라도 누락이라면 안된거임) 다시적용하록 메시지
	SQL = "select judgecnt,judgemaxpt,judgesignYN,judgeshowYN,maxChk,minChk     , judgeB,judgeE,judgeM,judgeC,judgeH    from tblRGameLevel  where gametitleidx = '"&r_tidx&"' and Gbidx = '"&r_gbidx&"'  "
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



	'1. 각지점의 점수를 db에서 불러온다.  
	'2. 감점과 경로위반 비율을 불러온다.  off1 , vio 

	fld = " score_1,score_2,score_3,score_4,score_5, off1,off2,vio  ,tryoutresult ,teamANa  " 'tryoutresult 0 기본 나머진 
	SQL = "Select  "& fld &" from sd_tennisMember where gamememberidx =  " & r_idx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	'Response.write sql


	If Not rs.EOF Then
		arrC = rs.GetRows()
	End If
	rs.close

	'Response.write r_B & "<br>"
	If IsArray(arrC) Then
		For ar = LBound(arrC, 2) To UBound(arrC, 2)
		s1 = isNullDefault(arrC(0, ar),0)
		s2 = isNullDefault(arrC(1, ar),0)
		s3 = isNullDefault(arrC(2, ar),0)
		s4 = isNullDefault(arrC(3, ar),0)
		s5 = isNullDefault(arrC(4, ar),0)
		Select Case UCase(locstr)
			Case "B" : s1 = r_B
			Case "E" : s2 = r_E
			Case "M" : s3 = r_M
			Case "C" : s4 = r_C
			Case "H" : s5 = r_H
		End Select 
		valarr = array(s1,s2,s3,s4,s5) '지점 점수
		perarr = array(0,0,0,0,0) '지점 비율

		off1 = isNullDefault(arrC(5,ar),0)
		off2 = isNullDefault(arrC(6,ar),"")
		vio = isNullDefault(arrC(7,ar),0)  '감점비율
		teamnm = isNullDefault(arrC(9,ar),"") '단체 팀구분(팀명칭)
		'Response.write teamnm

		If UCase(locstr) = "C" then
			If CDbl(r_vio) >= 0 Then '감점이 있다가 수정해서 0값이 온다면 다시 반영해주어야한다.
				vio = r_vio
			End If
			If CDbl(r_off1) >= 0 Then
				off1 = r_off1
			End If
			If CDbl(r_off2) >= 0 Then
				off2 = r_off2
			End If
		End if
		tryoutresult = arrC(9,ar) ''0기본 나머진 (기권 / 실격체크)
		Next
	End if


'http://ridingadmin.sportsdiary.co.kr/pub/ajax/riding/reqJudgeDetail.asp?test=t
'Response.write vio
'Response.end


	'최대값제거 최소값 제거 하기..#############
	 Function MaxArray(ByRef TheArray)
		  Dim i, Max
		  Max = 0
	  
		  For i = 0 To UBound(TheArray)
			   If TheArray(i) > TheArray(Max) Then
					Max = i
			   End If
		  Next
		  MaxArray = TheArray(Max)
	 End Function

	 Function MinArray(ByRef TheArray)
		  Dim i, Min
		  Min = 0
	  
		  For i = 0 To UBound(TheArray)
			   If TheArray(i) > 0 And TheArray(i) < TheArray(Min) Then
					Min = i
			   End If
		  Next
		  MinArray = TheArray(Min)
	 End Function

	'//지점별 비율 구하기
	Function setPointValue(pointvalue, off1, maxpt , vio)
		Dim pointper, sumvalue
		pointper = 0 
		sumvalue = 0

		if CDbl(vio) = 200 then
			sumvalue = CDbl(pointvalue) - cdbl(off1) - (maxpt * (0/100) )
		else
			sumvalue = CDbl(pointvalue) - cdbl(off1) - (maxpt * (vio/100) )
		End if
		pointper = (sumvalue / Cdbl(maxpt) )*100
		setPointValue =  pointper
	End Function


	'//총비율계산
	Function totalPer (maxpt,maxchk,minchk ,teamgb, off1 ,valarr, perarr, vio, ptcnt) 'ptcnt 지점수
		'//총점 :  지점별 총점 합산-감점-(최고기록 가능점수 X 경로위반 감점비율) >> 아래로 바꾸자.
		'//19618 총점 : 지점별 비율을 더한걸로. 그래서 각지점값을 각각 구해야한다.
		Dim sumvalue,i ,maxval,minval
		sumvalue = 0

		For i = 0 To 4
			sumvalue = sumvalue +  valarr(i)
			If CDbl(valarr(i)) > 0 then
			perarr(i) = setPointValue(valarr(i), off1, maxpt, vio) '//지점비율 구하기 
			Else
			perarr(i) = 0
			End if
		next

		'//최고점 최저점 점수 제거 
		maxval = MaxArray(valarr)
		minval = MinArray(valarr)

		'//만약 최대 최소를 빼야하는경우라면 총합에서 빼자.
		if maxchk = "Y" then
			sumvalue = CDbl(sumvalue) - maxval
		End if
		if minchk = "Y" then
			sumvalue = CDbl(sumvalue) - minval
		End if

		if CDbl(vio) = 200 then
			sumvalue = sumvalue - Cdbl(off1 * ptcnt) '- (maxpt * (0/100) )   '총비율에서 직접 빼는 형태로 변경 ( 9.18일 유희정 요청)
		else
			sumvalue = sumvalue - Cdbl(off1 * ptcnt) '- (maxpt * (vio/100) )
		End if
		 totalPer = sumvalue
	End Function
	
	'//////////////////////////////////////////
	function setViolation( maxpt,ptcnt,maxchk,minchk,teamgb, valarr, perarr, off1,vio)
		Dim total,minusptvalue,tper,rtarr,maxv,minv
		rtarr = array(0,0,0,0)

		if maxchk = "Y" then
			ptcnt = ptcnt - 1
		End if
		if minchk = "Y" then
			ptcnt = ptcnt - 1
		End if

		minusptvalue = 0 '최대최소가 선택시 뺄값

		'//총점
		if CDbl(vio) = 200 then	'//vio  200 실권
			total = totalPer(maxpt,maxchk,minchk, teamgb, off1, valarr, perarr, vio, ptcnt) '지점 총점

			'//총 비율 : (총점 / (최고기록 가능점수 * 지점수)) * 100			
			For i = 0 To 4
				tper = tper + CDbl(perarr(i))
			next
			
			maxv = MaxArray(valarr)
			minv = MinArray(valarr)
			if maxchk = "Y" then
				minusptvalue = CDbl(maxv)
			End if
			if minchk = "Y" then
				minusptvalue = CDbl(minusptvalue) + Cdbl(minv) 
			End if

			tper = (tper - minusptvalue) / ptcnt '//지점수로 나눈다.

			'총비율에서 직접 빼는 형태로 변경 ( 9.18일 유희정 요청) 추가s
			if CDbl(vio) = 200 then
				tper = tper - 0
			Else
				tper = tper - vio			
			End if
			'총비율에서 직접 빼는 형태로 변경 ( 9.18일 유희정 요청) 추가e
			
			if Cstr(teamgb) = "20103" then
				tper = Ceil_dot(tper,1) '//소수점 한자리 버림
			else
				tper = FormatNumber(tper,3) '//소수점 4째자리 반올림
			End if

		Else
		
			total = totalPer(maxpt,maxchk,minchk, teamgb, off1, valarr, perarr, vio, ptcnt) '지점 총점

			'//총 비율 : (총점 / (최고기록 가능점수 * 지점수)) * 100			
			For i = 0 To 4
				tper = CDbl(tper) + CDbl(perarr(i))
			next

			maxv = MaxArray(valarr)
			minv = MinArray(valarr)
			if maxchk = "Y" then
				minusptvalue = CDbl(maxv)
			End if
			if minchk = "Y" then
				minusptvalue = CDbl(minusptvalue) + Cdbl(minv) 
			End if

			tper = (tper - minusptvalue) / ptcnt '//지점수로 나눈다.

			if Cstr(teamgb) = "20103" then
				tper = round(tper,2) '//소수점 한자리 버림
			else
				tper = FormatNumber(tper,3) '//소수점 4째자리 반올림
			End if

		End if

		rtarr(0) = total '총점
		rtarr(1) = tper '총비율
		rtarr(2) = maxv '최대값
		rtarr(3) = minv '최소값
		setViolation = 	rtarr

	End function


rtarr =  setViolation( maxpt,ptcnt,maxchk,minchk,teamgb, valarr, perarr, off1,vio)


'For i = 0 To 4
'Response.write valarr(i) & ","
'Next
'Response.write "<br>"
'
'For i = 0 To 4
'Response.write perarr(i) & ","
'Next
'Response.write "<br>-----"
'
'
'For i = 0 To 3
'Response.write rtarr(i) & ","
'Next
'Response.end





	'#####################################
	'각지점비율 >> 지점비율 = 지점총점 / 지점별 최고 기록 가능점수
	scorestr = " score_1 = "&valarr(0)&",score_2 = "&valarr(1)&",score_3 = "&valarr(2)&",score_4 = "&valarr(3)&",score_5 = "&valarr(4)&" "
	perstr = ", per_1 = "& perarr(0) &"  "
	perstr = perstr & ", per_2 = "& perarr(1) &"  "
	perstr = perstr & ", per_3 = "& perarr(2) &"  "
	perstr = perstr & ", per_4 = "& perarr(3) &"  "
	perstr = perstr & ", per_5 = "& perarr(4) &"  "
		

	totalstr = " ,score_total = "&rtarr(0)&" , score_per = "&rtarr(1)&", off1 = "&off1&",off2 = "&off2&",maxval = "&rtarr(2)&",minval = "&rtarr(3)&",vio = '"&vio&"'   "

	'Y갯수에 따라서 중간값 을 넣는다.@@@@@@@@@@@@@
		Select Case CDbl(r_judgecnt)
		Case 1
			'패스 0
			midvalupquery = " ,midval = 0 " '지점이 하나라면 무조건 동점이다.
		Case 2
			'무조건 C지점값 update
			midvalupquery = " ,midval =  "&r_C   '동점일경우 짝수인경우는 무조건 C지점의 값으로 비교한다.

		Case 3
			'3개짜리 배열만들어야
			val3arr = array(0,0,0)
			n = 0
			For i = 0 To ubound(r_pYNarr)
				If r_pYNarr(i) = "Y" Then
					val3arr(n) = valarr(i)
					n = n + 1
				End if
			Next
			
			midarr_v = sortArray(val3arr) 'fn.util.asp 에 배열 소팅
			midvalupquery = " ,midval =  " & midarr_v(1)

		Case 4 '이것도 짝수임 그래서...
			'무조건 C지점값 update
			midvalupquery = " ,midval =  "&r_C   '동점일경우 짝수인경우는 무조건 C지점의 값으로 비교한다.

		Case 5 '최대 최소값을 뺀 3개값의 중간값으로 비교한다.
			midarr_v = sortArray(valarr)
			midvalupquery = " ,midval =  " & midarr_v(2)
		End Select 
	'Y갯수에 따라서 중간값 을 넣는다.@@@@@@@@@@@@@	


	If CStr(vio) = "200" then
		'실권(E) 처리하자....
		SQL = "Update SD_tennisMember Set tryoutresult = 'e' , boo_orderno=200 , total_order=200 where gameMemberIDX = " & r_idx
		Call db.execSQLRs(SQL , null, ConStr)

		SQL = "Update tblGameRequest Set gameresult = 'e' where RequestIDX = (select top 1 requestIDX from SD_tennisMember where  gameMemberIDX = " & r_idx & ")"
		Call db.execSQLRs(SQL , null, ConStr)

		SQL = "Update SD_tennisMember Set "& scorestr & perstr & totalstr &  midvalupquery &  " where gamememberidx = " & r_idx  '기본내용 저장
		Call db.execSQLRs(SQL , null, ConStr)
	
	else
		
		SQL = "Update SD_tennisMember Set "& scorestr & perstr & totalstr &  midvalupquery &  ",tryoutresult='0' where gamememberidx = " & r_idx  '기본내용 저장
		Call db.execSQLRs(SQL , null, ConStr)

	End if


	'단체인경우 처리되어야할곳
	'teamgb = 20201
	'score_per ->  group_score_per  (총비율 )  각비율합(기권실격자제외) / 명수((기권/실격자포함명수)
	If teamgb = "20201"  Then
		updateval = " (Select   convert(numeric(5,3), (sum(case when tryoutresult='0' then score_per else 0 end)/ count(*)))  as groupper From SD_tennisMember Where gametitleidx = '"&r_tidx&"' and gamekey3 = '"&r_gbidx&"'  and teamANa = '"&teamnm&"' ) "
		SQL = " Update SD_tennisMember Set  group_score_per = "&updateval&" Where gametitleidx = '"&r_tidx&"' and gamekey3 = '"&r_gbidx&"'  and teamANa = '"&teamnm&"' "
		Call db.execSQLRs(SQL , null, ConStr)
		'Response.write sql
		'Response.end
	End if

	'group_order 
	'공통사용하기 위해 함수로. req에 일딴 붙여둠
	Call orderUpdate( db, r_tidx, r_gbidx,  r_pubcode, r_rdno, "MM")

	If teamgb = "20201"  Then
	Call orderUpdateGroup( db, r_tidx, r_gbidx,  r_pubcode, r_rdno, "MM")
	End if

  	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing
%>