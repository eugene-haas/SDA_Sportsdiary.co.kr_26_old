<!--#include file="../Library/ajax_config.asp"-->
<%
SportsGb 		=  Request.Cookies("SportsGb")
MemberIDX   	=  decode(Request.Cookies("MemberIDX"),0)
PlayerIDX   	=  decode(Request.Cookies("PlayerIDX"),0)
ID       		=  fInject(Request("ID"))
GameTitleIDX 	=  fInject(Request("GameTitleIDX"))



    SQL ="EXEC View_sche_match_SCH '"& SportsGb &"',"&GameTitleIDX&","&MemberIDX
    SET LRs = DBCon.Execute(SQL)	
    
    retext =  "["
    cnt = 1 

    IF Not(LRs.Eof Or LRs.Bof) Then 
        Do Until LRs.Eof 
             retext = retext&"{"
             retext = retext&"""GameTitleName"": """&LRs("GameTitleName") &""","
             retext = retext&"""GameS"": """&LRs("GameS") &""","
             retext = retext&"""GameSYY"": """&LRs("GameSYY") &""","
             retext = retext&"""GameSMM"": """&LRs("GameSMM") &""","
             retext = retext&"""GameSDD"": """&LRs("GameSDD") &""","
             retext = retext&"""GameSNM"": """&LRs("GameSNM") &""","
             retext = retext&"""GameE"": """&LRs("GameE") &""","
             retext = retext&"""GameEYY"": """&LRs("GameEYY") &""","
             retext = retext&"""GameEMM"": """&LRs("GameEMM") &""","
             retext = retext&"""GameEDD"": """&LRs("GameEDD") &""","
             retext = retext&"""GameENM"": """&LRs("GameENM") &""","
             retext = retext&"""GameSTNM"": """&LRs("GameSTNM") &"""," 


             
             retext = retext&"""MentlNm"": """&LRs("MentlNm") &""","
             retext = retext&"""MentlCd"": """&LRs("MentlCd") &""","

            ' retext = retext&"""AdtWell"": """&ReplaceTagReText(LRs("AdtWell")) &""","
            ' retext = retext&"""AdtNotWell"": """&ReplaceTagReText(LRs("AdtNotWell")) &""","
            ' retext = retext&"""AdtMyDiay"": """&ReplaceTagReText(LRs("AdtMyDiay")) &""","
            ' retext = retext&"""AdtAdviceRe"": """&ReplaceTagReText(LRs("AdtAdviceRe")) &""","

             retext = retext&"""AdtWellCkYn"": """&LRs("AdtWellCkYn") &""","
             retext = retext&"""AdtNotWellCkYn"": """&LRs("AdtNotWellCkYn") &""","
             retext = retext&"""AdtMyDiayCklYn"": """&LRs("AdtMyDiayCklYn") &""","
             retext = retext&"""AdtAdviceCkYn"": """&LRs("AdtAdviceCkYn") &""","
             retext = retext&"""AdtAdviceReCkYn"": """&LRs("AdtAdviceReCkYn") &"""},"

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
