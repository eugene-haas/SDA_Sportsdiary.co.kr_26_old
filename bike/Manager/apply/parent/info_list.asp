<!-- #include virtual = "/pub/header.bike.asp" -->
<!-- #include virtual = "/library/fn.bike.asp" -->

<%
SET db = Server.CreateObject("ADODB.Connection")
    db.CommandTimeout = 1000
    db.Open B_ConStr
req = request("req")
If req <> "" Then
  Set oJSONoutput = JSON.Parse(req)
  PN              = oJSONoutput.get("PN")
  titleIdx        = oJSONoutput.get("titleIdx")
  sdate           = oJSONoutput.get("sdate")
  edate           = oJSONoutput.get("edate")
  parentAgreeYN   = oJSONoutput.get("parentAgreeYN")
  searchType      = oJSONoutput.get("searchType")
  searchText      = oJSONoutput.get("searchText")
Else
  Set oJSONoutput = JSON.Parse("{}")
End If

' S:페이징 설정값
If PN = "" Then
  PN = 1
End If
pageSize = 5
blockSize = 10
' E:페이징 설정값

SQL =       " SELECT * FROM ( "
SQL = SQL & " SELECT TOP 100 PERCENT ROW_NUMBER() OVER(ORDER BY WriteDate DESC) RowNum, * FROM ( "
SQL = SQL & " SELECT COUNT(*) OVER(PARTITION BY 1) TotalCount "
SQL = SQL & "      , parent.ParentInfoIdx, title.TitleName, member.UserID, member.UserName, member.Sex, member.Birthday, member.UserPhone, scrp.Category, scrp.Rating "
SQL = SQL & "      , parent.Relation, parent.ParentName, parent.ParentPhone, parent.AgreeYN, title.ApplyStart, parent.WriteDate "
SQL = SQL & " FROM tblBikeParentInfo parent "
SQL = SQL & " INNER JOIN tblBikeTitle title ON parent.TitleIdx = title.TitleIdx "
SQL = SQL & " INNER JOIN tblBikeApplyMemberInfo info ON parent.MemberIdx = info.MemberIdx AND parent.TitleIdx = info.TitleIdx "
SQL = SQL & " INNER JOIN (SELECT DISTINCT SCRPRatingIdx, Category, Rating FROM tblBikeSCRP) scrp ON info.SCRP = scrp.SCRPRatingIdx "
SQL = SQL & " INNER JOIN SD_Member.dbo.tblMember member ON parent.MemberIdx = member.MemberIDX "
SQL = SQL & " WHERE parent.DelYN = 'N' "


' S:검색조건
If titleIdx <> "" Then
  SQL = SQL & " AND title.TitleIdx = "& titleIdx &" "
End If
If sdate <> "" Then
  SQL = SQL & " AND parent.WriteDate >= '"& sdate &"' "
End If
If edate <> "" Then
  SQL = SQL & " AND parent.WriteDate <= '"& edate &"' "
End If
If parentAgreeYN <> "" Then
  SQL = SQL & " AND parent.AgreeYN = '"& parentAgreeYN &"' "
End If
If searchType <> "" AND searchText <> "" Then
  Select Case searchType
    Case "userId"   SQL = SQL & " AND member.UserId = '"& searchText &"' "
    Case "userName" SQL = SQL & " AND member.UserName = '"& searchText &"' "
  End Select
End If
' E:검색조건

SQL = SQL & " ) T1 "
SQL = SQL & " ORDER BY WriteDate DESC "
SQL = SQL & " ) T2 "
SQL = SQL & " WHERE RowNum BetWeen "& ((PN - 1) * pageSize) + 1 &" AND "& PN * pageSize &" "

Set rs = db.Execute(SQL)
If Not rs.eof Then
  totalCount = rs(1)
  arrParentInfo = rs.getRows()
End If
%>

<div class="btn-toolbar" role="toolbar" aria-label="btns">
  <a href="#" class="btn btn-link">전체 :  <%=totalCount%>건</a>

  <div class="btn-group pull-right">
    <a href="" id="" class="btn btn-primary">버튼</a>
    <a class="btn btn-success">엑셀다운로드</a>
  </div>
</div>

<div class="table-responsive">
  <table cellspacing="0" cellpadding="0" class="table table-hover">
    <thead>
      <tr>
        <th>번호</th>
        <th>대회명</th>
        <th>아이디</th>
        <th>선수명</th>
        <th>성별</th>
        <th>생년월일</th>
        <th>연락처</th>
        <th>부서</th>
        <th>등급</th>
        <th>성인/미성년</th>
        <th>보호자관계</th>
        <th>보호자명</th>
        <th>보호자연락처</th>
        <th>보호자동의</th>
        <th>보호자동의sms</th>
      </tr>
    </thead>

    <tbody>
      <%
        If IsArray(arrParentInfo) Then
          For i = 0 To Ubound(arrParentInfo, 2)
            ParentInfoIdx = arrParentInfo(2, i)
            TitleName     = arrParentInfo(3, i)
            UserID        = arrParentInfo(4, i)
            UserName      = arrParentInfo(5, i)
            Sex           = arrParentInfo(6, i)
            Birthday      = arrParentInfo(7, i)
            UserPhone     = arrParentInfo(8, i)
            Category      = arrParentInfo(9, i)
            Rating        = arrParentInfo(10, i)
            Relation      = arrParentInfo(11, i)
            ParentName    = arrParentInfo(12, i)
            ParentPhone   = arrParentInfo(13, i)
            AgreeYN       = arrParentInfo(14, i)
            ApplyStart    = arrParentInfo(15, i)
            AdultYN =  GetAdultYN(birthday, ApplyStart)
            %>
            <tr>
              <td><%=ParentInfoIdx%></td>
              <td><%=TitleName%></td>
              <td><%=UserID%></td>
              <td><%=UserName%></td>
              <td><%=Sex%></td>
              <td><%=Birthday%></td>
              <td><%=UserPhone%></td>
              <td><%=Category%></td>
              <td><%=Rating%></td>
              <td><%=AdultYN%></td>
              <td><%=Relation%></td>
              <td><%=ParentName%></td>
              <td><%=ParentPhone%></td>
              <td><%=AgreeYN%></td>
              <td ><a href="#" onclick="sendText(<%=ParentInfoIdx%>, '<%=UserName%>'); return;" class="btn btn-primary">문자발송</a></td>
            </tr>
            <%
          Next
        End If
      %>
    </tbody>
  </table>
</div>

<nav>
  <div class="container-fluid text-center">
    <%
      tPage = totalPage(totalCount, pageSize)
      jsonStr = JSON.Stringify(oJSONoutput)
      Call bikeAdminPaging(tPage, blockSize, PN, "goPN", jsonStr, "info_list.asp", "infoList")
    %>
  </div>
</nav>
