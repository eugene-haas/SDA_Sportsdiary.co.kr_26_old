<%
'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
''본선대진 다시적용
'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

	idx = oJSONoutput.IDX 
	tidx = oJSONoutput.TitleIDX
	levelno = oJSONoutput.S3KEY
	areanm = oJSONoutput.AreaNM

	Set db = new clsDBHelper

	'#######################################

	jooidx = CStr(tidx) & CStr(levelno) '생성된 추첨룰키
	lastroundcheck = Right(levelno,3)

	'If lastroundcheck = "007" Then '최종라운드 예외처리
	If lastroundcheck = "007" And  areanm = "최종라운드"  Then
		Call oJSONoutput.Set("result", "0" )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Set db = Nothing
		Response.end		
	End if

	
	Sub updateTSortNo(ByVal arrRS, ByVal rank, ByVal rndno1, ByVal rndno2, ByVal joono, ByVal midx )
      Dim r_orderno , r_sortno, r_joono ,r_abc, i    '순위번호 자리위치, 추첨번호

      If IsArray(arrRS) Then '랜덤번호

        For i = LBound(arrRS, 2) To UBound(arrRS, 2) 
			r_orderno = arrRS(0, i)  '0 ,1, 2 순위 0은 bye
			r_sortno = arrRS(1, i)    '자리 번호
			r_joono  = arrRS(2, i)    '추첨번호
		    r_abc = arrRS(7,i) '경기진행 조ABC

			If  CDbl(r_orderno) = Cdbl(rank) Then '순위번호비교

				Select Case CDbl(r_orderno)
				Case 1
				  If CDbl(r_joono)  = CDbl(rndno1) Then
					SQL = "update sd_TennisMember set sortno = " & r_sortno & " ,ABC = '"& r_abc &"' where gameMemberIDX = " & midx
					Call db.execSQLRs(SQL , null, ConStr)
					Exit for            
				  End if
				Case 2
				  If CDbl(r_joono)  = CDbl(rndno2) Then
					SQL = "update sd_TennisMember set sortno = " & r_sortno & " ,ABC = '"& r_abc &"' where gameMemberIDX = " & midx
					Call db.execSQLRs(SQL , null, ConStr)
					Exit for
				  End if
				End Select 
			
			End If
        Next

      End If

    End Sub



	'#######################################
	strtable = " sd_TennisMember "
	strtablesub =" sd_TennisMember_partner "
	strtablerull = " sd_TennisKATARullMake "

	'본선대진편성규칙 가져오기
		SQL = "Select orderno,sortno,joono,mxjoono,idx   ,gang,round,ABC from "&strtablerull&"  where mxjoono = '" & jooidx & "' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)	
		If rs.eof Then
			Call oJSONoutput.Set("result", "9090" ) '본선시드가 없슴 예외처리
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Set db = Nothing
			Response.end		
		else
			drowCnt=rs("gang")
			depthCnt = rs("round")
		   arrRND = rs.GetRows()    
		End if

	'부전, -- 삭제
		SQL = "Delete From "&strtable&" Where playerIDX in (0,1) and  Round= 1 and GameTitleIDX = '"&tidx&"' and gamekey3= '"&levelno&"'"
		Call db.execSQLRs(SQL , null, ConStr)	

	'모두 sortno = 0 update
		SQL = "Update "&strtable&" Set sortno = 0 where  GameTitleIDX = '" & tidx & "' and  gamekey3 = " & levelno & " and round = 1 "
		Call db.execSQLRs(SQL , null, ConStr)	


	'부전 생성
		If IsArray(arrRND) Then '랜덤번호

			For i = LBound(arrRND, 2) To UBound(arrRND, 2) 
				r_orderno = arrRND(0, i)  '0 ,1, 2 순위 0은 bye
				r_sortno = arrRND(1, i)    '자리 번호
				r_joono  = arrRND(2, i)    '추첨번호

				If CDbl(r_orderno) = 0 Then '부전자리라면
					insertfield = " gubun,GameTitleIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,key3name,Round,SortNo"
					insertvalue = "3  ,"&tidx&",'부전','tn001001',201,"&levelno&","&Left(levelno,5)&",'--',1," & r_sortno 
					SQL = "insert into "&strtable&" ("&insertfield&") values ("&insertvalue&")"
					Call db.execSQLRs(SQL , null, ConStr)	
				End if
			Next

		  End If

		'올라온 애들 소팅번호 업데이트
		strwhere = " GameTitleIDX = "&tidx&" and  gamekey3 = "&levelno&" and gubun in (2,3)  and Round = 1 and playerIDX > 1 and sortNo = 0"  '부전 -- 삭제 되었슴....
		SQL = "SELECT gameMemberIDX , userName,t_rank,rndno1,rndno2,tryoutgroupno,gubun FROM  " &strtable&   " where " & strWhere & " and sortNo = 0  ORDER BY gameMemberIDX ASC"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		n = 0
		Do Until rs.EOF 
		   midx = rs("gameMemberIDX")
		   rank = rs("t_rank")
		   rndno1 = rs("rndno1")
		   rndno2 = rs("rndno2")
		   joono = rs("tryoutgroupno")
		   gubun = rs("gubun")
		   username = rs("username")
			Call updateTSortNo(arrRND,  rank, rndno1,rndno2,joono, midx) 
		rs.movenext
		n = n + 1
		Loop
		Set rs = Nothing


	'빈자리 생성
		strWhere = " GameTitleIDX = "&tidx&" and gamekey3 = "& levelno & " and gubun in (2,3)  and Round = 1 and sortNO > 0 "
		SQL = "SELECT sortno FROM  " &strtable&"  WHERE delYN = 'N' and " & strWhere & " order by sortNO asc"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If Not rs.EOF Then 
			arrSt = rs.getrows()
		End If	

		reDim temsortnoarr(drowCnt)'빈소팅 번호 찾기
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
					insertfield = " gubun,playerIDX,GameTitleIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,key3name,Round,sortno "
					insertvalue = "3  ,1,"&tidx&",'--','tn001001',201,"&levelno&","&Left(levelno,5)&",'--',1," & temsortnoarr(n)
					SQL = "insert into "&strtable&" ("&insertfield&") values ("&insertvalue&")"
					Call db.execSQLRs(SQL , null, ConStr)	
			End if
		Next
		End if


		'모두 구분값 3으로 편성완료 시킨다.
		SQL = "Update "&strtable&" Set gubun = 3 where  GameTitleIDX = '" & tidx & "' and  gamekey3 = " & levelno & " and round = 1 "
		Call db.execSQLRs(SQL , null, ConStr)	


	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
	db.Dispose
	Set db = Nothing
%> 