<!--#include file="./include/config_top.asp" -->
<title>KATA Tennis 대회 참가신청</title>
<!--#include file="./include/config_bot.asp"-->
<!--#include file="./Library/ajax_config.asp"-->
<%  
    '=========================================================================================
  '대회참가신청 대회목록 페이지
  '=========================================================================================
  dim currPage      : currPage        = fInject(Request("currPage"))
  dim Fnd_KeyWord   : Fnd_KeyWord     = fInject(Request("Fnd_KeyWord"))
  
%>
<script>
  //대회목록조회
  function CHK_OnSubmit(valType, valIDX, chkPage){
  
    if(valType=="WR"){
      $('#Fnd_GameTitle').val(valIDX);   
      $('#act').val(valType);   
      
      if(chkPage!="") $("#currPage").val(chkPage);
      
      $('form[name=s_frm]').attr('action',"./write.asp");
      $('form[name=s_frm]').submit(); 
    }
    else{
	  //	console.log(chkPage);

      
      //리스트페이지
      var strAjaxUrl = "./ajax/list_GameTitle_info.asp";         
      var Fnd_KeyWord = $("#Fnd_KeyWord").val();
      
      if(chkPage!="") $("#currPage").val(chkPage);
      
      var currPage = $("#currPage").val();
      
      $.ajax({
        url: strAjaxUrl,
        type: "POST",
        dataType: "html",     
        data: { 
          currPage      : currPage
          ,Fnd_KeyWord    : Fnd_KeyWord       
        },    
        success: function(retDATA) {
        
          //console.log(retDATA);
          
          if(retDATA){
            var strcut = retDATA.split("|");
            
            //목록
            $("#tbl_list").html(strcut[0]);
            
            //페이징
            $("#page_list").html(strcut[1]);          
          }       
        }, 
        error: function(xhr, status, error){           
          if(error!=""){ 
            alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!"); 
            return; 
          }     
        }
      });  
    }
  }
  
  $(document).ready(function(){
    //참가신청 목록조회
    CHK_OnSubmit('LIST','',1);
  
  });              
</script>
</head>
<body class="lack_bg">
  <!-- S: header -->
  <!-- #include file = "./include/header.asp" -->
  <!-- E: header -->
  <form name="s_frm" method="post"> 
    <input type="hidden" id="currPage" name="currPage" value="<%=currPage%>" />
    <input type="hidden" id="Fnd_GameTitle" name="Fnd_GameTitle" />
    <input type="hidden" id="act" name="act" />
  <!-- S: main -->

  <!-- E: main -->
  </form>
</body>
</html>