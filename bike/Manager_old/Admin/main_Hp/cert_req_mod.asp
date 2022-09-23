<!--#include file="../dev/dist/config.asp"-->
<!--#include file="../include/head.asp"-->
<!--METADATA TYPE="typelib"  NAME="ADODB Type Library" UUID= "00000205-0000-0010-8000-00AA006D2EA4" -->
<object runat="Server" PROGID="ADODB.Command" Id="objCmd" VIEWASTEXT></object>
<%
    '========================================================================================================
    '증명서 신청정보 수정페이지 
    '======================================================================================================== 

    dim CRs, CSQL
    dim UserID, UserName, UserBirth, UserPhone, UserFax, UserAddr, UserAddrDtl, ZipCode
    dim TypeCertificate, TypeUse, TypeRecive, TypeResult, InsDate
    dim txtTitleNm1, txtTitleNm2, txtTitleNm3
    dim DateDuringS1, DateDuringS2, DateDuringS3
    dim DateDuringE1, DateDuringE2, DateDuringE3
    dim DateVisit, SubmitOrg, CertificateFee
    dim StrUserPhone, UserPhone1, UserPhone2, UserPhone3
    dim StrUserFax, UserFax1, UserFax2, UserFax3

    Check_AdminLogin()

    dim currPage            : currPage              = fInject(Request("currPage"))
    dim SDate               : SDate                 = fInject(Request("SDate"))
    dim EDate               : EDate                 = fInject(Request("EDate")) 
    dim fnd_KeyWord         : fnd_KeyWord           = fInject(Request("fnd_KeyWord"))  
    dim fnd_TypeCertificate : fnd_TypeCertificate   = fInject(Request("fnd_TypeCertificate"))   
    dim fnd_TypeUse         : fnd_TypeUse           = fInject(Request("fnd_TypeUse"))   
    dim fnd_TypeRecive      : fnd_TypeRecive        = fInject(Request("fnd_TypeRecive"))    
    dim fnd_TypeResult      : fnd_TypeResult        = fInject(Request("fnd_TypeResult"))    
    dim CIDX                : CIDX                  = crypt.DecryptStringENC(fInject(request("CIDX")))

    IF CIDX = "" Then   
        Call DBClose()
        response.write "<script>"
        response.write "  alert('잘못된 접근입니다. 확인 후 이용하세요.');"
        response.write "  history.back();"
        response.write "</script>"
        response.end
    END IF

    CSQL = "      SELECT CertificateIDX "
    CSQL = CSQL & "     ,UserID"
    CSQL = CSQL & "     ,UserName"
    CSQL = CSQL & "     ,CONVERT(CHAR(10), CONVERT(DATE, UserBirth), 102) UserBirth "
    CSQL = CSQL & "     ,UserPhone"
    CSQL = CSQL & "     ,UserFax"
    CSQL = CSQL & "   ,TypeCertificate"
    CSQL = CSQL & "   ,TypeUse"                               
    CSQL = CSQL & "     ,TypeRecive "
    CSQL = CSQL & "     ,SubmitOrg"
    CSQL = CSQL & "     ,txtTitleNm1"
    CSQL = CSQL & "     ,txtTitleNm2"
    CSQL = CSQL & "     ,txtTitleNm3"
    CSQL = CSQL & "     ,DateDuringS1"
    CSQL = CSQL & "     ,DateDuringS2"
    CSQL = CSQL & "     ,DateDuringS3"
    CSQL = CSQL & "     ,DateDuringE1"
    CSQL = CSQL & "     ,DateDuringE2"
    CSQL = CSQL & "     ,DateDuringE3"
    CSQL = CSQL & "     ,CertificateFee"
    CSQL = CSQL & "     ,DateVisit"
    CSQL = CSQL & "     ,ZipCode"
    CSQL = CSQL & "     ,UserAddr"
    CSQL = CSQL & "     ,UserAddrDtl"
    CSQL = CSQL & "     ,TypeResult"
    CSQL = CSQL & "     ,InsDate" 
	CSQL = CSQL & "     ,CertNumber"
	CSQL = CSQL & "     ,CertCount"
	CSQL = CSQL & "     ,CertAttach"
	CSQL = CSQL & "     ,CertWitness"
	CSQL = CSQL & "     ,CertDirector"
    CSQL = CSQL & "     ,CerPayYN"
	CSQL = CSQL & "     ,CerPayNum"
    CSQL = CSQL & "     ,CertContents"
    CSQL = CSQL & " FROM [KoreaBadminton].[dbo].[tblOnlineCertificate]"
    CSQL = CSQL & " WHERE DelYN = 'N'"
    CSQL = CSQL & "   AND CertificateIDX = '"&CIDX&"'"

    'response.write CSQL

    SET CRs = DBCon.Execute(CSQL)
    IF Not(CRs.Eof Or CRs.Bof) Then 
        UserID = CRs("UserID")
        UserName = CRs("UserName")
        UserBirth = CRs("UserBirth")
        UserPhone = CRs("UserPhone")
        UserFax = CRs("UserFax")  
        TypeCertificate = CRs("TypeCertificate")
        TypeRecive = CRs("TypeRecive")
        TypeResult = CRs("TypeResult")
        TypeUse = CRs("TypeUse")                                 
        SubmitOrg = ReHtmlSpecialChars(CRs("SubmitOrg"))  
        txtTitleNm1 = ReHtmlSpecialChars(CRs("txtTitleNm1"))
        txtTitleNm2 = ReHtmlSpecialChars(CRs("txtTitleNm2"))
        txtTitleNm3 = ReHtmlSpecialChars(CRs("txtTitleNm3"))   
        DateDuringS1 = ReHtmlSpecialChars(CRs("DateDuringS1"))  
        DateDuringS2 = ReHtmlSpecialChars(CRs("DateDuringS2"))  
        DateDuringS3 = ReHtmlSpecialChars(CRs("DateDuringS3"))  
        DateDuringE1 = ReHtmlSpecialChars(CRs("DateDuringE1"))
        DateDuringE2 = ReHtmlSpecialChars(CRs("DateDuringE2"))
        DateDuringE3 = ReHtmlSpecialChars(CRs("DateDuringE3"))
        CertificateFee = formatnumber(CRs("CertificateFee"), 0) 
        DateVisit = CRs("DateVisit")
        ZipCode = CRs("ZipCode")  
        UserAddr = ReHtmlSpecialChars(CRs("UserAddr"))
        UserAddrDtl = ReHtmlSpecialChars(CRs("UserAddrDtl"))  
        InsDate = CRs("InsDate")

        CertNumber = CRs("CertNumber")
        CertCount = CRs("CertCount")
        CertAttach = CRs("CertAttach")
        CertWitness = CRs("CertWitness")
        CertDirector = CRs("CertDirector")

        CerPayYN    = CRs("CerPayYN")
        CerPayNum   = CRs("CerPayNum")

        CertContents = ReHtmlSpecialChars(CRs("CertContents"))
   
        IF UserPhone <> "" Then
            StrUserPhone = Split(UserPhone, "-")
            UserPhone1 = StrUserPhone(0)
            UserPhone2 = StrUserPhone(1)
            UserPhone3 = StrUserPhone(2)
        End IF

        IF UserFax <> "" Then
            StrUserFax = Split(UserFax, "-")
            UserFax1 = StrUserFax(0)
            UserFax2 = StrUserFax(1)
            UserFax3 = StrUserFax(2)
        End IF
    Else
        response.Write "<script>alert('일치하는 정보가 없습니다. 확인 후 이용하세요'); history.back();</script>"
        response.End
    End IF
    CRs.Close
    SET CRs = Nothing

    CertPayIDX = 0
    CertPayRespMsg = ""
    CertPayPayTypeNm = "미결제"

    IF CerPayNum <> "" THEN
        CSQL = "SELECT"
        CSQL = CSQL &" CertPayIDX, CertPayRespCode,"
        CSQL = CSQL &" CASE"
        CSQL = CSQL &"   WHEN CertPayRespCode = '0000' THEN '성공'"
        CSQL = CSQL &"   ELSE '실패'"
        CSQL = CSQL &" END AS CertPayRespCodeNm,"
        CSQL = CSQL &" CASE"
        CSQL = CSQL &"   WHEN CertPayPayType = 'SC0040' AND CertPayCasFlag = 'R' THEN '입금전(요청일: '+ LEFT(CertPayCasDate, 4) +'-'+ SUBSTRING(CertPayCasDate, 5, 2) +'-'+ SUBSTRING(CertPayCasDate, 7, 2) +' '+ SUBSTRING(CertPayCasDate, 9, 2) +':'+ SUBSTRING(CertPayCasDate, 11, 2) +')'"
        CSQL = CSQL &"   WHEN CertPayPayType = 'SC0040' AND CertPayCasFlag = 'I' THEN '입금 완료'"
        CSQL = CSQL &"   ELSE CertPayRespMsg"
        CSQL = CSQL &" END AS  CertPayRespMsg,"
        CSQL = CSQL &" CertPayAmout, CertPayTid, CertPayPayType,"
        CSQL = CSQL &" CASE"
        CSQL = CSQL &"   WHEN CertPayPayType = 'SC0010' THEN '신용카드'"
        CSQL = CSQL &"   WHEN CertPayPayType = 'SC0030' THEN '계좌이체'"
        CSQL = CSQL &"   WHEN CertPayPayType = 'SC0040' THEN '무통장입금'"
        CSQL = CSQL &"   WHEN CertPayPayType = 'SC0060' THEN '휴대폰'"
        CSQL = CSQL &"   ELSE '미결제'"
        CSQL = CSQL &" END AS CertPayPayTypeNm,"
        CSQL = CSQL &" CASE"
        CSQL = CSQL &"   WHEN CertPayPayDate = '' THEN ''"
        CSQL = CSQL &"   ELSE LEFT(CertPayPayDate, 4) +'-'+ SUBSTRING(CertPayPayDate, 5, 2) +'-'+ SUBSTRING(CertPayPayDate, 7, 2) +' '+ SUBSTRING(CertPayPayDate, 9, 2) +':'+ SUBSTRING(CertPayPayDate, 11, 2)"
        CSQL = CSQL &" END AS CertPayPayDate,"
        CSQL = CSQL &" CertPayBuyer, CertPayCasFlag"
        CSQL = CSQL &" from [KoreaBadminton].[dbo].[tblOnlineCertificatePayLog] WITH(NOLOCK)"
        CSQL = CSQL &" WHERE CertificateIDX = ? AND CerPayNum = ?"

        With objCmd
            .ActiveConnection = DBCon
            .CommandType  = adCmdText

            .CommandText  = CSQL

            .Parameters.Append .CreateParameter("@NowPage", adBigInt, adParamInput, 20, CIDX)
            .Parameters.Append .CreateParameter("@CerPayNum", adVarChar, adParamInput, 64, CerPayNum)

            Set gRow = .Execute

            For ry = .Parameters.Count - 1 to 0 Step -1
                    .Parameters.Delete(ry)
                Next
        End With

        If gRow.eof Or gRow.bof Then
        Else
            CertPayIDX            = CDBL(gRow(0))
            CertPayRespCode       = TRIM(gRow(1))
            CertPayRespCodeNm     = TRIM(gRow(2))
            CertPayRespMsg        = TRIM(gRow(3))
            CertPayAmout          = TRIM(gRow(4))
            CertPayTid            = TRIM(gRow(5))
            CertPayPayType        = TRIM(gRow(6))
            CertPayPayTypeNm      = TRIM(gRow(7))
            CertPayPayDate        = TRIM(gRow(8))
            CertPayBuyer          = TRIM(gRow(9))
			CertPayCasFlag		  = TRIM(gRow(10))
        END IF 
        Set gRow = NOTHING
    END IF 
