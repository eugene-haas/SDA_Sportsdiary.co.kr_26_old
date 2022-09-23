<%
'#############################################

'편성완료 ,재편성

'#############################################
	'request
	tidx = oJSONoutput.TitleIDX '게임타이틀 인덱스
	gamekey3 = oJSONoutput.S3KEY '게임종목 키
	levelkey = gamekey3

	gamekey3 = Left(gamekey3,5)
	gamekeyname = oJSONoutput.TeamNM '부명칭


	If Left(gamekey3,3) = "200" Then
		joinstr = " left "
		singlegame =  true
	Else
		joinstr = " inner "
		singlegame = false
	End if  

	Set db = new clsDBHelper

	'예선총명수로 참가자 명수 확정
	strtable = "sd_TennisMember"
	strtablesub =" sd_TennisMember_partner "
	strtablesub2 = " tblGameRequest "
	strresulttable = " sd_TennisResult "

	strWhere = " GameTitleIDX = "&tidx&" and gamekey3 = "& levelkey & " and gubun in (0, 1)  and DelYN = 'N' "
	SQL = "select  max(tryoutgroupno) as maxgno,COUNT(*) as gcnt,max(sortNo) as maxsort from "&strtable&" where "&strWhere
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof Then
		attmembercnt = rs("gcnt")						'총참가자
		maxgno = rs("maxgno")						'설정된 마지막조
		atttourncnt  = CDbl(maxgno) * 2			'토너먼트 참가 인원
		maxsortno = rs("maxsort")				'마지막 소팅번호
	End if

	'예선의 모든 경기가 종료 되었다면
	strWhere = " GameTitleIDX = "&tidx&" and gamekey3 = "& levelkey & " and gubun in (0, 1)  and DelYN = 'N' and t_rank > 0"
	SQL = "select count(*) from "&strtable&" where "&strWhere
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)	

	endmembercnt = rs(0)								'종료한 참가자수

	If CDbl(endmembercnt) >= CDbl(attmembercnt) Then '예선경기가 종료되었다면
		
		If Cdbl(attmembercnt) > 0 And Cdbl(attmembercnt) <= 4 Then
			tnno = 4
		ElseIf Cdbl(attmembercnt) > 4 And Cdbl(attmembercnt) <=8 Then
			tnno = 8
		ElseIf Cdbl(attmembercnt) > 8 And Cdbl(attmembercnt) <=16 Then
			tnno = 16
		ElseIf Cdbl(attmembercnt) > 16 And Cdbl(attmembercnt) <=32 Then
			tnno = 32
		ElseIf Cdbl(attmembercnt) > 32 And Cdbl(attmembercnt) <=64 Then
			tnno = 64
		ElseIf Cdbl(attmembercnt) > 64 And Cdbl(attmembercnt) <=128 Then
			tnno = 128		
		ElseIf Cdbl(attmembercnt) > 128 And Cdbl(attmembercnt) <=256 Then
			tnno = 256
		End If

		tempmembercnt = tnno - Cdbl(atttourncnt) '부족한 토너먼트 참가자


		strWhere = " GameTitleIDX = "&tidx&" and gamekey3 = "& levelkey & " and gubun =2  and DelYN = 'N' and userName = '부전'"
		SQL = "select COUNT(*)  from "&strtable&" where "&strWhere
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		maketempcnt = rs(0)


			'Response.write 	endmembercnt & "--" & attmembercnt
			'Response.write tempmembercnt &"-"& tnno

			If CDbl(maketempcnt) >= CDbl(tempmembercnt) Then
				'이미 생성되었슴

			Else
		
				For n = 1 To tempmembercnt

					'선수 insert
					insertfield = " gubun,GameTitleIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,key3name,Round "
					selectfield = TOURNSET& ",GameTitleIDX,'부전',gamekey1,gamekey2,gamekey3,TeamGb,key3name,Round"
					selectSQL = "Select top 1 "&selectfield&"  from sd_TennisMember where Round= 1 and gubun = "&TOURNSET&" and GameTitleIDX = "&tidx&" and gamekey3= " & levelkey

					SQL = "SET NOCOUNT ON  insert into "&strtable&" ("&insertfield&")  "&selectSQL&" SELECT @@IDENTITY"
					'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
					'midx = rs(0)

					'파트너 insert
					insertfield  = " gameMemberIDX,userName "
					selectfield = " "&midx&",'부전' "
					SQL = "insert into "&strtablesub&" ("&insertfield&")  values ("&selectfield&")"
					'Call db.execSQLRs(SQL , null, ConStr)

				Next
		
				'#############
					strWhere = " GameTitleIDX = "&tidx&" and gamekey3 = "& levelkey & " and gubun in (2)  and DelYN = 'N' "
					SQL = "SELECT gameMemberIDX , userName FROM  " &strtable&   " where " & strWhere & " and sortNo = 0  ORDER BY gameMemberIDX ASC"
					Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
					
					If CDbl(maxsortno) = 0 then
						maxsortno = 1
					End if
					Do Until rs.EOF 
						strSql = "UPDATE " &  strtable & " SET "
						strSql = strSql & " sortNo = " & maxsortno
						strSql = strSql & " WHERE gameMemberIDX = " & rs("gameMemberIDX")
						Call db.execSQLRs(strSql , null, ConStr)
					maxsortno =CDbl(maxsortno) + 1
					rs.movenext
					Loop

					Set rs = Nothing
				'#############

		End If
		
	End if


	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	db.Dispose
	Set db = Nothing
%>