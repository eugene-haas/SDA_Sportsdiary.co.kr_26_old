<%@ Language=VBScript %>
<%
Response.ContentType = "image/jpeg"
' Uncomment to prompt user for download or run with associated program.
' Response.AddHeader "content-disposition","attachment;filename=ReadMe.jpg"
Set objHTTP = Server.CreateObject("Msxml2.ServerXMLHTTP")' Point to an image file with adequate access permissions granted
objHTTP.open "GET", "https://www.cloudv.kr/bootstrap/images/logo.png",false
objHTTP.send
Response.BinaryWrite objHTTP.ResponseBody
Set objHTTP = Nothing
%>