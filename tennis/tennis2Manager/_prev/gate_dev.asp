<!DOCTYPE HTML>
<html lang="en">
<head>
<meta charset="utf-8">
<title>SportsDiary Admin</title>
<script type="text/javascript" src="/Manager/Script/jquery.1.11.3.min.js"></script>
<script type="text/javascript" src="/Manager/Script/common.js"></script>
<script type="text/javascript" src="/Manager/Script/popup.js"></script>
<script type="text/javascript">
function chk_login(){
	var f = document.login_frm;
	if(f.UserID.value==""){
		alert("아이디를 입력해 주세요.");
		f.UserID.focus();
		return false;
	}
	if(f.UserPass.value==""){
		alert("패스워드를 입력해 주세요.");
		f.UserPass.focus();
		return false;
	}


	var UserID     = f.UserID.value;
	var UserPass   = f.UserPass.value;
	var strAjaxUrl = "/Manager/ajax/login_ok.asp";
	var retDATA="";
	 
	 $.ajax({
		url: strAjaxUrl,
		type: 'POST',
		dataType: 'html',				
		data: { UserID: UserID, UserPass: UserPass },		
		success: function(retDATA) {
			if(retDATA){
				//document.fBottom.popupClose("btnsave","btnsave","");
				if (retDATA=='TRUE') {
					location.href="/Manager/Main.asp";
				}
				else {
				alert('등록된 정보가 없습니다.');								
				}
			}
		}, error: function(xhr, status, error){						
			//parent.fBottom.popupClose("btnsave","btnsave","");
			alert ("오류발생! - 시스템관리자에게 문의하십시오!");			
		}
	});	


}
</script>
</head>
<body>
<form method="post" name="login_frm">
<table>
	<tr>
		<td>아이디</td>
		<td><input type="text" name="UserID" id="UserID" tabindex="1"/></td>
	</tr>
	<tr>
		<td>패스워드</td>
		<td><input type="password" name="UserPass" id="UserPass" tabindex="2" /></td>
	</tr>
	<tr>
		<td colspan="2"><input type="button" value="로그인" tabindex="3" onclick="chk_login();"></td>
	</tr>
</table>
</form>
<!-- bottom -->
<frame id="fBottom" name="fBottom" src="/Manager/include/bottom.asp" scrolling="no">
<!--// bottom -->
<body>
<!--#include virtual="/Manager/Include/footer.asp"-->