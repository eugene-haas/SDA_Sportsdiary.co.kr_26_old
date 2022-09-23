<%
'#############################################

'대회생성저장

'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" Then
		r_idx = oJSONoutput.IDX
	End if

	If hasown(oJSONoutput, "PARR") = "ok" then
		parr= oJSONoutput.PARR
		reqarr = Split(parr,",")
		p_1 = reqarr(0) '출전순서번호
		p_2 = reqarr(1) '위에추가(U) , 아래추가(D)
		p_3 = reqarr(2) '시작시간
		p_4 = reqarr(3) '종료시간
		p_5 = reqarr(4) '일정명칭
	End if


	Set db = new clsDBHelper 

		fld = " gubun, gametitleidx, gamekey3,  tryoutsortno, tryoutgroupno  , gamekey1,gamekey2,teamgb,key3name,pubcode,pubName,orgpubcode,orgpubname, gametime "
		SQL = "Select " & fld &  " from sd_tennisMember where gameMemberIDX = " & r_idx
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.EOF Then   'tryoutgroupno 소팅
			arrNo = rs.GetRows()
			If IsArray(arrNo)  Then
				i_gubun = arrNo(0, 0)
				i_tidx = arrNo(1, 0)
				i_gbidx = arrNo(2, 0)
				i_sortno = arrNo(3, 0)
				i_noticesortno = arrNo(4, 0)

				i_data1 = arrNo(5, 0)
				i_data2 = arrNo(6, 0)
				i_data3 = arrNo(7, 0)
				i_data4 = arrNo(8, 0)
				i_data5 = arrNo(9, 0)
				i_data6 = arrNo(10, 0)
				i_data7 = arrNo(11, 0)
				i_data8 = arrNo(12, 0)

				i_date = Left(arrNo(13, 0), 10)
			End if
		End If

		starttime = i_date & " " & setTimeFormat(P_3& ":00")
		endtime = i_date & " " & setTimeFormat(P_4& ":00")

		'################
		mysortno = i_sortno
		mygno = i_noticesortno
		tidx = i_tidx
		gbidx = i_gbidx


		'tryoutgroupno > tryoutsortNo 소팅

		If p_2 = "D" Then '아래추가
			wherestr = "  tryoutsortNo=" & mysortno & " and tryoutgroupno > " & mygno & " and gametitleidx = "&tidx & "and gamekey3=" & gbidx & " and round = 1 " 
			SQL = "update sd_TennisMember set tryoutgroupno = tryoutgroupno + 1 where " & wherestr
			Call db.execSQLRs(SQL , null, ConStr)

			insert_sno = mysortno
			insert_gno = CDbl(mygno) + 1

		Else '위에 추가 - 값
			wherestr = "  tryoutsortNo=" & mysortno & " and tryoutgroupno < " & mygno & " and gametitleidx = "&tidx & "and gamekey3=" & gbidx & " and round = 1 " 
			SQL = "update sd_TennisMember set tryoutgroupno = tryoutgroupno - 1 where " & wherestr

			insert_sno = mysortno
			insert_gno = CDbl(mygno) - 1
		End If 



		insertfield = " gubun, GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,key3name,  requestIDX, pubcode,pubname,orgpubcode,orgpubname  "
		insertfield = insertfield & " , gametime, gametimeend , noticetitle ,tryoutsortNo,tryoutgroupno,round "
		insertvalue = " 100, "&i_tidx&", 0, '공지사항', '"&i_data1&"','"&i_data2&"',"&i_gbidx&","&i_data3&",'"&i_data4&"', 0 ,'"&i_data5&"', '"&i_data6&"' ,'"&i_data7&"' , '"&i_data8&"'  "
		insertvalue = insertvalue & " , '"& starttime &"' , '"& endtime &"', '"& p_5  &"'  , '"&insert_sno&"','"&insert_gno&"',  1 "
		SQL = "SET NOCOUNT ON  Insert into sd_TennisMember ("&insertfield&") values ("&insertvalue&")  SELECT @@IDENTITY"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		
		gamemidx = rs(0)	

		insertfield = " GameMemberIDX, PlayerIDX,userName "
		insertvalue = " "&gamemidx&", 0 , '공지사항'   "
		SQL = "Insert into sd_TennisMember_partner ("&insertfield&") values ("&insertvalue&")"
		Call db.execSQLRs(SQL , null, ConStr)		


		
		









		
		'위아래 상태에 따라서 마장마술인 경우 시간 간격으로 뒤로 밀기 (다음 공지 시간은 어떻게 하나)---------------------------------------------
		'gbidx 로 묶인 게임 정보 
		strTableName2 = "  tblRGameLevel as a inner join tblTeamGbInfo as b  ON a.gbidx = b.teamgbidx "
		strfieldA = " a.RGameLevelidx,  b.levelno,b.TeamGbNm,b.ridingclass,b.ridingclasshelp ,a.GameDay,a.GameTime,a.gametimeend  " 
		strFieldName2 = strfieldA 
		strWhere2 = " a.GameTitleIDX = "&tidx&" and a.gbIDX = '"&gbidx&"' and a.DelYN = 'N' and b.DelYN = 'N' "

		SQL = "Select top 1 "&strFieldName2&" from "&strTableName2&" where " & strWhere2
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		'646	20101001	마장마술	b	h	2019-03-19	09:00	20:30

		If Not rs.EOF Then
			arrNo = rs.GetRows()
			If IsArray(arrNo)  Then
				o_ridx = arrNo(0, 0)
				o_levelno = arrNo(1, 0)
				o_levelnm = arrNo(2, 0)
				o_classnm = arrNo(3, 0)
				o_classhelp = arrNo(4, 0)
				o_gamedate = arrNo(5, 0)
			End if
		End If

	'복합마술 타입구분
	'Response.write "#############################################################<br></span>"
	If o_levelnm = "복합마술" Then
		If InStr(o_classnm,"마장마술") > 0 Then
			gametype = "BMMM" '게임형태 복합마술 마장마술
		End If
		If InStr(o_classnm,"장애물") > 0 Then
			gametype = "BMJM" '게임형태 복합마술 마장마술
		End if			
	End if
	'Response.write "#############################################################<br></span>"


		If o_levelnm = "마장마술"  Or gametype = "BMMM"   Then

			plusn = getGameTime(o_classnm)

