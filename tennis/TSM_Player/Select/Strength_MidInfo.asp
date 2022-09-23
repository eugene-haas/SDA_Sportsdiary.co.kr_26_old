<!--#include file="../Library/ajax_config.asp"-->
<%

	SportsGb 		= Request.Cookies("SportsGb") 
	MemberIDX   	=  decode(Request.Cookies("MemberIDX"),0)
	PlayerIDX   	=  decode(Request.Cookies("PlayerIDX"),0)

	element   		= fInject(Request("element"))
	StimFistCd 		= fInject(Request("StimFistCd"))
	StimMidCd 		= fInject(Request("StimMidCd"))		

    MID_COUNT = "0"

    p_TEAMTRAI = "N"
    p_TEAM = ""
    p_SvcStartDt = ""
    p_SvcEndDt = ""


	If SportsGb = "" or  element = ""or  MemberIDX = "" Then 		
		Response.Write "FALSE|\ element :"&element&"\ StimFistCd :"&StimFistCd&"\ StimMidCd "&StimMidCd
		Response.End
	Else 

    SQL ="select Team from tblMember where MemberIDX ='"&MemberIDX&"'" 
    SET LRs = DBCon.Execute(SQL)
    If Not (LRs.Eof Or LRs.Bof) Then 
       p_TEAM = LRs("Team")
    end if
    LRs.Close


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

                IF  element ="leader" then
                      SQL ="	select case when isnull(LeaderIDX,'')='' then 'N' else 'Y' end LeaderIDX" & _
                            "	from tblSvcStimRerd" & _
                            "	where MemberIDX ='"&MemberIDX&"'" & _
                            "	and SportsGb ='"&SportsGb&"'" & _
                            "	and LeaderIDX is not null and LeaderIDX >0" & _
                            "	and TrRerdDate<= replace('"& StimMidCd &"','-','')" & _
                            "	group by LeaderIDX" 
                            SET LRs = DBCon.Execute(SQL)

                         If Not (LRs.Eof Or LRs.Bof) Then 
                                Response.Write LRs("LeaderIDX")'&SQL
                                Response.End
                         else
                                Response.Write "N"'&SQL
                                Response.End
                         end if
                elseif element ="TEAMTRAI" then
                '권한 설정
                        trdate = replace(StimMidCd,"-","")
                        p_TEAMTRAI= "N"
                         SQL ="	select isnull(SvcStartDt,'')SvcStartDt,isnull(SvcEndDt,'')SvcEndDt" & _
                            "	from tblTeamInfo" & _
                            "	where SportsGb='"&SportsGb&"'" & _
                            "	and Team='"&p_TEAM&"'"
                          SET LRs = DBCon.Execute(SQL)
                         If Not (LRs.Eof Or LRs.Bof) Then 
                            p_SvcStartDt = LRs("SvcStartDt")
                            p_SvcEndDt = LRs("SvcEndDt")
                         end if
                         
                         if p_SvcStartDt = "" then 
                              p_TEAMTRAI ="N"
                         else
                            if p_SvcStartDt <= trdate then 
                                if p_SvcEndDt ="" then 
                                    p_TEAMTRAI ="Y"
                                else
                                    if p_SvcEndDt >= trdate then 
                                        p_TEAMTRAI ="Y"
                                    end if 
                                end if 
                            end  if 
                        end  if  


                         SQL ="	select PlayerReln,ViewManage,convert(nvarchar,ViewManageDate,112)ViewManageDate  " & _
                            "	from tblMember" & _
                            "	where SportsType='"&SportsGb&"'" & _
                            "	and DelYN='N'" & _
                            "	and MemberIDX='"&MemberIDX&"'"  

                         SET cRs = DBCon.Execute(SQL)
                         If Not (cRs.Eof Or cRs.Bof) Then 
                            p_PlayerReln =cRs("PlayerReln")
                            p_ViewManage =cRs("ViewManage")
                            p_ViewManageDate =cRs("ViewManageDate")
                         end if
                         cRs.Close
		                SET cRs = Nothing

                        if p_TEAMTRAI ="Y" then
                            if p_PlayerReln = "K"  then
                                if p_ViewManage ="Y" then
                                      p_TEAMTRAI ="Y"
                                else
                                      p_TEAMTRAI ="N"
                                end if
                            end if 
                        end if 


                        Response.Write p_TEAMTRAI'&" / p_SvcStartDt : "&p_SvcStartDt&" / p_SvcEndDt : "&p_SvcEndDt&" / StimMidCd : "&trdate
                        Response.End

                else
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
                End IF
            Else 
                    IF  element ="exc-list" then
                        SQL ="EXEC View_Strength '"& SportsGb &"','"& MemberIDX &"','"& StimMidCd &"','"& StimFistCd &"',''"
                        SET LRs = DBCon.Execute(SQL)
                        selData="<ul id ='"&element&"'>"
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

                                readonly=""
                                IF LRs("Team") <>"" THEN 
                                    readonly="readonly"
                                END IF 

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
                                selData = selData&"<input id ='"&StimID&"' type='number' value="&StimData&" onfocus = 'this.select()' "&readonly&">"& StimMidUnit
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
