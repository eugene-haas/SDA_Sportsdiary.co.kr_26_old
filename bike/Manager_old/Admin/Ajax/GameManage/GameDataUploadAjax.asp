<!--#include file="../../dev/dist/config.asp"-->
<%
  Dim AppendPath : AppendPath = ""
  Dim FSO
  SET FSO = CreateObject("Scripting.FileSystemObject")
  Set Upload = Server.CreateObject("TABSUpload4.Upload")
  Upload.Start global_filepath_Admin 
  Upload.CodePage = 65001
  AppendPath = fInject(Upload("GameType"))
  Upload.Save global_filepath_Admin & AppendPath & "\" , false
  FileName = Upload.Form("uploadfile").ShortSaveName
  

  IF FSO.FileExists(global_filepath_Admin & AppendPath & "\" & FileName ) Then 
    Response.Write "True"
  Else
    Response.Write "False"
  End IF

        

  'Response.Write "Upload(GameType) : " & fInject(Upload("GameType"))
  'Response.Write "AppendPath" & AppendPath 
  'Response.End
  
  
  
%>