
<!--#include virtual="/Manager/Library/config.asp"-->
<%
	Response.Buffer=true
%>
<%
'Tab Upload 4.5 업로드 컴포넌트를 생성합니다.
Set Upload = Server.CreateObject("TABSUpload4.Upload")

'업로드 크기 제한 (최대크기 10MB =  10 * 1024 * 1024)	
'Upload.MaxBytesToAbor = 10 * 1024 *1024 '10MB 로 제한

SavePath   = "D:\sportsdiary.co.kr\manager\upload\xls"

Upload.Start SavePath, False
'파일이 저장되는 경로

Set upFile = Upload.Form("attachfile")

'작업일
work_dt = Year(now)&AddZero(Month(now))&AddZero(Day(now))

ExtensionType = upFile.FileType

If upFile <> "" Then 
	'파일 확장자 체크
	If LCase(ExtensionType) = "xls" Or LCase(ExtensionType) = "xlsx" Then 
		upFile.Save "D:\sportsdiary.co.kr\manager\upload\xls",False
	Else
		Response.Write "<script>alert('xls,xlsx 파일만 업로드 가능합니다.');history.back();</script>"
		Response.End
	End If 
Else
	Response.Write "<script>alert('첨부된 파일이 없습니다. 파일 첨부후 이용해 주세요');history.back();</script>"
	Response.End
End If 


'파일 업로드
'파일저장위치 D:\sportsdiary.co.kr\manager\upload\xls

'업로드 파일명
upFileName = upFile.ShortSaveName


If upFileName  <> "" Then 
	Set oFSO = CreateObject( "Scripting.FileSystemObject" )
	filesize = upFile.FileSize
	filePath = upFile.SaveName

			Set XlsConn = Server.CreateObject("ADODB.Connection")
			'server 32bit
			'XlsConn.Open "PROVIDER=MICROSOFT.JET.OLEDB.8.0;DATA SOURCE=" & filePath &";Mode=ReadWrite|Share Deny None; Extended Properties='Excel 8.0; HDR=YES;';Persist Security Info=False"
			'server 64bit
'			XlsConn.Open "PROVIDER=MICROSOFT.ACE.OLEDB.12.0;DATA SOURCE=" & filePath &";Mode=ReadWrite|Share Deny None; Extended Properties='Excel 12.0; HDR=YES;';Persist Security Info=False"
			XlsConn.Open "PROVIDER=MICROSOFT.ACE.OLEDB.12.0;DATA SOURCE=" & filePath &";Mode=ReadWrite|Share Deny None; Extended Properties='Excel 12.0; HDR=YES;';Persist Security Info=False"
			Set XRs = Server.CreateObject("ADODB.RecordSet")
			xSQL = "SELECT 선수번호,성별,소속구분,체급코드,개인전단체전구분 FROM [sheet1$] "
			XRs.Open xSQL, XlsConn, 1, 3
			i = 0
			Response.Write "<table border='1' width='900px'>"
			
			do until XRs.eof
				'팀코드체크
				'플레이어일련번호,소속번호,스포츠구분,소속,성별,사용자명,대회번호
				CSQL = " SELECT P.PlayerIDX AS PlayerIDX , P.NowSchIDX AS SchIDX , P.SportsGb AS SportsGb , S.TeamGb AS TeamGb , P.Sex AS Sex , P.UserName AS UserName , 20 "
				CSQL = CSQL&" FROM tblPlayer P join tblschoollist S"
				CSQL = CSQL&" on P.NowSchIDX = S.SchIDX"
				CSQL = CSQL&" Where P.PlayerCode='"&XRs("선수번호")&"'"
				
				Set CRs = Dbcon.Execute(CSQL)




				If CRs.Eof Or CRs.Bof Then 
					 'Response.Write (CSQL)&"<br>"
					 Response.Write XRs("선수번호")&"<br>"
				Else 
					If XRs("개인전단체전구분") = "개인전" Then 
						GroupGameGb = "sd040001"
					Else
						GroupGameGb = "sd040001"						
					End If 
				  InSQL = "Insert Into tblRPlayerMaster"
					InSQL = InSQL&"("
					InSQL = InSQL&"PlayerIDX"
					InSQL = InSQL&",SchIDX"
					InSQL = InSQL&",SportsGb"
					InSQL = InSQL&",TeamGb"
					InSQL = InSQL&",Sex"
					InSQL = InSQL&",Level"
					InSQL = InSQL&",UserName"
					InSQL = InSQL&",GroupGameGb"
					InSQL = InSQL&",RGameLevelIDX"
					InSQL = InSQL&",GameTitleIDX"
					InSQL = InSQL&",DelYN"
					InSQL = InSQL&")"
					InSQL = InSQL&" VALUES "
					InSQL = InSQL&"("
					InSQL = InSQL&"'"&CRs("PlayerIDX")&"'"
					InSQL = InSQL&",'"&CRs("SchIDX")&"'"
					InSQL = InSQL&",'"&CRs("SportsGb")&"'"
					InSQL = InSQL&",'"&CRs("TeamGb")&"'"
					InSQL = InSQL&",'"&CRs("Sex")&"'"
					InSQL = InSQL&",'"&XRs("체급코드")&"'"
					InSQL = InSQL&",'"&CRs("UserName")&"'"
					InSQL = InSQL&",'"&GroupGameGb&"'"
						
						ASQL = "SELECT RGameLevelIDX FROM tblRGameLevel WHERE Level='"&XRs("체급코드")&"' AND GameTitleIDX='20'"
						Set ARs = Dbcon.Execute(ASQL)
					
					InSQL = InSQL&",'"&ARs("RGameLevelIDX")&"'"
					InSQL = InSQL&",'20'"
					InSQL = InSQL&",'N'"
					InSQL = InSQL&")"
'					Response.Write InSQL&"<br>"
'					Response.End
					Dbcon.Execute(InSQL)


						
					
				End If 
					CRs.close
					Set CRs = Nothing 	
		
%>				
<%			XRs.MoveNext
			Loop 
			Response.Write "</table>"

End If 
%>
<script>
alert("<%=i%>")
</script>