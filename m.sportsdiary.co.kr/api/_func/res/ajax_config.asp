<% @CODEPAGE="65001" language="vbscript" %>
<%
	Response.Expires = -1
	Response.ExpiresAbsolute = now() - 1
	Response.ContentType = "text/html;charset=utf-8"
	Response.CacheControl = "no-cache"
	Response.CacheControl = "private"
	Response.CodePage = "65001"
	Session.codepage = "65001"

	
	Const Ref = "GPQRSATWXVYBCHL640MN598OIJKZ12D7EF3U"
	
	' 암호화
	Function encode(str, chipVal)
		Dim Temp, TempChar, Conv, Cipher, i: Temp = ""
		
		chipVal = CInt(chipVal)
		str = StringToHex(str)
		
		For i = 0 To Len(str) - 1
			TempChar = Mid(str, i + 1, 1)
			Conv = InStr(Ref, TempChar) - 1
			Cipher = Conv Xor chipVal
			Cipher = Mid(Ref, Cipher + 1, 1)
			Temp = Temp + Cipher
		Next

		encode = Temp

	End Function
	
	' 복호화
	Function decode(str, chipVal)	      
		Dim Temp, TempChar, Conv, Cipher, i: Temp = ""
	
		chipVal = CInt(chipVal)
		
		For i = 0 To Len(str) - 1
		  TempChar = Mid(str, i + 1, 1)
		  Conv = InStr(Ref, TempChar) - 1
		  Cipher = Conv Xor chipVal
		  Cipher = Mid(Ref, Cipher + 1, 1)
		  Temp = Temp + Cipher
		Next
		
		Temp = HexToString(Temp)
		decode = Temp
		
	End Function


%>