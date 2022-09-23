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
Else
  Set oJSONoutput = JSON.Parse("{}")
  titleIdx = request("titleIdx")
  PN = request("PN")
  oJSONoutput.set("titleIdx"), titleIdx
End If

If Session("titleIdx") <> "" Then
  titleIdx = Session("titleIdx")
End If

If titleIdx = "" Then
  titleIdx = request("titleIdx")
End If

' S:페이징 설정값
If PN = "" Then
  PN = 1
End If
pageSize = 10
blockSize = 10
' E:페이징 설정값

SQL =       " SELECT * FROM ( "
SQL = SQL & " SELECT TOP 100 PERCENT ROW_NUMBER() OVER(ORDER BY ImageIdx DESC) RowNum, * FROM ( "
SQL = SQL & " SELECT COUNT(*) OVER(PARTITION BY 1) TotalCount "
SQL = SQL &  " , image.ImageIdx, title.TitleName, image.OriginFile, image.ContentsTitle, image.Thumbnail "
SQL = SQL &  " , image.ViewCount, image.OpenYN, image.WriteDate  "
SQL = SQL &  " FROM tblBikeImage image "
SQL = SQL &  " INNER JOIN tblBikeTitle title ON image.TitleIdx = title.TitleIdx "
SQL = SQL &  " WHERE image.DelYN = 'N' "
SQL = SQL &  " AND image.TitleIdx = "& titleIdx &" "

SQL = SQL & " ) T1 "
SQL = SQL & " ORDER BY ImageIdx DESC "
SQL = SQL & " ) T2 "
SQL = SQL & " WHERE RowNum BetWeen "& ((PN - 1) * pageSize) + 1 &" AND "& PN * pageSize &" "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  totalCount = rs("TotalCount")
  arrImage = rs.getRows()
End If
%>


<div class="btn-toolbar" role="toolbar" aria-label="btns">
  <a href="#" class="btn btn-link"><span>전체 : <%=TotalCount%> 건</span></a>
</div>


<div class="table-responsive">
  <table cellspacing="0" cellpadding="0" class="table table-hover">
    <thead>
      <tr>
        <th>번호</th>
        <th>대회명</th>
        <th>파일</th>
        <th>이미지 제목</th>
        <th>조회수</th>
        <th>공개/비공개</th>
      </tr>
    </thead>

    <tbody id="imageList">
      <%
        If IsArray(arrImage) Then
          For i = 0 To Ubound(arrImage, 2)
            imageIdx      = arrImage(2, i)
            titleName     = arrImage(3, i)
            originFile    = arrImage(4, i)
            contentsTitle = arrImage(5, i)
            thumbnail     = arrImage(6, i)
            viewCount     = arrImage(7, i)
            openYN        = arrImage(8, i)
            writeDate     = arrImage(9, i)
            %>
            <!-- <tr class="title_row" onclick="selectImage(<%=imageIdx%>, <%=titleIdx%>, $(this))"> -->
            <tr class="title_row" data-image-idx="<%=imageIdx%>" data-title-idx="<%=titleIdx%>">
              <td><span><%=imageIdx%></span></td>
              <td><span><%=titleName%></span></td>
              <td><span><%=originFile%></span></td>
              <td><span><%=contentsTitle%></span></td>
              <td><span><%=viewCount%></span></td>
              <td data-switch="Y">
                <span>
                  <label class="switch" title="">
                    <input type="checkbox" data-open-state="<%=openYN%>" onclick="changeImageState(<%=titleIdx%>,<%=imageIdx%>)" id="openState<%=imageIdx%>" <% If openYN = "Y" Then %>checked<% End If %>>
                    <span class="slider round"></span>
                  </label>
                </span>
              </td>
            </tr>
            <%
          Next
        End IF
      %>
    </tbody>
  </table>
</div>


<nav>
  <div class="container-fluid text-center" id="paging" data-current-page=<%=PN%>>
    <%
      tPage = totalPage(totalCount, pageSize)
      jsonStr = JSON.Stringify(oJSONoutput)
      Call bikeAdminPaging(tPage, blockSize, PN, "goPN", jsonStr, "info_list.asp", "infoList")
    %>
  </div>
</nav>


<%
Session("titleIdx") = ""
%>
