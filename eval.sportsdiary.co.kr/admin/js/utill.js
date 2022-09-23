//도구##################################################################
var px = px || {};

px.goSubmit = function (packet, gourl) {
	var typechkbox = false;

	if (packet.hasOwnProperty('F1')) {
		//alert(packet.F1 + ' ' + $.isArray(packet.F1));
		if ($.isArray(packet.F1)) {

			for (var i = 0; i < packet.F1.length; i++) {
				typechkbox = false;
				for (var n = 0; n < packet.F3.length; n++) {
					if (Number(packet.F1[i]) == Number(packet.F3[n])) { //체크박스라면
						typechkbox = true;
					}
				}

				if (typechkbox == true) {
					if ($("#F1_" + i).is(":checked")) {
						packet.F2[i] = px.strReplaceAll($('#F1_' + i).val(), ",", "`");
					}
					else {
						packet.F2[i] = '';
					}
				} else {
					if (packet.F2[i] != null) {
						if (packet.F2[i] == '') { //입력값이 직접 들어가있다면 그대로 넣는다.
							packet.F2[i] = px.strReplaceAll($('#F1_' + i).val(), ",", "`");
						}
					}

				}
			}

		}
		//alert(packet.F2);
	}
	document.ssform.target = "_self";
	document.ssform.p.value = JSON.stringify(packet);
	document.ssform.action = gourl;
	document.ssform.submit();
};

px.goTargetSubmit = function (packet, gourl, formtarget) {
	document.ssform.target = formtarget;
	document.ssform.p.value = JSON.stringify(packet);
	document.ssform.action = gourl;
	document.ssform.submit();
};
/* ===================================================================================
Format String ex) strVal = utx.strPrintf("this {0} a tes{1} string containing {2} values", "is","t","some");
=================================================================================== */
px.strPrintf = function () {
	var content = arguments[0];
	for (var i = 0; i < arguments.length - 1; i++) {
		var replacement = '{' + i + '}';
		content = content.replace(replacement, arguments[i + 1]);
	}
	return content;
};




/*  ===================================================================================
replace All - 정규식 이용 , strSrc의 문자열 str1을 str2로 변환시킨다.
=================================================================================== */
px.strReplaceAll = function (strSrc, str1, str2) {
	var regExp = new RegExp(str1, "g");
	if (strSrc != undefined) {
		strSrc = strSrc.replace(regExp, str2);
	}
	return strSrc;
};

px.chkValue = function (chkval, msg) {
	if (chkval == "" || chkval == undefined) {
		alert(msg + "주세요.");
		return false;
	}
	return true;
};

px.goPN = function (packet, pageno) {
	packet.PN = pageno;
	var gourl = location.href;
	document.ssform.target = "_self";
	document.ssform.p.value = JSON.stringify(packet);
	document.ssform.action = gourl;
	document.ssform.submit();
};



px.goPrint = function (packet, gameround) {
	packet.gameround = gameround;
	document.ssform.target = "_blank";
	document.ssform.p.value = JSON.stringify(packet);
	document.ssform.action = "print.asp";
	document.ssform.submit();
};

px.Print = function (packet, targeturl) {
	document.ssform.target = "_blank";
	document.ssform.p.value = JSON.stringify(packet);
	document.ssform.action = targeturl;
	document.ssform.submit();
};

px.hiddenSave = function (packet, targeturl) {
	document.ssform.target = "hiddenFrame";
	document.ssform.p.value = JSON.stringify(packet);
	document.ssform.action = targeturl;
	document.ssform.submit();
};


//input 기본값으로 0이되었을경우 처리
px.chkZero = function (inputobj) {
	if (inputobj.value == 0) {
		inputobj.value = '';
	}
	//console.log(inputobj.value);
};

px.setZero = function (inputobj) {
	if (inputobj.value == '') {
		inputobj.value = 0;
	}
};


//input 기본값으로 0이되었을경우 처리(수영)
px.chkZeroSm = function (inputobj) {
	if (inputobj.value == "00:00.00") {
		inputobj.value = '';
	}
	//console.log(inputobj.value);
};

px.chkZeroE2 = function (inputobj) {//다이빙
	if (inputobj.value == "000.00") {
		inputobj.value = '';
	}
	//console.log(inputobj.value);
};
px.chkZeroF2 = function (inputobj) {//아티스틱
	if (inputobj.value == "000.0000") {
		inputobj.value = '';
	}
	//console.log(inputobj.value);
};

