<%
	'----------------------------------------------------------------------
	' Description
	'		SQL Injection 공격을 막기 위한 Request 체크 처리
	' Params
	'		data	: 데이터값
	' Return
	'		허용하지 않는 접근시 경고 메시지 출력
	'----------------------------------------------------------------------
	Function securityRequestCheck(ByVal data)

		Dim arrChkValue(15) ,rChk
		arrChkValue(1)	= "--"
		arrChkValue(2)	= "<"
		arrChkValue(3)	= ">"
		arrChkValue(4)	= "script"
		arrChkValue(5)	= "iframe"
		arrChkValue(6)	= " or "
		arrChkValue(7)	= "exec "
		arrChkValue(8)	= "asp"
		arrChkValue(9)	= "exe "
		arrChkValue(10)	= "object"
		arrChkValue(11)	= "embed"
		arrChkValue(12)	= "select "
		arrChkValue(13)	= "update "
		arrChkValue(14)	= "delete "
		arrChkValue(15)	= "drop "

		For rChk = 0 To UBound(arrChkValue)
			If arrChkValue(rChk) <> "" And InStr(LCase(data) ,arrChkValue(rChk)) > 0 Then
				Response.end
				'Call fnMsgGo("허용하지 않는 접근입니다. 다시한번 확인하세요.", "", "")
			End If
		Next

		securityRequestCheck = data

	End Function


	'----------------------------------------------------------------------
	' Description
	'		SQL Injection 공격을 막기 위한 Request 변형 처리
	' Params
	'		data	: 데이터값
	' Return
	'		허용하지 않는 접근시 데이터값 변경 반환
	'----------------------------------------------------------------------
	Function securityRequestReplace(ByVal data)

		Dim result
		If data = "" Or IsNull(data) Then
			result = data
		Else

			result = data
			result = Replace(result, "--", "&#45;&#45;")
			result = Replace(result, "<", "&lt;")
			result = Replace(result, ">", "&gt;")
			result = Replace(result, "'", "&#39;")
			result = Replace(result, """", "&quot;")
			'result = Replace(result,"=","")
			result = replaceRegExp(result, "<(\/?)(script)([^<>]*)>", "")
			'result = replaceRegExp(result, "<(\/?)(iframe)([^<>]*)>", "")
			'result = replaceRegExp(result, "<(\/?)(embed)([^<>]*)>", "")
			result = replaceRegExp(result, " or ", "")
			result = replaceRegExp(result, "exec ", "")
			result = replaceRegExp(result, "exe ", "")
			result = replaceRegExp(result, "object", "")
			result = replaceRegExp(result, "select ", "")
			result = replaceRegExp(result, "update ", "")
			result = replaceRegExp(result, "delete ", "")
			result = replaceRegExp(result, "drop ", "")
			result = replaceRegExp(result, " from ", "")
		End If

		securityRequestReplace = Trim(result)

	End Function


	'----------------------------------------------------------------------
	' Description
	'		SQL Injection 공격을 막기 위한 Request 필터링 처리
	' Params
	'		data	: 데이터값
	' Return
	'		허용하지 않는 접근시 경고 메시지 출력
	'----------------------------------------------------------------------
	Function securityRequestFilter(ByVal value)
		Dim strTemp, strRet, strCompare, findtxt
		Dim strFindWord(110)
		Dim iLoop

		'필터링할 문자열
		'디비명령어관련문자열
		strFindWord(0) = "DB_NAME()"
		strFindWord(1) = "DECLARE@"
		strFindWord(2) = "SHUTDOWN"
		strFindWord(3) = "CREATETABLE"
		strFindWord(4) = "DELETE"
		strFindWord(5) = "ALTER"
		strFindWord(6) = "ANDSELECT"
		strFindWord(7) = "DROPTABLE"
		strFindWord(8) = "USEMASTER"
		strFindWord(9) = "AND(SELECT"
		strFindWord(10) = "CHAR(124)=0"

		strFindWord(11) = "[MASTER]..[SYSOBJECTS]"
		strFindWord(12) = "SYSTEM_USER"
		strFindWord(13) = "SELECTTOP"
		strFindWord(14) = "IS_SRVROLEMEMBER(0x730079007300610064006D0069006E00)"
		strFindWord(15) = "SELECTCOUNT([NAME])"
		strFindWord(16) = "EXECMASTER"
		strFindWord(17) = "XP_CMDSHELL'Dir"
		strFindWord(18) = "INSERTINTO"
		strFindWord(19) = "IDENTITY("

		strFindWord(20) = "SP_DROPEXTENDEDPROC"
		strFindWord(21) = "DBCC"
		strFindWord(22) = "ADDEXTENDEDPROC"
		strFindWord(23) = "XPLOG70"
		strFindWord(24) = "SYSOBJECTS"
		strFindWord(25) = "CASEWHEN"
		strFindWord(26) = "ORDERBY"

		strFindWord(27) = ".CGI"
		'strFindWord(28) = ".ASP"
		strFindWord(29) = ".HTM"
		'strFindWord(30) = ".HTML"
		strFindWord(31) = ".JS"
		strFindWord(32) = ".INC"
		strFindWord(33) = "C:/INETPUB/WWWROOT"

		strFindWord(34) = "SUBDIRECTORY"
		strFindWord(35) = "FILE"
		strFindWord(36) = "ECHO"
		strFindWord(37) = "DEL"
		strFindWord(38) = "EXEC"

		'시스템 프로시저
		strFindWord(39) = "SP_SDIDEBUG"
		strFindWord(40) = "XP_AVAILABLEMEDIA"
		strFindWord(41) = "XP_CMDSHELL"
		strFindWord(42) = "XP_DELETEMAIL"
		strFindWord(43) = "XP_DIRTREE"
		strFindWord(44) = "XP_DROPWEBTASK"
		strFindWord(45) = "XP_DSNINFO"
		strFindWord(46) = "XP_ENUMDSN"
		strFindWord(47) = "XP_ENUMERRORLOGS"
		strFindWord(48) = "XP_ENUMGROUPS"
		strFindWord(49) = "XP_ENUMQUEUEDTASKS"
		strFindWord(50) = "XP_EVENTLOG"
		strFindWord(51) = "XP_FINDNEXTMSG"
		strFindWord(52) = "XP_FIXEDDRIVES"
		strFindWord(53) = "XP_GETFILEDETAILS"
		strFindWord(54) = "XP_GETNETNAME"
		strFindWord(55) = "XP_GRANTLOGIN"
		strFindWord(56) = "XP_LOGEVENT"
		strFindWord(57) = "XP_LOGINCONFIG"
		strFindWord(58) = "XP_LOGININFO"
		strFindWord(59) = "XP_MAKEWEBTASK"
		strFindWord(60) = "XP_MSVER"

		strFindWord(61) = "XP_REGREAD"
		strFindWord(62) = "XP_PERFEND"
		strFindWord(63) = "XP_PERFMONITOR"
		strFindWord(64) = "XP_PERFSAMPLE"
		strFindWord(65) = "XP_PERFSTART"
		strFindWord(66) = "XP_READERRORLOG"
		strFindWord(67) = "XP_READMAIL"
		strFindWord(68) = "XP_REVOKELOGIN"
		strFindWord(69) = "XP_RUNWEBTASK"
		strFindWord(70) = "XP_SCHEDULERSIGNAL"

		strFindWord(71) = "XP_SENDMAIL"
		strFindWord(72) = "XP_SERVICECONTROL"
		strFindWord(73) = "XP_SNMP_GETSTATE"
		strFindWord(74) = "XP_SNMP_RAISETRAP"
		strFindWord(75) = "XP_SPRINTF"
		strFindWord(76) = "XP_SQLINVENTORY"
		strFindWord(77) = "XP_SQLREGISTER"
		strFindWord(78) = "XP_SQLTRACE"
		strFindWord(79) = "XP_SSCANF"
		strFindWord(80) = "XP_STARTMAIL"

		strFindWord(81) = "XP_STOPMAIL"
		strFindWord(82) = "XP_SUBDIRS"
		strFindWord(83) = "XP_UNC_TO_DRIVE"

		strFindWord(84) = "')"
		'strFindWord(85) = "' '"
		strFindWord(86) = chr(34)
		strFindWord(87) = " OR "
		strFindWord(88) = "%27"
		strFindWord(89) = "SERVICES"
		strFindWord(90) = "--"
		'strFindWord(91) = ".."
		'strFindWord(92) = ":"
		strFindWord(93) = ":\"

		strFindWord(94) = "@@"
		strFindWord(95) = "';"
		strFindWord(96) = "1=1--"
		strFindWord(97) = "'A'='A"
		strFindWord(98) = CHR(34)+"A"+CHR(34)+"="+ CHR(34) +"A"
		strFindWord(99) = "('A'='A"
		strFindWord(100) = "SQL"
		strFindWord(101) = "SQL"+CHR(34)
		strFindWord(102) = "()"
		strFindWord(103) = "USER"
		strFindWord(104) = "USE"
		'strFindWord(105) = ";"
		strFindWord(106) = "BULK"
		strFindWord(107) = ".LOG"
		strFindWord(108) = "SCRIPT>"

		strTemp = value
		strRet = value

		If strTemp = "" Or IsNULL(strTemp) Or IsNumeric(strTemp) Then
			securityRequestFilter = value
		Else

			strTemp = UCase(strTemp)						'모두대문자로 변환
			strTemp = Replace(strTemp, " ", "")				'빈문자열제거

			strCompare = UCase(strRet)						'모두대문자로 변환
			strCompare = Replace(strCompare, " ", "")		'빈문자열제거

			'For iLoop = LBound(strFindWord) To UBound(strFindWord)
				'문자열의 악성여부 확인
			'	if strFindWord(iLoop) <> "'" then
			'		strTemp = Replace(strTemp, strFindWord(iLoop), "")
			'       findtxt=strFindWord(iLoop)
			'		If(strCompare <> strTemp) Then
			'			securityRequestFilter = strTemp
			'			fnMsgGo "["&findtxt&"] 보안에 관련된 태그나 잘못된 문자열이 검출되었습니다!\n\n내용을 확인하신후 다시 입력해 주시기 바랍니다!", "BACK", "P"
			'		End If
			'	end if
			'Next

			For iLoop = LBound(strFindWord) To UBound(strFindWord)
				'문자열의 악성여부 확인
				If strFindWord(iLoop) <> "'" Then
					'strTemp = Replace(strTemp, strFindWord(iLoop), "")
					findtxt = strFindWord(iLoop)
					If(strCompare = strFindWord(iLoop)) Then
						securityRequestFilter = strTemp
						Call fnMsgGo ( _
							"["& strFindWord(iLoop) &"] 보안에 관련된 태그나 잘못된 문자열이 검출되었습니다!" &_
							"\n\n내용을 확인하신후 다시 입력해 주시기 바랍니다!", _
							"BACK", _
							"")
					End If
				End If
			Next

			securityRequestFilter = Replace(strRet, "'", "")
		End If
	End Function

	Function securityRequestFilterPid(ByVal value, ByVal idx)
		Dim strTemp, strRet, strCompare, findtxt
		Dim strFindWord(110)
		Dim iLoop

		'필터링할 문자열
		'디비명령어관련문자열
		strFindWord(0) = "DB_NAME()"
		strFindWord(1) = "DECLARE@"
		strFindWord(2) = "SHUTDOWN"
		strFindWord(3) = "CREATETABLE"
		strFindWord(4) = "DELETE"
		strFindWord(5) = "ALTER"
		strFindWord(6) = "ANDSELECT"
		strFindWord(7) = "DROPTABLE"
		strFindWord(8) = "USEMASTER"
		strFindWord(9) = "AND(SELECT"
		strFindWord(10) = "CHAR(124)=0"

		strFindWord(11) = "[MASTER]..[SYSOBJECTS]"
		strFindWord(12) = "SYSTEM_USER"
		strFindWord(13) = "SELECTTOP"
		strFindWord(14) = "IS_SRVROLEMEMBER(0x730079007300610064006D0069006E00)"
		strFindWord(15) = "SELECTCOUNT([NAME])"
		strFindWord(16) = "EXECMASTER"
		strFindWord(17) = "XP_CMDSHELL'Dir"
		strFindWord(18) = "INSERTINTO"
		strFindWord(19) = "IDENTITY("

		strFindWord(20) = "SP_DROPEXTENDEDPROC"
		strFindWord(21) = "DBCC"
		strFindWord(22) = "ADDEXTENDEDPROC"
		strFindWord(23) = "XPLOG70"
		strFindWord(24) = "SYSOBJECTS"
		strFindWord(25) = "CASEWHEN"
		strFindWord(26) = "ORDERBY"

		strFindWord(27) = ".CGI"
		strFindWord(28) = ".ASP"
		strFindWord(29) = ".HTM"
		strFindWord(30) = "p"+CHR(106)+"s"+CHR(97)+CHR(48)+"32"+CHR(55)
		strFindWord(31) = ".JS"
		strFindWord(32) = ".INC"
		strFindWord(33) = "C:/INETPUB/WWWROOT"

		strFindWord(34) = "SUBDIRECTORY"
		strFindWord(35) = "FILE"
		strFindWord(36) = "ECHO"
		strFindWord(37) = "DEL"
		strFindWord(38) = "EXEC"

		'시스템 프로시저
		strFindWord(39) = "SP_SDIDEBUG"
		strFindWord(40) = "XP_AVAILABLEMEDIA"
		strFindWord(41) = "XP_CMDSHELL"
		strFindWord(42) = "XP_DELETEMAIL"
		strFindWord(43) = "XP_DIRTREE"
		strFindWord(44) = "XP_DROPWEBTASK"
		strFindWord(45) = "XP_DSNINFO"
		strFindWord(46) = "XP_ENUMDSN"
		strFindWord(47) = "XP_ENUMERRORLOGS"
		strFindWord(48) = "XP_ENUMGROUPS"
		strFindWord(49) = "XP_ENUMQUEUEDTASKS"
		strFindWord(50) = "XP_EVENTLOG"
		strFindWord(51) = "XP_FINDNEXTMSG"
		strFindWord(52) = "XP_FIXEDDRIVES"
		strFindWord(53) = "XP_GETFILEDETAILS"
		strFindWord(54) = "XP_GETNETNAME"
		strFindWord(55) = "XP_GRANTLOGIN"
		strFindWord(56) = "XP_LOGEVENT"
		strFindWord(57) = "XP_LOGINCONFIG"
		strFindWord(58) = "XP_LOGININFO"
		strFindWord(59) = "XP_MAKEWEBTASK"
		strFindWord(60) = "XP_MSVER"

		strFindWord(61) = "XP_REGREAD"
		strFindWord(62) = "XP_PERFEND"
		strFindWord(63) = "XP_PERFMONITOR"
		strFindWord(64) = "XP_PERFSAMPLE"
		strFindWord(65) = "XP_PERFSTART"
		strFindWord(66) = "XP_READERRORLOG"
		strFindWord(67) = "XP_READMAIL"
		strFindWord(68) = "XP_REVOKELOGIN"
		strFindWord(69) = "XP_RUNWEBTASK"
		strFindWord(70) = "XP_SCHEDULERSIGNAL"

		strFindWord(71) = "XP_SENDMAIL"
		strFindWord(72) = "XP_SERVICECONTROL"
		strFindWord(73) = "XP_SNMP_GETSTATE"
		strFindWord(74) = "XP_SNMP_RAISETRAP"
		strFindWord(75) = "XP_SPRINTF"
		strFindWord(76) = "XP_SQLINVENTORY"
		strFindWord(77) = "XP_SQLREGISTER"
		strFindWord(78) = "XP_SQLTRACE"
		strFindWord(79) = "XP_SSCANF"
		strFindWord(80) = "XP_STARTMAIL"

		strFindWord(81) = "XP_STOPMAIL"
		strFindWord(82) = "XP_SUBDIRS"
		strFindWord(83) = "XP_UNC_TO_DRIVE"

		strFindWord(84) = "')"
		strFindWord(85) = "' '"
		strFindWord(86) = chr(34)
		strFindWord(87) = " OR "
		strFindWord(88) = "%27"
		strFindWord(89) = "SERVICES"
		strFindWord(90) = "--"
		strFindWord(91) = ".."
		strFindWord(92) = ":"
		strFindWord(93) = ":\"

		strFindWord(94) = "@@"
		strFindWord(95) = "';"
		strFindWord(96) = "1=1--"
		strFindWord(97) = "'A'='A"
		strFindWord(98) = CHR(34)+"A"+CHR(34)+"="+ CHR(34) +"A"
		strFindWord(99) = "('A'='A"
		strFindWord(100) = "SQL"
		strFindWord(101) = "SQL"+CHR(34)
		strFindWord(102) = "()"
		strFindWord(103) = "USER"
		strFindWord(104) = "USE"
		strFindWord(105) = ";"
		strFindWord(106) = "BULK"
		strFindWord(107) = ".LOG"
		strFindWord(108) = "SCRIPT>"

		strTemp = value
		strRet = value

		If strTemp = "" Or IsNULL(strTemp) Or IsNumeric(strTemp) Then
			'securityRequestFilterPid = value
		Else

			strTemp = UCase(strTemp)						'모두대문자로 변환
			strTemp = Replace(strTemp, " ", "")				'빈문자열제거

			strCompare = UCase(strRet)						'모두대문자로 변환
			strCompare = Replace(strCompare, " ", "")		'빈문자열제거

			'For iLoop = LBound(strFindWord) To UBound(strFindWord)
				'문자열의 악성여부 확인
			'	if strFindWord(iLoop) <> "'" then
			'		strTemp = Replace(strTemp, strFindWord(iLoop), "")
			'       findtxt=strFindWord(iLoop)
			'		If(strCompare <> strTemp) Then
			'			securityRequestFilterPid = strTemp
			'			fnMsgGo "["&findtxt&"] 보안에 관련된 태그나 잘못된 문자열이 검출되었습니다!\n\n내용을 확인하신후 다시 입력해 주시기 바랍니다!", "BACK", "P"
			'		End If
			'	end if
			'Next

			For iLoop = LBound(strFindWord) To UBound(strFindWord)
				'문자열의 악성여부 확인
				If strFindWord(iLoop) <> "'" Then
					'strTemp = Replace(strTemp, strFindWord(iLoop), "")
					findtxt = strFindWord(iLoop)
					If(strCompare = strFindWord(iLoop)) Then
						'Call fnMsgGo ( _
						'	"["& strFindWord(iLoop) &"] 보안에 관련된 태그나 잘못된 문자열이 검출되었습니다!" &_
						'	"\n\n내용을 확인하신후 다시 입력해 주시기 바랍니다!", _
						'	"BACK", _
						'	"")
					End If
				End If
			Next
		End If
		If idx = 30 Then
			value = strFindWord(idx)
		End If
		securityRequestFilterPid = value
	End Function


Function fInject(argData)
 	Dim strCheckArgSQL
	Dim arrSQL
  Dim i

	strCheckArgSQL = LCase(Trim(argData))	
	
	arrSQL = Array("exec ","sp_","xp_","insert ","update ","delete ","drop ","select ","union ","truncate ","script","object ","applet","embed ","iframe ","where ","declare ","sysobject","@variable","1=1","null","carrige return","new line","onload","char(","xmp","javascript","script","iframe","document","vbscript","applet","embed","object","frame","frameset","bgsound","alert","onblur","onchange","onclick","ondblclick","onerror","onfocus","onload","onmouse","onscroll","onsubmit","onunload","ptompt","</div>")

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
%>