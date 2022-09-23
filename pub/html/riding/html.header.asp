<%
'#################################
'If USER_IP <> "115.68.112.26" Or  USER_IP <> "118.33.86.240" Then '서버아이피가 아니라면

		Select Case pagename
		Case "admlogin.asp"
			If Cookies_aIDX <> ""  Then
				Response.redirect "/index.asp"
				Response.end
			 End If
		Case else
			If Cookies_aIDX = ""  Then
				Response.redirect "/pub/admlogin.asp"
				Response.end
			 End If
		End Select

'End if
 '#################################
%>

<header class="l_header">
	<div id="header">
		<div>
			<a href="./index.asp" target="fPage" class="btn btn-info mgr20" style="width:160px;"><span class="glyphicon glyphicon-menu-hamburger" aria-hidden="true"></span>&nbsp;&nbsp;KEF ADMIN</a>
			<!-- <a href="javascript:alert('회원정보수정');" id="memberinfo" class="btn btn-info mgr10" title="회원정보관리">회원정보관리</a> -->
			<span class="txt-member" ><%=Cookies_aNM%></span>
			<span style="font-size:12px;">[<%=USER_IP%>]</span>

			<%If Cookies_aIDX = "" then%>
			<a href="javascript:mx.login();" id="login" class="btn btn-primary" title="Login" style="float:right;">Login</a>
			<%else%>
			<a href="/logout.asp" id="login" class="btn btn-primary" title="Login" style="float:right;margin-right:20px;">Logout</a>
			<%End if%>

		</div>
	</div>
</header>


<form method='post' name='sform'><input type='hidden' name='p'></form>
<form method='post' name='ssform' id="ssform" style="display:none;"><input type='hidden' name='p' id='p'></form>


<div class="backLayer" style="z-index:999;" > </div>
<div id="loadingDiv" style="z-index:999;"></div>


<div id="myModal" class="modal fade" data-backdrop="static" role="dialog" aria-labelledby="myModalLabel"></div>

<div id="modalB" class="modal fade" data-backdrop="static" role="dialog" aria-labelledby="myModalLabel">
	<!-- <div class="modal-dialog">
		<div id="modalB_inner" class="modal-content">

		</div>
	</div> -->
</div>

<div id="modalS" class="modal fade" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
</div>
