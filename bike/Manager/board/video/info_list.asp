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
  selectedYear  = oJSONoutput.get("selectedYear")
  selectedTitle = oJSONoutput.get("selectedTitle")
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
SQL = SQL & " , title.TitleIdx, title.TitleName, title.WriteDate, ISNULL(vCount.Count, '') Count "
SQL = SQL & " FROM tblBikeTitle title "
SQL = SQL & " LEFT JOIN (SELECT TitleIdx, COUNT(TitleIdx) Count  "
SQL = SQL & " 			FROM tblBikeVideo  "
SQL = SQL & " 			GROUP BY TitleIdx) vCount ON title.TitleIdx = vCount.TitleIdx "
SQL = SQL & " WHERE title.DelYN = 'N' "

If selectedYear <> "" Then
  SQL = SQL & " AND title.StartDate > '"& selectedYear &"'  "
End If
If selectedTitle <> "" Then
  SQL = SQL & " AND title.TitleIdx = '"& selectedTitle &"'  "
End If

SQL = SQL & " ) T1 "
SQL = SQL & " ORDER BY WriteDate DESC "
SQL = SQL & " ) T2 "
SQL = SQL & " WHERE RowNum BetWeen "& ((PN - 1) * pageSize) + 1 &" AND "& PN * pageSize &" "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  totalCount = rs("TotalCount")
  arrTitle = rs.getRows()

End If
%>

<div class="btn-toolbar" role="toolbar" aria-label="btns">
  <a href="#" class="btn btn-link">전체 : <%=totalCount%> 건</a>

  <div class="btn-group pull-right">
    <a href="" id="" class="btn btn-default">앱노출</a>
    <a href="" id="" class="btn btn-primary">등록</a>
  </div>
</div>

<div class="table-responsive">
  <table cellspacing="0" cellpadding="0" class="table table-hover">
    <thead>
      <tr>
        <th>
          <div class="btn-group" data-toggle="buttons">
            <label class="btn btn-primary active">
              <input type="checkbox" autocomplete="off" checked>
              <span class="glyphicon glyphicon-ok"></span>
            </label>
          </div>
        </th>
        <th>대회명</th>
        <th>영상 등록수</th>
        <th>작성일</th>
        <th>보기</th>
      </tr>
    </thead>

    <tbody>
      <%
        If IsArray(arrTitle) Then
          For i = 0 To Ubound(arrTitle, 2)
            titleIdx  = arrTitle(2, i)
            titleName = arrTitle(3, i)
            writeDate = arrTitle(4, i)
            count     = arrTitle(5, i)
            %>
            <tr>
              <td>
                <span class="btn-group" data-toggle="buttons">
                  <label class="btn btn-primary active">
                    <input type="checkbox" autocomplete="off" checked>
                    <span class="glyphicon glyphicon-ok"></span>
                  </label>
                </span>
              </td>
              <td><span><%=titleName%></span></td>
              <td><span><%=count%></span></td>
              <td><span><%=writeDate%></span></td>
              <td><span><a href="detail/info.asp?titleIdx=<%=titleIdx%>" class="btn btn-default">상세보기</a></span></td>
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
    <ul class="pagination">
      <li class="prev"><a href="javascript:alert('첫 페이지 입니다.');">&lt;</a></li>
      <li class="active"><a href="javascript:;">1</a></li>
      <li class="next"><a href="javascript:alert('마지막 페이지 입니다.');">&gt;</a></li>
    </ul>
  </div>
</nav>
