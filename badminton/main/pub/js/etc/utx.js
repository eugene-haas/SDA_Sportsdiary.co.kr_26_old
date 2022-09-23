/* =================================================================================== 
    * 2018. 11. 26        
    * java script에서 사용하는 작은 utility function이다. 
                                                                    By Aramdry
   =================================================================================== */


var utx = utx || {}

/* =================================================================================== 
    Format String ex) strVal = utx.strPrintf("this {0} a tes{1} string containing {2} values", "is","t","some");
    =================================================================================== */
utx.sprintf = function() {
    var content = arguments[0];
    var arg;
    for (var i = 0; i < arguments.length - 1; i++) {
        var replacement = '{' + i + '}';
        arg = arguments[i + 1];
        if (arg == undefined || arg == null) arg = ' ';
        content = content.replace(replacement, arg);
    }
    return content;
};

utx.strPrintf = function() {
    var content = arguments[0];
    var arg;
    for (var i = 0; i < arguments.length - 1; i++) {
        var replacement = '{' + i + '}';
        arg = arguments[i + 1];
        if (arg == undefined || arg == null) arg = ' ';
        content = content.replace(replacement, arg);
    }
    return content;
};

/*  =================================================================================== 
    replace All - 정규식 이용 , strSrc의 문자열 str1을 str2로 변환시킨다. 
    =================================================================================== */
utx.strReplaceAll = function(strSrc, str1, str2) {
    var regExp = new RegExp(str1, "g");
    strSrc = strSrc.replace(regExp, str2);
    return strSrc;
}

/*  =================================================================================== 
       문자열내의 space, tab문자 제거  ( \s: space , \t: tab )
    =================================================================================== */
utx.TrimSpace = function(strSrc) {
    strSrc = strSrc.replace(/(\s*\t*\r*\n*)/g, "") // 문자열 내의 모든 공백 제거
    return strSrc;
}

/*  =================================================================================== 
        문자열 Find 
    =================================================================================== */
utx.strFind = function(strSrc, strFind) {
    if (strSrc == undefined || strSrc == "") return false;

    var strData = strSrc.toString();
    var pos = strData.indexOf(strFind);

    var ret = (pos == -1) ? false : true;
    return (pos == -1) ? false : true;
}

/* =================================================================================== 
        count object property
    =================================================================================== */
utx.countPropertyInObj = function(obj) {
    var cnt = 0;

    for (var prop in obj) cnt++;
    return cnt;
}

/* =================================================================================== 
    deep copy object
=================================================================================== */
utx.cloneObject = function(obj) {
    var clone = {};
    for (var i in obj) {
        if (obj[i] != null && typeof(obj[i]) == "object")
            clone[i] = utx.cloneObject(obj[i]);
        else
            clone[i] = obj[i];
    }
    return clone;
}

/* =================================================================================== 
       console log용 - obj을 입력받아 property를 출력한다. 
       asp에서는 호출할수 없다. ( console.log 사용)  ex) utx.printObj(objCoupon, "coupon Object"); 
   =================================================================================== */
utx.printObj = function(obj, strTitle) {

    if (strTitle == undefined || strTitle == null || strTitle == "") {
        strTitle = obj.toString();
    }
    console.log("=============== " + strTitle + " ===============");

    for (var prop in obj) {
        console.log(" - " + prop + " : " + obj[prop]);
    }

    console.log("======================================================");
}

/*  =================================================================================== 
    console log용 - 1차원 Array를 입력받아 그 값을 출력한다. 
    asp에서는 호출할수 없다. ( console.log 사용)  ex) utx.printAry(aryData); 
    =================================================================================== */
utx.printAry = function(ary) {
    var len = ary.length;

    console.log("===============================================");
    for (i = 0; i < len; i++) {
        strLog = utx.strPrintf(" {0} = {1}", i, ary[i]);
        console.log(strLog);
    }
    console.log("===============================================");
}

/* =================================================================================== 
   object property check 
   =================================================================================== */
