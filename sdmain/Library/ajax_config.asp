<% @CODEPAGE="65001" language="vbscript" %>
<%
	Response.Expires = -1
	Response.ExpiresAbsolute = now() - 1
	Response.ContentType = "text/html;charset=utf-8"
	Response.CacheControl = "no-cache"
	Response.CacheControl = "private"
	Response.CodePage = "65001"
	Session.codepage = "65001"

	
	Const Ref = "GPQRSATWXVYBCHL640MN598OIJKZ12D7EF3U"	

	dim GLOBAL_DT			: GLOBAL_DT          = Year(now)&AddZero(Month(now))&AddZero(Day(now))		  '현재일자 예)20150609							 
	dim LIST_SPORTSTYPE  	: LIST_SPORTSTYPE    = "|SD|judo|tennis|bike"						          '종목리스트  |통합|유도|테니스|자전거	
	dim GLOBAL_Num1         : GLOBAL_Num1        = "010-6312-6655"                           '최보라 팀장
    dim GLOBAL_Num2         : GLOBAL_Num2        = "02-704-0282"                             '대표번호	
    dim GLOBAL_Num3         : GLOBAL_Num3        = "02-715-0282(#3)"                         '대표번호	
    dim GLOBAL_Name1        : GLOBAL_Name1       = "최보라"                                   '담당1
    dim GLOBAL_Name2        : GLOBAL_Name2       = "스포츠다이어리"                            '담당2	
	dim GLOBAL_Fax          : GLOBAL_Fax         = "02-3483-8113"                             '팩스번호	
    dim GLOBAL_Email1       : GLOBAL_Email1      = "sd@sdah.co.kr"	                         '담당자메일1
    dim GLOBAL_Companycode  : GLOBAL_Companycode = "108-81-66493"                            '사업자번호
    dim GLOBAL_Address      : GLOBAL_Address     = "서울 마포구 삼개로16 근신빌딩 본관5층"	
    dim GLOBAL_Site         : GLOBAL_Site        = "www.sportsdiary.co.kr"	   
    dim GLOBAL_Domain       : GLOBAL_Domain      = "sportsdiary.co.kr"
   	
	
%>
<!--#include file="./common_function.asp"-->
<!--#include file="./dbcon.asp"-->
<!-- #include virtual="/pub/class/json2.asp" -->

<%
	DBopen()
	DBOpen3()
	DBOpen4()
%>