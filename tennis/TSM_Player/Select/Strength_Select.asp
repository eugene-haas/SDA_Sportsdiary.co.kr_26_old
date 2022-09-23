<!--#include file="../Library/ajax_config.asp"-->
<%
	SportsGb 		=  Request.Cookies("SportsGb")
	MemberIDX   	=  decode(Request.Cookies("MemberIDX"),0)
	PlayerIDX   	=  decode(Request.Cookies("PlayerIDX"),0)

	TrRerdDate 		= fInject(Request("TrRerdDate"))
	StimFistCd 		= fInject(Request("StimFistCd"))
	StimMidCd_1 	= "01"//fInject(Request("StimMidCd_01"))
	StimMidCd_2 	= "02"//fInject(Request("StimMidCd_02"))



	If MemberIDX = "" Then 	
		Response.Write "FALSE"
		Response.End
	Else 

		SQL ="EXEC View_Strength '"& SportsGb &"',"& MemberIDX &",'"& TrRerdDate &"','"& StimFistCd &"','"& StimMidCd_01 &"'"
		SET LRs = DBCon.Execute(SQL)	
		IF Not(LRs.Eof Or LRs.Bof) Then 
			Response.Write "TRUE|"&LRs("StimFistCd")&"|"&LRs("StimMidCd")&"|"&LRs("StimData")
        Else
			Response.Write SQL
			Response.End
		End IF

			LRs.Close
		SET LRs = Nothing
	End If 
    
	Dbclose()
%>
