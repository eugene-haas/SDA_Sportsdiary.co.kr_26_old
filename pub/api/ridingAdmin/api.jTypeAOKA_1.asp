<%
'#############################################
'장애물 type A 저장
'#############################################
	Set db = new clsDBHelper

	'request
	If hasown(oJSONoutput, "KGAME") = "ok" Then '체전여부 A 두번복사여부
		r_kgame= oJSONoutput.KGAME
	End If

	If hasown(oJSONoutput, "RDNO") = "ok" Then '장애물 A 라운드 별 계산에 필요
		r_rdno= oJSONoutput.RDNO
	End If


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
	If hasown(oJSONoutput, "BESTSC") = "ok" Then '최적시간
		r_bestsc= oJSONoutput.BESTSC
	End If


	If hasown(oJSONoutput, "GT") = "ok" then
		r_gametime= oJSONoutput.GT '소요시간
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

	'A타입 집계 
	'순위는 >> 감점합계가 적은선수, 소요시간 빠른 선수 
	'라운드 값을 가져와야한다...


	'#####################################
	If r_idx <> "" Then '집계만 사용할때뺌
		sgfstr = "A:" &  r_gametime & ":" & r_pt1 & ":" & r_pt2 & ";" 
		totalquery = " ROUND( "&r_pta&"   ,3,3 ) " '감점합계

		SQL = "Update SD_tennisMember Set score_1 =  "&r_gametime&" , score_2 = "&r_pt1&" , score_3 = "&r_pt2&" , score_sgf = '"&sgfstr&"' , score_total = "&totalquery&"  where gamememberidx = " & r_idx
		Call db.execSQLRs(SQL , null, ConStr)
	End if

	'공통사용하기 위해 함수로. req에 일딴 붙여둠
	Call orderUpdate( db, r_tidx, r_gbidx,  r_pubcode, r_rdno, "A_1")





'Declare @baseVal float
'
'Set @baseVal = 60
'Select * From sortTest       Order By case when ("&r_bestsc&" - score_1) < 0 then (abs("&r_bestsc&" - score_1) * 100) + 1  else abs("&r_bestsc&" - score_1) * 100  end


'		'부별순위 업데이트 (pubcode) 부별업데이트 
'		wherestr = " and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' and pubcode= '"&pubcode&"' and round= "&rdno&" and tryoutgroupno = 100 and tryoutresult  in( '0','R')  and score_1 > 0 " 
'		'감점이 0일수 있으니 score_1 > 0
'		Selecttbl = "( SELECT boo_orderno,RANK() OVER (ORDER BY score_total asc, case when ("&r_bestsc&" - score_1) < 0 then (abs("&r_bestsc&" - score_1) * 100) + 1  else abs("&r_bestsc&" - score_1) * 100  end) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
'		SQL = "UPDATE A  SET A.boo_orderno = A.RowNum FROM " & selecttbl
'		Call db.execSQLRs(SQL , null, ConStr)
'
'
'		'전체순위 업데이트 (각경기별) 전체업데이트 
'		wherestr = " and gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' and round= "&rdno&" and tryoutgroupno = 100 and tryoutresult  in( '0','R')  and score_1 > 0 "
'		Selecttbl = "( SELECT total_order,RANK() OVER (ORDER BY score_total asc, case when ("&r_bestsc&" - score_1) < 0 then (abs("&r_bestsc&" - score_1) * 100) + 1  else abs("&r_bestsc&" - score_1) * 100  end) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
'		SQL = "UPDATE A  SET A.total_order = A.RowNum FROM " & selecttbl
'		Call db.execSQLRs(SQL , null, ConStr)



  	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson


  db.Dispose
  Set db = Nothing
%>