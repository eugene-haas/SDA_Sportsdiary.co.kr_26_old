<%
Response.ContentType = "text/html"
Response.AddHeader "Content-Type", "text/html;charset=utf-8"
Response.CodePage = "65001"
Response.CharSet = "utf-8"

%>
<script type="text/javascript">

//분추가
function time_add(){
	var a = document.getElementById("minute");
	a.value = Math.min(a.value)+1;
}


//분감소
function time_minus(){
	var a = document.getElementById("minute");
	if(a.value>0){
		a.value = Math.min(a.value)-1;
	}else{
		alert("입력값은 -가 될수 없음");	
	}
}

//타이머 초기화
function time_reset(){
	var a = document.getElementById("minute");
	var b = document.getElementById("second");	
	a.value = 0;
	a.value = 00;
}

//타이머 시작
function time_start(){
	var a = document.getElementById("minute");
	if(a.value<=0){
		alert("타이머작동 값을 입력");
	}else{
		
	}
}

//타이머 멈춤


//타이머 점수입력
</script>
<input type="text" name="minute" id="minute" value="0">
<input type="text" name="second" id="second" value="00">
<input type="button" value="+" onclick="time_add();">
<input type="button" value="-" onclick="time_minus();">
<input type="button" value="시작" onclick="time_start();">
<input type="button" value="종료" >
<input type="button" value="점수입력" >
<input type="button" value="초기화" onclick="time_reset();">