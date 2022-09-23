<!DOCTYPE html>
<html lang="ko">
<head>
	<!-- #include file='./include/head.asp' -->
	<!-- #include file='./include/config.asp' -->
	<%
	   	'===================================================================================================
	   	'종목별 메인계정으로 사용할 계정선택 페이지
		'===================================================================================================
	  	'로그인하지 않았다면 login.asp로 이동
		Check_Login()

		dim SportsType  	: SportsType  = fInject(trim(Request("SportsType")))
		dim UserID    		: UserID      = Request.Cookies("SD")("UserID")

		dim txt_JoinUs  '가입회원 목록

	   	'SportsType = "tennis"
		'SportsType = "judo"

	   	IF SportsType = "" OR UserID = "" Then
			Response.Write "<script>alert('잘못된 경로로 접근하셨거나 누락된 항목이 있습니다.'); history.back();</script>"
			Response.End
		End IF

	 	SELECt CASE SportsType
	    	'유도
	    	CASE "judo"
				LSQL =  "     	SELECT M.MemberIDX "
				LSQL = LSQL & "   	,CASE "
				LSQL = LSQL & "     	WHEN M.EnterType = 'E' THEN "
				LSQL = LSQL & "       		CASE PlayerReln  "
				LSQL = LSQL & "         		WHEN 'A' THEN '엘리트 - 보호자(부-'+P.UserName+')'"
				LSQL = LSQL & "         		WHEN 'B' THEN '엘리트 - 보호자(모-'+P.UserName+')'"
				LSQL = LSQL & "         		WHEN 'Z' THEN '엘리트 - 보호자('+PlayerRelnMemo+'-'+P.UserName+')'"
				LSQL = LSQL & "         		WHEN 'R' THEN '엘리트 - 선수('+ISNULL(SportsDiary.dbo.FN_TeamNm2('"&SportsType&"', M.Team),'')+')'"
				LSQL = LSQL & "         		WHEN 'K' THEN '엘리트 - 비등록선수'"
				LSQL = LSQL & "         		WHEN 'S' THEN '엘리트 - 예비후보'"
				LSQL = LSQL & "         		WHEN 'T' THEN '엘리트 - 지도자('+ISNULL(SportsDiary.dbo.FN_PubName('sd03900'+LeaderType),'')+'-'+ISNULL(SportsDiary.dbo.FN_TeamNm2('"&SportsType&"', M.Team),'')+')'"
				LSQL = LSQL & "         		WHEN 'D' THEN '일반' "
				LSQL = LSQL & "      		END "
				LSQL = LSQL & "     	WHEN M.EnterType = 'A' THEN "
				LSQL = LSQL & "       		CASE PlayerReln "
				LSQL = LSQL & "         		WHEN 'A' THEN '생활체육 - 보호자(부-'+P.UserName+')'"
				LSQL = LSQL & "         		WHEN 'B' THEN '생활체육 - 보호자(모-'+P.UserName+')'"
				LSQL = LSQL & "         		WHEN 'Z' THEN '생활체육 - 보호자('+PlayerRelnMemo+'-'+P.UserName+')'"
				LSQL = LSQL & "         		WHEN 'R' THEN '생활체육 - 선수('+ISNULL(SportsDiary.dbo.FN_TeamNm2('"&SportsType&"', M.Team),'')+')'"
				LSQL = LSQL & "         		WHEN 'T' THEN '생활체육 - 지도자('+ISNULL(SportsDiary.dbo.FN_PubName('sd03900'+LeaderType),'')+'-'+ISNULL(SportsDiary.dbo.FN_TeamNm2('"&SportsType&"', M.Team),'')+')'"
				LSQL = LSQL & "        			WHEN 'D' THEN '일반' "
				LSQL = LSQL & "       		END "
				LSQL = LSQL & "    		WHEN M.EnterType = 'K' THEN "
				LSQL = LSQL & "       		CASE PlayerReln "
				LSQL = LSQL & "         		WHEN 'R' THEN '국가대표 - 선수('+ISNULL(SportsDiary.dbo.FN_TeamNm2('"&SportsType&"', M.Team),'')+')'"
				LSQL = LSQL & "         		WHEN 'T' THEN '국가대표 - 지도자('+ISNULL(SportsDiary.dbo.FN_PubName('sd03900'+LeaderType),'')+'-'+ISNULL(SportsDiary.dbo.FN_TeamNm2('"&SportsType&"', M.Team),'')+')'"
				LSQL = LSQL & "       		END "
				LSQL = LSQL & "   	END PlayerRelnNm "
				LSQL = LSQL & " FROM [SportsDiary].[dbo].[tblMember] M"
				LSQL = LSQL & "   	left join [SportsDiary].[dbo].[tblPlayer] P on M.PlayerIDX = P.PlayerIDX AND P.DelYN = 'N' AND P.SportsGb = '"&SportsType&"' "
				LSQL = LSQL & " WHERE M.DelYN = 'N' "
				LSQL = LSQL & "   	AND M.SportsType = '"&SportsType&"' "
				LSQL = LSQL & "   	AND M.SD_UserID = '"&UserID&"' "
				LSQL = LSQL & " ORDER BY M.EnterType "
					LSQL = LSQL & "   	,M.PlayerReln "

	'     		response.Write "LSQL="&LSQL&"<br>"

				SET LRs = DBCon.Execute(LSQL)
				IF Not(LRs.Eof or LRs.bof) Then
					Do Until LRs.Eof

						txt_JoinUs = txt_JoinUs & "<li>"
						txt_JoinUs = txt_JoinUs & "  <a href=""javascript:chk_UserIDSET('"&LRs("MemberIDX")&"');"">"
						txt_JoinUs = txt_JoinUs & "   <span class='img_box'><img src='images/ic_check_off@3x.png' alt></span>"
						txt_JoinUs = txt_JoinUs & "   <span class='txt'>"&LRs("PlayerRelnNm")&"</span>"
						txt_JoinUs = txt_JoinUs & "  </a>"
						txt_JoinUs = txt_JoinUs & "</li>"

						LRs.movenext
					Loop
				END IF

				LRs.Close
				SET LRs = Nothing

			'테니스
			CASE "tennis"

			 	LSQL = "    	SELECT M.MemberIDX"
			 	LSQL = LSQL & "   	,CASE "
				LSQL = LSQL & "   		WHEN M.PlayerReln IN('A','B','Z') THEN "
				LSQL = LSQL & " 			CASE "
				LSQL = LSQL & " 				WHEN P.UserName IS NULL OR P.UserName='' THEN "
				LSQL = LSQL & " 					CASE M.PlayerReln "
				LSQL = LSQL & " 						WHEN 'A' THEN '생활체육 - 보호자(부)' "
				LSQL = LSQL & " 						WHEN 'B' THEN '생활체육 - 보호자(모)' "
				LSQL = LSQL & "   						WHEN 'Z' THEN '생활체육 - 보호자('+M.PlayerRelnMemo+')' "
				LSQL = LSQL & "   					END "
				LSQL = LSQL & "   			ELSE "
				LSQL = LSQL & "  				CASE M.PlayerReln "
				LSQL = LSQL & "   					WHEN 'A' THEN '생활체육 - 보호자(부-'+P.UserName+')' "
				LSQL = LSQL & "   					WHEN 'B' THEN '생활체육 - 보호자(모-'+P.UserName+')' "
				LSQL = LSQL & "   					WHEN 'Z' THEN '생활체육 - 보호자('+M.PlayerRelnMemo+'-'+P.UserName+')' "
				LSQL = LSQL & "  				END "
				LSQL = LSQL & "   			END "
				LSQL = LSQL & "   		WHEN M.PlayerReln IN('T') THEN '생활체육 - 지도자('+ISNULL(SD_Tennis.dbo.FN_PubName('sd03900'+LeaderType),'')+'-'+ISNULL(SD_tennis.dbo.FN_TeamNm2('"&SportsType&"', M.Team),'')+')' "
				LSQL = LSQL & "   		WHEN M.PlayerReln IN('R') THEN "
				LSQL = LSQL & "   			CASE "
				LSQL = LSQL & " 				WHEN SD_Tennis.dbo.FN_TeamNm2('"&SportsType&"', M.Team2) IS NULL THEN '생활체육 - 선수('+ISNULL(SD_tennis.dbo.FN_TeamNm2('"&SportsType&"', M.Team),'')+')' "
				LSQL = LSQL & "   			ELSE "
				LSQL = LSQL & " 				'생활체육 - 선수('+ISNULL(SD_tennis.dbo.FN_TeamNm2('"&SportsType&"', M.Team),'')+'/'+ISNULL(SD_Tennis.dbo.FN_TeamNm2('"&SportsType&"', M.Team2),'')+')' "
				LSQL = LSQL & "   			END "
				LSQL = LSQL & "   	ELSE '생활체육 - 일반' "
				LSQL = LSQL & "   	END PlayerRelnNm "
				LSQL = LSQL & " FROM [SD_Tennis].[dbo].[tblMember] M"
				LSQL = LSQL & "   	left join [SD_Tennis].[dbo].[tblPlayer] P on M.PlayerIDX = P.PlayerIDX"
				LSQL = LSQL & "     	AND P.SportsGb = '"&SportsType&"' "
				LSQL = LSQL & "     	AND P.DelYN = 'N' "
				LSQL = LSQL & " WHERE M.DelYN = 'N' "
				LSQL = LSQL & "   	AND M.SportsType = '"&SportsType&"' "
				LSQL = LSQL & "   	AND M.EnterType = 'A' "
				LSQL = LSQL & "   	AND M.SD_UserID = '"&UserID&"' "
				LSQL = LSQL & " ORDER BY M.EnterType "
				LSQL = LSQL & "   	,M.PlayerReln "

	'     		response.Write "LSQL="&LSQL&"<br>"

				SET LRs = DBCon4.Execute(LSQL)
				IF Not(LRs.Eof or LRs.bof) Then
					Do Until LRs.Eof

						txt_JoinUs = txt_JoinUs & "<li>"
						txt_JoinUs = txt_JoinUs & "  <a href=""javascript:chk_UserIDSET('"&LRs("MemberIDX")&"');"">"
						txt_JoinUs = txt_JoinUs & "   <span class='img_box'><img src='images/ic_check_off@3x.png' alt></span>"
						txt_JoinUs = txt_JoinUs & "   <span class='txt'>"&LRs("PlayerRelnNm")&"</span>"
						txt_JoinUs = txt_JoinUs & "  </a>"
						txt_JoinUs = txt_JoinUs & "</li>"

						LRs.movenext
					Loop
				END IF

				LRs.Close
				SET LRs = Nothing

	  	END SELECT

	%>
	<script>
	  	function chk_UserIDSET(obj){
	    	$('#GameSETID').val(obj);
	  	}

		//종목메인 계정선택 설정
		function chk_Submit(){
			var SportsType = '<%=SportsType%>';
			var strAjaxUrl = './ajax/category.asp';
			var GameSETID = $('#GameSETID').val();

			if(!$('#GameSETID').val()){
				alert('종목메인 계정을 선택해 주세요.');
				return;
			}

			$.ajax({
				url: strAjaxUrl,
				type: 'POST',
				dataType: 'html',
				data: {
					GameSETID   : GameSETID
					,SportsType : SportsType
				},
				success: function(retDATA) {

					//console.log(retDATA);

					if(retDATA){

						var strcut = retDATA.split('|');

						if(strcut[0] == 'TRUE') {
							alert('종목메인 계정설정이 완료되었습니다.');

							switch(SportsType) {
								case 'judo'   : $(location).attr('href', 'http://judo.sportsdiary.co.kr/M_Player/Main/index.asp'); break;
								case 'tennis' : $(location).attr('href', 'http://tennis.sportsdiary.co.kr/tennis/M_Player/main/main.asp'); break;
								default       : $(location).attr('href', 'http://sdmain.sportsdiary.co.kr/sdmain/index.asp');	//sd main page
							}
						}
						else{
							switch(strcut[1]){
								case '99' : msg_log = '종목메인 계정설정이 완료되지 못하였습니다.\n확인 후 다시 이용하세요.'; break;
								default   : msg_log = '잘못된 접근입니다.\n확인 후 다시 이용하세요.';
							}
							alert(msg_log);
							return;
						}
					}
				},
				error: function(xhr, status, error){
					if(error){
						alert ('오류발생! - 시스템관리자에게 문의하십시오!');
						return;
					}
				}
			});
		}
	</script>
