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


	If hasown(oJSONoutput, "GT") = "ok" then
		r_gametime= oJSONoutput.GT '소요시간
	End If


	If hasown(oJSONoutput, "PT1") = "ok" then
		r_pt1= oJSONoutput.PT1
	Else
		r_pt1 = 0
	End If

	If hasown(oJSONoutput, "PT2") = "ok" then
		r_pt2= oJSONoutput.PT2
	Else
		r_pt2 = 0
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
		'Set r_jinput= oJSONoutput.JINPUTARR
		r_jinput= oJSONoutput.JINPUTARR
	End If

	If hasown(oJSONoutput, "BIGO") = "ok" then
		r_bigo= oJSONoutput.BIGO
	End If


	'Response.write r_jinput  &"<br>"
	'Response.write r_jinput.length
	'Response.write r_jinput.Get(0)
	'Response.end


	'A타입 집계 
	'순위는 >> 감점합계가 적은선수, 소요시간 빠른 선수 
	'라운드 값을 가져와야한다...


	'#####################################
	'결과값 상태가 실권, 기권 , 실격으로도 온다 이것도 처리루틴 추가 요망...
	'if  감점하계 (r_pta) = E 또는 R  또는 D 라면
	If r_pta = "E" Or r_pta = "R" Or r_pta = "D" then
	'사유소팅순서 구하기 fn_riding.asp
		orderno = getSayooSortno(r_pta)
		SQL = "Update SD_tennisMember Set tryoutresult = '"& LCase(r_pta) &"',boo_orderno="&orderno&",total_order="&orderno&"  where gameMemberIDX = " & r_idx
		Call db.execSQLRs(SQL , null, ConStr)
		totalquery = 0

		'만약 실권 이라면 0으로 입력되도록 변경
		r_pt1 = 0
		r_pt2 = 0
	Else
		SQL = "Update SD_tennisMember Set tryoutresult = 0,boo_orderno=0,total_order=0  where gameMemberIDX = " & r_idx
		Call db.execSQLRs(SQL , null, ConStr)
		totalquery = " ROUND( "&r_pta&"   ,3,3 ) " '감점합계
	End if


	If ssssss = "개별처리하기로함 사용하지 않음" then

		'복합마술인 경우
		SQL = "Select teamGb ,playeridx  from  SD_tennisMember where gameMemberIDX = " & r_idx
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.EOF Then
			arrNo = rs.GetRows()
			If IsArray(arrNo)  Then
				o_teamgb = arrNo(0, 0)
				o_pidx = arrNo(1,0) '선수인덱스
			End if
		End if

		'두번째 처리할때 필요한 값들 
		If o_teamgb = "20103" Or o_teamgb = "20203" then
			SQL = "select gamememberidx,gamekey3,requestidx from sd_tennismember where gametitleidx = "& r_tidx &" and teamgb = '20103'  and  playeridx = "& o_pidx &" and gameMemberIDX <> " & r_idx
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			r_idx2 = rs(0)
			r_gbidx2 = rs(1)
			r_ridx2 = rs(2)

			'tryoutresult, tryoutdocYN
			If r_pta = "E" Or r_pta = "R" Or r_pta = "D" then
				'사유소팅순서 구하기 fn_riding.asp
				orderno = getSayooSortno(r_pta)
				SQL = "Update SD_tennisMember Set tryoutresult = '"& LCase(r_pta) &"',boo_orderno="&orderno&",total_order="&orderno&"  where gamememberidx = " & r_idx2
				Call db.execSQLRs(SQL , null, ConStr)
			Else
				SQL = "Update SD_tennisMember Set tryoutresult = 0,boo_orderno=0,total_order=0 where gamememberidx = " & r_idx2
				Call db.execSQLRs(SQL , null, ConStr)

				'공통사용하기 위해 함수로. req에 일딴 붙여둠
				Call orderUpdate( db, r_tidx, r_gbidx2,  r_pubcode, r_rdno, "A") '복합마술 마장마술, 장애물 round = 1, 결과 2

			End If
		End If 

	End if
	'#####################################

	
	
	If r_idx <> "" Then '집계만 사용할때뺌
		sgfstr = "A:" &  r_gametime & ":" & r_pt1 & ":" & r_pt2 & ";" 

		SQL = "Update SD_tennisMember Set score_1 =  "&r_gametime&" , score_2 = "&r_pt1&" , score_3 = "&r_pt2&" , score_sgf = '"&sgfstr&"' , score_total = "&totalquery&",jinputarr =  '"&r_jinput&"',jinputtxtarr = '"&r_jinputtxt&"', jinputsecarr='"&r_jinputsec&"',bigo = '"&r_bigo&"'  where gamememberidx = " & r_idx
		'Response.write sql
		'Response.end
		
		Call db.execSQLRs(SQL , null, ConStr)

		'단체인경우 처리되어야할곳
			'teamgb = 20202
			'score_total ->  group_score_total  (총)  각합(기권실격자제외) / 명수((기권/실격자포함명수)
			'score_1 ->  group_score_1
			'score_total 감점합계 asc
			'score_1(소요시간)  asc
		SQL = "Select teamgb From SD_tennisMember Where gameMemberIDX = " & r_idx 
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		teamgb = rs(0)

		If teamgb = "20202"  Then
			updateval1 = " (Select round(  sum(case when tryoutresult='0' then score_total else 0 end)/ count(*), 3) as errsum  From SD_tennisMember Where gametitleidx = '"&r_tidx&"' and gamekey3 = '"&r_gbidx&"' and round= "&r_rdno&" and teamANa = (select top 1 teamana from SD_tennisMember where gameMemberidx = "& r_idx &") ) "
			updateval2 = " (Select convert(numeric(5,2), (sum(case when tryoutresult='0' then score_1 else 0 end)/ count(*)))  as grouptm  From SD_tennisMember Where gametitleidx = '"&r_tidx&"' and gamekey3 = '"&r_gbidx&"' and round= "&r_rdno&"  and teamANa = (select top 1 teamana from SD_tennisMember where gameMemberidx = "& r_idx &") ) "
			SQL = " Update SD_tennisMember Set  group_score_total = "&updateval1&",group_score_1 = "&updateval2&" Where gametitleidx = '"&r_tidx&"' and gamekey3 = '"&r_gbidx&"'  and teamANa = (select top 1 teamana from SD_tennisMember where gameMemberidx = "& r_idx &") "
			Call db.execSQLRs(SQL , null, ConStr)
			'Response.write sql
			'Response.end
		End if	
		
	
	End If

	'공통사용하기 위해 함수로. req에 일딴 붙여둠
	Call orderUpdate( db, r_tidx, r_gbidx,  r_pubcode, r_rdno, "A")

	If teamgb = "20202"  Then
	Call orderUpdateGroup( db, r_tidx, r_gbidx,  r_pubcode, r_rdno, "A")
	End if






