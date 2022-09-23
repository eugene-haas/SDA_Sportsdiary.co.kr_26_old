<%
'■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
Function nCode(pcodestr)
	Select Case pcodestr
	Case "949" 
	nCode = "charSet = ks_c_5601-1987"
	Exit function
	Case "932"
	nCode = "shift_jis"
	Exit function
	End select
End function


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

    fdname = "<img border=0 width=16 height=16 src='" & IURL & "folder.gif'> " & fl.name 
    Response.Write "<a href=javascript:viewfolder('"&srcpath_view&"')>" & fdname & "</a><br>"
    
    Response.Flush
  Next
end sub

'■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

sub findfile(folder)
  Dim where
  on error resume next
  set files = folder.Files
  
  i = 1
  For Each file In files
	If i = 1 Then
		where = " where path in ('" & Lcase(folder&"\"&file.name)& "'"
	else
		where = where & ",'" & Lcase(folder&"\"&file.name) & "'"
    End If
  i = i + 1
  Next

  where = where & ")  group by path,filename"
  SQL = "Select filename,max(ver),max(prefiletime),max(deleteflag) from "&svntable&" " & where
  Set rs = db.Execute(SQL)
  
  If Not rs.eof Then
	verdb = rs.GetRows
  Else
	verdb = "no"
  End if

'#################################################### 
  response.write "<table border='0' width='90%'>"

  for each file in files
	fileshow = true
	version = "<span class='ver'>....................version : 0</span>"  
	vernum = 0

	filecolor = ""
	lapse = DateDiff("h",CDate(file.dateLastModified),now)

	If CDbl(lapse)  < 3 Then '3시간
		filecolor = ";color:red;"
		fileshow = True
	Else
		If Cookies_svn = "1" Then
		fileshow = False
		End if
	End if	

	If verdb <> "no" Then
		for c = ubound(verdb,2) to 0  step -1
			If verdb(0,c) = file.name Then
				If CStr(verdb(3,c)) = "1" Then '삭제기록이 있다면
					version = "<span class='ver'>....................version :"& verdb(1,c) & " <font color='red'>....delete record<font></span>"
					vernum = verdb(1,c)
				Else
					version = "<span class='ver'>....................version :"& verdb(1,c) & "</span>"
					vernum = verdb(1,c)
				End if

				If CStr(file.dateLastModified) = CStr(verdb(2,c)) Then
					filecolor = ";color:#660000;"
				End if
			End If
		Next
	End if


	'charSet
	sitehomeurl = Replace(LCase(folder),basepath,"")
	pcode = findCharSet(sitehomeurl,arr2site)
	lastfileupdate = "<span class='fileupdate'>" & Replace(Replace(file.dateLastModified,"오전","am"),"오후","pm") & "</span>"

	If vernum = 0 then
	restorecmd = "javascript:alert('저장된 정보가 없습니다.')"
	Else
	restorecmd = "javascript:location.href='./restore.asp?upfile="&escape(folder&"\"&file.name)&"&pcode="&pcode&"';"
	End if

	deletecmd = "javascript:if(confirm('삭제하시겠습니까?')){location.href='./file.delok.asp?upfile="&escape(folder&"\"&file.name)&"&pcode="&pcode&"';}"

	viewcodecmd = "javascript:var openNewWindow = window.open('about:blank');openNewWindow.location.href='./view.asp?upfile="&escape(folder&"\"&file.name)&"&pcode="&pcode&"';"

	cmdbtn = "<span><input type='button' id='btn_blue' class='btn_08' value='source'  onclick="""&viewcodecmd&""">"
	cmdbtn = cmdbtn & "&nbsp;<input type='button' id='btn_orange' class='btn_08' value='restore' onclick="""&restorecmd&""">"
	cmdbtn = cmdbtn & "&nbsp;<input type='button' id='btn_orange' class='btn_08' value='delete' onclick="""&deletecmd&"""></span>"

	'파일종류(파일 확장자)
	If fileshow = True Then
	
	response.write "<tr>"
	If checkInStr(file.type,arrexcept) = true then
		Response.Write "<td><img border=0 width=16 height=16 src='" & svnurl & "img_ext/"&viewfileext(file.name)&".gif' onerror=javascript:this.src='" & svnurl & "img_ext/unknown.gif'>"

		If checkInStr(folder,arrexcepyurl) = false then
			filesize = "<span class='fsize'>....................file size :"& viewfilesize(file.size) & "</span>"
			If CDbl(file.size) < 70000 Then '파일크기 제한
				Response.Write " <a href='./ver.asp?upfile="&escape(folder&"\"&file.name)&"&pcode="&pcode&"' target='hiddenFrame'><span style='font-weight:bold;font-size:9pt;"&filecolor&"'>" & file.name & "</span></a> "&version &"</td>"
			Else
				Response.Write " <span style='font-weight:bold;font-size:9pt;"&filecolor&"'>" & file.name&filesize&"</span></td>"
			End if
		Else
		Response.Write " <span style='font-weight:bold;font-size:9pt;"&filecolor&"'>" & file.name & "</span></td>"
		End if

		If checkInStr(folder,arrexcepyurl) = false then
		Response.Write "<td width='150'>"&lastfileupdate&"</td>"
		Response.Write "<td width='170'>"&cmdbtn&"</td>"	
		End If

	Else
		Response.Write "<td><img border=0 width=16 height=16 src='" & svnurl & "img_ext/"&viewfileext(file.name)&".gif' onerror=javascript:this.src='" & svnurl & "img_ext/unknown.gif'>"
	    Response.Write " <span style='font-weight:bold;font-size:9pt;"&filecolor&"'>" & file.name & "</span></td>"
	End If
	response.write "</tr>"

	End if

'	Response.Write "<br><span style='font-size:8pt;'>"
'    Response.Write "(파일타입:" & file.type & ")"
'    Response.Write "&nbsp;&nbsp;&nbsp;"
'    Response.Write "(파일사이즈:" & viewfilesize(file.size) & ")"
'    Response.Write "<br>"
'    Response.Write "(마지막수정일시:" & file.dateLastModified & ")"
'    Response.Write "&nbsp;&nbsp;&nbsp;"
'    Response.Write "(마지막접속일시:" & file.dateLastAccessed & ")"
'    Response.Write "&nbsp;&nbsp;&nbsp;"
'    Response.Write "(생성일시:" & file.dateCreated & ")"
'    Response.Write "<br>"
'    Response.Write "(경로:" & file.path & ")"
'    Response.Write "</span><br>"

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
  if fn<>"" then
    if instr(fn,".")<>0 then
      temp = split(fn,".")
      viewfileext = temp(UBound(temp))
    end if
  end if
end function
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
  end if
end function
'■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
Function findCharSet(surl,arrData)
Dim i,n
	For i = 0 To UBound(arrData)
		For n = 0 To UBound(arrData(i))
			If CInt(InStr(LCase(surl),arrData(i)(n))) > 0 Then
				Select Case i
				Case 0
					findCharSet = "932"
					Exit function
				Case 1
					findCharSet = "cn"
					Exit function
				End select
			End if
		next
	Next
	If	findCharSet = "" Then
		findCharSet = "949"
	End if
End Function
'■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
Function checkInStr(checkStr,arrData)
	For i = 0 To UBound(arrData)
		If Cint(InStr(checkStr,arrData(i))) > 0 Then
			checkInStr = true
			Exit function
		End if
	Next
	checkInStr = false
End Function
'■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
%>