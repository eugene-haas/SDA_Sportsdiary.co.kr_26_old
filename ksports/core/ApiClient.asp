<%
	Dim m_host,m_uri,m_param,debug
	
	debug = false
	m_host = ""
	m_uri = ""
	m_param = ""

	' Apiclient 초기화 
	function init(hostname, uri, param)
		m_host = hostname
		m_uri = uri
		m_param	= param
	end function

	' API 서버에 접속하여 자료 수신
	function execute()
		content = post_request(m_host, m_uri, m_param)
		execute = content
	end function

	
	' 서버와 통신하는 함수
	' POST 방식으로 접속하여 처리하며 
	' 수신한 자료에서 header 정보를 버리고 본문만 리턴 
	function post_request(hostname, filePath, data)
		Dim str, headerStr, bodyStr,tempStr
		
		if debug=true then
			Response.write "## ApiClient.post_request()<br/>"
			Response.write "Host : " & hostname & "<br/>"
			Response.write "URI : " & filePath & "<br/>"
			Response.write "Param : " & data & "<br/>"
		end if
		
		str = ""
		headerStr = ""
		bodyStr = ""
		
		str = hostname & filePath
				
		set oXmlhttp = Server.CreateObject("Msxml2.ServerXMLHTTP")
		'set oXmlhttp = Server.CreateObject("Msxml2.xmlhttp")
		
		oXmlhttp.open "POST", str, false
		
		oXmlhttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
		
		oXmlhttp.setRequestHeader "Content-Length", Len(data)
		
		oXmlhttp.send data
		
		tempStr = oXmlhttp.responseText
		
		Set oXmlhttp = Nothing
		
		sResponse = split(tempStr,"\r\n")
		
		post_request = sResponse(0)
		'post_request = hostname & " " & filePath & " " & data 
		
	end function
%>