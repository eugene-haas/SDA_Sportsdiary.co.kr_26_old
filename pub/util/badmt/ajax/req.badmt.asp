<!-- #include virtual = "/pub/header.mall.admin.asp" -->
<!-- #include virtual = "/pub/fn/fn.log.asp" -->
<!-- #include virtual = "/pub/fn/fn.utx.asp" -->    
<!-- #include virtual = "/pub/util/badmt/sql/sql.badmt.asp" -->

<%     
    ' Call writeLog(SAMALL_LOG1, "req.cpn.asp --. start")

    Dim db, rs, strSql
    Set db = new clsDBHelper
%>

<%
    ' Data 구분자 - ( html + json data ) 유무 
    CMD_DATAGUBUN                   = 10000        ' ( json + html data )
        
    ' ============================ command
    CMD_BADMT_MIN                                   = 50000

    CMD_SEARCH_REG_AMAUSER                       = 50001             ' 등록 리스트에서 아마추어 선수를 서치한다. 
    CMD_UPDATE_AMAUSER_INFO                      = 50002             ' 등록 리스트에서 아마추어 선수정보를 Update
    CMD_RESEND_SMS_AMAUSER                       = 50003             ' 재등록 할수 있도록 SMS를 재전송한다. 
    CMD_REQ_DIRECTREG_AMAINFO                    = 50004             ' 아마추어 Info를 바로 등록한다. 임시테이블에 

    CMD_BADMT_MAX                                   = 59999
%>

<%
Dim intTotalCnt, intTotalPage '총갯수, 총페이지수
Dim strReq, oJSONoutput, reqCmd
Dim hasError
'############################################
    strReq = request("REQ")

    ' 사용예 ex) http://www.sdamall.co.kr/pub/util/badmt/ajax/req.badmt.asp?test=t  - 실서버    
    ' 사용예 ex) http://dev.sdamall.co.kr/pub/util/badmt/ajax/req.badmt.asp?test=t  - 개발서버   
	If request("test") = "t" Then 
        strReq = "{""CMD"":50004,""DINFO"":[""일반부"",""16001"",""A"",""혼복"",""복식"",""B0020002"",""혼합"",""Mix"",""30"",""16001002"",""B"",""B0110002"",""육태형"",""19820326"",""Man"",""010-7616-9352"",""운천"",""광주"",""5"",""서구"",""5005"",""B"",""B0110002"",""조희정"",""19871010"",""Woman"",""010-5615-1924"",""운천"",""광주"",""5"",""서구"",""5005"",""B"",""B0110002""],""POS"":0}"
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
   hasError = 0                         ' Error 가 없다. 
   reqCmd = CDbl(reqCmd)

    ' ***********************************************************************************************
    ' DB Work
    ' ===============================================================================================    
    if (reqCmd >= CMD_BADMT_MIN And reqCmd <  CMD_BADMT_MAX) Then 
        ' Call writeLog(SAMALL_LOG1, "====================== Cate Command ==================")   
        %> <!-- #include virtual = "/pub/util/badmt/api/db.badmt.asp" --> <% 
        Response.End
    End If


%>

<% 
    ' Call writeLog(SAMALL_LOG1, "req.cpn.asp --. end")
%>