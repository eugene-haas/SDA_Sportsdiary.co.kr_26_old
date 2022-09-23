<!--METADATA TYPE= "typelib"  NAME= "ADODB Type Library" FILE="C:\Program Files\Common Files\SYSTEM\ADO\msado15.dll"  -->
<%@ codepage="65001" language="VBScript" %>

<%'<!-- #include virtual="/study_src/pub/class/json2.asp" -->%>
<%'<!-- #include virtual = "/study_src/pub/fn/fn.paging.asp" -->%>
<%'<!-- #include virtual = "/study_src/pub/class/db_helper.asp"-->%>
<%'<!-- #include virtual = "/study_src/cfg/cfg.etc.asp" -->%>
<!-- #include virtual = "/study_src/fn/fn.utiletc.asp" -->
<%'<!-- #include virtual = "/study_src/fn/fn.log.asp" -->%>


<%'<!-- #include virtual = "/study_src/sql_test.asp" -->%>

<%
    '<script src="./js/svr_side/jsServerSide.js" language="javascript" type="text/javascript"  runat="server"></script>
    '<script src="./js/cli_side/jsClientSide.js" language="javascript" type="text/javascript" ></script>
%>


<%
Response.CharSet="utf-8"
Session.codepage="65001"
Response.codepage="65001"
Response.ContentType="text/html;charset=utf-8"

Response.Buffer = True
%>


<%
    Dim arySrc, aryRank, arySido, aryGugun

    ExcelSrc = "D:\wroot\my1\study_src\res\회원 등록명단(양산시).xlsx"
    ExcelDataRank = "D:\wroot\my1\study_src\res\Rank코드.xlsx"
    ExcelDataSido = "D:\wroot\my1\study_src\res\Sido코드.xlsx"
    ExcelDataGugun = "D:\wroot\my1\study_src\res\Gugun코드.xlsx"

    arySrc = LoadExcelFile(ExcelSrc)
    aryRank = LoadExcelFile(ExcelDataRank)
    arySido = LoadExcelFile(ExcelDataSido)
    aryGugun = LoadExcelFile(ExcelDataGugun)

    strData = ""
    strRet = ""
    strSido = ""
    strSigun = ""
    strClub = ""
    strName = ""
    strPhone = ""
    strBirth = ""
    strSex = ""
    strRank = ""
    strRank2 = ""

    Dim ul, ul2, i, j

    If IsArray(arySrc) Then 
        ul2 = UBound(arySrc, 1)
        ul = UBound(arySrc, 2) 

        For i = 0 to ul 
            For j = 0 to ul2
                strData = arySrc(j, i)

                ' Null이 아닐경우 공백 문자를 제거한다. 
                If( Not(arySrc(j, i) = "" Or IsNull(arySrc(j, i)) ) ) Then 
                    strData = RemoveSpace(arySrc(j, i))
                End If

                If (j = 1) Then             ' 시도명
                    strSido = FindSidoNo(strData)
                ElseIf (j = 2) Then         ' 시군명
                    strSigun = FindGugunNo(strData, strSido)
                ElseIf (j = 3) Then         ' 클럽명
                    strClub = strData
                ElseIf (j = 4) Then         ' 선수명
                    strName = strData
                ElseIf (j = 5) Then         ' 휴대폰번호
                    strData = RepairPhoneNumber(strData)
                    If (CheckPhoneNumberEx(strData) <> True ) Then                                                 
                        strData = strPrintf("******** Error PhoneNumber {0}  ", Array(strData))
                    End If
                    strPhone = strData
                ElseIf (j = 6) Then         ' 생년월일
                    strData = RepairBirthDay(strData)
                    If (CheckBirthDay(strData) = false ) Then 
                        strData = strPrintf("******** Error BirthDay {0}  ", Array(strData))
                    End If
                    strBirth = strData
                ElseIf (j = 7) Then         ' 성별
                    strSex = ReplaceStrSex(strData)

                    If (strSex = "" ) Then 
                        strSex = "******** Error strSex"
                    End If
                ElseIf (j = 8) Then         ' 전국급수
                    strRank = FindRankNo(strData)
                    If (strRank = "" ) Then 
                        strRank = "******** Error strRank"
                    End If
                ElseIf (j = 9) Then         ' 시도급수
                    strRank2 = FindRankNo(strData)
                    If (strRank2 = "" ) Then 
                        strRank2 = "******** Error strRank2"
                    End If
                End If                
            Next
            strRet = strPrintf("{0},{1},{2},{3},{4},{5},{6},{7},{8},{9}<br>", _ 
                      Array(strName, strBirth, strSex, strPhone, strClub, strSido, strSigun, strRank, strRank2, "2019" ))
            
            Response.write strRet
            Response.flush    '처리 완료된 데이터를 출력
        Next 
    End If  

    Response.Clear    '버퍼 내용 초기화
    Response.End    '페이지 종료

    strPhone = "0104367-8798"
    strPhone = RepairPhoneNumber(strPhone)
    Response.write "<br>" & strPhone & "<br>"

    strPhone = "010-43678798"
    strPhone = RepairPhoneNumber(strPhone)
    Response.write "<br>" & strPhone & "<br>"




%>


<% 
'   ===============================================================================     
'      Sub Function 
'   =============================================================================== 

'   ===============================================================================     
'      Check Birth Day
'   =============================================================================== 
    Function CheckBirthDay(strBirth)    
        strBirth = RemoveSpace(strBirth)
        patn = "(\d{8})$"
        ret = RegExpTest(patn, strBirth)
        CheckBirthDay = ret
    End Function

