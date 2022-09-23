<!--#include file="../dev/dist/config.asp"-->

<%
  Dim NowPage, Subject, Contents, Filecnt, iFilecnt, iDivision, iLink

  'iDivision = "0"
	iLink = "" ' 동영상링크등 링크주소

  'iLink = fInject(Request("iLink"))  ' 동영상링크등 링크주소
  
  'iType = fInject(Request("iType"))           ' 1:글쓰기, 2:수정
  
  'iMSeq = fInject(Request("iMSeq"))           ' 수정시 글번호
  'MSeq = decode(iMSeq,0)

  'NowPage = fInject(Request("iNowPage"))      ' 현재페이지
  'Subject = fInject(Request("iSubject"))      ' 제목

  'Contents = fInject(Request("iContents"))
  'iContents = HtmlSpecialChars(Contents)

  'Name = fInject(Request("iName"))            ' 로그인유저
  'ID = fInject(Request("iID"))                ' 로그인ID


  Set Upload = Server.CreateObject("TABSUpload4.Upload")

  Upload.CodePage = 65001
  Upload.Start global_filepath_temp_ADIMG

  iType = fInject(Upload.Form("iType"))           ' 1:글쓰기, 2:수정, 3:수정인데 파일존재
  
  iMSeq = fInject(Upload.Form("iMSeq"))           ' 수정시 글번호
  MSeq = decode(iMSeq,0)

  NowPage = fInject(Upload.Form("iNowPage"))      ' 현재페이지

	FileYN = fInject(Upload.Form("iFileYN"))	' 첨부파일 이미 있었는지 여부
	
	if FileYN = "Y" then
		iType = "3"
	end if

	ImageType = fInject(Upload.Form("iImageType"))
  LocateGb = fInject(Upload.Form("iLocateGb"))
	Subject = fInject(Upload.Form("iSubject"))
	BColor = fInject(Upload.Form("iBC"))
	ImgURL = fInject(Upload.Form("iLink"))
	txtMemo = fInject(Upload.Form("iMemo"))
	ViewYN = fInject(Upload.Form("iViewYN"))

  ''Contents = fInject(Upload.Form("iContents"))    ' 내용
  ' Contents = Upload.Form("iContents")    ' 내용
	'' 스마트에디터는 ' 문자만 변경이 안돼서 처리 해야 한다. HtmlSpecialChars 함수 사용 할 필요 없음.
	'iContents = Replace(Contents,"'","&#039;")
	'
  'SubType = fInject(Upload.Form("selSearch1"))  
	'NoticeYN = fInject(Upload.Form("selSearch2"))
	 
	Name = fInject(Upload.Form("iName"))            ' 로그인이름
  ID = fInject(Upload.Form("iID"))                ' 로그인ID
  FileCnt = fInject(Upload.Form("iFilecnt"))      ' 열린첨부파일항목갯수
  rFileCnt = Upload.Form("iFile").Count           ' 실첨부파일 갯수
  Set iFile = Upload.Form("iFile")                ' 실첨부파일,배열

  'execute를 사용하여 유동적으로 변수를 만듦, 파일쪽에 set 을 붙여야 ShortSaveName 을 사용 할 수 있음. 테스트로 놔둠. 사용안함.
  'For i = 1 to CInt(Filecnt) step 1
  '  execute("Dim File_"&i&"")
  '  'execute("File_"&i&" = fInject(Upload.Form(""iFile_"&i&"""))")
  '  execute("Set File_"&i&" = Upload.Form(""iFile_"&i&""")")
  'Next
  
  If Err.Number = 0 Then

		Upload.Save global_filepath_ADIMG, False

		ImgFileNm = iFile.ShortSaveName
		ImgFilePath = iFile.SaveName

		' 첨부파일 한개고 바로 하나 테이블에 저장해서 파일저장 로직을 따로 할 필요 없다.
		Set Image = Server.CreateObject("TABSUpload4.Image")

		Status = Image.Load(ImgFilePath)

		If Status = Ok Then

		ImgWidth = Image.Width
		ImgHeight = Image.Height

		End If

    Dim LCnt
    LCnt = 0
		
		iSportsGb = "tennis"

		ImgFileExt = ""

    LSQL = "EXEC AD_tblADImageInfo_M '" & iType & "','" & MSeq & "','" & iSportsGb & "','" & ImgURL & "','" & Subject & "','" & ImageType & "','" & ImgFileNm & "','" & BColor & "','" & ImgFileExt & "','" & ImgWidth & "','" & ImgHeight & "','" & LocateGb & "','" & txtMemo & "','" & ViewYN & "','" & ID & "','','','','',''"
	  'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
    'response.End
  
    Set LRs = DBCon6.Execute(LSQL)
		
    If Not (LRs.Eof Or LRs.Bof) Then
		
		  Do Until LRs.Eof
      
          LCnt = LCnt + 1
          iMSeq = LRs("MSeq")
					iCodeMod = LRs("CodeMod")
		
        LRs.MoveNext
		  Loop
		
	  End If
		
    LRs.close
  
    'For i = 1 To CInt(rFileCnt) step 1
		'
    '  If Upload.Form("iFile")(i) <> "" Then
		'
    '    Dim iFileName
    '    iFileName = iFile(i).ShortSaveName
    '    
		'		Set Image = Server.CreateObject("TABSUpload4.Image")
		'
		'		Status = Image.Load(iFileName)
		'
		'		If Status = Ok Then
		'
		'		ImgWidth = Image.Width
		'		ImgHeight = Image.Height
		'
		'		End If
		'
    '    Dim LCnt1
    '    LCnt1 = 0
		'		
    '    LSQL1 = "EXEC AD_tblADImageInfo_PDS_M '" & iType & "','" & MSeq & "','" & iSportsGb & "','" & ImgURL & "','" & Subject & "','" & ImageType & "','" & iFileName & "','" & BColor & "','" & ImgFileExt & "','" & ImgWidth & "','" & ImgHeight & "','" & LocateGb & "','" & txtMemo & "','" & ViewYN & "','" & ID & "','','','','',''"
	  '    response.Write "LSQL1=LSQL1=LSQL1="&LSQL1&"<br>"
    '    response.End
  	'		
    '    Set LRs = DBCon6.Execute(LSQL1)
		'		
    '    If Not (LRs.Eof Or LRs.Bof) Then
		'		
		'      Do Until LRs.Eof
    '  	
    '          LCnt1 = LCnt1 + 1
		'		
    '        LRs.MoveNext
		'      Loop
		'		
	  '    End If
		'		
    '    LRs.close
		'
    '  End If
		'
		'Next

		AD_DBClose()

		if iCodeMod = "YESINS" then

			response.Write "<script type='text/javascript'>alert('배너 이미지 등록이 잘 돼었습니다.');location.href='./AD_BN_IMG_List.asp';</script>"
			response.End

		elseif iCodeMod = "YESMOD" then

			response.Write "<script type='text/javascript'>alert('배너 이미지 수정이 잘 돼었습니다.');location.href='./AD_BN_IMG_List.asp';</script>"
			response.End

		elseif iCodeMod = "YVIEWYNMOD" then

			response.Write "<script type='text/javascript'>alert('광고 연결 관리에서 이미지가 사용 중입니다.\n사용유무 수정을 제외한 수정이 잘 돼었습니다.');location.href='./AD_BN_IMG_List.asp';</script>"
			response.End

		else
    
			response.Write "<script type='text/javascript'>alert('배너 이미지 등록에 오류가 있습니다.');location.href='./AD_BN_IMG_List.asp';</script>"
			response.End

		end if

  Else
  
		AD_DBClose()

    response.Write "<script type='text/javascript'>alert('배너 이미지 등록에 오류가 있습니다.');location.href='./AD_BN_IMG_List.asp';</script>"
    response.End
  
  End If

%>