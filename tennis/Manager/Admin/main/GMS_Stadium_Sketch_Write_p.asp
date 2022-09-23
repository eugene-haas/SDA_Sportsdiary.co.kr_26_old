<!--#include file="../dev/dist/config.asp"-->
<%

	'저장위치 찾기
	global_filepath_temp  = server.MapPath("\")
	global_filepath_temp  = Replace(global_filepath_temp,"\Manager","")&"\M_Player\upload\Sketch\"

	'Response.write Replace(global_filepath_temp,"\Manager","")&"\TM_Player\upload\"
	'Response.End
	'Response.write global_filepath_temp
	'Response.End

	'업로드를 처리할 오브젝트를 생성합니다.
	Set Upload = Server.CreateObject("TABSUpload4.Upload")
	'업로드를 시작합니다.
	Upload.Start global_filepath_temp
	'업로드된 파일을 디스크에 저장합니다.(Overwrite)
	Upload.Save global_filepath_temp, false

	Set iFile = Upload.Form("iFile") '등록파일
	Dim idx						: idx = Upload.Form("idx")				 'idx(이값이 전달되면 수정 아니라면 등록)
	dim Search_GameTitleIDX     : Search_GameTitleIDX = fInject(Upload.Form("Search_GameTitleIDX")) '대회선택
	dim Search_TeamGbIDX		: Search_TeamGbIDX	= fInject(Upload.Form("Search_TeamGbIDX")) '종별 선택
	dim UserID					: UserID      = Request.Cookies("UserID")  '쿠키에 저장된 아이디
	dim UserName				: UserName    = Request.Cookies("UserName") '쿠키에 저장된 이름
	dim watermark_yn			: watermark_yn    = fInject(Upload.Form("watermark_yn"))

	For i = 1 To Upload.Form("iFile").Count

		 If Upload.Form("iFile")(i) = "" Then

			LSQL = "EXEC Stadium_Sketch_insert_ok	" &_
				   " @idx = '" & idx & "'"&_
				   ",@Search_GameTitleIDX= '" & Search_GameTitleIDX & "'"&_
				   ",@Search_TeamGbIDX='"&Search_TeamGbIDX&"'"&_
				   ",@Photo = '' "&_
				   ",@UserID = '"&UserID&"'"&_
				   ",@UserName = '"&UserName&"'"
					'response.Write "LSQL="&LSQL&"<br>"
					'response.End

			Set LRs = DBCon.Execute(LSQL)

			If Not (LRs.Eof Or LRs.Bof) Then

				  Do Until LRs.Eof

				  iMSeq = LRs(0)

				LRs.MoveNext
				  Loop

			  End If

			LRs.close
%>
<form name="bform" method='post'>
	<input type="hidden" name="idx" id="idx" value="<%=idx%>">
</form>
<script language='javascript'>
	<%if idx <> "" then %>
		document.bform.action="GMS_Stadium_Sketch_Write.asp"
		document.bform.submit();
	<% else %>
		document.bform.action="GMS_Stadium_Sketch.asp"
		document.bform.submit();
	<% end if %>
</script>
<%
	Else

	 If Upload.Form("iFile")(i) <> "" Then
		Dim iFileName
			iFileName = Upload.Form("iFile")(i).ShortSaveName '// 저장된 이름

			Set Image = Server.CreateObject("TABSUpload4.Image")
			'이미지를 로딩합니다.
			Status = Image.Load(iFile(i).SaveName)
			'Response.write Image.Load(iFile(i).SaveName)


			If Status = Ok Then

					'Response.Write "이미지 크기: " & Image.Width & " x " & Image.Height
					'Response.write
					'logo.png를 읽어 투명 모드로 합성한다.
					Set LogoImage = Server.CreateObject("TABSUpload4.Image")

					If watermark_yn = "N" Then
						Status = ""
					Else
						Status = LogoImage.Load(global_filepath_temp&"sportsdiary_eng.png")
					End If


					If Image.Width > 1280 Then
						Image.Resize 1280, 0, ItpModeBicubic
						Image.Save global_filepath_temp&Upload.Form("iFile")(i).ShortSaveName, 100, True
					End If

					If Status = Ok Then
						'Image.DrawImage LogoImage, Image.Width-320, Image.Height-70, 255
						Image.DrawImage LogoImage, Image.Width-150, Image.Height-60, 255
						LogoImage.Close
					End If


					'주문번호 생성(주문번호 먼저 생성되는 버전)
					Dim rndValue, rndSeed,or_num,sub_gubun_request
					rndSeed = 100 '1~40

					Randomize ' 난수 발생기 초기화
					rndValue = Int((rndSeed * Rnd) + 1) ' 1에서 40까지 무작위 값 발생

					file_name = Year(Now())&Month(Now())&day(Now())&Hour(Now())&minute(Now())&second(Now())&rndValue&".jpg"

					'썸네일 이미지를 생성합니다.

					Image.SaveThumbnail global_filepath_temp&file_name, Image.Width, 0, Image.Height
					Image.SaveThumbnail global_filepath_temp&file_name&"_sub", Image.Width, 0, Image.Height
          Image.SaveThumbnail global_filepath_temp&"ListTN\ListTN_"&file_name, 320, 0, 90 '리스트 썸네일
					'Image.SaveThumbnail global_path_temp&"thumb200.jpg", & Image.Width & " x " & Image.Height
					Image.Close

					LSQL = "EXEC Stadium_Sketch_insert_ok	" &_
						   " @idx = '" & idx & "'"&_
						   ",@Search_GameTitleIDX= '" & Search_GameTitleIDX & "'"&_
						   ",@Search_TeamGbIDX='"&Search_TeamGbIDX&"'"&_
						   ",@Photo = '"&file_name&"'"&_
						   ",@UserID = '"&UserID&"'"&_
						   ",@UserName = '"&UserName&"'"
							'response.Write "LSQL="&LSQL&"<br>"
							'response.End
					Set LRs = DBCon.Execute(LSQL)

					If Not (LRs.Eof Or LRs.Bof) Then

						  Do Until LRs.Eof

						  iMSeq = LRs(0)

						LRs.MoveNext
						  Loop

					  End If

					LRs.close
%>
<form name="bform" method='post'>
	<input type="hidden" name="idx" id="idx" value="<%=idx%>">
</form>
<script language='javascript'>
	<%if idx <> "" then %>
		document.bform.action="GMS_Stadium_Sketch_Write.asp"
		document.bform.submit();
	<% else %>
		document.bform.action="GMS_Stadium_Sketch.asp"
		document.bform.submit();
	<% end if %>
</script>
<%


					Else
						Response.Write "이미지 파일을 열 수 없습니다. 오류 코드: " & Status
					End If

				End If
				'Response.write iFileName&"<br>"
		 End If
	Next

%>
