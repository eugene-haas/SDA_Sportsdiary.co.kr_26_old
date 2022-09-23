<!-- #include file='./include/head.asp' -->
<!-- #include file="./include/config.asp" -->
<%
	IF request.Cookies("SD")("MemberIDX") = "" Then
		'response.redirect "./index.asp"
        response.redirect "http://judo.sportsdiary.co.kr/M_Player/Main/index.asp"
		response.end
	End IF
%>
<script type="text/javascript">
	//쿠키정보 저장
	function setCookie (name, value, expires, domain) {
		var todayDate = new Date();
		//  document.cookie = name + "=" + escape (value) + "; path=/; expires=" + expires.toGMTString();
		document.cookie = name + "=" + escape(value) + "; path=/; expires=" + todayDate.toGMTString() + "; domain="+domain+";";
	}


	//통합로그아웃
	function CHK_LOGOUT_PROC(){

	 	var strAjaxUrl = './ajax/Logout.asp';

		$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',
			data: { },
			success: function(retDATA) {

				//console.log('retDATA='+retDATA);

				if(retDATA){
					if (retDATA=='TRUE') {
						var expdate = new Date();
							expdate.setTime(expdate.getTime() - 1); // 쿠키 삭제조건
						var domain = '.sportsdiary.co.kr';

						setCookie('SportsGb', '', expdate, domain);
						setCookie('sd_saveid', '', expdate, domain);
						setCookie('sd_savepass', '', expdate, domain);

						alert('로그아웃 되었습니다.');
						//$(location).attr('href', './index.asp');   //a href
            $(location).attr('href', 'http://sdmain.sportsdiary.co.kr/sdmain/index.asp');   //a href
					}
					else{
						alert('로그아웃중에 오류가 발생하였습니다.');
						history.back();
					}
				}
				else{
					alert('로그아웃중에 오류가 발생하였습니다.');
					history.back();
				}
			},
			error: function(xhr, status, error){
				if(error!=''){
					alert ('오류발생! - 시스템관리자에게 문의하십시오!');
					return;
				}
			}
		});
	}

	$(document).ready(function() {
		CHK_LOGOUT_PROC();
	});
</script>
