<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file='./include/head.asp' -->
	<!-- #include file='./include/config.asp' -->
	<%
		dim UserName 	: Username 	= fInject(trim(request("UserName")))
		dim UserBirth 	: UserBirth = fInject(trim(request("UserBirth")))

		IF UserBirth = "" OR UserBirth = "" Then
			Response.Write "<script>alert('잘못된 경로로 접근하셨거나 누락된 항목이 있습니다.'); history.back();</script>"
			Response.End
		End IF

		dim LSQL, LRs

		IF UserName = "" OR UserBirth = "" Then
			Response.Write "FALSE|200"
			Response.End
		Else
			'회원DB
			LSQL =  " 		SELECT * "
			LSQL = LSQL & " FROM [SD_Member].[dbo].[tblMember]"
			LSQL = LSQL & " WHERE DelYN = 'N'"
			LSQL = LSQL & "		AND UserName = '"&UserName&"' "
			LSQL = LSQL & "		AND replace(Birthday,'-','') = '"&UserBirth&"' "

			SET LRs = DBCon3.Execute(LSQL)
			IF Not(LRs.Eof or LRs.bof) Then

				response.Write "UserID=" &UserID

			ELSE
				Response.Write "<script>alert('일치하는 정보가 없습니다.'); history.back();</script>"
				Response.End
			END IF

				LRs.Close
			SET LRs = Nothing

			DBClose3()

		End IF

	%>
</head>
<body>
<div class="l">

	<div class="l_header">
		<div class="m_header s_sub">
			<!-- #include file="./include/header_back.asp" -->
		  <h1 class="m_header__tit">통합ID 계정 확인</h1>
		  <!-- #include file="./include/header_home.asp" -->
		</div>
	</div>

  <div class="l_content m_scroll combine_check [ _content _scroll ]">

    <!-- S: no_info -->
    <div class="no_info info">
      <!-- S: top_section -->
      <div class="top_section">
        <div class="img_box">
          <img src="images/ic_excla@3x.png" alt>
        </div>
        <p>가입된 ID가 없습니다.</p>
      </div>
      <!-- E: top_section -->

      <!-- S: word-form -->
      <div class="word-form">
        <p>회원가입을 원하시면 하단 버튼을 선택해주세요.</p>
      </div>

      <div class="cta">
        <a href="./join1_agree.asp" class="btn btn-ok btn-block">회원가입하기</a>
      </div>
      <!-- E: word-form -->
    </div>
    <!-- E: no_info -->

  </div>

  <!-- #include file='./include/footer.asp' -->
</div>
</body>
</html>
