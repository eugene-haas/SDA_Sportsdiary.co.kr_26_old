<!doctype html>
<html lang="ko">
 <head>
  <meta charset="UTF-8">
  <title>Document</title>
	<style type="text/css">
	body {
	  margin: 0;
	  padding: 0;
	  background-color: #FAFAFA;
	  font: 12pt "Tahoma";
	}

	* {
	  box-sizing: border-box;
	  -moz-box-sizing: border-box;
	}

	.page {
	  width: 21cm;
	  min-height: 29.7cm;
	  /*padding: 2cm;*/
	  padding:5cm 1.7cm 5cm 1.7cm;
	  margin: 1cm auto;
	  border: 1px #D3D3D3 solid;
	  border-radius: 5px;
	  background: white;
	  box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
	}

	.subpage {
	  /*padding: 1cm;*/
	  border: 5px black solid;
	  /*height: 256mm;*/
	  height:196mm;
	  /*outline: 2cm #FFEAEA solid;*/
	}

	.contents {
	  margin: 6.5cm 2cm 0cm 2cm;
	  border: 1px black solid;
	  /*height: 256mm;*/
	  height:50mm;
	  /*outline: 2cm #FFEAEA solid;*/
	}

	@page {
	  size: A4;
	  margin: 0;
	}

	@media print {
	  .page {
		margin: 0;
		border: initial;
		border-radius: initial;
		width: initial;
		min-height: initial;
		box-shadow: initial;
		background: initial;
		page-break-after: always;
	  }
	}	
</style>
 </head>
 <body>
  

<div class="book">

  <div class="page">
    <div class="subpage">제 DS-8211호<!-- Page 1/2 -->
		<div class="contents">
		<table style="width:100%" border="1">
		<tr>
			<td>남자초등부</td>
			<td>기록:4:34.31</td>
		</tr>
		<tr>
			<td>종목:자유형400M</td>
			<td>소속:백산초등학교</td>
		</tr>
		<tr>
			<td>1 위</td>
			<td>성명:조성빈</td>
		</tr>
		</table>
		</div>
	</div>
  </div>

  <div class="page">
    <div class="subpage">Page 2/2</div>
  </div>

  <div class="page">
    <div class="subpage">Page 2/2</div>
  </div>

  <div class="page">
    <div class="subpage">Page 2/2</div>
  </div>

</div>

 </body>
</html>
