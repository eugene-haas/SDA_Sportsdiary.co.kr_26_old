<%

idx = oJSONoutput.IDX
groupno = oJSONoutput.GROUPNO

Set db = new clsDBHelper

'개인참가자
If groupno > 0 Then

    '경기신청 리스트
    strField = " c.detailtitle, a.pgrade "
    strTable = " sd_bikeAttMember a "
    strTableSub1 = " LEFT JOIN sd_bikeGame b ON a.gameIDX = b.gameIDX "
    strTableSub2 = " LEFT JOIN sd_bikeLevel c ON b.levelno = c.levelIDX "
    strTable = strTable&strTableSub1&strTableSub2
    strWhere = " a.groupno = "&groupno&" "
    SQL = " SELECT "&strField&" FROM "&strTable&" WHERE "&strWhere&" "
    Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)

    If Not rs.eof Then
        arrRs = rs.GetRows()
    End If

    '전화번호, 동의여부, 등급
    strField = " b.pgrade, b.p_agree, c.UserPhone, c.Birthday " 
    strTable = " sd_bikeRequest a "
    strTableSub1 = " INNER JOIN sd_bikeAttMember b ON a.gameIDX = b.gameIDX "
    strTableSub2 = " INNER JOIN sd_bikePlayer c ON a.PlayerIDX = c.PlayerIDX "
    strWhere = " a.requestIDX = "&idx&" " 
    SQL = " SELECT "&strField&" FROM "&strTable&strTableSub1&strTableSub2&" WHERE "&strWhere&" "
    Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)
    pgrade = rs("pgrade")
    pagree = rs("p_agree")
    userPhone = rs("UserPhone")
    birthday = rs("Birthday")

ElseIf groupno = 0 Then

    'gameidx 구하기
    SQL = " SELECT gameidx FROM sd_bikeRequest WHERE requestIDX = "&idx&" "
    Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)
    gameidx = rs(0)

    '멤버 리스트 
    strField = " a.UserName, a.pgrade, a.p_agree, b.userPhone, b.birthday, ( case a.sex when 'man' then '남' when 'woman' then '여' else a.sex end ) sex "
    strTable = " sd_bikeAttmember a "
    strTableSub1 = " INNER JOIN sd_bikePlayer b ON a.playerIDX = b.playerIDX "
    strWhere = " a.PlayerIDX IN (select PlayerIDX from sd_bikeAttmember where gameidx  = "&gameidx&" ) AND a.groupno = 0 "
    SQL = " SELECT "&strField&" FROM "&strTable&strTableSub1&" WHERE "&strWhere&" "

    Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)

    If Not rs.eof Then
        arrRs2 = rs.GetRows()
    End If

End If





'###############################################
%>

<% If groupno <> 0 Then %>
    생년월일 : <%=birthday%>
    부모님 동의 : <%=pagree%>
    전화번호 : <%=userPhone%>
    참가 경기 : <%
        If IsArray(arrRs) Then
            For ar = LBound(arrRs, 2) To UBound(arrRs, 2)
                detailtitle = arrRs(0, ar)
                %><%=ar + 1%>.<%=detailtitle&"("&pgrade&")   "%><%
            Next
        End If %>

<% ElseIf groupno = 0 Then %>
선수 : 등급 : 부모동의 : 번호 : 생년월일 <%= vbCrLf %>
    <%
        If IsArray(arrRs2) Then
            For ar = LBound(arrRs2, 2) To UBound(arrRs2, 2)
                UserName = arrRs2(0, ar)
                pgrade = arrRs2(1, ar)
                pagree = arrRs2(2, ar)
                userPhone = arrRs2(3, ar)
                birthday = arrRs2(4, ar)
                sex = arrRs2(5, ar)

                '나이구분
                myage = GetAge(birthday)

                If CDbl(myage) < 19 Then
                    myageST = "미성년자"
                Else
                    myageST = "성인"
                End if

                %><%=UserName%>(<%=sex%>) : <%=pgrade%> : <%=pagree%> : <%=userPhone%> : <%=birthday&"("&myageST&")" & vbCrLf%>
                <%
            Next
        End If %>
<% End If %>


