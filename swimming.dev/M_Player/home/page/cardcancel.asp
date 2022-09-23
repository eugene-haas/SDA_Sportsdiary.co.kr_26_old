<!-- #include virtual = "/pub/header.swimmingAdmin.asp" -->
<% 
	Dim rndValue, rndSeed,or_num
	rndSeed = 20 '1~40

	Randomize ' 난수 발생기 초기화
	rndValue = Int((rndSeed * Rnd) + 1) ' 1에서 40까지 무작위 값 발생

	date_type = Year(Now())&Month(Now())&day(Now())&Hour(Now())&minute(Now())&second(Now())

	user_ip = Request.ServerVariables("REMOTE_ADDR")

	dim url 
	url = "http://iniapi.inicis.com" 
	Set HttpReq = Server.CreateObject("MSXML2.ServerXMLHTTP") 
	HttpReq.open "POST", url, false 
	HttpReq.setRequestHeader "Content-Type",  application/x-www-form-urlencoded;charset=utf-8" 
	HttpReq.Send("type=Refund&paymethod=card&timestamp="&date_type&"&clientIp="&user_ip&"&mid=swimmings1&tid=1111&tid=&msg=test&hashData=") 

	Response.write HttpReq.responseText
	 
%> 