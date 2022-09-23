<%
'#############################################
'기권 실격저장
'fn_ridging.asp 참조
'#############################################
	Set db = new clsDBHelper

	'request
	If hasown(oJSONoutput, "TIDX") = "ok" then
		r_tidx= oJSONoutput.TIDX
	End If
	If hasown(oJSONoutput, "GBIDX") = "ok" then
		r_gbidx= oJSONoutput.GBIDX
	End If

	If hasown(oJSONoutput, "PTSU") = "ok" Then '심사지점 수
		r_ptsu= oJSONoutput.PTSU
	End If

	If hasown(oJSONoutput, "MAXPT") = "ok" Then '지점별 최고 기록 가능점수
		r_maxpt= oJSONoutput.MAXPT
	End If

	If hasown(oJSONoutput, "BESTSC") = "ok" Then '최적시간
		r_bestsc= oJSONoutput.BESTSC
	End If


	If hasown(oJSONoutput, "PTNMARR") = "ok" then
		parr= oJSONoutput.PTNMARR
		reqarr = Split(parr,",")		'BEMCH

		For i = 0 To UBound(reqarr)
			If reqarr(i) = "B" Then
				upwstr = " , judgeB = 'Y' "
			End If
			If reqarr(i) = "E" Then
				upwstr = upwstr & " , judgeE = 'Y' "	
			End If
			If reqarr(i) = "M" Then
				upwstr = upwstr & " , judgeM = 'Y' "				
			End If
			If reqarr(i) = "C" Then
				upwstr = upwstr & " , judgeC = 'Y' "				
			End If
			If reqarr(i) = "H" Then
				upwstr = upwstr & " , judgeH = 'Y' "
			End if			
		next
	End if

	'###################
	'입력된 값이있는 경우 지점변경이 되면 안된다. 체크해야하지 않을가?
	'###################

	'지운거 혹 살릴까봐 delYN 된것도 모두 변경
	'경기중 변경한 경우는 모두 초기화 되어야한다.
	SQL = "UPDATE SD_tennisMember Set score_1= null,score_2= null,score_3= null,score_4= null,score_5= null,score_6= null, score_total= 0 ,score_per = 0 , per_1= 0 , per_2= 0 , per_3= 0 , per_4= 0 , per_5= 0,boo_orderno= 0,total_order=0,score_total2=0,score_sgf='',ptorder_1=0,ptorder_2=0,ptorder_3=0,ptorder_4=0,ptorder_5=0,maxval=0,maxval2=0,minval=0,minval2=0 where gametitleidx = '"&r_tidx&"' and gamekey3 = '"&r_gbidx&"' " 
	Call db.execSQLRs(SQL , null, ConStr)

	
	SQL = "Update tblRGameLevel Set judgeB= 'N',judgeE= 'N',judgeM= 'N',judgeC= 'N',judgeH= 'N'    where gametitleidx = '"&r_tidx&"' and Gbidx = '"&r_gbidx&"' " 
	Call db.execSQLRs(SQL , null, ConStr)
	
	If r_bestsc = ""  Then
		SQL = "Update tblRGameLevel Set judgecnt = '"& r_ptsu &"' ,judgemaxpt = '"&r_maxpt&"' "& upwstr &"  where gametitleidx = '"&r_tidx&"' and Gbidx = '"&r_gbidx&"' " 
		Call db.execSQLRs(SQL , null, ConStr)
	Else
		SQL = "Update tblRGameLevel Set  bestsc = '"&r_bestsc&"' where gametitleidx = '"&r_tidx&"' and Gbidx = '"&r_gbidx&"' " 
		Call db.execSQLRs(SQL , null, ConStr)
	End if

  
  	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing
%>
