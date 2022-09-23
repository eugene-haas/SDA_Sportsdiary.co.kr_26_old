<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script>
function chk_frm(){
	frm.action="ProfilePhoto.asp"
	frm.submit();
}
</script>
<html>
 <head>
  <title> New Document </title>
  <meta name="Generator" content="EditPlus">
  <meta name="Author" content="">
  <meta name="Keywords" content="">
  <meta name="Description" content="">
 </head>

 <body><div class="l">
 <form name="frm" method="post" enctype="multipart/form-data">
  <input type="file" name="profile">
	<input type="hidden" name="memcode" value="1">
	<a href="javascript:chk_frm();">전송</a>
 </div></body>
</html>