'   ===============================================================================     
'      문자열 변환 , 남자/혼합/여자 => Man/Mix/WoMan
'   ===============================================================================     
    Function ReplaceStrSex(strSex)
        Dim ret

        If (strSex = "남") Then 
            ret = "Man" 
        ElseIf (strSex = "여") Then 
            ret = "WoMan"  
        ElseIf (strSex = "혼합") Then 
            ret = "Mix"  
        End If

        ReplaceStrSex = ret
    End Function 

'   ===============================================================================     
'      문자열 변환 , 도 => SidoNM
'   ===============================================================================     
    Function ReplaceStrSiDo(strSiDo)
        Dim ret

        strSiDo = RemoveSpace(strSiDo)

        If( strSiDo = "경상남도" ) Then 
            ret = "15"
        End If

        ReplaceStrSiDo = ret
    End Function 

'   ===============================================================================     
'      문자열 변환 , 구군 => GuGunNM
'   ===============================================================================     
    Function ReplaceStrGugun(strGugun)
        Dim ret

        strGugun = RemoveSpace(strGugun)

        ReplaceStrGugun = ret
    End Function 

'   ===============================================================================     
'      문자열 변환 , Rank 영문자 => Rank NM
'   ===============================================================================     
    Function ReplaceStrRank(strRank)
        Dim ret

        strRank = RemoveSpace(strRank)

        ReplaceStrRank = ret
    End Function 

    Function FindSidoNo(str)        
        Dim ret, i, ul
        
        If IsArray(arySido) Then 
            ul = UBound(arySido, 2) 

            For i = 0 to ul 
                If( arySido(0, i) = str ) Then  
                    ret = arySido(1, i)
                    Exit For
                End If
            Next 
        End If  

        FindSidoNo = ret
    End Function 

    Function FindGugunNo(str, sidoNum)
        Dim ret, i, ul
        sidoNum = CDbl(sidoNum)

        If IsArray(aryGugun) Then 
            ul = UBound(aryGugun, 2) 

            For i = 0 to ul 
                If( aryGugun(2, i) = sidoNum ) Then  
                    If( aryGugun(0, i) = str ) Then  
                        ret = aryGugun(1, i)
                        Exit For
                    End If   
                End If
            Next 
        End If 

        FindGugunNo = ret
    End Function 

    Function FindRankNo(str)        
        Dim ret, i, ul
        
        ret = "B0110007"
        If IsArray(aryRank) Then 
            ul = UBound(aryRank, 2) 

            For i = 0 to ul 
                If( aryRank(0, i) = str ) Then  
                    ret = aryRank(1, i)
                    Exit For
                End If
            Next 
        End If  

        FindRankNo = ret
    End Function 

    '   ===============================================================================     
'      전화 번호 체크 
'   ===============================================================================  
	Function CheckPhoneNumberEx(strPhone)
        Dim pos1, pos2

        pos1 = instr(strPhone, "-")
        pos2 =  instrrev(strPhone, "-")

        ret = False
        If( Not(pos1 = 0 Or pos1 = pos2) ) Then 
		    ret = CheckPhoneNumber(strPhone)
        End If

		CheckPhoneNumberEx = ret
	End Function 

    Function RepairPhoneNumber(strPhone)
        Dim len1 , pos1, pos2
        Dim str1, str2, str3

        strPhone = Replace(strPhone, ".", "-" )

        len1 = Len(strPhone)
        pos1 = instr(strPhone, "-")
        pos2 =  instrrev(strPhone, "-")

'        strLog = strPrintf("len1 = {0}, pos1 = {1}, pos2 = {2}", Array(len1, pos1, pos2))
'        Response.write(strLog)

        ' 전화번호가 '-' 없이 숫자만 있다. 
        If( pos1 = 0 And pos2 = 0 And len1 = 11 ) Then 
            str1 = Mid(strPhone, 1,3)
            str2 = Mid(strPhone, 4,4)
            str3 = Mid(strPhone, 8,4)

            strPhone = strPrintf("{0}-{1}-{2}", Array(str1, str2, str3))
        End If

        ' 전화번호가 '-' 1개만 있다. 
        If( pos1 = pos2 And len1 = 12 ) Then    ' 010-77778888
            If (pos1 = 8) Then 
                str1 = Mid(strPhone, 1,3)
                str2 = Mid(strPhone, 4,9)
            ElseIf( pos1 = 4 ) Then             ' 0107777-8888
                str1 = Mid(strPhone, 1,8)
                str2 = Mid(strPhone, 9,4)
            End If

            strPhone = strPrintf("{0}-{1}", Array(str1, str2))
        End If

		RepairPhoneNumber = strPhone
    End Function

    Function RepairBirthDay(strBirth)
        Dim len1, str1

        len1 = Len(strBirth)        
     
        patn = "\.+"
		strBirth = RegExpReplace(patn, "", strBirth)

        If( len1 = 6 ) Then 
            str1 = Mid(strBirth, 1,2)

    '        strLog = strPrintf("<br>RepairBirthDay strBirth = {1}, str1 = {0}<br>", Array(str1, strBirth))
    '        Response.write(strLog)

            If (CDbl(str1) > 30 ) Then 
                strBirth = strPrintf("19{0}", Array(strBirth))
            ElseIf (CDbl(str1) > 30 ) Then 
                strBirth = strPrintf("20{0}", Array(strBirth))
            End If            
        End If

		RepairBirthDay = strBirth

    End Function
%>