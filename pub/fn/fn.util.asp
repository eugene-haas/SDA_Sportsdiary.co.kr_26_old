<%
'#############################
'request
'#############################
	Function BytesToStr(bytes)    '#### 바이트를 받아서 String 으로 반환한다.
	  Dim Stream
	  Set Stream = Server.CreateObject("Adodb.Stream")
		Stream.Type = 1 'bytes
		Stream.Open
		Stream.Write bytes
		Stream.Position = 0
		Stream.Type = 2 'String
		Stream.Charset = "utf-8"
		BytesToStr = Stream.ReadText
		Stream.Close
	  Set Stream = Nothing
	End Function

	Function utx_sprintfEx(sVal, aArgs)
		Dim i, arg
			If(sVal = "") Then
					sprintf = ""
					Exit Function
			End If

			For i=0 To UBound(aArgs)
					arg = aArgs(i)
					If(arg = "" Or IsNull(arg)) Then arg = " " End If
					sVal = Replace(sVal,"{" & CStr(i) & "}",arg)
			Next
			utx_sprintfEx = sVal
	End Function

	Function RequestJsonObject(req)   ' #### request 를 검사하고 jsonString 을 반환한다.
		Dim strReq
		If Not req.TotalBytes > 0 Then
			strReq = req.QueryString()
			If(strReq = "") Then
				strReq = "{}"
			Else
				strReq = GetJsonFromGetParam(strReq)
			End If
		Else
			strReq = BytesToStr(req.BinaryRead(req.TotalBytes))
		End If
		RequestJsonObject = strReq
	End Function

	' Get Parameter : key1=val1?key2=val2 형식
	Function GetJsonFromGetParam(strParam)
		Dim aryParam, aryData, strJson, strData, ub, Idx
		strJson = "{}"
		If(strParam <> "") Then
			aryParam = Split(strParam, "&")
			ub = UBound(aryParam)
			For Idx = 0 To ub
				aryData = Split(aryParam(Idx), "=")
				If(Idx = 0) Then
					strData = utx_sprintfEx(" ""{0}"":""{1}"" ", Array(aryData(0), aryData(1) ))
				Else
					strData = utx_sprintfEx("{0}, ""{1}"":""{2}"" ", Array(strData, aryData(0), aryData(1) ))
				End If
			Next
			strJson = utx_sprintfEx("{ {0} }", Array(strData) )
		Else
			strJson = "{}"
		End If
		GetJsonFromGetParam = strJson
	End Function
'#############################







'#############################
'문자랜덤번호생성  seed 10 lenno 4 랜덤번호최대수, 자리수
'#############################

	Function rndno(seed, lenno)
		Dim tempAuth,i
		'랜덤값 만들기
		Randomize   ' 난수 발생기 초기화
		For i = 1 To lenno
			tempAuth = tempAuth &  Int((seed * Rnd) + 0) ' 1에서 seed까지 무작위 값 발생
		Next
		rndno = tempAuth
	End Function


'#############################
'레코드 JSON 으로 반환
	'배열 예
	'listarr = jsonTors_arr(rs)
	'Set list = JSON.Parse( join(array(listarr)) )
	'Call oJSONoutput.Set("LIST", list )
'#############################
Function jsonTors_SE(rs , s, e)
	Dim rsObj,subObj, fieldarr, i, arr, mainObj,ar,c,n

	Set mainObj = jsObject()

	ReDim rsObj(e - s - 1)
	ReDim fieldarr(Rs.Fields.Count-1)
	
	'Response.write "<br>" & Rs.Fields.Count & " :" & s & " :" & e & "<br>"
	For i = 0 To Rs.Fields.Count - 1
		fieldarr(i) = Rs.Fields(i).name
	Next

	If Not rs.EOF Then
		arr = rs.GetRows()

		If IsArray(arr) Then
			n = 0

			For ar = LBound(arr, 2) To UBound(arr, 2)
				Set subObj = jsObject()

				If ar >= s and ar < e Then
				For c = LBound(arr, 1) To UBound(arr, 1)
					subObj(fieldarr(c)) = arr(c, ar)
				Next
				Set rsObj(n) = subObj
				n = n + 1
				End if
			Next

		End if

		jsonTors_SE = toJSON(rsObj)

	Else
		jsonTors_SE = toJSON(rsObj)
	End if

End Function




'   ===============================================================================     
'      2에 N값 구하기
'   =============================================================================== 
Function getN(rt)
	Dim i 
	For i = 1 To 10
		If rt =  2^i Then
			getN = i
			Exit function
		End If
	Next
	getN = 0
End function


'소수점 이하버림
Function Ceil_dot(ByVal intParam, ByVal jumno)  
	Dim sousooarr
	If InStr(intParam, ".") > 0 then
	sousooarr = Split(intParam,".")
	Ceil_dot = sousooarr(0) & "." & Left(sousooarr(1),jumno)
	Else
	Ceil_dot = intParam & ".0"
	End if
End Function  

'올림함수########################
Function Ceil_a(ByVal intParam)
	Ceil_a = -(Int(-(intParam)))
End Function


'#############################
'레코드 JSON 으로 반환
	'배열 예
	'listarr = jsonTors_arr(rs)
	'Set list = JSON.Parse( join(array(listarr)) )
	'Call oJSONoutput.Set("LIST", list )
'#############################
Function jsonTors_arr(rs)
	Dim rsObj,subObj, fieldarr, i, arr, mainObj,ar,c

	Set mainObj = jsObject()

	ReDim rsObj(rs.RecordCount - 1)
	ReDim fieldarr(Rs.Fields.Count-1)
	For i = 0 To Rs.Fields.Count - 1
		fieldarr(i) = Rs.Fields(i).name
	Next

	If Not rs.EOF Then
		arr = rs.GetRows()

		If IsArray(arr) Then
			For ar = LBound(arr, 2) To UBound(arr, 2)

				Set subObj = jsObject()
				For c = LBound(arr, 1) To UBound(arr, 1)
					subObj(fieldarr(c)) = arr(c, ar)
				Next
				Set rsObj(ar) = subObj
			Next
		End if

		jsonTors_arr = toJSON(rsObj)
	Else
		jsonTors_arr = toJSON(rsObj)
	End if
End Function





