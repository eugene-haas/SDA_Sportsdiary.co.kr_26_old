<!doctype html>
<html lang="en">
 <head>
  <meta charset="UTF-8">
  <title>Document</title>
 <link href="/pub/js/themes/smoothness/jquery-ui.min.css" rel="stylesheet" type="text/css" />
	<script src="/pub/js/jquery-1.11.1.min.js"></script>
	<script src="/pub/js/imgcavasupload.js"></script>
 </head>
 <body>

<style>
  [for=blue] { color: blue; }
  [for=green] { color: green; }
  [for=red] { color: red; }
</style>

<input id="uploadImage" type="file" name="photo" />
<input id="caption" type="text" name="caption" placeholder="caption" />

<label for="blue">Blue</label>
<input id="color" type="radio" name="color" value="blue" />

<label for="green">Green</label>
<input id="color" type="radio" name="color" value="green" />

<label for="red">Red</label>
<input id="color" type="radio" name="color" value="red" />

<canvas id="canvas" width="640" height="480" style="border:1px solid #ccc"></canvas>

<br />


<h5>Preview</h5>
<a href="#" id="imageData" type="text" target="_blank">
    <img id="preview" style="width:200px; height: 200px;" />
</a>



<!-- 


<form id="upload" action="#" method="POST" enctype="multipart/form-data">
<input type="hidden" id="MAX_FILE_SIZE" name="MAX_FILE_SIZE" value="300000" />

	<div style="text-align:center;">
		<input type="file" id="sns_photos" name="sns_photos[]" style="width:600px;" multiple="multiple" />
		
		<div id="filedragss" ><br>drop files here</div>

	</div>


	<div style="width:540px;height:60px;overflow:auto;margin-top:5px;padding-left:10px;text-align:center;padding-top:10px;">
		<span id="msg_btn"><input type="button" style="width:120px;" value="확인" onclick="gPage.SetImg();"></span>&nbsp;<input type="button" style="width:120px;" value="취 소" >
	</div>

</div>
</div>

<div id="submitbutton">
	<button type="submit">Upload Files</button>
</div>

<p id="progress"></p>
<div id="messages">
<p>Status Messages</p>
</div>

</form> -->



<script type="text/javascript">
<!--

//-->
</script>
 </body>
</html>





