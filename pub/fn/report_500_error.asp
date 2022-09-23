<%
	'=================================================================================
	'  Purpose  : 	500 error 발생시 error 객체 정보 
	'  Date     : 	2021.02.19
	'  Author   : 															By Aramdry
	'=================================================================================
%>



<%
	Dim SysChkStartTime, SysChkEndTime
	SysChkStartTime = Timer()
%>

<%
	' http://ictest.sportsdiary.co.kr/api/_func/report_500_error.asp


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
	Dim dirYear, dirMonth, strPath, curDate

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
	Dim aryVar, strYear, strMonth, dirYear, dirMonth, curDate

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
	'  500 error 발생시 error 객체 정보 
	'=================================================================================
   Function TraceErrorInfo(req, err_obj, site_code)
		Dim category, err_no, desc , err_fileInfo, strLog, USER_IP, path_info, host_path
      Dim curUrl, reqParam, clientIP, userInfo
		Dim browser, os, req_type, reqSize, nMaxData, nMaxLog, user_id,referer
      
      ' --------------------------------------------------------------------------
      ' Request Info 
		user_id = Session("userid")

		host_path 		= Request.ServerVariables("HTTP_HOST")
      path_info      = Request.ServerVariables("PATH_INFO")
      curUrl 		   = sys_sprintf("{0}{1}", Array(host_path, path_info))
		clientIP 	   = Request.ServerVariables("REMOTE_ADDR")
		userInfo	      = Request.ServerVariables("HTTP_USER_AGENT")
		browser 	      = sys_GetAgentBrowser(userInfo)
		os 				= sys_GetAgentDevice(userInfo)
		referer = Request.ServerVariables ("HTTP_REFERER")

      strLog = sys_sprintf("{0} {1} {2} {3} {4} {5} {6}", Array(user_id, curUrl, req_type, os, browser, clientIP, referer ))

      ' --------------------------------------------------------------------------
      ' err_obj Info 
      category =  err_obj.Category
      If err_obj.ASPCode > "" Then 
         err_no = sys_sprintf("{0}, {1}", Array(Server.HTMLEncode(", " & err_obj.ASPCode), Server.HTMLEncode(" (0x" & Hex(err_obj.Number) & ")" )))         
      End If 
      If err_obj.ASPDescription > "" Then          
         desc =  err_obj.ASPDescription
      elseIf (err_obj.Description > "") Then          
         desc =  err_obj.Description
      end if
      desc = Replace(desc, "'", " - ") 

      blnErrorWritten = False
      ' Only show the Source if it is available and the request is from the same machine as IIS
      If err_obj.Source > "" Then
         strServername = LCase(Request.ServerVariables("SERVER_NAME"))
         strServerIP = Request.ServerVariables("LOCAL_ADDR")
         strRemoteIP =  Request.ServerVariables("REMOTE_ADDR")
         If (strServerIP = strRemoteIP) And err_obj.File <> "?" Then
            err_fileInfo = sys_sprintf("file: {0}, line: {1}, col: {2}", Array(Server.HTMLEncode(err_obj.File), err_obj.Line, err_obj.Column))                     
            blnErrorWritten = True
         End If
      End If
      If Not blnErrorWritten And err_obj.File <> "?" Then         
         err_fileInfo = sys_sprintf("file: {0}, line: {1}, col: {2}", Array(Server.HTMLEncode(err_obj.File), err_obj.Line, err_obj.Column))                     
      End If

      USER_IP = Request.ServerVariables("HTTP_X_FORWARDED_FOR")
      If Len(USER_IP) = 0 Then USER_IP = Request.ServerVariables("REMOTE_ADDR")

      strLog = sys_sprintf("category: {0}, desc : {1}", Array(category, desc, USER_IP))
      strLog = sys_sprintf("err_fileInfo: {0}", Array(err_fileInfo))

      ' --------------------------------------------------------------------------
      ' DB Log 
  	  Set db = new clsDBHelper 
         Dim strSql
            strSql = strSql & " Insert Into TB_LOG (DB_TYPE ,USER_ID, USER_IP, USER_OS, BROWSER ,ERR_URL ,ERR_CONTENT ,ERR_FILE ,ERR_LINE ,REFFER) "
	        strSql = strSql & sys_sprintf("    Values ( '{0}', '{1}', '{2}', '{3}', '{4}', '{5}', '{6}', '{7}','{8}','{9}') ", Array(site_code,user_id, clientIP, os, browser, curUrl, desc, err_obj.File, err_obj.Line, referer))
			Call db.execSQLRs(strSql , null, ConStr)
		db.Dispose
		Set db = Nothing
	End Function

	Function CheckProcessTime()	
		Dim ProcessTime

		SysChkEndTime = Timer()		
		ProcessTime = SysChkEndTime - SysChkStartTime

		strLog = utx_sprintf("--------------------- 실행시간 : {0}, start = {1}, end = {2} ", Array(ProcessTime, SysChkStartTime, SysChkEndTime))
	 End Function 

%>
