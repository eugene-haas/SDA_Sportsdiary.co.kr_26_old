<%
'#############################################
'
'#############################################
	
	'request
	If hasown(oJSONoutput, "TIDX") = "ok" Then 
		tidx = oJSONoutput.TIDX
	End If

	Set db = new clsDBHelper 



	'###########################
		'cd_type levelno insert query 
		'insert Into tblteamgbinfo (cd_type, pteamgb,pteamgbnm,pteamgbengNm,cd_boo,cd_boonm,cd_boonm_short,cd_booLevelno,sexno,teamgb,teamgbnm,levelno,cd_mcnt) (
		' select '3', c.pteamgb,c.pteamgbnm,c.pteamgbengNm,b.cd_boo,b.cd_boonm,b.cd_boonm_short,b.cd_booLevelno,b.sexno,c.teamgb,c.teamgbnm,(c.pteamgb+b.cd_boo+c.teamgb) as levelno,c.cd_mcnt from
		'(select * from tblteamgbinfo where cd_type = 1)  as c cross join (select * from tblteamgbinfo where cd_type = 2) as b 
		')
	'###########################


	'파일 업로드
	'파일저장위치 D:\sportsdiary.co.kr\manager\upload\xls


	SQL = "select exlfile from sd_gametitle where gametitleidx = " & tidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	exlfilename = isnulldefault(rs(0),"")


	global_filepath = "E:\www\upload\sportsdiary\"&sitecode&"\exl\"
	global_filepath_DB = "/"& sitecode &"/exl/"

	'http://upload.sportsdiary.co.kr/sportsdiary/SWN02/exl/78.xls

	If exlfilename = "" then
		Call oJSONoutput.Set("result", 9 ) '등록된 파일없음
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.End
	Else
		If  Right(exlfilename,5) = ".xlsx" then
			extnm = ".xlsx"
		Else
			extnm = ".xls"
		End If
	
	End If


	'Set fs = Server.CreateObject("Scripting.FileSystemObject")
