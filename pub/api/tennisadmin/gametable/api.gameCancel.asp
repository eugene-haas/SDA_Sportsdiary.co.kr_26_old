<%
'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
''라운드 승처리 취소
'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

	gubun = oJSONoutput.GN			'예선/본선 구분  0예선 1본선
	tidx = oJSONoutput.TitleIDX		'대회인덱스
	midx = oJSONoutput.T_MIDX		'승자 인덱스

	levelno = oJSONoutput.S3KEY	 ' 상세번호(지역까지포함된)
	key3 = Left(levelno ,5)
	s2key = Left(key3,3)				 '단복식구분정보
	key3name = oJSONoutput.TeamNM
	sortno = oJSONoutput.T_SORTNO
	rd = oJSONoutput.T_NOWRD

	'플레이어 정보가져오기
		If s2key = "200" Then
			joinstr = " left "
			singlegame =  true
		Else
			joinstr = " inner "
			singlegame = false
		End if  
	'플레이어 정보가져오기

	Call oJSONoutput.Set("state", "0" )

	'#################################
	Set db = new clsDBHelper

  strtable = "sd_TennisMember"
  strtablesub =" sd_TennisMember_partner "
  strtablesub2 = " tblGameRequest "
  strresulttable = " sd_TennisResult "


	'결과 승패 기록이 있는지 찾아보자
	'rtwhere = " (gameMemberIDX1 = " & midx & " or gameMemberIDX2 = "&midx & ") and gameTitleIDX = "  & tidx & " and level = " & levelno
	'SQL = "Select resultIDX,gameMemberIDX1,gameMemberIDX2,stateno,winIDX,preresult,recorderName from sd_tennisResult where "& rtwhere &" and delYN = 'N' "
	'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	chksort1 = sortno * 2
	chksort2  = chksort1 -1

	'b.gubun = 1 본선결과
	rtwhere = "  b.gubun = 1 and a.round = " & CDbl(rd)-1 & " and a.sortno in ( "& chksort1 & ", " & chksort2 & ") and a.gameTitleIDX = "  & tidx & " and a.gamekey3 = " & levelno
	strfield = " b.resultIDX  " '인덱스 , 짝수 인덱스(대상) ,게임상태 ( 2, 진행 , 1, 종료)
	SQL = "select "& strfield &" from  " & strtable & " as a INNER JOIN " & strresulttable & " as b ON a.gameMemberIDX = b.gameMemberIDX1   where " & rtwhere 
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	
'	Call rsdrow(rs)
'	Response.write sql
'	Response.end

	If rs.eof Then
			'삭제후 -- 생성
			SQL = "DELETE From "&strtable&" From "&strtable&" As a Left Join "&strtablesub&" As b On a.gameMemberIDX = b.gameMemberIDX Where a.gameMemberIDX = " & midx
			Call db.execSQLRs(SQL , null, ConStr)

			insertfield = " gubun,playerIDX,GameTitleIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,key3name,Round,sortno "
			selectfield = TOURNSTART &  ",1,GameTitleIDX,'--',gamekey1,gamekey2,gamekey3,TeamGb,key3name," & rd & ", " & sortno
			selectSQL = "Select top 1 "&selectfield&"  from sd_TennisMember where Round= 1 and gubun in (2,3) and GameTitleIDX = "&tidx&" and gamekey3= " & levelno
			SQL = "insert into "&strtable&" ("&insertfield&")  "&selectSQL
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	Else '결과값이 있다... 
		scidx = rs("resultIDX")
		'rcname = rs("recorderName") '심판값
		'stateno = rs("stateno") '1 종료 2 진행중 , gubun = 1 본선, preresult = 'ING' 진행중 

		'상세기록 여부 확인
		SQL = "Select resultIDX from sd_tennisResult_record where resultIDX = " & scidx
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			

		If rs.eof Then '상세기록 없슴 삭제
			SQL = "delete from sd_tennisResult where resultIDX = " & scidx 'delYN으로 처리 하고 싶긴한데...흠...
			Call db.execSQLRs(SQL , null, ConStr)

			'삭제후 -- 생성
			SQL = "DELETE From "&strtable&" From "&strtable&" As a Left Join "&strtablesub&" As b On a.gameMemberIDX = b.gameMemberIDX Where a.gameMemberIDX = " & midx
			Call db.execSQLRs(SQL , null, ConStr)

			insertfield = " gubun,playerIDX,GameTitleIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,key3name,Round,sortno "
			selectfield = TOURNSTART &  ",1,GameTitleIDX,'--',gamekey1,gamekey2,gamekey3,TeamGb,key3name," & rd & ", " & sortno
			selectSQL = "Select top 1 "&selectfield&"  from sd_TennisMember where Round= 1 and gubun in (2,3) and GameTitleIDX = "&tidx&" and gamekey3= " & levelno

			SQL = "insert into "&strtable&" ("&insertfield&")  "&selectSQL
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)		 
		Else
			Call oJSONoutput.Set("result", "999" )
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.End
		End If 

	End if



	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
	db.Dispose
	Set db = Nothing
%> 