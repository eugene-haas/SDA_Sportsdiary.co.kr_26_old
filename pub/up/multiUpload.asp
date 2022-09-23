<!-- #include virtual = "/pub/header.bike.asp" -->
<%
	If iLoginID = "" Then '관리자 로그인이 안된경우
		Response.end
	End if

	'저장위치 찾기
	global_filepath_temp  = server.MapPath("\")
	global_filepath_temp  = Replace(global_filepath_temp,"\Manager","")&"\M_Player\upload\Sketch\"


	'업로드를 처리할 오브젝트를 생성합니다.
	Set Upload = Server.CreateObject("TABSUpload4.Upload")
	
	'업로드를 시작합니다.
	Upload.Start global_filepath_temp
	'업로드된 파일을 디스크에 저장합니다.(Overwrite)
	Upload.Save global_filepath_temp, False
	

	Set iFile = Upload.Form("iFile") '등록파일



	Set db = new clsDBHelper

	'Response.write seq & "###############"


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
							Status = LogoImage.Load(global_filepath_temp&"sportsdiary_water_mark_new.png")
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



						Dim rndValue, rndSeed,or_num,sub_gubun_request
						rndSeed = 100 '1~40
						Randomize ' 난수 발생기 초기화
						rndValue = Int((rndSeed * Rnd) + 1) ' 1에서 40까지 무작위 값 발생

						file_name = s_seq & "_" & Year(Now())&Month(Now())&day(Now())&Hour(Now())&minute(Now())&second(Now())&rndValue&".jpg"

						'썸네일 이미지를 생성합니다.
						Image.SaveThumbnail global_filepath_temp&"Thumbnail\"&file_name, Fix((Image.Width)/3), 0, Fix((Image.Height)/3)
'						Image.SaveThumbnail global_filepath_temp&file_name&"_sub", Image.Width, 0, Image.Height
						Image.Close

						SQL = "insert into sd_bikeBoard_c ( seq,tid,pid,filename,Thumbnail,title ) values ("&s_seq&","&s_tid&",'"&iLoginID&"','"&iFileName&"','"&file_name&"','"&s_seq&"')"
						Call db.execSQLRs(SQL , null, ConStr)


					Else
						Response.Write "이미지 파일을 열 수 없습니다. 오류 코드: " & Status
					End If

				End If

		 End If
	Next

Response.redirect "/bbs.asp"
%>
