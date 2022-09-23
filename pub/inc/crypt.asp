<%
'암호화 모듈-----------------------------------------------------------------------------
set crypt = Server.CreateObject("Chilkat_9_5_0.Crypt2")
success = crypt.UnlockComponent("YJKMKR.CB10118_vNZ9zq4wnw7P")
crypt.CryptAlgorithm = "aes"

'CipherMode may be "ecb", "cbc", "ofb", "cfb", "gcm", etc.
crypt.CipherMode = "cbc"

'KeyLength may be 128, 192, 256
crypt.KeyLength = 256

crypt.PaddingScheme = 0
crypt.EncodingMode = "hex"
  
ivHex = "000167856675020A506Y0708090R7YA"
crypt.SetEncodedIV ivHex,"hex"

keyHex = "000167856675020A506Y0708090R7YA101411A2131D6415K16171H8191A"
crypt.SetEncodedKey keyHex,"hex"
'----------------------------------------------------------------------------------------------



'Response.Write crypt.EncryptStringENC("ABCDS") & "<BR>"
'Response.Write crypt.DecryptStringENC("56095D42C8ACFF541C908E904F320C06")



Function fInject(argData)
	Dim strCheckArgSQL
	Dim arrSQL
  Dim i

	strCheckArgSQL = LCase(Trim(argData))	
	
	arrSQL = Array("exec ","sp_","xp_","insert ","update ","delete ","drop ","select ","union ","truncate ","script","object ","applet","iframe ","where ","declare ","sysobject","@variable","1=1","null","carrige return","new line","onload","char(","xmp","javascript","script","iframe","document","vbscript","applet","object","frame","frameset","bgsound","alert","onblur","onchange","onclick","ondblclick","onerror","onfocus","onload","onmouse","onscroll","onsubmit","onunload","ptompt","</div>")

	For i=0 To ubound(arrSQL) Step 1
		If(InStr(strCheckArgSQL,arrSQL(i)) > 0) Then
			Select Case  arrSQL(i)
			Case "'"
					arrSQL(i) ="홑따옴표"
			Case "char("
				arrSQL(i) ="char"
		  End SELECT
		  
			response.write "<SCRIPT LANGUAGE='JavaScript'>"
			response.write "  alert('허용되지 않은 문자열이 있습니다. [" & arrSQL(i) & "]') ; "
			response.write "  history.go(-1);"
			response.write "</SCRIPT>"
			response.end
		End If

		If(InStr(strCheckArgSQL,server.urlencode(arrSQL(i))) > 0) Then
			   Select Case  arrSQL(i)
			   Case "'"
				arrSQL(i) ="홑따옴표"
			   Case "char("
				arrSQL(i) ="char"
			   End SELECT
			response.write "<SCRIPT LANGUAGE='JavaScript'>"
			response.write "  alert('허용되지 않은 문자열이 있습니다. [" & arrSQL(i) & "]') ; "
			response.write "  history.go(-1);"
			response.write "</SCRIPT>"
			response.end
		End If

	Next

	'Xss 필터링	
	'argData = Replace(argData,"&","&amp;")
	'argData = Replace(argData,"\","&quot;")
	'argData = Replace(argData,"<","&lt;")
	'argData = Replace(argData,">","&gt;")
	'argData = Replace(argData,"'","&#39;")
	'argData = Replace(argData,"""","&#34;")

	fInject = argData
End Function 
%>