%>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script> 
<script>
    /**
    * left-menu 체크
    */
    var locationStr = "cert_regist.asp"; // 증명서 발급신청
    /* left-menu 체크 */

    /**
    * 다음 우편번호 서비스
    */
    function execDaumPostCode() {
        var themeObj = {
            bgColor: "", //바탕 배경색
            searchBgColor: "#0B65C8", //검색창 배경색
            contentBgColor: "#fefefe", //본문 배경색(검색결과,결과없음,첫화면,검색서제스트)
            pageBgColor: "#dedede", //페이지 배경색
            textColor: "#000", //기본 글자색
            queryTextColor: "#FFFFFF", //검색창 글자색
            //postcodeTextColor: "#000", //우편번호 글자색
            //emphTextColor: "", //강조 글자색
            //outlineColor: "" //테두리
        };

        var width = 500;
        var height = 600;

        new daum.Postcode({
        width: width,
        height: height,
        oncomplete: function(data) {
            // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

            // 도로명 주소의 노출 규칙에 따라 주소를 조합한다.
            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
            var fullRoadAddr = data.roadAddress; // 도로명 주소 변수
            var extraRoadAddr = ''; // 도로명 조합형 주소 변수

            // 법정동명이 있을 경우 추가한다. (법정리는 제외)
            // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
            if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                extraRoadAddr += data.bname;
            }
            // 건물명이 있고, 공동주택일 경우 추가한다.
            if(data.buildingName !== '' && data.apartment === 'Y'){
            extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
            }
            // 도로명, 지번 조합형 주소가 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
            if(extraRoadAddr !== ''){
                extraRoadAddr = ' (' + extraRoadAddr + ')';
            }
            // 도로명, 지번 주소의 유무에 따라 해당 조합형 주소를 추가한다.
            if(fullRoadAddr !== ''){
                fullRoadAddr += extraRoadAddr;
            }

            // 우편번호와 주소 정보를 해당 필드에 넣는다.
            document.getElementById('ZipCode').value = data.zonecode; //5자리 새우편번호 사용
            document.getElementById('UserAddr').value = fullRoadAddr;
            // document.getElementById('UserAddrDtl').value = data.jibunAddress;
            document.getElementById('UserAddrDtl').focus();

            // 사용자가 '선택 안함'을 클릭한 경우, 예상 주소라는 표시를 해준다.
            if(data.autoRoadAddress) {
                //예상되는 도로명 주소에 조합형 주소를 추가한다.
                var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
                document.getElementById('guide').innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';

            } else if(data.autoJibunAddress) {
                var expJibunAddr = data.autoJibunAddress;
                document.getElementById('guide').innerHTML = '(예상 지번 주소 : ' + expJibunAddr + ')';

            } else {
                document.getElementById('guide').innerHTML = '';
            }
        },
        theme: themeObj
        }).open({
            popupName: 'postcodePopup', //팝업 이름을 설정(영문,한글,숫자 모두 가능, 영문 추천)
            left: (window.screenLeft) + (document.body.clientWidth / 2) - (width / 2),
            top: (window.screen.height / 2) - (height / 2)
        });
    }
  
    //수령방법에 따라 입력필드 출력 
    $(document).on('click', '#taken_type', function(){    
        View_Division();    
    });
  
    //수령방법에 따라 입력필드 출력 
    function View_Division(){
        switch($('input:radio[name=taken_type]:checked').val()){
            case 'FAX' : $('#div_VISIT').hide(); $('#div_POST').hide(); break;
            case 'VISIT' : $('#div_FAX').hide(); $('#div_POST').hide(); break;
            case 'POST' : $('#div_VISIT').hide(); $('#div_FAX').hide(); break;
            case 'SPRINT' : $('#div_VISIT').hide(); $('#div_FAX').hide(); $('#div_POST').hide(); $("#CertCount").val(1).parents("tr").hide(); break;
            default:
        }
        
        $('#div_'+$('input:radio[name=taken_type]:checked').val()).show();
    }
  
    //발급종류 | 발급용도 Radio Btn 생성 
    function make_RadioBtn(valType, valCode){
        var strAjaxUrl = '../ajax/cert_req_Radio.asp';
        
        $.ajax({
            url: strAjaxUrl,
            type: 'POST',
            dataType: 'html',
            data: {
                valType   : valType 
                ,valCode  : valCode
            }, 
            success: function(retDATA) {                
                //console.log(retDATA);                
                $('#div_'+valType).html(retDATA);
            }, 
            error: function(xhr, status, error){
                if(error!=''){
                    alert ('오류발생! - 시스템관리자에게 문의하십시오!');
                    return;
                }
            }
        });
    }
  
    //신청시 
    function onSubmit(valType) {    
        if(valType=='MOD'){   
            //연락처
            if(!$('#UserPhone2').val()){
                alert("휴대폰 번호를 입력해 주세요.");
                $('#UserPhone2').focus();
                return; 
            }

            if(!$('#UserPhone3').val()){
                alert("휴대폰 번호를 입력해 주세요.");
                $('#UserPhone3').focus();
                return; 
            }

            //발급종류 
            if(!$('input:radio[name=TypeCertificate]').is(':checked')){
                alert('발급종류를 선택해 주세요.');
                $('#TypeCertificate').focus();
                return;
            }

            //발급용도  
            if(!$('input:radio[name=TypeUse]').is(':checked')){
                alert('발급용도를 선택해 주세요.');  
                $('#TypeUse').focus();
                return;
            }

            //제출처
            if(!$('#SubmitOrg').val()){
                alert('제출처를 입력해 주세요.'); 
                $('#SubmitOrg').focus();
                return;
            }

            //요청내용
            /*
            var cnt=0;

            for (var i=1; i<=3; i++){
                if(!$('#txtTitleNm'+i).val()) cnt+=1;
            }

            if(cnt==3){ 
                alert('요청내용 학교명/팀명을 1개 이상 입력해 주세요.'); 
                $('#txtTitleNm1').focus(); 
                return; 
            }
            else{
                if($('#txtTitleNm1').val()){ 
                if(!$('#DateDuringS1').val()){ alert('재학/재직기간을 입력해 주세요.'); $('#DateDuringS1').focus(); return;}
                if(!$('#DateDuringE1').val()){ alert('재학/재직기간을 입력해 주세요.'); $('#DateDuringE1').focus(); return;}
                }
                if($('#txtTitleNm2').val()){ 
                if(!$('#DateDuringS2').val()){ alert('재학/재직기간을 입력해 주세요.'); $('#DateDuringS2').focus(); return;}
                if(!$('#DateDuringE2').val()){ alert('재학/재직기간을 입력해 주세요.'); $('#DateDuringE2').focus(); return;}
                }
                if($('#txtTitleNm3').val()){ 
                if(!$('#DateDuringS3').val()){ alert('재학/재직기간을 입력해 주세요.'); $('#DateDuringS3').focus(); return;}
                if(!$('#DateDuringE3').val()){ alert('재학/재직기간을 입력해 주세요.'); $('#DateDuringE3').focus(); return;}
                }
            } 
            */

            //요청기간 
            if(!$('#DateDuringS1').val()){ alert('요청기간을 입력해 주세요.'); $('#DateDuringS1').focus(); return;}
            if(!$('#DateDuringE1').val()){ alert('요청기간을 입력해 주세요.'); $('#DateDuringE1').focus(); return;}   

            //수령방법   
            if(!$('input:radio[name=taken_type]').is(':checked')){
                alert('수령방법을 선택해 주세요.');  
                $('#taken_type').focus();
                return;
            }

            //수령방법에 따른 입력값 체크 
            switch($('input:radio[name=taken_type]:checked').val()){
                //팩스수령 팩스번호 체크  
                case 'FAX': 
                    $('#CertificateFee').val();
                    if(!$('#UserFax2').val()){ alert("팩스 번호를 입력해 주세요."); $('#UserFax2').focus(); return; }
                    if(!$('#UserFax3').val()){ alert("팩스 번호를 입력해 주세요."); $('#UserFax3').focus(); return; }        

                    var UserFax = $('#UserFax1').val() + '-' + $('#UserFax2').val().replace(/ /g, '') + '-' + $('#UserFax3').val().replace(/ /g, '');   
                    break;

                //방문수령 방문날짜체크   
                case 'VISIT': 
                    if(!$('#DateVisit').val()){ alert("방문날짜를 입력해 주세요."); $('#DateVisit').focus(); return; } 

                    var DateVisit = $('#DateVisit').val();
                    break;

                //우편수령 주소체크 
                case 'POST':  
                    if(!$('#ZipCode').val()){ alert("주소를 입력해 주세요"); return; }
                    if(!$('#UserAddr').val()){ alert("주소를 입력해 주세요"); return; }  

                    var ZipCode = $('#ZipCode').val();
                    var UserAddr = $('#UserAddr').val();
                    var UserAddrDtl = $('#UserAddrDtl').val();
                    break;

                default:  
            }

            if(confirm('신청정보를 수정하시겠습니까?')) {
                var strAjaxUrl    = '../ajax/cert_req_mod.asp';
                var TypeResult    = $('#TypeResult').val();  
                var UserPhone     = $('#UserPhone1').val() + '-' + $('#UserPhone2').val().replace(/ /g, '') + '-' + $('#UserPhone3').val().replace(/ /g, '');  
                var UserFax     = $('#UserFax1').val() + '-' + $('#UserFax2').val().replace(/ /g, '') + '-' + $('#UserFax3').val().replace(/ /g, '');  
                var TypeCertificate = $('input:radio[name=TypeCertificate]:checked').val();
                var TypeUse     = $('input:radio[name=TypeUse]:checked').val();
                var TypeRecive    = $('input:radio[name=taken_type]:checked').val();
                var SubmitOrg     = $('#SubmitOrg').val();
                var txtTitleNm1   = $('#txtTitleNm1').val();
                var txtTitleNm2   = $('#txtTitleNm2').val();
                var txtTitleNm3   = $('#txtTitleNm3').val();
                var DateDuringS1  = $('#DateDuringS1').val();
                var DateDuringS2  = $('#DateDuringS2').val();
                var DateDuringS3  = $('#DateDuringS3').val();
                var DateDuringE1  = $('#DateDuringE1').val();
                var DateDuringE2  = $('#DateDuringE2').val();
                var DateDuringE3  = $('#DateDuringE3').val();     
                var CertNumber   = $('#certNumber').val();
                var CertCount   = $('#certCount').val();
                var CertAttach   = $('#certAttach').val();
                var CertWitness   = $('#certWitness').val();
                var CertDirector   = $('#certDirector').val();
                var TYPE_PROC   = $('#TYPE_PROC').val();
                var CertContents    = $('#CertContents').val();
                var CIDX      = $('#CIDX').val();

                //수령방법에 따른 변수값 초기화 처리 
                switch(TypeRecive){
                    case 'FAX'  : DateVisit=''; ZipCode=''; UserAddr=''; UserAddrDtl=''; break;
                    case 'VISIT': UserFax=''; ZipCode=''; UserAddr=''; UserAddrDtl=''; break;
                    case 'POST' : UserFax=''; DateVisit=''; break;
                    case 'SPRINT' : UserFax=''; DateVisit=''; ZipCode=''; UserAddr=''; UserAddrDtl=''; break;
                    default : 
                }

                $.ajax({
                    url: strAjaxUrl,
                    type: 'POST',
                    dataType: 'html', 
                    data: {
                        TypeResult      : TypeResult
                        ,UserPhone      : UserPhone
                        ,UserFax      : UserFax
                        ,TypeCertificate  : TypeCertificate
                        ,TypeUse      : TypeUse
                        ,TypeRecive     : TypeRecive
                        ,SubmitOrg      : SubmitOrg
                        ,DateVisit      : DateVisit
                        ,ZipCode      : ZipCode
                        ,UserAddr     : UserAddr
                        ,UserAddrDtl    : UserAddrDtl
                        ,txtTitleNm1    : txtTitleNm1
                        ,txtTitleNm2    : txtTitleNm2
                        ,txtTitleNm3    : txtTitleNm3
                        ,DateDuringS1     : DateDuringS1
                        ,DateDuringS2     : DateDuringS2
                        ,DateDuringS3     : DateDuringS3
                        ,DateDuringE1     : DateDuringE1
                        ,DateDuringE2     : DateDuringE2
                        ,DateDuringE3     : DateDuringE3
                        ,CertNumber       : CertNumber
                        ,CertCount        : CertCount
                        ,CertAttach       : CertAttach
                        ,CertWitness      : CertWitness
                        ,CertDirector     : CertDirector
                        ,TYPE_PROC      : TYPE_PROC   
                        ,CertContents       : CertContents	
                        ,CIDX       : CIDX    
                    }, 
                    success: function(retDATA) {
                        //console.log(retDATA);
                        if(retDATA){
                            var strcut = retDATA.split('|');

                            if (strcut[0]=='TRUE') {

                                alert('신청정보 수정이 정상적으로 완료되었습니다.');
                                $('form[name=s_frm]').attr('action','./cert_regist.asp');
                                $('form[name=s_frm]').submit(); 
                            }else {  //FALSE|
                                var msg='';
                                switch (strcut[1]) { 
                                    case '66'   : msg='신청정보 수정이 실패하였습니다.\n관리자에게 문의하세요.'; break;
                                    case '33'   : msg='신청정보 수정권한이 없습니다.\n관리자에게 문의하세요.'; break;  
                                    default   : msg='잘못된 접근입니다.\n확인 후 다시 이용하세요.'; //200
                                    }           
                                    alert(msg);
                                return;
                            }
                        }
                    }, 
                    error: function(xhr, status, error){
                        if(error!=''){
                            alert ('오류발생! - 시스템관리자에게 문의하십시오!');     
                            return;
                        }
                    }
                });
            }else {
                return;
            }
        }else {
            $('form[name=s_frm]').attr('action','./cert_regist.asp');
            $('form[name=s_frm]').submit(); 
        }
    }

    //var CertPopup = null;
    function fnCertPopup(idx) {
        var oR = document.cerpform;

        if (confirm("발급하시겠습니까?")) {
            window.open("", "CertPopup", "width=750,height=600,tollbar=no,scrollbars=yes,resizable=no,top=50");
            oR.action = "/main_HP/cert_req_popup.asp";
            oR.target = "CertPopup";
            oR.idx.value = idx;    
            oR.submit();
        }
    }
                               
    $(document).on('change','#UserPhone1', function(){ $('#UserPhone2').focus(); });  
    $(document).on('change','#UserFax1', function(){ $('#UserFax2').focus(); });
  
    //최상단 체크박스 클릭
    $(document).on('click','#all_terms', function(){        
        if($('#all_terms').prop('checked')){
            $('#privacy_terms').prop('checked', true);
            $('#infokey_terms').prop('checked', true);
        }
        else{
            $('#privacy_terms').prop('checked', false);
            $('#infokey_terms').prop('checked', false);
        }
    });


    $(document).ready(function(){
        View_Division();  //수령방법에 따라 입력필드 출력 
        make_RadioBtn('TypeCertificate', '<%=crypt.EncryptStringENC(TypeCertificate)%>'); //발급종류 
        make_RadioBtn('TypeUse', '<%=crypt.EncryptStringENC(TypeUse)%>');     //발급용도 
    });

	function fn_searchLog(num) {
        post_to_url('/Main_HP/cert_pay_log.asp', {'NowPage': 1, 'KeyField1': '', 'KeyField2': '', 'KeyField3': 'PNUM', 'KeyWord': num});
	}
