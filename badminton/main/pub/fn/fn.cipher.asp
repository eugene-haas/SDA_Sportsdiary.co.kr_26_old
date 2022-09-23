<%
	Const conKey = "w암호화 비밀키"
	Const conIV = "w초기화 벡터"

	
	Function f_enc(ByVal word)
		
		If chkBlank(word) Then Exit Function
		Set objEncrypter = Server.CreateObject("Ryeol.StringEncrypter")
 		objEncrypter.Key = conKey
		objEncrypter.IV = conIV
 
		' 키 해시 알고리즘 설정. MD5 와 SHA2-256 을 지원합니다.
		' 아래 코드는 해시 크기가 256 비트이기 때문에, AES-256 이 사용됩니다.
		objEncrypter.KeyHashAlgorithm = "SHA2-256"
 
		' 문자열 암호화
		f_enc =objEncrypter.Encrypt(word)
		Set objEncrypter = Nothing
	End Function

	Function f_dec(ByVal cipher_word)
		'Response.write "<script>alert('"&cipher_word&"')</script>"
		If chkBlank(cipher_word) Then Exit Function
		Set objEncrypter = Server.CreateObject("Ryeol.StringEncrypter")
 		objEncrypter.Key = conKey
		objEncrypter.IV = conIV
 
		' 키 해시 알고리즘 설정. MD5 와 SHA2-256 을 지원합니다.
		' 아래 코드는 해시 크기가 256 비트이기 때문에, AES-256 이 사용됩니다.
		objEncrypter.KeyHashAlgorithm = "SHA2-256"
 
		' 문자열 복호화
		f_dec = objEncrypter.Decrypt(cipher_word)
		Set objEncrypter = Nothing
	End Function












'	'###### AES 암호화 키 ######
'	Set sha256 = new clsSHA256
'	CIPHER_KEY = sha256.sha256("(AbCd!@#$)")
'	Set sha256 = Nothing
'	'###### AES 암호화 키 끝 ######
'
'	'문자열자리수 까지(암호화자리수)
'	'~28(64) / ~60(128) / ~92(192) / ~124(256) / ...32+(64+)
'	Function encryption(ByVal word)
'		If chkBlank(word) Then Exit Function
'
'		Set aes = new clsAES
'		enCryption = aes.AESEncrypt(word, CIPHER_KEY)
'		Set aes = Nothing
'	End Function
'
'	Function decryption(ByVal cipher_word)
'		If chkBlank(cipher_word) Then Exit Function
'
'		Set aes = new clsAES
'		deCryption = aes.AESDecrypt(cipher_word, CIPHER_KEY)
'		Set aes = Nothing
'	End Function
'
'
'	Function encryptionByPw(ByVal word, ByVal pw)
'		If chkBlank(word) Then Exit Function
'
'		Set aes = new clsAES
'		EncryptionByPw = aes.AESEncrypt(word, pw)
'		Set aes = Nothing
'	End Function
'
'
'	Function decryptionByPw(ByVal cipher_word, ByVal pw)
'		If chkBlank(cipher_word) Then Exit Function
'
'		Set aes = new clsAES
'		DecryptionByPw = aes.AESDecrypt(cipher_word, pw)
'		Set aes = Nothing
'	End Function
'
'
'	Function base64Encryption(ByVal word)
'		Set base = new BASE64
'			base64Encryption = base.EncodeA(word)
'		Set base = Nothing
'	End Function
'
'
'	Function base64Decryption(ByVal word)
'		Set base = new BASE64
'			base64Decryption = base.DecodeA(word)
'		Set base = Nothing
'	End Function
'
'
'	Function createMD5(ByVal word)
'		If chkBlank(word) Then Exit Function
'
'		Set md = new md5
'			createMD5 = md.MD5(word)
'		Set md = Nothing
'	End Function
%>