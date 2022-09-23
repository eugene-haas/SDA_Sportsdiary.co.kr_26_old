<%
'#############################################
'장애물 type ㅠ 저장 1단계 2단계 저장..
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

	'1차
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
	'2차
	If hasown(oJSONoutput, "GT_2") = "ok" then
		r_gametime_2= oJSONoutput.GT_2 '소요시간
	End If
	If hasown(oJSONoutput, "PT1_2") = "ok" then
		r_pt1_2= oJSONoutput.PT1_2
	End If

	If hasown(oJSONoutput, "PT2_2") = "ok" then
		r_pt2_2= oJSONoutput.PT2_2
	End If

	If hasown(oJSONoutput, "PTA_2") = "ok" then
		r_pta_2= oJSONoutput.PTA_2
	End If

	'1. 2단계 진행된 사람 중 총감점이 적은선수가 우위순위
	'2. 2단계 진행된 사람 중 감점이 동일할 경우 소요시간이 제일 빠른선수   가 우위순위
	'3. 그 이후 순위는 1단계에서 진행된 선수들의 순위 출력 
	'   (순위 지정 방법은 1,2와 동일) 


	'1. 저장
	'2. 2단계 순위 생성
	'3. 2단계 최하위 순위 각각 가져요기
	'4. 1단계 순위 부여 + 최하위 순위 더해서 
	'#####################################
	sgfstr = "A:" &  r_gametime & ":" & r_pt1 & ":" & r_pt2 & ";"
	totalquery = " ROUND( "&r_gametime&"   ,3,3 ) " '소요시간

	If r_gametime_2 = "" Then
	SQL = "Update SD_tennisMember Set score_1 =  "&r_gametime&" , score_2 = "&r_pt1&" , score_3 = "&r_pt2
	SQL = SQL & "  ,score_sgf = '"&sgfstr&"' , score_total = "&r_pta&"  where gamememberidx = " & r_idx
	else
	SQL = "Update SD_tennisMember Set score_1 =  "&r_gametime&" , score_2 = "&r_pt1&" , score_3 = "&r_pt2&" , score_4 = '"&r_gametime_2&"' , score_5 = "&r_pt1_2&" , score_6 = "&r_pt2_2
	SQL = SQL & "  ,score_sgf = '"&sgfstr&"' , score_total = "&r_pta&", score_per = '"&r_pta_2&"'   where gamememberidx = " & r_idx
	End if
	Call db.execSQLRs(SQL , null, ConStr)


	Call orderUpdate( db, r_tidx, r_gbidx,  r_pubcode, 1, "B")


	'부별순위 업데이트 (pubcode) 부별업데이트 
	'부별 소팅해서 인덱스 순으로 가져온다. 
'	'2단계 순위
'	wherestr = " and gametitleidx =  '"&r_tidx&"' and gamekey3 = '"&r_gbidx&"' and pubcode = '"&r_pubcode&"' and tryoutgroupno = 100 and tryoutresult  in( '0','R') and  score_4 > 0 " 'score_per 감점이 없을수도 있지....소요시간은 0일수 없지...
'	Selecttbl = "( SELECT boo_orderno,ROW_NUMBER() OVER (ORDER BY score_total + score_per asc) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
'	SQL = "UPDATE A  SET A.boo_orderno = A.RowNum FROM " & selecttbl
'	Call db.execSQLRs(SQL , null, ConStr)
'
'	SQL = "select max(boo_orderno) from SD_tennisMember where DelYN = 'N' " & wherestr
'	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'	maxorder = rs(0)
'
'	If isNull(rs(0)) = True Then
'		maxorder = 0	
'	Else
'		maxorder = rs(0)
'	End if
'
'	'1단계 순위
'	wherestr = " and gametitleidx =  '"&r_tidx&"' and gamekey3 = '"&r_gbidx&"' and pubcode = '"&r_pubcode&"' and tryoutgroupno = 100 and tryoutresult  in( '0','R') and isNull(score_4,0) = 0 "
'	Selecttbl = "( SELECT boo_orderno,ROW_NUMBER() OVER (ORDER BY score_total + score_per asc) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
'	SQL = "UPDATE A  SET A.boo_orderno = A.RowNum + "&maxorder&" FROM " & selecttbl
'	Call db.execSQLRs(SQL , null, ConStr)
'
'
'	'###########################
'
'	'전체순위 업데이트 (각경기별) 전체업데이트 
'	'2단계 순위
'	wherestr = " and gametitleidx =  '"&r_tidx&"' and gamekey3 = '"&r_gbidx&"' and tryoutgroupno = 100 and tryoutresult  in( '0','R') and score_4 > 0  "
'	Selecttbl = "( SELECT total_order,ROW_NUMBER() OVER (ORDER BY score_total + score_per asc) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
'	SQL = "UPDATE A  SET A.total_order = A.RowNum FROM " & selecttbl
'	Call db.execSQLRs(SQL , null, ConStr)
'
'	SQL = "select max(boo_orderno) from SD_tennisMember where DelYN = 'N' " & wherestr
'	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'
'	If isNull(rs(0)) = True Then
'		maxorder = 0	
'	Else
'		maxorder = rs(0)
'	End if
'
'	'1단계 순위
'	wherestr = " and gametitleidx =  '"&r_tidx&"' and gamekey3 = '"&r_gbidx&"' and tryoutgroupno = 100 and tryoutresult  in( '0','R') and isNull(score_4,0) = 0 "
'	Selecttbl = "( SELECT total_order,ROW_NUMBER() OVER (ORDER BY score_total + score_per asc) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
'	SQL = "UPDATE A  SET A.total_order = A.RowNum + "&maxorder&"  FROM " & selecttbl
'	Call db.execSQLRs(SQL , null, ConStr)


  	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson


  db.Dispose
  Set db = Nothing
%>