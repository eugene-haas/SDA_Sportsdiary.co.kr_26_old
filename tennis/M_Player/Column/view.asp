<!-- #include file="../include/config.asp" -->

<%

  iSubType = fInject(Request("iSubType"))
  iSearchText = fInject(Request("iSearchText"))
  iSearchCol = fInject(Request("iSearchCol"))
  iNoticeYN = fInject(Request("iNoticeYN"))

  iDivision = fInject(Request("iDivision"))
  iSearchCol1 = fInject(Request("iSearchCol1"))

  ieSearchCol2 = fInject(Request("iSearchCol2")) ' ColumnistIDX
  iSearchCol2 = decode(ieSearchCol2,0)

  ' 칼람개설 페이징 번호
  iPageCnt = fInject(Request("iPageCnt"))

  If Len(iPageCnt) = 0 Then
    iPageCnt = "1"
  End If

  ' 칼람리스트 페이징 번호
  iSPageCnt = fInject(Request("iSPageCnt"))

  If Len(iSPageCnt) = 0 Then
    iSPageCnt = "1"
  End If



  TSubject = fInject(Request("TSubject"))

  If Len(TSubject) = 0 Then
    TSubject = "SD칼럼"
  End If

  Dim NowPage, iType

  NowPage = fInject(Request("i2"))  ' 현재페이지
  iType = fInject(Request("iType"))  ' 글쓰기 1, 수정 2

  'Name = fInject(Request.cookies(global_HP)("UserName"))
  Name = fInject(Request.cookies("UserName"))

  'iLoginID = decode(fInject(Request.cookies(global_HP)("UserID")),0)
  iUserID = fInject(Request.cookies("UserID"))
  iLoginID = decode(iUserID,0)

  ' 뷰 관련
  Dim LCnt, iMSeq, MSeq, Subject, Contents, InsDateCv, FileYN, FileCnt, LoginIDYN
  LCnt = 0

  ' 뷰에 해당하는 첨부파일 관련
  Dim  LCnt1, PSeq1, FileName1, FilePath1, ReplyYN
  LCnt1 = 0

  If iType = "2" Then

    iMSeq = fInject(Request("i1"))
    MSeq = decode(iMSeq,0)

    LSQL = "EXEC Community_Board_R '" & NowPage & "','" & MSeq & "','" & iLoginID & "'"
    'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
    'response.End

    Set LRs = DBCon4.Execute(LSQL)

    If Not (LRs.Eof Or LRs.Bof) Then

      Do Until LRs.Eof

          LCnt = LCnt + 1
          ColumnistIDX = LRs("ColumnistIDX")
          eColumnistIDX = encode(ColumnistIDX,0)
          Subject = LRs("Subject")
          SubTypeName = LRs("SubTypeName")
          SubType = LRs("SubType")
          Contents = LRs("Contents")
          Source = LRs("Source")
          ReplyYN = LRs("ReplyYN")
          NoticeYN = LRs("NoticeYN")
          InsDateCv = LRs("InsDateCv")
          FileYN = LRs("FileYN")
          FileCnt = LRs("FileCnt")
          LoginIDYN = LRs("LoginIDYN")
          ViewCnt = LRs("ViewCnt")

        LRs.MoveNext
      Loop

    End If

    LRs.close

    ' 디버깅 모드로 수정 해서 강제로 접근할 경우 체크
    'If LoginIDYN = "N" Then
    '
    '  response.Write "<script type='text/javascript'>alert('잘못된 접근 입니다.');location.href='/';</script>"
    '  'response.Write "<script type='text/javascript'>alert('글 등록이 잘 됐습니다.');</script>"
    '  response.End
    '
    'End If


    'If FileCnt <> "0" Then
    '
    '  LCnt1 = 0
    '
    '  LSQL = "EXEC Community_Board_Pds_R '" & MSeq & "'"
    '  'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
    '  'response.End
    '
    '  Set LRs = DBCon5.Execute(LSQL)
    '
    '  If Not (LRs.Eof Or LRs.Bof) Then
    '
    '    Do Until LRs.Eof
    '
    '        LCnt1 = LCnt1 + 1
    '        PSeq1 = PSeq1&"^"&LRs("PSeq")&""
    '        FileName1 = FileName1&"^"&LRs("FileName")&""
    '        FilePath1 = FilePath1&"^"&LRs("FilePath")&""
    '
    '      LRs.MoveNext
    '    Loop
    '
    '  End If
    '
    '  LRs.close
    '
    'End If

    DBClose4()

  End If

