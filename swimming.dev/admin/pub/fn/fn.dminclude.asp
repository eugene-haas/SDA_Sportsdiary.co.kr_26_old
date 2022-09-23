<%
' **** Dynamic ASP include v.2.0
function fixInclude(content)
   out=""   
   if instr(content,"#include ")>0 then
        response.write "Error: include directive not permitted!"
        response.end
   end if     
   content=replace(content,"<"&"%=","<"&"%response.write ")   
   pos1=instr(content,"<%")
   pos2=instr(content,"%"& ">")
   if pos1>0 then
      before= mid(content,1,pos1-1)
      before=replace(before,"""","""""")
      before=replace(before,vbcrlf,""""&vbcrlf&"response.write vbcrlf&""")
      before=vbcrlf & "response.write """ & before & """" &vbcrlf
      middle= mid(content,pos1+2,(pos2-pos1-2))
      after=mid(content,pos2+2,len(content))
      out=before & middle & fixInclude(after)
   else
      content=replace(content,"""","""""")
      content=replace(content,vbcrlf,""""&vbcrlf&"response.write vbcrlf&""")
      out=vbcrlf & "response.write """ & content &""""
   end if
   fixInclude=out
end function

Function getMappedFileAsString(byVal strFilename)
  Dim fso
  Set fso = CreateObject("ADODB.Stream")
  fso.CharSet = "utf-8"
  fso.Open
  fso.LoadFromFile(Server.MapPath(strFilename))
  getMappedFileAsString = fso.ReadText()

'  Response.write(getMappedFileAsString)
 ' Response.End
  Set fso = Nothing
End Function


'execute (fixInclude(getMappedFileAsString("included.asp")))
%>