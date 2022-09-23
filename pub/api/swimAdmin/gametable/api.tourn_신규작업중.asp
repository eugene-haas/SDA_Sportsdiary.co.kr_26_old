<%
'#############################################
'대진표 리그 화면 준비 
'#############################################

'request
idx = oJSONoutput.IDX
tidx = oJSONoutput.TitleIDX
title = oJSONoutput.Title
teamnm = oJSONoutput.TeamNM
areanm = oJSONoutput.AreaNM
poptitle = title & " " & teamnm & " (" & areanm & ")  예선 대진표"
resetflag = oJSONoutput.RESET 'ok를 받으면 sortNo를 0으로 업데이트 한다.

onemore = oJSONoutput.ONEMORE


Call oJSONoutput.Set("T_MIDX", 0 )
Call oJSONoutput.Set("T_SORTNO", 0 )
Call oJSONoutput.Set("T_DIVID", 0 )

Call oJSONoutput.Set("T_ATTCNT", 0 )
Call oJSONoutput.Set("T_NOWRD", 0 )
Call oJSONoutput.Set("T_RDID", 0 )
Call oJSONoutput.Set("S3KEY", 0 )

Call oJSONoutput.Set("SCIDX", 0 ) '결과테이블 인덱스
Call oJSONoutput.Set("POS", 0 )

Set db = new clsDBHelper


'타입 석어서 보내기
Call oJSONoutput.Set("result", "0" )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson
Response.write "`##`"

'기본정보#####################################
	strtable = "sd_TennisMember"
	strtablesub =" sd_TennisMember_partner "
	strtablesub2 = " tblGameRequest "
	strresulttable = " sd_TennisResult "

	SQL = " Select EntryCnt,attmembercnt,courtcnt,level,lastjoono,bigo,chkJooRull from   tblRGameLevel  where    DelYN = 'N' and  RGameLevelidx = " & idx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof then
		entrycnt = rs("entrycnt")					'참가제한인원수
		attmembercnt = rs("attmembercnt")		'참가신청자수
		courtcnt = rs("courtcnt")					'코트수
		levelno = rs("level")							'레벨
		lastjoono = rs("lastjoono")					'마지막에 편성된 max 조번호
        bigo=rs("bigo")
		chkJooRull = rs("chkJooRull")	'YN 추첨적용여부
		poptitle = poptitle & " <span style='color:red'>- 모집: " & entrycnt &" , - 신청 : " &  attmembercnt & " - 코트수 : " & courtcnt & "</span>"
        if bigo <>"" then 
        poptitle = poptitle & " <p><span style='color:blue'> ※공지글※</span><p><p<span>"&bigo&"</span><p>"
        end if 

		If Left(levelno,3) = "200" Then
			joinstr = " left "
			singlegame =  true
		Else
			joinstr = " inner "
			singlegame = false
		End if
	End if
'기본정보#####################################

'재추첨##############
	If resetflag = "ok" Then
		SQL = "delete from sd_TennisMember where (GameTitleIDX = "&tidx&" and gamekey3 = "& levelno & " and Round > 1) or ( Round =1 and userName = '부전')"
		Call db.execSQLRs(SQL , null, ConStr)
		
		SQL = "delete FROM sd_tennisResult where  gubun = 1 and  GameTitleIDX = "&tidx&"  and level = "& levelno & " " 'gubun = 1 본선
		Call db.execSQLRs(SQL , null, ConStr)

		
		strWhere = " GameTitleIDX = "&tidx&" and gamekey3 = "& levelno & " and gubun in (2,3)  and Round = 1"
		SQL = "update sd_TennisMember set sortno = 0,gubun=2,areaChanging='N' WHERE delYN = 'N' and " & strWhere 
		Call db.execSQLRs(SQL , null, ConStr)
	End if
'재추첨##############

'예선총명수로 참가자 명수 확정
	strWhere = " GameTitleIDX = "&tidx&" and gamekey3 = "& levelno & " and gubun in (0, 1)  and DelYN = 'N' "
	SQL = "SELECT  COUNT(*) as gcnt,max(tryoutgroupno) from "&strtable&" where "&strWhere
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	tcnt = 0
	attmembercnt = 0
	joono = 1

	If CDbl(rs(0)) > 0 Then
		attmembercnt = rs("gcnt")			'총참가자(sorting 마지막 번호)
		joono = rs(1)	'조번호
		tcnt = CDbl(joono) * 2				'토너먼트 총참가자
	End If
	
	
	If CDbl(joono) = CDbl(lastjoono) Then
	
	Else '크거나 작다면 예선에서 조가 줄었거나 커진경우 ( sortno 초기화)
		SQL = " Update tblRGameLevel Set lastjoono = "&joono&" where DelYN = 'N' and  RGameLevelidx = " & idx
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		strWhere = " GameTitleIDX = "&tidx&" and gamekey3 = "& levelno & " and gubun in (2,3)  and Round = 1"
		SQL = "Update sd_TennisMember  Set sortNo = 0 WHERE delYN = 'N' and " & strWhere 
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	End if
'예선총명수로 참가자 명수 확정

