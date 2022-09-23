<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file='./include/head.asp' -->
	<!-- #include file='./include/config.asp' -->
	<%
		'로그인이 되어있다면 index.asp 이동
		Check_NoLogin()

		dim fnd_UserID	: fnd_UserID = fInject(Request("fnd_UserID"))

		dim id_length

		IF fnd_UserID = "" Then
			Response.Write "<script>alert('잘못된 경로로 접근하셨거나 누락된 항목이 있습니다.'); history.back();</script>"
			Response.End
		Else
			fnd_UserID = HexToString(fnd_UserID)

			'자리수 계산, 보여줄 자리수
			id_length = Len(fnd_UserID) - 2

			fnd_UserID = "<span>"&Left(fnd_UserID, id_length)&"**"&"</span>"



		End IF
	%>
</head>
<body>
<div class="l">
	<div class="l_header">
		<div class="m_header s_sub">
		  <!-- #include file="./include/header_back.asp" -->
		  <h1 class="m_header__tit">아이디 찾기</h1>
		  <!-- #include file="./include/header_home.asp" -->
		</div>
  </div>

  <div class="l_content m_scroll [ _content _scroll ] ">

    <div class="m_combineHeader">
      <div class="m_combineHeader__imgWrap"><img src="images/ic_check@3x.png" class="m_combineHeader__img"></div>
      <p class="m_combineHeader__txtLarge">아이디 찾기 결과 안내</p>
    </div>

		<ul class="m_combineIdList">
			<li><%=fnd_UserID%></li>
		</ul>

    <div class="m_combineCont">

			<div class="m_smallLink">
	      <a href="./fnd_pwd.asp" class="m_smallLink__btn">
	        <span class="m_smallLink__txt">비밀번호 찾기</span>
	        <span class="m_smallLink__ic"></span>
	      </a>
	    </div>

      <a href="./login.asp" class="m_combineCont__btn">로그인</a>
    </div>

  </div>

  <!-- #include file='./include/footer.asp' -->
</div>
</body>
</html>
