<!--#include file="../Library/ajax_config.asp"-->
<%
SportsGb 		=  Request.Cookies("SportsGb")
Sex 		    =  Request.Cookies("Sex")
MemberIDX   	=  decode(Request.Cookies("MemberIDX"),0)
PlayerIDX   	=  decode(Request.Cookies("PlayerIDX"),0)

Tryear          = fInject(Request("Tryear"))
GameTitleIDX    = fInject(Request("GameTitleIDX"))

p_TrRerdIDX	=""
p_MentlCd	=""

p_AdtFistCd	=""
p_AdtInTp	=""
p_AdtMidCd =""

p_AdtWell	=""
p_AdtNotWell=""
p_AdtMyDiay=""
p_AdtAdvice	=""
p_AdtAdviceRe	=""

p_AdtWellCkYn	=""
p_AdtNotWellCkYn=""
p_AdtMyDiayCklYn	=""
p_AdtAdviceCkYn	=""
p_AdtAdviceReCkYn	=""


IF MemberIDX = "" Then 	
	Response.Write "FALSE"
	Response.End
Else 
    %>
    <div id="divTrRerdIDX">
    <%
        LSQL = "select* from tblSvcGameRerd  where SportsGb ='"&SportsGb&"' and MemberIDX ="&MemberIDX&" and MemberIDX ="&MemberIDX&" and DelYN ='N'"
        Set LRs = Dbcon.Execute(LSQL)
        IF Not (LRs.Eof Or LRs.Bof) Then 
        Do Until LRs.Eof 
            p_TrRerdIDX	=LRs("TrRerdIDX")
            p_MentlCd	=LRs("MentlCd")

            p_AdtFistCd	=LRs("AdtFistCd")
            p_AdtInTp	=LRs("AdtInTp")
            p_AdtMidCd=LRs("AdtMidCd")

            p_AdtWell	=LRs("AdtWell")
            p_AdtNotWell=LRs("AdtNotWell")	
            p_AdtMyDiay=LRs("AdtMyDiay")	
            p_AdtAdvice	=LRs("AdtAdvice")
            p_AdtAdviceRe	=LRs("AdtAdviceRe")

            p_AdtWellCkYn	=LRs("AdtWellCkYn")
            p_AdtNotWellCkYn	=LRs("AdtNotWellCkYn")
            p_AdtMyDiayCklYn	=LRs("AdtMyDiayCklYn")
            p_AdtAdviceCkYn	=LRs("AdtAdviceCkYn")
            p_AdtAdviceReCkYn	=LRs("AdtAdviceReCkYn")
            LRs.MoveNext
        Loop 
        end if
        LRs.Close
        %>
            <input type="hidden" name="p_TrRerdIDX"id="p_TrRerdIDX"value="<%=p_TrRerdIDX %>">
            <input type="hidden" name="p_MentlCd"id="p_MentlCd"value="<%=p_MentlCd %>">

            <input type="hidden" name="p_AdtFistCd"id="p_AdtFistCd"value="<%=p_AdtFistCd %>">
            <input type="hidden" name="p_AdtInTp"id="p_AdtInTp"value="<%=p_AdtInTp %>">
            <input type="hidden" name="p_AdtMidCd"id="p_AdtMidCd"value="<%=p_AdtMidCd %>">

            <input type="hidden" name="p_AdtWell"id="p_AdtWell"value="<%=p_AdtWell %>">
            <input type="hidden" name="p_AdtNotWell"id="p_AdtNotWell"value="<%=p_AdtNotWell %>">
            <input type="hidden" name="p_AdtMyDiay"id="p_AdtMyDiay"value="<%=p_AdtMyDiay %>">
            <input type="hidden" name="p_AdtAdvice"id="p_AdtAdvice"value="<%=p_AdtAdvice %>">
            <input type="hidden" name="p_AdtAdviceRe"id="p_AdtAdviceRe"value="<%=p_AdtAdviceRe %>">

                    
            <input type="hidden" name="p_AdtWellCkYn"id="p_AdtWellCkYn"value="<%=p_AdtWellCkYn %>">
            <input type="hidden" name="p_AdtNotWellCkYn"id="p_AdtNotWellCkYn"value="<%=p_AdtNotWellCkYn %>">
            <input type="hidden" name="p_AdtMyDiayCklYn"id="p_AdtMyDiayCklYn"value="<%=p_AdtMyDiayCklYn %>">
            <input type="hidden" name="p_AdtAdviceCkYn"id="p_AdtAdviceCkYn"value="<%=p_AdtAdviceCkYn %>">
            <input type="hidden" name="p_AdtAdviceReCkYn"id="p_AdtAdviceReCkYn"value="<%=p_AdtAdviceReCkYn %>">
    </div>
        <%
end if
SET LRs = Nothing
Dbclose()

%>




