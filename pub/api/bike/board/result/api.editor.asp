<%
'#############################################
'대진표 리그 화면 준비
'#############################################

'request
If hasown(oJSONoutput, "TIDX") = "ok" then
	r_tidx =  oJSONoutput.TIDX
End If
If hasown(oJSONoutput, "TITLE") = "ok" then
	title = oJSONoutput.TITLE
End if

Set db = new clsDBHelper

SQL = "Select gameresult from tblBikeTitle where TitleIdx = " & r_tidx
Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)

 If Not rs.eof Then
	contents = htmlDecode(rs(0))
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
				<div class="editor-box">
					<input type="radio" id="radio_notice01" name="noticetype" value="1" <%If noticetype="1" then%>checked<%End if%>>
					<label for="radio_notice01" class="label_edit">텍스트등록</label>
					 <textarea id="editor1">
					 <%
'					 if contents <> "" and isnull(contents) = false then
						response.write contents
'					 Else
'						response.write tempcontents
'					 end if
					 %>
					 </textarea>
		

	</div>
</div>

    <div id="rtbtnarea" class="modal-footer">
      <button type="button" data-dismiss='modal' aria-hidden='true' class="btn btn-default">닫기</button>
  	  <a href="javascript:mx.editOK(<%=r_tidx%>,'<%=title%>')" class='btn btn-primary'> 등록</a>
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
