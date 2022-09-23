<%
'#############################################
' 입력
'#############################################
	'request
	If hasown(oJSONoutput, "TIDX") = "ok" then
		tidx= oJSONoutput.TIDX
	End If
	If hasown(oJSONoutput, "DIDX") = "ok" then
		didx= oJSONoutput.DIDX
	End If	
	If hasown(oJSONoutput, "NO") = "ok" then
		no= oJSONoutput.NO
	Else
		no = 0
	End If	

	Set db = new clsDBHelper

		'대회찾기 ...................
		SQL = "Select gametitlename from SD_tennisTitle where gametitleidx = " & tidx
		Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)
		If Not rs.EOF Then
			arrArr = rs.GetRows()
			gametitle = arrArr(0,0)
		End if

		'규정종목 찾기 ................
		SQL = "Select idx,title,fieldvalue from SD_Pub.dbo.tblinsertData where idx = " & didx
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr) 'B_ConStr

		If rs.EOF Then
			Call oJSONoutput.Set("result", "1" )
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.write "`##`"
			Response.end
		End if

		arrNo = rs.GetRows()
		indata = arrNo(2,ar)
		dataarr = Split(indata, vbLf)
		incnt = UBound(dataarr)
		invalue = split(dataarr(no),"^") '1^2019^개인^마장마술^국산마+외산마^D Ckass^Preliminary^7^박숙자^650209^여^010-2045-2042^ 마하 ^대구광역시승마협회^일반부
		f_year = invalue(1)
		f_gubun = invalue(2) '개인 단체
		f_teamgbnm = invalue(3) '종별명칭
		f_levelnm = invalue(4) '출전마 (국산마 ...)
'		f_class = Split(invalue(5)," ")(0) ' 클레스

		f_class = invalue(5) ' 클레스

		f_chelp = invalue(6)
		f_mcode = invalue(7) '체육인번호
		f_pnm = invalue(8) '선수명

		f_birth = invalue(9) '생년월일 6 > 8자리로 변경해야함..

'		If CDbl(Left(f_birth,2)) > 20 Then
'			f_birth = "19" & f_birth
'		Else
'			f_birth = "20" & f_birth
'		End if

		f_sexstr = invalue(10) '남여 .. > 변환
		If f_sexstr = "여" Then
			f_sex = "Woman"
		Else
			f_sex = "Man"
		End If
		
		f_phone = Replace(invalue(11),"-","") '전화번호
		f_hnm = Trim(invalue(12)) '말명칭
		f_teamnm = invalue(13) '팀명칭
		f_pubname = invalue(14) '초등....

		Select Case f_pubname 
			Case "초등부" : f_pubcode = 1
			Case "중등부" : f_pubcode = 2
			Case "고등부" : f_pubcode = 3
			Case "대학부" : f_pubcode = 4
			Case "일반부" : f_pubcode = 5
			Case "동호인부" : f_pubcode = 6
		End Select 
		Select Case CStr(f_pubcode)
			Case "1" :  engcode = "EXXXXX"
			Case "2" :  engcode = "XMXXXX"
			Case "3" :  engcode = "XXHXXX"
			Case "4" :  engcode = "XXXUXX"
			Case "5" :  engcode = "XXXXGX"
			Case "6" :  engcode = "XXXXXC"
		End Select 

		'gbidx 찾기  (말에 관한 것도 체크해야되는군.
		
		'1^2019^개인^마장마술^국산마+외산마^D Ckass^Preliminary^7^박숙자^650209^여^010-2045-2042^ 마하 ^대구광역시승마협회^일반부		
		'26^2019^개인^장애물^국산마+외산마^유소년포니 80^FEI 238.2.2^0^이태묵^20010101^남^010-0000-0000^해사^경운중학교^중등부
		SQL = "Select teamgbidx,levelno from tblTeamGbInfo where useyear = '"&f_year&"' and pteamgbnm = '"&f_gubun&"' and  teamgbnm = '"&f_teamgbnm&"' and levelnm='"&f_levelnm&"' and ridingclass = '"&f_class&"' and ridingclasshelp = '"&f_chelp&"' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr) 'B_ConStr (종목관리가 설정되어있어야한다.)