'	If fs.FileExists(global_filepath& tidx & ".xls")  Then
'		extnm = ".xls"
'	Else
'		If fs.FileExists(global_filepath& tidx & ".xlsx") Then
'			extnm = ".xlsx"
'		else
'			Call oJSONoutput.Set("result", 9 ) '등록된 파일없음
'			strjson = JSON.stringify(oJSONoutput)
'			Response.Write strjson
'			Response.End
'		End if
'	End If

	strPath = global_filepath & tidx & extnm
	ar = LoadExcelFile(strPath)

	'Call getrowsdrow(ar)
	'Response.end

	'Redim arr (UBound( ar ,1 ) + 6, UBound(ar, 2)) 
	'초기화######################
	SQL = "Delete from tblgamerequest_TEMP where gametitleIDX = " & tidx
	SQL = SQL & " Delete from tblgamerequest_r  where requestIDX in ( Select requestIDX from tblgamerequest where gametitleIDX = " & tidx & " ) "
	SQL = SQL & " Delete from tblgamerequest  where gametitleIDX = " & tidx 
	Call db.execSQLRs(SQL , null, ConStr)
	'초기화######################	


	'일딴 밀어넣고
	If IsArray(ar) Then 

		'temp table를 만들고 거기에서 최종 가공하고 밀어넣는다. 시작전 temp table내용제거
		'일딴 업데이트 하고 나서 다시 조인해서 업데이트
		SQL = ""
		'필드수
		fldcnt =  Ubound(ar,1)
		'Response.write fldcnt
		'Response.end
		For a = LBound(ar, 2) To UBound(ar, 2)
				personID = ar(0, a) '빈값인데 만들어서 넣을까? 1--------

				CDBNM = ar(1, a) '종별
				CDCNM = ar(2, a) '세부종목
			
				name = isnulldefault(ar(3, a),"")
				'personID 로 playeridx, team 을 구해야한다.
				ename = ar(4, a)
				ubirthsex = ar(5, a) '0301313
				sex = Right(ubirthsex,1)


				If name = "" Then
					If SQL <> "" then
						Call db.execSQLRs(SQL , null, ConStr)
						SQL = ""
					End if
					Exit for
				End if

				If sex = "3" then
				sex  = 1
				End If
				If sex = "4" then
				sex  = 2
				End if				
				teamnm = ar(6, a)
				uclass = ar(7, a) '학년
				bestrc = ar(8, a) '개인기록
				sidonm = ar(9, a) '시도명
				'sido 코드 구하기
				levelno = ar(10, a) 'D2101 종목(2) 종별(1) 세부종목(2)
				
				If CDbl(fldcnt) > 10 then
				joo = ar(11, a) '조번호
				rane = ar(12, a)
				End if


				CDA = Left(levelno,2)
				CDB = Mid(levelno,3,1)
				CDC = Right(levelno,2)


				Select Case CDA
				Case "D2" : CDANM = "경영"
				Case "E2" : CDANM = "다이빙/수구"
				Case "F2" : CDANM = "아티스틱스위밍"
				End Select 

				SQL = SQL & " insert Into tblgamerequest_TEMP (GameTitleIDX,levelno,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,kskey,username,userclass,teamnm,birthday,sex,sidonm,bestRC,joo,rane, entertype) values "
				SQL = SQL & " ( "&tidx&",'"&levelno&"','"&CDA&"','"&CDANM&"','"&CDB&"','"&CDBNM&"','"&CDC&"','"&CDCNM&"','"&personID&"','"&Name&"','"&UClass&"','"&TeamNm&"','"&ubirthsex&"','"&sex&"','"&sidonm&"','"&bestRC&"','"&joo&"','"&rane&"', 'A')"
				
				If a Mod 100 =  0 then
				Call db.execSQLRs(SQL , null, ConStr)
				SQL = ""
				End If
		Next
			If SQL <> "" then
			Call db.execSQLRs(SQL , null, ConStr)
			End if
	End If
	



		'팀생성 #############
			'팀 신규 추가 된것들 인서트
			SQL = "insert tblteaminfo (entertype,team,teamnm, teamRegDt)  "
			SQL = SQL & "  ( "
			SQL = SQL & "  Select "
			SQL = SQL & "				'A' "
			SQL = SQL & "				, FORMAT((select case when max(team) is null then 1 else cast(right(max(team) , 5) as int)  end  from tblTeamInfo where entertype = 'A') + RANK() OVER (Order By teamnm), 'AM00000') as team  "
			SQL = SQL & "				, teamnm,year(getdate()) "
			SQL = SQL & "  from  tblGameRequest_TEMP "
			SQL = SQL & "  where gametitleidx = "&tidx&" and   teamnm Not In (Select a.teamnm From tblGameRequest_TEMP As a inner Join tblteaminfo As b On a.teamnm = b.teamnm And b.entertype = 'A' and b.delyn = 'N' where a.entertype = 'A' and gametitleidx = "&tidx&")  "
			SQL = SQL & "  group by teamnm ) "
			Call db.execSQLRs(SQL , null, ConStr) 

			'temp에 팀코드 찾아서 업데이트
			SQL = "update tblGameRequest_TEMP Set team = b.team  FROM tblGameRequest_TEMP As a inner Join tblteaminfo As b On a.teamnm = b.teamnm And b.entertype = 'A' and b.delyn = 'N' where a.entertype = 'A' and gametitleidx = "&tidx&""
			Call db.execSQLRs(SQL , null, ConStr) 



		'코드업데이트##########
			'없는 tblTeamGbInfo cd_type = 3 인것부터 만들어야할꺼 같음.
			SQL = "insert tblTeamGbInfo (cd_type,PTeamGb,PTeamGbNm,cd_boo,cd_booNm,TeamGb,TeamGbNm,cd_booLevelno,levelno,sexno,cd_mcnt)  "


			SQL = SQL & "  ( "
			SQL = SQL & " SELECT '3' "
			SQL = SQL & "        ,Max(y.pteamgb)			AS cda "
			SQL = SQL & "        ,Max(y.pteamgbnm)		AS cdanm "
			SQL = SQL & "        ,(SELECT TOP 1 cd_boo FROM   tblteamgbinfo WHERE  cd_boonm = x.cdbnm AND cd_type = 2) AS cdb "
			SQL = SQL & " 	   ,cdbnm "
			SQL = SQL & "        ,Max(y.teamgb)            AS cdc "
			SQL = SQL & "        ,cdcnm "
			SQL = SQL & "        ,'9' AS cd_booLevelno "
			SQL = SQL & "        ,( Max(y.pteamgb) + (SELECT TOP 1 cd_boo FROM   tblteamgbinfo WHERE  cd_boonm = x.cdbnm AND cd_type = 2) + Max(y.teamgb) )      AS levelno "
			SQL = SQL & "        ,Case  WHEN Cast(RIGHT(Max(x.birthday), 1) AS INT) % 2 = 0 THEN 2 ELSE 1  END	AS sexno "
			SQL = SQL & "        ,Max(cd_mcnt) "
			SQL = SQL & " FROM	tblgamerequest_temp AS x "
			SQL = SQL & " 		INNER JOIN tblteamgbinfo AS y "
			SQL = SQL & "         ON x.cdcnm = y.teamgbnm AND y.cd_type = 1 "
			SQL = SQL & " WHERE  gametitleidx = "&tidx&" "
			SQL = SQL & "        AND cdbnm + cdcnm NOT IN (SELECT cdbnm + cdcnm "
			SQL = SQL & " 												 FROM   tblteamgbinfo AS a "
			SQL = SQL & " 														INNER JOIN tblgamerequest_temp AS b "
			SQL = SQL & " 																ON a.cd_boonm = b.cdbnm AND a.teamgbnm = b.cdcnm AND b.delyn = 'N' AND b.gametitleidx = "&tidx&" "
			SQL = SQL & " 												 WHERE  a.delyn = 'N' "
			SQL = SQL & " 			                                 GROUP  BY cdbnm, cdcnm) "
			SQL = SQL & " GROUP  BY cdbnm, cdcnm  "
			SQL = SQL & "  )"
			Call db.execSQLRs(SQL , null, ConStr) 

			'테스트쿼리
			'select b.cd_boo as tg,* FROM tblGameRequest_TEMP As a inner Join tblTeamGbInfo As b ON a.cdbnm=b.cd_boonm AND a.cdcnm = b.teamgbnm AND b.delyn = 'N' and b.cd_type=3  and b.cd_boo not in ('!','0')
			'WHERE  a.delyn = 'N' AND a.gametitleidx = 140  and b.teamgb not in ( select teamgb from tblTeamGbInfo where cd_type = 1 and delyn='Y' and cd_boo not in ('!','0') ) order by idx
			
			'코드부터 찾아야 선수 업데이트가 되겠어
			SQL = "update tblGameRequest_TEMP Set CDA = b.pteamgb , CDANM = b.pteamgbnm , CDB = b.cd_boo ,CDC = b.teamgb, levelno = b.levelno "
			SQL = SQL & "		FROM tblGameRequest_TEMP As a inner Join tblTeamGbInfo As b ON a.cdbnm=b.cd_boonm AND a.cdcnm = b.teamgbnm AND b.delyn = 'N' and b.cd_type=3   "
			SQL = SQL & "		WHERE  a.delyn = 'N' AND a.gametitleidx = "&tidx&"   "
			Call db.execSQLRs(SQL , null, ConStr) 


		'선수생성###########
			SQL = "insert tblPlayer (entertype,kskey, startyear,nowyear, birthday, sex, sexkey, CDB,CDBNM ,team,teamnm, username)  "
			SQL = SQL & "  ( "
			SQL = SQL & "  Select "
			SQL = SQL & "				'A' "
			SQL = SQL & "				,FORMAT((select case when max(kskey) is null then 1 else cast(right(max(kskey) , 10) as int)  end from tblPlayer where entertype = 'A') + RANK() OVER (Order By username,birthday), 'AP0000000000') as kskey "
			SQL = SQL & "				,year(getdate()), year(getdate())  "
			SQL = SQL & "				,left(birthday,6), (case when cast(right(birthday,1) as int) % 2 = 0 then '2' else '1' end) as sex , right(birthday,1),max(cdb),max(cdbnm),max(team),max(teamnm) ,username   "
			SQL = SQL & "   "
			SQL = SQL & "  from  tblGameRequest_TEMP "
			SQL = SQL & "  where gametitleidx = "&tidx&" and idx Not In (Select a.idx From tblGameRequest_TEMP As a inner Join tblplayer As b On a.username = b.username and a.birthday = b.birthday+b.sexkey   And b.entertype = 'A' and b.delyn = 'N' where a.entertype = 'A' and gametitleidx = "&tidx&" )  "
			SQL = SQL & "  GROUP  BY username, birthday ) "
			Call db.execSQLRs(SQL , null, ConStr) 

		'있다면 ############

		'kskey
		SQL = "			UPDATE tblGameRequest_TEMP "
		SQL = SQL & "	SET kskey = b.kskey "
		SQL = SQL & "	FROM tblGameRequest_TEMP AS a INNER JOIN tblPlayer AS b "
		SQL = SQL & " ON a.username = b.username And  a.birthday = b.birthday + b.sexkey  and b.DelYN = 'N' Where a.gameTitleIDX = "&tidx&"  and  a.Delyn = 'N' and b.entertype = 'A' "
		Call db.execSQLRs(SQL , null, ConStr) 

			
		'kskey , nowyear 업데이트 및  로그로 복사.
		



	'코드 업데이트(팀코드 , 시도 코드는 은 그냥 믿고 넣자) 아래 시도 코드 별도로 넣을려면
 	'select a.pidx,a.username,a.team,b.team,a.teamnm,b.teamnm 	FROM tblGameRequest_TEMP AS a INNER JOIN tblTeamInfo AS b 
	'ON a.teamnm = b.teamnm And a.gameTitleIDX = 78  and b.teamregdt >= '2019-01-01'  Where a.Delyn = 'N' and b.DelYN = 'N' 

	'팀코드는 다를수 이다 시도도 다를수 있다 ......하나씩 업데이트 해야할듯...
