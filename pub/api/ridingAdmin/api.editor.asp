<%
'#############################################
'대진표 리그 화면 준비
'#############################################

'request
r_tidx = oJSONoutput.TIDX
title = oJSONoutput.TITLE

Set db = new clsDBHelper

SQL = "Select summary,filenames,summaryimg,noticetype from sd_tennisTitle where gametitleidx = " & r_tidx
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

 If Not rs.eof Then
	contents = htmlDecode(rs(0))
	updatefn = isNullDefault(rs(1),"")

	updateimg = isNullDefault(rs(2),"")
	noticetype = isNullDefault(rs(3),"1")
 End If
 

 tempcontents = "<div class=""contest_loadinfo""><p>제목이나 내용입력1</p><table><tr><th scope=""row"">항목명1</th><td>내용을 입력하세요.</td></tr><tr><th scope=""row"">항목명2</th>"
 tempcontents = tempcontents & "<td>내용을 입력하세요.</td></tr></table><p>제목이나 내용입력2</p><table><tr><th scope=""col"">항목명1</th><th scope=""col"">항목명2</th>"
 tempcontents = tempcontents & "<th scope=""col"">항목명3</th></tr><tr><td>내용을 입력하세요.</td><td>내용을 입력하세요.</td>"
 tempcontents = tempcontents & "<td>내용을 입력하세요.</td></tr></table><p>제목이나 내용입력3</p><p>제목이나 내용입력4</p></div>"
%>
<!-- 헤더 코트s -->

<div class="modal-dialog modal-xl">
  <div class="modal-content">


    <div class='modal-header'>
      <button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
      <h4 id='myModalLabel'>대회요강 : <%=title%></h4>
    </div>
  <!-- 헤더 코트e -->

    <div class="modal-body">
				<!-- <div id="cont" style="width:98%;height:80%;border:1px;solid;overflow:auto;" CONTENTEDITABLE><%'=contents%></div> -->
				<!-- <textarea name="editor1" id="editor1" rows="10" cols="80" ><%=contents%></textarea> -->
				<div class="editor-box">
					<input type="radio" id="radio_notice01" name="noticetype" value="1" <%If noticetype="1" then%>checked<%End if%>>
					<label for="radio_notice01" class="label_edit">텍스트등록</label>
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






<!-- 
	<span class="btn btn-success fileinput-button">
        <i class="glyphicon glyphicon-plus"></i>
        <span>Select files...</span>
        <input id="fileupload" type="file" name="files[]" multiple>
    </span>


    <div id="progress" class="progress">
        <div class="progress-bar progress-bar-success"></div>
    </div>

    <div id="files" class="files"></div>
 -->



    <div id="rtbtnarea" class="modal-footer">
      <button type="button" data-dismiss='modal' aria-hidden='true' class="btn btn-default">닫기</button>
  	  <a href="javascript:mx.editOK(<%=r_tidx%>,'<%=title%>')" class='btn btn-primary'>대회운영 요강 등록</a>
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
