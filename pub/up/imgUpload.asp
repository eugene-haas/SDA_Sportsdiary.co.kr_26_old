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
	Upload.Save global_filepath_temp, false

	Set iFile = Upload.Form("iFile") '등록파일
	Dim seq					: seq = Upload.Form("seq")				 'idx(이값이 전달되면 수정 아니라면 등록)
	dim s_tid					: s_tid      =  securityRequestReplace(Upload.Form("tid"))  'tid 게시판구분
	dim s_year				: s_year = securityRequestReplace(Upload.Form("sgameYear")) 'year
	dim s_tidx				: s_tidx = securityRequestReplace(Upload.Form("sgametitle")) 'tidx
	dim s_title				: s_title	= securityRequestReplace(Upload.Form("title")) 'title
	dim s_levelno			: s_levelno	= securityRequestReplace(Upload.Form("slevelno")) 'levelno
	dim watermark_yn	: watermark_yn    = securityRequestReplace(Upload.Form("watermark_yn"))


	Set db = new clsDBHelper

	'Response.write seq & "###############"
	If seq = "" Or  seq ="0" then
		SQL = "select max(num) from sd_bikeBoard where tid = '"&s_tid&"' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If isNull(rs(0)) = True Then
			s_num = 1
		Else
			s_num = CDbl(rs(0)) + 1
		End if

		SQL = "insert into sd_bikeBoard (titleidx,levelno,tid,pid,ip,title,num,tailcnt) values ("&s_tidx&","&s_levelno&","&s_tid&",'"&iLoginID&"','"&USER_IP&"','"&s_title&"',"&s_num&","& iFile.count &")"
		Call db.execSQLRs(SQL , null, ConStr)

		SQL = "select max(seq) from sd_bikeBoard where tid = '"&s_tid&"' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		s_seq = rs(0)

	Else
		'쿼리로 실제 남아있는 이미지수 카운트 + iFile.count
		SQL = "select count(*) from sd_bikeBoard_c where seq = " & seq
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		tailcnt = CDbl(rs(0)) + CDbl(iFile.count)
		SQL = "update sd_bikeBoard Set titleidx="&s_tidx&" ,levelno="&s_levelno&" ,pid='"&iLoginID&"',ip ='"&USER_IP&"' ,title='"&s_title&"',tailcnt="&tailcnt&"  where seq = " & seq
		Call db.execSQLRs(SQL , null, ConStr)

		s_seq = seq
	End if

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
