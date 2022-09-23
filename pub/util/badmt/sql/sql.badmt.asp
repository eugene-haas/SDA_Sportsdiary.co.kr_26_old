<% 
'   ===============================================================================     
'    Purpose : badminton admin 에 들어가는 Sql Query를 모아 놨다. 
'    Make    : 2019.02.20
'    Author  :                                                       By Aramdry
'   ===============================================================================    


' ---------------------------------------------------------------------------------------
'    인증 검증 코드 
'    Select COUNT(*) From tblAmatureRegAuth_ForTest Where DelYN = 'N'
'    Select COUNT(*) From tblAmatureRegAuth_ForTest Where DelYN = 'N' And AuthYN = 'Y'
'
'    Select COUNT(*) From tblAmatureRegAuth_ForTest As A Inner Join tblMemberHistory_ForTest As B 
'        On A.UserName = B.UserName And A.BirthDay = B.BirthDay And A.PhoneNum = B.UserPhone 
'        Where A.DelYN = 'N' And B.DelYN = 'N' And A.AuthYN = 'Y' And B.RegYear = '2019'


'    Select * From tblAmatureRegAuth_ForTest As A
'    Where A.DelYN = 'N' And A.AuthYN = 'Y' And 
'        Not Exists ( Select * From tblMember_ForTest As B
'                        Where B.DelYN = 'N' And A.UserName = B.UserName 
'                        And A.BirthDay = B.BirthDay And A.PhoneNum = B.UserPhone ) Order By AmatureRegAuthIDX
'    Select * From tblAmatureRegAuth_ForTest As A
'    Where A.DelYN = 'N' And A.AuthYN = 'Y' And 
'        Not Exists ( Select * From tblMemberHistory_ForTest As B
'                        Where B.DelYN = 'N' And B.RegYear = '2019' And A.UserName = B.UserName 
'                        And A.BirthDay = B.BirthDay And A.PhoneNum = B.UserPhone )  Order By AmatureRegAuthIDX
' ---------------------------------------------------------------------------------------
%>

<% 
    Dim FlagTest
    FlagTest = 1

'   **********************************************************************************
'   **********************************************************************************
'       * 베드민턴 선수 등록신청
'   ===============================================================================     
'        입력받은 데이터를  tblAmatureRegAuth 에서 찾음. 
'     - SMSSendYN : 전송 여부 확인 
'     - AuthYN  : 선수 인증 여부 확인 
'   =============================================================================== 
    Function getSqlSearchRegPlayer(name, birthDay, phone, club, sido, gugun) 
        Dim strSql, strTable, strWhere, strField    
        Dim strWhere1, strWhere2, strWhere3, strWhere4, strWhere5, strWhere6, strWhereDef

    ' ================================================================================================        
        strTable = "tblAmatureRegAuth With (NoLock)"

        If (FlagTest = 1) Then strTable = "tblAmatureRegAuth_ForTest With (NoLock)" End If
    ' ================================================================================================
        strField = "AmatureRegAuthIDX,UserName,BirthDay,Sex,PhoneNum,TeamNM, Team,SidoNM, Sido,GuGunNM, Gugun, AuthYN,SMSSendYN"

    ' ================================================================================================
        ' where
        strWhereDef = "DelYN = 'N' "
        strWhere = strWhereDef
        if(name <> "")      Then strWhere1 = strPrintf(" UserName = '{0}'",  Array(name) )  End If
        if(birthDay <> "")  Then strWhere2 = strPrintf(" BirthDay = '{0}'",  Array(birthDay) )  End If
        if(phone <> "")     Then strWhere3 = strPrintf(" PhoneNum = '{0}'",  Array(phone) )  End If    
        if(club <> "")      Then strWhere4 = strPrintf(" TeamNM = '{0}'",  Array(club) )
        if(sido <> "")      Then strWhere5 = strPrintf(" SidoNM = '{0}'",  Array(sido) )  End If
        if(gugun <> "")     Then strWhere6 = strPrintf(" GuGunNM = '{0}'",  Array(gugun) )  End If    

        strWhere = strAddStr(strWhere, strWhere1, " {0} And ({1}) ")  
        strWhere = strAddStr(strWhere, strWhere2, " {0} And ({1}) ") 
        strWhere = strAddStr(strWhere, strWhere3, " {0} And ({1}) ") 
        strWhere = strAddStr(strWhere, strWhere4, " {0} And ({1}) ") 
        strWhere = strAddStr(strWhere, strWhere5, " {0} And ({1}) ") 
        strWhere = strAddStr(strWhere, strWhere6, " {0} And ({1}) ") 

        If (strWhere <> strWhereDef) Then 
            strSql = strPrintf("Select {0} From {1} Where {2}", Array(strField, strTable, strWhere))        
        End If

        getSqlSearchRegPlayer = strSql
    End Function 

