<%
'#############################################
'대진표 리그 화면 준비 
'#############################################

'request
tidx = oJSONoutput.TIDX
title = oJSONoutput.TITLE

Set db = new clsDBHelper

SQL = "Select summary from sd_tennisTitle where gametitleidx = " & tidx
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

 If Not rs.eof Then
	contents = htmlDecode(rs(0))
 End if
%>
<!-- 헤더 코트s -->
  <div class='modal-header game-ctr'>
    <button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
    <h3 id='myModalLabel'>대회요강 : <%=title%></h3>
  </div>
<!-- 헤더 코트e -->


	<!-- <div id="cont" style="width:98%;height:80%;border:1px;solid;overflow:auto;" CONTENTEDITABLE><%'=contents%></div> -->
	<!-- <textarea name="editor1" id="editor1" rows="10" cols="80" ><%=contents%></textarea> -->
	<textarea id="editor1"><%=contents%></textarea>

  <div id="rtbtnarea" style="width:98%;margin:auto;height:40px;overflow:auto;text-align:center;padding-top:5px;font-size:18px;">
	<a href="javascript:mx.editOK(<%=tidx%>,'<%=title%>')" class='btn_a btn_func'  style="height:30px;font-size:18px;">대회운영 요강 등록</a>
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
