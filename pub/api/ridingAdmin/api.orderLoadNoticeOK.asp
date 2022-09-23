<%
'#############################################

'일정관리 수정

'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" Then
		r_idx = oJSONoutput.IDX 'tblRGameLevel 인덱스
	End if

	If hasown(oJSONoutput, "SNO") = "ok" Then
		r_sno = oJSONoutput.SNO '클릭된곳의 sortno
	End if

	If hasown(oJSONoutput, "NOIDX") = "ok" Then
		r_noidx = oJSONoutput.SNO '공지 인덱스 (부라면 0)
	End if


	If hasown(oJSONoutput, "PARR") = "ok" then
		parr= oJSONoutput.PARR
		reqarr = Split(parr,",")
		
		r_gameno = reqarr(0) '게임순서번호 gbidx처럼사용

		p_2 = reqarr(1) '위에추가(U) , 아래추가(D)
		p_3 = reqarr(2) '시작시간
		p_4 = reqarr(3) '종료시간
		p_5 = reqarr(4) '일정명칭
	End if


	Set db = new clsDBHelper 

	fld = " gameday,okYN,gameTitleIDX,GbIDX "
	SQL = "Select " & fld &  " from tblRGameLevel where RGameLevelidx = " & r_idx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arrNo = rs.GetRows()
		If IsArray(arrNo)  Then
			i_gameday = arrNo(0, 0)
			i_okYN = arrNo(1, 0)
			i_tidx = arrNo(2, 0)
			i_gbidx = arrNo(3, 0)

			i_date = Left(i_gameday, 10)
		End if
	End If
	rs.close



	'부별조정 완료여부 확인 전체 (한개라도 있으면 안됨)
	SQL = "select gameno from tblRGameLevel where gameTitleIDX = '"&i_tidx&"'  and  okYN = 'N' and delYN = 'N' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof  Then
		Call oJSONoutput.Set("result", "20" ) '수정시 세부종목 변경 불가
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.write "`##`"
		rs.close
		Set rs = Nothing
		db.Dispose
		Set db = Nothing
		Response.End			
	End if


	starttime = i_date & " " & setTimeFormat(P_3& ":00")
	endtime = i_date & " " & setTimeFormat(P_4& ":00")	
	notitle = htmlEncode(p_5)

	SQL = "update tblGameNotice set sdatetime = '"&starttime&"' , edatetime = '"&endtime&"' , noticetitle = '"&notitle&"'  where  idx = " &  r_noidx
	Call db.execSQLRs(SQL , null, ConStr)
  

	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson


  Set rs = Nothing
  db.Dispose
  Set db = Nothing


%>