</head>
</head>
<body>
<div class="l">

	<div class="l_content m_scroll category sel_cate [ _content _scroll ]">

		<input type="hidden" id="GameSETID" name="GameSETID" />
		<!-- S: top_section -->
		<section class="top_section">
		  <h2>회원구분을 선택해주세요.</h2>
		  <ul class="cate_list">
		    <%=txt_JoinUs%>
		    <!--
		      <li>
		        <a href="#">
		          <span class="img_box">
		            <img src="images/ic_check_off@3x.png" alt>
		          </span>
		          <span class="txt">엘리트 지도자</span>
		        </a>
		      </li>
		      <li>
		        <a href="#">
		          <span class="img_box">
		            <img src="images/ic_check_off@3x.png" alt>
		          </span>
		          <span class="txt">생활체육 동호인</span>
		        </a>
		      </li>
		      <li>
		        <a href="#">
		          <span class="img_box">
		            <img src="images/ic_check_off@3x.png" alt>
		          </span>
		          <span class="txt">보호자</span>
		        </a>
		      </li>
		      <li>
		        <a href="#">
		          <span class="img_box">
		            <img src="images/ic_check_off@3x.png" alt>
		          </span>
		          <span class="txt">선수</span>
		        </a>
		      </li>
		      <li>
		        <a href="#">
		          <span class="img_box">
		            <img src="images/ic_check_off@3x.png" alt>
		          </span>
		          <span class="txt">일반</span>
		        </a>
		      </li>
		      -->
		  </ul>
		</section>
		<!-- E: top_section -->
		<div class="cta btn_2">
		  <div class="btn_box"> <a href="javascript:history.back();" class="btn btn-cancel">이전</a> <a href="javascript:chk_Submit();" class="btn btn-ok">다음</a> </div>
		</div>

	</div>

	<!-- #include file='./include/footer.asp' -->

	<script>
	    function cateTab() {
	      var $cateBtn = $('.cate_list a');
	      var $selected = null;
	      var imgSrc = '';
	      var nSrc = '';
	      var bfSrc = '';
	      $cateBtn.click(function(){
	        imgSrc = $(this).find('img').attr('src');
	        if ($(this).hasClass('on')) {
	          $(this).removeClass('on');
	          $(this).find('img').attr('src', imgSrc.replace('_on@3x', '_off@3x'));
	          return;
	        }
	        if ($selected) {
	          $selected.removeClass('on');
	        }
	        $selected = $(this);
	        $selected.addClass('on');

	        if ($(this).hasClass('on')) {
	          nSrc = imgSrc.replace('_off@3x', '_on@3x');
	          bfSrc = imgSrc.replace('_on@3x', '_off@3x');
	          $cateBtn.find('img').attr('src', bfSrc);
	          $(this).find('img').attr('src', nSrc);
	        }
	      });
	    }

	    cateTab();
	  </script>

</div>
</body>
</html>
