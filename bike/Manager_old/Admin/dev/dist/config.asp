<% @CODEPAGE="65001" language="vbscript" %>
<%
	Response.ContentType = "text/html"
	Response.AddHeader "Content-Type", "text/html;charset=utf-8"
	Response.CodePage = "65001"
	Response.CharSet = "utf-8"
	

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
	
	' 문자열 -> 16진수
	Function StringToHex(pStr)
			Dim i, one_hex, retVal
			IF pStr<>"" Then
			For i = 1 To Len(pStr)
			  one_hex = Hex(Asc(Mid(pStr, i, 1)))
			  retVal = retVal & one_hex
			Next
			End IF
			StringToHex = retVal
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
	
	'===============================================================================
	'Function : isLogin()
	'Description : 로그인 여부 반환
	'===============================================================================
	Function isLogin()
		If GetUserid() = "" Then
			isLogin = False
		Else
			isLogin = true
		End If
	End Function
	
	'회원로그인체크 현재창
	Function ChkLogin(Refer_URL)
		If GetUserid() = "" Then
			Response.Write "<script>location.href='/Main/gate.asp?Refer_Url="&Refer_URL&"'</script>"
			Response.End
		End If 
	End Function 
	
	'회원로그인체크 부모창
	Function ChkLogin_Parent(Refer_URL)
		If GetUserid() = "" Then
			Response.Write "<script>parent.location.href='/Main/gate.asp?Refer_Url="&Refer_URL&"'</script>"
			Response.End
		End If 
	End Function 
	
	'회원로그인체크 현재창
	Function ChkAgtLogin(Refer_URL)
		If GetAgtId() = "" Then
			Response.Write "<script>top.location.href='/gate.asp?Refer_Url="&Refer_URL&"'</script>"
			Response.End
		End If 
	End Function 

