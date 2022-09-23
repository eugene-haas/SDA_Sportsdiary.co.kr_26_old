<!-- #include virtual = "/pub/header.bike.asp" -->
<!-- #include virtual = "/library/fn.bike.asp" -->

<%
SET db = Server.CreateObject("ADODB.Connection")
    db.CommandTimeout = 1000
    db.Open B_ConStr
req = request("req")
If req <> "" Then
  Set oJSONoutput = JSON.Parse(req)
  rsTitleIdx = oJSONoutput.get("titleIdx")
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
    <select id="gametitleidx" class="form-control">
      <option value="">전체</option>
      <%
        If IsArray(arrTitle) Then
          For t =  0 To Ubound(arrTitle, 2)
            titleIdx = arrTitle(0, t)
            titleName = arrTitle(1, t)
            %>
            <option value="<%=titleIdx%>" <% If Cdbl(rsTitleIdx) = Cdbl(titleIdx) Then %>selected<% End If %>><%=titleName%></option>
            <%
          Next
        End If
      %>

    </select>
  </div>

  <div class="col-sm-2">
    <span class="input-group-btn">
      <a class="btn btn-primary" onclick="busSearch();">검색</a>
    </span>
  </div>

</div>

<form name="frm" id="frm"><input type="hidden" name="req" id="req"></form>
