<!--#include file = "../include/config_top.asp" -->
<!--#include file = "../include/config_bot.asp" -->
<!--#include file = "../Library/ajax_config.asp"-->
TRUE|
<script>	function on_Submit(valPhone, valContents){		var strAjaxUrl = 'http://biz.moashot.com/EXT/URLASP/mssendutf.asp';		$.ajax({			url: strAjaxUrl,			type: 'POST',			dataType: 'html',			contentType: 'application/x-www-form-urlencoded; charset=utf-8',			data: { 				uid			: 'rubin500'				,pwd		: 'rubin0907'				,commType	: 0				,sendType	: 5				,fromNumber	: '027040282'				,nType		: 4				,returnType	: 0				,indexCode	: '2017-10-10 오후 5:12:07'				,title		: '*** 대회 참가신청 정상접수 완료 알림메시지 ***'				,toNumber	: valPhone				,contents	: valContents			}		});	}</script><script>on_Submit('01072907647','임되술님! 참가신청 대기팀으로 접수되었던 참가신청이 정상접수 처리되었습니다.');</script>