'===============================================================================
	'Function : SetSession(UID, UCOMNUM)
	'Description : 로그인 설정
	'===============================================================================
	Function SetSession(sLOGINID, sCUSTSEQ, sGLPE, sCUSTNM, sCUSTZIP, sCUSTZIP2, sCUSTADDR, sCUSTTEL, sCUSTEMAIL,sCUSTHP)

		Response.Cookies("sLOGINID").path = "/"
		Response.Cookies("sLOGINID").Domain = Request.ServerVariables("SERVER_NAME")
		Response.Cookies("sLOGINID") = sLOGINID
		Response.cookies("sLOGINID").expires						=date+1

		Response.Cookies("sCUSTSEQ").path = "/"
		Response.Cookies("sCUSTSEQ").Domain = Request.ServerVariables("SERVER_NAME")
		Response.Cookies("sCUSTSEQ") = sCUSTSEQ
		Response.cookies("sCUSTSEQ").expires						=date+1

		Response.Cookies("sCUSTNM").path = "/"
		Response.Cookies("sCUSTNM").Domain = Request.ServerVariables("SERVER_NAME")
		Response.Cookies("sCUSTNM") = sCUSTNM
		Response.cookies("sCUSTNM").expires						=date+1

		Response.Cookies("sGLPE").path = "/"
		Response.Cookies("sGLPE").Domain = Request.ServerVariables("SERVER_NAME")
		Response.Cookies("sGLPE") = sGLPE
		Response.cookies("sGLPE").expires						=date+1

		Response.Cookies("sCUSTZIP").path = "/"
		Response.Cookies("sCUSTZIP").Domain = Request.ServerVariables("SERVER_NAME")
		Response.Cookies("sCUSTZIP") = sCUSTZIP
		Response.cookies("sCUSTZIP").expires						=date+1

		Response.Cookies("sCUSTZIP2").path = "/"
		Response.Cookies("sCUSTZIP2").Domain = Request.ServerVariables("SERVER_NAME")
		Response.Cookies("sCUSTZIP2") = sCUSTZIP2
		Response.cookies("sCUSTZIP2").expires						=date+1

		Response.Cookies("sCUSTADDR").path = "/"
		Response.Cookies("sCUSTADDR").Domain = Request.ServerVariables("SERVER_NAME")
		Response.Cookies("sCUSTADDR") = sCUSTADDR
		Response.cookies("sCUSTADDR").expires						=date+1


		Response.Cookies("sCUSTTEL").path = "/"
		Response.Cookies("sCUSTTEL").Domain = Request.ServerVariables("SERVER_NAME")
		Response.Cookies("sCUSTTEL") = sCUSTTEL
		Response.cookies("sCUSTTEL").expires						=date+1

		Response.Cookies("sCUSTEMAIL").path = "/"
		Response.Cookies("sCUSTEMAIL").Domain = Request.ServerVariables("SERVER_NAME")
		Response.Cookies("sCUSTEMAIL") = sCUSTEMAIL
		Response.cookies("sCUSTEMAIL").expires						=date+1

		Response.Cookies("sCUSTHP").path = "/"
		Response.Cookies("sCUSTHP").Domain = Request.ServerVariables("SERVER_NAME")
		Response.Cookies("sCUSTHP") = sCUSTHP
		Response.cookies("sCUSTHP").expires						=date+1

	End Function

	'===============================================================================
	'Function : GetAgtId()
	'Description : 관리자 아이디 반환
	'===============================================================================
	Function GetAgtId()
		GetAgtId = Request.Cookies("AgtId")
	End Function

	'===============================================================================
	'Function : GetAgtNm()
	'Description : 관리자이름반화
	'===============================================================================
	Function GetAgtSEQ()
		GetAgtNm = Request.Cookies("AgtNm")
	End Function

	'===============================================================================
	'Function : GetAgtSEQ()
	'Description : 관리자SEq반화
	'===============================================================================
	Function GetAgtSEQ()
		GetAgtSEQ = Request.Cookies("AgtSEQ")
	End Function
	'===============================================================================
	'Function : GetAgtSEQ()
	'Description : 관리자SEq반화
	'===============================================================================
	Function GetAgtUniGrpCd()
		GetAgtUniGrpCd = Request.Cookies("AgtUniGrpCd")
	End Function

	'===============================================================================
	'Function : GetsLOGINID()
	'Description : 회원 아이디 반환
	'===============================================================================
	Function GetUserid()
		GetUserid = Request.Cookies("sLOGINID")
	End Function
	'===============================================================================
	'Function : GetsCUSTSEQ()
	'Description : 회원 SEQ 반환
	'===============================================================================
	Function GetUserSeq()
		GetUserSeq = Request.Cookies("sCUSTSEQ")
	End Function
	'===============================================================================
	'Function : GetsCUSTNM()
	'Description : 사용자 이름 반환
	'===============================================================================
	Function GetUserNm()
		GetUserNm = Request.Cookies("sCUSTNM")
	End Function
	'===============================================================================
	'Function : GetsCUSTZIP()
	'Description : 우편번호1 반환
	'===============================================================================
	Function GetUserZip1()
		GetUserZip1 = Request.Cookies("sCUSTZIP")
	End Function
	'===============================================================================
	'Function : GetsCUSTZIP2()
	'Description : 우편번호2 반환
	'===============================================================================
	Function GetUserZip2()
		GetUserZip2 = Request.Cookies("sCUSTZIP2")
	End Function
	'===============================================================================
	'Function : GetsCUSTADDR()
	'Description : 주소 반환
	'===============================================================================	
	Function GetUserAddr()
		GetUserAddr = Request.Cookies("sCUSTADDR")
	End Function
	'===============================================================================
	'Function : GetsCUSTTEL()
	'Description : 전호번호 반환
	'===============================================================================	
	Function GetUserTel()
		GetUserTel = Request.Cookies("sCUSTTEL")
	End Function
	'===============================================================================
	'Function : GetsCUSTEMAIL()
	'Description : 이메일 반환
	'===============================================================================	
	Function GetUserEmail()
		GetUserEmail = Request.Cookies("sCUSTEMAIL")
	End Function
	'===============================================================================
	'Function : GetsCUSTHP()
	'Description : 휴대폰번호 반환
	'===============================================================================
	Function GetUserHp()
		GetUserHp = Request.Cookies("sCUSTHP")
	End Function
	
	'=========================================================================================================================================================
	'바이트 수 구하기
	'=========================================================================================================================================================	
	Function GetTxtLenByte(szInput,nLen) 
	   Dim nCnt, szLeft 
	   
	   szInput = Trim(szInput) 
	   if isNull(szInput) or isEmpty(szInput) then 
		  GetTxtLenByte = "" 
	   else 
		  For nCnt = 1 To Len(szInput) 
			 szLeft = Mid(szInput,1,nCnt) 
			 If GetLenTxt(szLeft) > nLen Then 
				szLeft = Mid(szInput,1,nCnt-1) 
				szleft = szleft & "..." 
				Exit For 
			 End If 
		  Next 
		  GetTxtLenByte = szLeft 
	   end if 
	End Function 
	
	Function GetLenTxt(szAllText) 
		Dim nLen, nCnt, szEach 
	
		nLen = 0 
		szAllText = Trim(szAllText) 
		For nCnt = 1 To Len(szAllText) 
			szEach = Mid(szAllText,nCnt,1) 
			If 0 <= Asc(szEach) And Asc(szEach) <= 255 Then 
					nLen = nLen + 1             '한글이 아닌 경우 
			Else 
					nLen = nLen + 2             '한글인 경우 
			End If 
		Next 
	
		GetLenTxt = nLen 
	End Function 
	'===============================================================================
	'Function : SetEditSession()
	'Description : 회원정보 수정시 정보변경
	'===============================================================================
	Function SetEditSession(sCUSTZIP, sCUSTZIP2, sCUSTADDR, sCUSTTEL, sCUSTEMAIL,sCUSTHP)
		Response.Cookies("sCUSTZIP").path = "/"
		Response.Cookies("sCUSTZIP").Domain = Request.ServerVariables("SERVER_NAME")
		Response.Cookies("sCUSTZIP") = sCUSTZIP
		Response.cookies("sCUSTZIP").expires						=date+1

		Response.Cookies("sCUSTZIP2").path = "/"
		Response.Cookies("sCUSTZIP2").Domain = Request.ServerVariables("SERVER_NAME")
		Response.Cookies("sCUSTZIP2") = sCUSTZIP2
		Response.cookies("sCUSTZIP2").expires						=date+1

		Response.Cookies("sCUSTADDR").path = "/"
		Response.Cookies("sCUSTADDR").Domain = Request.ServerVariables("SERVER_NAME")
		Response.Cookies("sCUSTADDR") = sCUSTADDR
		Response.cookies("sCUSTADDR").expires						=date+1

		Response.Cookies("sCUSTTEL").path = "/"
		Response.Cookies("sCUSTTEL").Domain = Request.ServerVariables("SERVER_NAME")
		Response.Cookies("sCUSTTEL") = sCUSTTEL
		Response.cookies("sCUSTTEL").expires						=date+1

		Response.Cookies("sCUSTEMAIL").path = "/"
		Response.Cookies("sCUSTEMAIL").Domain = Request.ServerVariables("SERVER_NAME")
		Response.Cookies("sCUSTEMAIL") = sCUSTEMAIL
		Response.cookies("sCUSTEMAIL").expires						=date+1

		Response.Cookies("sCUSTHP").path = "/"
		Response.Cookies("sCUSTHP").Domain = Request.ServerVariables("SERVER_NAME")
		Response.Cookies("sCUSTHP") = sCUSTHP
		Response.cookies("sCUSTHP").expires						=date+1

  End Function
  
	GLOBAL_DT  = Year(now)&AddZero(Month(now))&AddZero(Day(now))'현재일자 예)20150609
	
	'강수 나누기
	Function GetDrowCnt(TouneyCnt)
			drowCnt = 1
			if Cdbl(TouneyCnt) <=2 then
				drowCnt = 2
			elseif Cdbl(TouneyCnt) >2 and Cdbl(TouneyCnt) <=4 then
				drowCnt = 4
			elseif Cdbl(TouneyCnt) >4 and Cdbl(TouneyCnt) <=8 then
				drowCnt=8
			elseif Cdbl(TouneyCnt) >8 and  CDbl(TouneyCnt) <=16 then
				drowCnt=16
			elseif Cdbl(TouneyCnt) >16 and  Cdbl(TouneyCnt) <=32 then
				drowCnt=32
			elseif Cdbl(TouneyCnt) >32 and  Cdbl(TouneyCnt) <=64 then
				drowCnt=64
			elseif Cdbl(TouneyCnt) >64 and  Cdbl(TouneyCnt) <=128 then
				drowCnt=128
			elseif Cdbl(TouneyCnt) >128 and  Cdbl(TouneyCnt) <=256 then
				drowCnt=256
			elseif Cdbl(TouneyCnt) >256 and  Cdbl(TouneyCnt) <=512 then
				drowCnt=512
			end if 
			GetDrowCnt = drowCnt
		End Function

	'RandNumber
	Function random_str()
		str = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" '랜덤으로 사용될 문자 또는 숫자
	
	 strlen = 6 '랜덤으로 출력될 값의 자릿수 ex)해당 구문에서 10자리의 랜덤 값 출력
	
	 Randomize '랜덤 초기화
	 For i = 1 To strlen '위에 선언된 strlen만큼 랜덤 코드 생성
		r = Int((36 - 1 + 1) * Rnd + 1)  ' 36은 str의 문자갯수
		serialCode = serialCode + Mid(str,r,1)
	 Next
	 random_str = serialCode
	End Function
	
	'랜덤숫자
	Function random_Disigt_str()
		Randomize '랜덤 초기화
		'4자리
		bufNum = int(9000 * rnd) + 1000	
		random_Disigt_str = bufNum
	End Function

	Function ReplaceTagText(str)
		dim txtTag
		IF str <> "" Then
			txtTag = replace(str,  "<", "&lt;")
			txtTag = replace(txtTag, ">", "&gt;")
			txtTag = replace(txtTag, "'", "&apos;")
			txtTag = replace(txtTag, chr(39), "&#39;")
			txtTag = replace(txtTag, chr(34), "&quot;")	
			txtTag = replace(txtTag, chr(10), "<br>")
			ReplaceTagText = txtTag
		END IF
	End Function

	Function ReplaceTagReText(str)
		dim txtTag
		IF str <> "" Then
			txtTag = replace(str,  "&lt;", "<")
			txtTag = replace(txtTag, "&gt;", ">")
			txtTag = replace(txtTag, "&apos;", "'")
			txtTag = replace(txtTag, "&#39;", chr(39))
			txtTag = replace(txtTag, "&quot;", chr(34))	
			txtTag = replace(txtTag, "<br>", chr(10))	 
			ReplaceTagReText = txtTag
		END IF
	End Function

	Function GetGangSu(ByVal Param_GameType, ByVal Param_MaxRound, ByVal Param_Round)

    CONST constLeague = "B0040001"
    CONST constTorunament = "B0040002" 
    Dim A_GameTypeNM : A_GameTypeNM = ""
		Dim Result_RoundNM : Result_RoundNM =""
		Dim Result_Gang : Result_Gang = 0
		Dim i : i = 1
		Dim j : j = 1
		Dim Max_Gang : Max_Gang = 1

		IF Param_GameType <> "" AND Param_MaxRound <> "" AND Param_Round <> "" Then
			IF Param_GameType = constTorunament Then
				A_GameTypeNM= "토너먼트"
			ELSE
				A_GameTypeNM =  "리그"
			End IF

			IF Param_GameType = constTorunament Then
				'Response.Write "게임 타입 : " & A_GameTypeNM& "<br>"
				'Response.Write "최대 라운드 : " & A_MaxRound & "<br>"
				'Response.Write "현재 라운드: " & A_Round & "<br>"
				Max_Gang = 1
				for j = 1 to Param_MaxRound
					Max_Gang = Max_Gang * 2
				next
				'Response.Write "최종 라운드 : " & Param_MaxRound & "<br>"
				'Response.Write "현재 라운드 :" & Param_Round & "<br>"
				'Response.Write "현재 라운드 강수 : " & Max_Gang & "<br>"
				redim Arr(Param_MaxRound) 
				Result_Gang = 0
				for i = 1 to Ubound(Arr) 
					if i = cdbl(1) Then
						Arr(i) = Max_Gang
					ELSE
						Arr(i) = Arr(i - 1) / 2
					End IF
					
					if cdbl(Param_Round) = cdbl(i) Then
						'Response.Write "Arr(i)" & Arr(i) & "<br>"
						Result_Gang = Arr(i)
					Exit For
					END IF
				next
				If Result_Gang = 4 Then
					Result_RoundNM = "준결승"
				ElseIf Result_Gang = 2 then
					Result_RoundNM = "결승"
				Else
					Result_RoundNM = Cstr(Result_Gang) & "강"
				End If
				'Response.Write "결과 : " & Result_RoundNM & "<br><br><br><br><br>"
			End IF
			GetGangSu = Result_RoundNM
		ELSE
			GetGangSu = ""
		End IF
  End Function
%>
<!--#include file="./common_function.asp"-->
<!--#include file="./crypt.asp"-->
<!--#include file="./dbcon.asp"-->
<%
	DBOpen()
%>