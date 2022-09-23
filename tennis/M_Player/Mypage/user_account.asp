<!-- #include file="../include/config.asp" -->
<!-- E: config -->
<%
	'로그인하지 않았다면 login.asp로 이동
	Check_Login()

	dim LSQL, LRs


	'종목메인 계정 설정
	FUNCTION Info_JoinUs(obj)
		dim txt_JoinUs	'가입회원 목록
		dim cnt_JoinUs	: cnt_JoinUs = 0

		SELECT CASE obj

'			CASE "judo"
'
'				'유도
'				txt_JoinUs = "<li>"
'				txt_JoinUs = txt_JoinUs & "<h3>유도</h3>"
'				txt_JoinUs = txt_JoinUs & "	<div class='cont clearfix'>"
'				txt_JoinUs = txt_JoinUs & "  <p>"
'				txt_JoinUs = txt_JoinUs & "    <span class='img_box'>"
'				txt_JoinUs = txt_JoinUs & "      <img src='../images/mypage/icon_vCheck@3x.png' alt>"
'				txt_JoinUs = txt_JoinUs & "    </span>"
'
'
'				LSQL =  " 		SELECT "
'				LSQL = LSQL & " 	CASE M.EnterType  "
'				LSQL = LSQL & " 		WHEN 'E' THEN "
'				LSQL = LSQL & " 			CASE PlayerReln  "
'				LSQL = LSQL & " 				WHEN 'A' THEN '엘리트-보호자(부-'+P.UserName+')'"
'				LSQL = LSQL & " 				WHEN 'B' THEN '엘리트-보호자(모-'+P.UserName+')'"
'				LSQL = LSQL & " 				WHEN 'Z' THEN '엘리트-보호자('+PlayerRelnMemo+'-'+P.UserName+')'"
'				LSQL = LSQL & " 				WHEN 'R' THEN '엘리트-선수('+SportsDiary.dbo.FN_TeamNm('"&obj&"','', M.Team)+')' "
'				LSQL = LSQL & " 				WHEN 'K' THEN '엘리트-비등록선수' "
'				LSQL = LSQL & " 				WHEN 'S' THEN '엘리트-예비후보' "
'				LSQL = LSQL & " 				WHEN 'T' THEN '엘리트-지도자('+ISNULL(SportsDiary.dbo.FN_PubName('sd03900' + LeaderType),'')+')-'+ISNULL(SportsDiary.dbo.FN_TeamNm2('"&obj&"', M.Team),'')"
'				LSQL = LSQL & " 				WHEN 'D' THEN '일반' "
'				LSQL = LSQL & " 			END "
'				LSQL = LSQL & " 		WHEN 'A' THEN "
'				LSQL = LSQL & " 			CASE PlayerReln "
'				LSQL = LSQL & " 				WHEN 'A' THEN '생활체육-보호자(부-'+P.UserName+')'"
'				LSQL = LSQL & " 				WHEN 'B' THEN '생활체육-보호자(모-'+P.UserName+')'"
'				LSQL = LSQL & " 				WHEN 'Z' THEN '생활체육-보호자('+PlayerRelnMemo+'-'+P.UserName+')'"
'				LSQL = LSQL & " 				WHEN 'R' THEN '생활체육-선수('+ISNULL(SportsDiary.dbo.FN_TeamNm2('"&obj&"', M.Team),'')+')' "
'				LSQL = LSQL & " 				WHEN 'T' THEN '생활체육-지도자('+ISNULL(SportsDiary.dbo.FN_PubName('sd03900' + LeaderType),'')+')-'+ISNULL(SportsDiary.dbo.FN_TeamNm2('"&obj&"', M.Team),'')"
'				LSQL = LSQL & " 				WHEN 'D' THEN '일반' "
'				LSQL = LSQL & " 			END	"
'				LSQL = LSQL & " 	ELSE '국가대표' "
'				LSQL = LSQL & " 	END PlayerRelnNm "
'				LSQL = LSQL & " FROM [SportsDiary].[dbo].[tblMember] M"
'				LSQL = LSQL & " 	left join [SportsDiary].[dbo].[tblPlayer] P on M.PlayerIDX = P.PlayerIDX"
'				LSQL = LSQL & " 		AND P.SportsGb = '"&obj&"' "
'				LSQL = LSQL & " 		AND P.DelYN = 'N' "
'				LSQL = LSQL & " WHERE M.DelYN = 'N' "
'				LSQL = LSQL & " 	AND M.SportsType = '"&obj&"' "
'				LSQL = LSQL & "		AND M.SD_UserID = '"&request.Cookies("SD")("UserID")&"' "
'				LSQL = LSQL & "		AND M.SD_GameIDSET = 'Y' "
'				LSQL = LSQL & " ORDER BY M.EnterType "
'				LSQL = LSQL & " 	,M.PlayerReln "
'
''				response.Write LSQL&"<br><br>"
'
'				SET LRs = DBCon.Execute(LSQL)
'				IF Not(LRs.Eof or LRs.bof) Then
'					cnt_JoinUs = 1
'					txt_JoinUs = txt_JoinUs & "<span class='txt'>"&LRs(0)&"</span>"
'				Else
'
'					LSQL =  " 		SELECT ISNULL(COUNT(*), 0) cnt"
'					LSQL = LSQL & " FROM [SportsDiary].[dbo].[tblMember] "
'					LSQL = LSQL & " WHERE DelYN = 'N' "
'					LSQL = LSQL & " 	AND SportsType = '"&obj&"' "
'					LSQL = LSQL & "		AND SD_UserID = '"&request.Cookies("SD")("UserID")&"' "
'
'					SET Rs = DBCon.Execute(LSQL)
'					IF Rs(0) > 0 Then
'						cnt_JoinUs = Rs(0)
'						txt_JoinUs = txt_JoinUs & "<span class='txt'>설정된 계정이 없습니다.</span>"
'					Else
'						txt_JoinUs = txt_JoinUs & "<span class='txt'>가입된 계정이 없습니다.</span>"
'					End IF
'
'						Rs.Close
'					SET Rs = Nothing
'
'				END IF
'
'				txt_JoinUs = txt_JoinUs & "  </p>"
'				txt_JoinUs = txt_JoinUs & "  <div class='btn_box'>"
'
'				'가입된 회원 있는지 유무 체크
'				IF cnt_JoinUs > 0 Then
'					txt_JoinUs = txt_JoinUs & "    <a href='./user_account_type.asp?SportsType="&obj&"' class='btn btn-ok'>설정변경</a>"
'				Else
'					txt_JoinUs = txt_JoinUs & "    <a href=""javascript:chk_onSubmitJoin();"" class='btn btn-ok'>회원가입</a>"
'				End IF
'
'				txt_JoinUs = txt_JoinUs & "  </div>"
'				txt_JoinUs = txt_JoinUs & "	</div>"
'				txt_JoinUs = txt_JoinUs & "</li>"
'
'					LRs.Close
'				SET LRs = Nothing


			CASE "tennis"

				'테니스
				txt_JoinUs = "<li>"
				txt_JoinUs = txt_JoinUs & "<h3>테니스</h3>"
				txt_JoinUs = txt_JoinUs & "	<div class='cont clearfix'>"
				txt_JoinUs = txt_JoinUs & "  <p>"
				txt_JoinUs = txt_JoinUs & "    <span class='img_box'>"
				txt_JoinUs = txt_JoinUs & "      <img src='http://img.sportsdiary.co.kr/sdapp/mypage/icon_vCheck@3x.png' alt>"
				txt_JoinUs = txt_JoinUs & "    </span>"


				LSQL =  " 		SELECT "
				LSQL = LSQL & " 	CASE M.PlayerReln "
				LSQL = LSQL & " 		WHEN 'A' THEN '생활체육-보호자(부-'+P.UserName+')'"
				LSQL = LSQL & " 		WHEN 'B' THEN '생활체육-보호자(모-'+P.UserName+')'"
				LSQL = LSQL & " 		WHEN 'Z' THEN '생활체육-보호자('+PlayerRelnMemo+'-'+P.UserName+')'"
				LSQL = LSQL & " 		WHEN 'T' THEN '생활체육-지도자('+ISNULL(SD_Tennis.dbo.FN_PubName('sd03900'+LeaderType),'')+')-'+ISNULL(SD_tennis.dbo.FN_TeamNm2('"&obj&"', M.Team),'')"
				LSQL = LSQL & "     	WHEN 'R' THEN "
				LSQL = LSQL & "       		CASE "
				LSQL = LSQL & "         		WHEN SD_Tennis.dbo.FN_TeamNm2('"&obj&"', M.Team2) IS NULL THEN '생활체육-선수('+ISNULL(SD_tennis.dbo.FN_TeamNm2('"&obj&"', M.Team),'')+')'"
				LSQL = LSQL & "       		ELSE '생활체육-선수('+ISNULL(SD_tennis.dbo.FN_TeamNm2('"&obj&"', M.Team),'')+'/'+ISNULL(SD_Tennis.dbo.FN_TeamNm2('"&obj&"', M.Team2),'')+')'"
				LSQL = LSQL & "       		END"
				LSQL = LSQL & " 		WHEN 'D' THEN '일반' "
				LSQL = LSQL & " 	END PlayerRelnNm "
				LSQL = LSQL & " FROM [SD_Tennis].[dbo].[tblMember] M"
				LSQL = LSQL & " 	left join [SD_Tennis].[dbo].[tblPlayer] P on M.PlayerIDX = P.PlayerIDX"
				LSQL = LSQL & " 		AND P.SportsGb = '"&obj&"' "
				LSQL = LSQL & " 		AND P.DelYN = 'N' "
				LSQL = LSQL & " WHERE M.DelYN = 'N' "
				LSQL = LSQL & " 	AND M.SportsType = '"&obj&"' "
				LSQL = LSQL & " 	AND M.EnterType = 'A' "
				LSQL = LSQL & "		AND M.SD_UserID = '"&request.Cookies("SD")("UserID")&"' "
				LSQL = LSQL & "		AND M.SD_GameIDSET = 'Y'"
				LSQL = LSQL & " ORDER BY M.EnterType "
				LSQL = LSQL & " 	,M.PlayerReln "

				SET LRs = DBCon3.Execute(LSQL)
				IF Not(LRs.Eof or LRs.bof) Then
					cnt_JoinUs = 1
					txt_JoinUs = txt_JoinUs & "<span class='txt'>"&LRs(0)&"</span>"
				ELSE

					LSQL =  " 		SELECT ISNULL(COUNT(*), 0) cnt"
					LSQL = LSQL & " FROM [SD_Tennis].[dbo].[tblMember] "
					LSQL = LSQL & " WHERE DelYN = 'N' "
					LSQL = LSQL & " 	AND SportsType = '"&obj&"' "
					LSQL = LSQL & "		AND SD_UserID = '"&request.Cookies("SD")("UserID")&"' "

					SET Rs = DBCon3.Execute(LSQL)
					IF Rs(0) > 0 Then
						cnt_JoinUs = Rs(0)
						txt_JoinUs = txt_JoinUs & "<span class='txt'>설정된 계정이 없습니다.</span>"
					Else
						'cnt_JoinUs = 0 이면
						txt_JoinUs = txt_JoinUs & "<span class='txt'>가입된 계정이 없습니다.</span>"
					End IF
						Rs.Close
					SET Rs = Nothing

				END IF

				txt_JoinUs = txt_JoinUs & "  </p>"
				txt_JoinUs = txt_JoinUs & "  <div class='btn_box'>"


				'가입된 회원 있는지 유무 체크
				IF cnt_JoinUs > 0 Then
					txt_JoinUs = txt_JoinUs & "    <a href='./user_account_type.asp?SportsType="&obj&"' class='btn btn-ok'>설정변경</a>"
				Else
					'cnt_JoinUs = 0 이면
					txt_JoinUs = txt_JoinUs & "    <a href=""javascript:chk_onSubmitJoin();"" class='btn btn-ok'>회원가입</a>"
				End IF

				txt_JoinUs = txt_JoinUs & "  </div>"
				txt_JoinUs = txt_JoinUs & "	</div>"
				txt_JoinUs = txt_JoinUs & "</li>"

					LRs.Close
				SET LRs = Nothing

		END SELECT

		Info_JoinUs = txt_JoinUs

	END FUNCTION
