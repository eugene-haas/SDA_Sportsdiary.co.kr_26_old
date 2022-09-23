<!-- #include file="../include/config.asp" -->
<%
	dim iTotalCount
	dim iTotalPage
	dim LCnt0 		: LCnt0 		= 0	 						'페이징
	dim LCnt  		: LCnt 			= 0
	dim iDivision 	: iDivision 	= "1"                   	'iDivision -  1 : 전체 - 일반뉴스+영상뉴스, 2 : 일반뉴스, 3 : 영상뉴스, 200:일반뉴스(메인), 300:영상뉴스(메인)
	dim iLoginID 	: iLoginID 		= decode(fInject(Request.cookies(SportsGb)("UserID")),0)
	dim NowPage 	: NowPage 		= fInject(Request("i2"))  	' 현재페이지
	dim PagePerData	: PagePerData 	= 5					  		' 한화면에 출력할 갯수
	dim BlockPage	: BlockPage 	= 5      					' 페이징수, 5면 1,2,3,4,5 까지 나오고 다음페이지 나옴
	
	'PagePerData = 2
	'BlockPage = 2

	'Request Data
	 
	dim iSubType	: iSubType 		= fInject(Request("iSubType"))
	dim iSearchText	: iSearchText 	= fInject(Request("iSearchText"))
	dim iSearchCol	: iSearchCol 	= fInject(Request("iSearchCol"))
	dim iNoticeYN	: iNoticeYN 	= fInject(Request("iNoticeYN"))

	IF Len(NowPage) = 0 Then NowPage = 1
	
	if(Len(iSubType) = 0) Then iSubType = "" ' 구분
	if(Len(iNoticeYN) = 0) Then iNoticeYN = "" ' 구분
	if(Len(iSearchCol) = 0) Then iSearchCol = "T" ' 검색 구분자
	if(Len(iSearchText) = 0) Then iSearchText = "" ' 검색어

	iType = "2"                      ' 1:조회, 2:총갯수

	LSQL = "EXEC SD_Tennis.dbo.Community_Board_S '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSubType & "','" & iSearchCol & "','" & iSearchText & "','" & iYear & "','" & iNoticeYN & "','" & iLoginID & "','','','','','','','','','',''"
	
	'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
	'response.End

	SET LRs = DBCon3.Execute(LSQL)
	IF Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof
			iTotalCount = LRs("TOTALCNT")
			iTotalPage = LRs("TOTALPAGE")
			LRs.MoveNext
		Loop
	End If
		LRs.close
