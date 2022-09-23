<!-- #include virtual = "/pub/header.bike.asp" -->
<!-- #include virtual = "/library/fn.bike.asp" -->

<%
SET db = Server.CreateObject("ADODB.Connection")
    db.CommandTimeout = 1000
    db.Open B_ConStr
req = request("req")
If req <> "" Then
  Set oJSONoutput = JSON.Parse(req)
  titleIdx        = oJSONoutput.get("titleIdx")
Else
  Set oJSONoutput = JSON.Parse("{}")
  titleIdx = request("titleIdx")
End If

If titleIdx = "" Then
  Response.End
End If

SQL =       " SELECT EventIdx, GroupType, Gender, CourseLength, EventDetailType, RatingCategory  "
SQL = SQL & " FROM tblBikeEventlist  "
SQL = SQL & " WHERE TitleIdx = "& titleIdx &" And DelYN = 'N' "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  arrEvent = rs.getRows()
End If
%>

<div class="form-group">
  <div class="col-sm-1">
    <label class="control-label">Url</label>
  </div>
  <div class="col-sm-2">
    <input type="text" id="sContents" value="" class="form-control" placeholder="영상 url">
  </div>

  <div class="col-sm-1">
    <label class="control-label">영상제목</label>
  </div>
  <div class="col-sm-2">
    <input type="text" id="sContentsTitle" value="" class="form-control" placeholder="영상 제목">
  </div>

  <div class="col-sm-1">
    <label class="control-label">종목</label>
  </div>
  <div class="col-sm-2">
    <select class="form-control" id="sEventIdx">
      <option value="">=종목선택=</option>
      <%
        If IsArray(arrEvent) Then
          For i = 0 To Ubound(arrEvent, 2)
            eventIdx        = arrEvent(0, i)
            groupType       = arrEvent(1, i)
            gender          = arrEvent(2, i)
            courseLength    = arrEvent(3, i)
            eventDetailType = arrEvent(4, i)
            ratingCategory  = arrEvent(5, i)
            %>
            <option value="<%=eventIdx%>"><%=gender%>/<%=groupType%>/<%=eventDetailType%>(<%=ratingCategory%>)</option>
            <%
          Next
        End If

      %>
    </select>
  </div>

  <div class="btn-group pull-right" role="group" aria-label="...">
    <a href="#" class="btn btn-green" id="" onclick="searchVideo()" accesskey="i" style="margin-right:20px;">검색<span>(S)</span></a>
  </div>
</div>
