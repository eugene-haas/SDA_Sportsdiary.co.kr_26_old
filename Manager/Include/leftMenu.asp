<!--#include virtual="/Manager/Common/common_header.asp"-->
<%
	Response.Write Request.Cookies("HostCode")
%>
<script>
function open_pop(){
	window.open('/Manager/View/TournamentInfo.asp','tournament','width=1295 height=775 scrollbars=yes');
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
							If Request.Cookies("HostCode") = "" Then 
						%>
						<!--최고관리자 메뉴-->
						<div class="depth">
							<h2><a href="#">최고관리자</a></h2>
							<!-- 2 depth -->
							<ul>
								<li class="depth-2">
									<a href="#">관리자관리</a>
									<!-- 3 depth -->
									<ul class="depth-3">
										<li><a href="/Manager/View/AdminGroup.asp" target="fPage">그룹관리</a></li>
										<li><a href="/Manager/View/AdminList.asp" target="fPage">관리자리스트</a></li>
									</ul>
									<!--// 3 depth -->
								</li>
							</ul>
							<!--// 2 depth -->
						</div>
						<!-- 1 depth -->
						<!--최고관리자 메뉴-->
						<div class="depth">
							<h2><a href="#">선수관리</a></h2>
							<!-- 2 depth -->
							<ul>
								<li class="depth-2">
									<a href="#">회원관리</a>
									<!-- 3 depth -->
									<ul class="depth-3">
										<li><a href="/Manager/View/PlayerInfo.asp" target="fPage">개인프로필</a></li>
										<li><a href="#">팀코드관리</a></li>
										<li><a href="#">선수코드관리</a></li>
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
							<h2><a href="#">대회관리</a></h2>
							<ul>
								<li class="depth-2"><a href="/Manager/View/ChampionshipInfo.asp" target="fPage">대회정보관리</a></li>
								<!--<li class="depth-2"><a href="/Manager/View/ChampionshipLevel.asp" target="fPage">대회체급관리</a></li>-->
								<!--<li class="depth-2"><a href="/Manager/View/MatchInfo.asp" target="fPage">대진표관리</a></li>-->
								<li class="depth-2"><a href="javascript:open_pop()">대진표추첨</a></li>
								<!--<li class="depth-2"><a href="#">게시판관리</a></li>-->
							</ul>							
						</div>
						<%
							'HostCode가 없으면 최고관리자
							If Request.Cookies("HostCode") = "" Then 
						%>
						<div class="depth">
							<h2><a href="#">경기관리</a></h2>
								<ul>
									<li class="depth-2"><a href="/Manager/View/ChampionshipVideo.asp" target="fPage">동영상관리</a></li>
									<li class="depth-2"><a href="/Manager/View/ChampionshipiNit.asp" target="fPage">경기초기화</a></li>
									<li class="depth-2"><a href="/Manager/View/ChampionshipNotAttend.asp" target="fPage">불참처리</a></li>	
									<li class="depth-2"><a href="/Manager/View/ChampionshipWeightFail.asp" target="fPage">계체탈락</a></li>									
								</ul>
						</div>
						<div class="depth">
							<h2><a href="#">소속관리</a></h2>
							<ul class="depth-2">
								<li class="depth-2"><a href="#">회원관리</a></li>
								<li class="depth-2"><a href="#">게시판관리</a></li>
								<li class="depth-2"><a href="#">경기관리</a></li>								
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