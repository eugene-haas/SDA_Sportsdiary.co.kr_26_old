<!--METADATA TYPE= "typelib"  NAME= "ADODB Type Library" FILE="C:\Program Files\Common Files\SYSTEM\ADO\msado15.dll"  -->
<%@ codepage="65001" language="VBScript" %>

<%
Response.CharSet="utf-8"
Session.codepage="65001"
Response.codepage="65001"
Response.ContentType="text/html;charset=utf-8"

response.end
%>



<% '<!-- #include virtual = "/pub/fn/fn.log.asp" --> %>
<% '<!-- #include virtual = "/pub/fn/fn.string.asp" -->%>
<% '<!-- #include virtual = "/pub/fn/fn.utiletc.asp" -->%>
<% '<!-- #include virtual = "/pub/util/badmt/sql/sql.badmt.asp" -->%>


<head>
<script type="text/javascript" src="/pub/util/badmt/js/badmt.js?ver=1"></script>
<script type="text/javascript" src="/pub/js/etc/utx.js?ver=1"></script>
<script type="text/javascript" src="/pub/js/etc/ctx.js?ver=1"></script>
</head>

<%
    Dim arySrc, aryRank, arySido, aryGugun
    Dim aryGameKind, aryLevel, aryPub, aryTeam, aryTeamGB

    Dim strData,strAData, strAry, strRet,strKind,strLevel,strRank,strSido,strTeamGB
    Dim g_sex,g_type,gc_sex,gc_type,gc_level,gc_rank,gc_sido,gc_teamGB,gc_entryType
    Dim p1_gugun,p1_club,p1_name,p1_birthDay,p1_phone,p1_sex,p1c_gugun,p1c_club,p1c_sex
    Dim p2_gugun,p2_club,p2_name,p2_birthDay,p2_phone,p2_sex,p2c_gugun,p2c_club,p2c_sex
    Dim resPath

    resPath = Server.mappath("/pub")

    ' 광주 / 개인전 / 일반부 
    ExcelSrc        = resPath & "/util/badmt/res/data/reqDirectReg.xls"    
    ExcelGameKind   = resPath & "/util/badmt/res/sysdata/gameKind.xlsx"    
    ExcelLevel      = resPath & "/util/badmt/res/sysdata/LevelInfo.xlsx"
    ExcelPub        = resPath & "/util/badmt/res/sysdata/pubCode.xlsx"
    ExcelTeam       = resPath & "/util/badmt/res/sysdata/team.xlsx"
    ExcelTeamGB     = resPath & "/util/badmt/res/sysdata/TeamgbInfo.xlsx"    
    ExcelRank       = resPath & "/util/badmt/res/sysdata/Rank_Code.xlsx"
    ExcelSido       = resPath & "/util/badmt/res/sysdata/Sido_Code.xlsx"
    ExcelGugun      = resPath & "/util/badmt/res/sysdata/Gugun_Code.xlsx"

    arySrc = LoadExcelFile(ExcelSrc)
    aryGameKind = LoadExcelFile(ExcelGameKind)
    aryLevel = LoadExcelFile(ExcelLevel)
    aryPub = LoadExcelFile(ExcelPub)
    aryTeam = LoadExcelFile(ExcelTeam)
    aryTeamGB = LoadExcelFile(ExcelTeamGB)

    aryRank = LoadExcelFile(ExcelRank)
    arySido = LoadExcelFile(ExcelSido)
    aryGugun = LoadExcelFile(ExcelGugun)
    
    strData = ""

    strRet = ""
    strKind = ""
    strLevel = ""
    strRank = ""
    strSido = "광주"
    strTeamGB = "일반부"

    g_sex = ""                  ' game sex   : 남자, 여자 , 혼합
    g_type = ""                 ' game play type : 개인전 , 단체전 
    gc_sex = ""                 ' game sex code : 
    gc_type = ""                ' game type code
    gc_level = ""               ' game level code
    gc_rank = ""                ' game rank code
    gc_sido = "5"                ' game sido code   : 광주 
    gc_teamGB = "16001"         ' game Team Gubun code : 아마추어 
    gc_entryType = "A"          ' game Entry Type : 아마추어 

    p1_gugun = ""               ' player 1 시군 
    p1_club = ""                ' player 1 클럽
    p1_name = ""                ' player 1 이름
    p1_birthDay = ""            ' player 1 생년월일
    p1_phone = ""               ' player 1 핸드폰
    p1_sex = ""                 ' player 1 성별 : 남자, 여자 

    p1c_gugun = ""              ' player 1 code  시군 
    p1c_club = ""               ' player 1 code  클럽
    p1c_sex = ""                ' player 1 code  성별 

    p2_gugun = ""               ' player 2 시군 
    p2_club = ""                ' player 2 클럽
    p2_name = ""                ' player 2 이름
    p2_birthDay = ""            ' player 2 생년월일
    p2_phone = ""               ' player 2 핸드폰
    p2_sex = ""                 ' player 2 성별 : 남자, 여자 

    p2c_gugun = ""              ' player 2 code  시군 
    p2c_club = ""               ' player 2 code  클럽
    p2c_sex = ""                ' player 2 code  성별 

    strAry = "["


    Dim ul, ul2, i, j, idx

