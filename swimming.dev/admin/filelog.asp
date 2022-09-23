<!-- #include virtual = "/pub/header.swimmingAdmin.asp" -->
<!--#include virtual="/pub/fn/fn.file.asp" -->
<%
	Set db = new clsDBHelper
%>





<!DOCTYPE html>
<head>
	  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>대한수영연맹</title>
  <!-- Tell the browser to be responsive to screen width -->
  <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">

</head>
<body>

<%=hostname%>
<%
Select Case hostname
Case "pigwing.svn.com" : p1color = "style='color:red;'"
Case "pigwing2.svn.com" : p2color = "style='color:red;'"
Case "tygem.svn.com" : t1color = "style='color:red;'"
Case "tygem2.svn.com" : t2color = "style='color:red;'"
End select
%>
<!--  <a href="http://tygem.svn.com" <%=t1color%>>타이젬(141)</a>&nbsp;&nbsp;<a href="http://tygem2.svn.com" <%=t2color%>>타이젬제휴(81)</a>&nbsp;&nbsp; -->
<!--  <a href="http://pigwing.svn.com" <%=p1color%>>피그윙(120)</a>&nbsp;&nbsp;<a href="http://pigwing2.svn.com" <%=p2color%>>피그윙제휴(80)</a> -->
<!--  <br> -->
<hr width="100%">

<hr>
IIS WEBROOT ............<%= Request.ServerVariables("LOCAL_ADDR") %>
<hr>

<%
'■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
if toperrchk = false then

  srcpath = Request("srcpath")
  If srcpath = "" Then
	srcpath = "D:/log_dev/sitelog/swn02"
  End if

  if srcpath="" then
    srcpath = pickdl
    chktop = true
  else
    if Mid(srcpath,3,1)<>"/" and Mid(srcpath,3,1)<>"\" then
      srcpath = replace(srcpath,":",":/")
    end if

    utemp = split(srcpath,"/")
    for i=0 to UBound(utemp)-1
      if i=0 then
        beforefolder = utemp(0)
      else
        beforefolder = beforefolder & "/" & utemp(i)
      end if
    next
    if right(srcpath,2)=":/" or right(srcpath,1)=":" then
      chktop = true
    else
      chktop = false
    end if
  end If
  


  '===========================================
  'Response.Write "[체크경로]:" & srcpath & "<br>"
  'Response.Write "[상위경로]:" & beforefolder & "<br>"
  
  Response.Flush
  '===========================================
  
  set fs = createobject("scripting.filesystemobject")
  '-------------------------
  '폴더객체 구하기
  '-------------------------
  set folder = fs.GetFolder(srcpath)
  '하위 폴더 콜렉션 구하기
  set fc = folder.SubFolders


  Response.Write "현재 폴더 : " & folder & "<hr>"
 '#############################



  strPath = folder
  If Len(strPath) > 10 then
  Call GetFileList(strPath )
  Call GetFolderList(strPath)  
  %>





<%
 Sub GetFolderList(strPath)
  Dim FSO, Folder, Sub_folder,Folderstr
  
  Set FSO = Server.CreateObject( "Scripting.FileSystemObject" )
  Set Folder = FSO.GetFolder(strPath)
  Set Sub_folder = Folder.Subfolders


  For Each folder In Sub_folder 
   if folder.Name <> "" then 
		GetFolderList(strPath&"\"&folder.Name) 
		'시작 경로에서 하위 폴더를 붙이면서 검색한다.
		'Folderstr =  "<hr><font color=blue>"
		'Folderstr = Folderstr & strPath & "\" & folder.name & "\<br>" 
		'폴더명을 출력한다.
		Call GetFileList(strPath & "\" & folder.name)
		'하위 폴더에 있는 파일을 검색한다.    
		end if   
  Next
  Set Sub_folder = Nothing
  Set Folder = Nothing
  Set FSO = Nothing
' 개채를 비운다.  
 End Sub

 Sub GetFileList(strPath)
  Dim FSO, Folder, Files, FilePath,filecolor,file
  Set FSO = Server.CreateObject( "Scripting.FileSystemObject" )
  Set Folder = FSO.GetFolder(strPath) 
  '하위 폴더명을 붙이면서 Folder개채를 생성한다.
  Set Files = Folder.Files
  'Folder개채로 File개채를 생성한다.

  Dim lapse

  For Each file In Files  
    filecolor = ""
	lapse = DateDiff("h",CDate(File.dateLastModified),now) '3시간

	If CDbl(lapse)  < 3 Then
		filecolor = ";color:red;"
	End if	

	 If CDbl(lapse)  < 2 Then
	 FilePath = strPath&"\"& "<span style='"&filecolor&"'>" & File.Name & "</span>"
     Response.write FilePath & "<br>" 
	 End if
     'File개채들을 출력한다.
  Next
  Set Files = Nothing
  Set Folder = Nothing
  Set FSO = Nothing
 End Sub

%>


  <%
  response.write "<BR>"
  End if
 
 '-------------------------
  if chktop = false then
    '루트가 아니라, 하부폴더로 들어갔다면,
    fdname = "폴더 " & ".. "
    Response.Write "<a href=javascript:viewfolder('"&escape(beforefolder)&"');>" & fdname & "</a><br>"
  end if
  
  Response.Flush
  '===========================================
  'If Cookies_svndir = "" then
  call findfolder(fc)
  'End if

  call findfile(folder)
 
  'If Cookies_svndir = "" then
  set folder=Nothing
  'End if

  set fc=nothing
  '===========================================
end if
%>

<script language="javascript">
function viewfolder(srcurl){
  if (srcurl.length < 4){

  }else{
	thisurl  = "<%=Request.ServerVariables("SCRIPT_NAME")%>?srcpath="+srcurl;
	location.href = thisurl;
  }
}
</script>

</body>
</html>

<%
	db.Dispose
	Set db = Nothing

%>