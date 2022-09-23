<%
	'----------------------------------------------------------------------
	'@description
	'	입력된 데이터 공백, null 체크 후 Boolean 값을 반환한다.
	'@param
	'	(string) value : 데이터값
	'@return
	'	(Boolean) true or false
	'----------------------------------------------------------------------
	Function chkBlank(ByVal value)
		If Trim(value) = "" Or Len(Trim(value)) = 0 Or IsNull(value) Or IsEmpty(value)  Then
			chkBlank = True
		Else
			chkBlank = False
		End If
	End Function
%>
<!-- #include virtual = "/api/fn/fn.cipher.asp" --><%'암호화%>
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
URL_HOST   	= Request.ServerVariables("HTTP_HOST")
CHKDOMAIN 	= mid(URL_HOST,instr(URL_HOST,".")+1)

'#관라자와 홈 기타등등 구분#################
SITECODE = "EVAL2" '디비자리수 5
COOKIENM = SITECODE  '생성되는 쿠키명
'##########################################


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

			Call oJSONoutput.Set("errorcode", "ERR-2000" ) '서버에서 메시지 생성 전달
			Call oJSONoutput.Set("servermsg", "잘못된 접근입니다." ) '서버에서 메시지 생성 전달
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.end

	End If
Else
	Cookies_adminDecode = "''"
End if
%>