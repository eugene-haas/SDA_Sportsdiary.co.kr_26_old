<%
  
' response.Write "Cookie_MemberIDX="&Cookie_MemberIDX&"<br>"
' response.Write "SportsGb="&SportsGb&"<br>"
' response.Write "SDMemberIDX="&decode(request.Cookies("SD")("MemberIDX"),0)&"<br>"
' response.Write "UserName="&Request.Cookies(SportsGb)("UserName")&"<br>"
' response.Write "tennis_MemberIDX="&decode(request.Cookies(SportsGb)("MemberIDX"),0)&"<br>"
' response.Write "PlayerReln="&decode(Request.Cookies(SportsGb)("PlayerReln"),0)&"<br>"
' response.Write "EnterType="&request.Cookies(SportsGb)("EnterType")&"<br>"

  '====================================================================================   
  '쿠키 계정
  'include/gnbType/player_gnb.asp
  FUNCTION Info_JoinUsTxt(obj, valIDX)
    dim txt_JoinUs  '가입회원 목록
    
    SELECT CASE obj
    
'     CASE "judo"   
'       '유도
'       LSQL =  "     SELECT "
'       LSQL = LSQL & "   CASE M.EnterType  "
'       LSQL = LSQL & "     WHEN 'E' THEN "
'       LSQL = LSQL & "       CASE PlayerReln  "
'       LSQL = LSQL & "         WHEN 'A' THEN '유도 엘리트 - 보호자(부-'+P.UserName+')'"
'       LSQL = LSQL & "         WHEN 'B' THEN '유도 엘리트 - 보호자(모-'+P.UserName+')'"
'       LSQL = LSQL & "         WHEN 'Z' THEN '유도 엘리트 - 보호자('+PlayerRelnMemo+'-'+P.UserName+')'"
'       LSQL = LSQL & "         WHEN 'R' THEN '유도 엘리트 - 선수('+SportsDiary.dbo.FN_TeamNm('"&obj&"','', M.Team)+')'"
'       LSQL = LSQL & "         WHEN 'K' THEN '유도 엘리트 - 비등록선수' "
'       LSQL = LSQL & "         WHEN 'S' THEN '유도 엘리트 - 예비후보' "
'       LSQL = LSQL & "         WHEN 'T' THEN '유도 엘리트 - 지도자('+ISNULL(SportsDiary.dbo.FN_PubName('sd03900' + LeaderType),'')+')'+'<span class=""affiliation"">('+ISNULL(SportsDiary.dbo.FN_TeamNm2('"&obj&"', M.Team),'')+')</span>'"
'       LSQL = LSQL & "         WHEN 'D' THEN '유도 일반' "
'       LSQL = LSQL & "       END "
'       LSQL = LSQL & "     WHEN 'A' THEN "
'       LSQL = LSQL & "       CASE PlayerReln "
'       LSQL = LSQL & "         WHEN 'A' THEN '유도 생활체육 - 보호자(부-'+P.UserName+')'"
'       LSQL = LSQL & "         WHEN 'B' THEN '유도 생활체육 - 보호자(모-'+P.UserName+')'"
'       LSQL = LSQL & "         WHEN 'Z' THEN '유도 생활체육 - 보호자('+PlayerRelnMemo+'-'+P.UserName+')'"
'       LSQL = LSQL & "         WHEN 'R' THEN '유도 생활체육 - 선수('+ISNULL(SportsDiary.dbo.FN_TeamNm2('"&obj&"', M.Team),'')+')' "
'       LSQL = LSQL & "         WHEN 'T' THEN '유도 생활체육 - 지도자('+ISNULL(SportsDiary.dbo.FN_PubName('sd03900' + LeaderType),'')+')'+'<span class=""affiliation"">('+ISNULL(SportsDiary.dbo.FN_TeamNm2('"&obj&"', M.Team),'')+')</span>'"  
'       LSQL = LSQL & "         WHEN 'D' THEN '유도 일반' "  
'       LSQL = LSQL & "       END "
'       LSQL = LSQL & "   ELSE '국가대표' "
'       LSQL = LSQL & "   END PlayerRelnNm "
'       LSQL = LSQL & " FROM [SportsDiary].[dbo].[tblMember] M"
'       LSQL = LSQL & "   left join [SportsDiary].[dbo].[tblPlayer] P on M.PlayerIDX = P.PlayerIDX"
'       LSQL = LSQL & "     AND P.SportsGb = '"&obj&"' "
'       LSQL = LSQL & "     AND P.DelYN = 'N' "
'       LSQL = LSQL & " WHERE M.DelYN = 'N' "
'       LSQL = LSQL & "   AND M.SportsType = '"&obj&"' "
'       LSQL = LSQL & "   AND M.SD_UserID = '"&request.Cookies("SD")("UserID")&"' " 
'       LSQL = LSQL & "   AND M.MemberIDX = '"&valIDX&"' "  
'       LSQL = LSQL & " ORDER BY M.EnterType "
'       LSQL = LSQL & "   ,M.PlayerReln " 
'       
'       '       response.Write LSQL&"<br><br>"
'       
'       SET LRs = DBCon.Execute(LSQL)
'       IF Not(LRs.Eof or LRs.bof) Then
'         txt_JoinUs = txt_JoinUs & LRs(0)      
'       END IF
'       
'         LRs.Close
'       SET LRs = Nothing
      
    
    CASE "tennis" 
    
      '테니스
      
      LSQL =  "     SELECT M.MemberIDX"
      LSQL = LSQL & "   ,CASE M.PlayerReln "
      LSQL = LSQL & "     WHEN 'A' THEN '테니스 생활체육 - 보호자(부-'+P.UserName+')'"
      LSQL = LSQL & "     WHEN 'B' THEN '테니스 생활체육 - 보호자(모-'+P.UserName+')'"
      LSQL = LSQL & "     WHEN 'Z' THEN '테니스 생활체육 - 보호자('+PlayerRelnMemo+'-'+P.UserName+')'"
      LSQL = LSQL & "     WHEN 'T' THEN '테니스 생활체육 - 지도자('+ISNULL(SD_Tennis.dbo.FN_PubName('sd03900'+LeaderType),'')+')'+'<span class=""affiliation"">('+ISNULL(SD_tennis.dbo.FN_TeamNm2('"&obj&"', M.Team),'')+')</span>'"
      LSQL = LSQL & "     WHEN 'R' THEN " 
      LSQL = LSQL & "       CASE "
      LSQL = LSQL & "         WHEN SD_Tennis.dbo.FN_TeamNm2('"&obj&"', M.Team2) IS NULL THEN '테니스 생활체육 - 선수<span class=""affiliation"">('+ISNULL(SD_tennis.dbo.FN_TeamNm2('"&obj&"', M.Team),'')+')</span>'"
      LSQL = LSQL & "       ELSE '테니스 생활체육 - 선수<span class=""affiliation"">('+ISNULL(SD_tennis.dbo.FN_TeamNm2('"&obj&"', M.Team),'')+' / '+ISNULL(SD_Tennis.dbo.FN_TeamNm2('"&obj&"', M.Team2),'')+')</span>'"
      LSQL = LSQL & "       END"  
      LSQL = LSQL & "     WHEN 'D' THEN '테니스 일반' "  
      LSQL = LSQL & "   END PlayerRelnNm "
      LSQL = LSQL & " FROM [SD_Tennis].[dbo].[tblMember] M"
      LSQL = LSQL & "   left join [SD_Tennis].[dbo].[tblPlayer] P on M.PlayerIDX = P.PlayerIDX"
      LSQL = LSQL & "     AND P.SportsGb = '"&obj&"' "
      LSQL = LSQL & "     AND P.DelYN = 'N' "
      LSQL = LSQL & " WHERE M.DelYN = 'N' "
      LSQL = LSQL & "   AND M.SportsType = '"&obj&"' "
      LSQL = LSQL & "   AND M.EnterType = 'A' "
      LSQL = LSQL & "   AND M.SD_UserID = '"&request.Cookies("SD")("UserID")&"' " 
      LSQL = LSQL & "   AND M.MemberIDX = '"&valIDX&"' "  
      LSQL = LSQL & " ORDER BY M.EnterType "
      LSQL = LSQL & "   ,M.PlayerReln "
      
  '       response.Write LSQL
      
      SET LRs = DBCon3.Execute(LSQL)
      IF Not(LRs.Eof or LRs.bof) Then
        txt_JoinUs = txt_JoinUs &LRs("PlayerRelnNm")'&"("&LRs("MemberIDX")&")"
      END IF      
        LRs.Close
      SET LRs = Nothing
  
    END SELECT
  
    Info_JoinUsTxt = txt_JoinUs 
  
  END FUNCTION

  '정식오픈시 주석해제처리
