<% 
'   ===============================================================================     
'    Purpose : 지도자 쿠폰 관리를 위한 ajax Page
'    Make    : 2018.11.20
'    Author  :                                                       By Aramdry
'   ===============================================================================    
'    Call writeLog(LOCAL_LOG1, "db.work.asp --. start")   
%>

<% 
'   ===============================================================================     
'    아래 선언된 function들은 다음 경로를 참조하면 된다. 
'       /pub/fn/sql/fn.sql.coupon.asp   - coupon에 사용되는 모든 쿼리가 함수화 되어 있다. 
'       /pub/fn/fn.string.asp           - string 관련 함수들  
'       /pub/fn/fn.util.asp             - util 관련 함수들  - GetRandomKey()
'   abcde0526, abcdef, abcde123, abcde0804, abcde3308, abcdefg, abcde3075
'   ===============================================================================     
%> 

<% 
'   ===============================================================================         
'    Dim memIdx, userID, userName, userPhone
'    Dim nFind, strFind, aryUsers, couchKey, strJson, aryCouch
'    Dim strSub, strContent
   '   ===============================================================================   
   '   Json data 추출   
    If hasown(oJSONoutput, "CMD") = "ok" Then 
        cmd = oJSONoutput.CMD
    End If	

    If hasown(oJSONoutput, "POS") = "ok" Then 
        nPos = CDbl(oJSONoutput.POS)
    End If

    If hasown(oJSONoutput, "SEX") = "ok" Then 
        nSex = CDbl(oJSONoutput.SEX)
    End If
    
    '   ===============================================================================   

    '   ===============================================================================   
    '   테스트 아이디 등록
    '   ===============================================================================   
    '       1. 기존에 등록이 되어 있는 아이디 인지 검사  - 기존에 등록되어 있으면 패스 
    '       2. 연령대를 다양하게 넣기 위해 GetBirthDayForTest()사용
    '       3. 한번에 한쌍의 아이디를 생성한다. (남, 여)
    '       4. Pos 번호에 의하여 각종 변수값이 변한다. 
    '       5. 등록을 마친후, 등록 성공 메시지를 찍는다. 
    '   ===============================================================================  
    if( cmd = CMD_REG_TESTID ) Then 
'        Call writeLog(LOCAL_LOG1, "======================================= CMD_REG_TESTID")             
        
    '   ===============================================================================  
        nBaseKey = 1000
        If (nSex = 2) Then nBaseKey = 2000 End If

        nPos = nPos + 1
        nIDOrder = nPos+nBaseKey

        strID = strPrintf("sdTest_{0}", Array(nIDOrder))
        strPW = strPrintf("widline_{0}", Array(nIDOrder))
        nAge = GetAgeForTest(nPos)
        strBirthDay = GetBirthDayForTest(nAge)
        strRegDate = GetRegDayForTest(nPos)
        strPush = HasPushFlag(nPos)
        strSms = HasSmsFlag(nPos)

        strLog = strPrintf("strID = {0}, strPW = {1}, strBirthDay = {2}, strRegDay = {3}, strPush = {4}, strSms = {5}" , _ 
                    Array(strID, strPW, strBirthDay, strRegDay, strPush, strSms))
        
        'Call writeLog(LOCAL_LOG1, strLog) 

        strSql = getSQLInsertMember(strID, strPW, strBirthDay, strRegDate, strPush, strSms, nSex, nIDOrder)
        Call writeLog(LOCAL_LOG1, strSql) 

            
        Call oJSONoutput.Set("ID", strID)   
        Call db.execSQLRs(strSql , null, GDB_CONNSTR)  

'        If Not (rs.Eof Or rs.Bof) Then              ' 이미 등록되어 있다. 
'            rs.Close 
'            Call oJSONoutput.Set("result", "90" )     
'        Else 
'        '   ===============================================================================  
'            ' 2. 지도자 구분 Key 생성 3. 지도자 구분 Key 중복 검사 - 최대 20번 실패시 종료             
'            rs.Close 
'        End If
        
        strJson = JSON.stringify(oJSONoutput)
        strRtn = strPrintf("{0}`##`Empty html", Array(strJson)) 
        Call Response.Write(strRtn)
        
'        Call writeLog(LOCAL_LOG1, "======================================= CMD_REG_TESTID")        
    End if
%>

<%
    Set rs = Nothing

	Call db.Dispose
    Set db = Nothing
    Call writeLog(LOCAL_LOG1, "db.work.asp --. end")
%>