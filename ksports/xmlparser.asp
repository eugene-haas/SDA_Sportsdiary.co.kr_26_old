<% @LANGUAGE="VBSCRIPT" CODEPAGE="65001" %>

<!doctype html>
<html lang="en">
 <head>
  <meta charset="UTF-8">
  <title>Document</title>
 </head>
 <body>
 <%

Function loadXML()
	Dim request_url,xmlHttp,str_xml,xmldoc,rtlValue,rootNode,dataNode
	Dim test
	request_url = "http://tennis.sportsdiary.co.kr/ksports/gameloadT1.asp?sss=1"
	Set xmlHttp = Server.CreateObject("Microsoft.XMLHTTP")
	xmlHttp.Open "GET", request_url, False
	xmlHttp.Send
	str_xml = xmlHttp.ResponseText
	'Response.write str_xml
	

	If str_xml <> "" Then
		Set xmldoc = Server.CreateObject("Microsoft.XMLDOM")
		xmldoc.Async = False
		xmldoc.validateOnParse = False
		rtlValue = xmldoc.loadXML(str_xml)
		Set rootNode = xmldoc.selectNodes("//RESULT")
		Set rcNode = xmldoc.selectNodes("//RESULT//RESULT_CODE")
		Set dataNode = xmldoc.selectNodes("//DATA")
		Set eventCDNode = xmldoc.selectNodes("//DATA//EVENT//EVENT_CD")
		Set eventNameKorNode = xmldoc.selectNodes("//DATA//EVENT//EVENT_NM_KOR")


		test = eventCDNode(0).childNodes(0).Text
'		dataNodeLength = dataNode(0).childNodes.length
		eventName = dataNode(0).childNodes(0).childNodes(0).Text
		For i = 1 To 2
			test = eventCDNode(i).childNodes(0).Text
			eventName = eventNameKorNode(i).childNodes(0).Text
			Response.write "eventname =" & eventName & " <br/>"
			Response.write "evenCode =" & test & " <br/>"
		Next		
	End If

	Set rootNode = Nothing
	Set dataNode = Nothing
	Set xmlHttp = Nothing
	Set xmldoc = Nothing

	loadXML = test
End Function

result = loadXML()


%>

 </body>
</html>
