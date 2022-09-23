<%
'#############################################
'게시판 편집기
'#############################################

'request
	If hasown(oJSONoutput, "IDX") = "ok" Then
		idx = oJSONoutput.IDX
	End If
	If hasown(oJSONoutput, "TID") = "ok" Then
		tid = oJSONoutput.TID
	End If
	If hasown(oJSONoutput, "PN") = "ok" Then
		pageno = oJSONoutput.PN
	End If

	If idx = "0" then
		title = "글쓰기"
	Else
		idx = f_dec(idx)
		title = "글수정"
	End if


Set db = new clsDBHelper

'유효성 체크
If isnumeric(tid) = False Or isnumeric(idx) = False Then
	tid = 0
	idx = 0
End if

strTableName = "tblBoard"
strFieldName = " seq,tid,uid,ip,title,contents,readnum,writeday,num,ref,re_step,re_level,filename,pubshow,topshow,bestshow "
strWhere =  " tid = "&tid&" and delYN = 'N' "

'카운트 업데이트 
SQL = "update tblBoard Set readnum = readnum + 1 where seq = " & idx
Call db.execSQLRs(SQL , null, B_ConStr)


SQL = "Select "&strFieldName&" from tblBoard where seq = " & idx
Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)

 If Not rs.eof Then
	title = htmlDecode(rs("title"))
	contents = htmlDecode(rs("contents"))
	writeday = rs("writeday")
'	updatefn = isNullDefault(rs(1),"")
''	updateimg = isNullDefault(rs(2),"")
'	noticetype = isNullDefault(rs(3),"1")
 End If

' tempcontents = "<div class=""contest_loadinfo""><p>제목이나 내용입력1</p><table><tr><th scope=""row"">항목명1</th><td>내용을 입력하세요.</td></tr><tr><th scope=""row"">항목명2</th>"
' tempcontents = tempcontents & "<td>내용을 입력하세요.</td></tr></table><p>제목이나 내용입력2</p><table><tr><th scope=""col"">항목명1</th><th scope=""col"">항목명2</th>"
' tempcontents = tempcontents & "<th scope=""col"">항목명3</th></tr><tr><td>내용을 입력하세요.</td><td>내용을 입력하세요.</td>"
' tempcontents = tempcontents & "<td>내용을 입력하세요.</td></tr></table><p>제목이나 내용입력3</p><p>제목이나 내용입력4</p></div>"
%>
<!-- 헤더 코트s -->

<div class="modal-dialog modal-xl">
  <div class="modal-content">


    <div class='modal-header'>
      <button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
      <h4 id='myModalLabel'><%=title%>   : <%=mid(Replace(writeday,"-","."),6,5)%></h4>
    </div>
  <!-- 헤더 코트e -->

    <div class="modal-body">



				<!-- <div id="cont" style="width:98%;height:80%;border:1px;solid;overflow:auto;" CONTENTEDITABLE><%'=contents%></div> -->
				<!-- <textarea name="editor1" id="editor1" rows="10" cols="80" ><%=contents%></textarea> -->
				


				<%'뷰 형태와 수정 형태 두개를 만들고 스크립트로 show hide%>
				<!-- <div class="editor-box" id = "viewarea">
				</div> -->


				<div class="editor-box" id= "editorarea">
					<!-- <label  class="label_edit">글제목</label>&nbsp; --><input type="text" id="title" name="title" class = "form-control" placeholder="제목을 입력해 주십시오." style="margin-bottom:5px;">
					<!-- <label for="radio_notice01" class="label_edit">텍스트등록</label> -->

					 <textarea id="editor1">
					 <%
					 if contents <> "" and isnull(contents) = false then
						response.write contents
					 Else
						response.write tempcontents
					 end if
					 %>
					 </textarea>

					 <hr width="98%">

					 <input type="radio" id="radio_notice02" name="noticetype" value="2" <%If noticetype="2" then%>checked<%End if%>>
					 <label for="radio_notice02" class="label_edit">이미지로등록</label>&nbsp;

					<form id="JPGFORM" method="post" enctype="multipart/form-data" action="" style="padding:10px;overflow:hidden;">
						<h5>
							jpg만 허용 
							<span style="font-weight:normal;margin-left:10px;">* 사이즈 가로 600px에 맞춰 등록해주세요</span>
						</h5>

						<div>
							<input type="hidden" id="uptype_img" name="uptype" value="img">
							<input type="hidden" id="title_idx_img" name="title_idx" value="<%=r_tidx%>">
							<input type="file" id="noticefile_img" name="noticefile" style="display:inline-block;">
							<a class='btn btn-primary' href="javascript:mx.fileUpload('noticeimg');">전송</a>
						</div>

						<div id="noticeimgs" class="noticeimgs" style="margin-top:10px;">
						<%
						If updateimg <> "" then
						arrimg = split(updateimg, ";")
					
						For i = 0 To ubound(arrimg)
							r_filenmstr = arrimg(i)
							If r_filenmstr <> "" Then
								uptype = "img"
								%><!-- #include virtual = "/pub/up/html.include.filelist.asp" --><%
							End if
						next

						End if		
						%>
						</div>
					</form>
				
					<form id="FILEFORM" method="post" enctype="multipart/form-data" action="" style="padding:10px;overflow:hidden;">
						<h5>pdf , hwp만 허용</h5>

						<div>
							<input type="hidden" id="uptype" name="uptype" value="file">
							<input type="hidden" id="title_idx" name="title_idx" value="<%=r_tidx%>">
							<input type="file" id="noticefile" name="noticefile" style="display:inline-block;">
							<a class='btn btn-primary' href="javascript:mx.fileUpload('attachment');">전송</a>
						</div>

						<div id="files" class="files" style="margin-top:10px;">
						<%
						If updatefn <> "" then
						arr = split(updatefn, ";")
					
						For i = 0 To ubound(arr)
							r_filenmstr = arr(i)
							If r_filenmstr <> "" Then
								uptype = "file"					
								%><!-- #include virtual = "/pub/up/html.include.filelist.asp" --><%
							End if
						next

						End if		
						%>
						</div>
					</form>
				</div>
