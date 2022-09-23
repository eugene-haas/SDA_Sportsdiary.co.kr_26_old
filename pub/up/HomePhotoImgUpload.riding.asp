<!-- #include virtual = "/pub/header.pub.asp" -->
<%
	If Cookies_aID = "" Then '관리자 로그인이 안된경우
		Response.end
	End if

	dim arr_file()

	Set db = new clsDBHelper

	'저장위치 찾기
'	global_filepath_temp  = server.MapPath("\")
'	global_filepath_temp  = Replace(global_filepath_temp,"\Manager","")&"\M_Player\upload\Sketch\"
	global_filepath_temp = "E:\www\upload\sportsdiary\"&sitecode&"\"&year(date)&"\"
	global_filepath_waterMark = "E:\www\upload\sportsdiary\"&sitecode&"\"
	global_filepath_DB = "/"& sitecode &"/"& year(date) &"/"

	'해당 폴더가 없으면 생성
	Set Fso = Server.CreateObject("Scripting.FileSystemObject")
	if not Fso.FolderExists(global_filepath_temp) Then
	  global_filepath_temp = Fso.CreateFolder(global_filepath_temp)
	end if
	Set Fso = nothing

	'업로드를 처리할 오브젝트를 생성합니다.
	Set Upload = Server.CreateObject("TABSUpload4.Upload")
	'업로드를 시작합니다.
	Upload.Start global_filepath_temp
	'업로드된 파일을 디스크에 저장합니다.(Overwrite)
	Upload.Save global_filepath_temp, false

	Set iFile = Upload.Form("iFile") '등록파일
	Dim total_board_seq : total_board_seq = fInject(Upload.Form("total_board_seq")) 
	dim ReturnURI       : ReturnURI       = fInject(Upload.Form("ReturnURI"))
	Dim board_title     : board_title     = fInject(Upload.Form("board_title")) 
	Dim board_contents  : board_contents  = fInject(Upload.Form("board_contents")) 
	dim flag            : flag            = fInject(Upload.Form("flag"))

	dim UserID          : UserID          = Cookies_aID  '쿠키에 저장된 아이디
	dim UserName        : UserName        = Cookies_aNM '쿠키에 저장된 이름

	'response.write sketch_idx
	'response.end
	redim arr_file(Upload.Form("iFile").Count-1)
	For i = 1 To Upload.Form("iFile").Count

		If Upload.Form("iFile")(i) = "" Then

		Else

			 If Upload.Form("iFile")(i) <> "" Then
				iFileName = Upload.Form("iFile")(i).ShortSaveName '// 저장된 이름

				Set Image = Server.CreateObject("TABSUpload4.Image")
				'이미지를 로딩합니다.
				Status = Image.Load(iFile(i).SaveName)

				If Status = Ok Then
						'Response.Write "이미지 크기: " & Image.Width & " x " & Image.Height
						'logo.png를 읽어 투명 모드로 합성한다.
						Set LogoImage = Server.CreateObject("TABSUpload4.Image")

						If Status = Ok Then
							Image.DrawImage LogoImage, Image.Width-150, Image.Height-60, 255
							LogoImage.Close
						End If

						If Image.Width > 1280 Then
							Image.Resize 1280, 0, ItpModeBicubic
							Image.Save global_filepath_temp&Upload.Form("iFile")(i).ShortSaveName, 100, True
						Else
							Image.Save global_filepath_temp&Upload.Form("iFile")(i).ShortSaveName, 100, True
						End If

						arr_file(i-1) = global_filepath_DB&Upload.Form("iFile")(i).ShortSaveName

						Image.Close
					Else
						Response.Write "이미지 파일을 열 수 없습니다. 오류 코드: " & Status
					End If

				End If

		 End If
	Next

	if board_title <> "" Then
		if flag = "mod" then
			insert_db = "update tblTotalBoard set TITLE='"& board_title &"', CONTENTS='"&board_contents&"', MODDATE=GETDATE() where SEQ='"& total_board_seq &"' "
			Call db.execSQLRs(insert_db , null, R_ConStr)
		Else
			'insert_db = "insert into tblTotalBoard (GameTitleIDX,UserID,UserName,Delyn,Writeday,ViewCnt) values ('"& Search_GameTitleIDX &"','"& UserID &"','"& UserName &"','N',getdate(),0)"
			insert_db = "insert into tblTotalBoard (CATE,TITLE,CONTENTS,REGDATE,REGID,REGNAME,VISIT,DelYN,viewYN) values ('0','"&board_title&"','"&board_contents&"',GETDATE(),'"& UserID &"','"& UserName &"','0','N','Y')"
			Call db.execSQLRs(insert_db , null, R_ConStr)
			insert_db = "SELECT IDENT_CURRENT('tblTotalBoard')"
			Set GRs = db.ExecSQLReturnRS(insert_db , null, R_ConStr)
			total_board_seq = GRs(0)
			set GRs = Nothing
		end if

		insert_photo_db = ""
		for i = LBound(arr_file,1) to ubound(arr_file,1)
			insert_photo_db = insert_photo_db & "insert into tblTotalBoard_File (TotalBoard_SEQ, FILENAME,REGDATE,DelYN) values ('"& total_board_seq &"','"& arr_file(i) &"',getdate(),'N') "
		Next
		Call db.execSQLRs(insert_photo_db , null, R_ConStr)
	end if

	if flag = "mod" Then
		ReturnURI = ReturnURI &"?seq="& total_board_seq &"&flag="& flag
	end if

	Response.write "<script type='text/javascript'>"
	Response.write "alert('완료되었습니다.');"
	Response.write "location.href='"& ReturnURI &"'"
	Response.write "</script>"
%>
