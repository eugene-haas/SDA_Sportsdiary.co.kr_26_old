<%'<!-- #include virtual = "/pub/header.swimmingAdmin.asp" -->%>
<%
	'테스트 확인
'	Set db = new clsDBHelper
'	tidx = "129"
'	tcode = "SW00732"
'	leaderidx = "5615"
'	PayMethod = "Card"
'	Order_tid = "StdpayCARDswsportsdi20210129102059065945"
'	Order_MOID = "swsportsdi_1611883239202"



			'리더정보체크
				SQL = "Select username  from tblReader where idx = '"&leaderidx&"' "
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				If rs.eof Then
					'오류 ~ 어디로 보내 리더가 없을수 없잖아
					Call CencelafterOK("리더정보없음" & leaderidx)
					Response.end
				else
					leadernm = rs(0)
				End if

			'결제정보체크
				SQL_Order = "Select orderidx From tblSwwimingOrderTable "
				SQL_Order = SQL_Order & " Where del_yn = 'N'  "
				SQL_Order = SQL_Order & " and gametitleidx = '" & tidx & "'	"
				SQL_Order = SQL_Order & " and LeaderIDX = '"&leaderidx&"'  and  oorderstate in ( '01', '00') " '가상계좌이고 00 결제전이 있어도 결제되면 안됨
				Set rs = db.ExecSQLReturnRS(SQL_Order , null, ConStr)
				If Not rs.eof Then
					'결제정보가 있는데 오면 안됨.
					Call CencelafterOK("결제정보있음_"&rs(0))
					Response.end
				End if


			'가상계좌여부 확인 (가상계좌처리)
				If PayMethod = "VBank" Then
					endurl = "/home/page/apply-parti.asp"
					payOK = "N"
					delYN = "Y"
				Else
					endurl = "/home/page/apply-parti.asp"
					payOK = "Y"
					delYN = "N"
				End if

			'개인 경기 참가자 넣기#####################################################(팀이 한번만 등록한다 요점) ---띠발 바꿨다..룰이 여러번 넣는다.....
				insertFLD = " GameTitleIDX,gbIDX,levelno,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,P1_ksportsno,P1_PlayerIDX,P1_UserName,P1_UserClass,P1_Team,P1_TeamNm,P1_UserPhone,P1_Birthday,P1_SEX,sido,sidonm,bestRC,ITgubun "
				insertFLD = insertFLD &  " ,paymentIDX,paymentNm,paymentType,payOK, Order_tid, Order_MOID			,delyn " 'delyn 가상계좌 사용 흠
				bestrcstr = " select top 1 gameresult from tblRecord where  kskey = a.kskey  and  levelno = b.levelno order by gameresult asc   "

				fld = " A.tidx,B.gbIDX,B.levelno,B.CDA,B.CDANM,B.CDB,B.CDBNM,B.CDC,B.CDCNM,kskey,playeridx,username,userclass,team,teamnm,userphone,birthday,sex,a.sido,a.sidonm"
				fld = fld & " ,("&bestrcstr&"),b.ITgubun, '"&leaderidx&"','"&leadernm&"','"&PayMethod&"', '"&payOK&"', '"&Order_tid&"','"&Order_MOID&"' , '"&delyn&"' "
				selectQ = "Select "&fld&" from tblGameRequest_imsi as A inner join tblGameRequest_imsi_r as B ON a.seq = b.seq  where  a.leaderidx = '"&leaderidx&"' "
				selectQ = selectQ & " and a.tidx = " & tidx & " and a.team = '"&tcode&"' and b.ITgubun = 'I' and a.payOk = 'N' " '취소한 내역이 있으면 중복되므로 and a.payOk = 

				SQL = "insert Into tblGameRequest ("&insertFLD&")  ("&selectQ&")"
				Call db.execSQLRs(SQL , null, ConStr)

				
				
				fld = " GameTitleIDX,ITgubun,P1_ksportsno,P1_PlayerIDX,P1_UserName,gbIDX,levelno,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,P1_Team,P1_TeamNm,P1_UserClass,P1_SEX,sidonm,RequestIDX		,joo,rane,'1' "
				minfld = " GameTitleIDX,Itgubun,ksportsno,PlayerIDX,userName,gbIDX,levelno,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,Team,TeamNm,userClass,Sex,sidonm,requestIDX "
				selectQ = "Select "&fld&" from tblGameRequest where delyn = 'N' and ITgubun= 'I' and  P1_playeridx>0 and GameTitleIDX = " & tidx  
				selectQ = selectQ & " and p1_team = '"&tcode&"'  and paymentIDX = '"&leaderidx&"'  " '개인 다른 동일한 선수꺼면...어쩌지 할필요 없다 팀에서 다넣는다.

				'음...가상계좌에서 넣으면 안들어간다. 이건 결제 완료되는시점에 넣어주어야한다.
				If PayMethod <> "VBank" Then
					SQL = "insert Into sd_gameMember ("&minfld&",tryoutgroupno,tryoutsortNo,gubun)  ("&selectQ&")"
					Call db.execSQLRs(SQL , null, ConStr)
				End if


			'단체@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

				'계영 팀 넣기 (팀단위로 넣어야함) 리더가 등록하므로 한번만 올꺼다... 하나만 넣으면된다.
				'계영 팀 넣기 (단체팀 이미 들어간게 있는지 검사후 넣는다. except select  보다  left join  으로 처리하는게 좋을것 같다. ) -- 요고 잘못된생각 팀이 한번만 오고 여러명으로 보낸다..그러므로 종목별로 넣으면 된다.
				fld = " "&tidx&",max(b.gbIDX),b.levelno,max(b.CDA),max(b.CDANM),max(b.CDB),max(b.CDBNM),max(b.CDC),max(b.CDCNM),'','0','단체','0',team,teamnm,Null,'0',max(sex),max(a.sido),max(a.sidonm)"
				fld = fld & ",Null,'T' , '"&leaderidx&"','"&leadernm&"','"&PayMethod&"','"&payOK&"', '"&Order_tid&"','"&Order_MOID&"' , '"&delyn&"' "
				selectQ = "Select "&fld&" from  tblGameRequest_imsi as A inner join tblGameRequest_imsi_r as B ON a.seq = b.seq  "
				selectQ = selectQ & " where a.leaderidx = '"&leaderidx&"' and  a.tidx = " & tidx & " and a.team = '"&tcode&"' and b.ITgubun = 'T' and a.payOK = 'N' group by b.levelno,a.team,a.teamnm"   '취소한 내역이 있으면 중복되므로 and a.payOk = 'N'  넣자.
				SQL = "insert Into tblGameRequest ("&insertFLD&")  ("&selectQ&") "
				Call db.execSQLRs(SQL , null, ConStr)



				If PayMethod <> "VBank" Then
					'단체명만 대진표에 넣기 
					fld = " GameTitleIDX,ITgubun,P1_ksportsno,P1_PlayerIDX,P1_UserName,gbIDX,levelno,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,P1_Team,P1_TeamNm,P1_UserClass,P1_SEX,sidonm,RequestIDX		,joo,rane,'1' ,paymentIDX"
					minfld = " GameTitleIDX,Itgubun,ksportsno,PlayerIDX,userName,gbIDX,levelno,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,Team,TeamNm,userClass,Sex,sidonm,requestIDX "
					selectQ = "Select "&fld&" from tblGameRequest  where delyn = 'N' and ITgubun= 'T' and P1_playeridx='0' and GameTitleIDX = " & tidx  & " and  p1_team = '"&tcode&"'    and paymentIDX = '"&leaderidx&"'   "

					'음...가상계좌에서 넣으면 안들어간다. 이건 결제 완료되는시점에 넣어주어야한다. (leaderidx : 리더 인덱스 (신청자) 팀은 리더당 한팀만 등록하여야한다.)  21.06.15 리더필드추가
					SQL = "insert Into sd_gameMember ("&minfld&",tryoutgroupno,tryoutsortNo,gubun,leaderidx)  ("&selectQ&")"
					Call db.execSQLRs(SQL , null, ConStr)


					'E2  단체선수 저장 #################21.06.15 (수구는빼야한다)
					selectQ = "Select m.gamememberidx,m.requestidx,a.playeridx,a.kskey,a.username,a.sex,a.team,a.teamnm,a.sido  from tblGameRequest_imsi as a inner join tblGameRequest_imsi_r as b "
					selectQ = selectQ & " ON a.seq = b.seq and a.tidx = "& tidx &" and a.delyn = 'N' "
					selectQ = selectQ & " inner join sd_gameMember as m "
					selectQ = selectQ & " On a.tidx = m.GameTitleIDX and b.gbidx = m.gbidx   and a.team = m.team and a.leaderIDX = m.leaderidx  and m.DelYN = 'N' and m.ITgubun = 'T'  and ((m.cda = 'E2'  and m.cdc <> '31' ) or (m.cda = 'F2')) "  
					selectQ = selectQ & " where b.delyn = 'N' and b.ITgubun = 'T' and ((b.cda ='E2'  and b.cdc <> '31') or (m.cda = 'F2'))  and a.team = '"&tcode&"'  and a.leaderidx = '"&leaderidx&"' "

					SQL = "Insert Into sd_gameMember_partner (gamememberidx,requestidx,playeridx,ksportsno,username,sex,team,teamnm,sido) ("&selectQ&") "
					Call db.execSQLRs(SQL , null, ConStr)
					'E2  단체선수 저장 #################21.06.15 (수구는빼야한다)


					'신청 계영참가자 넣기(단체전) 음 머가 문제지 찾아보자.... 
					fld = "  c.requestIDX,a.kskey,a.playeridx, a.username,a.userclass,a.team,a.teamnm,a.sex, '"&Order_MOID&"' ,b.capno"				

					selectQ ="				   select "&fld&" from tblGameRequest_imsi as a inner join tblGameRequest_imsi_r as b      ON         a.seq = b.seq and b.delyn = 'N'  " '21.06.15 and a.leaderidx =  c.paymentIDX  추가
					selectQ = selectQ & "  inner join tblGameRequest as c      ON        a.tidx = c.gametitleidx and a.team = c.p1_team and b.ITgubun = c.ITgubun and b.levelno = c.levelno and c.delyn = 'N'  and c.ITgubun= 'T'  and a.leaderidx =  c.paymentIDX "
					selectQ = selectQ & "  where a.delyn = 'N' and a.tidx = "&tidx&" and a.team = '"&tcode&"'  and a.leaderidx = '"&leaderidx&"' " '리더당 한팀만 등록가능함

					insertFLD = " requestIDX,kskey,playeridx,username,userClass,team,teamnm,sex     ,Order_MOID , capno "					
					SQL = "insert Into tblGameRequest_r ("&insertFLD&")  ("&selectQ&")"
					Call db.execSQLRs(SQL , null, ConStr)
			
					'startType 설정하기 (있는것만 업데이트 하는거니 상관없겠지 ..ㅜㅜ)
					SQL = ";with tbl as ( "
					SQL = SQL & " select a.levelno,max(b.gametimess)as gs ,COUNT(*) as cnt from sd_gameMember as a INNER JOIN tblTeamGbInfo as b "
					SQL = SQL & " ON a.cdc = b.teamgb and b.delyn = 'N'  where a.delyn = 'N' and  a.GameTitleIDX = '"&tidx&"' and a.team = '"&tcode&"'  and b.cd_type='1' and PTeamGb = 'D2'  group by a.levelno )" 'tblTeamGbInfo.cd_type  레벨찾기

					'음...가상계좌에서 넣으면 안들어간다. 이건 결제 완료되는시점에 넣어주어야한다.
					SQL = SQL & " update sd_gameMember set startType= '3' where GameTitleIDX = '"&tidx&"' and levelno in ( select levelno from tbl where cnt <= 8 or gs >= 320) " '걸리는시간이 320 , 출전선수가 8명이하면 시작을 3으로
					Call db.execSQLRs(SQL , null, ConStr)
				End If


			SQL = "update tblGameRequest_imsi set payOk = '"&payOK&"' where tidx = " & tidx & " and team = '"&tcode&"' and payOk = 'N' and leaderidx = '"&leaderidx&"' " '단체전은 참가비가 없으니 일딴 여기까지 payok는 실결제가 완료일수도 아닐수도 vbank는 별도 체크해야한다.
			Call db.execSQLRs(SQL , null, ConStr)
%>