%>
<script>

	function chk_onSubmitJoin(){
		//$('.chk_sub_account').modal('show');

		if(confirm("추가계정이 필요한 종목입니다.\n로그아웃 후 회원가입을 통해 추가계정을 생성합니다.")){
			chk_logout();
		}
		else{
			return;
		}

	}
</script>
<body>
	<!-- S: sub-header -->
  <div class="sd-header sd-header-sub">
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <h1>종목 계정 관리</h1>
    <!-- #include file="../include/sub_header_gnb.asp" -->
  </div>
  <!-- #include file = "../include/gnb.asp" -->
  <!-- E: sub-header -->

  <!-- S: sub -->
  <div class="sub user_account">
    <ul>
    	<%
		'response.Write Info_JoinUs("judo")
		response.Write Info_JoinUs("tennis")
		%>
      <!--
      <li>
        <h3>유도</h3>
        <div class="cont clearfix">
          <p>
            <span class="img_box">
              <img src="../images/mypage/icon_vCheck@3x.png" alt>
            </span>
            <span class="txt">체육회등록 엘리트 선수</span>
          </p>
          <div class="btn_box">
            <a href="./user_account_type.asp?SportsType=judo" class="btn btn-ok">설정변경</a>
          </div>
        </div>
      </li>
      <li>
        <h3>테니스</h3>
        <div class="cont clearfix">
          <p>
            <span class="img_box">
              <img src="../images/mypage/icon_vCheck@3x.png" alt>
            </span>
            <span class="txt">체육회등록 엘리트 선수</span>
          </p>
          <div class="btn_box">
            <a href="./user_account_type.asp?SportsType=tennis" class="btn btn-ok">설정변경</a>
          </div>
        </div>
      </li>
      -->
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
            <p>추가 계정이 필요한 종목입니다.<br>추가계정 생성을 진행하시겠습니까?<br>(로그아웃 후 회원가입을 통해 추가계정을 생성합니다.)</p>
          </div>
          <!-- E: modal-body -->
          <!-- S: modal-footer -->
          <div class="modal-footer">
            <ul class="btn_list">
              <li>
                <a href="#" class="btn btn-cancel" data-dismiss="modal">취소</a>
              </li>
              <li>
                <a href="#" onClick="chk_logout();" class="btn btn-ok">확인</a>
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

  <!-- S: footer -->
  <div class="footer">
    <!-- S: bottom-menu -->
    <!-- #include file="../include/bottom_menu.asp" -->
    <!-- E: bottom-menu -->
  </div>
  <!-- E: footer -->

  <!-- S: bot-config -->
  <!-- #include file= "../include/bot_config.asp" -->
  <!-- E: bot-config -->
</body>
