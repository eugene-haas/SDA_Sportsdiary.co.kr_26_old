
<!-- #include virtual = "/pub/ajax/riding/reqTennisRankPlayer.asp" -->
<%

'#############################################
' 랭크 포인트 조회
'#############################################
	'request
	Set db = new clsDBHelper
     
    If hasown(oJSONoutput, "inputkey") = "ok" then	 '입금일짜
	    inputkey = oJSONoutput.inputkey
    else
        inputkey=""
    end if  
   
    if inputkey <>"" then
        '업데이트  
        Sql=" insert into sd_TennisRPoint_log_bak select *,getdate(),'D' from sd_TennisRPoint_log where idx ='"&inputkey&"' "
        Call db.execSQLRs(Sql , null, ConStr)
        Sql1=" delete sd_TennisRPoint_log  where idx ='"&inputkey&"'"
        Call db.execSQLRs(Sql1 , null, ConStr)
    '타입 석어서 보내기
        Call oJSONoutput.Set("result", "4" )  
        Call oJSONoutput.Set("msg","삭제 되었습니다." ) 
    else
        Call oJSONoutput.Set("result", "1" )  
        Call oJSONoutput.Set("msg","번호["&inputkey&"] 삭제하는데 오류가 발생했습니다. 확인 해주시기 바랍니다." ) 
    end if 
     
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
	 
db.Dispose
Set db = Nothing
%>