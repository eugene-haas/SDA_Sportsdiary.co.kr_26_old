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
  selectedYear    = oJSONoutput.get("selectedYear")
Else
  Set oJSONoutput = JSON.Parse("{}")
End If

SQL = " SELECT CONVERT(VARCHAR(4), StartDate , 121) FROM tblBiketitle WHERE DelYN = 'N' GROUP BY CONVERT(VARCHAR(4), StartDate , 121) "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  arrTitleYear = rs.getRows()
End If

If selectedYear <> "" Then
  SQL = " SELECT TitleIdx, TitleName FROM tblBikeTitle WHERE DelYN = 'N' AND CONVERT(VARCHAR(4), StartDate, 121) = '"& selectedYear &"' "
  Set rs = db.Execute(SQL)
  If Not rs.eof Then
    arrTitleName = rs.getRows()
  End If
End If


%>

<div class="form-group">

  <div class="col-sm-2">
    <select id="titleYear" class="form-control" onchange="selectTitleYear()">
      <option value="">=년도선택=</option>
      <%
        If IsArray(arrTitleYear) Then
          For i = 0 To Ubound(arrTitleYear, 2)
            titleYear = arrTitleYear(0, i)
            %>
              <option value="<%=titleYear%>" <% If selectedYear = titleYear Then%>selected<% End If %>><%=titleYear%></option>
            <%
          Next
        End If
      %>
    </select>
  </div>

  <%
    If IsArray(arrTitleName) Then
    %>
    <div class="col-sm-3">
      <select id="titleList" class="form-control">
        <option value="">=대회선택=</option>
        <%
          For i = 0 To Ubound(arrTitleName, 2)
            titleIdx  = arrTitleName(0, i)
            titleName = arrTitleName(1, i)
            %>
              <option value="<%=titleIdx%>"><%=titleName%></option>
            <%
          Next
        %>
      </select>
    </div>
    <%
    Else
    %>
    <div class="col-sm-3">
      <select id="" class="form-control">
        <option value="">년도를 선택해주세요</option>
      </select>
    </div>
    <%
    End If
  %>


  <div class="col-sm-1">
    <a class="btn btn-green" onclick="searchTitle();">대회검색</a>
  </div>
</div>
