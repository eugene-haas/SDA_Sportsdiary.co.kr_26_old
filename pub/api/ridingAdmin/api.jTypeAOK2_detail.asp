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

	If hasown(oJSONoutput, "BIGO2") = "ok" then
		r_bigo2= oJSONoutput.BIGO2
	End If




	If r_pta = "E" Or r_pta = "R" Or r_pta = "D" then
	'사유소팅순서 구하기 fn_riding.asp
		orderno = getSayooSortno(r_pta)
		SQL = "Update SD_tennisMember Set tryoutresult = '"& LCase(r_pta) &"',boo_orderno="&orderno&",total_order="&orderno&"  where gameMemberIDX = " & r_idx
		Call db.execSQLRs(SQL , null, ConStr)
		totalquery = 0
		r_pta = orderno
	ElseIf r_pta_2 = "E" Or r_pta_2 = "R" Or r_pta_2 = "D" Then
		orderno = getSayooSortno(r_pta_2)
		SQL = "Update SD_tennisMember Set tryoutresult = '"& LCase(r_pta_2) &"',boo_orderno="&orderno&",total_order="&orderno&"  where gameMemberIDX = " & r_idx
		Call db.execSQLRs(SQL , null, ConStr)
		totalquery = 0	
		r_pta_2 = orderno
	Else
		SQL = "Update SD_tennisMember Set tryoutresult = 0,boo_orderno=0,total_order=0  where gameMemberIDX = " & r_idx
		Call db.execSQLRs(SQL , null, ConStr)
		totalquery = " ROUND( "&r_gametime&"   ,3,3 ) " '소요시간
	End if



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
	SQL = SQL & "  ,score_sgf = '"&sgfstr&"' , score_total = "&r_pta&"   ,jinputarr =  '"&r_jinput&"',jinputtxtarr = '"&r_jinputtxt&"', jinputsecarr='"&r_jinputsec&"',bigo = '"&r_bigo&"'   where gamememberidx = " & r_idx
	
	Else
	
	SQL = "Update SD_tennisMember Set score_1 =  "&r_gametime&" , score_2 = "&r_pt1&" , score_3 = "&r_pt2&" , score_4 = '"&r_gametime_2&"' , score_5 = "&r_pt1_2&" , score_6 = "&r_pt2_2
	SQL = SQL & "  ,score_sgf = '"&sgfstr&"' , score_total = "&r_pta&", score_per = '"&r_pta_2&"'   ,jinputarr =  '"&r_jinput&"',jinputtxtarr = '"&r_jinputtxt&"', jinputsecarr='"&r_jinputsec&"',bigo = '"&r_bigo&"',bigo2 = '"&r_bigo2&"'     where gamememberidx = " & r_idx
	
	End if
	Call db.execSQLRs(SQL , null, ConStr)



	SQL = "Select teamgb From SD_tennisMember Where gameMemberIDX = " & r_idx 
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	teamgb = rs(0)
	If teamgb = "20202"  Then
		updateval1 = " (Select round(  sum(case when tryoutresult='0' then (score_total + score_per) else 0 end)/ count(*), 3) as errsum  From SD_tennisMember Where gametitleidx = '"&r_tidx&"' and gamekey3 = '"&r_gbidx&"' and teamANa = (select top 1 teamana from SD_tennisMember where gameMemberidx = "& r_idx &") ) "
		updateval2 = " (Select convert(numeric(5,2), (sum(case when tryoutresult='0' then (isNull(score_1,0) + isNull(score_4,0)) else 0 end)/ count(*)))  as grouptm  From SD_tennisMember Where gametitleidx = '"&r_tidx&"' and gamekey3 = '"&r_gbidx&"' and teamANa = (select top 1 teamana from SD_tennisMember where gameMemberidx = "& r_idx &") ) "
		SQL = " Update SD_tennisMember Set  group_score_total = "&updateval1&",group_score_1 = "&updateval2&" Where gametitleidx = '"&r_tidx&"' and gamekey3 = '"&r_gbidx&"'  and teamANa = (select top 1 teamana from SD_tennisMember where gameMemberidx = "& r_idx &") "
		Call db.execSQLRs(SQL , null, ConStr)
		'Response.write sql
		'Response.end
	End if	



	Call orderUpdate( db, r_tidx, r_gbidx,  r_pubcode, 1, "B")

	If teamgb = "20202"  Then
	Call orderUpdateGroup( db, r_tidx, r_gbidx,  r_pubcode, r_rdno, "B")
	End if




  	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson


  db.Dispose
  Set db = Nothing
%>