<!--METADATA TYPE= "typelib"  NAME= "ADODB Type Library" FILE="C:\Program Files\Common Files\SYSTEM\ADO\msado15.dll"  -->

<% @CODEPAGE="65001" language="VBScript" %>
<%
Response.CharSet="utf-8"
Session.codepage="65001"
Response.codepage="65001"
Response.ContentType="text/html;charset=utf-8"

'#############################################################

Function BytesToStr(bytes)    '#### 바이트를 받아서 String 으로 반환한다.
  Dim Stream
  Set Stream = Server.CreateObject("Adodb.Stream")
    Stream.Type = 1 'bytes
    Stream.Open
    Stream.Write bytes
    Stream.Position = 0
    Stream.Type = 2 'String
    Stream.Charset = "utf-8"
    BytesToStr = Stream.ReadText
    Stream.Close
  Set Stream = Nothing
End Function

Function RequestJsonObject(req)   '#### request 를 검사하고 jsonString 을 반환한다.
  If Not req.TotalBytes > 0 Then
    RequestJsonObject = "{}"
    Exit Function
  End If
  RequestJsonObject = BytesToStr(req.BinaryRead(req.TotalBytes))
End Function

'#############################################################


JsonData = RequestJsonObject2(Request)

Set JsonObj 		= JSON.Parse(join(array(JsonData)))
res_cmd   		    = JsonObj.get("CMD")
%>
