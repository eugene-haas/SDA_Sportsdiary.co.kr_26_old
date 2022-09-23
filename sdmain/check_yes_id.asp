<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file='./include/head.asp' -->
  <!-- #include file='./include/config.asp' -->

  <%
    '로그인했다면 main.asp로 이동
    Check_NoLogin()

    '회원가입시 통합ID 계정 확인
    dim UserName  : UserName  = fInject(trim(request("UserName")))
    dim UserBirth   : UserBirth = fInject(trim(request("UserBirth")))
    dim chk_User

    IF UserBirth = "" OR UserBirth = "" Then
      Response.Write "<script>alert('잘못된 경로로 접근하셨거나 누락된 항목이 있습니다.'); history.back();</script>"
      Response.End
    End IF

    dim LSQL, LRs
    dim txt_JoinUs  '가입회원 목록

    IF UserName = "" OR UserBirth = "" Then
      Response.Write "FALSE|200"
      Response.End
    Else
  	'통합계정 가입 유무체크
     	'	- 가입계정 수에 따라 통합아이디설정페이지로 이동하거나 로그인페이지로 이동합니다.
    	chk_User = CHK_JOINUS(UserName, UserBirth)

  	'통합
      LSQL =  "     	SELECT UserName"
  	LSQL = LSQL & "		,CONVERT(CHAR, CONVERT(DATE, Birthday), 102) UserBirth"
  	LSQL = LSQL & "		,CASE SEX WHEN 'Man' THEN '남' ELSE '여' END SEXNm"
     	LSQL = LSQL & "		,CONVERT(CHAR, WriteDate, 102) RegDate"
      LSQL = LSQL & " FROM [SD_Member].[dbo].[tblMember]"
      LSQL = LSQL & " WHERE DelYN = 'N' "
    	LSQL = LSQL & "     AND UserName = '"&UserName&"'"
      LSQL = LSQL & "     AND Birthday = '"&UserBirth&"'"

     'response.Write LSQL&"<br><br>"

      SET LRs = DBCon3.Execute(LSQL)
      IF Not(LRs.Eof or LRs.bof) Then
        Do Until LRs.Eof

          txt_JoinUs = txt_JoinUs & "<li><span>통합계정 :</span> <span>"&LRs("UserName")&"("&LRs("SEXNm")&"-"&LRs("UserBirth")&"), "&LRs("RegDate")&"</span></li>"

          LRs.movenext
        Loop
      END IF

        LRs.Close
      SET LRs = Nothing


  	'유도
  	LSQL =  "     	SELECT "
  	LSQL = LSQL & "   	CASE "
  	LSQL = LSQL & "     	WHEN M.EnterType = 'E' THEN "
  	LSQL = LSQL & "       		CASE M.PlayerReln  "
  	LSQL = LSQL & "         		WHEN 'A' THEN '엘리트-보호자(부-'+P.UserName+')'"
  	LSQL = LSQL & "         		WHEN 'B' THEN '엘리트-보호자(모-'+P.UserName+')'"
  	LSQL = LSQL & "         		WHEN 'Z' THEN '엘리트-보호자('+M.PlayerRelnMemo+'-'+P.UserName+')'"
  	LSQL = LSQL & "         		WHEN 'R' THEN '엘리트-선수('+ISNULL(SportsDiary.dbo.FN_TeamNm2('judo', M.Team),'')+')'"
  	LSQL = LSQL & "         		WHEN 'K' THEN '엘리트-비등록선수'"
  	LSQL = LSQL & "         		WHEN 'S' THEN '엘리트-예비후보'"
  	LSQL = LSQL & "         		WHEN 'T' THEN '엘리트-지도자('+ISNULL(SportsDiary.dbo.FN_PubName('sd03900'+M.LeaderType),'')+'-'+ISNULL(SportsDiary.dbo.FN_TeamNm2('judo', M.Team),'')+')'"
  	LSQL = LSQL & "         		WHEN 'D' THEN '일반' "
  	LSQL = LSQL & "      		END "
  	LSQL = LSQL & "     	WHEN M.EnterType = 'A' THEN "
  	LSQL = LSQL & "       		CASE M.PlayerReln "
  	LSQL = LSQL & "         		WHEN 'A' THEN '생활체육-보호자(부-'+P.UserName+')'"
  	LSQL = LSQL & "         		WHEN 'B' THEN '생활체육-보호자(모-'+P.UserName+')'"
  	LSQL = LSQL & "         		WHEN 'Z' THEN '생활체육-보호자('+M.PlayerRelnMemo+'-'+P.UserName+')'"
  	LSQL = LSQL & "         		WHEN 'R' THEN '생활체육-선수('+ISNULL(SportsDiary.dbo.FN_TeamNm2('judo', M.Team),'')+')'"
  	LSQL = LSQL & "         		WHEN 'T' THEN '생활체육-지도자('+ISNULL(SportsDiary.dbo.FN_PubName('sd03900'+M.LeaderType),'')+'-'+ISNULL(SportsDiary.dbo.FN_TeamNm2('judo', M.Team),'')+')'"
  	LSQL = LSQL & "        			WHEN 'D' THEN '일반' "
  	LSQL = LSQL & "       		END "
  	LSQL = LSQL & "    		WHEN M.EnterType = 'K' THEN "
  	LSQL = LSQL & "       		CASE PlayerReln "
  	LSQL = LSQL & "         		WHEN 'R' THEN '국가대표-선수('+ISNULL(SportsDiary.dbo.FN_TeamNm2('judo', M.Team),'')+')'"
  	LSQL = LSQL & "         		WHEN 'T' THEN '국가대표-지도자('+ISNULL(SportsDiary.dbo.FN_PubName('sd03900'+M.LeaderType),'')+'-'+ISNULL(SportsDiary.dbo.FN_TeamNm2('judo', M.Team),'')+')'"
  	LSQL = LSQL & "       		END "
  	LSQL = LSQL & "   		END PlayerRelnNm "
      LSQL = LSQL & "		,CONVERT(CHAR, CONVERT(DATE, SrtDate), 102) RegDate"
  	LSQL = LSQL & " FROM [SportsDiary].[dbo].[tblMember] M"
  	LSQL = LSQL & "   	left join [SportsDiary].[dbo].[tblPlayer] P on M.PlayerIDX = P.PlayerIDX AND P.SportsGb = 'judo' AND P.DelYN = 'N' "
  	LSQL = LSQL & " WHERE M.DelYN = 'N' "
  	LSQL = LSQL & "   	AND M.SportsType = 'judo' "
  	LSQL = LSQL & "     AND M.UserName = '"&UserName&"'"
  	LSQL = LSQL & "     AND M.Birthday = '"&UserBirth&"'"
  	LSQL = LSQL & " ORDER BY M.EnterType DESC"
  	LSQL = LSQL & "   	,CASE M.PlayerReln"
  	LSQL = LSQL & "			WHEN 'A' THEN 1"
  	LSQL = LSQL & "			WHEN 'B' THEN 1"
  	LSQL = LSQL & "			WHEN 'Z' THEN 1"
  	LSQL = LSQL & "			WHEN 'R' THEN 2"
  	LSQL = LSQL & "			WHEN 'K' THEN 2"
  	LSQL = LSQL & "			WHEN 'S' THEN 2"
  	LSQL = LSQL & "			WHEN 'T' THEN 3"
  	LSQL = LSQL & "			ELSE 4"
  	LSQL = LSQL & "			END ASC"

    'response.Write LSQL&"<br><br>"

      SET LRs = DBCon.Execute(LSQL)
      IF Not(LRs.Eof or LRs.bof) Then
        Do Until LRs.Eof

          txt_JoinUs = txt_JoinUs & "<li><span>유도 :</span> <span>"&LRs(0)&", "&LRs("RegDate")&"</span></li>"

          LRs.movenext
        Loop
      END IF

        LRs.Close
      SET LRs = Nothing

      '테니스
  	LSQL =  "     	SELECT "
  	LSQL = LSQL & "   	CASE M.EnterType  "
  	LSQL = LSQL & "     	WHEN 'E' THEN "
  	LSQL = LSQL & "     		CASE M.PlayerReln "
  	LSQL = LSQL & "       			WHEN 'A' THEN '엘리트-보호자(부-'+P.UserName+')'"
  	LSQL = LSQL & "       			WHEN 'B' THEN '엘리트-보호자(모-'+P.UserName+')'"
  	LSQL = LSQL & "       			WHEN 'Z' THEN '엘리트-보호자('+PlayerRelnMemo+'-'+P.UserName+')'"
  	LSQL = LSQL & "       			WHEN 'T' THEN '엘리트-지도자('+ISNULL([SD_Tennis].[dbo].[FN_PubName]('sd03900'+M.LeaderType),'')+')'+'-'+ISNULL([SD_Tennis].[dbo].[FN_TeamNm2]('tennis', M.Team),'')"
  	LSQL = LSQL & "       			WHEN 'D' THEN '일반' "
  	LSQL = LSQL & "       			WHEN 'R' THEN "
  	LSQL = LSQL & "           			CASE WHEN [SD_Tennis].[dbo].[FN_TeamNm2]('tennis', M.Team2) IS NULL THEN '엘리트-선수('+ISNULL([SD_Tennis].[dbo].[FN_TeamNm2]('tennis', M.Team),'')+')'"
  	LSQL = LSQL & "             			ELSE '엘리트-선수('+ISNULL([SD_Tennis].[dbo].[FN_TeamNm2]('tennis', M.Team),'')+' / '+ISNULL([SD_Tennis].[dbo].[FN_TeamNm2]('tennis', M.Team2),'')+')'"
  	LSQL = LSQL & "             			END"
  	LSQL = LSQL & "             	END"
  	LSQL = LSQL & "     	WHEN 'A' THEN "
  	LSQL = LSQL & "     		CASE M.PlayerReln "
  	LSQL = LSQL & "       			WHEN 'A' THEN '생활체육-보호자(부-'+P.UserName+')'"
  	LSQL = LSQL & "       			WHEN 'B' THEN '생활체육-보호자(모-'+P.UserName+')'"
  	LSQL = LSQL & "       			WHEN 'Z' THEN '생활체육-보호자('+PlayerRelnMemo+'-'+P.UserName+')'"
  	LSQL = LSQL & "       			WHEN 'T' THEN '생활체육-지도자('+ISNULL([SD_Tennis].[dbo].[FN_PubName]('sd03900'+M.LeaderType),'')+')'+'-'+ISNULL([SD_Tennis].[dbo].[FN_TeamNm2]('tennis', M.Team),'')"
  	LSQL = LSQL & "       			WHEN 'D' THEN '일반' "
  	LSQL = LSQL & "       			WHEN 'R' THEN "
  	LSQL = LSQL & "           			CASE WHEN [SD_Tennis].[dbo].[FN_TeamNm2]('tennis', M.Team2) IS NULL THEN '생활체육-선수('+ISNULL([SD_Tennis].[dbo].[FN_TeamNm2]('tennis', M.Team),'')+')'"
  	LSQL = LSQL & "             			ELSE '생활체육-선수('+ISNULL([SD_Tennis].[dbo].[FN_TeamNm2]('tennis', M.Team),'')+' / '+ISNULL([SD_Tennis].[dbo].[FN_TeamNm2]('tennis', M.Team2),'')+')'"
  	LSQL = LSQL & "             			END"
  	LSQL = LSQL & "             	END"
  	LSQL = LSQL & "       	END PlayerRelnNm "
     	LSQL = LSQL & "		,CONVERT(CHAR, CONVERT(DATE, SrtDate), 102) RegDate"
  	LSQL = LSQL & " FROM [SD_Tennis].[dbo].[tblMember] M "
      LSQL = LSQL & "   	inner join [SD_Member].[dbo].[tblMember] S on M.SD_UserID = S.UserID AND S.DelYN = 'N' AND S.UserName = '"&UserName&"' AND S.Birthday = '"&UserBirth&"' "
  	LSQL = LSQL & "   	left join [SD_Tennis].[dbo].[tblPlayer] P on M.PlayerIDX = P.PlayerIDX AND P.SportsGb = 'tennis' AND P.DelYN = 'N' "
  	LSQL = LSQL & " WHERE M.DelYN = 'N' "
  	LSQL = LSQL & "   	AND M.SportsType = 'tennis' "
  	LSQL = LSQL & " ORDER BY M.EnterType DESC"
  	LSQL = LSQL & "   	,CASE M.PlayerReln"
  	LSQL = LSQL & "			WHEN 'A' THEN 1"
  	LSQL = LSQL & "			WHEN 'B' THEN 1"
  	LSQL = LSQL & "			WHEN 'Z' THEN 1"
  	LSQL = LSQL & "			WHEN 'R' THEN 2"
  	LSQL = LSQL & "			WHEN 'K' THEN 2"
  	LSQL = LSQL & "			WHEN 'S' THEN 2"
  	LSQL = LSQL & "			WHEN 'T' THEN 3"
  	LSQL = LSQL & "			ELSE 4"
  	LSQL = LSQL & "			END ASC"

     'response.Write LSQL&"<br><br>"

      SET LRs = DBCon3.Execute(LSQL)
      IF Not(LRs.Eof or LRs.bof) Then
        Do Until LRs.Eof

          txt_JoinUs = txt_JoinUs & "<li><span>테니스 :</span> <span>"&LRs(0)&", "&LRs("RegDate")&"</span></li>"

          LRs.movenext
        Loop
      END IF

        LRs.Close
      SET LRs = Nothing

    End IF

  	'자전거
      LSQL = "     	SELECT "
  	LSQL = LSQL & "   	 CASE M.EnterType  "
  	LSQL = LSQL & "     	WHEN 'E' THEN "
  	LSQL = LSQL & "       		CASE M.PlayerReln  "
  	LSQL = LSQL & "         		WHEN 'A' THEN '엘리트-보호자(부-'+P.UserName+')'"
  	LSQL = LSQL & "         		WHEN 'B' THEN '엘리트-보호자(모-'+P.UserName+')'"
  	LSQL = LSQL & "         		WHEN 'Z' THEN '엘리트-보호자('+M.PlayerRelnMemo+'-'+P.UserName+')'"
  	LSQL = LSQL & "         		WHEN 'R' THEN "
  	LSQL = LSQL & "   					CASE WHEN [SD_Bike].[dbo].[FN_TeamNm]('bike', M.Team) <> '' THEN '엘리트-선수('+[SD_Bike].[dbo].[FN_TeamNm]('bike', M.Team)+')' "
  	LSQL = LSQL & "							ELSE '엘리트-선수' "
  	LSQL = LSQL & "							END"
  	LSQL = LSQL & "       			END "
  	LSQL = LSQL & "     	WHEN 'A' THEN "
  	LSQL = LSQL & "       		CASE M.PlayerReln "
  	LSQL = LSQL & "         		WHEN 'A' THEN '생활체육-보호자(부-'+P.UserName+')'"
  	LSQL = LSQL & "         		WHEN 'B' THEN '생활체육-보호자(모-'+P.UserName+')'"
  	LSQL = LSQL & "         		WHEN 'Z' THEN '생활체육-보호자('+M.PlayerRelnMemo+'-'+P.UserName+')'"
  	LSQL = LSQL & "         		WHEN 'R' THEN "
  	LSQL = LSQL & " 					CASE WHEN [SD_Bike].[dbo].[FN_TeamNm]('bike', M.Team) <> '' THEN '생활체육-선수('+[SD_Bike].[dbo].[FN_TeamNm]('bike', M.Team)+')' "
  	LSQL = LSQL & "							ELSE '생활체육-선수' "
  	LSQL = LSQL & "							END"
  	LSQL = LSQL & "       			END "
  	LSQL = LSQL & "   		END PlayerRelnNm "
     	LSQL = LSQL & "		,CONVERT(CHAR, CONVERT(DATE, SrtDate), 102) RegDate"
  	LSQL = LSQL & " FROM [SD_Bike].[dbo].[tblMember] M"
     	LSQL = LSQL & "   	inner join [SD_Member].[dbo].[tblMember] S on M.SD_UserID = S.UserID AND S.DelYN = 'N' AND S.UserName = '"&UserName&"' AND S.Birthday = '"&UserBirth&"' "
      LSQL = LSQL & "   	left join [SD_Bike].[dbo].[sd_bikePlayer] P on M.PlayerIDX = P.PlayerIDX AND P.SportsGb = 'bike' AND P.DelYN = 'N' "
  	LSQL = LSQL & " WHERE M.DelYN = 'N' "
  	LSQL = LSQL & "   	AND M.SportsType = 'bike' "
  	LSQL = LSQL & " ORDER BY M.EnterType DESC"
  	LSQL = LSQL & "   	,CASE M.PlayerReln"
  	LSQL = LSQL & "			WHEN 'A' THEN 1"
  	LSQL = LSQL & "			WHEN 'B' THEN 1"
  	LSQL = LSQL & "			WHEN 'Z' THEN 1"
  	LSQL = LSQL & "			WHEN 'R' THEN 2"
  	LSQL = LSQL & "			WHEN 'K' THEN 2"
  	LSQL = LSQL & "			WHEN 'S' THEN 2"
  	LSQL = LSQL & "			WHEN 'T' THEN 3"
  	LSQL = LSQL & "			ELSE 4"
  	LSQL = LSQL & "			END ASC"

  	SET LRs = DBCon3.Execute(LSQL)
      IF Not(LRs.Eof or LRs.bof) Then
        Do Until LRs.Eof

          txt_JoinUs = txt_JoinUs & "<li><span>자전거 :</span> <span>"&LRs(0)&", "&LRs("RegDate")&"</span></li>"

          LRs.movenext
        Loop
      END IF

        LRs.Close
      SET LRs = Nothing

  %>
