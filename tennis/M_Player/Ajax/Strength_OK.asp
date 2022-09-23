<!--#include file="../Library/ajax_config.asp"-->
<%
	Check_Login()
	
	SportsGb 		=  Request.Cookies("SportsGb")
	MemberIDX   	=  decode(Request.Cookies("MemberIDX"),0)
	PlayerIDX   	=  decode(Request.Cookies("PlayerIDX"),0)
    Team            =  decode(Request.Cookies("Team"),0)

	TrRerdDate 		= fInject(Request("TrRerdDate"))
	StimFistCd 		= fInject(Request("StimFistCd"))

	StimData_1   	= fInject(Request("StimData_1"))	
	StimData_2 	    = fInject(Request("StimData_2"))	
	StimData_3   	= fInject(Request("StimData_3"))	
	StimData_4 	    = fInject(Request("StimData_4"))	
    
	If MemberIDX = "" Then 	
		Response.Write "FALSE"
		Response.End
	Else 
	    
        If StimData_1 > 0  Then 	
        
		SQL =  "EXEC  Insert_Strength '"&SportsGb&"','"&Team&"','"&PlayerIDX&"','"&MemberIDX&"','"&TrRerdDate&"','"&StimFistCd&"','1','"&StimData_1&"'"
		DBCon.Execute(SQL)	
        
        END IF 

        IF StimData_2 >0 THEN
        
		SQL =  "EXEC  Insert_Strength '"&SportsGb&"','"&Team&"','"&PlayerIDX&"','"&MemberIDX&"','"&TrRerdDate&"','"&StimFistCd&"','2','"&StimData_2&"'"
		DBCon.Execute(SQL)	

        END IF 

        IF StimData_3 >0 THEN
        
		SQL =  "EXEC  Insert_Strength '"&SportsGb&"','"&Team&"','"&PlayerIDX&"','"&MemberIDX&"','"&TrRerdDate&"','"&StimFistCd&"','3','"&StimData_3&"'"
		DBCon.Execute(SQL)	

        END IF 

        IF StimData_4 >0 THEN
        
		SQL =  "EXEC  Insert_Strength '"&SportsGb&"','"&Team&"','"&PlayerIDX&"','"&MemberIDX&"','"&TrRerdDate&"','"&StimFistCd&"','4','"&StimData_4&"'"
		DBCon.Execute(SQL)	

        END IF 


		Response.Write "TRUE"
		Response.End

	End If 
    
	Dbclose()
%>