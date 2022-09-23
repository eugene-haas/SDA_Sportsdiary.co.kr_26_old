
<!--METADATA TYPE= "typelib"  NAME= "ADODB Type Library" FILE="C:\Program Files\Common Files\SYSTEM\ADO\msado15.dll"  -->
<!-- #include virtual = "/study_src/pub/charset.asp" -->

<!-- #include virtual = "/study_src/pub/class/db_helper.asp"-->
<!-- #include virtual="/study_src/pub/class/json2.asp" -->
<!-- #include virtual = "/study_src/cfg/cfg.etc.asp" -->
<!-- #include virtual = "/study_src/fn/fn.log.asp" -->  
<!-- #include virtual = "/study_src/fn/fn.sql.asp" -->
<!-- #include virtual = "/study_src/fn/fn.utiletc.asp" -->
<!-- #include virtual = "/study_src/fn/fn.utiletc.asp" -->

<%     
    Call writeLog(LOCAL_LOG1, "reqAjax.asp --. start")

    Dim db, rs, strSql
    Set db = new clsDBHelper
%>

<%
    ' Data 구분자 - ( html + json data ) 유무 
    CMD_REG_TESTID                      = 50001             ' Regist Test ID 
      
    ' ============================ 쿠폰 등록
%>

<%
Dim strReq, oJSONoutput, reqCmd
'############################################
    strReq = request("REQ")
    
    ' 사용예 ex) http://localhost/study_src/ajax/reqAjax.asp?test=t  - 개발서버   
	If request("test") = "t" Then 
        strReq = "{""CMD"":50001,""POS"":0,""SEX"":2}"
    End if

	If strReq = "" Then	
       Response.End 
    End if

	If InStr(strReq, "CMD") >0 then
	    Set oJSONoutput = JSON.Parse(strReq)
		reqCmd = oJSONoutput.CMD
	Else
		reqCmd = strReq
	End if

   Call oJSONoutput.Set("result", "1" ) '정상
   reqCmd = CDbl(reqCmd)

   Call writeLog(LOCAL_LOG1, "req command =  " & reqCmd)   

    ' ***********************************************************************************************
    ' Call Diallg
    ' ===============================================================================================
    ' 쿠폰 만들기 / 수정 Popup
    if (reqCmd = CMD_REG_TESTID) Then 
        Call writeLog(LOCAL_LOG1, "====================== CMD_REG_TESTID ==================")   
        %><!-- #include virtual = "/study_src/ajax/api/db.work.asp" --><%
        Response.End
    End If

%>

<% 
    Call writeLog(LOCAL_LOG1, "reqAjax.asp --. end")
%>