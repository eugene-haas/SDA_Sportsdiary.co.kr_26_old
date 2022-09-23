<!--#include file="../Library/ajax_config.asp"-->
<%
SportsGb 		=  Request.Cookies("SportsGb")
MemberIDX   	=  decode(Request.Cookies("MemberIDX"),0)
PlayerIDX   	=  decode(Request.Cookies("PlayerIDX"),0)

ID       		=  fInject(Request("ID"))
GameTitleIDX 	=  Request.Cookies("GameTitleIDX")
GameDay 	    =  fInject(Request("GameDay"))


SQL ="EXEC View_match_search '"& SportsGb &"','','"&GameDay&"'":
SET LRs = DBCon.Execute(SQL)	
    
retext =  "["
cnt = 1 

IF Not(LRs.Eof Or LRs.Bof) Then 
    Do Until LRs.Eof 
            retext = retext&"{"
            retext = retext&"""GameTitleName"": """&LRs("GameTitleName") &""","
            retext = retext&"""GameTitleIDX"": """&LRs("GameTitleIDX") &""","
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
            retext = retext&"""Gamediff"": """&LRs("Gamediff") &""","

            retext = retext&"""GameYear"": """&LRs("GameYear") &""","
            retext = retext&"""GameArea"": """&LRs("GameArea") &""","
            retext = retext&"""Sido"": """&LRs("Sido") &""","
            retext = retext&"""SidoNm"": """&LRs("SidoNm") &""","
            retext = retext&"""SidoDtl"": """&LRs("SidoDtl") &""","
             
            retext = retext&"""GameRcvDateS"": """&LRs("GameRcvDateS") &""","
            retext = retext&"""GameRcvDateSyy"": """&LRs("GameRcvDateSyy") &""","
            retext = retext&"""GameRcvDateSmm"": """&LRs("GameRcvDateSmm") &""","
            retext = retext&"""GameRcvDateSdd"": """&LRs("GameRcvDateSdd") &""","
            retext = retext&"""GameRcvDateSName"": """&LRs("GameRcvDateSName") &""","

            retext = retext&"""GameRcvDateE"": """&LRs("GameRcvDateE") &""","
            retext = retext&"""GameRcvDateEyy"": """&LRs("GameRcvDateEyy") &""","
            retext = retext&"""GameRcvDateEmm"": """&LRs("GameRcvDateEmm") &""","
            retext = retext&"""GameRcvDateEdd"": """&LRs("GameRcvDateEdd") &""","
            retext = retext&"""GameRcvDateEName"": """&LRs("GameRcvDateEName") &""","
             
            retext = retext&"""GameRcvDateSdiff"": """&LRs("GameRcvDateSdiff") &""","
            retext = retext&"""GameDday"": """&LRs("GameDday") &""","
            retext = retext&"""color"": """&LRs("color") &""","
            retext = retext&"""MatchYN"": """&LRs("MatchYN") &""","
            
            retext = retext&"""cnt"": """&LRs("cnt") &"""},"

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