' dim txt_Name : txt_Name = Info_JoinUsTxt(SportsGb, COOKIE_MEMBER_IDX())
  
  ' response.Write Info_JoinUsTxt(SportsGb)
%>
<script>
  //종목별 회원가입 계정카운트 조회
  //1개일 경우는 계정전환아이콘, 메뉴 출력하지 않음
  function chk_JoinUser_COUNT(obj){
  
    var strAjaxUrl = "../../../sdmain/ajax/chk_GameIDSET.asp";
    
    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',     
      data: { 
        SportsType  : obj
      },    
      success: function(retDATA) {
      
        console.log(retDATA);
        
        if(retDATA){
        
          var strcut = retDATA.split("|");          
          
          if(strcut[0] == "TRUE") {   
            if(strcut[1]>1) {
              $('.id_change').show();   //mypage/mypage.asp [id=div_change]
              $('#div_change').show();   //include/gnbType/player_gnb.asp     
              $('.tg_pop').show();    //include/gnbType/player_gnb.asp
              
            }
            else{
              $('.id_change').hide();   //include/gnbType/player_gnb.asp
              $('.tg_pop').hide();    //include/gnbType/player_gnb.asp
              $('#div_change').hide();  //mypage/mypage.asp [id=div_change]        
            }
          }           
        }
      }, 
      error: function(xhr, status, error){           
        if(error!=""){
          alert ("오류발생! - 시스템관리자에게 문의하십시오!");     
          return;
        }
      }
    });   
  }
  
  $(document).ready(function () { 
    //종목별 회원가입 계정카운트 조회
    //1개일 경우는 계정전환아이콘, 메뉴 출력하지 않음
    //chk_JoinUser_COUNT('<%=request.Cookies(SportsGb)("SportsGb")%>');
  });

