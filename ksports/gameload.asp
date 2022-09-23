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


Function PostHTTPFile(strURL,param)
    Dim objXML
    Dim strHTTPResponse

    Set objXML = Server.CreateObject("Msxml2.ServerXMLHTTP")

    Call objXML.Open("POST", strURL, False)
    Call objXML.Send(param)

    strHTTPResponse = objXML.responseBody 'responseText

    Set objXML = Nothing

    PostHTTPFile = strHTTPResponse
End Function





page = request("page")
y = request("y")
cd = request("cd")
eventName = request("eventName")
If y = "" Then
y = 2017
End If
If cd = "" Then
cd = "JU"
End If
If page = "" Then
page = 1
End If


Function ParseCDRXML(strXML)
	Dim objXML,objRoot ,I, thisNode,strID, strNarrative

	Set objXML= Server.CreateObject("Microsoft.XMLDOM")
	objXML.async = False
	objXML.loadXML(strXML)
'	Set objRoot = objXML.documentElement

'Response.write objXML.documentElement

'              For I = 0 TO (objRoot.childNodes.length - 1)
'                   Set thisChild = objRoot.childNodes(I)
'                   strID 			= thisChild.childNodes(0).Text
'                   strNarrative 	= thisChild.childNodes(2).Text
'		       	    DoSomething strID,strNarrative
'				Next
End Function

Response.ContentType = "text/xml"
source = Stream_BinaryToString( GetHTTPFile("http://tennis.sportsdiary.co.kr/ksports/core/api_request_020T1.asp?pageNo="&page&"&regYear="&y&"&classCd="&cd&"&eventNm="&eventName) , "utf-8" )
Response.write source


'xmldata = ParseCDRXML(soruce)

%>