'    strSrc = "1"    
'    gc_level =  FindLevelCode(strSrc, gc_teamGB, gc_entryType )
'
'    strSrc = "30"    
'    gc_level =  FindLevelCode(strSrc, gc_teamGB, gc_entryType )
'
'    strLog = strPrintf("strSrc = {0}, gc_level = {1} , gc_teamGB = {2}, gc_entryType = {3}", Array(strSrc, gc_level, gc_teamGB, gc_entryType))
'
'    response.write strLog
'    response.End
    
    If IsArray(arySrc) Then 
        idx = 0
        ul2 = UBound(arySrc, 1)
        ul = UBound(arySrc, 2)       
        For i = 0 to ul 
            For j = 0 to ul2
                strData = arySrc(j, i)'
                ' Null이 아닐경우 공백 문자를 제거한다. 
                If( Not(arySrc(j, i) = "" Or IsNull(arySrc(j, i)) ) ) Then 
                    strData = RemoveSpace(arySrc(j, i))
                End If'
                If (j = 1) Then             ' 종목
                    strKind = strData
                    Call FindGameType(strData, g_type, gc_type, g_sex, gc_sex)
                ElseIf (j = 2) Then         ' 연령대
                    strLevel = strData
                    gc_level =  FindLevelCode(strData, gc_teamGB, gc_entryType )
                   
                ElseIf (j = 4) Then         ' 출전급수
                    strRank = strData
                    gc_rank =  FindRankNo(strData )
                ElseIf (j = 5) Then         ' p1_시군구
                    p1_gugun = strData
                    p1c_gugun =  FindGugunNo(strData, gc_sido )
                ElseIf (j = 6) Then         ' p1_클럽
                    p1_club = strData
                ElseIf (j = 7) Then         ' p1_성명
                    p1_name = strData
                ElseIf (j = 8) Then         ' p1_생년월일
                    Call FindBirthDayAndSex(strData, p1_birthDay, p1_sex, p1c_sex)
                ElseIf (j = 9) Then         ' p1_전화번호 
                    strData = RepairPhoneNumber(strData)
                    If (CheckPhoneNumberEx(strData) <> True ) Then                                                 
                        strData = strPrintf("******** Error PhoneNumber {0}  ", Array(strData))
                    End If
                    p1_phone = strData

                ElseIf (j = 14) Then         ' p2_시군구
                    p2_gugun = strData
                    p2c_gugun =  FindGugunNo(strData, gc_sido )
                ElseIf (j = 15) Then         ' p2_클럽
                    p2_club = strData
                ElseIf (j = 16) Then         ' p2_성명
                    p2_name = strData
                ElseIf (j = 17) Then         ' p2_생년월일
                    Call FindBirthDayAndSex(strData, p2_birthDay, p2_sex, p2c_sex)
                ElseIf (j = 18) Then         ' p2_전화번호 
                    strData = RepairPhoneNumber(strData)
                    If (CheckPhoneNumberEx(strData) <> True ) Then                                                 
                        strData = strPrintf("******** Error PhoneNumber {0}  ", Array(strData))
                    End If
                    p2_phone = strData
                End If                
            Next
            
            strRet = strPrintf("<br>{0},{1},{2},{3},{4},{5},{6},{7},{8},{9},{10},{11} <br>", _ 
                      Array(strTeamGB,gc_teamGB,gc_entryType, strKind,g_type,g_sex,gc_sex,gc_type,strLevel,gc_level,strRank,gc_rank))

            strRet = strPrintf("{0},{1},{2},{3},{4},{5},{6},{7},{8},{9},{10},{11} <br>", _ 
                      Array(strRet, p1_name,p1_birthDay,p1c_sex,p1_phone,p1_club,strSido, gc_sido, p1_gugun,p1c_gugun,gc_rank,strRank))

            strRet = strPrintf("{0},{1},{2},{3},{4},{5},{6},{7},{8},{9},{10},{11} <br><br>", _ 
                      Array(strRet, p2_name,p2_birthDay,p2c_sex,p2_phone,p2_club,strSido, gc_sido, p2_gugun,p2c_gugun,gc_rank,strRank))
            
            
            strAData = strPrintf("['{0}','{1}','{2}','{3}','{4}','{5}','{6}','{7}','{8}','{9}','{10}','{11}'", _ 
                      Array(strTeamGB,gc_teamGB,gc_entryType, strKind,g_type,gc_type,g_sex,gc_sex,strLevel,gc_level,strRank,gc_rank))

            strAData = strPrintf("{0},'{1}','{2}','{3}','{4}','{5}','{6}','{7}','{8}','{9}','{10}','{11}'", _ 
                      Array(strAData, p1_name,p1_birthDay,p1c_sex,p1_phone,p1_club,strSido, gc_sido, p1_gugun,p1c_gugun,strRank, gc_rank))

            strAData = strPrintf("{0},'{1}','{2}','{3}','{4}','{5}','{6}','{7}','{8}','{9}','{10}','{11}' ]", _ 
                      Array(strAData, p2_name,p2_birthDay,p2c_sex,p2_phone,p2_club,strSido, gc_sido, p2_gugun,p2c_gugun,strRank, gc_rank))
            

            If(i <> ul) Then strAData = strPrintf("{0}, ", Array(strAData))

            strAry = strAry & strAData

