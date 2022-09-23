<!-- #include virtual = "/pub/header.swimmingAdmin.asp" -->
<%
	If Request.Cookies("UserID") = "" Then
		'Response.Write "<script>top.location.href='./Gate.asp'</script>"
		'Response.End
	End If

	If CDbl(ADGRADE) <= 500 Then
		'Response.redirect "./contest.asp"
		'Response.End
	End if
%>
<%
	Set db = new clsDBHelper

'##############################################
' 소스 뷰 경계
'##############################################
%>
<%=CONST_HTMLVER%>

<head>

</head>
<body <%=CONST_BODY%>>




  
  
  
  
  <!-- #include virtual = "/pub/class/aes.asp" -->
  aes256테스트<br>

<%
aKey = "cmr!@server_1234"
aIV = "cmr!@server_1234"

' 인스턴스 만들기
Set objEncrypter = Server.CreateObject("Ryeol.StringEncrypter")
objEncrypter.Key = aKey
objEncrypter.IV = aIV


' 키 해시 알고리즘 설정. MD5 와 SHA2-256 을 지원합니다.
' 아래 코드는 해시 크기가 256 비트이기 때문에, AES-256 이 사용됩니다.
objEncrypter.KeyHashAlgorithm = "SHA2-256"
' 문자열 암호화
encNm = objEncrypter.Encrypt("홍길동")
encB = objEncrypter.Encrypt("19820915")
Response.write encNm & "<br>"



'jsondata = Stream_BinaryToString( GetHTTPFile("http://106.250.187.82:8180/api/getMember.do?name="&encNm&"&birthday="&encB&"&api_key=532c6a8db578af72f7d1576abfbd2a00") , "utf-8" )	
jsondata = Stream_BinaryToString( GetHTTPFile("http://106.250.187.82:8180/api/getMember.do?name=YLu6BxAHf6pZ+iDVyCoueg==&birthday=rYKBAl74yHMgjPlsIbTI0Q==&api_key=532c6a8db578af72f7d1576abfbd2a00") , "utf-8" )

Response.write jsondata & "<br>"
Set obj = JSON.Parse( join(array(jsondata)) )

Response.write obj.result & "<br>"
Response.write obj.count & "<br>"
'arrlen = sList.length

If hasown(obj, "list") = "ok" then
	Set sList = obj.list
End If

'Set aes = new clsAES 
'aaa = aes.AESEncrypt( "test", "cmr!@server_1234")
'Response.write aes.AESDecrypt( aaa,  "cmr!@server_1234"  ) & "<br>"


'문자열 복호화
strDecrypted = objEncrypter.Decrypt(encNm)
Response.write strDecrypted & "<br>"

Response.write sList.Get(0).name
'Response.write   objEncrypter.Decrypt(sList.Get(0).name)


'Response.end
'
'Response.write   objEncrypter.Decrypt(sList.Get(0).name)
'
'
'For intloop = 0 To sList.length-1
'
'   Response.write sList.Get(0).member_id & "<br>"
'   'Response.write aes.AESDecrypt( "cmr!@server_1234",  sList.Get(0).name   ) & "<br>"
'   'Response.write f_dec(   sList.Get(0).name   ) & "<br>"
'
'
'
'   Response.write sList.Get(0).reg_dt & "<br>"
'   Response.write sList.Get(0).member_hash & "<br>"
'   Response.write sList.Get(0).sex & "<br>"
'Next




'Set sList = obj.ORD_INFO

'Response.write sList.length
'Set this = sList.Get(0)

'Response.write this.ORD_NO




%>




</body>
</html>