'   ===============================================================================     
'        입력받은 seq를  tblAmatureRegAuth 에서 찾음. 
'   =============================================================================== 
    Function getSqlRegPlayerInfo(seq) 
        Dim strSql, strTable, strWhere, strField    
        Dim strWhere1, strWhere2, strWhere3, strWhere4, strWhere5, strWhere6, strWhereDef

    ' ================================================================================================        
        strTable = "tblAmatureRegAuth With (NoLock)"

        If (FlagTest = 1) Then strTable = "tblAmatureRegAuth_ForTest With (NoLock)" End If
    ' ================================================================================================
        strField = "AmatureRegAuthIDX,UserName,BirthDay,PhoneNum,Team,AuthYN"

    ' ================================================================================================
        ' where
        strWhere = strPrintf("DelYN = 'N' And AmatureRegAuthIDX = '{0}'", array(seq))

        If (seq <> "") Then 
            strSql = strPrintf("Select {0} From {1} Where {2}", Array(strField, strTable, strWhere))        
        End If

        getSqlRegPlayerInfo = strSql
    End Function 

'   ===============================================================================     
'        입력받은 데이터를  tblMember : 베드민턴 선수 테이블에서 찾음 
'   =============================================================================== 
    Function getSqlFindRegPlayerFromMember(name, birthDay, phone, team) 
        Dim strSql, strTable, strWhere, strField    
        Dim strWhere1, strWhere2, strWhere3, strWhere4
    ' ================================================================================================        
        strTable = "tblMember With (NoLock)"
        If (FlagTest = 1) Then strTable = "tblMember_ForTest With (NoLock)" End If

    ' ================================================================================================
        strField = "MemberIDX"

    ' ================================================================================================
        ' where
        strWhere = "DelYN = 'N' "
        if(name <> "")      Then strWhere1 = strPrintf(" UserName = '{0}'",  Array(name) )  End If
        if(birthDay <> "")  Then strWhere2 = strPrintf(" Birthday = '{0}'",  Array(birthDay) )  End If
        if(phone <> "")     Then strWhere3 = strPrintf(" UserPhone = '{0}'",  Array(phone) )  End If    
        if(club <> "")      Then strWhere4 = strPrintf(" Team = '{0}'",  Array(team) )

        strWhere = strAddStr(strWhere, strWhere1, " {0} And ({1}) ")  
        strWhere = strAddStr(strWhere, strWhere2, " {0} And ({1}) ") 
        strWhere = strAddStr(strWhere, strWhere3, " {0} And ({1}) ") 
        strWhere = strAddStr(strWhere, strWhere4, " {0} And ({1}) ") 

        strSql = strPrintf("Select {0} From {1} Where {2}", Array(strField, strTable, strWhere))        

        getSqlFindRegPlayerFromMember = strSql
    End Function 

'   ===============================================================================     
'        입력받은 데이터를  tblMemberHistory 각 년도 선수 테이블 ( 현재는 2019년만 유효 )에서 찾음 
'   =============================================================================== 
    Function getSqlFindRegPlayerFromMemberHistory(name, birthDay, phone, team) 
        Dim strSql, strTable, strWhere, strField    
        Dim strWhere1, strWhere2, strWhere3, strWhere4
    ' ================================================================================================        
        strTable = "tblMemberHistory With (NoLock)"
        If (FlagTest = 1) Then strTable = "tblMemberHistory_ForTest With (NoLock)" End If

    ' ================================================================================================
        strField = "MemberIDX"

    ' ================================================================================================
        ' where
        strWhere = "DelYN = 'N' And RegYear = '2019'"
        if(name <> "")      Then strWhere1 = strPrintf(" UserName = '{0}'",  Array(name) )  End If
        if(birthDay <> "")  Then strWhere2 = strPrintf(" Birthday = '{0}'",  Array(birthDay) )  End If
        if(phone <> "")     Then strWhere3 = strPrintf(" UserPhone = '{0}'",  Array(phone) )  End If    
        if(club <> "")      Then strWhere4 = strPrintf(" Team = '{0}'",  Array(team) )

        strWhere = strAddStr(strWhere, strWhere1, " {0} And ({1}) ")  
        strWhere = strAddStr(strWhere, strWhere2, " {0} And ({1}) ") 
        strWhere = strAddStr(strWhere, strWhere3, " {0} And ({1}) ") 
        strWhere = strAddStr(strWhere, strWhere4, " {0} And ({1}) ") 

        strSql = strPrintf("Select {0} From {1} Where {2}", Array(strField, strTable, strWhere))        

        getSqlFindRegPlayerFromMemberHistory = strSql
    End Function 

