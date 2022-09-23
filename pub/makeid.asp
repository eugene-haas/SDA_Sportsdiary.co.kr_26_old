<!-- #include virtual = "/pub/header.radingAdmin.asp" -->
<%



'## 접속 사용자 아이피##################
USER_IP = Request.ServerVariables("HTTP_X_FORWARDED_FOR")
If Len(USER_IP) = 0 Then USER_IP = Request.ServerVariables("REMOTE_ADDR")


If USER_IP <> "118.33.86.240" Then
	Response.end
End if

    '===============================================================================
	' 랜덤 PW를 얻는다. 
	'===============================================================================
	Function GetRandomPasswd(keyLen)
		Dim arySrc(6), aryLen(6), max, r1, r2, i, j, ul, len1
		arySrc(0) = "abcdefghijklmnopqrstuvwxyz"
		arySrc(1) = "0123456789"
		arySrc(2) = "~!@#$%^&*()_+"
		arySrc(3) = "0123456789~!@#$%^&*()_+"
		arySrc(4) = "0123456789~!@#$%^&*()_+abcdefghijklmnopqrstuvwxyz"
		arySrc(5) = "@#$%^&*()_+abcdefghijklmnopqrstuvwxyz"

		ul = UBound(arySrc)
		serialCode = ""
		For i = 0 To ul
			len1 = Len(arySrc(i))
			aryLen(i) = len1
		Next
		
		For j = 0 To keyLen
			r1 = GetRandomNum(ul) -1
			r2 = GetRandomNum(aryLen(r1))
			serialCode = serialCode + Mid(arySrc(r1),r2,1)
		Next
		
		GetRandomPasswd = serialCode
	End Function

    '===============================================================================
	' 랜덤 Id를 얻는다.  strBase + random string
	'===============================================================================
	Function GetRandomID(strBase, keyLen)
		Dim arySrc(3), aryLen(3), max, r1, r2, i, j, ul, len1
		arySrc(0) = "abcdefghijklmnopqrstuvwxyz"
		arySrc(1) = "0123456789"
		arySrc(2) = "abcdefghijklmnopqrstuvwxyz0123456789"

		ul = UBound(arySrc)
		serialCode = ""
		For i = 0 To ul
			len1 = Len(arySrc(i))
			aryLen(i) = len1
		Next
		
		For j = 0 To keyLen
			r1 = GetRandomNum(ul) -1
			r2 = GetRandomNum(aryLen(r1))
			serialCode = serialCode + Mid(arySrc(r1),r2,1)
		Next
		
		GetRandomID = strBase & serialCode
	End Function 

    '===============================================================================
	' 랜덤 숫자를 얻는다. 
	'===============================================================================
	Function GetRandomNum(nRange)
		Randomize
		GetRandomNum = (Int(nRange * Rnd) + 1)
	End Function 	


Response.write "<table>"
For i = 1 To 1000

Response.write"<tr>"
Response.write  "<td>" & GetRandomID("wd_",6) & 	"</td><td>"	& GetRandomPasswd(13) & "</td>"
Response.write"</tr>"
next
Response.write "</table>"

%>

</body>
</html>