%>
<script type="text/javascript">
	var selSearchValue1 = "<%=iSubType%>";
	var selSearchValue2 = "<%=iNoticeYN%>";
	var selSearchValue = "<%=iSearchCol%>";
	var txtSearchValue = "<%=iSearchText%>";

	function ReadLink(i1, i2) {
		post_to_url('./view.asp', { 'i1': i1, 'i2': i2, 'iType': '2', 'iSubType': selSearchValue1, 'iNoticeYN': selSearchValue2, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
	}

	function PagingLink(i2) {
		post_to_url('./list.asp', { 'i2': i2, 'iSubType': selSearchValue1, 'iNoticeYN': selSearchValue2, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
	}

	function fn_selSearch() {

		selSearchValue2 = document.getElementById('selSearch2').value;
		selSearchValue1 = document.getElementById('selSearch1').value;
		selSearchValue = document.getElementById('selSearch').value;
		txtSearchValue = document.getElementById('txtSearch').value;

		post_to_url('./list.asp', { 'i2': 1, 'iSubType': selSearchValue1, 'iNoticeYN': selSearchValue2, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
	}

</script>	
  <body>
    <!-- S: container_body -->
    <div class="part_main tennis_part">
      <!-- S: header -->
      <!-- #include file = '../include/header_sub_left.asp' -->
      <h1>SD 뉴스</h1>
      <!-- #include file = '../include/header_sub_right.asp' -->
      <!-- E: header -->

      <!-- S: main -->
      <div class="main gray_bg">
        <!-- S: include gnb -->
        <!--
        <span class="srch_box">
        <input type="text" class="search_box" placeholder="검색어를 입력해 주세요">
        </span>
        -->
        <!-- #include file = "../include/gnbType/player_gnb.asp" -->
        <!-- E: include gnb -->
        <!-- s: select box -->
        <div class="top_select">
          <select name="" id="">
            <option value="">전체</option>
          </select>
          <select name="" id="">
            <option value="">최신순</option>
          </select>
        </div>
        <!-- e: select box -->		  
        <!-- s: list 시작 -->
        <div class="news_list_page">
          <div class="list_box">
            <ul>
			<%
			' 리스트 조회
			iType = "1"
			
   			'EXEC Community_Board_S '1','5','5','1','1','','T','','','','padmin','6','','','','','','','','',''
   
			LSQL = "EXEC SD_Tennis.dbo.Community_Board_S '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSubType & "','" & iSearchCol & "','" & iSearchText & "','" & iYear & "','" & iNoticeYN & "','" & iLoginID & "','','','','','','','','','',''"
			
   			'response.Write "LSQL="&LSQL&"<br>"
			'response.End

			SET LRs = DBCon3.Execute(LSQL)
			IF Not (LRs.Eof Or LRs.Bof) Then
				Do Until LRs.Eof
					LCnt = LCnt + 1
			 
			 		SELECT CASE LRs("Division")
			 			CASE "2"
			 			%>
			 			<li class="no_img">
							<a href="javascript:ReadLink('<%=encode(LRs("MSeq"),0) %>','<%=NowPage %>');">
							  <div class="r_con">
								<p class="list_name">
								  <p class="name"><%=LRs("Subject")%></p>
								  <p class="txt_con"><%=gf_LeftAtDb(LRs("Contents"), 95)%></p>
								</p>
								<p class="bt_con">
								  <span class="date"><%=LRs("InsDateCv")%></span>
									&nbsp;
									<span class="date">조회수 <%=LRs("ViewCnt")%></span>	  
								  <span class="line"></span>
								  <span class="companny_name"><%=LRs("Name")%></span>
								</p>
							  </div>
							</a>
						  </li>
			 			<%
			 			CASE "3"
			 			%>
			 			<li>
							<a href="javascript:ReadLink('<%=encode(LRs("MSeq"),0) %>','<%=NowPage %>');">
							  <div class="img">
									<!--<img src="../images/media/list_img1.png" alt="" />-->
									<iframe width="145" height="82" src="https://www.youtube.com/embed/<%=LRs("Link")%>?rel=0&amp;showinfo=0" frameborder="0" allowfullscreen></iframe>
									</div>
									<div class="r_con">
									<p class="list_name"><%=LRs("Subject")%></p>
									<p class="bt_con">
										<span class="date"><%=LRs("InsDateCv")%></span>
										<span class="line"></span>
										<span class="companny_name"><%=LRs("Name")%></span>
									</p>
							  </div>
								</a>
						  </li>
			 		<%
			 		END SELECT
				  	
			 		LRs.MoveNext
				Loop
			Else 
			
			End IF
			  	LRs.close
			SET LRs = Nothing
			 
		  	DBClose3()			
			%> 
			<!--
			 <li>
                <a href="view.asp">
                  <div class="img">
                    <div class="mv_box">
                      <img src="../images/media/list_img1.png" alt="" class="photo"/>
                      <img src="../images/media/mv_icon.png" alt="" class="mv_icon"/>
                    </div>
                  </div>
                  <div class="r_con">
                    <p class="list_name">
                      정현, ASB클래식 1회전서 에드먼드와 또 만나
                    </p>
                    <p class="bt_con">
                      <span class="date">2018.01.05</span>
                      <span class="line"></span>
                      <span class="companny_name">한국테니스연맹</span>
                    </p>
                  </div>
                </a>
              </li>
			 -->
            </ul>
          </div>
					<div class="mored_btn">
						<a href="#">
							<span class="txt">더보기</span>
							<span class="icon_more"><i class="fa fa-angle-down" aria-hidden="true"></i></span>
						</a>
					</div>
        </div>
        <!-- e: list 끝 -->
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