'배열내 중복값 제거
Function FnDistinctData(ByVal aData)
 	   Dim dicObj, items, returnValue

 	   Set dicObj = CreateObject("Scripting.dictionary")
 	   dicObj.removeall
 	   dicObj.CompareMode = 0

'loop를 돌면서 기존 배열에 있는지 검사 후 Add
 	   For Each items In aData
 	   	   If not dicObj.Exists(items) Then dicObj.Add items, items
 	   Next

 	   returnValue = dicObj.keys
 	   Set dicObj = Nothing
 	   FnDistinctData = returnValue
End Function



'*******************************************************************************************
' 문자발송
'*******************************************************************************************
Sub sendPhoneMessage(db,sendType, title, msg, sitecode, fromphone, tophone)
	Dim SQL 
	fromphone = Replace(fromphone,"-","")
	tophone = Replace(tophone,"-","")
	msg = Replace(msg,"\n",vbLf)

	'sendType 7 LMS 3, MMS
	If sendType = "" Then
		sendType = 3
	End If
	
	'suserID  =  배드민턴 아이디/전화번호 bka1957/027040282
	'sms_88 수영
	'테니스는 테니스에 있다. sitecode = ""

	If sitecode = "" Or sitecode = "TENNIS01" Then '테니스
	SQL  = " INSERT INTO SD_Tennis.dbo.t_send (sSubject,nSvcType,nAddrType,sAddrs,nContsType,sConts,sFrom,dtStartTime, sitecode)  "	
	Else '수영..
	SQL  = " INSERT INTO sms_88.dbo.t_send (sSubject,nSvcType,nAddrType,sAddrs,nContsType,sConts,sFrom,dtStartTime, sitecode)  "
	End If
	
	SQL = SQL & " VALUES ('"& title &"', '"& sendType &"', 0, '"& tophone &"', 0, '"& msg &"', '"& fromphone &"', GETDATE(), '"& sitecode &"' ) "
	Call db.execSQLRs(SQL , null, ConStr)
End Sub


'==============================================
'1차원배열 소팅
'==============================================
function sortArray(arrShort)
	Dim i , temp, j 

	for i = UBound(arrShort) - 1 To 0 Step -1
		for j= 0 to i
			if arrShort(j)>arrShort(j+1) then
				temp=arrShort(j+1)
				arrShort(j+1)=arrShort(j)
				arrShort(j)=temp
			end if
		next
	next
	sortArray = arrShort

end Function



'2차원 배열 소팅  사용예) productEvList = arraySort (arrNo, 4, "Text", "asc" ) 
'==============================================
function arraySort( arToSort, sortBy, compareType, direction )
'==============================================
	Dim c, d, e, smallestValue, smallestIndex, tempValue
	For c = 0 To uBound( arToSort, 2 ) - 1
	 smallestValue = arToSort( sortBy, c )
	 smallestIndex = c
	 For d = c + 1 To uBound( arToSort, 2 )
	  if compareType = "Text" Then
	   If direction = "desc" Then 
		if strComp( CStr(arToSort( sortBy, d )), CStr(smallestValue) ) = -1 Then
		 smallestValue = arToSort( sortBy, d )
		 smallestIndex = d
		End if
	   Else 
		if strComp( CStr(arToSort( sortBy, d )), CStr(smallestValue) ) = 1 Then
		 smallestValue = arToSort( sortBy, d )
		 smallestIndex = d
		End if
	  End If 
	  elseif compareType = "Date" then
	   if not isDate( smallestValue ) then
		arraySort = arraySort( arToSort, sortBy, false)
	   exit function
	  else
	   if dateDiff( "d", arToSort( sortBy, d ), smallestValue ) > 0 Then
		smallestValue = arToSort( sortBy, d )
		smallestIndex = d
	   End if
	  end if
	  elseif compareType = "Number" Then
	   if clng( arToSort( sortBy, d ) ) < clng(smallestValue) Then
		smallestValue = arToSort( sortBy, d )
		smallestIndex = d
	   End if
	  end if
	 Next
	 if smallestIndex <> c Then 'swap
	  For e = 0 To uBound( arToSort, 1 )
	   tempValue = arToSort( e, smallestIndex )
	   arToSort( e, smallestIndex ) = arToSort( e, c )
	   arToSort( e, c ) = tempValue
	  Next
	 End if
	Next
	arraySort = arToSort 
end function




'시분초로 변경
Function setTimeFormat(ByVal timestr)
	setTimeFormat = FormatDateTime(CDate(timestr),4) + ":" + Right(timestr,2)
End Function


Sub ajaxUrlPrint(chkip)
	If chkip = "118.33.86.240" Then
		Response.write "API 파일 : "&NOW_URL&"<br>"
	End if
End sub

Sub debugPrint(ByVal chkip, ByVal bugstr)

	If chkip = "118.33.86.240" Then
		Response.write  bugstr
	End if

End sub


'*******************************************************************************************
' getRows table형식으로 출력
'*******************************************************************************************
Sub getRowsDrowTable(ByRef rs ,ByVal tableclass)
	Dim row,col,arr,rowidx
	If Not rs.eof Then arr = rs.GetRows

	response.write "<table class='"&tableclass&"'>"
	'thead
	Response.write "<thead>"
	If IsArray(arr) Then
	For row = 0 To LBound(arr, 2) 'Rows top 1
		Response.write "<tr class=""gametitle"">"
		For col = 0 To UBound(arr, 1) 'Columns
			Response.Write "<th>"  & rs.Fields(col).Name  & "</th>"
		Next
		Response.write "</tr>"
	Next
	End If
	'tbody
	Response.write "<tbody id='content'  >"
	If IsArray(arr) Then
		For row = LBound(arr, 2) To UBound(arr, 2)
			rowidx = arr(0, row)			
			Response.write "<tr style=""cursor:pointer;"" onclick = ""$('#content tr').css('background-color', 'white' );$( this ).css( 'background-color', '#BFBFBF' );mx.input_edit("&rowidx&"); "">"
			For col = LBound(arr, 1) To UBound(arr, 1)
				Response.write "<td>" & arr(col, row) & "</td>"
			Next
			Response.write "</tr>"
		Next
	End if
	Response.write "</tbody>"
	Response.write "</table>"
End Sub



