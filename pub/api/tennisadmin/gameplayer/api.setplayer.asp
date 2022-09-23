<%
'#############################################

'#############################################
	'request
	idx = oJSONoutput.IDX

	Set db = new clsDBHelper
	strTableName = "  tblGameRequest as a "
	lvlsql = " (select top 1 n.TeamGbNm + '('+ m.LevelNm + ')'  from tblRGameLevel as n left join tblLevelInfo as m  ON n. level = m.level  where n.level = a.level and n.GameTitleIDX = a.GameTitleIDX) as TeamGbNm "

	accsql = " (select top 1 (n.fee + n.fund)   from tblRGameLevel as n left join tblLevelInfo as m  ON n. level = m.level  where n.level = a.level and n.GameTitleIDX = a.GameTitleIDX) as accTotal "
	'paysql = " (select top 1 VACCT_NO from TB_RVAS_LIST where CUST_CD = a.RequestIDX) as payok " 체크할일 이 있을가


	strFieldName = " RequestIDX,GameTitleIDX,level,"&lvlsql&","&accsql&",EnterType,WriteDate,P1_PlayerIDX,P1_UserName,P1_UserLevel,P1_TeamNm,P1_TeamNm2,P1_UserPhone,P1_Birthday,P1_SEX  "
	strFieldName = strFieldName & " ,P2_PlayerIDX,P2_UserName,P2_UserLevel,P2_TeamNm,P2_TeamNm2,P2_UserPhone,P2_Birthday,P2_SEX,P1_rpoint,P2_rpoint  "
	strWhere = " DelYN = 'N' and RequestIDX = " & idx

	SQL = "Select "& strFieldName &" from "& strTableName &" where " & strWhere
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

'Response.write sql
'Response.end

	If Not rs.eof Then
		titleidx =			rs("GameTitleIDX")
		levelno = 		rs("level")
		TeamGbNm	=	rs("TeamGbNm")
		
		p1idx =			rs("P1_PlayerIDX")
		p1nm = 			rs("P1_UserName")
		p1t1 = 			rs("P1_TeamNm")
		p1t2 = 			rs("P1_TeamNm2")
		p1phone = 		rs("P1_UserPhone")
		p1birth = 		rs("P1_Birthday")
		p1sex =			rs("P1_SEX")


		p2idx =			rs("P2_PlayerIDX")
		p2nm = 			rs("P2_UserName")
		p2t1 = 			rs("P2_TeamNm")
		p2t2 = 			rs("P2_TeamNm2")
		p2phone = 		rs("P2_UserPhone")
		p2birth = 		rs("P2_Birthday")
		p2sex = 			rs("P2_SEX")

		p1rpoint = 		rs("P1_rpoint")
		p2rpoint = 		rs("P2_rpoint")
		acctotal =		rs("accTotal")
	End if

	'#########################################################
	Select Case Left(levelno,3)
	Case "201","200"
		boo = "개인전"
		gamekey1 = "tn001001"
	Case "202"
		boo = "단체전"
		gamekey1 = "tn001002"
	End Select


		If CDbl(acctotal) > 0 Then '금액이 0이상인 경우만
			'계좌발급
			'==========================================
			'가상계좌 정보를 설정해 둔다.  (빈계좌 하나를 가져온다.)
			'==========================================
				Function ConvertDateFormat(ByVal strDate)
					Dim tmpDate1, tmpDate2
					Dim returnDate
					tmpDate1 = Split(strDate, " ")
					tmpDate2 = Split(tmpDate1(2), ":")
					
					'오후라면 12시간을 더해준다
					If tmpDate1(1) = "오후" Then 
						'오후 12시는 정오를 가르키기 때문에 제외
						If CDbl(tmpDate2(0)) < 12 Then 
							tmpDate2(0) = CDbl(tmpDate2(0)) + 12
						End If 
					End If 
					
					returnDate = Replace(tmpDate1(0),"-","") & CheckFormat(tmpDate2(0),2) & CheckFormat(tmpDate2(1),2) & CheckFormat(tmpDate2(2),2)
					ConvertDateFormat = returnDate
				End Function 

				'자릿수를 맞추기 위한 함수
				Function CheckFormat(ByVal num, ByVal splitpos)
					Dim tmpNum : tmpNum = 10000000
					tmpNum = tmpNum + CDbl(num)
					CheckFormat = Right(tmpNum, splitpos)
				End Function 

				vcwhere = " VACCT_NO =  (Select top 1 VACCT_NO from TB_RVAS_MAST where CUST_CD is null  and USER_NM is null) " '이름과 ridx 가 널인값만  현장입금 처리때문에
				SQL = "Update TB_RVAS_MAST Set STAT_CD = '1' ,IN_GB = '2', PAY_AMT = " & acctotal & ", CUST_CD = '" & idx & "' ,CUST_NM = '한국테니스진흥협회' , USER_NM = '" & p1nm & "',ENTRY_DATE= '" & ConvertDateFormat(Now()) & "' where " & vcwhere
				Call db.execSQLRs(SQL , null, ConStr)


				SQL = "Select VACCT_NO from TB_RVAS_MAST where CUST_CD = '" &idx& "' "
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			    vacctno = rs(0)

			'==========================================
			'문자전송
				SQL = "select gametitlename from sd_tennistitle where gametitleidx = " & titleidx
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			    gametitlename = rs(0)
				'If InStr(gametitlename," " ) > 1 Then
				'	gtnm = Split(gametitlename, " " )
				'	gametitlename = gtnm(1)
				'End if

