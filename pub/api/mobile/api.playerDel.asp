<%
'#############################################
'참가 신청자 정보 요청
'#############################################
	'request
	ridx =  oJSONoutput.ridx
	pidx = oJSONoutput.pidx
	tidx = oJSONoutput.tidx
	levelno = oJSONoutput.levelno
	key1 = "tn001001" '개인천

	inbankname = ""
	inbank = ""
	inbankacc = ""

	If hasown(oJSONoutput, "inbankname") = "ok" then	 '이름
		inbankname = oJSONoutput.inbankname
	End If
	If hasown(oJSONoutput, "inbank") = "ok" then	 '은행
		inbank = oJSONoutput.inbank
	End If
	If hasown(oJSONoutput, "inbankacc") = "ok" then	 '환불계좌 (암화화하자)
		inbankacc = oJSONoutput.inbankacc
		inbankacc = f_enc(Replace(inbankacc,"-",""))
	End If

	Set db = new clsDBHelper

	'삭제플레그 확인
	SQL = "Select cfg,teamGbNm from tblRGameLevel where GameTitleIDX = "&tidx&" and Level = '"&levelno&"' and delYN = 'N' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	teamGbNm = rs("teamGbNm")
	cfg = rs("cfg") '변형요강, 신청, 수정 ,삭제
	chk1 = Left(cfg,1)
	chk2 = Mid(cfg,2,1)
	chk3 = Mid(cfg,3,1)
	chk4 = Mid(cfg,4,1)
	If chk4 = "N" Then
		Call oJSONoutput.Set("result", "54" ) '삭제신청제한
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End If


	'발급받은 가상계좌정보 사용막음
	If ridx <> "" And isnull(ridx) = False then
	SQL = "UPDATE TB_RVAS_MAST Set STAT_CD = '0' where CUST_CD = '" & ridx & "' "
	Call db.execSQLRs(SQL , null, ConStr)
	End if


	'입금완료여부확인
	SQL = "Select VACCT_NO from TB_RVAS_LIST where CUST_CD = '" & ridx & "' and STAT_CD = '0' and ERP_PROC_YN = 'N'  "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)	

	If Not rs.eof Then
		payok = "ok"
		'입금받을 가상계좌 번호를 암호화 해서 넣어둔다.
		SQL = "Update TB_RVAS_LIST Set  recustnm = '"&inbankname&"' , rebanknm='"&inbank&"', refund = '"& inbankacc &"',tidx='"&tidx&"',levelno='"&levelno&"',refunddate=getdate() where CUST_CD = '" & ridx & "' and STAT_CD = '0' "
		Call db.execSQLRs(SQL , null, ConStr)
	End If


	'#################	
	Sub attreg()'대진등록 삭제
		Dim strWhere , SQL
		SQLsub = " ( select gamememberidx from sd_tennismember where GameTitleIDX = " & tidx & " and  gamekey3 = " & levelno & " and gubun = 0 and (playerIDX = " & pidx & "  or requestIDX='"&ridx&"') )"
		SQL = "DELETE From sd_TennisMember  Where gamememberidx  in " & SQLsub
		Call db.execSQLRs(SQL , null, ConStr)
		SQL = "DELETE From sd_TennisMember_partner  Where gamememberidx  in " & SQLsub
		Call db.execSQLRs(SQL , null, ConStr)
	End sub

	Sub attdelete() '참가신청삭제
		Dim SQL
		SQL ="update tblGameRequest SEt DelYN = 'Y' where RequestIDX = " & ridx '참가신청삭제
		Call db.execSQLRs(SQL , null, ConStr)
	End sub
	'#################

	'대회정보
	SQL ="SELECT count(*)  FROM tblGameRequest where  GameTitleIDX = " & tidx & " and Level = " & levelno & " and DelYN = 'N' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	attCNT = rs(0) '현재까지 참가자수

	SQL = "Select top 1 attmembercnt from tblRGameLevel where GameTitleIDX = " & tidx & " and level = '"&levelno&"' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)	
	attmembercnt = rs("attmembercnt") '참가 제한수

	If Cdbl(attCNT) <= CDbl(attmembercnt) Then	'삭제
		Call attreg()
		Call attdelete()
	Else
		'삭제하는 아이가 몇번째 아이인지 찾아야겠군.	
		SQL ="SELECT count(*) FROM tblGameRequest where  GameTitleIDX = " & tidx & " and Level = " & levelno & " and DelYN = 'N' and RequestIDX <= " & ridx
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		myno = rs(0)
		
		If CDbl(myno) <= CDbl(attmembercnt) Then '참가 인원 안쪽이라면
			Call attreg()
			Call attdelete()

			'1번 대기자를 찾아서 대진표 인서트
			sfield = " RequestIDX,UserName,UserPhone,P1_PlayerIDX,P1_UserName,P1_TeamNm,P1_TeamNm2, P2_PlayerIDX,P2_UserName,P2_TeamNm,P2_TeamNm2,P1_UserPhone,P2_UserPhone "
			SQL ="SELECT top "& CDbl(attmembercnt) + 1  &" "&sfield&"  FROM tblGameRequest where  GameTitleIDX = " & tidx & " and Level = " & levelno & " and DelYN = 'N'  order by RequestIDX asc"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			rs.movelast

			attidx				 = rs("RequestIDX")
			attname			 = rs("UserName")
			attphone		 = rs("UserPhone")

			p1idx				 = rs("P1_PlayerIDX")
			p1name			 = rs("P1_UserName")
			p1team1txt		 = rs("P1_TeamNm")
			p1team2txt		 = rs("P1_TeamNm2")
			p1phone			 = rs("P1_UserPhone")

			p2idx				 = rs("P2_PlayerIDX")
			p2name			 = rs("P2_UserName")
			p2team1txt 	 = rs("P2_TeamNm")
			p2team2txt 	 = rs("P2_TeamNm2")
			p2phone			 = rs("P2_UserPhone")

			
			'문자전송을 위해서 발송횟수 초기화
			SQL =  "update tblGameRequest Set lmsSendChk = 0 Where RequestIDX = " & attidx
			Call db.execSQLRs(SQL , null, ConStr)			
			'################################################
			'대진표등록
			'################################################
				'등록여부확인
				SQL = "Select playeridx from sd_TennisMember where GameTitleIDX = "&tidx&" and gamekey3 = "&levelno&" and playeridx = "&p1idx&" and delYN = 'N' "
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

				If rs.eof then
					insertfield = " gubun, GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,key3name,TeamANa,TeamBNa ,requestIDX"
					insertvalue = " 0, "&tidx&", "&p1idx&", '"&p1name&"', '"&key1&"',"&Left(levelno,3)&","&levelno&","&Left(levelno,5)&",'"&teamgbNm&"','"&p1team1txt&"','"&p1team2txt&"'  , "&attidx&" "
					SQL = "SET NOCOUNT ON  Insert into sd_TennisMember ("&insertfield&") values ("&insertvalue&")  SELECT @@IDENTITY"
					Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
					gamemidx = rs(0)	

					insertfield = " GameMemberIDX, PlayerIDX,userName,TeamANa,TeamBNa "
					insertvalue = " "&gamemidx&", "&p2idx&", '"&p2name&"','"&p2team1txt&"','"&p2team2txt&"' "
					SQL = "Insert into sd_TennisMember_partner ("&insertfield&") values ("&insertvalue&")"
					Call db.execSQLRs(SQL , null, ConStr)
				End If
			'################################################

		Else '대기자 삭제
			Call attdelete()
		End if
	End if


	If p1name = attname Or p2name = attname Then
		attname = ""
		attphone = ""
	End if

	'참가신청 문자발송정보
	Call oJSONoutput.Set("result", "0" )
	Call oJSONoutput.Set("attname", attname )
	Call oJSONoutput.Set("attphone", attphone )
	Call oJSONoutput.Set("p1name", p1name )
	Call oJSONoutput.Set("p1phone", p1phone )
	Call oJSONoutput.Set("p1name", p2name )
	Call oJSONoutput.Set("p1phone", p2phone )

	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	db.Dispose
	Set db = Nothing
%>
