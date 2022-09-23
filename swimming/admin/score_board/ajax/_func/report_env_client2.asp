
<%
	'=================================================================================
	'  Purpose  : 	Web page Request한 Client Infomation을 system Log로 남긴다.
	'  Date     : 	2019.11.27
	'  Author   : 															By Aramdry
	'=================================================================================
%>

<%
	Dim SysChkStartTime, SysChkEndTime
	SysChkStartTime = Timer()
%>

<%
	' http://ictest.sportsdiary.co.kr/api\_func\env_client.asp


	'=================================================================================
	'  Sub Function
	'=================================================================================
	Function sys_sprintf(sVal, aArgs)
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
		sys_sprintf = sVal
	End Function

'   ===============================================================================     
'      Json Object을 입력받아 그 값의 길이가 nLimit보다 작은 값만 Json Text로 변환한다.  ( 1차원 배열만 지원 )
'   ===============================================================================
	Function sys_JSonStringifyByLimit(jObj, nLimit)
		dim key, n , nLen, val , strJson
		n = 0
		
		for each key in jObj.keys()
			val = jObj.get(key)
			nLen = Len(val)
			If(nLen < nLimit) Then 
				If(n = 0) Then 
					strJson = sys_sprintf(" ""{0}"":""{1}"" ", Array(key, val))
				Else 
					strJson = sys_sprintf("{0}, ""{1}"":""{2}"" ", Array(strJson, key, val))
				End If 
				n = n + 1
			End If 
		next

		strJson = sys_sprintf(" { {0} } ", Array(strJson))
		sys_JSonStringifyByLimit = strJson
	End Function 

	'=================================================================================
	'	Debug: (UTF-8 - ADODB.Stream) - 현재 날짜/시간 + 로그 데이터 출력
	'   LOGFILE_PATH에 있는 log.txt에 로그 데이터를 찍는다.
	'   원격 파일 엑세스 에러 - 서버 셋팅에 의해 asp파일에서 ADODB.Stream를 못 만든다.
	'   주의 : 1. 로그 파일은 1명당 하나씩 할당해서 쓴다.
	'          2. 로그 파일은 개발이 끝난 다음에는 주석으로 처리한다. - 파일을 열고 쓰는 부하가 생각보다 클수 있다.
	'=================================================================================
	Function envLog(strLog)
		Dim objStream, strTmp, strTime
		Dim DIR_SYSINFO, strPath, physicalPath, strFileName

	'	physicalPath 				= Request.ServerVariables("APPL_PHYSICAL_PATH")
	'	DIR_SYSINFO					= sys_sprintf("{0}syslog/sysInfo/", Array(physicalPath) )
		DIR_SYSINFO					= "C:/WEBLOGFILE/icheon/syslog/sysInfo/"
		Call sys_CheckDirByDate(DIR_SYSINFO)
		strPath = sys_GetFilePathWithDate(DIR_SYSINFO, "SysLog")

		'Call utxWebLog(strPath)
		'Call utxWebLog(strLog)

		Set objStream = Server.CreateObject("ADODB.Stream")
		objStream.Mode = 3
		objStream.Type = 2 ' 텍스트 타입 (1: Bin, 2: Text)
		objStream.CharSet = "UTF-8"
		objStream.Open

		' trick , move to file end position to append file
		on error resume next
		objStream.LoadFromFile (strPath)
		objStream.ReadText(-1)

		' write log - append
		strTime = sys_GetSysTime()
		strTmp = sys_sprintf("{0} >> {1}", Array(strTime, strLog) )
		objStream.WriteText strTmp, 1
		objStream.SaveToFile strPath, 2
		objStream.Flush
		objStream.Close
		Set objStream = Nothing
    On Error GoTo 0
	End Function

	Function sys_GetSysTime()
		Dim strTime, curTime
		curTime = Time() 

		strTime = sys_sprintf("{0} {1}:{2}:{3}", Array(Date(), Hour(curTime), Minute(curTime), Second(curTime) ) )
		sys_GetSysTime = strTime 
	End Function

	'   ===============================================================================
	'     http agent info를 가지고 browser info를 얻는다.
	'   ===============================================================================
	Function sys_GetAgentBrowser(strUserAgent)
		Dim strAgentBrowser
		If InStr(strUserAgent,"Edge") > 0 then
		strAgentBrowser = "Edge"
		elseIf InStr(strUserAgent,"rv:11.0") > 0 then
		strAgentBrowser = "IE11"
		elseIf InStr(strUserAgent,"MSIE 10") > 0 then
		strAgentBrowser = "IE10"
		elseIf InStr(strUserAgent,"MSIE 9") > 0 then
		strAgentBrowser = "IE9"
		elseIf InStr(strUserAgent,"MSIE 8") > 0 then
		strAgentBrowser = "IE8"
		elseIf InStr(strUserAgent,"MSIE 7") > 0 then
		strAgentBrowser = "IE7"
		elseIf InStr(strUserAgent,"MSIE 6") > 0 then
		strAgentBrowser = "IE6"
		elseIf InStr(strUserAgent,"Opera") > 0 or InStr(strUserAgent,"OPERA") > 0 or InStr(strUserAgent,"OPR") > 0 then
		strAgentBrowser = "Opera"
		elseIf InStr(strUserAgent,"Firefox") > 0 or InStr(strUserAgent,"FIREFOX") > 0 then
		strAgentBrowser = "Firefox"
		elseIf InStr(strUserAgent,"KAKAOTALK") > 0 then
		strAgentBrowser = "KakaoTalk"
		elseIf InStr(strUserAgent,"NAVER") > 0 then
		strAgentBrowser = "Naver"
		elseIf InStr(strUserAgent,"FBAN") > 0 or InStr(strUserAgent,"FBAV") > 0 or InStr(strUserAgent,"FBBV") > 0 or InStr(strUserAgent,"FBRV") > 0 or InStr(strUserAgent,"FBDV") > 0 or InStr(strUserAgent,"FBMD") > 0 or InStr(strUserAgent,"FBSN") > 0 or InStr(strUserAgent,"FBSV") > 0 or InStr(strUserAgent,"FBSS") > 0 or InStr(strUserAgent,"FBCR") > 0 or InStr(strUserAgent,"FBID") > 0 or InStr(strUserAgent,"FBLC") > 0 or InStr(strUserAgent,"FBOP") > 0 then
		strAgentBrowser = "Facebook"
		elseIf InStr(strUserAgent,"Chrome") > 0 or InStr(strUserAgent,"CriOS") > 0 then
		strAgentBrowser = "Chrome"
		elseIf InStr(strUserAgent,"Android") > 0 or InStr(strUserAgent,"ANDROID") > 0 then
		strAgentBrowser = "Android"
		elseIf InStr(strUserAgent,"Safari") > 0 or InStr(strUserAgent,"SAFARI") > 0 then
		strAgentBrowser = "Safari"
		else
		strAgentBrowser = "Browser ETC"
		end if

		sys_GetAgentBrowser = strAgentBrowser
	End Function

	'   ===============================================================================
	'     http agent info를 가지고 OS info를 얻는다.
	'   ===============================================================================
	Function sys_GetAgentDevice(strUserAgent)
		Dim strAgentDevice

		If InStr(strUserAgent,"Android") > 0 then
			strAgentDevice = "Android"
		elseIf InStr(strUserAgent,"iPhone") > 0 then
			strAgentDevice = "iPhone"
		elseIf InStr(strUserAgent,"iPad") > 0 then
			strAgentDevice = "iPad"
		elseIf InStr(strUserAgent,"iPod") > 0 then
			strAgentDevice = "iPod"
		elseIf InStr(strUserAgent,"Macintosh") > 0 then
			strAgentDevice = "Macintosh"
		elseIf InStr(strUserAgent,"SymbianOS") > 0 then
			strAgentDevice = "SymbianOS"
		elseIf InStr(strUserAgent,"BlackBerry") > 0 then
			strAgentDevice = "BlackBerry"
		elseIf InStr(strUserAgent,"BB10") > 0 then
			strAgentDevice = "BB10"
		elseIf InStr(strUserAgent,"Nokia") > 0 then
			strAgentDevice = "Nokia"
		elseIf InStr(strUserAgent,"SonyEricsson") > 0 then
			strAgentDevice = "SonyEricsson"
		elseIf InStr(strUserAgent,"webOS") > 0 then
			strAgentDevice = "webOS"
		elseIf InStr(strUserAgent,"PalmOS") > 0 then
			strAgentDevice = "PalmOS"
		elseIf InStr(strUserAgent,"LINUX") > 0 or InStr(strUserAgent,"Linux") > 0 then
			strAgentDevice = "Linux"
		elseIf InStr(strUserAgent,"Windows") > 0 then
			strAgentDevice = "Windows"
		else
			strAgentDevice = "Device ETC"
		end if

		sys_GetAgentDevice = strAgentDevice
	End Function

	'=================================================================================