'            idx = idx + 1
'            strAData = strPrintf("<div id = 'div_direct_{0}'>{1},{2},{3},{4},{5},{6},{7},{8},{9},{10},{11},{12}", _ 
'                      Array(idx, strTeamGB,gc_teamGB,gc_entryType, strKind,g_type,g_sex,gc_sex,gc_type,strLevel,gc_level,strRank,gc_rank))
'
'            strAData = strPrintf("{0},{1},{2},{3},{4},{5},{6},{7},{8},{9},{10},{11}", _ 
'                      Array(strAData, p1_name,p1_birthDay,p1c_sex,p1_phone,p1_club,strSido, gc_sido, p1_gugun,p1c_gugun,gc_rank,strRank))
'
'            strAData = strPrintf("{0},{1},{2},{3},{4},{5},{6},{7},{8},{9},{10},{11} </div>", _ 
'                      Array(strAData, p2_name,p2_birthDay,p2c_sex,p2_phone,p2_club,strSido, gc_sido, p2_gugun,p2c_gugun,gc_rank,strRank))
       


        '    badmt.AddDataForDirectReg(strAData) 
        '    AddDataForDirectReg(strAData)
            

        '    Response.write strAData
       '//'     Response.write strRet
        '    Response.flush    '처리 완료된 데이터를 출력
        Next 
    End If  

    strAry = strAry & "]"

 '   Response.write strAry
 '   Response.flush    '처리 완료된 데이터를 출력
    
