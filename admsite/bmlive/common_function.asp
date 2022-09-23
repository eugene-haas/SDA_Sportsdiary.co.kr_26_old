<%
		'-------------------------전역 변수-----------------------
	global_PagePerData = 10   				 ' 한화면에 출력할 갯수
	global_PagePerGalleryData = 8 	 ' 한화면에 출력할 갯수
	global_PagePerTeamPlayerData = 10 ' 팀/선수 한화면에 출력할 갯수
	global_PagePerInfoData = 10 		 ' 협회 정보 한화면에 출력할 갯수


	global_BlockPage = 10  ' 페이징수, 5면 1,2,3,4,5 까지 나오고 다음페이지 나옴

	global_Name_Val = "성명을 입력해 주세요."
	global_ID_Val = "ID를 입력해 주세요."
	global_Pass_Val = "암호를 입력해 주세요."
	global_Subject_Val = "제목을 입력해 주세요."
	global_Contents_Val = "내용을 입력해 주세요."
	global_Link_Val = "링크를 입력해 주세요."

	global_fileNum = 5 ' 첨부파일 최대 갯수
	global_filepath = "D:\HP\koreabadminton.org\FileDown\" ' 첨부파일 저장경로
	global_filepath2 = "D:\HP\koreabadminton.org\FileDown\GameSummary\" ' 첨부파일 저장경로
	global_filepathUrl = "/FileDown/" ' Common_Js.js 에서 global_filepathUrl_script
	global_filepath_temp = "D:\HP\koreabadminton.org\FileTemp\" ' 첨부파일 Temp 경로
	global_filepath_tempUrl = "/FileTemp/"
	global_filepathImg = "D:\HP\koreabadminton.org\FileImg" ' 이미지업로드 저장 경로
	global_filepathImgUrl = "/FileImg/" ' Common_Js.js 에서 global_filepathImgUrl_script
	golbal_youtubeEmbeded = "https://www.youtube.com/embed/" '유투브 IFrame 나오게 하는 방법

	global_filepath_TB = "D:\HP\koreabadminton.org\FileDown\TB\" ' 상단배너이미지
	global_filepathUrl_TB = "/FileDown/TB/"

	global_filepath_MB = "D:\HP\koreabadminton.org\FileDown\MB\" ' 중단배너이미지
	global_filepathUrl_MB = "/FileDown/MB/"

	global_filepath_MVTHUM = "D:\HP\koreabadminton.org\FileDown\MVTHUM\" ' 갤러리-경기동영상 썸네일
	global_filepathUrl_MVTHUM = "/FileDown/MVTHUM/"

	global_filepath_Admin = "D:\badminton.sportsdiary.co.kr\badmintonAdmin\FileDown\xls\"
	SportsGb = "badminton"

	global_HP = "badminton"
	global_domain = "adm.sportsdiary.co.kr"

	global_MainNoticeCnt = "6"	' 메인공지사항출력갯수
	global_MainTPTCnt = "4"			' 메인커뮤니티>갤러리출력갯수
	global_MainMVCnt = "4"			' 메인영상뉴스출력갯수
	global_MainCLCnt = "5"			' 메인칼럼리스트출력갯수



	'------------------------------Role----------------------------
'	Const_Player = "P"
'	Const_Leader = "L"
'	Const_Director = "D"
'	Const_Judgment = "J"
'	Const_User = "U"
'	'Const_LocalUnion = "S"
		'----------------------------------------------------------
	global_iLoginID = global_Id
	global_iName = global_userName

	'회원프로필 기본이미지
	ImgDefault  = "../images/profile@3x.png"
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
 		Else
			chk_TotRound = 512 		
		End If 
	End Function 