'	현재 날짜를 기반으로 File Path + File Name생성
'=================================================================================
Function sys_GetFilePathWithDate(parentPath, strName)
	Dim aryVar, strYear, strMonth, strDay
	Dim dirYear, dirMonth, strPath

	curDate 	= Date()

	aryVar = Split(curDate, "-")

	strYear 		= aryVar(0)
	strMonth 		= aryVar(1)
	strDay 			= aryVar(2)

	dirYear 	= sys_sprintf("{0}{1}/", Array(parentPath, strYear) )
	dirMonth 	= sys_sprintf("{0}{1}/", Array(dirYear, strMonth) )
	'strPath	= sys_sprintf("{0}{1}_{2}{3}{4}.txt", Array(dirMonth, strName, strYear, strMonth, strDay) )
	strPath	= sys_sprintf("{0}{1}_{2}{3}{4}.log", Array(dirMonth, strName, strYear, strMonth, strDay) )

	sys_GetFilePathWithDate = strPath
End Function

'=================================================================================
'	parentPath경로에 현재 Date에 기반한 Year, Month Dir가 없으면 새로 만든다.
'=================================================================================
Function sys_CheckDirByDate(parentPath)
	Dim aryVar, strYear, strMonth, dirYear, dirMonth

	curDate 	= Date()

	aryVar 		= Split(curDate, "-")
	strYear 	= aryVar(0)
	strMonth 	= aryVar(1)

	dirYear 	= sys_sprintf("{0}{1}/", Array(parentPath, strYear) )
	dirMonth 	= sys_sprintf("{0}{1}/", Array(dirYear, strMonth) )

	If(sys_IsExistDir(dirYear) = False) Then
		Call sys_CreateDir(dirYear)
	End If

	If(sys_IsExistDir(dirMonth) = False) Then
		Call sys_CreateDir(dirMonth)
	End If