'*******************************************************************************************
' getRows 출력
'*******************************************************************************************
Sub getRowsDrow(arr)
	Dim c, ar
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


'*******************************************************************************************
' 성별한글반환
'*******************************************************************************************
Function strSex(sex)
	If LCase(sex) = "man" Or sex = "1" Then
		strSex = "남"
	Else
		strSex = "여"
	End If
End function

'*******************************************************************************************
' 핸드폰 번호를 받아서 배열로 반환
'*******************************************************************************************
function phonesplit(pno)
	Dim phonearr(3)
	pno =Replace(pno,"-","")
	phonearr(3) = pno
	phonearr(0) = left(pno,3)
	if len(pno)>=11 then
		phonearr(1) = mid(pno,4,4)
		phonearr(2) = right(pno,4)
	else
		phonearr(1) = mid(pno,4,3)
		phonearr(2) = right(pno,4)
	end if

	phonesplit = phonearr
End function


'*******************************************************************************************
' 배열내의 중복값 가져오기
' varArr : 배열
'*******************************************************************************************
Function DuplValRemove(ByVal varArr)
 	   Dim dic, items, rtnVal,i
	   Dim dup(12) '최대

 	   Set dic = CreateObject("Scripting.Dictionary")
 	   dic.removeall
 	   dic.CompareMode = 0

	   i = 0
 	   For Each items In varArr
 	   	   If not dic.Exists(items) Then
			dic.Add items, items
		   Else
			'중복값
			dup(i) = items
			i = i + 1
		   End if
 	   Next

 	   rtnVal = dup 'dic.keys (중복제거값)
 	   Set dic = Nothing
 	   DuplValRemove = rtnVal
End Function



Function Stream_BinaryToString(Binary, CharSet)
  Const adTypeText = 2
  Const adTypeBinary = 1

  'Create Stream object
  Dim BinaryStream 'As New Stream
  Set BinaryStream = Server.CreateObject("ADODB.Stream")

  'Specify stream type - we want To save text/string data.
  BinaryStream.Type = adTypeBinary

  'Open the stream And write text/string data To the object
  BinaryStream.Open
  BinaryStream.Write Binary


  'Change stream type To binary
  BinaryStream.Position = 0
  BinaryStream.Type = adTypeText

  'Specify charset For the source text (unicode) data.
  If Len(CharSet) > 0 Then
    BinaryStream.CharSet = CharSet
  Else
    BinaryStream.CharSet = "us-ascii"
  End If

  'Open the stream And get binary data from the object
  Stream_BinaryToString = BinaryStream.ReadText
End Function


'######################################################

Function GetHTTPFile(strURL)
    Dim objXML
    Dim strHTTPResponse

    Set objXML = Server.CreateObject("Msxml2.ServerXMLHTTP")

    Call objXML.Open("GET", strURL, False)
    Call objXML.Send()

    strHTTPResponse = objXML.responseBody 'responseText

    Set objXML = Nothing

    GetHTTPFile = strHTTPResponse
End Function




'Const Ref = "GPQRSATWXVYBCHL640MN598OIJKZ12D7EF3U"

