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


	If hasown(oJSONoutput, "OFF1") = "ok" Then '감점
		r_off1= oJSONoutput.OFF1
	Else
		r_off1 = 0
	End If

	If hasown(oJSONoutput, "OFF2") = "ok" Then '경로위반
		r_off2= oJSONoutput.OFF2
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
	End If


	If hasown(oJSONoutput, "PTPERARR") = "ok" Then  '지점별 비율계산값 배열
		Set r_ptarr= oJSONoutput.PTPERARR '여기배열값이 객체라면 Set this = r_ptarr.Get(0) 크기는 r_ptarr.length
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
	scorestr = " score_1 = "&r_B&",score_2 = "&r_E&",score_3 = "&r_M&",score_4 = "&r_C&",score_5 = "&r_H&" "


'	totalquery = " ROUND( (isnull(score_1,0) + isnull(score_2,0) + isnull(score_3,0) + isnull(score_4,0) + isnull(score_5,0) ),3,3 ) "
'	perquery =  " ROUND(   ( (isnull(score_1,0) + isnull(score_2,0) + isnull(score_3,0) + isnull(score_4,0) + isnull(score_5,0))/" & CDbl(r_judgemaxpt) * CDbl(r_judgecnt) & ")* 100 ,3,3)"   '총점 /( 지점별최고기록가능점수*심사 지점 수)
'	per = " ROUND(   ( "&r_pta&"  /" & r_judgemaxpt & ") * 100   ,3,3)"


'	perstr = ", per_1 = "& FormatNumber( (r_B/r_judgemaxpt)*100,3) &"  "
'	perstr = perstr & ", per_2 = "& FormatNumber( (r_E/r_judgemaxpt)*100,3) &"  "
'	perstr = perstr & ", per_3 = "& FormatNumber( (r_M/r_judgemaxpt)*100,3) &"  "
'	perstr = perstr & ", per_4 = "& FormatNumber( (r_C/r_judgemaxpt)*100,3) &"  "
'	perstr = perstr & ", per_5 = "& FormatNumber( (r_H/r_judgemaxpt)*100,3) &"  "

	perstr = ", per_1 = "& r_ptarr.Get(0) &"  "
	perstr = perstr & ", per_2 = "& r_ptarr.Get(1) &"  "
	perstr = perstr & ", per_3 = "& r_ptarr.Get(2) &"  "
	perstr = perstr & ", per_4 = "& r_ptarr.Get(3) &"  "
	perstr = perstr & ", per_5 = "& r_ptarr.Get(4) &"  "
		

	totalstr = " ,score_total = "&r_mmtotal&" , score_per = "&r_pertotal&", off1 = "&r_off1&",off2 = "&r_off2&",maxval = "&r_mmmax&",minval = "&r_mmmin&",vio = '"&r_vio&"'   "

	'Y갯수에 따라서 중간값 을 넣는다.@@@@@@@@@@@@@
		sarr = array(r_B,r_E,r_M,r_C,r_H)
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
					val3arr(n) = sarr(i)
					n = n + 1
				End if
			Next
			
			midarr_v = sortArray(val3arr) 'fn.util.asp 에 배열 소팅
			midvalupquery = " ,midval =  " & midarr_v(1)

		Case 4 '이것도 짝수임 그래서...
			'무조건 C지점값 update
			midvalupquery = " ,midval =  "&r_C   '동점일경우 짝수인경우는 무조건 C지점의 값으로 비교한다.

		Case 5 '최대 최소값을 뺀 3개값의 중간값으로 비교한다.
			midarr_v = sortArray(sarr)
			midvalupquery = " ,midval =  " & midarr_v(2)
		End Select 
	'Y갯수에 따라서 중간값 을 넣는다.@@@@@@@@@@@@@	


	If CStr(r_vio) = "200" then
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




	'공통사용하기 위해 함수로. req에 일딴 붙여둠
	Call orderUpdate( db, r_tidx, r_gbidx,  r_pubcode, r_rdno, "MM")

  	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing
%>
