
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
			xSQL = "SELECT * FROM [sheet1$] "
			XRs.Open xSQL, XlsConn, 1, 3
			i = 0
			Response.Write "<table border='1' width='900px'>"
			
			do until XRs.eof
				'팀코드체크
				CSQL = "SELECT PlayerCode FROM tblPlayer WHERE PlayerCode='"&XRs("선수번호")&"'"
				'Response.Write (CSQL)
				Set CRs = Dbcon.Execute(CSQL)

				'학교IDX찾기
				CSQL2 = "SELECT SchIDX FROM tblSchoolList WHERE SchoolName='"&XRs("팀명")&"' AND ZoneCode='"&XRs("시도")&"'"
				Set CRs2 = Dbcon.Execute(CSQL2)


				If CRs.Eof Or CRs.Bof Then 
								InSQL = "Insert Into tblPlayer ("
								InSQL = InSQL&" SportsGb"
								InSQL = InSQL&",PlayerGb"
								InSQL = InSQL&",NowSchIDX"
								InSQL = InSQL&",UserName"
								InSQL = InSQL&",UserPhone"
								InSQL = InSQL&",BirthDay"
								InSQL = InSQL&",Sex"
								InSQL = InSQL&",PlayerStartYear"
								InSQL = InSQL&",Tall"
								InSQL = InSQL&",Weight"
								InSQL = InSQL&",[Level]"
								InSQL = InSQL&",BloodType"
								InSQL = InSQL&",UseForHand"
								InSQL = InSQL&",Specialty"
								InSQL = InSQL&",UserID"
								InSQL = InSQL&",UserPass"
								InSQL = InSQL&",Email"
								InSQL = InSQL&",DelYN"
								InSQL = InSQL&",WriteDate"
								InSQL = InSQL&",PlayerCode"
								InSQL = InSQL&")"
								InSQL = InSQL&" VALUES "
								InSQL = InSQL&"("
								InSQL = InSQL&" 'judo'"
								InSQL = InSQL&",'sd039001'"
								InSQL = InSQL&",'"&CRs2("SchIDX")&"'"
								InSQL = InSQL&",'"&XRs("선수명")&"'"
								InSQL = InSQL&",'000-000-0000'"
								InSQL = InSQL&",'"&Replace(XRs("생년월일"),".","-")&"'"
								InSQL = InSQL&",'"&XRs("성별")&"'"
								InSQL = InSQL&",'sd005021'"
								InSQL = InSQL&",'sd006173'"
								InSQL = InSQL&",'sd007068'"
								InSQL = InSQL&",'lv001001'"
								InSQL = InSQL&",'sd009004'"
								InSQL = InSQL&",''"
								InSQL = InSQL&",''"
								InSQL = InSQL&",'"&XRs("선수번호")&"'"
								InSQL = InSQL&",'"&XRs("선수번호")&"'"
								InSQL = InSQL&",''"
								InSQL = InSQL&",'N'"
								InSQL = InSQL&",getdate()"
								InSQL = InSQL&",'"&XRs("선수번호")&"'"
								InSQL = InSQL&")"
								Response.Write InSQL&"<br>"
								Dbcon.Execute(InSQL)

							i = i + 1
				End If 
					CRs.close
					Set CRs = Nothing 
					CRs2.close
					Set CRs2 = Nothing 
	
		
%>				
<%			XRs.MoveNext
			Loop 
			Response.Write "</table>"

End If 
%>
<script>
alert("<%=i%>")
</script>


1263
