<!--#include file="../dev/dist/config.asp"-->

<%
  
	Dim iFileCnt, iFileName, iTitle, iNsid, iSource, iAction, iName, iInsDateT, iInsDateF, iInsDateB, iContent
	Dim iType, ColumnistIDX, iDivision, iLink, SubType, N_Year, Temp, iUserID, iLoginID, MSeq, TeamGb, FileExt, LCnt, iFileExt

	iType = "1"
	ColumnistIDX = ""
	iDivision = "4"
	iLink = ""
	SubType = ""
	NoticeYN = "N"
	N_Year = ""
	Temp = ""
	MSeq = ""
	TeamGb = ""
	FileExt = ""
	iFileExt = ""

	LCnt = 0

	iUserID = fInject(Request.cookies("UserID"))
	iLoginID = decode(iUserID,0)
	
	iFileCnt = 0

  Set fs = Server.CreateObject("Scripting.FileSystemObject")
  Set folderObj = fs.GetFolder(global_filepath_TKNews)
  Set files = folderObj.Files

	For Each file in files
		
		iFileName = file.name
		iFileExt = FileExt_Check(iFileName)


		If iFileExt = "xml" then

			iFileCnt = iFileCnt + 1

			Set objXML = Server.CreateObject("Microsoft.XMLDOM")
			objXML.async = False '//비동기 모드를 false 로 바꿔서 동기식 호출이 되게 합니다.
			objXML.load (global_filepath_TKNews&"\"&iFileName)
			
			If objXML.parseError.errorCode <> 0 Then
				Response.Write "XML 페이지 로딩중 에러가 발생했습니다."
				Response.End
			End If

			iAction = objXML.getElementsByTagName("action")(0).text

			If iAction = "I" Then
			
				'title = objXML.documentElement.childNodes(0).text

				iNsid = objXML.getElementsByTagName("nsid")(0).text

				iTitle = objXML.getElementsByTagName("title")(0).text
				iSource = objXML.getElementsByTagName("press")(0).text
				iName = objXML.getElementsByTagName("author")(0).text
				iContent = objXML.getElementsByTagName("content")(0).text
				iContent = HtmlSpecialChars_TK(iContent)
				iInsDateF = objXML.getElementsByTagName("date")(0).text
				iInsDateB = objXML.getElementsByTagName("time")(0).text
				iInsDateT = iInsDateF&" "&iInsDateB

				LSQL = "EXEC Community_Board_M '" & iType & "','" & ColumnistIDX & "','" & iDivision & "','" & iName & "','" & iTitle & "','" & iContent & "','" & iLink & "','" & SubType & "','" & NoticeYN & "','" & N_Year & "','" & Temp & "','" & iLoginID & "','" & MSeq & "','" & TeamGb & "','" & FileExt & "','" & iSource & "','" & iNsid & "','" & iInsDateT & "','" & iAction & "',''"
				'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
				'response.End
  
				Set LRs = DBCon5.Execute(LSQL)

				If Not (LRs.Eof Or LRs.Bof) Then

				  Do Until LRs.Eof
				  
				      LCnt = LCnt + 1
				      iMSeq = LRs("MSeq")

				    LRs.MoveNext
				  Loop

				End If

				LRs.close
				

				Dim tFileNm, tFileNmExt, tFileCnt
				
				tFileCnt = 0

				tFileNm = global_filepath_TKNews_Bak&"\"&left(iFileName, instr(iFileName,".") - 1)
				tFileNmExt = Mid(iFileName,instr(iFileName,"."))

				Do while fs.FileExists(tFileNm&tFileNmExt) = true
					tFileCnt = tFileCnt + 1
					tFileNm = tFileNm&"["&tFileCnt&"]"
				Loop
			
				'response.Write tFileNm&tFileNmExt
				'response.End
			
				fs.MoveFile global_filepath_TKNews&"\"&iFileName, tFileNm&tFileNmExt
	
			Else

			End If

		End If


	Next




	Dim iFileCnt1, iFileName1, iTitle1, iNsid1, iSource1, iAction1, iName1, iInsDateT1, iInsDateF1, iInsDateB1, iContent1
	Dim iType1, ColumnistIDX1, iDivision1, iLink1, SubType1, N_Year1, Temp1, iUserID1, iLoginID1, MSeq1, TeamGb1, FileExt1, LCnt1, NoticeYN1, iFileExt1

	iType1 = "1"
	ColumnistIDX1 = ""
	iDivision1 = "4"
	iLink1 = ""
	SubType1 = ""
	NoticeYN1 = "N"
	N_Year1 = ""
	Temp1 = ""
	MSeq1 = ""
	TeamGb1 = ""
	FileExt1 = ""
	iFileExt1 = ""

	LCnt1 = 0

	iUserID1 = fInject(Request.cookies("UserID"))
	iLoginID1 = decode(iUserID,0)
	
	iFileCnt1 = 0

  Set fs1 = Server.CreateObject("Scripting.FileSystemObject")
  Set folderObj1 = fs1.GetFolder(global_filepath_TKNews)
  Set files1 = folderObj1.Files

	For Each file1 in files1
		
		iFileName1 = file1.name
		iFileExt1 = FileExt_Check(iFileName1)

		If iFileExt1 = "xml" then
		
			iFileCnt1 = iFileCnt1 + 1

			Set objXML1 = Server.CreateObject("Microsoft.XMLDOM")
			objXML1.async = False '//비동기 모드를 false 로 바꿔서 동기식 호출이 되게 합니다.
			objXML1.load (global_filepath_TKNews&"\"&iFileName1)
			
			If objXML1.parseError.errorCode <> 0 Then
				Response.Write "XML 페이지 로딩중 에러가 발생했습니다."
				Response.End
			End If

			iAction1 = objXML1.getElementsByTagName("action")(0).text

			If iAction1 = "U" Then
			
				'title = objXML.documentElement.childNodes(0).text

				iNsid1 = objXML1.getElementsByTagName("nsid")(0).text

				iTitle1 = objXML1.getElementsByTagName("title")(0).text
				iSource1 = objXML1.getElementsByTagName("press")(0).text
				iName1 = objXML1.getElementsByTagName("author")(0).text
				iContent1 = objXML1.getElementsByTagName("content")(0).text
				iContent1 = HtmlSpecialChars_TK(iContent1)
				iInsDateF1 = objXML1.getElementsByTagName("date")(0).text
				iInsDateB1 = objXML1.getElementsByTagName("time")(0).text
				iInsDateT1 = iInsDateF1&" "&iInsDateB1

				LSQL = "EXEC Community_Board_M '" & iType1 & "','" & ColumnistIDX1 & "','" & iDivision1 & "','" & iName1 & "','" & iTitle1 & "','" & iContent1 & "','" & iLink1 & "','" & SubType1 & "','" & NoticeYN1 & "','" & N_Year1 & "','" & Temp1 & "','" & iLoginID1 & "','" & MSeq1 & "','" & TeamGb1 & "','" & FileExt1 & "','" & iSource1 & "','" & iNsid1 & "','" & iInsDateT1 & "','" & iAction1 & "',''"
				'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
				'response.End
  
				Set LRs = DBCon5.Execute(LSQL)

				If Not (LRs.Eof Or LRs.Bof) Then

				  Do Until LRs.Eof
				  
				      LCnt = LCnt + 1
				      iMSeq = LRs("MSeq")

				    LRs.MoveNext
				  Loop

				End If

				LRs.close


				Dim tFileNm1, tFileNmExt1, tFileCnt1
				
				tFileCnt1 = 0

				tFileNm1 = global_filepath_TKNews_Bak&"\"&left(iFileName1, instr(iFileName1,".") - 1)
				tFileNmExt1 = Mid(iFileName1,instr(iFileName1,"."))

				Do while fs1.FileExists(tFileNm1&tFileNmExt1) = true
					tFileCnt1 = tFileCnt1 + 1
					tFileNm1 = tFileNm1&"["&tFileCnt1&"]"
				Loop
			
				'response.Write tFileNm&tFileNmExt
				'response.End

				fs1.MoveFile global_filepath_TKNews&"\"&iFileName1, tFileNm1&tFileNmExt1

			Else

			End If

		End If


	Next



   
	Tennis_DBClose()

  response.Write "<script type='text/javascript'>alert('글 등록이 잘 돼었습니다.');location.href='./Community_News_TennisKorea_Write.asp';</script>"
  response.End

%>