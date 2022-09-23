<!-- #include virtual = "/pub/header.ridingadmin.asp" -->
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=3">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge, chrome=1">
    <title>Tournament Tree</title>
  
    <script src="http://img.sportsdiary.co.kr/lib/jquery/jquery-3.1.1.min.js"></script>

<style type="text/css">
div {
  display: inline-block;
  width: 100px;
  height: 100px;
  border: 2px solid black;
  margin: 15px;
}
#vertical {
  direction: rtl;
  overflow-y: scroll;
  overflow-x: hidden;
  background: gold;
}
#vertical p {
  direction: ltr;
  margin-bottom: 0;
}
#horizontal {
  direction: rtl;
  transform: rotate(180deg);
  overflow-y: hidden;
  overflow-x: scroll;
  background: tomato;
  padding-top: 30px;
}
#horizontal span {
  direction: ltr;
  display: inline-block;
  transform: rotate(-180deg);
}	
</style>


<div id=vertical>
  <p>content
    <br>content
    <br>content
    <br>content
    <br>content
    <br>content
    <br>content
    <br>content
    <br>content
    <br>content
    <br>content
    <br>content
    <br>content</p>
</div>
<div id=horizontal><span> content_content_content_content_content_content_content_content_content_content_content_content_content_content</span>
</div>



  </body>
</html>

