
<%
	'=================================================================================
	'  Purpose  : 	Trace Log
	'  Date     : 	2019.11.27
	'  Author   : 															By Aramdry
	'=================================================================================
%>

<%
	' Log File Path - 
	LOGFILE_PATH = "D:/log_dev/log/app/judo_log/log"

	' SysLog File Path - sad mall Log
	SYS_LOGFILE_PATH = "/syslog/"


	' Log File Type - Badminton Log
	Const DEV_LOG_BASE 	= 10
	Const DEV_LOG1 			= 11               ' log1.txt    -	Aramdry
	Const DEV_LOG2 			= 12               ' log2.txt
	Const DEV_LOG3 			= 13               ' log3.txt
	Const DEV_LOG4 			= 14               ' log4.txt
	Const DEV_LOG5 			= 15               ' log5.txt
	Const DEV_LOG6 			= 16               ' log6.txt
	Const DEV_LOG7 			= 17               ' log7.txt
	Const DEV_LOG8 			= 18               ' log8.txt
	Const DEV_LOG9 			= 19               ' log9.txt
	Const DEV_LOG10			= 20              ' log10.txt
	Const DEV_LOGMAX 		= 21

	' Log File Type - System Log
	Const SYS_BASE 			= 100
	Const SYS_LOG1 			= 101                  ' log1.txt     -  Aramdry
	Const SYS_LOG2 			= 102                  ' log2.txt
	Const SYS_LOG3 			= 103                  ' log3.txt
	Const SYS_LOG4 			= 104                  ' log4.txt
	Const SYS_LOG5 			= 105                  ' log5.txt
	Const SYS_LOG6 			= 106                  ' log6.txt
	Const SYS_LOG7 			= 107                  ' log7.txt
	Const SYS_LOG8 			= 108                  ' log8.txt
	Const SYS_LOG9 			= 109                  ' log9.txt
	Const SYS_LOG10 		= 110                  ' log10.txt
	Const SYS_LOG_MAX 	= 111
%>

