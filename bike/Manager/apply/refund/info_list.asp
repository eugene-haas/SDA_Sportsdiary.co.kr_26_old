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
  refundYN      = oJSONoutput.get("refundYN")
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
SQL = SQL & " SELECT COUNT(*) OVER(PARTITION BY 1) AS TatalCount "
SQL = SQL & "        , refund.RefundIdx, title.TitleName, member.UserID, member.UserName, member.Sex, member.Birthday, scrp.Category, scrp.Rating"
SQL = SQL & " 	     , applyList.eventList, member.UserPhone, deposit.TR_AMT "
SQL = SQL & " 	     , refund.AccountName, refund.AccountBank, refund.AccountNumber, refund.RefundYN, refund.PaymentIdx, refund.refundDate, refund.WriteDate "
SQL = SQL & " FROM tblBikeRefund refund "
SQL = SQL & " INNER JOIN tblBikePayment pay ON refund.PaymentIdx = pay.PaymentIdx "
SQL = SQL & " LEFT JOIN (SELECT SUM(CONVERT(INT, Price)) Price, PaymentIdx  "
SQL = SQL & " 		       FROM tblBikePaymentHistory  "
SQL = SQL & " 		       GROUP BY PaymentIdx) price ON refund.PaymentIdx = price.PaymentIdx "
SQL = SQL & " INNER JOIN tblBikeTitle title ON pay.TitleIdx = title.TitleIdx "
SQL = SQL & " INNER JOIN SD_Member.dbo.tblMember member ON pay.MemberIdx = member.MemberIDX "
SQL = SQL & " LEFT JOIN "
SQL = SQL & " 		     (SELECT DISTINCT PaymentIdx "
SQL = SQL & " 		     	              , STUFF(( "
SQL = SQL & " 		    			               SELECT ',' + b.EventDetailType "
SQL = SQL & " 		    			               FROM tblBikeEventApplyInfo a "
SQL = SQL & " 		    			               LEFT JOIN tblBikeEventList b ON a.EventIdx = b.EventIdx "
SQL = SQL & " 		    			               WHERE ap.PaymentIdx = a.PaymentIdx "
SQL = SQL & " 		    			               FOR XMl PATH('') "
SQL = SQL & " 		    	                ),1,1,'') eventList "
SQL = SQL & " 		     FROM tblBikeEventApplyInfo ap "
SQL = SQL & " 		     WHERE PaymentIdx <> 0) applyList ON pay.PaymentIdx = applyList.PaymentIdx "
SQL = SQL & " INNER JOIN tblBikeApplyMemberInfo info ON pay.MemberIdx = info.MemberIdx AND title.TitleIdx = info.TitleIdx		  "
SQL = SQL & " INNER JOIN (SELECT DISTINCT SCRPRatingIdx, Category, Rating FROM tblBikeSCRP) scrp ON info.SCRP = scrp.SCRPRatingIdx "
SQL = SQL & " INNER JOIN SD_RookieTennis.dbo.TB_RVAS_LIST deposit ON pay.TR_DATE = deposit.TR_DATE AND pay.TR_SEQ = deposit.TR_SEQ AND pay.PaymentAccount = deposit.VACCT_NO "
SQL = SQL & " WHERE pay.PaymentFor = 'event' "

' S:검색조건
If titleIdx <> "" Then
  SQL = SQL & " AND title.TitleIdx = "& titleIdx &" "
End If
If refundYN <> "" Then
  SQL = SQL & " AND refund.RefundYN = '"& refundYN &"' "
End If
If sdate <> "" Then
  SQL = SQL & " AND refund.WriteDate >= '"& sdate &"' "
End If
If edate <> "" Then
  SQL = SQL & " AND refund.WriteDate <= '"& edate &"' "
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
  arrRefundInfo = rs.getRows()
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
        <th>종목</th>
        <th>환불금액</th>
        <th>예금주</th>
        <th>은행명</th>
        <th>계좌번호</th>
        <th>환불요청일시</th>
        <th>환불유무</th>
        <th>환불일</th>
      </tr>
    </thead>

    <tbody>
      <%
        If IsArray(arrRefundInfo) Then
          For i = 0 To Ubound(arrRefundInfo, 2)
            RefundIdx     = arrRefundINfo(2, i)
            TitleName     = arrRefundINfo(3, i)
            UserID        = arrRefundINfo(4, i)
            UserName      = arrRefundINfo(5, i)
            Sex           = arrRefundINfo(6, i)
            Birthday      = arrRefundINfo(7, i)
            Category      = arrRefundINfo(8, i)
            Rating        = arrRefundINfo(9, i)
            EventList     = arrRefundINfo(10, i)
            UserPhone     = arrRefundINfo(11, i)
            TR_AMT        = arrRefundINfo(12, i)
            AccountName   = arrRefundINfo(13, i)
            AccountBank   = arrRefundINfo(14, i)
            AccountNumber = arrRefundINfo(15, i)
            RefundYN      = arrRefundINfo(16, i)
            PaymentIdx    = arrRefundINfo(17, i)
            refundDate    = arrRefundINfo(18, i) ' 활불일
            WriteDate     = arrRefundINfo(19, i) ' 환불요청일
            %>
            <tr id="refund<%=refundIdx%>" data-payment-idx="<%=PaymentIdx%>" >
              <td><%=RefundIdx%></td>
              <td><%=TitleName%></td>
              <td><%=UserID%></td>
              <td><%=UserName%></td>
              <td><%=Sex%></td>
              <td><%=Birthday%></td>
              <td><%=UserPhone%></td>
              <td><%=Category%></td>
              <td><%=Rating%></td>
              <td><%=EventList%></td>
              <td><%=TR_AMT%></td>
              <td><%=AccountName%></td>
              <td><%=AccountBank%></td>
              <td><%=AccountNumber%></td>
              <td><%=WriteDate%></td>
              <td>
                <label class="switch" title="환불여부">
                  <input type="checkbox" data-open-state="<%=RefundYN%>" id="refundState<%=refundIdx%>" onclick="changeRefundState('<%=refundIdx%>', '<%=paymentIdx%>')" value="" <% If RefundYN = "Y" Then%>checked<% End If %>>
                  <span class="slider round"></span>
                </label>
              </td>
              <td>
                <% If RefundYN = "Y" Then %>
                  <%=refundDate%>
                <% End If %>
              </td>
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
