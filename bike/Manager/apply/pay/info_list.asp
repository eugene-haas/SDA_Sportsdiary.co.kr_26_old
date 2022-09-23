<!-- #include virtual = "/pub/header.bike.asp" -->
<!-- #include virtual = "/library/fn.bike.asp" -->

<%
SET db = Server.CreateObject("ADODB.Connection")
    db.CommandTimeout = 1000
    db.Open B_ConStr
req = request("req")

If req <> "" Then
  Set oJSONoutput = JSON.Parse(req)
  PN            = oJSONoutput.get("PN")
  titleIdx      = oJSONoutput.get("titleIdx")
  sdate         = oJSONoutput.get("sdate")
  edate         = oJSONoutput.get("edate")
  paymentState  = oJSONoutput.get("paymentState")
  searchType    = oJSONoutput.get("searchType")
  searchText    = oJSONoutput.get("searchText")
Else
  Set oJSONoutput = JSON.Parse("{}")
End If

' S:페이징 설정값
If PN = "" Then
  PN = 1
End If
pageSize = 1000
blockSize = 10
' E:페이징 설정값

SQL =       " SELECT * FROM ( "
SQL = SQL & " SELECT TOP 100 PERCENT ROW_NUMBER() OVER(ORDER BY WriteDate DESC) RowNum, * FROM ( "
SQL = SQL & " SELECT  COUNT(*) OVER(PARTITION BY 1) AS TatalCount "
SQL = SQL & "       , pay.PaymentIdx, pay.MemberIdx, pay.TitleIdx, title.TitleName, member.UserId, member.UserName, member.Sex, scrp.Category, scrp.Rating "
SQL = SQL & " 	    , gift.GiftName, gift.GiftOption, applyList.eventList, member.Birthday, member.UserPhone, parent.Relation "
SQL = SQL & " 	    , parent.ParentName, parent.ParentPhone, parent.AgreeYN, pay.PaymentState, price.Price, pay.PaymentAccount, pay.WriteDate  "
SQL = SQL & " FROM tblBikePayment pay "
SQL = SQL & " LEFT JOIN "
SQL = SQL & " 		     (SELECT DISTINCT PaymentIdx "
SQL = SQL & " 		     	              , STUFF(( "
SQL = SQL & " 		    			               SELECT ',' + b.EventDetailType "
SQL = SQL & " 		    			               FROM tblBikeEventApplyInfo a "
SQL = SQL & " 		    			               LEFT JOIN tblBikeEventList b ON a.EventIdx = b.EventIdx "
SQL = SQL & "                              LEFT JOIN tblBikeTeamInvite c ON a.TeamIdx = c.TeamIdx AND a.MemberIdx = c.MemberIdx "
SQL = SQL & " 		    			               WHERE ap.PaymentIdx = a.PaymentIdx "
SQL = SQL & "                              AND (c.JoinYN = 'N' OR c.JoinYN IS NULL) "
SQL = SQL & " 		    			               FOR XMl PATH('') "
SQL = SQL & " 		    	                ),1,1,'') eventList "
SQL = SQL & " 		     FROM tblBikeEventApplyInfo ap "
SQL = SQL & " 		     LEFT JOIN tblBikeEventList el ON ap.EventIdx = el.EventIdx "
SQL = SQL & " 		     WHERE PaymentIdx <> 0) applyList ON pay.PaymentIdx = applyList.PaymentIdx "
SQL = SQL & " LEFT JOIN		  "
SQL = SQL & " 		     (SELECT PaymentIdx, SUM(CONVERT(INT,Price)) Price  "
SQL = SQL & " 		     FROM tblBikePaymentHistory  "
SQL = SQL & " 		     GROUP BY PaymentIdx ) price ON pay.PaymentIdx = price.PaymentIdx "
SQL = SQL & " LEFT JOIN tblBikeTitle title ON pay.TitleIdx = title.TitleIdx "
SQL = SQL & " LEFT JOIN tblBikeApplyMemberInfo info ON pay.MemberIdx = info.MemberIdx AND pay.TitleIdx = info.TitleIdx "
SQL = SQL & " LEFT JOIN tblBikeParentInfo parent ON pay.MemberIdx = parent.MemberIdx AND pay.TitleIdx = parent.TitleIdx "
SQL = SQL & " LEFT JOIN SD_Member.dbo.tblMember member ON pay.MemberIdx = member.MemberIDX "
SQL = SQL & " LEFT JOIN (SELECT DISTINCT SCRPRatingIdx, Category, Rating FROM tblBikeSCRP) scrp ON info.SCRP = scrp.SCRPRatingIdx "
SQL = SQL & " LEFT JOIN tblBikeGiftSelect gs ON pay.TitleIdx = gs.TitleIdx AND pay.MemberIdx = gs.MemberIdx "
SQL = SQL & " LEFT JOIN tblBikeGift gift ON gs.Giftidx = gift.GiftIdx "
SQL = SQL & " WHERE pay.DelYN = 'N' "
SQL = SQL & " AND pay.PaymentFor = 'event' "

