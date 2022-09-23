<%@Language="VBScript" CODEPAGE="65001"%>
<%Response.ContentType="text/html;charset=utf-8"%>
<!DOCTYPE html>
<head>
<title>대회목록 조회 샘플</title>
<script src="view/ajax.js" type="text/javascript"></script>
<script src="view/paging.js" type="text/javascript"></script>
<script>
var debug = false;
//var reqUrl = "/ksports/view/api_view_020.asp";
var reqUrl = "/ksports/core/api_request_020.asp";
var param = "pageNo=";
var pageNo = 1;
var regYear = "&regYear=2018";
var classCD = "&classCD=JU";
param = param + pageNo + regYear + classCD;



function movePage(pageNo) {
	param = "pageNo=" + pageNo;
	ajaxRequest();
}

</script>
</head>
<body>
<input type="button" value="대회목록 조회" onclick="javascript:ajaxRequest()"/>
<textarea id="divXml" style="width:100%; height:500px; border:1px solid;"></textarea>
</body>

<script>

function displayResult() {
	var root;
	var result_code;
	var data;
	console.log(req);
	console.log(req.responseXML);
	//root node = result
	root = req.responseXML.documentElement;
	//result code , 성공 실패 여부
	resultCode = root.children[0].innerHTML;
	//data , 대회정보
	data = req.responseXML.getElementsByTagName("DATA");
	// 검색결과 개수
	totalCount = req.responseXML.getElementsByTagName("TOTAL_COUNT")[0].textContent;
	//대회별 정보
	event = req.responseXML.getElementsByTagName("EVENT");
//	console.log(event);
	eventCnt = event.length
	for (i = 0; i < eventCnt ; i++ )
	{
		var eventName = event[i].getElementsByTagName("EVENT_NM_KOR")[0].textContent;
		var placeKor = event[i].getElementsByTagName("PLACE_KOR")[0].textContent;
		var eventCD = event[i].getElementsByTagName("EVENT_CD")[0].textContent;
		var classCD = event[i].getElementsByTagName("CLASS_CD")[0].textContent;
//		console.log(event[i]);
	}



	document.getElementById("divXml").innerText = receiveText;
}
</script>


</html>