'=========================================================================================================================================================
'============================================================* 참여인원에 따른 강수 구하기================================================================
'=========================================================================================================================================================
	Function Check_Login()
		Check_Login = false
		If Request.Cookies("SD") = "" Then 
			Check_Login = false	
		else 
			Check_Login = true
		End If 
	End Function 

	Function Check_UserLogin()
		If Request.Cookies("SD") = "" Then 
			Response.Write "<script>alert('로그인이 필요 합니다.');location.href='/pub/admlogin.asp';</script>"
			Response.End
		End If 
	End Function 

	Function Check_SessionUserLogin()
		If Session("SD") = "" Then 
			Response.Write "<script>alert('로그인이 필요 합니다.');location.href='/pub/admlogin.asp';</script>"
			Response.End
		End If 
	End Function 
	
	Function Check_AdminLogin()
		'If Request.Cookies("UserID") = "" or  Request.Cookies("AdminYN") <> encode("Y",0) Then 
		If  Request.Cookies("sportsdiary") = "" Then 
			Response.Write "<script>alert('어드민 로그인이 필요 합니다.');location.href='/pub/admlogin.asp';</script>"
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

	' 특수문자 치환 ( 리플 텍스트 에리어에 사용 )
  Function HtmlSpecialChars1(strValue)
    HtmlSpecialChars1 = Replace( strValue, "&", "&amp;" )
    HtmlSpecialChars1 = Replace( HtmlSpecialChars1, ">", "&gt;" )
    HtmlSpecialChars1 = Replace( HtmlSpecialChars1, "<", "&lt;" )
    HtmlSpecialChars1 = Replace( HtmlSpecialChars1, """", "&quot;" )
    HtmlSpecialChars1 = Replace( HtmlSpecialChars1, "'", "&#039;" )
    'HtmlSpecialChars1 = Replace( HtmlSpecialChars1, chr(10), "<BR>" )
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

	Function ReHtmlSpecialChars1(strValue) 
	   dim txtTag
		
		IF strValue <> "" Then   
			txtTag = Replace( strValue, "&gt;", ">")
			txtTag = Replace( txtTag, "&lt;","<")
			txtTag = Replace( txtTag, "&quot;","""")
			txtTag = Replace( txtTag, "&#039;","'")
			'txtTag = Replace( txtTag, "<BR>",chr(10))
			txtTag = Replace( txtTag, "&amp;","&")
			
			ReHtmlSpecialChars1 = txtTag
		
		End IF	
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
	'=====================================================================================================						
	'Server.URLEncode --> URLDecode
	'=====================================================================================================									
	FUNCTION URLDecode(sText)
		dim sDecoded : sDecoded = sText
		dim oRegExpr, oMatchCollection
		
		SET oRegExpr = Server.CreateObject("VBScript.RegExp")
			oRegExpr.Pattern = "%[0-9,A-F]{2}"
			oRegExpr.Global = True
		
		SET oMatchCollection = oRegExpr.Execute(sText)
		
		For Each oMatch In oMatchCollection
			sDecoded = Replace(sDecoded,oMatch.value,Chr(CInt("&H" & Right(oMatch.Value,2))))
		Next
		
		URLDecode = sDecoded
		
	END FUNCTION
	'=====================================================================================================	


	Function PlayerEnNameChg(xtrEnName)
		Dim zIvi, zIvRtnValue
		Dim zIvArrName, zIvFirstName, zIvLastName

		zIvRtnValue = xtrEnName
		If InStr(xtrEnName, " ") > 0 Then
			zIvRtnValue = ""
			zIvArrName = Split(xtrEnName, " ")

			For zIvi = 0 To Ubound(zIvArrName)
				If zIvi = 0 Then
					zIvRtnValue = zIvRtnValue & UCase(Trim(Split(xtrEnName, " ")(zIvi))) &" "
				Else
					zIvRtnValue = zIvRtnValue & UCase(Mid(Trim(Split(xtrEnName, " ")(zIvi)), 1, 1)) & LCase(Mid(Trim(Split(xtrEnName, " ")(zIvi)), 2, Len(Trim(Split(xtrEnName, " ")(zIvi)))-1)) &" "
				End If 
			Next
		End If
		PlayerEnNameChg = zIvRtnValue
	End Function
	
%>