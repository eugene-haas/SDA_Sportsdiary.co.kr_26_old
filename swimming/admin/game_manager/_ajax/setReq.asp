<!-- #include virtual = "/pub/fn/fn.cipher.asp" -->
<!-- #include virtual="/pub/class/JSON_2.0.4.asp" -->
<!-- #include virtual="/pub/class/JSON_UTIL_0.1.1.asp" -->
<!-- #include virtual="/pub/class/json2.asp" -->


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

			Call oJSONoutput.Set("result", 111 ) '서버에서 메시지 생성 전달
			Call oJSONoutput.Set("servermsg", "잘못된 접근입니다." ) '서버에서 메시지 생성 전달
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.end

	End If
Else
	'로그아웃
End if
'#################################


	JsonData = RequestJsonObject(request)
	'If JsonData = "{}" Then
	'	Response.End
	'End if

	'If request("test") = "t" Then
	'	JsonData = "{""CMD"":400,""LIDX"":11365,""inputId"":""다이빙_1"",""inputPw"":""1234""}"
	'End if

	Set oJSONoutput = JSON.Parse( join(array(JsonData)) )

	'CMD = oJSONoutput.Get("CMD")
	'If CMD <>  "200" And Cookies_adminEncode = "" Then '로그아웃아닌데 쿠키가 없다면
	'	Call oJSONoutput.Set("result", 111 ) '서버에서 메시지 생성 전달
	'	Call oJSONoutput.Set("servermsg", "로그아웃 되었습니다." ) '서버에서 메시지 생성 전달
	'	strjson = JSON.stringify(oJSONoutput)
	'End if

	'If CMD = ""  Then
	'	Response.end
	'End if
%>