Ref = "GPQRSATWXVYBCHL640MN598OIJKZ12D7EF3U"

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
        For i = 1 To Len(pStr)
          one_hex = Hex(Asc(Mid(pStr, i, 1)))
          retVal = retVal & one_hex
        Next
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












	'f_dec

	Sub rsDrow(ByVal rs)
	Dim i 
		For i = 0 To Rs.Fields.Count - 1
			'response.write  Rs.Fields(i).name &","
		Next

		response.write "<table class='table' id=""tblrsdrow"">"
		Response.write "<thead id=""headtest"">"
		For i = 0 To Rs.Fields.Count - 1
			response.write "<th>"& Rs.Fields(i).name &"</th>"
		Next
		Response.write "</thead>"

		ReDim rsdata(Rs.Fields.Count) '필드값저장

		Do Until rs.eof
			For i = 0 To Rs.Fields.Count - 1
				rsdata(i) = rs(i)
			Next
			%>
				<tr class="gametitle">
					<%
						For i = 0 To Rs.Fields.Count - 1
							If Rs.Fields(i).name = "취소계좌" And  rsdata(i) <> "" Then
								Response.write "<td>" & f_dec(rsdata(i))   & "</td>"
							else
								Response.write "<td>" & rsdata(i)   & "</td>"
							End if
						Next
					%>
				</tr>
			<%
		rs.movenext
		Loop

		If Not rs.eof then
		rs.movefirst
		End if
		Response.write "</tbody>"
		Response.write "</table>"
	End Sub



	'배열값을 랜덤하게 섞어주는 함수 (대상배열, 생성갯수)
	Function Shuffle( inArray, needed )
		incnt = UBound( inArray )
		dim outArray
		redim outArray( needed )

		For i = 0 To needed
			Randomize
			choose = Int( incnt * Rnd(1) )
			outArray( i ) = inArray( choose )
			inArray( choose ) = inArray( incnt )
			incnt = incnt - 1

		Next
		Shuffle = outArray
	End Function




	Function getPubday(sval, sval2)
		rval_fn = ""
		if sval <> "" then
			if sval = "M1" then '매월
				rval_fn = "매월 " & sval2 & "일"
			elseif sval = "W1" then '매주
				rval_fn = replace(sval2,"0","일")
				rval_fn = replace(rval_fn,"1","월")
				rval_fn = replace(rval_fn,"2","화")
				rval_fn = replace(rval_fn,"3","수")
				rval_fn = replace(rval_fn,"4","목")
				rval_fn = replace(rval_fn,"5","금")
				rval_fn = replace(rval_fn,"6","토")
				rval_fn = "매주 " & rval_fn & "요일"
			elseif sval = "T1" then '격주
				rval_fn = replace(sval2,"0","일")
				rval_fn = replace(rval_fn,"1","월")
				rval_fn = replace(rval_fn,"2","화")
				rval_fn = replace(rval_fn,"3","수")
				rval_fn = replace(rval_fn,"4","목")
				rval_fn = replace(rval_fn,"5","금")
				rval_fn = replace(rval_fn,"6","토")
				rval_fn = "격주 " & rval_fn & "요일"
			elseif sval = "W2" then '주2회
				rval_fn = replace(sval2,"0","일")
				rval_fn = replace(rval_fn,"1","월")
				rval_fn = replace(rval_fn,"2","화")
				rval_fn = replace(rval_fn,"3","수")
				rval_fn = replace(rval_fn,"4","목")
				rval_fn = replace(rval_fn,"5","금")
				rval_fn = replace(rval_fn,"6","토")
				rval_fn = "매주 " & replace(rval_fn,",","요일,") & "요일"
			elseif sval = "D1" then '1일
				rval_fn = "매월 1일, 11일, 21일"
			elseif sval = "B1" then
				rval_fn = "비정기"
			end if

		end if

		getPubday = rval_fn
	End Function

	Function setColumnIdx(ByVal rs)
		Set dic = Server.CreateObject("Scripting.Dictionary")
		For i = 0 To rs.Fields.Count - 1
			dic.Add rs.Fields(i).Name, i
        Next
		Set setColumnIdx = dic
	End Function

	'----------------------------------------------------------------------
	'@description
	'	입력된 데이터값 출력
	'@param
	'	(string) value : 데이터값
	'@return
	'----------------------------------------------------------------------
	Sub print(ByVal value)
		response.write value & "<br>"
	End Sub

	'----------------------------------------------------------------------
	'@description
	'	입력된 조건값을 비교 후에 Boolean 값을 반환한다.
	'@param
	'	(Boolean) condition : 비교할 데이터 조건
	'	(string)  true_val  : True 일경우 반환값
	'	(string)  false_val : False 일경우 반환값
	'@return
	'	(string) true or false 반환값
	'----------------------------------------------------------------------
	Function iif(ByVal condition, ByVal true_val, ByVal false_val)
		If condition Then
			iif = true_val
		Else
			iif = false_val
		End If
	End Function


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



	'----------------------------------------------------------------------
	' Description
	'		숫자형의 자리수가 한자리일경우 두자리로 변환 처리
	' Params
	'		data	: 데이터값
	' Return
	'		두자리 문자형 값으로 반환
	'----------------------------------------------------------------------
	Function addZero(ByVal val)
		If Len(val) = 1 Then
			addZero = "0" & val
		Else
			addZero = val
		End If
	End Function



	'----------------------------------------------------------------------
	' Description
	'		인증번호 생성
	' Params
	'		length	: 반환길이
	' Return
	'		생성된 인증번호 반환
	'----------------------------------------------------------------------
	Function returnAuthNum(ByVal length)
		Dim i, num
		Dim tmpAuthNum, tmpAuthLength, tmpAuthNumResult

		tmpAuthNum = "0123456789"
		tmpAuthLength = length

		If chkBlank(Trim(tmpAuthLength)) Then tmpAuthLength = 6

		tmpAuthNumResult = ""
		Randomize
		For i = 1 to tmpAuthLength
			num = Int((10 - 1 + 1) * Rnd + 1)
			tmpAuthNumResult = tmpAuthNumResult & Mid(tmpAuthNum,num,1)
		Next

		returnAuthNum = tmpAuthNumResult
	End Function


	'----------------------------------------------------------------------
	' Description
	'		현재 시간을 기준으로 고유한 값을 돌려준다 시분초까지 사용.
	'		YYYYHHMMSS 형식의 값을 반환 한다.
	' Params
	' Return
	'		생성된 Number값
	'----------------------------------------------------------------------
	Function returnNowNum()

		Dim dates, seconds, minutes, hours

		dates = Replace(Replace(Date(),"-",""),":","")
		seconds = Second(Now())
		minutes = minute(Now())
		hours = Hour(Now())

		If Len(seconds) = 1 Then
			seconds = "0" & seconds
		End If

		If Len(minutes) = 1 Then
			minutes = "0" & minutes
		End If

		If Len(hours) = 1 Then
			hours = "0" & hours
		End If

		returnNowNum = dates  & hours & minutes & seconds

	End Function


	'----------------------------------------------------------------------
	' Description
	'		사용자 코드 생성
	' Params
	'		length	: 반환길이
	' Return
	'		생성된 코드 반환
	'----------------------------------------------------------------------
	Function returnUserCode()
		Dim i, num
		Dim tmpEng, tmpNum, tmpCodeResult

		tmpEng = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
		tmpNum = "0123456789"

		tmpCodeResult = ""
		Randomize

		For i = 1 to 2
			num = Int((26 - 1 + 1) * Rnd + 1)
			tmpCodeResult = tmpCodeResult & Mid(tmpEng,num,1)
		Next

		For i = 1 to 6
			num = Int((10 - 1 + 1) * Rnd + 1)
			tmpCodeResult = tmpCodeResult & Mid(tmpNum,num,1)
		Next

		returnUserCode = tmpCodeResult
	End Function


	'----------------------------------------------------------------------
	' Description
	'		Windows Style GUID 만들기
	' Params
	'
	' Return
	'		생성된 코드 반환
	'----------------------------------------------------------------------
    Function fnGetGUID()
		Dim myTypeLib, tmpGuid
		Set myTypeLib = Server.CreateObject("Scriptlet.Typelib")
		tmpGuid = myTypeLib.guid
		Set myTypeLib = Nothing

		tmpGuid = Replace(tmpGuid,"{","")
		tmpGuid = Replace(tmpGuid,"}","")

		fnGetGUID = tmpGuid
    End Function


	'----------------------------------------------------------------------
	' Description
	'		주문번호생성
	' Params
	'
	' Return
	'		생성된 코드 반환
	'----------------------------------------------------------------------
    Function makeOrderNum()
		Dim md

		'Set md = new md5
		'	Randomize
		'	makeOrderNum = Replace(Date,"-","") & UCase(Left(md.MD5(Rnd * 999999), 7))
		'Set md = Nothing

		makeOrderNum = Replace(Date,"-","") & returnAuthNum(7)
    End Function



	'----------------------------------------------------------------------
	' Description
	'		이미지 사이즈 비교 후 정비율로 이미지 사이즈값을 반환한다.
	' Params
	'		width     = 이미지 가로 크기값
	'		height    = 이미지 세로 크기값
	'		maxWidth  = 비교할 가로 크기값
	'		maxHeight = 비교할 세로 크기값
	' Return
	'		변환된 width:height
	'----------------------------------------------------------------------
	Function getImageSize(ByVal width, ByVal height,ByVal maxWidth,ByVal maxHeight)
		If width > maxWidth Then
			ratio = maxWidth / width

			width = maxWidth
			height = Int(height * ratio)
		End If

		If height > maxHeight Then
			ratio = maxHeight / height

			height = maxHeight
			width = Int(width * ratio)
		End If

		getImageSize = width &":"& height
	End Function


	'----------------------------------------------------------------------
	' Description
	'		지정된 값에 대해서 입력된 값을 절사 시킨다.
	' Params
	'		number = 입력된 숫자형 데이터
	'		number_round = 절사시킬 자리수
	' Return
	'		절사처리된 값
	'----------------------------------------------------------------------
	Function numberRound(ByVal number, ByVal number_round)

		numberRound = CLng(number / number_round) * number_round

	End Function


	'----------------------------------------------------------------------
	' Description
	'		가운데 자리 보안처리
	' Params
	'		val		 = 입력 데이터 값
	' Return
	'		변환된 데이터값
	'----------------------------------------------------------------------
	Function getSecureWord(ByVal word)
		If chkBlank(word) Then Exit Function

		Dim i
		Dim resultWord : resultWord = ""

		If Len(word) < 3 Then
			resultWord = resultWord & Left(word,1) &"*"
		Else
			resultWord = resultWord & Left(word,1)
			For i=1 To Len(word)-2
				resultWord = resultWord & "*"
			Next
			resultWord = resultWord & Right(word,1)
		End If

		getSecureWord = resultWord
	End Function


	'----------------------------------------------------------------------
	' Description
	'		길이에 맞게 앞에 설정자리외 *표시
	' Params
	'		val		 = 입력 데이터 값
	'		openLens = 보여줄 자리수
	'		wordLens = 숨길 고정 자리수
	' Return
	'		변환된 데이터값
	'----------------------------------------------------------------------
	Function getSecureWord2(ByVal val, ByVal openLens, ByVal wordLens)
		Dim tmp_datas : tmp_datas = val
		Dim l, secStar

		If Len(tmp_datas) <= 4 Then
			tmp_datas = Left(tmp_datas, 2)
			openLens  = 2
		Else
			tmp_datas = Left(tmp_datas, openLens)
		End If

		For l = openLens+1 To wordLens
			secStar = secStar & "*"
		Next

		getSecureWord2 = tmp_datas & secStar
	End Function


	'----------------------------------------------------------------------
	' Description
	'		이메일 발송 파일내용 불러오기
	' Params
	'		val		 = 입력 데이터 값
	'		openLens = 보여줄 자리수
	'		wordLens = 숨길 고정 자리수
	' Return
	'		변환된 데이터값
	'----------------------------------------------------------------------
	Function getEmailSendFile(ByVal file_path)
		Dim fso, file, contents

		Set fso = Server.CreateObject("Scripting.FileSystemObject")
			Set file = fso.OpenTextFile(Server.Mappath(file_path), 1)
				contents = file.ReadAll()
			Set file = Nothing
		Set fso = Nothing

		getEmailSendFile = contents
	End Function


	'----------------------------------------------------------------------
	' Description
	'		세션삭제
	' Params
	'		session_name : 세션명
	' Return
	'
	'----------------------------------------------------------------------
	Sub removeSession(ByVal session_name)
		session(session_name) = ""
		session.Contents.Remove(session_name)
	End Sub

	'----------------------------------------------------------------------
	' Description
	'		경로에서 파일명 뽑아내기
	' Params
	'		types	: 데이터값
	' Return
	'		데이터 처리결과
	'----------------------------------------------------------------------
	Function filePathFixName(ByVal types)
		Dim path, fixName, tmpData

		path = URL_PATH
		path = Right(path,InStr(StrReverse(path),"/")-1)
		path = Mid(path,1,Len(path)-4)
		fixName = path

		If types = 1 Then		'originfix
			'(예) /intranet/event/event_list.asp → event_list
			filePathFixName = fixName
		ElseIf types = 2 Then	'prefix
			'(예) /intranet/event/event_list.asp → event
			tmpData = Split(fixName,"_")
			filePathFixName  = tmpData(0)
		ElseIf types = 3 Then	'suffix
			'(예) /intranet/event/event_list.asp → list
			tmpData = Split(fixName,"_")
			filePathFixName  = tmpData(UBound(tmpData))
		End If
	End Function


	'----------------------------------------------------------------------
	' Description
	'		모바일 기기체크
	' Params
	'
	' Return
	'		모바일 기기에서 접속인지 체크여부 반환
	'----------------------------------------------------------------------
	Function returnMobileCheck()
		Dim mobile, mobileArr, userAgent, mobileCheck, i

		mobileCheck = False
		mobile = "iPhone|iPod|BlackBerry|Android|Windows CE|LG|MOT|SAMSUNG|SonyEricsson|Mobile|Symbian|Opera Mobi|Opera Mini|IEmobile|Mobile|lgtelecom|PPC"
		mobileArr = split(mobile,"|")

		userAgent = Request.ServerVariables("HTTP_USER_AGENT")
		For i = 0 to UBound(mobileArr)
			If InStr(userAgent, mobileArr(i)) > 0 Then
				mobileCheck = True
			End If
		Next

		returnMobileCheck = mobileCheck
	End Function


	'----------------------------------------------------------------------
	' Description
	'		로그기록
	' Params
	'		logMemo : 로그기록 내용
	'		logPath : 로그저장 장소
	' Return
	'		해당경로에 로그기록표시
	'----------------------------------------------------------------------
	Sub writeLog(ByVal logMemo, ByVal logPath)
		Dim objFso, objFile, logWrite

		Set objFso = CreateObject("Scripting.FileSystemObject")

		If Not objFso.fileExists(logPath) Then
			Set objFile = objFso.CreateTextFile(logPath,True)
		Else
			Set objFile = objFso.OpenTextFile(logPath, 8, True)
		End If

		objFile.WriteLine("["& Now() &"] ["& NOW_URL &"] "& logMemo)

		objFile.Close
		Set objFile = Nothing
		Set objFso = Nothing
	End Sub


	Function writeFormLog(ByVal logPath)
		Dim objFso, objFile, params

		Set objFso = CreateObject("Scripting.FileSystemObject")

		If Not objFso.fileExists(logPath) Then
			Set objFile = objFso.CreateTextFile(logPath,True)
		Else
			Set objFile = objFso.OpenTextFile(logPath, 8, True)
		End If

		params = ""
		For Each item In request.Form
			If params <> "" Then params = params & "|@|"
			params = params & iif(request.Form(item)<>"", item &":"& request.Form(item), "null")
		Next

		objFile.WriteLine("["& Now() &"] ["& URL_PATH &"] POST PARAMS "& params)

		objFile.Close
		Set objFile = Nothing
		Set objFso = Nothing
	End Function


	Function writeQueryLog(ByVal logPath)
		Dim objFso, objFile, params

		Set objFso = CreateObject("Scripting.FileSystemObject")

		If Not objFso.fileExists(logPath) Then
			Set objFile = objFso.CreateTextFile(logPath,True)
		Else
			Set objFile = objFso.OpenTextFile(logPath, 8, True)
		End If


		For Each item In request.querystring
			If params <> "" Then params = params & "|@|"
			params = params & iif(request.querystring(item)<>"", item &":"& request.querystring(item), "null")
		Next

		objFile.WriteLine("["& Now() &"] ["& URL_PATH &"] GET PARAMS "& params)

		objFile.Close
		Set objFile = Nothing
		Set objFso = Nothing
	End Function

	Sub writeDBLog(ByVal tableName, ByVal fieldName, ByVal idxFieldName ,ByVal WhereQuery, ByVal newValue, ByVal operation, ByVal adminName)

		'--------EX Parameter -----------
		'tableName = " sd_TennisRPoint "
		'fieldName = "rankpoint"
		'idxFieldName = "idx"
		'WhereQuery = " Where PlayerIDX = 14637 and teamGb = 20101 "
		'newValue = "13"
		'operation = "update"
		'adminName = "admin"
		'--------Parameter -----------

		'Set db = new clsDBHelper
		' 1. Arrange
		log_WhereQuery = WhereQuery
		log_tableName = tableName
		log_fieldName = fieldName
		log_idxFieldName = idxFieldName
		log_newvalue = newValue
		log_operation = operation
		log_adminName = adminName

		'response.write log_idx & "<br>"
		'response.write log_tableName & "<br>"
		'response.write log_fieldName & "<br>"
		'response.write log_newvalue & "<br>"
		'response.write log_operation & "<br>"
		IF Len(log_idxFieldName) > 0 Then
			log_idxField = " ," & log_idxFieldName
		End If

		'2.Select
		SQL = " Select " & log_fieldName & log_idxField & " from " & log_tableName & log_WhereQuery
		'response.write SQL & "<br>"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not (rs.EOF or rs.BOF) Then
			oldValue = rs(0)
			log_oldvalue = oldValue
			'Response.Write log_oldvalue & "</br>"
			IF Len(log_idxFieldName) > 0 Then
				log_idxFieldValue =  rs(1)
			End If
			'Rows = rs.GetRows()
		End If

		'3.Act
		'Insert, update
		field = " tableIdx, adminName, operation, tableName, fieldName, oldValue, newValue "
		strSql = "Insert INTO tblUpdateLog ("& field &") VALUES "
		strSql = strSql & "('" & log_idxFieldValue  & "'"
		strSql = strSql & ",'" & log_adminName & "'"
		strSql = strSql & ",'" & log_operation & "'"
		strSql = strSql & ",'" & log_tableName & "'"
		strSql = strSql & ",'" & log_fieldName & "'"
		strSql = strSql & ",'" & log_oldvalue & "'"
		strSql = strSql & ",'" & log_newValue & "')"
		'response.write strSql
		Call db.execSQLRs(strSql , null, ConStr)

	End Sub

	Sub writeDBLogNonQuery(ByVal tableName, ByVal fieldName,ByVal tableIdx, ByVal oldValue, ByVal newValue, ByVal operation, ByVal adminName)

  '--------Parameter -----------
  'tableName = " sd_TennisRPoint "
  'fieldName = "rankpoint"
  'idxFieldName = "idx"
  'WhereQuery = " PlayerIDX = 14637 and teamGb = 2010232312 "
  'oldValue = "10"
  'newValue = "13"
  'operation = "update"
  'adminName = "admin"
  '--------Parameter -----------

  ' 1. Arrange
  'log_WhereQuery = WhereQuery
  log_tableName = tableName
  log_fieldName = fieldName
	log_idxFieldValue = tableIdx
  log_oldvalue = oldValue
  log_newvalue = newValue
  log_operation = operation
  log_adminName = adminName

  'response.write log_tableName & "<br>"
  'response.write log_fieldName & "<br>"
  'response.write log_oldvalue & "<br>"
  'response.write log_newvalue & "<br>"
  'response.write log_operation & "<br>"
	'response.write log_adminName & "<br>"


  '3.Act
  'Insert, update
  field = " tableIdx, adminName, operation, tableName, fieldName, oldValue, newValue "
  strSql = "Insert INTO tblUpdateLog ("& field &") VALUES "
  strSql = strSql & "('" & log_idxFieldValue
  strSql = strSql & "','" & log_adminName & "'"
  strSql = strSql & ",'" & log_operation & "'"
  strSql = strSql & ",'" & log_tableName & "'"
  strSql = strSql & ",'" & log_fieldName & "'"
  strSql = strSql & ",'" & log_oldvalue & "'"
  strSql = strSql & ",'" & log_newValue & "')"
  'response.write strSql
  Call db.execSQLRs(strSql , null, ConStr)

	End Sub


	'만나이계산
	Function korAge(ByVal birthday)
		If Month(birthday) < Month(Now()) Then
			korAge = Year(Now()) - Year(birthday)
		ElseIf Month(birthday) = Month(Now()) Then
			If Day(birthday) <= Day(Now()) Then
				korAge = Year(Now()) - Year(birthday)
			Else
				korAge = Year(Month()) - Year(birthday) - 1
			End If
		Else
			korAge = Year(Now()) - Year(birthday) - 1
		End If
	End Function



