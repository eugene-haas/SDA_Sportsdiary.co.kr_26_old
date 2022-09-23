// Ajax 통신을 위한 instance
var req = null;
// Ajax 호출 후 수신한 Text
var receiveText = "";
// Ajax 호출 후 수신한 Text를 XML 형식으로 변환된 오브젝트
var xmlDoc = null;
function getXMLHttpRequest() {
	if (window.ActiveXObject) {
		try {
			return new ActiveXObject("Msxml2.XMLHTTP");
		} catch(e) {
			try {
				return new ActiveXObject("Microsoft.XMLHTTP");
			} catch(e) { return null; }
		}
	} else if (window.XMLHttpRequest) {
		return new XMLHttpRequest();
	} else {
		return null;
	}
}

function ajaxRequest() {
	req = getXMLHttpRequest();
	req.onreadystatechange  = function() {
		if (req.readyState == 4) {
			if (req.status == 200) {
				receiveText = req.responseText;
				xmlDoc = req.responseXML;
				displayResult();
			} else {
				alert("Error Code : " + req.status + " / Error Msg : " + req.statusText);
			}
		}
	}

	req.open("POST", reqUrl + "?curdate=" + Math.floor(Math.random()*99999), true);
	req.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	req.send(param);
}

/**
 * debug가 true일 경우 console.log() 함수를 이용해서 디버그하기 위해 사용
 */
function log(val) {
	if(debug) {
		console.log(val);
	}
}

/**
 * 숫자에 Comma 표시
 */
function addComma(val) {
	if(val==null || val=="")
		return "";
	
	return val.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}
