<%
cookiesInfo = request.cookies("tennisinfo")

If cookiesInfo <> "" Then
	cookiesInfoArr =  Split(f_dec(cookiesInfo), "_`_")
	ck_id = cookiesInfoArr(0)
	ck_hostcode = cookiesInfoArr(1)
	ck_gubun = cookiesInfoArr(2)
End if


	se_userid				= f_dec(session("user_id"))
	se_hostcode		= f_dec(session("hostcode"))
	se_gubun				= f_dec(session("gubun"))


	ADGRADE = 700
	If ck_id = "widline1234" Then 'password widline4321
		'999최고 운영자는 500번부터
		ADGRADE = 900
	End if



'1. 통합계정 쿠키

	Cookies_id = Request.Cookies("SD")("UserID")
	Cookies_name = Request.Cookies("SD")("UserName")
	Cookies_birth = decode(Request.Cookies("SD")("UserBirth"), 0)
	Cookies_midx = decode(Request.Cookies("SD")("MemberIDX"), 0)

'2. 종목(SportsGn=bike 자전거) 계정쿠키
If Request.Cookies("SD") <> "" Then
	C_SportsGb = "bike"

  Set db = new clsDBHelper
    ' player table에 있는지 확인후 없으면 insert
    ' If USER_IP = "118.33.86.240" Then
    Dim checkUserBirth, checkUserName, checkUserPhone, checkUserSex
    checkUserBirth = decode(Request.Cookies("SD")("UserBirth"),0)
    checkUserName = Request.Cookies("SD")("UserName")
    checkUserPhone = decode(Request.Cookies("SD")("UserPhone"),0)
    checkUserSex = Request.Cookies("SD")("Sex")

    checkPlayerSQL = " SELECT TOP 1 PlayerIDX, ISNULL(ProfileIMG, '') ProfileIMG, EnterType FROM SD_Bike.dbo.sd_bikePlayer WHERE Birthday = '"& checkUserBirth &"' AND UserName = '"& checkUserName &"' AND DelYN = 'N' "

    Set rs = db.ExecSQLReturnRS(checkPlayerSQL , null, ConStr)
      If rs.eof Then
        insertPlayerSQL = " INSERT INTO SD_Bike.dbo.sd_bikePlayer (SportsGb, UserName, UserPhone, Birthday, Sex, DelYN, EnterType, WriteDate) "
        insertPlayerSQL = insertPlayerSQL & "VALUES ( 'bike', '"& checkUserName &"', '"& checkUserPhone &"', '"& checkUserBirth &"', '"& checkUserSex &"', 'N', 'A', GETDATE() ) "
        Call db.ExecSQLReturnRS(insertPlayerSQL , null, ConStr)
      End If

    Set rs = db.ExecSQLReturnRS(checkPlayerSQL , null, ConStr)
    Dim cbike_pidx, cbike_purl, cbike_entertype, cbike_ptype, cbike_name, cbike_midx
    cbike_pidx = rs("PlayerIDX")
    cbike_purl = rs("ProfileIMG")
    cbike_entertype = rs("EnterType")
    cbike_ptype = "R" ' R:선수
    cbike_name = checkUserName
    cbike_midx = decode(Request.Cookies(C_SportsGb)("MemberIDX"), 0)

    ' sd_bike.tblmember table에 있는지 확인후 없으면 insert
    checkMemberSQL = " SELECT * FROM sd_bike.dbo.tblMember WHERE SD_UserID = '"& Cookies_id &"' AND DelYN = 'N' "
    Set rs = db.ExecSQLReturnRS(checkMemberSQL , null, ConStr)
    If rs.eof Then
      insertMemberSQL = " INSERT INTO dbo.tblMember ( SD_UserID, SD_GameIDSET, UserName, PlayerIDX, PlayerReln, EnterType, SrtDate, WriteDate, InsDate, InsID, ModDate ) "
      insertMemberSQL = insertMemberSQL & " VALUES ( '"& Cookies_id &"', 'Y', '"& cbike_name &"', "& cbike_pidx &", 'R', 'A', CONVERT(VARCHAR(8), GETDATE(), 112), GETDATE(), GETDATE(), '"& Cookies_id &"', GETDATE() ) "
      Call db.ExecSQLReturnRS(insertMemberSQL , null, ConStr)
    End If

    db.dispose()
    ' End If
  End If




	' cbike_midx = decode(Request.Cookies(C_SportsGb)("MemberIDX"), 0)  		'회원IDX
	' cbike_pidx = decode(Request.Cookies(C_SportsGb)("PlayerIDX"), 0) 			'선수IDX
	' cbike_purl = decode(Request.Cookies(C_SportsGb)("PhotoPath"), 0)			'회원프로필 이미지
	' cbike_ptype = decode(Request.Cookies(C_SportsGb)("PlayerReln"), 0) 		'회원구분	 부모[A:부 B:모 Z:기타],  R:선수 , T:지도자
	' cbike_entertype = Request.Cookies(C_SportsGb)("EnterType") 					'선수구분[E:엘리트 | A:아마추어]
	' cbike_name = Request.Cookies(C_SportsGb)("UserName")   						'사용자명


'관리자
If LCase(URL_HOST) = "bikeadmin.sportsdiary.co.kr" Then
	iLoginID = Request.Cookies("UserID")
	iLoginID = decode(iLoginID,0)
	iLoginName = Request.Cookies("UserName")
End if

%>
