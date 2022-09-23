<!--METADATA TYPE= "typelib"  NAME= "ADODB Type Library" FILE="C:\Program Files\Common Files\SYSTEM\ADO\msado15.dll"  -->

<%@ codepage="65001" language="VBScript" %>
<%
	Response.CharSet="utf-8"
	Session.codepage="65001"
	Response.codepage="65001"
	Response.ContentType="text/html;charset=utf-8"

	Response.Expires = -1
	Response.Expiresabsolute = Now() - 1
	Response.AddHeader "pragma","no-cache"
	Response.AddHeader "cache-control","private"
	Response.CacheControl = "no-cache"

Function Stream_BinaryToString(Binary, CharSet)
  Const adTypeText = 2
  Const adTypeBinary = 1
  
  'Create Stream object
  Dim BinaryStream 'As New Stream
  Set BinaryStream = Server.CreateObject("ADODB.Stream")
  
  'Specify stream type - we want To save text/string data.
  BinaryStream.Type = adTypeBinary
  
  'Open the stream And write text/string data To the object
  BinaryStream.Open
  BinaryStream.Write Binary
  
  
  'Change stream type To binary
  BinaryStream.Position = 0
  BinaryStream.Type = adTypeText
  
  'Specify charset For the source text (unicode) data.
  If Len(CharSet) > 0 Then
    BinaryStream.CharSet = CharSet
  Else
    BinaryStream.CharSet = "us-ascii"
  End If
  
  'Open the stream And get binary data from the object
  Stream_BinaryToString = BinaryStream.ReadText
End Function


'######################################################

Function GetHTTPFile(strURL)
    Dim objXML
    Dim strHTTPResponse

    Set objXML = Server.CreateObject("Msxml2.ServerXMLHTTP")

    Call objXML.Open("GET", strURL, False)
    Call objXML.Send()

    strHTTPResponse = objXML.responseBody 'responseText

    Set objXML = Nothing

    GetHTTPFile = strHTTPResponse
End Function

Dim Source

'Source = BinDecode( GetHTTPFile("http://tennis.sportsdiary.co.kr/tennis/SD_OS/index.asp") )	
'Source = Stream_BinaryToString( GetHTTPFile("http://badmintonadmin.sportsdiary.co.kr/Main/Print/Matchall_ViewEx_test2.asp?GameLevelIDX=&GameTitleIdx=F5FF9E5EFCEC1A489E243B1D641975C2") , "utf-8" )	
Source = Stream_BinaryToString( GetHTTPFile("http://judo.sportsdiary.co.kr/M_Player/main/index_db.asp") , "utf-8" )	

	Sub makeHTML(strLog)		
		Dim objStream
		strPath = server.MapPath("\pub\exer\aaaa.asp")
		If strPath = "" Then Exit sub

		Set objStream = Server.CreateObject("ADODB.Stream")
		objStream.Mode = 3
		objStream.Type = 2 ' 텍스트 타입 (1: Bin, 2: Text)
		objStream.CharSet = "UTF-8"
		objStream.Open
		
		' trick , move to file end position to append file
		on error resume next
			objStream.LoadFromFile (strPath)
			objStream.ReadText(-1)

		' write log - append 
		objStream.WriteText strLog, 1		
		objStream.SaveToFile strPath, 2
		objStream.Flush
		objStream.Close
		Set objStream = Nothing		
        On Error GoTo 0
	end sub

'Call makeHTML(source)

Response.write source






%>
