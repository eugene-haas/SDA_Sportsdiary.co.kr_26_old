<!--#include file="../../dev/dist/config.asp"-->
<%

  fnd_KeyWord 	= fInject(Request("fnd_KeyWord"))

  ' EXEC AD_tblADCode_S '1','10','10','1','3','tennis','','','','','IMGTYPE','','','','T','','S2Y','테니','','','',''
  LSQL = "EXEC AD_tblADCode_S '1','10','10','1','3','tennis','','','','','IMGTYPE','','','','T','','S2Y','" & fnd_KeyWord & "','','','',''"
  'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = DBCon6.Execute(LSQL)
           
  If Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      LCnt = LCnt + 1
%>
      <li>
        <a href="javascript:;" onclick="javascript:input_KeyWord('<%=LRs("Code01Name")%>','<%=LRs("Code01")%>');">

          <span><%=replace(LRs("Code01Name"),fnd_KeyWord, "<strong>"&fnd_KeyWord&"</strong>")%></span>

        </a>
      </li>
<%
	    LRs.MoveNext
		Loop
	End If

  LRs.Close
	SET LRs = Nothing
  AD_DBClose()

%>
