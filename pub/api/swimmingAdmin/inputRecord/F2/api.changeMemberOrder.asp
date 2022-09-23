<%
'#############################################

'상세종목 불러오기

'#############################################
	'request
	listlidx = oJSONoutput.Get("LIDX") '실지편성된곳
	lidx = oJSONoutput.Get("CHOICELIDX") '통합본 리스트 호출용
	midx = oJSONoutput.Get("MIDX")
	cngval = oJSONoutput.Get("CNGVAL")
	gameround = oJSONoutput.Get("RND") '대상라운드
	CDA = "F2" '아티스틱


	If isnumeric(cngval) = False Then
		Call oJSONoutput.Set("result", 111 ) '서버에서 메시지 생성 전달
		Call oJSONoutput.Set("servermsg", "숫자로 입력해 주세요." ) '서버에서 메시지 생성 전달
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End If


	Set db = new clsDBHelper

	  Select Case CStr(gameround)
	  Case "1" :	sortfldname =  "tryoutsortNo"
	  Case "2" :	sortfldname =  "tryoutsortNo2"
	  Case "3" :	sortfldname =  "tryoutsortNo3"
	  Case "4" :	sortfldname =  "tryoutsortNo4"
	  Case "5" :	sortfldname =  "tryoutsortNo5"
	  End Select 

	 '듀엣이나 팀은 순서가 필요하지 않다 (경기를 하지 않으니까)

	  fld = " tryoutgroupno,"&sortfldname&", 	gametitleidx,gbidx" 
	  SQL = "select "&fld&" from SD_gameMember where gameMemberIDX  = '"&midx&"' "
	  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	  If Not rs.EOF Then
			gno = rs(0) '조번호(넣을곳)
			orderno = rs(1) '레인번호(넣을곳)
			tidx = rs(2)
			gbidx = rs(3)
			Call oJSONoutput.Set("TIDX", tidx )



			'기본정보 호출 (통합내용)
			booinfo = getBooInfo(lidx, db, ConStr, CDA)
			grouplevelidx = booinfo(0) 
			RoundCnt =  booinfo(1)
			judgeCnt =  booinfo(2)
			grplidxs = booinfo(3)
			grpgbidxs = booinfo(6) 'gbidxs


			SQL = "select max("&sortfldname&") from SD_gameMember where delyn = 'N' and gametitleidx = "&tidx&" and gbidx in ("&grpgbidxs&")  "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			
			If CDbl(cngval) < 1 Then
				Call oJSONoutput.Set("result", 111 ) '서버에서 메시지 생성 전달
				Call oJSONoutput.Set("servermsg", "순서는 1보다 작을수 없습니다." ) '서버에서 메시지 생성 전달
				strjson = JSON.stringify(oJSONoutput)
				Response.Write strjson
				Response.end
			End if
'			If CDbl(cngval) > CDbl(rs(0)) then
'				Call oJSONoutput.Set("result", 111 ) '서버에서 메시지 생성 전달
'				Call oJSONoutput.Set("servermsg", "입력값이 순서를 벗어났습니다." ) '서버에서 메시지 생성 전달
'				strjson = JSON.stringify(oJSONoutput)
'				Response.Write strjson
'				Response.end
'			End if

			SQL = " update  SD_gameMember set "&sortfldname&" = "&orderno&"  where delyn = 'N' and gametitleidx = "&tidx&" and gbidx  in ("&grpgbidxs&")  and "&sortfldname&" = "&cngval&" " '통합정보까지 포함해서
			SQL = SQL & " update  SD_gameMember set "&sortfldname&" = "&cngval&"  where gameMemberidx = " & midx 
			Call db.execSQLRs(SQL , null, ConStr)
	  
	  End If

	'Call oJSONoutput.Set("sql", SQL )
	Call oJSONoutput.Set("result", 0 )
'				Call oJSONoutput.Set("result", 111 ) '서버에서 메시지 생성 전달
'				Call oJSONoutput.Set("servermsg", SQL ) '서버에서 메시지 생성 전달
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing
%>