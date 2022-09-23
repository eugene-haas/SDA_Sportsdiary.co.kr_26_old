<!-- #include file="../include/config.asp" -->
<%
	dim CIDX	: CIDX = decode(request("CIDX"), 0)
	
	IF CIDX = "" Then
		response.Write "<script>alert('잘못된 접근입니다. 확인 후 이용하세요.'); history.back();</script>"
		response.End()
	End IF
	
	
	dim LSQL, LRs
	dim Subject
	
	'============================================================================================================
	'컴럼리스트 타이틀 조회	
	'============================================================================================================
	LSQL = "		SELECT Subject"
	LSQL = LSQL & "	FROM [SD_Tennis].[dbo].[tblColumnist]"
	LSQL = LSQL & "	WHERE DelYN = 'N'"
	LSQL = LSQL & "		AND ColumnistIDX = '"&CIDX&"'"	
	SET LRs = DBCon3.Execute(LSQL)
	IF Not(LRs.Eof Or LRs.Bof) Then 
		Subject = ReplaceTagReText(LRs("Subject"))
	Else
		response.Write "<script>alert('일치하는 정보가 없습니다. 확인 후 이용하세요.'); history.back();</script>"
		response.End()
	End IF
		LRs.Close
	SET LRs = Nothing
	'============================================================================================================
	
'	response.Write CIDX
%>
  <body>
    <!-- S: container_body -->
    <div class="part_main tennis_part">
      <!-- S: header -->
      <!-- #include file = '../include/header_sub_left.asp' -->
      <h1><%=Subject%></h1>
      <!-- #include file = '../include/header_sub_right.asp' -->
      <!-- E: header -->

      <!-- S: main -->
      <div class="main">
        <!-- S: include gnb -->
        <!--
        <span class="srch_box">
        <input type="text" class="search_box" placeholder="검색어를 입력해 주세요">
        </span>
        -->
        <!-- #include file = "../include/gnbType/player_gnb.asp" -->
        <!-- E: include gnb -->

        <!-- s: 칼럼스토리 시작 -->
				<div class="column_story_page">
					<ul>
						<li>
							<a href="view.asp">
								<div class="img">
									<img src="../images/media/list_img1.png" alt="" />
								</div>
								<div class="bt_con">
									<div class="txt">
										<p class="name">2018 테니스 잘 하는 법</p>
										<p class="date_con">
											<span class="date">2018.01.05</span>
											<span class="division_line"></span>
											<span class="views_number"><span>55</span> 읽음</span>
										</p>
									</div>
								</div>
							</a>
						</li>
						<li>
							<a href="view.asp">
								<div class="img">
									<img src="../images/media/list_img1.png" alt="" />
								</div>
								<div class="bt_con">
									<div class="txt">
										<p class="name">2018 테니스 잘 하는 법</p>
										<p class="date_con">
											<span class="date">2018.01.05</span>
											<span class="division_line"></span>
											<span class="views_number"><span>55</span> 읽음</span>
										</p>
									</div>
								</div>
							</a>
						</li>
					</ul>
					<div class="mored_btn">
						<a href="#">
							<span class="txt">더보기</span>
							<span class="icon_more"><i class="fa fa-angle-down" aria-hidden="true"></i></span>
						</a>
					</div>
				</div>
				<!-- e: 칼럼스토리 시작 -->
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