<!--#include file="../dev/dist/config.asp"-->
<%
	sk_gubun	= request("sk_gubun")
	sketch_idx	= request("sketch_idx")
	idx			= request("idx")

		
	LSQL = "EXEC Stadium_Sketch_result_ok	" &_
		   " @sk_gubun = '" & sk_gubun & "'"&_
		   ",@idx= '" & idx & "'"
			'response.Write LSQL&"<br>"
			'response.End
	Set LRs = DBCon7.Execute(LSQL)

	If Not (LRs.Eof Or LRs.Bof) Then

		  Do Until LRs.Eof

		  iMSeq = LRs(0)
			 Response.write iMSeq

		LRs.MoveNext
		  Loop

	  End If

	LRs.close
%>