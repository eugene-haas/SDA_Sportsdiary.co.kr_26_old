<!--METADATA TYPE= "typelib"  NAME= "ADODB Type Library" FILE="C:\Program Files\Common Files\SYSTEM\ADO\msado15.dll"  -->
<!-- #include virtual = "/pub/charset.asp" -->
<!-- #include virtual="/pub/class/json2.asp" -->
<%
		M_conKey = "w암호화 비밀키" ' 암호화 비밀키
		M_conIV = year(date) & "초기화 백터" '초기화 벡터 (자정문제발생)

		Function chkBlank(ByVal value)
			If Trim(value) = "" Or Len(Trim(value)) = 0 Or IsNull(value) Or IsEmpty(value)  Then
				chkBlank = True
			Else
				chkBlank = False
			End If
		End Function


		Function mallEncode(ByVal word, ByVal zero)
			'If chkBlank(word) Then Exit Function
			Set objEncrypter = Server.CreateObject("Ryeol.StringEncrypter")
	 		objEncrypter.Key = M_conKey
			objEncrypter.IV = M_conIV
			objEncrypter.KeyHashAlgorithm = "SHA2-256"
			mallEncode =objEncrypter.Encrypt(word)
			Set objEncrypter = Nothing
		End Function

		Function malldecode(ByVal cipher_word, ByVal zero)
			'If chkBlank(cipher_word) Then Exit Function
			Set objEncrypter = Server.CreateObject("Ryeol.StringEncrypter")
	 		objEncrypter.Key = M_conKey
			objEncrypter.IV = M_conIV
			objEncrypter.KeyHashAlgorithm = "SHA2-256"
			malldecode = objEncrypter.Decrypt(cipher_word)
			Set objEncrypter = Nothing
		End Function


		Function shopBNLink(ByVal Cookies_midx, ByVal bnurl)
			Dim strjson
			If Cookies_midx = "" Then
				shopBNLink = "로그인페이지로"
			else
				Set mallobj =  JSON.Parse("{}")
				Call mallobj.Set("M_MIDX", Cookies_midx ) '로그인이 필요없이 이동할때 0
				Call mallobj.Set("M_PR", "R" ) 'R: 선수 S:예비후보선수, L:지도자, A,B,Z:보호자, D:일반
				Call mallobj.Set("M_SGB", "judo" )
				Call mallobj.Set("M_BNKEY", bnurl) '베너URL 찾아서 보냄 상품코드가 있을시는 ? ...
				strjson = JSON.stringify(mallobj)
				malljsondata = mallencode(strjson,0)

				shopBNLink = "http://www.sdamall.co.kr/pub/" & Server.URLEncode(malljsondata)
			End If
		End Function
%>
		<br>
		<a href='<%=shopBNLink("123456", "http://www.widline.co.kr")%>' class="orange-btn" target="_blank">안드로이드폰전송</a>
		<br><br><br>
		<a onclick='alert("<%=shopBNLink("123456", "http://www.widline.co.kr")%>")' class="orange-btn">아이폰링크</a>
