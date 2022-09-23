<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file='./include/head.asp' -->
	<!-- #include file="./include/config.asp" -->
	<!-- <link rel="stylesheet" href="/front/css/mypage/user_account.css"> -->

	<%
		'로그인하지 않았다면 login.asp로 이동
		Check_Login()

		dim SportsType	: SportsType = fInject(trim(request("SportsType")))
		dim cnt_JoinUs  : cnt_JoinUs = 0									 	'가입계정 카운트
		dim txt_JoinUs															'해당 종목 가입된 계정목록 html
		dim LRs, LSQL

		IF SportsType = "" Then
			response.write "<script>"
			response.write "	alert('잘못된 접근입니다. 확인 후 다시 이용하세요.');"
			response.write "	history.back();"
			response.write "</script>"
			response.end
		End IF

		txt_JoinUs = "				<h3>"&ReplaceSportsGbText(SportsType)&"</h3>"
		txt_JoinUs = txt_JoinUs & "	<ul class='clearfix'>"

		SELECT CASE SportsType
			CASE "judo" : SET LRs = DBCon.Execute(INFO_QUERY_JOINACCOUNT(SportsType, "ACCOUNTSET"))
			CASE Else  	: SET LRs = DBCon3.Execute(INFO_QUERY_JOINACCOUNT(SportsType, "ACCOUNTSET"))
		END SELECT

		IF Not(LRs.Eof or LRs.bof) Then
			Do Until LRs.Eof
				cnt_JoinUs = cnt_JoinUs + 1

				IF LRs("SD_GameIDSET") = "Y" Then
					txt_JoinUs = txt_JoinUs & " <li><a href='#' class='btn btn-default on' data-id='"&LRs("MemberIDX")&"'>"&LRs("PlayerRelnNm")&"</a></li>"
				Else
					txt_JoinUs = txt_JoinUs & " <li><a href='#' class='btn btn-default' data-id='"&LRs("MemberIDX")&"'>"&LRs("PlayerRelnNm")&"</a></li>"
				End IF

				LRs.movenext
			Loop
		Else
			txt_JoinUs = "<li>가입된 회원계정이 없습니다.</li>"
		END IF
			LRs.Close
		SET LRs = Nothing

		txt_JoinUs = txt_JoinUs & "</ul>"

	%>
	<script>
		/*
		//종목메인 계정 선택유무 체크
		function chk_Submit(valIDX){

			//alert($("li").hasClass("on"));
			if(!$('li').find('a').hasClass('on')) {
				$('#join_IDX').val('');
			}
			else{
				$('#join_IDX').val(valIDX);
			}
		}
		*/

		//종목메인 계정설정
		function SET_JoinUserID(){
			//console.log($('#join_IDX').val());

			if(!$('#join_IDX').val()){
				alert('종목메인계정으로 사용할 계정을 선택해 주세요.');
				return;
			}


			var strAjaxUrl = './ajax/user_account_type.asp';
			var join_IDX = $('#join_IDX').val();
			var SportsType = $('#SportsType').val();

			$.ajax({
				url: strAjaxUrl,
				type: 'POST',
				dataType: 'html',
				data: {
					SportsType  : SportsType
					,join_IDX   : join_IDX
				},
				success: function(retDATA) {

					//console.log(retDATA);

					if(retDATA){

						var strcut = retDATA.split('|');

						if(strcut[0] == 'TRUE') {
							alert('선택한 계정을 종목메인계정으로 설정을 하였습니다.');
							$(location).attr('href', './user_account.asp');
						}
						else{ //FALSE
							var txtMsg='';

							switch(strcut[1]){
								case '66' 	: txtMsg = '종목메인 계정설정을 완료하지 못하였습니다.\n확인 후 다시 이용하세요.'; break;
								default		: txtMsg = '잘못된 접근입니다.\n확인 후 다시 이용하세요.';
							}
							alert(txtMsg);
							return;
						}
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
	</script>
</head>
<body>
<div class="l">
	<input type="hidden" id="join_IDX" name="join_IDX" />
	<input type="hidden" id="SportsType" name="SportsType" value="<%=SportsType%>" />

	<div class="l_header">
		<div class="m_header s_sub">
			<!-- #include file="./include/header_back.asp" -->
			<h1 class="m_header__tit">종목 메인계정 설정</h1>
			<!-- #include file="./include/header_home.asp" -->
		</div>
	</div>


  <!-- S: sub sel_user_type -->
  <div class="l_content m_scroll sub sel_user_type [ _content _scroll ]">
    <section>
      <%=txt_JoinUs%>
    </section>

    <!-- S: cta -->
    <div class="cta">
      <%IF cnt_JoinUs > 0 Then%>
      <a href="javascript:SET_JoinUserID();" class="btn btn-ok">저장</a>
      <%Else%>
      <a href="javascript:history.back()" class="btn btn-ok">돌아가기</a>
      <%End IF%>
    </div>
    <!-- E: cta -->
  </div>
  <!-- E : sub sel_user_type -->


  <!-- include file="../include/bottom_menu.asp" -->
  <!-- include file= "../include/bot_config.asp" -->
</div>

<script>

	function tabSelType(){
		var $selBtn = $('.sel_user_type section ul .btn');
		var $selected = null;


		$selBtn.each(function(){
			if ($(this).hasClass('on')) {
				$('#join_IDX').val($(this).attr('data-id'));
				//console.log($('#join_IDX').val());
				return;
			}
		})

		$selBtn.click(function() {

			if($(this).hasClass('on')) {
				$(this).removeClass('on');
				$('#join_IDX').val('');
				return;
			}

			$selBtn.filter('.on').removeClass('on');

			if ($selected) {
				$selected.removeClass('on');
			}

			$selected = $(this);
			$selected.addClass('on');
			$('#join_IDX').val($(this).attr('data-id'));
		});
	}

	tabSelType();

</script>
</body>
</html>
