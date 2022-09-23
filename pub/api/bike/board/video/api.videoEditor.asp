<%
Dim urlCnt, seq
Set db = new clsDBHelper

'종목 대회선택 옵션 리스트 불러오기
SQL = "SELECT gameyear FROM sd_bikeTitle WHERE delYN = 'N' GROUP BY gameyear ORDER BY gameyear DESC"
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

If Not rs.EOF Then
    arrY = rs.GetRows()
End If

If GY = "" Then
    GY = year(date)
End if

SQL = "SELECT titleIDX,gameTitleName FROM sd_bikeTitle WHERE delYN = 'N' AND gameyear = '"&GY&"' ORDER BY titleidx DESC"
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

If Not rs.EOF Then
    arrT = rs.GetRows()
End If


'등록/수정 구분
If hasown(oJSONoutput, "MODE") = "ok" Then
    MODE = chkStrRpl(oJSONoutput.MODE,"")
    If MODE = "write" Then
        urlCnt = 1
    ElseIf MODE = "edit" Then
        seq = chkStrRpl(oJSONoutput.SEQ,"") '게시글 seq
        urlCnt = chkStrRpl(oJSONoutput.URLCNT,"") '비디오 url숫자
    End If
End If

' 수정모드일때 데이터 불러오기
If MODE = "edit" Then
  '대회, 부, 제목 불러오기
  SQL = " SELECT seq, titleIDX, title, levelno from sd_bikeBoard WHERE seq = "& seq &" "
  Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)
  seq = rs("seq")
  tidx = rs("titleIDX")
  levelno = rs("levelno")
  btitle = rs("title")

  '영상 url 불러오기
  SQL = " SELECT idx, filename AS url FROM sd_bikeBoard_c WHERE seq = "& seq &" "
  Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)
  If Not rs.eof Then
    arrUrl = rs.getrows()
  End If

  '부 목록 불러오기
  SQL = "SELECT levelIDX,detailtitle,sex,booNM FROM sd_bikeLevel WHERE delYN = 'N' AND titleIDX = '"& tidx &"' ORDER BY sex, booNM"
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
  If Not rs.EOF Then
  	arrB = rs.GetRows()
  End If

End IF

db.dispose

%>

<form method="post"  name="eform">
<input type="hidden" name="tid" id="tid" value="<%=tid%>">
<input type="hidden" name="p" id="p">
<input type="hidden" name="urlCnt" id="urlCnt" value = <%=urlCnt%>>

<!-- S: player_video_write -->
<div class="player_video_write">
  <!-- S: box-shadow -->
  <div class="box-shadow">
    <!-- S: table-box -->
    <div class="table-box basic-write" id="writeVideo">
      <table cellspacing="0" cellpadding="0">
        <tr>
          <th>대회명</th>
          <td id="wyear">
            <select name = "sgameYear" id="sgameYear"  class="sl_search w_50" onchange="mx.selectYear('B');">
            <%
            If IsArray(arrY) Then
                For ar = LBound(arrY, 2) To UBound(arrY, 2)
                    s_gameyear = arrY(0, ar)
                    %><option value="<%=s_gameyear%>" <%If CStr(GY) = s_gameyear then%>selected<%End if%>><%=s_gameyear%></option><%
                i = i + 1
                Next
            End if
            %>
            </select>
            <select name="sgametitle"  id="sgametitle"  class="sl_search" onchange="mx.SelectTitle('B')">
              <option value="">대회선택</option>
              <%
              If IsArray(arrT) Then
                  For ar = LBound(arrT, 2) To UBound(arrT, 2)
                      gtitleIDX = arrT(0, ar)
                      gtitleName = arrT(1, ar)
                      %><option value="<%=gtitleIDX%>" <%If CStr(gtitleIDX) = CStr(tidx) then%>selected<%End if%>><%=gtitleName%></option><%
                  i = i + 1
                  Next
              End if
              %>
            </select>
          </td>
        </tr>
        <tr>
          <th>종목</th>
          <td id="wlevel">
              <select name="slevelno" id="slevelno"  class="sl_search">
                <option value="">=종목선택=</option>
                <%
                If IsArray(arrB) Then
                    %><option value="0">연습시간</option><%
                    For ar = LBound(arrB, 2) To UBound(arrB, 2)
                        glevelno = arrB(0, ar)
                        gsubtitle = arrB(1, ar)
                        gbooNM = arrB(2, ar)
                        %><option value="<%=glevelno%>" <%If CStr(glevelno) = CStr(levelno) then%>selected<%End if%>><%=gsubtitle%>[<%=gbooNM%>] </option><%
                    i = i + 1
                    Next
                End if
                %>
              </select>
          </td>
        </tr>
        <tr>
          <th>제목</th>
          <td>
              <input type="text" id="btitle" placeholder="제목을 입력하세요" <% If Mode = "edit" Then %> value="<%=btitle%>" <% End If %> class="in-style-1">
          </td>
        </tr>
        <!-- S:수정모드일때 -->
        <% If MODE = "edit" Then %>
        <tr>
            <th>URL입력</th>
            <td style="background:#f0f0f0;">
                <input type="text" id="urlInputForm" placeholder="URL 주소를 입력 해주세요." class="in-style-1">
                <a href="#" class="blue-btn view-btn" onclick="mx.previewVideo($(this));">영상미리보기</a>
                <a href="#" class="icon-btn">
                  <i class="fas fa-plus-circle" onclick="mx.addVideo(<%=seq%>);"></i>
                </a>
            </td>
        </tr>
        <% End If %>
        <%
        If IsArray(arrUrl) Then
            For ar = LBound(arrUrl, 2) To UBound(arrUrl, 2)
                cIDX = arrUrl(0, ar)
                url = arrUrl(1, ar)
                %><!-- #include virtual = "/pub/html/bike/board/video/urlform.asp" --><%
            i = i + 1
            Next
        %>
        <!-- E:수정모드일때 -->
        <% Else %>
        <!-- #include virtual = "/pub/html/bike/board/video/urlform.asp" -->
        <% End If %>
        <tr>
          <th>영상미리보기</th>
          <td id="previewVideo">
            <iframe id="ytbFrame" src="" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>
          </td>
        </tr>
      </table>
    </div>
    <!-- E: table-box -->
  </div>
  <!-- E: box-shadow -->
  <!-- S: bt-btn-box -->
  <div class="bt-btn-box txt-right">
    <a href="/board/video.asp" class="white-btn">취소</a>
    <% If Mode = "edit" Then %>
    <a href="javascript:mx.editVideo(<%=seq%>);" class="blue-btn">수정</a>
    <% ElseIf Mode = "write" Then %>
    <a href="javascript:mx.writeVideo();" class="blue-btn">등록</a>
    <% End If %>
  </div>
  <!-- E: bt-btn-box -->
</div>
<!-- E: player_video_write -->

</form>
