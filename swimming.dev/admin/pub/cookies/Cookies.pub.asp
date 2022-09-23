<script language="Javascript" runat="server">
function IsJsonString(str) {
  try {
    var json = JSON.parse(str);
    return (typeof json === 'object');
  } catch (e) {
    return false;
  }
}	
</script>


<%
'관리자 로그인 
Cookies_adminID = request.Cookies("saveid") 
Cookies_adminEncode = request.Cookies(COOKIENM) 


'#################################
'객체인지 파악하고 아니라면
'#################################
If Cookies_adminEncode <> "" Then
	Cookies_adminDecode =  f_dec(Cookies_adminEncode)

	If IsJsonString(Cookies_adminDecode) = false Then
			for each Item in request.cookies
					Response.cookies(item).expires	= DateAdd("d",-10000,now())		 'date - 365
					Response.cookies(item).domain	= CHKDOMAIN	
			Next
	End If
End if
'#################################






If Cookies_adminEncode <> "" Then
	Cookies_adminDecode =  f_dec(Cookies_adminEncode)

	Set adCookies = JSON.Parse(Cookies_adminDecode)

	If hasown(adCookies, "aIDX") = "ok" Then				'관리자키
		Cookies_aIDX =	 chkInt(adCookies.aIDX,0)
	End If
	If hasown(adCookies, "aID") = "ok" Then				'아이디
		Cookies_aID =	 adCookies.aID
	End If
	If hasown(adCookies, "aNM") = "ok" Then				'이름
		Cookies_aNM =	 adCookies.aNM
	End If
	If hasown(adCookies, "aAUTH") = "ok" Then			'권한
		Cookies_AUTH =	 adCookies.aAUTH
	End If

	Select Case Cookies_AUTH
	Case "A" : ADGRADE = 900
	Case "B" : ADGRADE = 700
	Case "C" : ADGRADE = 500 '여기서부터 현장운영자
	Case "D" : ADGRADE = 300
	Case "E" : ADGRADE = 200
	Case Else
		If pagename <> "admlogin.asp" then
		Response.redirect  "/pub/admlogin.asp"
		Response.End
		End if
	End Select 
End If


'앱 로그인 쿠키 (루키테니스)
Cookies_SD =  request.Cookies("SD") '통합계정정보
Cookies_PI =   request.Cookies("RookeiPI") '루키테니스플레이어 정보
Cookies_stateNo = 0

'############################
'앱에 사용중인것 복사해둠
'############################
If SportsGb = "" Then
	SportsGb = "tennis"
End if
iLIUserID = Request.Cookies("SD")("UserID")
iLIMemberIDX = Request.Cookies(SportsGb)("MemberIDX")
iLIMemberIDXd = decode(iLIMemberIDX,0)
iLISportsGb = SportsGb
'############################




'############################
'체크 사이트코드
'사이트 생성시 설정 할수분 
'############################
Select Case sitecode
Case "RTN01","SWN01","RDN01","SWN02"
	Cookiemake = True
Case Else
	Cookiemake = False
End Select 