'				SMS_title = "" 'SSUBJECT
'				SMS_Send_Type = 3 'NSVCTYPE --3:SMS, 5:LMS 
'				SMS_DDRS = p1phone 'SADDRS --수신번호 
'				SMS_Contents = gametitlename & TeamGbNm & "참가자.가상계좌:KEB하나은행("&vacctno&") 금액:"&acctotal&"원"	'SCONTS -- 내용
'				SMS_Send_No="02-2249-6130" 'SFROM --발신번호 (발신 확인번호 등록 유의)
'
'				insertvalues = " '"&SMS_title&"','"&SMS_Send_Type&"',0,'"&SMS_DDRS&"',0,'"&SMS_Contents&"','"&SMS_Send_No&"',getdate() "
'				SQL = "INSERT INTO t_send (SSUBJECT ,NSVCTYPE ,NADDRTYPE,SADDRS ,NCONTSTYPE,SCONTS,SFROM,DTSTARTTIME) VALUES ("&insertvalues&")"
'				Call db.execSQLRs(SQL , null, ConStr)	

				SMS_Subject = "["&gametitlename&"]입금대기전환안내"

				If sitecode = "" Then
					'sitecode = "TENNIS01"	 '21.11.12 로그에 안보이게 해달라고 해서 뺌 (국장 요청)
				End If
	
				fromNumber = "027040282"
				'fromNumber = "05055550055"
				toNumber = p1phone
				SMS_Msg = ""
				SMS_Msg = SMS_Msg & "- "&p1nm&"/"&p2nm&")\n "
				SMS_Msg = SMS_Msg & ""&gametitlename&"  "&TeamGbNm&" 입금대기로 전환\n"
				SMS_Msg = SMS_Msg & "24시간내 (3일전은 3시간, 2일전부터는 1시간) 미입금시 접수취소됩니다. \n"

				SMS_Msg = SMS_Msg & "- 가상계좌 : " & vacctno & "\n"
				SMS_Msg = SMS_Msg & "- 은행명 : KEB하나은행\n"
				SMS_Msg = SMS_Msg & "- 참가비 : " & acctotal & "원  \n\n"
				
				Call sendPhoneMessage(db, "7", SMS_Subject, SMS_Msg, sitecode,fromNumber,  toNumber)

				SQL = "update tblGameRequest set lastupdate = getdate() where requestidx = " & idx
				Call db.execSQLRs(SQL , null, ConStr)
			
			
			'==========================================
		End If
		




	insertfield = " gubun, GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,key3name,TeamANa,TeamBNa,rankpoint,RequestIDX "
	insertvalue = " 0, "&titleidx&", "&p1idx&", '"&p1nm&"', '"&gamekey1&"',"&Left(levelno,3)&","&levelno&","&Left(levelno,5)&",'"&Split(teamgbnm,"(")(0)&"','"&p1t1&"','"&p1t2&"',"&p1rpoint&","&idx&" " 
	SQL = "SET NOCOUNT ON  Insert into sd_TennisMember ("&insertfield&") values ("&insertvalue&")  SELECT @@IDENTITY"
	
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	gamemidx = rs(0)	

	insertfield = " GameMemberIDX, PlayerIDX,userName,TeamANa,TeamBNa,rankpoint "
	insertvalue = " "&gamemidx&", "&p2idx&", '"&p2nm&"','"&p2t1&"','"&p2t2&"',"&p2rpoint&"   "
	SQL = "Insert into sd_TennisMember_partner ("&insertfield&") values ("&insertvalue&")"
	Call db.execSQLRs(SQL , null, ConStr)		

	gamemember = "<a href='javascript:mx.delPlayer("&idx&","& gamemidx &")' class='btn_a' style='color:red'>신청취소</a>"

  db.Dispose
  Set db = Nothing
%>

<%=gamemember%>
