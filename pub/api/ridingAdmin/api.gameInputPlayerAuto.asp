<%
'#############################################


'#############################################
	'request

	If hasown(oJSONoutput, "TIDX") = "ok" Then
		tidx = oJSONoutput.TIDX
	End If
	If hasown(oJSONoutput, "GBIDX") = "ok" Then
		gbidx = oJSONoutput.GBIDX
	End If

	If hasown(oJSONoutput, "PCODE") = "ok" Then
		pcode = oJSONoutput.PCODE
	End If
	
	If hasown(oJSONoutput, "PNM") = "ok" Then
		pnm = oJSONoutput.PNM '초등부
	End If
	

	If hasown(oJSONoutput, "AutoNo") = "ok" Then	
	autono = oJSONoutput.AutoNo
	End if

	Set db = new clsDBHelper


	'######################################
	'복합마술인경우
	'마장마술이던 장애물이던 먼저 온애가 자동생성하면 둘다 찾아서 생성한다. 
	'teamgb   팀코드  릴레이 20208 복합마술 20103
	'######################################


	SQL = "SELECT useyear,PTeamGb,PTeamGbNm,TeamGb,TeamGbNm,levelno,levelNm,ridingclass,ridingclasshelp FROM tblTeamGbInfo Where teamgbidx = " & gbidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.eof Then
		boo = rs("PTeamGbNm")
		gamekey1 = rs("PTeamGb") '개인/단체
		teamgb = rs("teamgb") '종목  릴레이 20208 복합마술 20103
		gamekey2 = rs("levelno") '외산마+국산마 ..
		TeamGbNm = rs("TeamGbNm")
		rclass = rs("ridingclass") '복합마술 마장마술 장애물 구분 또는 클레스 구분

		'복합마술 찾기
		If teamgb = "20103" Then

			SQL = "Select  top 1 gbidx,pubcode,pubname from tblRGameLevel where gametitleidx = " & tidx & " and levelno like '"&teamgb&"%'  and gbidx  <> '"&gbidx&"' "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			If Not rs.eof Then
				gbidx_2 = rs("gbidx")
				pcode_2 = rs("pubcode")
				pnm_2 = rs("pubname")

				SQL = "SELECT useyear,PTeamGb,PTeamGbNm,TeamGb,TeamGbNm,levelno,levelNm,ridingclass,ridingclasshelp FROM tblTeamGbInfo Where teamgbidx = " & gbidx_2
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

				boo_2 = rs("PTeamGbNm")
				gamekey1_2 = rs("PTeamGb") '개인/단체
				teamgb_2 = rs("teamgb") '종목  릴레이 20208 복합마술 20103
				gamekey_2 = rs("levelno") '외산마+국산마 ..
				TeamGbNm_2 = rs("TeamGbNm")
				rclass_2 = rs("ridingclass") '복합마술 마장마술 장애물 구분 또는 클레스 구분
			End if

		End if
	End if


	'1. 참여하지 않은 선수 두명을 가져온다. (중복되게 가져온다.)
	'2. 저장한다.

	'참가 신청하지 않은 유저 중에 검색작업할것 (선수는, 말은 조건에 따라 횟수로 올수 있다)
	'사람 1 말 1


	If gamekey1 = "202" And teamgb = "20208" then'단체라면 (이고 릴레이만) 다른경 개인하고 방식이 동일한데 나중에 집계가 틀리다.
	strSql = "SELECT top 1 PlayerIDX,UserName,team,TeamNm,TeamNm as t2,UserPhone,Birthday,Sex  from tblPlayer where DelYN = 'N' " & subSql & " and usertype = 'G' ORDER BY NEWID() "
	gubun = 1
	else
	strSql = "SELECT top 1 PlayerIDX,UserName,team,TeamNm,TeamNm as t2,UserPhone,Birthday,Sex  from tblPlayer where DelYN = 'N' " & subSql & " and usertype = 'P' ORDER BY NEWID() "
	gubun = 0
	End if
	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)
	
	If Not rs.EOF Then 
		arrRS = rs.GetRows()
	End if
		
	insertfield = " SportsGb, GameTitleIDX,gbidx,EnterType,UserPass,UserName,UserPhone,txtMemo,pubcode,pubname " '여러팀을 등록했을시 ...
	insertfield = insertfield & " ,P1_PlayerIDX,P1_UserName,P1_TeamNm,P1_TeamNm2,P1_UserPhone,P1_Birthday,P1_SEX,P1_rpoint "
	insertfield = insertfield & " ,P2_PlayerIDX,P2_UserName,P2_TeamNm,P2_TeamNm2,P2_UserPhone,P2_Birthday,P2_SEX,P2_rpoint "

	'복합마술 찾기
	If teamgb = "20103"   Then
	insertvalue_2 = " 'riding',"&tidx&",'"&gbidx_2&"','A','null','운영자','01000000000','자동생성' , '"&pcode_2&"' , '"&pnm_2&"' "	
	End if
	insertvalue = " 'riding',"&tidx&",'"&gbidx&"','A','null','운영자','01000000000','자동생성' , '"&pcode&"' , '"&pnm&"' "	

	
	If IsArray(arrRS) Then
		For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 
				p1idx = arrRS(0, ar) 
				p1nm = arrRS(1, ar) 
				'p1level =	 arrRS(2, ar) 
				p1team =	 arrRS(2, ar) 
				p1t1 =	 arrRS(3, ar) 
				p1t2 =	 arrRS(4, ar) 
				p1phone =	 arrRS(5, ar) 
				p1birth =	 arrRS(6, ar) 
				p1sex =	 arrRS(7, ar) 
				p1rpoint = 0
				If teamgb = "20103"   Then
				insertvalue_2 = insertvalue_2 & "," &  p1idx & " ,'"&p1nm&"','"&p1t1&"','"&p1t2&"','"&p1phone&"','"&p1birth&"','"&p1sex&"',"&p1rpoint&" "
				End if
				insertvalue = insertvalue & "," &  p1idx & " ,'"&p1nm&"','"&p1t1&"','"&p1t2&"','"&p1phone&"','"&p1birth&"','"&p1sex&"',"&p1rpoint&" "

		Next
	
	Else
		db.Dispose
		Set db = Nothing

		'타입 석어서 보내기
		Call oJSONoutput.Set("result", "1" )
		oJSONoutput.AutoNo = CDbl(autono) - 1
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.write "`##`"	
	End if


	'subSql = " and PlayerIDX not in (Select P2_PlayerIDX from tblGameRequest Where GameTitleIDX = " & tidx  & " and gbidx = " & gbidx &" and DelYN = 'N') "
	strSql = "SELECT top 1 PlayerIDX,UserName,team,TeamNm,TeamNm as t2,UserPhone,Birthday,Sex  from tblPlayer where DelYN = 'N' " & subSql & " and usertype = 'H' ORDER BY NEWID() "
	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)
	
	If Not rs.EOF Then 
		arrRS = rs.GetRows()
	End if


	If IsArray(arrRS) Then
		For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 
				p2idx = arrRS(0, ar) 
				p2nm = arrRS(1, ar) 
				'p2level =	 arrRS(2, ar) 
				p1team =	 arrRS(2, ar) 
				p2t1 =	 arrRS(3, ar) 
				p2t2 =	 arrRS(4, ar) 
				p2phone =	 arrRS(5, ar) 
				p2birth =	 arrRS(6, ar) 
				p2sex =	 arrRS(7, ar) 
				p2rpoint = 0
				If teamgb = "20103"   Then
				insertvalue_2 = insertvalue_2 & "," &  p2idx & " ,'"&p2nm&"','"&p2t1&"','"&p2t2&"','"&p2phone&"','"&p2birth&"','"&p2sex&"',"&p2rpoint&" "
				End if
				insertvalue = insertvalue & "," &  p2idx & " ,'"&p2nm&"','"&p2t1&"','"&p2t2&"','"&p2phone&"','"&p2birth&"','"&p2sex&"',"&p2rpoint&" "
		Next
	Else
		db.Dispose
		Set db = Nothing

		'타입 석어서 보내기
		Call oJSONoutput.Set("result", "1" )
		oJSONoutput.AutoNo = CDbl(autono) - 1
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.write "`##`"		
	End if



			'복합마술///////////////////////////////////
			If teamgb = "20103"   Then
				SQL = "SET NOCOUNT ON INSERT INTO tblGameRequest ( "&insertfield&" ) VALUES ("&insertvalue_2&") SELECT @@IDENTITY" 
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				idx_2 = rs(0)

				'################################################
				'대진표등록
				'################################################
				insertfield_2 = " gubun, GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,key3name,TeamANa,TeamBNa,rankpoint,  requestIDX, pubcode,pubname"
				insertvalue_2 = " "&gubun&", "&tidx&", "&p1idx&", '"&p1nm&"', '"&gamekey1_2&"','"&gamekey2_2&"',"&gbidx_2&","&teamgb_2&",'"&teamgbnm_2&"','"&p1t1&"','"&p1t2&"',"&p1rpoint&", "&idx_2&" ,'"&pcode_2&"' , '"&pnm_2&"'  "
				SQL = "SET NOCOUNT ON  Insert into sd_TennisMember ("&insertfield_2&") values ("&insertvalue_2&")  SELECT @@IDENTITY"
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				gamemidx_2 = rs(0)	

				insertfield_2 = " GameMemberIDX, PlayerIDX,userName,TeamANa,TeamBNa,rankpoint "
				insertvalue_2 = " "&gamemidx_2&", "&p2idx&", '"&p2nm&"','"&p2t1&"','"&p2t2&"',"&p2rpoint&"   "
				SQL = "Insert into sd_TennisMember_partner ("&insertfield_2&") values ("&insertvalue_2&")"
				Call db.execSQLRs(SQL , null, ConStr)
			End if
			'복합마술///////////////////////////////////





			SQL = "SET NOCOUNT ON INSERT INTO tblGameRequest ( "&insertfield&" ) VALUES ("&insertvalue&") SELECT @@IDENTITY" 
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			idx = rs(0)

			'################################################
			'대진표등록
			'################################################
			insertfield = " gubun, GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,key3name,TeamANa,TeamBNa,rankpoint,  requestIDX, pubcode,pubname"
			insertvalue = " "&gubun&", "&tidx&", "&p1idx&", '"&p1nm&"', '"&gamekey1&"','"&gamekey2&"',"&gbidx&","&teamgb&",'"&teamgbnm&"','"&p1t1&"','"&p1t2&"',"&p1rpoint&", "&idx&" ,'"&pcode&"' , '"&pnm&"'  "
			SQL = "SET NOCOUNT ON  Insert into sd_TennisMember ("&insertfield&") values ("&insertvalue&")  SELECT @@IDENTITY"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			gamemidx = rs(0)	

			insertfield = " GameMemberIDX, PlayerIDX,userName,TeamANa,TeamBNa,rankpoint "
			insertvalue = " "&gamemidx&", "&p2idx&", '"&p2nm&"','"&p2t1&"','"&p2t2&"',"&p2rpoint&"   "
			SQL = "Insert into sd_TennisMember_partner ("&insertfield&") values ("&insertvalue&")"
			Call db.execSQLRs(SQL , null, ConStr)		



			
			gamemember = "<a href=""javascript:if (window.confirm('참가를 취소하면 복구 되지 않습니다.')){mx.delPlayer("& idx &", "& playeridx &");}"" class='btn btn-default' >신청취소</a>"
			SQL = "SELECT top 1 EntryListYN from tblGameRequest where SportsGb = 'riding' and DelYN = 'N' and gbidx =" & gbidx & " and GameTitleIDX = "&tidx & " and RequestIDX = " &  idx 
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			If Not rs.eof  then
				rEntryListYN = rs("EntryListYN")
			End if

			If rEntryListYN = "Y" Then
				rEntryListYN="참가자"
			Else
				rEntryListYN="대기자"
			End If



			Set rs = Nothing
			db.Dispose
			Set db = Nothing

			'타입 석어서 보내기
			Call oJSONoutput.Set("result", "0" )
			oJSONoutput.AutoNo = CDbl(autono) - 1
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.write "`##`"

			%>
			<!-- #include virtual = "/pub/html/riding/gameinfoPlayerList.asp" -->
			<%		
%>