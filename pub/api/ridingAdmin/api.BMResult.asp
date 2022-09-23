<%
'#############################################
'복합마술 경기결과 생성
'#############################################

	'request
	If hasown(oJSONoutput, "KGAME") = "ok" Then '체전여부 A 두번복사여부
		r_kgame= oJSONoutput.KGAME
	End If

	If hasown(oJSONoutput, "TIDX") = "ok" then
		r_tidx= oJSONoutput.TIDX
	End If
	If hasown(oJSONoutput, "GBIDX") = "ok" then
		r_gbidx= oJSONoutput.GBIDX
	End If
	
	If hasown(oJSONoutput, "GBIDX2") = "ok" then
		r_gbidx2= oJSONoutput.GBIDX2
	End If

	If hasown(oJSONoutput, "GAMETYPE") = "ok" Then 'gbidx2의 경기 형태 마장마술인지 아닌지 판다.... MM
		r_gametype= oJSONoutput.GAMETYPE
	End If

	'장애물이 어떤걸까
	If r_gametype = "MM" Then
		'첫번째 gbidx 가 장애물
		JGB =  " ( gamekey3 = "&r_gbidx&" ) "
		MGB = " ( gamekey3 = "&r_gbidx2&" ) "
		updategbidx = r_gbidx
	Else
		'두번째 gbidx 가 장애물
		JGB =  " ( gamekey3 = "&r_gbidx2&" ) "
		MGB = " ( gamekey3 = "&r_gbidx&" ) "
		updategbidx = r_gbidx2
	End if

	
	'2라운드로 생성하자....( 0으로 할까 했는데 재경기가 없단다)

	nextrdno = CDbl(r_rdno) + 1 '생성할 라운드번호
	nowrdno = r_rdno '현재라운드

	Set db = new clsDBHelper 

	'#####################
	'생성된게 있으면 지우고
	Sub checkBMResult()
		Dim SQL, rs, gbidx
		SQL = "select gamekey3 from sd_tennisMember where gametitleidx = "&r_tidx&" and  gamekey3 in ("&r_gbidx& ","&r_gbidx2&")  and round = 2 "

		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If Not rs.eof Then
			 ''존재한다 삭제
			 gbidx = rs(0)
			SQL = "delete from sd_TennisMember_partner where gamememberidx in (select gamememberidx from sd_tennisMember where gametitleidx = "&r_tidx&" and  gamekey3 = "&gbidx&"  and round = 2)"
			Call db.execSQLRs(SQL , null, ConStr)
			SQL = "delete from sd_TennisMember where gametitleidx = "&r_tidx&" and  gamekey3 = "&gbidx&"  and round = 2"
			Call db.execSQLRs(SQL , null, ConStr)
		End if
	End sub


	'다음라운드 출전 순서 표 생성
	Sub saveRoundMember(midx,orderno,rndno)
		Dim insertfield,selectfield,newmidx, SQL ,rs
		'재경기로 현재내용 복사(새로운 round) 한후 출전순서 생성
		insertfield = "gubun,gametime,gametimeend,place,GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,key3name,t_win,t_tie,t_lose,t_rank,SortNo,TeamANa,TeamBNa,DelYN,Sex,Courtno,requestIDX,pubcode,engcode,pubName,orgpubcode,orgengcode,orgpubname   ,tryoutresult "

		If rndno = "2" Then '1라운드의 인덱스값을 가질수 있도록 한다.
			selectfield = rndno  & ", tryoutsortNo  ,  gamememberidx, " & insertfield & "  , case when boo_orderno >= 200 then boo_orderno else 0 end , case when total_order >= 200 then total_order else 0 end  "
			selectSQL = "Select top 1 "&selectfield&"  from sd_TennisMember where gameMemberIDX = " & midx & "  "
		Else
			selectfield = rndno  & ", tryoutsortNo  ,  midx1, " & insertfield & "  , case when boo_orderno >= 200 then boo_orderno else 0 end , case when total_order >= 200 then total_order else 0 end  "
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
	Sub saveBMrs(midx,v1,v2,v3,v4,v5, bmscore, gametime) '감점합,총소요시간합,시간감점합,장애감점합
		Dim insertfield,selectfield,newmidx, SQL ,rs
		'재경기로 현재내용 복사(새로운 round) 한후 출전순서 생성
		insertfield = "gubun,gametimeend,place,GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,key3name,t_win,t_tie,t_lose,t_rank,SortNo,TeamANa,TeamBNa,DelYN,Sex,Courtno,requestIDX,pubcode,engcode,pubName,orgpubcode,orgengcode,orgpubname  ,tryoutresult "

		selectfield = v1  & ", "&v2  & ", "&v3  & ", "&v4&", "&v5&", "&bmscore& ",2, tryoutsortNo ,midx1,  " & insertfield& ", '"&gametime&"'  "
		selectSQL = "Select top 1 "&selectfield&"  from sd_TennisMember where gameMemberIDX = " & midx & "  " 'order by pubcode, orgpubcode asc

		SQL = "SET NOCOUNT ON  insert into sd_TennisMember (score_total,score_1,score_2,score_3,score_per,score_total2,      Round,tryoutsortNo, midx1,  "&insertfield&" ,gametime)  "&selectSQL&" SELECT @@IDENTITY"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		newmidx = rs(0)

		'파트너 insert
		insertfield  = " gameMemberIDX,PlayerIDX,userName,TeamANa,TeamBNa "
		selectfield =  " "&newmidx&",PlayerIDX,userName,TeamANa,TeamBNa "
		SQL = "insert into sd_TennisMember_partner ("&insertfield&")  select top 1 " & selectfield & " from sd_TennisMember_partner where gameMemberIDX  =  " & midx 
		Call db.execSQLRs(SQL , null, ConStr)
	End sub


	'결과생성
	Sub saveBMResult(makeround, ordertype)
		'순위의 역순으로 출전순서 생성
		Dim SQL, rs, arrK, ar,rd2_midx,strwhere,arrM,mrs,am,mper,mpidx, rd2_1,rd2_2,rd2_3,rd2_4,rd2_5,jpidx,bmscore, sno, snosub

		'장애물   감점합, 총소요시간, 시간감점, 장애감점
		strwhere = " where delyn = 'N' and GameTitleIDX =  "&r_tidx&" and  "&JGB&" and Round = 1 and gubun < 100  " 
		SQL = "select gameMemberIDX ,isnull(score_total,0) as s, isnull(score_1,0) as t,isnull(score_2,0) as s1,isnull(score_3,0) as s2,playeridx, '0',score_total2,tryoutsortNo  from sd_tennisMember " & strwhere
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		strwhere = " where delyn = 'N' and GameTitleIDX =  "&r_tidx&" and  "&MGB&" and Round = 1 and gubun < 100  " 
		SQL = "select score_per,playeridx,tryoutsortNo, CONVERT(CHAR(19), gametime, 20)  from sd_tennisMember " & strwhere
		Set mrs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If Not mrs.EOF Then
			arrM = mrs.GetRows() '마장마술
		End if

		If Not rs.EOF Then
			arrK = rs.GetRows() '장애물
		
			
			If IsArray(arrK)  Then
				For ar = LBound(arrK, 2) To UBound(arrK, 2)
					rd2_midx = arrK(0, ar) '업데이트 키값
					rd2_1 = arrK(1, ar) '감점합계
					rd2_2 = arrK(2, ar) '총소요시간합
					rd2_3 = arrK(3, ar) '시간감점합
					rd2_4 = arrK(4, ar) '장애감점합
					jpidx = arrK(5,ar) '참애물 참가 인덱스
					sno = arrK(8,ar) '경기순서번호

					For am = LBound(arrM, 2) To UBound(arrM, 2)
						mper = arrM(0, am)
						mpidx = arrM(1, am)
						snosub = arrM(2, am)
						gametime = arrM(3, am)

						'If CStr(jpidx) = CStr(mpidx) Then
						If CStr(sno) = CStr(snosub) Then
							arrK(6,ar)  = mper
							rd2_5 = mper
							'100 - (score_per + score_total) 복합마술 점수 (어떤필드에 넣어야하지 score_total2 에 넣자.)
							arrK(7,ar) = 100 -  CDbl(mper) + CDbl(rd2_1) 
							bmscore = arrK(7,ar)
							Exit for
						End if
					Next 

					Call saveBMrs( rd2_midx , rd2_1,rd2_2,rd2_3,rd2_4,rd2_5, bmscore, gametime )
				Next
				'Call getrowsdrow(arrK)


				'랭킹집계 BM 100 - (score_per + score_total)
				Call orderUpdate( db, r_tidx, updategbidx,  0, 2, "BM") 'pubcode 0 으로 보내면 검색해서 각각 적용 A, A_1
			End if
		End If

	End sub


	'#####################
	'체전 비체전 구분 이야기는 없지만 일단 동일하게 처리

	If r_kgame = "Y" Then '체전

		'1단계 + 2단계 합산으로 출전 순위를 만들어서 결승 생성
		Call checkBMResult() '결과가 있다면 삭제
		Call saveBMResult( nextrdno, r_odrtype)

	Else '비체전

		'1단계 + 2단계 합산으로 출전 순위를 만들어서 결승 생성
		Call checkBMResult() '보낼때 마지막 라운드로 보내니까 올일은 없다 
		Call saveBMResult( nextrdno, r_odrtype)

	End if


  	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson


  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>