utx.hasown = function(obj, prop) {
    if (obj == null) return "notok";
    if (obj.hasOwnProperty(prop) == true) {
        return "ok";
    } else {
        return "notok";
    }
}

/* =================================================================================== 
    object property check 
    =================================================================================== */
utx.hasownEx = function(obj, prop) {
        if (obj == null) return false;
        return obj.hasOwnProperty(prop);
    }
    /* =================================================================================== 
        Empty object check 
        =================================================================================== */
utx.isObjEmpty = function(obj) {
    if ('object' !== typeof obj) {
        return true;
    }

    if (null === obj) {
        return true;
    }

    if ('undefined' !== Object.keys) {
        // Using ECMAScript 5 feature.
        return (0 === Object.keys(obj).length);
    } else {
        // Using legacy compatibility mode.
        for (var key in obj) {
            if (obj.hasOwnProperty(key)) {
                return false;
            }
        }
        return true;
    }
}

/* =================================================================================== 
    str에 0를 붙여 준다.   기본은 2 : 숫자 한자리수를 2자리수로 표현하기 위해.. 
    =================================================================================== */
utx.appendZero = function(str, limit) {
    var len, gap, strZero = "";
    if (limit == undefined || limit == null) limit = 2;

    len = str.toString().length;
    if (len > limit) return str;

    gap = limit - len;
    for (var i = 0; i < gap; i++) strZero += "0";

    return strZero + str;
};

/* =================================================================================== 
   문자열을 limit갯수 이하로 줄여서 반환한다. 
   =================================================================================== */
utx.reduceStr = function(str, limit, bMark) {
    var len, gap, strPoints = "...";
    if (bMark == undefined) bMark = true;

    len = str.toString().length;
    if (len < limit) return str;

    str = str.substring(0, limit);
    return (bMark) ? (str + strPoints) : str;
};

/* ================================================================ 
		숫자를 입력받아 ,를 찍어 출력한다. 
	/* ================================================================ */
utx.getStrMoney = function(strVal) {
    var strSrc = strVal.toString();
    var len = strSrc.length;
    var strTmp = "",
        strRet = "",
        cnt = 0;

    // 문자열을 끝에서 부터 하나씩 저장하면서 3회마다 ,를 붙여 저장한다. (이때 문자열은 거꾸로 되어 있다. )
    for (var i = len - 1; i >= 0; i--) {
        cnt++;
        if (i > 0 && (cnt % 3) == 0) strTmp += (strSrc.charAt(i) + ",");
        else strTmp += strSrc.charAt(i);
    }

    // 문자열을 재정렬 한다. 
    len = strTmp.length;
    for (var i = len - 1; i >= 0; i--) {
        strRet += strTmp.charAt(i);
    }
    return strRet;
}

/*  =================================================================================== 
        생년월일 체크 - 정규식 사용
    =================================================================================== */
utx.checkBirthDay = function(strBirth) {
    // 8자리 생년월일 체크 
    var regExp = /^[0-9]{8}$/;
    var match = regExp.test(strBirth);

    if (match == true) {
        var year = Number(strBirth.substr(0, 4));
        var month = Number(strBirth.substr(4, 2));
        var day = Number(strBirth.substr(6, 2));

        //            strLog = utx.strPrintf("checkBirthDay .. 2222 strBirth = {0}, year = {1}, month = {2}, day = {3}", strBirth, year, month, day)
        //            console.log(strLog);

        if (!(year > 1930 && year < 2030)) match = false; // 년 / 월/ 일 체크 
        else if (month > 12) match = false;
        else if (day > 31) match = false;
    }

    console.log("checkBirthDay .. " + match + " , " + strBirth);
    return match;
}

/*  =================================================================================== 
        전화번호 체크 - 정규식 사용
    =================================================================================== */
utx.checkPhoneNumber = function(strPhone) {
    // 01로 시작하는 핸드폰 및 지역번호와 050, 070 검증함. 그리고 -(하이픈)은 넣어도 되고 생략해도 되나 넣을 때에는 정확한 위치에 넣어야 함.
    var regExp = /^(01[016789]{1}|02|0[3-9]{1}[0-9]{1})-?[0-9]{3,4}-?[0-9]{4}$/;

    var match = regExp.test(strPhone);
    console.log("checkPhoneNumber .. " + match + " , " + strPhone);
    return match;

}

