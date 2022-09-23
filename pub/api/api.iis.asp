<%
'http://thesky.tistory.com/category/?page=73   속성 볼때 예시


	Set oXml = Server.CreateObject("microsoft.XMLDOM")
    oXml.async = false
	oXml.load( server.mappath("/widline/applicationHost.config"))

   If oXml.parseError.errorCode <> 0 Then
      Response.Write "XML 페이지 로딩중 에러가 발생했습니다."
      Response.End
   End If


    xPath = "/configuration/system.applicationHost/sites"
	Set itemNodes = oXml.selectNodes(xPath)
	'Set itemNodes = oXml.documentElement  > root


	For Each itemNode In itemNodes 


		Response.write "<table class=""type09"">"
		Response.write "<thead><th>port</th><th>site</th></thead>"
		
		For i = 0 To itemNode.childNodes.length -1 
		'site > bindings > 

			If itemNode.childNodes(i).nodeName = "site" Then
				
				Response.write "<tr><td colspan='2' style='color:orange;border-bottom:1px solid red'>" & itemNode.childNodes(i).getAttribute("name") & "</td></tr>"

				For n = 0 to itemNode.childNodes(i).childNodes(1).childNodes.length -1 

					Response.write "<tr>"

					binds = itemNode.childNodes(i).childNodes(1).childNodes(n).getAttribute("bindingInformation")
					bind = Split(binds, ":")

					If ubound(bind) > 1 then
					bindport = bind(1)
					bindsite = bind(2)
					End If 
					'response.write "<td>" & bindport & "</td><td><a href=""http://"&bidsite&""" target=""_blank"">" &  bindsite  & "</a></td>"
					response.write "<td>" & bindport & "</td><td><a href=""#"" onclick=""mx.SendPacket(this, {'CMD':mx.CMD_TARGETSITE,'URL':'"&bindsite&"'})"">" &  bindsite  & "</a></td>"

					Response.write "</tr>"
				next
			End if
		Next

		Response.write "</table>"		

	Next

Set itemNdes = nothing
%>