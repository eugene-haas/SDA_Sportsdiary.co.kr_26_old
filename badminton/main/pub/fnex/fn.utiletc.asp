
<% 	
	'=================================================================================
	'  Purpose  : 	
	'  Date     : 
	'  Author   : 															By Aramdry
	'================================================================================= 
%>

<!--METADATA TYPE= "typelib"  NAME= "ADODB Type Library" FILE="C:\Program Files\Common Files\SYSTEM\ADO\msado15.dll"  -->

<script language="Javascript" runat="server">

	/* =================================================================================
			테스트용 - 숫자를 입력받아 2로 나눈 나머지가 1이면 'Y' 0 이면 'N'반환
	   ================================================================================= */
	function GetYesNoChar(num) {
		return (num % 2) ? "'Y'" : "'N'";
	}
</script>

<% 	
    '=================================================================================
	'	Sql 구문 - 변수값을 ' ' 로 둘러싼 문자열로 반환한다.
	'================================================================================= 
	Function strSqlVar(strVal)
		strSqlVar = "'" & strVal & "'"
	End Function

	'=================================================================================
	'	정규식 - 문자열 Find ( ex) FindByRegEx "(of|loop)", "loop repeats a block of code loop repeats a block"
	'================================================================================= 
	Function FindByRegEx(ByVal strExp, ByVal strSrc)
		Dim regEx
		Set regEx = New RegExp

		regEx.Pattern = strExp
		regEx.IgnoreCase = True		' Case Insensitive ( 대소문자 구분 - 안함 )
		regEx.Global = True			' 전체 문서에서 검색 

		Set findRst = regEx.Execute(strSrc)
		For Each x In findRst
		'	response.write(findRst(x) & " = " & x )
			response.write(x & "<br>" )
		Next

		Set findRst = Nothing
		Set regEx = Nothing
	End Function

	'=================================================================================
	'	정규식 - 문자열 Replace  ( ex) replaceByRegEx("[(|'|)]", "", "((2001)) 	('300')")
	'================================================================================= 
	Function replaceByRegEx(ByVal strExp, ByVal strNew, ByVal strSrc)
		Dim regEx
		Set regEx = New RegExp

		regEx.Pattern = strExp
		regEx.IgnoreCase = True		' Case Insensitive ( 대소문자 구분 - 안함 )
		regEx.Global = True			' 전체 문서에서 검색 

		strSrc = regEx.Replace(strSrc, strNew)
		Set regEx = Nothing

		replaceByRegEx = strSrc
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
	'	Debug: DB Query후 얻은 RecordSet을 이용하여 화면에 결과를 출력한다. 
	'================================================================================= 
	Function printRecordSet(ByRef rs)
		if (rs.EOF Or rs.BOF) Then Exit Function		' RecordSet에 Data가 없으면 return 
		
		rs.movefirst			 ' 다른 함수에서 record set을 사용하였을 경우 위치 초기화 
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

	End Function
%>