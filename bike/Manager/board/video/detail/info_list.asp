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
  sContents       = oJSONoutput.get("sContents")
  sContentsTitle  = oJSONoutput.get("sContentsTitle")
  sEventIdx       = oJSONoutput.get("sEventIdx")
Else
  Set oJSONoutput = JSON.Parse("{}")
  titleIdx = request("titleIdx")
  oJSONoutput.set("titleIdx"), titleIdx
End If

If Session("titleIdx") <> "" Then
  titleIdx = Session("titleIdx")
End If

' S:페이징 설정값
If PN = "" Then
  PN = 1
End If
pageSize = 10
blockSize = 10
' E:페이징 설정값

' titleIdx = 1
SQL =       " SELECT * FROM ( "
SQL = SQL & " SELECT TOP 100 PERCENT ROW_NUMBER() OVER(ORDER BY VideoIdx DESC) RowNum, * FROM ( "
SQL = SQL & " SELECT COUNT(*) OVER(PARTITION BY 1) TotalCount "
SQL = SQL &  " , video.VideoIdx, title.TitleName, video.contents, video.ContentsTitle, video.ContentsThumbnail "
SQL = SQL &  " , event.EventDetailType, video.ViewCount, video.OpenYN, event.RatingCategory, video.WriteDate  "
SQL = SQL &  " FROM tblBikeVideo video "
SQL = SQL &  " INNER JOIN tblBikeTitle title ON video.TitleIdx = title.TitleIdx "
SQL = SQL &  " INNER JOIN tblBikeEventList event ON video.EventIdx = event.EventIdx "
SQL = SQL &  " WHERE video.DelYN = 'N' "
SQL = SQL &  " AND video.TitleIdx = "& titleIdx &" "
If sContents <> "" Then
  SQL = SQL & " AND video.Contents LIKE '%"& sContents &"%' "
End If
If sContentsTitle <> "" Then
  SQL = SQL & " AND video.ContentsTitle LIKE '%"& sContentsTitle &"%' "
End If
If sEventIdx <> "" Then
  SQL = SQL & " AND video.EventIdx = "& sEventIdx &" "
End If

SQL = SQL & " ) T1 "
SQL = SQL & " ORDER BY VideoIdx DESC "
SQL = SQL & " ) T2 "
SQL = SQL & " WHERE RowNum BetWeen "& ((PN - 1) * pageSize) + 1 &" AND "& PN * pageSize &" "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  totalCount = rs("TotalCount")
  arrVideo = rs.getRows()

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
        <th>URL</th>
        <th>영상제목</th>
        <th>종목</th>
        <th>등급</th>
        <th>조회수</th>
        <th>공개/비공개</th>
        <th>유튜브에서보기</th>
      </tr>
    </thead>

    <tbody>
      <%
        If IsArray(arrVideo) Then
          For i = 0 To Ubound(arrVideo, 2)
            videoIdx           = arrVideo(2, i)
            titleName          = arrVideo(3, i)
            url                = arrVideo(4, i)
            contentsTitle      = arrVideo(5, i)
            contentsThumbnail  = arrVideo(6, i)
            eventDetailType    = arrVideo(7, i)
            viewCount          = arrVideo(8, i)
            openYN             = arrVideo(9, i)
            ratingCategory     = arrVideo(10, i)
            %>
            <tr class="title_row" onclick="selectVideo(<%=videoIdx%>, <%=titleIdx%>, $(this))">
              <td><span><%=videoIdx%></span></td>
              <td><span><%=titleName%></span></td>
              <td><span><%=url%></span></td>
              <td><span><%=contentsTitle%></span></td>
              <td><span><%=eventDetailType%></span></td>
              <td><span><%=ratingCategory%></span></td>
              <td><span><%=viewCount%></span></td>
              <td>
                <span>
                  <label class="switch" title="">
                    <input type="checkbox" data-open-state="<%=openYN%>" onclick="changeVideoState(<%=videoIdx%>)" id="openState<%=videoIdx%>" <% If openYN = "Y" Then %>checked<% End If %>>
                    <span class="slider round"></span>
                  </label>
                </span>
              </td>
              <td><a href="https://www.youtube.com/watch?v=<%=url%>" class="btn btn-primary" target="_blank">보기</a></td>
            </tr>
            <%
          Next
        End IF
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


<%
Session("titleIdx") = ""

%>
