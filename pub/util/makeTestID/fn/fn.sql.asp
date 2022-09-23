<% 
'   ===============================================================================     
'    Purpose : Coupon에 들어가는 Sql Query를 모아 놨다. 
'    Make    : 2018.11.20
'    Author  :                                                       By Aramdry
'   ===============================================================================    
%>

<% 
    'MemberIDX,UserID,UserPass,UserPassGb,UserName,UserEnName,UserPhone,Birthday,Sex,Email,ZipCode,Address,
    'AddressDtl,EmailYn,EmailYnDt,SmsYn,SmsYnDt,PushYN,PushYNDt,WriteDate,ModDate,DelYN
    Function getSQLInsertMember(strID, strPW, strBirthDay, strRegDate, nPush, nSms, nSex, nIDOrder)
        Dim strSql, strTable
        Dim strField, strField1, strField2
        Dim strValue, strValue1, strValue2, strValue3

        Dim strName, strEngName, strPhone, strEmail, strAddr, strAddrDtl, strZipCode
        Dim strSex, strPushYN, strPushDate, strSmsYN, strSmsDate        

        If nSex = 1 Then 
            strName = strPrintf("테스트남_{0}", Array(nIDOrder))
            strEngName = strPrintf("sdMan_{0}", Array(nIDOrder))
            strSex  = "Man"
        Else 
            strName = strPrintf("테스트여_{0}", Array(nIDOrder))
            strEngName = strPrintf("sdWoMan_{0}", Array(nIDOrder))
            strSex  = "WoMan"
        End If

        If nPush = 1 Then 
            strPushYN = "Y"
            strPushDate = strRegDate
        End If

        If nSms = 1 Then 
            strSmsYN = "Y"
            strSmsDate = strRegDate
        End If


        strPhone = "010-1111-1111"
        strEmail = "widline@aaa.com"
        strAddr = "서울시 WidLine"
        strAddrDtl = "WidLine"
        strZipCode = "04173"

        '   =============================================================================== 
        '   DB Table
        '   strTable = "tblMember_test"
           strTable = "tblMember"

        '   =============================================================================== 
        '   Field
        strField1 = "UserID,UserPass,UserName,UserPhone,Birthday,Sex,Email,ZipCode, "
        strField2 = "Address, AddressDtl,SmsYn,SmsYnDt,PushYN,PushYNDt,WriteDate"
        strField = strPrintf("{0} {1}", Array(strField1, strField2))

        '   =============================================================================== 
        '   set values
        strValue1 = strPrintf("'{0}','{1}','{2}','{3}','{4}','{5}','{6}','{7}',", _ 
                    Array(strID, strPW, strName, strPhone, strBirthDay, strSex, strEmail, strZipCode))   

        strValue2 = strPrintf("'{0}','{1}','{2}','{3}','{4}','{5}','{6}'", _ 
                    Array(strAddr, strAddrDtl, strSmsYN, strSmsDate, strPushYN, strPushDate,strRegDate))             

        strValue = strPrintf("{0} {1}", Array(strValue1, strValue2))     
        
        '   =============================================================================== 
        '   set sql query 
        strSql = strPrintf("Insert Into {0} ({1}) Values({2})", Array(strTable, strField, strValue))
        getSQLInsertMember = strSql  

    End Function 

%>