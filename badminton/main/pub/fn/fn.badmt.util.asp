
<%
    '----------------------------------------------------------------------
	'@description
	'	입력된 데이터 공백, null 체크 후 Boolean 값을 반환한다.
	'@param
	'	(string) value : 데이터값
	'@return
	'	(Boolean) true or false
	'----------------------------------------------------------------------
	Function chkBlank(ByVal value)
		If Trim(value) = "" Or Len(Trim(value)) = 0 Or IsNull(value) Or IsEmpty(value)  Then
			chkBlank = True
		Else
			chkBlank = False
		End If
	End Function


	'----------------------------------------------------------------------
	'@description
	'	request 받는 메소드 체크 후 request값을 반환한다.
	'@param
	'	(string) request_name : request 변수명
	'	(string) method       : 메소드 타입
	'@return
	'	(string) request값
	'----------------------------------------------------------------------
	Function chkReqMethod(ByVal request_name, ByVal method)
		If UCase(method) = "POST" Then
			chkReqMethod = request.Form(request_name)
		ElseIf UCase(method) = "GET" Then
			chkReqMethod = request.QueryString(request_name)
		Else
			chkReqMethod = request(request_name)
		End If
	End Function


	'----------------------------------------------------------------------
	'@description
	'	request 받는 메소드 체크 후 request count값 반환한다.
	'@param
	'	(string) request_name : request 변수명
	'	(string) method       : 메소드 타입
	'@return
	'	(string) request count값
	'----------------------------------------------------------------------
	Function chkReqMethodCount(ByVal request_name, ByVal method)
		If UCase(method) = "POST" Then
			chkReqMethodCount = request.Form(request_name).count
		ElseIf UCase(method) = "GET" Then
			chkReqMethodCount = request.QueryString(request_name).count
		Else
			chkReqMethodCount = 0
		End If
	End Function


	'----------------------------------------------------------------------
	'@description
	'	request 받는 메소드 체크 후 선택 한 request item 값 반환한다.
	'@param
	'	(string) request_name : request 변수명
	'	(string) method       : 메소드 타입
	'@return
	'	(string) request item 값
	'----------------------------------------------------------------------
	Function chkReqMethodItem(ByVal request_name, ByVal index, ByVal method)
		If UCase(method) = "POST" Then
			chkReqMethodItem = request.Form(request_name)(index)
		ElseIf UCase(method) = "GET" Then
			chkReqMethodItem = request.QueryString(request_name)(index)
		Else
			chkReqMethodItem = ""
		End If
	End Function


	'----------------------------------------------------------------------
	'@description
	'	입력된 데이터를 string 형식으로 체크 후 공백일경우
	'	설정된 기본값을 반환
	'@param
	'	(string) value       : 입력값
	'	(string) default_val : 기본값
	'@return
	'	(string) 비교후 반환값
	'----------------------------------------------------------------------
	Function chkStr(ByVal value, ByVal default_val)
		If chkBlank(value) Then
			chkStr = default_val
		Else
			chkStr = Trim(value)
		End if
	End Function


	'----------------------------------------------------------------------
	'@description
	'	입력된 데이터를 string 형식으로 체크 후 공백일경우
	'	설정된 기본값을 반환, 값이 있을경우 SQL Injection 체크 후
	'	포함된 단어일 경우 이전페이지 이동
	'@param
	'	(string) value       : 입력값
	'	(string) default_val : 기본값
	'@return
	'	(string) 비교후 반환값
	'----------------------------------------------------------------------
	Function chkStrReq(ByVal value, ByVal default_val)
		If chkBlank(value) Then
			chkStrReq = default_val
		Else
			chkStrReq = securityRequestCheck(Trim(value))
		End If
	End Function


	'----------------------------------------------------------------------
	'@description
	'	입력된 데이터를 string 형식으로 체크 후 공백일경우
	'	설정된 기본값을 반환, 값이 있을경우 SQL Injection 체크 후
	'	포함된 단어일 경우 Replace
	'@param
	'	(string) value       : 입력값
	'	(string) default_val : 기본값
	'@return
	'	(string) 비교후 반환값
	'----------------------------------------------------------------------
	Function chkStrRpl(ByVal value, ByVal default_val)
		If chkBlank(value) Then
			chkStrRpl = default_val
		Else
			chkStrRpl = securityRequestReplace(Trim(value))
		End if
	End Function


	'----------------------------------------------------------------------
	' Description
	'		입력된 숫자형 형식 체크 및 기본값 설정 처리
	' Params
	'		data		: 비교 데이터 값
	'		def_data	: 정의 데이터 값
	' Return
	'		빈값 또는 NUll 데이터일 경우 정의된 데이터값 반환
	'----------------------------------------------------------------------
	Function chkInt(ByVal data, ByVal def_data)

		If chkBlank(data) Or Not IsNumeric(data) Then
			chkInt = def_data
		Else
			If Len(data) > 16 Then
				chkInt = 0
			Else
				chkInt = Cdbl(data)
			End If
		End if

	End Function


	'----------------------------------------------------------------------
	' Description
	'		입력된 숫자형 형식 체크 및 기본값 설정 처리
	' Params
	'		data		: 비교 데이터 값
	'		def_data	: 정의 데이터 값
	' Return
	'		빈값 또는 NUll 데이터일 경우 정의된 데이터값 반환
	'----------------------------------------------------------------------
	Function chkLong(ByVal data, ByVal def_data)

		If chkBlank(data) Or Not IsNumeric(data) Then
			chkLong = def_data
		Else
			If Len(data) > 10 Then
				chkLong = 0
			Else
				chkLong = CLng(data)
			End If
		End if

	End Function



	'----------------------------------------------------------------------
	' Description
	'		입력된 데이터 길이 체크 후 길이 초과시 길이많큼 반환 처리
	'		한글 2bytes, 영문/숫자 1bytes
	' Params
	'		data	: 데이터 값
	'		length	: 문자열 길이
	' Return
	'		문자열 길이 처리 반환
	'----------------------------------------------------------------------
	Function chkLength(ByVal data, ByVal length)
		If chkBlank(data) Or chkBlank(length) Then
			chkLength = data
		Else
			If returnToByte(data) > length Then
				chkLength = Trim(returnToCut(data, length, ""))
			Else
				chkLength = Trim(data)
			End If
		End If
	End Function


	'----------------------------------------------------------------------
	'@description
	'	입력된 데이터 비교 후 checked or selected 반환
	'@param
	'	(string) input_val  : 데이터값
	'	(string) find_val   : 입력값
	'	(string) return_val : 반환정보
	'@return
	'	(string) 값이 있을경우 반환정보 반환
	'----------------------------------------------------------------------
	Function chkCompare(ByVal input_val, ByVal find_val, ByVal return_val)
		If chkBlank(input_val) Or chkBlank(find_val) Or chkBlank(return_val) Then
			Exit Function
		End If

		If InStr(input_val, ",") Then
			If InStr(input_val, find_val) Then
				chkCompare = return_val
			End If
		Else
			If input_val = find_val Then
				chkCompare = return_val
			End If
		End If
	End Function


	'----------------------------------------------------------------------
	'@description
	'	페이지 referer 체크
	'	페이지 바로 접속여부 확인용
	'@param
	'@return
	'	(Boolean) true or false
	'----------------------------------------------------------------------
	Function chkReferer()
		If Len(URL_REFERER)=0 Or (InStr(URL_REFERER, SITE_URL)=0 And InStr(URL_REFERER, SITE_MOBILE_URL)=0) Then
			chkReferer = False
		Else
			chkReferer = True
		End If
	End Function


	'----------------------------------------------------------------------
	'@description
	'	관리자페이지 접속확인
	'@param
	'@return
	'	(Boolean) true or false
	'----------------------------------------------------------------------
	Function chkAdminPage()
		If InStr(URL_REFERER, STIE_URL & "/tong_adm")=0  Then
			chkAdminPage = False
		Else
			chkAdminPage = True
		End If
	End Function

    Sub getRowsDrow(arr)
        Response.write "<table border=1>"
        If IsArray(arr) Then
            For ar = LBound(arr, 2) To UBound(arr, 2)
                Response.write "<tr>"
                For c = LBound(arr, 1) To UBound(arr, 1)
                    Response.write "<td>" & arr(c, ar) & "</td>"
                Next
                Response.write "</tr>"
            Next
        End if
        Response.write "</table>"
    End Sub
    %>