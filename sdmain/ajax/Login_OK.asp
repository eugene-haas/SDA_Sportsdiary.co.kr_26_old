<!--#include file="../Library/ajax_config.asp"-->
<%
	'========================================================================================
	'로그인 페이지
	'========================================================================================
	dim UserID 		: UserID   	= LCase(fInject(trim(Request("UserID"))))
	dim UserPass 	: UserPass 	= fInject(trim(Request("UserPass")))
	dim saveid		: saveid 	= fInject(trim(request("saveid")))

	dim LSQL, LRs

	IF UserID = "" OR UserPass = "" Then
		Response.Write "FALSE|200"
		Response.End
	Else

  dim MemberIDX, UserName, UserPhone, Birthday, Sex, UserPassGb
  dim chk_User				'통합ID설정 유무(2개 이상이면 통합설정하지 않은 경우입니다.)
  dim chk_Log					'로그인 로그
  dim str_Cookie()			'종목별 쿠키설정

  '회원DB
  LSQL = " 		SELECT MemberIDX "
  LSQL = LSQL & " 	,UserName"
  LSQL = LSQL & " 	,replace(UserPhone,'-','') UserPhone"
  LSQL = LSQL & " 	,Birthday"
  LSQL = LSQL & " 	,Sex"
  LSQL = LSQL & " 	,ISNULL(UserPassGb,'') UserPassGb"     '임시비밀번호 구분
  LSQL = LSQL & " FROM [SD_Member].[dbo].[tblMember]"
  LSQL = LSQL & " WHERE DelYN = 'N'"
  LSQL = LSQL & "		AND UserID = '"&UserID&"' "
'  LSQL = LSQL & "		AND UserPass = '"&UserPass&"' "


' If ((Request.ServerVariables("REMOTE_ADDR") = "112.187.195.132") Or (Request.ServerVariables("REMOTE_ADDR") = "183.96.195.107")) And UserPass = "a12345" Then
'
' else
  LSQL = LSQL & "		AND PWDCOMPARE('"&UserPass&"', PassEnc) = 1 "
' End if

'############################
'다음 문의시 관리자 페이지 변경하자....
'PassEnc = PWDENCRYPT('0000')

'use SD_Member
'--select userid,userpass,username,passenc from tblMember where username = '이재우' 
'update sd_member.dbo.tblmember set PassEnc = PWDENCRYPT('012345ss') where memberidx in (
'select b.memberidx from sportsdiary.dbo.tblmember as a inner join sd_member.dbo.tblmember as b on a.userid = b.userid and a.delyn = 'N' where b.delyn = 'N' and a.username = '이재우' and a.userid='lmklmk1234' and  a.team = 'AJU00642')

'############################





  SET LRs = DBCon3.Execute(LSQL)
  IF Not(LRs.Eof Or LRs.Bof) Then

    MemberIDX 	= LRs("MemberIDX")
    UserName 	  = LRs("UserName")
    UserPhone 	= LRs("UserPhone")
    Birthday 	  = LRs("Birthday")
    Sex 		    = LRs("Sex")
    UserPassGb 	= LRs("UserPassGb")

		'1. 로그인 로그 기록
   	'	/sdmain/Libary/common_function.asp
		chk_Log = INFO_LOGINLOG(UserID, UserName, Sex)

		'2. 통합ID 설정 유무체크
   		'	통합회원DB에서 한개의 개정만 남긴 후 기타 계정은 삭제하기 위한 계정카운트조회 로직입니다.
		'	SD_Member.dbo.tblMember 가입계정 카운트 chk_User
		'	/sdmain/Libary/common_function.asp
		chk_User = CHK_JOINUS(UserName, Birthday)

		'3.	통합정보 쿠키설정
		response.Cookies("SD").Domain 			= ".sportsdiary.co.kr"
		response.Cookies("SD").path 			= "/"

		response.Cookies("SD")("UserID")    	= UserID					'사용자ID
		response.Cookies("SD")("UserName")  	= UserName					'사용자명
		response.Cookies("SD")("UserBirth")  	= encode(BirthDay, 0)		'생년월일
		response.Cookies("SD")("MemberIDX")  	= encode(MemberIDX, 0)		'MemberIDX
		response.Cookies("SD")("UserPhone")  	= encode(UserPhone, 0)		'Phone
		response.Cookies("SD")("Sex")  			  = Sex						'성별
    response.Cookies("SD")("SaveIDYN")  	= saveid					'자동로그인정보(chk_GameIDSET.asp종목계정설정때 필요)