' S:검색조건
If titleIdx <> "" Then
  SQL = SQL & " AND title.TitleIdx = "& titleIdx &" "
End If
If sdate <> "" Then
  SQL = SQL & " AND pay.WriteDate >= '"& sdate &"' "
End If
If edate <> "" Then
  SQL = SQL & " AND pay.WriteDate <= '"& edate &"' "
End If
If paymentState <> "" Then
  SQL = SQL & " AND pay.PaymentState = '"& paymentState &"' "
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
  arrPayInfo = rs.getRows()
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
        <th>아이디</th>
        <th>선수명</th>
        <th>성별</th>
        <th>생년월일</th>
        <th>연락처</th>
        <th>부서</th>
        <th>등급</th>
        <th>종목신청내역</th>
        <th>입금상태</th>
        <th>입금액</th>
        <th>가상계좌</th>
        <th>가상계좌sms</th>
        <th>신청일시</th>
      </tr>
    </thead>

    <tbody>
      <%
        If IsArray(arrPayInfo) Then
          For i = 0 To Ubound(arrPayInfo, 2)
          PaymentIdx       = arrPayInfo(2, i)
          MemberIdx        = arrPayInfo(3, i)
          TitleIdx         = arrPayInfo(4, i)
          TitleName        = arrPayInfo(5, i)
          UserId           = arrPayInfo(6, i)
          UserName         = arrPayInfo(7, i)
          Sex              = arrPayInfo(8, i)
          Category         = arrPayInfo(9, i)
          Rating           = arrPayInfo(10, i)
          GiftName         = arrPayInfo(11, i)
          GiftOption       = arrPayInfo(12, i)
          EventList        = arrPayInfo(13, i)
          Birthday         = arrPayInfo(14, i)
          UserPhone        = arrPayInfo(15, i)
          adultYN = GetAdultBasedOnTitle(TitleIdx, MemberIdx, db)
          If adultYN = "Y" Then
            adultYNText = "성인"
          ElseIf adultYN = "N" Then
            adultYNText = "미성년자"
          End If
          Relation         = arrPayInfo(16, i)
          ParentName       = arrPayInfo(17, i)
          ParentPhone      = arrPayInfo(18, i)
          AgreeYN          = arrPayInfo(19, i)
          PaymentState     = arrPayInfo(20, i)
          PaymentStateText = ""
          Select Case PaymentState
            Case 0 PaymentStateText = "입금대기"
            Case 1 PaymentStateText = "입금완료"
            Case 2 PaymentStateText = "취소"
            Case 3 PaymentStateText = "환불요청"
            Case 4 PaymentStateText = "환불완료"
          End Select
          Price            = arrPayInfo(21, i)
          PaymentAccount   = arrPayInfo(22, i)
          WriteDate        = arrPayInfo(23, i)
          %>
          <tr>
            <td><%=PaymentIdx%></td>
            <td><%=TitleName%></td>
            <td><%=UserId%></td>
            <td><%=UserName%></td>
            <td><%=Sex%></td>
            <td><%=Birthday%></td>
            <td><%=UserPhone%></td>
            <td><%=Category%></td>
            <td><%=Rating%></td>
            <td><%=EventList%></td>
            <td><%=PaymentStateText%></td>
            <td><%=Price%></td>
            <td><%=PaymentAccount%></td>
            <td><a href="#" onclick="sendText(<%=PaymentIdx%>); return;" class="btn btn-primary">문자발송</a></td>
            <td><%=WriteDate%></td>
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
