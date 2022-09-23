<!DOCTYPE html>
<html lang="ko">
<head>
  <!--#include file="../include/config.asp"-->
  <!-- #include file='../include/css/join_style.asp' -->
  <link rel="stylesheet" href="/front/css/join/join2_type3_child_form.css">
  <%
     	'================================================================================================
  	'STEP2
  	'선수보호자 회원가입 : 자녀선수확인 페이지
  	'================================================================================================
     	dim UserName  		: UserName    		= fInject(Request("UserName"))
  	dim UserBirth  		: UserBirth    		= fInject(Request("UserBirth"))

  	dim sd_parents 		: sd_parents    	= fInject(Request("sd_parents"))	'보호자 권한 회원가입 안내사항을 확인동의
  	dim SportsType  	: SportsType    	= fInject(Request("SportsType"))    '종목구분
  	dim EnterType   	: EnterType     	= fInject(Request("EnterType"))     '회원구분[E:엘리트 | A:생활체육]
  	dim PlayerReln  	: PlayerReln    	= fInject(Request("PlayerReln"))  	'가입자 구분

  	'자녀정보
  	dim PlayerName  	: PlayerName   		= fInject(trim(Request("PlayerName")))
  	'dim PlayerBirth 	: PlayerBirth  		= fInject(trim(Request("PlayerBirth")))  	'선수정보tblPlayer 생년월일 정보가 없는경우가 있음
  	dim UserPhone1 		: UserPhone1   		= fInject(trim(Request("UserPhone1")))
  	dim UserPhone2 		: UserPhone2   		= fInject(trim(Request("UserPhone2")))
  	dim UserPhone3 		: UserPhone3   		= fInject(trim(Request("UserPhone3")))
  	dim PlayerPhone		: PlayerPhone 		= UserPhone1&UserPhone2&UserPhone3


  	dim LSQL, LRs
  	dim PlayerIDX, PlayerID, PlayerSEX, TeamNm, TeamNm2, Team, Team2

    	IF sd_parents = "" OR SportsType = "" OR EnterType = "" OR PlayerReln = "" OR PlayerName = "" OR PlayerPhone = "" OR UserName = "" OR UserBirth = "" Then
        	Response.Write "<script>"
  		response.write "	alert('잘못된 경로로 접근하셨거나 누락된 항목이 있습니다.');"
  		response.write "	history.back();"
  		response.write "</script>"
  		Response.End
  	Else
  		'=======================================================================
     		'1. SD통합회원가입 SD_Member.dbo.tblMember
  		'2. 선수계정으로 가입한 자녀회원 정보 조회 SD_Tennis.dbo.tblMember
  		'=======================================================================
  		LSQL = "	  	SELECT M.UserID PlayerID"
  		LSQL = LSQL & "		,T.PlayerIDX PlayerIDX "
  		LSQL = LSQL & "		,CASE M.SEX WHEN 'WoMan' THEN '여자' WHEN 'Man' THEN '남자' END PlayerSEX "
  		LSQL = LSQL & "		,T.Team Team "
  		LSQL = LSQL & "		,T.Team2 Team2 "
  		LSQL = LSQL & "		,ISNULL(SD_Tennis.dbo.FN_TeamNm2('"&SportsType&"', T.Team),'') TeamNm"
  		LSQL = LSQL & "		,ISNULL(SD_Tennis.dbo.FN_TeamNm2('"&SportsType&"', T.Team2),'') TeamNm2"
  		LSQL = LSQL & " FROM [SD_Member].[dbo].[tblMember] M"
  		LSQL = LSQL & " 	inner join [SD_tennis].[dbo].[tblMember] T on M.UserID = T.SD_UserID AND T.DelYN = 'N' AND T.EnterType = '"&EnterType&"' AND T.PlayerReln IN('R','K','S')"
  		LSQL = LSQL & " WHERE M.DelYN = 'N'"
  		LSQL = LSQL & " 	AND M.UserName = '"&PlayerName&"'"
     		LSQL = LSQL & " 	AND replace(UserPhone,'-','') = '"&PlayerPhone&"'"
     		'LSQL = LSQL & " 	AND M.Birthday = '"&PlayerBirth&"'"

  		SET LRs = DBCon3.Execute(LSQL)
  		IF Not(LRs.Eof Or LRs.Bof) Then
  			PlayerIDX 	= LRs("PlayerIDX")
  			PlayerID 	= LRs("PlayerID")
  			PlayerSEX 	= LRs("PlayerSEX")
  			Team 		= LRs("Team")
  			Team2 		= LRs("Team2")
  			TeamNm 		= LRs("TeamNm")
  			TeamNm2 	= LRs("TeamNm2")
  		Else
  			Response.Write "<script>"
     			response.write "	alert('일치하는 정보가 없습니다. 자녀정보를 확인 후 이용하세요.');"
     			response.write "	history.back();"
     			response.write "</script>"
  			Response.End
  		End If
  			LRs.Close
  		SET LRs = Nothing

  	End IF

     	'테니스 동호인 테이블에는 생년월일 정보가 없어 사용하지 않음
  '	IF PlayerBirth <> "" Then
  '		PlayerBirth = left(PlayerBirth,4)&"."&mid(PlayerBirth,5,2)&"."&right(PlayerBirth,2)
  '	End IF
  %>
  <script>
  	function chk_onSubmit(){
  		if(!$('#sd_child').is(":checked")){
  			alert("자녀선수의 정보가 맞으면 체크박스 체크를 해주세요.");
  			$('#sd_child').focus();
  			return;
  		}

  		$('form[name=s_frm]').attr('action','./join3_type3_userInfo.asp');
  		$('form[name=s_frm]').submit();
  	}
  </script>
