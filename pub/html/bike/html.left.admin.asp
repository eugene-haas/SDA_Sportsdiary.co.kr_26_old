<!-- S: left-gnb -->
<div class="left-gnb">

  <!-- S: top-content -->
  <div class="top-content">

    <div class="user-name">
      <p class="profile-img"><img src="/AdminMain/images/profill-img.png" alt=""></p>
      <div class="r-con"><p class="p-name"><%=iLoginName%> 님</p></div>
    </div>

    <div class="login-btn">
	<%If iLoginID= "" then%>
		<a href="#" class="white-btn">로그인</a>
	<%else%>
		<a href='javascript:px.go(<%=reqjson%>,"<%=logouturl%>");' class="white-btn">로그아웃</a>
	<%End if%>
	</div>
  </div>

<!-- //////////////////////////////////////////////////////////////////////////// -->


  <!-- S: left-menu -->
  <div class="left-menu">
    <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
		<%
			menustr =  setLeftMenu(db, "dbopentypeA",  PAGENAME, iLoginID, logouturl, reqjson, chkrule)
			menustr = Split(menustr,"|")
		%>
   </div>
  </div>
  <!-- E: left-menu -->
</div>

<!-- E: left-gnb -->