</script>
<div class="gnb <%=Type_Class%>" id="gnb">
  <!-- <div class="gnb-box"> -->
    <!-- S: gnb-header -->
    <div class="gnb-header clearfix">
      <!-- S: profile 사진 -->
      <!-- 베타용 프로필, 오픈 시 아래 내용 출력하기 -->
      <div class="profile">
        <img id="imgGnb" src="../images/include/gnb/profile_tennis.png" alt="프로필 사진">
        <!-- <img id="imgGnb" src="<%=decode(Request.Cookies(SportsGb)("PhotoPath"), 0)%>" alt="프로필 사진"> -->
      </div>
      <!-- E: profile 사진 -->
      <!-- S: 환영, 로그아웃 -->

      <div class="welcome">     
        <!-- 베타용, 오픈 시 아래 내용 출력하기 -->
        <h2>방문을 환영합니다.</h2>
        <!-- <h2><span><%=Request.Cookies(SportsGb)("UserName")%></span> 님</h2> -->
        <span class="user_type"><%=txt_Name%></span>
        <!-- <a href="javascript:chk_logout();" class="login">로그아웃</a> -->
      </div>
      <!-- E: 환영, 로그아웃 -->
      <!-- S: gnb icon -->
      <div class="gnb-icon clearfix" >
        <!-- <a href="../Main/main.asp">
          <img src="../images/include/gnb/home@3x.png" alt="홈으로 이동">
        </a>
        <a href="#" class="close-btn">
          <img src="../images/include/gnb/X@3x.png" alt="닫기">
        </a> -->
        
        <!-- <a href="#" class="id_change" data-toggle="modal" data-target=".change_account">
          <i class="fa fa-refresh"></i>
        </a> -->

        <a href="#" class="id_change btn_not_yet">
          <i class="fa fa-refresh"></i>
        </a>
        
        
        <a href="../mypage/mypage.asp" class="ic_mypage btn_not_yet">
          <img src="../images/main/ic_people_disable@3x.png" alt="마이페이지">
        </a>
        <!-- <span class="tg_pop">다른 계정으로 쉽게 <br> 전환할 수 있습니다.</span> -->
      </div>
      <!-- E: gnb icon -->

      <!-- S: top_list -->
      <ul class="top_list">
        <li>
          <a href="#" class="btn_not_yet">
            <span class="ic_deco">
              <i class="fa fa-calendar-o"></i>
            </span>
            <span class="txt">나의훈련일정</span>
          </a>
        </li>
        <li>
          <a href="../Stats/stat-record.asp" class="btn_not_yet">
            <span class="ic_deco">
              <i class="fa fa-bar-chart"></i>
            </span>
            <span class="txt">나의통계</span>
          </a>
        </li>
        <li>
          <a href="#" class="btn_not_yet">
            <span class="ic_deco">
              <i class="fa fa-star-o"></i>
            </span>
            <span class="txt">메모리</span>
          </a>
        </li>
      </ul>
      <!-- E: top_list -->
    </div>
    <!-- E: gnb-header -->

    <!-- S: gnb-icon-list -->
    <div class="gnb-icon-list list-4">
      <h2>나의 다이어리</h2>
      <ul class="flex">
        <li>
          <a href="#" class="btn_not_yet">
            <span class="img_box">
              <img src="../images/include/gnb/match_diary_disable@3x.png" alt>
            </span>
            <span class="txt">대회일지</span>
          </a>
        </li>
        <li>
          <a href="#" class="btn_not_yet">
            <span class="img_box">
              <img src="../images/include/gnb/train_diary_disable@3x.png" alt>
            </span>
            <span class="txt">훈련일지</span>
          </a>
        </li>
        <li>
          <a href="#" class="btn_not_yet">
            <span class="img_box">
              <img src="../images/include/gnb/physic_diary_disable@3x.png" alt>
            </span>
            <span class="txt">체력측정</span>
          </a>
        </li>
        <li>
          <a href="#" class="btn_not_yet">
            <span class="img_box">
              <img src="../images/include/gnb/injury_diary_disable@3x.png" alt>
            </span>
            <span class="txt">부상정보</span>
          </a>
        </li>
      </ul>
    </div>
    <!-- E: gnb-icon-list -->

    <!-- S: gnb-list -->
    <div class="gnb-list">
      <h2>대회정보</h2>
      <ul class="clearfix">
        <li>
          <!--<a href="../Result/institute-search.asp">-->
          <a href="javascript:alert('*2018년 2월 공식런칭*\n보다 완성된 서비스로 찾아뵙겠습니다.\n새해 복 많이 받으세요.');">
            <span class="txt">대회일정/결과</span>
            <span class="r_arr">
              <img src="../images/include/gnb/r_arr@3x.png" alt>
            </span>
          </a>
        </li>
        <li>
          <a href="#" class="btn_not_yet">
            <span class="txt">대회영상모음</span>
            <span class="r_arr">
              <img src="../images/include/gnb/r_arr@3x.png" alt>
            </span>
          </a>
        </li>
        <li>
          <a href="../Record/record-srch-win.asp" class="btn_not_yet">
            <span class="txt">경기기록실</span>
            <span class="r_arr">
              <img src="../images/include/gnb/r_arr@3x.png" alt>
            </span>
          </a>
        </li>
        <li>
          <a href="../Analysis/analysis-match-result.asp" class="btn_not_yet">
            <span class="txt">선수분석</span>
            <span class="r_arr">
              <img src="../images/include/gnb/r_arr@3x.png" alt>
            </span>
          </a>
        </li>
      </ul>
    </div>
    <!-- E: gnb-list -->

    <!-- S: gnb-list -->
    <div class="gnb-list">
      <h2>자료실</h2>
      <ul class="clearfix">
        <li>
          <a href="#" class="btn_not_yet">
            <span class="txt">뉴스</span>
            <span class="r_arr">
              <img src="../images/include/gnb/r_arr@3x.png" alt>
            </span>
          </a>
        </li>
        <li>
          <a href="#" class="btn_not_yet">
            <span class="txt">동영상</span>
            <span class="r_arr">
              <img src="../images/include/gnb/r_arr@3x.png" alt>
            </span>
          </a>
        </li>
        <li>
          <a href="#" class="btn_not_yet">
            <span class="txt">칼럼리스트</span>
            <span class="r_arr">
              <img src="../images/include/gnb/r_arr@3x.png" alt>
            </span>
          </a>
        </li>
        <li>
          <a href="#" class="btn_not_yet">
            <span class="txt">애널리스트</span>
            <span class="r_arr">
              <img src="../images/include/gnb/r_arr@3x.png" alt>
            </span>
          </a>
        </li>
      </ul>
    </div>
    <!-- E: gnb-list -->

    <!-- S: gnb-list -->
    <div class="gnb-list">
      <h2>커뮤니티</h2>
      <ul class="clearfix">
        <li>
          <a href="#" class="btn_not_yet">
            <span class="txt">파트너찾기</span>
            <span class="r_arr">
              <img src="../images/include/gnb/r_arr@3x.png" alt>
            </span>
          </a>
        </li>
        <li>
          <a href="#" class="btn_not_yet">
            <span class="txt">레슨코치 찾기</span>
            <span class="r_arr">
              <img src="../images/include/gnb/r_arr@3x.png" alt>
            </span>
          </a>
        </li>
        <li>
          <a href="#" class="btn_not_yet">
            <span class="txt">난타모집</span>
            <span class="r_arr">
              <img src="../images/include/gnb/r_arr@3x.png" alt>
            </span>
          </a>
        </li>
        <li>
          <a href="#" class="btn_not_yet">
            <span class="txt">동호회 소개</span>
            <span class="r_arr">
              <img src="../images/include/gnb/r_arr@3x.png" alt>
            </span>
          </a>
        </li>
      </ul>
    </div>
    <!-- E: gnb-list -->

    <!-- S: gnb-icon-list -->
    <div class="gnb-icon-list list-3">
      <h2>게시판</h2>
      <ul class="flex">
        <li>
          <a href="../Board/notice-list.asp">
            <span class="img_box">
              <img src="../images/include/gnb/notice_board@3x.png" alt>
            </span>
            <span class="txt">공지사항</span>
          </a>
        </li>
        <li>
          <a href="../Board/qa_board.asp" class="btn_not_yet">
            <span class="img_box">
              <img src="../images/include/gnb/qa_board_disabled@3x.png" alt>
            </span>
            <span class="txt">질문과답변</span>
          </a>
        </li>
        <li>
          <a href="../Board/faq.asp">
            <span class="img_box">
              <img src="../images/include/gnb/faq_board@3x.png" alt>
            </span>
            <span class="txt">자주하는 질문</span>
          </a>
        </li>
      </ul>
    </div>
    <!-- E: gnb-icon-list -->

    <!-- S: gnb-footer -->
    <div class="gnb-footer">
      <ul class="clearfix">
        <li class="r-bar">
          <a href="../Map/company.asp">회사소개</a>
        </li>
        <li class="r-bar">
          <a href="../Map/access.asp">이용약관</a>
        </li>
        <li class="r-bar">
          <a href="../Map/personal.asp">개인정보처리방침</a>
        </li>
        <!-- <li>
          <a href="../Map/info-map.asp">광고문의</a>
        </li> -->
      </ul>

      <p class="bot_info">
        Copyright &copy;WIDLINE Corp.<br>
        All Right Reserved.<br>
        Sports Diary <span class="bluy">오픈베타서비스</span>
      </p>
    </div>

    <!-- E: gnb-footer -->

    <!-- S: gnb_ctr -->
    <div class="gnb_ctr">
      <ul class="clearfix">
        <li class="idx_link">
          <a href="http://sdmain.sportsdiary.co.kr/sdmain/index.asp">
            <img src="../images/include/gnb/ic_event.png" alt="종목">
          </a>
        </li>
        <li>
          <a href="../main/index.asp">
            <img src="../images/include/gnb/ic_home@3x.png" alt="홈으로 이동">
          </a>
        </li>
        <li>
          <a href="#" class="close-btn">
            <img src="../images/include/gnb/ic_x@3x.png" alt="닫기">
          </a>
        </li>
      </ul>
    </div>
    <!-- E: gnb_ctr -->
  </div>
  <!-- E: gnb-box -->

  <!-- S: tops top-btn -->
  <div class="tops btn-div">
    <a href="#" class="top_btn">TOP</a>
  </div>
  <!-- E: tops top-btn -->

  <!-- S: 계정 전환 모달 -->
  <!-- #include file="./change_modal.asp" -->
  <!-- E: 계정 전환 모달 -->