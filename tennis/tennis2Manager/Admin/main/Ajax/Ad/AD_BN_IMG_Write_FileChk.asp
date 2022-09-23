<!--#include file="../../../dev/dist/config.asp"-->
<%

	iMSeqe = fInject(Request("i4"))
  iMSeq = decode(iMSeqe,0)


  LSQL = "EXEC AD_tblADImageInfo_FileDel_Chk '" & iMSeq & "'"
	'response.Write "LSQL=LSQL="&LSQL&"<br>"
  'response.End
 
  Set LRs = DBCon6.Execute(LSQL)
          
  If Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof

      iResult = LRs("Result")

      LRs.MoveNext
    Loop
  End If
 
  LRs.close

	AD_DBClose()

  Response.Write iResult

%>