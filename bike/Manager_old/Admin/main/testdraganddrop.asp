<html>
<head>
<script src="/js/jquery-1.12.2.min.js"></script>
<script type="text/javascript">
$(document).ready(function() {
  $(".up, .down").click(function() {
    var $element = this;
    var row = $($element).parents("tr:first");
    var swapRow = $(this).is('.up') ? row.prev() : row.next();
    
    if ($(this).is('.up')) {
        row.insertBefore(swapRow);
    } else {
        row.insertAfter(swapRow);
    }
    
   	if(swapRow.children()) {
    	var tempValue = row.children().first().html();
      row.children().first().html(swapRow.children().first().html());
      swapRow.children().first().html(tempValue);
    }
  });
});
</script>
</head>
<body>
<table>
  <tr>
    <td>1</td>
    <td>Title 1</td>
    <td>Body 1</td>
    <td>
      <button class="up">Up </button>
      <button class="down">Down </button>
    </td>
  </tr>
  <tr>
    <td>2</td>
    <td>Title 2</td>
    <td>Body 2</td>
    <td>
      <button class="up">Up </button>
      <button class="down">Down </button>
    </td>
  </tr>
  <tr>
    <td>3</td>
    <td>Title 3</td>
    <td>Body 3</td>
    <td>
      <button class="up">Up </button>
      <button class="down">Down </button>
    </td>
  </tr>
  <tr>
    <td>4</td>
    <td>Title 4</td>
    <td>Body 4</td>
    <td>
      <button class="up">Up </button>
      <button class="down">Down </button>
    </td>
  </tr>
</table>

</body>
</html>