</div>




    <div id="rtbtnarea" class="modal-footer">
      <button type="button" data-dismiss='modal' aria-hidden='true' class="btn btn-default">닫기</button>
	  <a href="javascript:mx.editOK(0,<%=tid%>,<%=pageno%>)" class='btn btn-primary'>글쓰기</a>
	  <!-- <a href="javascript:mx.editOK(<%=r_tidx%>,'<%=title%>')" class='btn btn-primary'>글쓰기</a> -->
    </div>



  </div>
</div>



<script>
	CKEDITOR.replace( 'editor1', {
		toolbar: [
			{ name: 'document', items: [ 'Print' ] },
			{ name: 'clipboard', items: [ 'Undo', 'Redo' ] },
			{ name: 'styles', items: [ 'Format', 'Font', 'FontSize' ] },
			{ name: 'basicstyles', items: [ 'Bold', 'Italic', 'Underline', 'Strike', 'RemoveFormat', 'CopyFormatting' ] },
			{ name: 'colors', items: [ 'TextColor', 'BGColor' ] },
			{ name: 'align', items: [ 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock' ] },
			{ name: 'links', items: [ 'Link', 'Unlink' ] },
			{ name: 'paragraph', items: [ 'NumberedList', 'BulletedList', '-', 'Outdent', 'Indent', '-', 'Blockquote' ] },
			{ name: 'insert', items: [ 'Image', 'Table' ] },
			{ name: 'tools', items: [ 'Maximize' ] },
			{ name: 'editing', items: [ 'Scayt' ] }
		],
		customConfig: '',
		disallowedContent: 'img{width,height,float}',
		extraAllowedContent: 'img[width,height,align]',
		extraPlugins: 'tableresize,uploadimage,uploadfile',
		height: 800,
		contentsCss: [ 'https://cdn.ckeditor.com/4.8.0/full-all/contents.css', 'mystyles.css' ],
		bodyClass: 'document-editor',
		format_tags: 'p;h1;h2;h3;pre',
		removeDialogTabs: 'image:advanced;link:advanced',
		stylesSet: [
			/* Inline Styles */
			{ name: 'Marker', element: 'span', attributes: { 'class': 'marker' } },
			{ name: 'Cited Work', element: 'cite' },
			{ name: 'Inline Quotation', element: 'q' },
			/* Object Styles */
			{
				name: 'Special Container',
				element: 'div',
				styles: {
					padding: '5px 10px',
					background: '#eee',
					border: '1px solid #ccc'
				}
			},
			{
				name: 'Compact table',
				element: 'table',
				attributes: {
					cellpadding: '5',
					cellspacing: '0',
					border: '1',
					bordercolor: '#ccc'
				},
				styles: {
					'border-collapse': 'collapse'
				}
			},
			{ name: 'Borderless Table', element: 'table', styles: { 'border-style': 'hidden', 'background-color': '#E6E6FA' } },
			{ name: 'Square Bulleted List', element: 'ul', styles: { 'list-style-type': 'square' } }
		]
	} );
</script>


<%
db.Dispose
Set db = Nothing
%>
