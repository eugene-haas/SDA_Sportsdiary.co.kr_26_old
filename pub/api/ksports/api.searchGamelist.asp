<%

Dim classCode, regYear, classCD, eventCD, eventName, eventYear, totalCount, totalPage, lastPage

classCode = oJSONoutput.classCode
regYear = oJSONoutput.regYear
eventName = oJSONoutput.eventName
eventName = Server.UrlEncode(eventName)


'param에 검색조건이 들어감 종목, 년도, 페이지
Function loadXML( pageNo, regYear, classCode )
	Dim request_url,xmlHttp,str_xml,xmldoc,rtlValue,rootNode,dataNode
	request_url = "http://tennis.sportsdiary.co.kr/ksports/gameloadT1.asp?page="& pageNo &"&y="& regYear & "&cd=" & classCode & "&eventName=" & eventName


	Set xmlHttp = Server.CreateObject("Microsoft.XMLHTTP")
	xmlHttp.Open "GET", request_url, False
	xmlHttp.Send
	str_xml = xmlHttp.ResponseText


	Set xmldoc = Server.CreateObject("Microsoft.XMLDOM")
	xmldoc.Async = False
	xmldoc.validateOnParse = False
	rtlValue = xmldoc.loadXML(str_xml)

	Set rootNode = xmldoc.selectNodes("//RESULT")
	Set dataNode = xmldoc.selectNodes("//DATA")
	Set totalCountNode = xmldoc.selectNodes("//RESULT//TOTAL_COUNT")
	Set totalPageNode = xmldoc.selectNodes("//RESULT//TOTAL_PAGE_COUNT")

	dataNodeLength = dataNode(0).childNodes.length
	totalCount = totalCountNode(0).childNodes(0).Text
	totalPage = totalPageNode(0).childNodes(0).Text

	loadXML = str_xml

	Set xmldoc = Nothing
	Set rootNode = Nothing
	Set dataNode = Nothing

End Function

'대회별정보 파싱
Function eventInfo(result, num)
	Dim eventInfoArr(3)
	Dim eventCD, eventName

	str_xml = result

	If str_xml <> "" Then
		Set xmldoc = Server.CreateObject("Microsoft.XMLDOM")
		xmldoc.Async = False
		xmldoc.validateOnParse = False
		rtlValue = xmldoc.loadXML(str_xml)

		Set rcNode = xmldoc.selectNodes("//RESULT//RESULT_CODE")
		Set classCDNode = xmldoc.selectNodes("//DATA//EVENT//CLASS_CD")
		Set eventCDNode = xmldoc.selectNodes("//DATA//EVENT//EVENT_CD")
		Set eventNameKorNode = xmldoc.selectNodes("//DATA//EVENT//EVENT_NM_KOR")
		Set eventYearNode = xmldoc.selectNodes("//DATA//EVENT//EVENT_YEAR")

		classCD = classCDNode(num).childNodes(0).Text
		eventCD = eventCDNode(num).childNodes(0).Text
		eventName = eventNameKorNode(num).childNodes(0).Text
		eventYear = eventYearNode(num).childNodes(0).Text

		eventInfoArr(0) = classCD
		eventInfoArr(1) = eventCD
		eventInfoArr(2) = eventName
		eventInfoArr(3) = eventYear

	End If

	Set xmldoc = Nothing

	eventInfo =  eventInfoArr

End Function

result = loadXML(1, regYear, classCode)
lastPage = totalCount Mod 20

'한번요청에 대회정보를 20개씩만 리턴해주기때문에 totalPage만큼 반복해서 가져온다.
Dim resultArr(50),  rsArr
If  totalPage > 1 Then
	For a = 1 To totalPage
		resultArr(a) =  loadXML(a, regYear, classCode)
	Next
End If

%>
<!-- #include virtual = "/pub/html/ksports/gul02.asp" -->
