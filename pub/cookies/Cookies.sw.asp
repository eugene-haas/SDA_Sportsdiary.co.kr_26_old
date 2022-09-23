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
	Cookies_PI = ""
	'쿠키갱신###################################

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



%>
