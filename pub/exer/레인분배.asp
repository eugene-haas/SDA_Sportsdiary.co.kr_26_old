<!doctype html>
<html lang="en">
 <head>
  <meta charset="UTF-8">
  <meta name="Generator" content="EditPlus®">
  <meta name="Author" content="">
  <meta name="Keywords" content="">
  <meta name="Description" content="">
  <title>Document</title>
 <script src="http://img.sportsdiary.co.kr/lib/jquery/jquery-3.1.1.min.js"></script>
 </head>
 <body>

  <div id="aaa"></div>

<script type="text/javascript">
<!--

	function mapadd(plusstr){
		return plusstr + '함수에서더하기';
	}


//	const  aaa = [1,2,3,4,5];
	//const bbb = aaa.map( x => 1 + "더하기");
//	const bbb = aaa.map(x => mapadd(x));
//	const bbb = aaa.map((v, i) => v + i);  
//var bbb = aaa.map(v => ({even: v, odd: v + 1})); 
//	console.log( bbb );

var fives = [];
var evens = [2, 4, 6, 8,];

// Expression bodies (표현식의 결과가 반환됨)
var odds = evens.map(v => v + 1);   // [3, 5, 7, 9]
var nums = evens.map((v, i) => v + i);  // [2, 5, 8, 11]
var pairs = evens.map(v => ({even: v, odd: v + 1})); // [{even: 2, odd: 3}, ...]

// Statement bodies (블럭 내부를 실행만 함, 반환을 위해선 return을 명시)
nums.forEach(v => {
  if (v % 5 === 0)
    fives.push(v);
});


console.log(fives);

//v = 1,2,3,4,5
//i = 0,1,2,3,4
//1,3,5,7,9


$('#aaa').html('여기다가 : <span id="div"></span>');
$('#div').html('aaaa');

//-->
</script>

 </body>
</html>
