<!--#include file="../library/ajax_config_bn.asp"-->
<%
	'Check_Login()
  
  isportsgb = fInject(Request("isportsgb"))
  iproductlocateidx = fInject(Request("iproductlocateidx"))
  idproductlocateidx = decode(iproductlocateidx, 0)
  iuserid = fInject(Request("iuserid"))
  imemberidx = fInject(Request("imemberidx"))
  idmemberidx = decode(imemberidx, 0)

  iType = "1"

  LSQL = "EXEC SD_AD.dbo.AD_tblADLog_M '" & iType & "','" & isportsgb & "','" & idproductlocateidx & "','" & iuserid & "','" & idmemberidx & "','','','','',''"

  'response.Write "LSQL="&LSQL&"<br>"
  'response.End

  Set LRs = DBCon6.Execute(LSQL)
  If Not (LRs.Eof Or LRs.Bof) Then
    
    Do Until LRs.Eof
  
      iResult = LRs("Result")
  
      LRs.MoveNext
	  Loop
  
  End If
	LRs.close

  response.Write iResult
  'response.Write LSQL

%>

