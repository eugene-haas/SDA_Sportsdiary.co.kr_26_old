<%

mxjoono = oJSONoutput.mxjoono  
Set db = new clsDBHelper

sql = "delete [SD_Tennis].[dbo].sd_TennisKATARullMake where mxjoono='"&mxjoono&"'  " 
Call db.execSQLRs(sql , null, ConStr)	
  
'타입 석어서 보내기
Call oJSONoutput.Set("result", "20" )  
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson
Response.write "`##`"
 
db.Dispose
Set db = Nothing
%>