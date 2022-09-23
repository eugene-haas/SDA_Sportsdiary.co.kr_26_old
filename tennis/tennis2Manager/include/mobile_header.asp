<% '로그인 체크
If ck_id = "" Then
	Response.redirect "/pub/login.asp"
	Response.end
End If
%>

<header class="header clear">
  <div class="header__side-con">
    <%If ADGRADE > 600 then%><button class="header__side-con__btn" type="button" name="button" onclick="location.href='/adminlist.asp';">대회정보관리<%'=sitecode%></button><%End if%>
    <a href="./mobile_index.asp" class="header__side-con__btn header__btn-home t_ico"><img src="./Images/mobile_ico_home.svg" alt="홈"></a>
    <button onclick="closeModal()" class="header__side-con__btn header__btn-cancel t_ico"><img src="./Images/mobile_ico_close.svg" alt="닫기"></a>
  </div>
  <h1 class="header__main-con">대회 리스트</h1>
  <div class="header__side-con">
    <button class="header__side-con__btn" type="button" name="button" onclick="location.href='/pub/logout.asp';">로그아웃</button>
    <button class="header__side-con__btn header__btn-reset t_ico"><img src="./Images/mobile_ico_reset.svg" alt="새로고침"></button>
  </div>
</header>