'	SQL = "			UPDATE tblGameRequest_TEMP "
'	SQL = SQL & "	SET pidx = b.playeridx ,team = b.team, sido = b.sidocode "
'	SQL = SQL & "	FROM tblGameRequest_TEMP AS a INNER JOIN tblPlayer AS b "
'	SQL = SQL & " ON a.kskey = b.kskey And a.gameTitleIDX = "&tidx&" 	Where a.Delyn = 'N' and b.DelYN = 'N' "
'	Call db.execSQLRs(SQL , null, ConStr) 


	'걸리는 시간 업데이트 (시작이 결승인지 체크하기 위해서 넣어둠)
	'SQL = "update tblgamerequest_TEMP set gametimess = b.gametimess "
	'SQL = SQL & " from tblgamerequest_TEMP as a inner join tblTeamGbInfo as b on a.CDA = b.Pteamgb and a.cdc = b.teamgb and b.cd_type = 1 and a.delyn = 'N' and b.delyn = 'N' where 'a.gametitleidx = " & tidx
	'Call db.execSQLRs(SQL , null, ConStr) 


	'pidx
	SQL = "			UPDATE tblGameRequest_TEMP "
	SQL = SQL & "	SET pidx = b.playeridx, team = b.team, teamnm = b.teamnm "
	SQL = SQL & "	FROM tblGameRequest_TEMP AS a INNER JOIN tblPlayer AS b "
	SQL = SQL & " ON a.kskey = b.kskey And a.Delyn = 'N' and b.DelYN = 'N' Where a.gameTitleIDX = "&tidx&" "
	Call db.execSQLRs(SQL , null, ConStr) 

	'team,sido
	SQL = "			UPDATE tblGameRequest_TEMP "
	'SQL = SQL & "	SET team = b.team , sido = b.sidocode "
	SQL = SQL & "	SET sido = b.sidocode "
	SQL = SQL & "	FROM tblGameRequest_TEMP AS a INNER JOIN tblTeamInfo AS b "
	SQL = SQL & " ON a.teamnm = b.teamnm and a.sidonm = b.sido And a.Delyn = 'N' and b.DelYN = 'N' Where a.gameTitleIDX = "&tidx&" "
	Call db.execSQLRs(SQL , null, ConStr) 


	'gbidx 모두 생성해두었고... 업데이트만 (작업 SQL맨위 참조)
	SQL = "			UPDATE tblGameRequest_TEMP "
	SQL = SQL & "	SET gbidx = b.teamgbIDX, ITgubun = b.cd_mcnt  "
	SQL = SQL & "	FROM tblGameRequest_TEMP AS a INNER JOIN tblTeamGbInfo AS b "
	SQL = SQL & " ON a.levelno = b.levelno And a.gameTitleIDX = "&tidx&" and b.cd_type= 3	and b.DelYN = 'N'  Where a.Delyn = 'N' "
	Call db.execSQLRs(SQL , null, ConStr)    

	
	fld = " gametitleidx,gbidx,sexno,ITgubun,cda,cdanm,cdb,cdbnm,cdc,cdcnm,levelno "
	SQL = "insert into tblRGameLevel ("&fld&") (select '"&tidx&"', max(gbidx) as gbidx ,max(sex) as sex,max(itgubun) as itgubun ,max(cda) as cda,max(cdanm) as cdanm,max(cdb) as cdb,max(cdbnm) as cdbnm,max(cdc) as cdc,max(cdcnm) as cdcnm,levelno from tblGameRequest_TEMP where gametitleidx = "&tidx&"  group by levelno) "
	Call db.execSQLRs(SQL , null, ConStr) 

	'부를 만든다.

				'If 계영인경우(단체전) Then
					'같은학교라면 ...
						'tblrequest_r 에 맴버 추가
					'다른학교라면 
						'대회에 참가 종목생성
						'tblrequest 생성 하고 
						'tblrequest_r 에 멤버 넣고
					
					'insertstr = insertstr & "insert"
				'Else
					'tblrequest 에 insert
				'End if

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing


%>