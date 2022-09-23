<!-- #include virtual = "/pub/api/sms/reqAjaxSms.asp" -->
<%

'#############################################
' 랭크 포인트 조회
'#############################################
	'request

    SMS_title=""'--제목
    SMS_Contents="" '--내용
    SMS_Recive_No=""'--수신번호
    SMS_Send_No="02-2249-6130" '--발신번호 (발신 확인번호 등록 유의) --기본값 : ? 
    SMS_Send_Type="3"'--3:SMS, 5:LMS
    SMS_Send_fileUrl="C:\UMSBiz\Conts\"'LMS 일때 기본 경로
    SMS_sql_idx=""
    
	If sitecode = "" Then
		sitecode = "TENNIS01"	
	End if


    If hasown(oJSONoutput, "SMS_title") = "ok" then	 '--제목
	    SMS_title = oJSONoutput.SMS_title
    end if 
    If hasown(oJSONoutput, "SMS_Recive_No") = "ok" then	 '--수신번호
	    SMS_Recive_No = oJSONoutput.SMS_Recive_No
    end if 
    If hasown(oJSONoutput, "SMS_Send_No") = "ok" then	 '--발신번호 (발신 확인번호 등록 유의)
	    SMS_Send_No = oJSONoutput.SMS_Send_No
    end if 

    If hasown(oJSONoutput, "SMS_dtStart") = "ok" then	 '--발신시간
	    SMS_dtStart  =oJSONoutput.SMS_dtStart
    end if 
    If hasown(oJSONoutput, "SMS_dtStartTime") = "ok" then	 '--발신시간
	    SMS_dtStartTime  = oJSONoutput.SMS_dtStartTime
    end if 
    
    if  SMS_dtStart ="" then 
        SMS_dtStart=""
        SMS_dtStartTime=""
    end if

    if SMS_Send_No ="" then 
        SMS_Send_No="02-2249-6130"
    end if 

	'test 
    'SMS_Send_No="02-2249-6130"
	'SMS_Recive_No="01096311107"
     
    If hasown(oJSONoutput, "SMS_Contents") = "ok" then	 '--내용
	    SMS_Contents = Replace(oJSONoutput.SMS_Contents,"<br>",chr(13)&chr(10))

        if len(SMS_Contents)>=80 then 
            SMS_Send_Type="5"
            '파일 저장  (기본 절대 경로 ) 
            SMS_Send_filetxtName = "Lms_"&replace(SMS_dtStartTime,"-","")&"_"&SMS_Recive_No&".txt"
            Set stm2 = server.CreateObject("ADODB.Stream")
            stm2.Open 
            stm2.Type = 2				'adTypeBinary (1), TEXT(2)
            stm2.Charset = "euc-kr"		'또는 UTF-8
            stm2.WriteText(SMS_Contents)
            f_name = SMS_Send_fileUrl & SMS_Send_filetxtName
            call stm2.SaveToFile(f_name , 2)

        end if 
    end if 

    SMS_sql=""
    '쿼리 스트링
    If hasown(oJSONoutput, "SMS_sql_idx") = "ok" then	 
	    SMS_sql_idx  = oJSONoutput.SMS_sql_idx

        If hasown(oJSONoutput, "SMS_sql_param1") = "ok" then	 
	        SMS_sql = replace(SMS_sql_idx,"@SMS_sql_param1",oJSONoutput.SMS_sql_param1)
        end if 
        If hasown(oJSONoutput, "SMS_sql_param2") = "ok" then
	        SMS_sql = replace(SMS_sql_idx,"@SMS_sql_param2",oJSONoutput.SMS_sql_param2)	 
        end if 
        If hasown(oJSONoutput, "SMS_sql_param3") = "ok" then	
	        SMS_sql = replace(SMS_sql_idx,"@SMS_sql_param3",oJSONoutput.SMS_sql_param3) 
        end if 
        If hasown(oJSONoutput, "SMS_sql_param4") = "ok" then
	        SMS_sql = replace(SMS_sql_idx,"@SMS_sql_param4",oJSONoutput.SMS_sql_param4)	 
        end if 
        If hasown(oJSONoutput, "SMS_sql_param5") = "ok" then
	        SMS_sql = replace(SMS_sql_idx,"@SMS_sql_param5",oJSONoutput.SMS_sql_param5)	 
        end if 
        If hasown(oJSONoutput, "SMS_sql_param6") = "ok" then
	        SMS_sql = replace(SMS_sql_idx,"@SMS_sql_param6",oJSONoutput.SMS_sql_param6)	 
        end if 
        If hasown(oJSONoutput, "SMS_sql_param7") = "ok" then
	        SMS_sql = replace(SMS_sql_idx,"@SMS_sql_param7",oJSONoutput.SMS_sql_param7)	 
        end if 
        If hasown(oJSONoutput, "SMS_sql_param8") = "ok" then
	        SMS_sql = replace(SMS_sql_idx,"@SMS_sql_param8",oJSONoutput.SMS_sql_param8)	 
        end if 
    end if 

    '문자내용 체크
    if SMS_Contents= "" then 
         Call oJSONoutput.Set("result", "2" ) 
	    strjson = JSON.stringify(oJSONoutput)
	    Response.Write CStr(strjson)
        Response.end
    end if
    '수신번호 체크
    if SMS_Recive_No= "" then 
        Call oJSONoutput.Set("result", "3" ) 
	    strjson = JSON.stringify(oJSONoutput)
	    Response.Write CStr(strjson)
        Response.end
    end if

    if SMS_sql_idx ="" then
    
        InSQL = "INSERT INTO [SD_Tennis].[dbo].[t_send]"
        InSQL = InSQL&"("
        InSQL = InSQL&" SSUBJECT "
        InSQL = InSQL&",NSVCTYPE "
        InSQL = InSQL&",NADDRTYPE"
        InSQL = InSQL&",SADDRS "
        InSQL = InSQL&",NCONTSTYPE"
        InSQL = InSQL&",SCONTS"
        InSQL = InSQL&",SFROM"
        InSQL = InSQL&",DTSTARTTIME"

	'################################멀티사용
		If sitecode <> "" Then
        InSQL = InSQL&",sitecode"
		End if
	'################################멀티사용
		
		
		InSQL = InSQL&")"
        InSQL = InSQL&" VALUES "
        subsql=""
        arrAge = split(SMS_Recive_No,"|")
        count = UBound(arrAge)
         if count>0 then 
            for i=0 to count
                
                if arrAge(i) <>"" then 

                    if subsql<>"" then 
                        subsql = subsql &","
                    end if 

                subsql = subsql&"("
                subsql = subsql&"'"&SMS_title&"'"  'SSUBJECT
                subsql = subsql&",'"&SMS_Send_Type&"' " 'NSVCTYPE --3:SMS, 5:LMS 
                subsql = subsql&",0 "
                subsql = subsql&",'"&arrAge(i)&"'" 'SADDRS --수신번호 
                subsql = subsql&",0"
                if SMS_Send_Type="3" then 
                    subsql = subsql&",'"&SMS_Contents&"'" 'SCONTS -- 내용
                else
                    subsql = subsql&",'"&SMS_Send_filetxtName&"'" 'SCONTS -- txt파일명
                end if 
                subsql = subsql&",'"&SMS_Send_No&"'" 'SFROM --발신번호 (발신 확인번호 등록 유의)
                if SMS_dtStartTime="" then
                    subsql = subsql&",getdate()"'DTSTARTTIME --발신시간(예약시간)--빈값은 getdate()
                else
                    subsql = subsql&",'"&SMS_dtStart &" "& SMS_dtStartTime&"'"'DTSTARTTIME --발신시간(예약시간)--빈값은 getdate()
                end if 

				'################################멀티사용
					If sitecode <> "" Then
                    subsql = subsql&", '"&sitecode&"' "
					End if
				'################################멀티사용


                subsql = subsql&")"
                end if

            next 
        else
                InSQL = InSQL&"("
                InSQL = InSQL&"'"&SMS_title&"'"  'SSUBJECT
                InSQL = InSQL&",'"&SMS_Send_Type&"' " 'NSVCTYPE --3:SMS, 5:LMS 
                InSQL = InSQL&",0 "
                InSQL = InSQL&",'"&SMS_Recive_No&"'" 'SADDRS --수신번호 
                InSQL = InSQL&",0"
                if SMS_Send_Type="3" then 
                    InSQL = InSQL&",'"&SMS_Contents&"'" 'SCONTS -- 내용
                else
                    InSQL = InSQL&",'"&SMS_Send_filetxtName&"'" 'SCONTS -- txt파일명
                end if 
                InSQL = InSQL&",'"&SMS_Send_No&"'" 'SFROM --발신번호 (발신 확인번호 등록 유의)
                if SMS_dtStartTime="" then
                    InSQL = InSQL&",getdate()"'DTSTARTTIME --발신시간(예약시간)--빈값은 getdate()
                else
                    InSQL = InSQL&",'"&SMS_dtStart &" "& SMS_dtStartTime&"'"'DTSTARTTIME --발신시간(예약시간)--빈값은 getdate()
                end if 

				'################################멀티사용
					If sitecode <> "" Then
                    InSQL = InSQL&", '"&sitecode&"' "
					End if
				'################################멀티사용
				
				InSQL = InSQL&")"
        end if

        
        if subsql<>"" then 
            InSQL =InSQL& subsql 
        end if 
        SMS_sql = InSQL 
    end if 

'Response.write InSQL & "--<br>"	
'Response.write subsql & "--<br>"	
'Response.write SMS_sql
'Response.end


    Set db = new clsDBHelper

    if SMS_sql <>"" then 
        Call db.execSQLRs(SMS_sql , null, ConStr)	
        
        Call oJSONoutput.Set("result", "0" ) 
    else
        
        Call oJSONoutput.Set("result", "999" ) 
    end if
    
    
strjson = JSON.stringify(oJSONoutput)
Response.Write CStr(strjson) 
db.Dispose
Set db = Nothing

%>