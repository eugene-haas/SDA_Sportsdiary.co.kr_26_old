<!-- #include virtual = "/pub/header.bike.asp" -->
<!-- #include virtual = "/library/fn.bike.asp" -->

<%
SET db = Server.CreateObject("ADODB.Connection")
    db.CommandTimeout = 1000
    db.Open B_ConStr
req = request("req")
If req <> "" Then
  Set oJSONoutput = JSON.Parse(req)
  titleIdx = oJSONoutput.titleIdx

End If


SQL = " SELECT TitleIdx, TitleName FROM tblBikeTitle WHERE DelYN = 'N' AND HostIdx = 1 "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  arrTitle = rs.getRows()
End If
%>

<div class="form-group">

  <div class="col-sm-1">
    <label class="control-label">대회</label>
  </div>
  <div class="col-sm-2">
    <select id="title" class="form-control">
      <option value="">전체</option>
      <%
        If IsArray(arrTitle) Then
          For t =  0 To Ubound(arrTitle, 2)
            titleIdx = arrTitle(0, t)
            titleName = arrTitle(1, t)
            %>
            <option value="<%=titleIdx%>"><%=titleName%></option>
            <%
          Next
        End If
      %>

    </select>
  </div>

  <div class="col-sm-1">
    <label class="control-label">환불여부</label>
  </div>
  <div class="col-sm-2">
    <select id="refundYN" class="form-control">
      <option value="">전체</option>
      <option value="Y">Y</option>
      <option value="N">N</option>
    </select>
  </div>

  <div class="col-sm-1">
    <label class="control-label">환불요청일</label>
  </div>
  <div class="col-sm-2">
    <div class="input-group [ _date ]">
      <input type="text" class="form-control" placeholder="시작날짜" id="sdate" value="">
      <span class="input-group-addon">
        <span class="glyphicon glyphicon-calendar"></span>
      </span>
    </div>
  </div>
  <div class="col-sm-2">
    <div class="input-group [ _date ]">
      <input type="text" class="form-control" placeholder="끝날짜" id="edate" value="">
      <span class="input-group-addon">
        <span class="glyphicon glyphicon-calendar"></span>
      </span>
    </div>
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
    <div class="input-group">
      <input type="text" class="form-control" placeholder="" id="searchText" value="">
      <span class="input-group-btn">
        <a class="btn btn-primary" onclick="searchRefundList();">검색</a>
      </span>
    </div>
  </div>
</div>
