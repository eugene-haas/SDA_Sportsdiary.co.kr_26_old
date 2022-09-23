
<span id="ajaxButton" style="cursor: pointer; text-decoration: underline">
  Make a request
</span>
<script src="/Js/jquery-1.12.2.min.js"></script>
<script type="text/javascript" src="/js/CommonAjax.js"></script>
<script type="text/javascript">

CMD_SETJOO = 13; 

(function() {
  document.getElementById("ajaxButton").onclick = function() 
  {
     Url ="/Ajax/ReqReturnASP.asp"
     var packet = {};
     packet.CMD = CMD_SETJOO
     SendPacket(Url, packet)
  };
})();

function OnReceiveAjax(data){
  alert("hi" + data)
}

</script>