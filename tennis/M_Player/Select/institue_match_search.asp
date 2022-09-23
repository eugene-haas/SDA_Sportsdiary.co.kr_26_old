<!--#include file="../Library/ajax_config.asp"-->
<%
SportsGb 		=  Request.Cookies("SportsGb")
MemberIDX   	=  decode(Request.Cookies("MemberIDX"),0)
PlayerIDX   	=  decode(Request.Cookies("PlayerIDX"),0)
SQL ="EXEC View_match_search '"& SportsGb &"'":
SET LRs = DBCon.Execute(SQL)	
retext =  "["
cnt = 1 
IF Not(LRs.Eof Or LRs.Bof) Then 
Do Until LRs.Eof 
GameTitleIDX	=LRs("GameTitleIDX") 
SportsGb		=LRs("SportsGb") 
GameGb		=LRs("GameGb") 
PubName		=LRs("PubName") 
EnterType		=LRs("EnterType") 
EnterTypeNm		=LRs("EnterTypeNm") 
GameTitleName		=LRs("GameTitleName") 
GameS		=LRs("GameS") 
GameE		=LRs("GameE") 
GameYear		=LRs("GameYear") 
GameArea		=LRs("GameArea") 
Sido		=LRs("Sido") 
SidoNm		=LRs("SidoNm") 
SidoDtl		=LRs("SidoDtl") 

    if cnt=LRs("cnt") then 
        retext = retext&"{""id"":"""&GameTitleIDX&""",""title"":"""&GameTitleName&""",""start"":"""&GameS&""",""end"":"""&GameE&""",""color"":""""}"
    else 
       retext = retext&"{""id"":"""&GameTitleIDX&""",""title"":"""&GameTitleName&""",""start"":"""&GameS&""",""end"":"""&GameE&""",""color"":""""},"
    end if
cnt=cnt+1
LRs.MoveNext
Loop 
End IF
	LRs.Close
SET LRs = Nothing
retext = retext&"]"

Response.Write retext

Dbclose()
%>
