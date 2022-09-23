<%
'#############################################
'대회생성저장
'#############################################

	'request
	If hasown(oJSONoutput, "KGAME") = "ok" Then '체전여부 A 두번복사여부
		r_kgame= oJSONoutput.KGAME
	End If
	
	If hasown(oJSONoutput, "RDNO") = "ok" then'장애물 A 라운드 별 계산에 필요
		r_rdno= oJSONoutput.RDNO
	End If

	If hasown(oJSONoutput, "TIDX") = "ok" then
		r_tidx= oJSONoutput.TIDX
	End If
	If hasown(oJSONoutput, "GBIDX") = "ok" then
		r_gbidx= oJSONoutput.GBIDX
	End If
	
	If hasown(oJSONoutput, "MIDXS") = "ok" then
		midxs= oJSONoutput.MIDXS
		midxarr = Split(midxs,",")
	End if
	
	If hasown(oJSONoutput, "ORTYPE") = "ok" then
		r_odrtype= oJSONoutput.ORTYPE
	End if

	
	
	nextrdno = CDbl(r_rdno) + 1 '생성할 라운드번호
	nowrdno = r_rdno '현재라운드

	Set db = new clsDBHelper 

	'#####################
	'다음라운드 출전 순서 표 생성
	Sub saveRoundMember(midx,orderno,rndno)
		Dim insertfield,selectfield,newmidx, SQL ,rs
		'재경기로 현재내용 복사(새로운 round) 한후 출전순서 생성
		insertfield = "gubun,gametime,gametimeend,place,GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,key3name,t_win,t_tie,t_lose,t_rank,SortNo,TeamANa,TeamBNa,DelYN,Sex,Courtno,requestIDX,pubcode,engcode,pubName,orgpubcode,orgengcode,orgpubname "	',tryoutresult "

		'기본 선택해서 온애들은 순서번호를 그대로 가진다. Kgame과 구분해야한다. 중요

		If rndno = "2" Then '1라운드의 인덱스값을 가질수 있도록 한다.
			If r_kgame = "Y" then
			selectfield = rndno  & ", "& orderno &"  ,  gamememberidx, " & insertfield & "  , case when boo_orderno >= 200 then boo_orderno else 0 end , case when total_order >= 200 then total_order else 0 end  "
			else
			selectfield = rndno  & ", tryoutsortNo  ,  gamememberidx, " & insertfield & "  , case when boo_orderno >= 200 then boo_orderno else 0 end , case when total_order >= 200 then total_order else 0 end  "
			End if
			selectSQL = "Select top 1 "&selectfield&"  from sd_TennisMember where gameMemberIDX = " & midx & "  "
		Else
			If r_kgame = "Y" then
			selectfield = rndno  & ", "& orderno &"  ,  midx1, " & insertfield & "  , case when boo_orderno >= 200 then boo_orderno else 0 end , case when total_order >= 200 then total_order else 0 end  "
			Else
			selectfield = rndno  & ", tryoutsortNo  ,  midx1, " & insertfield & "  , case when boo_orderno >= 200 then boo_orderno else 0 end , case when total_order >= 200 then total_order else 0 end  "
			End if
			selectSQL = "Select top 1 "&selectfield&"  from sd_TennisMember where gameMemberIDX = " & midx & "  "
		End If
		
		SQL = "SET NOCOUNT ON  insert into sd_TennisMember (Round,tryoutsortNo  ,midx1    ,"&insertfield&",boo_orderno,total_order)  "&selectSQL&" SELECT @@IDENTITY"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		newmidx = rs(0)

		'파트너 insert
		insertfield  = " gameMemberIDX,PlayerIDX,userName,TeamANa,TeamBNa "
		selectfield =  " "&newmidx&",PlayerIDX,userName,TeamANa,TeamBNa "
		SQL = "insert into sd_TennisMember_partner ("&insertfield&")  select top 1 " & selectfield & " from sd_TennisMember_partner where gameMemberIDX  =  " & midx 
		Call db.execSQLRs(SQL , null, ConStr)
	End Sub
	
	'결승 결과값을 저장해서 생성한다.
	Sub saveKResult(midx,orderno,rndno  ,v1,v2,v3,v4) '감점합,총소요시간합,시간감점합,장애감점합
		Dim insertfield,selectfield,newmidx, SQL ,rs
		'재경기로 현재내용 복사(새로운 round) 한후 출전순서 생성
		insertfield = "gubun,gametime,gametimeend,place,GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,key3name,t_win,t_tie,t_lose,t_rank,SortNo,TeamANa,TeamBNa,DelYN,Sex,Courtno,requestIDX,pubcode,engcode,pubName,orgpubcode,orgengcode,orgpubname	,tryoutresult "

		selectfield = v1  & ", "&v2  & ", "&v3  & ", "&v4  & ", " & rndno  & ", "& orderno &"  ,midx1 , " & insertfield& "  , case when boo_orderno >= 200 then boo_orderno else 0 end , case when total_order >= 200 then total_order else 0 end,3  " 
		selectSQL = "Select top 1 "&selectfield&"  from sd_TennisMember where gameMemberIDX = " & midx & "  " 'order by pubcode, orgpubcode asc

		SQL = "SET NOCOUNT ON  insert into sd_TennisMember (score_total,score_1,score_2,score_3,         Round,tryoutsortNo, midx1,  "&insertfield&" ,boo_orderno,total_order,gamest)  "&selectSQL&" SELECT @@IDENTITY"
		
