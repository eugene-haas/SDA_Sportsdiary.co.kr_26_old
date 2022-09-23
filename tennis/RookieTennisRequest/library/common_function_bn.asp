
<%

  global_filepath_ADIMG = "D:\ADIMG\tennis"
	global_filepathUrl_ADIMG = "/ADImgR/tennis/"
	global_filepath_temp_ADIMG = "D:\ADIMG\temp"
	global_filepath_tempUrl_ADIMG = "/ADImgR/temp/"

  M_conKey = "w암호화 비밀키" ' 암호화 비밀키
	'M_conIV = Replace(USER_IP,".","") & "초기화 백터" '초기화 벡터 (결제중 아이피가 변경되면 오류발생가능성 ) 
	'M_conIV = Replace(date,"-","") & "초기화 백터" '초기화 벡터 (자정문제발생)
	M_conIV = year(date) & "초기화 백터" '초기화 벡터 (자정문제발생)

  Const Ref_bn = "GPQRSATWXVYBCHL640MN598OIJKZ12D7EF3U"

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


  FUNCTION IPHONEYN()	

    If(Len(Request.ServerVariables("HTTP_USER_AGENT"))=0) Then
        strAgent = "NONE"
    Else
        strAgent = Request.ServerVariables("HTTP_USER_AGENT")
    End if
    
    mobile = Array("iPhone", "ipad", "ipod")

    imb = 0
    
    For Each n In mobile
        If (InStr(LCase(strAgent), LCase(n)) > 0) Then
            imb = imb + 1
        End If
    Next

    IPHONEYN = imb

  END FUNCTION

  Function fInject(argData)
   	Dim strCheckArgSQL
  	Dim arrSQL
    Dim i
  
  	strCheckArgSQL = LCase(Trim(argData))	
  	
  	arrSQL = Array("exec ","sp_","xp_","insert ","update ","delete ","drop ","select ","union ","truncate ","script","object ","applet","embed ","iframe ","where ","declare ","sysobject","@variable","1=1","null","carrige return","new line","onload","char(","xmp","javascript","script","iframe","document","vbscript","applet","embed","object","frame","frameset","bgsound","alert","onblur","onchange","onclick","ondblclick","onerror","onfocus","onload","onmouse","onscroll","onsubmit","onunload","ptompt","</div>")
  
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

  
  ' 16진수 -> 문자열
  Function HexToString(pHex)
    Dim one_hex, tmp_hex, i, retVal
    For i = 1 To Len(pHex)
      one_hex = Mid(pHex, i, 1)
      If IsNumeric(one_hex) Then
              tmp_hex = Mid(pHex, i, 2)
              i = i + 1
      Else
              tmp_hex = Mid(pHex, i, 4)
              i = i + 3
      End If
      retVal = retVal & Chr("&H" & tmp_hex)
    Next
    HexToString = retVal
  End Function	

  ' 암호화
  Function encode(str, chipVal)
    Dim Temp, TempChar, Conv, Cipher, i: Temp = ""
    
    chipVal = CInt(chipVal)
    str = StringToHex(str)
    For i = 0 To Len(str) - 1
      TempChar = Mid(str, i + 1, 1)
      Conv = InStr(Ref_bn, TempChar) - 1
      Cipher = Conv Xor chipVal
      Cipher = Mid(Ref_bn, Cipher + 1, 1)
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
      Conv = InStr(Ref_bn, TempChar) - 1
      Cipher = Conv Xor chipVal
      Cipher = Mid(Ref_bn, Cipher + 1, 1)
      Temp = Temp + Cipher
    Next
    Temp = HexToString(Temp)
    decode = Temp
  End Function

%>
