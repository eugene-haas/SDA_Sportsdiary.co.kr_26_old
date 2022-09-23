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

	score.gradeSearch = function(startkey){
		var gameidx = localStorage.getItem("GameTitleIDX"); //경기인덱스
		var searchstr1 = $("#SYear").val();
		var searchstr2 = $("#GroupGameGb").val();
		var searchstr3 = $("#TeamGb").val();
		var searchstr4 = $("#SexLevel").val();

		var title1 = $("#GroupGameGb  option:checked").text()
		var title2 = $("#TeamGb  option:checked").text()
		var title3 = $("#SexLevel  option:checked").text()
		var nextkey = localStorage.getItem('nextkey'); //다음 내용

		if (startkey == 's'){ //시작 페이지
			var parmobj = {'CMD':mx.CMD_GAMEGRADEPERSON,'S1':searchstr1,'S2':searchstr2,'S3':searchstr3,'S4':searchstr4,'NKEY':startkey };
			parmobj.T1 = title1;
			parmobj.T2 = title2;
			parmobj.T3 = title3;
			mx.SendPacket('div-gradelist', parmobj);
		}
		else{
			var parmobj = {'CMD':mx.CMD_GAMEGRADEPERSONAPPEND,'S1':searchstr1,'S2':searchstr2,'S3':searchstr3,'S4':searchstr4,'NKEY':nextkey };
			parmobj.T1 = title1;
			parmobj.T2 = title2;
			parmobj.T3 = title3;
			mx.SendPacket('table-gradelist', parmobj);
		}
	};
	
	score.showScore = function(){
		mx.SendPacket('round-res', {'CMD':mx.CMD_SETSCORE })			
	};

	score.setSearch = function(){
		var teamvalue = $("#TeamGb").val();
		if (teamvalue == '201'){
			drLevelList_sum("#SexLevel",teamvalue,"lineinsert");
		}else
		{
			drLevelList_sum("#SexLevel",teamvalue,"");		
		}
	};

	score.changeGroup = function(){
		var groupgb = $('#GroupGameGb').val();
		localStorage.setItem("GroupGameGb",groupgb);

		if ( groupgb == 'tn001001' ){ //개인전
			$('#TeamGb').children("option").remove();
			$('#TeamGb').append("<option value='200' selected>단식</option>");
			$('#TeamGb').append("<option value='201'>복식</option>");
		}
		else{
			$('#TeamGb').children("option").remove();
			$('#TeamGb').append("<option value='202'>복식</option>");
		}
		drLevelList_sum("#SexLevel",$("#TeamGb").val(),"");	
	}

    /*--------------------$(document).ready(function()--------------------*/
    $(document).ready(function(){
		localStorage.setItem("GroupGameGb",$('#GroupGameGb').val());		
		localStorage.setItem("nextkey",''); //초기화
		drLevelList_sum("#SexLevel",$("#TeamGb").val(),'');

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
	<!-- #include file = "./body/stat.body.asp" -->
</div>
 <!-- E: main -->

<!-- #include file = "./body/pop.point.asp" -->
<!-- #include file = "./body/pop.skill.asp" -->

<!-- #include virtual = "/pub/html/tennis/html.footer.asp" -->	
 <script src="js/main.js"></script>
</body>
</html>