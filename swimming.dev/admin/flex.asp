<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>TEST대한수영연맹</title>
</head>
<body >

<%for i= 1 to 3%>
<div class="contaniner">
  <div class="item chichen">1</div>
  <div class="item salmon">2</div>
  <div class="item steak">3</div>
  <div class="item kebab">4</div>
  <div class="item kebab">5</div>
  <div class="item kebab">6</div>
  <div class="item kebab">7</div>
  <div class="item kebab">8</div>
</div>
<%next%>




<style>
  .contaniner{
    border:1px red solid;
    display: flex;
    /*display: inline-block;*/
    flex-direction: row;
    flex-wrap: wrap;
    align-items: stretch;
    justify-content: space-between;
  }
  .item{
    border: 1px seagreen solid;
    width: 100px;
    height: auto;
    /* height: 100px; */
  }
</style>


</body>
</html>	