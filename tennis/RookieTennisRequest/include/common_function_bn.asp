<%
 M_conKey = "w암호화 비밀키" ' 암호화 비밀키
	'M_conIV = Replace(USER_IP,".","") & "초기화 백터" '초기화 벡터 (결제중 아이피가 변경되면 오류발생가능성 ) 
	'M_conIV = Replace(date,"-","") & "초기화 백터" '초기화 벡터 (자정문제발생)
	M_conIV = year(date) & "초기화 백터" '초기화 벡터 (자정문제발생)


	Function mallEncode(ByVal word, ByVal zero)

		'If chkBlank(word) Then Exit Function
		Set objEncrypter = Server.CreateObject("Ryeol.StringEncrypter")
	 	objEncrypter.Key = M_conKey
		objEncrypter.IV = M_conIV

		' 키 해시 알고리즘 설정. MD5 와 SHA2-256 을 지원합니다.
		' 아래 코드는 해시 크기가 256 비트이기 때문에, AES-256 이 사용됩니다.
		objEncrypter.KeyHashAlgorithm = "SHA2-256"

		' 문자열 암호화
		mallEncode =objEncrypter.Encrypt(word)
		Set objEncrypter = Nothing
	End Function

%>