<!--#include file="../../../dev/dist/config.asp"-->
<%
	
	iPeriodType = fInject(Request("iPeriodType"))
  iLocateIDX = fInject(Request("iLocateIDX"))


  LSQL = "EXEC AD_tblADLocate_PeriodType_R '" & iPeriodType & "','" & iLocateIDX & "'"
	'response.Write "LSQL=LSQL="&LSQL&"<br>"
  'response.End
 
  Set LRs = DBCon6.Execute(LSQL)
          
  If Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof

      PeriodTypeCash = LRs("PeriodTypeCash")

      LRs.MoveNext
    Loop
  End If
 
  LRs.close

	DBClose()

  response.Write PeriodTypeCash
%>