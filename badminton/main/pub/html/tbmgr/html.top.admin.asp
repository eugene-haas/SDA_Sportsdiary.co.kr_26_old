<%
'#################################
'		로그인여부 체크, 상단 view 영역
 '#################################
%>
<%If iLoginID <> "" Then%>
<%'=reqjson%>
	<script type="text/javascript">
	<!--
		document.body.innerHTML = "<form method='post' name='sform'><input type='hidden' name='p'></form>";
		//px.obj = <%=reqjson%>;
		//px.obj.returnurl = "<%=returnpage%>";
		//px.go(px.obj, "<%=loginurl%>");
	//-->
	</script>
</div>
</body>
</html>
<%
Response.end
End if%>

  <div class="head">
    <!-- S: top-head -->
    <div class="top-head">
      <div class="pd-15">
        <h1 class="logo"><a href="/index2.asp">Sdamall Admin Home</a> (<%=USER_IP%>)</h1>
      </div>
    </div>
    <!-- E: top-head -->

    <!-- S: mobile-gnb -->
    <div class="mobile-gnb">

    </div>
    <!-- E: mobile-gnb -->
  </div>
