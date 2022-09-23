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
  gender          = oJSONoutput.get("gender")
  playerType      = oJSONoutput.get("playerType")
  sdate           = oJSONoutput.get("sdate")
  edate           = oJSONoutput.get("edate")
  searchType      = oJSONoutput.get("searchType")
  searchText      = oJSONoutput.get("searchText")
  groupType       = oJSONoutput.get("groupType")
  eventType       = oJSONoutput.get("eventType")
  ratingCategory  = oJSONoutput.get("ratingCategory")
  eventDetailType = oJSONoutput.get("eventDetailType")
  paymentRequest  = oJSONoutput.get("paymentRequest")
Else
  Set oJSONoutput = JSON.Parse("{}")
End If

' S:페이징 설정값
If PN = "" Then
  PN = 1
End If
pageSize = 10
blockSize = 10
' E:페이징 설정값


SQL =       " SELECT * FROM ( "
SQL = SQL & " SELECT TOP 100 PERCENT ROW_NUMBER() OVER(ORDER BY WriteDate DESC) RowNum, * FROM ( "
SQL = SQL & " SELECT COUNT(*) OVER(PARTITION BY 1) TotalCount "
SQL = SQL & "      , a.EventApplyIdx, title.TitleName, team.TeamName, b.GroupType, member.UserId, member.UserName, member.Sex, member.Birthday, member.UserPhone "
SQL = SQL & "      , scrp.Category, scrp.Rating, b.CourseLength, b.EventDetailType, gift.GiftOption  "
SQL = SQL & "      , ISNULL(f.PaymentState, 0) PaymentState, title.ApplyStart, a.WriteDate, a.PaymentIdx "
SQL = SQL & " FROM ( SELECT MemberIdx, TeamIdx, EventIdx, PaymentIdx, EventApplyIdx, WriteDate FROM tblBikeEventApplyInfo "
SQL = SQL & "        WHERE DelYN = 'N' "
SQL = SQL & "        UNION ALL "
SQL = SQL & "        SELECT a.MemberIdx, a.TeamIdx, b.EventIdx, 0, 0, WriteDate FROM tblBikeTeamInvite a "
SQL = SQL & "        LEFT JOIN tblBikeTeam b ON a.TeamIdx = b.TeamIdx "
SQL = SQL & "        WHERE a.JoinYN = 'N' AND a.DelYN = 'N' "
SQL = SQL & "      ) a  "
SQL = SQL & " INNER JOIN tblBikeEventList b ON a.EventIdx = b.EventIdx  "
SQL = SQL & " INNER JOIN tblBikeApplyMemberInfo c ON a.MemberIdx = c.MemberIdx AND b.TitleIdx = c.TitleIdx"
SQL = SQL & " INNER JOIN tblBikeParentInfo d ON a.MemberIdx = d.MemberIdx AND b.TitleIdx = d.TitleIdx  "
SQL = SQL & " LEFT JOIN tblBikeGiftSelect e ON a.MemberIdx = e.MemberIdx AND b.TitleIdx = e.TitleIdx  "
SQL = SQL & " LEFT JOIN tblBikePayment f ON a.PaymentIdx = f.PaymentIdx  "
SQL = SQL & " INNER JOIN (SELECT SCRPRatingIdx, Category, Rating FROM tblBikeSCRP GROUP BY SCRPRatingIdx, Category, Rating) scrp ON c.SCRP = scrp.SCRPRatingIdx  "
SQL = SQL & " LEFT JOIN tblBikeGift gift ON e.Giftidx = gift.GiftIdx  "
SQL = SQL & " INNER JOIN SD_Member.dbo.tblMember member ON a.MemberIdx = member.MemberIDX  "
SQL = SQL & " INNER JOIN tblBikeTitle title ON b.TitleIdx = title.TitleIdx  "
SQL = SQL & " LEFT JOIN tblBikeTeam team ON a.TeamIdx = team.TeamIdx "
SQL = SQL & " WHERE b.DelYN = 'N'"

' S: 검색조건
If titleIdx <> "" Then
  SQL = SQL & " AND title.TitleIdx = "& titleIdx &" "
End If

If playerType <> "" Then
  SQL = SQL & " AND title.Type = '"& playerType &"' "
End If

If sdate <> "" Then
  SQL = SQL & " AND a.WriteDate >= '"& sdate &"' "
End If

If edate <> "" Then
  SQL = SQL & " AND a.WriteDate <= '"& edate &"' "
End If

