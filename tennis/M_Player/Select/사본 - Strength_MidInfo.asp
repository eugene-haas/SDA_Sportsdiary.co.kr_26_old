<!--#include file="../Library/ajax_config.asp"-->
<%

	SportsGb 		= Request.Cookies("SportsGb") 
	MemberIDX   	=  decode(Request.Cookies("MemberIDX"),0)
	PlayerIDX   	=  decode(Request.Cookies("PlayerIDX"),0)

	element   		= fInject(Request("element"))
	StimFistCd 		= fInject(Request("StimFistCd"))
	StimMidCd 		= fInject(Request("StimMidCd"))		

    MID_COUNT = "0"

	If SportsGb = "" Then 		
		Response.Write "FALSE"
		Response.End
	Else 
        IF element="COUNT" THEN 
            	SQL = " SELECT COUNT(B.StimMidCd)CNT "
	            SQL = SQL&" FROM tblSvcStimFistInfo A "
	            SQL = SQL&" INNER JOIN tblSvcStimMidInfo b "
	            SQL = SQL&" on A.SportsGb = b.SportsGb "
	            SQL = SQL&"  AND A.StimFistCd = b.StimFistCd "
	            SQL = SQL&"  AND A.DelYN ='N' AND B.DELYN ='N' AND A.SportsGb ='"& SportsGb &"'"

                if StimFistCd<>"0" then
                     SQL = SQL&"  AND A.StimFistCd ='"& StimFistCd &"'"
                end if

		    SET LRs = DBCon.Execute(SQL)	

		    IF Not(LRs.Eof Or LRs.Bof) Then 
                MID_COUNT = LRs("CNT")

			    Response.Write "TRUE|"&MID_COUNT
            Else
			    Response.Write SQL
			    Response.End
		    End IF

        Else
            IF StimFistCd="0" THEN
                SQL ="EXEC View_Strength_MidInfo '"& SportsGb &"','',''"
		        SET LRs = DBCon.Execute(SQL)
		        selData = selData&" <div class=sub train strength><div class=exc-list><ul><li class=clearfix>"		
                If Not (LRs.Eof Or LRs.Bof) Then 
		            Do Until LRs.Eof 
                    '../images/strength/icon-squart@3x.png
                            'selData = selData&" <div class='event-img'></div>"	
                            'selData = selData&" <div class='event-img'><img src=../images/strength/"&LRs("StimGideFile")&" alt></div>"	
                            'selData = selData&"<div class='exc-cont'> <p  class='exc-title' >"&LRs("StimMidNm")&"</p> </div></li>"
			            LRs.MoveNext
		            Loop  
                     selData = selData&"</div></ul></div>"
                    Response.Write selData
                    Response.End
                Else
			        Response.Write SQL
			        Response.End
		        End IF
            Else 
                    IF  element ="exc-list" then
                        SQL ="EXEC View_Strength '"& SportsGb &"','"& MemberIDX &"','"& StimMidCd &"','"& StimFistCd &"',''"

                        SET LRs = DBCon.Execute(SQL)

                        selData="<ul id ='"&element&"'>"
                        selData = selData&" <div class=sub train strength><div class=exc-list><ul><li class=clearfix>"	
                        seq = 1
                        If Not (LRs.Eof Or LRs.Bof) Then 	
                                Do Until LRs.Eof    
                                StimFistCd=LRs("StimFistCd")
                                StimFistNm=LRs("StimFistNm")
                                StimGideFile=LRs("StimGideFile")
                                StimMidCd=LRs("StimMidCd")
                                StimMidNm=LRs("StimMidNm")
                                StimMidUnit=LRs("StimMidUnit")
                                StimGideFile=LRs("StimGideFile")
                                StimData=LRs("StimData")
                                StimID = "SEQ"&StimMidCd
                                selData = selData&"<li class='clearfix'>"
                                selData = selData&" <div class='event-img'>"
                                selData = selData&" <img src='../images/strength/"&StimGideFile&"' alt>"
                                selData = selData&"</div>"
                                selData = selData&"<div class='exc-cont'>"
                                selData = selData&"<p class='exc-title'>"&StimMidNm&"</p>"
                                selData = selData&"<p class='exc-exp'>"&LRs("StimMidText")&"</p>"
                                selData = selData&"</div>"
                                selData = selData&"<div class='exc-count'>"
                                selData = selData&"<label>"
                                selData = selData&"<input id ='"&StimID&"' type='number' value="&StimData&">"& StimMidUnit
                                selData = selData&"</label></div>"
                                selData = selData&"</li>"
                                seq = seq+1
                                LRs.MoveNext
                                Loop  
                            selData = selData&"</ul>"
                            Response.Write selData
                            Response.End
                        ELSE
			                Response.Write SQL
			                Response.End

                        END IF
                    End IF
	        End If 
        END IF

		LRs.Close
		SET LRs = Nothing
	    Dbclose()
	End If 
       
%>