'	'부별순위 업데이트 (pubcode) 부별업데이트 
'	'부별 소팅해서 인덱스 순으로 가져온다.  ROW_NUMBER  tryoutgroupno = 100 and .tryoutresult  in( '0','R') 
'	wherestr = " and gametitleidx =  '"&r_tidx&"' and gamekey3 = '"&r_gbidx&"' and pubcode = '"&r_pubcode&"' and round= "&r_rdno&" and tryoutgroupno = 100 and tryoutresult  in( '0','R')  and score_1 > 0 " '감점이 0일수 있으니 score_1 > 0
'	Selecttbl = "( SELECT boo_orderno,RANK() OVER (ORDER BY score_total asc, score_1 asc) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
'	SQL = "UPDATE A  SET A.boo_orderno = A.RowNum FROM " & selecttbl
'	Call db.execSQLRs(SQL , null, ConStr)
'
'	'감점합과 소요시간이 같은사람이 있다면 재경기가 일어나는데 이거 처리해줘야함..
'
'
'	'전체순위 업데이트 (각경기별) 전체업데이트 
'	wherestr = " and gametitleidx =  '"&r_tidx&"' and gamekey3 = '"&r_gbidx&"' and round= "&r_rdno&" and tryoutgroupno = 100 and tryoutresult  in( '0','R')  and score_1 > 0 "
'	Selecttbl = "( SELECT total_order,RANK() OVER (ORDER BY score_total asc, score_1 asc) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
'	SQL = "UPDATE A  SET A.total_order = A.RowNum FROM " & selecttbl
'	Call db.execSQLRs(SQL , null, ConStr)



  	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson


  db.Dispose
  Set db = Nothing
%>