If searchType <> "" AND searchText <> "" Then
  Select Case searchType
    Case "userId"   SQL = SQL & " AND member.UserId = '"& searchText &"' "
    Case "userName" SQL = SQL & " AND member.UserName = '"& searchText &"' "
  End Select
End If

If groupType <> "" Then
  SQL = SQL & " AND b.groupType = '"& groupType &"' "
End If

If eventType <> "" Then
  SQL = SQL & " AND b.eventType = '"& eventType &"' "
End If

If gender <> ""  AND gender <> "전체" Then
  SQL = SQL & " AND b.gender = '"& gender &"' "
End If

If ratingCategory <> "" Then
  SQL = SQL & " AND b.ratingCategory = '"& ratingCategory &"' "
End If

If eventDetailType <> "" Then
  SQL = SQL & " AND b.eventDetailType = '"& eventDetailType &"' "
End If

If paymentRequest <> "" Then
  Select Case paymentRequest
    Case "Y" SQL = SQL & " AND a.PaymentIdx > 0 "
    Case "N" SQL = SQL & " AND a.PaymentIdx = 0 "
  End Select
End If
' E: 검색조건
SQL = SQL & " ) T1 "
SQL = SQL & " ORDER BY WriteDate DESC "
SQL = SQL & " ) T2 "
SQL = SQL & " WHERE RowNum BetWeen "& ((PN - 1) * pageSize) + 1 &" AND "& PN * pageSize &" "

Set rs = db.Execute(SQL)
If Not rs.eof Then
  totalCount = rs("TotalCount")
  arrApplyPlayer = rs.getRows()
End If

%>

<div class="btn-toolbar" role="toolbar" aria-label="btns">
  <a href="#" class="btn btn-link">전체 : <%=totalCount%> 건</a>

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
        <th>개인/단체</th>
        <th>아이디</th>
        <th>선수명</th>
        <th>팀명</th>
        <th>성별</th>
        <th>생년월일</th>
        <th>연락처</th>
        <th>부서</th>
        <th>등급</th>
        <th>종목</th>
        <th>의류</th>
        <th>미성년</th>
        <th>계좌요청</th>
        <th>입금</th>
      </tr>
    </thead>

    <tbody>
        <%
          If IsArray(arrApplyPlayer) Then
            For i = 0 To Ubound(arrApplyPlayer, 2)
              EventApplyIdx   = arrApplyPlayer(2, i)
              TitleName       = arrApplyPlayer(3, i)
              TeamName        = arrApplyPlayer(4, i)
              GroupType       = arrApplyPlayer(5, i)
              UserId          = arrApplyPlayer(6, i)
              UserName        = arrApplyPlayer(7, i)
              Sex             = arrApplyPlayer(8, i)
              Birthday        = arrApplyPlayer(9, i)
              UserPhone       = arrApplyPlayer(10, i)
              Category        = arrApplyPlayer(11, i)
              Rating          = arrApplyPlayer(12, i)
              CourseLength    = arrApplyPlayer(13, i)
              EventDetailType = arrApplyPlayer(14, i)
              GiftOption      = arrApplyPlayer(15, i)
              PaymentState    = arrApplyPlayer(16, i)
              ApplyStart      = arrApplyPlayer(17, i)
              PaymentIdx      = arrApplyPlayer(19, i)

              adultYN = GetAdultYN(Birthday, ApplyStart)
              If adultYN = "Y" Then
                adultYNText = "성인"
              ElseIf adultYN = "N" Then
                adultYNText = "미성년"
              End If

              PaymentStateText = ""
              Select Case PaymentState
                Case 0 PaymentStateText = "입금대기"
                Case 1 PaymentStateText = "입금완료"
                Case 2 PaymentStateText = "환불요청"
                Case 3 PaymentStateText = "환불완료"
              End Select

              paymentReqeust = "N"
              If Cdbl(PaymentIdx) > 0 Then
                paymentReqeust = "Y"
              End If
              %>
              <tr>
                <td><%=EventApplyIdx%></td>
                <td><%=TitleName%></td>
                <td><%=GroupType%></td>
                <td><%=UserId%></td>
                <td><%=UserName%></td>
                <td><%=TeamName%></td>
                <td><%=Sex%></td>
                <td><%=Birthday%></td>
                <td><%=UserPhone%></td>
                <td><%=Category%></td>
                <td><%=Rating%></td>
                <td><%=CourseLength%><%=EventDetailType%></td>
                <td><%=GiftOption%></td>
                <td><%=adultYN%></td>
                <td><%=paymentReqeust%></td>
                <td><%=PaymentStateText%></td>
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
