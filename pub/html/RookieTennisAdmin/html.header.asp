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

<header>
	<div id="header" >

		<div class="top-tp">

		</div>
		<div class="top-btm" style="background:orange;">
			<p class="home"><a href="./index.asp" target="fPage"><i class="fa fa-home" aria-hidden="true"></i> 루키홈</a></p>
			<ul class="btn-member-list">
				<li>
				<%If Cookies_aIDX = "" then%>
				<a href="javascript:mx.login();" id="login" class="btn-logout" title="Login">Login</a>
				<%else%>
				<a href="./logout.asp" id="login" class="btn-logout" title="Login">Logout</a>
				<%End if%>
				</li>
				<li><a href="javascript:alert('회원정보수정');" id="memberinfo" class="btn-member" title="회원정보관리"><i class="fa fa-user" aria-hidden="true"></i></a></li>
			</ul>
			<p class="txt-member"><%=Request.Cookies("UserName")%> (<%=USER_IP%>)   <%=Cookies_aNM%></p>
		</div>
	</div>
</header>


<form method='post' name='sform'><input type='hidden' name='p'></form>
<form method='post' name='ssform' style="display:none;"><input type='hidden' name='p' id='p'></form>


<div class="backLayer" style="z-index:999;" > </div>
<div id="loadingDiv" style="z-index:999;"></div>


<div id="myModal" class="modal hide fade tourney_admin_modal contest_page" role="dialog" aria-labelledby="myModalLabel"></div>

<div id="modalB" class="modal hide fade tourney_admin_modal contest_page" role="dialog" aria-labelledby="myModalLabel"></div>

<div id="modalS" class="modal hide fade step2modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="z-index:1100">
  <!-- <div class='modal-header game-ctr'>
    <button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
    <h3 id='myModalLabel'>선수 교체</h3>
  </div>

  <div class="modal-body" id="Modaltestbody">
    여기 수정
  </div>
  <div class="modal-footer">
    <button class="btn" data-dismiss="modal" aria-hidden="true">닫기</button>
    <button class="btn btn-primary" onclick="mx.changePlayer()">저장</button>
  </div> -->
</div>

