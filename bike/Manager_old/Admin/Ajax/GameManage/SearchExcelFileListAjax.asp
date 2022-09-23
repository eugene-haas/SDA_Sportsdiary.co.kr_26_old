
<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->
<script language="Javascript" runat="server">
function hasown(obj,  prop){
  if (obj.hasOwnProperty(prop) == true){
    return "ok";
  }
  else{
    return "notok";
  }
}
</script>
<%
  Const PersonGame = "B0030001"
  Const GroupGame = "B0030002"
  
  REQ = Request("Req")
  Set oJSONoutput = JSON.Parse(REQ)

  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.Write "`##`"
  'Response.Write "StadiumCourt : " & StadiumCourt & "<BR/>"
%>       
 <%
  PersonGameCode =crypt.EncryptStringENC("B0030001")
  GroupGameCode =crypt.EncryptStringENC("B0030002")

  Dim strPath : strPath = "D:\badminton.sportsdiary.co.kr\badmintonAdmin\FileDown\xls\PersonGame"
  Dim FSO, Folder, Files, FilePath,filecolor
  '1.FileObject 생성
  Set FSO = Server.CreateObject( "Scripting.FileSystemObject" )
  '2. FolderObject 생성
  Set Folder = FSO.GetFolder(strPath) 
  '3. Files 가져오기
  Set Files = Folder.Files

  For Each file In Files
    If CDate(File.dateCreated) > Date - 300  then 
    iTotalCount = iTotalCount + 1 
    %>
    <tr>
      <td >
        <%=iTotalCount%>
      </td>
      <td >
        <a href="javascript:SelFileSheet('<%=File.Name%>','<%=PersonGameCode%>')" class="btn"><%=File.Name%></a>
      </td>
      <td>
        개인전
      </td>
      
      <td>
        <a href="javascript:RemoveFile('<%=File.Name%>', '<%=PersonGameCode%>')" class="btn btn-red">파일삭제</a>
      </td>
    </tr>

    <%
    End if
  Next
  Set Files = Nothing
  Set Folder = Nothing
  Set FSO = Nothing

  strPath = "D:\badminton.sportsdiary.co.kr\badmintonAdmin\FileDown\xls\GroupGame"
  '1.FileObject 생성
  Set FSO = Server.CreateObject( "Scripting.FileSystemObject" )
  '2. FolderObject 생성
  Set Folder = FSO.GetFolder(strPath) 
  '3. Files 가져오기
  Set Files = Folder.Files

  For Each file In Files
    If CDate(File.dateCreated) > Date - 300  then 
    iTotalCount = iTotalCount + 1 
    %>
    <tr>
      <td >
        <%=iTotalCount%>
      </td>
      <td >
          <a href="javascript:SelFileSheet('<%=File.Name%>', '<%=GroupGameCode%>')" class="btn"><%=File.Name%></a>
      </td>
      <td>
        단체전
      </td>
  
      <td>
        <a href="javascript:RemoveFile('<%=File.Name%>', '<%=GroupGameCode%>')"class="btn btn-red">파일삭제</a>
      </td>
    </tr>

    <%
    End if
  Next
  Set Files = Nothing
  Set Folder = Nothing
  Set FSO = Nothing


%>