End Function

'=================================================================================
'	Directory 존재 유무 확인
'=================================================================================
Function sys_IsExistDir(strPath)
	Dim objFSO, retVal
	Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
	retVal = objFSO.FolderExists(strPath)

	Set objFSO = Nothing

	sys_IsExistDir = retVal
End Function

'=================================================================================
'	Directory 생성
'=================================================================================
Function sys_CreateDir(strPath)
	Dim objFSO, dirExist, nPos, strDir
	dirExist = True
	nPos = InStrRev(strPath, ".")

	strDir = strPath
	' file path면 dir 경로를 구해서 Directory를 만든다.
	If( nPos <> 0 ) Then
		strDir = utxGetDirPath(strDir)
	End If

	Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
	dirExist = objFSO.FolderExists(strDir)

	If(dirExist = False) Then
		objFSO.CreateFolder(strDir)
	End If
	Set objFSO = Nothing
End Function


%>

<%
	'=================================================================================
	'  현재 호출된 WebPage 주소, Request Param, client ip, user Agent
	'  Json Data 형식만 받는다. 
	'=================================================================================
	Function TraceSysInfo(strReq, req)
		'On Error GoTo ErrorHandler   ' Enable error-handling routine.

		Dim curUrl, reqParam, clientIP, userInfo, strLog
		Dim browser, os, req_type, reqSize, nMaxData, nMaxLog		

		strLog = strReq

		nMaxLog		= 1024 * 5
		nMaxData 	= 1024

		reqSize = Len(strLog)

		if(reqSize > nMaxLog) Then 
			Dim jsonObj2
			Set jsonObj2 = JSON.Parse(strLog)
			'On Error GoTo 0   ' Turn off error trapping.

			strLog = sys_JSonStringifyByLimit(jsonObj2, nMaxData)			
			Set jsonObj2 = Nothing
		End If 

		req_type = ""
		If(strLog <> "{}") Then
			If(reqSize < 1) Then
				req_type = "Get"
			else
				req_type = "Post"
			End If
		End If

		curUrl 		= Request.ServerVariables("PATH_INFO")
		clientIP 	= Request.ServerVariables("REMOTE_ADDR")
		userInfo	= Request.ServerVariables("HTTP_USER_AGENT")
		browser 	= sys_GetAgentBrowser(userInfo)
		os 				= sys_GetAgentDevice(userInfo)

		strLog = sys_sprintf("{0} {1} {2} {3} {4} {5}", Array(curUrl, req_type, strLog, os, browser, clientIP ))
		Call envLog(strLog)

		

		'Exit Function      ' Exit to avoid handler.
		'ErrorHandler:  ' Error-handling routine.	
		'Resume Next  	' Resume execution at the statement immediately 
                	' following the statement where the error occurred.
	End Function

	Function CheckProcessTime()	
		Dim ProcessTime

		SysChkEndTime = Timer()		
		ProcessTime = SysChkEndTime - SysChkStartTime

		strLog = utx_sprintf("--------------------- 실행시간 : {0}, start = {1}, end = {2} ", Array(ProcessTime, SysChkStartTime, SysChkEndTime))
		Call envLog(strLog)
	 End Function 

