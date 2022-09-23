<!--#include virtual="/Manager/Common/common_header.asp"-->
<%
  Response.Write Request.Cookies("HostCode")

  If Request.Cookies("UserID") = "" Then
    Response.Write "<script>top.location.href='/Manager/gate.asp?Refer_Url="&Refer_URL&"'</script>"
    Response.End
  End If 
%>
<script>
function open_pop(){
  window.open('/Manager/View/TournamentInfo.asp','tournament','width=1335 height=775 scrollbars=yes');
}
function open_pop2(){
  window.open('/Manager/View/yyj2.asp','tournament','width=1335 height=775 scrollbars=yes');
}
</script>
<body style="background:#3e4e68">
      <!-- S : container -->
      <div id="container">
        <!-- S : navi -->
        <nav>
          <div id="left-navi">
            <%
              'HostCode가 없으면 최고관리자
              'If Request.Cookies("HostCode") = "" Then 
			  If Request.Cookies("HostCode") = "" and request.Cookies("UserID") <> "sdmanager" Then
            %>
            <!--최고관리자 메뉴-->
            <div class="depth">
              <h2>최고관리자</h2>
              <!-- 2 depth -->
              <ul>
                <li class="depth-2">
                  관리자관리
                  <!-- 3 depth -->
                  <ul class="depth-3">
                    <!--<li><a href="/Manager/View/AdminGroup.asp" target="fPage">그룹관리</a></li>-->
                    <li><a href="/Manager/View/AdminList.asp" target="fPage">관리자리스트</a></li>
                    <li><a href="/Manager/View/TabletRegist.asp" target="fPage">태블릿신청</a></li>
                    <li><a href="/manager/view/DayRegistMember.asp" target="fPage">일별가입자수</a></li>
                    <li><a href="/manager/view/MonthRegistPage.asp" target="fPage">월별페이지사용통계</a></li>
                    <li><a href="/manager/view/APPManager.asp" target="fPage">APP관리</a></li>
                  </ul>
                  <!--// 3 depth -->
                </li>
              </ul>
              <!--// 2 depth -->
            </div>
            <!-- 1 depth -->
            <!--최고관리자 메뉴-->
            <div class="depth">
              <h2>회원관리</h2>
              <!-- 2 depth -->
              <ul>
                <li class="depth-2">
                  회원관리
                  <!-- 3 depth -->
                  <ul class="depth-3">
                    <li><a href="/Manager/View/TeamInfo.asp" target="fPage">팀코드관리</a></li>
                    <li><a href="/Manager/View/MemberInfo.asp" target="fPage">회원명단</a></li>
                    <li><a href="/Manager/View/PlayerInfo.asp" target="fPage">선수명단</a></li>
                    <li><a href="/Manager/View/LeaderInfo.asp" target="fPage">지도자명단</a></li>
                   <!-- <li><a href="#">선수코드관리</a></li>
                    <li><a href="/Manager/View/PlayerInfo.asp" target="fPage">개인프로필</a></li>-->
                  </ul>
                  <!--// 3 depth -->
                </li>
              </ul>
              <!--// 2 depth -->
            </div>
            <%
              End If 
            %>
            <!--// 1 depth -->
            <!-- 1 depth -->

            <div class="depth">
              <h2>대회관리</h2>
              <ul>
                <li class="depth-2"><a href="/Manager/View/ChampionshipInfo.asp" target="fPage">대회정보관리</a></li>
                <!--<li class="depth-2"><a href="/Manager/View/ChampionshipLevel.asp" target="fPage">대회체급관리</a></li>-->
                <!--<li class="depth-2"><a href="/Manager/View/MatchInfo.asp" target="fPage">대진표관리</a></li>-->
                <!--<li class="depth-2"><a href="javascript:open_pop()">대진표추첨2</a></li>-->
                <li class="depth-2"><a href="javascript:open_pop2()">대진표추첨</a></li>
                <li class="depth-2"><a href="/manager/tourney/tourney.asp" target="fPage">대진표결과 출력</a></li>
                <li class="depth-2"><a href="/manager/tourney/enter-score.asp" target="fPage">결과기록지 출력</a></li>
                <li class="depth-2"><a href="/manager/tourney/OperatingMedal.asp" target="fPage">입상현황 출력</a></li>
								<li class="depth-2"><a href="/Manager/View/DayList.asp" target="fPage">대회순서등록</a></li>
                  <li class="depth-2"><a href="/Manager/View/ChampionshipOperate.asp" target="fPage">대회순서현황</a></li>
                  <li class="depth-2"><a href="/Manager/View/ChampionshipOPenData.asp" target="fPage">대회열람자료</a></li>
                <%
                  '종목이 유도인 경우에만 노출
                  If Request.Cookies("SportsGb") = "judo" Then 
                %>
                <li class="depth-2"><a href="/Manager/View/GameTeamInfo.asp" target="fPage">단체전명단</a></li>
								
                <%
                  '종목이 레슬링인 경우에만 노출
                  ElseIf Request.Cookies("SportsGb") = "wres" Then 
                %>
                <li class="depth-2"><a href="/Manger/View/MatchGameList.asp">경기리스트</a></li>
                <%
                  Else
                %>
                <li class="depth-2"><a href="/Manager/View/GameTeamInfo.asp" target="fPage">단체전명단</a></li>
                <%
                  End If 
                %>
              </ul>             
            </div>
            <%
              'HostCode가 없으면 최고관리자
              'If Request.Cookies("HostCode") = "" Then 
			   If Request.Cookies("HostCode") = "" and request.Cookies("UserID") <> "sdmanager" Then
            %>
            <div class="depth">
              <h2>경기관리</h2>
                <ul>
                  <li class="depth-2"><a href="/Manager/View/DayListWres.asp" target="fPage">리그전순서등록</a></li>
                  <li class="depth-2"><a href="/Manager/View/MatchUpload.asp" target="fPage">동영상관리</a></li>
                  <li class="depth-2"><a href="/Manager/View/ChampionshipiNit.asp" target="fPage">경기초기화</a></li>
                  <li class="depth-2"><a href="/Manager/View/ChampionshipGroupiNit.asp" target="fPage">단체전초기화</a></li>
                  <li class="depth-2"><a href="/Manager/View/ChampionshipNotAttend.asp" target="fPage">불참처리</a></li>  
                  <li class="depth-2"><a href="/Manager/View/ChampionshipWeightFail.asp" target="fPage">계체탈락</a></li>  
									<%If Request.Cookies("SportsGb") = "wres" Then %>
									<li class="depth-2"><a href="/Manager/View/ChampionshipRCheif_View.asp" target="fPage">심판관리</a></li>
									<%End If%>
                </ul>
            </div>
            <div class="depth">
              <h2>게시판관리</h2>
              <ul>
                <!--<li class="depth-2"><a href="#">회원관리</a></li>-->
                    <li class="depth-2">
                      <a href="/Manager/board/noticeBoard.asp" target="fPage">공지사항</a>
                    </li>
                    <li class="depth-2">
                      <a href="/Manager/board/qnaBoard.asp" target="fPage">Q&amp;A 게시판</a>
                    </li>
                    <li class="depth-2">
                      <a href="/Manager/board/faqBoard.asp" target="fPage">FAQ 게시판</a>
                    </li>
                <!--<li class="depth-2"><a href="#">경기관리</a></li>-->
              </ul>
            </div>
            <%
              End If 
            %>
            <!--// 1 depth -->
          </div>
            <!-- 1 depth -->
            <div class="depth">
              <h2><a href="#">오프라인대회관리</a></h2>
              <ul class="depth-2">
                <li class="depth-2"><a href="/Manager/View/Offline_ChampionshipLevel.asp" target="fPage">대회체급관리</a></li>                
              </ul>
            </div>
            <!--// 1 depth -->
          </div>
        </nav>
        <!-- E : navi -->
</body>