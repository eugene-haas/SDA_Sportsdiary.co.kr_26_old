<!--#include file="../dev/include/common_function.asp"-->

<%
     itmp = Request("tmp")
     iMemberIDX  = Request("iidx")


     LSQL = "EXEC Favor_Y '"  & iMemberIDX & "'"
     'response.Write  "LSQL="&LSQL&"<br>"
     'response.End

     Set LRs  = DBcon.Execute(LSQL)

      
  If Not (LRs.Eof Or LRs.Bof) Then
  
		Do Until LRs.Eof
      
        LCnt = LCnt + 1
        iMemberIDX = LRs("MemberIDX")

  
      LRs.MoveNext
		Loop
  
	End If
  
  LRs.close
  
  DBClose()

  response.Write "Y"

%>