</script>
<div id="content" class="cert_req_mod">
    <!-- S: page_title -->
    <div class="page_title clearfix">
        <h2>증명서신청내역</h2>
        <a href="./cert_regist.asp" class="btn btn-back"><span class="ic_deco"><i class="fas fa-angle-left"></i></span>뒤로가기</a>

        <!-- S: 네비게이션 -->
        <div  class="navigation_box">
            <span class="ic_deco">
                <i class="fas fa-angle-right fa-border"></i>
            </span>
            <ul>
                <li>홈페이지관리</li>
                <li>온라인서비스</li>
                <li><a href="./cert_regist.asp">증명서발급신청</a></li>
                <li><a href="./cert_req_mod.asp">증명서신청내역</a></li>
            </ul>
        </div>
        <!-- E: 네비게이션 -->
    </div>
    <!-- E: page_title -->

    <form name="s_frm" method="post">
    <input type="hidden" name="currPage" id="currPage" value="<%=currPage%>" />
    <input type="hidden" name="CIDX" id="CIDX" value="<%=fInject(request("CIDX"))%>" />
    <input type="hidden" name="SDate" id="SDate" value="<%=SDate%>" />
    <input type="hidden" name="SDate" id="SDate" value="<%=SDate%>" />
    <input type="hidden" name="fnd_KeyWord" id="fnd_KeyWord" value="<%=fnd_KeyWord%>" />
    <input type="hidden" name="fnd_TypeCertificate" id="fnd_TypeCertificate" value="<%=fnd_TypeCertificate%>" />
    <input type="hidden" name="fnd_TypeUse" id="fnd_TypeUse" value="<%=fnd_TypeUse%>" />
    <input type="hidden" name="fnd_TypeRecive" id="fnd_TypeRecive" value="<%=fnd_TypeRecive%>" />
    <input type="hidden" name="fnd_TypeResult" id="fnd_TypeResult" value="<%=fnd_TypeResult%>" />
    <table class="left-head view-table">
        <tbody>
            <tr class="tiny-line">
                <th>처리상태</th>
                <td>
                    <span class="con">
                        <select name="TypeResult" id="TypeResult" >
                            <option value="S" <%IF TypeResult = "S" Then response.write "selected" End IF%>>신청대기</option>
                            <option value="P" <%IF TypeResult = "P" Then response.write "selected" End IF%>>처리중</option>
                            <option value="R" <%IF TypeResult = "R" Then response.write "selected" End IF%>>발급완료</option>
                            <option value="C" <%IF TypeResult = "C" Then response.write "selected" End IF%>>취소</option>
                        </select>
                    </span>
                </td>
            </tr>
            <tr>
                <th>신청일</th>
                <td><%=InsDate%></td>
            </tr> 
            <tr class="id_line">
                <th>아이디</th>
                <td><%=UserID%></td>
            </tr>
            <tr>
                <th>신청자</th>
                <td><%=UserName%></td>
            </tr>
            <tr>
                <th>생년월일</th>
                <td><%=UserBirth%></td>
            </tr>
            <tr class="phone_line">
                <th>연락처</th>
                <td><select name="UserPhone1" id="UserPhone1" >
                    <option value="010" <%IF UserPhone1 = "010" Then response.write "selected" End IF%>>010</option>
                    <option value="011" <%IF UserPhone1 = "011" Then response.write "selected" End IF%>>011</option>
                    <option value="016" <%IF UserPhone1 = "016" Then response.write "selected" End IF%>>016</option>
                    <option value="017" <%IF UserPhone1 = "017" Then response.write "selected" End IF%>>017</option>
                    <option value="018" <%IF UserPhone1 = "018" Then response.write "selected" End IF%>>018</option>
                    <option value="019" <%IF UserPhone1 = "019" Then response.write "selected" End IF%>>019</option>
                    <option value="070" <%IF UserPhone1 = "070" Then response.write "selected" End IF%>>070</option>
                </select>
                <span class="divn">-</span>
                <input type="number" name="UserPhone2" id="UserPhone2" maxlength="4" oninput="maxLengthCheck(this);" onKeyUp="if($('#UserPhone2').val().length==4) $('#UserPhone3').focus(); chk_InputValue(this, 'Digit');" value="<%=UserPhone2%>" />
                <span class="divn">-</span>
                <input type="number" name="UserPhone3" id="UserPhone3" maxlength="4" oninput="maxLengthCheck(this);" onKeyUp="if($('#UserPhone3').val().length==4) $('#TypeCertificate').focus(); chk_InputValue(this, 'Digit');" value="<%=UserPhone3%>" /></td>
            </tr>
            <tr>
                <th>발급종류</th>
                <td id="div_TypeCertificate"></td>
            </tr>
            <tr>
                <th>용도</th>
                <td id="div_TypeUse"></td>
            </tr>
            <tr class="short-line"></tr>
                <th>제출처</th>
                <td>
                <span class="con">
                    <input type="text" name="SubmitOrg" id="SubmitOrg" value="<%=SubmitOrg%>">
                </span>
                </td>
            </tr>
            <tr class="req_cont">
                <th>요청기간</th>
                <td>
                    <input type="hidden" id="txtTitleNm1" />
                    <input type="hidden" id="txtTitleNm2" />
                    <input type="hidden" id="txtTitleNm3" />
                    <input type="hidden" id="DateDuringS2" />
                    <input type="hidden" id="DateDuringS3" />
                    <input type="hidden" id="DateDuringE2" />
                    <input type="hidden" id="DateDuringE3" />
                    <input type="text" name="DateDuringS1" id="DateDuringS1" placeholder="기간" class="term date_ipt" value="<%=DateDuringS1%>" readonly="readonly" />
                    <span class="divn">~</span>
                    <input type="text" name="DateDuringE1" id="DateDuringE1" class="term date_ipt" placeholder="기간" value="<%=DateDuringE1%>" readonly="readonly" />
                </td>
            </tr>
            <tr class="divn_td">
                <th>요청내용</th>
                <td><textarea type="text" name="CertContents" id="CertContents" style="width:620px;height:150px;margin-top:10px; margin-bottom:10px;"><%=CertContents%></textarea></td>
            </tr>
            <tr>
                <th>수령방법</th>
                <td>
                    <label>
                        <input type="radio" name="taken_type" id="taken_type" class="fax" value="FAX" <%IF TypeRecive = "FAX" Then response.write "checked" End IF%> />
                        <span class="txt">팩스수령</span>
                    </label>
                    <label>
                        <input type="radio" name="taken_type" id="taken_type" class="visit" value="VISIT" <%IF TypeRecive = "VISIT" Then response.write "checked" End IF%> />
                        <span class="txt">방문수령</span>
                    </label>
                    <label>
                        <input type="radio" name="taken_type" id="taken_type" class="post" value="POST" <%IF TypeRecive = "POST" Then response.write "checked" End IF%> />
                        <span class="txt">우편수령</span>
                    </label>
                    <label>
                        <input type="radio" name="taken_type" id="taken_type" class="sprint" value="SPRINT" <%IF TypeRecive = "SPRINT" Then response.write "checked" End IF%> />
                        <span class="txt">직접출력</span>
                    </label>
                </td>
            </tr>
            <tr class="divn_td">
                <th>발급료</th>
                <td class="toggle_box">
				    <%=CertificateFee%>
                </td>
            </tr>
            <tr id="div_FAX" class="phone_line tr_view">
                <th>팩스번호</th>
                <td><select name="UserFax1" id="UserFax1" >
                    <option value="02" <%IF UserFax1 = "02" Then response.write "selected" End IF%>>02</option>
                    <option value="031" <%IF UserFax1 = "031" Then response.write "selected" End IF%>>031</option>
                    <option value="032" <%IF UserFax1 = "032" Then response.write "selected" End IF%>>032</option>
                    <option value="041" <%IF UserFax1 = "041" Then response.write "selected" End IF%>>041</option>
                    <option value="042" <%IF UserFax1 = "042" Then response.write "selected" End IF%>>042</option>
                    <option value="043" <%IF UserFax1 = "043" Then response.write "selected" End IF%>>043</option>
                    <option value="044" <%IF UserFax1 = "044" Then response.write "selected" End IF%>>044</option>
                    <option value="051" <%IF UserFax1 = "051" Then response.write "selected" End IF%>>051</option>
                    <option value="052" <%IF UserFax1 = "052" Then response.write "selected" End IF%>>052</option>
                    <option value="053" <%IF UserFax1 = "053" Then response.write "selected" End IF%>>053</option>
                    <option value="054" <%IF UserFax1 = "054" Then response.write "selected" End IF%>>054</option>
                    <option value="055" <%IF UserFax1 = "055" Then response.write "selected" End IF%>>055</option>
                    <option value="061" <%IF UserFax1 = "061" Then response.write "selected" End IF%>>061</option>
                    <option value="062" <%IF UserFax1 = "062" Then response.write "selected" End IF%>>062</option>
                    <option value="063" <%IF UserFax1 = "063" Then response.write "selected" End IF%>>063</option>
                    <option value="064" <%IF UserFax1 = "064" Then response.write "selected" End IF%>>064</option>
                </select>
                <span class="divn">-</span>
                <input type="number" name="UserFax2" id="UserFax2" maxlength="4" oninput="maxLengthCheck(this);" onKeyUp="if($('#UserFax2').val().length==4) $('#UserFax3').focus(); chk_InputValue(this, 'Digit');" value="<%=UserFax2%>" />
                <span class="divn">-</span>
                <input type="number" name="UserFax3" id="UserFax3" maxlength="4" oninput="maxLengthCheck(this);" onKeyUp="chk_InputValue(this, 'Digit');" value="<%=UserFax3%>" /></td>
            </tr>
            <tr id="div_VISIT" class="visit_date tr_view">
                <th>방문날짜</th>
                <td>
                    <span class="con">
                    <input type="text" name="DateVisit" id="DateVisit" placeholder="방문날짜" class="date_ipt" value="<%=DateVisit%>" readonly="readonly" />
                    </span>
                </td>
            </tr>
            <tr id="div_POST" class="addr_line tr_view">
                <th>주소</th>
                <td><div class="srch_post_num"> <a href="#" onclick="execDaumPostCode(); return false;">
                    <input type="text" disabled name="ZipCode" id="ZipCode" value="<%=ZipCode%>" />
                    <span class="btn btn_gray">우편번호검색</span> </a> </div>
                <div class="detail_post">
                    <input type="text" name="UserAddr" id="UserAddr" disabled placeholder="우편번호검색을 눌러 주세요" value="<%=UserAddr%>" />
                    <input type="text" name="UserAddrDtl" id="UserAddrDtl" placeholder="상세주소 입력" value="<%=UserAddrDtl%>" />
                    <span id="guide"></span> </div></td>
            </tr>
            <tr>
                <th>발급번호</th>
                <td>
                <span class="con">
                    <input type="text" name="certNumber" id="certNumber" placeholder="발급번호" maxlength="20" value="<%=CertNumber%>" />
                </span>
                </td>
            </tr>
            <tr>
                <th>발급부수</th>
                <td>
                <span class="con">
                    <select name="certCount" id="certCount">
                    <%for ci = 1 To 5%>
                    <option value="<%=ci%>" <%If CInt(CertCount) = ci Then Response.Write "selected=""selected"""%>><%=ci%></option>
                    <%next %>
                </select>
                </span> 매
                </td>
            </tr>
            <tr>
                <th>소속</th>
                <td>
                <span class="con">
                    <input type="text" name="certAttach" id="certAttach" placeholder="소속" maxlength="30" value="<%=CertAttach%>" />
                </span>
                </td>
            </tr>
            <tr>
                <th>기록 대조·확인자</th>
                <td>
                <span class="con">
                    <input type="text" name="certWitness" id="certWitness" placeholder="기록 대조·확인자" maxlength="10" value="<%=CertWitness%>" />
                </span>
                </td>
            </tr>
            <tr>
                <th>사무국장</th>
                <td>
                <span class="con">
                    <input type="text" name="certDirector" id="certDirector" placeholder="사무국장" maxlength="10" value="<%=CertDirector%>" />
                </span>
                </td>
            </tr>
            <%IF CerPayNum <> "" THEN%>
            <tr>
                <th>결제내역</th>
                <td>
                <span>
					<%If CertPayPayType = "SC0040" AND CertPayCasFlag = "R" Then %>
					<%=CertPayPayTypeNm%> 결제 요청, 주문번호: <a href="javascript:;" onclick="fn_searchLog('<%=CerPayNum%>')" target="_blank"><%=CerPayNum%></a> &nbsp;(<%=CertPayRespMsg%>) 
					<%ElseIf CertPayPayType = "SC0040" AND CertPayCasFlag = "I" Then %>
					<%=CertPayPayTypeNm%> 결제 완료, 주문번호: <a href="javascript:;" onclick="fn_searchLog('<%=CerPayNum%>')" target="_blank"><%=CerPayNum%></a> &nbsp;(결제일자: <%=CertPayPayDate%>) 
					<%Else %>
                    <%=CertPayPayTypeNm%> 결제, 주문번호: <a href="javascript:;" onclick="fn_searchLog('<%=CerPayNum%>')" target="_blank"><%=CerPayNum%></a> &nbsp;(결제일자: <%=CertPayPayDate%>)
					<%End If %>
                </span>
                </td>
            </tr>
            <%END IF %>
            <script>
                $(document).ready(function(){
                    var $radioclick = null;
                    var $radiobtn =null;
                    var $toggleDiv = null;
                    var $toggleTr =null;
                    radioEvent();
                })
                function radioEvent(){
                    radioinit();
                    radioeven();
                    initChk();
                }
                function radioinit(){
                    $radioclick= $('[name="taken_type"]');
                    $toggleDiv = $(".toggle_box > div");
                    $toggleTr = $(".tr_view");
                }
                function radioeven(){
                    $radioclick.on('click', function(){
                        radioeexec($(this));
                    })
                }

                function radioeexec($exec){
                    var $execAttr = $("."+ $exec.attr("class"));
                    var $exectrAttr = $($toggleTr);
                    $toggleDiv.hide();
                    $toggleDiv.filter($execAttr).show();

                    console.log($exectrAttr.attr("class"));
                }

                function initChk() {
                    var checkedIpt;
                    $radioclick.each(function () {
                        if ($(this).prop('checked')) {
                        checkedIpt = $(this);
                        }
                    });
                    radioeexec(checkedIpt)
                }
            </script>
        </tbody>
    </table>
    <div class="btn-list-center">
	    <a href="javascript:;" onClick="fnCertPopup('<%=crypt.EncryptStringENC(CIDX) %>')" class="btn btn-back">발급하기</a>
		<a href="javascript: onSubmit('MOD');" class="btn btn-confirm">수정하기</a>
		<a href="javascript: onSubmit('LIST');" class="btn btn-gray">목록</a>
	</div>
    </form>
</div>
<form name="cerpform" method="post">
    <input type="hidden" name="idx" />
</form>
<!-- E: content cert_req_mod -->
<!--#include file="../include/footer.asp"-->
<%DBClose()%>