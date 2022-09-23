<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
	REQ = Request("REQ")
	
   	'REQ = "{""CMD"":3,""tIDX"":""47E0533CF10C4690F617881B06E75784"",""tStadiumIDX"":""775A4EB13A5B7CE6E0E1AAB80606E49A"",""tStadiumName"":""완도여자중학교"",""tCourtCnt"":""4""}"

	SET oJSONoutput = JSON.Parse(REQ)
	
	tIDX = fInject(oJSONoutput.tIDX)
	tStadiumIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tStadiumIDX))
	tStadiumName = fInject(oJSONoutput.tStadiumName)
	tCourtCnt = fInject(oJSONoutput.tCourtCnt)
	tAddr = fInject(oJSONoutput.tAddr)
	tAddrDtl = fInject(oJSONoutput.tAddrDtl) 

	'Response.Write "CMD :" & CMD & "<BR>"
	'Response.Write "tStadiumIDX :" & tStadiumIDX & "<BR>"
	'Response.Write "NowPage :" & NowPage & "<BR>"

	IF( tStadiumIDX <> "") Then

		LSQL = " 		UPDATE tblStadium SET "
		LSQL = LSQL & "		StadiumName = '" & tStadiumName &"'"
		LSQL = LSQL & "		,StadiumCourt = '" &  tCourtCnt & "'"
		LSQL = LSQL & "		,StadiumAddr = '" &  tAddr & "'"
		LSQL = LSQL & "		,StadiumAddrDtl = '" &  tAddrDtl & "'" 
		LSQL = LSQL & " WHERE StadiumIDX = '" &  tStadiumIDX & "'"
		
		'Response.Write "SQL :" & LSQL & "<BR>"
		
		DBCon.Execute(LSQL)
			
	End IF


	Call oJSONoutput.Set("result", 0 )
	
	strjson = JSON.stringify(oJSONoutput)
	
	Response.Write strjson

	DBClose()
%>
