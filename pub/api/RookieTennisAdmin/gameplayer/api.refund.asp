<%
'#############################################
'환불 취소상태 변경
'#############################################
'request
ridx = oJSONoutput.ridx

Set db = new clsDBHelper

SQL = "update SD_RookieTennis.dbo.TB_RVAS_LIST Set refundok  =  case when refundok = 'Y' then 'N' else 'Y' end,refunddate = getdate()  where CUST_CD = '" & Left(sitecode,2) & ridx & "' "
Call db.execSQLRs(SQL , null, ConStr)



Call oJSONoutput.Set("result", "0" )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson

db.Dispose
Set db = Nothing
%>

