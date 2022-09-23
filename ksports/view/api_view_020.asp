<%@Language="VBScript" CODEPAGE="65001"%>
<%Response.ContentType="text/html;charset=utf-8"%>
<!DOCTYPE html>
<head>
<title>대회목록 조회 샘플</title>
<script src="./ajax.js" type="text/javascript"></script>
<script src="./paging.js" type="text/javascript"></script>
<script>
var debug = false;
//var reqUrl = "/ksports/view/api_view_020.asp";
var reqUrl = "/ksports/core/api_request_020.asp";
var param = "pageNo=1";

var classCD = "&classCD=JU"
param = param + regYear + classCD





function movePage(pageNo) {
	param = "pageNo=" + pageNo;
	ajaxRequest();
}

/**
 * ajax로 정상적으로 xml을 조회하였을 경우 호출되는 함수
 * ajax.js 파일의 ajaxRequest() 함수 참고
 */
function displayResult() {
	var rootNode = null;
	var resultCodeNode = null;
	var resultMsgNode = null;
	var totalCountNode = null;
	var totalPageCountNode = null;
	var currentPageNode = null;
	var rowsPerPageNode = null;
	var baseDtNode = null;
	var dataNode = null;
	var statList = null;
	var statNode = null;
	var pagingObj = null;

	var resultCode = "";
	var resultMsg = "";
	var baseDt = "";
	var totalCount = 0;
	var totalPageCount = 0;
	var currentPage = 0;
	var rowsPerPage = 0;
	var dispTitle = new Array();
	var dispData = new Array();

	// 디버그를 위해 수신한 XML 파일을 TextArea에 표시
	document.getElementById("divXml").innerText = receiveText;
	log(xmlDoc);
	
	//----------------------------------------------
	// XML 파싱
	// documentElement는 항상 루트 노드를 나타낸다
	// RESULT
	rootNode = xmlDoc.documentElement;
	console.log(rootNode);

	// RESULT_CODE
	resultCodeNode = rootNode.getElementsByTagName("RESULT_CODE");
	if(resultCodeNode==null) {
		alert("RESULT_CODE not found");
		return;
	}
	resultCode = resultCodeNode[0].childNodes[0].nodeValue;
	log("RESULT_CODE : " + resultCode);
	
	// RESULT_MSG
	resultMsgNode = rootNode.getElementsByTagName("RESULT_MSG");
	if(resultMsgNode==null) {
		alert("RESULT_MSG not found");
		return;
	}
	resultMsg = resultMsgNode[0].childNodes[0].nodeValue;
	log("RESULT_MSG : " + resultMsg);
	
	// 처리결과 확인 
	if(resultCode!="0000000") {
		alert("팀 등록목록 조회를 실패했습니다.\n\n에러코드 : " + resultCode + "\n에러메시지 : " + resultMsg);
		return;
	}

	// BASE_DT
	baseDtNode = rootNode.getElementsByTagName("BASE_DT");
	if(baseDtNode==null) {
		alert("BASE_DT not found");
		return;
	}
	baseDt = baseDtNode[0].childNodes[0].nodeValue;
	log("BASE_DT : " + baseDt);
	
	// TOTAL_COUNT
	totalCountNode = rootNode.getElementsByTagName("TOTAL_COUNT");
	if(totalCountNode==null) {
		alert("TOTAL_COUNT not found");
		return;
	}
	totalCount = totalCountNode[0].childNodes[0].nodeValue;
	log("TOTAL_COUNT : " + totalCount);
	
	// TOTAL_PAGE_COUNT
	totalPageCountNode = rootNode.getElementsByTagName("TOTAL_PAGE_COUNT");
	if(totalPageCountNode==null) {
		alert("TOTAL_PAGE_COUNT not found");
		return;
	}
	totalPageCount = totalPageCountNode[0].childNodes[0].nodeValue;
	log("TOTAL_PAGE_COUNT : " + totalPageCount);
	
	// CURRENT_PAGE
	currentPageNode = rootNode.getElementsByTagName("CURRENT_PAGE");
	if(currentPageNode==null) {
		alert("CURRENT_PAGE not found");
		return;
	}
	currentPage = currentPageNode[0].childNodes[0].nodeValue;
	log("CURRENT_PAGE : " + currentPage);
	
	// ROWS_PER_PAGE
	rowsPerPageNode = rootNode.getElementsByTagName("ROWS_PER_PAGE");
	if(rowsPerPageNode==null) {
		alert("ROWS_PER_PAGE not found");
		return;
	}
	rowsPerPage = rowsPerPageNode[0].childNodes[0].nodeValue;
	log("ROWS_PER_PAGE : " + rowsPerPage);
	

	// DATA
	dataNode = rootNode.getElementsByTagName("DATA");
	if(dataNode==null) {
		alert("DATA not found");
		return;
	}
	log("DATA : " + dataNode.length);
	
	// EVENT 목록을 조회 
	statList = rootNode.getElementsByTagName("EVENT");
	log("EVENT : " + statList.length);

	// EVENT 갯수 만큼 루핑 
	dispTitle[0] = "-";
	for(var idx0=0; idx0<statList.length; idx0++) {
		statNode = statList[idx0];
		var realChildCount = 0;
		var dispValue = new Array();

		// STAT의 child node 처리 
		for(var sidx=0; sidx<statNode.childNodes.length; sidx++) {
			var row = statNode.childNodes[sidx];

			/*
			 * nodeType
			 *	1 : Element
			 *	2 : Attribute
			 *	3 : Text
			 *	8 : Comment
			 *	9 : Document
			 * nodeType이 1인 경우에만 처리해야 함
			 */
			if(row.nodeType!=1) {
				log("## Node not element : node type : " + statNode.childNodes[sidx].nodeType);
				continue;
			}
			realChildCount++;

			var value = "";
			if(row.childNodes && row.childNodes.length>0)
				value = row.childNodes[0].nodeValue;
			else
				value = "";

			dispValue[dispValue.length] = value;

			log("[" + idx0 + "][" + sidx + "] Node Type : " + row.nodeType + "(Element)");
			log("[" + idx0 + "][" + sidx + "] Node Name : " + row.nodeName);
			log("[" + idx0 + "][" + sidx + "] Node Value : " + value);
		}
		dispData[dispData.length] = dispValue;
		log("Real Child Count : " + realChildCount);
	}
	
	// 페이징 생성
	pagingObj = new Paging("movePage", totalCount, rowsPerPage, currentPage);
	pagestr = pagingObj.getPageString();
	
	msg = header + title + body + footer + pagestr;
	
	//console.log(msg);
	document.getElementById("divContents").innerHTML = msg;
	document.getElementById("divBaseDt").innerHTML = "(자료조회일 : " + baseDt + " | 검색된 대회 수 : " + totalCount + "건 | 페이지 : " + currentPage + "/" + totalPageCount + ")";
}
</script>
<style>
<!--
	body, table, tr, td, a, span { font-family: dotum, "돋움"; font-size: 12px; }
	tr { height: 23px; }
	td { text-align:center; }
	a {font-weight: :normal; text-decoration: none;}
	.page_link {font-weight: :bold; text-decoration: none; padding: 5px 5px 5px 5px; background-color:#adadad;}
-->
</style>
</head>
<body>
<input type="button" value="대회목록 조회" onclick="javascript:ajaxRequest()"/>
<div style="text-align:bottom;padding-top:20px;font-weight:bold;">XML 소스</div>
<textarea id="divXml" style="width:100%; height:500px; border:1px solid;"></textarea>
<div id="divBaseDt" style="padding-top:10px;font-weight:bold;"></div>
<div id="divContents" style="width:100%; height:100%;"></div>
</body>
</html>