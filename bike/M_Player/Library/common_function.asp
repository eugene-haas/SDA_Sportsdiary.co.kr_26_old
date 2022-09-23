<%
	'========================================================================================================
	'한자리수 숫자 0붙이기
	'========================================================================================================
	Function AddZero(Str)
		IF len(Str)=1 Then
			AddZero="0"&Str
		Else
			AddZero=Str
		End IF
	End Function

	'========================================================================================================
	'========================================================================================================
	Function Check_Login()
		If Request.Cookies("SD")("UserID") = "" Then			'통합로그인
			response.Write "<script>"
			response.Write "	alert('로그인 후 이용할 수 있는 종목입니다.\n로그인 페이지로 이동합니다.');"
			response.Write "	$(location).attr('href', 'http://sdmain.sportsdiary.co.kr/sdmain/login.asp');"
			response.Write "</script>"
			response.End
   	End IF
	End Function

	'========================================================================================================
  '========================================================================================================
	Function Check_NoLogin()
		If Request.Cookies("SD")("UserID") <> "" Then
			response.Write "<script>"
			response.write "	$(location).attr('href','../Main/index.asp');"
			response.write "</script>"
			response.End
			Response.End
		End If
	End Function
  
  '========================================================================================================
  '========================================================================================================

	  FUNCTION IPHONEYN()	'아이폰여부체크  by 백 190809 수정
		Dim M_AGENT
		M_AGENT = LCase(Request.ServerVariables("HTTP_USER_AGENT")) 
		If InStr(M_AGENT,"ipad") > 0 or InStr(m_agent,"iphone") > 0 Or InStr(M_AGENT, "ipod") > 0 Then
			IPHONEYN = "1"
		Else
			IPHONEYN = "1"
		End If
		

'        If(Len(Request.ServerVariables("HTTP_USER_AGENT"))=0) Then
'            strAgent = "NONE"
'        Else
'            strAgent = Request.ServerVariables("HTTP_USER_AGENT")
'        End if
'
'        mobile = Array("iPhone", "ipad", "ipod")
'
'        imb = 0
'
'        For Each n In mobile
'            If (InStr(LCase(strAgent), LCase(n)) > 0) Then
'                imb = imb + 1
'            End If
'        Next
'
'        IPHONEYN = imb

    END FUNCTION

%>
