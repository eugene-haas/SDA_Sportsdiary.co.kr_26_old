<!-- #include virtual = "/pub/header.RidingAdmin.asp" -->
<%
'############################################
%><!-- #include virtual = "/pub/setReq.asp" --><%'이걸열어서 디버깅하자.%><%
'#############################################




'   ===============================================================================     
'      Excel File Find SheetName
'   =============================================================================== 
	Function getSheetName(conn)
		Dim i
		Set oADOX = CreateObject("ADOX.Catalog")
		oADOX.ActiveConnection = conn
		ReDim sheetarr(oADOX.Tables.count)
		i = 0
		For Each oTable in oADOX.Tables
			sheetarr(i) = oTable.Name
		i = i + 1
		Next 
		getSheetName = sheetarr
	End Function

'   ===============================================================================     
'      Load Excel File
'   =============================================================================== 
	Function LoadExcelFile(strPath)
        Dim aryData, SQL ,sheetname,xlsConnString ,rs 

        Set excelConnection = Server.createobject("ADODB.Connection")
		xlsConnString = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" & strPath & ";Extended Properties=""Excel 12.0 Xml;HDR=YES;IMEX=1"";"
		sheetname = getSheetName(xlsConnString)
		excelConnection.Open xlsConnString

		SQL = "SELECT  * FROM ["&sheetname(0)&"] "
		Set rs = Server.CreateObject("ADODB.Recordset")
        rs.Open SQL, excelConnection

		'Call rsdrow(rs)
		'Response.end

        If Not (rs.Eof Or rs.Bof) Then
            aryData = rs.GetRows()
        End If
	
		LoadExcelFile = aryData

        rs.Close
        excelConnection.Close

        Set rs = Nothing
        Set excelConnection = Nothing
    End Function

	'request
	If hasown(oJSONoutput, "TIDX") = "ok" Then 
		tidx = oJSONoutput.TIDX
	End If

	Set db = new clsDBHelper  


	SQL = "Select exlfile from sd_tennisTitle where gametitleidx = " & tidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	exlfilename = LCase(Mid(rs(0), InStrRev(rs(0), "/") + 1))
	

	'http://upload.sportsdiary.co.kr/sportsdiary/RDN01/setgame_/60.참가신청업로드항목(수정).xls
	'E:\www\upload\sportsdiary\RDN01\setgame_\60.참가신청업로드항목(수정).xlsx

	global_filepath = "E:\www\upload\sportsdiary\"&sitecode&"\"&SENDPRE&"\"
	global_filepath_DB = "/"& sitecode &"/"&SENDPRE&"/"


	Set fs = Server.CreateObject("Scripting.FileSystemObject")
	If fs.FileExists(global_filepath& exlfilename) = False  Then
		Call oJSONoutput.Set("result", 9 ) '등록된 파일없음
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.End
	End if

	strPath = global_filepath & exlfilename
	ar = LoadExcelFile(strPath)


