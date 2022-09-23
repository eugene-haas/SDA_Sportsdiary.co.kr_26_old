<%
'#################################
		Select Case pagename
		Case "login.asp"
			If ck_id <> ""  Then
				Response.redirect "./klist.asp"
				Response.end
			 End If
		Case else
			If ck_id = ""  Then
				Response.redirect "./login.asp"
				Response.end
			 End If
		End Select
 '#################################
%>
<header>
	<div id="header">

		<div class="top-tp">
		</div>
		<div class="top-btm">
			<p class="home"><a href="./index.asp" target="fPage"><i class="fa fa-home" aria-hidden="true"></i> Sports Diary HOME</a></p>
			<ul class="btn-member-list">
				<li>
				<%If ck_id = "" then%>
				<a href="javascript:mx.login();" id="login" class="btn-logout" title="Login">Login</a>
				<%else%>
				<a href="./logout.asp" id="login" class="btn-logout" title="Login">Logout</a>
				<%End if%>
				</li>
				<li><a href="javascript:alert('회원정보수정');" id="memberinfo" class="btn-member" title="회원정보관리"><i class="fa fa-user" aria-hidden="true"></i></a></li>
			</ul>
			<p class="txt-member"><%=Request.Cookies("UserName")%> (<%=USER_IP%>)</p>
		</div>
	</div>
</header>