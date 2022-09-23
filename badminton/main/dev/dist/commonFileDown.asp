<!--#include virtual = "/dev/dist/config.asp"-->
<!--#include virtual = "/dev/dist/common_xFso.asp"-->
<!--#include virtual = "/dev/dist/common_xTabsFileUp.asp"-->
<!--METADATA TYPE="typelib"  NAME="ADODB Type Library" UUID= "00000205-0000-0010-8000-00AA006D2EA4" -->
<object runat="Server" PROGID="ADODB.Command" Id="objCmd" VIEWASTEXT></object>
<%
    '===================================================================================================================================
    'PAGE : /dev/dist/commonFileDown.asp
    'DATE : 2018년 04월 20일
    'DESC : [System] 파일 다운로드(탭스 다운로드 이용)
    '===================================================================================================================================
    Dim gRow, gSQL, sRow, i, ry, intNum, Buff, Cnt 
    Dim ProcType, ColumnType
    Dim FL_IDX
    Dim xUpPath

    ' 로그인 체크
    Check_AdminLogin()

    If Request("pType") = "" Then ProcType = "W" Else ProcType = fInject(Trim(Request("pType")))
	If Request("fType") = "" Then ColumnType = "F" Else ColumnType = fInject(Trim(Request("fType")))
    If Request("idx") = "" Then FL_IDX = 0 Else FL_IDX = crypt.DecryptStringENC(fInject(Trim(Request("idx"))))

    'Response.Write "FL_IDX: "& FL_IDX

    If FL_IDX = "0" Or FL_IDX = "" Then
        Call DbClose()
        Response.End
    End iF

    Select Case ProcType
        Case "C"
            xUpPath = global_filepath

            gSQL = "SELECT MSeq, FileName, FilePath, FileType from Community_Board_Pds_Tbl WITH(NOLOCK) WHERE PSeq = ?"
            With objCmd
                .ActiveConnection = DBCon
                .CommandType  = adCmdText
                .CommandText  = gSQL
                
                .Parameters.Append .CreateParameter("@PSeq", adBigInt, adParamInput, 20, Cdbl(FL_IDX))

                Set gRow = .Execute

                For ry = .Parameters.Count - 1 to 0 Step -1
                    .Parameters.Delete(ry)
                Next
            End With

            If gRow.eof Or gRow.bof Then
                Buff	= Null
                Cnt		= 0
            Else
                Buff	= gRow.getrows
                Cnt		= UBound(Buff,2)
            End If
            Set gRow = Nothing
            Call DbClose()

            If IsNull(Buff) = False Then
                For i=0 To Cnt
                    MSeq            = Cdbl(Buff(0, i))
                    FileName        = Trim(Buff(1, i))
                    FilePath        = Trim(Buff(2, i))
                    FileType        = Trim(Buff(3, i))

                    Call OpenFso()
                    If xFsoSrFile(xUpPath, FileName) Then
                        ' 다운로드 객체 생성
                        Call xUpTabsDownLoad()

                        xTabsDown.FilePath = xUpPath &"\"& FileName
                        xTabsDown.FileName = FilePath
                        xTabsDown.TransferFile True

                        ' 다운로드 객체 제거
                        Call xUpTabsDownDelete()
                    Else
                        Response.Write "<script type='text/javascript'>alert('첨부파일이 없습니다.');location.replace('/');</script>"
                        Response.End
                    End If 
                    Call CloseFso()
                Next
            End If
		Case "E"
            xUpPath = global_filepathImg

            gSQL = "SELECT CertFile, CertWFile, CertDFile"
			gSQL = gSQL &" from [dbo].[tblOnlineCertificateInfo] WITH(NOLOCK) WHERE CertInfoIDX = ?" 

            With objCmd
                .ActiveConnection = DBCon
                .CommandType  = adCmdText
                .CommandText  = gSQL
                
                .Parameters.Append .CreateParameter("@CertInfoIDX", adBigInt, adParamInput, 20, Cdbl(FL_IDX))

                Set gRow = .Execute

                For ry = .Parameters.Count - 1 to 0 Step -1
                    .Parameters.Delete(ry)
                Next
            End With

            If gRow.eof Or gRow.bof Then
                CertFile	= ""
				CertWFile	= ""
				CertDFile	= ""
            Else
                CertFile	= Trim(gRow(0))
				CertWFile	= Trim(gRow(1))
				CertDFile	= Trim(gRow(2))
            End If
            Set gRow = Nothing
            Call DbClose()

			Select Case ColumnType
				Case "F"
					DownFileName = CertFile
				Case "W"
					DownFileName = CertWFile
				Case "D"
					DownFileName = CertDFile
			End Select 

			Call OpenFso()
			If xFsoSrFile(xUpPath, DownFileName) Then
				' 다운로드 객체 생성
				Call xUpTabsDownLoad()

				xTabsDown.FilePath = xUpPath &"\"& DownFileName
				xTabsDown.FileName = DownFileName
				xTabsDown.TransferFile True

				' 다운로드 객체 제거
				Call xUpTabsDownDelete()
			Else
				Response.Write "<script type='text/javascript'>alert('첨부파일이 없습니다.');location.replace('/');</script>"
				Response.End
			End If 
			Call CloseFso()
    End Select
%>