'	Call getrowsdrow(ar)
'	Response.end

	'Redim arr (UBound( ar ,1 ) + 6, UBound(ar, 2)) 
	'초기화######################
	SQL = "Delete from tblgamerequest_TEMP where gametitleIDX = " & tidx
	SQL = SQL & " Delete from tblgamerequest_r  where requestIDX in ( Select requestIDX from tblgamerequest where gametitleIDX = " & tidx & " ) "
	SQL = SQL & " Delete from tblgamerequest  where gametitleIDX = " & tidx 
	Call db.execSQLRs(SQL , null, ConStr)
	'초기화######################	


	'코드가져오기
	SQL = "select pubcodeidx,pubcode,pubname,ppubcode,ppubname,engcode from tblPubCode where delyn = 'N' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.eof Then
		codearr = rs.GetRows()
	End if

	infld  = "GameTitleIDX,gbIDX,useyear,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,RCLASS,RCLASSHELP,pubcode,engcode,pubname"
	infld = infld & ",ksportsno,P1_PlayerIDX,P1_UserName,P1_Team,P1_TeamNm,P1_UserPhone,P1_Birthday,P1_SEX,P2_PlayerIDX,P2_UserName"
	
	If IsArray(ar) Then 
		
		'temp table를 만들고 거기에서 최종 가공하고 밀어넣는다. 시작전 temp table내용제거
		'일딴 업데이트 하고 나서 다시 조인해서 업데이트
		SQL = ""
		'필드수
		fldcnt =  Ubound(ar,1)
		'Response.write fldcnt
		'Response.end
		For a = LBound(ar, 2) To UBound(ar, 2)
				nowyear = ar(1,a) '년도
				CDANM = ar(2,a)  '개인/ 단체
				If CDANM = "개인" then
					CDA = 201
				Else
					CDA = 202
				End if
				CDBNM = ar(3,a) '종별 (마장마술등) 
				CDCNM = ar(4,a) '말 국산마 등..국산마+외산마..
				PUBNM = ar(14,a) '일반부등 ..

				For x = 0 To UBound(codearr, 2)
					If codearr(2, x) = CDBNM then
					CDB = codearr(1,x)
					End If
					If codearr(2, x) = CDBNM then
					CDC = codearr(1,x)
					End if	
					If codearr(2, x) = PUBNM then
					PUBCD = codearr(1,x)
					PUBENG = codearr(5,x)
					End if	
				Next 

				RCLASS = ar(5, a) '클레스
				If InStr(rclass," ") > 0 Then
					RCLASS = Split(rclass, " ")(0)
				End if

				RCHELP = ar(6, a) '종별상세
				personID = ar(7, a) '체육인번호

				'personID 로 playeridx, team 을 구해야한다. (줄리가 없겠지 지대로 주는게 없으니  ..  쌍 어떻게 마추나...
				
				name = ar(8, a)
				ubirth = ar(9, a) '6자리 > 8자리로
				pidx = ""

				'80년뒤에 수정하시옷.
				If Len(Trim(ubirth)) = 6 Then
					If Left(ubirth,1) > 3 Then
						ubirth = "19" & ubirth
					Else
						ubirth = "20" & ubirth
					End if
				Else
						ubirth = "200" & ubirth				
				End If
				
				sex = ar(10, a)
				Select Case sex
				Case "남" : sex = "M"
				Case "여" : sex = "W"
				Case Else :  sex = "M"
				End select
				uphone = Replace(ar(11,a),"-","")

				hname = ar(12,a)
				hpidx = ""
				'말이름으로 말 playeridx 구해야함...
				teamnm = ar(13, a)
				team = ""
				'팀코드 구해야하고


				'tblTeamGbInfo 항목이 있는지 확인 없다면 생성..(다음스텝에 저장)


				'nfld  = "GameTitleIDX,gbIDX,useyear,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,RCLASS,RCLASSHELP,pubcode,engcode,pubname"
				'nfld = nfld ",ksportsno,P1_PlayerIDX,P1_UserName,P1_Team,P1_TeamNm,P1_UserPhone,P1_Birthday,P1_SEX,P2_PlayerIDX,P2_UserName"

				SQL = SQL & " insert Into tblgamerequest_TEMP ("&infld&") values "
				SQL = SQL & " ( "&tidx&",'"&gbidx&"','"&nowyear&"','"&CDA&"','"&CDANM&"','"&CDB&"','"&CDBNM&"','"&CDC&"','"&CDCNM&"','"&RClass&"','"&RCHELP&"','"&PUBCD&"','"&PUBENG&"','"&PUBNM&"' "
				SQL = SQL & " ,'"&personID&"','"&pidx&"','"&Name&"','"&team&"','"&TeamNm&"','"&uphone&"','"&ubirth&"','"&sex&"','"&hpidx&"','"&hname&"' )" '& "</br>"
				
				If a Mod 100 =  0 Then '100개 단위로 저장
				Call db.execSQLRs(SQL , null, ConStr)
				SQL = ""
				End If
				
		Next
			Call db.execSQLRs(SQL , null, ConStr)
	End If
	