'    Response.Clear    '버퍼 내용 초기화
'    Response.End    '페이지 종료
%>


<script language="Javascript">
    
    var aryDirect = <%=strAry%>;

    badmt.reqDirectReg("", aryDirect);

//    document.write(aryDirect);

//    var len = aryDirect.length; 
//
//    for(i=0; i< len ; i++)
//    {
//        strLog = utx.strPrintf("aryDirect[{0}] = {1} <br>", i, aryDirect[i] );
//        document.write(strLog);
//    }
</script>

<% 
'   ===============================================================================     
'      Sub Function 
'   =============================================================================== 
'   ===============================================================================     
'      문자열 변환 종목문자 => 게임 타입/타입코드, 게임 성별/성별코드, 
'   =============================================================================== 
    Function FindGameType(strSrc, byref g_type, byref g_typeCode, byref g_sex, byref g_sexCode)
        Dim i, ul
        
        If IsArray(aryGameKind) Then 
            ul = UBound(aryGameKind, 2) 

            For i = 0 to ul 
                If( aryGameKind(0, i) = strSrc ) Then  
                    g_sex = aryGameKind(1, i)
                    g_type = aryGameKind(2, i)
                    g_sexCode = aryGameKind(3, i)
                    g_typeCode = aryGameKind(4, i)
                    Exit For
                End If
            Next 
        End If  
    End Function

'   ===============================================================================     
'      820326-1  => 생년월일 / 성별 구분
'   =============================================================================== 
    Function FindBirthDayAndSex(strSrc, ByRef birthDay, ByRef sex, ByRef sexCode)
        Dim len1, pos, strBirth, strSex, str1 

        len1 = Len(strSrc)
        pos = instr(strSrc, "-")

'        strLog = strPrintf("strSrc = {0}, len1 = {1}, pos = {2}<br><br>", Array(strSrc, len1, pos))
'        Response.Write strLog
        
        If (len1 = 8 And pos = 7 ) Then 
            strBirth = Mid(strSrc, 1,6)
            strSex = Mid(strSrc, 8, 1)

'            strLog = strPrintf("strBirth = {0}, strSex = {1}<br><br>", Array(strBirth, strSex))
'            Response.Write strLog

            str1 = Mid(strBirth, 1,2)
            If (CDbl(str1) > 30 ) Then 
                birthDay = strPrintf("19{0}", Array(strBirth))
            ElseIf (CDbl(str1) < 30 ) Then 
                birthDay = strPrintf("20{0}", Array(strBirth))
            End If 

            If (strSex = "1") Then 
                sex = "남자"
                sexCode = "Man"
            ElseIf (strSex = "2") Then 
                sex = "여자"
                sexCode = "Woman"
            End If
        End If

        
    End Function

'   ===============================================================================     
'      문자열 변환 Level문자 => Level Code
'   ===============================================================================     
    Function FindLevelCode(str, teamGBCode, entryCode)        
        Dim ret, i, ul

'        strLog = strPrintf("str = {0}, teamGBCode = {1}, entryCode = {2}<br>", Array(str, teamGBCode, entryCode))
'        Response.Write strLog


        If IsArray(aryLevel) Then 
            ul = UBound(aryLevel, 2) 

            For i = 0 to ul 

'            strLog = strPrintf("level = {0}, lc = {1}, teamGB = {2}, EnterType = {3}<br>", Array(aryLevel(0, i), aryLevel(1, i), aryLevel(2, i), aryLevel(3, i)))
'            Response.Write strLog

                If( aryLevel(2, i) = teamGBCode ) Then  
                    If( aryLevel(3, i) = entryCode ) Then  
                        If( aryLevel(0, i) = str ) Then  
                            ret = aryLevel(1, i)
                            Exit For
                        End If
                    End If
                End If
            Next 
        End If  

        FindLevelCode = ret
    End Function 

