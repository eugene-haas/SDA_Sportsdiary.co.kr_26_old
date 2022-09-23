<!--#include file="../Library/ajax_config.asp"-->
<%
	SportsGb 		= Request.Cookies("SportsGb")
	element   		= fInject(Request("element"))
	StimFistCd 		= fInject(Request("attname"))
    '변경정보
	StimMidCd 		= fInject(Request("CODE"))		
    

	If SportsGb = "" Then 		
		Response.Write "FALSE"
		Response.End
	Else 
        IF StimFistCd="0" THEN
             SQL ="EXEC View_Strength_FistInfo '"& SportsGb &"',''"
		     SET LRs = DBCon.Execute(SQL)

            selData = "<select id='StimFistCd' onchange='StimFistCd_serch();'>"
		    selData = selData&"<option value='0'>::  측정항목 선택  ::</option>"		
            If Not (LRs.Eof Or LRs.Bof) Then 
		        Do Until LRs.Eof 
                    if StimMidCd = LRs("StimFistCd")then
                        selData = selData&"<option value='"&LRs("StimFistCd")&"' selected>"&LRs("StimFistNm")&"</option>"	
                    else
                        selData = selData&"<option value='"&LRs("StimFistCd")&"'>"&LRs("StimFistNm")&"</option>"	
                    end if

			        LRs.MoveNext
		        Loop  
                selData = selData&"</select>"
                Response.Write selData
                Response.End
            Else
			    Response.Write SQL
			    Response.End
		    End IF
	    End If 

		 LRs.Close
		SET LRs = Nothing
	    Dbclose()
	End If 
       
%>
