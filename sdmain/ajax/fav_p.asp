<!--#include file="../Library/ajax_config.asp"-->


<%  
    iType =  "1"

    tmp  = Request("tmp")
    iLIMemberIDXG  = Request("iLIMemberIDXG")
    iUid  = Request("iUid")
    Most = Request("iMost")
    Rank = Request("Rank")

    iMemberIDX = "N"
    
     
     LSQL = "EXEC Favor_M '" & iType & "','" & iUid & "','" & iLIMemberIDXG & "','" & tmp & "','','','"&Most&"','"&Rank&"'"

     'response.Write  "LSQL="&LSQL&"<br>"
     'response.End

  Set LRs  = DBcon3.Execute(LSQL)

      
  If Not (LRs.Eof Or LRs.Bof) Then
  
		Do Until LRs.Eof
      
      'iMemberIDX = LRs("iMemberIDX")
      iMemberIDX = "Y"
  
      LRs.MoveNext
		Loop
  
	End If
  
  LRs.close
  
  DBClose()

  response.Write iMemberIDX


%>