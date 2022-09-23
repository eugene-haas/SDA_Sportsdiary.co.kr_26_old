<!--#include file="../Library/ajax_config.asp"-->
<%
SportsGb 		=  Request.Cookies("SportsGb")
MemberIDX   	=  decode(Request.Cookies("MemberIDX"),0)
PlayerIDX   	=  decode(Request.Cookies("PlayerIDX"),0)
YYMM            =  fInject(Request("YYMM"))


SQL ="EXEC View_sche_calendar_list '"& SportsGb &"','"& MemberIDX &"','"& PlayerIDX &"','"&YYMM&"'":
SET LRs = DBCon.Execute(SQL)	
retext =  "["
cnt = 1 
IF Not(LRs.Eof Or LRs.Bof) Then 
Do Until LRs.Eof 

    retext = retext&"{"
    retext = retext&"""titleDay"": """&LRs("titleDay") &""","
    retext = retext&"""id"": """&LRs("id") &""","
    retext = retext&"""title"": """&LRs("title") &""","
    retext = retext&"""subtitle"": """&LRs("subtitle") &""","
    retext = retext&"""bigo"": """&LRs("bigo") &""","
    retext = retext&"""className"": """&LRs("className") &""","
    retext = retext&"""titleid"": """&LRs("titleid") &""","
    retext = retext&"""cnt"": """&LRs("cnt") &"""},"

cnt=cnt+1
LRs.MoveNext
Loop 
End IF
LRs.Close
retext = Mid(retext, 1, len(retext) - 1)
retext = retext&"]"

SET LRs = Nothing

Response.Write retext

Dbclose()
%>
