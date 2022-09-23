<!-- #include virtual = "/pub/header.tennis.asp" -->
<%

'/pub/fc/fn.util.asp

strArr = array("A","B","C","D","E","F")

rtArr = Shuffle(strArr, 5)

For i = 0 To ubound(rtArr)
	Response.write rtArr(i) & "<br>"

Next


Response.write request.ServerVariables("SCRIPT_NAME")

%>