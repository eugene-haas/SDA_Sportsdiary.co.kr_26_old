
<%
'■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
sub findfolder(fc)
  on error resume next
  For Each fl in fc
    if err then
      'Response.Write err.Number
      if err.number=70 then
        Response.Write "사용 권한이 없습니다."
      end if
      err.Clear
      exit for
    end If
	errshow = ""

    srcpath_view = srcpath & "/" & fl.name
    srcpath_view = escape(srcpath_view)

    fdname = "폴더 " & fl.name 
    Response.Write "<a href=javascript:viewfolder('"&srcpath_view&"')>" & fdname & "</a><br>"
    
    Response.Flush
  Next
end sub

'■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

sub findfile(folder)
  Dim lapse,files,file,filecolor
  on error resume next
  set files = folder.Files

  response.write "<table border='0' width='90%'>"
  for each file in files

	lapse = DateDiff("h",CDate(file.dateLastModified),now)

	If CDbl(lapse)  < 3 Then '3시간
		filecolor = ";color:red;"
	End if	

	response.write "<tr>"
	Response.Write "<td>" & file.name & "</td>"
	response.write "</tr>"

    if err.number=70 then
      Response.Write "읽기 권한오류<br>"
      err.Clear
    end If
    Response.Flush
  Next

  response.write "</table>"  

  set files = nothing
end sub

'■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

function viewfileext(fn)
  Dim temp
  if fn<>"" then
    if instr(fn,".")<>0 then
      temp = split(fn,".")
      viewfileext = temp(UBound(temp))
    end if
  end if
end Function

'■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

function viewfilesize(fs)
  '기본적으로 바이트단위
  if fs<1024 then  '1024 보다 작으면 바이트단위로
    viewfilesize = fs & " Bytes"
  elseif fs<(1024*1024) then  'KB 단위
    viewfilesize = formatnumber((fs/1024),2) & " KB"
  elseif fs<(1024*1024*1024) then 'MB 단위
    viewfilesize = formatnumber((fs/(1024*1024)),2) & " MB"
  elseif fs<(1024*1024*1024*1024) then 'GB 단위
    viewfilesize = formatnumber((fs/(1024*1024*1024)),2) & " GB"
  else  'TB 단위
    viewfilesize = formatnumber((fs/(1024*1024*1024*1024)),2) & " TB"
  end If
end Function


'■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

%>