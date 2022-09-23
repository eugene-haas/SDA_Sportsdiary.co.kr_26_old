
<% 	
	'=================================================================================
	'  Purpose  : 	
	'  Date     : 
	'  Author   : 															By Aramdry
	'================================================================================= 
%>

<!-- #include virtual = "/pub/cfg/cfg.log.asp" -->

<script language="Javascript" runat="server">
	

</script>

<% 	
	Function log_sprintf(sVal, aArgs)      
    Dim i, arg
      If(sVal = "") Then 
         log_sprintf = ""
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
	'	Debug: 구글 실행후 f12키를 눌러 실시간 로그를 볼때 사용한다. 
	'================================================================================= 
	Function consoleLog(strLog)
		Response.Write("<script language=Javascript> console.log('" & strLog & "'); </script>")
	end Function
    
	'=================================================================================
	'	Debug: 웹페이지에 log를 찍는다. 
	'================================================================================= 
	Function printLog(dstr)
		Response.write  dstr & "<br>"
	End Function

	'=================================================================================
	'	Debug: 웹페이지에 log를 찍는다. 
	'================================================================================= 
	Function webLog(strLog)
		strWebLog = log_sprintf("{0}<br>", Array(strLog)) 
		Response.write  strWebLog
	End Function

	Function GetLogPath(logType)
		Dim strPath, fileNum

		if( logType < LOCAL_LOG_MAX ) Then  
			fileNum = logType			
			strPath = LOCAL_LOGFILE_PATH & fileNum & ".txt"			
			strPath = Server.MapPath(strPath)
		elseif( logType < SPORTS_LOG_MAX ) Then  
			fileNum = logType-SPORTS_BASE
			strPath = SPORTS_LOGFILE_PATH & fileNum & ".txt"
         strPath = Server.MapPath(strPath)
      elseif( logType < SAMALL_LOG_MAX ) Then  
         fileNum = logType-SAMALL_BASE
         strPath = SAMALL_LOGFILE_PATH & fileNum & ".txt"
         strPath = Server.MapPath(strPath)
      elseif( logType < SYS_LOG_MAX ) Then  
			fileNum = logType-SYS_BASE
			strPath = SYS_LOGFILE_PATH & "syslog" & fileNum & "\" & GetLogFileName("SysLog", "1")
			strPath = Server.MapPath(strPath)
		End If

		GetLogPath = strPath	
	End Function

   '=================================================================================
	'	현재 날짜를 기반으로 LogFile 명 생성 
	'=================================================================================    
	Function GetLogFileName(strName, nType)		
		Dim strPath, curDate, cYear, cMonth, cDay
		If(strName = "") Then strName = "Log" End If 
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
    '   주의 : 1. 로그 파일은 1명당 하나씩 할당해서 쓴다.  - /pub/cfg/cfg.log.asp 에 이름을 적고 할당해서 쓴다. 
    '          2. 로그 파일은 개발이 끝난 다음에는 주석으로 처리한다. - 파일을 열고 쓰는 부하가 생각보다 클수 있다. 
	'================================================================================= 
   Function TraceLog(logType, strLog)		
		Dim objStream
		strPath = GetLogPath(logType)

     '   response.write("writeLog " & logType & ", " & strPath & ", " & strLog)

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

   Function TraceDateLog(logType, strLog)		
		Dim objStream, strTmp
		strPath = GetLogPath(logType)

     '   response.write("writeLog " & logType & ", " & strPath & ", " & strLog)

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
		strTmp = (FormatDateTime(Now) & " => " & strLog)
		objStream.WriteText strTmp, 1			
		objStream.SaveToFile strPath, 2
		objStream.Flush
		objStream.Close
		Set objStream = Nothing		
        On Error GoTo 0
	end Function

   Function DbgLog(logType, strLog)		
		Dim objStream
		strPath = GetLogPath(logType)

     '   response.write("writeLog " & logType & ", " & strPath & ", " & strLog)

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
   
	Function writeLog(logType, strLog)		
		Dim objStream
		strPath = GetLogPath(logType)

     '   response.write("writeLog " & logType & ", " & strPath & ", " & strLog)

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
	'	Debug: LOGFILE_PATH에 있는 log.txt에 로그 데이터를 찍는다. 	날짜 - 로그 
  '   원격 파일 엑세스 에러 - 서버 셋팅에 의해 asp파일에서 ADODB.Stream를 못 만든다.
	'================================================================================= 
	Function writeSysLog(logType, strLog)	
		Call writeDateLog(logType, strLog)	
	End Function 

	'=================================================================================
	'	Debug: LOGFILE_PATH에 있는 log.txt에 로그 데이터를 찍는다. 	날짜 - 로그 
  '   원격 파일 엑세스 에러 - 서버 셋팅에 의해 asp파일에서 ADODB.Stream를 못 만든다.
	'================================================================================= 
	Function writeDateLog(logType, strLog)	
		Dim objStream, strTmp
		strPath = GetLogPath(logType)
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
		strTmp = (FormatDateTime(Now) & " => " & strLog)
		objStream.WriteText strTmp, 1		
		objStream.SaveToFile strPath, 2
		objStream.Flush
		objStream.Close
		Set objStream = Nothing
        On Error GoTo 0
	end Function

	'=================================================================================
	'	Debug: (MultiCode - Scripting.FileSystemObject) - 한글 깨짐 (UTF-8 파일 열때 )
	'   LOGFILE_PATH에 있는 log.txt에 로그 데이터를 찍는다. 
  '   원격 파일 엑세스 에러 - 서버 셋팅에 의해 asp파일에서 Scripting.FileSystemObject를 못 만든다.
	'================================================================================= 
	Function writeLogEx(logType, strLog)	
		Dim fso, fDebug	
		strPath = GetLogPath(logType)		
		If strPath = "" Then Exit Function

		Set fso = Server.CreateObject("Scripting.FileSystemObject")			
		set fDebug = fso.OpenTextFile(strPath, 8, True)

		fDebug.WriteLine(strLog)		
		fDebug.WriteLine(" ")		
		fDebug.Close()

		Set fDebug = nothing
		Set fso = nothing
	end Function

	'=================================================================================
	'	Debug: LOGFILE_PATH에 있는 log.txt에 로그 데이터를 찍는다. 	날짜 - 로그 
  '   원격 파일 엑세스 에러 - 서버 셋팅에 의해 asp파일에서 Scripting.FileSystemObject를 못 만든다.
	'================================================================================= 
	Function writeDateLogEx(logType, strLog)	
		Dim fso, fDebug
		strPath = GetLogPath(logType)		
		If strPath = "" Then Exit Function
		
		set fDebug = fso.OpenTextFile(strPath, 8, True, -1)

		fDebug.WriteLine(FormatDateTime(Now) & " - " & strLog)		
		fDebug.Close()

		Set fDebug = nothing
		Set fso = nothing
	end Function

	'=================================================================================
	'	Debug: DB Query후 얻은 RecordSet을 이용하여 Log에 결과를 출력한다. 
	'================================================================================= 
	Function WriteLogRecordSet(logType, ByRef rs)
		if (rs.EOF Or rs.BOF) Then Exit Function		' RecordSet에 Data가 없으면 return 

		cnt = 0
		' Recordset Counting
		Do Until rs.eof
			cnt = cnt+1
			rs.movenext			
		Loop
		rs.movefirst
		
		strCount = "Record Count = " & cnt
		Call writeLog(logType,strCount)

		strHeader = ""
		For i = 1 To rs.Fields.Count			
			if (i=rs.Fields.Count) then
					strHeader = strheader & rs.Fields(i-1).name
				else 				
					strHeader = strheader & rs.Fields(i-1).name & " , "
			end if
		Next

		Call writeLog(logType,strHeader)

		strContent = " "			
		Do Until rs.eof
			For i=1 To rs.Fields.Count
				if (i=rs.Fields.Count) then
					strContent = strContent & rs.Fields(i-1)
				else 				
					strContent = strContent & rs.Fields(i-1) & " , "
				end if
			Next		
			
			rs.movenext
			Call writeLog(logType,strContent)
			strContent = " "
		Loop

		rs.movefirst			 ' 다른 함수에서 record set을 사용하였을 경우 위치 초기화 
	End Function

	'=================================================================================
	'	Debug: DB Query후 얻은 RecordSet을 이용하여 화면에 결과를 출력한다. 
	'================================================================================= 
	Function printRecordSet(ByRef rs)

		
		if (rs.EOF Or rs.BOF) Then Exit Function		' RecordSet에 Data가 없으면 return 		
		cnt = 0
		' Recordset Counting
		Do Until rs.eof
			cnt = cnt+1
			rs.movenext			
		Loop
		rs.movefirst

		strCount = "<br>Record Count = " & cnt
		Call printLog(strCount)

		' make table 
		Response.write "<table class='table-list' border = '1'>"
		Response.write "<thead id='headtest'>"

		For i = 0 To rs.Fields.Count
			If i = 0 then
				Response.write "<th onclick=""$('td:nth-child("&i+1&"), th:nth-child("&i+1&")').hide();"" style=""corsor:hand;""> No </th>"
			Else
				Response.write "<th onclick=""$('td:nth-child("&i+1&"), th:nth-child("&i+1&")').hide();"" style=""corsor:hand;"">"& rs.Fields(i-1).name &"</th>"
			End if
		Next
		Response.write "</thead>"
	
		cnt = 1
		Do Until rs.eof
			%>
				<tr class="gametitle">
				<%
					For i=0 To rs.Fields.Count
						If i = 0 Then 
							Response.write "<td>" & cnt & "</td>"		
						Else 
							Response.write "<td>" & rs.Fields(i-1) & "</td>"		
						End if
					Next
				%>
				</tr>
			<%			
			cnt = cnt + 1
			rs.movenext
		Loop

		If Not rs.eof then
		rs.movefirst
		End If
		
		Response.write "</tbody>"
		Response.write "</table>"

		rs.movefirst			 ' 다른 함수에서 record set을 사용하였을 경우 위치 초기화 

	End Function
%>