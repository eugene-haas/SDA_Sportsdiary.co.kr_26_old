<!--#include file="../Library/ajax_config.asp"-->
<%
SportsGb 		=  Request.Cookies("SportsGb")
MemberIDX   	=  decode(Request.Cookies("MemberIDX"),0)
PlayerIDX   	=  decode(Request.Cookies("PlayerIDX"),0)
TrRerdDate 	    =  fInject(Request("TrRerdDate"))



    SQL ="EXEC View_sche_train '"& SportsGb &"',"&MemberIDX&",'"&TrRerdDate&"'"
    SET LRs = DBCon.Execute(SQL)	
    
    retext =  "["
    cnt = 1 

    IF Not(LRs.Eof Or LRs.Bof) Then 
        Do Until LRs.Eof 
             retext = retext&"{"
             retext = retext&"""TrRerdIDX"": """&LRs("TrRerdIDX") &""","
             retext = retext&"""TrRerdDate"": """&LRs("TrRerdDate") &""","
             retext = retext&"""MentlCd"": """&LRs("MentlCd") &""","
             retext = retext&"""MentlNm"": """&LRs("MentlNm") &""","

             retext = retext&"""AdtFistCd"": """&LRs("AdtFistCd") &""","
             retext = retext&"""AdtInTp"": """&LRs("AdtInTp") &""","
             retext = retext&"""AdtInTpNm"": """&LRs("AdtInTpNm") &""","
             retext = retext&"""AdtMidCd"": """&LRs("AdtMidCd") &""","
             retext = retext&"""AdtMIdNm"": """&LRs("AdtMIdNm") &""","
             retext = retext&"""bigo"": """&LRs("bigo") &""","
             retext = retext&"""TgtNm"": """&LRs("TgtNm") &""","
             

             
            ' retext = retext&"""AdtWell"": """&ReplaceTagReText(LRs("AdtWell")) &""","
            ' retext = retext&"""AdtNotWell"": """&ReplaceTagReText(LRs("AdtNotWell")) &""","
            ' retext = retext&"""AdtMyDiay"": """&ReplaceTagReText(LRs("AdtMyDiay")) &""","
            ' retext = retext&"""AdtAdvice"": """&ReplaceTagReText(LRs("AdtAdvice")) &""","
            ' retext = retext&"""AdtAdviceRe"": """&ReplaceTagReText(LRs("AdtAdviceRe")) &"""," 

            ' retext = retext&"""AdtWellCkYn"": """&LRs("AdtWellCkYn") &""","
            ' retext = retext&"""AdtNotWellCkYn"": """&LRs("AdtNotWellCkYn") &""","
            ' retext = retext&"""AdtMyDiayCklYn"": """&LRs("AdtMyDiayCklYn") &""","
            ' retext = retext&"""AdtAdviceCkYn"": """&LRs("AdtAdviceCkYn") &""","
            ' retext = retext&"""AdtAdviceReCkYn"": """&LRs("AdtAdviceReCkYn") &""","
             retext = retext&"},"

            cnt =cnt+1
        LRs.MoveNext
        Loop 
    End IF
    LRs.Close

    retext = Mid(retext, 1, len(retext) - 1)
    retext = retext&"]"

    Response.Write retext

SET LRs = Nothing
Dbclose()
%>
