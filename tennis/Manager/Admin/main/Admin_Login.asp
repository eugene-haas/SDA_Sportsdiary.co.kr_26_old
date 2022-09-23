<!--#include file="../dev/dist/config.asp"-->
<!--#include file="headLogin.asp"-->

<%
  
  AdminYN = fInject(Request("AdminYN"))
	AdminYN = decode(AdminYN,0)
	UserID = fInject(Request("UserID"))
	UserID = decode(UserID,0)

	if AdminYN = "Y" and UserID <> "" then
		response.Redirect("./Admin_List.asp")
	end if

%>

  <script type="text/javascript">

		// BackSpace 키 방지 이벤트
  	$(document).keydown(function (e) {

  		if (e.target.nodeName != "INPUT" && e.target.nodeName != "TEXTAREA") {
  			if (e.keyCode === 8) {
  				return false;
  			}
  		}
  	});

		//window.history.forward(0);

  	function enterkey() {
  		if (window.event.keyCode == 13) {

  			// 엔터키가 눌렸을 때 실행할 내용
  			OK_Link();
  		}
  	}

  	function OK_Link() {

  		// 스마트에디트 아닐때
  		var theForm = document.form1;

  		if (theForm.txtID.value == "") {
  			alert('<%=global_ID_Val %>');
  			return theForm.txtID.focus();
  		}

  		if (theForm.psAdmin.value == "") {
  			alert('<%=global_Pass_Val %>');
  			return theForm.psAdmin.focus();
  		}

  		try {

  			theForm.method = "post";
  			theForm.target = "_self";
  			theForm.action = "./Admin_Login_p.asp";
  			theForm.submit();

  		} catch (e) { }

  	}

  </script>

		<form name="form1" id="form1">
		<div class="admin_login_box">
			<h1 class="logo">
				<img src="./Images/admin_logo.png" alt="KATA Tennis">
			</h1>
			<div class="login_con">
				<div class="login_title">KATA Tennis App Admin</div>
				<div class="in_list">
					<ul>
						<li>
							<span class="l_text">User ID</span>
							<span class="r_con">
								<input type="checkbox" />
								<span>아이디 저장</span>
							</span>
						</li>
						<li>
							<input type="text" id="txtID" name="txtID" class="in_10" />
						</li>
						<li>
							<span>Password</span>
						</li>
						<li>
							<input type="password" id="psAdmin" name="psAdmin" onkeyup="javascript:enterkey();" class="in_10" />
						</li>
					</ul>
				</div>
				<a href="javascript:;" onclick="javascript:OK_Link();" id="btnOK" name="btnOK" class="login_btn">로그인</a>
			</div>
			<p class="copy_text">COPYRIGHT(C) 2011 KOREA JUDO ASSOCIATION. ALL RIGHTS RESERVED.</p>
		</div>
		</form>
  <section>

<!--#include file="footer.asp"-->
