<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file="../include/head.asp" -->
  <!-- #include file="../include/config.asp" -->

  <%

    iLIUserID = Request.Cookies("SD")("UserID")
    iLIMemberIDX = Request.Cookies(SportsGb)("MemberIDX")
    iLISportsGb = SportsGb

  	LocateIDX_1 = "19"
  	'LocateIDX_2 = "10"
  	'LocateIDX_3 = "13"

  %>

  <!-- S: detail INFO -->
  <%
    dim NtcIDX    	: NtcIDX    	= fInject(request("NtcIDX"))
    dim currPage  	: currPage    	= fInject(request("currPage"))
    dim fnd_user  	: fnd_user    	= fInject(request("fnd_user"))
    dim search_date 	: search_date   = fInject(request("search_date"))
    dim SDate     	: SDate     	= fInject(request("SDate"))
    dim EDate     	: EDate     	= fInject(request("EDate"))


    IF NtcIDX = "" Then
      response.Write "<script>alert('잘못된 접근입니다\n확인 후 이용하세요'); history.back();</script>"
      response.End()
    End IF

    	CSQL =  " SELECT * "
  	CSQL = CSQL & " FROM [SD_tennis].[dbo].[tblSvcNotice] "
  	CSQL = CSQL & " WHERE DelYN = 'N' "
  	CSQL = CSQL & "		AND SportsGb = '"&SportsGb&"' "
  	CSQL = CSQL & "   	AND NtcIDX = "&NtcIDX

    SET CRs = server.CreateObject ("ADODB.Recordset")
      CRs.Open CSQL, DBCon3, 1 ,3

      CRs("ViewCnt") = CRs("ViewCnt") + 1
      CRs.Update

      Title     = CRs("Title")
      Contents  = CRs("Contents")
      Notice    = CRs("Notice")
      WriteDate   = CRs("WriteDate")
      UserName  = CRs("UserName")
      ViewCnt   = CRs("ViewCnt")

      CRs.Close
    SET CRs = Nothing


  %>
  <!-- E: detail INFO -->
  <script>
    function chk_Submit(typeURL, NtcIDX, chkPage){
      $('form[name=s_frm]').attr('action',"./notice-list.asp");
      $('form[name=s_frm]').submit();

    }
  </script>
</head>
<body>
  <div class="l">

    <!-- #include file = "../include/gnb.asp" -->

    <div class="l_header">
      <div class="m_header s_sub">
        <!-- #include file="../include/header_back.asp" -->
        <h1 class="m_header__tit">공지사항</h1>
        <!-- #include file="../include/header_gnb.asp" -->
      </div>

      <div class="m_horizon"></div>
    </div>

    <div class="l_content m_scroll [ _content _scroll ]">
      <form name="s_frm" method="post">
        <input type="hidden" name="currPage" id="currPage" value="<%=currPage%>" />
        <input type="hidden" name="SDate" id="SDate" value="<%=SDate%>" />
        <input type="hidden" name="EDate" id="EDate" value="<%=EDate%>" />
        <input type="hidden" name="fnd_user" id="fnd_user" value="<%=fnd_user%>" />
        <input type="hidden" name="search_date" id="search_date" value="<%=search_date%>" />
        <input type="hidden"  class="on_val" id="on_val" name="on_val" />
        <input type="hidden"  class="active_val"  id="active_val" name="active_val" />

        <div class="m_noticeForumView">
          <div class="m_noticeForumView__header">
            <h3 class="m_noticeForumView__tit"><%IF Notice = "Y" Then response.Write "[필독]&nbsp;" End IF%><%=Title%></h3>
            <p class="m_noticeForumView__additionalTxt">
              <span><%=UserName%></span>
              <span><%=replace(left(WriteDate, 10), "-", ".")%></span>
              <span class="seen">조회수</span>
              <span><%=formatnumber(ViewCnt, 0)%></span>
            </p>
          </div>

          <div class="m_noticeForumView__contentWrap">
            <!-- S: 게시판 작성 내용 -->
            <p class="m_noticeForumView__content">
              <%=Contents%>
            </p>
            <!-- E: 게시판 작성 내용 -->
          </div>

          <div class="m_forum__btnBar">
            <a href="javascript: chk_Submit();" class="btn show-list">목록</a>
          </div>
        </div>

      </form>
    </div>
  </div>

  <!-- #include file="../include/bottom_menu.asp" -->
  <!-- #include file= "../include/bot_config.asp" -->
</body>
</html>
<% AD_DBClose() %>
