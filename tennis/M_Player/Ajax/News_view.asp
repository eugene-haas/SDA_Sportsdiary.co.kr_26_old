<!--#include file="../Library/ajax_config.asp"-->
<%

  'iSubType = fInject(Request("iSubType"))
  'iSearchText = fInject(Request("iSearchText"))
  'iSearchCol = fInject(Request("iSearchCol"))
  'iNoticeYN = fInject(Request("iNoticeYN"))
  '
  '' 칼람개설 페이징 번호
  'iPageCnt = fInject(Request("iPageCnt"))
  '
  'If Len(iPageCnt) = 0 Then
  '  iPageCnt = "1"
  'End If
  '
  'iDivision = fInject(Request("iDivision"))
  '
  'iSearchCol1 = fInject(Request("iSearchCol1")) ' S2Y : 최신순, S2C : 많이본순
  '
  'ieSearchCol2 = fInject(Request("iSearchCol2")) ' ColumnistIDX
  'iSearchCol2 = decode(ieSearchCol2,0)
  '
  'Dim NowPage, iType

  'NowPage = fInject(Request("i2"))  ' 현재페이지
  'iType = fInject(Request("iType"))  ' 글쓰기 1, 수정 2
  '
  'Name = fInject(Request.cookies(SportsGb)("UserName"))
  ''Name = Request.Cookies("UserName")
  '
  'iLoginID = decode(fInject(Request.cookies(SportsGb)("UserID")),0)
  ''iLoginID = Request.Cookies("UserID")
  ''iLoginID = decode(iLoginID,0)
  '
  '' 뷰 관련
  'Dim LCnt, iMSeq, MSeq, Subject, Contents, InsDateCv, FileYN, FileCnt, LoginIDYN
  'LCnt = 0
  '
  '' 뷰에 해당하는 첨부파일 관련
  'Dim  LCnt1, PSeq1, FileName1, FilePath1, ReplyYN
  'LCnt1 = 0
  '
  ''response.Write "iType="&iType&"<br>"
  ''response.End
  '
  'IF iType = "2" Then

    NowPage = "1"

    iMSeq = fInject(Request("i1"))
    MSeq = decode(iMSeq,0)

    LSQL = "EXEC SD_Tennis.dbo.Community_Board_R '" & NowPage & "','" & MSeq & "','" & iLoginID & "'"
    'response.Write "LSQL="&LSQL&"<br>"
    'response.End

    SET LRs = DBCon3.Execute(LSQL)

    IF Not (LRs.Eof Or LRs.Bof) Then

      Subject = LRs("Subject")
      Name = LRs("Name")
      SubTypeName = LRs("SubTypeName")
      SubType = LRs("SubType")
      Source = LRs("Source")
      rDivision = LRs("Division")
      iContents = LRs("Contents")
      ViewCnt = LRs("ViewCnt")
      ReplyYN = LRs("ReplyYN")
      NoticeYN = LRs("NoticeYN")
      InsDateCv = LRs("InsDateCv")
      FileYN = LRs("FileYN")
      FileCnt = LRs("FileCnt")
      LoginIDYN = LRs("LoginIDYN")
      Link = LRs("Link")

    Else

      response.write "<script>"
      response.write "  alert('일치하는 정보가 없습니다.');"
      response.write "  history.back();"
      response.write "</script>"
      response.end

    End IF

    LRs.close

    ' 디버깅 모드로 수정 해서 강제로 접근할 경우 체크, 로그인 체크 없음.
    'If LoginIDYN = "N" Then
    '
    '  response.Write "<script type='text/javascript'>alert('잘못된 접근 입니다.');location.href='/';</script>"
    '  'response.Write "<script type='text/javascript'>alert('글 등록이 잘 됐습니다.');</script>"
    '  response.End
    '
    'End If

    ' 이미지게시판은 없음
    'IF FileCnt <> "0" Then
    '
    ' LCnt1 = 0
    ' FileSize = ""
    '
    ' LSQL = "EXEC SD_Tennis.dbo.Community_Board_Pds_R '" & MSeq & "'"
    ' 'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
    ' 'response.End
    '
    ' SET LRs = DBCon3.Execute(LSQL)
    ' IF Not (LRs.Eof Or LRs.Bof) Then
    '   Do Until LRs.Eof
    '
    '     LCnt1 = LCnt1 + 1
    '     PSeq1 = PSeq1&"^"&LRs("PSeq")&""
    '     FileSize1 = FileSize1&"^"&iFileSize(LRs("FileName"))&""
    '     FileName1 = FileName1&"^"&LRs("FileName")&""
    '     FilePath1 = FilePath1&"^"&LRs("FilePath")&""
    '
    '     LRs.MoveNext
    '   Loop
    '
    ' End IF
    ' LRs.close
    '
    'End IF

  'End IF
%>

<div class="sd-board-view-box-C">
  <p class="title"><%=Subject %></p>
  <ul class="additional">
    <li class="additional-item">
      <span class="additional-label-dateCreated">기사입력일</span><span class="additional-dateCreated"><%=InsDateCv %></span>
    </li>
    <li class="additional-item">
      <span class="additional-label-writer">작성자</span><span class="additional-writer"><%=Name%></span>
    </li>
    <% if Source <> "" then %>
    <li class="additional-item">
      <span class="additional-label-source">출처</span><span class="additional-source"><%=Source %></span>
    </li>
    <% end if %>
    <% if ViewCnt <> "" then %>
    <li class="additional-item">
      <span class="additional-label-viewCount">조회수</span><span class="additional-viewCount"><%=ViewCnt %></span>
    </li>
     <% end if %>
  </ul>

  <%
    IF rDivision = "3" Then
  %>
  <div class="con_txt">

    <!-- editor content -->
    <iframe width="100%" height="191" src="https://www.youtube.com/embed/<%=Link%>" frameborder="0" gesture="media" allow="encrypted-media" allowfullscreen></iframe>

    <%=iContents %>
    <!-- editor content -->

  </div>
  <% else %>
  <div class="con_txt">

    <!-- editor content -->
    <%=iContents %>
    <!-- editor content -->

  </div>
  <%
    End IF
  %>

</div>
