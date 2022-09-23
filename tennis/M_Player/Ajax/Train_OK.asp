<!--#include file="../Library/ajax_config.asp"-->
<%
	Check_Login()
	
	SportsGb 		=  Request.Cookies("SportsGb")
	MemberIDX   	=  decode(Request.Cookies("MemberIDX"),0)
	PlayerIDX   	=  decode(Request.Cookies("PlayerIDX"),0)
 
   ' /*훈련일지*/
     tblSvcTrRerd       = ReplaceTagText(fInject(Request("tblSvcTrRerd")))
    ' /*훈련목표*/
     tblSvcTrRerdTgt    = fInject(Request("tblSvcTrRerdTgt"))
   '  /*훈련정보*/
     tblSvcTrRerdTrai   = fInject(Request("tblSvcTrRerdTrai"))
   '  /*개인훈련정보*/
     tblSvcTrRerdPTrai   = fInject(Request("tblSvcTrRerdPTrai"))
   ' /*훈련평가*/
     tblSvcTrRerdAsmt   = fInject(Request("tblSvcTrRerdAsmt"))
   ' /*부상부위*/
     tblSvcTrRerdJury   = fInject(Request("tblSvcTrRerdJury"))
    
    ''체크  : 훈련 평가 / 훈련목표 /
    SQL =  "EXEC Insert_Train '"&SportsGb&"',"&MemberIDX&",'"&tblSvcTrRerd&"','"&tblSvcTrRerdTgt &"','"&tblSvcTrRerdTrai &"','"&tblSvcTrRerdAsmt &"','"&tblSvcTrRerdJury &"','"&tblSvcTrRerdTrai_person &"'"
	If tblSvcTrRerd = "" Then 	
		Response.Write "FALSE|"&SQL
		Response.End
	Else                                                      '  /*훈련일지*             *훈련목표*          *훈련정보*                *훈련평가*             *부상부위                개인 훈련정보 */
		SQL =  "EXEC Insert_Train '"&SportsGb&"',"&MemberIDX&",'"&tblSvcTrRerd&"','"&tblSvcTrRerdTgt &"','"&tblSvcTrRerdTrai &"','"&tblSvcTrRerdAsmt &"','"&tblSvcTrRerdJury &"','"&tblSvcTrRerdPTrai &"'"
		DBCon.Execute(SQL)	

		Response.Write "TRUE"
		Response.End
	End If 
    
	Dbclose()
%>