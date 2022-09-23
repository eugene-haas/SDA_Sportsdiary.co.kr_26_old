<!--#include file="../Library/ajax_config.asp"-->
<%
    Check_Login()
   
    dim QnAIDX   	: QnAIDX    	= fInject(Request("QnAIDX"))  '글IDX
    dim ReQnAIDX  	: ReQnAIDX    	= fInject(Request("ReQnAIDX"))  '답변구분
    dim WriterID  	: WriterID    	= fInject(Request("WriterID"))    '글작성자                                                                       
    dim MemberIDX   : MemberIDX 	= decode(request.Cookies("SD")("MemberIDX"), 0)
                                                                       
    dim txtData   '버튼 
    dim LSQL, LRs

    IF ReQnAIDX = "" OR WriterID = "" OR MemberIDX = "" Then
        response.End()
    End IF

  
' RESPONSE.Write "QnAIDX="&QnAIDX&"<BR>"
' RESPONSE.Write "ReQnAIDX="&ReQnAIDX&"<BR>"
' RESPONSE.Write "WriterID="&WriterID&"<BR>"
' RESPONSE.Write "MemberIDX="&MemberIDX&"<BR>"
  
  '=======================================================================================
  'CHK: 답변유무
  '=======================================================================================
  FUNCTION CHK_REPLYINFO(valIDX)
    dim REVALUE
    
    LSQL = " 		SELECT COUNT(*) "
    LSQL = LSQL & " FROM [SD_tennis].[dbo].[tblSvcQnA] "
    LSQL = LSQL & " WHERE DelYN = 'N' "
    LSQL = LSQL & " 	AND SportsGb = '"&SportsGb&"' "
    LSQL = LSQL & " 	AND QnAType = 'P' "
    LSQL = LSQL & " 	AND ReQnAIDX = "&valIDX
    
'   response.Write LSQL&"<br>"
        
    SET LRs = DBCon3.Execute(LSQL)     
    IF LRs(0)>0 Then
      REVALUE = "TRUE"
    Else
      REVALUE = "FALSE"
    End IF  
      LRs.Close
    SET LRs = Nothing         
    
    CHK_REPLYINFO = REVALUE
    
  END FUNCTION
  '=======================================================================================
  txtData = "<a href=""javascript:chk_URL('LIST');"" class='btn btn-cancel'>목록</a>"
  
  '작성자인 경우
  IF WriterID = MemberIDX Then  
    
'   response.Write "CHK_REPLYINFO(QnAIDX)="&CHK_REPLYINFO(QnAIDX)&"<br>"
    
    IF CHK_REPLYINFO(QnAIDX) = "FALSE" Then
      txtData = txtData &"  <a href=""javascript:chk_URL('DEL');"" class='btn delete'>삭제</a>"
      txtData = txtData &"  <a href=""javascript:chk_URL('MOD');"" class='btn btn-save'>수정</a>"
    End IF    
    
  End IF

  
  response.Write txtData

%>