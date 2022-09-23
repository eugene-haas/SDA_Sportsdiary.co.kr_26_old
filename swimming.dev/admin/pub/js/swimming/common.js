var px =  px || {};

px.go = function(packet,gourl){

	//if ($("form[name=sform]").length == 0){
	//if( document.sfrom == undefined ){
	//	document.body.innerHTML = "<form method='post' name='sform'><input type='hidden' name='p'></form>";
	//}
	
	document.sform.p.value =   JSON.stringify( packet  );
	document.sform.action = gourl;
	document.sform.submit();
};
