<!-- #include virtual = "/pub/header.swimmingAdmin.asp" -->
<% 
	Dim rndValue, rndSeed,or_num
	rndSeed = 20 '1~40

	Randomize ' 난수 발생기 초기화
	rndValue = Int((rndSeed * Rnd) + 1) ' 1에서 40까지 무작위 값 발생

	
	FUNCTION ENCRYPTION(STR,STREN)
	  DIM CP
	  SET CP=SERVER.CREATEOBJECT("CAPICOM.HASHEDDATA")
	  SELECT CASE UCASE(STREN) '입력된 암호화의 종류에 따라 암호화함.
		CASE "SHA1" : CP.ALGORITHM=0
		CASE "MD2"  : CP.ALGORITHM=1
		CASE "MD4"  : CP.ALGORITHM=2
		CASE "MD5"  : CP.ALGORITHM=3
		CASE "SHA256" : CP.ALGORITHM=4
		CASE "SHA384" : CP.ALGORITHM=5
		CASE "SHA512" : CP.ALGORITHM=6
		CASE ELSE '암호화 종류가 입력되지 않거나 지원되지 않는 암호화 
		  ENCRYPTION="0" : SET CP=NOTHING : EXIT FUNCTION
	  END SELECT
	  CP.HASH USTR2BSTR(STR) 'UNICODE를 BYTE로 변환
	  ENCRYPTION=CP.VALUE
	  SET CP=NOTHING
	END FUNCTION
	 
	 
	 
	'UNICODE를 BYTE로 변환
	FUNCTION USTR2BSTR(USTR)
	  DIM I: DIM STRCHAR: DIM STRRESULT: STRRESULT=""
	  FOR I=1 TO LEN(USTR)
		STRCHAR=MID(USTR, I, 1)
		STRRESULT=STRRESULT&CHRB(ASCB(STRCHAR))
	  NEXT
	  USTR2BSTR=STRRESULT
	END Function

	ini_Key = "ItEQKi3rY7uvDS8l"
	type_Refund = "Refund"
	paymethod = "Card"
	timestamp = Year(Now())&Month(Now())&day(Now())&Hour(Now())&minute(Now())&second(Now())
	clientIp = Request.ServerVariables("REMOTE_ADDR")
	'MIDt = "swimmings1"
	MIDt = "INIpayTest"
	tid = "StdpayCARDINIpayTest20200513091851176223"

	hash = ENCRYPTION(ini_Key&type_Refund&paymethod&timestamp&clientIp&MIDt&tid,"SHA512")

	msg = "test"
	dim url 
	url = "https://deviniapi.inicis.com" 
	Set HttpReq = Server.CreateObject("MSXML2.ServerXMLHTTP") 
	HttpReq.open "POST", url, false 
	HttpReq.setRequestHeader "Content-Type", "application/json/x-www-form-urlencoded;charset=utf-8" 
	
	test = "type="&type_Refund&"&paymethod="&paymethod&"&timestamp="&timestamp&"&clientIp="&user_ip&"&mid="&MIDt&"&tid="&tid&"&msg="&msg&"&hashData="
	
	HttpReq.Send(test&Server.UrlEncode(hash)) 

	Response.write HttpReq.responseText
	 
%> 