'Response.write sql
'Call rsdrow(rs)
'Response.end

		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		newmidx = rs(0)

		'파트너 insert
		insertfield  = " gameMemberIDX,PlayerIDX,userName,TeamANa,TeamBNa "
		selectfield =  " "&newmidx&",PlayerIDX,userName,TeamANa,TeamBNa "
		SQL = "insert into sd_TennisMember_partner ("&insertfield&")  select top 1 " & selectfield & " from sd_TennisMember_partner where gameMemberIDX  =  " & midx 
		Call db.execSQLRs(SQL , null, ConStr)
	End sub


	Sub checkMakeRound()
		Dim SQL, rs

		SQL = "select round from sd_tennisMember where gametitleidx = "&r_tidx&" and  gamekey3 = "&r_gbidx&"  and round = " & nextrdno
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If Not rs.eof Then
			Call oJSONoutput.Set("result", "40" ) ''존재한다 삭제후 다시 해라....경고
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Set rs = Nothing
			db.Dispose
			Set db = Nothing
			Response.End
		End if
	End sub

	'K라운드 2경기 생성
	Sub saveKRoundMember(makeround, ordertype)
		'순위의 역순으로 출전순서 생성
		Dim SQL, rs, arrK, ar,rd2_midx,strwhere

		Select Case CStr(makeround)
		Case "2" '2단계라운드 생성
			SQL = "select gameMemberIDX from sd_tennisMember where gametitleidx = "&r_tidx&" and  gamekey3 = "&r_gbidx&"  and round = 1 and gubun < 100  order by total_order desc, tryoutsortno asc" 'and tryoutresult  in ( '0','R') 기권자도 복사
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		
			If Not rs.EOF Then
				arrK = rs.GetRows()
				If IsArray(arrK)  Then
					For ar = LBound(arrK, 2) To UBound(arrK, 2)
						rd2_midx = arrK(0, ar) '업데이트 키값
						Call saveRoundMember( rd2_midx , ar+1, nextrdno)
					Next
				End if
			End If

		Case "3" '결승 결과 생성 (합을 다넣어주어야한다.)   'K 순위가 중복이라면 1라운드의 순위로 순서를 부여한다.
			'having sort     score_total asc, score_1 asc
			'strwhere = " where a.delyn = 'N' and a.GameTitleIDX =  "&r_tidx&" and  a.gamekey3 = "&r_gbidx&" and a.Round = 1 and b.Round = 2 and a.gubun < 100  order by s,t " 'a.tryoutresult  in( '0','R') and  b.tryoutresult  in( '0','R') 기권자도 복사는 하자.
			
			strwhere = " where a.delyn = 'N' and a.GameTitleIDX =  "&r_tidx&" and  a.gamekey3 = "&r_gbidx&" and a.Round = 1 and b.Round = 2 and a.gubun < 100  order by b.tryoutsortno asc " 'a.tryoutresult  in( '0','R') and  b.tryoutresult  in( '0','R') 기권자도 복사는 하자.

			'SQL = "select b.gameMemberIDX ,isnull((a.score_total+b.score_total),0) as s, isnull((isnull(a.score_1,0)+isnull(b.score_1,0)),0) as t,isnull((isnull(a.score_2,0)+isnull(b.score_2,0)),0) as s1,isnull((isnull(a.score_3,0)+isnull(b.score_3,0)),0) as s2  from sd_tennisMember as a inner join sd_tennisMember as b ON a.requestIDX = b.requestIDX  "&strwhere

			SQL = "select b.gameMemberIDX ,isnull((a.score_total+b.score_total),0) as s, case when a.tryoutresult = '0' then isnull(a.score_1,0) else isnull(b.score_1,0) end as t,isnull((isnull(a.score_2,0)+isnull(b.score_2,0)),0) as s1,isnull((isnull(a.score_3,0)+isnull(b.score_3,0)),0) as s2  from sd_tennisMember as a inner join sd_tennisMember as b ON a.requestIDX = b.requestIDX  "&strwhere
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


			If Not rs.EOF Then
				arrK = rs.GetRows()
				If IsArray(arrK)  Then
					For ar = LBound(arrK, 2) To UBound(arrK, 2)
						rd2_midx = arrK(0, ar) '업데이트 키값
						rd2_1 = arrK(1, ar) '감점합계
						rd2_2 = arrK(2, ar) '총소요시간합 > 1라운드의 소요시간 으로 넣음 1라운드가 실권일 경우 2라운드로 넣음
						rd2_3 = arrK(3, ar) '시간감점합
						rd2_4 = arrK(4, ar) '장애감점합

						Call saveKResult( rd2_midx , ar+1, nextrdno,rd2_1,rd2_2,rd2_3,rd2_4 )
					Next



					'랭킹집계 A_1 도
					Call orderUpdate( db, r_tidx, r_gbidx,  0, nextrdno, ordertype) 'pubcode 0 으로 보내면 검색해서 각각 적용 A, A_1

						'K 순위가 중복이라면 1라운드의 순위로 순서를 부여한다. 루프돌면서 중복 순위가 있다면 ㅜㅜ
						SQL = ";with sameordertbl as ( "
						SQL = SQL & "	Select gamememberidx,playeridx,boo_orderno, total_order from sd_tennisMember  where delyn='N' and round = 3 and gametitleidx = "&r_tidx&" and gamekey3 = "&r_gbidx&" and total_order in  "
						SQL = SQL & "	( SELECT total_order  count from sd_tennismember where delyn = 'N' and round = 3 and gametitleidx = "&r_tidx&" and gamekey3 = "&r_gbidx&" and tryoutresult not in ('r','e')  GROUP BY  total_order	Having	COUNT(*) > 1	 )  "
						SQL = SQL & " ),  "
						SQL = SQL & " newsorttbl as  "
						SQL = SQL & "	( Select  a.gamememberidx,a.playeridx,a.boo_orderno as orderB, a.total_order as order3 , b.total_order as order1  from sameordertbl as a inner join sd_tennisMember as b  "
						SQL = SQL & "   on a.playeridx = b.playeridx where b.round = 1 and b.gametitleidx = "&r_tidx&" and b.gamekey3 = "&r_gbidx&" ) "

						SQL = SQL & "UPDATE A  SET A.order3 = (A.order3 + A.RowNum - 1), A.orderB = (A.order3 + A.RowNum - 1)  FROM "
						SQL = SQL & "	(SELECT orderB,  order3,order1,RANK() OVER (partition by order3 Order By order3,order1) AS RowNum    FROM newsorttbl ) AS A "
						Call db.execSQLRs(SQL , null, ConStr)

				End if
			End If

		End Select 

	End sub



	'#####################




	'체전인경우 round 1 > 순위 대로 뒤집어서 출전순서 만듬  round 2 > 1단계 + 2단계 합산으로 출전 순위를 만들어서 결승 생성 round3 선택 해서 재경기 할지 말지 결정

	If r_kgame = "Y" Then '체전
		Select Case CDbl(nextrdno)
			Case 2
				'2라운드 순위의 역순으로 출전순서 생성 해서 복사
				Call checkMakeRound() '보낼때 마지막 라운드로 보내니까 올일은 없다 
				Call saveKRoundMember(nextrdno , r_odrtype)

			Case 3
				'1단계 + 2단계 합산으로 출전 순위를 만들어서 결승 생성
				Call checkMakeRound() '보낼때 마지막 라운드로 보내니까 올일은 없다 
				Call saveKRoundMember( nextrdno, r_odrtype)

			Case 4
				'재경기 1회
				Call checkMakeRound() '보낼때 마지막 라운드로 보내니까 올일은 없다 
				For n = 0 To ubound(midxarr)
					Call saveRoundMember( midxarr(n) , n+1, nextrdno)
				Next
			Case 5
				'재경기 2회
				Call checkMakeRound() '보낼때 마지막 라운드로 보내니까 올일은 없다 
				For n = 0 To ubound(midxarr)
					Call saveRoundMember( midxarr(n) , n+1, nextrdno)
				Next
			Case Else
				'2라운드 이상 없슴 공지.
		End Select 

	Else '비체전

		Select Case CDbl(nextrdno)
			Case 2
				'재경기 1회
				Call checkMakeRound() '보낼때 마지막 라운드로 보내니까 올일은 없다 
				For n = 0 To ubound(midxarr)
					Call saveRoundMember( midxarr(n) , n+1, nextrdno)
				Next
			Case 3
				'재경기 2회
				Call checkMakeRound() '보낼때 마지막 라운드로 보내니까 올일은 없다 
				For n = 0 To ubound(midxarr)
					Call saveRoundMember( midxarr(n) , n+1, nextrdno)
				Next
			Case Else
				'2라운드 이상 없슴 공지.
		End Select 

	End if


  	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson


  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>
