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
			<a href="./index.asp" target="fPage" class="mgr10"><span class="glyphicon glyphicon-home" aria-hidden="true"></span> 수영관리자</a>
			<%If Cookies_aIDX = "" then%>
			<a href="javascript:mx.login();" id="login" class="btn btn-info" title="Login">Login</a>
			<%else%>
			<a href="./logout.asp" id="login" class="btn btn-info" title="Login">Logout</a>
			<%End if%>
			<a href="javascript:alert('회원정보수정');" id="memberinfo" class="btn btn-info mgr10" title="회원정보관리">회원정보관리</a>
			<span class="txt-member"><%=Request.Cookies("UserName")%> (<%=USER_IP%>)   <%=Cookies_aNM%></span>
		</div>
	</div>
</header>


<form method='post' name='sform'><input type='hidden' name='p'></form>
<form method='post' name='ssform' style="display:none;"><input type='hidden' name='p' id='p'></form>


<div class="backLayer" style="z-index:999;" > </div>
<div id="loadingDiv" style="z-index:999;"></div>


<div id="myModal" class="modal fade" role="dialog" aria-labelledby="myModalLabel"></div>

<div id="modalB" class="modal fade" role="dialog" aria-labelledby="myModalLabel">
	<!-- <div class="modal-dialog">
		<div id="modalB_inner" class="modal-content">

		</div>
	</div> -->
</div>

<div id="modalS" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
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
