<%
'##################
'선택박스 바꿈
'##################

	SelectObject_IDX = oJSONoutput.SELECTOBJECT.IDX
	ChangeObject_IDX = oJSONoutput.CHANGEOBJECT.IDX

	SelectObject_SORTNO = oJSONoutput.SELECTOBJECT.SORTNO
	ChangeObject_SORTNO = oJSONoutput.CHANGEOBJECT.SORTNO

    Call oJSONoutput.Set("RESET", "notok" )

	levelno = oJSONoutput.S3KEY
	tidx = oJSONoutput.TitleIDX


	sellID = oJSONoutput.T_DIVID

	sellinfo = Split(sellID , "_")
	rd = sellinfo(1)


	SelectObject_Round = rd
	SelectObject_Sort =  SelectObject_SORTNO
	ChangeObject_Round = rd
	ChangeObject_Sort =  ChangeObject_SORTNO

	Set db = new clsDBHelper

	'1라운드만 편성가능하다.
	If CDbl(rd) > 1 Then
		  Call oJSONoutput.Set("result", 1000 )
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson

		  db.Dispose
		  Set db = Nothing	
		  Response.end
	End if


	'소팅번호 중복값 체크
		strWhere = " GameTitleIDX = "&tidx&" and gamekey3 = "& levelno & " and gubun in (2,3)  and Round = 1"
		SQL = "SELECT sortno,count(*) FROM sd_TennisMember  WHERE delYN = 'N' and " & strWhere & " group by sortNO"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.EOF Then 
			arrSt = rs.getrows()
		End If

		If IsArray(arrSt) Then
			For ar = LBound(arrSt, 2) To UBound(arrSt, 2)
				sortno = arrSt(0, ar) 
				sortcnt = arrSt(1, ar)
				
				If sortno = 0 Then
					Exit for
				End if

				If CDbl(sortcnt) > 1 Then
					'전체 제편성 후 다시 돌려보냄? 아님 0으로 그럼 화면 갱신중에 다시 번호부여하자.
					SQL = " UPDATE sd_TennisMember  SET SortNo = 0 WHERE delYN = 'N' and " & strWhere & " and sortNo = " & sortno
					Call db.execSQLRs(strSql , null, ConStr)

					Call oJSONoutput.Set("result", 1001 )
					strjson = JSON.stringify(oJSONoutput)
					Response.Write strjson

					db.Dispose
					Set db = Nothing
					Response.end
				End if
			Next
		End If 
	'소팅번호 중복값 체크


'####
		IF CDbl(SelectObject_IDX) > 0  Then '0 이면 빈박스
			'IDX로 SORT정보 가져오기 
			SQL = "SELECT TOP 1 Round, SortNo FROM sd_TennisMember  WHERE gameMemberIDX  = '" & SelectObject_IDX & "'"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			
			If Not rs.eof Then
				SelectObject_Round = rs("Round")
				SelectObject_Sort = rs("SortNo")
			END If
		End if
	

		IF CDbl(ChangeObject_IDX) > 0  THEN
			SQL = "SELECT TOP 1 Round, SortNo FROM sd_TennisMember  WHERE gameMemberIDX  = '" & ChangeObject_IDX & "'"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			
			If Not rs.eof Then
				ChangeObject_Round = rs("Round")
				ChangeObject_Sort = rs("SortNo")
			END IF
		End if
'####


	'라운드가 같거나 0이 아닌 경우 
	'0이면 데이터를 못 불러온거에요.
	IF(  (CDbl(SelectObject_Round) > 0 and CDbl(ChangeObject_Round) > 0 ) and (CDbl(SelectObject_Round) = CDbl(ChangeObject_Round)) ) Then

		IF CDbl(SelectObject_IDX) > 0  Then '0 이면 빈박스
			strSql = " UPDATE sd_TennisMember "
			strSql = strSql & " SET SortNo = '" & ChangeObject_Sort & "' , areaChanging = case when areaChanging='Y'  then 'N' else 'Y' end "
			strSql = strSql & " WHERE gameMemberIDX = '" &  SelectObject_IDX & "'"
			Call db.execSQLRs(strSql , null, ConStr)
		END IF

		IF CDbl(ChangeObject_IDX) > 0  THEN
			strSql = " UPDATE sd_TennisMember "
			strSql = strSql & " SET SortNo = '" & SelectObject_Sort & "'"
			strSql = strSql & " WHERE gameMemberIDX = '" &  ChangeObject_IDX & "'"
			Call db.execSQLRs(strSql , null, ConStr)
		END IF
	END IF

  Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing
%>