'Sex=Man&SaveIDYN=Y&MemberIDX=34353731&UserPhone=3031303437303933363530&UserName=%EB%B0%B1%EC%8A%B9%ED%9B%88&UserBirth=3230303230343235&UserID=mujerk

'If Request.ServerVariables("REMOTE_ADDR") = "112.187.195.132"  then
'========================================================================================================
	'가입된 회원계정 목록 출력쿼리
	'	GNB 상단영역../include/gnb.asp
	'	MODAL 계정전환 모달../include/gnbType/change_modal.asp
	'	ACCOUNT 종목메인설정../mypage/user_account.asp
	'	ACCOUNTSET 종목메인설정변경../mypage/user_account_type.asp
	'========================================================================================================
	FUNCTION INFO_QUERY_JOINACCOUNT()		 
		dim txt_SQL
		txt_SQL = " AND M.MemberIDX = '"&MemberIDX&"' "	
	
		LSQL =  "     	SELECT M.MemberIDX "
		LSQL = LSQL & "   	,M.SD_GameIDSET "
		LSQL = LSQL & " 	,CONVERT(CHAR, CONVERT(DATE, M.SrtDate), 102) SrtDate "
		LSQL = LSQL & "   	,CASE M.EnterType  "
		LSQL = LSQL & "     	WHEN 'E' THEN "
		LSQL = LSQL & "       		CASE M.PlayerReln  "
		LSQL = LSQL & "         		WHEN 'A' THEN '엘리트-보호자(부-'+P.UserName+')'"
		LSQL = LSQL & "         		WHEN 'B' THEN '엘리트-보호자(모-'+P.UserName+')'"
		LSQL = LSQL & "        		 	WHEN 'Z' THEN '엘리트-보호자('+M.PlayerRelnMemo+'-'+P.UserName+')'"
		LSQL = LSQL & "        		 	WHEN 'R' THEN '엘리트-선수('+[SportsDiary].[dbo].[FN_TeamNm]('judo','', M.Team)+')'"
		LSQL = LSQL & "         		WHEN 'K' THEN '엘리트-비등록선수' "
		LSQL = LSQL & "         		WHEN 'S' THEN '엘리트-예비후보' "
		LSQL = LSQL & "         		WHEN 'T' THEN '엘리트-지도자('+ISNULL([SportsDiary].[dbo].[FN_PubName]('sd03900' + M.LeaderType),'')+')'+ISNULL([SportsDiary].[dbo].[FN_TeamNm2]('judo', M.Team),'')"
		LSQL = LSQL & "         		WHEN 'D' THEN '일반' "
		LSQL = LSQL & "       			END "
		LSQL = LSQL & "     	WHEN 'A' THEN "
		LSQL = LSQL & "       		CASE M.PlayerReln "
		LSQL = LSQL & "         		WHEN 'A' THEN '생활체육-보호자(부-'+P.UserName+')'"
		LSQL = LSQL & "         		WHEN 'B' THEN '생활체육-보호자(모-'+P.UserName+')'"
		LSQL = LSQL & "         		WHEN 'Z' THEN '생활체육-보호자('+M.PlayerRelnMemo+'-'+P.UserName+')'"
		LSQL = LSQL & "         		WHEN 'R' THEN '생활체육-선수('+ISNULL([SportsDiary].[dbo].[FN_TeamNm2]('judo', M.Team),'')+')' "
		LSQL = LSQL & "         		WHEN 'T' THEN '생활체육-지도자('+ISNULL([SportsDiary].[dbo].[FN_PubName]('sd03900' + M.LeaderType),'')+')'+ISNULL([SportsDiary].[dbo].[FN_TeamNm2]('judo', M.Team),'')"  
		LSQL = LSQL & "         		WHEN 'D' THEN '일반' "  
		LSQL = LSQL & "       			END "
		LSQL = LSQL & "    		WHEN 'K' THEN "
		LSQL = LSQL & "       		CASE M.PlayerReln "
		LSQL = LSQL & "         		WHEN 'R' THEN '국가대표-선수('+ISNULL([SportsDiary].[dbo].[FN_TeamNm2]('judo', M.Team),'')+')'"
		LSQL = LSQL & "         		WHEN 'T' THEN '국가대표-지도자('+ISNULL([SportsDiary].[dbo].[FN_PubName]('sd03900'+M.LeaderType),'')+'-'+ISNULL([SportsDiary].[dbo].[FN_TeamNm2]('judo', M.Team),'')+')'"
		LSQL = LSQL & "       		END "	
		LSQL = LSQL & "   		END PlayerRelnNm "
		LSQL = LSQL & " FROM [SportsDiary].[dbo].[tblMember] M"
		LSQL = LSQL & "   	left join [SportsDiary].[dbo].[tblPlayer] P on M.PlayerIDX = P.PlayerIDX AND P.SportsGb = 'judo' AND P.DelYN = 'N' "
		LSQL = LSQL & " WHERE M.DelYN = 'N' "
		LSQL = LSQL & "   	AND M.SportsType = 'judo' "
		LSQL = LSQL & "   	AND M.SD_UserID = '"&UserID&"' " 