/*  =================================================================================== 
        전화번호 부분 체크 (글자수 6자리 이상- 정규식 사용)
    =================================================================================== */
utx.checkPhonePart6 = function(strPhone) {
    var regExp = new RegExp("^[0-9]{2,4}-", "g");
    var match = regExp.test(strPhone);
    console.log("checkPhonePart6 .. " + match + " , " + strPhone);
    return match;
}

/*  =================================================================================== 
        숫자 체크 
    =================================================================================== */
utx.IsNumber = function(strSrc) {
    var regExp = new RegExp("^[0-9]*$", "g");
    var match = regExp.test(strSrc);
    console.log("IsNumber .. " + match + " , " + strSrc);
    return match;
}


/*  =================================================================================== 
        시작, 종료 날짜 비교 함수 - 
        문자열 비교일 경우 비교문이 오작동 한다.  ex)2018-12-3 09:39 >= 2018-12-28 00:00 
        ( 앞에서 부터 순서대로 비교 하므로 12-까지는 동일하고 그다음 문자열 '3"과 '2'를 비교한다. 3과 28을 비교 할것이라고 소스를 짜는데 --;; ) 
    =================================================================================== */
utx.IsValidPeriod = function(strDateS, strDateE) // Error check - 쿠폰 발급기간
    {
        var dateS = new Date(strDateS);
        var dateE = new Date(strDateE);

        return (dateS >= dateE) ? false : true;
    }

/* =================================================================================== 
    uniqe Array class
    data를 관리하기 위해 동적배열로 만들었다.  
    ex) var dAry = new utx.uAry(); dAry.init(5, -1); ... dAry.delete(5); dAry.insert(30); 
    =================================================================================== */
utx.uAry = function() {
    this.ary = [];
    this.size = 100;
    this.defSize = 100;
    this.initVal = 0;
    this.pos = 0;

    /* =================================================================================== 
    초기화 함수 , size: 배열 크기 , initVal : 배열 초기화 값
    =================================================================================== */
    utx.uAry.prototype.init = function(size, initVal) {
        this.ary = new Array(size);
        this.size = size;
        this.defSize = size;
        this.initVal = initVal;
        this.pos = 0;

        if (size == undefined || size == null) size = 100;
        if (initVal == undefined || initVal == null) initVal = 0;

        for (var i = 0; i < size; i++) {
            this.ary[i] = initVal;
        }
    }

    /* =================================================================================== 
    Reset 함수 , 배열 초기화
    =================================================================================== */
    utx.uAry.prototype.reset = function() {
        this.pos = 0;
        for (var i = 0; i < this.size; i++) {
            this.ary[i] = this.initVal;
        }
    }

    /* =================================================================================== 
    data insert : 기존 data를 검색하여 없는 경우에만 insert. 
                  배열이 꽉찬 경우 배열을 재 설정 해 준다. 
    =================================================================================== */
    utx.uAry.prototype.insert = function(data) {
        if (this.find(data) != -1) return;
        if (this.pos >= (this.size - 1)) {
            var size = this.size + this.defSize;
            this.reAllocAry(size);
        }
        this.ary[this.pos++] = data;
    }

    /* =================================================================================== 
    data insert : size를 입력받아 새로운 배열을 만들고, 기존 배열 data를 copy한다. 
    =================================================================================== */
    utx.uAry.prototype.reAllocAry = function(size) {
        var ary = new Array(size);
        for (var i = 0; i < size; i++) {
            if (i < this.size) ary[i] = this.ary[i];
            else ary[i] = this.initVal;
        }

        this.ary = null;
        this.ary = ary;
        this.size = size;
    }

    /* =================================================================================== 
    data delete : data를 입력받아 배열에서 삭제하고, 삭제된 데이터 뒤에 데이터는 한칸씩 앞으로 move
    =================================================================================== */
    utx.uAry.prototype.delete = function(data) {
        idx = this.find(data);
        if (idx == -1) return;

        console.log("delete = " + idx + " , " + data);

        // 배열 이므로 date move ( data를 delete data기준으로 이후데이터를 한칸씩 당긴다. )
        var len = this.pos;
        for (var i = idx; i < (len - 1); i++) {
            this.ary[i] = this.ary[i + 1];
        }

        this.pos--;
    }

    /* =================================================================================== 
    data delete : data를 입력받아 배열에서 찾는다. 
    =================================================================================== */
    utx.uAry.prototype.find = function(data) {
        var len = this.pos;

        for (var i = 0; i < len; i++) {
            if (this.ary[i] == data) return i;
        }
        return -1;
    }

    /* =================================================================================== 
    data print : debug 용 - data 확인용 
    =================================================================================== */
    utx.uAry.prototype.print = function() {
        var len = this.pos;

        for (var i = 0; i < len; i++) {
            console.log("data [" + i + "]  = " + this.ary[i]);
        }
    }

    /* =================================================================================== 
    array를 return 한다. 
    =================================================================================== */
    utx.uAry.prototype.getArray = function() {
        return this.ary;
    }

    /* =================================================================================== 
    array의 data 들어있는 갯수 
    =================================================================================== */
    utx.uAry.prototype.getSize = function() {
        return this.pos;
    }
}

