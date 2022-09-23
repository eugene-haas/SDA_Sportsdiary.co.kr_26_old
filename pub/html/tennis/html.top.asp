<%
'#################################
If USER_IP <> "115.68.112.26" Or  USER_IP <> "118.33.86.240" Then '서버아이피가 아니라면
	If ck_id = ""  Then
		Response.redirect "./index.asp"
		Response.end
	 End If
 End if
 '#################################
%>
	
	
	<!-- S: header -->
    <div class="header container-fluid">
      <div class="row">

		<div class="pull-left">
          <a href="<%=homeurl%>" role="button" class="prev-btn"><span class="icon-prev"><i class="fa fa-angle-left" aria-hidden="true"></i></span><%=headtitle%></a>
        </div>

        <!-- S: include header -->
			<div>
			 <h1 class="logo">
			  <%=headimgstr%>
			</h1>
			</div>

			<div class="pull-right">
			  <span class="sd-logo"><img src="images/tournerment/header/logo@3x.png" alt="스포츠 다이어리" width="100"></span>
			  <a href="index.asp" role="button" class="home-link"><span class="icon-home"><i class="fa fa-home" aria-hidden="true"></i></span></a>
			  <a href="javascript:mx.SendPacket(null, {'CMD':mx.CMD_LOGOUT});" class="log-out-btn">
				<span class="ic-deco"><i class="fa fa-power-off" aria-hidden="true"></i></span>
				<span class="txt">로그아웃</span>
			  </a>
			</div>
		<!-- E: include header -->

      </div>
    </div>
    <!-- E: header -->