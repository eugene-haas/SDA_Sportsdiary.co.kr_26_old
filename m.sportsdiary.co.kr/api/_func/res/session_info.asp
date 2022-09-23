
<% 
'   ===============================================================================     
'    Purpose : Login User Settion Info 전역 Define
'    Author  :                                                       By Aramdry

'   ===============================================================================      
<!--#include virtual="/app/api/_Func/res/ajax_config.asp"-->

'   ===============================================================================     
'    	COOKIES info define - 통합 쿠키 
'   ===============================================================================  
   CK_SD_USER_ID      = Request.Cookies("SD")("UserID")
   CK_SD_USER_ID      = request.Cookies("SD")("MemberIDX")
   

'   ===============================================================================     
'    COOKIES info define - 종목 쿠키 (유도)
'   ===============================================================================  
   SportsGb = "judo"
 '  CK_JODO_MEMBER_IDX   =  decode(Request.Cookies(SportsGb)("MemberIDX"), 0)
 '  CK_JODO_PLAYER_RELN  =  decode(request.Cookies(SportsGb)("PlayerReln", 0)
   

%>