'   **********************************************************************************
'   **********************************************************************************
'       * 베드민턴 선수 데이터 업데이트 
'   ===============================================================================     
'        tblAmatureRegAuth SMS 재전송 필드 업데이트 
'   =============================================================================== 
    Function getSqlUpdateResendSMSForRegPlayer(seq) 
        Dim strSql, strTable, strWhere, strField    
        Dim strWhere1, strWhere2, strWhere3, strWhere4, strWhere5, strWhere6
        Dim strSet, strSet1, strSet2, strSet3, strSetDef

    ' ================================================================================================        
        strTable = "tblAmatureRegAuth"
        If (FlagTest = 1) Then strTable = "tblAmatureRegAuth_ForTest" End If

    ' ================================================================================================
        ' Set Data        
        strSet = " SMSSendYN  = 'N' "

    ' ================================================================================================
        ' where
        strWhere = strPrintf(" DelYN = 'N' And AmatureRegAuthIDX = '{0}'",  Array(seq) )

        If (seq <> "") Then 
            strSql = strPrintf(" Update {0} Set {1} Where {2}",  Array(strTable, strSet, strWhere) )       
        End If
        getSqlUpdateResendSMSForRegPlayer = strSql
    End Function 

'   **********************************************************************************
'   **********************************************************************************
'       * 베드민턴 선수 데이터 업데이트 
'   ===============================================================================     
'        입력받은 데이터를  tblAmatureRegAuth 에서 Update
'        데이터 업데이트시 재인증을 해야 함으로 SMSSendYN, AuthYN 필드를 초기화 한다 .
'     - SMSSendYN : 전송 여부 확인 
'     - AuthYN  : 선수 인증 여부 확인 
'   =============================================================================== 
    Function getSqlUpdateRegPlayer(seq, name, birthDay, phone) 
        Dim strSql, strTable, strWhere, strField    
        Dim strWhere1, strWhere2, strWhere3, strWhere4, strWhere5, strWhere6
        Dim strSet, strSet1, strSet2, strSet3, strSetDef

    ' ================================================================================================        
        strTable = "tblAmatureRegAuth"
        If (FlagTest = 1) Then strTable = "tblAmatureRegAuth_ForTest" End If

    ' ================================================================================================
        ' Set Data
        if(name <> "")      Then strSet1 = strPrintf(" UserName = '{0}'",  Array(name) )  End If
        if(birthDay <> "")  Then strSet2 = strPrintf(" BirthDay = '{0}'",  Array(birthDay) )  End If
        if(phone <> "")     Then strSet3 = strPrintf(" PhoneNum = '{0}'",  Array(phone) )  End If    
        
        strSetDef = "AuthYN = 'N', SMSSendYN  = 'N' ,"
        strSet = strSetDef
        strSet = strAddStr(strSet, strSet1, " {0} {1}, ")  
        strSet = strAddStr(strSet, strSet2, " {0} {1}, ")  
        strSet = strAddStr(strSet, strSet3, " {0} {1}  ")  

    ' ================================================================================================
        ' where
        strWhere = strPrintf(" DelYN = 'N' And AmatureRegAuthIDX = '{0}'",  Array(seq) )

        If (seq <> "" And strSet <> strSetDef) Then 
            strSql = strPrintf(" Update {0} Set {1} Where {2}",  Array(strTable, strSet, strWhere) )       
        End If
        getSqlUpdateRegPlayer = strSql
    End Function 

