<!--#include file="../Library/ajax_config.asp"-->
<%
SportsGb 		=  Request.Cookies("SportsGb")
MemberIDX   	=  decode(Request.Cookies("MemberIDX"),0)
PlayerIDX   	=  decode(Request.Cookies("PlayerIDX"),0)

ID       		=  fInject(Request("ID"))
GameTitleIDX 	=  fInject(Request("GameTitleIDX"))
GameDay 	    =  fInject(Request("GameDay"))
StadiumNumber   =  fInject(Request("StadiumNumber"))

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

ELSEIF ID="stadium-state" THEN 
    SQL ="EXEC View_match_SCH '"& SportsGb &"','"&GameTitleIDX&"','"&GameDay&"','','"&ID&"'":
     'Response.Write  SQL
     'Response.end 
    SET LRs = DBCon.Execute(SQL)	
    
    retext =  "["
    cnt = 1 

    IF Not(LRs.Eof Or LRs.Bof) Then 
        Do Until LRs.Eof  
             retext = retext&"{"
             retext = retext&"""StadiumNumber"": """&LRs("StadiumNumber") &""","
             retext = retext&"""StadiumNumberNm"": """&LRs("StadiumNumberNm") &""","
             retext = retext&"""GroupGameGb"": """&LRs("GroupGameGb") &""","
             retext = retext&"""GroupGameNm"": """&LRs("GroupGameNm") &""","
             retext = retext&"""PTeamGb"": """&LRs("PTeamGb") &""","
             retext = retext&"""PTeamGbNm"": """&LRs("PTeamGbNm") &""","
             retext = retext&"""TeamGb"": """&LRs("TeamGb") &""","
             retext = retext&"""TeamGbNm"": """&LRs("TeamGbNm") &""","
             retext = retext&"},"
 
        LRs.MoveNext
        Loop 
    End IF
    LRs.Close

    retext = Mid(retext, 1, len(retext) - 1)
    retext = retext&"]"

    Response.Write retext
    
ELSEIF ID="stadium-list" THEN 
    SQL ="EXEC View_match_SCH '"& SportsGb &"','"&GameTitleIDX&"','"&GameDay&"','"&StadiumNumber&"','"&ID&"'":
     'Response.Write  SQL
     'Response.end 
    SET LRs = DBCon.Execute(SQL)	
    
    retext =  "["
    cnt = 1 

    IF Not(LRs.Eof Or LRs.Bof) Then 
        Do Until LRs.Eof  												
             retext = retext&"{"

             retext = retext&"""StadiumNumber"": """&LRs("StadiumNumber") &""","
            ' retext = retext&"""PlayerResultIDX"": """&LRs("PlayerResultIDX") &""","
            ' retext = retext&"""RGameLevelidx"": """&LRs("RGameLevelidx") &""","
             retext = retext&"""LUserName"": """&LRs("LUserName") &""","
             retext = retext&"""RUserName"": """&LRs("RUserName") &""","
             retext = retext&"""LSchoolName"": """&LRs("LSchoolName") &""","
             retext = retext&"""RSchoolName"": """&LRs("RSchoolName") &""","
             retext = retext&"""GroupGameNum"": """&LRs("GroupGameNum") &""","
             retext = retext&"""GameNum"": """&LRs("GameNum") &""","
            ' retext = retext&"""LPlayerIDX"": """&LRs("LPlayerIDX") &""","
            ' retext = retext&"""RPlayerIDX"": """&LRs("RPlayerIDX") &""","
            ' retext = retext&"""LTeam"": """&LRs("LTeam") &""","
            ' retext = retext&"""LTeamDtl"": """&LRs("LTeamDtl") &""","
            ' retext = retext&"""RTeam"": """&LRs("RTeam") &""","
            ' retext = retext&"""RTeamDtl"": """&LRs("RTeamDtl") &""","
             retext = retext&"""LResult"": """&LRs("LResult") &""","
             retext = retext&"""RResult"": """&LRs("RResult") &""","
             retext = retext&"""LResultNm"": """&LRs("LResultNm") &""","
             retext = retext&"""RResultNm"": """&LRs("RResultNm") &""","
             retext = retext&"""GameStatus"": """&LRs("GameStatus") &""","
             retext = retext&"""GroupGameGbNM"": """&LRs("GroupGameGbNM") &""","
             retext = retext&"""TeamGBNM"": """&LRs("TeamGBNM") &""","
             retext = retext&"""LevelNM"": """&LRs("LevelNM") &""","

            ' retext = retext&"""Sex"": """&LRs("Sex") &""","
             retext = retext&"""GroupGameGb"": """&LRs("GroupGameGb") &""","
             retext = retext&"""NowRoundNM"": """&LRs("NowRoundNM") &""","
             retext = retext&"""TurnNum"": """&LRs("TurnNum") &""","
             retext = retext&"""TempNum"": """&LRs("TempNum") &""","
             retext = retext&"""BeforGameStatus"": """&LRs("BeforGameStatus") &""","

             
             retext = retext&"},"
 
        LRs.MoveNext
        Loop 
    End IF
    LRs.Close

    retext = Mid(retext, 1, len(retext) - 1)
    retext = retext&"]"

    Response.Write retext
ELSE
    SQL ="EXEC View_match_SCH '"& SportsGb &"','"&GameTitleIDX&"','"&GameDay&"','',''":
     '   Response.Write  SQL

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
