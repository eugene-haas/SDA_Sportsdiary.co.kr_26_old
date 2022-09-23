<!doctype html>
 
 
<head>
<meta name="viewport" content="width=320; user-scalable=no" />
<meta http-equiv="Content-type" content="text/html; charset=utf-8">
<title>Camera</title>
 <script src="/bike/M_player/js/library/jquery-3.1.1.min.js"></script>

<%'<script src="/jquery/jquery.js"></script>%>
 
<script>
$(document).ready(function(){
    if (!('url' in window) && ('webkitURL' in window)) {
        window.URL = window.webkitURL;
    }
 
    $('#camera').change(function(e){
        $('#pic').attr('src', URL.createObjectURL(e.target.files[0]));
    });
});
</script>
</head>
 
 
 
<input type="file" id="camera" name="camera" capture="camera" accept="image/*" />
<br />
 
<img id="pic" style="width:100%;" />


<!-- 

<!doctype html>
 
 
<head>
<meta name="viewport" content="width=320; user-scalable=no" />
<meta http-equiv="Content-type" content="text/html; charset=utf-8">
<title>Camera</title>
<script src="/jquery/jquery.js"></script>
 
<script>
$(document).ready(function(){
    if (!('url' in window) && ('webkitURL' in window)) {
        window.URL = window.webkitURL;
    }
 
    $('#camcorder').change(function(e){
        $('#mov').attr('src', URL.createObjectURL(e.target.files[0]));
        // iOS Safari에서는 autoplay가 안먹히므로 알림
        alert('동영상 재생버튼을 누르시오');
    });
});
</script>
</head>
 
 
 
<input type="file" id="camcorder" name="camcorder" capture="camcorder" accept="video/*" />
<br />
 
<video id="mov"></video>
 -->

<!-- 
<!doctype html>
 
 
<head>
<meta name="viewport" content="width=320; user-scalable=no" />
<meta http-equiv="Content-type" content="text/html; charset=utf-8">
<title>Camera</title>
</head>
 
 
 
<form method="post" enctype="multipart/form-data" action="camera.php">
<input type="file" id="camera" name="camera" capture="camera" accept="image/*" />
<input type="file" id="camcorder" name="camcorder" capture="camcorder" accept="video/*" />
<br />
<input type="submit" value="전송" />
</form>

 -->
