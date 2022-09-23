<!-- #include virtual = "/pub/header.tennis.asp" -->

<%
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
Source = Stream_BinaryToString( GetHTTPFile("http://tennis.sportsdiary.co.kr/tennis/SD_OS/index.asp") , "utf-8" )	



Response.write source
%>
