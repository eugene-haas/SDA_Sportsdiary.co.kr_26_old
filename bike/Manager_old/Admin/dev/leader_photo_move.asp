<%@ Language=VBScript CodePage = 65001  %>
<!--METADATA TYPE="typelib"  NAME="ADODB Type Library UUID= "00000205-0000-0010-8000-00AA006D2EA4" -->
<object runat="Server" PROGID="ADODB.Connection" Id="objCon" VIEWASTEXT></object>
<object runat="Server" PROGID="ADODB.Command" Id="objCmd" VIEWASTEXT></object>
<%
	'===================================================================================================================================
    'PAGE : /dev/player_photo_move.asp
    'DATE : 2018년 06월 01일
    'DESC : [관리자] 기존 선수 사진 이동
    '===================================================================================================================================
	Response.AddHeader "Pragma", "no-cache"
	Response.CacheControl = "no-cache"
	Response.Expires = -1
	Response.Charset = "UTF-8"
	Session.CodePage = 65001

	CONST CnStr_DS = "115.68.112.26"
	CONST CnStr_IC = "KoreaBadminton"
	CONST CnStr_ID = "sportsdiary"
	CONST CnStr_PW = "dnlemfkdls715)@*@"

	Dim objCn_Str

	objCn_Str = "Provider=SQLOLEDB.1;Persist Security Info=False;User ID=" & CnStr_ID & ";password=" & CnStr_PW & ";Initial Catalog=" & CnStr_IC & ";Data Source=" & CnStr_DS

	'데이터베이스 연결
	Sub DbOpen()
		objCon.Open (objCn_Str)
	End Sub
	
	'객체닫기
	Sub DbClose()
		objCon.Close
	End Sub
%>
<!--#include virtual="/dev/dist/common_xFso.asp"-->
<%
    Dim gRow, i, ry, intNum, Buff, Cnt, SysBuff, SysCnt
	Dim xUpPathBefore, xUpPathAfter
	Dim pl3_photo

	xUpPathAfter	= "D:\HP\koreabadminton.org\FileDown\Leader"
	xUpPathBefore	= "D:\badminton_before\people_photo"
	
	If Request.QueryString("dkduq87376189zaji") <> "alknxcvlksjdflkj234" Then
		Response.End
	End If 

	Call DbOpen()
	With objCmd
		.ActiveConnection = objCon
		.CommandType  = adCmdStoredProc

		.CommandText  = "SP_SYS_TBLLEADERINFO"

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
	Call DBClose()

	Call OpenFso()
	For i=O To Cnt
		pl3_photo		= Trim(Buff(0, i))
		
		'파일이 존재할 경우
		If xFsoSrFile(xUpPathBefore, pl3_photo) Then
			'Response.Write xUpPathBefore &"\"& pl3_photo &"이 있다<br />"
			
			' 파일이 xUpPathAfter 경로에 있는지 확인, 없으면 이동
			If xFsoSrFile(xUpPathAfter, pl3_photo) = False Then
				'Response.Write xUpPathAfter &"\"& pl3_photo &"이 없다<br />"

				objCmFso.CopyFile xUpPathBefore &"\"& pl3_photo, "D:\HP\koreabadminton.org\FileDown\Leader\B\"
				'Set objFile = objCmFso.GetFile()
			End If 
		End If 
	Next
	Call CloseFso()
%>