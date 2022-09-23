<%
datareq = True

If hasown(oJSONoutput, "classCode") = "ok" then
    classCode = oJSONoutput.classCode
Else
    datareq = False
End IF 

If hasown(oJSONoutput, "detailType") = "ok" then
    detailType = oJSONoutput.detailType
Else
    datareq = False
End If

If datareq = False then
    Call oJSONoutput.Set("result", "1" ) '보낸값이  없음
    strjson = JSON.stringify(oJSONoutput)
    Response.Write strjson
    Response.write "`##`"
    Response.End	
End If


'중복확인
Set db = new clsDBHelper
SQL = " SELECT COUNT(*) FROM k_detailTypeList WHERE detailType = '"&detailType&"' AND ClassCode = '"&classCode&"' AND DelYN = 'N' "
Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)


If rs(0) > 0 then
    Call oJSONoutput.Set("result", "5" ) '중복 옵션 있음
    strjson = JSON.stringify(oJSONoutput)
    Response.Write strjson
    Response.write "`##`"
    Response.end
Else 
    SQL = " SET NOCOUNT ON INSERT INTO k_detailTypeList( ClassCode, DetailType, DelYN ) VALUES( '"&classCode&"', '"&detailType&"', 'N' ) SELECT @@IDENTITY" 
    Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)
End If

idx = rs(0) 

%>

<option value="<%=idx%>"  id="detailType_<%=idx%>" selected ><%=detailType%></option>