/*  =================================================================================== 
    문자열내의 space, tab문자 제거  ( \s: space , \t: tab )
 =================================================================================== */
utx.TrimSpace = function(strSrc) {
    strSrc = strSrc.replace(/(\s*\t*\r*\n*)/g, "") // 문자열 내의 모든 공백 제거

    console.log("strSrc = " + strSrc);
    return strSrc;
}

/*  =================================================================================== 
       sleep Sync function ( 동기화 .. System Blocking)
       delay 시간이 흐를때 까지 while Loop를 수행한다. 
    =================================================================================== */
utx.sleep = function(delay) {
    var endTime = new Date().getTime() + delay;
    while (new Date().getTime() < endTime);
}

/*  =================================================================================== 
       sleep Async function ( 비동기화 .. System non Blocking)
       delay 시간이 흐른후 인자로 받은 fpExec 함수를 실행한다. 
    =================================================================================== */
utx.sleepAsync = function(delay, fpExec) {
    setTimeout(fpExec, delay);
}


/*  =================================================================================== 
   get data 
   l, r : l, r 사이의 데이터를 구한다. 
   만약 l, r중 하나만 값이 존재하면 나머지 값이 구하는 Data이다. 
   ex) utx.getBlockData(strSrc, l, "");, utx.getBlockData(strSrc, "", r);, utx.getBlockData(strSrc, l, r);
=================================================================================== */
utx.getBlockData = function(strSrc, l, r) {
    if ((l == undefined && r == undefined) || (l == "" && r == "")) return strSrc
    var strData, lpos, rpos, len, len1, len2, pos;

    len = strSrc.length;

    if (l != undefined && l != "") {
        lpos = strSrc.indexOf(l);
        len1 = l.length;
    }

    if (r != undefined && r != "") {
        rpos = strSrc.indexOf(r);
        len2 = r.length;
    }

    if (l == undefined || l == "") // r값을 기준으로 strSrc.Left값을 구한다. 
    {
        pos = rpos;
        strData = strSrc.substring(0, pos);
    } else if (r == undefined || r == "") // l값을 기준으로 strSrc.Right값을 구한다. 
    {
        pos = lpos + len1;
        strData = strSrc.substring(pos);
    } else { // l와 r 사이의 값을 구한다. 
        pos = lpos + len1;
        strData = strSrc.substring(pos);

        pos = strData.indexOf(r);
        strData = strData.substring(0, pos);
    }

    return strData;
}

/*  =================================================================================== 
       생년월일 체크 - 8자리 숫자 
    =================================================================================== */
utx.sleepAsync = function(delay, fpExec) {
    setTimeout(fpExec, delay);
}

