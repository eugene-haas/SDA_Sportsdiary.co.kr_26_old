<%
	'-------------------------전역 변수-----------------------
	global_PagePerData = 10   				 ' 한화면에 출력할 갯수
	global_PagePerGalleryData = 8 	 ' 한화면에 출력할 갯수
	global_PagePerTeamPlayerData = 10 ' 팀/선수 한화면에 출력할 갯수
	global_PagePerInfoData = 10 		 ' 협회 정보 한화면에 출력할 갯수

	global_BlockPage = 10  ' 페이징수, 5면 1,2,3,4,5 까지 나오고 다음페이지 나옴

	'global_Id = "junida"
	'global_userName = "주니"
	'global_Admin ="admin"
	'global_AdminName ="admin"

	global_Name_Val = "성명을 입력해 주세요."
	global_ID_Val = "ID를 입력해 주세요."
	global_Pass_Val = "암호를 입력해 주세요."
	global_Subject_Val = "제목을 입력해 주세요."
	global_Source_Val = "출처를 입력해 주세요."
	global_Contents_Val = "내용을 입력해 주세요."
	global_Link_Val = "링크를 입력해 주세요."
	global_File_Val = "파일을 첨부해 주세요."
	global_Column_Val = "칼럼구분을 선택해 주세요."

	'global_fileNum = 5 ' 첨부파일 최대 갯수
	'global_filepath = "D:\judo.sports.or.kr\FileDown\" ' 첨부파일 저장경로
	'global_filepath_temp = "D:\judo.sports.or.kr\FileTemp\" ' 첨부파일 Temp 경로
	'golbal_youtubeEmbeded = "https://www.youtube.com/embed/" '유투브 IFrame 나오게 하는 방법
	'SportsGb = "judo"

	'global_filepath_TKNews = "D:\sportsdiary.co.kr\tennis\File\TennisKoreaNews" ' 테니스코리아뉴스
	'global_filepath_TKNews_Bak = "D:\sportsdiary.co.kr\tennis\File\TennisKoreaNews_Bak" ' 테니스코리아뉴스 업로드후 백업

	global_fileNum = 5 ' 첨부파일 최대 갯수

	'global_filepath = "D:\sportsdiary.co.kr\tennis\File\FileDown" ' 첨부파일 저장경로
	'global_filepathUrl = "/FileDown/" ' Common_Js.js 에서 global_filepathUrl_script
	'global_filepath_temp = "D:\sportsdiary.co.kr\tennis\File\FileTemp" ' 첨부파일 Temp 경로
	'global_filepath_tempUrl = "/FileTemp/"
	'global_filepathImg = "D:\sportsdiary.co.kr\tennis\File\FileImg" ' 이미지업로드 저장 경로
	'global_filepathImgUrl = "/FileImg/" ' Common_Js.js 에서 global_filepathImgUrl_script
	'golbal_youtubeEmbeded = "https://www.youtube.com/embed/" '유투브 IFrame 나오게 하는 방법
	'
  'global_filepath_ADIMG = "D:\ADIMG\tennis"
	'global_filepathUrl_ADIMG = "/ADImgR/tennis/"
	'global_filepath_temp_ADIMG = "D:\ADIMG\temp"
	'global_filepath_tempUrl_ADIMG = "/ADImgR/temp/"

  tennis_global_filepath = "D:\SDADMIN_FILE\tennis\File\FileDown" ' 첨부파일 저장경로
	tennis_global_filepathUrl = "/FileDown/" ' Common_Js.js 에서 global_filepathUrl_script
	tennis_global_filepath_temp = "D:\SDADMIN_FILE\tennis\File\FileTemp" ' 첨부파일 Temp 경로
	tennis_global_filepath_tempUrl = "/FileTemp/"
	tennis_global_filepathImg = "D:\SDADMIN_FILE\tennis\File\FileImg" ' 이미지업로드 저장 경로
	tennis_global_filepathImgUrl = "/FileImg/" ' Common_Js.js 에서 global_filepathImgUrl_script
	tennis_golbal_youtubeEmbeded = "https://www.youtube.com/embed/" '유투브 IFrame 나오게 하는 방법
  tennis_global_filepath_ADIMG = "D:\SDADMIN_FILE\tennis\ADImg\ADImgFile"
	tennis_global_filepathUrl_ADIMG = "/ADImgR/tennis/"
	tennis_global_filepath_temp_ADIMG = "D:\SDADMIN_FILE\tennis\ADImg\ADImgTemp"
	tennis_global_filepath_tempUrl_ADIMG = "/ADImgR/temp/"

  judo_global_filepath = "D:\SDADMIN_FILE\judo\File\FileDown" ' 첨부파일 저장경로
	judo_global_filepathUrl = "/FileDown/" ' Common_Js.js 에서 global_filepathUrl_script
	judo_global_filepath_temp = "D:\SDADMIN_FILE\judo\File\FileTemp" ' 첨부파일 Temp 경로
	judo_global_filepath_tempUrl = "/FileTemp/"
	judo_global_filepathImg = "D:\SDADMIN_FILE\judo\File\FileImg" ' 이미지업로드 저장 경로
	judo_global_filepathImgUrl = "/FileImg/" ' Common_Js.js 에서 global_filepathImgUrl_script
	judo_golbal_youtubeEmbeded = "https://www.youtube.com/embed/" '유투브 IFrame 나오게 하는 방법
  judo_global_filepath_ADIMG = "D:\SDADMIN_FILE\judo\ADImg\ADImgFile"
	judo_global_filepathUrl_ADIMG = "/ADImgR/judo/"
	judo_global_filepath_temp_ADIMG = "D:\SDADMIN_FILE\judo\ADImg\ADImgTemp"
	judo_global_filepath_tempUrl_ADIMG = "/ADImgR/temp/"


  SportsGb = "sdadmin"

	'global_HP = "KATA"
	global_domain = "sdmainadmin.sportsdiary.co.kr"

	global_MainNoticeCnt = "6"	' 메인공지사항출력갯수
	global_MainTNewsCnt = "3"		' 메인일반뉴스출력갯수
	global_MainMNewsCnt = "2"		' 메인영상뉴스출력갯수
	global_MainCLCnt = "5"			' 메인칼럼리스트출력갯수

	'------------------------------Role----------------------------
	Const_Player = "P"
	Const_Leader = "L"
	Const_Director = "D"
	Const_Judgment = "J"
	Const_User = "U"
	'Const_LocalUnion = "S"
		'----------------------------------------------------------
	global_iLoginID = global_Id
	global_iName = global_userName

	'회원프로필 기본이미지
	ImgDefault  = "../images/public/ic-profile-basic@3x.png"
	'=========================================================================================================================================================
	'============================================================* 한자리수 숫자 0붙이기  ====================================================================
	'=========================================================================================================================================================
	
	Function AddZero(Str)
	 IF len(Str)=1 Then
	  AddZero="0"&Str
	 Else
	  AddZero=Str
	 End IF
	End Function
