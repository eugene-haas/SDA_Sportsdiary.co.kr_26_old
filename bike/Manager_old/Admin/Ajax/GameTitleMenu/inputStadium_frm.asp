<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
	REQ = Request("REQ")
   
   	'REQ = "{""CMD"":2,""tIDX"":""47E0533CF10C4690F617881B06E75784"",""tStadiumName"":""김"",""tCourtCnt"":""1"",""tAddr"":""서울"",""tAddrDtl"":""1-2""}"

	SET oJSONoutput = JSON.Parse(REQ)

	CMD = oJSONoutput.CMD
	'------------------------대회 기본 정보-------------------------------
	tIdx 			= fInject(crypt.DecryptStringENC(oJSONoutput.tIdx))
	tStadiumName 	= fInject(oJSONoutput.tStadiumName)
	tCourtCnt 		= fInject(oJSONoutput.tCourtCnt)
	tAddr 			= fInject(oJSONoutput.tAddr)  
	tAddrDtl 		= fInject(oJSONoutput.tAddrDtl)   

	LSQL = "		SET NOCOUNT ON "
	LSQL = LSQL & " INSERT INTO tblStadium (GameTitleIDX, StadiumName, StadiumCourt, StadiumAddr, StadiumAddrDtl) "
	LSQL = LSQL & " VALUES ('"&tIdx&"','"&tStadiumName&"','"&tCourtCnt&"','"&tAddr&"','"&tAddrDtl&"')" 
	LSQL = LSQL & " SELECT @@IDENTITY as IDX "

	'Response.Write "LSQL :" & LSQL & "<BR>"

	SET LRs = DBCon.Execute(LSQL)
	IF NOT (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof
			IDX = LRs("IDX")
			LRs.MoveNext
		Loop
	End If  

	Call oJSONoutput.Set("result", 0 )
	 
	strjson = JSON.stringify(oJSONoutput)
	
	Response.Write strjson

	
	DBClose()
%>
