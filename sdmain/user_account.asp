<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file='./include/head.asp' -->
	<!-- #include file="./include/config.asp" -->
	<!-- <link rel="stylesheet" href="/front/css/mypage/user_account.css"> -->

	<%
		Check_Login()

		dim txt_SDType		'종목별 설정된 메인계정 목록 출력

		'========================================================================================================
	   	'종목별 설정된 메인계정 상태출력
		'	함수 위치 	: /Libary/common_function.asp
		'	사용함수 	:
		'	 	ReplaceSportsGbText()
	   	'		INFO_QUERY_JOINACCOUNT()
		'		CHK_COUNT_SPORTSGB_JOINUS()
	   	'========================================================================================================
		FUNCTION Info_JoinUs(valSportsGb)
			dim txt_JoinUs						'종목별 가입계정 출력 html변수
			dim cnt_JoinUs	: cnt_JoinUs = 0	'종목별 가입계정 카운트
			dim LSQL, LRs

			txt_JoinUs = "				<li>"
			txt_JoinUs = txt_JoinUs & "		<h3>"&ReplaceSportsGbText(valSportsGb)&"</h3>"
			txt_JoinUs = txt_JoinUs & "		<div class='cont clearfix'>"
			txt_JoinUs = txt_JoinUs & "  		<p>"
			txt_JoinUs = txt_JoinUs & "   			<span class='img_box'><img src='./images/icon_vCheck@3x.png' alt></span>"

	   		SELECT CASE valSportsGb
	   			CASE "judo" : SET LRs = DBCon.Execute(INFO_QUERY_JOINACCOUNT(valSportsGb, "ACCOUNT"))
	   			CASE Else  	: SET LRs = DBCon3.Execute(INFO_QUERY_JOINACCOUNT(valSportsGb, "ACCOUNT"))
	   		END SELECT

			IF Not(LRs.Eof or LRs.bof) Then
				cnt_JoinUs = 1
				txt_JoinUs = txt_JoinUs & "			<span class='txt'>"&LRs("PlayerRelnNm")&"</span>"
			ELSE
	   			cnt_JoinUs = CHK_COUNT_SPORTSGB_JOINUS(valSportsGb)

				IF cnt_JoinUs > 0 Then
					txt_JoinUs = txt_JoinUs & "		<span class='txt'>메인계정 미설정 상태입니다.</span>"
				Else
					txt_JoinUs = txt_JoinUs & "		<span class='txt'>가입된 계정이 없습니다.</span>"
				End IF
			END IF
				LRs.Close
			SET LRs = Nothing


			txt_JoinUs = txt_JoinUs & "  		</p>"
			txt_JoinUs = txt_JoinUs & "  		<div class='btn_box'>"


			'가입된 회원 있는지 유무 체크
			IF cnt_JoinUs > 0 Then
				txt_JoinUs = txt_JoinUs & "    		<a href='./user_account_type.asp?SportsType="&valSportsGb&"' class='btn btn-ok'>설정변경</a>"
			Else
				'cnt_JoinUs = 0 이면
				txt_JoinUs = txt_JoinUs & "    		<a href='./join_MemberTypeGb.asp?SportsType="&valSportsGb&"' class='btn btn-ok'>계정추가</a>"
			End IF

			txt_JoinUs = txt_JoinUs & "  		</div>"
			txt_JoinUs = txt_JoinUs & "		</div>"
			txt_JoinUs = txt_JoinUs & "	</li>"

			Info_JoinUs = txt_JoinUs

		END FUNCTION
	%>
</head>
<body>
<div class="l">
	<div class="l_header">
		<div class="m_header s_sub">
			<!-- #include file="./include/header_back.asp" -->
			<h1 class="m_header__tit">종목 계정 관리</h1>
			<!-- #include file="./include/header_home.asp" -->
		</div>
	</div>

  <!-- S: sub -->
  <div class="l_content m_scroll sub user_account [ _content _scroll ]">
    <ul>
    	<%
		   	txt_SDType = Split(mid(LIST_SPORTSTYPE, 4, len(LIST_SPORTSTYPE) - 3), "|")

			'FOR i = 1 To Ubound(txt_SDType)
             FOR i = 1 To 1     '테니스, 자전거 사용안함
				IF txt_SDType(i) <> "" Then
					response.write Info_JoinUs(txt_SDType(i))
				End IF
			NEXT
		%>
    </ul>
  </div>
  <!-- E : sub -->

  <!-- S: chk_sub_account -->
  <div class="modal fade conf_modal chk_sub_account">
    <!-- S: modal-dialog -->
    <div class="modal-dialog">
      <!-- S: modal-content -->
      <div class="modal-content">
        <!-- S: modal-body -->
        <div class="modal-body">
          <p>추가 계정이 필요한 종목입니다.<br>추가계정 생성을 진행하시겠습니까?</p>
        </div>
        <!-- E: modal-body -->
        <!-- S: modal-footer -->
        <div class="modal-footer">
          <ul class="btn_list">
            <li>
              <a href="#" class="btn btn-cancel" data-dismiss="modal">취소</a>
            </li>
            <li>
              <a href="./join_MemberTypeGb.asp" class="btn btn-ok">확인</a>
            </li>
          </ul>
        </div>
        <!-- E: modal-footer -->
      </div>
      <!-- E: modal-content -->
    </div>
    <!-- E: modal-dialog -->
  </div>
  <!-- E: chk_sub_account -->

  <!-- include file="../include/bottom_menu.asp" -->
  <!-- include file= "../include/bot_config.asp" -->
</div>
</body>
</html>