'   ===============================================================================     
'        입력받은 데이터를  tblMember : 베드민턴 선수 테이블에서 Update
'   =============================================================================== 
    Function getSqlUpdateRegPlayerFromMember(seq, name, birthDay, phone) 
        Dim strSql, strTable, strWhere, strField    
        Dim strWhere1, strWhere2, strWhere3, strWhere4, strWhere5, strWhere6
        Dim strSet, strSet1, strSet2, strSet3, strSetDef

    ' ================================================================================================        
        strTable = "tblMember"
        If (FlagTest = 1) Then strTable = "tblMember_ForTest" End If

    ' ================================================================================================
        ' Set Data
        if(name <> "")      Then strSet1 = strPrintf(" UserName = '{0}'",  Array(name) )  End If
        if(birthDay <> "")  Then strSet2 = strPrintf(" Birthday = '{0}'",  Array(birthDay) )  End If
        if(phone <> "")     Then strSet3 = strPrintf(" UserPhone = '{0}'",  Array(phone) )  End If    
        
        strSetDef = " "
        strSet = strSetDef
        strSet = strAddStr(strSet, strSet1, " {0} {1}, ")  
        strSet = strAddStr(strSet, strSet2, " {0} {1}, ")  
        strSet = strAddStr(strSet, strSet3, " {0} {1} ")  

    ' ================================================================================================
        ' where        
        strWhere = strPrintf(" DelYN = 'N' And MemberIDX = '{0}'",  Array(seq) )

        If (seq <> "" And strSet <> strSetDef) Then 
            strSql = strPrintf(" Update {0} Set {1} Where {2}",  Array(strTable, strSet, strWhere) )       
        End If
        getSqlUpdateRegPlayerFromMember = strSql
    End Function 

'   ===============================================================================     
'        입력받은 데이터를  tblMemberHistory 각 년도 선수 테이블 ( 현재는 2019년만 유효 )에서 Update
'   =============================================================================== 
    Function getSqlUpdateRegPlayerFromMemberHistory(seq, name, birthDay, phone) 
        Dim strSql, strTable, strWhere, strField    
        Dim strWhere1, strWhere2, strWhere3, strWhere4, strWhere5, strWhere6
        Dim strSet, strSet1, strSet2, strSet3, strSetDef

    ' ================================================================================================        
        strTable = "tblMemberHistory"
        If (FlagTest = 1) Then strTable = "tblMemberHistory_ForTest" End If

    ' ================================================================================================
        ' Set Data
        if(name <> "")      Then strSet1 = strPrintf(" UserName = '{0}'",  Array(name) )  End If
        if(birthDay <> "")  Then strSet2 = strPrintf(" Birthday = '{0}'",  Array(birthDay) )  End If
        if(phone <> "")     Then strSet3 = strPrintf(" UserPhone = '{0}'",  Array(phone) )  End If    
        
        strSetDef = " "
        strSet = strSetDef
        strSet = strAddStr(strSet, strSet1, " {0} {1}, ")  
        strSet = strAddStr(strSet, strSet2, " {0} {1}, ")  
        strSet = strAddStr(strSet, strSet3, " {0} {1}  ")  

    ' ================================================================================================
        ' where        
        strWhere = strPrintf(" DelYN = 'N' And MemberIDX = '{0}' And RegYear = '2019'",  Array(seq) )

        If (seq <> "" And strSet <> strSetDef) Then 
            strSql = strPrintf(" Update {0} Set {1} Where {2}",  Array(strTable, strSet, strWhere) )       
        End If
        getSqlUpdateRegPlayerFromMemberHistory = strSql
    End Function 

'   ===============================================================================     
'        Team Code를 얻는다.   tblTeamInfoHistory
'   =============================================================================== 
    Function getSqlTeamCode(strTeam, sidoCode, gugunCode)  
        Dim strSql, strTable, strWhere, strField    
        Dim strWhere1, strWhere2, strWhere3, strWhere4, strWhere5, strWhere6, strWhereDef

    ' ================================================================================================        
        strTable = "tblTeamInfoHistory With (NoLock)"
    ' ================================================================================================
        strField = "Team,TeamNm"

    ' ================================================================================================
        ' where        
        strWhere = strPrintf(" DelYN = 'N' And RegYear = '2019' And TeamNm = '{0}' And sido = '{1}' And sidogugun = '{2}'", _
              Array(strTeam, sidoCode, gugunCode) )

        If (strTeam <> "" And sidoCode <> "" And gugunCode <> "") Then 
            strSql = strPrintf("Select {0} From {1} Where {2}", Array(strField, strTable, strWhere))        
        End If

        getSqlTeamCode = strSql
    End Function 

