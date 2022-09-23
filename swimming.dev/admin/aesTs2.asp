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
	<!-- #include virtual = "/pub/html/swimming/html.head.lte.asp" -->
</head>
<body <%=CONST_BODY%>>
<div class="wrapper">
  <!-- #include virtual = "/pub/html/swimming/html.header.lte.asp" -->
  <!-- #include virtual = "/pub/html/swimming/html.left.lte.asp" -->

  <!-- Content Wrapper. Contains page content -->
  <div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
      <h1>
        ...
        <small><!-- Control panel --></small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li class="active">Dashboard</li>
      </ol>
    </section>
	<!-- Main content -->
    <section class="content">











  
  
  
  
<%'  <!-- #include virtual = "/pub/class/aes.asp" -->%>
  aes256테스트<br>

<%
aKey = "cmr!@server_1234"
aIV = "cmr!@server_1234"


set crypt = Server.CreateObject("Chilkat_9_5_0.Crypt2")
success = crypt.UnlockComponent("YJKMKR.CB10118_vNZ9zq4wnw7P")
crypt.CryptAlgorithm = "aes"


'CipherMode may be "ecb", "cbc", "ofb", "cfb", "gcm", etc.
crypt.CipherMode = "cbc"

'KeyLength may be 128, 192, 256
crypt.KeyLength = 256

crypt.PaddingScheme = 0
crypt.EncodingMode = "hex"


Response.write crypt.KeyLength  & "<br>"


'ivHex = "000167856675020A506Y0708090R7YA"
'crypt.SetEncodedIV ivHex,"hex"

'keyHex = "000167856675020A506Y0708090R7YA101411A2131D6415K16171H8191A"
'crypt.SetEncodedKey keyHex,"hex"

'crypt.SetEncodedIV akey
'crypt.SetEncodedKey aiv

'Function s2a(s)
'  ReDim a(Len(s) - 1)
'  Dim i
'  For i = 0 To UBound(a)
'      a(i) = Mid(s, i + 1, 1)
'  Next
'  s2a = a
'End Function
'
'Function s2h(s)
'  Dim a : a = s2a(s)
'  Dim i
'  For i = 0 To UBound(a)
'      a(i) = Right(00 & Hex(Asc(a(i))), 2)
'  Next
'  s2h = Join(a)
'End Function
'
'Function h2s(h)
'  Dim a : a = Split(h)
'  Dim i
'  For i = 0 To UBound(a)
'      a(i) = Chr("&H" & a(i))
'  Next
'  h2s = Join(a, "")
'End Function
'
'
'
'Response.write h2s(ivHex) & "<br>"






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
encNm2 = objEncrypter.Encrypt("홍길동2")
encB2 = objEncrypter.Encrypt("19881018")
Response.write encNm & "<br>"
Response.write encB & "<br>"
Response.write encNm2 & "<br>"
Response.write encB2 & "<br>"



'jsondata = Stream_BinaryToString( GetHTTPFile("http://106.250.187.82:8180/api/getMember.do?name="&encNm&"&birthday="&encB&"&api_key=532c6a8db578af72f7d1576abfbd2a00") , "utf-8" )	
jsondata = Stream_BinaryToString( GetHTTPFile("http://106.250.187.82:8180/api/getMember.do?name=YLu6BxAHf6pZ+iDVyCoueg==&birthday=rYKBAl74yHMgjPlsIbTI0Q==&api_key=532c6a8db578af72f7d1576abfbd2a00") , "utf-8" )

Response.write jsondata & "<br>"
Set obj = JSON.Parse( join(array(jsondata)) )

Response.write obj.result & "<br>"
'Response.write obj.count & "<br>"
'arrlen = sList.length

If hasown(obj, "list") = "ok" then
	Set sList = obj.list
End If

'Set aes = new clsAES 
'aaa = aes.AESEncrypt( "한글", "cmr!@server_1234")
'Response.write aes.AESDecrypt( aaa,  "cmr!@server_1234"  ) & "<br>"


'문자열 복호화
strDecrypted = objEncrypter.Decrypt(encNm) & "<br>"
strDecrypted = objEncrypter.Decrypt(encB) & "<br>"
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





<script type="text/javascript">
<!--
var sss = "cmr!@server_1234";
	console.log( sss.substring(0,16) );
//-->
</script>






    </section>
    <!-- /.content -->
  </div>

  <!-- /.content-wrapper -->
  <!-- #include virtual = "/pub/html/swimming/html.footer.lte.asp" -->


  <!-- Add the sidebar's background. This div must be placed
       immediately after the control sidebar -->
  <div class="control-sidebar-bg"></div>
</div>
<!-- ./wrapper -->



<!-- jQuery 2.2.0 -->
<script src="plugins/jQuery/jQuery-2.2.0.min.js"></script>
<!-- jQuery UI 1.11.4 -->
<script src="https://code.jquery.com/ui/1.11.4/jquery-ui.min.js"></script>
<script>
  $.widget.bridge('uibutton', $.ui.button);
</script>
<!-- Bootstrap 3.3.6 -->
<script src="/bootstrap/js/bootstrap.min.js"></script>

<!-- FastClick -->
<script src="/plugins/fastclick/fastclick.js"></script>
<!-- AdminLTE App -->
<script src="/dist/js/app.min.js"></script>




</body>
</html>