'강수 계산##############
	if tcnt <=2 then
	drowCnt = 2
	depthCnt = 2
	elseif tcnt >2 and tcnt <=4 then
	drowCnt = 4
	depthCnt = 3
	elseif tcnt >4 and tcnt <=8 then
	drowCnt=8
	depthCnt = 4
	elseif tcnt >8 and  CDbl(tcnt) <=16 then
	drowCnt=16
	depthCnt = 5
	elseif tcnt >16 and  tcnt <=32 then
	drowCnt=32
	depthCnt = 6
	elseif tcnt >32 and  tcnt <=64 then
	drowCnt=64
	depthCnt = 7
	elseif tcnt >64 and  tcnt <=128 then
	drowCnt=128
	depthCnt = 8
	elseif tcnt >128 and  tcnt <=256 then
	drowCnt=256
	depthCnt = 9
	end if 
'강수 계산##############

'예선정보
'#############################
	strwhere = " a.GameTitleIDX = "&tidx&" and  a.gamekey3 = "&levelno&" and a.tryoutgroupno > 0 and a.gubun = 1 and a.t_rank in (1,2)"
	strsort = " order by a.tryoutgroupno asc, a.t_rank asc" '결과순
	strAfield = " a. gamememberIDX, a.userName , a.tryoutgroupno, a.tryoutsortno, a.teamAna , a.teamBNa , a.tryoutstateno, a.t_rank,a.key3name "
	strBfield = " b.partnerIDX, b.userName, b.teamANa  , b.teamBNa , b.positionNo     ,a.rndno1,a.rndno2 "
	strfield = strAfield &  ", " & strBfield 
	SQL = "select max(a.tryoutgroupno) from  " & strtable & " as a "& joinstr &" JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  where " & strwhere 
	'Response.Write  "SQL 설명 : 예선 마지막 조 번호를 가져온다  " & "</br>"	
	'Response.Write SQL & "</br>"	
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	maxgno = rs(0) '편성완료된

	'Response.Write  "마지막 조 번호 :" & maxgno & "</br>"	
	'Response.Write "</br>"	
	
	SQL = "select "& strfield &" from  " & strtable & " as a "& joinstr &" JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  where " & strwhere & strsort
	'Response.Write  "SQL 설명 : 예선 결과가 1위, 2위인 예선 대진표를 가져온다.   " & "</br>"	
	'Response.Write SQL & "</br>"	
	'Response.Write "</br>"	
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


	If Not rs.EOF Then 
	arrL = rs.getrows()
	End If
'#############################