/*  =================================================================================== 
       min (포함) 과 max (불포함) 사이의 임의 정수를 반환
    =================================================================================== */
utx.getRandomInt = function(min, max) {
    return Math.floor(Math.random() * (max - min)) + min;
}

/*  =================================================================================== 
       sort 에서 사용 - swap function  
    =================================================================================== */
utx.SwapRows = function(ary, row1, row2) {
    var i = 0,
        tempVal, len = 0;
    tempVal = ary[row1];
    ary[row1] = ary[row2];
    ary[row2] = tempVal;
}


/*  =================================================================================== 
       copy row function  
    =================================================================================== */
utx.CopyRows = function(aryS, aryT, rowS, rowT) {
    var i, lenS, lenT, len;
    lenS = aryS.length;
    lenT = aryT.length;

    if (rowS >= lenS || rowT >= lenT) return false;
    if (aryS[rowS][0] == undefined) { // 1차원 배열 
        aryT[rowT] = aryS[rowS];
    } else { // 2차원 배열     

        if (aryS[0] instanceof Array) len = aryS[0].length;
        else if (aryS[0] instanceof Object) len = utx.countPropertyInObj(aryS[0]);

        if (!(aryT[rowT] instanceof Array)) {
            aryT[rowT] = new Array();
        }

        for (i = 0; i < len; i++) {
            aryT[rowT].push(aryS[rowS][i]);
        }
    }

    return true;
}

/*  =================================================================================== 
       sort 에서 사용 - 문자열 비교 
    =================================================================================== */
utx.CompareStr = function(str1, str2) {
    return str1.localeCompare(str2);
}

/*  =================================================================================== 
       sort 에서 사용 - 숫자 비교 
    =================================================================================== */
utx.CompareNum = function(val1, val2) {
    var ret = (val1 - val2);
    ret = (ret < 0) ? -1 : ((ret > 0) ? 1 : 0);

    return ret;
}

/*  =================================================================================== 
       sort 에서 사용 - 버블 sort ( 2차원 배열 )
    =================================================================================== */
utx.sort2DimAry = function(ary, key, dataType, IsDesc) {
        var i = 0,
            j = 0,
            len = 0,
            v1, v2;
        len = ary.length;

        if (dataType == undefined || dataType == null) dataType = 2;
        if (IsDesc == undefined || IsDesc == null) IsDesc = 0;

        for (i = 0; i < (len - 1); i++) {
            for (j = 0; j < (len - i) - 1; j++) {
                v1 = ary[j][key];
                v2 = ary[j + 1][key];
                if (IsDesc) {
                    if (dataType == 1) { // text
                        if (utx.CompareStr(v1, v2) < 0) {
                            utx.SwapRows(ary, j, j + 1);
                        }
                    } else if (dataType == 2) { // number 
                        if (utx.CompareNum(v1, v2) < 0) {
                            utx.SwapRows(ary, j, j + 1);
                        }
                    }
                } else {
                    if (dataType == 1) { // text
                        if (utx.CompareStr(v1, v2) > 0) {
                            utx.SwapRows(ary, j, j + 1);
                        }
                    } else if (dataType == 2) { // number 
                        if (utx.CompareNum(v1, v2) > 0) {
                            utx.SwapRows(ary, j, j + 1);
                        }
                    }
                }
            }
        }
    }
    /*  =================================================================================== 
           sort 에서 사용 - 부분 버블 sort ( 2차원 배열 )
        =================================================================================== */