'	Function TraceSysInfo(strReq, req)
'		Dim curUrl, reqParam, clientIP, userInfo, strLog
'		Dim browser, os, req_type, reqSize
'
'		reqSize = req.TotalBytes
'
'		req_type = ""
'		If(strReq <> "{}") Then
'			If(reqSize < 1) Then
'				req_type = "Get방식"
'			else
'				req_type = "Post방식"
'			End If
'		End If
'
'
'		curUrl 		= Request.ServerVariables("PATH_INFO")
'		clientIP 	= Request.ServerVariables("REMOTE_ADDR")
'		userInfo	= Request.ServerVariables("HTTP_USER_AGENT")
'		browser 	= sys_GetAgentBrowser(userInfo)
'		os 				= sys_GetAgentDevice(userInfo)
'
'
''		strLog = "--------------------------------------------------------------Web Info"
''		Call envLog(strLog)
''
''		strLog = sys_sprintf("curUrl = {0}", Array(curUrl))
''		Call envLog(strLog)
''
''		strLog = sys_sprintf("clientIP = {0}, browser = {1}, os = {2}", Array(clientIP, browser, os))
''		Call envLog(strLog)
''
''		If(reqSize < 1000) Then
''			strLog = sys_sprintf("req_type = {0}, reqSize = {1}, strReq >> {2}", Array(req_type, reqSize, strReq))
''		Else
''			strLog = sys_sprintf("reqSize = {0}", Array(reqSize))
''		End If
''		Call envLog(strLog)
''
''		strLog = sys_sprintf("userInfo = {0}", Array(userInfo))
''		Call envLog(strLog)
'
'		If(reqSize < 1000) Then
'			strLog = sys_sprintf("----- ({0}) , ({1} >> {2}) , ({3} , {4} , {5})", Array(curUrl, req_type, strReq, os, browser, clientIP ))
'		Else
'			strLog = sys_sprintf("----- ({0}) , ({1} >> { size 1000 over }) , ({2} , {3} , {4})", Array(curUrl, req_type, os, browser, clientIP ))
'		End If
'		Call envLog(strLog)
'	End Function

%>
