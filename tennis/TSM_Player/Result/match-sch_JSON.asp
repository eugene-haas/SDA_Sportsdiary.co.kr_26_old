<!--#include file="../Library/ajax_config.asp"-->
<%
SportsGb 		=  Request.Cookies("SportsGb")
MemberIDX   	=  decode(Request.Cookies("MemberIDX"),0)
PlayerIDX   	=  decode(Request.Cookies("PlayerIDX"),0)
ID       		=  fInject(Request("ID"))
GameTitleIDX 	=  Request.Cookies("GameTitleIDX")
GameDay 	=   fInject(Request("GameDay"))

IF ID="idx" THEN 
    SQL ="EXEC View_match_SCH '"& SportsGb &"','"&GameTitleIDX&"','','','"&ID&"'":
    SET LRs = DBCon.Execute(SQL)	
    
    retext =  "["
    cnt = 1 

    IF Not(LRs.Eof Or LRs.Bof) Then 
        Do Until LRs.Eof 
            GameDay	        =LRs("GameDay") 
            GameDayNM		=LRs("GameDayNM") 

            retext = retext&"{""cnt"":"""&cnt&""",""GameDay"":"""&GameDay&""",""GameDayNM"":"""&GameDayNM&"""},"

            cnt =cnt+1
        LRs.MoveNext
        Loop 
    End IF
    LRs.Close

    retext = Mid(retext, 1, len(retext) - 1)
    retext = retext&"]"

    Response.Write retext
    	
ELSE
    SQL ="EXEC View_match_SCH '"& SportsGb &"','"&GameTitleIDX&"','"&GameDay&"','',''":
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
             retext = retext&"""GameDay"": """&LRs("GameDay") &""","
             retext = retext&"""GameArea"": """&LRs("GameArea") &""","
             retext = retext&"""Sido"": """&LRs("Sido") &""","
             retext = retext&"""SidoNm"": """&LRs("SidoNm") &""","
             retext = retext&"""SidoDtl"": """&LRs("SidoDtl") &""","
             retext = retext&"""PTeamGb"": """&LRs("PTeamGb") &""","
             retext = retext&"""PTeamGbNm"": """&LRs("PTeamGbNm") &""","
             retext = retext&"""TeamGb"": """&LRs("TeamGb") &""","
             retext = retext&"""TeamGbNm"": """&LRs("TeamGbNm") &""","
             retext = retext&"""Level"": """&LRs("Level") &""","
             retext = retext&"""LevelNm"": """&LRs("LevelNm") &""","
             retext = retext&"""GroupGameGb"": """&LRs("GroupGameGb") &""","
             retext = retext&"""GroupGameNm"": """&LRs("GroupGameNm") &""","
             retext = retext&"""GameType"": """&LRs("GameType") &""","
             retext = retext&"""GameTypeNm"": """&LRs("GameTypeNm") &""","
             retext = retext&"""StadiumNumber"": """&LRs("StadiumNumber") &""","
             retext = retext&"""TotRound"": """&LRs("TotRound") &""","
             retext = retext&"""EntryCnt"": """&LRs("EntryCnt") &"""},"
            cnt =cnt+1
        LRs.MoveNext
        Loop 
    End IF
    LRs.Close

    retext = Mid(retext, 1, len(retext) - 1)
    retext = retext&"]"

    Response.Write retext

END IF
SET LRs = Nothing
Dbclose()
%>
