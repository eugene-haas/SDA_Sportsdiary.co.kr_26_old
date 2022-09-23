<%

FSTR = oJSONoutput.FSTR 
FSTR2 = oJSONoutput.FSTR2
FSTR_idx = oJSONoutput.FSTR_idx 
       
If hasown(oJSONoutput, "sortno") = "ok" then	 
	sortno = oJSONoutput.sortno
end if 
       
If hasown(oJSONoutput, "order") = "ok" then	 
	order = oJSONoutput.order
end if 

If hasown(oJSONoutput, "joono") = "ok" then	 
	joono = oJSONoutput.joono
end if 


Set db = new clsDBHelper

if FSTR_idx ="" then 
    '타입 석어서 보내기
    Call oJSONoutput.Set("result", "100" )  


else
    setsql=""
    'sql = "insert into sd_TennisKATARullMake_log select * ,getdate(),'u' from [SD_Tennis].[dbo].sd_TennisKATARullMake where idx='"&FSTR_idx&"' " 
    'Call db.execSQLRs(sql , null, ConStr)	

    sql = "update sd_TennisKATARullMake " 
    sql = sql & " set "

    if sortno <>"" then 
         if setsql <>"" then 
            setsql = setsql &","
         end if
         setsql = setsql & " sortno ='"&sortno&"'"
    end if 

    if joono <>"" then 
         if setsql <>"" then 
            setsql = setsql &","
         end if
         setsql = setsql & " joono ='"&joono&"'"
    end if 

    if order <>"" then 
         if setsql <>"" then 
            setsql = setsql &","
         end if
         setsql = setsql & " orderno ='"&order&"'"
    end if 

    sql = sql & setsql
    sql = sql & " where idx='"&FSTR_idx&"' " 
    
    if setsql <> "" then
        Call db.execSQLRs(sql , null, ConStr)	
        '타입 석어서 보내기
        Call oJSONoutput.Set("result", "0" )  
    else
        Call oJSONoutput.Set("result", "100" )  
    end if 

end if 

strjson = JSON.stringify(oJSONoutput)
Response.Write strjson
Response.write "`##`"


db.Dispose
Set db = Nothing
%>