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

%>

<div class="form-group">
  <div class="col-sm-1">
    <label class="control-label">이미지 제목</label>
  </div>
  <div class="col-sm-2">
    <input type="text" id="sContentsTitle" value="" class="form-control" placeholder="이미지 제목">
  </div>


  <div class="btn-group pull-right" role="group" aria-label="...">
    <a href="#" class="btn btn-green" id="" onclick="searchVideo()" accesskey="i" style="margin-right:20px;">검색<span>(S)</span></a>
  </div>
</div>