'Response.write sql
'Response.end




	'코드 업데이트(팀코드 , 시도 코드는 은 그냥 믿고 넣자) 아래 시도 코드 별도로 넣을려면
 	'select a.pidx,a.username,a.team,b.team,a.teamnm,b.teamnm 	FROM tblGameRequest_TEMP AS a INNER JOIN tblTeamInfo AS b 
	'ON a.teamnm = b.teamnm And a.gameTitleIDX = 78  and b.teamregdt >= '2019-01-01'  Where a.Delyn = 'N' and b.DelYN = 'N' 

	'이름 + 전화번호
	SQL = "			UPDATE tblGameRequest_TEMP "
	'SQL = SQL & "	SET pidx = b.playeridx ,team = b.team, sido = b.sidocode "
	SQL = SQL & "	SET ksportsno = b.ksportsno , P1_playeridx = b.playeridx  "
	SQL = SQL & "	FROM tblGameRequest_TEMP AS a INNER JOIN tblPlayer AS b "
	'SQL = SQL & " ON a.ksportsno = b.ksportsno And a.gameTitleIDX = "&tidx&" and b.delyn = 'N'	Where a.DelYN = 'N' "
	SQL = SQL & " ON a.P1_username = b.username and a.P1_userphone = b.userphone And a.gameTitleIDX = '"&tidx&"' and b.usertype = 'P' and b.delyn = 'N'	 Where a.DelYN = 'N' "
	Call db.execSQLRs(SQL , null, ConStr) 

	'이름 + 생년월일
	SQL = "			UPDATE tblGameRequest_TEMP "
	SQL = SQL & "	SET ksportsno = b.ksportsno , P1_playeridx = b.playeridx  "
	SQL = SQL & "	FROM tblGameRequest_TEMP AS a INNER JOIN tblPlayer AS b "
	SQL = SQL & " ON a.P1_username = b.username and a.P1_birthday = b.birthday And a.gameTitleIDX = '"&tidx&"' and b.usertype = 'P' and b.delyn = 'N'	 Where a.DelYN = 'N'  and a.p1_playeridx = '' "
	Call db.execSQLRs(SQL , null, ConStr) 

	'팀코드 채우기#################
	SQL = "			UPDATE tblGameRequest_TEMP "
	SQL = SQL & "	SET P1_team = b.team "
	SQL = SQL & "	FROM tblGameRequest_TEMP AS a INNER JOIN tblTeamInfo AS b "
	SQL = SQL & " ON a.P1_teamnm = b.teamnm And a.Delyn = 'N' and b.DelYN = 'N' Where a.gameTitleIDX = '"&tidx&"' "
	Call db.execSQLRs(SQL , null, ConStr) 

	'없는팀 생성하기
	SQL = "insert into tblTeamInfo (team,teamnm) "
	SQL = SQL & " select 'ATE' + left('0000000', len(cast(right(max(team),7) as int)+ROW_NUMBER() over (order by p1_teamnm))-1) + cast(cast(right(max(team),7) as int) +  ROW_NUMBER() over (order by p1_teamnm) as varchar), p1_teamnm from "
	SQL = SQL & " (select (select  'ATE'+left('0000000', len(cast(right(max(team),7) as int)+ 1)-1)+cast( (cast(right(max(team),7) as int)) as varchar)  from tblTeamInfo) as team ,P1_teamnm from tblGameRequest_TEMP where gametitleidx = '"&tidx&"' and  P1_team = '' ) T "
	SQL = SQL & " group by p1_teamnm "
	Call db.execSQLRs(SQL , null, ConStr) 

	'없는코드 다시 채우기
	SQL = "			UPDATE tblGameRequest_TEMP "
	SQL = SQL & "	SET P1_team = b.team "
	SQL = SQL & "	FROM tblGameRequest_TEMP AS a INNER JOIN tblTeamInfo AS b "
	SQL = SQL & " ON a.P1_teamnm = b.teamnm And a.Delyn = 'N' and b.DelYN = 'N' Where a.gameTitleIDX = '"&tidx&"' "
	Call db.execSQLRs(SQL , null, ConStr) 
	'팀코드 채우기#################
	

	'playeridx is null 이라면 생성해야한다...ㅡㅡ
	SQL = "insert into tblPlayer (usertype,username,team,teamnm,userphone,birthday,sex) "
	SQL = SQL & " select 'P', P1_username,P1_team,P1_teamnm,P1_userphone,P1_birthday,P1_sex  from tblGameRequest_TEMP where gametitleidx = '" & tidx & "' and P1_playeridx = ''  group by P1_username,P1_team,P1_teamnm,P1_userphone,P1_birthday,P1_sex"
	Call db.execSQLRs(SQL , null, ConStr) 

	'다시선수정보업데이트
	SQL = "			UPDATE tblGameRequest_TEMP "
	SQL = SQL & "	SET ksportsno = b.ksportsno , P1_playeridx = b.playeridx  "
	SQL = SQL & "	FROM tblGameRequest_TEMP AS a INNER JOIN tblPlayer AS b "
	SQL = SQL & " ON a.P1_username = b.username and a.P1_birthday = b.birthday And a.gameTitleIDX = '"&tidx&"' and b.usertype = 'P' and b.delyn = 'N'	 Where a.DelYN = 'N'  and a.p1_playeridx = '' "
	Call db.execSQLRs(SQL , null, ConStr) 
	

	'말 playeridx 채우기
	SQL = "			UPDATE tblGameRequest_TEMP "
	SQL = SQL & "	SET P2_playeridx = b.playeridx  "
	SQL = SQL & "	FROM tblGameRequest_TEMP AS a INNER JOIN tblPlayer AS b "
	SQL = SQL & " ON a.P2_username = b.username And a.gameTitleIDX = '"&tidx&"' and b.usertype = 'H' and b.delyn = 'N'	 Where a.DelYN = 'N' "
	Call db.execSQLRs(SQL , null, ConStr) 

	'없는말 채우기
	SQL = "insert into tblPlayer (usertype,username) "
	SQL = SQL & " select 'H', P2_username from tblGameRequest_TEMP where gametitleidx = '" & tidx & "' and P2_playeridx = '' group by P2_username"
	Call db.execSQLRs(SQL , null, ConStr) 

	'말 playeridx 다시채우기
	SQL = "			UPDATE tblGameRequest_TEMP "
	SQL = SQL & "	SET P2_playeridx = b.playeridx  "
	SQL = SQL & "	FROM tblGameRequest_TEMP AS a INNER JOIN tblPlayer AS b "
	SQL = SQL & " ON a.P2_username = b.username And a.gameTitleIDX = '"&tidx&"' and b.usertype = 'H' and b.delyn = 'N'	 Where a.DelYN = 'N'  and a.P2_playeridx = '' "
	Call db.execSQLRs(SQL , null, ConStr) 

      

	'없는 gbidx 모두 생성
	SQL = "insert into tblTeamGbInfo (useyear,PTeamGb,PTeamGbNm,TeamGb,TeamGbNm,levelno,levelNm,ridingclass,ridingclasshelp)"
	SQL = SQL & "	select useyear,cda,cdanm,cda+cdb,cdbnm,cda+cdb+cdc,cdcnm,rclass,rclasshelp from ( "
	SQL = SQL & "	select a.useyear,a.cda,a.cdanm,a.cdb,a.cdbnm,a.cdc,a.cdcnm,a.rclass,a.rclasshelp,max(b.TeamGbIDX) as gbidx from tblGameRequest_TEMP as a left join tblTeamGbInfo as b "
	SQL = SQL & "	on a.useyear = b.useyear and a.cda = b.pteamgb and a.cdbnm = b.TeamGbNm and a.cdcnm = b.levelNm and a.rclass = b.ridingclass and a.rclasshelp = b.ridingclasshelp "
	SQL = SQL & "	group by a.useyear,a.cda,a.cdanm,a.cdb,a.cdbnm,a.cdc,a.cdcnm,a.rclass,a.rclasshelp "
	SQL = SQL & " ) T where gbidx is null "
	Call db.execSQLRs(SQL , null, ConStr) 

	'gbidx 없데이트
	SQL = "			UPDATE tblGameRequest_TEMP "
	SQL = SQL & "	SET gbidx = b.teamgbIDX  "
	SQL = SQL & "	FROM tblGameRequest_TEMP AS a INNER JOIN tblTeamGbInfo AS b "
	SQL = SQL & " on a.useyear = b.useyear and a.cda = b.pteamgb and a.cdbnm = b.TeamGbNm and a.cdcnm = b.levelNm and a.rclass = b.ridingclass and a.rclasshelp = b.ridingclasshelp And a.gameTitleIDX = "&tidx&" and b.delyn ='N'	Where a.Delyn = 'N' "
	Call db.execSQLRs(SQL , null, ConStr)    

	'세부종목생성 gameno는 1번부터 증가값
	SQL = "insert into tblRGameLevel (gameno, gamenostr ,gametitleidx,gbidx,pubcode,engcode,pubname,attdates,attdatee,gameday,levelno) "
	SQL = SQL & " select ROW_NUMBER() over (order by gbidx),ROW_NUMBER() over (order by gbidx),* from ( " 
	SQL = SQL & " select gametitleidx,gbidx,pubcode,engcode,pubname,getdate() as attdates,getdate() as attdatee, '"&Date()&"' as gameday, (cda+cdb+cdc) as level from tblGameRequest_TEMP  "
	SQL = SQL & "	where gametitleidx = '"&tidx&"' group by  gametitleidx,gbidx,pubcode,engcode,pubname,(cda+cdb+cdc) ) T "
	Call db.execSQLRs(SQL , null, ConStr)

	

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing

%>

