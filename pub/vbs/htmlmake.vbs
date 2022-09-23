

Function Stream_BinaryToString(Binary, CharSet)
  Const adTypeText = 2
  Const adTypeBinary = 1
  
  'Create Stream object
  Dim BinaryStream 'As New Stream
  Set BinaryStream = CreateObject("ADODB.Stream")
  
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


Function GetHTTPFile(strURL)
    Dim objXML
    Dim strHTTPResponse

    Set objXML = CreateObject("Msxml2.ServerXMLHTTP")

    Call objXML.Open("GET", strURL, False)
    Call objXML.Send()

    strHTTPResponse = objXML.responseBody 'responseText

    Set objXML = Nothing

    GetHTTPFile = strHTTPResponse
End Function

source = Stream_BinaryToString( GetHTTPFile("http://tennis.sportsdiary.co.kr/pub/test.asp") , "utf-8" )

Set fs = CreateObject ("scripting.FileSystemObject")
filepath = "D:\test\test.asp"

'#############################################
includefile1 = "<!-- #include virtual = ""/pub/header.tennis.asp"" -->"

includefile2 = "<% if a= 1 then%>"
includefile2 = includefile2 & "<% else %>"
includefile2 = includefile2 & "<% end if %>"

starttop	 = instr(source,"<!-- include s -->")
endtop		 = instr(source,"<!-- include e -->")

if starttop > 0 then
	source = left(source,starttop-1) & includefile2 & mid(source,endtop)
End if

source = includefile1 & source

'Set objFile = fs.CreateTextFile(filepath,true,false)

	'Error
	if Err.number <> 0 then
	'에러있음 걍 두고
	else
	Objfile.WriteLine(Source)
	objFile.close
	end if

