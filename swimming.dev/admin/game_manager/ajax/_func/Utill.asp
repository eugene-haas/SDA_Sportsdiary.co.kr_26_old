<%
'모든페이지에서 쓸 공동 변수
Dim userid, association_code, groupcode, access, spcode

Function AlertMsgLocation(msg, uriString)   '#### alert찍고 location 을 변경
  Response.Write "<Script type=""text/javascript"">"
  IF Trim(msg) <> "" or isnull(msg) Then Response.Write "alert("""& msg &""");"
  IF Trim(uriString) <> "" or isnull(uriString) Then Response.Write "location.href="""& uriString &""";"
  Response.Write "</Script>"
End Function

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

Function RequestJsonObject(req)   '#### request 를 검사하고 jsonString 을 반환한다.
  If Not req.TotalBytes > 0 Then
    RequestJsonObject = "{}"
    Exit Function
  End If
  RequestJsonObject = BytesToStr(req.BinaryRead(req.TotalBytes))
End Function

Function ArrayToSession(params)   '#### session 을 저장
  If isArray(params) = False Then Exit Function
  Session.Timeout = 30
  For i = 0 To UBound(params,1)
    Session(""& params(i,0) &"") = Cstr(params(i,1))
  Next
End Function

Function SessionToArray()   '#### session 을 가져온다
  If Session.Contents.Count > 0 Then
    Dim sessionArray : Redim sessionArray(Session.Contents.Count-1,1)
    i = 0
    For Each names in Session.Contents
      sessionArray(i,0) = names
      sessionArray(i,1) = Session(""& names &"")
      i = i + 1
    Next
    SessionToArray = sessionArray
  Else
    SessionToArray = Null
  End If
End Function

Function SessionAbadon()    '#### 사용중인 세션 전부를 즉시 만료 시킨다. ※이 함수는 쓰이는 즉시 모든 세션이 만료되고 현페이지 어디서든 세션을 사용할 수 없습니다.
  Session.Abandon
End Function

Function SessionRemove(item)    '#### item 으로 특정 세션만 삭제 한다.
  If isNull(Session(""& item &"")) = false then
    Session.Contents.Remove(""& item &"")
  End If
End Function

Function SessionRemoveAll()   '#### 모든 세션을 삭제 한다.
  Session.Contents.RemoveAll()
End Function

Function SessionChk()   '#### 세션이 있는지 체크하고 있으면 만료시간을 늘린다.
  If Session.Contents.Count > 0 Then
    Session.Timeout = 30
    SessionChk = True
  Else
    SessionChk = False
  End If
End Function

Function FileDownloadTabsUpload(FilePath,FileName,DownloadName)    '#### 파일 다운로드. TABSUpload4 모듈이 설치되어 있을 경우만 다운로드 된다.
  DefaultPath = FilePath & FileName
  If InStr(Request.ServerVariables("HTTP_USER_AGENT"), "Chrome") > 0 or InStr(Request.ServerVariables("HTTP_USER_AGENT"), "Firefox") > 0 or InStr(strUserAgent,"Safari") > 0 or InStr(strUserAgent,"SAFARI") > 0 Then
  Else
    Response.AddHeader "Content-Disposition","attachment; filename=""" & Server.URLPathEncode(DownloadName) & """"
  End If
  SET objDownload = Server.CreateObject("TABSUpload4.Download")
  objDownload.FilePath = Server.MapPath(DefaultPath)
  objDownload.FileName = DownloadName
  objDownload.TransferFile True, True
  SET objDownload = Nothing
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

Function RequestJsonObject2(req)   ' #### request 를 검사하고 jsonString 을 반환한다.
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
	RequestJsonObject2 = strReq
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

Function FirstPlusText(limit,plus,text) ' #### 앞에 문자붙이기'
  returnText = text
  If limit > Len(text) Then
    For returni = 1 To limit-Len(text)
      returnText = plus & returnText
    Next
  End If
  FirstPlusText = returnText
End Function

Function WordCheck(str,patrn) ' #### 정규식
	Dim regEx, match, matches
	SET regEx = New RegExp
	regEx.Pattern = patrn
	regEx.IgnoreCase = False
	regEx.Global = True
	Matches = regEx.Test(str)
	WordCheck = Matches
End Function

Sub IsLoginSessionCheck() ' #### 세션체크
  If Session.Contents.Count > 0 Then
    Session.Timeout = 30
    userid = Session("userid")
    association_code = Session("association_code")
    groupcode = Session("groupcode")
    access = Session("access")
    spcode = Session("sports_code")
  Else
    userid = ""
    association_code = ""
    groupcode = ""
    access = ""
    spcode = ""
    Response.Clear
    Response.Write "{""state"":""false"", ""errorcode"":""ERR-100""}"
    Response.End
  End If
End Sub

Function SendEmail(email,title,contents)  '#### 이메일 전송
  Set Smtp = Server.CreateObject("TABSUpload4.Smtp")

  Smtp.ServerName = "49.247.7.60"
  Smtp.ServerPort = 6700
  Smtp.AddHeader "X-TABS-Campaign", "63E3F849-267F-4B6B-BC6E-496295D789B3"
  Smtp.FromAddress = "online@widline.co.kr"
  Smtp.AddToAddr email, ""
  Smtp.Subject = title
  Smtp.Encoding = "base64"
  Smtp.Charset = "euc-kr"
  Smtp.BodyHtml = contents

  Set Result = Smtp.Send()
End Function

%>