</head>
<body>
<div class="l checkYestId">
  <form name="s_frm" id="s_frm" method="post">
    <input type="hidden" name="UserName" id="UserName" value="<%=UserName%>" />
    <input type="hidden" name="UserBirth" id="UserBirth" value="<%=UserBirth%>" />
  </form>

  <div class="l_header">
    <div class="m_header s_sub">
      <!-- #include file="./include/header_back.asp" -->
      <h1 class="m_header__tit">통합계정 확인</h1>
      <!-- #include file="./include/header_home.asp" -->
    </div>
  </div>

  <div class="l_content m_scroll [ _content _scroll ]">
    <div class="m_combineHeader">
      <div class="m_combineHeader__imgWrap"><img src="images/ic_check@3x.png" class="m_combineHeader__img"></div>
      <p class="m_combineHeader__txtLarge">가입된 계정이 존재합니다.</p>
    </div>

    <ul class="m_combineIdList" id='txt_JoinUs'>
      <%=txt_JoinUs%>
    </ul>

    <%
    IF chk_User > 1 Then
    %>
    <div class="m_combineCont">
      <p class="m_combineCont__txt">
        통합ID 계정설정이 이루어지지 않은 상태입니다.<br>
        로그인 후 통합ID 설정을 하시기 바랍니다.
      </p>

      <a href="./login.asp" class="m_combineCont__btn">로그인(통합ID 설정하기)</a>
    </div>
    <%
    Else
    %>
    <div class="m_combineCont">
      <p class="m_combineCont__txt">
        종목별  회원계정 추가를 원하시면 <br>
        로그인 후 계정추가를 진행해 주세요.
      </p>

      <a href="./login.asp" class="m_combineCont__btn">로그인</a>
    </div>
    <%
    End IF
    %>

    <div class="identification">
      <button class="identification__btn" type="button" data-toggle="collapse" data-target="#collapse0" aria-expanded="false" aria-controls="collapse0">본인이 아니신가요?</button>
      <div id="collapse0" class="identification__infoWrap [ collapse ]" aria-expanded="false">
        <p class="identification__txt">같은 생년월일을 가진 동명이인의 경우<br /> CS센터를 통해 회원가입 처리가 가능합니다.</p>
        <a href="tel:02-704-0280" class="identification__callBtn">CS센터 전화연결</a>
      </div>
    </div>
  </div>

  <!-- #include file='./include/footer.asp' -->

</div>
</body>
</html>
