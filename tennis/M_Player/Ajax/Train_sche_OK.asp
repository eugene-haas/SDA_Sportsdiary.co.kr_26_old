<!--#include file="../Library/ajax_config.asp"-->
<%
	Check_Login()
	
	SportsGb 		=  Request.Cookies("SportsGb")
	MemberIDX   	=  decode(Request.Cookies("MemberIDX"),0)
	PlayerIDX   	=  decode(Request.Cookies("PlayerIDX"),0)
 
   ' /*ÈÆ·ÃÀÏÁö*/
     tblSvcTrRerd       = fInject(ReplaceTagText(Request("tblSvcTrRerd")))
   ' /*ÈÆ·ÃÆò°¡*/
     tblSvcTrRerdAsmt   = fInject(ReplaceTagText(Request("tblSvcTrRerdAsmt")))

     SQL =  "EXEC Insert_Train_sche '"&SportsGb&"',"&MemberIDX&",'"&tblSvcTrRerd&"','"&tblSvcTrRerdAsmt &"'"
    ''Ã¼Å©  : ÈÆ·Ã Æò°¡ / ÈÆ·Ã¸ñÇ¥ /

	If tblSvcTrRerd = "" Then 	
		Response.Write "FALSE|"&SQL
		Response.End
	Else                                                      '  /*ÈÆ·ÃÀÏÁö*             *ÈÆ·ÃÆò°¡*    /
		SQL =  "EXEC Insert_Train_sche '"&SportsGb&"',"&MemberIDX&",'"&tblSvcTrRerd&"','"&tblSvcTrRerdAsmt &"'"
		DBCon.Execute(SQL)	

		Response.Write "TRUE"
		Response.End
	End If 
    
	Dbclose()
%>