<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

	<title><%=Msite_title%></title>
	<link href="./css/style1.css" rel="stylesheet" type="text/css">
	<style>select{ behavior: url("./js/selectbox.htc");}</style>
	<script type="text/javascript" src="./js/main_move.js"></script>
	<script type="text/javascript" src="./js/calendar.js"></script>

	<script language="javascript">
		function RefreshStaticMenu() {
			document.getElementById('plyr_back').style.height = document.body.scrollHeight;
			document.getElementById('plyr_back').style.width = document.body.scrollWidth;
			document.getElementById('plyr_fram').style.top =(document.body.scrollTop + ((document.body.clientHeight/2)-180)) + "px";
			document.getElementById('plyr_fram').style.left = (document.body.scrollLeft + ((document.body.clientWidth/2)-320)) + "px";
		}
		function hidden_process() {
			document.getElementById('plyr_back').style.display='none';
			document.getElementById('plyr_fram').style.display='none';
			sub_frame.location.href = "../loading.htm";
		}





<%select case Mpage_title%>

<%Case "수강접수 및 배송관리"%>

		function return_process(inx,ncode,ntitle) {
			if (inx==1) {
				//
			} else {
				search_frm.search_opt17.value = ncode;
				search_frm.search_opt7.value = ntitle;		
			}
			hidden_process();
		}
		function pop_load(k) {
			RefreshStaticMenu();
			sub_frame.location.href = "../loading.htm";
			if (k==1) {
				sub_frame.location.href = "./pop_ncode.asp";
			} else {
				sub_frame.location.href = "./pop_gcode.asp";
			}
			document.getElementById('plyr_back').style.display='block';
			document.getElementById('plyr_fram').style.display='block';
		}

		function all_ck(ival) {
			if (search_frm.ock.length > 1) {
				for (i=1;i<search_frm.ock.length;i++)	{
					search_frm.ock[i].checked=ival;
				}
			}
		}
		function batch_process() {
			if (search_frm.ock.length <= 1) return;
			if (search_frm.batch_type.value =="0") {
				alert("변경처리할 상태가 선택되지 않았습니다.");
				search_frm.batch_type.focus();
				return;
			}
			var j = 0;
			search_frm.trans_data.value = "";
			if (search_frm.ock.length > 1) {
				for (i=1;i<search_frm.ock.length;i++)	{
					if (search_frm.ock[i].checked==true) {
						search_frm.trans_data.value = search_frm.trans_data.value + "|" + search_frm.ock[i].value + "," + search_frm.trans_num[i].value;
						j=j+1;
					}
				}
			}
			if (j==0) {
				alert("체크된 리스트가 없습니다.");
			} else {
				var fu = confirm("선택하신 " + String(j) + "건의 수강접수정보의 상태를 변경하겠습니까?");
				if (fu==false) return;
				search_frm.target="sub_frame";
				search_frm.action = "./request_batch_process.asp";
				search_frm.submit();
			}
		}
		function check_process(k) {
			if (search_frm.trans_num[k].value.length > 10) {
				search_frm.ock[k].checked=true;
			} else {
				if (search_frm.trans_num[k].value.length < 2) search_frm.ock[k].checked=false;
			}
		}
		function save_process() {
		<%
			if user_lev > 1 then
		%>
				alert("마스터관리자만 본 서비스를 이용하실 수 있습니다.");
		<%
			else
		%>
				search_frm.trans_data.value = "";
				var fu = false;
				var j = 0;
				if (search_frm.ock.length > 1) {
					for (i=1;i<search_frm.ock.length;i++)	{
						if (search_frm.ock[i].checked==true) {
							search_frm.trans_data.value = search_frm.trans_data.value + "|" + search_frm.ock[i].value;
							j=j+1;
						}
					}
				}
				if (j==0) {
					fu = confirm("엑셀 저장은 현재 페이지만을 저장합니다.\n많은 리스트 저장을 원하시면 List검색항목을 최대로 지정하신 후 저장하십시오.\n엑셀다운로드를 수행하시겠습니까?");
					if (fu==false) return;
				} else {
					search_frm.trans_data.value = search_frm.trans_data.value + "|";
				}
				search_frm.target = "_blank";
				search_frm.action = "./save/request_trans_search.asp";
				search_frm.submit();
		<%
			end if
		%>
		}

		function email_process() {
			search_frm.rmail.value = "";
			var fu = false;
			var j = 0;
			var allemail = "";
			if (search_frm.ock.length > 1) {
				for (i=1;i<search_frm.ock.length;i++)	{
					if (search_frm.ock[i].checked==true) {
						search_frm.rmail.value = search_frm.rmail.value + search_frm.emaildata[i].value + ";";
						j=j+1;
					}
					allemail = allemail + search_frm.emaildata[i].value + ";";
				}
			}
			if (j==0) {
				fu = confirm("선택된 발송대상자가 없습니다. 현재 페이지 전체대상자에게 발송하시겠습니까?");
				if (fu==false) return;
				search_frm.rmail.value = allemail;
			}
			window.open("", "batch_mail", "scrollbars=no,resizable=no,width=690,height=640,left=300,top=150");

			search_frm.target = "batch_mail";
			search_frm.action = "http://211.172.225.227/mail_lms/email.asp";
			search_frm.submit();
		}
		function trans_search(k) {
			if (search_frm.trans_num[k].value.length < 12) {
				alert("우편송장번호가 유효하지 않습니다.");
				search_frm.trans_num[k].focus();
				return;
			}
			p_h = 450;
			p_w = 510;
			s_h = (screen.height-p_h)/2;
			s_w = (screen.width-p_w)/2;
			window.open("http://service.epost.go.kr/trace.RetrieveRegiPrclDeliv.postal?sid1=" + search_frm.trans_num[k].value, "trans_view" + String(k), "scrollbars=auto,resizable=yes,width=" + String(p_w) + ",height=" + String(p_h) + ",left=" + String(s_w) + ",top=" + String(s_h));
		}
		function sms_process() {

			search_frm.rmail.value = "";
			var fu = false;
			var j = 0;
			var allemail = "";
			if (search_frm.ock.length > 1) {
				for (i=1;i<search_frm.ock.length;i++)	{
					if (search_frm.ock[i].checked==true) {
						search_frm.rmail.value = search_frm.rmail.value + search_frm.hpdata[i].value + ";";
						j=j+1;
					}
					allemail = allemail + search_frm.hpdata[i].value + ";";
				}
			}
			if (j==0) {
				fu = confirm("선택된 발송대상자가 없습니다. 현재 페이지 전체대상자에게 발송하시겠습니까?");
				if (fu==false) return;
				search_frm.rmail.value = allemail;
			}
			window.open("", "batch_sms", "scrollbars=no,resizable=no,width=383,height=340,left=300,top=150");
			search_frm.target = "batch_sms";
			search_frm.action = "../sms/sms_send.asp?team_c=yes";
			search_frm.submit();
		}

		function enter_ck() {
			if(event.keyCode == 13) {
				query_build(0);
				return;
			}
		}
		function query_build(inx) {
			if(inx==-1) {
<%
				for i = 0 to searchc
					if searcht(i) <> "o" then
						if searcht(i) = "s" then
							response.write "search_frm.search_opt" & cstr(i) & ".selectedIndex=0;" & vbnewline
						else
							response.write "search_frm.search_opt" & cstr(i) & ".value = " & chr(34) & chr(34) & ";" & vbnewline
						end if
					else
						response.write "search_frm.search_opt" & cstr(i) & "_1.checked=true;" & vbnewline
					end if
				next
%>
				search_frm.search_opt7.value = "-과정선택-";
				return;
			} else if(inx==0) {
<%
				for i = 0 to searchc
					if searcht(i) <> "o" then
						response.write "search_frm.sch_opt" & cstr(i) & ".value=search_frm.search_opt" & cstr(i) & ".value;"& vbnewline
					end if
				next
%>
				search_frm.page_count.value="1";
			} else {
				search_frm.page_count.value=String(inx);
			}
			search_frm.target="_self";
			search_frm.action = "./request_trans_search_2017.asp";
			search_frm.submit();
		}


		function detail_view(inx) {
			search_frm.target="_self";
			search_frm.action = "./request_view.asp";
			search_frm.inx.value=String(inx);
			search_frm.submit();
		}
	</script>

