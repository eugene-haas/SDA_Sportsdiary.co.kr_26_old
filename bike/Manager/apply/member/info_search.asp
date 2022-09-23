<!-- #include virtual = "/pub/header.bike.asp" -->
<!-- #include virtual = "/library/fn.bike.asp" -->

<%
SET db = Server.CreateObject("ADODB.Connection")
    db.CommandTimeout = 1000
    db.Open B_ConStr
req = request("req")
If req <> "" Then

End If


SQL = " SELECT TitleIdx, TitleName FROM tblBikeTitle WHERE HostIdx = 1 AND DelYN = 'N' "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  arrTitle = rs.getRows()
End If

SQL = " SELECT Type, Code FROM tblBikeEventCode WHERE Type = 'RatingCategory' "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  arrRatingCategory = rs.getRows()
End If

SQL = " SELECT Type, Code FROM tblBikeEventCode WHERE Type = 'Gender' "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  arrGender = rs.getRows()
End If


%>

<div class="form-group">

  <div class="col-sm-1">
    <label class="control-label">대회</label>
  </div>
  <div class="col-sm-2">
    <select id="title" class="form-control">
      <option value="">대회명을 선택하세용</option>
      <%
        If IsArray(arrTitle) Then
          For i = 0 To Ubound(arrTitle, 2)
            TitleIdx  = arrTitle(0, i)
            TitleName = arrTitle(1, i)
            %>
            <option value="<%=TitleIdx%>"><%=TitleName%></option>
            <%
          Next
        End If
      %>
    </select>
  </div>

  <div class="col-sm-1">
    <label class="control-label">성별</label>
  </div>
  <div class="col-sm-2">
    <select id="gender" class="form-control">
      <%
        If IsArray(arrGender) Then
          For i = 0 To Ubound(arrGender, 2)
            cType    = arrGender(0, i)
            Code     = arrGender(1, i)
            %>
              <option value="" data-c-type="<%=cType%>" data-code="<%=Code%>"><%=Code%></option>
            <%
          Next
        End If
      %>
    </select>
  </div>

  <div class="col-sm-1">
    <label class="control-label">부서</label>
  </div>
  <div class="col-sm-2">
    <select id="ratingCategory" class="form-control">
      <option value="" data-code="">전체</option>
      <%
        If IsArray(arrRatingCategory) Then
          For i = 0 To Ubound(arrRatingCategory, 2)
            cType    = arrRatingCategory(0, i)
            Code     = arrRatingCategory(1, i)
            %>
              <option value="" data-c-type="<%=cType%>" data-code="<%=Code%>"><%=Code%></option>
            <%
          Next
        End If
      %>
    </select>
  </div>

</div>


<div class="form-group">

  <div class="col-sm-1">
    <label class="control-label">검색</label>
  </div>
  <div class="col-sm-1">
    <select id="searchType" class="form-control">
      <option value="">=선택=</option>
      <option value="userName">이름</option>
      <option value="userId">id</option>
    </select>
  </div>

  <div class="col-sm-2">
    <div class="input-group [ _date ]">
      <input type="text" class="form-control" placeholder="" id="searchText" value="">
      <span class="input-group-btn">
        <a class="btn btn-primary" onclick="searchApplyMember();">검색</a>
      </span>
    </div>
  </div>

</div>
