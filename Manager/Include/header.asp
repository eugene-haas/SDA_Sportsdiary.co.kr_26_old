<!--#include virtual="/Manager/Common/common_header.asp"-->
<!--#include virtual="/Manager/Library/config.asp"-->
<%
'관리자 로그인 체크
ChkAgtLogin("/Manager/gate.asp")
%>
<script type="text/javascript">
function logout(){
	location.href="/Manager/logout.asp";	
}
</script>
		<div class="wrap">
			<!-- S : header -->
			<header>
				<div id="header">
					<div class="top-tp">
						<div class="logo">
							<h1><a href="/Manager/View/Main.asp"  target="fPage"><img src="../Images/sportsdiary_judo_B.png" alt="스포츠 다이어리" width="145" height="45"/></a></h1>
						</div>
						<div class="top-banner">
							배너가 들어갑니다. 771 x 64
						</div>
					</div>
					<div class="top-btm">
						<p class="home"><a href="/Manager/View/Main.asp" target="fPage"><i class="fa fa-home" aria-hidden="true"></i> Sports Diary HOME</a></p>
						<ul class="btn-member-list">
							<li><a href="javascript:logout();" class="btn-logout" title="Log Out">Log Out</a></li>
							<li><a href="javascript:alert('회원정보수정');" class="btn-member" title="회원정보관리"><i class="fa fa-user" aria-hidden="true"></i></a></li>
						</ul>
						<p class="txt-member">안녕하세요. <%=Request.Cookies("UserName")%>님. 접속을 환영합니다.</p>
					</div>
				</div>
			</header>
			<!-- S : header -->