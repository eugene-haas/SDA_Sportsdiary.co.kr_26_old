<!--#include file="../Library/ajax_config.asp"-->
<%
	Check_Login()
	
	SportsGb 		=  Request.Cookies("SportsGb")
	MemberIDX   	=  decode(Request.Cookies("MemberIDX"),0)
	PlayerIDX   	=  decode(Request.Cookies("PlayerIDX"),0)
    ' /*ÈÆ·ÃÀÏÁö*/
     tblSvcGameRerd   = ReplaceTagText(fInject(Request("tblSvcGameRerd")))
       ' /*ÈÆ·ÃÆò°¡*/
     tblSvcGameAsmt   = (fInject(Request("tblSvcGameAsmt")))



	If MemberIDX = "" Then 	
		Response.Write "FALSE"
		Response.End
	Else 
	    SQL =  "EXEC  Insert_MatchDiary '"&SportsGb&"',"&MemberIDX&",'"&tblSvcGameRerd&"','"&tblSvcGameAsmt&"'"
        If tblSvcGameRerd<>"" and tblSvcGameAsmt<>"" Then 	
        DBCon.Execute(SQL)	
		Response.Write "TRUE"
		Response.End
        else
		Response.Write "FALSE"
		Response.End
        END IF 


	End If 
    
	Dbclose()
%>