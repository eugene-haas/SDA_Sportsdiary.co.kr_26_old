<% 	
	'=================================================================================
	'  Purpose  : 	utility - environment funciton 
	'  Date     : 	2019.11.27
	'  Author   : 															By Aramdry
	'================================================================================= 
%>

<% 	
   
'=================================================================================
'	현재 날짜를 기반으로 File 명 생성 
'=================================================================================    
Function utxGetFileNameWithDate(strName, nType)		
	Dim strPath, curDate, cYear, cMonth, cDay
	If(strName = "") Then strName = "Log" End If 
	If(nType = "") Then nType = "1" End If

	If(nType = "1") Then 
		curDate 	= Date()
		curDate 	= Replace(curDate, "-", "")
		strPath = utx_sprintf("{0}_{1}.txt", Array(curDate, strName))
	End If 
		
	utxGetFileNameWithDate = strPath
End Function

'=================================================================================
'	현재 날짜를 기반으로 File Path + File Name생성 
'=================================================================================    
Function utxGetFilePathWithDate(parentPath, strName)		
	Dim aryVar, strYear, strMonth, strDay
	Dim dirYear, dirMonth, strPath

	curDate 	= Date()

	aryVar = Split(curDate, "-")

	strYear 		= aryVar(0)
	strMonth 		= aryVar(1)
	strDay 			= aryVar(2)
	
	dirYear 	= utx_sprintf("{0}{1}/", Array(parentPath, strYear) )
	dirMonth 	= utx_sprintf("{0}{1}/", Array(dirYear, strMonth) )
	strPath	= utx_sprintf("{0}{1}_{2}{3}{4}.txt", Array(dirMonth, strName, strYear, strMonth, strDay) ) 
		
	utxGetFilePathWithDate = strPath
End Function

'=================================================================================
'	Directory Path, fileName를 받아서  filePath를 반환한다. 
'=================================================================================    
Function utxMergeFilePath(strDir, strFile)		
	Dim strPath, strTmp, nLen, nPos
	
	strTmp = strDir
	strTmp = Replace(strTmp, "\", "/")
	nLen = Len(strTmp)		
	nPos = InStrRev(strTmp, "/")

	strLog = utx_sprintf("utxMergeFilePath Len = {0}, pos = {1}<br>", Array(nLen, nPos))
	response.write(strLog)

	If(nLen <> nPos) Then 
		strTmp = strTmp & "/"
	End If 

	strPath = utx_sprintf("{0}{1}", Array(strTmp, strFile))	    
	utxMergeFilePath = strPath
End Function

'=================================================================================
'	Dir Path를 입력받아 마지막에 / 이 없으면 /를 경로에 붙여준다. 
'================================================================================= 
Function utxDirPathAppendSep(strPath)		
	Dim strDir, strTmp, nPos, nLen
	strTmp = Replace(strPath, "\", "/")
	nPos = InStrRev(strTmp,"/")
	nLen = Len(strPath)

	If(nPos <> nLen) Then 
		strPath = utx_sprintf("{0}/", Array(strTmp))
	End If 

	utxDirPathAppendSep = strPath
End Function

'=================================================================================
'	File Path에서 Directory Path 분리 
'  ex) D:\wroot\my1\Node_JS_Test\test.txt => D:\wroot\my1\Node_JS_Test\
'================================================================================= 
Function utxGetDirPath(strPath)		
	Dim strDir, strTmp, nPos
	strTmp = Replace(strPath, "\", "/")
	nPos = InStrRev(strTmp,"/")
	strDir = Left(strTmp, nPos)

	utxGetDirPath = strDir
End Function

'=================================================================================
'	File Path에서 File Name 분리 
'  ex) D:\wroot\my1\Node_JS_Test\test.txt => test.txt
'================================================================================= 
Function utxGetFileName(strPath)		
	Dim strName, nPos, nLen, strTmp
	strTmp = Replace(strPath, "\", "/")
	nPos = InStrRev(strTmp,"/")
	nLen = Len(strTmp)
	strName = Right(strTmp, nLen-nPos)

	strLog = utx_sprintf("nPos = {0}, nLen = {1}<br>", Array(nPos, nLen))
	response.write(strLog)

	utxGetFileName = strName
End Function

'=================================================================================
'	File Path에서 File 확장자 분리 
'  ex) D:\wroot\my1\Node_JS_Test\test.txt => txt
'================================================================================= 
Function utxGetFileExt(strPath)		
	Dim strExt, nPos, nLen, strTmp
	strTmp = Replace(strPath, "\", "/")
	nPos = InStrRev(strTmp,".")
	nLen = Len(strTmp)
	strExt = Right(strTmp, nLen-nPos)

	strLog = utx_sprintf("nPos = {0}, nLen = {1}<br>", Array(nPos, nLen))
	response.write(strLog)

	utxGetFileExt = strExt
End Function

'=================================================================================
'	Directory 존재 유무 확인 
'=================================================================================
Function utxIsExistDir(strPath)
	Dim objFSO, retVal
	Set objFSO = Server.CreateObject("Scripting.FileSystemObject") 
	retVal = objFSO.FolderExists(strPath)

	Set objFSO = Nothing 

	utxIsExistDir = retVal
End Function 

'=================================================================================
'	Directory 생성
'=================================================================================  
Function utxCreateDir(strPath)
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

'=================================================================================
'	File 존재 유무 확인
'=================================================================================  
Function utxIsExistFile(strPath)
	Dim objFSO, retVal
	Set objFSO = Server.CreateObject("Scripting.FileSystemObject") 
	retVal = objFSO.FileExists(strPath)

	Set objFSO = Nothing 

	utxIsExistFile = retVal
End Function 


'=================================================================================
'	parentPath경로에 현재 Date에 기반한 Year, Month Dir가 없으면 새로 만든다. 
'================================================================================= 
Function utxCheckDirByDate(parentPath)		
	Dim aryVar, strYear, strMonth, dirYear, dirMonth

	curDate 	= Date()

	aryVar 		= Split(curDate, "-")
	strYear 	= aryVar(0)
	strMonth 	= aryVar(1)		

	dirYear 	= utx_sprintf("{0}{1}\", Array(parentPath, strYear) )
	dirMonth 	= utx_sprintf("{0}{1}\", Array(dirYear, strMonth) )

	If(utxIsExistDir(dirYear) = False) Then 
		Call utxCreateDir(dirYear)
	End If 

	If(utxIsExistDir(dirMonth) = False) Then 
		Call utxCreateDir(dirMonth)
	End If 

	utxCheckDirByDate = dirMonth
End Function


	'   ===============================================================================     
	'     http agent info를 가지고 browser info를 얻는다. 
	'   ===============================================================================
	Function utxGetAgentBrowser(strUserAgent)
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

		utxGetAgentBrowser = strAgentBrowser
	End Function 

	'   ===============================================================================     
	'     http agent info를 가지고 OS info를 얻는다. 
	'   ===============================================================================
	Function utxGetAgentDevice(strUserAgent)
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

		utxGetAgentDevice = strAgentDevice
	End Function 

	Function utxPrintReqServer()
		Dim strLog, key 
		For Each key in Request.ServerVariables
			strLog = utx_sprintf("{0}-{1}<br>", Array(key, Request.ServerVariables(key)))
			Call utxWebLog(strLog)
		Next 
	End Function 
   
%>