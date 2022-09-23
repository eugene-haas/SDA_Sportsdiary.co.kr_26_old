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
	dim Search_GameTitleIDX     : Search_GameTitleIDX = fInject(Upload.Form("Search_GameTitleIDX")) '대회선택
	dim UserID					: UserID      = Cookies_aID  '쿠키에 저장된 아이디
	dim UserName				: UserName    = Cookies_aNM '쿠키에 저장된 이름
	dim watermark_yn			: watermark_yn    = fInject(Upload.Form("watermark_yn"))
	dim ReturnURI			: ReturnURI    = fInject(Upload.Form("ReturnURI"))
	dim flag			: flag    = fInject(Upload.Form("flag"))
	dim sketch_idx			: sketch_idx    = fInject(Upload.Form("sketch_idx"))

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

						If watermark_yn = "N" Then
							Status = ""
						Else
							Status = LogoImage.Load(global_filepath_waterMark&"sportsdiary_water_mark_new.png")
						End If

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

						'Dim rndValue, rndSeed,or_num,sub_gubun_request
						'rndSeed = 100 '1~40
						'Randomize ' 난수 발생기 초기화
						'rndValue = Int((rndSeed * Rnd) + 1) ' 1에서 40까지 무작위 값 발생

						'file_name = s_seq & "_" & Year(Now())&Month(Now())&day(Now())&Hour(Now())&minute(Now())&second(Now())&rndValue&".jpg"

						''썸네일 이미지를 생성합니다.
						'Image.SaveThumbnail global_filepath_temp&"Thumbnail\"&file_name, Fix((Image.Width)/3), 0, Fix((Image.Height)/3)
'						'Image.SaveThumbnail global_filepath_temp&file_name&"_sub", Image.Width, 0, Image.Height
						Image.Close




					Else
						Response.Write "이미지 파일을 열 수 없습니다. 오류 코드: " & Status
					End If

				End If

		 End If
	Next

	if Search_GameTitleIDX <> "" Then
		if flag = "mod" then
			insert_db = "update sd_Tennis_Stadium_Sketch set GameTitleIDX='"& Search_GameTitleIDX &"' where idx='"& sketch_idx &"' "
			Call db.execSQLRs(insert_db , null, R_ConStr)
		Else
			insert_db = "insert into sd_Tennis_Stadium_Sketch (GameTitleIDX,UserID,UserName,Delyn,Writeday,ViewCnt) values ('"& Search_GameTitleIDX &"','"& UserID &"','"& UserName &"','N',getdate(),0)"
			Call db.execSQLRs(insert_db , null, R_ConStr)
			insert_db = "SELECT IDENT_CURRENT('sd_Tennis_Stadium_Sketch')"
			Set GRs = db.ExecSQLReturnRS(insert_db , null, R_ConStr)
			sketch_idx = GRs(0)
			set GRs = Nothing
		end if

		insert_photo_db = ""
		for i = LBound(arr_file,1) to ubound(arr_file,1)
			insert_photo_db = insert_photo_db & "insert into sd_Tennis_Stadium_Sketch_Photo (Sketch_idx,photo,delyn,writeday) values ('"& sketch_idx &"','"& arr_file(i) &"','N',getdate());"
		Next
		Call db.execSQLRs(insert_photo_db , null, R_ConStr)
	end if

	if flag = "mod" Then
		ReturnURI = ReturnURI &"?idx="& Search_GameTitleIDX &"&sketch_idx="& sketch_idx &"&flag="& flag
	end if

	Response.write "<script type='text/javascript'>"
	Response.write "alert('완료되었습니다.');"
	Response.write "location.href='"& ReturnURI &"'"
	Response.write "</script>"
%>