'   ===============================================================================     
'      문자열 변환 Team문자 => Team Code
'   ===============================================================================     
    Function FindTeamCode(str, sidoCode, gugunCode)        
        Dim ret, i, ul
        
        If IsArray(aryTeam) Then 
            ul = UBound(aryTeam, 2) 

            For i = 0 to ul 
                If( aryTeam(2, i) = sidoCode ) Then  
                    If( aryTeam(3, i) = gugunCode ) Then  
                        If( aryTeam(0, i) = str ) Then  
                            ret = aryTeam(1, i)
                            Exit For
                        End If
                    End If
                End If

'                strLog = strPrintf("{0}, {1}, {2}, {3}<br>", Array(aryTeam(0, i), aryTeam(1, i), aryTeam(2, i), aryTeam(3, i)))
'                Response.Write strLog
            Next 
        End If  

        FindTeamCode = ret
    End Function 








'   ===============================================================================     
'      문자열 변환 시도문자 => 시도 Code
'   ===============================================================================     
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

'   ===============================================================================     
'      문자열 변환 구군문자 => 구군 Code
'   ===============================================================================     
    Function FindGugunNo(str, sidoNum)
        Dim ret, i, ul

        If IsArray(aryGugun) Then 
            ul = UBound(aryGugun, 2) 

            For i = 0 to ul 
'                strLog = strPrintf("gugun = {0}, gugunCode = {1}, sido = {2}<br>", Array(aryGugun(0, i), aryGugun(1, i), aryGugun(2, i)))
'                Response.write(strLog)

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

'   ===============================================================================     
'      문자열 변환 Rank문자 => Rank Code
'   =============================================================================== 
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

    Function DataTest()

        strSrc = "820326-1"
        Call FindBirthDayAndSex(strSrc, p1_birthDay, p1_sex, p1c_sex)

        strLog = strPrintf("birth = {0}, sex = {1}, sexCode = {2}<br><br>", Array(p1_birthDay, p1_sex, p1c_sex))
        Response.Write strLog

        strSrc = "혼복"
        Call FindGameType(strSrc, g_type, gc_type, g_sex, gc_sex)

        strLog = strPrintf("g_type = {0}, gc_type = {1}, g_sex = {2}, gc_sex = {3}<br><br>", Array(g_type, gc_type, g_sex, gc_sex))
        Response.Write strLog

        strSrc = "여복"
        Call FindGameType(strSrc, g_type, gc_type, g_sex, gc_sex)

        strLog = strPrintf("g_type = {0}, gc_type = {1}, g_sex = {2}, gc_sex = {3}<br><br>", Array(g_type, gc_type, g_sex, gc_sex))
        Response.Write strLog

        strSrc = "남복"
        Call FindGameType(strSrc, g_type, gc_type, g_sex, gc_sex)

        strLog = strPrintf("g_type = {0}, gc_type = {1}, g_sex = {2}, gc_sex = {3}<br><br>", Array(g_type, gc_type, g_sex, gc_sex))
        Response.Write strLog


        strSrc = "30"
        strLevel =  FindLevelCode(strSrc, gc_teamGB, gc_entryType )

        strLog = strPrintf("strSrc = {0}, strLevel = {1}<br><br>", Array(strSrc, strLevel))
        Response.Write strLog

        strSrc = "45"
        strLevel =  FindLevelCode(strSrc, gc_teamGB, gc_entryType )

        strLog = strPrintf("strSrc = {0}, strLevel = {1}<br><br>", Array(strSrc, strLevel))
        Response.Write strLog

        strSrc = "청송"
        strTeamCode =  FindTeamCode(strSrc, "15", "15019")

        strLog = strPrintf("strSrc = {0}, strTeamCode = {1}<br><br>", Array(strSrc, strTeamCode))
        Response.Write strLog
    End Function      
%>

<script language="Javascript">

</script>