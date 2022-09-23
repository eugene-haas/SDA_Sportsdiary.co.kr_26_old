<!--#include file="../dev/dist/config.asp"-->
<!--#include virtual = "/dev/dist/common_xFso.asp"-->
<!--#include virtual = "/dev/dist/common_xTabsFileUp.asp"-->
<!--METADATA TYPE="typelib"  NAME="ADODB Type Library" UUID= "00000205-0000-0010-8000-00AA006D2EA4" -->
<object runat="Server" PROGID="ADODB.Command" Id="objCmd" VIEWASTEXT></object>
<%
	'===================================================================================================================================
    'PAGE : /Main_HP/cert_regist_info_proc.asp
    'DATE : 2018년 04월 18일
    'DESC : [관리자] 증명서발급 정보관리 처리
    '===================================================================================================================================
    Dim gRow, gSQL, sRow, i, ry, intNum, Buff, Cnt 
    Dim ArrayDel, ArrayDelCnt
    Dim CertInfoIDX, CertWitness, CertDirector, CertPrice, CertFile, CertWFile, CertDFile
    Dim ListPage, ViewPage, WritePage
    Dim iLoginID
    Dim xUpPath, yUpPrevPK, yUpOObject

    ' 로그인 체크
    Check_AdminLogin()

    ListPage    = "/Main_HP/cert_regist_info.asp"
    ViewPage    = "/Main_HP/cert_regist_info.asp"
    WritePage   = "/Main_HP/cert_regist_info.asp"

    ' 로그인 아이디, 이름
    iLoginID = decode(fInject(Request.cookies("UserID")), 0)
    Name = fInject(Request.cookies("UserName"))

    ' 업로드 사이즈 제한(MB)
    xUpLimitSize    = 10                    ' 기본 세팅 사이즈 제한값보다 큰값이 업로드 될경우 404 에러 발생.
    xUpPath         = global_filepathImg

    ' 업로드 객체 생성
    Call xUpTabsInstCreate(xUpPath, xUpLimitSize)

    If xTabsInst.Form("pType") = "" Then ProcType = "W" Else ProcType = fInject(Trim(xTabsInst.Form("pType")))
    If xTabsInst.Form("idx") = "" Then CertInfoIDX = 0 Else CertInfoIDX = crypt.DecryptStringENC(fInject(Trim(xTabsInst.Form("idx"))))
	If xTabsInst.Form("CertPrice") = "" Or IsNumeric(Trim(xTabsInst.Form("CertPrice"))) = false Then CertPrice = 0 Else CertPrice = CDbl(xTabsInst.Form("CertPrice"))	

    CertWitness         = fInject(Trim(xTabsInst.Form("CertWitness")))
    CertDirector        = fInject(Trim(xTabsInst.Form("CertDirector")))

    'Response.Write "ProcType: "& ProcType &"<br />"
    'Response.Write "CertInfoIDX: "& CertInfoIDX &"<br />"
    'Response.Write "CertWitness: "& CertWitness &"<br />"
    'Response.Write "CertDirector: "& CertDirector &"<br />"
    'Response.Write "CertPrice: "& CertPrice &"<br />"   
    'Response.End

    '첨부파일 업로드
    Call xUpTabsUpload2(xUpPath, xTabsInst.Form("yUpStateFlag"), xTabsInst.Form("yUpPrevPK"), xTabsInst.Form("yUpRObject"), xTabsInst.Form("yUpOObject"), xTabsInst.Form("xUpRObject"), xUpLimitSize, xTabsInst.Form("xUpCondition"), "N", ListPage)

    'Response.Write "xUpPath: "& xUpPath &"<br />"
    'Response.Write "yUpStateFlag: "& xTabsInst.Form("yUpStateFlag") &"<br />"
    'Response.Write "yUpPrevPK: "& xTabsInst.Form("yUpPrevPK") &"<br />"
    'Response.Write "yUpRObject: "& xTabsInst.Form("yUpRObject") &"<br />"
	'Response.Write "yUpRObject: "& xTabsInst.Form("yUpRObject") &"<br />"
    'Response.Write "xUpCondition: "& xTabsInst.Form("xUpCondition") &"<br /><br />"
    'Response.Write "xSaveFileDBPK: "& xSaveFileDBPK &"<br />"
    'Response.Write "xSaveFileDBAction: "& xSaveFileDBAction &"<br />"
    'Response.Write "xSaveFileONameStr: "& xSaveFileONameStr &"<br />"
    'Response.Write "xSaveFileNNameStr: "& xSaveFileNNameStr &"<br />"
    'Response.Write "xSaveFileSizeStr: "& xSaveFileSizeStr &"<br />"
    'Response.End
	
	If Split(xSaveFileNNameStr, "**")(0) <> "" Then
		CertWFile = Split(xSaveFileNNameStr, "**")(0)
	Else
		CertWFile = ""
	End If

	If Split(xSaveFileNNameStr, "**")(1) <> "" Then
		CertDFile = Split(xSaveFileNNameStr, "**")(1)
	Else
		CertDFile = ""
	End If

	If Split(xSaveFileNNameStr, "**")(2) <> "" Then
		CertFile = Split(xSaveFileNNameStr, "**")(2)
	Else
		CertFile = ""
	End If
	'Response.Write "CertWFile = "& CertWFile &"<br />"
	'Response.Write "CertDFile = "& CertDFile &"<br />"
	'Response.Write "CertFile = "& CertFile &"<br />"
	'Response.End

    ' 업로드 객체 제거
    Call xUpTabsInstDelete()

	With objCmd
		.ActiveConnection = DBCon
		.CommandType  = adCmdStoredProc

		.CommandText  = "SP_ADM_TBLONLINECERTIFICATEINFO_UPDATE"

		.Parameters.Append .CreateParameter("@CertInfoIDX", adBigInt, adParamInput, 20, CertInfoIDX)
		.Parameters.Append .CreateParameter("@CertWitness", adVarWChar, adParamInput, 20, CertWitness)
		.Parameters.Append .CreateParameter("@CertDirector", adVarWChar, adParamInput, 20, CertDirector)
		.Parameters.Append .CreateParameter("@CertPrice", adInteger, adParamInput, 4, CertPrice)
		.Parameters.Append .CreateParameter("@CertFile", adVarWChar, adParamInput, 100, CertFile)
        .Parameters.Append .CreateParameter("@CertWFile", adVarWChar, adParamInput, 100, CertWFile)
        .Parameters.Append .CreateParameter("@CertDFile", adVarWChar, adParamInput, 100, CertDFile)
		.Parameters.Append .CreateParameter("@RTN_ERROR",adChar, adParamOutput, 1, "")

		.Execute, ,adExecuteNoRecords

		RTN_ERROR = .Parameters("@RTN_ERROR")

		For ry = .Parameters.Count - 1 to 0 Step -1
			.Parameters.Delete(ry)
		Next
	End With
    Call DbClose()
	
	If RTN_ERROR = "S" Then
		Response.Write "<script type='text/javascript'>alert('글 수정이 잘 되었습니다.');location.replace('"& ListPage &"');</script>"
	    Response.End
	Else
		Response.Write "<script type='text/javascript'>alert('글 수정에 오류가 있습니다.');location.replace('"& ListPage &"');</script>"
	    Response.End
	End If 
%>