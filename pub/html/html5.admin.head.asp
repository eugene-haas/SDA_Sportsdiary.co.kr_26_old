
<!doctype html>
<html lang = "ko">
<head>
<meta charset = "UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">



	<title><%=Msite_title%></title>
	<link href="./css/style1.css" rel="stylesheet" type="text/css">
	<link rel="stylesheet" href="/pub/css/hstudy.css?v=4" type="text/css"> 

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
	</script>
</head>