'		LSQL = LSQL &		txt_SQL   '왜써야하는지 몰라서 지음...
		LSQL = LSQL & " ORDER BY M.EnterType "
		LSQL = LSQL & "   	,M.PlayerReln " 	
		INFO_QUERY_JOINACCOUNT = LSQL 
	END FUNCTION

	SET LRs = DBCon.Execute(INFO_QUERY_JOINACCOUNT())
	IF Not(LRs.Eof or LRs.bof) Then
		Response.Cookies("SD")("txt_Name") = LRs("PlayerRelnNm")
	END IF
'End if


'Response.write lsql
'Response.end


    IF UserPassGb <> "" Then response.Cookies("SD")("UserPassGb") = encode(UserPassGb, 0)  '임시비밀번호 구분[Y:임시비밀번호 발급의 경우]

		'4. 각 종목별 메인계정설정이 되어 있다면 해당 계정으로 쿠키를 설정합니다.
   	'	../Libary/ajax_config.asp
		'	LIST_SPORTSTYPE	 = |SD|judo|tennis|bike...  [|SD] 제외 이후 문자사용

   	dim txt_SportsGb : txt_SportsGb = split(mid(LIST_SPORTSTYPE, 4, len(LIST_SPORTSTYPE)), "|")

      redim str_Cookie(Ubound(txt_SportsGb))

   		FOR i = 1 To Ubound(txt_SportsGb)
			str_Cookie(i) = SET_INFO_COOKIE(UserID, txt_SportsGb(i), saveid) '쿠키세팅
		NEXT


			'5. 자동로그인 기능
			IF saveid = "Y" then
				response.Cookies("SD").expires 	= Date() + 365
			Else
				response.Cookies("SD").expires 	= Date() + 1
			End IF

			Response.Write "TRUE|"&chk_User&"|"&UserName&"|"&BirthDay
			Response.End

	ELSE

			Response.Write "FALSE|99"
			Response.End

	END IF

    LRs.Close
		SET LRs = Nothing

		DBClose3()

	End IF


%>
