<!-- #include virtual = "/pub/header.bike.asp" -->
<!-- #include virtual = "/library/fn.bike.asp" -->

<%
Set db = new clsDBHelper

req = request("req")
If req <> "" Then
  Set oJSONoutput = JSON.Parse(req)
  PN              = oJSONoutput.get("PN")
  titleIdx        = oJSONoutput.get("titleIdx")
Else
  Set oJSONoutput = JSON.Parse("{}")
  titleIdx = request("titleIdx")
  oJSONoutput.Set("titleIdx"), titleIdx
End If

If titleIdx = "" Then
  titleIdx = Session("titleIdx")
End If


' S:페이징 설정값
If PN = "" Then
  PN = 1
End If
pageSize = 1000
blockSize = 10
' E:페이징 설정값

If titleIdx = "" Then
  response.redirect "/contest/info.asp"
End If

SQL =       " SELECT * FROM ( "
SQL = SQL & " SELECT TOP 100 PERCENT ROW_NUMBER() OVER(ORDER BY WriteDate DESC) RowNum, * FROM ( "
SQL = SQL & " SELECT COUNT(*) OVER(PARTITION BY 1) TotalCount "
SQL = SQL & " , a.EventIdx, EventDate, b.Type, EventType, GroupType, Gender, RatingCategory, CourseLength, EventDetailType, MinPlayer, MaxPlayer, EntryFee, MemberLimit, a.WriteDate "
SQL = SQL & " FROM tblBikeEventList a LEFT JOIN tblBikeTitle b ON a.TitleIdx = b.TitleIdx "
SQL = SQL & " WHERE a.titleIdx = "& titleIdx &" AND a.DelYN = 'N' "
SQL = SQL & " ) T1 "
SQL = SQL & " ORDER BY WriteDate DESC "
SQL = SQL & " ) T2 "
SQL = SQL & " WHERE RowNum BetWeen "& ((PN - 1) * pageSize) + 1 &" AND "& PN * pageSize &" "
Set rs = db.ExecSQLReturnRs(SQL, Null, ConStr)
If Not rs.eof Then
  totalCount = rs(1)
  arrRs = rs.getRows()
End If


%>

<div class="btn-toolbar" role="toolbar" aria-label="btns">
  <a href="#" class="btn btn-link">전체 : <%=totalCount%> 건</a>

  <div class="btn-group pull-right">
    <a href="contest.asp" id="" class="btn btn-primary">대회관리</a>
  </div>
</div>

<div class="table-responsive">
  <table cellspacing="0" cellpadding="0" class="table table-hover">
    <thead>
      <tr>
        <th>번호</th>
        <th>경기일자</th>
        <th>대회유형</th>
        <th>경기유형</th>
        <th>개인/단체</th>
        <th>성별</th>
        <th>부서</th>
        <th>코스길이</th>
        <th>종목</th>
        <th>팀제한</th>
        <th>신청인원</th>
        <th>참가비</th>
        <th>선수정보</th>
      </tr>
    </thead>

    <tbody>
        <%
          If IsArray(arrRs) Then
            For i = 0 To Ubound(arrRs, 2)
              EventIdx        = arrRs(2, i)
              EventDate       = arrRs(3, i)
              PlayerType      = arrRs(4, i)
              EventType       = arrRs(5, i)
              GroupType       = arrRs(6, i)
              Gender          = arrRs(7, i)
              RatingCategory  = arrRs(8, i)
              CourseLength    = arrRs(9, i)
              EventDetailType = arrRs(10, i)
              MinPlayer       = arrRs(11, i)
              MaxPlayer       = arrRs(12, i)
              EntryFee        = arrRs(13, i)
              MemberLimit     = arrRs(14, i)
              %>
              <tr class="event_row" onclick="selectEvent($(this), <%=EventIdx%>)">
                <td><span><%=EventIdx%></span></td>
                <td><span><%=EventDate%></span></td>
                <td><span><%=PlayerType%></span></td>
                <td><span><%=EventType%></span></td>
                <td><span><%=GroupType%></span></td>
                <td><span><%=Gender%></span></td>
                <td><span><%=RatingCategory%></span></td>
                <td><span><%=CourseLength%></span></td>
                <td><span><%=EventDetailType%></span></td>
                <td><span><%=MinPlayer%>~<%=MaxPlayer%></span></td>
                <td><span><%=MemberLimit%></span></td>
                <td><span><%=EntryFee%></span></td>
                <td><span><a href="" class="btn btn-primary">신청목록</a></span></td>
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
