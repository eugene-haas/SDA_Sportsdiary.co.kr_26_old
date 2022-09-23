var mx =  mx || {};

$(document).ready(function(){
		localStorage.removeItem('MOREINFO');
		localStorage.removeItem('GAMEINFO');
		//mx.init();
}); 

mx.golevel = function(idx,gametitle){
	var obj = {};
	obj.IDX = idx;
	obj.TITLE = gametitle;
	localStorage.setItem('GAMEINFO', JSON.stringify( obj  ));
	location.href="./mobile_list_match.asp?idx="+idx;
};
