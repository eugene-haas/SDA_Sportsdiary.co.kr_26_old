<%
'#############################################
'장애물 type A 저장
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


	If hasown(oJSONoutput, "PT1") = "ok" then
		r_pt1= oJSONoutput.PT1 '소요시간
	End If

	If hasown(oJSONoutput, "PT2") = "ok" then
		r_pt2= oJSONoutput.PT2 '벌초
	End If

	If hasown(oJSONoutput, "PTA") = "ok" then
		r_pta= oJSONoutput.PTA
	End If



	'#####################################
	sgfstr = "C:" &  r_gametime & ":" & r_pt2 & ";"
	totalquery = " ROUND( "&r_pta&"   ,3,3 ) " '소요시간

	SQL = "Update SD_tennisMember Set score_1 =  "&r_pt1&" , score_2 = "&r_pt2&" , score_sgf = '"&sgfstr&"' , score_total = "&totalquery&"  where gamememberidx = " & r_idx
	Call db.execSQLRs(SQL , null, ConStr)

	Call orderUpdate( db, r_tidx, r_gbidx,  r_pubcode, 1, "C")


'	'부별순위 업데이트 (pubcode) 부별업데이트 
'	'부별 소팅해서 인덱스 순으로 가져온다. 
'	wherestr = " and gametitleidx =  '"&r_tidx&"' and gamekey3 = '"&r_gbidx&"' and pubcode = '"&r_pubcode&"' and score_total > 0 "
'	Selecttbl = "( SELECT boo_orderno,ROW_NUMBER() OVER (ORDER BY score_total asc) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
'	SQL = "UPDATE A  SET A.boo_orderno = A.RowNum FROM " & selecttbl
'	Call db.execSQLRs(SQL , null, ConStr)
'
'
'
'	'전체순위 업데이트 (각경기별) 전체업데이트 
'	wherestr = " and gametitleidx =  '"&r_tidx&"' and gamekey3 = '"&r_gbidx&"'  and score_total > 0 "
'	Selecttbl = "( SELECT total_order,ROW_NUMBER() OVER (ORDER BY score_total asc) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
'	SQL = "UPDATE A  SET A.total_order = A.RowNum FROM " & selecttbl
'	Call db.execSQLRs(SQL , null, ConStr)



  	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson


  db.Dispose
  Set db = Nothing
%>