If Cookies_SD <> "" And  (Cookiemake = true) Then
	Cookies_sdId =  request.Cookies("SD")("UserID")
	Cookies_sdBth =  decode(request.Cookies("SD")("UserBirth"),0)  
	Cookies_sdNm =  request.Cookies("SD")("UserName")  
	Cookies_sdPhone =  decode(request.Cookies("SD")("UserPhone"),0)  
	Cookies_sdIdx =   decode(request.Cookies("SD")("MemberIDX"),0) 
	Cookies_sdSave =   request.Cookies("SD")("SaveIDYN") 
	Cookies_sdSex =   request.Cookies("SD")("Sex")


	If USER_IP = "118.33.86.240" Then
	'Response.write "<script>alert(1);</script><span style='font-size:20px;'>"& LCase(URL_PATH) & "</span>"
	'Response.End
	End if

	If pagename = "write.asp" Or pagename = "list.asp" then 
		Select Case LCase(URL_HOST & URL_PATH)
		Case LCase(URL_HOST) & "/list.asp", LCase(URL_HOST) & "/request/list.asp", LCase(URL_HOST) & "/tnrequest/list.asp"
			G_pathcheck = True
		Case LCase(URL_HOST) & "/write.asp", LCase(URL_HOST) & "/request/write.asp", LCase(URL_HOST) & "/tnrequest/write.asp"
			G_pathcheck = True		
		Case Else
			G_pathcheck = false
		End Select
	Else
		G_pathcheck = false
	End if



	'쿠키갱신###################################
	'resetcookie =   request.Cookies("ResetC") '갱신여부
	'If resetcookie = "" then	
		Cookies_PI = ""
		'Response.Cookies("ResetC") = "ok"
		'Response.Cookies("ResetC").domain = URL_HOST
	'End if
	'쿠키갱신###################################



	If pagename <> "admlogin.asp" then
	If sitecode = "RTN01" Or sitecode = "SWN01" Then '공통으로 사용하니 만큼 가급적 디비 작업은 하지 말자 이것이외에 이것때문에 영향을 안받도록 조심해야함...
	If Cookies_PI = "" Or G_pathcheck = True  then
		'테니스 플레이어 정보가 있다면 셋팅 (미리 내용을 넣어두어야할까?)
		Set db = new clsDBHelper

			'kata 회원여부 검사 (막힘 품  >>
			'\pub\api\RookieTennis\mobile\api.searchMember.asp
			'\pub\api\RookieTennisAdmin\gameplayer\api.memberWindow.asp
			SQL = "select top 1 playeridx from SD_Tennis.dbo.tblPlayer where username = '"&Cookies_sdNm&"' and userphone = '"&Replace(Cookies_sdPhone,"-","")&"' "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			If rs.eof Then '참가가능
				Cookies_kata = "N"
			Else '참가불가
				Cookies_kata = "N"
			End if

			pfieldstr = "PlayerIDX , TeamGb,belongBoo, userlevel,Team,TeamNm,Team2,Team2Nm,userLevel,sidogu,gamestartyymm    ,gameday,dblrnk,stateNo,sayou,lastorder,sdpoint,firstcount, levelup "
			SQL = "Select "&pfieldstr&" from tblPlayer where MemberIDX = " & Cookies_sdIdx
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			If rs.eof Then

				'***'만약 동일 이름 전화번호로 가입후 탈퇴이력이 있다고 가정하고  tblplayer 에서 찾아서 delYN = Y ***
				SQL = "update tblPlayer Set delYn = 'Y' where username = '"&Cookies_sdNm&"' and userphone = '"&Cookies_sdPhone&"' "
				Call db.execSQLRs(SQL , null, ConStr) 


				i_field = "MemberIDX,UserName,Userphone,birthday,sex ,userid"
				i_value = Cookies_sdIdx & ", '" &Cookies_sdNm& "', '" &Cookies_sdPhone& "', '" &Cookies_sdBth& "', '" &Cookies_sdSex& "', '"&Cookies_sdId&"' "
				SQL = "Insert Into tblPlayer ("&i_field&") values ("&i_value&")" 

				
				If USER_IP = "118.33.86.240" Then
					'Response.write sql
					'Response.end
				End if
				
				Call db.execSQLRs(SQL , null, ConStr) 
			
				SQL = "Select "&pfieldstr&" from tblPlayer where MemberIDX = " & Cookies_sdIdx
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

				Cookies_pidx = rs(0)

				Cookies_teamGB = rs(1)
				Cookies_Boo = rs(2)

				Cookies_grade = rs(3)
				Cookies_t1code = rs(4)
				Cookies_t1name = rs(5)
				Cookies_t2code = rs(6)
				Cookies_t2name = rs(7)
				Cookies_playerlevel = rs(8) '쓰 두개 써놨네 뒤에 쓰나...ㅡㅡ
				Cookies_sidogu = rs(9)
				Cookies_gamestartyymm = rs(10)
				Cookies_gameday = rs(11)
				Cookies_dblrnk = rs(12)
				Cookies_stateNo = rs(13)
				Cookies_sayou = rs(14)
				Cookies_lastorder = rs(15)
				Cookies_sdpoint = rs(16)
				Cookies_firstcnt = rs(17)
				player_levelup  = rs("levelup")
			else
				Cookies_pidx = rs(0)
				Cookies_teamGB = rs(1)
				Cookies_Boo = rs(2)
				Cookies_grade = rs(3)
				Cookies_t1code = rs(4)
				Cookies_t1name = rs(5)
				Cookies_t2code = rs(6)
				Cookies_t2name = rs(7)
				Cookies_playerlevel = rs(8)
				Cookies_sidogu = rs(9)
				Cookies_gamestartyymm = rs(10)

				Cookies_gameday = rs(11)
				Cookies_dblrnk = rs(12)
				Cookies_stateNo = rs(13)
				Cookies_sayou = rs(14)
				Cookies_lastorder = rs(15)
				Cookies_sdpoint = rs(16)
				Cookies_firstcnt = rs(17)
				player_levelup  = rs("levelup")
			End If

			

			'tblPlayer.stateNO 상태 : 0 기본 / 1 박탈 /  원스타승급 100 승급  / 200 투스타 승급 /201( 투스타 승급박탈 )
			If CDbl(Cookies_stateNo) =  200 And Cookies_dblrnk = "Y" And CDbl(player_levelup)  <  CDbl(nowyear)   And (Cookies_teamGB = "20102" Or  Cookies_teamGB = "20105" )  Then
				'업데이트 하고
				SQL = "update tblPlayer Set stateNo = '201' where PlayerIDX = "&Cookies_pidx & " " '승급자 지위 초기화
				Call db.execSQLRs(SQL , null, ConStr) 
				Cookies_stateNo = "201"
			End if

			'playerCookie Create
			Set pobj = JSON.Parse("{}")					
			Call pobj.Set("pidx", Cookies_pidx )
			Call pobj.Set("tgb", Cookies_teamGB )
			Call pobj.Set("boo", Cookies_Boo )
			Call pobj.Set("gd", Cookies_grade )
			Call pobj.Set("t1cd", Cookies_t1code )
			Call pobj.Set("t1nm", Cookies_t1name )
			Call pobj.Set("t2cd", Cookies_t2code )
			Call pobj.Set("t2nm", Cookies_t2name )
			Call pobj.Set("plvl", Cookies_level )
			Call pobj.Set("sidogu", Cookies_sidogu )
			Call pobj.Set("syymm", Cookies_gamestartyymm )

			Call pobj.Set("gameday", Cookies_gameday ) '승급일
			Call pobj.Set("dblrnk", Cookies_dblrnk ) '승급여부 YN
			Call pobj.Set("stateno", Cookies_stateNo ) '상태 : 0 기본 / 1 박탈 /  100 승급  / 101( 투스타 승급박탈 )
			Call pobj.Set("sayou", Cookies_sayou ) '박탈 사유
			Call pobj.Set("lastorder", Cookies_lastorder ) '마지막이력 1 2 3 순위 0 기본값
			Call pobj.Set("sdpt", Cookies_sdpoint ) '랭킹포인트
			Call pobj.Set("kata", Cookies_kata ) '카타선수여부
			Call pobj.Set("fcnt", Cookies_firstcnt ) '1등횟수




			strjson = JSON.stringify(pobj)
			strjson = f_enc(strjson)
			Response.Cookies("RookeiPI") = strjson
			'Response.Cookies("RookeiPI").domain = CHKDOMAIN
			Response.Cookies("RookeiPI").domain = URL_HOST '쿠키갯수 넘침제거
			'response.cookies("RookeiPI").expires 	= Cookies_savedate
			Set pobj = nothing

			Call db.Dispose
			Set db = Nothing
	Else
		Cookies_PI = f_dec(Cookies_PI)
		Set objPlayerInfo = JSON.Parse(Cookies_PI)

		If hasown(objPlayerInfo, "pidx") = "ok" Then
			Cookies_pidx =	 chkInt(objPlayerInfo.pidx,0)
		End If
		If hasown(objPlayerInfo, "tgb") = "ok" Then
			Cookies_teamGB =	 objPlayerInfo.tgb
		End If
		If hasown(objPlayerInfo, "boo") = "ok" Then
			Cookies_Boo =	 objPlayerInfo.boo
		End If
		If hasown(objPlayerInfo, "gd") = "ok" Then
			Cookies_grade =	 objPlayerInfo.gd
		End If
		If hasown(objPlayerInfo, "t1cd") = "ok" Then
			Cookies_t1code =	 objPlayerInfo.t1cd
		End If
		If hasown(objPlayerInfo, "t1nm") = "ok" Then
			Cookies_t1name =	 objPlayerInfo.t1nm
		End If
		If hasown(objPlayerInfo, "t2cd") = "ok" Then
			Cookies_t2code =	 objPlayerInfo.t2cd
		End If
		If hasown(objPlayerInfo, "t2nm") = "ok" Then
			Cookies_t2name =	 objPlayerInfo.t2nm
		End If
		If hasown(objPlayerInfo, "plvl") = "ok" Then
			Cookies_playerlevel =	 objPlayerInfo.plvl
		End If
		If hasown(objPlayerInfo, "sidogu") = "ok" Then
			Cookies_sidogu =	 objPlayerInfo.sidogu
		End If
		If hasown(objPlayerInfo, "syymm") = "ok" Then
			Cookies_gamestartyymm =	 objPlayerInfo.syymm
		End If

		If hasown(objPlayerInfo, "gameday") = "ok" Then
			Cookies_gameday =	 objPlayerInfo.gameday
		End If
		If hasown(objPlayerInfo, "dblrnk") = "ok" Then  '승급여부 YN
			Cookies_dblrnk =	 objPlayerInfo.dblrnk
		End If
		If hasown(objPlayerInfo, "stateno") = "ok" Then  '상태 0 1 2 기본, 승급 , 박탈 (1별에서 2별로온 승급자 2)
			Cookies_stateNo =	 objPlayerInfo.stateno
		End If
		If hasown(objPlayerInfo, "sayou") = "ok" Then  '박탈 사유
			Cookies_sayou =	 objPlayerInfo.sayou
		End If
		If hasown(objPlayerInfo, "lastorder") = "ok" Then '마지막이력 1 2 3 순위 0 기본값
			Cookies_lastorder =	 objPlayerInfo.lastorder
		End If
		If hasown(objPlayerInfo, "sdpt") = "ok" Then'랭킹포인트
			Cookies_sdpoint =	 objPlayerInfo.sdpt
		End If
		If hasown(objPlayerInfo, "kata") = "ok" Then '카타선수여부	 YN
			Cookies_kata =	 objPlayerInfo.kata
		End If
		If hasown(objPlayerInfo, "fcnt") = "ok" Then '1등 횟수
			Cookies_firstcnt =	 objPlayerInfo.fcnt
		End If

	End If
	End If
	End if

End If










'테블릿#####################
cookiesInfo = request.cookies("tennisinfo")
If cookiesInfo <> "" Then
	cookiesInfoArr =  Split(f_dec(cookiesInfo), "_`_")
	ck_id = cookiesInfoArr(0)
	ck_hostcode = cookiesInfoArr(1)
	ck_gubun = cookiesInfoArr(2)
End if
'테블릿#####################



'승마 전역변수로 사용할 쿠키 불러오기
	Cookies_RDOBJ = request.Cookies("RDOBJ") 
	If Cookies_RDOBJ <> "" Then
		Set RDINFOCookies = JSON.Parse(Cookies_RDOBJ)
		If hasown(RDINFOCookies, "kgame") = "ok" Then
			Cookies_kgame =	RDINFOCookies.kgame
		End If
	End If
'승마 전역변수로 사용할 쿠키 불러오기	
%>
