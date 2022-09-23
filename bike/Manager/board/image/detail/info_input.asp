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
  titleIdx        = oJSONoutput.get("titleIdx")
  imageIdx        = oJSONoutput.get("imageIdx")
Else
  Set oJSONoutput = JSON.Parse("{}")
  titleIdx = request("titleIdx")
End If

If titleIdx = "" Then
  Response.End
End If



If imageIdx <> "" Then
  SQL = " SELECT ImageIdx, OriginFile, ContentsTitle FROM tblBikeImage WHERE ImageIdx = "& imageIdx &" AND DelYN = 'N' "
  Set rs = db.Execute(SQL)
  If Not rs.eof Then
    selectedImageIdx = rs("ImageIdx")
    contentsFile     = rs("OriginFile")
    contentsFilePath = "http://upload.sportsdiary.co.kr/sportsdiary/" & GLOBAL_HOSTCODE & contentsFile
    contentsTitle    = rs("ContentsTitle")
  End If
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

  <div class="col-sm-2">
    <label class="control-label">이미지 제목</label>
  </div>
  <div class="col-sm-3">
    <input type="text" id="contentsTitle" value="<%=contentsTitle%>" class="form-control" placeholder="이미지 제목">
  </div>

  <div class="col-sm-2">
    <label class="control-label">이미지 업로드</label>
  </div>
  <div class="col-sm-2">
    <input type="file" id="uploadImage" files="<%=contentsFilePath%>">
  </div>

  <div class="col-sm-2">
    <label for="logoYN" class="control-label">이미지 로고삽입</label>
  </div>
  <div class="col-sm-1">
    <input type="checkbox" id="logoYN">
  </div>
</div>

<div class="form-group">
  <div class="col-sm-2">
    <label class="control-label">이미지 미리보기</label>
  </div>
  <div class="col-sm-3" style="height:200px;overflow:hidden;">
    <img id="imagePreview" src="<%=contentsFilePath%>" alt="" style="width:200px;"/>
  </div>


</div>

<div class="btn-group pull-right" role="group" aria-label="...">
  <a href="#" class="btn btn-primary" id="" onclick="uploadImage('insert', <%=titleIdx%>)" accesskey="i">등록<span>(I)</span></a>
  <a href="#" class="btn btn-primary" id="" onclick="uploadImage('update', <%=titleIdx%>, <%=selectedImageIdx%>)" accesskey="e">수정<span>(E)</span></a>
  <a href="#" class="btn btn-danger"  id="" onclick="deleteImage(<%=titleIdx%>, <%=selectedImageIdx%>)" accesskey="r">삭제<span>(R)</span></a>
</div>