px.setZeroSm = function (inputobj) {
	if (inputobj.value == '') {
		inputobj.value = "00:00.00";
	}
};

px.setZeroE2 = function (inputobj) {
	if (inputobj.value == '') {
		inputobj.value = "000.00";
	}
};
px.setZeroF2 = function (inputobj) {
	if (inputobj.value == '') {
		inputobj.value = "00.0000";
	}
};



//스토리지에 저장해두기
px.saveText = function (el) {
	localStorage.setItem(el.id, el.value);
};


//input에 저장된스토리지 모두 불러오기
px.allStorage = function () {
	var archive = [],
		keys = Object.keys(localStorage),
		i = 0, key;
	for (; key = keys[i]; i++) {
		//obj = {};
		//obj['"'+key+'"'] = localStorage.getItem(key);
		//archive.push( obj );
		$('#' + key).val(localStorage.getItem(key));
	}
	//return archive; //배열에 key값이 동적인 객체를 넣을때
};

px.checkAll = function (el) {
	var checkStatus = el.is(":checked");
	var $checkTable = el.parents("Table");
	var $checkList = $checkTable.find("input[type='checkbox']");


	if (checkStatus) {

		for (var i = 0; i < $checkList.length; i++) {
			if ($('#' + $checkList[i].id).is(":disabled") == false) {
				$('#' + $checkList[i].id).prop("checked", true);
			}
		}

	} else {

		for (var i = 0; i < $checkList.length; i++) {
			if ($('#' + $checkList[i].id).is(":disabled") == false) {
				$('#' + $checkList[i].id).prop("checked", false);
			}
		}

	}
};


px.toggle = function (source, targetnm) {
	var checkboxes = document.getElementsByName(targetnm);
	for (var i = 0, n = checkboxes.length; i < n; i++) {
		checkboxes[i].checked = source.checked;
	}
};


//도구##################################################################

//화면 인쇄
$.getScript('/admin/js/print/printThis.js', function () {
	//	console.log('script loading!!');
});

$.getScript('/admin/js/excel/xlsx.full.min.js', function () {
	//	console.log('script loading!!');
});
$.getScript('/admin/js/excel/FileSaver.min.js', function () {
	//	console.log('2 script loading!!');
});




//공통
// 참고 출처 : https://redstapler.co/sheetjs-tutorial-create-xlsx/
px.s2ab = function (s) {
	var buf = new ArrayBuffer(s.length); //convert s to arrayBuffer
	var view = new Uint8Array(buf);  //create uint8array as viewer
	for (var i = 0; i < s.length; i++) view[i] = s.charCodeAt(i) & 0xFF; //convert to octet
	return buf;
};

px.exportExcel = function (xlsname, sheetname, xlstableid) {


	if (xlsname == "QA") {
		$('textarea').remove();
	}



	excelHandler.tablename = xlsname;
	excelHandler.sheetname = sheetname;
	excelHandler.xlstableid = xlstableid;

	// step 1. workbook 생성
	var wb = XLSX.utils.book_new();

	// step 2. 시트 만들기
	var newWorksheet = excelHandler.getWorksheet();

	//간격조정때 사용
	//      var wsrows =  [
	//            {wch: 10}, // A Cell Width
	//            {wch: 50}, // B Cell Width
	//         ];
	//      newWorksheet['!cols'] = wsrows;


	// step 3. workbook에 새로만든 워크시트에 이름을 주고 붙인다.
	XLSX.utils.book_append_sheet(wb, newWorksheet, excelHandler.getSheetName());

	// step 4. 엑셀 파일 만들기
	var wbout = XLSX.write(wb, { bookType: 'xlsx', type: 'binary' });

	// step 5. 엑셀 파일 내보내기
	saveAs(new Blob([px.s2ab(wbout)], { type: "application/octet-stream" }), excelHandler.getExcelFileName());
	if (xlsname == "QA") {
		window.location.reload();
	}
};

var excelHandler = {
	tablename: 'gamename',
	sheetname: 'sheetname',
	xlstableid: 'xlstbl',

	getExcelFileName: function () {
		return this.tablename + '.xlsx';
	},
	getSheetName: function () {
		return this.sheetname;
	},
	getExcelData: function () {
		return document.getElementById(this.xlstableid);
	},
	getWorksheet: function () {
		return XLSX.utils.table_to_sheet(this.getExcelData());
	}
}