'최대값 보다 크다면 모두 0으로 초기화
strWhere = " GameTitleIDX = "&tidx&" and gamekey3 = "& levelno & " and gubun in (2,3)  and DelYN = 'N' and Round = 1"
SQL = "update " &strtable&   " set gubun=0 where " & strWhere & " and sortNo > "& drowCnt
Call db.execSQLRs(SQL , null, ConStr)



	'=============

	Sub updateSortNo(ByVal arrRS, ByVal rank, ByVal rndno1, ByVal rndno2, ByVal joono, ByVal midx )
		Dim r_orderno , r_sortno, r_joono

		If IsArray(arrRS) Then

			For i = LBound(arrRS, 2) To UBound(arrRS, 2) 
				r_orderno = arrRS(0, i) 
				r_sortno = arrRS(1, i) 
				r_joono  = arrRS(2, i) 

				If CDbl(rndno1) > 0 And CDbl(rndno2) > 0 Then '복사가 정상적으로 되었다면
				If CDbl(r_joono) = CDbl(joono) And CDbl(r_orderno) = Cdbl(rank) Then
						SQL = "update sd_TennisMember set sortno = " & r_sortno & " where gameMemberIDX = " & midx
						Call db.execSQLRs(SQL , null, ConStr)
					Exit for
				End If
				End if
			Next
		End If
	End Sub



	Sub TempMember(arrRND)
		strWhere = " GameTitleIDX = "&tidx&" and gamekey3 = "& levelno & " and gubun in (2,3)  and Round = 1"
		SQL = "SELECT sortno FROM sd_TennisMember  WHERE delYN = 'N' and " & strWhere & " order by sortNO asc"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.EOF Then 
			arrSt = rs.getrows()
		End If	

		'빈소팅 번호 찾기
		reDim temsortnoarr(drowCnt)
		tempi= 0
		For i = 1 To drowCnt
			tempsortno = tempno(arrST, i) '공통함수에 req 페이지에 존재
			If tempsortno > 0 then
				temsortnoarr(tempi) = tempsortno
				tempi = tempi + 1
			End if
		next	

		If temsortnoarr(0) <> "" Then '빈곳이 없는경우
		For n = 0 To ubound(temsortnoarr)
			If temsortnoarr(n) = "" Or isNull(temsortnoarr(n)) = True Then
				Exit For
			Else
				'부전 인서트
				insertfield = " gubun,GameTitleIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,key3name,Round "
				selectfield = TOURNSTART &  ",GameTitleIDX,'부전',gamekey1,gamekey2,gamekey3,TeamGb,key3name,Round"
				selectSQL = "Select top 1 "&selectfield&"  from sd_TennisMember where Round= 1 and gubun in (2,3) and GameTitleIDX = "&gameTitleIDX&" and gamekey3= " & gamekey3
				SQL = "SET NOCOUNT ON  insert into "&strtable&" ("&insertfield&")  "&selectSQL&" SELECT @@IDENTITY"
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				midx = rs(0)
				'파트너 insert
				insertfield  = " gameMemberIDX,userName "
				selectfield = " "&midx&",'부전' "
				SQL = "insert into "&strtablesub&" ("&insertfield&")  values ("&selectfield&")"
				Call db.execSQLRs(SQL , null, ConStr)
			End if
		Next
		End If
	End Sub





	SQL = "SELECT gameMemberIDX,t_rank,rndno1,rndno2,tryoutgroupno,gubun,userName FROM  " &strtable&   " where " & strWhere & " and sortNo = 0  ORDER BY gameMemberIDX ASC"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

Call rsDrow(rs)	

	If Not rs.EOF Then 
		arrR0 = rs.GetRows()
	End If
	

	'추첨룰 가져오기
		SQL = "select orderno,sortno,joono,mxjoono,idx from sd_TennisKATARull where mxjoono = " & joono '마지막조번호
		Set rsrndno = db.ExecSQLReturnRS(SQL , null, ConStr)		
		'Call rsDrow(rsrndno)
		If Not rsrndno.EOF Then 
			arrRND = rsrndno.GetRows()
		End if
	'추첨룰 가져오기


	If chkJooRull = "N" Then '추첨룰이 없는경우

	Else
		If IsArray(arrR0) Then
		'추첨룰 
		If IsArray(arrRND) Then

			indatachk = false
			For i = LBound(arrRND, 2) To UBound(arrRND, 2) 
				r_orderno = arrRND(0, i) 
				r_sortno = arrRND(1, i) 
				r_joono  = arrRND(2, i)  '랜덤조번호

				For m = LBound(arrR0, 2) To UBound(arrR0, 2) 
					 midx = arrR0(0, m) 
					 rank = arrR0(1, m) 
					 rndno1 = arrR0(2, m) 
					 rndno2 = arrR0(3, m) 
					 joono = arrR0(4, m) 

					If CDbl(rndno1) > 0 And CDbl(rndno2) > 0 Then '복사가 정상적으로 되었다면
					If CDbl(r_orderno) = Cdbl(rank) Then
						If (CDbl(r_orderno) = 1 And CDbl(r_joono) = Cdbl(rndno1)) Or (CDbl(r_orderno) = 2 And CDbl(r_joono) = Cdbl(rndno2))  Then
							SQL = "update sd_TennisMember set sortno = " & r_sortno & " where gameMemberIDX = " & midx
							Call db.execSQLRs(SQL , null, ConStr)
							indatachk = true
						Exit for
						End if					
					End If
					End If
				Next

				If indatachk = False Then
					'룰맴버 생성
					If CDbl(r_orderno) = 0 Then
						'부전
						insertfield = " gubun,GameTitleIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,key3name,Round,sortno  "
						insertvalue = " 2, "&tidx&", '부전','tn001001',"&Left(levelno,3)&",	"&levelno&","&Left(levelno,5)&",'"&teamnm&"',1,"&r_sortno&" "
						SQL = "SET NOCOUNT ON  insert into "&strtable&" ("&insertfield&") values  ("&insertvalue&") SELECT @@IDENTITY"
						Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
						midx = rs(0)
						'파트너 insert
						insertfield  = " gameMemberIDX, userName "
						insertvalue = " "&midx&", '부전' "
						SQL = "insert into "&strtablesub&" ("&insertfield&")  values ("&insertvalue&")"
						Call db.execSQLRs(SQL , null, ConStr)
					else
						insertfield = " gubun,PlayerIDX,GameTitleIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,key3name,Round,sortno  "
						insertvalue = " 2, 1, "&tidx&", '"& r_joono &"_"& r_orderno &"','tn001001',"&Left(levelno,3)&",	"&levelno&","&Left(levelno,5)&",'"&teamnm&"',1,"&r_sortno&" "
						SQL = "SET NOCOUNT ON  insert into "&strtable&" ("&insertfield&") values  ("&insertvalue&") SELECT @@IDENTITY"
						Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
						midx = rs(0)
						'파트너 insert
						insertfield  = " gameMemberIDX, PlayerIDX, userName "
						insertvalue = " "&midx&",1, '"& r_joono &"_"& r_orderno &"' "
						SQL = "insert into "&strtablesub&" ("&insertfield&")  values ("&insertvalue&")"
						Call db.execSQLRs(SQL , null, ConStr)
					End if
				End if
				
			Next
		End If
		End if
	End if