%>

<script type="text/javascript">

  var selSearchValue1 = "<%=iSubType%>";
  var selSearchValue2 = "<%=iNoticeYN%>";
  var selSearchValue = "<%=iSearchCol%>";
  var txtSearchValue = "<%=iSearchText%>";

  var selSearchValue3 = "<%=iDivision%>";
  var selSearchValue4 = "<%=iSearchCol1%>";

  var selSearchValue5 = "<%=ieSearchCol2%>";

  var iType = Number("<%=iType%>");
  var iMSeq = "<%=iMSeq%>";

  var iPageCnt = "<%=iPageCnt%>";
  var iSPageCnt = "<%=iSPageCnt%>";

  // 목록 이동 : S //
  function CancelLinkC(i2, TSubject) {

    post_to_url('./story.asp', { 'i2': i2, 'iType': '2', 'iSubType': selSearchValue1, 'iNoticeYN': selSearchValue2, 'iDivision': 12, 'iSearchCol1': selSearchValue4, 'iSearchCol2': selSearchValue5, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue, 'TSubject': TSubject, 'iSPageCnt': i2, 'iPageCnt': iPageCnt });
  }
  // 목록 이동 : E //

</script>

  <body>
    <!-- S: sub-header -->
    <div class="sd-header sd-header-sub">
      <!-- #include file="../include/sub_header_arrow.asp" -->
      <h1><%=TSubject%></h1>
      <!-- #include file="../include/sub_header_gnb.asp" -->
    </div>
    <!-- #include file = "../include/gnb.asp" -->
    <!-- E: sub-header -->

    <!-- S: container_body -->
    <div class="part_main tennis_part">


      <!-- S: main -->
      <div class="main gray_bg">
        
        <!--
        <span class="srch_box">
        <input type="text" class="search_box" placeholder="검색어를 입력해 주세요">
        </span>
        -->


        <!-- s: view 시작 -->
        <div class="column_story_view">
          <p class="view_name"><%=Subject %></p>
          <div class="date">
            <span>기사입력일</span>
            <span class="date_line"></span>
            <span><%=InsDateCv %></span>
          </div>

          <% if Source <> "" then %>
          <div class="source">
            <span>출처</span>
            <span class="date_line"></span>
            <span><%=Source %></span>
          </div>
          <% end if %>

          <% if ViewCnt <> "" then %>
          <div class="source count">
            <span>조회수</span>
            <span class="date_line"></span>
            <span><%=ViewCnt %></span>
          </div>
          <% end if %>

          <!-- s: video 뷰 -->
          <div class="con_txt cont_area">
            <pre>
              <%=Contents %>
            </pre>
          </div>

          <div class="more_btn">
            <a href="javascript:;" onclick="javascript:CancelLinkC('<%=iSPageCnt %>', '<%=TSubject %>');"><%=TSubject%> 목록</a>
          </div>

        </div>
        <!-- s: view 끝 -->

      </div>
      <!-- E: main -->

      <!-- S: main_footer -->
      <!-- #include file = '../include/main_footer.asp' -->
      <!-- E: main_footer -->

    </div>
    <!-- E: container_body -->

    <!-- S: bot_config -->
    <!-- #include file = "../include/bot_config.asp" -->
    <!-- E: bot_config -->
  </body>
</html>
