<%
'StateNo  게임 종료등 999

	title = oJSONoutput.title
	vacct = oJSONoutput.vacct
	money = oJSONoutput.money
	name = oJSONoutput.name
	phone = oJSONoutput.phone

    Set db = new clsDBHelper

			'==========================================
			'문자전송
				SMS_title = "" 'SSUBJECT
				SMS_Send_Type = 7 'NSVCTYPE --3:SMS, 5:LMS 
				'SMS_DDRS = "01047093650" 'SADDRS --수신번호 
				SMS_DDRS = phone 'SADDRS --수신번호 
				SMS_Contents = title & "의 발급된 가상계좌:KEB하나은행("&vacct&") 금액:"&money&"원 입니다. "	'SCONTS -- 내용
			
				SMS_Contents = SMS_Contents & " 24시간내 (3일전은 3시간, 2일전부터는 1시간) 미입금시 접수취소됩니다.  "	'SCONTS -- 내용

				SMS_Send_No="02-2249-6130" 'SFROM --발신번호 (발신 확인번호 등록 유의)
				'DTSTARTTIME --발신시간(예약시간)--빈값은 getdate()

				insertvalues = " '"&SMS_title&"','"&SMS_Send_Type&"',0,'"&SMS_DDRS&"',0,'"&SMS_Contents&"','"&SMS_Send_No&"',getdate() ,'TENNIS01' "
				SQL = "INSERT INTO t_send (SSUBJECT ,NSVCTYPE ,NADDRTYPE,SADDRS ,NCONTSTYPE,SCONTS,SFROM,DTSTARTTIME,sitecode) VALUES ("&insertvalues&")"
				Call db.execSQLRs(SQL , null, ConStr)	
			'==========================================


	  Call oJSONoutput.Set("result", "0" )
	  strjson = JSON.stringify(oJSONoutput)
	  Response.Write strjson

    db.Dispose
    Set db = Nothing
%>



