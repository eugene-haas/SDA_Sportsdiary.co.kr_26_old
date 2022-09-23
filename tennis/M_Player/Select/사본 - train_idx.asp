<!--#include file="../Library/ajax_config.asp"-->
<%
SportsGb 		=  Request.Cookies("SportsGb")
Sex 		    =  Request.Cookies("Sex")
MemberIDX   	=  decode(Request.Cookies("MemberIDX"),0)
PlayerIDX   	=  decode(Request.Cookies("PlayerIDX"),0)

TrRerdDate      = fInject(Request("TrRerdDate"))

p_TrRerdIDX	=""
p_MentlCd	=""

p_AdtFistCd	=""
p_AdtInTp	=""
p_AdtMidCd =""
p_AdtMidCd1 =""

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
        LSQL = "select* from tblSvcTrRerd  where SportsGb ='"&SportsGb&"' and MemberIDX ="&MemberIDX&" and TrRerdDate =LTRIM(RTRIM(REPLACE('"&TrRerdDate&"','-',''))) and DelYN ='N'"

        LSQL = "EXEC View_train '"&SportsGb&"','"&MemberIDX&"','"&TrRerdDate&"','','tridx',0 "

        'Response.Write LSQL
        'Response.End
        Set LRs = Dbcon.Execute(LSQL)
        IF Not (LRs.Eof Or LRs.Bof) Then 
        Do Until LRs.Eof 
            p_TrRerdIDX	=LRs("TrRerdIDX")
            p_MentlCd	=LRs("MentlCd")

            p_AdtFistCd	=LRs("AdtFistCd")
            p_AdtInTp	=LRs("AdtInTp")

            p_AdtMidCd  =LRs("AdtMidCd")
            p_AdtMidCd1  =LRs("AdtMidCd")

            p_Injury  =LRs("Injury")
               
            p_AdtWell	    =LRs("AdtWell")
            p_AdtNotWell    =LRs("AdtNotWell")	
            p_AdtMyDiay     =LRs("AdtMyDiay")	
            p_AdtAdvice	    =LRs("AdtAdvice")
            p_AdtAdviceRe	=LRs("AdtAdviceRe")

            p_AdtWellCkYn	=LRs("AdtWellCkYn")
            p_AdtNotWellCkYn	=LRs("AdtNotWellCkYn")
            p_AdtMyDiayCklYn	=LRs("AdtMyDiayCklYn")
            p_AdtAdviceCkYn	=LRs("AdtAdviceCkYn")
            p_AdtAdviceReCkYn	=LRs("AdtAdviceReCkYn")
            p_TEAMTRAI	=LRs("TEAMTRAI")

            LRs.MoveNext
        Loop 
        end if
        LRs.Close
        %>
            <input type="hidden" name="p_TEAMTRAI"id="p_TEAMTRAI" value="<%=p_TEAMTRAI %>" >
            <input type="hidden" name="p_TrRerdIDX"id="p_TrRerdIDX" value="<%=p_TrRerdIDX %>">
            <input type="hidden" name="p_MentlCd"id="p_MentlCd" value="<%=p_MentlCd %>">
            <input type="hidden" name="btn-select"id="btn-select"   value="<%=p_AdtFistCd %>">
            <%
                IF p_AdtInTp ="A" THEN 
                    p_AdtMidCd=0
                    p_AdtMidCd1=0
                END IF

                IF p_AdtInTp="B" THEN 
                    p_AdtMidCd1=0
                END IF
                
                IF p_AdtInTp="C" THEN 
                    p_AdtMidCd=0
                    p_AdtInTp="A"
                END IF
             %>
            <input type="hidden" name="p_AdtFistCd"id="p_AdtFistCd"value="<%=p_AdtFistCd %>">
            <input type="hidden" name="p_AdtInTp"id="p_AdtInTp"value="<%=p_AdtInTp %>">
            <input type="hidden" name="p_AdtMidCd"id="p_AdtMidCd"value="<%=p_AdtMidCd %>">
            <input type="hidden" name="p_AdtMidCd1"id="p_AdtMidCd1"value="<%=p_AdtMidCd1 %>">
            <input type="hidden" name="p_Injury"id="p_Injury"value="<%=p_Injury %>">

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