'   ===============================================================================     
'        Find regInfo를 얻는다.   tblDirectRegForTest
'   =============================================================================== 
    Function getSqlFindDirectInfo(aryDInfo)  
        Dim strSql, strTable, strWhere, strField    
        Dim strWhere1, strWhere2, strWhere3, strWhere4, strWhere5, strWhere6, strWhereDef
        Dim ul 

        Dim gc_teamGB,gc_entryType, gc_type,gc_sex,gc_level,gc_rank
        Dim p1_name,p1_birthDay,p1_phone,p2_name,p2_birthDay,p2_phone

        If IsArray(aryDInfo) Then ul = UBound(aryDInfo) End If

        If (ul <> 33) Then 
            getSqlFindDirectInfo = ""
            Exit Function 
        End If  
        
        gc_teamGB= aryDInfo(1) 
        gc_entryType= aryDInfo(2)  
        gc_type= aryDInfo(5) 
        gc_sex= aryDInfo(7) 
        gc_level= aryDInfo(9) 
        gc_rank= aryDInfo(11) 

        p1_name= aryDInfo(12) 
        p1_birthDay= aryDInfo(13) 
        p1_phone= aryDInfo(15) 
        
        p2_name= aryDInfo(23) 
        p2_birthDay= aryDInfo(24) 
        p2_phone= aryDInfo(26) 

    ' ================================================================================================        
        strTable = "tblDirectRegForTest With (NoLock)"
    ' ================================================================================================
        strField = "gc_teamGB,g_entryType, gc_playType, gc_sex, gc_level, gc_levelJo"

    ' ================================================================================================
        ' where        
        strWhere1 = strPrintf(" DelYN = 'N' And gc_teamGB = '{0}' And g_entryType = '{1}'", Array(gc_teamGB,g_entryType) )

        strWhere2 = strPrintf("gc_playType = '{0}' And gc_sex = '{1}' And gc_level = '{2}' And gc_levelJo = '{3}'", _
              Array(gc_playType, gc_sex, gc_level, gc_levelJo) )

        strWhere3 = strPrintf("p1_name= '{0}' And p1_birthDay= '{1}' And p1_phoneNum= '{2}'", _
              Array(p1_name,p1_birthDay,p1_phoneNum) )
        strWhere4 = strPrintf("p2_name= '{0}' And p2_birthDay= '{1}' And p2_phoneNum= '{2}'", _
              Array(p2_name,p2_birthDay,p2_phoneNum) )

        strWhere = strAddStr(strWhere1, strWhere2, " {0} And {1} ")  
        strWhere = strAddStr(strWhere, strWhere3, " {0} And {1} ")  
        strWhere = strAddStr(strWhere, strWhere4, " {0} And {1} ")  

        strSql = strPrintf("Select {0} From {1} Where {2}", Array(strField, strTable, strWhere))  

        getSqlFindDirectInfo = strSql
    End Function 