</head>
<body class="join-body">
  <!-- S: sub-header -->
	<div class="sd-header sd-header-sub">
		<!-- #include file="../include/sub_header_arrow.asp" -->
		<h1>자녀선수 정보 확인</h1>
	</div>
	<!-- E: sub-header -->

  <form name="s_frm" id="s_frm" method="post">
	  	<input type="hidden" id="SportsType" name="SportsType" value="<%=SportsType%>" />
        <input type="hidden" id="EnterType" name="EnterType" value="<%=EnterType%>" />
        <input type="hidden" id="PlayerReln" name="PlayerReln" value="<%=PlayerReln%>" />
        <input type="hidden" id="UserBirth" name="UserBirth" value="<%=UserBirth%>" />
        <input type="hidden" id="UserName" name="UserName" value="<%=UserName%>" />

        <!--자녀정보-->
        <input type="hidden" id="PlayerIDX" name="PlayerIDX" value="<%=PlayerIDX%>" />
        <input type="hidden" id="PlayerID" name="PlayerID" value="<%=PlayerID%>" />
        <input type="hidden" id="PlayerName" name="PlayerName" value="<%=PlayerName%>" />
        <!--<input type="hidden" id="PlayerBirth" name="PlayerBirth" value="<%=PlayerBirth%>" /> -->
        <input type="hidden" id="PlayerPhone" name="PlayerPhone" value="<%=PlayerPhone%>" />
        <input type="hidden" id="PlayerSEX" name="PlayerSEX" value="<%=PlayerSEX%>" />
        <input type="hidden" id="Team" name="Team" value="<%=Team%>" />
        <input type="hidden" id="Team" name="Team2" value="<%=Team2%>" />
        <input type="hidden" id="TeamNm" name="TeamNm" value="<%=TeamNm%>" />
        <input type="hidden" id="TeamNm2" name="TeamNm2" value="<%=TeamNm2%>" />
  <!-- S: main -->
  <div class="main user_divn child_form pack">
    <!-- S: input-list -->
    <div class="input-list">
      <ul>
        <li>
          <span class="tit">이름</span>
          <span class="txt"><%=PlayerName%></span>
        </li>
        <li>
          <span class="tit">아이디</span>
          <span class="txt"><%=PlayerID%></span>
        </li>
		<!--
        <li>
          <span class="tit">생년월일</span>
          <span class="txt"><%=PlayerBirth%></span>
        </li>
		-->
        <li>
          <span class="tit">성별</span>
          <span class="txt"><%=PlayerSEX%></span>
        </li>
        <li>
          <span class="tit">소속</span>
          <span class="txt"><%
		  response.Write TeamNm
		  IF TeamNm2 <> "" Then response.Write " /  "&TeamNm2
		  %></span>
        </li>
      </ul>
    </div>
    <!-- E: input-list -->

    <!-- S: user_divn parents -->
    <div class="user_divn parents">
      <!-- S: check_agree -->
      <div class="check_agree">
        <label class="bind_whole ic_check act_btn">
          <span class="txt">자녀선수의 정보가 맞습니다.</span>
          <input type="checkbox" name="sd_child" id="sd_child" />
          <svg version="1.1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
            <path d="M16.667,62.167c3.109,5.55,7.217,10.591,10.926,15.75 c2.614,3.636,5.149,7.519,8.161,10.853c-0.046-0.051,1.959,2.414,2.692,2.343c0.895-0.088,6.958-8.511,6.014-7.3 c5.997-7.695,11.68-15.463,16.931-23.696c6.393-10.025,12.235-20.373,18.104-30.707C82.004,24.988,84.802,20.601,87,16"></path>
          </svg>
        </label>
      </div>
      <!-- E: check_agree -->
    </div>
    <!-- E: user_divn parents -->


    <!-- S: small_link -->
    <!-- <div class="small_link">
      <a href="./fnd_pwd.asp" class="btn btn-link">
        <span>신규 소속 생성 요청</span>
        <span class="triangle"></span>
      </a>
    </div> -->
    <!-- E: small_link -->

  </div>
  <!-- E: main -->
  </form>
  <div class="cta">
    <a href="javascript:chk_onSubmit();" class="btn btn-ok btn-block btn_chk_account">다음</a>
  </div>


  <script>
    WholeAgree.start('.check_agree');
  </script>
  <script src="../js/main.js"></script>
</body>
</html>
