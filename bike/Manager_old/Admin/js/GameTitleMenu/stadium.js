
////////////명령어////////////

CMD_SELSTADIUM = 1;
CMD_INSERTSTADIUM = 2;
CMD_UPDATESTADIUM = 3;
CMD_DELSTADIUM = 4;

////////////명령어////////////

////////////Ajax Receive////////////

initDateContrl = false;

function OnReceiveAjax(CMD, dataType, htmldata, jsondata) {
  
	switch(CMD) {
		case CMD_SELSTADIUM : {
			if(dataType == "html") {
				//alert(jsondata.NowPage)
				//alert(jsondata.tIDX)
				$('#stdatiuminput_area').html(htmldata);
			}
		} 
		break;
		
		case CMD_INSERTSTADIUM : {
			if(dataType == "json") {
				//alert(jsondata.NowPage)
				href_stadium(jsondata.tIDX);
			}
		}
		break;
		
		case CMD_UPDATESTADIUM : {
			if(dataType == "json") {
				href_stadium(jsondata.tIDX);
			}
		}
		break;

		case CMD_DELSTADIUM :{
			if(dataType == "json") {
				//alert(jsondata.NowPage)
				href_stadium(jsondata.tIDX);
			}
		} 
		break;
		
		default: $('#content').html(jsondata);		
		//$(location).attr('href', 'http://badmintonadmin.sportsdiary.co.kr/Main/GameTitleMenu/index.asp')
	}
};
////////////Ajax Receive////////////

////////////Custom Function////////////


function updateStadium_frm(NowPage) {
	Url ="/Ajax/GameTitleMenu/updateStadium_frm.asp"

	var tIDX = $( "#selGameTitleIdx" ).val(); 
	var tStadiumIDX = $( "#selStadium" ).val();  
	var tStadiumName = $( "#txtStadiumName" ).val();  
	var tCourtCnt = $( "#txtCourtCnt" ).val();  
	var tAddr = $( "#Addr" ).val();  
	var tAddrDtl = $( "#AddrDtl" ).val();  

	if(tStadiumIDX == "") {
		alert("종목 선택 후 수정해주세요")
		return;
  	}
    
	var packet = {};
	
	packet.CMD = CMD_UPDATESTADIUM;
	packet.tIDX = tIDX;
	packet.tStadiumIDX = tStadiumIDX;
	packet.tStadiumName =  tStadiumName;
	packet.tCourtCnt =  tCourtCnt;
	packet.tAddr =  tAddr;
	packet.tAddrDtl =  tAddrDtl;
	
	SendPacket(Url, packet);
};

function delStadium_frm(NowPage){
	Url ="/Ajax/GameTitleMenu/delStadium_frm.asp"
	var tidx = $( "#selGameTitleIdx" ).val();
	var tStadiumIDX = $( "#selStadium" ).val();  

	if(tStadiumIDX == ""){
		alert("종목 선택 후 삭제해주세요")
		return;
	}

	var packet = {};
	packet.CMD = CMD_DELSTADIUM;
	packet.tIDX = tidx
	packet.tStadiumIDX = tStadiumIDX;
	packet.NowPage = NowPage;
	SendPacket(Url, packet)
};


function inputStadium_frm(NowPage) {
	
	Url ="/Ajax/GameTitleMenu/inputStadium_frm.asp"

	var tIDX = $( "#selGameTitleIdx" ).val(); 
	var tStadiumIDX = $( "#selStadium" ).val();  
	var tStadiumName = $( "#txtStadiumName" ).val();  
	var tCourtCnt = $( "#txtCourtCnt" ).val();  
	var tAddr = $("#Addr").val();  	
	var tAddrDtl = $("#AddrDtl").val();  	
	var packet = {};

	packet.CMD = CMD_INSERTSTADIUM;
	packet.tIDX = tIDX;
	packet.tStadiumIDX = tStadiumIDX;
	packet.tStadiumName = tStadiumName;
	packet.tCourtCnt = tCourtCnt;
	packet.tAddr = tAddr;
	packet.tAddrDtl = tAddrDtl;

	SendPacket(Url, packet);
  
};


function SelStadium(stadiumIdx) {
	//암호화해야하는 URL
	Url ="/Ajax/GameTitleMenu/selStadium.asp"
	
	var tIDX = $( "#selGameTitleIdx" ).val(); 
	var packet = {};
	
	packet.CMD = CMD_SELSTADIUM;
	packet.tIDX = tIDX;
	packet.tStadiumIdx = stadiumIdx;
	
	SendPacket(Url, packet)
};

////////////Custom Function////////////
$(document).ready(function(){
  	init();
}); 

init = function(){
  	$(".date_ipt").datepicker('setDate', 'today');
};

href_back = function(NowPage){
  	post_to_url('./index.asp', { 'i2': NowPage});
};

href_stadium = function(tIDX){
  	post_to_url('./stadium.asp', { 'tIDX': tIDX});
};