'Response.write sql


		'먼저 들어가 있어야한다.
		If rs.EOF Then
			Call oJSONoutput.Set("result", "1" )
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.write "`##`"
			Response.end
		End if


		gbidx =  rs(0)
		levelno = rs(1)

		'순서번호
		SQL = "select max(gameno) from tblRGameLevel where DelYN='N' and GameTitleIDX = "&tidx
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If isnull(rs(0)) = True Then
			inggameno = 1
		Else
			inggameno = CDbl(rs(0)) + 1
		End If
		rs.close

		'준비 ......................
			'1. 세부종목이 있는지 검사해서 없으면 생성				
				SQL = "select RGameLevelidx from tblRGameLevel where DelYN='N' and GameTitleIDX = "&tidx&" and GbIDX = '"&gbidx&"' and pubcode = '"&f_pubcode&"' "
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				If rs.eof Then
					insertfield = " gameno,gamenostr,GameTitleIDX,GbIDX,pubcode,engcode,pubName,GameDay,GameTime,levelno,fee     "
					insertvalue = " '"&inggameno&"','"&inggameno&"',"&tidx&",'"&gbidx&"','"&f_pubcode&"','"&engcode&"','"&f_pubname&"','"&date&"','00:00','"& levelno &"',0 "  
					SQL = "INSERT INTO tblRGameLevel ( "&insertfield&" ) VALUES ( "&insertvalue&" )"
					Call db.execSQLRs(SQL , null, ConStr)
				End If


			'2. 팀명칭이 등록되어있는지 확인하고 없다면 생성
				SQL = "Select Team,teamnm from tblTeamInfo where TeamNm = '"&f_teamnm&"' and delyn='N' "
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				If rs.eof Then
					'등록 후 정보
					SQL = "Select top 1 convert(nvarchar,SUBSTRING(Team,4,LEN(Team))+1) as teamLast, len(Team) as TeamLen from  tblTeamInfo where delyn='N'  ORDER BY Team desc"
					Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
					teamcode = "ATE000" & rs(0)

					insertfield = " Team,TeamNm,EnterType "
					insertvalue = "'"&teamcode&"','"&f_teamnm&"','A' "
					SQL = "INSERT INTO tblTeamInfo ( "&insertfield&" ) VALUES ( "&insertvalue&" ) "
					Call db.execSQLRs(SQL , null, ConStr)
				Else
					teamcode = rs(0)
				End if
			

			'3. 선수가 등록되어있는지 확인하고 없다면 생성
				SQL = "select playeridx from tblplayer where DelYN='N' and nowyear = '"&f_year&"' and userType = 'P'  and username = '"&f_pnm&"'  "   'and  userphone = '"&f_phone&"' "
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

				If rs.eof Then
					insertfield = " ksportsno,nowyear,userType,username,userphone,birthday,sex,team,teamnm  "
					insertvalue = " '"&f_mcode&"',  '"&f_year&"','P','"&f_pnm&"','"&f_phone&"','"&f_birth&"','"&f_sex&"','"&teamcode&"','"&f_teamnm&"' "  
					SQL = "SET NOCOUNT ON  INSERT INTO tblplayer ( "&insertfield&" ) VALUES ( "&insertvalue&" )  SELECT @@IDENTITY"
					Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
					pidx = rs(0)
				Else
					pidx = rs(0)
				End If

			'4. 말명칭으로 말 정보 가져오기 (없으면 이것도 강제 등록 하자)
				SQL = "select playeridx,birthday,sex from tblplayer where DelYN='N' and userType = 'H'  and username = '"&f_hnm&"' "
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)		
				If rs.eof Then
					SQL = "SET NOCOUNT ON  INSERT INTO tblplayer ( userType,username ) VALUES ( 'H','"&f_hnm&"' )  SELECT @@IDENTITY"
					Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
					hpidx = rs(0)
				else
					hpidx = rs(0)
					hbirth = rs(1)
					hsex = rs(2)
				End If

	'처리 ........................
		'신청여부확인
			SQL = "select requestIDX from tblGameRequest where DelYN='N' and gametitleidx = "&tidx&" and gbidx = "&gbidx&" and pubcode = '"&f_pubcode&"' and  P1_PlayerIDX = '"&pidx&"' and P2_PlayerIDX = '"&hpidx&"'  "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)	

			If rs.eof then
				'1. 참가신청에 넣는다.
					insertfield = "  GameTitleIDX,gbidx,EnterType,UserName,pubcode,pubname "
					insertfield = insertfield & " ,P1_PlayerIDX,P1_UserName,P1_Team,P1_TeamNm,P1_UserPhone,P1_Birthday,P1_SEX "
					insertfield = insertfield & " ,P2_PlayerIDX,P2_UserName,P2_Birthday,P2_SEX "

					insertvalue = "'"&tidx&"','"&gbidx&"','A','운영자', '"&f_pubcode&"','"&f_pubname&"' "	
					insertvalue = insertvalue & "," & pidx & ",'" &  f_pnm & "' ,'" & teamcode & "','"&f_teamnm&"'   ,'"&f_phone&"','"&f_birth&"','"&f_sex&"'    "
					insertvalue = insertvalue & "," & hpidx & ",'" & f_hnm & "' ,'" & hbirth & "','" & hsex & "' "

					SQL = "SET NOCOUNT ON INSERT INTO tblGameRequest ( "&insertfield&" ) VALUES ("&insertvalue&") SELECT @@IDENTITY" 
					Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
					reqidx = rs(0)

				'2. 게임 테이블에 넣는다.			
					insertfield = " gubun, GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,key3name,TeamANa, requestIDX, pubcode,pubname"
					insertvalue = " '0','"&tidx&"','"&pidx&"','"&f_pnm&"', '"&Left(levelno,3)&"','"&levelno&"','"&gbidx&"','"&Left(levelno,5)&"','"&f_teamgbnm&"','"&f_teamnm&"','"&reqidx&"','"&f_pubcode&"', '"&f_pubname&"'  "
					SQL = "SET NOCOUNT ON  Insert into sd_TennisMember ("&insertfield&") values ("&insertvalue&")  SELECT @@IDENTITY"
					Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
					gamemidx = rs(0)	

					SQL = "Insert into sd_TennisMember_partner (GameMemberIDX, PlayerIDX,userName) values ("&gamemidx&", '"&hpidx&"', '"&f_hnm&"')"
					Call db.execSQLRs(SQL , null, ConStr)
			End if



			'준비 ......................
				'1. 세부종목이 있는지 검사해서 없으면 생성

				'2. 선수가 등록되어있는지 확인하고 없다면 생성

				'3. 팀명칭이 등록되어있는지 확인하고 없다면 생성

				'4. 말명칭으로 말 정보 가져오기

			'처리 ........................
				'1. 참가신청에 넣는다.

				'2. 게임 테이블에 넣는다.





		nextno = CDbl(no) + 1
		oJSONoutput.NO = nextno
		If CDbl(nextno) = CDbl(incnt) + 2 then
			oJSONoutput.NO  = "_end"
		End if

		'타입 석어서 보내기
		Call oJSONoutput.Set("result", "0" )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.write "`##`"	


		'Response.write  dataarr(no)




  Set rs = Nothing
  db.Dispose
  Set db = Nothing

%>
<tr class="gametitle"  style="cursor:pointer">
		<td><%=no%></td>
		<td><%=gametitle%></td>
		<td><%=f_teamgbnm & "/" & f_levelnm & "/" & f_class & "/" & f_chelp %></td>
		<td><%=f_pubname%></td>
		<td><%=f_pnm%></td>
		<td><%=f_hnm%></td>
		<td><%=f_teamnm%></td>
</tr>