'			'시작시간은 o_stime
'			'클레스명은 o_classnm
'			Select Case Left(LCase(o_classnm),1)
'			Case "s" :	plusn = 8 '8분
'			Case "a" :	plusn = 7 '7분
'			Case "b" :	plusn = 6 '6분
'			Case "c" :	plusn = 6 '6분
'			Case "d" :	plusn = 7 '7분
'			Case "f" :	plusn = 6 '6분
'			Case Else :	plusn = 6 '6분 (오류안나게)
'			End select


				'endtime  '공지이후 시작시간
				If p_2 = "D" Then '아래추가
					SQL = "Select gameMemberIDX,gubun,tryoutsortno,tryoutresult,gametimeend,gametime from SD_tennisMember  where gametitleidx = " & tidx & " and delYN = 'N' and gamekey3 = '"&gbidx&"' and tryoutsortno > " & insert_sno &" and round=1 order by tryoutsortno asc , tryoutgroupno asc"

				Else '위
					SQL = "Select gameMemberIDX,gubun,tryoutsortno,tryoutresult,gametimeend,gametime from SD_tennisMember  where gametitleidx = " & tidx & " and delYN = 'N' and gamekey3 = '"&gbidx&"' and tryoutsortno >= "& insert_sno &" and round=1 order by tryoutsortno asc , tryoutgroupno asc"
				End If
				
				Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)
				If Not rss.EOF Then
					arrNo2 = rss.GetRows()
				End If
				rss.close	

				nextdatetime = endtime
				i = 1
				If IsArray(arrNo2)  Then
					For ar2 = LBound(arrNo2, 2) To UBound(arrNo2, 2)
						u_midx = arrNo2(0, ar2) '업데이트 키값
						u_gubun = arrNo2(1,ar2) '공지 100
						u_sno = arrNo2(2,ar2) 
						u_rt = isNullDefault(arrNo2(3,ar2),"") '상태 (기권 w 상태 파악을 위해서넣음)
						u_noticetimeend = arrNo2(4,ar2) '공지 설정된 끝시간

						If CDbl(u_gubun) = 100 And CStr(u_sno) > CStr(insert_sno) Then
							'여기서 끝내야할꺼같은데
							'nextdatetime = u_noticetimeend
							'i = 1
							Exit for
						End if


						If CDbl(u_gubun) < 100  then
						'다음 공지 사항이 나올때 까지 시간 조정
							If u_rt = "w" Then '경기전 기권이라면 
								nextdatetime = nextdatetime
							else
								If i = 1 then
									nextdatetime = nextdatetime
								Else
									nextdatetime = o_gamedate & " " & getNextTime(nextdatetime, plusn ) '날짜 시간, 간격
								End If
								i = i + 1
							End if

							SQL = "update SD_tennisMember Set gametime = '"&nextdatetime&"', gubun = 1 where gameMemberIDX = " & u_midx
							Call db.execSQLRs(SQL , null, ConStr)
						End If
						
					Next
				End if



				'마장마술 생성된 마지막 시간을 앞의  출전순서 경기종료 시간으로 설정해준다.
				SQL = "Select top 1 gametime from SD_tennisMember  where gametitleidx = " & tidx & " and delYN = 'N' and gamekey3 = '"&gbidx&"' and gubun < 100 and round=1 order by tryoutsortno desc"
				Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)
				If Not rss.EOF Then
					arrNo2 = rss.GetRows()
				End If
				rss.close	
		
				If IsArray(arrNo2)  Then
				For ar2 = LBound(arrNo2, 2) To UBound(arrNo2, 2)
						lasttime = arrNo2(0,ar2) '게임시간
				next
				End If

				nextdatetime =  getNextTime(lasttime, plusn ) '날짜 시간, 간격
				SQL = "update tblRGameLevel set gametimeend = '"&Left(nextdatetime,5)&"'  where gametitleidx ='"&tidx&"'  and gbidx = '"&gbidx&"' "
				Call db.execSQLRs(SQL , null, ConStr)

		End if



	
	'####################################################################

  find_gbidx = i_gbidx
  tidx = i_tidx
  'find_gbidx   'tidx필요
  %><!-- #include virtual = "/pub/html/riding/sclist.asp" --><%


  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>