<%Case else%>


		function return_process(inx,ncode,ntitle) {
			if (inx==1) {
				search_frm.search_opt1.value = ncode;
				search_frm.search_opt0.value = ntitle;		
			} else {
				search_frm.search_opt3.value = ncode;
				search_frm.search_opt2.value = ntitle;
			}
			hidden_process();
		}
		function pop_load(k) {
			RefreshStaticMenu();
			sub_frame.location.href = "../loading.htm";
			if (k==1) {
				sub_frame.location.href = "./pop_ncode.asp";
			} else {
				sub_frame.location.href = "./pop_gcode.asp?ncode=" + search_frm.search_opt1.value;
			}
			document.getElementById('plyr_back').style.display='block';
			document.getElementById('plyr_fram').style.display='block';
		}
		function save_process() {
<%
			if user_lev > 1 and user_id <> "mujerk" then
%>
				alert("마스터관리자만 본 서비스를 이용하실 수 있습니다.<%=user_lev%>");
<%
			else
%>
				var fu = confirm("엑셀 저장은 현재 페이지만을 저장합니다.\n많은 리스트 저장을 원하시면 List검색항목을 최대로 지정하신 후 저장하십시오.\n엑셀다운로드를 수행하시겠습니까?");
				if (fu==false) return;			
				search_frm.target = "_blank";
				search_frm.action = "./save/request_cancel_report_2017.asp";
				search_frm.submit();
<%
			end if
%>
		}
		function query_build(inx) {
		
			if(inx==-1) {
<%
				for i = 0 to searchc
					response.write "search_frm.search_opt" & cstr(i) & ".value = " & chr(34) & chr(34) & ";" & vbnewline
				next
%>
				search_frm.search_opt0.value = "-기수선택-";
				search_frm.search_opt2.value = "-과정선택-";
				return;
			} else if(inx==0) {

<%
				for i = 0 to searchc
					response.write "search_frm.sch_opt" & cstr(i) & ".value=search_frm.search_opt" & cstr(i) & ".value;" & vbnewline
				next
%>
			}
			search_frm.target="_self";
			search_frm.action = "./request_cancel_report.asp";
			search_frm.submit();
		}

<%End Select %>
	</script>
</head>