'   ===============================================================================     
'        Insert regInfo.   tblDirectRegForTest
'   =============================================================================== 
    Function getSqlInsertDirectInfo(aryDInfo, p1c_team, p2c_team)  
        Dim strSql, strTable, strWhere, strField    
        Dim strWhere1, strWhere2, strWhere3, strWhere4, strWhere5, strWhere6, strWhereDef
        Dim ul 

        Dim g_teamGB,gc_teamGB,gc_entryType, g_kind,g_type,gc_type,g_sex,gc_sex,g_level,gc_level,g_rank,gc_rank
        Dim p1_name,p1_birthDay,p1c_sex,p1_phone,p1_club,p1_sido, p1c_sido, p1_gugun,p1c_gugun,p1_rank,p1c_rank
        Dim p2_name,p2_birthDay,p2c_sex,p2_phone,p2_club,p2_sido, p2c_sido, p2_gugun,p2c_gugun,p2_rank,p2c_rank

        If IsArray(aryDInfo) Then ul = UBound(aryDInfo) End If

        If (ul <> 33) Then 
            getSqlInsertDirectInfo = ""
            Exit Function 
        End If      

        g_teamGB= aryDInfo(0) 
        gc_teamGB= aryDInfo(1) 
        gc_entryType= aryDInfo(2)  
        g_kind  = aryDInfo(3) 
        g_type= aryDInfo(4) 
        gc_type= aryDInfo(5) 
        g_sex= aryDInfo(6) 
        gc_sex= aryDInfo(7) 
        g_level= aryDInfo(8) 
        gc_level= aryDInfo(9) 

        g_rank= aryDInfo(10) 
        gc_rank= aryDInfo(11) 

        p1_name= aryDInfo(12) 
        p1_birthDay= aryDInfo(13) 
        p1c_sex= aryDInfo(14) 
        p1_phone= aryDInfo(15) 
        p1_club= aryDInfo(16) 
        p1_sido= aryDInfo(17)  
        p1c_sido= aryDInfo(18)  
        p1_gugun= aryDInfo(19) 
        p1c_gugun= aryDInfo(20) 
        p1_rank= aryDInfo(21) 
        p1c_rank= aryDInfo(22) 
        
        p2_name= aryDInfo(23) 
        p2_birthDay= aryDInfo(24) 
        p2c_sex= aryDInfo(25) 
        p2_phone= aryDInfo(26) 
        p2_club= aryDInfo(27) 
        p2_sido= aryDInfo(28)  
        p2c_sido= aryDInfo(29)  
        p2_gugun= aryDInfo(30) 
        p2c_gugun= aryDInfo(31) 
        p2_rank= aryDInfo(32) 
        p2c_rank= aryDInfo(33)  


    ' ================================================================================================        
        strTable = "tblDirectRegForTest"
    ' ================================================================================================    
     '   strField
        strField1 = "g_teamGB,gc_teamGB,g_entryType,g_kind,g_playType,gc_playType,g_sex,gc_sex,g_level,gc_level,g_levelJo,gc_levelJo,"
        strField2 = "p1_name,p1_birthDay,p1_sex,p1_phoneNum,p1_teamNM,p1_team,"
        strField3 = "p1_sidoNM,p1_sido,p1_guGunNM,p1_guGun,p1_rank_SidoNM,p1_rank_Sido,"
        strField4 = "p2_name,p2_birthDay,p2_sex,p2_phoneNum,p2_teamNM,p2_team,"
        strField5 = "p2_sidoNM,p2_sido,p2_guGunNM,p2_guGun,p2_rank_SidoNM,p2_rank_Sido"
        strField = strPrintf("{0} {1} {2} {3} {4}", Array(strField1, strField2, strField3, strField4, strField5))
    ' ================================================================================================
        ' values        p1c_team, p2c_team
        strValue1 = strPrintf(" '{0}', '{1}', '{2}', '{3}', '{4}', '{5}', '{6}', '{7}', '{8}', '{9}', '{10}', '{11}',", _
                    Array(g_teamGB,gc_teamGB,gc_entryType, g_kind,g_type,gc_type,g_sex,gc_sex,g_level,gc_level,g_rank,gc_rank ) )
        strValue2 = strPrintf(" '{0}', '{1}', '{2}', '{3}', '{4}', '{5}', '{6}', '{7}', '{8}', '{9}', '{10}', '{11}',", _
                    Array(p1_name,p1_birthDay,p1c_sex,p1_phone,p1_club,p1c_team, p1_sido, p1c_sido, p1_gugun,p1c_gugun,p1_rank,p1c_rank ) )
        strValue3 = strPrintf(" '{0}', '{1}', '{2}', '{3}', '{4}', '{5}', '{6}', '{7}', '{8}', '{9}', '{10}', '{11}'", _
                    Array(p2_name,p2_birthDay,p2c_sex,p2_phone,p2_club,p2c_team, p2_sido, p2c_sido, p2_gugun,p2c_gugun,p2_rank,p2c_rank ) )

        strValue = strPrintf("{0} {1} {2}", Array(strValue1, strValue2, strValue3))

        strSql = strPrintf(" Insert Into {0} ( {1} ) values( {2} )",  Array(strTable, strField, strValue) )       

        getSqlInsertDirectInfo = strSql
    End Function 
   %> 