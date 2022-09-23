<%
    '====================================================================================
    '비밀번호가 발급된 임시비밀번호인지 체크 후 임시비밀번호인 경우 비밀번호변경 페이지로 이동시킵니다.
    '/Libary/common_function.asp
    CHK_USERPASS_TYPE()

    '====================================================================================
    'Gnb Type
    'COOKIE_MEMBER_IDX = decode(request.Cookies(SportsGb)("MemberIDX"),0)
    '/Libary/common_function.asp
    '====================================================================================
    dim Cookie_MemberIDX  : Cookie_MemberIDX  = COOKIE_MEMBER_IDX()               '종목별 가입계정 MemberIDX

	dim txt_Name  '테니스 로그인한 계정타입명
	dim Img_IDType  '테니스 가입한 계정프로필 이미지 출력

	If dbtype = "class" Then
		Set LRs= db.ExecSQLReturnRS(INFO_QUERY_JOINACCOUNT("GNB") , null, T_ConStr)
	Else
		SET LRs = DBCon3.Execute(INFO_QUERY_JOINACCOUNT("GNB"))
	End if


	IF Not(LRs.Eof or LRs.bof) Then
		txt_Name = LRs("PlayerRelnNm")
	END IF
		LRs.Close
	SET LRs = Nothing

	IF request.cookies(SportsGb)("PhotoPath") <> "" Then
		Img_IDType = decode(request.cookies(SportsGb)("PhotoPath"), 0)
	Else
		Img_IDType = ImgDefault
	End IF


    iLIUserID = Request.Cookies("SD")("UserID")
    iLIMemberIDX = Request.Cookies("SD")("MemberIDX")
    iLISportsGb = SportsGb

    'LocateIDX_ham_1 = "66"
    'LocateIDX_ham_2 = "10"
    LocateIDX_ham_3 = "66"

%>

<script>
	/*
		회원제 서비스 전환업데잍트 20180726
		1. 메인 SD뉴스, 더보기버튼 	/main/index.asp
		2. 대회일정/결과(본선)		/tournament/Totaltourney.asp
		3. Gnb영역 SD뉴스			/include/Player_Gnb.asp
		4. 메인 SD뉴스				/ajax/index_news_default.asp
	*/
	//현재계정 로그인 및 회원가입 상태 조회
	function CHK_JOINMEMBER(){
		var SDLoginID = '<%=request.Cookies("SD")("UserID")%>';
		var LoginIDX = '<%=Cookie_MemberIDX%>';
		var CHK_VALUE = 0;

		//통합회원 로그인 및 가입여부 체크
		if(!SDLoginID){
			CHK_VALUE = 1001;
		}
		else{
			//종목 계정가입 로그인 및 가입여부 체크
			//if(!LoginIDX) CHK_VALUE = 1002; // 백승훈 막음
		}

		return CHK_VALUE;
	}

    /*
    //20180824 사용안함
    //현재계정 로그인 및 회원가입 여부에 따른 페이지 이동처리
    //사용페이지 [
    //      /main/index.asp                 :SD 뉴스
    //      /include/gnbType/player_gnb.asp :뉴스
    //  ]
	function CHK_JOIN(valParam, valURL){
		var CHK_VALUE = CHK_JOINMEMBER();

		switch(valParam){
			case '1001'	:
				if(CHK_VALUE==1001){
					if(confirm('회원정보가 필요한 서비스입니다. 로그인 또는 회원가입을 해주세요.\n\n로그인페이지로 이동하시겠습니까?')){
						$(location).attr('href','http://sdmain.sportsdiary.co.kr/sdmain/login.asp');
					}
					else{
						return;
					}
				}
				else{
					$(location).attr('href',valURL);
				}
				break;
			case '1002'	:
				if(CHK_VALUE==1001){
					if(confirm('회원정보가 필요한 서비스입니다. 로그인 또는 회원가입을 해주세요.\n\n로그인페이지로 이동하시겠습니까?')){
						$(location).attr('href','http://sdmain.sportsdiary.co.kr/sdmain/login.asp');
					}
					else{
						return;
					}
				}
				else if(CHK_VALUE==1002){
					if(confirm('계정정보가 필요한 서비스입니다. 로그인 또는 계정추가를 해주세요.\n\n계정추가페이지로 이동하시겠습니까?')){
						$(location).attr('href','http://sdmain.sportsdiary.co.kr/sdmain/join_MemberTypeGb.asp');
					}
					else{
						return;
					}
				}
				else{
					$(location).attr('href',valURL);
				}
				break;
			default :
				$(location).attr('href',valURL);
	   	}
	}
    */