<%
  '=================================================================================
	'	log file전용 sprintf function
	'=================================================================================
	Function log_sprintf(sVal, aArgs)
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
      log_sprintf = sVal
  End Function

	'=================================================================================
	'	현재 날짜를 기반으로 File Path + File Name생성
	'=================================================================================
	Function log_GetFilePathWithDate(parentPath, strName)
		Dim aryVar, strYear, strMonth, strDay
		Dim dirYear, dirMonth, strPath

		curDate 	= Date()

		aryVar = Split(curDate, "-")

		strYear 		= aryVar(0)
		strMonth 		= aryVar(1)
		strDay 			= aryVar(2)

		dirYear 	= log_sprintf("{0}{1}/", Array(parentPath, strYear) )
		dirMonth 	= log_sprintf("{0}{1}/", Array(dirYear, strMonth) )
		strPath	= log_sprintf("{0}{1}_{2}{3}{4}.txt", Array(dirMonth, strName, strYear, strMonth, strDay) )

		log_GetFilePathWithDate = strPath
	End Function

	'=================================================================================
	'	parentPath경로에 현재 Date에 기반한 Year, Month Dir가 없으면 새로 만든다.
	'=================================================================================
	Function log_CheckDirByDate(parentPath)
		Dim aryVar, strYear, strMonth, dirYear, dirMonth

		curDate 	= Date()

		aryVar 		= Split(curDate, "-")
		strYear 	= aryVar(0)
		strMonth 	= aryVar(1)

		dirYear 	= log_sprintf("{0}{1}/", Array(parentPath, strYear) )
		dirMonth 	= log_sprintf("{0}{1}/", Array(dirYear, strMonth) )

		If(log_IsExistDir(dirYear) = False) Then
			Call log_CreateDir(dirYear)
		End If

		If(log_IsExistDir(dirMonth) = False) Then
			Call log_CreateDir(dirMonth)
		End If
	End Function

	'=================================================================================
	'	Directory 존재 유무 확인
	'=================================================================================
	Function log_IsExistDir(strPath)
		Dim objFSO, retVal
		Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
		retVal = objFSO.FolderExists(strPath)

		Set objFSO = Nothing

		log_IsExistDir = retVal
	End Function

	'=================================================================================
	'	Directory 생성
	'=================================================================================
	Function log_CreateDir(strPath)
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
	'	Dir Path를 입력받아 마지막에 / 이 없으면 /를 경로에 붙여준다.
	'=================================================================================
	Function log_DirPathAppendSep(strPath)
		Dim strDir, strTmp, nPos, nLen
		strTmp = Replace(strPath, "\", "/")
		nPos = InStrRev(strTmp,"/")
		nLen = Len(strPath)

		If(nPos <> nLen) Then
			strPath = log_sprintf("{0}/", Array(strTmp))
		End If

		log_DirPathAppendSep = strPath
	End Function

		Function log_GetSysTime()
		Dim strTime, curTime
		curTime = Time()

		strTime = log_sprintf("{0} {1}:{2}:{3}", Array(Date(), Hour(curTime), Minute(curTime), Second(curTime) ) )
		log_GetSysTime = strTime
	End Function


	'=================================================================================
	'	log file 전체 경로및 파일 경로 얻어오는 함수
	'=================================================================================
	Function GetLogPath(logType)
		Dim strPath, fileNum, dirPath

		if( logType < DEV_LOGMAX ) Then
			fileNum = logType	- DEV_LOG_BASE
			strPath = LOGFILE_PATH & fileNum & ".txt"		
    elseif( logType < SYS_LOG_MAX ) Then
			fileNum = logType-SYS_BASE

			dirPath = log_sprintf("{0}syslog{1}", Array(SYS_LOGFILE_PATH, fileNum))
			'response.write("GetLogPath - dirPath " & dirPath & "<br>")

			dirPath = log_DirPathAppendSep(Server.MapPath(dirPath))
			'response.write("GetLogPath - dirPath2 " & dirPath & "<br>")

			' Check Date 기반 년/월 Dir - 없으면 만든다.
			Call log_CheckDirByDate(dirPath)
			strPath = log_GetFilePathWithDate(dirPath, "SysLog")
		End If

		GetLogPath = strPath
	End Function

   '=================================================================================
	'	현재 날짜를 기반으로 LogFile 명 생성
	'=================================================================================
	Function GetLogFileName(strName, nType)
		Dim strPath, curDate, cYear, cMonth, cDay
		If(strName = "") Then strName = "SysLog" End If
		If(nType = "") Then nType = "1" End If

		If(nType = "1") Then
			curDate 	= Date()
			curDate 	= Replace(curDate, "-", "")
			strPath = log_sprintf("{0}_{1}.txt", Array(curDate, strName))
		End If

		GetLogFileName = strPath
	End Function

	'=================================================================================
	'	Debug: (UTF-8 - ADODB.Stream)
	'   LOGFILE_PATH에 있는 log.txt에 로그 데이터를 찍는다.
    '   원격 파일 엑세스 에러 - 서버 셋팅에 의해 asp파일에서 ADODB.Stream를 못 만든다.
    '   주의 : 1. 로그 파일은 1명당 하나씩 할당해서 쓴다.
    '          2. 로그 파일은 개발이 끝난 다음에는 주석으로 처리한다. - 파일을 열고 쓰는 부하가 생각보다 클수 있다.
	'=================================================================================
  Function utxLog(logType, strLog)
		' 내부 개발용 일때만 로그를 찍는다. 
		If( Request.ServerVariables("REMOTE_ADDR") <> "112.187.195.132" ) Then 
			Exit Function 
		End If 
		
		Dim objStream
		strPath = GetLogPath(logType)

      'response.write("writeLog " & logType & ", " & strPath & ", " & strLog)
		If strPath = "" Then Exit Function

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
		objStream.WriteText strLog, 1
		objStream.SaveToFile strPath, 2
		objStream.Flush
		objStream.Close
		Set objStream = Nothing
    On Error GoTo 0
	end Function

	'=================================================================================
	'	Debug: (UTF-8 - ADODB.Stream) - 현재 날짜/시간 + 로그 데이터 출력
	'   LOGFILE_PATH에 있는 log.txt에 로그 데이터를 찍는다.
    '   원격 파일 엑세스 에러 - 서버 셋팅에 의해 asp파일에서 ADODB.Stream를 못 만든다.
    '   주의 : 1. 로그 파일은 1명당 하나씩 할당해서 쓴다.
    '          2. 로그 파일은 개발이 끝난 다음에는 주석으로 처리한다. - 파일을 열고 쓰는 부하가 생각보다 클수 있다.
	'=================================================================================
  Function utxLogDate(logType, strLog)
		Dim objStream, strTmp, strTime
		strPath = GetLogPath(logType)

    'response.write("writeLog " & logType & ", " & strPath & ", " & strLog)

		If strPath = "" Then Exit Function

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
		strTime = log_GetSysTime()
		strTmp = log_sprintf("{0} >> {1}", Array(strTime, strLog) )

		objStream.WriteText strTmp, 1
		objStream.SaveToFile strPath, 2
		objStream.Flush
		objStream.Close
		Set objStream = Nothing
    On Error GoTo 0
	end Function

	'=================================================================================
	' System Log 출력
	'	Debug: (UTF-8 - ADODB.Stream) - 현재 날짜/시간 + 로그 데이터 출력
	'   LOGFILE_PATH에 있는 log.txt에 로그 데이터를 찍는다.
    '   원격 파일 엑세스 에러 - 서버 셋팅에 의해 asp파일에서 ADODB.Stream를 못 만든다.
    '   주의 : 1. 로그 파일은 1명당 하나씩 할당해서 쓴다.
    '          2. 로그 파일은 개발이 끝난 다음에는 주석으로 처리한다. - 파일을 열고 쓰는 부하가 생각보다 클수 있다.
	'=================================================================================
	Function utxSysLog(logType, strLog)
		' Call utxLogDate(logType, strLog)
	End Function

	'=================================================================================
	'	Debug: 웹페이지에 log를 찍는다.
	'=================================================================================
	Function utxWebLog(strLog)
		strWebLog = log_sprintf("{0}<br>", Array(strLog))
		Response.write  strWebLog
	End Function


'   ===============================================================================
'     print - 2차원 배열을 print하는 범용 함수  - Log File Display
'   ===============================================================================
	Function utxLog2Dim(logType, rAryInfo, strTitle)
		Dim Idx, aj , ul, ul2, strInfo

		If(IsArray(rAryInfo)) Then
			ul = UBound(rAryInfo,2)
			ul2 = UBound(rAryInfo,1)

			If(strTitle = "") Then strTitle = "printInfo" End If
			strLog = log_sprintf(" ------------------------- {0} ------------------------- ", Array(strTitle))
			Call utxLog(logType, strLog)

			strInfo = ""

			For Idx = 0 To ul
				strInfo = log_sprintf("Idx = {0}, ", Array(Idx))
				For aj = 0 To ul2
					strInfo = log_sprintf("{0} ({1} - {2})", Array(strInfo, aj, rAryInfo(aj, Idx)))
				Next
				Call utxLog(logType, strInfo)
			Next

			strLog = log_sprintf(" ------------------------- {0} ------------------------- ", Array(strTitle))
			Call utxLog(logType, strLog)
		End If
	End Function

'   ===============================================================================
'     print - 1차원 배열을 print하는 범용 함수 - Log File Display
'   ===============================================================================
	Function utxLog1Dim(logType, rAryInfo, sBlock, strTitle)
		Dim Idx, aj , ul, ul2, strInfo

		strLog = log_sprintf(" ---utxLog1Dim {0} ------------------------- ", Array(strTitle))
		Call utxLog(logType, strLog)

		If(IsArray(rAryInfo)) Then
			sBlock = CDbl(sBlock)
			if(sBlock = "" Or sBlock = "0" Or sBlock = 0) Then sBlock = 5 End If

			ul = UBound(rAryInfo)

			If(strTitle = "") Then strTitle = "printInfo" End If
			strLog = log_sprintf(" ------------------------- {0} ------------------------- ", Array(strTitle))
			Call utxLog(logType, strLog)

			strInfo = ""

			For Idx = 0 To ul
				If(Idx Mod sBlock = 0) Then
					If(Idx = 0) Then
						strInfo = log_sprintf("({0} - {1}), ", Array(Idx, rAryInfo(Idx)))
					Else
						Call utxLog(logType, strInfo)
						strInfo = log_sprintf("({0} - {1}), ", Array(Idx, rAryInfo(Idx)))
					End If
				Else
					strInfo = log_sprintf("{0}({1} - {2}), ", Array(strInfo, Idx, rAryInfo(Idx)))
				End If
			Next
			Call utxLog(logType, strInfo)

			strLog = log_sprintf(" ------------------------- {0} ------------------------- ", Array(strTitle))
			Call utxLog(logType, strLog)
		End If
	End Function

'   ===============================================================================
'     print - 2차원 배열을 print하는 범용 함수  - Web Display
'   ===============================================================================
	Function utxWebLog2Dim(rAryInfo, strTitle)
		Dim Idx, aj , ul, ul2, strInfo

		If(IsArray(rAryInfo)) Then
			ul = UBound(rAryInfo,2)
			ul2 = UBound(rAryInfo,1)

			If(strTitle = "") Then strTitle = "printInfo" End If
			strLog = log_sprintf(" ------------------------- {0} ------------------------- <br>", Array(strTitle))
			Call utxWebLog(strLog)

			strInfo = ""

			For Idx = 0 To ul
				strInfo = log_sprintf("Idx = {0}, ", Array(Idx))
				For aj = 0 To ul2
					strInfo = log_sprintf("{0} ({1} - {2})", Array(strInfo, aj, rAryInfo(aj, Idx)))
				Next
				strInfo = log_sprintf("{0}<br>", Array(strInfo))
				Call utxWebLog(strInfo)
			Next

			strLog = log_sprintf(" ------------------------- {0} ------------------------- <br>", Array(strTitle))
			Call utxWebLog(strLog)
		End If
	End Function

'   ===============================================================================
'     print - 1차원 배열을 print하는 범용 함수 - Web Display
'   ===============================================================================
	Function utxWebLog1Dim(rAryInfo, sBlock, strTitle)
		Dim Idx, aj , ul, ul2, strInfo

		If(IsArray(rAryInfo)) Then
			sBlock = CDbl(sBlock)
			if(sBlock = "" Or sBlock = "0" Or sBlock = 0) Then sBlock = 5 End If

			ul = UBound(rAryInfo)

			If(strTitle = "") Then strTitle = "printInfo" End If
			strLog = log_sprintf(" ------------------------- {0} ------------------------- <br>", Array(strTitle))
			Call utxWebLog(strLog)

			strInfo = ""

			For Idx = 0 To ul
				If(Idx Mod sBlock = 0) Then
					If(Idx = 0) Then
						strInfo = log_sprintf("({0} - {1}), ", Array(Idx, rAryInfo(Idx)))
					Else
						strInfo = log_sprintf("{0}<br>", Array(strInfo))
						Call utxWebLog(strInfo)
						strInfo = log_sprintf("({0} - {1}), ", Array(Idx, rAryInfo(Idx)))
					End If
				Else
					strInfo = log_sprintf("{0}({1} - {2}), ", Array(strInfo, Idx, rAryInfo(Idx)))
				End If
			Next
			strInfo = log_sprintf("{0}<br>", Array(strInfo))
			Call utxWebLog(strInfo)

			strLog = log_sprintf(" ------------------------- {0} ------------------------- <br>", Array(strTitle))
			Call utxWebLog(strLog)
		End If
	End Function
%>
