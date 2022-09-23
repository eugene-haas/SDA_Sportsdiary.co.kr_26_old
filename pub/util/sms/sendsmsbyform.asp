<iframe name="ifSns" width="500" height="100" frameborder="0"></iframe>
<!-- <iframe name="ifSns" width="0" height="0" frameborder="0"></iframe> -->


<script>

function OnBtnRegCouch()
    {        
        console.log("OnBtnRegCouch"); 
     //   location.href='http://biz.moashot.com/EXT/URLASP/mssendutf.asp?uid=widline&pwd=line0282&sendType=3&returnType=2&nType=1&fromNumber=027150282&toNumber=01043693442&contents=잘생기셨네요.. From Aramdry';//parent.location.href='coupon.couch.asp';
        
    //    var strUrl = "http://dev.sdamall.co.kr/pub/api/coupon/api.cpn.sns.asp"; 
    //    popupWindow = window.open(strUrl,'popUpWindow','height=500,width=500,left=100,top=100,resizable=yes,scrollbars=yes,toolbar=yes,menubar=no,location=no,directories=no, status=yes');
            var $form = $('<form></form>');
            $form.attr('action', 'http://biz.moashot.com/EXT/URLASP/mssendutf.asp');
    //        $form.attr('action', 'http://dev.sdamall.co.kr/pub/api/coupon/api.cpn.sns.asp');            
            $form.attr('method', 'post');
            $form.attr('target', 'ifSns');
            $form.appendTo('body');
              
            uidVal="widline";
            pwdVal="line0282";
            sendTypeVal="3";
            returnTypeVal="2";
            nTypeVal="1";
            fromNumberVal="027150282";
            toNumberVal="01043693442";
            contentsVal="잘생기셨네요.. From Aramdry";

            var uid = $('<input type="hidden" value="'+uidVal+'" name="uid">');
            var pwd = $('<input type="hidden" value="'+pwdVal+'" name="pwd">');
            var sendType = $('<input type="hidden" value="'+sendTypeVal+'" name="sendType">');
            var returnType = $('<input type="hidden" value="'+returnTypeVal+'" name="returnType">');
            var nType = $('<input type="hidden" value="'+nTypeVal+'" name="nType">');

            var fromNumber = $('<input type="hidden" value="'+fromNumberVal+'" name="fromNumber">');
            var toNumber = $('<input type="hidden" value="'+toNumberVal+'" name="toNumber">');
            var contents = $('<input type="hidden" value="'+contentsVal+'" name="contents">');

            $form.append(uid).append(pwd).append(sendType).append(returnType).append(nType).append(fromNumber).append(toNumber).append(contents);         
            $form.submit();

    }

    </script>