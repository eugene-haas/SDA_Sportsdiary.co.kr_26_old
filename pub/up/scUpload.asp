<!--METADATA TYPE= "typelib"  NAME= "ADODB Type Library" FILE="C:\Program Files\Common Files\SYSTEM\ADO\msado15.dll"  -->
<%@ codepage="65001" language="VBScript" %>
<%
	Response.CharSet="utf-8"
	Session.codepage="65001"
	Response.codepage="65001"
	Response.ContentType="text/html;charset=utf-8"

	PAGENAME = LCase(Mid(Request.ServerVariables("URL"), InStrRev(Request.ServerVariables("URL"), "/") + 1))
	If Left(PAGENAME, 3) = "req" Then 'ajax 콜파일만 적용되도록
		Response.Expires = -1
		Response.Expiresabsolute = Now() - 1
		Response.AddHeader "pragma","no-cache"
		Response.AddHeader "cache-control","private"
		Response.CacheControl = "no-cache"
	End if

''######################################
%>
<script language="Javascript" runat="server">
function hasown(obj,  prop){
	if (obj.hasOwnProperty(prop) == true){
		return "ok";
	}
	else{
		return "notok";
	}
}
</script>

<!-- #include virtual = "/pub/cfg/cfg.swimmingAdmin.asp" -->
<!-- #include virtual = "/pub/class/db_helper.asp" -->
<!-- #include virtual = "/pub/fn/fn.sqlinjection.asp" -->
<!-- #include virtual = "/pub/fn/fn.string.asp" -->
<!-- #include virtual = "/pub/fn/fn.util.asp" -->
<!-- #include virtual = "/pub/fn/fn_swimming.asp" -->
<!-- #include virtual = "/pub/fn/fn.cipher.asp" -->

<!-- #include virtual="/pub/class/JSON_2.0.4.asp" -->
<!-- #include virtual="/pub/class/JSON_UTIL_0.1.1.asp" -->
<!-- #include virtual="/pub/class/json2.asp" -->
<!-- #include virtual = "/pub/cookies/cookies.pub.asp" --><%'암호화 모듈 아래쪽에%>

<%
'	If Cookies_aID = "" Then '관리자 로그인이 안된경우
'		Response.end
'	End if

	Set db = new clsDBHelper

	'저장위치 찾기
	global_filepath_temp = "E:\www\upload\sportsdiary\"&sitecode&"\TEMP\" '임시저장
	global_filepath = "E:\www\upload\sportsdiary\"&sitecode&"\recom\"&year(date)&"\"
	global_filepath_DB = "/"& sitecode &"/recom/"&year(date)&"/"



	'해당 폴더가 없으면 생성
	Set Fso = Server.CreateObject("Scripting.FileSystemObject")
	if not Fso.FolderExists(global_filepath_temp) Then
	  global_filepath_temp = Fso.CreateFolder(global_filepath_temp)
	end If
	if not Fso.FolderExists(global_filepath) Then
	  global_filepath = Fso.CreateFolder(global_filepath)
	end if	
	Set Fso = nothing


	'업로드를 처리할 오브젝트를 생성합니다.
	Set Upload = Server.CreateObject("TABSUpload4.Upload")

	'업로드 파일 최대 크기를 제한합니다.
	Upload.MaxBytesToAbort = 20 * 1024 * 1024	
	
	'업로드를 시작합니다.
	Upload.Start global_filepath_temp

	'업로드된 파일을 디스크에 저장합니다.(true Overwrite) '단일파일 이름 그대로 저장
	'Upload.Save global_filepath , False
	'filename = Upload.Form("lnmainfile").ShortSaveName
	'dbsavefilename = global_filepath_DB & filename

	tidx = Upload.Form("f_tidx")
	teamcd = Upload.Form("f_teamcd")
	teamnm = Upload.Form("f_teamnm")
	leaderidx = Upload.Form("f_leaderidx")

	Set File = Upload.Form("inpFileApply") '여러개 파일폼중에 선택할수 있는 방법으로 만들어서
	
	orgfilenm = File.FileName
	
	filename = tidx & "_" & teamnm & "_" & leaderidx &  "." & right(orgfilenm , 3)
	File.SaveAs global_filepath & filename , true
	dbsavefilename = global_filepath_DB & filename

	Set Upload = Nothing

	'디비 업데이트 
	SQL = "Select idx,team from sd_schoolConfirm where team = '"&teamcd&"' and gametitleidx = '"&tidx&"' and leaderIDX = '"&leaderidx&"' and gubun = 1 "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If rs.eof then
		SQL = "insert into  sd_schoolConfirm (gametitleidx,team,teamnm,fileUrl ,leaderIDX) values ("&tidx&",'"&teamcd&"','"&teamnm&"','"&dbsavefilename&"' , "&leaderidx&")  "
		Call db.execSQLRs(SQL , null, ConStr)
	Else
		SQL = "update  sd_schoolConfirm set fileUrl ='"&dbsavefilename&"' where  idx = " & rs(0)
		Call db.execSQLRs(SQL , null, ConStr)	
	End if


		Function GetRandomNum(nRange)
			Randomize
			GetRandomNum = (Int(nRange * Rnd) + 1)
		End Function 

	'리턴값은  변경된 파일명으로 넣자.
	Response.write "<a href=""http://upload.sportsdiary.co.kr/sportsdiary"&dbsavefilename&"?v="&GetRandomNum(1234)&""" target=""_blank"">" & filename & "</a>"


	db.Dispose
	Set db = Nothing
%>