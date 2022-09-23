<!-- #include virtual="/pub/class/json2.asp" -->
<%

'############################################################
'DEC_GameLevelDtlIDX = Request("GameLevelDtlIDX")
'DEC_TeamGameNum = Request("TeamGameNum")
'DEC_GameNum = Request("GameNum")

DEC_GameLevelDtlIDX = chkInt(chkReqMethod("GameLevelDtlIDX", "GET"), 1185)
DEC_TeamGameNum = chkInt(chkReqMethod("TeamGameNum", "GET"), 2)
DEC_GameNum = chkInt(chkReqMethod("GameNum", "GET"), 1)


'DEC_GameLevelDtlIDX = 1185
'DEC_TeamGameNum = 2
'DEC_GameNum = 1
%>

<!-- #include virtual="/pub/inc/inc.scoreboard.asp" -->