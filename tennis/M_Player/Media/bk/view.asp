<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file="../include/config.asp" -->

  <%

    'iLIUserID = Request.Cookies("SD")("UserID")
    'iLIMemberIDX = Request.Cookies(SportsGb)("MemberIDX")
    'iLISportsGb = SportsGb

    iLIUserID = Request.Cookies("SD")("UserID")
    iLIMemberIDX = Request.Cookies(SportsGb)("MemberIDX")
    iLIMemberIDXd = decode(Request.Cookies(SportsGb)("MemberIDX"),0)
    iLISportsGb = SportsGb

  	LocateIDX_1 = "17"
  	'LocateIDX_2 = "10"
  	'LocateIDX_3 = "13"

  %>

  <%

    iSubType = fInject(Request("iSubType"))
    iSearchText = fInject(Request("iSearchText"))
    iSearchCol = fInject(Request("iSearchCol"))
    iNoticeYN = fInject(Request("iNoticeYN"))

    ' 칼람개설 페이징 번호
    iPageCnt = fInject(Request("iPageCnt"))

    If Len(iPageCnt) = 0 Then
      iPageCnt = "1"
    End If

    iDivision = fInject(Request("iDivision"))

    iSearchCol1 = fInject(Request("iSearchCol1")) ' S2Y : 최신순, S2C : 많이본순

    ieSearchCol2 = fInject(Request("iSearchCol2")) ' ColumnistIDX
    iSearchCol2 = decode(ieSearchCol2,0)

    Dim NowPage, iType

    NowPage = fInject(Request("i2"))  ' 현재페이지
    iType = fInject(Request("iType"))  ' 글쓰기 1, 수정 2

    Name = fInject(Request.cookies(SportsGb)("UserName"))
    'Name = Request.Cookies("UserName")

    iLoginID = decode(fInject(Request.cookies(SportsGb)("UserID")),0)
    'iLoginID = Request.Cookies("UserID")
    'iLoginID = decode(iLoginID,0)

    ' 뷰 관련
    Dim LCnt, iMSeq, MSeq, Subject, Contents, InsDateCv, FileYN, FileCnt, LoginIDYN
    LCnt = 0

    ' 뷰에 해당하는 첨부파일 관련
    Dim  LCnt1, PSeq1, FileName1, FilePath1, ReplyYN
    LCnt1 = 0

    'response.Write "iType="&iType&"<br>"
    'response.End

    IF iType = "2" Then

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

    End IF
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

    // 목록 이동 : S //
    function CancelLink(i2) {
      post_to_url('./list.asp', { 'i2': i2, 'iSubType': selSearchValue1, 'iNoticeYN': selSearchValue2, 'iDivision': selSearchValue3, 'iSearchCol1': selSearchValue4, 'iSearchCol2': selSearchValue5, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue, 'iPageCnt': i2 });
      //post_to_url('./list.asp', { 'i2': i2, 'iSubType': selSearchValue1, 'iNoticeYN': selSearchValue2, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
    }
    // 목록 이동 : E //

  </script>
</head>
<body>
    <!-- S: sub-header -->
    <div class="sd-header sd-header-sub">
      <!-- #include file="../include/sub_header_arrow.asp" -->
      <h1>SD 뉴스</h1>
      <!-- #include file="../include/sub_header_right.asp" -->
    </div>
    <!-- E: sub-header -->

    <!-- #include file = "../include/gnb.asp" -->


    <!-- S: main banner 01 -->
    <%
      imType = "1"
      imSportsGb = "tennis"
      imLocateIDX = LocateIDX_1

      LSQL = "EXEC AD_View_S '" & imType & "','" & imSportsGb & "','" & imLocateIDX & "','','','','',''"
      'response.Write "LSQL="&LSQL&"<br>"
      'response.End

      Set LRs = DBCon6.Execute(LSQL)
      If Not (LRs.Eof Or LRs.Bof) Then
    %>
    <div class="major_banner">
      <div class="banner banner_<%=LRs("LocateGb")%> carousel">
        <div <% if LRs("TypeOutput") = "S" then %>class="bxslider"<% end if %>>
        <!-- #include file="../include/banner_Include.asp" -->
        </div>
      </div>
    </div>
    <%
      End If
      LRs.close
    %>
    <!-- E: main banner 01 -->

    <!-- S: container_body -->
    <div class="part_main tennis_part sd-scroll [ _sd-scroll ]">

      <!-- S: main -->
      <div class="main gray_bg">

        <!--
        <span class="srch_box">
        <input type="text" class="search_box" placeholder="검색어를 입력해 주세요">
        </span>
        -->

        <!-- s: view 시작 -->
        <div class="new_list_view">
          <p class="view_name"><%=Subject %></p>
          <div class="date">
            <span>기사입력일</span>
            <span class="date_line"></span>
            <span><%=InsDateCv %></span>
          </div>
          <div class="source count">
            <span>작성자</span>
            <span class="date_line"></span>
            <span><%=Name%></span>
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
          <!-- s: photo 뷰 -->
          <!--
          <div class="img">
            <img src="../images/media/view_photo.png" alt=""/>
          </div>
          -->
          <!-- E: photo 뷰 -->
          <%
            IF rDivision = "3" Then
          %>
          <!-- S: video 뷰 -->
          <div class="img">
            <iframe width="100%" height="191" src="https://www.youtube.com/embed/<%=Link%>" frameborder="0" gesture="media" allow="encrypted-media" allowfullscreen></iframe>
          </div>
          <div class="con_txt cont_area">
            <pre><%=iContents %></pre>
          </div>
          <!-- E: video 뷰 -->
          <% else %>
          <div class="con_txt cont_area">
            <pre><%=iContents %></pre>
          </div>
          <%
            End IF
          %>

          <div class="more_btn">
            <a href="javascript:;" onclick="javascript:CancelLink('<%=iPageCnt %>');">목록</a>
          </div>
        </div>
        <!-- s: view 끝 -->

      </div>
      <!-- E: main -->

    </div>
    <!-- E: container_body -->


    <!-- #include file = '../include/main_footer.asp' -->
    <!-- #include file = "../include/bot_config.asp" -->
  </body>
</html>
<% AD_DBClose() %>
