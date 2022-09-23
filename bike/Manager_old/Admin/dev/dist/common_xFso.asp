<%
    '==============================================================================================================================
	'CODE : FSO 함수
	'==============================================================================================================================

    Dim objCmFso    
    
    'FSO객체 생성
    Sub OpenFso()
        Set objCmFso = Server.CreateObject("Scripting.FileSystemObject")
    End Sub
    
    'FSO객체 삭제
    Sub CloseFso()
        Set objCmFso = Nothing
    End Sub
    
    '절대경로를 물리적경로로 변경
    Function xFsoMapPath(xArgPath)
        Dim xyRtnVal
        
        xyRtnVal = Server.MapPath(xArgPath)
        xFsoMapPath = xyRtnVal
    End Function

    '경로에 폴더 검색함수
    Function xFsoSrFolder(xArgPath)
        Dim xyRtnVal
    
        xyRtnVal = objCmFso.FolderExists(xArgPath)

        xFsoSrFolder = xyRtnVal
    End Function
    
    '경로에 폴더 생성함수
    Sub xFsoCrFolder(xArgPath)
        Dim xyRtnVal 
        
        If xFsoSrFolder(xArgPath) = false Then
            objCmFso.CreateFolder(xArgPath)
        End If
    End Sub
    
    '경로에 폴더삭제 함수
    Sub xFsoDeFolder(xArgPath)
        Dim xyRtnVal
        
        If xFsoSrFolder(xArgPath) = false Then
            objCmFso.DeleteFolder(xArgPath)
        End If
    End Sub
    
    '해당 경로에 파일검색 함수
    Function xFsoSrFile(xArgPath, xArgName)
        Dim xyRtnVal
        Dim xyRoot
        
        xyRoot = xArgPath & "\" & xArgName
        xyRtnVal = objCmFso.FileExists(xyRoot)
        
        xFsoSrFile = xyRtnVal
    End Function
    
    '해당 경로에 파일삭제 함수
    Sub xFsoDeFile(xArgPath, xArgName)
        Dim xyRtnVal
        Dim xyRoot
        
        xyRoot = xArgPath & "\" & xArgName

        If xFsoSrFile(xArgPath, xArgName) = true Then
            objCmFso.DeleteFile(xyRoot)
        End If
    End Sub
    
    'HTML 파일 읽어들이기
    Function xFsoFileRead(xAbsEx, xName)
        Dim xAbs, xLineStr
        Dim objCmFsoOpen
        xAbs = xFsoMapPath(xAbsEx) &"\"& xName

        Call OpenFso()
        Set objCmFsoOpen = objCmFso.OpenTextFile(xAbs)
        
        '한줄씩 출력
        Do While Not objCmFsoOpen.AtEndOfStream
		    xLineStr = xLineStr & objCmFsoOpen.ReadLine & CHR(13) & CHR(10)
		Loop
	
        Set objCmFsoOpen = Nothing
        Call CloseFso()
        
        xFsoFileRead = xLineStr
    End Function
%>
