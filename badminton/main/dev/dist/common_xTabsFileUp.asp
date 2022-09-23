<%
	'==============================================================================================================================
	'CODE : 업로드 함수(TABS)
	'DESC : 업로드시 제약조건 설정 및 업로드 사용함수(FSO 컨트롤 파일과 같이 쓰임, 삭제와 폴더생성을 FSO진행)
	'       1. 파일 마인타입
	'       2. 파일 확장자
	'       3. 파일 용량
	'==============================================================================================================================

	Dim xTabsInst, xTabsProg, xTabsProgID, xTabsDown
	Dim xErrFileName, xErrScript
	Dim xSaveFileDBPK, xSaveFileDBAction, xSaveFileONameStr, xSaveFileNNameStr, xSaveFileSizeStr

	'xUpPath : 업로드 경로(물리적경로)
	'xUpObj : 업로드된 파일객체
	'yUpName : 기존업로드된 파일명
	'xUpSize : 업로드시 파일용량제한(단위 : MByte)
	'xCondiSet : 업로드파일 제약조건(기본제약 : 스크립트에 관련된 파일모두 차단)
	'xBackUrl : 업로드 에러발생시 이전페이지로 돌아가기위한 주소(쿼리스트링으로 페이지초기화 값추가)

	xErrScript = "YK"       '기본값(성공)
	xErrFileName = ""       '기본값(성공했으므로 에러파일이 없음)

	'업로드 객체생성
	Sub xUpTabsInstCreate(xUpPath, xUpMaxByte)
		'Tab Upload 4.5 업로드 컴포넌트
	    Set xTabsInst = Server.CreateObject("TABSUpload4.Upload")

	    xTabsInst.CodePage = 65001
	    xTabsInst.MaxBytesToAbort = xUpMaxByte * 1024 * 1024
	    xTabsInst.Start xUpPath
	End Sub

	'업로드 객체삭제
	Sub xUpTabsInstDelete()
	    Set xTabsInst = Nothing
	End Sub

	'다운로드 객체생성
	Sub xUpTabsDownLoad()
	    Set xTabsDown = Server.CreateObject("TABSUpload4.Download")
	End Sub

	'다운로드 객체삭제
	Sub xUpTabsDownDelete()
	    Set xTabsDown = Nothing
	End Sub

	'MineType검사(중복체크)
	Function xUpTabsMinType(xUpMethod, xCondiSet)
	    Dim zMineArray, zMineArrayCnt, zMineRtnVal
	    Dim xRtnVal
	    Dim x
	    Dim j

	    xRtnVal = true
	    If InStr(xCondiSet, ",") > 0 Then
	        zMineArray = Split(xCondiSet, ",")
	        zMineArrayCnt = Ubound(zMineArray,1)

	        j = 0
	        For x = 0 to zMineArrayCnt
	            zMineRtnVal = xUpMineType(xUpMethod, Trim(zMineArray(x)))
	            If zMineRtnVal = true Then
	                j = j + 1
	            End If
	        Next

	        If j = 0 Then
                xRtnVal = false
            End If
	    Else
	        xRtnVal = xUpMineType(xUpMethod, xCondiSet)
	    End If

	    xUpTabsMinType = xRtnVal
	End Function

	'확장자 검사(허용목록)
	Function xUpFileTypePos(xUpFileType, xCondiSet)
	    Dim xRtnVal

	    Select Case xCondiSet
	        Case "DOC"
	            Select Case xUpFileType
	                Case "xls", "xlsx", "ppt", "pptx", "doc", "docx", "hwp", "pdf"
	                    xRtnVal = true
	                Case Else
	                    xRtnVal = false
	            End Select
			Case "IMG"
	            Select Case xUpFileType
	                Case "jpg", "gif", "png", "JPG", "GIF", "PNG"
	                    xRtnVal = true
	                Case Else
	                    xRtnVal = false
	            End Select
			Case "ETC"
				Select Case xUpFileType
	                Case "xls", "xlsx", "ppt", "pptx", "doc", "docx", "hwp", "pdf", "jpg", "gif", "png", "zip"
	                    xRtnVal = true
	                Case Else
	                    xRtnVal = false
	            End Select
	    End Select

	    xUpFileTypePos = xRtnVal
	End Function

	'MineType검사(체크)
	Function xUpMineType(xUpMethod, xCondiSet)
	    Dim yRtnVal

	    yRtnVal = true

	    'MineType에 맞게 검사
		If xUpFileTypePos(xUpMethod.FileType, xCondiSet) = False Then
			Select Case xCondiSet
				Case "IMG"
					xErrScript = "NI"
				Case "DOC"
					xErrScript = "ND"
				Case "ETC"
					xErrScript = "NE"
			End Select
			xErrFileName = xUpMethod.FileName
			yRtnVal = false
	    End If

	    xUpMineType = yRtnVal
	End Function

	'유효성검사가 오류인경우 메세지 출력함수
	Sub xUpTabsErr(xErrScript, xBackUrlStyle, xBackUrl)
	    Dim xRtnValMsg
	    Dim xScript

        Select Case xErrScript
            Case "NI"
                xRtnValMsg = "이미지형식의 파일이 아닙니다."
            Case "NV"
                xRtnValMsg = "동영상형식의 파일이 아닙니다."
            Case "NA"
                xRtnValMsg = "오디오형식의 파일이 아닙니다."
            Case "ND"
                xRtnValMsg = "문서형식의 파일이 아닙니다."
            Case "NE"
                xRtnValMsg = "첨부하신 파일은 업로드가 불가능합니다."
            Case "SE"
                xRtnValMsg = "파일용량제한을 초과한 파일입니다."
        End Select
        xRtnValMsg = xRtnValMsg & " 업로드가 취소되었습니다."

        xScript = ""
		Select Case xBackUrlStyle
			Case "N"
				xScript = xScript & "<script type=""text/javascript"">" & CHR(13)
				xScript = xScript & "alert(""" & xRtnValMsg & """);" & CHR(13)
				xScript = xScript & "location.replace(""" & xBackUrl & """);" & CHR(13)
				xScript = xScript & "</script>"
			Case "F"
				xScript = xScript & "<script type=""text/javascript"">" & CHR(13)
				xScript = xScript & "alert(""" & xRtnValMsg & """);" & CHR(13)
				xScript = xScript & "parent.location.replace(""" & xBackUrl & """);" & CHR(13)
				xScript = xScript & "</script>"
			Case "A"
				xScript = xScript & xRtnValMsg
		End Select
        Response.Write xScript
        Response.End
	End Sub

	'파일용량 검사
	Function xUpTabsFileSize(xUpMethod, xUpSize)
	    Dim xRtnVal
	    Dim xUpSizeByte

        xUpSizeByte = xUpSize * 1024 * 1024
        If xUpMethod.FileSize > xUpSizeByte Then
            xErrScript = "SE"
            xErrFileName = xUpMethod.FileName
            xRtnVal = false
        Else
            xRtnVal = true
        End If

	    xUpTabsFileSize = xRtnVal
	End Function

	'파일명다시 만들기(7자리 난수 발생함수)
	Function RandomNumberMake()
	    Dim RandomNumber
	    Dim Number_Start, Number_End

	    Randomize

	    Number_Start = 1000000
	    Number_End = 9999999
	    RandomNumber = INT((Number_End - Number_Start + 1) * Rnd + Number_Start)

	    RandomNumberMake = RandomNumber
	End Function

	'파일명다시 만들기(년/월/일/시/분/초/랜덤숫자7자리)
    Function xUpTabsMakeFileName()
		Dim RtnVal
		Dim MiliSecond, DateTimeStr, RandomNumber

		MiliSecond = Split(Cstr(FormatNumber(Timer(),2)),".")
		DateTimeStr = Cstr(Year(Now())) & Right(Cstr(100 + Month(Now())),2) & Right(Cstr(100 + Day(Now())),2) & Right(Cstr(100 + Hour(Now())),2) & Right(Cstr(100 + Minute(Now())),2) & Right(Cstr(100 + Second(Now())),2)
		RandomNumber = RandomNumberMake()

		RtnVal = DateTimeStr & Right(Cstr(100 + Cint(MiliSecond(1))),2) & RandomNumber

		xUpTabsMakeFileName = RtnVal
    End Function

	'업로드이전 제약사항 체크
	Function xUpTabsInsp(xUpObj, xUpSize, xCondiSet)
	    Dim y
	    Dim xUpMethod
	    Dim xRtnVal

        xRtnVal = true
        y = 1
	    For Each xUpMethod IN xUpObj
	        If xUpObj(y) <> "" Then
	            '용량검사
	            If xUpTabsFileSize(xUpMethod, xUpSize) = false Then
	                xRtnVal = false
	                Exit For
	            End If

	            'MineType 및 확장자 검사
	            If xUpTabsMinType(xUpMethod, xCondiSet) = false Then
	                xRtnVal = false
	                Exit For
	            End If
	        End If
	        y = y + 1
	    Next
	    xUpTabsInsp = xRtnVal
	End Function

	'업로드 함수
	Function xUpTabsUpload(xUpPathRoot, yUpStateFlag, yUpPrevPK, yUpRObject, xUpRObject, xUpLimitSize, xUpCondition, xUpReturnStyle, xUpReturnURL)
	    Dim zy
	    Dim xUpPathPhyRoot, xUpRObjectCnt
	    Dim xUpFileNameOrg, xUpFileNameOrgExt, xUpFileNameNew

	    If xUpTabsInsp(xUpRObject, xUpLimitSize, xUpCondition) = false Then
	        '업로드 불가(1개의 파일이라도 이상이 있는경우 전체 업로드 실행안됨)
	        '에러메세지 처리
	        Call xUpTabsErr(xErrScript, xUpReturnStyle, xUpReturnURL)
	    Else
	        '업로드 가능(첨부한 파일만 처리)
	        For zy = 1 to xUpRObject.Count
	            If xUpRObject(zy) <> "" Then
	                'PK번호
                    xSaveFileDBPK = xSaveFileDBPK & yUpPrevPK(zy) & "**"

                    Select Case yUpStateFlag(zy)
	                    Case "W", "R"
                            xSaveFileDBAction = xSaveFileDBAction & yUpStateFlag(zy) & "**"
	                    Case "M"
	                        If yUpRObject(zy) <> "" Then
	                            '수정시(기존 파일 삭제후 업로드)
	                            Call xUpTabsDelete(xUpPathRoot, yUpRObject(zy))
	                            xSaveFileDBAction = xSaveFileDBAction & yUpStateFlag(zy) & "**"
	                        Else
	                            '수정시(입력)
	                            xSaveFileDBAction = xSaveFileDBAction & "W" & "**"
	                        End If
	                End Select

	                xUpFileNameOrg = xUpRObject(zy).FileName
	                xUpFileNameOrg = Replace(xUpFileNameOrg,"&","_")
	                xUpFileNameOrg = Replace(xUpFileNameOrg,"%","_")
	                xUpFileNameOrgExt = xUpRObject(zy).FileType
	                xUpFileNameNew = xUpTabsMakeFileName() & "." & xUpFileNameOrgExt
	                xUpPathPhyRoot = xUpPathRoot & "\" & xUpFileNameNew

	                '업로드
	                xUpRObject(zy).SaveAs xUpPathPhyRoot, false

	                '파일 데이터 배열삽입
	                xSaveFileONameStr = xSaveFileONameStr & xUpFileNameOrg & "**"
		            xSaveFileNNameStr = xSaveFileNNameStr & xUpFileNameNew & "**"
		            xSaveFileSizeStr = xSaveFileSizeStr & xUpRObject(zy).FileSize & "**"
	            Else
	                If yUpStateFlag(zy) = "D" Then
	                    '삭제만 하는 경우
	                    Call xUpTabsDelete(xUpPathRoot, yUpRObject(zy))

	                    'PK번호
	                    xSaveFileDBPK = xSaveFileDBPK & yUpPrevPK(zy) & "**"

	                    '데이터베이스 처리형태
	                    xSaveFileDBAction = xSaveFileDBAction & yUpStateFlag(zy) & "**"
	                    xSaveFileONameStr = xSaveFileONameStr & "" & "**"
		                xSaveFileNNameStr = xSaveFileNNameStr & "" & "**"
		                xSaveFileSizeStr = xSaveFileSizeStr & "0" & "**"
	                End If
	            End If
	        Next
	    End If
	End Function

	'업로드 함수(순차적으로)
	Function xUpTabsUpload2(xUpPathRoot, yUpStateFlag, yUpPrevPK, yUpRObject, yUpOObject, xUpRObject, xUpLimitSize, xUpCondition, xUpReturnStyle, xUpReturnURL)
	    Dim zy
	    Dim xUpPathPhyRoot, xUpRObjectCnt
	    Dim xUpFileNameOrg, xUpFileNameOrgExt, xUpFileNameNew

	    If xUpTabsInsp(xUpRObject, xUpLimitSize, xUpCondition) = false Then
	        '업로드 불가(1개의 파일이라도 이상이 있는경우 전체 업로드 실행안됨)
	        '에러메세지 처리
	        Call xUpTabsErr(xErrScript, xUpReturnStyle, xUpReturnURL)
	    Else
	        '업로드 가능(첨부한 파일만 처리)
	        For zy = 1 to xUpRObject.Count
	            If xUpRObject(zy) <> "" Then
	                'PK번호
                    xSaveFileDBPK = xSaveFileDBPK & yUpPrevPK(zy) & "**"

                    Select Case yUpStateFlag(zy)
	                    Case "W", "R"
                            xSaveFileDBAction = xSaveFileDBAction & yUpStateFlag(zy) & "**"
	                    Case "M"
	                        If yUpRObject(zy) <> "" Then
	                            '수정시(기존 파일 삭제후 업로드)
	                            Call xUpTabsDelete(xUpPathRoot, yUpRObject(zy))
	                            xSaveFileDBAction = xSaveFileDBAction & yUpStateFlag(zy) & "**"
	                        Else
	                            '수정시(입력)
	                            xSaveFileDBAction = xSaveFileDBAction & "W" & "**"
	                        End If
	                End Select

	                xUpFileNameOrg = xUpRObject(zy).FileName
	                xUpFileNameOrg = Replace(xUpFileNameOrg,"&","_")
	                xUpFileNameOrg = Replace(xUpFileNameOrg,"%","_")
	                xUpFileNameOrgExt = xUpRObject(zy).FileType
	                xUpFileNameNew = xUpTabsMakeFileName() & "." & xUpFileNameOrgExt
	                xUpPathPhyRoot = xUpPathRoot & "\" & xUpFileNameNew

	                '업로드
	                xUpRObject(zy).SaveAs xUpPathPhyRoot, false

	                '파일 데이터 배열삽입
	                xSaveFileONameStr = xSaveFileONameStr & xUpFileNameOrg & "**"
		            xSaveFileNNameStr = xSaveFileNNameStr & xUpFileNameNew & "**"
		            xSaveFileSizeStr = xSaveFileSizeStr & xUpRObject(zy).FileSize & "**"
	            Else
	                If yUpStateFlag(zy) = "D" Then
	                    '삭제만 하는 경우
	                    Call xUpTabsDelete(xUpPathRoot, yUpRObject(zy))

	                    'PK번호
	                    xSaveFileDBPK = xSaveFileDBPK & yUpPrevPK(zy) & "**"

	                    '데이터베이스 처리형태
	                    xSaveFileDBAction = xSaveFileDBAction & yUpStateFlag(zy) & "**"
	                    xSaveFileONameStr = xSaveFileONameStr & "" & "**"
		                xSaveFileNNameStr = xSaveFileNNameStr & "" & "**"
		                xSaveFileSizeStr = xSaveFileSizeStr & "0" & "**"
					Else
						If yUpPrevPK(zy) > "" Then
							xSaveFileDBPK = xSaveFileDBPK & yUpPrevPK(zy) & "**"
						Else
							xSaveFileDBPK = xSaveFileDBPK & "**"
						End If
						xSaveFileDBAction = xSaveFileDBAction & "**"
	                    xSaveFileONameStr = xSaveFileONameStr & yUpOObject(zy) & "**"
		                xSaveFileNNameStr = xSaveFileNNameStr & yUpRObject(zy) &"**"
		                xSaveFileSizeStr = xSaveFileSizeStr & "0" & "**"
	                End If
	            End If
	        Next
	    End If
	End Function

	'첨부파일 삭제함수
	Sub xUpTabsDelete(xUpPathRoot, xName)
	    Call OpenFso()
	    Call xFsoDeFile(xUpPathRoot, xName)
	    Call CloseFso()
	End Sub

	'결과 배열
	Function StrSplit(Str1, ExpWord)
	    Dim RtnVal

	    RtnVal = Split(Str1,ExpWord)

	    StrSplit = RtnVal
	End Function
%>
