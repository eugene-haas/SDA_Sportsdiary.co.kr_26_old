function init(){	
	backtoTop();	
}

function backtoTop() {
	var $topButton = $(".backtoTop");

	$(window).on("scroll", function(){
		if ($(window).scrollTop() > 500) {
			buttonOn();
		}else{
			buttonOff();
		}
	});
	function buttonOn() {
		$topButton.on("click", "a", function(b) {
			b.preventDefault();
			$("html, body").scrollTop(0);
			buttonOff();
		});
		$topButton.addClass("show");
	}
	function buttonOff() {
		$topButton.removeClass("show");
	}
}

/*===============================================================================
'Description : trim 함수와 동일한 기능 
'===============================================================================*/
function trim(str) {
		return str.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
}

/*===============================================================================
'Description : formatnumber 함수와 동일한 기능 
'===============================================================================*/
function commify(n) {    
	var reg = /(^[+-]?\d+)(\d{3})/;    n += '';     
	while (reg.test(n))        
	n = n.replace(reg, '$1' + ',' + '$2');    
	return n;
} 



/*박스 생성S*/
function make_box(element,attname,code,action_type){
	if(action_type=="SportsGb"){
		var strAjaxUrl = "/Manager/Select/Sports_Select.asp";		
	}else if(action_type=="PlayerGb"){
		var strAjaxUrl = "/Manager/Select/Player_Select.asp";		
	}else if(action_type=="Sex_Radio"){
		var strAjaxUrl = "/Manager/Select/Sex_Radio.asp";				
	}else if(action_type=="Sex_Select"){
		var strAjaxUrl = "/Manager/Select/Sex_Select.asp";						
	}else if(action_type=="search_Sex_Select"){
		var strAjaxUrl = "/Manager/Select/search_Sex_Select.asp";						
	}else if(action_type=="Sex_Select_Change"){
		var strAjaxUrl = "/Manager/Select/Sex_Select_Change.asp";								
	}else if(action_type=="Sex_Select_Change2"){
		var strAjaxUrl = "/Manager/Select/Sex_Select_Change2.asp";								
	}else if(action_type=="Year"){
		var strAjaxUrl = "/Manager/Select/Year_Select.asp";	
	}else if(action_type=="Year_Small"){
		var strAjaxUrl = "/Manager/Select/Year_Select_Small.asp";			
	}else if(action_type=="Year_GameTitle"){
		var strAjaxUrl = "/Manager/Select/Year_GameTitle_Select.asp";					
	}else if(action_type=="Month"){
		var strAjaxUrl = "/Manager/Select/Month_Select.asp";
	}else if(action_type=="Day"){
		var strAjaxUrl = "/Manager/Select/Day_Select.asp";
	}else if(action_type=="Tall"){
		var strAjaxUrl = "/Manager/Select/Tall_Select.asp";
	}else if(action_type=="Weight"){
		var strAjaxUrl = "/Manager/Select/Weight_Select.asp";
	}else if(action_type=="Level"){
		var strAjaxUrl = "/Manager/Select/Level_Select.asp";
	}else if(action_type=="Blood"){
		var strAjaxUrl = "/Manager/Select/Blood_Select.asp";
	}else if(action_type=="PlayYear"){
		var strAjaxUrl = "/Manager/Select/PlayYear_Select.asp";		
	}else if(action_type=="Area"){
		var strAjaxUrl = "/Manager/Select/Area_Select.asp";		
	}else if(action_type=="Area_Small"){
		var strAjaxUrl = "/Manager/Select/Area_Select_Small.asp";		
	}else if(action_type=="TeamGb"){
		var strAjaxUrl = "/Manager/Select/TeamGb_Select.asp";		
	}else if(action_type=="TeamGb2"){
		var strAjaxUrl = "/Manager/Select/TeamGb_Select_Change.asp";		  
	}else if(action_type=="TeamGb3"){
		var strAjaxUrl = "/Manager/Select/TeamGb_Select_Change2.asp";		  
	}else if(action_type=="GameGb"){
		var strAjaxUrl = "/Manager/Select/GameGb_Select.asp";			
	}else if (action_type=="GameTitle"){
		var strAjaxUrl = "/Manager/Select/GameTitle_Select.asp";
	}else if (action_type=="GameTitle_Year"){
		var strAjaxUrl = "/Manager/Select/GameTitle_Select_Year.asp";
	}else if (action_type=="GameTitle_Year_change"){
		var strAjaxUrl = "/Manager/Select/GameTitle_Select_Year_change.asp";
	}else if (action_type=="GameTitle_Year_change2"){
		var strAjaxUrl = "/Manager/Select/GameTitle_Select_Year_change2.asp";
	}else if (action_type=="GroupGameGb"){
		var strAjaxUrl = "/Manager/Select/GroupGameGb_Select.asp";	
	}else if (action_type=="GroupGameGb2"){
		var strAjaxUrl = "/Manager/Select/GroupGameGb_Select_change.asp";	
	}else if (action_type=="VersusGb"){
		var strAjaxUrl = "/Manager/Select/VersusGb_Select.asp";		
	}else if (action_type=="HostCode"){
		var strAjaxUrl = "/Manager/Select/Host_Select.asp";				
	}

	$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',
			data: { element: element ,attname:attname ,code:code },
			success: function(retDATA) {
				if(retDATA){	
						document.getElementById(element).innerHTML = retDATA	
				}			
				
				if (retDATA == null) {
					//조회종료 효과
					//parent.fBottom.popupClose("","","");
					alert ("조회 데이타가 없습니다!");
					document.getElementById("setseq").value = "";
				}
			}, error: function(xhr, status, error){
				//조회종료 효과
				//parent.fBottom.popupClose("","","");
				alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!");
				setseq = "";
			}
		});
}		
/*박스 생성E*/


/*체급박스 생성S*/
function make_box_level(element,attname,code,action_type,teamgb){
	//alert(action_type)
		var strAjaxUrl = "/Manager/Select/Level_Select_Check.asp";
	$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',
			data: { element: element ,attname:attname ,code:code ,teamgb:teamgb},
			success: function(retDATA) {
				if(retDATA){	
						document.getElementById(element).innerHTML = retDATA	
				}			
				
				if (retDATA == null) {
					//조회종료 효과
					//parent.fBottom.popupClose("","","");
					alert ("조회 데이타가 없습니다!");
					document.getElementById("setseq").value = "";
				}
			}, error: function(xhr, status, error){
				//조회종료 효과
				//parent.fBottom.popupClose("","","");
				alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!");
				setseq = "";
			}
		});
}		
/*체급박스 생성E*/

