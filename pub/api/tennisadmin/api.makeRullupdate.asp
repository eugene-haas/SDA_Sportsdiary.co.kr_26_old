<%

FSTR_idx = oJSONoutput.FSTR_idx 
FSTR = oJSONoutput.FSTR 
FSTR2 = oJSONoutput.FSTR2
order = oJSONoutput.order 
joono1 = oJSONoutput.joono1
joono2 = oJSONoutput.joono2 

Set db = new clsDBHelper

sql = "update sd_TennisKATARullMake " 
sql = sql & " set joono = '"&joono2&"'" 
sql = sql & " where idx='"&FSTR_idx&"'  " 

Call db.execSQLRs(sql , null, ConStr)	
 
sql = "select gameMemberIDX  " 
sql = sql & " from  sd_TennisMember "  
sql = sql & " where GameTitleIDX='"&FSTR&"'  and  gamekey3 ='"&CStr(Split(fstr2,",")(0))&"' and ISNULL(round,'')='' and delyn='N' "  

if order=1  then 
	sql = sql & " and rndno1='"&joono1&"' "
else
	sql = sql & " and rndno2='"&joono1&"' "
end if   
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)	


If Not rs.eof Then
		 
	sql = "update sd_TennisMember  "  
	if order=1  then 
		sql = sql & " set rndno1='"&joono2&"' "
	else
		sql = sql & " set rndno2='"&joono2&"' "
	end if  

	sql = sql & " where GameTitleIDX='"&FSTR&"'  and  gamekey3 ='"&CStr(Split(fstr2,",")(0))&"' and ISNULL(round,'')='' and delyn='N' "  

		if order=1  then 
			sql = sql & " and rndno1='"&joono1&"'"
		else
			sql = sql & " and rndno2='"&joono1&"'"
		end if  



		Call db.execSQLRs(sql , null, ConStr)	
End if


'타입 석어서 보내기
Call oJSONoutput.Set("result", "0" )  
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson
Response.write "`##`"


db.Dispose
Set db = Nothing
%>