</script>

<div class="l_gnb [ _gnb ]" id="gnb">
  <div class="l_gnb__dim [ _gnbDim _gnbClose ]"></div>
  <div class="l_gnb__box [ _gnbBox ]">

    <div class="l_gnb__cont">

      <%IF request.Cookies("SD")("UserID") <> "" Then%>

      <div class="m_profile">
        <div class="m_profile__imgWrap">

          <img id="imgGnb" src="<%=Img_IDType%>" alt="프로필 사진" class="m_profile__img">

        </div>

        <div class="m_profile__txtWrap">
          <h2 class="m_profile__txt"><span  class="m_profile__name"><%=Request.Cookies("SD")("UserName")%></span> 님</h2>
          <span class="m_profile__belong"><%=txt_Name%></span>
        </div>

        <div class="m_profile__btns">
          <a href="http://sdmain.sportsdiary.co.kr/sdmain/mypage/mypage.asp" class="m_profile__btn s_toMypage"> </a>
        </div>
      </div>

      <%Else%>

      <div class="m_userJoin">
        <h2 class="m_userJoin__guide">
          <span class="m_userJoin__guideTxt">처음이신가요?</span><br>
          <span class="m_userJoin__guideTxt s_blue">회원가입을 해주세요.</span>
        </h2>
        <div class="m_userJoin__btns">
          <a href="http://sdmain.sportsdiary.co.kr/sdmain/login.asp" class="m_userJoin__btn">
            <span class="m_userJoin__btnIcon s_login"></span><span class="m_userJoin__btnTxt s_login">로그인</span>
          </a>
          <a href="http://sdmain.sportsdiary.co.kr/sdmain/combine_check.asp" class="m_userJoin__btn">
            <span class="m_userJoin__btnIcon s_account"></span><span class="m_userJoin__btnTxt s_account">회원가입</span>
          </a>
        </div>
      </div>

      <%End IF%>

      <div class="m_gnbBoard">
        <h2 class="m_gnbBoard__tit">대회정보</h2>
        <ul class="m_navList">
          <li class="m_navList__item"> <a class="m_navList__link" href="../Result/institute-search.asp"> 대회일정/결과 </a> </li>
          <li class="m_navList__item s_notReady"> <a class="m_navList__link"> 대회영상모음 </a> </li>
          <li class="m_navList__item"> <a class="m_navList__link" href="../record/record_kata.asp"> 경기기록실 </a> </li>
          <li class="m_navList__item s_notReady"> <a class="m_navList__link"> 선수분석 </a> </li>
        </ul>
      </div>

      <div class="m_gnbBoard">
        <h2 class="m_gnbBoard__tit">자료실</h2>
        <ul class="m_navList">
          <li class="m_navList__item"> <a class="m_navList__link" href="../Media/list.asp"> 뉴스 </a> </li>
          <li class="m_navList__item s_notReady"> <a class="m_navList__link btn_not_yet"> 동영상 </a> </li>
          <li class="m_navList__item s_notReady"> <a class="m_navList__link btn_not_yet"> 칼럼리스트 </a> </li>
          <li class="m_navList__item s_notReady"> <a class="m_navList__link btn_not_yet"> 애널리스트 </a> </li>
        </ul>
      </div>

      <div class="m_gnbBoard">
        <h2 class="m_gnbBoard__tit">게시판</h2>
        <ul class="m_navHList s_3items">
          <li class="m_navHList__item"> <a class="m_navHList__link s_notice" href="../Board/notice-list.asp"> 공지사항 </a> </li>
          <li class="m_navHList__item"> <a class="m_navHList__link s_qa" href="../Board/qa_board.asp"> 질문과답변 </a> </li>
          <li class="m_navHList__item"> <a class="m_navHList__link s_faq" href="../Board/faq.asp"> 자주하는 질문 </a> </li>
        </ul>
      </div>

      <div class="m_gnbBoard">
        <h2 class="m_gnbBoard__tit">경기운영</h2>
        <div style="margin:auto;width:90%;margin-top:10px;"><a class="btn btn-default" href="http://tennisadmin2.sportsdiary.co.kr/pub/login.asp" style="width:100%;padding:10px;"> 경기운영</a></div>
      </div>


      <!-- S: main banner 03 -->
      <%
        imType = "1"
        imSportsGb = "tennis"
        imLocateIDX = LocateIDX_ham_3

        LSQL = "EXEC AD_View_S '" & imType & "','" & imSportsGb & "','" & imLocateIDX & "','','','','',''"

    		If dbtype = "class" Then
    			Set LRs= db.ExecSQLReturnRS(LSQL , null, BN_ConStr)
    		Else
    	        Set LRs = DBCon6.Execute(LSQL)
			End If

    		If Not (LRs.Eof Or LRs.Bof) Then
			If lrs("result") = "Yes" then

      %>
	    <div class="major_banner">
	      <div class="banner banner_<%=LRs("LocateGb")%> carousel">
	    	  <div <% if LRs("TypeOutput") = "S" then %>class="bxslider"<% end if %>>
	    		  <%
	    			  Do Until LRs.Eof

                iLink = LRs("Link")

                if Len(iLink) = 0 then

                  iLink = ""

                else

                  if instr(iLink,"?") > 0 then

                    iLink = iLink&"&"&tpara

                  else

                    iLink = iLink&"?"&tpara

                  end if

                end if
	    			    iLinkType = LRs("LinkType")
                iProductLocateIDX = LRs("ProductLocateIDX")
                ieProductLocateIDX = encode(iProductLocateIDX, 0)
	  		    %>
	  		      <% if (IPHONEYN() = "0" and iLinkType = "2") then %>
                <% if iLink = "" then %>
	  		        <div style="background-color: #<%=LRs("BColor")%>"> <img src="<%=global_filepathUrl_ADIMG %><%=LRs("ImgFileNm") %>" alt="" /> </div>
	  		        <% else %>
                <div style="background-color: #<%=LRs("BColor")%>"> <a href="<%=iLink %>" class="banner_area" target="_blank" onclick="javascript:fn_ADLOG('<%=iLISportsGb %>','<%=ieProductLocateIDX %>','<%=iLIUserID %>','<%=iLIMemberIDX %>');"> <img src="<%=global_filepathUrl_ADIMG %><%=LRs("ImgFileNm") %>" alt="" /> </a> </div>
                <% end if %>
              <% else %>
                <% if iLink = "" then %>
                <div style="background-color: #<%=LRs("BColor")%>"> <img src="<%=global_filepathUrl_ADIMG %><%=LRs("ImgFileNm") %>" alt="" /> </div>
                <% else %>
                <div style="background-color: #<%=LRs("BColor")%>"> <a href="javascript:;" onclick="javascript:fn_ADLOG('<%=iLISportsGb %>','<%=ieProductLocateIDX %>','<%=iLIUserID %>','<%=iLIMemberIDX %>');javascript:fn_mclicklink('<%=iLinkType %>','<%=iLink %>');" class="banner_area"> <img src="<%=global_filepathUrl_ADIMG %><%=LRs("ImgFileNm") %>" alt="" /> </a> </div>
                <% end if %>
              <% end if %>
	  		    <%
	    					LRs.MoveNext
	    				Loop
	    			%>
	    		</div>
	    	</div>
	    </div>
	    <%
		  End if
	      End If
	      LRs.close
	    %>
      <!-- E: main banner 03 -->

    </div>

    <div class="l_gnb__fNav">
      <a href="http://sdmain.sportsdiary.co.kr/sdmain/index.asp" class="l_gnb__fNavItem s_event"> 종목 선택 </a>
      <a href="javascript:alert('sportsdiary://goPushMsg');" class="l_gnb__fNavItem s_push"> 앱 알림함 </a>
      <a href="../main/index.asp" class="l_gnb__fNavItem s_home"> 홈으로 </a>
      <a class="l_gnb__fNavItem s_close [ _gnbClose ]"> 닫기 </a>
    </div>

  </div>
</div>

<!-- S: tops top-btn -->
<!-- <div class="tops btn-div"> <a href="#" class="top_btn">TOP</a> </div> -->
<!-- E: tops top-btn -->

<!-- S: 계정 전환 모달 -->
<!-- #include file="./change_modal.asp" -->
<!-- E: 계정 전환 모달 -->
