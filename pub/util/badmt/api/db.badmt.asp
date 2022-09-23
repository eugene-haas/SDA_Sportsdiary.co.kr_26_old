<% 
'   ===============================================================================     
'    Purpose : 배드민턴
'              참가신청 데이터 오류 수정

'    Make    : 2019.2.23
'    Author  :                                                       By Aramdry
'   ===============================================================================    
    ' Call writeLog(SAMALL_LOG1, "api.cpn.db.publish.asp --. start")   
%>

<% 
'   ===============================================================================     
'    아래 선언된 function들은 다음 경로를 참조하면 된다. 
'       /pub/fn/sql/sql.badmt - 모든 쿼리가 함수화 되어 있다. 
'   ===============================================================================     
%> 

<% 
'   ===============================================================================             
   '    Dim cp_seq, sUseDate, eUseDate, idPos, userID, memIdx       
   '   ===============================================================================   
   '   Json data 추출   
    If hasown(oJSONoutput, "CMD") = "ok" Then 
        cmd = oJSONoutput.CMD
    End If	

    If hasown(oJSONoutput, "SEQ") = "ok" Then           ' tblAmatureRegAuth 의 seq
        seq = oJSONoutput.SEQ
    End If	

    If hasown(oJSONoutput, "NAME") = "ok" Then          ' modify Name
        mName = oJSONoutput.NAME
    End If

    If hasown(oJSONoutput, "BIRTH") = "ok" Then         ' modify birthday
        mBirth = oJSONoutput.BIRTH                     
    End If

    If hasown(oJSONoutput, "PHONE") = "ok" Then         ' modify phone
        mPhone = oJSONoutput.PHONE
    End If

    If hasown(oJSONoutput, "POS") = "ok" Then         ' modify birthday
        pos = oJSONoutput.POS                     
    End If

    '   ===============================================================================   
    '        SMS 재전송
    '        1. seq key를 가지고  tblAmatureRegAuth에서 해당 User를 찾는다. 
    '        2. tblAmatureRegAuth의 SMSSendYN를 'N'로 변경한다. 
    '   ===============================================================================       
    if( cmd = CMD_RESEND_SMS_AMAUSER ) Then 
        Call writeLog(SAMALL_LOG1, "======================================= CMD_RESEND_SMS_AMAUSER") 
        strSql = getSqlRegPlayerInfo(seq)
        Call writeLog(SAMALL_LOG1, "strSql = " & strSql) 
        if( strSql <> "" ) Then 
            ' seq key를 가지고  tblAmatureRegAuth에서 해당 User를 찾는다. 
            Set rs = db.ExecSQLReturnRS(strSql , null, BadMin_ConStr)    

            ' tblAmatureRegAuth의 SMSSendYN를 'N'로 변경한다. 
            If Not (rs.Eof Or rs.Bof) Then
                strSql = getSqlUpdateResendSMSForRegPlayer(seq)
                
                Call writeLog(SAMALL_LOG1, "strSql = " & strSql) 
                if( strSql <> "" ) Then 
                    Call db.execSQLRs(strSql , null, BadMin_ConStr)  
                End If
            Else 
                Call oJSONoutput.Set("result", "92" )       ' seq key로 해당 User를 찾지 못했다. 
            End If
        Else 
            Call oJSONoutput.Set("result", "91" )       ' seq key가 값이 없다. 
        End If
        Call writeLog(SAMALL_LOG1, "======================================= CMD_RESEND_SMS_AMAUSER") 
    End If

    '   ===============================================================================   
    '        DB Update
    '        1. seq key를 가지고  tblAmatureRegAuth에서 해당 User를 찾는다. 
    '        2. AuthYN가 Y이면  tblMember,  tblMemberHistory 에 해당 선수의 데이터가 입력 되어 있다. 
    '        3. AuthYN가 Y이면 변경할 데이터를  tblAmatureRegAuth, tblMember,  tblMemberHistory에서 변경한다.  
    '        4. AuthYN가 N이면 변경할 데이터를  tblAmatureRegAuth에서 변경한다. 
    '        5. 데이터 변경을 한 경우 tblAmatureRegAuth의 SMSSendYN를 'N'로 변경한다. 
    '   ===============================================================================       
    if( cmd = CMD_UPDATE_AMAUSER_INFO ) Then 
        Call writeLog(SAMALL_LOG1, "======================================= CMD_UPDATE_AMAUSER_INFO") 
        strSql = getSqlRegPlayerInfo(seq)
        Call writeLog(SAMALL_LOG1, "strSql = " & strSql) 
        if( strSql <> "" ) Then 
            ' seq key를 가지고  tblAmatureRegAuth에서 해당 User를 찾는다. 
            Set rs = db.ExecSQLReturnRS(strSql , null, BadMin_ConStr)    
            
            If Not (rs.Eof Or rs.Bof) Then
                sName = rs("UserName")
                sBirthDay = rs("BirthDay")
                sPhone = rs("PhoneNum")
                sTeam = rs("Team")
                authYN = rs("AuthYN")

            '   ===============================================================================  
                ' AuthYN가 Y이면  tblMember,  tblMemberHistory 에 해당 선수의 데이터가 입력 되어 있다
                ' AuthYN가 Y이면 변경할 데이터를  tblAmatureRegAuth, tblMember,  tblMemberHistory에서 변경한다. 
                if( authYN = "Y") Then                     
                    strSql = getSqlFindRegPlayerFromMember(sName, sBirthDay, sPhone, sTeam) 
                    Call writeLog(SAMALL_LOG1, "getSqlFindRegPlayerFromMember = " & strSql) 
                    Set rs = db.ExecSQLReturnRS(strSql , null, BadMin_ConStr)

                    ' tblMember에 해당 User가 있다. 
                    If Not (rs.Eof Or rs.Bof) Then
                        memIdx = rs("MemberIDX")                        
                        
                        strSql = getSqlFindRegPlayerFromMemberHistory(sName, sBirthDay, sPhone, sTeam) 
                        Call writeLog(SAMALL_LOG1, "getSqlFindRegPlayerFromMemberHistory = " & strSql) 
                        Set rs = db.ExecSQLReturnRS(strSql , null, BadMin_ConStr)

                        ' tblMemberHistory에 해당 User가 있다. 
                        If Not (rs.Eof Or rs.Bof) Then
                            strSql = getSqlUpdateRegPlayerFromMember(memIdx, mName, mBirth, mPhone)                
                            Call writeLog(SAMALL_LOG1, "getSqlUpdateRegPlayerFromMember = " & strSql) 
                            if( strSql <> "" ) Then 
                                Call db.execSQLRs(strSql , null, BadMin_ConStr)  
                            End If

                            strSql = getSqlUpdateRegPlayerFromMemberHistory(memIdx, mName, mBirth, mPhone)                
                            Call writeLog(SAMALL_LOG1, "getSqlUpdateRegPlayerFromMemberHistory = " & strSql) 
                            if( strSql <> "" ) Then 
                                Call db.execSQLRs(strSql , null, BadMin_ConStr)  
                            End If
                        Else 
                            Call oJSONoutput.Set("result", "94" )       ' 인증된 User가 tblMemberHistory에 없다. 
                            hasError = 1
                        End If

                    Else 
                        Call oJSONoutput.Set("result", "93" )       ' 인증된 User가 tblMember에 없다. 
                        hasError = 1
                    End If

                End If
                
                If ( hasError = 0 ) Then 
                    strSql = getSqlUpdateRegPlayer(seq, mName, mBirth, mPhone)
                    
                    Call writeLog(SAMALL_LOG1, "getSqlUpdateRegPlayer = " & strSql) 
                    if( strSql <> "" ) Then 
                        Call db.execSQLRs(strSql , null, BadMin_ConStr)  
                    End If
                End If
            Else 
                Call oJSONoutput.Set("result", "92" )       ' seq key로 해당 User를 찾지 못했다. 
            End If
        Else 
            Call oJSONoutput.Set("result", "91" )           ' seq key가 값이 없다. 
        End If
        Call writeLog(SAMALL_LOG1, "======================================= CMD_UPDATE_AMAUSER_INFO")    
    End if

    '   ===============================================================================   
    '        Direct Reg For Ama Info
    '        1. gc_teamGB,g_entryType, gc_playType, gc_sex, gc_level, gc_levelJo를 가지고  
    '           tblDirectRegForTest에서 해당 GameInfo를 찾는다. 
    '        2. 이미 등록한 GameInfo 이면 Error를 출력한다. 
    '        3. 새로운 GameInfo이면 
    '        4. pl, p2의 team code를 구한다. (strTeam, sidoCode, gugunCode 이용)
    '        5. 등록을 한다. 
    '   ===============================================================================       
    if( cmd = CMD_REQ_DIRECTREG_AMAINFO ) Then 
        If hasown(oJSONoutput, "DINFO") = "ok" Then         ' modify phone
            directInfo = oJSONoutput.DINFO
            aryDInfo = split(directInfo, ",")

            p1_club  = aryDInfo(16) 
            p1c_sido  = aryDInfo(18)
            p1c_gugun  = aryDInfo(20)

            p2_club  = aryDInfo(27) 
            p2c_sido  = aryDInfo(29)
            p2c_gugun  = aryDInfo(31)

            ul = UBound(aryDInfo)

            strLog = strPrintf("ul = {6}, p1_club = {0}, p1c_sido = {1},p1c_gugun = {2},p2_club = {3},p2c_sido = {4},p2c_gugun = {5}", _
                        Array(p1_club, p1c_sido,p1c_gugun,p2_club,p2c_sido,p2c_gugun, ul))
            Call writeLog(SAMALL_LOG1, "Direct Info2 = " & strLog) 
        End If

        Call writeLog(SAMALL_LOG1, "======================================= CMD_REQ_DIRECTREG_AMAINFO") 
       ' 이미 등록한 GameInfo 인지 아닌지 찾는다. 
        strSql = getSqlFindDirectInfo(aryDInfo)  
        Call writeLog(SAMALL_LOG1, "getSqlFindDirectInfo = " & strSql) 

        if( strSql <> "" ) Then             
            Set rs = db.ExecSQLReturnRS(strSql , null, BadMin_ConStr)    
            
            If (rs.Eof Or rs.Bof) Then
                ' pl, p2의 team code를 구한다. (strTeam, sidoCode, gugunCode 이용)
                p1c_team = 0
                p2c_team = 0

                strSql = getSqlTeamCode(p1_club, p1c_sido, p1c_gugun)
                Call writeLog(SAMALL_LOG1, "getSqlTeamCode = " & strSql)                 

                if( strSql <> "" ) Then             
                    Set rs = db.ExecSQLReturnRS(strSql , null, BadMin_ConStr)    

                    If Not (rs.Eof Or rs.Bof) Then
                        p1c_team = rs("Team")
                    End If
                End If

                strSql = getSqlTeamCode(p2_club, p2c_sido, p2c_gugun)
                Call writeLog(SAMALL_LOG1, "getSqlTeamCode = " & strSql) 

                if( strSql <> "" ) Then             
                    Set rs = db.ExecSQLReturnRS(strSql , null, BadMin_ConStr)    

                    If Not (rs.Eof Or rs.Bof) Then
                        p2c_team = rs("Team")
                    End If
                End If

                ' 등록을 한다.
                strSql = getSqlInsertDirectInfo(aryDInfo, p1c_team, p2c_team)
                Call writeLog(SAMALL_LOG1, "getSqlInsertDirectInfo = " & strSql) 

                if( strSql <> "" ) Then             
                    Call db.execSQLRs(strSql , null, BadMin_ConStr)  
                End If

            Else 
                Call oJSONoutput.Set("result", "91" )           ' 이미 등록한 GameInfo다. 
                hasError = 1 
            End If
        End If
        
        Call writeLog(SAMALL_LOG1, "======================================= CMD_REQ_DIRECTREG_AMAINFO") 
    End If


    strJson = JSON.stringify(oJSONoutput)
    strRtn = strPrintf("{0}`##`Empty html", Array(strJson)) 
    Call Response.Write(strRtn)


%>

<%
    Set rs = Nothing

	Call db.Dispose
    Set db = Nothing
    ' Call writeLog(SAMALL_LOG1, "api.cpn.db.publish.asp --. end")
%>