utx.sortPart2DimAry = function(ary, key, sIdx, eIdx, dataType, IsDesc) {
    var i = 0,
        j = 0,
        len = 0,
        v1, v2;
    len = ary.length;
    if (sIdx > eIdx) return;

    if (dataType == undefined || dataType == null) dataType = 2;
    if (IsDesc == undefined || IsDesc == null) IsDesc = 0;


    for (i = sIdx; i < (eIdx); i++) {
        for (j = sIdx; j < sIdx + (eIdx - i); j++) {
            v1 = ary[j][key];
            v2 = ary[j + 1][key];
            if (IsDesc) {
                if (dataType == 1) { // text
                    if (utx.CompareStr(v1, v2) < 0) {
                        utx.SwapRows(ary, j, j + 1);
                    }
                } else if (dataType == 2) { // number 
                    if (utx.CompareNum(v1, v2) < 0) {
                        utx.SwapRows(ary, j, j + 1);
                    }
                }
            } else {
                if (dataType == 1) { // text
                    if (utx.CompareStr(v1, v2) > 0) {
                        utx.SwapRows(ary, j, j + 1);
                    }
                } else if (dataType == 2) { // number 
                    if (utx.CompareNum(v1, v2) > 0) {
                        utx.SwapRows(ary, j, j + 1);
                    }
                }
            }
        }
    }
}

/*  =================================================================================== 
       sort 에서 사용 - 버블 sort ( 1차원 배열 )
    =================================================================================== */
utx.sortAry = function(ary, dataType, IsDesc) {
    var i = 0,
        j = 0,
        len = 0;
    len = ary.length;

    if (dataType == undefined || dataType == null) dataType = 2;
    if (IsDesc == undefined || IsDesc == null) IsDesc = 0;


    for (i = 0; i < (len - 1); i++) {
        for (j = 0; j < (len - i) - 1; j++) {
            v1 = ary[j];
            v2 = ary[j + 1];
            if (IsDesc) {
                if (dataType == 1) { // text
                    if (utx.CompareStr(v1, v2) < 0) {
                        utx.SwapRows(ary, j, j + 1);
                    }
                } else if (dataType == 2) { // number 
                    if (utx.CompareNum(v1, v2) < 0) {
                        utx.SwapRows(ary, j, j + 1);
                    }
                }
            } else {
                if (dataType == 1) { // text
                    if (utx.CompareStr(v1, v2) > 0) {
                        utx.SwapRows(ary, j, j + 1);
                    }
                } else if (dataType == 2) { // number 
                    if (utx.CompareNum(v1, v2) > 0) {
                        utx.SwapRows(ary, j, j + 1);
                    }
                }
            }
        }
    }
}

/*  =================================================================================== 
       sort 에서 사용 - 부분 버블 sort ( 1차원 배열 )
    =================================================================================== */
utx.sortPartAry = function(ary, sIdx, eIdx, dataType, IsDesc) {
    var i = 0,
        j = 0,
        len = 0,
        v1, v2;
    len = ary.length;
    if (sIdx > eIdx) return;

    if (dataType == undefined || dataType == null) dataType = 2;
    if (IsDesc == undefined || IsDesc == null) IsDesc = 0;


    for (i = sIdx; i < (eIdx); i++) {
        for (j = sIdx; j < sIdx + (eIdx - i); j++) {
            v1 = ary[j];
            v2 = ary[j + 1];
            if (IsDesc) {
                if (dataType == 1) { // text
                    if (utx.CompareStr(v1, v2) < 0) {
                        utx.SwapRows(ary, j, j + 1);
                    }
                } else if (dataType == 2) { // number 
                    if (utx.CompareNum(v1, v2) < 0) {
                        utx.SwapRows(ary, j, j + 1);
                    }
                }
            } else {
                if (dataType == 1) { // text
                    if (utx.CompareStr(v1, v2) > 0) {
                        utx.SwapRows(ary, j, j + 1);
                    }
                } else if (dataType == 2) { // number 
                    if (utx.CompareNum(v1, v2) > 0) {
                        utx.SwapRows(ary, j, j + 1);
                    }
                }
            }
        }
    }
}

/*  =================================================================================== 
       1차원 배열을 복사한다. 
    =================================================================================== */
utx.copy1DAry = function(arySrc) {
	var ary = null, len = 0, i = 0; 
	len = arySrc.length; 
	ary = [];

	for(i = 0; i<len; i++) {
		ary.push(arySrc[i]); 
	}

	return ary; 
}
	