'		n = 0
'		Do Until rs.EOF 
'			'빈곳에 룰에 맞추어 번호 부여
'			 midx = rs("gameMemberIDX")
'			 rank = rs("t_rank")
'			 rndno1 = rs("rndno1")
'			 rndno2 = rs("rndno2")
'			 joono = rs("tryoutgroupno")
'			 gubun = rs("gubun")
'			 username = rs("username")
'
'			Call updateSortNo(arrRND,  rank, rndno1,rndno2,joono, midx)
'
''			'편성완료후 부전편성 
''			If gubun = "3" And username = "부전" then
''				strSql = "UPDATE " &  strtable & " SET "
''				strSql = strSql & " sortNo = " & temsortnoarr(n)
''				strSql = strSql & " WHERE gameMemberIDX = " & rs("gameMemberIDX")
''				Call db.execSQLRs(strSql , null, ConStr)
''			End if
'		rs.movenext
'		n = n + 1
'		Loop
'		Set rs = Nothing
'
'		'나머지 빈공간에 추첨룰번호로 맴버 생성
'		Call TempSortNo(arrRND,  rank, rndno1,rndno2,joono, midx)
'	End if

'#############


'소팅번호 부여
'#############
'	strWhere = " GameTitleIDX = "&tidx&" and gamekey3 = "& levelno & " and gubun in (2,3)  and Round = 1"
'	SQL = "SELECT sortno FROM sd_TennisMember  WHERE delYN = 'N' and " & strWhere & " order by sortNO asc"
'	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'
'	If Not rs.EOF Then 
'		arrSt = rs.getrows()
'	End If
'
'
'	'빈소팅 번호 찾기
'	reDim temsortnoarr(drowCnt)
'	tempi= 0
'	For i = 1 To drowCnt
'		tempsortno = tempno(arrST, i) '공통함수에 fn_tennis.asp
'		If tempsortno > 0 then
'			temsortnoarr(tempi) = tempsortno
'			tempi = tempi + 1
'		End if
'	next

'	If temsortnoarr(0) <> "" Then '빈곳이 있다면 (0번인 소팅번호가 있다면) 추첨룰에 맞춰서 넣어보자...
'	End if	












'본선정보
'#############################
	strwhere = " a.GameTitleIDX = " & tidx & " and  a.gamekey3 = " & levelno  & " and gubun >= "&TOURNSET&"  " 'TOURNSET 2 본선대기 3 본선입력완료
	strsort = " order by a.Round asc,a.SortNo asc"

	strAfield = " a. gamememberIDX, a.userName,a.teamAna, a.teamBNa, a.Round, a.SortNo  "
	strBfield = " b.userName, b.teamAna, b.teamBNa,a.gubun,a.areaChanging,a.PlayerIDX,a.rndno1,a.rndno2,t_rank,tryoutgroupno "
	strfield = strAfield &  ", " & strBfield

	SQL = "select "& strfield &" from  " & strtable & " as a "&joinstr&" JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  where " & strwhere & strsort
	'Response.Write  "SQL 설명 : 본선 대진표를 가져온다. 강수 오름차순   " & "</br>"	
	'Response.Write SQL & "</br>"	
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	rscnt =  rs.RecordCount

	If Not rs.EOF Then 
	arrT = rs.getrows()
	End If
