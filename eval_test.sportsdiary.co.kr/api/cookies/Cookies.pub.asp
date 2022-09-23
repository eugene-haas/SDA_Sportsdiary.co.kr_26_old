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

	
		Cookies_aIDX 		= chkInt(adCookies.get("aIDX"),0) '관리자키
		Cookies_aID 		=	 adCookies.get("aID")'아이디
		Cookies_aNM 		=	 adCookies.get("aNM")	'이름
		Cookies_AUTH 		=	 adCookies.get("aAUTH")		'권한
		Cookies_aGrpIDX =	 adCookies.get("aGrpIDX") '협단체키
		Cookies_aGrpNM 	=	 adCookies.get("aGrpNM")	
	

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


If Cookies_SD <> ""  Then
	Cookies_sdId =  request.Cookies("SD")("UserID")
	Cookies_sdBth =  decode(request.Cookies("SD")("UserBirth"),0)  
	Cookies_sdNm =  request.Cookies("SD")("UserName")  
	Cookies_sdPhone =  decode(request.Cookies("SD")("UserPhone"),0)  
	Cookies_sdIdx =   decode(request.Cookies("SD")("MemberIDX"),0) 
	Cookies_sdSave =   request.Cookies("SD")("SaveIDYN") 
	Cookies_sdSex =   request.Cookies("SD")("Sex")
	Cookies_PI = ""
End If



%>
