<!-- #include virtual = "/pub/header.RidingAdmin.asp" -->
<%
'############################################
%><!-- #include virtual = "/pub/setReq.asp" --><%'이걸열어서 디버깅하자.%><%
'#############################################


	'request
	If hasown(oJSONoutput, "TIDX") = "ok" Then 
		tidx = oJSONoutput.TIDX
	End If

	Set db = new clsDBHelper 

					
				'1. tblGameRequest 에넣기 (참가신청)
				insertFLD = " gametitleidx,gbidx,P1_playeridx,p1_username,p1_team,p1_teamnm,p1_userphone,p1_birthday,p1_sex,  p2_playeridx,p2_username,pubcode,engcode,pubname ,tempidx"

				fld = " gametitleidx,gbidx,P1_playeridx,p1_username,p1_team,p1_teamnm,p1_userphone,p1_birthday,p1_sex,  p2_playeridx,p2_username, pubcode,engcode,pubname ,idx"
				selectQ = "Select "&fld&" from tblGameRequest_TEMP where delyn = 'N' and GameTitleIDX = '" & tidx  & "'"
				SQL = "insert Into tblGameRequest ("&insertFLD&")  ("&selectQ&")"
				Call db.execSQLRs(SQL , null, ConStr)


				'2. sd_TennisMember 에넣기 (경기테이블 선수) gubun 편성전 0 으로 밀어넣자...기타 지구력 어쩌구 0 편성전   1 편성완료 , 릴레이 2 리그 , 3 토너먼트 등이 있을껀데 여긴 마장마술, 장애물만.....한다.
				'gamekey3 > gbidx  key3name > cdbnm
				insertFLD = " gubun,gametitleidx,gamekey3,gamekey1,teamgb,gamekey2,key3name, pubcode,engcode,pubname,   team,teamAna,  ksportsno,playeridx,username,sex ,tempidx"

				fld = " '0' as gubun,gametitleidx,gbidx,cda,(cda+cdb) as teamgb,(cda+cdb+cdc) as levelno,cdbnm,pubcode,engcode,pubname,  p1_team,p1_teamnm,  ksportsno, P1_playeridx,p1_username,p1_sex , idx "
				selectQ = "Select "&fld&" from tblGameRequest_TEMP where delyn = 'N' and  GameTitleIDX = '" & tidx  & "'"
				SQL = "insert Into sd_TennisMember ("&insertFLD&")  ("&selectQ&")"
				Call db.execSQLRs(SQL , null, ConStr)	

				'3. sd_TennisMember_partner  sd_TennisMember inner join tblGameRequest_TEMP 해서 말정보 insert
				insertFLD = " gameMemberIDX,playeridx,username "

				fld = " b.gamememberidx,a.P2_playeridx,a.P2_username "
				selectQ = "Select "&fld&" from  tblGameRequest_TEMP as a    INNER JOIN sd_TennisMember as b ON  a.idx = b.tempidx and b.delyn = 'N'   where a.delyn = 'N' and  a.GameTitleIDX = '" & tidx  & "'"
				SQL = "insert Into sd_TennisMember_partner ("&insertFLD&")  ("&selectQ&")"
				Call db.execSQLRs(SQL , null, ConStr)					

				'4. sd_TennisMember 에 tblGameRequest inner join tblGameRequest_TEMP 해서 requestIDX 업데이트
				SQL = "update sd_TennisMember set requestIDX = b.requestIDX FROM sd_TennisMember AS a INNER JOIN tblGameRequest AS b ON a.tempidx = b.tempidx and b.delyn = 'N'  where a.delyn = 'N' and  a.GameTitleIDX = '" & tidx  & "'" 
				Call db.execSQLRs(SQL , null, ConStr)		


		'다등록했으면 템프 삭제(진짜지우는게 좋을꺼같은데) 이건 뒤에 삭제버튼으로
		SQL = "update tblGameRequest_TEMP set delyn = 'Y' where GameTitleIDX = '" & tidx  & "'"
		Call db.execSQLRs(SQL , null, ConStr)


	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing


%>
