<!-- #include virtual="/classes/JSON_2.0.4.asp" -->
<!-- #include virtual="/classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include virtual="/classes/json2.asp" -->



<%
	'참조 1: http://widecloud.tistory.com/143
	'참조 2: http://itzone.tistory.com/123
	'참조 3: http://itzone.tistory.com/123

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

	Dim UrlAddress,oJSONoutput

	IF request("t") = "t" Then
		Req =  "{""CMD"":20000,""IDX"":""1"",""UrlAddress"":""/Ajax/ReqReturnASP.asp""}"
		Session("Req") =Req
	Else
		REQ = request("REQ")
	End if

	IF(Req = "") Then
	  Response.WRITE "Req is Empty"
	  Response.End
	END IF

	Set oJSONoutput = JSON.Parse(REQ)
	
	UrlAddress = oJSONoutput.UrlAddress

	include(UrlAddress)
%>

