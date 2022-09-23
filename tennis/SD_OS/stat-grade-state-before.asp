<!-- #include virtual = "/pub/header.tennis.asp" -->
<%=CONST_HTMLVER%>

<head>
<!-- #include virtual = "/pub/html/tennis/html.head.asp" -->


<script type="text/javascript">
<!--
      if ('addEventListener' in document) {
          document.addEventListener('DOMContentLoaded', function() {
              FastClick.attach(document.body);
          }, false);
      }

	var score =  score || {};


	score.gradeSearch = function(pn){
		var gameidx = localStorage.getItem("GameTitleIDX"); //경기인덱스
		var searchstr1 = $("#SYear").val();
		var searchstr2 = $("#SearchType").val();
		var searchstr3 = $("#SearchValue").val();
		if (searchstr3 == ''){
			if(searchstr2 == 'A'){
				alert("선수명을 입력해 주십시오.");
				return;
			}
			else{
				alert("소속명을 입력해 주십시오.");
				return;
			}
		}

		if (pn == 1){ //시작 페이지
			localStorage.setItem("nextpage",Number(pn) + 1);
			var parmobj = {'CMD':mx.CMD_GAMEGRADEGROUP,'S1':searchstr1,'S2':searchstr2,'S3':searchstr3,'PN':pn };
			mx.SendPacket('div-gradelist', parmobj);
		}
		else{
			var nextpn = localStorage.getItem('nextpage') ; //다음 내용
			localStorage.setItem("nextpage",Number(nextpn) + 1);
			var parmobj = {'CMD':mx.CMD_GAMEGRADEGROUPAPPEND,'S1':searchstr1,'S2':searchstr2,'S3':searchstr3,'PN':nextpn };
			mx.SendPacket('table-gradelist', parmobj);
		}
	};



    /*--------------------$(document).ready(function()--------------------*/
    $(document).ready(function(){
		localStorage.setItem("GroupGameGb",$('#GroupGameGb').val());		
		localStorage.setItem("listpageno",''); //새로고침 페이지 번호 초기화
		//drLevelList_sum("#SexLevel",$("#TeamGb").val(),'');

      //S:년,월 가져오기
      function selectdate(str, obj){
 
        var val_date = "";
        var strdata = "";
        var now = new Date();
        var nowyear = now.getFullYear();
        var nowmonth = now.getMonth() + 1;
        if(str == "year"){
          var beforeyear = nowyear-3;

          for (i=beforeyear;i<=nowyear;i++)
          {
              if (i == nowyear){
                strdata += "<option value='"+ i +"' selected>"+ String(i) +"년</option>";              
              }
              else{
                strdata += "<option value='"+ i +"' >"+ String(i) +"년</option>";              
              }
          }       
        }
        else if(str == "month"){
          for (i=1;i<=12;i++)
          {
            if (i == nowmonth){
              strdata += "<option value='"+ addzero(String(i)) +"' selected>"+ String(i) +"월</option>";
            }
            else{
              strdata += "<option value='"+ addzero(String(i)) +"'>"+ String(i) +"월</option>";            
            }
          }
        }

        $(obj).append(strdata);
      }
      //E:년,월 가져오기

      //조회조건 날짜 가져오기
      selectdate("year", "#SYear");
    });
    /*--------------------$(document).ready(function()--------------------*/

//    $(document).ajaxStart(function() {
//      apploading("AppBody", "조회 중 입니다.");
//    });
//    $(document).ajaxStop(function() {
//      $('#AppBody').oLoader('hide');
//    });
    //E:로딩바	
//-->
</script>

    

</head>
<body id="AppBody">

<!-- #include virtual = "/pub/html/tennis/html.top.asp" -->

<!-- S: main -->
<div class="main container-fluid">
	<!-- #include file = "./body/statbefore.body.asp" -->
</div>
 <!-- E: main -->

<!-- #include file = "./body/pop.point.asp" -->
<!-- #include file = "./body/pop.skill.asp" -->
<!-- #include file = "./body/pop.gradesamename.asp" -->

<!-- #include virtual = "/pub/html/tennis/html.footer.asp" -->	
 <script src="js/main.js"></script>
</body>
</html>

