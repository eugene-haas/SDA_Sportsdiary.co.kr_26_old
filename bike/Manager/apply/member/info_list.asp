<!-- #include virtual = "/pub/header.bike.asp" -->
<!-- #include virtual = "/library/fn.bike.asp" -->

<%
' 참가최종 리스트 (가상계좌 받기 이상 진행한 사람 리스트)
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
SQL = SQL & "      , main.MemberInfoIdx, main.MemberIdx, title.TitleName, member.UserID, member.UserName, member.UserPhone, member.Sex, member.Birthday  "
SQL = SQL & "      , scrp.Category, scrp.Rating, event.ApplyList, gift.GiftName, gift.GiftOption "
SQL = SQL & "      , parent.ParentName, parent.ParentPhone, parent.Relation, parent.AgreeYN, title.ApplyStart, main.WriteDate "
SQL = SQL & " FROM tblBikeApplyMemberInfo main "
SQL = SQL & " INNER JOIN tblBikeTitle title ON main.TitleIdx = title.TitleIdx "
SQL = SQL & " INNER JOIN tblBikeParentInfo parent ON main.MemberIdx = parent.MemberIdx AND main.TitleIdx = parent.TitleIdx "
SQL = SQL & " INNER JOIN tblBikeGiftSelect gs ON main.MemberIdx = gs.MemberIdx AND main.TitleIdx = gs.TitleIdx "
SQL = SQL & " INNER JOIN tblBikeGift gift ON gs.GiftIdx = gift.GiftIdx "
SQL = SQL & " INNER JOIN SD_Member.dbo.tblMember member ON main.MemberIdx = member.MemberIDX "
SQL = SQL & " INNER JOIN (SELECT DISTINCT SCRPRatingIdx, Category, Rating FROM tblBikeSCRP) scrp ON main.SCRP = scrp.SCRPRatingIdx "
SQL = SQL & " INNER JOIN (SELECT DISTINCT el.TitleIdx, ap.MemberIdx "
SQL = SQL & " 		                  		, STUFF(( "
SQL = SQL & " 		                  				  SELECT ',' + b.EventDetailType "
SQL = SQL & " 		                  				  FROM tblBikeEventApplyInfo a "
SQL = SQL & " 		                  				  LEFT JOIN tblBikeEventList b ON a.EventIdx = b.EventIdx "
SQL = SQL & " 		                  				  LEFT JOIN tblBikePayment c ON a.PaymentIdx = c.PaymentIdx"
SQL = SQL & " 		                  				  WHERE a.MemberIdx = ap.MemberIdx "
SQL = SQL & " 		                  				  AND b.TitleIdx = el.TitleIdx "
SQL = SQL & " 		                  				  AND a.DelYN = 'N'	"
SQL = SQL & " 		                  				  AND (c.PaymentState = 1) "
SQL = SQL & " 		                  				  FOR XML PATH('') "
SQL = SQL & " 		                  		   ),1,1,'') ApplyList "
SQL = SQL & " 		        FROM tblBikeEventApplyInfo ap "
SQL = SQL & " 		        LEFT JOIN tblBikeEventList el ON ap.EventIdx = el.EventIdx "
SQL = SQL & " 		        WHERE ap.DelYN = 'N' "
SQL = SQL & " 		        GROUP BY TitleIdx, MemberIdx "
SQL = SQL & " 		        ) event ON main.MemberIdx = event.MemberIdx AND main.TitleIdx = event.TitleIdx "
SQL = SQL & " WHERE event.ApplyList IS NOT NULL "

If titleIdx <> "" Then
  SQL = SQL & " AND title.TitleIdx = "& titleIdx &" "
End If
If gender <> "" AND gender <> "전체" Then
  If gender = "남자" Then
    sex = "Man"
  ElseIf gender = "여자" Then
    sex = "WoMan"
  End If
  SQL = SQL & " AND member.Sex = '"& sex &"' "
End If
If playerType <> "" Then
  SQL = SQL & " AND title.Type = '"& playerType &"' "
End If

If sdate <> "" Then
  SQL = SQL & " AND main.WriteDate <= "& sdate &" "
End If
If edate <> "" Then
  SQL = SQL & " AND main.WriteDate >= "& sdate &" "
End If

If searchType <> "" AND searchText <> "" Then
  Select Case searchType
    Case "userId"   SQL = SQL & " AND member.UserId = '"& searchText &"' "
    Case "userName" SQL = SQL & " AND member.UserName = '"& searchText &"' "
  End Select
End If

If ratingCategory <> "" Then
  SQL = SQL & " AND scrp.Category = '"& ratingCategory &"' "
End If


SQL = SQL & " ) T1 "
SQL = SQL & " ORDER BY WriteDate DESC "
SQL = SQL & " ) T2 "
SQL = SQL & " WHERE RowNum BetWeen "& ((PN - 1) * pageSize) + 1 &" AND "& PN * pageSize &" "

Set rs = db.Execute(SQL)
If Not rs.eof Then
  totalCount  = rs(1)
  arrApplyMember = rs.getRows()
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
        <th>연락처</th>
        <th>성별</th>
        <th>생년월일</th>
        <th>부서</th>
        <th>등급</th>
        <th>참가종목</th>
        <th>의류</th>
        <th>미성년여부</th>
        <th>보호자명</th>
        <th>보호자연락처</th>
        <th>보호자관계</th>
      </tr>
    </thead>

    <tbody>
      <%
        If IsArray(arrApplyMember) Then
          For i = 0 To Ubound(arrApplyMember, 2)
            MemberInfoIdx = arrApplyMember(2, i)
            MemberIdx     = arrApplyMember(3, i)
            TitleName     = arrApplyMember(4, i)
            UserID        = arrApplyMember(5, i)
            UserName      = arrApplyMember(6, i)
            UserPhone     = arrApplyMember(7, i)
            Sex           = arrApplyMember(8, i)
            Birthday      = arrApplyMember(9, i)
            Category      = arrApplyMember(10, i)
            Rating        = arrApplyMember(11, i)
            ApplyList     = arrApplyMember(12, i)
            GiftName      = arrApplyMember(13, i)
            GiftOption    = arrApplyMember(14, i)
            ParentName    = arrApplyMember(15, i)
            ParentPhone   = arrApplyMember(16, i)
            Relation      = arrApplyMember(17, i)
            AgreeYN       = arrApplyMember(18, i)
            ApplyStart    = arrApplyMember(19, i)
            AdultYN = GetAdultYN(Birthday, ApplyStart)
            If AdultYN = "Y" Then
              AdultYNText = "성인"
            ElseIf AdultYN = "N" Then
              AdultYNText = "미성년"
            End If
            %>
            <tr>
              <td><%=MemberInfoIdx%></td>
              <td><%=TitleName%></td>
              <td><%=UserID%></td>
              <td><%=UserName%></td>
              <td><%=UserPhone%></td>
              <td><%=Sex%></td>
              <td><%=Birthday%></td>
              <td><%=Category%></td>
              <td><%=Rating%></td>
              <td><%=ApplyList%></td>
              <td><%=GiftOption%></td>
              <td><%=AdultYNText%></td>
              <td><%=ParentName%></td>
              <td><%=ParentPhone%></td>
              <td><%=Relation%></td>
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