Function include(sFile)
	dim mfo, mf, sTemp, arTemp, arTemp2, lTemp, sTemp2, lTemp2, sFile2

	If InStr(1,sFile,":") = 0 Then
		sFile = Server.MapPath(sFile)
	End If

	'first read the file into a variable use FSO
	set mfo = Server.CreateObject("Scripting.FileSystemObject")

	'does file exist?
	If mfo.FileExists(sFile) Then
		'read it
		set mf = mfo.OpenTextFile(sFile, 1, false, -2)
		sTemp = mf.ReadAll
		mf.close
		set mfo = nothing
	Else
		sTemp = ""
	End If

	If sTemp <> "" Then
		'sTemp contains the mixed ASP and HTML, so the next task is to dynamically replace the inline HTML with response.write statements
		arTemp = Split(sTemp,"<" & "%")
		sTemp = ""

		For lTemp = LBound(arTemp) to UBound(arTemp)

			If InStr(1,arTemp(lTemp),"%" & ">") > 0 Then
				'inline asp
				arTemp2 = Split(arTemp(lTemp),"%" & ">")

				'everything up to the % > is ASP code

				sTemp2 = trim(arTemp2(0))

				If Left(sTemp2,1) = "=" Then
					'need to replace with response.write
					sTemp2 = "Response.Write " & mid(sTemp2,2)
				End If

				sTemp = sTemp & sTemp2 & vbCrLf

				'everything after the % > is HTML
				sTemp2 = arTemp2(1)

			Else
				'inline html only
				sTemp2 = arTemp(lTemp)

			End If

			arTemp2 = Split(sTemp2,vbCrLf)
			For lTemp2 = LBound(arTemp2) to UBound(arTemp2)
				sTemp2 = Replace(arTemp2(lTemp2),"""","""""")   'replace quotes with doubled quotes
				sTemp2 = "Response.Write """ & sTemp2 & """"    'add response.write and quoting

				If lTemp2 < Ubound(arTemp2) Then
					sTemp2 = sTemp2 & " & vbCrLf"   'add cr+lf if not the last line inlined
				End If

				sTemp = sTemp & sTemp2 & vbCrLf 'add to running variable
			Next

		Next

		Execute sTemp

		ExecInclude = True

	End If
End Function

'// 유/무료 체크
Function getPayYN(coin_flag, coin, coin_day)
	if coin_flag = "Y" then
		fval = "Y"
	elseif coin_flag = "N" then
		fval = "N"
	elseif coin_flag = "FY" then
		if chkBlank(coin_day) then
		else
			if coin_day < left(const_now,10) or coin_day = left(const_now,10) then
				fval = "N"
			else
				if coin > 0 then
					fval = "Y"
				end if
			end if

		end if
	elseif coin_flag = "FN" then
		if chkBlank(coin_day) then
		else
			if coin_day < left(const_now,10) or coin_day = left(const_now,10) then
				if coin > 0 then
					fval = "Y"
				end if
			end if
		end If
	else
		fval = "N"
	end if

	getPayYN = fval
End Function

Sub writeLog(ByVal logMemo, ByVal logPath)

	Dim objFso, objFile, logWrite

	Set objFso = CreateObject("Scripting.FileSystemObject")

	If Not objFso.fileExists(logPath) Then
		Set objFile = objFso.CreateTextFile(logPath,True)
	Else
		Set objFile = objFso.OpenTextFile(logPath, 8, True)
	End If

	objFile.WriteLine("["& Now() &"] "& logMemo)

	objFile.Close
	Set objFile = Nothing
	Set objFso = Nothing
End Sub




Function gen_dedate(datedata)
	Dim ddatedata
	If IsNull(datedata) = True Or datedata = "" then
		ddatedata =""
	Else
		Select Case Len(datedata)
			Case 6:ddatedata = Left(datedata,2) & "-" & Mid(datedata,3,2) & "-" & Mid(datedata,5,2)
			Case 8:ddatedata = Left(datedata,4) & "-" & Mid(datedata,5,2) & "-" & Mid(datedata,7,2)
			Case 10:ddatedata = Left(datedata,2) & "-" & Mid(datedata,3,2) & "-" & Mid(datedata,5,2) & " " & Mid(datedata,7,2) & ":" & Mid(datedata,9,2)
			Case 12:ddatedata = Left(datedata,4) & "-" & Mid(datedata,5,2) & "-" & Mid(datedata,7,2) & " " & Mid(datedata,9,2) & ":" & Mid(datedata,11,2)
			Case 14:ddatedata = Left(datedata,4) & "-" & Mid(datedata,5,2) & "-" & Mid(datedata,7,2) & " " & Mid(datedata,9,2) & ":" & Mid(datedata,11,2) & ":" & Mid(datedata,13,2)
			Case else:ddatedata =""
		End select
	End If
	gen_dedate = ddatedata
End Function


Function gen_endate()
	Dim datedata
	datedata = cstr(Hour(now))
	if len(datedata)=1 then datedata = "0" & datedata
	datedata = datedata & trim(replace(right(formatdatetime(now, 3), 5),":",""))
	gen_endate = replace(cstr(date),"-","") & datedata
End Function

Function gen_dedate(datedata)
	Dim ddatedata
	If IsNull(datedata) = True Or datedata = "" then
		ddatedata =""
	Else
		Select Case Len(datedata)
			Case 6:ddatedata = Left(datedata,2) & "-" & Mid(datedata,3,2) & "-" & Mid(datedata,5,2)
			Case 8:ddatedata = Left(datedata,4) & "-" & Mid(datedata,5,2) & "-" & Mid(datedata,7,2)
			Case 10:ddatedata = Left(datedata,2) & "-" & Mid(datedata,3,2) & "-" & Mid(datedata,5,2) & " " & Mid(datedata,7,2) & ":" & Mid(datedata,9,2)
			Case 12:ddatedata = Left(datedata,4) & "-" & Mid(datedata,5,2) & "-" & Mid(datedata,7,2) & " " & Mid(datedata,9,2) & ":" & Mid(datedata,11,2)
			Case 14:ddatedata = Left(datedata,4) & "-" & Mid(datedata,5,2) & "-" & Mid(datedata,7,2) & " " & Mid(datedata,9,2) & ":" & Mid(datedata,11,2) & ":" & Mid(datedata,13,2)
			Case else:ddatedata =""
		End select
	End If
	gen_dedate = ddatedata
End Function


'memo_cnt1=0 '수신메시지
Function genNumeric(Nobj)
	If VarType(Nobj) = vbnull Then
		genNumeric= False
	Else
		Nobj = RTrim(lTrim(Nobj))
		If isNumeric(Nobj) =False Or Nobj="" Then
			genNumeric= False
		Else
			genNumeric= true
		End if
	End if
End function

Function genleft(t,f)
	If Len(t) > f Then
		genleft = Left(t,f) & ".."
	Else
		genleft = t
	End if
End Function



'/////////////
Sub QuickSort(vec,loBound,hiBound,SortField)
   '==--------------------------------------------------------==
  '== Sort a 2 dimensional array on SortField                ==
  '==                                                        ==
  '== This procedure is adapted from the algorithm given in: ==
  '==    ~ Data Abstractions & Structures using C++ by ~     ==
  '==    ~ Mark Headington and David Riley, pg. 586    ~     ==
  '== Quicksort is the fastest array sorting routine for     ==
  '== unordered arrays.  Its big O is  n log n               ==
  '==                                                        ==
  '== Parameters:                                            ==
  '== vec       - array to be sorted                         ==
  '== SortField - The field to sort on (2nd dimension value) ==
  '== loBound and hiBound are simply the upper and lower     ==
  '==   bounds of the array's 1st dimension.  It's probably  ==
  '==   easiest to use the LBound and UBound functions to    ==
  '==   set these.                                           ==
  '==--------------------------------------------------------==

  Dim pivot(),loSwap,hiSwap,temp,counter
  Redim pivot (Ubound(vec,2))

  '== Two items to sort
  if hiBound - loBound = 1 then
    if vec(loBound,SortField) > vec(hiBound,SortField) then Call SwapRows(vec,hiBound,loBound)
  End If

  '== Three or more items to sort

  For counter = 0 to Ubound(vec,2)
    pivot(counter) = vec(int((loBound + hiBound) / 2),counter)
    vec(int((loBound + hiBound) / 2),counter) = vec(loBound,counter)
    vec(loBound,counter) = pivot(counter)
  Next

  loSwap = loBound + 1
  hiSwap = hiBound

  do
    '== Find the right loSwap
    while loSwap < hiSwap and vec(loSwap,SortField) <= pivot(SortField)
      loSwap = loSwap + 1
    wend
    '== Find the right hiSwap
    while vec(hiSwap,SortField) > pivot(SortField)
      hiSwap = hiSwap - 1
    wend
    '== Swap values if loSwap is less then hiSwap
    if loSwap < hiSwap then Call SwapRows(vec,loSwap,hiSwap)


  loop while loSwap < hiSwap

  For counter = 0 to Ubound(vec,2)
    vec(loBound,counter) = vec(hiSwap,counter)
    vec(hiSwap,counter) = pivot(counter)
  Next

  '== Recursively call function .. the beauty of Quicksort
    '== 2 or more items in first section
    if loBound < (hiSwap - 1) then Call QuickSort(vec,loBound,hiSwap-1,SortField)
    '== 2 or more items in second section
    if hiSwap + 1 < hibound then Call QuickSort(vec,hiSwap+1,hiBound,SortField)

End Sub  'QuickSort


    '===============================================================================
	' 만나이계산 ex) Date형 인자
	'===============================================================================
	Function korAge(ByVal birthday)
		If Month(birthday) < Month(Now()) Then
			korAge = Year(Now()) - Year(birthday)
		ElseIf Month(birthday) = Month(Now()) Then
			If Day(birthday) <= Day(Now()) Then
				korAge = Year(Now()) - Year(birthday)
			Else
				korAge = Year(Now()) - Year(birthday) - 1
			End If
		Else
			korAge = Year(Now()) - Year(birthday) - 1
		End If
	End Function

    '===============================================================================
	' 만나이계산 ex) birthday = 19950103
	' 생일 체크 , 생일이 지나지 않았으면 1살을 더 뺀다.
	'===============================================================================
	Function korAgeEx(birthday)
		Dim nYear, nMonth, nDay, nAge , bMoreMinus

		nAge = 0
		bMoreMinus = 0

		strLen = Len(birthday)
		If(strLen = 8 ) Then
			nYear = CInt(Mid(birthday, 1, 4))
			nMonth = CInt(Mid(birthday, 5, 2))
			nDay = CInt(Mid(birthday, 7, 2))

			If( nMonth > Month(Now()) ) Then
				bMoreMinus = 1
			ElseIf( nDay > Day(Now()) ) Then
				bMoreMinus = 1
			End If

			nAge = Year(Now()) - nYear + 1
			If (bMoreMinus = 1) Then
				nAge = nAge - 1
			End If
		End If

		korAgeEx = nAge
	End Function

	'===============================================================================
	' 나이구하기 ex) birthday = 19950103
	'===============================================================================
	Function GetAge(birthday)
		Dim myage

		myage = Cint(year(date)) - CInt(Left(birthday,4)) + 1
		if CDbl(mid(Replace(date,"-",""),5))  >  CDbl(Mid(Replace(birthday,"-",""), 5)) Then
			myage = myage - 1
		End if
		GetAge = myage
	End Function



'############################################################################
' 기존에 붙어있던 펑션 옴김
'############################################################################
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
		dim txtTag1

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

	'===============================================================================
	'RandNumber 랜덤문자, 숫자 추출
	'===============================================================================
	Function random_str()
		Dim str,i,r,serialCode
		str = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" '랜덤으로 사용될 문자 또는 숫자
		strlen = 6 '랜덤으로 출력될 값의 자릿수 ex)해당 구문에서 10자리의 랜덤 값 출력
		Randomize '랜덤 초기화
		For i = 1 To strlen '위에 선언된 strlen만큼 랜덤 코드 생성
			r = Int((36 - 1 + 1) * Rnd + 1)  ' 36은 str의 문자갯수
			serialCode = serialCode + Mid(str,r,1)
		Next
		random_str = serialCode
	End Function
	'===============================================================================
	'랜덤숫자
	'===============================================================================
	Function random_Disigt_str()
		Dim bufNum
		Randomize '랜덤 초기화
		'4자리
		bufNum = int(9000 * rnd) + 1000
		random_Disigt_str = bufNum
	End Function
	'===============================================================================
	'html 태그 변환
	'===============================================================================


'############################################################################
' 기존에 붙어있던 펑션 옴김
'############################################################################
%>