/* ==================================================================================         
   string을 입력받아 2차원 배열을 만든다.  
   sep1, sep2를 기준으로 배열값이 만들어진다.
================================================================================== */
utx.Get2DAryFromStr = function(strSrc, sep1, sep2) {
    var aryLine, aryData, aryRet;
    var len1, len2, i, j;

    aryLine = String(strSrc).split(sep1);
    len1 = aryLine.length;
    aryData = aryLine[0].split(sep2)
    len2 = aryData.length;

    aryRet = new Array();

    for (i = 0; i < len1; i++) {
        aryData = String(aryLine[i]).split(sep2)
        aryRet[i] = new Array();
        for (j = 0; j < len2; j++) {
            aryRet[i].push(aryData[j]);
        }
    }

    return aryRet;
}

/* ==================================================================================         
   2차원 배열을 입력받아 string을 만든다.  
   sep1, sep2를 기준으로 배열값이 만들어진다.
================================================================================== */
utx.GetStrFrom2DAry = function(rAry, sep1, sep2) {
	var len1, len2, i, j;
	var strData = "",
		 strLine = "";

	if (!utx.Is2DArray(rAry)) return strData;

	len1 = rAry.length;
	
	if (rAry[0] instanceof Array) len2 = rAry[0].length;
	else if (rAry[0] instanceof Object) len2 = utx.countPropertyInObj(rAry[0]);

	for (i = 0; i < len1; i++) {
		 for (j = 0; j < len2; j++) {
			  if (j == 0) strLine = utx.sprintf("{0}", rAry[i][j]);
			  else strLine = utx.sprintf("{0}{1}{2}", strLine, sep2, rAry[i][j]);
		 }
		 if (i == 0) strData = utx.sprintf("{0}", strLine);
		 else strData = utx.sprintf("{0}{1}{2}", strData, sep1, strLine);
	}

	return strData;
}

/* ==================================================================================         
      2차원 배열인지 아닌지 체크 
   ================================================================================== */
utx.Is2DArray = function(ary) {
    if (ary == undefined || ary == null || !(ary instanceof Array)) return false;
    return (ary[0][0] === undefined) ? false : true;
}

/* ==================================================================================
			1차원 배열 print Data	
	================================================================================== */
utx.printInfo1DAry = function(ary, strTitle) {
    if (ary == undefined || ary == null || !(ary instanceof Array)) return;
    var i = 0,
        len = 0,
        strLine = ""

    if (strTitle == undefined) strTitle = "printInfo";
    strLine = utx.sprintf(" ----------------------------------- {0} ----------------------------------- ", strTitle);
    console.log(strLine);

    len = ary.length;
    for (i = 0; i < len; i++) {
        strLine = utx.sprintf("({0} - {1})", i, ary[i]);
        console.log(strLine);
    }

    strLine = utx.sprintf(" ----------------------------------- {0} ----------------------------------- ", strTitle);
    console.log(strLine);
}

/* ==================================================================================         
      2차원 배열 print Data
   ================================================================================== */
utx.printInfo2DAry = function(ary, strTitle) {
    var strLine = "",
        strData = "",
        strPost = "";
    if (!utx.Is2DArray(ary)) return;

    var len1, len2, i, j;
    len1 = ary.length;

    if (ary[0] instanceof Array) len2 = ary[0].length;
    else if (ary[0] instanceof Object) len2 = utx.countPropertyInObj(ary[0]);

    if (strTitle == undefined) strTitle = "printInfo";
    strLine = utx.sprintf(" ----------------------------------- {0} ----------------------------------- ", strTitle);
    console.log(strLine);

    for (i = 0; i < len1; i++) {
        for (j = 0; j < len2; j++) {
            if (j == 0) strLine = utx.sprintf("({0} - {1})", j, ary[i][j]);
            else strLine = utx.sprintf("{0} ({1} - {2})", strLine, j, ary[i][j]);
        }

        strLine = utx.sprintf("Idx = {0} ++ {1}", i, strLine);
        console.log(strLine);
    }

    strLine = utx.sprintf(" ----------------------------------- {0} ----------------------------------- ", strTitle);
    console.log(strLine);

    return;
}



/* =================================================================================== 
    =================================================================================== */