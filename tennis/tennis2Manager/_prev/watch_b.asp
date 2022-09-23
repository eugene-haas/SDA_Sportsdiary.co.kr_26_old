<html>
<style type="text/css">
h1 {
  text-align: center;
  font-family: 'Open Sans', sans-serif;
}

span.timerVal {
  font-family: 'Lato', sans-serif;
  font-size: 30px;

}

#timerLabel {
  margin-top: 7px;
}

.timer {
    -webkit-touch-callout: none;
    -webkit-user-select: none;
    -khtml-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none;
}
</style>
<script src="index.js"></script>
<body>
<div class="container">
  <div class="row">
    <div class="col-xs-12">
      <h1>Kitchen Timer  <i class="fa fa-plus-circle fa-1x" id="addTimerBtn" aria-hidden="true"></i></h1>
    </div>
  </div>
  <div id="timers">
  </div>
</div>

<script id="timerTemplate" type="text/x-handlebars-template">
	<div class="row well timer" timerId="{{timerId}}" style="display:none">
		<div class="col-lg-offset-2 col-lg-4 col-sm-offset-1 col-sm-4 col-xs-8">
    	<input type="text" class="form-control" id="timerLabel" placeholder="Timer Name">
    </div>
		<div class="col-lg-2 col-sm-2 col-xs-4">
      <span class="timerVal">00:00</span>
    </div>
    <div class="col-lg-4 col-sm-5 col-xs-12">
      <i class="fa fa-play-circle fa-2x" aria-hidden="true"></i>
      <i class="fa fa-plus-circle fa-2x" aria-hidden="true"></i>
      <i class="fa fa-minus-circle fa-2x" aria-hidden="true"></i>
      <i class="fa fa-refresh fa-2x" aria-hidden="true"></i>
      <i class="fa fa-times fa-3x" aria-hidden="true"></i>
  	</div>
  </div>
</script>

<script id="timerAlertTemplate" type="text/x-handlebars-template">
    <div id="timer{{timerName}}Alert" title="Timer Expired: {{timerName}}>
        <p>The timer {{timerName}} has expired!</p>
    </div>
</script>
</body>
</html>
