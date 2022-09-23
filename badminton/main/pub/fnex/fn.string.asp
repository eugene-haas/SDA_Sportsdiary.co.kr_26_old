<%
	Function GetCouponCode (ByVal strlen, ByVal table, ByVal trans)
		str = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
		serialCode = ""
		Randomize
		For j = 1 To strlen
			r = Int((Len(str) - 1 + 1) * Rnd + 1)
			serialCode = serialCode + Mid(str,r,1)
		Next

		sql = "SELECT " & vbCrLf _
			& "    idx " & vbCrLf _
			& " FROM " & table & " " & vbCrLf _
			& " WHERE coupon_code = ?"
		params = Array(_
						  db.MakeParam("@coupon_code" ,adVarwchar ,adParamInput ,50 ,serialCode) _
						)
		Set rs = db.ExecSQLReturnRS(sql, params, trans)
		If rs.eof Then
			GetCouponCode = serialCode
		Else
			serialCode = GetCouponCode(strlen, table, trans)
			GetCouponCode = serialCode
		End If
	End Function

	'----------------------------------------------------------------------
	' Description
	'		문자열 UrlEncode형식으로 처리
	' Params
	'		data : 변환할 문자 데이터
	' Return
	'		UrlEncode형식으로 변경하여 반환
	'----------------------------------------------------------------------
	Function returnURLEncode(ByVal data)

		If data <> "" Then
			returnURLEncode = Server.URLEncode(data)
		Else
			returnURLEncode = data
		End If

	End Function


	'----------------------------------------------------------------------
	' Description
	'		입력받은 데이터를 HTML Encoding 처리
	' Params
	'		data : 데이터 자료
	' Return
	'		변경된 데이터 자료
	'----------------------------------------------------------------------
	Function htmlEncode(ByVal data)

		Dim result

		If data <> "" then
			result = Trim(data)
			result = Replace(result, ">", "&gt;")
			result = Replace(result, "<", "&lt;")
			result = Replace(result, """", "&quot;")
			result = Replace(result, "'", "&#39;")
			result = Replace(result, "&", "&amp;")

			htmlEncode = result
		Else
			htmlEncode = ""
		End If

	End Function


	'----------------------------------------------------------------------
	' Description
	'		입력받은 데이터를 HTML Decoding 처리
	' Params
	'		data : 데이터 자료
	' Return
	'		변경된 데이터 자료
	'----------------------------------------------------------------------
	Function htmlDecode(ByVal data)

		Dim result

		If data <> "" Then
			result = Trim(data)
			result = Replace(result, "&amp;", "&")
			result = Replace(result, "&#39;", "'")
			result = Replace(result, "&quot;", """")
			result = Replace(result, "&lt;", "<")
			result = Replace(result, "&gt;", ">")

			htmlDecode = result
		Else
			htmlDecode = ""
		End If

	End Function

    
	'----------------------------------------------------------------------
	' Description
	'		Enter Key와 Space를 HTML형식으로 변환 처리
	' Params
	'		data : 데이터 자료
	' Return
	'		변경된 데이터 자료
	'----------------------------------------------------------------------
	Function textareaEncode(ByVal data)

		Dim result

		If data <> "" Then
			result = data
			result = Replace(result, "</br>", Chr(13) & Chr(10))
			result = Replace(result, "<br>", Chr(10))
			result = Replace(result, "&nbsp;", Space(1))

			textareaEncode = result
		Else
			textareaEncode = ""
		End If

	End Function


	'----------------------------------------------------------------------
	' Description
	'		Enter Key와 Space를 HTML형식으로 변환 처리
	' Params
	'		data : 데이터 자료
	' Return
	'		변경된 데이터 자료
	'----------------------------------------------------------------------
	Function textareaDecode(ByVal data)

		Dim result

		If data <> "" Then
			result = data
			result = Replace(result, Chr(13) & Chr(10), "</br>")
			result = Replace(result, Chr(10), "<br>")
			result = Replace(result, Space(1), "&nbsp;")

			textareaDecode = result
		Else
			textareaDecode = ""
		End If

	End Function




	'----------------------------------------------------------------------
	' Description
	'		입력된 자를 문자열이 길이값을 반환
	' Params
	'		str		: 문자열 데이터
	' Return
	'		입력된 자를 문자열이 길이값을 반환(한글 2byte, 영문/숫자 1byte)
	'----------------------------------------------------------------------
	Function returnToByte(ByVal str)
		Dim str_byte, t

		str_byte = 0

		For t = 1 To Len(str)
			If Len(escape(Mid(str, t, 1))) > 4 Then
				str_byte = str_byte + 2
			Else
				str_byte = str_byte + 1
			End If
		Next

		returnToByte = str_byte
	End Function



	'----------------------------------------------------------------------
	' Description
	'		입력된 자를 문자열이 길이 만큼 문자열을 잘라서 반환
	' Params
	'		str		: 문자열 데이터
	'		length	: 자를 문자열 길이
	' Return
	'		입력된 길이만큼 잘라져서   문자열 반환
	'----------------------------------------------------------------------
	Function returnToCut(ByVal str, ByVal length, ByVal word)
		If chkBlank(str) Then
			returnToCut = str
			Exit Function
		End If

		Dim str_len, str_byte, str_cut, str_return, char, t

		str_len = 0
		str_byte = 0
		str_len = Len(str)

		For t = 1 To str_len
			char = ""
			str_cut = Mid(str, t, 1)
			char = escape(str_cut)

			If Len(char) > 4 Then
				str_byte = str_byte + 2
			Else
				str_byte = str_byte + 1
			End If

			If length < str_byte Then
				If word <> "" Then
					str_return = str_return & word
				Else
					str_return = str_return
				End If

				Exit For
			Else
				str_return = str_return & str_cut
			End If

		Next

		returnToCut = str_return
	End Function


	'----------------------------------------------------------------------
	' Description
	'		문자열에서 HTML태그를 삭제
	' Params
	'		htmlCont : 문자열 데이터
	' Return
	'		HTML태그가 제거된 문자 반환
	'----------------------------------------------------------------------
    Function replaceContTag(ByVal htmlCont)

		If htmlCont = "" Or IsNull(htmlCont) Then
			Exit Function
		End If

		Dim patrn, regEx, match, matches

		patrn = "\<(\/?)(html|head|meta|body|title|HTML|HEAD|META|BODY|TITLE)([^<>]*)>"

		Set regEx = New RegExp				'정규식을 만듭니다.
			regEx.Pattern = patrn           '패턴을 설정합니다.
			regEx.IgnoreCase = True         '대/소문자를 구분하지 않도록 합니다.
			regEx.Global = True				'전체 문자열을 검색하도록 설정합니다.

			Set matches = regEx.Execute(htmlCont)
				For Each match in matches
					htmlCont = regEx.Replace(htmlCont, "")
				Next
			Set matches = Nothing
		Set regEx = Nothing

		htmlCont = replaceRegExp(htmlCont,"<BR>","<br />")

		replaceContTag = htmlCont

	End Function


	'----------------------------------------------------------------------
	' Description
	'		입력된 패턴을 문자열에서 찾아서 포함된 여부를 반환한다.
	' Params
	'		str		: 문자열 데이터
	'		patrn	: 필터링 할 정규식 패턴
	' Return
	'		필터링된 패턴이 포함되어있는지 Boolean값 반환
	'----------------------------------------------------------------------
	Function stateRegExp(ByVal str, ByVal patrn)

		'pattern0 = "[^가-힣]"								'## 한글만
		'pattern1 = "[^-0-9 ]"								'## 숫자만
		'pattern2 = "[^-a-zA-Z]"							'## 영어만
		'pattern3 = "[^-a-zA-Z0-9/ ]"						'## 영어+숫자만
		'pattern4 = "[^-가-힣a-zA-Z0-9/ ]"					'## 한글+영어+숫자만
		'pattern5 = "\<(\/?)(script)([^<>]*)>"				'## 스크립트만
		'pattern6 = "<[^>]*>"								'## 태그만

		If IsNull(str) Then
			Exit Function
		End If


		Dim regEx
		Set regEx = New RegExp
			with regEx
				.Pattern = patrn				'패턴 설정
				.IgnoreCase = True			'대/소문자 구분하지 않음
				.Global = True					'전체 문자열 검색
			end with

		 Set matchChk = regEx.Execute(str)

		If 0 < matchChk.count Then
			stateRegExp = False
		Else
			stateRegExp = True
		End If

		Set matchChk = Nothing
		Set regEx = Nothing

	End Function


	'----------------------------------------------------------------------
	' Description
	'		입력된 패턴을 문자열에서 찾아서 변환시킬 문자열로 변환후 반환
	' Params
	'		str		: 문자열 데이터
	'		patrn	: 필터링 할 정규식 패턴
	'		replStr : 변환할 문자열 데이터
	' Return
	'		변환된 문자열 반환
	'----------------------------------------------------------------------
	Function replaceRegExp(ByVal str, ByVal patrn, ByVal replStr)

		'pattern0 = "[^가-힣]"						'한글만
		'pattern1 = "[^0-9 ]"						'숫자만
		'pattern2 = "[^a-zA-Z]"					'영어만
		'pattern3 = "[^a-zA-Z0-9/ ]"				'영어+숫자만
		'pattern4 = "[^가-힣a-zA-Z0-9/ ]"			'한글+영어+숫자만
		'pattern5 = "\<(\/?)(script)([^<>]*)>"		'스크립트만
		'pattern6 = "<[^>]*>"						'태그만

		If IsNull(str) Then
			Exit Function
		End If

		Dim regEx
		Set regEx = New RegExp
			with regEx
				.Pattern = patrn					'패턴 설정
				.IgnoreCase = True					'대/소문자 구분하지 않음
				.Global = True						'전체 문자열 검색
			end with

		replaceRegExp = regEx.Replace(str, replStr)

		Set regEx = Nothing

	End Function


	'----------------------------------------------------------------------
	' Description
	'		문자열 데이터안에 이미지 체크처리
	' Params
	'		str		: 문자열 데이터
	'		patrn	: 필터링 할 정규식 패턴
	' Return
	'		패턴에 맞는 정보 반환
	'----------------------------------------------------------------------
	Function getImagesTagSearch(ByVal str, ByVal patrn)

		'pattern0 = "<img [^<>]*>"							'이미지 태그만 추출 패턴 → <img src='경로' /> 추출
		'pattern1 = "[^=']*\.(gif|jpg|bmp|png|jpeg)"		'이미지 경로 전체 추출 패턴 → Img Src 추출
		'pattern2 = "[^='/]*\.(gif|jpg|bmp|png|jpeg)"		'이미지 파일명만 추출 패턴 → 파일명 추출

		If patrn = "tag" Then
			pattern = "<img [^<>]*>"
		ElseIf patrn = "path" Then
			pattern = "[^=']*\.(gif|jpg|bmp|png|jpeg)"
		ElseIf patrn = "filename" Then
			pattern = "[^='/]*\.(gif|jpg|bmp|png|jpeg)"
		End If

		If IsNull(str) Then
			Exit Function
		End If

		Dim regEx, Matches, Match, tmpStr

		Set regEx = New RegExp

		with regEx
			.Pattern = pattern				'패턴 설정
			.IgnoreCase = True				'대/소문자 구분하지 않음
			.Global = True					'전체 문자열 검색
		End with

		Set Matches = regEx.Execute(str)

		tmpStr = ""
		For Each Match in Matches
			If tmpStr <> "" Then
				tmpStr = tmpStr & ","
			End If

			tmpStr = tmpStr & Match
		Next

		getImagesTagSearch = Trim(Replace(Replace(tmpStr, """", ""), "'", ""))

		Set Matches = Nothing
		Set regEx = Nothing

	End Function

	Function checkPartnerPid(ByVal str)
		rtnStr = request(str)
		Randomize()
		nd_num = Int((125 * Rnd) + 1)
		checkPartnerPid = securityRequestFilterPid(rtnStr, nd_num)
	End Function

	'----------------------------------------------------------------------
	' Description
	'		문자열 데이터안에 정규식 체크처리
	' Params
	'		str		: 문자열 데이터
	'		patrn	: 정규식 체크 할 패턴
	' Return
	'		패턴에 맞는 정보 반환 (True Or False)
	'----------------------------------------------------------------------
	Function isDataCheck(ByVal str, ByVal patrn)

		If IsNull(str) Or str = "" Or IsNull(patrn) Or patrn = "" Then
			IsDataCheck = False
			Exit Function
		End If

		If patrn = "email" Then
			patrn = "^([a-z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-z0-9_\-]+\.)+))([a-z]{2,4}|[0-9]{1,3})(\]?)$"
		ElseIf patrn = "phone" Then
			patrn = "^0(10|11|16|17|18|19)-[^0][0-9]{2,3}-[0-9]{4}$"
		ElseIf patrn = "phone2" Then
			patrn = "^0(10|11|16|17|18|19)[^0][0-9]{2,3}[0-9]{4}$"
		ElseIf patrn = "tel" Then
			patrn = "^0(2|31|33|32|42|43|41|53|54|55|52|51|63|61|62|64|70)-[^0][0-9]{2,3}-[0-9]{4}$"
		ElseIf patrn = "tel2" Then
			patrn = "^0(2|31|33|32|42|43|41|53|54|55|52|51|63|61|62|64|70)[^0][0-9]{2,3}[0-9]{4}$"
		ElseIf patrn = "date" Then
			'YYYY-MM-DD 형식체크
			If IsDate(str) Then
				isDataCheck = True
			Else
				isDataCheck = False
			End If

			Exit Function
		ElseIf patrn = "date2" Then
			'YYYYMMDD 형식체크
			str = Left(str, 4) &"-"& Mid(str, 5, 2) &"-"& Right(str, 2)

			If IsDate(str) Then
				isDataCheck = True
			Else
				isDataCheck = False
			End If

			Exit Function
		Else
			isDataCheck = False
			Exit Function
		End If

		Dim regEx

		Set regEx = New RegExp
			with regEx
				.Pattern = patrn			'패턴 설정
				.IgnoreCase = True			'대/소문자 구분하지 않음
				.Global = True				'전체 문자열 검색
			end with

		IsDataCheck = regEx.Test(str)

		Set regEx = Nothing

	End Function


	'----------------------------------------------------------------------
	' Description
	'		type_0	= YYYY-MM-DD
	'		type_1	= YYYY.MM.DD
	'		type_2	= YYYY년 MM월 DD일
	'		type_3	= YYYY-MM-DD (HH:MM)
	'		type_4	= YYYY-MM-DD (HH:MM:SS)
	'		type_5	= HH:MM:SS
	'		type_6	= YYYYMMDD
	' Params
	'		dates	= 입력 데이트 값
	'		types	= 변환타입
	' Return
	'		변환된 데이트값
	'----------------------------------------------------------------------
	Function dateTypes(ByVal dates, ByVal types)
		If Not IsDate(dates) Then
			'fnMsgGo "날짜형식이 아님니다.", "BACK", ""
			'Exit Function

			dateTypes = ""
			Exit Function
		End If

		If types = 0 Then
			dateTypes = Left(dates, 10)
		ElseIf types = 1 Then
			dateTypes = Replace(Left(dates, 10), "-", ".")
		ElseIf types = 2 Then
			dateTypes = Year(dates) &"년 " & addZero(Month(dates)) & "월 " & addZero(Day(dates)) & "일"
		ElseIf types = 3 Then
			dateTypes = ""
			dateTypes = dateTypes & Left(dates, 10) & " ("
			dateTypes = dateTypes & addZero(Hour(dates)) & ":"
			dateTypes = dateTypes & addZero(Minute(dates)) &")"
		ElseIf types = 4 Then
			dateTypes = ""
			dateTypes = dateTypes & Left(dates, 10) & " ("
			dateTypes = dateTypes & addZero(Hour(dates)) & ":"
			dateTypes = dateTypes & addZero(Minute(dates)) & ":"
			dateTypes = dateTypes & addZero(Second(dates)) & ")"
		ElseIf types = 5 Then
			dateTypes = ""
			dateTypes = dateTypes & addZero(Hour(dates)) & ":"
			dateTypes = dateTypes & addZero(Minute(dates)) & ":"
			dateTypes = dateTypes & addZero(Second(dates))
		ElseIf types = 6 Then
			dateTypes = Replace(Left(dates, 10), "-", "")
		ElseIf types = 7 Then
			dateTypes = ""
			dateTypes = Replace(Left(dates, 10), "-", ".") & " "
			dateTypes = dateTypes & addZero(Hour(dates)) & ":"
			dateTypes = dateTypes & addZero(Minute(dates))
		Else
			dateTypes = dates
		End If
	End Function
%>