'=========================================================================================================================================================
'============================================================* 한자리수 숫자 0붙이기  ====================================================================
'=========================================================================================================================================================
'=========================================================================================================================================================
'============================================================* 참여인원에 따른 강수 구하기================================================================
'=========================================================================================================================================================
	Function chk_TotRound(PlayerCnt)
		If PlayerCnt <=2 Then 
			chk_TotRound = 2
		ElseIf PlayerCnt > 2 And PlayerCnt <=4 Then 
			chk_TotRound = 4
		ElseIf PlayerCnt > 4 And PlayerCnt <=8 Then 
			chk_TotRound = 8
		ElseIf PlayerCnt > 8 And PlayerCnt <=16 Then 
			chk_TotRound = 16
		ElseIf PlayerCnt > 16 And PlayerCnt <=32 Then 
			chk_TotRound = 32
		ElseIf PlayerCnt > 32 And PlayerCnt <=64 Then 
			chk_TotRound = 64
		ElseIf PlayerCnt > 64 And PlayerCnt <=128 Then 
			chk_TotRound = 128
		ElseIf PlayerCnt > 128 And PlayerCnt <= 256 Then 
			chk_TotRound = 256	
		End If 
	End Function 
'=========================================================================================================================================================
'============================================================* 참여인원에 따른 강수 구하기================================================================
'=========================================================================================================================================================
	Function Check_Login()
		Check_Login = false
		If Request.Cookies("UserID") = "" Then 
			Check_Login = false	
		else 
			Check_Login = true
		End If 
	End Function 

	Function Check_UserLogin()
		If Request.Cookies("UserID") = "" Then 
			Response.Write "<script>alert('로그인이 필요 합니다.');location.href='/';</script>"
			Response.End
		End If 
	End Function 

	Function Check_SessionUserLogin()
		If Session("UserID") = "" Then 
			Response.Write "<script>alert('로그인이 필요 합니다.');location.href='/Member/login.asp';</script>"
			Response.End
		End If 
	End Function 
	
	Function Check_AdminLogin()
		'If Request.Cookies("UserID") = "" or Request.Cookies("AdminYN") <> encode("Y",0) Then 
    If Request.Cookies("UserID") = "" or Request.Cookies("AdminYN") <> crypt.EncryptStringENC("Y") Then 
			Response.Write "<script>alert('어드민 로그인이 필요 합니다.');location.href='http://sdmainadmin.sportsdiary.co.kr/admin/main/admin_Login.asp';</script>"
			Response.End
		End If 
	End Function 
	
	Function Check_NoLogin()
		If Request.Cookies("UserID") <> "" Then 
			Response.Write "<script>location.href='/'</script>"
			Response.End
		End If 
	End Function

	Function Check_Role(Roles, chkRole)
		Check_Role = false
		roleArray = Split(Roles,"|")
		count = UBound(roleArray)
		FOR i = 0 to count 
			If roleArray(i) = chkRole Then
				Check_Role = true
			End If
		next 
	End Function

  ' 첨부파일 삭제 함수
  Function DeleteExistFile(filePath) 
    Dim fso, result
    Set fso = CreateObject("Scripting.FileSystemObject") 
    If fso.FileExists(filePath) Then 
      fso.DeleteFile(filePath) '파일이 존재하면 삭제합니다. 
      result = 1
    Else
      result = 0
    End If
    DeleteExistFile = result
  End Function

  ' 특수문자 치환
  Function HtmlSpecialChars(strValue)

    HtmlSpecialChars = Replace( strValue, "&", "&amp;" )
    HtmlSpecialChars = Replace( HtmlSpecialChars, ">", "&gt;" )
    HtmlSpecialChars = Replace( HtmlSpecialChars, "<", "&lt;" )
    HtmlSpecialChars = Replace( HtmlSpecialChars, """", "&quot;" )
    HtmlSpecialChars = Replace( HtmlSpecialChars, "'", "&#039;" )
    HtmlSpecialChars = Replace( HtmlSpecialChars, chr(10), "<BR>" )

  End Function
        
   Function ReHtmlSpecialChars(strValue) 
	   dim txtTag
		
		IF strValue <> "" Then   
			txtTag = Replace( strValue, "&gt;", ">")
			txtTag = Replace( txtTag, "&lt;","<")
			txtTag = Replace( txtTag, "&quot;","""")
			txtTag = Replace( txtTag, "&#039;","'")
			txtTag = Replace( txtTag, "<BR>",chr(10))
			txtTag = Replace( txtTag, "&amp;","&")
			
			ReHtmlSpecialChars = txtTag
		
		End IF	
  	End Function

            
	' 특수문자 치환
  Function HtmlSpecialChars_TK(strValue)

		HtmlSpecialChars_TK = Replace( strValue, "'", "&#039;" )

		'HtmlSpecialChars_TK = Replace( HtmlSpecialChars_TK, "<div>&nbsp;</div>", "" )

		'HtmlSpecialChars_TK = Replace( HtmlSpecialChars_TK, "<div>", "" )
		'HtmlSpecialChars_TK = Replace( HtmlSpecialChars_TK, "</div>", "" )

  End Function


	Function FileExt_Check(str)
		
		fext = ""
		fext1 = ""

		fext = UCase(str)
		fext1 = Mid(str,InStr(str,".") + 1)

		FileExt_Check = fext1

	End Function 


	' 유도 로그 찍는 용
	Function JudoWriteLine(str)
		Response.Write(str & "<br/>")
	End Function 

	' 유도 로그 찍는 용2
	' 호출 시 파라미터가 2개라서 대괄호는 못 쓴다.
	Function JudoTitleWriteLine(title, str)
		Response.Write(title & " : " & str & "<br/>")
	End Function 


	'=============================================================================================================
	' 문서자료실 확장자에 따른 이미지 변환
	'=============================================================================================================
	Function iFileExtImg(str1)
	
		If 	str1 = "XLS" or str1 = "XLSX" Then
			Response.Write "<img src='/DocImg/Doc/doc_xls.png' />"
		ElseIf	str1 = "PDF" Then
			Response.Write "<img src='/DocImg/Doc/doc_pdf.png' />"
		ElseIf	str1 = "TXT" Then
			Response.Write "<img src='/DocImg/Doc/doc_txt.png' />"
		ElseIf	str1 = "DOC" or str1 = "DOCX" Then
			Response.Write "<img src='/DocImg/Doc/doc_doc.png' />"
		ElseIf	str1 = "TTF" Then
			Response.Write "<img src='/DocImg/Doc/doc_ttf.png' />"
		ElseIf	str1 = "HWP" Then
			Response.Write "<img src='/DocImg/Doc/doc_hwp.png' />"
		ElseIf	str1 = "PPT" Then
			Response.Write "<img src='/DocImg/Doc/doc_ppt.png' />"
		ElseIf	str1 = "LOG" Then
			Response.Write "<img src='/DocImg/Doc/doc_log.png' />"
		ElseIf	str1 = "TIF" Then
			Response.Write "<img src='/DocImg/Doc/doc_tif.png' />"
		ElseIf	str1 = "BMP" Then
			Response.Write "<img src='/DocImg/IMG/doc_bmp.png' />"
		ElseIf	str1 = "GIF" Then
			Response.Write "<img src='/DocImg/IMG/doc_gif.png' />"
		ElseIf	str1 = "JPG" Then
			Response.Write "<img src='/DocImg/IMG/doc_jpg.png' />"
		ElseIf	str1 = "PNG" Then
			Response.Write "<img src='/DocImg/IMG/doc_png.png' />"
	ElseIf	str1 = "7Z" Then
			Response.Write "<img src='/DocImg/ARC/doc_7z.png' />"
	ElseIf	str1 = "RAR" Then
			Response.Write "<img src='/DocImg/ARC/doc_rar.png' />"
	ElseIf	str1 = "ZIP" Then
			Response.Write "<img src='/DocImg/ARC/doc_zip.png' />"
		ElseIf	str1 = "" Then
			Response.Write "<img src='/DocImg/Doc/doc_x.png' />"
		Else
			Response.Write "<img src='/DocImg/Doc/doc_other.png' />"
		End If

	End Function 

	'=============================================================================================================
	'파일사이즈 출력
	'=============================================================================================================
	FUNCTION iFileSize(valObj)
		dim fs, txtFile
		dim valSize	
		dim vbi 	 
		dim vbm : vbm = "bytes"		
		
		SET fs = Server.CreateObject("Scripting.FileSystemObject")
		
		IF fs.FileExists(global_filepath&valObj) Then 
			
			SET txtFile = fs.GetFile(global_filepath&valObj)
		
			valSize 	= txtFile.size 
			vbi 		= valSize
			
			IF valSize > 1073741824 then  '1GB 보다 크면
				vbi = valSize/1073741824  '1024*1024*1024
				vbm = "GB"
			ELSE
				IF valSize > 1048576 then '1MB 보다 크면
					vbi = valSize / 1048576  '1024*1024
					vbm = "MB"
				ELSE
					IF valSize > 1024 then  '1KB 보다 크면
						vbi = valSize / 1024
						vbm = "KB"
					END IF
				END IF
			END IF
			
			IF vbm = "bytes" then
				iFileSize = formatnumber(vbi,0) & vbm
			ELSE
				iFileSize = formatnumber(vbi,2) & vbm
			END IF
		
		End IF
		
	END FUNCTION

	'****************
	'@ 랜덤 문자 생성 함수
	'****************
	Function Func_getRndChr(ByVal rLen)
		Dim rtnStr
		Randomize
		For rIdx = 1 To rLen
		rtnStr = rtnStr & Chr(Int(2*Rnd)*32 + Int((90-65+1)*Rnd + 65))
		Next
		Func_getRndChr = rtnStr
	End Function

	'// GUID 생성해서 값을 리턴하는 함수
  Function fnGetGUID()
		Dim myTypeLib
		Set myTypeLib = Server.CreateObject("Scriptlet.Typelib")
		fnGetGUID = myTypeLib.guid
		Set myTypeLib = Nothing
  End Function
	
	
%>