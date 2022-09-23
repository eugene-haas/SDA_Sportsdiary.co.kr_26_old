
<!--#include file="../../dev/dist/config.asp"-->
<!--#include file="../../include/head.asp"-->

<%

	AdminGameTitlee = fInject(Request.cookies("AdminGameTitle"))
	AdminGameTitle = decode(AdminGameTitlee,0)
	Authority = fInject(crypt.DecryptStringENC(Request.cookies(global_HP)("Authority")))
%>

<script>
  var locationStr = "Admin_Index";
</script>

  <div id="content">

  <!-- S: 네비게이션 -->
  <div	class="navigation_box">
    <span class="intro_title">Sports Diary Bike</span><p></p><%=AdminGameTitle %>
  </div>
  <!-- E: 네비게이션 -->
  <div class="search_top community">
    <div ><div>
  </div>
<!--#include file="../../include/footer.asp"-->
