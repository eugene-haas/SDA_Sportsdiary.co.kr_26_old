<%
	'두개에서 에서 공통을 사용 하나만 열면되게 수정
	If request("test") = "t" Then
		REQ ="{""CMD"":900,""PIDX"":""9003"",""HIDX"":""6861"",""HNM"":""신강자"",""PUBCODE"":""2"",""LEVELIDX"":""2874"",""GUBUNTYPE"":1,""SENDPRE"":""home_""}"
	Else
		REQ = request("REQ")
	End if

	If REQ = "" Then
		Response.End
	End if


	Set oJSONoutput = JSON.Parse( join(array(REQ)) )
	CMD = oJSONoutput.Get("CMD")
	SENDPRE = oJSONoutput.Get("SENDPRE") '전달받은 파일
%>