'#############################
	

	'스코어 입력 정보 가져오기
	'#############################
		strwhere = " a.GameTitleIDX = " & tidx & " and a.gamekey3 = " & levelno  & " and a.gubun >= "&TOURNSET&" " 'a.gubun 상태  0예선, 1 예선종료 gubun 2 본선 올라감 3 본선 대진표 설정완료
		strsort = " order by  a.Round asc, a.SortNo asc"
		strAfield = " a.Round , a.SortNo , a. gamememberIDX  " '열 인덱스(기준)
		strBfield = " b.gameMemberIDX2 , b.resultIDX , b.stateno ,winResult,b.courtno " '인덱스 , 짝수 인덱스(대상) ,게임상태 ( 2, 진행 , 1, 종료)
		strfield = strAfield &  ", " & strBfield 

		SQL = "select "& strfield &" from  " & strtable & " as a INNER JOIN " & strresulttable & " as b ON a.gameMemberIDX = b.gameMemberIDX1   where " & strwhere & strsort
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.EOF Then 
			arrRS = rs.GetRows() 'RIDX, CIDX, GSTATE
		End if

	'#############################

	'본선 정보, 스코어 정보 function
	'#############################
		Sub drowCourt(ByVal rd, ByVal sno)
			Dim selectstr, userstr,usercolor,strjson,usecourt,courtstate,m,c,i
			Dim r_rdno,r_sno,r_idx,r_stateno,resultIDX,r_court,r_courtno
			
			If IsArray(arrRS) Then
				For i = LBound(arrRS, 2) To UBound(arrRS, 2) 
					r_rdno = arrRS(0, i) 
					r_sno = arrRS(1, i)
					r_idx = arrRS(4, i)
					r_stateno = arrRS(5, i)
					r_court = arrRS(7, i)
					If rd = r_rdno And sno = r_sno Then
						resultIDX = r_idx
						r_courtno = r_court
						Exit for
					End if
				Next
			End if
			%>
				<%'If CDbl(x) > CDbl(lineno) then%>
					<select id="c_<%=rd%>_<%=sno%>" style="width:100px;"  onchange='mx.SetCourt(<%=strjson%>)'>
					<%
					If resultIDX = "" Then
						resultIDX = 0
					End if
					oJSONoutput.SCIDX = resultIDX
					oJSONoutput.POS = "c_" & rd & "_" & sno
					strjson = JSON.stringify(oJSONoutput)		

					For m = 1 To courtcnt
						selectstr = ""
						usestr = ""
						usecolor = ""

						If IsArray(useCourtRS) Then
							For c = LBound(useCourtRS, 2) To UBound(useCourtRS, 2) 
								usecourt = useCourtRS(0, c) 
								courtstate =  useCourtRS(1, c) 
								If m = CDbl(usecourt) And m <> CDbl(r_courtno)  then
									If courtstate = "1" Then
									usestr = "종료"
									usecolor = " style='color:red'"
									else
									usestr = "사용"			'사용중
									usecolor = " style='color:orange'"
									End if
								End If
								If m = CDbl(r_courtno) Then
									selectstr = "selected"	'선택된
									usestr = "선택"			'선택중
									usecolor = " style='color:green'"
								End if
							Next
						End If

						%><option value="<%=m%>" <%=selectstr%> <%=usecolor%>><%=m%>번 <%=usestr%></option><%
					Next

					%>
					</select>	
				<!-- <a href='javascript:mx.SetCourt(<%=strjson%>)' class="btn_a" style="text-align:center;width:50px;">OK</a> -->

				<%'End if%>
		<%
		End sub
		
		
		Sub tournInfo(ByVal arrRS , ByVal rd , ByVal sortno, ByVal arrRT)
			Dim ar ,m1idx,m1name,m1teamA,m1teamB,mrd,msortno,m2name,m2teamA,m2teamB,mgubun,marchange
			Dim chkmember,nextround,nr,nextmember,nr_m1name,m1pidx,nr_sortno,temp_sortno
			Dim mrndno1,mrndno2,mrndno,mtrank,mtryoutgroupno
			chkmember = False
			nextmember = False '다음 라운드 진출여부
			temp_sortno = 0
			
			If IsArray(arrRS) Then

				For ar = LBound(arrRS, 2) To UBound(arrRS, 2)
					m1pidx			= arrRS(11, ar) 
					m1idx				= arrRS(0, ar) 
					m1name			= arrRS(1, ar)  
					m1teamA			= arrRS(2, ar) 
					m1teamB			= arrRS(3, ar) 
					mrd					= arrRS(4, ar) 
					msortno			= arrRS(5, ar) 
					m2name			= arrRS(6, ar) 
					m2teamA			= arrRS(7, ar) 
					m2teamB			= arrRS(8, ar) 
					mgubun			= arrRS(9, ar) 
					mchange			= arrRs(10,ar)
					nextround		= CDbl(mrd) + 1


					mrndno1			= arrRs(12,ar)
					mrndno2			= arrRs(13,ar)
					mtrank			= arrRs(14,ar)
					mtryoutgroupno = arrRs(15,ar)
					If CDbl(mtrank) = 1 Then
						mrndno = mrndno1
					Else
						mrndno = mrndno2
					End if
					


					If CDbl(rd) = CDbl(mrd) And CDbl(msortno) = CDbl(sortno) Then
						chkmember = true
						'화면 그림
							oJSONoutput.T_MIDX = m1idx
							oJSONoutput.T_NOWRD = rd
							oJSONoutput.T_SORTNO = sortno
							oJSONoutput.T_DIVID = "cell_"&rd&"_"&sortno
							oJSONoutput.S3KEY = levelno
							strjson = JSON.stringify(oJSONoutput)
							%>
								<%If CDbl(rd) = 1 then%>
								<div id="no_<%=rd%>_<%=sortno%>" style="flex:1;height:100%;background:<%If mchange = "Y"  then%>#99A5DF<%else%>#C7E61D<%End if%>;"><%=mtryoutgroupno%><br><%=mtrank%><br> <%=mrndno%></div>
								<%End if%>

								<div id="cell_<%=rd%>_<%=sortno%>" style="flex:10;height:100%;background:<%If mchange = "Y"  then%>#E0E7EF<%else%>#E5E5E5<%End if%>;">
								<a name="<%=m1name%>_<%=rd%>"></a>
								
								<%'If mgubun = "3" Or CDbl(rd) > 1 Then '고정%>
								<%If CDbl(rd) > 1 Then '고정%>
									<%If m1name = "부전" then%>
										<span style="color:blue;"><%=m1name%></span>
									<%else%>
										<%=m1name%> & <%=m2name%>
									<%End if%>
								<%else%>
									<%If m1name = "부전" then%>
									<a href='javascript:mx.tournChangeSelectArea(<%=strjson%>)'><span style="color:blue;"><%=m1name%></span><%=mgubun%></a>
									<%else%>
										<a href='javascript:mx.tournChangeSelectArea(<%=strjson%>)'><%=m1name%> & <%=m2name%></a>
									<%End if%>
								<%End if%>
								
								<br>
								<%If Fix(sortno mod 2) = 1 then%>
								<%'Call drowCourt(rd, sortno) '코트입력 부분%>
								<%End if%>

								<%If mgubun = "3" Then '편성완료라면%>
									<%If CDbl(mrd) > 1 then%>
										<!-- <a href="#" class="btn_a">취소</a> -->
									<%End if%>
										
										<%
											'진행중이라면 물어보자(결과값이 있는지)
											'Dim rt , r_sno,r_ridx,r_stno
											'If IsArray(arrRT) Then
											'	For rt = LBound(arrRT, 2) To UBound(arrRT, 2)
											'			r_rd		= arrRT(0,rt)
											'			r_sno 	= arrRT(1,rt)
											'			r_ridx 	= arrRT(4,rt)
											'			r_stno	= arrRT(5,rt)
											'		If rd = r_rd And sortno = r_sno Then
											'			
											'		End if
											'	next
											'End if

											'다음 라운드 진출자로 등록 되었는지 확인
											temp_sortno = 0
											For nr = LBound(arrRS, 2) To UBound(arrRS, 2)
												nr_mrd	= arrRS(4, nr)
												nr_sortno	= arrRS(5, nr) 
												nr_m1name		= arrRS(1, nr) 

												If CDbl(sortno) Mod 2 = 1 Then
													temp_sortno = CDbl(sortno) +1
												Else 
													temp_sortno = sortno
												End If
												temp_sortno = Fix(CDbl(temp_sortno) /2)

												If  CDbl(temp_sortno) = CDbl(nr_sortno) And CDbl(nr_mrd) = CDbl(nextround) Then '다음 라운드 소트 번호에 값이 있다면
													nextmember = true
													Exit for
												End If
												temp_sortno = 0
											next
											
											Call oJSONoutput.Set("result", 0 )
											strjson = JSON.stringify(oJSONoutput)
										%>

										<%If m1name <> "부전"   And nextmember =  false then%>
											<a href='javascript:mx.SetTournGameResult(<%=strjson%>)' class="btn_a">승</a>

											<%If Fix(sortno mod 2) = 1 then%>
											<br><%Call drowCourt(rd, sortno) '코트입력 부분%>
											<%End if%>

										
										<%else%>
											<%If nr_m1name = m1name And m1name <> "부전"  Then '진출자라면%>
												<span class="winnercell">승리</span>
											<%End if%>
										<%End if%>
										<%
										nextmember = False
										%>
								<%End if%>
								</div>
							<%
						Exit for
					End if
				Next
				
				If chkmember = False And CDbl(rd) = 1 And CDbl(mgubun)= 2 Then '편성완료 전이라면
					
					oJSONoutput.T_MIDX = 0
					oJSONoutput.T_SORTNO = sortno
					oJSONoutput.T_DIVID = "cell_"&rd&"_"&sortno
					oJSONoutput.S3KEY = levelno
					strjson = JSON.stringify(oJSONoutput)					
					%>
					<div id="no_<%=rd%>_<%=sortno%>" style="flex:1;height:100%;background:#C7E61D;"><%=sortno%></div>					
					<div id="cell_<%=rd%>_<%=sortno%>" style="flex:10;height:100%;"><a href='javascript:mx.tournChangeSelectArea(<%=strjson%>)'>빈박스</a></div><%
				End if


			End If

		End Sub
		
		Function gubunColor(ByVal arrRS, ByVal rd)
			Dim ar,mgcolor
			If IsArray(arrRS) Then

				mgcolor = "green"
				For ar = LBound(arrRS, 2) To UBound(arrRS, 2)
					mrd					= arrRS(4, ar) 
					mgubun			= arrRS(9, ar) 

					If CDbl(rd) = CDbl(mrd) Then
							If mgubun = "3" Then '편성후
								mgcolor = "#965F41"
								Exit for
							End if
					End If
				Next
			End If

			gubunColor = mgcolor
		End function
	
		Sub resultInfo(ByVal resultKey)

		End sub

	'#############################



    dim Dicgubun
    Set Dicgubun = Server.CreateObject("Scripting.Dictionary")

		


