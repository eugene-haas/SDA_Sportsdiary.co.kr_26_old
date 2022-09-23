<%
'#############################################
'리그순위변경
'#############################################
	
	'request

	If hasown(oJSONoutput, "LIDX") = "ok" Then 
		lidx = oJSONoutput.LIDX
	End If

	If hasown(oJSONoutput, "IDX") = "ok" Then 
		idx = oJSONoutput.IDX
	End If

	If hasown(oJSONoutput, "ID") = "ok" Then 
		domid = oJSONoutput.ID '필드_루프번호_인덱스
		idarr = Split(domid, "_")
	End If

	If hasown(oJSONoutput, "INVAL") = "ok" Then 
		inval = oJSONoutput.INVAL
	End If

	If hasown(oJSONoutput, "LOOPNO") = "ok" Then 
		loopno = oJSONoutput.LOOPNO
		nextloopno = CDbl(loopno) + 1
	End If

	If hasown(oJSONoutput, "STARTTM") = "ok" Then '출발시간
		starttm = oJSONoutput.STARTTM
	End If
	If hasown(oJSONoutput, "STAYTIME") = "ok" Then 'stay tome
		staytime = oJSONoutput.STAYTIME
	End If
	If hasown(oJSONoutput, "TIMETAKEN") = "ok" Then '소요시간
		timetaken = oJSONoutput.TIMETAKEN
	End If
	If hasown(oJSONoutput, "AVGSP") = "ok" Then '평균속력
		avgsp = oJSONoutput.AVGSP
	End If
	If hasown(oJSONoutput, "NEXTTM") = "ok" Then '다음출발예정시간
		nexttm = oJSONoutput.NEXTTM
	End If

	If hasown(oJSONoutput, "TRC") = "ok" Then '최종기록 (: 제거한 
		totalrecord = oJSONoutput.TRC
		ordersortdata = Replace(totalrecord,":","")
	End If
	If hasown(oJSONoutput, "TAVG") = "ok" Then '최종시속
		totalavgspeed = oJSONoutput.TAVG
	End If
	If hasown(oJSONoutput, "RESULT") = "ok" Then '최종결과  완주 / 실권 200
		totalresult = oJSONoutput.RESULT
	End If


	If inval = ""  Then
		Call oJSONoutput.Set("RT",0) '결과처리
		Call oJSONoutput.Set("result", 88 ) '잘못된 입력값
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson	
		Response.end
	else
		Select Case idarr(0)
		Case "arrive" : lengthchkeck = 8
		Case "vetgate" : lengthchkeck = 8
		Case "bpm" : lengthchkeck = 2
		End Select 

		If Len(inval) <> lengthchkeck then
			Call oJSONoutput.Set("RT",0) '결과처리
			Call oJSONoutput.Set("result", 88 ) '잘못된 입력값
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson	
			Response.End
		End if
	End if



	Set db = new clsDBHelper 
	SQL = "select loopcnt, stm,resttm,staytime1,staytime2,staytime3,bpm1,bpm2,bpm3,levelno  from tblRGameLevel where RGameLevelidx = " & lidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If not rs.eof Then
		loopcnt = rs(0)
		stm =  rs(1) '출발시간
		resttm= rs(2) '의무휴식시간 (분)
		staytime1= "00:"&isnulldefault(rs(3),"00")&":00" '제한시간
		staytime2= "00:"&isnulldefault(rs(4),"00")&":00"
		staytime3= "00:"&isnulldefault(rs(5),"00")&":00"
		bpm1= rs(6) '제한 bpm
		bpm2= rs(7)
		bpm3= rs(8)
		levelno = rs(9)

		'개인단체 구분
		If Left(levelno,3) = "202" Then
			gametype = "group"
		Else
			gametype = "person" '201
		End if
	End If
	
	'########
		'arrive_
		'vetgate_
		'staytime_
		'bpm_
		'timetaken_
		'perspeed_

		'starttm_

		'#####
		'total_record_
		'total_perspeed_
		'total_order > 200~500 501~...
		'불합격사유
		'total_result_
		'total_order  순위 
	'########

	'초로변환
	Function getSeconds(tm)
		Dim tmarr,ts,ms,ss
		tmarr = split(tm,":")   
		ts = CDbl(tmarr(0)) * 60 * 60
		ms = CDbl(tmarr(1)) * 60
		ss = CDbl(tmarr(2))
		'//시/분/초
		getSeconds =  Cdbl(ts+ms+ss)

	End Function	


	'1번은 출발시간 업데이트
	Select Case idarr(0)
	Case "arrive" :		valfld = "loop"&loopno&"val2"
	Case "vetgate" :		valfld = "loop"&loopno&"val3"
	Case "bpm" :		valfld = "loop"&loopno&"val5"
	End Select 



	'결과 찾기 (완주 실권) ////////////////////////////////////////////////////////////////////////////
	'order by cast(t1.tryouttotalorder as int) asc 
	'order by isnull(sortno,'9999') asc"

	If idarr(0) = "bpm" Then

	else
		setfield =  " , loop"&loopno&"val1 = '"&starttm&"' , loop"&loopno&"val4 = '"&staytime&"' , loop"&loopno&"val6 = '"&timetaken&"' , loop"&loopno&"val7 = '"&avgsp&"' "
		
		If isnumeric(ordersortdata) = True then
		setfield = setfield & ",total_record = '"&totalrecord&"', ordersortdata = '"&ordersortdata&"',total_perspeed = '"&totalavgspeed&"' " 
		Else
		setfield = setfield & "  " 
		End if
		
		
		If nexttm <> "" Then
			setfield = setfield & " , loop"& nextloopno &"val1 = '"&nexttm&"'  "
		End If
	End If

	SQL = "update sd_gameMember_geegoo Set "&valfld&" = '"&inval&"' "&setfield & "  where GameMemberIDX = " &  idx
	'Response.write sql
	'Response.end
	Call db.execSQLRs(SQL , null, ConStr)

	'결과 찾기 (완주 실권) ////////////////////////////////////////////////////////////////////////////



	'루프내용확인해서 실권여부 판단
	fldnm = fldnm & " loop1val4,loop1val5 "
	fldnm = fldnm & " ,loop2val4,loop2val5 "
	fldnm = fldnm & " ,loop3val4,loop3val5 ,groupno,teamnm "

	SQL = "Select  "&fldnm&" from sd_gameMember_geegoo where GameMemberIDX = " &  idx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	groupno = rs("groupno")
	teamnm = rs("teamnm")
	
	If totalresult = "200" Then
		setresultfld = " total_result = '200' "
		rt = 200
	Else
		 '총루프수에 따라서 확인해보자
		If CDbl(loopcnt) = 1 Then
			chk1 = chkStr(isNullDefault(rs(0),staytime1),staytime1)
			chk2 = chkStr(isNullDefault(rs(1),0),0)

			If Left(chk1,1) = "-" Or Left(chk2,1) = "-" Then
				'저장만 진행
				savetype = "onlysave"
			End If 
			
			If savetype = "onlysave" Then
					setresultfld = " total_result = '0' "			
					rt = 0
			else
				linechk1 = getSeconds(chk1)   - getSeconds(staytime1)
				linechk2 = CDbl(chk2) - bpm1

				If CDbl(linechk1) > 0 Or CDbl(linechk2) > 0   Then
					setresultfld = " total_result = '200' "
					rt = 200
				Else
					setresultfld = " total_result = '0' "			
					rt = 0
				End If
			End if

		End if

		

		If CDbl(loopcnt) = 2 Then

			chk1 = chkStr(isNullDefault(rs(0),staytime1),staytime1)
			chk2 = chkStr(isNullDefault(rs(1),0),0)
			chk3 = chkStr(isNullDefault(rs(2),staytime2),staytime2)
			chk4 = chkstr(isNullDefault(rs(3),0),0)

			If Left(chk1,1) = "-" Or Left(chk2,1) = "-" Or Left(chk3,1) = "-" Or Left(chk4,1) = "-" Then
				'저장만 진행
				savetype = "onlysave"
			End If 
			
			If savetype = "onlysave" Then
					setresultfld = " total_result = '0' "			
					rt = 0
			else

				linechk1 = getSeconds(chk1)   - getSeconds(staytime1)
				linechk2 = CDbl(chk2) - bpm1
				linechk3 = getSeconds(chk3) - getSeconds(staytime2)
				linechk4 = CDbl(chk4) - bpm2

				'***저장후 최종체크로 변경 변경 ***
				If CDbl(linechk1) > 0 Or CDbl(linechk2) > 0 Or CDbl(linechk3) > 0 Or CDbl(linechk4) > 0  Then
					setresultfld = " total_result = '200' "
					rt = 200
				Else
					setresultfld = " total_result = '0' "						
					rt = 0
				End If
			End if

		End if

		If CDbl(loopcnt) = 3 Then

			chk1 = chkStr(isNullDefault(rs(0),staytime1),staytime1)
			chk2 = chkStr(isNullDefault(rs(1),0),0)
			chk3 = chkStr(isNullDefault(rs(2),staytime2),staytime2)
			chk4 = chkstr(isNullDefault(rs(3),0),0)

			chk5 = chkstr(isNullDefault(rs(4),staytime3),staytime3)
			chk6 = chkstr(isNullDefault(rs(5),0),0)

			If Left(chk1,1) = "-" Or Left(chk2,1) = "-" Or Left(chk3,1) = "-" Or Left(chk4,1) = "-"  Or Left(chk5,1) = "-" Or Left(chk6,1) = "-" Then
				'저장만 진행
				savetype = "onlysave"
			End If 
			
			If savetype = "onlysave" Then
					setresultfld = " total_result = '0' "			
					rt = 0
			else			

				linechk1 = getSeconds(chk1)   - getSeconds(staytime1)
				linechk2 = CDbl(chk2) - bpm1
				linechk3 = getSeconds(chk3) - getSeconds(staytime2)
				linechk4 = CDbl(chk4) - bpm2
				linechk5 = getSeconds(chk5) - getSeconds(staytime3)
				linechk6 = CDbl(chk6) - bpm3

				If CDbl(linechk1) > 0 Or CDbl(linechk2) > 0 Or CDbl(linechk3) > 0 Or CDbl(linechk4) > 0 Or CDbl(linechk5) > 0 Or CDbl(linechk6) > 0  Then
					setresultfld = " total_result = '200' "
					rt = 200
				Else
					setresultfld = " total_result = '0' "			
					rt = 0
				End If

			End if

		End if

	End If 


	SQL = "update sd_gameMember_geegoo Set "& setresultfld & "  where GameMemberIDX = " &  idx
	'Response.write sql
	'Response.end
	Call db.execSQLRs(SQL , null, ConStr)


	If savetype <> "onlysave" Then
		If gametype = "group" Then


			'우리팀 상위 3명꺼 더하기 
			SQL = "select sum(a.ordersortdata),count(*) from (select top 3 cast(ordersortdata as float) as ordersortdata from sd_gameMember_geegoo where total_result < 200 and groupno = "&groupno&" and teamnm = '"&teamnm&"' order by ordersortdata asc ) as a" 
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			sumdata = ""
			mcnt = 0
			If Not rs.eof then
			sumdata = rs(0)
			mcnt = rs(1) '대상 명수 3명이상이여야 된다. 3이하이면 순위대상제외 0으로 설정?
			End if

			If CDbl(mcnt) > 2 Then
				'소팅정보 업데이트 , 개별정도 업데이트 하고 ,
				SQL = "update sd_gameMember_geegoo set groupsortdata = '"&sumdata&"' where  groupno = "&groupno&" and teamnm = '"&teamnm&"' "
				Call db.execSQLRs(SQL , null, ConStr)
			Else
				SQL = "update sd_gameMember_geegoo set groupsortdata = '0' where  groupno = "&groupno&" and teamnm = '"&teamnm&"' "
				Call db.execSQLRs(SQL , null, ConStr)
			End if

			'total_grouporder
			'단체순위와 개별 순위를 각각 넣자..

			'결과를 산정할때 우리팀의 높은수 3명

			'단체전 : 팀원 중 가장 높은 점수를 받은 3명의 선수 최 종 기록을 합산한 점수로 최종 순위를 결정하며, 동점일 경 우 팀원 중 3번째 선수의 기록이 가장 좋은 팀을 따져서 순 위를 결정함. 팀의 구성원이 3인이 되지 않을 경우, 팀 등급 판정 대상에서 제외됨 
			
			'3명이상인 조만 가져온다.
			'각 높은순으로 3명의 점수를  with 절 활용

			wherestr = " isnull(groupsortdata,'0') > 0 and groupno = " & groupno    '업데이트 대상 (R, E 는 대상 )
			Selecttbl = "( SELECT total_grouporder,DENSE_RANK()  OVER (Order By groupsortdata asc) AS RowNum FROM sd_gameMember_geegoo where "&wherestr&" ) AS A "
			SQL = "UPDATE A  SET A.total_grouporder = A.RowNum FROM " & selecttbl
			Call db.execSQLRs(SQL , null, ConStr)




		Else '개인순위

			'순위 산정  -- or ( tryoutresult in ('r','e') )) 
			wherestr = " total_result <= 300 and groupno = " & groupno    '업데이트 대상 (R, E 는 대상 )

			Selecttbl = "( SELECT total_order,RANK() OVER (Order By case when total_result > 200 then 200 else total_result end asc, ordersortdata asc) AS RowNum FROM sd_gameMember_geegoo where "&wherestr&" ) AS A "
			SQL = "UPDATE A  SET A.total_order = A.RowNum FROM " & selecttbl
			Call db.execSQLRs(SQL , null, ConStr)

		End if
	End if
	
	Call oJSONoutput.Set("RT",rt) '결과처리
	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	db.Dispose
	Set db = Nothing


%>