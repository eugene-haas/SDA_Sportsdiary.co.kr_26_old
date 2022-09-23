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

	If hasown(oJSONoutput, "JINPUTTXTARR") = "ok" then
		r_jinputtxt= oJSONoutput.JINPUTTXTARR
	End If
	If hasown(oJSONoutput, "JINPUTSECARR") = "ok" then
		r_jinputsec= oJSONoutput.JINPUTSECARR
	End If

	If hasown(oJSONoutput, "JINPUTARR") = "ok" then
		r_jinput= oJSONoutput.JINPUTARR
	End If

	If hasown(oJSONoutput, "BIGO") = "ok" then
		r_bigo= oJSONoutput.BIGO
	End If


	'#####################################
	sgfstr = "C:" &  r_gametime & ":" & r_pt2 & ";"
	'totalquery = " ROUND( "&r_pta&"   ,3,3 ) " '소요시간

	If r_pta = "E" Or r_pta = "R" Or r_pta = "D" then
	'사유소팅순서 구하기 fn_riding.asp
		orderno = getSayooSortno(r_pta)
		SQL = "Update SD_tennisMember Set tryoutresult = '"& LCase(r_pta) &"',boo_orderno="&orderno&",total_order="&orderno&"  where gameMemberIDX = " & r_idx
		Call db.execSQLRs(SQL , null, ConStr)
		totalquery = 0
	Else
		SQL = "Update SD_tennisMember Set tryoutresult = 0,boo_orderno=0,total_order=0  where gameMemberIDX = " & r_idx
		Call db.execSQLRs(SQL , null, ConStr)
		totalquery = " ROUND( "&r_pta&"   ,3,3 ) " '감점합계
	End if





	SQL = "Update SD_tennisMember Set score_1 =  "&r_pt1&" , score_2 = "&r_pt2&" , score_sgf = '"&sgfstr&"' , score_total = "&totalquery&"   ,jinputarr =  '"&r_jinput&"',jinputtxtarr = '"&r_jinputtxt&"', jinputsecarr='"&r_jinputsec&"',bigo = '"&r_bigo&"'    where gamememberidx = " & r_idx
	Call db.execSQLRs(SQL , null, ConStr)

	SQL = "Select teamgb From SD_tennisMember Where gameMemberIDX = " & r_idx 
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	teamgb = rs(0)
	If teamgb = "20202"  Then 'score_total 총소요시간  score_2 벌초 2 group_score_1 > 총벌초
		updateval1 = " (Select round(  sum(case when tryoutresult='0' then (score_total) else 0 end)/ count(*), 3) as errsum  From SD_tennisMember Where gametitleidx = '"&r_tidx&"' and gamekey3 = '"&r_gbidx&"' and teamANa = (select top 1 teamana from SD_tennisMember where gameMemberidx = "& r_idx &") ) "
		updateval2 = " (Select convert(numeric(5,2), (sum(case when tryoutresult='0' then isNull(score_2,0)  else 0 end)/ count(*)))  as grouptm  From SD_tennisMember Where gametitleidx = '"&r_tidx&"' and gamekey3 = '"&r_gbidx&"' and teamANa = (select top 1 teamana from SD_tennisMember where gameMemberidx = "& r_idx &") ) "
		SQL = " Update SD_tennisMember Set  group_score_total = "&updateval1&",group_score_1 = "&updateval2&" Where gametitleidx = '"&r_tidx&"' and gamekey3 = '"&r_gbidx&"'  and teamANa = (select top 1 teamana from SD_tennisMember where gameMemberidx = "& r_idx &") "
		Call db.execSQLRs(SQL , null, ConStr)
		'Response.write sql
		'Response.end
	End if	



	Call orderUpdate( db, r_tidx, r_gbidx,  r_pubcode, 1, "C")
	If teamgb = "20202"  Then
	Call orderUpdateGroup( db, r_tidx, r_gbidx,  r_pubcode, r_rdno, "C")
	End if

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