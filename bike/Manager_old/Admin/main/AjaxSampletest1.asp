
<span id="ajaxButton" style="cursor: pointer; text-decoration: underline">
  Make a request
</span>

<script type="text/javascript" src="/js/CommonAjax.js"></script>

<script type="text/javascript">

CMD_SETJOO = 13 ; 

(function() {
  document.getElementById("ajaxButton").onclick = function() 
  {
     var obj = {};
     obj.UrlAddress ="/Ajax/ReqReturnASP.asp"
     obj.CMD = CMD_SETJOO
     obj.type = "json"
     console.log(obj)
     SendPacket(null, obj)
  };

})();

function OnReceiveAjax(data){
  switch (data.CMD)
  case 1 : break;

}



</script>