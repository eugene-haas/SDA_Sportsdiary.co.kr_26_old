
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
    
    If hasown(oJSONoutput, "inputval") = "ok" then	 '입금일짜
	    inputval = oJSONoutput.inputval
    else
        inputval=""
    end if 

    if  inputkey =""  then 
    
    Call oJSONoutput.Set("result", "1" ) 
    
    else

   
     '업데이트  
    Sql=" insert into sd_TennisRPoint_log_bak select *,getdate(),'U' from sd_TennisRPoint_log where idx ='"&inputkey&"' "
    Call db.execSQLRs(Sql , null, ConStr)
    Sql1=" update sd_TennisRPoint_log set getpoint ='"&inputval&"' where idx ='"&inputkey&"'"
    Call db.execSQLRs(Sql1 , null, ConStr)
    '타입 석어서 보내기
    Call oJSONoutput.Set("result", "0" ) 

    end if 
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
	 
db.Dispose
Set db = Nothing
%>