''타입 석어서 보내기
'Call oJSONoutput.Set("result", "0" )
'strjson = JSON.stringify(oJSONoutput)
'Response.Write strjson
'Response.write "`##`"


'#############################################


'부전 결과 자동라운드 생성 >  페이지 호출
'	If onemore = "notok" then
	reqstr = "?REQ={""CMD"":20000,""IDX"":"""&tidx&""",""S1"":""tn001001"",""S2"":"&Left(levelno,3)&",""S3"":"&levelno&",""TT"":1,""SIDX"":0}"
	source = Stream_BinaryToString( GetHTTPFile("http://tennis.sportsdiary.co.kr/pub/ajax/reqtennis.asp"&reqstr) , "utf-8" )
	'Response.write source
'End if


%>
<div class='modal-header'><button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
<h3 id='myModalLabel'><%=poptitle%></h3>
<h2><%=poptitle_sub%></h2>
<h2><%=poptitle_sub1%></h2>
<h2 id="sqlquery"></h2>

<!-- #include virtual = "/pub/api/swimAdmin/gametable/api.gameCourt.asp" -->
</div> 

<div class='modal-body'>

<table border="0">
   <thead>
	  <tr>
        <th id="gametableTh"  id="gametableTd" ><h2>예선결과  <a href="javascript:$('#loadmsg').text('&nbsp;다시 추첨 중.....');mx.tournament(<%=idx%>,'<%=teamnm%>','<%=areanm%>','reset')" class = "btn_a" style="border:1px solid black">1라운드 편성 초기화</a></h2></th> 
        <th style="width:3px;font-size:3px;"></th>
		<th width="*" style="padding-left: 310px; text-align: left;"><h2>본선대진  <a href="javascript:$('#loadmsg').text('&nbsp;새로 고침 중.....');mx.tournament(<%=idx%>,'<%=teamnm%>','<%=areanm%>')" class = "btn_a" style="border:1px solid black">새로고침</a><span id="loadmsg"></span></h2></th>	  
	  </tr>
   </thead>


   <tbody>
    <tr>

	<%'예선#################%>
		<td >
			<div class="title_scroll">
			<table border="1" width="300" class="table-list" id="gametable">
              <thead>
                <tr><th>조</th><th  colspan="2">1위</th><th  colspan="2">2위</th></tr>
              </thead>
              <tr>

				<tbody>
					<%
						IF ISNULL(maxgno) Then
						maxgno = 0
						END IF
						
					For joo =1 To maxgno
						teamcnt = 0
						rtcnt = 0
						Response.write "<tr>"
						Response.write "<td>"&joo&"</td>"
					
						If IsArray(arrL) Then
							r = 1
							For ar = LBound(arrL, 2) To UBound(arrL, 2) 
								aname		= arrL(1, ar) 
								groupno	= arrL(2, ar) 
								sortno		= arrL(3, ar) 
								bname		= arrL(10, ar) 
								rankno		= arrL(7, ar) 
								rndno1		= arrL(14, ar) 
								rndno2		= arrL(15, ar) 


								If CDbl(joo) = CDbl(groupno) Then
									teamcnt = teamcnt + 1
									%>
										<%
										If r = 1 And CDbl(rankno) = 2 then%>
										<td style="width:30px;">&nbsp;</td>
										<td><span class="player" style="color:orange">진출전</span></td>
										<%
										teamcnt = teamcnt + 1
										End If
										%>
										<td style="width:30px;"><%If CDbl(rankno) = 1 then%><span style="color:red;"><%=rndno1%></span><%else%><%=rndno2%><%End if%></td>
										<td><span class="player"><a href="#<%=aname%>_1" class="btn_a"> <%=aname%><br><%=bname%></a></span></td>
									<%						
									r = r + 1
									End If
							Next
						End If				

						For n = 1 To 2- CDbl(teamcnt) 
							%><td style="width:30px;">&nbsp;</td><td><span class="player">&nbsp;</span><span class="belong">&nbsp;</span></td><%
						Next						

						Response.write "</tr>"					
					tempjoo = groupno
					Next
					%>
				</tr>
				</tbody>
			</table>
			</div>
        </td>
	<%'예선#################%>


		<td style="width:3px;font-size:3px;"></td>
	<%'본선#################%>		
		<td>
          <table class="tourney_admin <%=drowCnt%>" id ="tourney_admin" border="0">

			<thead>
              <tr>
                    <%For i = 1 To depthCnt
						If i = 1 then
							roundcnt = Fix(drowCnt)
						Else
							roundcnt = Fix(roundcnt/2)
						End if
					%>
					<th>
                        <span>
                            <a href="javascript:;" class="btn btn-group-sm" data-collap="<%=depthcollap %>"><%=roundcnt%></a>
                        </span>
                        <span id="set_Round_<%=i %>">
							<%
							oJSONoutput.T_ATTCNT = roundcnt
							oJSONoutput.T_NOWRD = i
							oJSONoutput.T_RDID = "set_Round_"&i
							oJSONoutput.S3KEY = levelno
							strjson = JSON.stringify(oJSONoutput)							
							 rdcolor = gubunColor(arrT,i)
							 If rdcolor = "green" then
								btnstr = "편성완료"
							 Else
								btnstr = "재편성"
							 End if
							%>
                            <a class="btn_a"   id="set_Round_a<%=i %>"  href='javascript:mx.tornGameIn(<%=strjson%>)'><%=btnstr%></a> 
                        </span>
                    </th>
					<%Next%>
              </tr>
            </thead>

            <tbody>
                <tr>
                    <%For i = 1 To depthCnt
						If i = 1 then
							roundcnt = Fix(drowCnt)
						Else
							roundcnt = Fix(roundcnt/2)
						End If
						%>

						<td id="<%=i%>_row" style="padding:0px;">
								<%For n = 1 To roundcnt%>
									<div style="width:100%;border:1px solid <%=gubunColor(arrT,i)%>;padding:0px;margin:0px;">
										<%' 행 열을 가진 함수호출 내용 가져와 서 그림%>
										<%Call tournInfo(arrT, i, n, arrRS)%>
									</div>
								<%next%>
                        </td>
                    <%Next%>
                </tr>
            </tbody>
          </table>
        </td>
	<%'본선#################%>
    </tr>
   </tbody>
</table>


</div>




<!-- #include virtual = "/pub/api/swimAdmin/gametable/inc.tournbtn.asp" --><%

db.Dispose
Set db = Nothing
%>
